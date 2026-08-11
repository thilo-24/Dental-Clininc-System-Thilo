package com.sunrisedental.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;

import com.sunrisedental.config.DatabaseConnection;

public class AppointmentValidationUtil {

    /**
     * Checks if the doctor has any existing appointment within 30 minutes 
     * of the requested date and time.
     */
    public static boolean isDoctorAvailable(String doctorName, LocalDate appDate, LocalTime appTime) {
        String sql = "SELECT appointment_time FROM appointments WHERE LOWER(TRIM(dentist_name)) = LOWER(TRIM(?)) AND appointment_date = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, doctorName);
            ps.setDate(2, java.sql.Date.valueOf(appDate));

            try (ResultSet rs = ps.executeQuery()) {
                LocalDateTime newBookingDateTime = LocalDateTime.of(appDate, appTime);

                while (rs.next()) {
                    LocalTime existingTime = rs.getTime("appointment_time").toLocalTime();
                    LocalDateTime existingBookingDateTime = LocalDateTime.of(appDate, existingTime);

                    // Calculate total absolute difference in minutes
                    long minutesDifference = Math.abs(ChronoUnit.MINUTES.between(existingBookingDateTime, newBookingDateTime));

                    // Less than 30 minutes means there is a scheduling conflict
                    if (minutesDifference < 30) {
                        System.out.println("Conflict Detected: " + doctorName + " already has a booking at " + existingTime + 
                                           ". Time diff is " + minutesDifference + " mins.");
                        return false; // Doctor is busy
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        return true; // Doctor is free
    }
}