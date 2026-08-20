<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CodeGym JSP Demo</title>
    </head>

    <body style="font-family: 'Arial', sans-serif; text-align: center; margin-top: 100px; background-color: #f8fafc;">
        <h2 style="color: #1b2a7a; font-size: 36px;">Chào mừng tới lớp học Java Web!</h2>
        <p style="font-size: 18px;">Đây là trang JSP động được biên dịch trực tiếp từ Tomcat Server.</p>

        <%-- Đoạn mã Java động được nhúng trực tiếp trong HTML qua thẻ JSP Scriptlet --%>
            <% java.util.Date date=new java.util.Date(); %>
                <p style="color: #64748b;">Thời gian hệ thống hiện tại: <strong style="color: #f15a24;">
                        <%= date %>
                    </strong></p>

                <br />
                <!-- Đường dẫn thẻ "a href" trỏ tới servlet khớp với urlPatterns đã khai báo ở HelloServlet.java -->
                <a href="hello"
                    style="background-color: #1b2a7a; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;">Đi
                    tới HelloServlet</a>
    </body>

    </html>