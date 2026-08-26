<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // ========================================================
    // JSP Scriptlet: Nhận tham số từ request và tính toán
    // ========================================================

    // Nhận tham số 'rate' và 'usd' từ request (form POST)
    String rateParam = request.getParameter("rate");
    String usdParam  = request.getParameter("usd");

    // Ép kiểu sang số thực (double)
    double rate = Double.parseDouble(rateParam);
    double usd  = Double.parseDouble(usdParam);

    // Tính toán: VND = USD * Rate
    double vnd = usd * rate;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết Quả Chuyển Đổi | USD → VND</title>
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
            max-width: 480px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.4);
            animation: slideUp 0.5s ease;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .header {
            text-align: center;
            margin-bottom: 36px;
        }

        .header .icon {
            font-size: 3rem;
            margin-bottom: 12px;
            display: block;
        }

        .header h1 {
            font-size: 1.7rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 6px;
        }

        .header p {
            color: rgba(255, 255, 255, 0.45);
            font-size: 0.88rem;
        }

        /* Bảng hiển thị thông số đầu vào */
        .input-summary {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 14px;
            padding: 20px;
            margin-bottom: 24px;
        }

        .input-summary .row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
        }

        .input-summary .row:not(:last-child) {
            border-bottom: 1px solid rgba(255, 255, 255, 0.07);
        }

        .input-summary .label {
            color: rgba(255, 255, 255, 0.5);
            font-size: 0.85rem;
        }

        .input-summary .value {
            color: #ffffff;
            font-weight: 600;
            font-size: 0.95rem;
        }

        /* Thẻ kết quả chính */
        .result-card {
            background: linear-gradient(135deg,
                rgba(99, 102, 241, 0.25),
                rgba(139, 92, 246, 0.25));
            border: 1px solid rgba(99, 102, 241, 0.4);
            border-radius: 18px;
            padding: 30px 24px;
            text-align: center;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .result-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle,
                rgba(99, 102, 241, 0.08) 0%,
                transparent 60%);
            pointer-events: none;
        }

        .result-card .arrow-label {
            color: rgba(255, 255, 255, 0.45);
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 10px;
        }

        .result-card .usd-display {
            font-size: 1.2rem;
            color: rgba(255, 255, 255, 0.6);
            margin-bottom: 16px;
            font-weight: 500;
        }

        .result-card .arrow {
            font-size: 1.5rem;
            margin-bottom: 16px;
            display: block;
        }

        .result-card .vnd-label {
            color: rgba(255, 255, 255, 0.55);
            font-size: 0.82rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }

        .result-card .vnd-amount {
            font-size: 2.4rem;
            font-weight: 800;
            color: #a78bfa;
            letter-spacing: -1px;
            line-height: 1;
        }

        .result-card .vnd-currency {
            font-size: 1rem;
            color: rgba(167, 139, 250, 0.7);
            font-weight: 600;
            margin-top: 6px;
        }

        /* Công thức */
        .formula-box {
            background: rgba(255, 255, 255, 0.04);
            border: 1px dashed rgba(255, 255, 255, 0.12);
            border-radius: 10px;
            padding: 12px 16px;
            color: rgba(255, 255, 255, 0.4);
            font-size: 0.82rem;
            text-align: center;
            margin-bottom: 28px;
            font-family: 'Courier New', monospace;
        }

        .formula-box span {
            color: rgba(167, 139, 250, 0.8);
            font-weight: 600;
        }

        /* Nút quay lại */
        .btn-back {
            display: block;
            width: 100%;
            padding: 15px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 12px;
            color: #ffffff;
            font-size: 0.95rem;
            font-weight: 600;
            text-decoration: none;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-back:hover {
            background: rgba(255, 255, 255, 0.14);
            border-color: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <span class="icon">✅</span>
        <h1>Kết Quả Quy Đổi</h1>
        <p>Chuyển đổi USD sang VND thành công</p>
    </div>

    <!-- Thông số đầu vào -->
    <div class="input-summary">
        <div class="row">
            <span class="label">💵 Số USD nhập vào</span>
            <span class="value"><%= usd %> USD</span>
        </div>
        <div class="row">
            <span class="label">📊 Tỉ giá áp dụng</span>
            <span class="value"><%= rate %> VND/USD</span>
        </div>
    </div>

    <!-- Thẻ kết quả -->
    <div class="result-card">
        <div class="arrow-label">Kết quả quy đổi</div>
        <div class="usd-display"><%= usd %> USD</div>
        <span class="arrow">⬇️</span>
        <div class="vnd-label">Tương đương</div>
        <div class="vnd-amount"><%= String.format("%,.0f", vnd) %></div>
        <div class="vnd-currency">VND (Đồng Việt Nam)</div>
    </div>

    <!-- Hiển thị công thức tính toán bằng JSP Expression -->
    <div class="formula-box">
        Công thức: <span><%= usd %></span> USD × <span><%= rate %></span>
        = <span><%= String.format("%,.0f", vnd) %></span> VND
    </div>

    <!-- Nút quay lại -->
    <a href="index.jsp" class="btn-back" id="btn-back">
        ← Quy Đổi Lần Khác
    </a>
</div>

</body>
</html>
