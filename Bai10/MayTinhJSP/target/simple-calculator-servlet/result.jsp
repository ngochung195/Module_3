<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculator Result</title>
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
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .result-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 24px;
            padding: 48px 40px;
            width: 480px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5),
                        0 0 80px rgba(99, 102, 241, 0.15);
            text-align: center;
            animation: fadeInUp 0.5s ease;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .result-icon {
            font-size: 56px;
            margin-bottom: 16px;
            display: block;
        }

        .result-title {
            font-size: 22px;
            font-weight: 600;
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 28px;
            letter-spacing: -0.3px;
        }

        /* ---- SUCCESS ---- */
        .expression-box {
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 16px;
            padding: 24px 28px;
            margin-bottom: 20px;
        }

        .expression {
            font-size: 20px;
            color: rgba(255, 255, 255, 0.75);
            letter-spacing: 0.5px;
        }

        .expression .operand {
            color: #a5b4fc;
            font-weight: 600;
        }

        .expression .op {
            color: #f472b6;
            font-weight: 700;
            margin: 0 8px;
        }

        .result-value {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border-radius: 16px;
            padding: 28px;
            margin-bottom: 20px;
        }

        .result-value .label {
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            color: rgba(255, 255, 255, 0.65);
            margin-bottom: 8px;
        }

        .result-value .number {
            font-size: 48px;
            font-weight: 800;
            color: #fff;
            line-height: 1;
            letter-spacing: -1px;
        }

        /* ---- ERROR ---- */
        .error-box {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.35);
            border-radius: 16px;
            padding: 28px;
            margin-bottom: 20px;
        }

        .error-icon-big {
            font-size: 48px;
            margin-bottom: 12px;
        }

        .error-title-text {
            font-size: 18px;
            font-weight: 700;
            color: #f87171;
            margin-bottom: 8px;
        }

        .error-message {
            font-size: 15px;
            color: rgba(248, 113, 113, 0.8);
        }

        .error-expression {
            margin-top: 14px;
            font-size: 14px;
            color: rgba(255, 255, 255, 0.4);
        }

        /* ---- BACK BUTTON ---- */
        .btn-back {
            display: inline-block;
            padding: 14px 36px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: rgba(255, 255, 255, 0.85);
            font-size: 15px;
            font-weight: 600;
            font-family: inherit;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
            letter-spacing: 0.3px;
            margin-top: 8px;
        }

        .btn-back:hover {
            background: rgba(99, 102, 241, 0.25);
            border-color: rgba(99, 102, 241, 0.5);
            color: #fff;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
<div class="result-card">

    <c:choose>
        <%-- SUCCESS: result attribute is set --%>
        <c:when test="${not empty result}">
            <span class="result-icon">✅</span>
            <p class="result-title">Kết quả tính toán</p>

            <div class="expression-box">
                <div class="expression">
                    <span class="operand">${firstOperand}</span>
                    <span class="op">${operator}</span>
                    <span class="operand">${secondOperand}</span>
                    <span class="op">=</span>
                    <span class="operand">${result}</span>
                </div>
            </div>

            <div class="result-value">
                <div class="label">Result</div>
                <div class="number">${result}</div>
            </div>
        </c:when>

        <%-- ERROR: errorMessage attribute is set --%>
        <c:when test="${not empty errorMessage}">
            <span class="result-icon">⚠️</span>
            <p class="result-title">Đã xảy ra lỗi</p>

            <div class="error-box">
                <div class="error-icon-big">🚫</div>
                <div class="error-title-text">Phép tính không hợp lệ</div>
                <div class="error-message">${errorMessage}</div>
                <div class="error-expression">
                    ${firstOperand} &nbsp;${operator}&nbsp; ${secondOperand}
                </div>
            </div>
        </c:when>

        <%-- FALLBACK: No data available --%>
        <c:otherwise>
            <span class="result-icon">❓</span>
            <p class="result-title">Không có dữ liệu</p>
        </c:otherwise>
    </c:choose>

    <br/>
    <a href="${pageContext.request.contextPath}/" class="btn-back">
        ← Tính toán mới
    </a>
</div>
</body>
</html>
