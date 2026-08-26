<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.HashMap, java.util.Map" %>
<%
    /* ================================================================
     *  BƯỚC 1: Khởi tạo từ điển (Map<String, String>)
     *  Key   = từ tiếng Anh (viết thường)
     *  Value = nghĩa tiếng Việt
     * ================================================================ */
    Map<String, String> dictionary = new HashMap<>();

    // Lời chào & giao tiếp
    dictionary.put("hello",       "Xin chào");
    dictionary.put("hi",          "Chào");
    dictionary.put("goodbye",     "Tạm biệt");
    dictionary.put("bye",         "Tạm biệt");
    dictionary.put("thank",       "Cảm ơn");
    dictionary.put("thanks",      "Cảm ơn");
    dictionary.put("sorry",       "Xin lỗi");
    dictionary.put("please",      "Làm ơn / Xin hãy");
    dictionary.put("yes",         "Có / Vâng");
    dictionary.put("no",          "Không");

    // Đồ vật thông dụng
    dictionary.put("book",        "Quyển sách");
    dictionary.put("pen",         "Bút mực");
    dictionary.put("pencil",      "Bút chì");
    dictionary.put("computer",    "Máy tính");
    dictionary.put("phone",       "Điện thoại");
    dictionary.put("table",       "Cái bàn");
    dictionary.put("chair",       "Cái ghế");
    dictionary.put("house",       "Ngôi nhà");
    dictionary.put("door",        "Cánh cửa");
    dictionary.put("window",      "Cửa sổ");
    dictionary.put("bag",         "Cái túi");
    dictionary.put("key",         "Chìa khóa");

    // Thiên nhiên
    dictionary.put("water",       "Nước");
    dictionary.put("fire",        "Lửa");
    dictionary.put("sun",         "Mặt trời");
    dictionary.put("moon",        "Mặt trăng");
    dictionary.put("star",        "Ngôi sao");
    dictionary.put("sky",         "Bầu trời");
    dictionary.put("tree",        "Cái cây");
    dictionary.put("flower",      "Hoa");
    dictionary.put("rain",        "Mưa");
    dictionary.put("wind",        "Gió");

    // Động vật
    dictionary.put("cat",         "Con mèo");
    dictionary.put("dog",         "Con chó");
    dictionary.put("bird",        "Con chim");
    dictionary.put("fish",        "Con cá");
    dictionary.put("rabbit",      "Con thỏ");
    dictionary.put("horse",       "Con ngựa");

    // Tính từ & trạng thái
    dictionary.put("happy",       "Vui vẻ / Hạnh phúc");
    dictionary.put("sad",         "Buồn");
    dictionary.put("good",        "Tốt / Giỏi");
    dictionary.put("bad",         "Xấu / Tệ");
    dictionary.put("beautiful",   "Đẹp");
    dictionary.put("ugly",        "Xấu xí");
    dictionary.put("big",         "To / Lớn");
    dictionary.put("small",       "Nhỏ");
    dictionary.put("fast",        "Nhanh");
    dictionary.put("slow",        "Chậm");
    dictionary.put("hot",         "Nóng");
    dictionary.put("cold",        "Lạnh");
    dictionary.put("new",         "Mới");
    dictionary.put("old",         "Cũ / Già");

    /* ================================================================
     *  BƯỚC 2: Nhận từ khóa từ request (POST parameter "search")
     *          Xử lý null-safe và chuẩn hóa (trim + lowercase)
     * ================================================================ */
    request.setCharacterEncoding("UTF-8");

    String keyword    = request.getParameter("search");
    String rawKeyword = "";   // từ gốc người dùng nhập (để hiển thị lại)
    String result     = null; // kết quả tra cứu
    boolean searched  = false;

    if (keyword != null && !keyword.trim().isEmpty()) {
        rawKeyword = keyword.trim();
        searched   = true;
        String normalizedKey = rawKeyword.toLowerCase();
        result = dictionary.get(normalizedKey);
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <%
            if (searched) {
                out.print("Kết quả: " + rawKeyword + " | Từ Điển JSP");
            } else {
                out.print("Từ Điển Anh - Việt | JSP Dictionary");
            }
        %>
    </title>
    <meta name="description" content="Kết quả tra cứu từ điển Anh - Việt.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* ======= CSS Reset & Variables ======= */
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        :root {
            --color-bg-dark:       #0d1117;
            --color-bg-card:       #161b22;
            --color-bg-card-hover: #1c2333;
            --color-border:        rgba(255, 255, 255, 0.08);
            --color-border-found:  rgba(86, 211, 100, 0.35);
            --color-border-miss:   rgba(252, 129, 74, 0.35);
            --color-border-glow:   rgba(99, 179, 237, 0.4);
            --color-primary:       #63b3ed;
            --color-primary-dark:  #3182ce;
            --color-accent:        #9f7aea;
            --color-success:       #56d364;
            --color-warning:       #fc814a;
            --color-text-main:     #e6edf3;
            --color-text-muted:    #7d8590;
            --color-text-hint:     #484f58;
            --gradient-hero:       linear-gradient(135deg, #1a1f35 0%, #0d1117 50%, #1a1230 100%);
            --gradient-btn:        linear-gradient(135deg, #3182ce, #6b46c1);
            --gradient-btn-hover:  linear-gradient(135deg, #2b6cb0, #553c9a);
            --gradient-found:      linear-gradient(135deg, rgba(86,211,100,0.08), rgba(72,187,120,0.04));
            --gradient-miss:       linear-gradient(135deg, rgba(252,129,74,0.08), rgba(237,100,75,0.04));
            --shadow-card:         0 8px 32px rgba(0, 0, 0, 0.4);
            --shadow-glow-success: 0 0 32px rgba(86, 211, 100, 0.12);
            --shadow-glow-miss:    0 0 32px rgba(252, 129, 74, 0.12);
            --radius-card:         16px;
            --radius-input:        10px;
            --radius-result:       20px;
            --transition-fast:     0.2s ease;
            --transition-smooth:   0.35s cubic-bezier(0.4, 0, 0.2, 1);
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: var(--gradient-hero);
            min-height: 100vh;
            color: var(--color-text-main);
            line-height: 1.6;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px 60px;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: -200px; left: -200px;
            width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(99, 179, 237, 0.06) 0%, transparent 70%);
            pointer-events: none; z-index: 0;
        }

        body::after {
            content: '';
            position: fixed;
            bottom: -200px; right: -200px;
            width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(159, 122, 234, 0.06) 0%, transparent 70%);
            pointer-events: none; z-index: 0;
        }

        /* ======= Container ======= */
        .container {
            width: 100%;
            max-width: 680px;
            position: relative;
            z-index: 1;
        }

        /* ======= Nav / Back Button ======= */
        .nav-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 36px;
            animation: fadeInDown 0.6s ease forwards;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 18px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--color-border);
            border-radius: 100px;
            color: var(--color-text-muted);
            font-family: inherit;
            font-size: 0.875rem;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: border-color var(--transition-fast), color var(--transition-fast), background var(--transition-fast);
        }

        .btn-back:hover {
            border-color: var(--color-primary);
            color: var(--color-primary);
            background: rgba(99, 179, 237, 0.06);
        }

        .nav-brand {
            font-size: 0.8rem;
            font-weight: 600;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--color-text-hint);
        }

        /* ======= Result Card ======= */
        .result-card {
            border-radius: var(--radius-card);
            padding: 40px;
            box-shadow: var(--shadow-card);
            border: 1px solid;
            animation: scaleIn 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) 0.1s both;
            margin-bottom: 24px;
        }

        .result-card.found {
            background: var(--gradient-found), var(--color-bg-card);
            border-color: var(--color-border-found);
            box-shadow: var(--shadow-card), var(--shadow-glow-success);
        }

        .result-card.not-found {
            background: var(--gradient-miss), var(--color-bg-card);
            border-color: var(--color-border-miss);
            box-shadow: var(--shadow-card), var(--shadow-glow-miss);
        }

        .result-card.empty {
            background: var(--color-bg-card);
            border-color: var(--color-border);
            box-shadow: var(--shadow-card);
        }

        /* ======= Result - Found State ======= */
        .result-status {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 28px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 5px 14px;
            border-radius: 100px;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .status-badge.found {
            background: rgba(86, 211, 100, 0.12);
            border: 1px solid rgba(86, 211, 100, 0.3);
            color: var(--color-success);
        }

        .status-badge.not-found {
            background: rgba(252, 129, 74, 0.12);
            border: 1px solid rgba(252, 129, 74, 0.3);
            color: var(--color-warning);
        }

        .keyword-block {
            text-align: center;
            margin-bottom: 24px;
        }

        .keyword-label {
            font-size: 0.78rem;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--color-text-hint);
            margin-bottom: 8px;
        }

        .keyword-text {
            font-size: clamp(1.8rem, 4vw, 2.8rem);
            font-weight: 800;
            letter-spacing: -0.02em;
            color: var(--color-text-main);
            line-height: 1.2;
        }

        .divider {
            width: 48px;
            height: 2px;
            margin: 24px auto;
            border-radius: 2px;
        }

        .divider.found  { background: linear-gradient(90deg, var(--color-success), transparent); }
        .divider.not-found { background: linear-gradient(90deg, var(--color-warning), transparent); }

        .meaning-label {
            font-size: 0.78rem;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--color-text-hint);
            margin-bottom: 12px;
            text-align: center;
        }

        .meaning-text {
            font-size: clamp(1.5rem, 3.5vw, 2.2rem);
            font-weight: 700;
            text-align: center;
            line-height: 1.25;
            background: linear-gradient(135deg, #56d364, #48bb78);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        /* ======= Not Found State ======= */
        .not-found-icon {
            font-size: 3.5rem;
            text-align: center;
            margin-bottom: 16px;
            display: block;
            animation: shake 0.6s ease 0.3s both;
        }

        .not-found-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--color-warning);
            text-align: center;
            margin-bottom: 10px;
        }

        .not-found-msg {
            text-align: center;
            color: var(--color-text-muted);
            font-size: 0.95rem;
            line-height: 1.6;
        }

        .not-found-keyword {
            color: var(--color-text-main);
            font-weight: 600;
            font-style: italic;
        }

        /* ======= Empty State ======= */
        .empty-icon {
            font-size: 3rem;
            text-align: center;
            margin-bottom: 16px;
            display: block;
        }

        .empty-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--color-text-muted);
            text-align: center;
            margin-bottom: 10px;
        }

        .empty-msg {
            text-align: center;
            color: var(--color-text-hint);
            font-size: 0.9rem;
        }

        /* ======= Search Again Form ======= */
        .search-again-card {
            background: var(--color-bg-card);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-card);
            padding: 28px 32px;
            animation: fadeInUp 0.6s ease 0.3s both;
        }

        .search-again-title {
            font-size: 0.78rem;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--color-text-hint);
            margin-bottom: 16px;
        }

        .search-again-form {
            display: flex;
            gap: 10px;
        }

        .search-again-input {
            flex: 1;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.04);
            border: 1.5px solid var(--color-border);
            border-radius: var(--radius-input);
            color: var(--color-text-main);
            font-family: inherit;
            font-size: 0.95rem;
            outline: none;
            transition: border-color var(--transition-fast), box-shadow var(--transition-fast);
        }

        .search-again-input::placeholder { color: var(--color-text-hint); }

        .search-again-input:focus {
            border-color: var(--color-primary);
            box-shadow: 0 0 0 3px rgba(99, 179, 237, 0.12);
        }

        .btn-search-again {
            padding: 12px 20px;
            background: var(--gradient-btn);
            border: none;
            border-radius: var(--radius-input);
            color: #fff;
            font-family: inherit;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
            transition: transform var(--transition-fast), box-shadow var(--transition-fast);
        }

        .btn-search-again:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(49, 130, 206, 0.3);
        }

        /* ======= Footer ======= */
        .footer {
            margin-top: 40px;
            text-align: center;
            color: var(--color-text-hint);
            font-size: 0.8rem;
            animation: fadeInUp 0.6s ease 0.45s both;
        }

        /* ======= Animations ======= */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @keyframes scaleIn {
            from { opacity: 0; transform: scale(0.92); }
            to   { opacity: 1; transform: scale(1); }
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%       { transform: translateX(-8px); }
            40%       { transform: translateX(8px); }
            60%       { transform: translateX(-5px); }
            80%       { transform: translateX(5px); }
        }

        /* ======= Responsive ======= */
        @media (max-width: 480px) {
            .result-card, .search-again-card { padding: 24px 20px; }
            .search-again-form { flex-direction: column; }
            .btn-search-again  { width: 100%; text-align: center; }
        }
    </style>
