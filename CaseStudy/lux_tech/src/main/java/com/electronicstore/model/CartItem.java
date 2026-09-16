package com.electronicstore.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * CartItem – Một dòng sản phẩm trong giỏ hàng.
 * Lưu trong Session cùng với Cart.
 *
 * QUAN TRỌNG: Giá (price) trong CartItem chỉ dùng để hiển thị tạm thời.
 * Khi checkout, backend PHẢI lấy lại price từ database theo productId.
 * Không bao giờ tin price từ client/session để tính tổng tiền thực tế.
 */
public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int productId;
    private String productName;
    private BigDecimal price;      // Giá hiển thị – chỉ dùng UI, không dùng cho checkout
    private int quantity;
    private String categoryName;   // Tùy chọn – dùng hiển thị
    private String color;          // Màu sắc được chọn
    private String image;          // Tên file ảnh (VD: iphone-17.png)
    private int maxStock;          // Tồn kho tối đa của sản phẩm

    public CartItem() {}

    public CartItem(int productId, String productName, BigDecimal price, int quantity) {
        this(productId, productName, price, quantity, null, null, 999);
    }

    public CartItem(int productId, String productName, BigDecimal price, int quantity, String color) {
        this(productId, productName, price, quantity, color, null, 999);
    }

    public CartItem(int productId, String productName, BigDecimal price, int quantity, String color, String image, int maxStock) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.color = color;
        this.image = image;
        this.maxStock = maxStock;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public String getName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public int getMaxStock() { return maxStock; }
    public void setMaxStock(int maxStock) { this.maxStock = maxStock; }

    /**
     * Lấy tên file ảnh hiển thị, tự động fallback nếu image bị null hoặc rỗng.
     */
    public String getDisplayImage() {
        if (image != null && !image.trim().isEmpty()) {
            return image.trim();
        }
        String n = (productName != null) ? productName.toLowerCase() : "";
        if (n.contains("iphone")) return "iphone-17.png";
        if (n.contains("galaxy") || n.contains("s24")) return "galaxy-s24.png";
        if (n.contains("macbook")) return "macbook-pro.png";
        if (n.contains("dell") || n.contains("xps")) return "dell-xps.png";
        if (n.contains("airpod")) return "airpods-pro.png";
        if (n.contains("sony") || n.contains("wh-1000")) return "sony-wh1000xm5.png";
        if (n.contains("anker")) return "anker-20000.png";
        if (n.contains("baseus")) return "baseus-10000.png";
        if (n.contains("keychron")) return "keychron-k2.png";
        if (n.contains("logitech") || n.contains("mx")) return "logitech-mx3s.png";
        return "";
    }

    /**
     * Kiểm tra xem dòng giỏ hàng này có khớp với productId và color chỉ định không.
     */
    public boolean isMatch(int targetProductId, String targetColor) {
        if (this.productId != targetProductId) {
            return false;
        }
        String c1 = (this.color != null) ? this.color.trim() : "";
        String c2 = (targetColor != null) ? targetColor.trim() : "";
        return c1.equalsIgnoreCase(c2);
    }

    /**
     * Subtotal hiển thị (chỉ dùng UI, không dùng tính tổng checkout thực tế).
     */
    public BigDecimal getSubtotal() {
        if (price != null) {
            return price.multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }

    @Override
    public String toString() {
        return "CartItem{productId=" + productId + ", name='" + productName + "', color='" + color + "', qty=" + quantity + '}';
    }
}
