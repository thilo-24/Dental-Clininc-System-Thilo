package com.sunrisedental.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import com.sunrisedental.config.DatabaseConnection;
import com.sunrisedental.factory.Treatment;
import com.sunrisedental.factory.TreatmentFactory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Strict list of the 5 daily valid time slots
    private static final List<String> ALLOWED_SLOTS = Arrays.asList(
        "09:00", "11:00", "14:00", "16:00", "18:00" ,"20:00"
    );

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String patientIdParam = request.getParameter("patientId");
        String dentistName = request.getParameter("dentistName");
        String treatmentType = request.getParameter("treatmentType");
        String appDate = request.getParameter("appointmentDate");
        String appTime = request.getParameter("appointmentTime");

        // 1. Check for missing or empty form fields
        if (patientIdParam == null || treatmentType == null || appDate == null || appTime == null || dentistName == null ||
            patientIdParam.trim().isEmpty() || treatmentType.trim().isEmpty() || appDate.trim().isEmpty() || 
            appTime.trim().isEmpty() || dentistName.trim().isEmpty()) {
            
            response.sendRedirect("receptionist/book-appointment.jsp?error=" + URLEncoder.encode("All assignment parameters are mandatory.", "UTF-8"));
            return;
        }

        // 2. Validate Patient ID numeric format
        int patientId;
        try {
            patientId = Integer.parseInt(patientIdParam.trim());
            if (patientId <= 0) {
                response.sendRedirect("receptionist/book-appointment.jsp?error=" + URLEncoder.encode("Patient ID must be a positive number.", "UTF-8"));
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("receptionist/book-appointment.jsp?error=" + URLEncoder.encode("Invalid Patient ID format. Please enter a numerical ID.", "UTF-8"));
            return;
        }

        // 3. Validate time slot matches one of the 5 allowed daily slots
        String slotTime = appTime.trim();
        if (slotTime.length() > 5) {
            slotTime = slotTime.substring(0, 5); // Normalize HH:mm format
        }

        if (!ALLOWED_SLOTS.contains(slotTime)) {
            response.sendRedirect("receptionist/book-appointment.jsp?error=" + 
                    URLEncoder.encode("Invalid slot selection. Please choose one of the 5 authorized daily slots.", "UTF-8"));
            return;
        }

        String formattedTime = slotTime + ":00";

        Connection conn = null;
        PreparedStatement checkPatientPs = null;
        PreparedStatement checkDoctorPs = null;
        PreparedStatement checkSlotPs = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();

            // 4. Foreign key check against patients(id)
            String checkPatientSql = "SELECT id FROM patients WHERE id = ?";
            checkPatientPs = conn.prepareStatement(checkPatientSql);
            checkPatientPs.setInt(1, patientId);
            rs = checkPatientPs.executeQuery();

            if (!rs.next()) {
                response.sendRedirect("receptionist/book-appointment.jsp?error=" + URLEncoder.encode("Patient ID " + patientId + " is not registered in the system.", "UTF-8"));
                return;
            }
            rs.close();

            // 5. Verify Doctor is active and authorized for this treatment
            String checkDoctorSql = "SELECT d.id FROM doctors d " +
                                    "JOIN doctor_treatments dt ON d.id = dt.doctor_id " +
                                    "JOIN treatments t ON dt.treatment_id = t.id " +
                                    "WHERE d.doctor_name = ? AND d.is_active = TRUE AND t.treatment_name = ?";
            checkDoctorPs = conn.prepareStatement(checkDoctorSql);
            checkDoctorPs.setString(1, dentistName.trim());
            checkDoctorPs.setString(2, treatmentType.trim());
            rs = checkDoctorPs.executeQuery();

            if (!rs.next()) {
                response.sendRedirect("receptionist/book-appointment.jsp?error=" + 
                        URLEncoder.encode("Selected doctor is either inactive or not authorized for this treatment.", "UTF-8"));
                return;
            }
            rs.close();

            // 6. Check if the slot is already booked for this doctor on this date
            String checkSlotSql = "SELECT id FROM appointments WHERE dentist_name = ? AND appointment_date = ? AND appointment_time LIKE ?";
            checkSlotPs = conn.prepareStatement(checkSlotSql);
            checkSlotPs.setString(1, dentistName.trim());
            checkSlotPs.setString(2, appDate.trim());
            checkSlotPs.setString(3, slotTime + "%");
            rs = checkSlotPs.executeQuery();

            if (rs.next()) {
                response.sendRedirect("receptionist/book-appointment.jsp?error=" + 
                        URLEncoder.encode("The " + slotTime + " slot for " + dentistName + " on " + appDate + " is already booked.", "UTF-8"));
                return;
            }
            rs.close();

            // 7. Resolve treatment details using Factory pattern
            Treatment treatment = TreatmentFactory.getTreatment(treatmentType.trim());
            if (treatment == null) {
                throw new IllegalArgumentException("Unknown treatment factory mapping.");
            }
            
            double baseFee = treatment.getBasePrice();
            String verifiedName = treatment.getTreatmentName();

            // 8. Generate appointment reference code
            String appointmentNumber = "APP-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

            // 9. Insert record into appointments table
            String sql = "INSERT INTO appointments (appointment_number, patient_id, dentist_name, " +
                         "treatment_type, appointment_date, appointment_time, consultation_fee, payment_status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";

            ps = conn.prepareStatement(sql);
            ps.setString(1, appointmentNumber);
            ps.setInt(2, patientId);
            ps.setString(3, dentistName.trim());
            ps.setString(4, verifiedName);
            ps.setString(5, appDate.trim());
            ps.setString(6, formattedTime);
            ps.setDouble(7, baseFee);

            ps.executeUpdate();

            response.sendRedirect("receptionist/dashboard.jsp?msg=" + URLEncoder.encode("Appointment " + appointmentNumber + " Booked Successfully!", "UTF-8"));

        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            response.sendRedirect("receptionist/book-appointment.jsp?error=" + URLEncoder.encode("Invalid treatment selection.", "UTF-8"));
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("receptionist/book-appointment.jsp?error=" + URLEncoder.encode("Database transaction fault: " + e.getMessage(), "UTF-8"));
        } finally {
            if (rs != null) { try { rs.close(); } catch (SQLException e) { e.printStackTrace(); } }
            if (checkPatientPs != null) { try { checkPatientPs.close(); } catch (SQLException e) { e.printStackTrace(); } }
            if (checkDoctorPs != null) { try { checkDoctorPs.close(); } catch (SQLException e) { e.printStackTrace(); } }
            if (checkSlotPs != null) { try { checkSlotPs.close(); } catch (SQLException e) { e.printStackTrace(); } }
            if (ps != null) { try { ps.close(); } catch (SQLException e) { e.printStackTrace(); } }
        }
    }
}