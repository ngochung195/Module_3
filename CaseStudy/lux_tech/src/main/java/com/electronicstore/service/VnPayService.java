package com.electronicstore.service;

import com.electronicstore.model.Order;
import com.electronicstore.util.VnPayConfig;
import com.electronicstore.util.VnPayUtil;
import jakarta.servlet.http.HttpServletRequest;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * VnPayService – Xử lý logic nghiệp vụ cổng thanh toán VNPay Sandbox.
 * - Khởi tạo Payment URL với chữ ký HMAC-SHA512
 * - Xác thực kết quả giao dịch trả về từ VNPay (verify SecureHash)
 * - Kiểm tra tính toàn vẹn dữ liệu (Amount, OrderId)
 */
public class VnPayService {

    /**
     * Lớp đóng gói kết quả xác thực giao dịch VNPay trả về.
     */
    public static class VnPayResult {
        private boolean validSignature;
        private boolean success;
        private int orderId;
        private BigDecimal amount;
        private String responseCode;
        private String transactionNo;
        private String bankCode;
        private String payDate;
        private String message;

        public boolean isValidSignature() {
            return validSignature;
        }

        public void setValidSignature(boolean validSignature) {
            this.validSignature = validSignature;
        }

        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public int getOrderId() {
            return orderId;
        }

        public void setOrderId(int orderId) {
            this.orderId = orderId;
        }

        public BigDecimal getAmount() {
            return amount;
        }

        public void setAmount(BigDecimal amount) {
            this.amount = amount;
        }

        public String getResponseCode() {
            return responseCode;
        }

        public void setResponseCode(String responseCode) {
            this.responseCode = responseCode;
        }

        public String getTransactionNo() {
            return transactionNo;
        }

        public void setTransactionNo(String transactionNo) {
            this.transactionNo = transactionNo;
        }

        public String getBankCode() {
            return bankCode;
        }

        public void setBankCode(String bankCode) {
            this.bankCode = bankCode;
        }

        public String getPayDate() {
            return payDate;
        }

        public void setPayDate(String payDate) {
            this.payDate = payDate;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }

    /**
     * Tạo URL thanh toán VNPay kèm chữ ký số bảo mật HMAC-SHA512.
     * @param request HttpServletRequest để trích xuất IP và tạo returnUrl
     * @param order Đối tượng Order đã được lưu trong DB
     * @return Chuỗi URL đầy đủ chuyển hướng người dùng sang VNPay Sandbox
     */
    public String createPaymentUrl(HttpServletRequest request, Order order) {
        if (order == null || order.getId() <= 0) {
            throw new IllegalArgumentException("Đơn hàng không hợp lệ để tạo liên kết thanh toán.");
        }

        long amountVnPay = order.getTotal().multiply(new BigDecimal(100)).longValue();

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", VnPayConfig.getVersion());
        vnp_Params.put("vnp_Command", VnPayConfig.getCommand());
        vnp_Params.put("vnp_TmnCode", VnPayConfig.getTmnCode());
        vnp_Params.put("vnp_Amount", String.valueOf(amountVnPay));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", "ORDER_" + order.getId());
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang " + order.getId());
        vnp_Params.put("vnp_OrderType", "other");
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VnPayConfig.getDynamicReturnUrl(request));
        vnp_Params.put("vnp_IpAddr", VnPayUtil.getIpAddress(request));

        TimeZone tz = TimeZone.getTimeZone("Asia/Ho_Chi_Minh");
        Calendar cld = Calendar.getInstance(tz);
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        formatter.setTimeZone(tz);
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        // Hạn thanh toán 15 phút
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        // Sắp xếp tham số, tạo hashData và chữ ký HMAC-SHA512
        String hashData = VnPayUtil.buildHashData(vnp_Params);
        String vnp_SecureHash = VnPayUtil.hmacSHA512(VnPayConfig.getHashSecret(), hashData);

        // Tạo chuỗi truy vấn query
        String queryUrl = VnPayUtil.buildQueryUrl(vnp_Params);
        return VnPayConfig.getUrl() + "?" + queryUrl + "&vnp_SecureHash=" + vnp_SecureHash;
    }

