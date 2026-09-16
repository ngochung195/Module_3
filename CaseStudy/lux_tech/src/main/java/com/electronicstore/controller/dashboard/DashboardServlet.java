package com.electronicstore.controller.dashboard;

import com.electronicstore.model.Product;
import com.electronicstore.service.DashboardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {
    private DashboardService dashboardService;

    @Override
    public void init() throws ServletException {
        this.dashboardService = new DashboardService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int totalProducts = dashboardService.getTotalProducts();
        int totalCustomers = dashboardService.getTotalCustomers();
        int totalOrders = dashboardService.getTotalOrders();
        BigDecimal totalRevenue = dashboardService.getTotalRevenue();
        int pendingOrders = dashboardService.getPendingOrders();
        int onlineOrders = dashboardService.getOnlineOrders();
        int staffOrders = dashboardService.getStaffOrders();
        BigDecimal onlineRevenue = dashboardService.getOnlineRevenue();
        List<Product> topProducts = dashboardService.getBestSellingProducts(5);

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("onlineOrders", onlineOrders);
        request.setAttribute("staffOrders", staffOrders);
        request.setAttribute("onlineRevenue", onlineRevenue);
        request.setAttribute("topProducts", topProducts);

        request.getRequestDispatcher("/WEB-INF/views/dashboard/index.jsp").forward(request, response);
    }
}
