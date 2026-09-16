package com.electronicstore.util;

import jakarta.servlet.http.HttpServletRequest;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * VnPayUtil – Tiện ích mã hóa, ký số HMAC-SHA512, sắp xếp tham số và trích xuất IP theo chuẩn VNPay v2.1.0.
 */
public class VnPayUtil {

    /**
     * Băm chuỗi dữ liệu với khóa bí mật sử dụng thuật toán HMAC-SHA512.
     * @param key Khóa bí mật (HashSecret)
     * @param data Chuỗi dữ liệu cần băm (chuỗi hash data đã sắp xếp)
     * @return Chuỗi Hexadecimal 128 ký tự chữ thường
     */
    public static String hmacSHA512(String key, String data) {
        try {
            if (key == null || data == null) {
                throw new IllegalArgumentException("Khóa bí mật và dữ liệu băm không được để null");
            }
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKey);
            byte[] result = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            System.err.println("Lỗi tính HMAC-SHA512: " + ex.getMessage());
            return "";
        }
    }

    /**
     * Sắp xếp và tạo chuỗi hash data theo chuẩn VNPay v2.1.0 (sử dụng StandardCharsets.US_ASCII).
     * Cả fieldName và fieldValue đều được URLEncoder.encode theo tài liệu mẫu VNPay.
     * @param fields Map chứa các tham số (không chứa vnp_SecureHash)
     * @return Chuỗi hash data đã format: key1=val1&key2=val2
     */
    public static String buildHashData(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>();
        for (Map.Entry<String, String> entry : fields.entrySet()) {
            if (entry.getValue() != null && !entry.getValue().trim().isEmpty()) {
                fieldNames.add(entry.getKey());
            }
        }
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            try {
                hashData.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8.toString()));
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));
                if (itr.hasNext()) {
                    hashData.append('&');
                }
            } catch (UnsupportedEncodingException e) {
                // UTF-8 luôn được hỗ trợ bởi JVM
            }
        }
        return hashData.toString();
    }

    /**
     * Sắp xếp và tạo chuỗi Query URL theo chuẩn VNPay v2.1.0.
     * @param fields Map chứa các tham số
     * @return Chuỗi query: key1=val1&key2=val2 (được encode UTF-8)
     */
    public static String buildQueryUrl(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>();
        for (Map.Entry<String, String> entry : fields.entrySet()) {
            if (entry.getValue() != null && !entry.getValue().trim().isEmpty()) {
                fieldNames.add(entry.getKey());
            }
        }
        Collections.sort(fieldNames);

        StringBuilder query = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            try {
                query.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                }
            } catch (UnsupportedEncodingException e) {
                // UTF-8 luôn được hỗ trợ bởi JVM
            }
        }
        return query.toString();
    }

    /**
     * Lấy địa chỉ IP chính xác của Client, hỗ trợ chạy qua Proxy/Load Balancer.
     */
    public static String getIpAddress(HttpServletRequest request) {
        if (request == null) {
            return "127.0.0.1";
        }
        String ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("Proxy-Client-IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getRemoteAddr();
        }
        if (ipAddress != null && ipAddress.contains(",")) {
            ipAddress = ipAddress.split(",")[0].trim();
        }
        if ("0:0:0:0:0:0:0:1".equals(ipAddress) || "::1".equals(ipAddress)) {
            ipAddress = "127.0.0.1";
        }
        return (ipAddress != null && !ipAddress.isEmpty()) ? ipAddress : "127.0.0.1";
    }
}
