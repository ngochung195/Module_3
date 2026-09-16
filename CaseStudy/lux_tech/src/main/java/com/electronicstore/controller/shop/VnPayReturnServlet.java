package com.electronicstore.controller.shop;

import com.electronicstore.model.Customer;
import com.electronicstore.model.Order;
import com.electronicstore.service.CustomerService;
import com.electronicstore.service.OrderService;
import com.electronicstore.service.VnPayService;
import com.electronicstore.service.VnPayService.VnPayResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

/**
 * VnPayReturnServlet – Tiếp nhận kết quả thanh toán từ VNPay qua Return URL (Phase 10.1).
 * GET /vnpay-return
 * - Xác thực chữ ký số HMAC-SHA512 (Verify Signature)
 * - Kiểm tra tính toàn vẹn của đơn hàng và số tiền
 * - Cập nhật trạng thái đơn hàng (PAID) nếu thành công (đảm bảo tính Idempotent)
 * - Chuyển tiếp tới trang kết quả thanh toán payment-result.jsp
 */
@WebServlet(name = "VnPayReturnServlet", urlPatterns = {"/vnpay-return"})
public class VnPayReturnServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private VnPayService vnPayService;
    private OrderService orderService;
    private CustomerService customerService;

    @Override
    public void init() throws ServletException {
        this.vnPayService = new VnPayService();
        this.orderService = new OrderService();
        this.customerService = new CustomerService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Xác thực chữ ký và trích xuất dữ liệu trả về từ VNPay
        VnPayResult result = vnPayService.verifyReturn(request);

        // Trường hợp 1: Chữ ký không hợp lệ (Signature Invalid / Giả mạo dữ liệu)
        if (!result.isValidSignature()) {
            request.setAttribute("paymentSuccess", false);
            request.setAttribute("errorTitle", "Chữ Ký Không Hợp Lệ");
            request.setAttribute("errorMessage", "Chữ ký bảo mật giao dịch không hợp lệ (PAYMENT_INVALID). Hệ thống từ chối ghi nhận thanh toán.");
            request.getRequestDispatcher("/WEB-INF/views/shop/payment-result.jsp").forward(request, response);
            return;
        }

        int orderId = result.getOrderId();
        if (orderId <= 0) {
            request.setAttribute("paymentSuccess", false);
            request.setAttribute("errorTitle", "Giao Dịch Không Hợp Lệ");
            request.setAttribute("errorMessage", "Không xác định được mã đơn hàng từ giao dịch VNPay.");
            request.getRequestDispatcher("/WEB-INF/views/shop/payment-result.jsp").forward(request, response);
            return;
        }

        // 2. Tìm kiếm đơn hàng trong cơ sở dữ liệu
        Order order = orderService.findByIdWithDetails(orderId);
        if (order == null) {
            request.setAttribute("paymentSuccess", false);
            request.setAttribute("errorTitle", "Đơn Hàng Không Tồn Tại");
            request.setAttribute("errorMessage", "Không tìm thấy thông tin đơn hàng #" + orderId + " trong hệ thống.");
            request.getRequestDispatcher("/WEB-INF/views/shop/payment-result.jsp").forward(request, response);
            return;
        }

        // 3. Kiểm tra tính toàn vẹn số tiền thanh toán (Amount Tampering)
        if (result.getAmount() != null && order.getTotal() != null) {
            BigDecimal diff = order.getTotal().subtract(result.getAmount()).abs();
            // Cho phép sai số nhỏ do làm tròn nếu có (< 1 đồng)
            if (diff.compareTo(BigDecimal.ONE) > 0) {
                request.setAttribute("paymentSuccess", false);
                request.setAttribute("order", order);
                request.setAttribute("errorTitle", "Số Tiền Không Khớp");
                request.setAttribute("errorMessage", "Số tiền thanh toán thực tế không khớp với tổng tiền đơn hàng trong hệ thống.");
                request.getRequestDispatcher("/WEB-INF/views/shop/payment-result.jsp").forward(request, response);
                return;
            }
        }

        Customer customer = customerService.findById(order.getCustomerId());
        request.setAttribute("order", order);
        request.setAttribute("customer", customer);
        request.setAttribute("vnPayResult", result);

        // 4. Kiểm tra mã phản hồi (ResponseCode)
        if (result.isSuccess()) {
            // Thanh toán thành công: Cập nhật đơn hàng sang PAID (Idempotent)
            orderService.markOrderAsPaid(orderId);

            // Nạp lại dữ liệu đơn hàng mới nhất sau khi cập nhật
            Order updatedOrder = orderService.findByIdWithDetails(orderId);
            request.setAttribute("order", updatedOrder);
            request.setAttribute("paymentSuccess", true);
        } else {
            // Thanh toán thất bại hoặc khách hàng hủy thanh toán
            // Giữ nguyên trạng thái PENDING của đơn hàng để khách có thể thử lại
            request.setAttribute("paymentSuccess", false);
            request.setAttribute("errorTitle", "Thanh Toán Thất Bại");
            request.setAttribute("errorMessage", result.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/shop/payment-result.jsp").forward(request, response);
    }
}
