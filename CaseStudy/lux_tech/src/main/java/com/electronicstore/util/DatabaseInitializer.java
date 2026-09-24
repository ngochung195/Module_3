package com.electronicstore.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class DatabaseInitializer {

    public static void main(String[] args) {
        System.out.println("=== BẮT ĐẦU CHẠY CẬP NHẬT DATABASE LUXTECH ===");
        File schemaFile = new File("database/schema.sql");
        if (!schemaFile.exists()) {
            schemaFile = new File("d:/CodeGym/Module3/CaseStudy/lux_tech/database/schema.sql");
        }

        if (!schemaFile.exists()) {
            System.err.println("Không tìm thấy file schema.sql tại: " + schemaFile.getAbsolutePath());
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             BufferedReader reader = new BufferedReader(new FileReader(schemaFile, StandardCharsets.UTF_8))) {

            System.out.println("Đã kết nối thành công tới CSDL: " + conn.getCatalog());
            StringBuilder sqlBuilder = new StringBuilder();
            String line;
            int count = 0;

            while ((line = reader.readLine()) != null) {
                String trimmed = line.trim();
                if (trimmed.startsWith("--") || trimmed.startsWith("//") || trimmed.isEmpty()) {
                    continue;
                }
                sqlBuilder.append(line).append("\n");
                if (trimmed.endsWith(";")) {
                    String sql = sqlBuilder.toString().trim();
                    if (!sql.isEmpty()) {
                        try {
                            stmt.execute(sql);
                            count++;
                        } catch (Exception ex) {
                            System.err.println("Lỗi khi chạy lệnh SQL: " + ex.getMessage());
                        }
                    }
                    sqlBuilder.setLength(0);
                }
            }

            System.out.println("=== THÀNH CÔNG: Đã thực thi xong " + count + " khối lệnh SQL! ===");

            // Kiểm tra tổng số đơn hàng hiện tại trong DB
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total_orders, SUM(total) AS total_revenue FROM orders")) {
                if (rs.next()) {
                    System.out.println("-> Tổng số đơn hàng trong DB: " + rs.getInt("total_orders"));
                    System.out.println("-> Tổng doanh thu tất cả đơn hàng: " + rs.getBigDecimal("total_revenue") + " VNĐ");
                }
            }

            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total_items FROM order_details")) {
                if (rs.next()) {
                    System.out.println("-> Tổng số chi tiết đơn hàng (order_details): " + rs.getInt("total_items"));
                }
            }

        } catch (Exception e) {
            System.err.println("Lỗi khi thực thi khởi tạo Database: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
