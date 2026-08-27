<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Không Tìm Thấy Trang</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            min-height: 100vh;
            color: #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            text-align: center;
        }
        .error-container {
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 20px;
            padding: 60px 40px;
            max-width: 500px;
        }
        .error-code {
            font-size: 6rem;
            font-weight: 800;
            color: #a78bfa;
            line-height: 1;
            margin-bottom: 20px;
            text-shadow: 0 0 20px rgba(167, 139, 250, 0.4);
        }
        h1 {
            font-size: 1.5rem;
            margin-bottom: 16px;
            color: #e0e0e0;
        }
        p {
            color: #9ca3af;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .btn-home {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #7c3aed, #5b21b6);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(124, 58, 237, 0.3);
        }
    </style>
</head>
<body>

<div class="error-container">
    <div class="error-code">404</div>
    <h1>Trang Không Tồn Tại!</h1>
    <p>Xin lỗi, trang bạn đang tìm kiếm không tồn tại, đã bị xóa hoặc tạm thời không thể truy cập được.</p>
    <a href="${pageContext.request.contextPath}/products" class="btn-home">Về Trang Chủ</a>
</div>

</body>
</html>
