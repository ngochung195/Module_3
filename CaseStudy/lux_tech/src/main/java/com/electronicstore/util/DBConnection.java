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

            // 2. Kiểm tra Environment Variables (Hỗ trợ đa nền tảng: Aiven, Render, Railway, Clever Cloud, Docker, Local)
            String envHost = getEnvOrProperty("DB_HOST");
            if (envHost == null) envHost = getEnvOrProperty("MYSQLHOST");

            String envPort = getEnvOrProperty("DB_PORT");
            if (envPort == null) envPort = getEnvOrProperty("MYSQLPORT");

            String envDbName = getEnvOrProperty("DB_NAME");
            if (envDbName == null) envDbName = getEnvOrProperty("MYSQLDATABASE");

            String envUser = getEnvOrProperty("DB_USERNAME");
            if (envUser == null) envUser = getEnvOrProperty("DB_USER");
            if (envUser == null) envUser = getEnvOrProperty("MYSQLUSER");

            String envPass = getEnvOrProperty("DB_PASSWORD");
            if (envPass == null) envPass = getEnvOrProperty("DB_PASS");
            if (envPass == null) envPass = getEnvOrProperty("MYSQLPASSWORD");

            String envSsl = getEnvOrProperty("DB_SSL");
            if (envSsl == null) envSsl = getEnvOrProperty("MYSQL_SSL");

            String envUrl = getEnvOrProperty("DB_URL");
            if (envUrl == null) envUrl = getEnvOrProperty("MYSQL_URL");
            if (envUrl == null) envUrl = getEnvOrProperty("MYSQL_PUBLIC_URL");
            if (envUrl == null) envUrl = getEnvOrProperty("DATABASE_URL");

            // Xử lý nếu người dùng cung cấp Full Database URL (như Service URI từ Aiven / Render / Railway)
            if (envUrl != null && !envUrl.trim().isEmpty()) {
                String rawUrl = envUrl.trim();
                parseAndSetFromUri(rawUrl, envUser, envPass, envSsl);
                return;
            }

            // Xử lý nếu cấu hình bằng các biến host/port/name/user/pass riêng biệt
            if (envHost != null && !envHost.trim().isEmpty() && envDbName != null && !envDbName.trim().isEmpty()) {
                String port = (envPort != null && !envPort.trim().isEmpty()) ? envPort.trim() : "3306";
                boolean isCloudHost = envHost.contains("aivencloud.com") || envHost.contains("railway.app")
                        || envHost.contains("clever-cloud.com") || envHost.contains("rds.amazonaws.com")
                        || envHost.contains("render.com");
                
                boolean useSsl = "true".equalsIgnoreCase(envSsl) || (envSsl == null && isCloudHost);

                StringBuilder urlBuilder = new StringBuilder("jdbc:mysql://");
                urlBuilder.append(envHost.trim()).append(":").append(port).append("/").append(envDbName.trim());
                if (useSsl) {
                    urlBuilder.append("?sslMode=REQUIRED");
                } else {
                    urlBuilder.append("?sslMode=DISABLED");
                }
                urlBuilder.append("&allowPublicKeyRetrieval=true&serverTimezone=Asia/Ho_Chi_Minh&useUnicode=true&characterEncoding=UTF-8&connectTimeout=10000&socketTimeout=30000");

                url = urlBuilder.toString();
                username = envUser != null ? envUser.trim() : "root";
                password = envPass != null ? envPass : "";
                System.out.println("[DBConnection] Khởi tạo kết nối CSDL từ Environment Variables (" + envHost + ":" + port + "/" + envDbName + ", SSL=" + useSsl + ").");
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

    /**
     * Phân tích Service URI (vd: mysql://avnadmin:pwd@host:port/dbname?ssl-mode=REQUIRED)
     * thành định dạng chuẩn JDBC cho MySQL Connector
     */
    private static void parseAndSetFromUri(String rawUrl, String fallbackUser, String fallbackPass, String envSsl) {
        try {
            String uriStr = rawUrl;
            if (uriStr.startsWith("jdbc:mysql://")) {
                uriStr = uriStr.substring(5); // strip "jdbc:" to parse with URI
            } else if (!uriStr.startsWith("mysql://")) {
                uriStr = "mysql://" + uriStr;
            }

            java.net.URI uri = new java.net.URI(uriStr);
            String parsedUser = fallbackUser;
            String parsedPass = fallbackPass;

            String userInfo = uri.getUserInfo();
            if (userInfo != null && !userInfo.isEmpty()) {
                String[] parts = userInfo.split(":", 2);
                parsedUser = java.net.URLDecoder.decode(parts[0], java.nio.charset.StandardCharsets.UTF_8);
                if (parts.length > 1) {
                    parsedPass = java.net.URLDecoder.decode(parts[1], java.nio.charset.StandardCharsets.UTF_8);
                }
            }

            String host = uri.getHost();
            int port = uri.getPort() > 0 ? uri.getPort() : 3306;
            String path = uri.getPath();
            String dbName = (path != null && path.length() > 1) ? path.substring(1) : "defaultdb";

            boolean isCloudHost = (host != null && (host.contains("aivencloud.com") || host.contains("railway.app")
                    || host.contains("clever-cloud.com") || host.contains("rds.amazonaws.com")));

            boolean useSsl = "true".equalsIgnoreCase(envSsl) || (rawUrl.contains("ssl-mode=REQUIRED") || rawUrl.contains("useSSL=true") || (envSsl == null && isCloudHost));

            StringBuilder jdbcUrl = new StringBuilder("jdbc:mysql://");
            jdbcUrl.append(host).append(":").append(port).append("/").append(dbName);
            if (useSsl) {
                jdbcUrl.append("?sslMode=REQUIRED");
            } else {
                jdbcUrl.append("?sslMode=DISABLED");
            }
            jdbcUrl.append("&allowPublicKeyRetrieval=true&serverTimezone=Asia/Ho_Chi_Minh&useUnicode=true&characterEncoding=UTF-8&connectTimeout=10000&socketTimeout=30000");

            url = jdbcUrl.toString();
            username = (parsedUser != null && !parsedUser.isEmpty()) ? parsedUser : fallbackUser;
            password = parsedPass != null ? parsedPass : (fallbackPass != null ? fallbackPass : "");

            System.out.println("[DBConnection] Phân tích thành công Database URI (" + host + ":" + port + "/" + dbName + ", User: " + username + ", SSL=" + useSsl + ").");
        } catch (Exception ex) {
            System.err.println("[DBConnection] Cảnh báo lỗi phân tích URI, sử dụng URL dạng thô: " + ex.getMessage());
            String cleanUrl = rawUrl;
            if (cleanUrl.startsWith("mysql://")) {
                cleanUrl = "jdbc:" + cleanUrl;
            }
            url = cleanUrl;
            username = fallbackUser;
            password = fallbackPass != null ? fallbackPass : "";
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

