package com.sunrisedental.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.sunrisedental.config.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/GetBookedSlotsServlet")
public class GetBookedSlotsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dentistName = request.getParameter("dentistName");
        String appointmentDate = request.getParameter("appointmentDate");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        List<String> bookedTimes = new ArrayList<>();

        if (dentistName != null && appointmentDate != null && 
            !dentistName.trim().isEmpty() && !appointmentDate.trim().isEmpty()) {

            String sql = "SELECT appointment_time FROM appointments WHERE dentist_name = ? AND appointment_date = ?";

            try (Connection conn = DatabaseConnection.getInstance().getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, dentistName.trim());
                ps.setString(2, appointmentDate.trim());

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String time = rs.getString("appointment_time");
                        if (time != null && time.length() >= 5) {
                            bookedTimes.add(time.substring(0, 5));
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Return simple JSON array (e.g., ["09:00", "14:00"])
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < bookedTimes.size(); i++) {
            json.append("\"").append(bookedTimes.get(i)).append("\"");
            if (i < bookedTimes.size() - 1) json.append(",");
        }
        json.append("]");

        out.print(json.toString());
        out.flush();
    }
}