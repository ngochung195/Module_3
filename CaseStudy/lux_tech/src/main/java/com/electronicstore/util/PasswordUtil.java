package com.electronicstore.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    /**
     * Mã hóa mật khẩu thô bằng BCrypt
     * @param plainTextPassword Mật khẩu chưa mã hóa
     * @return Chuỗi mã hóa BCrypt
     */
    public static String hashPassword(String plainTextPassword) {
        if (plainTextPassword == null || plainTextPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống.");
        }
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt(10));
    }

    /**
     * Kiểm tra mật khẩu thô với chuỗi mật khẩu đã mã hóa trong CSDL
     * @param plainTextPassword Mật khẩu chưa mã hóa người dùng nhập vào
     * @param hashedPassword Mật khẩu đã mã hóa từ CSDL
     * @return true nếu khớp, ngược lại false
     */
    public static boolean checkPassword(String plainTextPassword, String hashedPassword) {
        if (plainTextPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            // Kiểm tra theo chuẩn BCrypt
            if (hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2b$") || hashedPassword.startsWith("$2y$")) {
                return BCrypt.checkpw(plainTextPassword, hashedPassword);
            }
            // Hỗ trợ so sánh trực tiếp nếu trong DB là plain-text ngẫu nhiên (chỉ dùng dự phòng)
            return plainTextPassword.equals(hashedPassword);
        } catch (Exception e) {
            System.err.println("Lỗi kiểm tra mật khẩu BCrypt: " + e.getMessage());
            return false;
        }
    }
}
