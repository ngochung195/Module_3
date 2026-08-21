<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Discount Calculator</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: inline-block; width: 180px; font-weight: bold; }
        input[type="text"], input[type="number"] { padding: 5px; width: 200px; }
        button { padding: 8px 15px; cursor: pointer; }
    </style>
</head>
<body>
    <h2>Product Discount Calculator</h2>
    <form action="display-discount" method="POST">
        <div class="form-group">
            <label for="description">Product Description:</label>
            <input type="text" id="description" name="description" required>
        </div>
        <div class="form-group">
            <label for="price">List Price:</label>
            <input type="number" step="0.01" id="price" name="price" required>
        </div>
        <div class="form-group">
            <label for="discount">Discount Percent (%):</label>
            <input type="number" step="0.01" id="discount" name="discount" required>
        </div>
        <div class="form-group">
            <button type="submit">Calculate Discount</button>
        </div>
    </form>
</body>
</html>