    /**
     * Xác thực dữ liệu trả về từ VNPay thông qua HTTP Request.
     * Kiểm tra chữ ký số bằng mã bí mật HashSecret.
     */
    public VnPayResult verifyReturn(HttpServletRequest request) {
        VnPayResult result = new VnPayResult();

        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements(); ) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if (fieldValue != null && !fieldValue.trim().isEmpty()) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        // 1. Tính toán lại SecureHash từ các tham số nhận được
        String hashData = VnPayUtil.buildHashData(fields);
        String calculatedHash = VnPayUtil.hmacSHA512(VnPayConfig.getHashSecret(), hashData);

        boolean isValidSignature = calculatedHash.equalsIgnoreCase(vnp_SecureHash);
        result.setValidSignature(isValidSignature);

        if (!isValidSignature) {
            result.setSuccess(false);
            result.setMessage("Chữ ký bảo mật không hợp lệ (Signature Invalid). Giao dịch có dấu hiệu bị giả mạo.");
            return result;
        }

        // 2. Trích xuất thông tin giao dịch
        String txnRef = request.getParameter("vnp_TxnRef");
        int orderId = 0;
        if (txnRef != null) {
            if (txnRef.startsWith("ORDER_")) {
                try {
                    orderId = Integer.parseInt(txnRef.substring(6));
                } catch (NumberFormatException ignored) {
                }
            } else {
                try {
                    orderId = Integer.parseInt(txnRef);
                } catch (NumberFormatException ignored) {
                }
            }
        }
        result.setOrderId(orderId);

        String amountStr = request.getParameter("vnp_Amount");
        if (amountStr != null) {
            try {
                long rawAmount = Long.parseLong(amountStr);
                result.setAmount(BigDecimal.valueOf(rawAmount / 100));
            } catch (NumberFormatException ignored) {
            }
        }

        String responseCode = request.getParameter("vnp_ResponseCode");
        result.setResponseCode(responseCode);
        result.setTransactionNo(request.getParameter("vnp_TransactionNo"));
        result.setBankCode(request.getParameter("vnp_BankCode"));
        result.setPayDate(request.getParameter("vnp_PayDate"));

        // "00" là mã thành công của VNPay
        if ("00".equals(responseCode)) {
            result.setSuccess(true);
            result.setMessage("Giao dịch thanh toán thành công.");
        } else {
            result.setSuccess(false);
            result.setMessage(mapResponseCodeToMessage(responseCode));
        }

        return result;
    }

    /**
     * Chuyển đổi mã phản hồi của VNPay sang thông điệp tiếng Việt thân thiện.
     */
    public String mapResponseCodeToMessage(String responseCode) {
        if (responseCode == null) return "Giao dịch không thành công.";
        switch (responseCode) {
            case "00":
                return "Giao dịch thành công.";
            case "07":
                return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).";
            case "09":
                return "Giao dịch không thành công: Thẻ/Tài khoản chưa đăng ký dịch vụ InternetBanking tại ngân hàng.";
            case "10":
                return "Giao dịch không thành công: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần.";
            case "11":
                return "Giao dịch không thành công: Đã hết hạn chờ thanh toán. Vui lòng thực hiện lại giao dịch.";
            case "12":
                return "Giao dịch không thành công: Thẻ/Tài khoản bị khóa.";
            case "13":
                return "Giao dịch không thành công: Quý khách nhập sai mật khẩu xác thực giao dịch (OTP).";
            case "24":
                return "Giao dịch không thành công: Khách hàng đã hủy giao dịch thanh toán.";
            case "51":
                return "Giao dịch không thành công: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch.";
            case "65":
                return "Giao dịch không thành công: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.";
            case "75":
                return "Ngân hàng thanh toán đang bảo trì. Vui lòng thử lại sau.";
            case "79":
                return "Giao dịch không thành công: Khách hàng nhập sai mật khẩu thanh toán quá số lần quy định.";
            default:
                return "Thanh toán thất bại (Mã lỗi VNPay: " + responseCode + ").";
        }
    }
}
