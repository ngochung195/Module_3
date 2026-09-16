package com.electronicstore.filter;

import com.electronicstore.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
    // Back Office
    "/dashboard/*", "/dashboard",
    "/products/*", "/products",
    "/categories/*", "/categories",
    "/customers/*", "/customers",
    "/orders/*", "/orders",
    "/users/*", "/users",
    // Customer Online Shop (yêu cầu đăng nhập)
    "/cart", "/cart/*",
    "/checkout", "/checkout/*",
    "/my-orders", "/my-orders/*",
    "/profile", "/profile/*"
    // Lưu ý: /shop, /shop/products, /shop/product là public – không yêu cầu đăng nhập
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // Nếu chưa đăng nhập -> Chuyển hướng tới trang /login
        if (currentUser == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Đã đăng nhập -> Cho phép tiếp tục luồng xử lý
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy filter
    }
}
