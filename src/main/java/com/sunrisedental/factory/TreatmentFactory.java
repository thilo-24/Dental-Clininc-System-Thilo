package com.sunrisedental.factory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.sunrisedental.config.DatabaseConnection;

// Generic Concrete Product mapped dynamically from data configurations
class DynamicTreatment implements Treatment {
    private final String name;
    private final double price;

    public DynamicTreatment(String name, double price) {
        this.name = name;
        this.price = price;
    }

    @Override public String getTreatmentName() { return this.name; }
    @Override public double getBasePrice() { return this.price; }
}

public class TreatmentFactory {
    
    public static Treatment getTreatment(String type) {
        if (type == null || type.trim().isEmpty()) {
            return null;
        }

        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();
            String sql = "SELECT treatment_name, base_price FROM treatments WHERE LOWER(TRIM(treatment_name)) = LOWER(TRIM(?))";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, type.trim());
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return new DynamicTreatment(rs.getString("treatment_name"), rs.getDouble("base_price"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        throw new IllegalArgumentException("Unknown or unconfigured treatment type: " + type);
    }
}