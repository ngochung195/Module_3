package com.electronicstore.service;

import com.electronicstore.dao.CustomerDAO;
import com.electronicstore.dao.OrderDAO;
import com.electronicstore.dao.OrderDetailDAO;
import com.electronicstore.dao.ProductDAO;
import com.electronicstore.dao.UserDAO;
import com.electronicstore.model.Cart;
import com.electronicstore.model.CartItem;
import com.electronicstore.model.Customer;
import com.electronicstore.model.Order;
import com.electronicstore.model.OrderDetail;
import com.electronicstore.model.Product;
import com.electronicstore.model.User;
import com.electronicstore.util.DBConnection;
import com.electronicstore.util.ValidationUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderService {
    private final OrderDAO orderDAO;
    private final OrderDetailDAO orderDetailDAO;
    private final ProductDAO productDAO;
    private final CustomerDAO customerDAO;
    private final UserDAO userDAO;

    public OrderService() {
        this.orderDAO = new OrderDAO();
        this.orderDetailDAO = new OrderDetailDAO();
        this.productDAO = new ProductDAO();
        this.customerDAO = new CustomerDAO();
        this.userDAO = new UserDAO();
    }

    public OrderService(OrderDAO orderDAO, OrderDetailDAO orderDetailDAO) {
        this.orderDAO = orderDAO;
        this.orderDetailDAO = orderDetailDAO;
        this.productDAO = new ProductDAO();
        this.customerDAO = new CustomerDAO();
        this.userDAO = new UserDAO();
    }

    public OrderService(OrderDAO orderDAO, OrderDetailDAO orderDetailDAO, ProductDAO productDAO,
                        CustomerDAO customerDAO, UserDAO userDAO) {
        this.orderDAO = orderDAO;
        this.orderDetailDAO = orderDetailDAO;
        this.productDAO = productDAO;
        this.customerDAO = customerDAO;
        this.userDAO = userDAO;
    }

    /**
     * Lấy tất cả đơn hàng – dùng cho ADMIN/STAFF.
     */
    public List<Order> findAll() {
        return orderDAO.findAll();
    }

    /**
     * Tìm đơn hàng theo ID (chưa kèm details).
     */
    public Order findById(int id) {
        return orderDAO.findById(id);
    }

    /**
     * Tìm đơn hàng theo ID kèm theo danh sách OrderDetail.
     */
    public Order findByIdWithDetails(int id) {
        Order order = orderDAO.findById(id);
        if (order != null) {
            List<OrderDetail> details = orderDetailDAO.findByOrderId(id);
            order.setOrderDetails(details);
        }
        return order;
    }

    /**
     * Lấy tất cả đơn hàng của một Customer cụ thể.
     * Dùng SQL WHERE customer_id = ? – không lấy hết rồi filter Java.
     */
    public List<Order> findByCustomerId(int customerId) {
        return orderDAO.findByCustomerId(customerId);
    }

    /**
     * Lấy đơn hàng của Customer kèm OrderDetail.
     * Kiểm tra ownership: chỉ trả về nếu order thuộc về customerId.
     * @return Order nếu hợp lệ, null nếu không tìm thấy hoặc không phải của customer này
     */
    public Order findByIdWithDetailsForCustomer(int orderId, int customerId) {
        Order order = orderDAO.findById(orderId);
        if (order == null) {
            return null;
        }
        // Kiểm tra ownership – bảo mật quan trọng
        if (order.getCustomerId() != customerId) {
            return null; // 403: Customer không được xem order của người khác
        }
        List<OrderDetail> details = orderDetailDAO.findByOrderId(orderId);
        order.setOrderDetails(details);
        return order;
    }

    /**
     * Tìm kiếm đơn hàng (ADMIN/STAFF) theo keyword và status.
     */
    public List<Order> search(String keyword, String status) {
        return orderDAO.search(keyword, status);
    }

    /**
     * Tìm kiếm đơn hàng (ADMIN/STAFF) theo keyword, status và source (ONLINE / STAFF).
     */
    public List<Order> search(String keyword, String status, String source) {
        return orderDAO.search(keyword, status, source);
    }

    /**
     * Cập nhật trạng thái đơn hàng (ADMIN/STAFF).
     * @return thông báo lỗi nếu không thành công, null nếu thành công
     */
    public String updateStatus(int orderId, String newStatus) {
        Order order = orderDAO.findById(orderId);
        if (order == null) {
            return "Đơn hàng không tồn tại.";
        }

        // Validate transition
        String currentStatus = order.getStatus();
        if ("CANCELLED".equalsIgnoreCase(currentStatus) || "COMPLETED".equalsIgnoreCase(currentStatus)) {
            return "Không thể thay đổi trạng thái của đơn hàng đã " +
                   ("CANCELLED".equalsIgnoreCase(currentStatus) ? "hủy" : "hoàn thành") + ".";
        }

        boolean success = orderDAO.updateStatus(orderId, newStatus.toUpperCase());
        return success ? null : "Lỗi hệ thống! Không thể cập nhật trạng thái đơn hàng.";
    }

    /**
     * Đánh dấu đơn hàng là đã thanh toán thành công qua VNPay (Idempotent).
     * @return true nếu cập nhật thành công hoặc đơn hàng đã ở trạng thái PAID từ trước
     */
    public boolean markOrderAsPaid(int orderId) {
        Order order = orderDAO.findById(orderId);
        if (order == null) {
            return false;
        }

        // Idempotency: nếu đơn hàng đã được đánh dấu PAID thì không làm gì thêm
        if ("PAID".equalsIgnoreCase(order.getStatus()) && "PAID".equalsIgnoreCase(order.getPaymentStatus())) {
            return true;
        }

        return orderDAO.updatePaymentSuccess(orderId, "PAID", "PAID");
    }

    /**
     * Quy trình Checkout an toàn đa bảng với Database Transaction (Phase 10 & 10.1).
     * Mặc định phương thức COD.
     */
    public Order processCheckout(User user, Customer customerInput, Cart cart) throws Exception {
        return processCheckout(user, customerInput, cart, "COD");
    }

    /**
     * Quy trình Checkout an toàn đa bảng với Database Transaction hỗ trợ phương thức thanh toán.
     * - Validate cart: không rỗng
     * - Mở JDBC Connection với setAutoCommit(false)
     * - Re-check từng sản phẩm: kiểm tra tồn tại, lấy giá chuẩn DB, kiểm tra tồn kho DB
     * - Tính toán lại tổng tiền từ giá DB (không tin tưởng giá session)
     * - Đồng bộ Customer (tạo mới nếu chưa có, hoặc cập nhật thông tin nhận hàng)
     * - Gán customer_id cho User nếu cần
     * - Tạo Order với trạng thái PENDING và payment_method tương ứng (COD hoặc VNPAY)
     * - Lưu từng OrderDetail và trừ tồn kho (decreaseStock)
     * - Commit transaction
     * - Rollback khi gặp lỗi
     * @return Order đã tạo thành công kèm OrderDetails
     * @throws Exception nếu có bất kỳ lỗi xác thực hoặc lỗi hệ thống DB
     */
    public Order processCheckout(User user, Customer customerInput, Cart cart, String paymentMethod) throws Exception {
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            throw new IllegalArgumentException("Giỏ hàng của bạn đang trống. Vui lòng chọn sản phẩm trước khi thanh toán.");
        }

        if (customerInput == null) {
            throw new IllegalArgumentException("Thông tin khách hàng không hợp lệ.");
        }

        if (ValidationUtil.isEmpty(customerInput.getName())) {
            throw new IllegalArgumentException("Họ và tên người nhận không được để trống.");
        }
        if (customerInput.getName().trim().length() < 2) {
            throw new IllegalArgumentException("Họ và tên người nhận phải có ít nhất 2 ký tự.");
        }

        if (ValidationUtil.isEmpty(customerInput.getPhone())) {
            throw new IllegalArgumentException("Số điện thoại nhận hàng không được để trống.");
        }
        if (!ValidationUtil.isValidPhone(customerInput.getPhone())) {
            throw new IllegalArgumentException("Số điện thoại không hợp lệ (ví dụ: 0912345678 hoặc +84912345678).");
        }

        if (ValidationUtil.isEmpty(customerInput.getAddress())) {
            throw new IllegalArgumentException("Địa chỉ giao hàng không được để trống.");
        }
        if (customerInput.getAddress().trim().length() < 5) {
            throw new IllegalArgumentException("Địa chỉ giao hàng phải có ít nhất 5 ký tự.");
        }

        if (!ValidationUtil.isEmpty(customerInput.getEmail()) && !ValidationUtil.isValidEmail(customerInput.getEmail())) {
            throw new IllegalArgumentException("Địa chỉ email không đúng định dạng.");
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. RE-CHECK SẢN PHẨM, GIÁ & TỒN KHO TRỰC TIẾP TỪ DATABASE
            BigDecimal totalAmount = BigDecimal.ZERO;
            List<OrderDetail> detailsToCreate = new ArrayList<>();

            for (CartItem item : cart.getItems()) {
                Product dbProduct = productDAO.findById(conn, item.getProductId());
                if (dbProduct == null) {
                    throw new IllegalStateException("Sản phẩm '" + item.getName() + "' không tồn tại hoặc đã ngừng kinh doanh.");
                }

                // Re-check tồn kho
                if (dbProduct.getQuantity() < item.getQuantity()) {
                    throw new IllegalStateException("Sản phẩm '" + dbProduct.getName() + "' hiện chỉ còn "
                            + dbProduct.getQuantity() + " sản phẩm trong kho (bạn đang đặt " + item.getQuantity() + "). Vui lòng điều chỉnh lại số lượng.");
                }

                // Re-check giá: Lấy giá chính xác từ database
                BigDecimal authoritativePrice = dbProduct.getPrice();
                BigDecimal lineTotal = authoritativePrice.multiply(BigDecimal.valueOf(item.getQuantity()));
                totalAmount = totalAmount.add(lineTotal);

                OrderDetail detail = new OrderDetail();
                detail.setProductId(dbProduct.getId());
                detail.setProductName(dbProduct.getName());
                detail.setQuantity(item.getQuantity());
                detail.setPrice(authoritativePrice);
                detailsToCreate.add(detail);
            }

            // 2. XỬ LÝ KHÁCH HÀNG (CUSTOMER & USER)
            int customerId = (user != null) ? user.getCustomerId() : 0;
            if (customerId <= 0) {
                // Tạo mới Customer
                boolean custSaved = customerDAO.saveWithConnection(conn, customerInput);
                if (!custSaved || customerInput.getId() <= 0) {
                    throw new SQLException("Không thể lưu thông tin khách hàng mới.");
                }
                customerId = customerInput.getId();
                if (user != null) {
                    user.setCustomerId(customerId);
                    userDAO.updateCustomerId(conn, user.getId(), customerId);
                }
            } else {
                // Đã có customer_id -> cập nhật thông tin giao nhận mới nhất
                customerInput.setId(customerId);
                customerDAO.updateWithConnection(conn, customerInput);
            }

            // 3. TẠO ORDER (TRẠNG THÁI PENDING)
            Order order = new Order();
            order.setCustomerId(customerId);
            order.setCustomerName(customerInput.getName());
            order.setTotal(totalAmount);
            order.setStatus("PENDING");
            String validMethod = "VNPAY".equalsIgnoreCase(paymentMethod) ? "VNPAY" : "COD";
            order.setPaymentMethod(validMethod);
            order.setPaymentStatus("UNPAID");
            order.setSource("ONLINE");

            boolean orderSaved = orderDAO.save(conn, order);
            if (!orderSaved || order.getId() <= 0) {
                throw new SQLException("Không thể khởi tạo đơn hàng.");
            }

            // 4. TẠO ORDER_DETAILS VÀ TRỪ TỒN KHO SẢN PHẨM
            for (OrderDetail detail : detailsToCreate) {
                detail.setOrderId(order.getId());
                boolean detailSaved = orderDetailDAO.save(conn, detail);
                if (!detailSaved) {
                    throw new SQLException("Không thể lưu chi tiết đơn hàng cho sản phẩm ID " + detail.getProductId());
                }

                // Trừ tồn kho có kiểm tra quantity >= orderedQuantity
                boolean stockDecreased = productDAO.decreaseStock(conn, detail.getProductId(), detail.getQuantity());
                if (!stockDecreased) {
                    throw new IllegalStateException("Sản phẩm '" + detail.getProductName() + "' không đủ tồn kho để hoàn tất đơn hàng.");
                }
            }

            order.setOrderDetails(detailsToCreate);

            // 5. COMMIT TRANSACTION
            conn.commit();
            return order;

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Lỗi rollback transaction: " + ex.getMessage());
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Lỗi đóng connection: " + e.getMessage());
                }
            }
        }
    }

    /**
     * Hủy đơn hàng và hoàn trả tồn kho sản phẩm nguyên tử với Database Transaction (Phase 11).
     * - Kiểm tra đơn hàng tồn tại
     * - Kiểm tra quyền sở hữu (nếu !isAdminOrStaff, bắt buộc order.getCustomerId() == customerId)
     * - Kiểm tra trạng thái: chỉ cho phép hủy khi đang PENDING
     * - Bắt đầu Transaction:
     *     + Cập nhật status sang CANCELLED
     *     + Đọc order_details và gọi productDAO.increaseStock cho từng sản phẩm
     *     + Commit
     *     + Rollback nếu có lỗi
     * @return null nếu thành công, chuỗi thông báo lỗi nếu thất bại
     */
    public String cancelOrderWithStockRestore(int orderId, int customerId, boolean isAdminOrStaff) {
        Order order = orderDAO.findById(orderId);
        if (order == null) {
            return "Đơn hàng không tồn tại.";
        }

        // Kiểm tra quyền sở hữu đơn hàng – Bảo mật tối quan trọng
        if (!isAdminOrStaff && order.getCustomerId() != customerId) {
            return "Bạn không có quyền thao tác trên đơn hàng này.";
        }

        // Kiểm tra trạng thái đơn hàng
        String currentStatus = order.getStatus();
        if (!isAdminOrStaff) {
            if (!"PENDING".equalsIgnoreCase(currentStatus)) {
                return "Chỉ có thể hủy đơn hàng đang ở trạng thái Chờ xác nhận (PENDING). Đơn hàng hiện tại đang " + currentStatus + ".";
            }
        } else {
            if ("COMPLETED".equalsIgnoreCase(currentStatus) || "CANCELLED".equalsIgnoreCase(currentStatus)) {
                return "Không thể hủy đơn hàng đã hoàn thành hoặc đã hủy.";
            }
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Cập nhật trạng thái đơn hàng sang CANCELLED
            boolean statusUpdated = orderDAO.updateStatus(conn, orderId, "CANCELLED");
            if (!statusUpdated) {
                throw new SQLException("Không thể cập nhật trạng thái đơn hàng sang CANCELLED.");
            }

            // 2. Lấy danh sách chi tiết đơn hàng để hoàn trả tồn kho
            List<OrderDetail> details = orderDetailDAO.findByOrderId(orderId);
            if (details != null) {
                for (OrderDetail detail : details) {
                    boolean restored = productDAO.increaseStock(conn, detail.getProductId(), detail.getQuantity());
                    if (!restored) {
                        throw new SQLException("Lỗi hoàn trả tồn kho cho sản phẩm ID " + detail.getProductId());
                    }
                }
            }

            // 3. Commit transaction
            conn.commit();
            return null; // Thành công

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Lỗi rollback khi hủy đơn: " + ex.getMessage());
                }
            }
            return "Lỗi hệ thống khi hủy đơn hàng: " + e.getMessage();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Lỗi đóng connection: " + e.getMessage());
                }
            }
        }
    }

    /**
     * Tạo đơn hàng tại quầy (STAFF/ADMIN) với source = 'STAFF' (Phase 13).
     * Trừ tồn kho và lưu đơn hàng trong Database Transaction.
     */
    public Order createStaffOrder(int customerId, int productId, int quantity, String paymentMethod) throws Exception {
        if (customerId <= 0) throw new IllegalArgumentException("Vui lòng chọn khách hàng.");
        if (productId <= 0) throw new IllegalArgumentException("Vui lòng chọn sản phẩm.");
        if (quantity <= 0) throw new IllegalArgumentException("Số lượng sản phẩm phải lớn hơn 0.");

        Product product = productDAO.findById(productId);
        if (product == null) throw new IllegalArgumentException("Sản phẩm không tồn tại.");
        if (product.getQuantity() < quantity) {
            throw new IllegalStateException("Sản phẩm '" + product.getName() + "' chỉ còn tồn kho " + product.getQuantity() + " chiếc.");
        }

        Customer customer = customerDAO.findById(customerId);
        if (customer == null) throw new IllegalArgumentException("Khách hàng không tồn tại.");

        BigDecimal price = product.getPrice();
        BigDecimal total = price.multiply(BigDecimal.valueOf(quantity));

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            Order order = new Order();
            order.setCustomerId(customerId);
            order.setCustomerName(customer.getName());
            order.setTotal(total);
            order.setStatus("COMPLETED");
            order.setPaymentMethod(paymentMethod != null ? paymentMethod : "COD");
            order.setPaymentStatus("PAID");
            order.setSource("STAFF");

            boolean saved = orderDAO.save(conn, order);
            if (!saved || order.getId() <= 0) throw new SQLException("Không thể lưu đơn hàng.");

            OrderDetail detail = new OrderDetail();
            detail.setOrderId(order.getId());
            detail.setProductId(productId);
            detail.setProductName(product.getName());
            detail.setPrice(price);
            detail.setQuantity(quantity);

            boolean detailSaved = orderDetailDAO.save(conn, detail);
            if (!detailSaved) throw new SQLException("Không thể lưu chi tiết đơn hàng.");

            boolean stockDecreased = productDAO.decreaseStock(conn, productId, quantity);
            if (!stockDecreased) throw new IllegalStateException("Không thể trừ tồn kho sản phẩm.");

            conn.commit();
            return order;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) {}
            }
        }
    }
}
