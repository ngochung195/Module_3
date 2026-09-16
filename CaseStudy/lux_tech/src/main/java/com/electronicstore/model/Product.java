package com.electronicstore.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Product implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private BigDecimal price;
    private int quantity;
    private int categoryId;
    private String image;
    private String categoryName; // Dùng hiển thị tên danh mục lên UI
    private int totalSold; // Tổng số lượng đã bán (dành cho thống kê)
    private List<ProductColor> colors = new ArrayList<>(); // Danh sách màu sắc thực tế lưu trong DB

    public Product() {
    }

    public Product(int id, String name, BigDecimal price, int quantity, int categoryId) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.categoryId = categoryId;
    }

    public Product(int id, String name, BigDecimal price, int quantity, int categoryId, String image) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.categoryId = categoryId;
        this.image = image;
    }

    public Product(int id, String name, BigDecimal price, int quantity, int categoryId, String categoryName, String image) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.image = image;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public int getTotalSold() {
        return totalSold;
    }

    public void setTotalSold(int totalSold) {
        this.totalSold = totalSold;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    /**
     * Lấy tên ảnh hiển thị, tự động fallback nếu image trong DB bị null hoặc rỗng.
     */
    public String getDisplayImage() {
        if (image != null && !image.trim().isEmpty()) {
            return image.trim();
        }
        String n = (name != null) ? name.toLowerCase() : "";
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

    public List<ProductColor> getColors() {
        return colors;
    }

    public void setColors(List<ProductColor> colors) {
        this.colors = (colors != null) ? colors : new ArrayList<>();
    }

    /**
     * Danh sách màu sắc thực tế của sản phẩm để người dùng chọn khi xem chi tiết.
     * Ưu tiên danh sách màu được cấu hình trong CSDL (this.colors),
     * nếu chưa có cấu hình riêng thì fallback về danh sách mặc định theo tên/danh mục.
     */
    public List<ProductColor> getAvailableColors() {
        if (this.colors != null && !this.colors.isEmpty()) {
            return this.colors;
        }

        List<ProductColor> defaultColors = new ArrayList<>();
        String n = (name != null) ? name.toLowerCase() : "";
        String cat = (categoryName != null) ? categoryName.toLowerCase() : "";

        if (n.contains("iphone")) {
            defaultColors.add(new ProductColor("Titan Sa Mạc", "#cda277"));
            defaultColors.add(new ProductColor("Titan Tự Nhiên", "#9e9b94"));
            defaultColors.add(new ProductColor("Titan Trắng", "#f4f3ed", "#d1d5db"));
            defaultColors.add(new ProductColor("Titan Đen", "#393836"));
        } else if (n.contains("galaxy") || n.contains("s24")) {
            defaultColors.add(new ProductColor("Xám Titan", "#6f7074"));
            defaultColors.add(new ProductColor("Đen Titan", "#2c2c2e"));
            defaultColors.add(new ProductColor("Tím Titan", "#595166"));
            defaultColors.add(new ProductColor("Vàng Titan", "#e4d9bc"));
        } else if (n.contains("macbook")) {
            defaultColors.add(new ProductColor("Đen Không Gian", "#2e3033"));
            defaultColors.add(new ProductColor("Bạc Ánh Kim", "#e2e4e6", "#cbd5e1"));
            defaultColors.add(new ProductColor("Xám Không Gian", "#7d7e82"));
        } else if (n.contains("dell") || n.contains("xps")) {
            defaultColors.add(new ProductColor("Bạch Kim (Platinum)", "#dadbdc", "#cbd5e1"));
            defaultColors.add(new ProductColor("Than Chì (Graphite)", "#424446"));
        } else if (n.contains("airpod")) {
            defaultColors.add(new ProductColor("Trắng Tinh Khôi", "#ffffff", "#d1d5db"));
        } else if (n.contains("sony") || n.contains("wh-1000")) {
            defaultColors.add(new ProductColor("Đen Nhám", "#1f2022"));
            defaultColors.add(new ProductColor("Bạc Ánh Kim", "#dcd7ce", "#cbd5e1"));
            defaultColors.add(new ProductColor("Xanh Midnight", "#222d3b"));
        } else if (n.contains("anker")) {
            defaultColors.add(new ProductColor("Đen Huyền Bí", "#181818"));
            defaultColors.add(new ProductColor("Trắng Sứ", "#f8f9fa", "#d1d5db"));
            defaultColors.add(new ProductColor("Xanh Navy", "#1e3a8a"));
        } else if (n.contains("baseus")) {
            defaultColors.add(new ProductColor("Đen Nhám", "#262626"));
            defaultColors.add(new ProductColor("Trắng Ngọc", "#ffffff", "#d1d5db"));
            defaultColors.add(new ProductColor("Tím Pastel", "#c4b5fd"));
        } else if (n.contains("keychron")) {
            defaultColors.add(new ProductColor("Xám Carbon", "#374151"));
            defaultColors.add(new ProductColor("Trắng Retro", "#f1f5f9", "#cbd5e1"));
            defaultColors.add(new ProductColor("Đen RGB", "#111827"));
        } else if (n.contains("logitech") || n.contains("mx")) {
            defaultColors.add(new ProductColor("Xám Graphite", "#374151"));
            defaultColors.add(new ProductColor("Xám Nhạt (Pale Gray)", "#e5e7eb", "#9ca3af"));
        } else if (cat.contains("thoại")) {
            defaultColors.add(new ProductColor("Đen Huyền Bí", "#1f2937"));
            defaultColors.add(new ProductColor("Xanh Dương", "#2563eb"));
            defaultColors.add(new ProductColor("Trắng Tinh Khôi", "#ffffff", "#d1d5db"));
        } else if (cat.contains("laptop")) {
            defaultColors.add(new ProductColor("Xám Không Gian", "#4b5563"));
            defaultColors.add(new ProductColor("Bạc Kim Loại", "#e5e7eb", "#9ca3af"));
        } else {
            defaultColors.add(new ProductColor("Đen Tiêu Chuẩn", "#1f2937"));
            defaultColors.add(new ProductColor("Trắng Tinh Khôi", "#f8fafc", "#d1d5db"));
            defaultColors.add(new ProductColor("Xám Hiện Đại", "#64748b"));
        }
        return defaultColors;
    }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                ", categoryId=" + categoryId +
                '}';
    }
}
