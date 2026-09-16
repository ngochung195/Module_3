package com.electronicstore.controller;

import com.electronicstore.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

/**
 * HealthCheckServlet – Endpoint kiểm tra trạng thái hoạt động (Liveness / Readiness probe) cho Render.
 * Không yêu cầu authentication và không để lộ thông tin nhạy cảm.
 * GET /health
 */
@WebServlet(name = "HealthCheckServlet", urlPatterns = {"/health", "/api/health"})
public class HealthCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        boolean dbConnected = false;
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                dbConnected = true;
            }
        } catch (Exception ignored) {
            dbConnected = false;
        }

        if (dbConnected) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            // Vẫn giữ HTTP 200 cho liveness probe hoặc 503 nếu muốn fail probe
            response.setStatus(HttpServletResponse.SC_OK);
        }

        try (PrintWriter out = response.getWriter()) {
            out.print("{\"status\":\"UP\",\"database\":\"" + (dbConnected ? "UP" : "DOWN") + "\"}");
            out.flush();
        }
    }
}

