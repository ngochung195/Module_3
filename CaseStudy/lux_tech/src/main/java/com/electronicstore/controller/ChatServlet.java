package com.electronicstore.controller;

import com.electronicstore.model.ChatRequest;
import com.electronicstore.model.ChatResponse;
import com.electronicstore.service.AIChatService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * ChatServlet – Controller tiếp nhận và xử lý các yêu cầu hội thoại AI từ người dùng.
 * Endpoint: POST /chat hoặc POST /api/chat
 * Request: JSON { "message": "...", "currentProductId": 1, "history": [...] }
 * Response: JSON { "success": true, "message": "...", "timestamp": 12345678 }
 */
@WebServlet(name = "ChatServlet", urlPatterns = {"/chat", "/api/chat"})
public class ChatServlet extends HttpServlet {

    private AIChatService aiChatService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        this.aiChatService = new AIChatService();
        this.gson = new GsonBuilder().create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            ChatResponse res = ChatResponse.ok("LuxTech AI Chat Service is active.");
            out.print(gson.toJson(res));
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        ChatResponse chatResponse;

        try {
            // Đọc payload JSON từ request body
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }

            String body = sb.toString().trim();
            ChatRequest chatRequest = null;

            if (!body.isEmpty()) {
                try {
                    chatRequest = gson.fromJson(body, ChatRequest.class);
                } catch (Exception e) {
                    chatRequest = null;
                }
            }

            // Fallback nếu request gửi dạng standard form parameter
            if (chatRequest == null || chatRequest.getMessage() == null) {
                String messageParam = request.getParameter("message");
                String productIdParam = request.getParameter("productId");
                if (messageParam != null && !messageParam.trim().isEmpty()) {
                    chatRequest = new ChatRequest(messageParam);
                    if (productIdParam != null) {
                        try {
                            chatRequest.setCurrentProductId(Integer.parseInt(productIdParam.trim()));
                        } catch (NumberFormatException ignored) {
                        }
                    }
                }
            }

            if (chatRequest == null || chatRequest.getMessage() == null || chatRequest.getMessage().trim().isEmpty()) {
                chatResponse = ChatResponse.error("Nội dung câu hỏi không được để trống.");
            } else {
                chatResponse = aiChatService.processChat(chatRequest);
            }

        } catch (Exception e) {
            System.err.println("[ChatServlet] Lỗi ngoại lệ khi xử lý request: " + e.getMessage());
            chatResponse = ChatResponse.error("Xin lỗi, hệ thống AI tạm thời gặp sự cố. Vui lòng thử lại sau.");
        }

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(chatResponse));
            out.flush();
        }
    }
}
