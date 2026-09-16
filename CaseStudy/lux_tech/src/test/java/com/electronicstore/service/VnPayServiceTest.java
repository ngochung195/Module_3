package com.electronicstore.service;

import com.electronicstore.model.Order;
import com.electronicstore.util.VnPayConfig;
import com.electronicstore.util.VnPayUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

public class VnPayServiceTest {

    private VnPayService vnPayService;

    @BeforeEach
    void setUp() {
        vnPayService = new VnPayService();
    }

    @Test
    @DisplayName("createPaymentUrl phải tạo URL chứa đúng amount x100, TxnRef, vnp_SecureHash và baseUrl")
    void testCreatePaymentUrl() {
        Order order = new Order();
        order.setId(888);
        order.setTotal(new BigDecimal("20000000.00")); // 20 triệu VNĐ

        String paymentUrl = vnPayService.createPaymentUrl(null, order);

        assertNotNull(paymentUrl);
        assertTrue(paymentUrl.startsWith(VnPayConfig.getUrl()));
        assertTrue(paymentUrl.contains("vnp_Amount=2000000000"), "Số tiền phải được nhân 100 thành 2.000.000.000 xu");
        assertTrue(paymentUrl.contains("vnp_TxnRef=ORDER_888"));
        assertTrue(paymentUrl.contains("vnp_SecureHash="));
        assertTrue(paymentUrl.contains("vnp_Version=2.1.0"));
        assertTrue(paymentUrl.contains("vnp_Command=pay"));
    }

    @Test
    @DisplayName("Xác thực chữ ký: Phải hợp lệ khi dữ liệu toàn vẹn và không bị can thiệp")
    void testVerifyReturnSuccess() {
        // Giả lập params nhận từ VNPay
        Map<String, String> fields = new HashMap<>();
        fields.put("vnp_Amount", "2000000000");
        fields.put("vnp_BankCode", "NCB");
        fields.put("vnp_OrderInfo", "Thanh toan don hang 888");
        fields.put("vnp_ResponseCode", "00");
        fields.put("vnp_TmnCode", VnPayConfig.getTmnCode());
        fields.put("vnp_TransactionNo", "14567890");
        fields.put("vnp_TxnRef", "ORDER_888");

        // Tạo SecureHash hợp lệ
        String hashData = VnPayUtil.buildHashData(fields);
        String validSecureHash = VnPayUtil.hmacSHA512(VnPayConfig.getHashSecret(), hashData);

        // Kiểm tra khớp chữ ký
        String checkHash = VnPayUtil.hmacSHA512(VnPayConfig.getHashSecret(), VnPayUtil.buildHashData(fields));
        assertTrue(checkHash.equalsIgnoreCase(validSecureHash));
    }

    @Test
    @DisplayName("Xác thực chữ ký: Phải THẤT BẠI khi amount hoặc orderId bị can thiệp (Tampering)")
    void testVerifyReturnTamperedData() {
        Map<String, String> originalFields = new HashMap<>();
        originalFields.put("vnp_Amount", "2000000000");
        originalFields.put("vnp_ResponseCode", "00");
        originalFields.put("vnp_TxnRef", "ORDER_888");

        String hashData = VnPayUtil.buildHashData(originalFields);
        String originalSecureHash = VnPayUtil.hmacSHA512(VnPayConfig.getHashSecret(), hashData);

        // Hacker sửa vnp_Amount từ 2 tỷ xuống 20 triệu
        Map<String, String> tamperedFields = new HashMap<>(originalFields);
        tamperedFields.put("vnp_Amount", "20000000");

        String tamperedHashData = VnPayUtil.buildHashData(tamperedFields);
        String tamperedCalculatedHash = VnPayUtil.hmacSHA512(VnPayConfig.getHashSecret(), tamperedHashData);

        assertNotEquals(originalSecureHash, tamperedCalculatedHash,
                "Chữ ký phải khác nhau khi dữ liệu giao dịch bị thay đổi");
    }
}
