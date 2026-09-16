package com.electronicstore.service;

import com.electronicstore.util.GeminiConfig;
import com.google.genai.Client;
import com.google.genai.types.GenerateContentConfig;
import com.google.genai.types.GenerateContentResponse;

import com.google.genai.types.Content;
import com.google.genai.types.Part;

/**
 * GeminiService – Service tương tác trực tiếp với Google Gemini 3.5 Flash qua Google GenAI SDK.
 * Đảm bảo:
 *  - Không hard-code API Key
 *  - Tái sử dụng Client an toàn
 *  - Xử lý timeout và exception thân thiện, không crash server
 */
public class GeminiService {

    private static volatile GeminiService instance;
    private Client genAiClient;
    private String currentApiKey;

    public GeminiService() {
        initClient();
    }

    public static GeminiService getInstance() {
        if (instance == null) {
            synchronized (GeminiService.class) {
                if (instance == null) {
                    instance = new GeminiService();
                }
            }
        }
        return instance;
    }

    private synchronized void initClient() {
        String apiKey = GeminiConfig.getApiKey();
        if (apiKey != null && !apiKey.equals(currentApiKey)) {
            try {
                this.genAiClient = Client.builder().apiKey(apiKey).build();
                this.currentApiKey = apiKey;
                System.out.println("[GeminiService] Khởi tạo thành công Google GenAI Client.");
            } catch (Exception e) {
                System.err.println("[GeminiService] Lỗi khi tạo Google GenAI Client: " + e.getMessage());
                this.genAiClient = null;
            }
        } else if (apiKey == null) {
            this.genAiClient = null;
            this.currentApiKey = null;
        }
    }

    /**
     * Gửi yêu cầu sinh nội dung tới mô hình Gemini 3.5 Flash với System Instruction và User Prompt.
     * @param systemInstruction Chỉ thị hệ thống
     * @param fullPrompt Nội dung prompt kết hợp context và câu hỏi
     * @return Văn bản phản hồi từ Gemini
     * @throws Exception nếu có lỗi kết nối hoặc API chưa được cấu hình
     */
    public String generateContent(String systemInstruction, String fullPrompt) throws Exception {
        // Tải lại cấu hình nếu API key chưa có hoặc vừa được cập nhật
        if (!GeminiConfig.isConfigured() || genAiClient == null) {
            GeminiConfig.loadConfiguration();
            initClient();
        }

        if (!GeminiConfig.isConfigured() || genAiClient == null) {
            throw new IllegalStateException("Tính năng AI hiện chưa được cấu hình (thiếu GEMINI_API_KEY). Vui lòng cấu hình biến môi trường.");
        }

        String modelId = GeminiConfig.getModelId();

        try {
            GenerateContentConfig.Builder configBuilder = GenerateContentConfig.builder()
                    .temperature(0.7f);

            if (systemInstruction != null && !systemInstruction.trim().isEmpty()) {
                Content instructionContent = Content.builder()
                        .parts(Part.builder().text(systemInstruction.trim()).build())
                        .build();
                configBuilder.systemInstruction(instructionContent);
            }

            GenerateContentResponse response = genAiClient.models.generateContent(modelId, fullPrompt, configBuilder.build());

            if (response != null && response.text() != null) {
                return response.text().trim();
            } else {
                throw new RuntimeException("Phản hồi từ mô hình Gemini rỗng.");
            }
        } catch (Exception e) {
            System.err.println("[GeminiService] Lỗi khi gọi Gemini API (" + modelId + "): " + e.getMessage());
            throw e;
        }
    }
}
