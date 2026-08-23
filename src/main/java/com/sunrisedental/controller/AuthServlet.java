package com.sunrisedental.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.sunrisedental.config.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userParam = request.getParameter("username");
        String passParam = request.getParameter("password");

        if (userParam == null || passParam == null || userParam.trim().isEmpty() || passParam.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=Username and Password fields cannot be empty");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();

            String sql = "SELECT username, role FROM users WHERE username = ? AND password = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, userParam.trim());
            ps.setString(2, passParam);

            rs = ps.executeQuery();

            if (rs.next()) {
                String activeUser = rs.getString("username");
                String assignedRole = rs.getString("role").toUpperCase();

                HttpSession session = request.getSession(true);
                session.setAttribute("user", activeUser);
                session.setAttribute("role", assignedRole);

                if ("ADMIN".equals(assignedRole)) {
                    response.sendRedirect("admin/dashboard.jsp");
                } else if ("RECEPTIONIST".equals(assignedRole)) {
                    response.sendRedirect("receptionist/dashboard.jsp");
                } else {
                    response.sendRedirect("login.jsp?error=Role Assignment Error");
                }
            } else {
                response.sendRedirect("login.jsp?error=Invalid Credentials Entered");
            }

        } catch (SQLException e) {
            throw new ServletException("Database system connection interrupted during credential authentication", e);
        } finally {
            if (rs != null) {
                try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (ps != null) {
                try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    } // <-- This brace closes the doPost method cleanly

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("login.jsp?error=Session terminated safely.");
    }
} // <-- This brace closes the entire AuthServlet class


