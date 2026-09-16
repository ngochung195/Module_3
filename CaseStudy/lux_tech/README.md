# LuxTech – Hệ Thống Quản Lý & Bán Hàng Điện Tử

LuxTech là nền tảng thương mại điện tử chuyên cung cấp thiết bị công nghệ thông minh, tích hợp trợ lý ảo thông minh **Google Gemini 3.5 Flash** và cổng thanh toán trực tuyến **VNPay Sandbox**. Dự án được xây dựng theo kiến trúc MVC chuẩn trên nền tảng **Java 17**, **Jakarta Servlet 6.0**, **JSP/JSTL**, **JDBC** và triển khai tối ưu trên **Apache Tomcat 10.1 / Docker**.

---

## 1. Yêu Cầu Môi Trường (Prerequisites)

* **Java Development Kit (JDK):** Version 17+
* **Apache Maven:** Version 3.8+
* **Apache Tomcat:** Version 10.1+ (Hỗ trợ Jakarta EE 10)
* **MySQL Server:** Version 8.0+ / 9.0+
* **Docker & Docker Compose** (Tùy chọn khi chạy container hóa)

---

## 2. Hướng Dẫn Chạy Cục Bộ (Run Locally)

### Bước 1: Khởi tạo Database
1. Mở MySQL Server và chạy script tạo bảng:
   ```sql
   -- Chạy file database/schema.sql
   -- Chạy file database/data.sql
   -- Chạy file database/add_products_phase11.sql
   ```
2. Cấu hình thông số kết nối trong file `src/main/resources/db.properties` hoặc thiết lập biến môi trường.

### Bước 2: Build dự án bằng Maven
```bash
mvn clean package -DskipTests
```
File WAR sẽ được tạo tại `target/lux_tech.war`.

### Bước 3: Triển khai lên Tomcat 10
* Copy `target/lux_tech.war` vào thư mục `webapps/` của Tomcat 10.
* Khởi động Tomcat và truy cập: `http://localhost:8080/lux_tech/`

---

## 3. Hướng Dẫn Chạy Bằng Docker (Run with Docker)

### Build Docker Image
```bash
docker build -t luxtech:latest .
```

### Khởi Chạy Container
```bash
docker run -d --name luxtech-app \
  -p 8080:8080 \
  -e DB_HOST="your-mysql-host" \
  -e DB_PORT="3306" \
  -e DB_NAME="electronic_store" \
  -e DB_USERNAME="your-db-user" \
  -e DB_PASSWORD="your-db-password" \
  -e GEMINI_API_KEY="your-gemini-api-key" \
  -e VNPAY_TMN_CODE="your-vnpay-tmn-code" \
  -e VNPAY_HASH_SECRET="your-vnpay-hash-secret" \
  luxtech:latest
```
Truy cập website tại: `http://localhost:8080/`

---

## 4. Danh Sách Biến Môi Trường (Environment Variables)

| Tên Biến | Mô Tả | Mặc Định / Ví Dụ |
|---|---|---|
| `PORT` | Cổng dịch vụ lắng nghe (Render tự cấp phát) | `8080` |
| `DB_HOST` | Địa chỉ máy chủ CSDL MySQL Cloud | `db.example.com` |
| `DB_PORT` | Cổng kết nối CSDL MySQL | `3306` |
| `DB_NAME` | Tên cơ sở dữ liệu | `electronic_store` |
| `DB_USERNAME` | Tên đăng nhập CSDL MySQL | `root` |
| `DB_PASSWORD` | Mật khẩu truy cập CSDL | `********` |
| `DB_URL` | *(Tùy chọn)* Chuỗi kết nối JDBC trực tiếp | `jdbc:mysql://...` |
| `GEMINI_API_KEY` | Khóa API Google Gemini AI | `AIzaSy...` |
| `VNPAY_TMN_CODE` | Mã website tại hệ thống VNPay Sandbox | `RWTJ2TDY` |
| `VNPAY_HASH_SECRET`| Khóa bí mật tạo checksum giao dịch VNPay | `ZJKTIPJSDNVMB...` |
| `VNPAY_URL` | URL cổng thanh toán VNPay Gateway | `https://sandbox.vnpayment.vn/paymentv2/vpcpay.html` |
| `VNPAY_RETURN_URL` | URL nhận kết quả thanh toán callback | `https://luxtech.onrender.com/vnpay-return` |

---

## 5. Cấu Hình Cơ Sở Dữ Liệu (Database Configuration)