</head>
<body>

<div class="container">

    <!-- ===== Navigation Bar ===== -->
    <nav class="nav-bar" aria-label="Điều hướng">
        <a href="index.jsp" class="btn-back" id="btn-back" aria-label="Quay lại trang chủ">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round"
                 stroke-linejoin="round" width="16" height="16">
                <line x1="19" y1="12" x2="5" y2="12"/>
                <polyline points="12 19 5 12 12 5"/>
            </svg>
            Trang chủ
        </a>
        <span class="nav-brand">📖 JSP Dictionary</span>
    </nav>

    <!-- ===== Result Section ===== -->
    <main id="result-section">

        <%
        /* ================================================================
         *  BƯỚC 3: Hiển thị kết quả dựa trên trạng thái tra cứu
         * ================================================================ */
        if (!searched) {
            // Trường hợp truy cập trực tiếp không có từ khóa
        %>
        <div class="result-card empty" role="region" aria-label="Hướng dẫn sử dụng">
            <span class="empty-icon" role="img" aria-label="Sách">📚</span>
            <h1 class="empty-title">Chưa có từ khóa</h1>
            <p class="empty-msg">Vui lòng nhập một từ tiếng Anh từ trang chủ để tra cứu nghĩa tiếng Việt.</p>
        </div>
        <%
        } else if (result != null) {
            // Trường hợp TÌM THẤY từ trong từ điển
        %>
        <div class="result-card found" role="region" aria-label="Kết quả tìm kiếm - Tìm thấy">

            <div class="result-status">
                <span class="status-badge found">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                         stroke-linejoin="round" width="12" height="12">
                        <polyline points="20 6 9 17 4 12"/>
                    </svg>
                    Tìm thấy
                </span>
            </div>

            <div class="keyword-block">
                <p class="keyword-label">Từ tiếng Anh</p>
                <h1 class="keyword-text"><%= rawKeyword %></h1>
            </div>

            <div class="divider found"></div>

            <div>
                <p class="meaning-label">Nghĩa tiếng Việt</p>
                <p class="meaning-text"><%= result %></p>
            </div>

        </div>
        <%
        } else {
            // Trường hợp KHÔNG TÌM THẤY từ trong từ điển
        %>
        <div class="result-card not-found" role="region" aria-label="Kết quả tìm kiếm - Không tìm thấy">

            <div class="result-status">
                <span class="status-badge not-found">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                         stroke-linejoin="round" width="12" height="12">
                        <line x1="18" y1="6" x2="6" y2="18"/>
                        <line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                    Không tìm thấy
                </span>
            </div>

            <span class="not-found-icon" role="img" aria-label="Không tìm thấy">🔍</span>
            <h1 class="not-found-title">Không tìm thấy kết quả</h1>
            <p class="not-found-msg">
                Từ &ldquo;<span class="not-found-keyword"><%= rawKeyword %></span>&rdquo;
                chưa có trong từ điển.<br>
                Hãy thử với một từ khác hoặc kiểm tra lại chính tả.
            </p>

        </div>
        <% } %>

    </main>

    <!-- ===== Search Again ===== -->
    <section class="search-again-card" aria-label="Tìm kiếm lại">
        <p class="search-again-title">🔍 &nbsp;Tìm kiếm từ khác</p>
        <form id="search-again-form" action="dictionary.jsp" method="POST" class="search-again-form">
            <input
                type="text"
                id="search-again-input"
                name="search"
                class="search-again-input"
                placeholder="Nhập từ tiếng Anh..."
                autocomplete="off"
                spellcheck="false"
                <%
                    // Pre-fill ô tìm kiếm nếu đã có từ khóa trước đó
                    if (searched) {
                %>
                value="<%= rawKeyword %>"
                <%
                    }
                %>
            />
            <button type="submit" id="btn-search-again" class="btn-search-again">Tìm kiếm</button>
        </form>
    </section>

    <!-- ===== Footer ===== -->
    <footer class="footer">
        <p>Được xây dựng với ❤️ bằng <strong>JSP thuần túy</strong> &bull; Tương thích Tomcat 10.1+</p>
    </footer>

</div>

</body>
</html>
