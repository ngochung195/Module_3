package com.electronicstore.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class DBConnection {
    private static String url;
    private static String username;
    private static String password;
    private static String driver = "com.mysql.cj.jdbc.Driver";

    static {
        loadConfiguration();
    }

    public static synchronized void loadConfiguration() {
        try {
            // 1. Load MySQL Driver
            Class.forName(driver);

            // 2. Kiểm tra Environment Variables trước (dành cho Docker / Cloud / Render)
            String envHost = getEnvOrProperty("DB_HOST");
            String envPort = getEnvOrProperty("DB_PORT");
            String envDbName = getEnvOrProperty("DB_NAME");
            String envUser = getEnvOrProperty("DB_USERNAME");
            if (envUser == null) {
                envUser = getEnvOrProperty("DB_USER");
            }
            String envPass = getEnvOrProperty("DB_PASSWORD");
            if (envPass == null) {
                envPass = getEnvOrProperty("DB_PASS");
            }
            String envUrl = getEnvOrProperty("DB_URL");
            if (envUrl == null) {
                envUrl = getEnvOrProperty("MYSQL_URL");
            }

            if (envUrl != null && !envUrl.trim().isEmpty()) {
                url = envUrl.trim();
                username = envUser;
                password = envPass != null ? envPass : "";
                System.out.println("[DBConnection] Khởi tạo kết nối từ biến môi trường DB_URL/MYSQL_URL.");
                return;
            }

            if (envHost != null && !envHost.trim().isEmpty() && envDbName != null && !envDbName.trim().isEmpty()) {
                String port = (envPort != null && !envPort.trim().isEmpty()) ? envPort.trim() : "3306";
                url = "jdbc:mysql://" + envHost.trim() + ":" + port + "/" + envDbName.trim()
                        + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Ho_Chi_Minh&useUnicode=true&characterEncoding=UTF-8";
                username = envUser != null ? envUser.trim() : "root";
                password = envPass != null ? envPass : "";
                System.out.println("[DBConnection] Khởi tạo kết nối CSDL từ Environment Variables (" + envHost + ":" + port + "/" + envDbName + ").");
                return;
            }

            // 3. Fallback: Đọc từ file db.properties (chạy Local)
            try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (input != null) {
                    Properties prop = new Properties();
                    prop.load(input);
                    url = prop.getProperty("db.url");
                    username = prop.getProperty("db.username");
                    password = prop.getProperty("db.password");
                    String customDriver = prop.getProperty("db.driver");
                    if (customDriver != null && !customDriver.trim().isEmpty()) {
                        driver = customDriver.trim();
                        Class.forName(driver);
                    }
                    System.out.println("[DBConnection] Khởi tạo kết nối CSDL từ classpath db.properties.");
                } else {
                    System.err.println("[DBConnection] Cảnh báo: Không tìm thấy file db.properties và chưa cấu hình biến môi trường DB_*.");
                }
            }
        } catch (Exception e) {
            System.err.println("[DBConnection] Lỗi khởi tạo tham số DBConnection: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static String getEnvOrProperty(String key) {
        String val = System.getenv(key);
        if (val == null || val.trim().isEmpty()) {
            val = System.getProperty(key);
        }
        return (val != null && !val.trim().isEmpty()) ? val.trim() : null;
    }

    public static Connection getConnection() throws SQLException {
        if (url == null || username == null) {
            loadConfiguration();
        }
        if (url == null || username == null) {
            throw new SQLException("Cấu hình kết nối CSDL chưa đầy đủ. Vui lòng kiểm tra biến môi trường DB_* hoặc file db.properties.");
        }
        return DriverManager.getConnection(url, username, password);
    }

    public static void closeConnection(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null && !rs.isClosed()) {
                rs.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {
            if (stmt != null && !stmt.isClosed()) {
                stmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

