package com.electronicstore.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Cart – Giỏ hàng của Customer.
 * Lưu trong Session (không persistent vào database).
 * Quản lý các dòng CartItem, hỗ trợ thêm, cập nhật số lượng, xóa và tính tổng.
 */
public class Cart implements Serializable {
    private static final long serialVersionUID = 1L;

    private List<CartItem> items = new ArrayList<>();

    public Cart() {}

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
    }

    /**
     * Tìm kiếm một mục trong giỏ theo mã sản phẩm và màu sắc.
     */
    public CartItem getItem(int productId, String color) {
        for (CartItem item : items) {
            if (item.isMatch(productId, color)) {
                return item;
            }
        }
        return null;
    }

    /**
     * Thêm sản phẩm vào giỏ hàng.
     * @param product Sản phẩm từ DB
     * @param quantity Số lượng muốn thêm
     * @param color Tùy chọn màu sắc
     * @return true nếu thêm thành công
     */
    public boolean addItem(Product product, int quantity, String color) {
        if (product == null || quantity <= 0 || product.getQuantity() <= 0) {
            return false;
        }

        // Chuẩn hóa tên màu
        String chosenColor = (color != null && !color.trim().isEmpty()) ? color.trim() : "";
        if (chosenColor.isEmpty() && product.getAvailableColors() != null && !product.getAvailableColors().isEmpty()) {
            chosenColor = product.getAvailableColors().get(0).getName();
        }

        CartItem existing = getItem(product.getId(), chosenColor);
        if (existing != null) {
            int newQty = existing.getQuantity() + quantity;
            int maxStock = product.getQuantity();
            if (newQty > maxStock) {
                newQty = maxStock;
            }
            existing.setQuantity(newQty);
            existing.setMaxStock(maxStock);
            existing.setPrice(product.getPrice()); // Cập nhật lại giá hiển thị mới nhất
            return true;
        } else {
            int initialQty = Math.min(quantity, product.getQuantity());
            CartItem newItem = new CartItem(
                product.getId(),
                product.getName(),
                product.getPrice(),
                initialQty,
                chosenColor,
                product.getDisplayImage(),
                product.getQuantity()
            );
            newItem.setCategoryName(product.getCategoryName());
            items.add(newItem);
            return true;
        }
    }

    /**
     * Cập nhật số lượng của một mục trong giỏ.
     * @param productId Mã sản phẩm
     * @param color Màu sắc
     * @param newQuantity Số lượng mới (nếu <= 0 thì tự động xóa)
     * @return true nếu cập nhật thành công
     */
    public boolean updateQuantity(int productId, String color, int newQuantity) {
        CartItem item = getItem(productId, color);
        if (item == null) {
            return false;
        }

        if (newQuantity <= 0) {
            return removeItem(productId, color);
        }

        if (item.getMaxStock() > 0 && newQuantity > item.getMaxStock()) {
            newQuantity = item.getMaxStock();
        }
        item.setQuantity(newQuantity);
        return true;
    }

    /**
     * Xóa một mục khỏi giỏ hàng.
     */
    public boolean removeItem(int productId, String color) {
        return items.removeIf(item -> item.isMatch(productId, color));
    }

    /**
     * Làm trống toàn bộ giỏ hàng.
     */
    public void clear() {
        items.clear();
    }

    /**
     * Tổng số lượng tất cả sản phẩm (cộng dồn quantity) – dùng hiển thị badge trên navbar.
     */
    public int getTotalItems() {
        int total = 0;
        for (CartItem item : items) {
            total += item.getQuantity();
        }
        return total;
    }

    /**
     * Số dòng mặt hàng khác nhau trong giỏ.
     */
    public int getLineCount() {
        return items == null ? 0 : items.size();
    }

    /**
     * Tổng tiền của giỏ hàng.
     * LƯU Ý: Giá trong CartItem chỉ dùng để hiển thị.
     * Khi checkout, backend PHẢI lấy lại giá từ database.
     */
    public BigDecimal getTotal() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) {
            if (item.getPrice() != null) {
                total = total.add(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            }
        }
        return total;
    }

    /**
     * Kiểm tra giỏ hàng có rỗng không.
     */
    public boolean isEmpty() {
        return items == null || items.isEmpty();
    }
}
