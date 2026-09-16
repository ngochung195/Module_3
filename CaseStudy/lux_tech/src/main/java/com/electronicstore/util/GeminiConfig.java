package com.electronicstore.util;

import java.io.InputStream;
import java.util.Properties;

/**
 * GeminiConfig – Quản lý cấu hình Google Gemini AI cho LuxTech Store.
 * Đảm bảo API key được đọc từ biến môi trường, tuyệt đối không hard-code trong mã nguồn.
 */
public class GeminiConfig {

    public static final String DEFAULT_MODEL_ID = "gemini-3.5-flash";
    public static final int MAX_MESSAGE_LENGTH = 1000;
    public static final int MAX_HISTORY_MESSAGES = 10;

    private static String apiKey;
    private static String modelId = DEFAULT_MODEL_ID;

    static {
        loadConfiguration();
    }

    public static synchronized void loadConfiguration() {
        // 1. Ưu tiên đọc từ biến môi trường GEMINI_API_KEY
        String envKey = System.getenv("GEMINI_API_KEY");
        if (envKey == null || envKey.trim().isEmpty()) {
            // 2. Fallback sang GOOGLE_API_KEY
            envKey = System.getenv("GOOGLE_API_KEY");
        }

        // 3. Fallback sang System properties
        if (envKey == null || envKey.trim().isEmpty()) {
            envKey = System.getProperty("GEMINI_API_KEY");
        }
        if (envKey == null || envKey.trim().isEmpty()) {
            envKey = System.getProperty("GOOGLE_API_KEY");
        }

        // 4. Fallback sang file properties nếu có (không bắt buộc)
        if (envKey == null || envKey.trim().isEmpty()) {
            try (InputStream input = GeminiConfig.class.getClassLoader().getResourceAsStream("gemini.properties")) {
                if (input != null) {
                    Properties prop = new Properties();
                    prop.load(input);
                    envKey = prop.getProperty("gemini.apiKey");
                    String customModel = prop.getProperty("gemini.modelId");
                    if (customModel != null && !customModel.trim().isEmpty()) {
                        modelId = customModel.trim();
                    }
                }
            } catch (Exception e) {
                // Ignore properties loading error
            }
        }

        apiKey = (envKey != null && !envKey.trim().isEmpty()) ? envKey.trim() : null;

        if (apiKey == null) {
            System.out.println("[GeminiConfig] Thông báo: Chưa cấu hình GEMINI_API_KEY trong biến môi trường.");
        } else {
            System.out.println("[GeminiConfig] Khởi tạo cấu hình Gemini AI thành công với model: " + modelId);
        }
    }

    public static boolean isConfigured() {
        return apiKey != null && !apiKey.trim().isEmpty();
    }

    public static String getApiKey() {
        return apiKey;
    }

    public static String getModelId() {
        return modelId;
    }
}
