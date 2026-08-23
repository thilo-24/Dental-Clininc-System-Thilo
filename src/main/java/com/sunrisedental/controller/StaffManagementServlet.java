package com.sunrisedental.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;

// UPGRADED IMPORTS FOR TOMCAT 11 (jakarta instead of javax)
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.sunrisedental.config.DatabaseConnection;

@WebServlet("/StaffManagementServlet")
public class StaffManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=" + URLEncoder.encode("Unauthorized action sequence boundary breach.", "UTF-8"));
            return;
        }

        String actionType = request.getParameter("actionType");
        String message = "";
        String errorMessage = "";
        
        // Context Path Setup to keep target structures uniform
        String contextPath = request.getContextPath();
        
        // FIX 1: Safe Object extraction instead of direct casting to avoid NullPointerException crashes
        Object adminIdObj = session.getAttribute("userId");
        int currentAdminId = (adminIdObj != null) ? (Integer) adminIdObj : 0;

        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();

            if ("INSERT".equalsIgnoreCase(actionType)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password"); 
                String role = request.getParameter("role");

                if (username != null && !username.trim().isEmpty() && password != null) {
                    String insertSql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
                    try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                        stmt.setString(1, username.trim());
                        stmt.setString(2, password);
                        stmt.setString(3, role);
                        stmt.executeUpdate();
                        message = "Account identity node for " + username + " successfully committed.";
                    }
                } else {
                    errorMessage = "Failed to commit. Required identity parameters cannot be null.";
                }

            } else if ("UPDATE".equalsIgnoreCase(actionType)) {
                // Admin updating their own credentials sequence
                String targetIdParam = request.getParameter("userId");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                if (targetIdParam != null) {
                    int targetUserId = Integer.parseInt(targetIdParam);

                    // FIX 2: Check if currentAdminId is valid (not 0) along with your security validation logic
                    if (currentAdminId == 0 || targetUserId != currentAdminId) {
                        errorMessage = "Access Violation. You are only authorized to alter your own unique identity key matrix.";
                    } else if (username != null && !username.trim().isEmpty() && password != null && !password.trim().isEmpty()) {
                        String updateSql = "UPDATE users SET username = ?, password = ?, role = ? WHERE id = ?";
                        try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                            stmt.setString(1, username.trim());
                            stmt.setString(2, password);
                            stmt.setString(3, role);
                            stmt.setInt(4, targetUserId);
                            
                            int rows = stmt.executeUpdate();
                            if (rows > 0) {
                                // Dynamically sync active session context parameters with updated DB parameters
                                session.setAttribute("user", username.trim());
                                session.setAttribute("role", role);
                                message = "Your administrative authentication profile parameters have been successfully secure-saved.";
                            } else {
                                errorMessage = "Identity sync error: Target user entity row index missing.";
                            }
                        }
                    } else {
                        errorMessage = "Modification abort: Data entries cannot be empty parameters.";
                    }
                }

            } else if ("DELETE".equalsIgnoreCase(actionType)) {
                String userIdParam = request.getParameter("userId");
                
                if (userIdParam != null) {
                    int userId = Integer.parseInt(userIdParam);

                    // FIX 3: Safe constraint validation to ensure clean handling rules
                    if (currentAdminId != 0 && userId == currentAdminId) {
                        errorMessage = "Self-destructive node termination rejected. You cannot delete your own profile.";
                    } else {
                        String deleteSql = "DELETE FROM users WHERE id = ?";
                        try (PreparedStatement stmt = conn.prepareStatement(deleteSql)) {
                            stmt.setInt(1, userId);
                            int rowsAffected = stmt.executeUpdate();
                            if (rowsAffected > 0) {
                                message = "Account node ID #" + userId + " permanently unlinked from active directory.";
                            } else {
                                errorMessage = "Target identity node sequence could not be located.";
                            }
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Data transaction error encountered: " + e.getMessage();
        }

        // Return handling parameters back to view matrix wrapper
        if (!errorMessage.isEmpty()) {
            response.sendRedirect(contextPath + "/admin/manage-staff.jsp?error=" + URLEncoder.encode(errorMessage, "UTF-8"));
        } else {
            response.sendRedirect(contextPath + "/admin/manage-staff.jsp?msg=" + URLEncoder.encode(message, "UTF-8"));
        }
    }
}