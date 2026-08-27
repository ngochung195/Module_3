<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm Kiếm Sản Phẩm | Product Management</title>
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
        .container { max-width: 1100px; margin: 0 auto; padding: 32px 24px; }
        .breadcrumb { font-size: 0.8rem; color: #9ca3af; margin-bottom: 20px; }
        .breadcrumb a { color: #c4b5fd; text-decoration: none; }
        .search-hero {
            text-align: center;
            padding: 40px 20px;
        }
        .search-hero h2 {
            font-size: 1.8rem;
            color: #a78bfa;
            margin-bottom: 8px;
        }
        .search-hero p { color: #9ca3af; margin-bottom: 28px; }
        .search-form {
            display: flex;
            gap: 10px;
            max-width: 580px;
            margin: 0 auto;
        }
        .search-form input {
            flex: 1;
            padding: 13px 20px;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(124,58,237,0.4);
            border-radius: 12px;
            color: #e0e0e0;
            font-size: 1rem;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .search-form input:focus {
            border-color: #7c3aed;
            box-shadow: 0 0 0 3px rgba(124,58,237,0.2);
        }
        .search-form input::placeholder { color: #9ca3af; }
        .btn {
            padding: 13px 24px; border: none; border-radius: 12px;
            cursor: pointer; font-size: 0.9rem; font-weight: 600;
            text-decoration: none; transition: all 0.2s ease;
            display: inline-flex; align-items: center; gap: 6px;
        }
        .btn-primary { background: linear-gradient(135deg, #7c3aed, #5b21b6); color: white; }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 15px rgba(124,58,237,0.4); }
        .btn-danger { background: linear-gradient(135deg, #ef4444, #b91c1c); color: white; }
        .btn-danger:hover { transform: translateY(-1px); }
        .btn-warning { background: linear-gradient(135deg, #f59e0b, #b45309); color: white; }
        .btn-warning:hover { transform: translateY(-1px); }
        .btn-info { background: linear-gradient(135deg, #06b6d4, #0e7490); color: white; }
        .btn-info:hover { transform: translateY(-1px); }
        .btn-sm { padding: 5px 12px; font-size: 0.8rem; border-radius: 8px; }
        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }
        .results-title { color: #c4b5fd; font-size: 1rem; }
        .result-count {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 14px;
            background: rgba(124,58,237,0.15);
            border: 1px solid rgba(124,58,237,0.3);
            border-radius: 999px;
            font-size: 0.8rem;
            color: #c4b5fd;
        }
        .keyword-highlight {
            background: rgba(124,58,237,0.25);
            color: #c4b5fd;
            padding: 1px 6px;
            border-radius: 4px;
            font-style: normal;
        }
        .card {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; }
        thead th {
            padding: 13px 16px;
            background: rgba(124,58,237,0.2);
            color: #c4b5fd;
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-align: left;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        tbody tr { border-bottom: 1px solid rgba(255,255,255,0.05); transition: background 0.15s; }
        tbody tr:hover { background: rgba(255,255,255,0.05); }
        tbody tr:last-child { border-bottom: none; }
        td { padding: 13px 16px; font-size: 0.875rem; vertical-align: middle; }
        .badge {
            display: inline-block; padding: 3px 10px; border-radius: 999px;
            font-size: 0.75rem; font-weight: 600;
            background: rgba(124,58,237,0.25); color: #c4b5fd;
        }
        .price { color: #34d399; font-weight: 600; }
        .actions { display: flex; gap: 6px; }
        .empty-state { text-align: center; padding: 60px 20px; color: #9ca3af; }
    </style>
</head>
<body>

<div class="header">
    <h1>🛒 Product Management</h1>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/products">Danh Sách</a>
        <a href="${pageContext.request.contextPath}/products?action=create">Thêm Mới</a>
        <a href="${pageContext.request.contextPath}/products?action=search">Tìm Kiếm</a>
    </div>
</div>

<div class="container">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/products">Trang chủ</a>
        &rsaquo; Tìm Kiếm
    </div>

    <!-- Hero search box -->
    <div class="search-hero">
        <h2>🔍 Tìm Kiếm Sản Phẩm</h2>
        <p>Tìm kiếm theo tên, nhà sản xuất hoặc mô tả sản phẩm</p>
        <form class="search-form" action="${pageContext.request.contextPath}/products" method="get">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword"
                   value="${keyword}"
                   placeholder="Nhập từ khóa tìm kiếm..."
                   autofocus>
            <button type="submit" class="btn btn-primary">🔍 Tìm</button>
        </form>
    </div>

    <!-- Kết quả tìm kiếm -->
    <c:if test="${keyword != null}">
        <div class="results-header">
            <span class="results-title">
                Kết quả cho: <em class="keyword-highlight">"${keyword}"</em>
            </span>
            <span class="result-count">📦 ${totalCount} sản phẩm</span>
        </div>

        <div class="card">
            <c:choose>
                <c:when test="${empty products}">
                    <div class="empty-state">
                        <div style="font-size:3rem">🔍</div>
                        <p>Không tìm thấy sản phẩm phù hợp với từ khóa "<strong>${keyword}</strong>".</p>
                        <p style="margin-top:8px;font-size:0.85rem">
                            <a href="${pageContext.request.contextPath}/products" style="color:#a78bfa">← Xem tất cả sản phẩm</a>
                        </p>
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
                                    <td style="max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"
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
    </c:if>

</div>
</body>
</html>
