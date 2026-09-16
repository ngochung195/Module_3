package com.electronicstore.model;

import java.io.Serializable;

/**
 * Đại diện cho một tùy chọn màu sắc của sản phẩm.
 */
public class ProductColor implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int productId;
    private String name;       // Tên màu (VD: "Titan Sa Mạc", "Titan Đen")
    private String hexCode;    // Mã màu CSS (VD: "#cda277")
    private String borderHex;  // Viền cho màu sáng (VD: "#cbd5e1")

    public ProductColor() {}

    public ProductColor(String name, String hexCode) {
        this(0, 0, name, hexCode, null);
    }

    public ProductColor(String name, String hexCode, String borderHex) {
        this(0, 0, name, hexCode, borderHex);
    }

    public ProductColor(int id, int productId, String name, String hexCode, String borderHex) {
        this.id = id;
        this.productId = productId;
        this.name = name;
        this.hexCode = hexCode;
        this.borderHex = borderHex;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getHexCode() {
        return hexCode;
    }

    public void setHexCode(String hexCode) {
        this.hexCode = hexCode;
    }

    public String getBorderHex() {
        return borderHex;
    }

    public void setBorderHex(String borderHex) {
        this.borderHex = borderHex;
    }

    @Override
    public String toString() {
        return "ProductColor{" +
                "id=" + id +
                ", productId=" + productId +
                ", name='" + name + '\'' +
                ", hexCode='" + hexCode + '\'' +
                ", borderHex='" + borderHex + '\'' +
                '}';
    }
}
