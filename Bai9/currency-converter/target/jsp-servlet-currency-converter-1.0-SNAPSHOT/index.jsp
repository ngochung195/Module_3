<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Currency Converter</title>
</head>
<body>
    <h2>Currency Converter</h2>
    <form action="convert" method="post">
        <label for="rate">Tỉ giá (Rate):</label>
        <input type="number" step="0.01" id="rate" name="rate" required><br><br>
        
        <label for="usd">Lượng USD (USD Amount):</label>
        <input type="number" step="0.01" id="usd" name="usd" required><br><br>
        
        <input type="submit" value="Convert">
    </form>
</body>
</html>
