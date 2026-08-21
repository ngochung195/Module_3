package com.codegym;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ConverterServlet", value = "/convert")
public class ConverterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            float rate = Float.parseFloat(request.getParameter("rate"));
            float usd = Float.parseFloat(request.getParameter("usd"));

            float vnd = rate * usd;

            PrintWriter out = response.getWriter();
            out.println("<html>");
            out.println("<head><title>Kết quả chuyển đổi</title></head>");
            out.println("<body>");
            out.println("<h2>Kết quả chuyển đổi (Currency Converter Result)</h2>");
            out.println("<p>Tỉ giá (Rate): " + rate + "</p>");
            out.println("<p>Lượng USD: " + usd + "</p>");
            out.println("<p><strong>Số tiền VNĐ: " + vnd + "</strong></p>");
            out.println("<a href=\"index.jsp\">Quay lại</a>");
            out.println("</body>");
            out.println("</html>");
        } catch (NumberFormatException e) {
            PrintWriter out = response.getWriter();
            out.println(
                    "<html><body><h2>Lỗi: Dữ liệu nhập vào không hợp lệ.</h2><a href=\"index.jsp\">Quay lại</a></body></html>");
        }
    }
}
