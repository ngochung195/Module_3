package com.electronicstore.controller.auth;

import com.electronicstore.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
    }

    /**
     * GET /register – Hiển thị form đăng ký
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã đăng nhập, redirect
        if (request.getSession(false) != null
                && request.getSession(false).getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    /**
     * POST /register – Xử lý đăng ký Customer mới.
     * Tạo đồng thời Customer + User trong 1 transaction.
     * POST → Redirect → GET (PRG pattern).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name      = request.getParameter("name");
        String phone     = request.getParameter("phone");
        String email     = request.getParameter("email");
        String address   = request.getParameter("address");
        String username  = request.getParameter("username");
        String password  = request.getParameter("password");
        String password2 = request.getParameter("password2");

        // Kiểm tra confirm password
        if (password == null || !password.equals(password2)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("address", address);
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // Gọi service – transaction bên trong
        String error = userService.registerCustomer(name, phone, email, address, username, password);

        if (error != null) {
            // Có lỗi – giữ lại giá trị nhập
            request.setAttribute("errorMessage", error);
            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("address", address);
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        } else {
            // Thành công – PRG: redirect sang login với thông báo
            response.sendRedirect(request.getContextPath() + "/login?registered=true");
        }
    }
}
