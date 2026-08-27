<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Sản Phẩm | Product Management</title>
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
        .nav-links a {
            color: #c4b5fd;
            text-decoration: none;
            margin-left: 20px;
            font-size: 0.9rem;
            transition: color 0.2s;
        }
        .nav-links a:hover { color: #fff; }
        .container { max-width: 1200px; margin: 0 auto; padding: 32px 24px; }
        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .toolbar h2 { font-size: 1.25rem; color: #c4b5fd; }
        .toolbar-right { display: flex; gap: 10px; }
        .btn {
            padding: 9px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.875rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }
        .btn-primary { background: linear-gradient(135deg, #7c3aed, #5b21b6); color: white; }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 15px rgba(124,58,237,0.4); }
        .btn-danger { background: linear-gradient(135deg, #ef4444, #b91c1c); color: white; }
        .btn-danger:hover { transform: translateY(-1px); box-shadow: 0 4px 15px rgba(239,68,68,0.4); }
        .btn-warning { background: linear-gradient(135deg, #f59e0b, #b45309); color: white; }
        .btn-warning:hover { transform: translateY(-1px); box-shadow: 0 4px 15px rgba(245,158,11,0.4); }
        .btn-info { background: linear-gradient(135deg, #06b6d4, #0e7490); color: white; }
        .btn-info:hover { transform: translateY(-1px); box-shadow: 0 4px 15px rgba(6,182,212,0.4); }
        .btn-sm { padding: 5px 12px; font-size: 0.8rem; }
        .search-bar {
            display: flex;
            gap: 8px;
        }
        .search-bar input {
            padding: 9px 16px;
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 8px;
            background: rgba(255,255,255,0.08);
            color: #e0e0e0;
            font-size: 0.875rem;
            width: 240px;
            outline: none;
            transition: border-color 0.2s;
        }
        .search-bar input:focus { border-color: #7c3aed; }
        .search-bar input::placeholder { color: #9ca3af; }
        .alert {
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.875rem;
        }
        .alert-success { background: rgba(34,197,94,0.15); border: 1px solid rgba(34,197,94,0.3); color: #86efac; }
        .alert-danger  { background: rgba(239,68,68,0.15);  border: 1px solid rgba(239,68,68,0.3);  color: #fca5a5; }
        .card {
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; }
        thead th {
            padding: 14px 16px;
            background: rgba(124,58,237,0.2);
            color: #c4b5fd;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-align: left;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        tbody tr {
            border-bottom: 1px solid rgba(255,255,255,0.05);
            transition: background 0.15s;
        }
        tbody tr:hover { background: rgba(255,255,255,0.05); }
        tbody tr:last-child { border-bottom: none; }
        td { padding: 13px 16px; font-size: 0.875rem; vertical-align: middle; }
        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 600;
            background: rgba(124,58,237,0.25);
            color: #c4b5fd;
        }
        .price { color: #34d399; font-weight: 600; }
        .actions { display: flex; gap: 6px; }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #9ca3af;
        }
        .empty-state p { margin-top: 8px; }
        .stats-bar {
            display: flex;
            gap: 16px;
            margin-bottom: 24px;
        }
        .stat-card {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 16px 24px;
            flex: 1;
        }
        .stat-card .value { font-size: 1.75rem; font-weight: 700; color: #a78bfa; }
        .stat-card .label { font-size: 0.8rem; color: #9ca3af; margin-top: 4px; }
    </style>
</head>
<body>

<div class="header">
    <h1>🛒 Product Management</h1>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/products">Trang Chủ</a>
        <a href="${pageContext.request.contextPath}/products?action=create">Thêm Mới</a>
        <a href="${pageContext.request.contextPath}/products?action=search">Tìm Kiếm</a>
    </div>
</div>

<div class="container">

    <!-- Thống kê -->
    <div class="stats-bar">
        <div class="stat-card">
            <div class="value">${totalCount}</div>
            <div class="label">Tổng số sản phẩm</div>
        </div>
    </div>

    <!-- Thông báo -->
    <c:if test="${param.success eq 'created'}">
        <div class="alert alert-success">✅ Đã thêm sản phẩm mới thành công!</div>
    </c:if>
    <c:if test="${param.success eq 'updated'}">
        <div class="alert alert-success">✅ Đã cập nhật sản phẩm thành công!</div>
    </c:if>
    <c:if test="${param.success eq 'deleted'}">
        <div class="alert alert-success">✅ Đã xóa sản phẩm thành công!</div>
    </c:if>
    <c:if test="${param.error eq 'notfound'}">
        <div class="alert alert-danger">❌ Không tìm thấy sản phẩm.</div>
    </c:if>

    <!-- Toolbar -->
    <div class="toolbar">
        <h2>📦 Danh Sách Sản Phẩm</h2>
        <div class="toolbar-right">
            <form class="search-bar" action="${pageContext.request.contextPath}/products" method="get">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" placeholder="🔍 Tìm kiếm sản phẩm...">
                <button type="submit" class="btn btn-info">Tìm</button>
            </form>
            <a href="${pageContext.request.contextPath}/products?action=create" class="btn btn-primary">+ Thêm Mới</a>
        </div>
    </div>

    <!-- Bảng sản phẩm -->
    <div class="card">
        <c:choose>
            <c:when test="${empty products}">
                <div class="empty-state">
                    <div style="font-size: 3rem;">📭</div>
                    <p>Chưa có sản phẩm nào. <a href="${pageContext.request.contextPath}/products?action=create" style="color:#a78bfa;">Thêm ngay!</a></p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Tên Sản Phẩm</th>
                            <th>Giá</th>
                            <th>Nhà Sản Xuất</th>
                            <th>Mô Tả</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${products}" var="product" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td><strong>${product.name}</strong></td>
                                <td class="price">
                                    <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                </td>
                                <td><span class="badge">${product.manufacturer}</span></td>
                                <td style="max-width:200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"
                                    title="${product.description}">${product.description}</td>
                                <td>
                                    <div class="actions">
                                        <a href="${pageContext.request.contextPath}/products?action=view&id=${product.id}"
                                           class="btn btn-info btn-sm">👁 Xem</a>
                                        <a href="${pageContext.request.contextPath}/products?action=edit&id=${product.id}"
                                           class="btn btn-warning btn-sm">✏ Sửa</a>
                                        <a href="${pageContext.request.contextPath}/products?action=delete&id=${product.id}"
                                           class="btn btn-danger btn-sm">🗑 Xóa</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

</div>
</body>
</html>
