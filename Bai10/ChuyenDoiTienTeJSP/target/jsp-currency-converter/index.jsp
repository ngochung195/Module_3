<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chuyển Đổi Tiền Tệ USD → VND</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 24px;
            padding: 50px 45px;
            width: 100%;
            max-width: 460px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.4);
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .header .icon {
            font-size: 3rem;
            margin-bottom: 12px;
            display: block;
        }

        .header h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
        }

        .header p {
            color: rgba(255, 255, 255, 0.5);
            font-size: 0.9rem;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            color: rgba(255, 255, 255, 0.75);
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 10px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper .currency-tag {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.4);
            font-size: 0.85rem;
            font-weight: 600;
            pointer-events: none;
        }

        .form-group input {
            width: 100%;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 12px;
            padding: 15px 18px 15px 55px;
            color: #ffffff;
            font-size: 1.05rem;
            font-weight: 500;
            transition: all 0.3s ease;
            outline: none;
        }

        .form-group input::placeholder {
            color: rgba(255, 255, 255, 0.25);
        }

        .form-group input:focus {
            border-color: rgba(99, 102, 241, 0.7);
            background: rgba(99, 102, 241, 0.1);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .btn-submit {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border: none;
            border-radius: 12px;
            color: #ffffff;
            font-size: 1rem;
            font-weight: 700;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 8px;
            text-transform: uppercase;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(99, 102, 241, 0.5);
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 24px 0;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(255, 255, 255, 0.1);
        }

        .divider span {
            color: rgba(255, 255, 255, 0.3);
            font-size: 0.8rem;
        }

        .info-box {
            background: rgba(99, 102, 241, 0.1);
            border: 1px solid rgba(99, 102, 241, 0.25);
            border-radius: 10px;
            padding: 12px 16px;
            color: rgba(255, 255, 255, 0.5);
            font-size: 0.8rem;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <span class="icon">💱</span>
        <h1>Chuyển Đổi Tiền Tệ</h1>
        <p>USD sang VND theo tỉ giá nhập vào</p>
    </div>

    <form action="converter.jsp" method="POST">

        <div class="form-group">
            <label for="rate">Tỉ Giá (1 USD = ? VND)</label>
            <div class="input-wrapper">
                <span class="currency-tag">VND</span>
                <input
                    type="number"
                    id="rate"
                    name="rate"
                    placeholder="Ví dụ: 25000"
                    step="0.01"
                    min="0"
                    required
                />
            </div>
        </div>

        <div class="form-group">
            <label for="usd">Số Lượng USD</label>
            <div class="input-wrapper">
                <span class="currency-tag">USD</span>
                <input
                    type="number"
                    id="usd"
                    name="usd"
                    placeholder="Ví dụ: 100"
                    step="0.01"
                    min="0"
                    required
                />
            </div>
        </div>

        <div class="divider"><span>sẽ quy đổi thành</span></div>

        <button type="submit" class="btn-submit" id="btn-convert">
            🔄 Quy Đổi Ngay
        </button>

    </form>

    <div class="info-box" style="margin-top: 24px;">
        Công thức: <strong>VND = USD × Tỉ Giá</strong>
    </div>
</div>

</body>
</html>
