<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.electronicstore.util.DBConnection" %>
<%
    boolean dbConnected = false;
    String dbError = null;
    try (Connection conn = DBConnection.getConnection()) {
        if (conn != null && !conn.isClosed()) {
            dbConnected = true;
        }
    } catch (Exception e) {
        dbError = e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LuxTech - Hệ Thống Quản Lý Cửa Hàng Điện Tử</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- LuxTech Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxtech-theme.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            color: #111827;
        }
        .hero-section {
            background: linear-gradient(135deg, #171717 0%, #262626 100%);
            color: white;
            padding: 80px 0;
            border-bottom: 4px solid #FF6B00;
            margin-bottom: 40px;
        }
        .card-custom {
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            transition: transform 0.2s ease;
        }
        .card-custom:hover {
            transform: translateY(-4px);
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: #171717; border-bottom: 1px solid rgba(255,255,255,0.08);">
        <div class="container">
            <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/">
                <span class="d-inline-flex align-items-center justify-content-center bg-primary text-white rounded-3 px-2 py-1" style="background-color: #FF6B00 !important; font-size: 0.9rem;">
                    <i class="bi bi-cpu-fill"></i>
                </span>
                <span class="fs-5 tracking-tight text-white"><span style="color:#FF6B00;">LUX</span>TECH</span>
            </a>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/shop" class="btn btn-outline-light btn-sm rounded-pill px-3">
                    <i class="bi bi-shop me-1"></i> Cửa hàng Online
                </a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm rounded-pill px-3">
                    <i class="bi bi-box-arrow-in-right me-1"></i> Đăng nhập
                </a>
            </div>
        </div>
    </nav>

    <!-- Hero Header -->
    <div class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 fw-bold mb-3"><span style="color: #FF6B00;">LUX</span>TECH STORE</h1>
            <p class="lead text-light text-opacity-75" style="max-width: 650px; margin: 0 auto;">Hệ thống bán lẻ & quản lý thiết bị công nghệ điện tử thông minh, trẻ trung & đột phá</p>
            <div class="mt-4 d-flex justify-content-center gap-3 flex-wrap">
                <a href="${pageContext.request.contextPath}/shop" class="btn btn-primary btn-lg rounded-pill px-4 shadow-sm">
                    <i class="bi bi-bag-check-fill me-2"></i> Mua Sắm Ngay
                </a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-lg rounded-pill px-4">
                    <i class="bi bi-person-lock me-2"></i> Cổng Quản Trị Back-Office
                </a>
            </div>
        </div>
    </div>

    <!-- Main Content Container -->
    <div class="container">
        <div class="row justify-content-center">
            <!-- System Status Card -->
            <div class="col-md-8">
                <div class="card card-custom p-4 mb-4">
                    <h5 class="card-title fw-bold border-bottom pb-2">
                        <i class="fa-solid fa-server text-primary me-2"></i>Trạng Thái Khởi Tạo Môi Trường (Phase 1)
                    </h5>
                    
                    <div class="mt-3">
                        <p class="mb-2"><strong>Mô hình:</strong> Java 17 + Servlet 6.0 + JSP + JDBC + MySQL</p>
                        <p class="mb-2"><strong>Máy chủ Web:</strong> Apache Tomcat 10+</p>
                        <p class="mb-2"><strong>Kết nối CSDL (JDBC):</strong>
                            <% if (dbConnected) { %>
                                <span class="badge bg-success"><i class="fa-solid fa-circle-check me-1"></i>Thành công (connected)</span>
                            <% } else { %>
                                <span class="badge bg-danger"><i class="fa-solid fa-circle-xmark me-1"></i>Thất bại</span>
                            <% } %>
                        </p>
                        <% if (!dbConnected && dbError != null) { %>
                            <div class="alert alert-warning mt-2 small mb-0">
                                <strong>Lỗi kết nối MySQL:</strong> <%= dbError %><br/>
                                <em>Lưu ý: Vui lòng khởi chạy MySQL service và chạy script <code>database/schema.sql</code> & <code>database/data.sql</code>.</em>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- LuxTech AI Chatbox (Phase 11 - Gemini 3.5 Flash) -->
    <jsp:include page="/WEB-INF/views/common/ai-chatbox.jsp"/>
    <script src="${pageContext.request.contextPath}/assets/js/luxtech-ai-chat.js?v=1.0" defer></script>
</body>
</html>
