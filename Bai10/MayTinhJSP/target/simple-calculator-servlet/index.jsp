<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Calculator</title>
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

        .calculator-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 24px;
            padding: 48px 40px;
            width: 420px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5),
                        0 0 80px rgba(99, 102, 241, 0.15);
        }

        .calculator-header {
            text-align: center;
            margin-bottom: 36px;
        }

        .calculator-header .icon {
            font-size: 48px;
            margin-bottom: 12px;
            display: block;
        }

        .calculator-header h1 {
            font-size: 28px;
            font-weight: 700;
            color: #fff;
            letter-spacing: -0.5px;
        }

        .calculator-header p {
            color: rgba(255, 255, 255, 0.5);
            font-size: 14px;
            margin-top: 6px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            color: rgba(255, 255, 255, 0.75);
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 8px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 14px 18px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 12px;
            color: #fff;
            font-size: 16px;
            font-family: inherit;
            outline: none;
            transition: all 0.3s ease;
            appearance: none;
            -webkit-appearance: none;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: #6366f1;
            background: rgba(99, 102, 241, 0.1);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .form-group input::placeholder {
            color: rgba(255, 255, 255, 0.3);
        }

        .select-wrapper {
            position: relative;
        }

        .select-wrapper::after {
            content: '▼';
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.5);
            pointer-events: none;
            font-size: 12px;
        }

        .form-group select option {
            background: #1a1a2e;
            color: #fff;
        }

        .btn-calculate {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border: none;
            border-radius: 12px;
            color: #fff;
            font-size: 16px;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            margin-top: 8px;
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
        }

        .btn-calculate:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(99, 102, 241, 0.6);
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
        }

        .btn-calculate:active {
            transform: translateY(0);
        }

        .divider {
            height: 1px;
            background: rgba(255, 255, 255, 0.1);
            margin: 28px 0;
        }
    </style>
</head>
<body>
<div class="calculator-card">
    <div class="calculator-header">
        <span class="icon">🧮</span>
        <h1>Simple Calculator</h1>
        <p>Nhập phép tính và nhấn Calculate</p>
    </div>

    <form action="calculate" method="post">
        <div class="form-group">
            <label for="first-operand">First Operand</label>
            <input type="number"
                   id="first-operand"
                   name="first-operand"
                   placeholder="Nhập số thứ nhất"
                   step="any"
                   required />
        </div>

        <div class="form-group">
            <label for="operator">Operator</label>
            <div class="select-wrapper">
                <select id="operator" name="operator" required>
                    <option value="+">+ &nbsp; Addition</option>
                    <option value="-">- &nbsp; Subtraction</option>
                    <option value="*">× &nbsp; Multiplication</option>
                    <option value="/">&divide; &nbsp; Division</option>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label for="second-operand">Second Operand</label>
            <input type="number"
                   id="second-operand"
                   name="second-operand"
                   placeholder="Nhập số thứ hai"
                   step="any"
                   required />
        </div>

        <div class="divider"></div>

        <button type="submit" class="btn-calculate">
            ⚡ Calculate
        </button>
    </form>
</div>
</body>
</html>