Hệ thống hỗ trợ cơ chế nạp cấu hình linh hoạt:
1. **Ưu tiên 1:** Đọc từ biến môi trường `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USERNAME`, `DB_PASSWORD` hoặc `DB_URL` (dành cho Cloud / Render / Docker).
2. **Fallback:** Tự động đọc từ file `src/main/resources/db.properties` khi chạy trên môi trường phát triển nội bộ.

---

## 6. Cấu Hình Gemini AI (Gemini Configuration)

* Backend tích hợp chính thức qua Google GenAI SDK (`com.google.genai:google-genai`).
* **Bảo mật:** API Key tuyệt đối được giữ kín ở tầng server và đọc từ biến môi trường `GEMINI_API_KEY`.
* Frontend chỉ tương tác thông qua endpoint REST an toàn: `POST /chat`.

---

## 7. Cấu Hình Thanh Toán VNPay (VNPay Configuration)

* Tương thích chuẩn API VNPay v2.1.0 với thuật toán mã hóa SHA-512.
* URL callback tự động điều chỉnh theo domain request (`getDynamicReturnUrl`) hoặc gán cố định qua biến `VNPAY_RETURN_URL`.

---

## 8. Hướng Dẫn Triển Khai Lên Render (Deploy to Render)

### Bước 1: Chuẩn bị CSDL MySQL Cloud
Tạo database MySQL trên các dịch vụ Cloud miễn phí/thương mại (như *TiDB Cloud, Supabase, Aiven, Clever Cloud, Railway*) và thực thi các script SQL trong thư mục `database/`.

### Bước 2: Đẩy Mã Nguồn Lên GitHub
```bash
git add .
git commit -m "feat: dockerize luxtech for render deployment"
git push origin main
```

### Bước 3: Tạo Web Service trên Render.com
1. Đăng nhập vào [Render Dashboard](https://dashboard.render.com/).
2. Nhấn **New +** -> Chọn **Web Service**.
3. Kết nối với GitHub Repository của dự án `lux_tech`.
4. Render sẽ tự động nhận diện `Dockerfile`.
   * **Name:** `luxtech-store` (hoặc tên tùy chọn)
   * **Region:** Singapore / Oregon / Frankfurt
   * **Branch:** `main`
   * **Runtime:** `Docker`
5. Thêm các **Environment Variables** trong mục cấu hình:
   * `DB_HOST`: `<Địa chỉ Cloud DB của bạn>`
   * `DB_PORT`: `3306`
   * `DB_NAME`: `<Tên database của bạn>`
   * `DB_USERNAME`: `<User database>`
   * `DB_PASSWORD`: `<Password database>`
   * `GEMINI_API_KEY`: `<API Key từ Google AI Studio>`
   * `VNPAY_TMN_CODE`: `RWTJ2TDY` *(hoặc mã sandbox riêng)*
   * `VNPAY_HASH_SECRET`: `ZJKTIPJSDNVMBFCEPGKYWKMFXEWBFHND`
   * `VNPAY_RETURN_URL`: `https://<ten-service-render>.onrender.com/vnpay-return`
6. Nhấn **Create Web Service**.

### Bước 4: Kiểm Tra Health Endpoint
Sau khi Render hoàn tất quá trình build và khởi động, kiểm tra trạng thái dịch vụ tại:
`https://<ten-service-render>.onrender.com/health`
Kết quả trả về:
```json
{
  "status": "UP",
  "database": "UP"
}
```

---

## 9. Xử Lý Sự Cố (Troubleshooting)

* **Lỗi 502 / Timed out waiting for port:**
  * Nguyên nhân: Tomcat không bind đúng port mà Render cấp phát.
  * Khắc phục: Dockerfile đã tự động thay thế cổng trong `server.xml` theo biến `$PORT`. Hãy kiểm tra tab Logs trên Render.
* **Lỗi Database Connection Failed:**
  * Nguyên nhân: Thông số `DB_HOST`, `DB_USERNAME`, `DB_PASSWORD` sai hoặc Cloud DB chưa mở quyền truy cập (Allow all IPs `0.0.0.0/0`).
  * Khắc phục: Kiểm tra cấu hình IP Whitelist trên nhà cung cấp MySQL Cloud.
* **Lỗi Gemini AI không trả lời:**
  * Nguyên nhân: Chưa cấu hình biến `GEMINI_API_KEY` hoặc API key bị hết hạn/hết quota.
  * Khắc phục: Kiểm tra biến môi trường trên Render và sinh key mới tại Google AI Studio.
