package com.oceanviewresort.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static Connection connection;

    private static final String URL = "jdbc:mysql://localhost:3306/oceanview_resort";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    private DBConnection() {
        // private constructor to prevent object creation
    }

    public static Connection getConnection() throws SQLException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found in WEB-INF/lib", e);
        }

        if (connection == null || connection.isClosed()) {
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        }

        return connection;
    }
}