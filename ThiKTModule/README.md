# BÀI THI THỰC HÀNH MODULE 3 - JAVA WEB BACK-END DEVELOPMENT
## Đề tài: Quản Lý Thông Tin Sản Phẩm (Product Management)

---

### 1. Kiến trúc dự án (MVC 3-Tier Architecture)
```text
ThiKTModule/
├── database.sql                                      # Script tạo CSDL & dữ liệu mẫu
├── pom.xml                                           # Cấu hình Maven (Jakarta EE 10, Servlet 6, JSP 3.1, JSTL 3.0, MySQL Connector)
└── src/
    └── main/
        ├── java/com/codegym/
        │   ├── model/
        │   │   ├── Category.java                     # Model Danh mục
        │   │   └── Product.java                      # Model Sản phẩm
        │   ├── dao/
        │   │   ├── DBContext.java                    # Quản lý kết nối JDBC MySQL
        │   │   ├── ICategoryDAO.java                 # Interface Category DAO
        │   │   ├── CategoryDAO.java                  # Xử lý truy vấn CSDL cho Category
        │   │   ├── IProductDAO.java                  # Interface Product DAO
        │   │   └── ProductDAO.java                   # CRUD & Search sản phẩm
        │   ├── service/
        │   │   ├── ICategoryService.java
        │   │   ├── CategoryService.java
        │   │   ├── IProductService.java
        │   │   └── ProductService.java
        │   └── controller/
        │       └── ProductServlet.java               # Servlet điều hướng, xử lý request & validation
        └── webapp/
            ├── index.jsp                             # Redirect trang chủ về /products
            └── WEB-INF/
                ├── web.xml                           # Cấu hình deployment descriptor
                └── views/
                    └── product/
                        └── list.jsp                  # Giao diện Danh sách, Modal Thêm mới, Modal Sửa, Modal Xóa, Tìm kiếm
```

---

### 2. Các chức năng đã cài đặt đầy đủ theo yêu cầu đề bài
1. **Cơ sở dữ liệu (MySQL)**:
   - Database: `product_management`
   - Bảng `categories`: `id`, `name`, `description`
   - Bảng `products`: `id`, `name`, `price`, `quantity`, `color`, `description`, `category_id` (khóa ngoại liên kết tới `categories`).
   - Đã nạp dữ liệu mẫu có giá > 10.000.000 VNĐ.

2. **Hiển thị danh sách sản phẩm**:
   - Hiển thị đầy đủ: STT, Tên sản phẩm, Giá (format VNĐ), Số lượng, Màu sắc, Tên danh mục (lấy từ Category), Nút Sửa & Xóa.
   - Nút "Add Product" ("Thêm mới") mở popup modal ngay tại trang.

3. **Thêm mới sản phẩm (Modal Popup)**:
   - Form popup modal nhập thông tin: Name, Price, Quantity, Color, Description, Category.
   - **Validation đầy đủ (Client-side & Server-side)**:
     - Tên sản phẩm: Không được để trống.
     - Giá: Không được để trống và phải lớn hơn 10.000.000 VNĐ (`> 10000000`).
     - Số lượng: Không được để trống và phải là số nguyên dương (`> 0`).
     - Màu sắc: Dropdown list ("Đỏ", "Xanh", "Đen", "Trắng", "Vàng").
     - Danh mục: Dropdown list lấy từ bảng `Category`.
   - Sau khi Create thành công: Đóng modal, lưu CSDL, reload danh sách kèm thông báo `"Thêm mới sản phẩm thành công!"`.

4. **Xóa sản phẩm (Delete)**:
   - Xóa theo ID sản phẩm.
   - Khi bấm Delete hiển thị modal popup xác nhận chuẩn đề bài: `Bạn có muốn xóa sản phẩm [Tên sản phẩm] hay không?`.
   - Khi bấm Đồng ý: Xóa trong CSDL, reload danh sách kèm thông báo `"Xóa sản phẩm thành công!"`.

5. **Tìm kiếm (Search)**:
   - Tìm kiếm gần đúng theo `Tên sản phẩm`.
   - Tìm kiếm theo `Giá`.
   - Tìm kiếm kết hợp theo `Tất cả các thông tin` (Tên, Giá, Danh mục).
   - Nút Reset xóa bộ lọc để hiển thị lại toàn bộ danh sách.

6. **Chỉnh sửa sản phẩm (Edit)**:
   - Nút Sửa hỗ trợ cập nhật thông tin sản phẩm qua modal popup với đầy đủ validation.

---

### 3. Hướng dẫn chạy và kiểm thử

#### Cách 1: Chạy bằng Maven & Tomcat trong IDE (IntelliJ / Eclipse / VS Code)
- Import project Maven: `ThiKTModule`
- Cấu hình Server: Tomcat 10.1+
- URL truy cập: `http://localhost:8080/ThiKTModule/` hoặc `http://localhost:8080/products`

#### Cách 2: Deploy file WAR trực tiếp vào thư mục `webapps` của Tomcat
1. Build file WAR:
   ```bash
   mvn clean package
   ```
2. Copy file `target/ThiKTModule.war` vào thư mục `webapps` của Apache Tomcat.
3. Khởi động Tomcat và truy cập: `http://localhost:8080/ThiKTModule/`
