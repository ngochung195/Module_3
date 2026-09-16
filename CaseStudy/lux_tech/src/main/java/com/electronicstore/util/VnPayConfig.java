package com.electronicstore.util;

import jakarta.servlet.http.HttpServletRequest;

import java.io.InputStream;
import java.util.Properties;

/**
 * VnPayConfig – Quản lý thông số cấu hình cổng thanh toán VNPay Sandbox.
 * Hỗ trợ nạp cấu hình ưu tiên từ biến môi trường (Environment Variables / Render),
 * fallback về vnpay.properties và giá trị Sandbox mặc định.
 */
public class VnPayConfig {
    private static String tmnCode;
    private static String hashSecret;
    private static String url;
    private static String returnUrl;
    private static String version = "2.1.0";
    private static String command = "pay";
    private static boolean isExplicitReturnUrl = false;

    static {
        loadConfiguration();
    }

    public static synchronized void loadConfiguration() {
        // 1. Đọc từ properties file làm base
        Properties prop = new Properties();
        try (InputStream input = VnPayConfig.class.getClassLoader().getResourceAsStream("vnpay.properties")) {
            if (input != null) {
                prop.load(input);
            }
        } catch (Exception e) {
            System.err.println("[VnPayConfig] Không thể tải vnpay.properties: " + e.getMessage());
        }

        // 2. Ưu tiên biến môi trường, sau đó đến properties file, cuối cùng là giá trị mặc định Sandbox
        tmnCode = getEnvOrProp("VNPAY_TMN_CODE", prop.getProperty("vnpay.tmnCode", "RWTJ2TDY"));
        hashSecret = getEnvOrProp("VNPAY_HASH_SECRET", prop.getProperty("vnpay.hashSecret", "ZJKTIPJSDNVMBFCEPGKYWKMFXEWBFHND"));
        url = getEnvOrProp("VNPAY_URL", prop.getProperty("vnpay.url", "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html"));

        String envReturnUrl = getEnvOrProp("VNPAY_RETURN_URL", prop.getProperty("vnpay.returnUrl", null));
        if (envReturnUrl != null && !envReturnUrl.trim().isEmpty()) {
            returnUrl = envReturnUrl.trim();
            isExplicitReturnUrl = true;
        } else {
            returnUrl = "http://localhost:8080/lux_tech/vnpay-return";
            isExplicitReturnUrl = false;
        }

        version = getEnvOrProp("VNPAY_VERSION", prop.getProperty("vnpay.version", "2.1.0"));
        command = getEnvOrProp("VNPAY_COMMAND", prop.getProperty("vnpay.command", "pay"));
    }

    private static String getEnvOrProp(String envKey, String fallback) {
        String val = System.getenv(envKey);
        if (val == null || val.trim().isEmpty()) {
            val = System.getProperty(envKey);
        }
        return (val != null && !val.trim().isEmpty()) ? val.trim() : fallback;
    }

    public static String getTmnCode() {
        return tmnCode;
    }

    public static String getHashSecret() {
        return hashSecret;
    }

    public static String getUrl() {
        return url;
    }

    public static String getReturnUrl() {
        return returnUrl;
    }

    /**
     * Tạo return URL linh hoạt dựa trên HTTP Request hiện tại hoặc cấu hình tĩnh.
     */
    public static String getDynamicReturnUrl(HttpServletRequest request) {
        if (isExplicitReturnUrl && returnUrl != null && returnUrl.startsWith("http")) {
            return returnUrl;
        }
        if (request == null) {
            return returnUrl;
        }
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();

        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append(scheme).append("://").append(serverName);
        if ((scheme.equalsIgnoreCase("http") && serverPort != 80) || (scheme.equalsIgnoreCase("https") && serverPort != 443)) {
            urlBuilder.append(":").append(serverPort);
        }
        urlBuilder.append(contextPath).append("/vnpay-return");
        return urlBuilder.toString();
    }

    public static String getVersion() {
        return version;
    }

    public static String getCommand() {
        return command;
    }
}

