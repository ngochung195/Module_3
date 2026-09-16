package com.electronicstore.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.Statement;

class UpdateColorsTest {

    @Test
    @DisplayName("Cập nhật lại toàn bộ bảng product_colors theo tệp add_products_phase11.sql")
    void updateColors() {
        String sqlFilePath = "database/add_products_phase11.sql";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // 1. Xóa các màu của sản phẩm đã thêm ở phase 11 (hoặc clear và re-insert)
            stmt.execute("DELETE FROM product_colors WHERE product_id IN (SELECT id FROM products WHERE id > 10)");

            // 2. Đọc file add_products_phase11.sql
            String content = new String(Files.readAllBytes(Paths.get(sqlFilePath)), java.nio.charset.StandardCharsets.UTF_8);

            // 3. Tìm phần INSERT INTO product_colors
            int colorInsertIdx = content.indexOf("INSERT INTO product_colors");
            if (colorInsertIdx != -1) {
                String colorSql = content.substring(colorInsertIdx).trim();
                // Bỏ comment nếu có
                StringBuilder cleanSql = new StringBuilder();
                for (String line : colorSql.split("\r?\n")) {
                    String t = line.trim();
                    if (!t.startsWith("--") && !t.startsWith("/*")) {
                        cleanSql.append(line).append("\n");
                    }
                }
                stmt.execute(cleanSql.toString());
                System.out.println("[UpdateColorsTest] Đã cập nhật thành công màu sắc sản phẩm trong CSDL.");
            }

        } catch (Exception e) {
            System.err.println("[UpdateColorsTest] Lỗi khi cập nhật màu: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
