package com.electronicstore.service;

import com.electronicstore.dao.DashboardDAO;
import com.electronicstore.model.Product;

import java.math.BigDecimal;
import java.util.List;

public class DashboardService {
    private final DashboardDAO dashboardDAO;

    public DashboardService() {
        this.dashboardDAO = new DashboardDAO();
    }

    public DashboardService(DashboardDAO dashboardDAO) {
        this.dashboardDAO = dashboardDAO;
    }

    public int getTotalProducts() {
        return dashboardDAO.countProducts();
    }

    public int getTotalCustomers() {
        return dashboardDAO.countCustomers();
    }

    public int getTotalOrders() {
        return dashboardDAO.countOrders();
    }

    public BigDecimal getTotalRevenue() {
        return dashboardDAO.calculateTotalRevenue();
    }

    public int getPendingOrders() {
        return dashboardDAO.countPendingOrders();
    }

    public int getOnlineOrders() {
        return dashboardDAO.countOnlineOrders();
    }

    public int getStaffOrders() {
        return dashboardDAO.countStaffOrders();
    }

    public BigDecimal getOnlineRevenue() {
        return dashboardDAO.calculateOnlineRevenue();
    }

    public List<Product> getBestSellingProducts(int limit) {
        if (limit <= 0) {
            limit = 5;
        }
        return dashboardDAO.findBestSellingProducts(limit);
    }
}
