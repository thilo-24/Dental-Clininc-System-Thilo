package com.sunrisedental.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.sunrisedental.config.DatabaseConnection;

@WebServlet("/TreatmentManagementServlet")
public class TreatmentManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=" + URLEncoder.encode("Access Denied.", "UTF-8"));
            return;
        }

        String actionType = request.getParameter("actionType");
        String message = "";
        String errorMessage = "";
        String contextPath = request.getContextPath();

        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();

            if ("INSERT".equalsIgnoreCase(actionType)) {
                String name = request.getParameter("treatmentName");
                String priceParam = request.getParameter("basePrice");

                if (name != null && !name.trim().isEmpty() && priceParam != null) {
                    double price = Double.parseDouble(priceParam);
                    String sql = "INSERT INTO treatments (treatment_name, base_price) VALUES (?, ?)";
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setString(1, name.trim());
                        stmt.setDouble(2, price);
                        stmt.executeUpdate();
                        message = "New treatment '" + name + "' successfully registered.";
                    }
                } else {
                    errorMessage = "Missing parameters. Check fields and retry.";
                }

            } else if ("UPDATE".equalsIgnoreCase(actionType)) {
                String idParam = request.getParameter("treatmentId");
                String name = request.getParameter("treatmentName");
                String priceParam = request.getParameter("basePrice");

                if (idParam != null && name != null && !name.trim().isEmpty() && priceParam != null) {
                    int id = Integer.parseInt(idParam);
                    double price = Double.parseDouble(priceParam);
                    String sql = "UPDATE treatments SET treatment_name = ?, base_price = ? WHERE id = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setString(1, name.trim());
                        stmt.setDouble(2, price);
                        stmt.setInt(3, id);
                        stmt.executeUpdate();
                        message = "Treatment catalog configuration successfully updated.";
                    }
                }

            } else if ("DELETE".equalsIgnoreCase(actionType)) {
                String idParam = request.getParameter("treatmentId");
                if (idParam != null) {
                    int id = Integer.parseInt(idParam);
                    String sql = "DELETE FROM treatments WHERE id = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setInt(1, id);
                        stmt.executeUpdate();
                        message = "Selected procedure line item dropped from active directory.";
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Data mutation error: " + e.getMessage();
        }

        if (!errorMessage.isEmpty()) {
            response.sendRedirect(contextPath + "/admin/treatment-fees.jsp?error=" + URLEncoder.encode(errorMessage, "UTF-8"));
        } else {
            response.sendRedirect(contextPath + "/admin/treatment-fees.jsp?msg=" + URLEncoder.encode(message, "UTF-8"));
        }
    }
}