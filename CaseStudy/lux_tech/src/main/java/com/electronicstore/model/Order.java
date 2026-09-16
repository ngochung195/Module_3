package com.electronicstore.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int customerId;
    private String customerName; // Hiển thị UI
    private Timestamp orderDate;
    private BigDecimal total;
    private String status; // PENDING, PAID, CONFIRMED, COMPLETED, CANCELLED
    private String paymentMethod; // COD, VNPAY
    private String paymentStatus; // UNPAID, PAID
    private String source = "ONLINE"; // ONLINE, STAFF (Phase 13)

    private List<OrderDetail> orderDetails = new ArrayList<>();

    public Order() {
    }

    public Order(int id, int customerId, Timestamp orderDate, BigDecimal total, String status) {
        this.id = id;
        this.customerId = customerId;
        this.orderDate = orderDate;
        this.total = total;
        this.status = status;
        this.source = "ONLINE";
    }

    public Order(int id, int customerId, Timestamp orderDate, BigDecimal total, String status, String paymentMethod, String paymentStatus) {
        this.id = id;
        this.customerId = customerId;
        this.orderDate = orderDate;
        this.total = total;
        this.status = status;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.source = "ONLINE";
    }

    public Order(int id, int customerId, Timestamp orderDate, BigDecimal total, String status, String paymentMethod, String paymentStatus, String source) {
        this.id = id;
        this.customerId = customerId;
        this.orderDate = orderDate;
        this.total = total;
        this.status = status;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.source = (source != null && !source.trim().isEmpty()) ? source : "ONLINE";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getSource() {
        return source != null ? source : "ONLINE";
    }

    public void setSource(String source) {
        this.source = (source != null && !source.trim().isEmpty()) ? source : "ONLINE";
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", customerId=" + customerId +
                ", customerName='" + customerName + '\'' +
                ", orderDate=" + orderDate +
                ", total=" + total +
                ", status='" + status + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", source='" + source + '\'' +
                '}';
    }
}
