package com.codegym;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "DictionaryServlet", value = "/translate")
public class DictionaryServlet extends HttpServlet {
    private Map<String, String> dictionary = new HashMap<>();

    @Override
    public void init() {
        // Khởi tạo danh sách từ vựng
        dictionary.put("hello", "Xin chào");
        dictionary.put("book", "Quyển sách");
        dictionary.put("computer", "Máy tính");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Thiết lập encoding để hiển thị tiếng Việt chính xác
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String searchWord = request.getParameter("word");
        PrintWriter writer = response.getWriter();

        writer.println("<html>");
        writer.println("<head><title>Kết quả tra từ</title></head>");
        writer.println("<body>");

        if (searchWord != null && !searchWord.trim().isEmpty()) {
            searchWord = searchWord.trim();
            String result = dictionary.get(searchWord.toLowerCase());

            if (result != null) {
                writer.println("<h2>Từ khóa: " + searchWord + "</h2>");
                writer.println("<h2>Nghĩa: " + result + "</h2>");
            } else {
                writer.println("<h2>Không tìm thấy từ: " + searchWord + "</h2>");
            }
        }

        writer.println("<br/>");
        writer.println("<a href='" + request.getContextPath() + "/'>Quay lại trang chủ</a>");
        writer.println("</body>");
        writer.println("</html>");
    }
}
