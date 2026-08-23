package com.sunrisedental.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.sunrisedental.config.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/PatientServlet")
public class PatientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String contact = request.getParameter("contactNumber");
        String address = request.getParameter("address");

        if ("register".equals(action)) {
            // 1. Mandatory Fields Validation
            if (name == null || contact == null || address == null ||
                name.trim().isEmpty() || contact.trim().isEmpty() || address.trim().isEmpty()) {
                
                response.sendRedirect("receptionist/register-patient.jsp?error=" + 
                    URLEncoder.encode("All fields are mandatory", StandardCharsets.UTF_8));
                return;
            }

            name = name.trim();
            contact = contact.trim();
            address = address.trim();

            // 2. Strict Contact Number Validation (Must be exactly 10 digits)
            if (!contact.matches("^[0-9]{10}$")) {
                response.sendRedirect("receptionist/register-patient.jsp?error=" + 
                    URLEncoder.encode("Contact number must be exactly 10 digits without special characters or spaces", StandardCharsets.UTF_8));
                return;
            }

            Connection conn = null;
            PreparedStatement checkPs = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                conn = DatabaseConnection.getInstance().getConnection();
                
                // 3. Duplicate Check: Ensure name AND contact_number combination doesn't exist
                String checkSql = "SELECT id FROM patients WHERE LOWER(name) = LOWER(?) AND contact_number = ?";
                checkPs = conn.prepareStatement(checkSql);
                checkPs.setString(1, name);
                checkPs.setString(2, contact);
                rs = checkPs.executeQuery();

                if (rs.next()) {
                    // Patient already exists! Redirect back with error message
                    response.sendRedirect("receptionist/register-patient.jsp?error=" + 
                        URLEncoder.encode("Invalid registration: Patient with this name and contact number already exists!", StandardCharsets.UTF_8));
                    return;
                }

                // Close result set and check statement before running insert
                rs.close();
                checkPs.close();

                // 4. Insert New Patient Record
                String sql = "INSERT INTO patients (name, contact_number, address) VALUES (?, ?, ?)";
                ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, name);
                ps.setString(2, contact);
                ps.setString(3, address);
                ps.executeUpdate();

                rs = ps.getGeneratedKeys();
                int generatedId = 0;
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }

                response.sendRedirect("receptionist/dashboard.jsp?msg=" + 
                    URLEncoder.encode("Patient registered successfully! Assigned ID: " + generatedId, StandardCharsets.UTF_8));

            } catch (SQLException e) {
                throw new ServletException("Database write failure during new patient entry initialization", e);
            } finally {
                if (rs != null) { try { rs.close(); } catch (SQLException e) { e.printStackTrace(); } }
                if (checkPs != null) { try { checkPs.close(); } catch (SQLException e) { e.printStackTrace(); } }
                if (ps != null) { try { ps.close(); } catch (SQLException e) { e.printStackTrace(); } }
            }
        }
    }
}