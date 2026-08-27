<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} | Chi Tiết Sản Phẩm</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            min-height: 100vh;
            color: #e0e0e0;
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
        .container { max-width: 800px; margin: 48px auto; padding: 0 24px; }
        .breadcrumb { font-size: 0.8rem; color: #9ca3af; margin-bottom: 24px; }
        .breadcrumb a { color: #c4b5fd; text-decoration: none; }
        .card {
            background: rgba(255,255,255,0.06);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(6,182,212,0.25);
            border-radius: 20px;
            overflow: hidden;
        }
        .card-header {
            background: linear-gradient(135deg, rgba(6,182,212,0.15), rgba(14,116,144,0.15));
            padding: 28px 36px;
            border-bottom: 1px solid rgba(6,182,212,0.2);
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        .product-name {
            font-size: 1.6rem;
            font-weight: 700;
            color: #e0f2fe;
            margin-bottom: 8px;
        }
        .product-id {
            display: inline-block;
            padding: 3px 12px;
            background: rgba(6,182,212,0.2);
            border: 1px solid rgba(6,182,212,0.4);
            border-radius: 999px;
            font-size: 0.78rem;
            color: #67e8f9;
        }
        .price-display {
            text-align: right;
        }
        .price-label { font-size: 0.75rem; color: #9ca3af; margin-bottom: 4px; }
        .price-value {
            font-size: 2rem;
            font-weight: 800;
            color: #34d399;
        }
        .card-body { padding: 36px; }
        .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
        .detail-item {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 12px;
            padding: 16px 20px;
        }
        .detail-label {
            font-size: 0.75rem;
            color: #9ca3af;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 6px;
        }
        .detail-value { font-size: 1rem; color: #e0e0e0; font-weight: 500; }
        .description-box {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 28px;
        }
        .description-box .detail-label { margin-bottom: 10px; }
        .description-text { font-size: 0.9rem; line-height: 1.7; color: #d1d5db; }
        .action-bar { display: flex; gap: 12px; }
        .btn {
            padding: 11px 28px; border: none; border-radius: 10px;
            cursor: pointer; font-size: 0.9rem; font-weight: 600;
            text-decoration: none; transition: all 0.2s ease;
            display: inline-flex; align-items: center; gap: 6px;
        }
        .btn-warning { background: linear-gradient(135deg, #f59e0b, #b45309); color: white; }
        .btn-warning:hover { transform: translateY(-1px); box-shadow: 0 4px 15px rgba(245,158,11,0.4); }
        .btn-danger { background: linear-gradient(135deg, #ef4444, #b91c1c); color: white; }
        .btn-danger:hover { transform: translateY(-1px); box-shadow: 0 4px 15px rgba(239,68,68,0.4); }
        .btn-secondary {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.15);
            color: #e0e0e0;
        }
        .btn-secondary:hover { background: rgba(255,255,255,0.12); }
        .manufacturer-badge {
            display: inline-block;
            padding: 4px 14px;
            background: rgba(124,58,237,0.25);
            border: 1px solid rgba(124,58,237,0.4);
            border-radius: 999px;
            color: #c4b5fd;
            font-weight: 600;
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
        &rsaquo; Chi Tiết Sản Phẩm
    </div>

    <div class="card">
        <div class="card-header">
            <div>
                <div class="product-name">${product.name}</div>
                <span class="product-id">ID: ${product.id}</span>
            </div>
            <div class="price-display">
                <div class="price-label">GIÁ BÁN</div>
                <div class="price-value">
                    <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                </div>
            </div>
        </div>

        <div class="card-body">
            <div class="detail-grid">
                <div class="detail-item">
                    <div class="detail-label">🏭 Nhà Sản Xuất</div>
                    <div class="detail-value">
                        <span class="manufacturer-badge">${product.manufacturer}</span>
                    </div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">🆔 Mã Sản Phẩm</div>
                    <div class="detail-value">#${product.id}</div>
                </div>
            </div>

            <div class="description-box">
                <div class="detail-label">📝 Mô Tả Sản Phẩm</div>
                <div class="description-text">
                    <c:choose>
                        <c:when test="${not empty product.description}">${product.description}</c:when>
                        <c:otherwise><em style="color:#6b7280">Chưa có mô tả</em></c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="action-bar">
                <a href="${pageContext.request.contextPath}/products?action=edit&id=${product.id}"
                   class="btn btn-warning">✏ Chỉnh Sửa</a>
                <a href="${pageContext.request.contextPath}/products?action=delete&id=${product.id}"
                   class="btn btn-danger">🗑 Xóa</a>
                <a href="${pageContext.request.contextPath}/products"
                   class="btn btn-secondary">↩ Quay Lại</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>
