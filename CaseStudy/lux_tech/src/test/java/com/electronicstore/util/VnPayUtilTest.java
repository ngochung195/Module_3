package com.electronicstore.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

public class VnPayUtilTest {

    @Test
    @DisplayName("HMAC-SHA512 phải tạo ra chuỗi hash Hex 128 ký tự")
    void testHmacSHA512LengthAndDeterminism() {
        String key = "RAOXTXAWLZMTHZTEDGXDUWGMYXHHTXFL";
        String data = "vnp_Amount=10000000&vnp_Command=pay&vnp_CurrCode=VND";

        String hash1 = VnPayUtil.hmacSHA512(key, data);
        String hash2 = VnPayUtil.hmacSHA512(key, data);

        assertNotNull(hash1);
        assertEquals(128, hash1.length(), "HMAC-SHA512 phải có đúng 128 ký tự Hex");
        assertEquals(hash1, hash2, "Mã băm phải có tính tất định (deterministic) với cùng key và data");
    }

    @Test
    @DisplayName("buildHashData phải tự động sắp xếp tham số theo alphabet ASCII và bỏ qua giá trị rỗng")
    void testBuildHashDataSortingAndFiltering() {
        Map<String, String> params = new HashMap<>();
        params.put("vnp_TxnRef", "ORDER_1001");
        params.put("vnp_Amount", "2000000000");
        params.put("vnp_Command", "pay");
        params.put("vnp_EmptyField", "");
        params.put("vnp_NullField", null);

        String hashData = VnPayUtil.buildHashData(params);

        // Thứ tự alphabet đúng: vnp_Amount -> vnp_Command -> vnp_TxnRef
        assertTrue(hashData.startsWith("vnp_Amount=2000000000&vnp_Command=pay&vnp_TxnRef=ORDER_1001"),
                "Chuỗi hashData phải được sắp xếp đúng thứ tự alphabet: " + hashData);
        assertFalse(hashData.contains("vnp_EmptyField"), "Không được chứa trường rỗng");
        assertFalse(hashData.contains("vnp_NullField"), "Không được chứa trường null");
    }

    @Test
    @DisplayName("buildQueryUrl phải encode URL tham số đúng chuẩn")
    void testBuildQueryUrl() {
        Map<String, String> params = new HashMap<>();
        params.put("vnp_OrderInfo", "Thanh toan don hang 1001");
        params.put("vnp_Amount", "5000000");

        String query = VnPayUtil.buildQueryUrl(params);
        assertTrue(query.contains("vnp_OrderInfo=Thanh+toan+don+hang+1001"));
        assertTrue(query.startsWith("vnp_Amount=5000000"));
    }
}
