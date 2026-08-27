<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Sản Phẩm | Product Management</title>
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
            color: #c4b5fd; text-decoration: none;
            margin-left: 20px; font-size: 0.9rem;
        }
        .nav-links a:hover { color: #fff; }
        .container { max-width: 700px; margin: 48px auto; padding: 0 24px; }
        .breadcrumb { font-size: 0.8rem; color: #9ca3af; margin-bottom: 24px; }
        .breadcrumb a { color: #c4b5fd; text-decoration: none; }
        .breadcrumb a:hover { color: #fff; }
        .card {
            background: rgba(255,255,255,0.06);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 20px;
            padding: 36px;
        }
        .card-title {
            font-size: 1.3rem;
            color: #a78bfa;
            margin-bottom: 28px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .form-group { margin-bottom: 20px; }
        label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #c4b5fd;
            margin-bottom: 8px;
        }
        .required::after { content: ' *'; color: #f87171; }
        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            padding: 11px 16px;
            background: rgba(255,255,255,0.07);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 10px;
            color: #e0e0e0;
            font-size: 0.9rem;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            font-family: inherit;
        }
        input[type="text"]:focus,
        input[type="number"]:focus,
        textarea:focus {
            border-color: #7c3aed;
            box-shadow: 0 0 0 3px rgba(124,58,237,0.2);
        }
        textarea { resize: vertical; min-height: 100px; }
        .btn-group { display: flex; gap: 12px; margin-top: 28px; }
        .btn {
            padding: 11px 28px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-primary { background: linear-gradient(135deg, #7c3aed, #5b21b6); color: white; }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 15px rgba(124,58,237,0.4); }
        .btn-secondary {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.15);
            color: #e0e0e0;
        }
        .btn-secondary:hover { background: rgba(255,255,255,0.12); }
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.875rem;
            background: rgba(239,68,68,0.15);
            border: 1px solid rgba(239,68,68,0.3);
            color: #fca5a5;
        }
        .help-text { font-size: 0.78rem; color: #6b7280; margin-top: 4px; }
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
        &rsaquo; Thêm Sản Phẩm Mới
    </div>

    <div class="card">
        <div class="card-title">➕ Thêm Sản Phẩm Mới</div>

        <c:if test="${not empty errorMessage}">
            <div class="alert">❌ ${errorMessage}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/products" method="post">
            <input type="hidden" name="action" value="create">

            <div class="form-group">
                <label class="required" for="name">Tên Sản Phẩm</label>
                <input type="text" id="name" name="name"
                       placeholder="Ví dụ: Laptop Dell XPS 15"
                       value="${param.name}" required>
            </div>

            <div class="form-group">
                <label class="required" for="price">Giá (VNĐ)</label>
                <input type="number" id="price" name="price"
                       placeholder="Ví dụ: 25000000"
                       min="0" step="1000"
                       value="${param.price}" required>
                <div class="help-text">Nhập giá bằng số, đơn vị: đồng (VNĐ)</div>
            </div>

            <div class="form-group">
                <label class="required" for="manufacturer">Nhà Sản Xuất</label>
                <input type="text" id="manufacturer" name="manufacturer"
                       placeholder="Ví dụ: Apple, Samsung, Dell..."
                       value="${param.manufacturer}" required>
            </div>

            <div class="form-group">
                <label for="description">Mô Tả</label>
                <textarea id="description" name="description"
                          placeholder="Mô tả chi tiết về sản phẩm...">${param.description}</textarea>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-primary">💾 Lưu Sản Phẩm</button>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">↩ Quay Lại</a>
            </div>
        </form>
    </div>
</div>

</body>
</html>
