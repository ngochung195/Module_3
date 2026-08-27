<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xóa Sản Phẩm | Product Management</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            min-height: 100vh;
            color: #e0e0e0;
            display: flex;
            flex-direction: column;
        }
        .header {
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding: 16px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .header h1 { font-size: 1.5rem; color: #a78bfa; }
        .nav-links a { color: #c4b5fd; text-decoration: none; margin-left: 20px; }
        .nav-links a:hover { color: #fff; }
        .container { max-width: 600px; margin: 64px auto; padding: 0 24px; width: 100%; }
        .breadcrumb { font-size: 0.8rem; color: #9ca3af; margin-bottom: 24px; }
        .breadcrumb a { color: #c4b5fd; text-decoration: none; }
        .card {
            background: rgba(255,255,255,0.06);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(239,68,68,0.3);
            border-radius: 20px;
            padding: 40px;
            text-align: center;
        }
        .warning-icon {
            font-size: 4rem;
            margin-bottom: 16px;
            animation: shake 0.5s ease-in-out;
        }
        @keyframes shake {
            0%, 100% { transform: rotate(0deg); }
            25% { transform: rotate(-10deg); }
            75% { transform: rotate(10deg); }
        }
        .card-title {
            font-size: 1.4rem;
            color: #f87171;
            margin-bottom: 12px;
        }
        .card-subtitle {
            color: #9ca3af;
            font-size: 0.9rem;
            margin-bottom: 28px;
        }
        .product-info {
            background: rgba(239,68,68,0.08);
            border: 1px solid rgba(239,68,68,0.2);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 28px;
            text-align: left;
        }
        .info-row {
            display: flex;
            align-items: flex-start;
            margin-bottom: 10px;
            font-size: 0.875rem;
        }
        .info-row:last-child { margin-bottom: 0; }
        .info-label {
            color: #9ca3af;
            min-width: 130px;
            font-size: 0.8rem;
        }
        .info-value { color: #e0e0e0; font-weight: 500; }
        .price-value { color: #f87171; font-weight: 700; }
        .btn-group { display: flex; gap: 12px; justify-content: center; }
        .btn {
            padding: 12px 32px; border: none; border-radius: 10px;
            cursor: pointer; font-size: 0.9rem; font-weight: 600;
            text-decoration: none; transition: all 0.2s ease;
            display: inline-flex; align-items: center; gap: 6px;
        }
        .btn-danger { background: linear-gradient(135deg, #ef4444, #b91c1c); color: white; }
        .btn-danger:hover { transform: translateY(-1px); box-shadow: 0 4px 20px rgba(239,68,68,0.4); }
        .btn-secondary {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.15);
            color: #e0e0e0;
        }
        .btn-secondary:hover { background: rgba(255,255,255,0.12); }
        .warning-text {
            font-size: 0.8rem;
            color: #f87171;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="header">
    <h1>🛒 Product Management</h1>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/products">Danh Sách</a>
        <a href="${pageContext.request.contextPath}/products?action=create">Thêm Mới</a>
    </div>
</div>

<div class="container">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/products">Trang chủ</a>
        &rsaquo; Xóa Sản Phẩm
    </div>

    <div class="card">
        <div class="warning-icon">⚠️</div>
        <div class="card-title">Xác Nhận Xóa Sản Phẩm</div>
        <div class="card-subtitle">Thao tác này không thể hoàn tác. Bạn có chắc chắn muốn xóa sản phẩm này không?</div>

        <!-- Thông tin sản phẩm sẽ bị xóa -->
        <div class="product-info">
            <div class="info-row">
                <span class="info-label">🏷 ID:</span>
                <span class="info-value">${product.id}</span>
            </div>
            <div class="info-row">
                <span class="info-label">📦 Tên SP:</span>
                <span class="info-value">${product.name}</span>
            </div>
            <div class="info-row">
                <span class="info-label">💰 Giá:</span>
                <span class="price-value">
                    <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">🏭 Nhà SX:</span>
                <span class="info-value">${product.manufacturer}</span>
            </div>
            <c:if test="${not empty product.description}">
            <div class="info-row">
                <span class="info-label">📝 Mô tả:</span>
                <span class="info-value">${product.description}</span>
            </div>
            </c:if>
        </div>

        <!-- Form xác nhận xóa -->
        <form action="${pageContext.request.contextPath}/products" method="post">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" value="${product.id}">

            <div class="btn-group">
                <button type="submit" class="btn btn-danger">🗑 Xác Nhận Xóa</button>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">↩ Hủy Bỏ</a>
            </div>
        </form>

        <div class="warning-text">⚠ Lưu ý: Dữ liệu sẽ bị xóa vĩnh viễn và không thể khôi phục.</div>
    </div>
</div>

</body>
</html>
