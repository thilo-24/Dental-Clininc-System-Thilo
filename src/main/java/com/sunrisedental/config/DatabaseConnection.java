package com.sunrisedental.config;

//Singleton Database Connection for Sunrise Dental System
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static DatabaseConnection instance;
    private Connection connection;

    // Adjust port mapping if your MySQL operates on standard 3306 instead of 3606
    private final String url = "jdbc:mysql://localhost:3306/sunrise_dental?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private final String username = "root";
    private final String password = "";

    private DatabaseConnection() throws SQLException {
        try {
            // Explicitly force registration of MySQL modern driver engine class
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database Driver Missing from System Deployment Lifecycle.", e);
        }
    }

    public static synchronized DatabaseConnection getInstance() throws SQLException {
        if (instance == null || instance.getConnection() == null || instance.getConnection().isClosed()) {
            instance = new DatabaseConnection();
        }
        return instance;
    }

    public Connection getConnection() {
        return connection;
    }
}