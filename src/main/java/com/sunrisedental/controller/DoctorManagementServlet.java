package com.sunrisedental.controller;

import java.io.IOException;
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
import jakarta.servlet.http.HttpSession;

@WebServlet("/DoctorManagementServlet")
public class DoctorManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=Access Denied: Admin privileges required");
            return;
        }

        String action = request.getParameter("action");

        if ("addDoctor".equals(action)) {
            handleAddDoctor(request, response);
        } else if ("toggleStatus".equals(action)) {
            handleToggleStatus(request, response);
        } else if ("assignTreatments".equals(action)) {
            handleAssignTreatments(request, response);
        }
    }

    private void handleAddDoctor(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("doctorName");
        String spec = request.getParameter("specialization");

        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("admin/manage-doctors.jsp?error=Doctor name cannot be empty");
            return;
        }

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO doctors (doctor_name, specialization, is_active) VALUES (?, ?, TRUE)")) {
            ps.setString(1, name.trim());
            ps.setString(2, (spec != null && !spec.trim().isEmpty()) ? spec.trim() : "General Dental Surgeon");
            ps.executeUpdate();

            response.sendRedirect("admin/manage-doctors.jsp?msg=Doctor added successfully");
        } catch (SQLException e) {
            response.sendRedirect("admin/manage-doctors.jsp?error=Database error: " + e.getMessage());
        }
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int docId = Integer.parseInt(request.getParameter("doctorId"));
        boolean currentStatus = Boolean.parseBoolean(request.getParameter("currentStatus"));

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE doctors SET is_active = ? WHERE id = ?")) {
            ps.setBoolean(1, !currentStatus);
            ps.setInt(2, docId);
            ps.executeUpdate();

            response.sendRedirect("admin/manage-doctors.jsp?msg=Doctor availability updated");
        } catch (SQLException e) {
            response.sendRedirect("admin/manage-doctors.jsp?error=Database error: " + e.getMessage());
        }
    }

    private void handleAssignTreatments(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int docId = Integer.parseInt(request.getParameter("doctorId"));
        String[] treatmentIds = request.getParameterValues("treatmentIds");

        Connection conn = null;
        try {
            conn = DatabaseConnection.getInstance().getConnection();
            conn.setAutoCommit(false);

            // Clear old mappings
            try (PreparedStatement deletePs = conn.prepareStatement("DELETE FROM doctor_treatments WHERE doctor_id = ?")) {
                deletePs.setInt(1, docId);
                deletePs.executeUpdate();
            }

            // Insert new mappings
            if (treatmentIds != null && treatmentIds.length > 0) {
                try (PreparedStatement insertPs = conn.prepareStatement("INSERT INTO doctor_treatments (doctor_id, treatment_id) VALUES (?, ?)")) {
                    for (String tId : treatmentIds) {
                        insertPs.setInt(1, docId);
                        insertPs.setInt(2, Integer.parseInt(tId));
                        insertPs.addBatch();
                    }
                    insertPs.executeBatch();
                }
            }

            conn.commit();
            response.sendRedirect("admin/manage-doctors.jsp?msg=Doctor treatments updated successfully");
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            response.sendRedirect("admin/manage-doctors.jsp?error=Failed to update treatments: " + e.getMessage());
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }
}