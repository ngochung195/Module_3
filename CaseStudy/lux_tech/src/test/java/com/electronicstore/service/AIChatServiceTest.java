package com.electronicstore.service;

import com.electronicstore.model.ChatRequest;
import com.electronicstore.model.ChatResponse;
import com.electronicstore.util.GeminiConfig;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class AIChatServiceTest {

    private AIChatService aiChatService;

    @BeforeEach
    void setUp() {
        aiChatService = new AIChatService();
    }

    @Test
    @DisplayName("Nội dung tin nhắn null hoặc rỗng phải trả về lỗi hợp lệ")
    void testProcessChat_EmptyMessage() {
        ChatRequest req1 = new ChatRequest(null);
        ChatResponse res1 = aiChatService.processChat(req1);
        assertNotNull(res1);
        assertFalse(res1.isSuccess());
        assertTrue(res1.getMessage().contains("không được để trống") || res1.getMessage().contains("Vui lòng"));

        ChatRequest req2 = new ChatRequest("   ");
        ChatResponse res2 = aiChatService.processChat(req2);
        assertNotNull(res2);
        assertFalse(res2.isSuccess());
    }

    @Test
    @DisplayName("Nội dung tin nhắn vượt quá giới hạn phải trả về lỗi giới hạn ký tự")
    void testProcessChat_MessageTooLong() {
        StringBuilder longMsg = new StringBuilder();
        for (int i = 0; i < GeminiConfig.MAX_MESSAGE_LENGTH + 10; i++) {
            longMsg.append("a");
        }

        ChatRequest req = new ChatRequest(longMsg.toString());
        ChatResponse res = aiChatService.processChat(req);
        assertNotNull(res);
        assertFalse(res.isSuccess());
        assertTrue(res.getMessage().contains("quá dài") || res.getMessage().contains("tối đa"));
    }

    @Test
    @DisplayName("Khi chưa cấu hình API Key hệ thống trả thông báo thân thiện và không crash")
    void testProcessChat_WithoutApiKey_ShouldNotCrash() {
        ChatRequest req = new ChatRequest("Laptop nào phù hợp cho sinh viên?");
        ChatResponse res = aiChatService.processChat(req);
        assertNotNull(res);
        assertNotNull(res.getMessage());
        // Không được lộ exception hay null pointer
        assertFalse(res.getMessage().contains("NullPointerException"));
        assertFalse(res.getMessage().contains("Exception in thread"));
    }
}
