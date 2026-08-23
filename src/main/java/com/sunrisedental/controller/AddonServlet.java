package com.sunrisedental.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.sunrisedental.config.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddonServlet")
public class AddonServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String appointmentIdParam = request.getParameter("appointmentId");

        if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty()) {
            response.sendRedirect("receptionist/view-appointments.jsp?error=" + 
                URLEncoder.encode("Invalid Appointment ID", StandardCharsets.UTF_8));
            return;
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(appointmentIdParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("receptionist/view-appointments.jsp?error=" + 
                URLEncoder.encode("Invalid Appointment ID format", StandardCharsets.UTF_8));
            return;
        }

        if ("add".equalsIgnoreCase(action)) {
            String addonName = request.getParameter("addonName");
            String addonPriceParam = request.getParameter("addonPrice");

            if (addonName == null || addonPriceParam == null || 
                addonName.trim().isEmpty() || addonPriceParam.trim().isEmpty()) {
                response.sendRedirect("receptionist/edit-appointment.jsp?id=" + appointmentId + 
                    "&error=" + URLEncoder.encode("Specify both treatment name and price.", StandardCharsets.UTF_8));
                return;
            }

            double addonPrice;
            try {
                addonPrice = Double.parseDouble(addonPriceParam.trim());
            } catch (NumberFormatException e) {
                response.sendRedirect("receptionist/edit-appointment.jsp?id=" + appointmentId + 
                    "&error=" + URLEncoder.encode("Invalid price format.", StandardCharsets.UTF_8));
                return;
            }

            String sql = "INSERT INTO appointment_addons (appointment_id, addon_name, addon_price) VALUES (?, ?, ?)";
            try (Connection conn = DatabaseConnection.getInstance().getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                ps.setInt(1, appointmentId);
                ps.setString(2, addonName.trim());
                ps.setDouble(3, addonPrice);
                ps.executeUpdate();

                response.sendRedirect("receptionist/edit-appointment.jsp?id=" + appointmentId + 
                    "&msg=" + URLEncoder.encode("Extra service added successfully!", StandardCharsets.UTF_8));
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("receptionist/edit-appointment.jsp?id=" + appointmentId + 
                    "&error=" + URLEncoder.encode("Database error: " + e.getMessage(), StandardCharsets.UTF_8));
            }

        } else if ("delete".equalsIgnoreCase(action)) {
            String addonIdParam = request.getParameter("addonId");
            if (addonIdParam != null && !addonIdParam.trim().isEmpty()) {
                try {
                    int addonId = Integer.parseInt(addonIdParam.trim());
                    String sql = "DELETE FROM appointment_addons WHERE id = ? AND appointment_id = ?";
                    try (Connection conn = DatabaseConnection.getInstance().getConnection();
                         PreparedStatement ps = conn.prepareStatement(sql)) {
                        
                        ps.setInt(1, addonId);
                        ps.setInt(2, appointmentId);
                        ps.executeUpdate();

                        response.sendRedirect("receptionist/edit-appointment.jsp?id=" + appointmentId + 
                            "&msg=" + URLEncoder.encode("Add-on removed.", StandardCharsets.UTF_8));
                    }
                } catch (NumberFormatException | SQLException e) {
                    e.printStackTrace();
                    response.sendRedirect("receptionist/edit-appointment.jsp?id=" + appointmentId + 
                        "&error=" + URLEncoder.encode("Error deleting add-on.", StandardCharsets.UTF_8));
                }
            }
        }
    }
}