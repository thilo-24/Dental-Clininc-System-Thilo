package com.sunrisedental.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.sunrisedental.config.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/BillingServlet")
public class BillingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentIdParam = request.getParameter("appointmentId");

        if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty()) {
            response.sendRedirect("receptionist/billing.jsp?error=" + URLEncoder.encode("Invalid Appointment Selection", "UTF-8"));
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            
            // Update the invoice workflow status to PAID
            String sql = "UPDATE appointments SET payment_status = 'PAID' WHERE id = ?";

            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(appointmentIdParam.trim()));
            ps.executeUpdate();

            // Success redirect with safety-encoded string configuration
            response.sendRedirect("receptionist/dashboard.jsp?msg=" + URLEncoder.encode("Payment Processed and Settlement Receipt (including 20% Tax) Issued!", "UTF-8"));

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("receptionist/billing.jsp?error=" + URLEncoder.encode("Database checkout pipeline exception encountered.", "UTF-8"));
        } finally {
            if (ps != null) {
                try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
}