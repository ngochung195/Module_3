<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Từ điển Anh - Việt</title>
</head>
<body>
    <h2>Từ điển Anh - Việt</h2>
    <form action="${pageContext.request.contextPath}/translate" method="post">
        <label for="word">Nhập từ tiếng Anh:</label>
        <input type="text" id="word" name="word" required>
        <button type="submit">Tìm kiếm</button>
    </form>
</body>
</html>
