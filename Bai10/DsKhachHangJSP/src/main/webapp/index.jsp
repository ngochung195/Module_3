<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.codegym.model.Customer, java.util.ArrayList, java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    /* ── Khởi tạo danh sách khách hàng giả lập ──────────────────────────── */
    List<Customer> customers = new ArrayList<>();

    customers.add(new Customer(
        "Nguyễn Văn An",
        "15/03/1990",
        "123 Lê Lợi, Quận 1, TP.HCM",
        "images/customer1.jpg"
    ));
    customers.add(new Customer(
        "Trần Thị Bích",
        "22/07/1995",
        "456 Nguyễn Huệ, Quận 1, TP.HCM",
        "images/customer2.jpg"
    ));
    customers.add(new Customer(
        "Lê Minh Cường",
        "08/11/1988",
        "789 Hai Bà Trưng, Quận 3, TP.HCM",
        "images/customer3.jpg"
    ));
    customers.add(new Customer(
        "Phạm Thị Dung",
        "30/01/2000",
        "321 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM",
        "images/customer4.jpg"
    ));
    customers.add(new Customer(
        "Hoàng Quốc Đạt",
        "14/06/1993",
        "55 Võ Thị Sáu, Quận 3, TP.HCM",
        "images/customer5.jpg"
    ));

    request.setAttribute("customers", customers);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Danh sách khách hàng - Ứng dụng JSP JSTL CodeGym">
    <title>Danh Sách Khách Hàng | CodeGym</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* ── Reset & Base ─────────────────────────────────────── */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --primary:       #6C63FF;
            --primary-dark:  #4B44CC;
            --accent:        #FF6584;
            --bg-deep:       #0F0E17;
            --bg-card:       #1A1830;
            --bg-table:      #141225;
            --border:        rgba(108, 99, 255, 0.25);
            --text-main:     #E8E6FF;
            --text-muted:    #8B88B0;
            --row-even:      rgba(108, 99, 255, 0.06);
            --row-hover:     rgba(108, 99, 255, 0.15);
            --shadow-glow:   0 0 40px rgba(108, 99, 255, 0.25);
            --radius-lg:     16px;
            --radius-sm:     8px;
            --transition:    0.3s ease;
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-deep);
            color: var(--text-main);
            min-height: 100vh;
            padding: 40px 20px 60px;
            background-image:
                radial-gradient(ellipse 80% 50% at 20% -10%, rgba(108,99,255,0.18) 0%, transparent 60%),
                radial-gradient(ellipse 60% 40% at 80% 110%, rgba(255,101,132,0.12) 0%, transparent 55%);
        }

        /* ── Header ───────────────────────────────────────────── */
        .page-header {
            text-align: center;
            margin-bottom: 48px;
        }

        .page-header .badge {
            display: inline-block;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: #fff;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            padding: 4px 14px;
            border-radius: 20px;
            margin-bottom: 16px;
        }

        .page-header h1 {
            font-size: clamp(1.8rem, 4vw, 2.8rem);
            font-weight: 700;
            background: linear-gradient(135deg, #E8E6FF 30%, var(--primary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 10px;
        }

        .page-header p {
            color: var(--text-muted);
            font-size: 0.95rem;
        }

        /* ── Card Container ───────────────────────────────────── */
        .card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-glow);
            overflow: hidden;
            max-width: 1100px;
            margin: 0 auto;
        }

        /* ── Table ────────────────────────────────────────────── */
        .table-wrapper { overflow-x: auto; }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        thead {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
        }

        thead th {
            padding: 16px 20px;
            text-align: left;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.9);
            white-space: nowrap;
        }

        tbody tr {
            border-bottom: 1px solid var(--border);
            transition: background var(--transition), transform var(--transition);
        }

        tbody tr:nth-child(even)  { background: var(--row-even); }
        tbody tr:hover            { background: var(--row-hover); transform: translateX(4px); }
        tbody tr:last-child       { border-bottom: none; }

        td {
            padding: 16px 20px;
            vertical-align: middle;
            color: var(--text-main);
        }

        /* ── Avatar / Image cell ──────────────────────────────── */
        .td-avatar { width: 70px; }

        .avatar {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--primary);
            display: block;
            transition: border-color var(--transition), transform var(--transition);
        }

        tr:hover .avatar {
            border-color: var(--accent);
            transform: scale(1.12);
        }

        /* ── Name cell ────────────────────────────────────────── */
        .name-text {
            font-weight: 600;
            font-size: 0.95rem;
            color: #fff;
        }

        /* ── DOB cell ─────────────────────────────────────────── */
        .dob-pill {
            display: inline-block;
            background: rgba(108, 99, 255, 0.2);
            border: 1px solid rgba(108, 99, 255, 0.4);
            color: #A9A5FF;
            font-size: 0.78rem;
            font-weight: 500;
            padding: 3px 10px;
            border-radius: 20px;
        }

        /* ── Address cell ─────────────────────────────────────── */
        .address-text {
            color: var(--text-muted);
            font-size: 0.85rem;
            max-width: 280px;
        }

        /* ── Index cell ───────────────────────────────────────── */
        .idx {
            font-weight: 700;
            color: var(--primary);
            font-size: 0.9rem;
        }

        /* ── Footer stats ─────────────────────────────────────── */
        .card-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 24px;
            background: rgba(0,0,0,0.25);
            border-top: 1px solid var(--border);
            font-size: 0.82rem;
            color: var(--text-muted);
            flex-wrap: wrap;
            gap: 8px;
        }

        .total-badge {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: #fff;
            font-weight: 700;
            font-size: 0.78rem;
            padding: 3px 12px;
            border-radius: 20px;
        }

        /* ── Responsive ───────────────────────────────────────── */
        @media (max-width: 600px) {
            .address-text { display: none; }
            thead th.th-address { display: none; }
        }
    </style>
</head>
<body>

    <!-- ── Page Header ──────────────────────────────────────────────── -->
    <header class="page-header">
        <div class="badge">CodeGym · Module 3</div>
        <h1>Danh Sách Khách Hàng</h1>
        <p>Quản lý thông tin khách hàng với JSP &amp; JSTL trên Tomcat 10.1+</p>
    </header>

    <!-- ── Main Table Card ──────────────────────────────────────────── -->
    <main>
        <div class="card">
            <div class="table-wrapper">
                <table id="customer-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Ảnh</th>
                            <th>Họ &amp; Tên</th>
                            <th>Ngày Sinh</th>
                            <th class="th-address">Địa Chỉ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="customer" items="${customers}" varStatus="loop">
                            <tr>
                                <td class="idx">${loop.index + 1}</td>
                                <td class="td-avatar">
                                    <img class="avatar"
                                         src="${pageContext.request.contextPath}/${customer.image}"
                                         alt="Ảnh của ${customer.name}"
                                         onerror="this.src='https://ui-avatars.com/api/?name=${customer.name}&background=6C63FF&color=fff&size=52'">
                                </td>
                                <td><span class="name-text">${customer.name}</span></td>
                                <td><span class="dob-pill">${customer.dob}</span></td>
                                <td><span class="address-text">${customer.address}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="card-footer">
                <span>Hiển thị <strong>${customers.size()}</strong> khách hàng</span>
                <span class="total-badge">Tổng: ${customers.size()} bản ghi</span>
            </div>
        </div>
    </main>

</body>
</html>
