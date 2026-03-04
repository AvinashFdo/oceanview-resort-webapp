package com.oceanviewresort.util;

import java.sql.Connection;

public class DBTest {
    public static void main(String[] args) {
        try (Connection con = DBConnection.getConnection()) {
            System.out.println("✅ Connected to DB: " + con.getCatalog());
        } catch (Exception e) {
            System.out.println("❌ DB connection failed");
            e.printStackTrace();
        }
    }
}