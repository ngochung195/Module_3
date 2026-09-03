<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Quản lý User</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 30px;
                    background-color: #f8fafc;
                }

                h2 {
                    color: #1b2a7a;
                    text-align: center;
                }

                table {
                    width: 80%;
                    margin: 20px auto;
                    border-collapse: collapse;
                    background: white;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                }

                th,
                td {
                    border: 1px solid #ddd;
                    padding: 12px;
                    text-align: left;
                }

                th {
                    background-color: #1b2a7a;
                    color: white;
                }

                tr:hover {
                    background-color: #f1f5f9;
                }

                .btn {
                    padding: 8px 12px;
                    text-decoration: none;
                    border-radius: 4px;
                    color: white;
                    font-weight: bold;
                    font-size: 14px;
                }

                .btn-add {
                    background-color: #27ae60;
                }

                .btn-sort {
                    background-color: #8e44ad;
                }

                .btn-search {
                    background-color: #f39c12;
                    border: none;
                    cursor: pointer;
                }

                .btn-reset {
                    background-color: #7f8c8d;
                }

                .btn-edit {
                    background-color: #2980b9;
                    margin-right: 5px;
                }

                .btn-delete {
                    background-color: #c0392b;
                }

                .action-bar {
                    width: 80%;
                    margin: 0 auto 15px auto;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    flex-wrap: wrap;
                    gap: 10px;
                }
            </style>
        </head>

        <body>
            <h2>Danh Sách Người Dùng (Users)</h2>
            <div class="action-bar">
                <div>
                    <a href="${pageContext.request.contextPath}/users?action=create" class="btn btn-add">Thêm mới User</a>
                    <a href="${pageContext.request.contextPath}/users?action=sort" class="btn btn-sort">Sắp xếp theo tên</a>
                </div>
                <form action="${pageContext.request.contextPath}/users" method="get" style="display: flex; gap: 8px; align-items: center;">
                    <input type="hidden" name="action" value="search" />
                    <input type="text" name="country" placeholder="Nhập quốc gia..." value="<c:out value='${requestScope.searchCountry}'/>" style="padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px;" />
                    <button type="submit" class="btn btn-search">Tìm kiếm</button>
                    <c:if test="${not empty requestScope.searchCountry}">
                        <a href="${pageContext.request.contextPath}/users" class="btn btn-reset">Đặt lại</a>
                    </c:if>
                </form>
            </div>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Tên User</th>
                    <th>Email</th>
                    <th>Quốc gia</th>
                    <th>Hành động</th>
                </tr>
                <c:forEach var="user" items="${requestScope.listUser}">
                    <tr>
                        <td>
                            <c:out value="${user.id}" />
                        </td>
                        <td>
                            <c:out value="${user.name}" />
                        </td>
                        <td>
                            <c:out value="${user.email}" />
                        </td>
                        <td>
                            <c:out value="${user.country}" />
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/users?action=edit&id=${user.id}"
                                class="btn btn-edit">Sửa</a>
                            <a href="${pageContext.request.contextPath}/users?action=delete&id=${user.id}"
                                class="btn btn-delete">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </body>

        </html>