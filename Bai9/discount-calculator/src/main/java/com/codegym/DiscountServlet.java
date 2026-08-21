package com.codegym;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DiscountServlet", value = "/display-discount")
public class DiscountServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        double discount = Double.parseDouble(request.getParameter("discount"));

        double discountAmount = price * discount * 0.01;
        double discountPrice = price - discountAmount;

        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Discount Result</title>");
            out.println("<style>body { font-family: Arial, sans-serif; margin: 20px; } p { margin: 10px 0; }</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h2>Product Discount Result</h2>");
            out.println("<p><strong>Product Description:</strong> " + description + "</p>");
            out.println("<p><strong>List Price:</strong> $" + String.format("%.2f", price) + "</p>");
            out.println("<p><strong>Discount Percent:</strong> " + String.format("%.2f", discount) + "%</p>");
            out.println("<p><strong>Discount Amount:</strong> $" + String.format("%.2f", discountAmount) + "</p>");
            out.println("<p><strong>Discount Price:</strong> $" + String.format("%.2f", discountPrice) + "</p>");
            out.println("<br/>");
            out.println("<a href=\"index.jsp\">Back to Calculator</a>");
            out.println("</body>");
            out.println("</html>");
        }
    }
}
