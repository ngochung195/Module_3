<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Từ Điển Anh - Việt | JSP Dictionary</title>
    <meta name="description" content="Tra cứu từ vựng Anh - Việt nhanh chóng và chính xác với ứng dụng JSP Dictionary.">
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
            --color-border-glow:   rgba(99, 179, 237, 0.4);
            --color-primary:       #63b3ed;
            --color-primary-dark:  #3182ce;
            --color-accent:        #9f7aea;
            --color-text-main:     #e6edf3;
            --color-text-muted:    #7d8590;
            --color-text-hint:     #484f58;
            --color-success:       #56d364;
            --gradient-hero:       linear-gradient(135deg, #1a1f35 0%, #0d1117 50%, #1a1230 100%);
            --gradient-btn:        linear-gradient(135deg, #3182ce, #6b46c1);
            --gradient-btn-hover:  linear-gradient(135deg, #2b6cb0, #553c9a);
            --shadow-card:         0 8px 32px rgba(0, 0, 0, 0.4);
            --shadow-glow:         0 0 24px rgba(99, 179, 237, 0.15);
            --radius-card:         16px;
            --radius-input:        10px;
            --transition-fast:     0.2s ease;
            --transition-smooth:   0.35s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* ======= Base Styles ======= */
        html {
            scroll-behavior: smooth;
        }

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

        /* ======= Background Decoration ======= */
        body::before {
            content: '';
            position: fixed;
            top: -200px;
            left: -200px;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(99, 179, 237, 0.06) 0%, transparent 70%);
            pointer-events: none;
            z-index: 0;
        }

        body::after {
            content: '';
            position: fixed;
            bottom: -200px;
            right: -200px;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(159, 122, 234, 0.06) 0%, transparent 70%);
            pointer-events: none;
            z-index: 0;
        }

        /* ======= Main Container ======= */
        .container {
            width: 100%;
            max-width: 680px;
            position: relative;
            z-index: 1;
        }

        /* ======= Header / Hero Section ======= */
        .hero {
            text-align: center;
            margin-bottom: 48px;
            animation: fadeInDown 0.7s ease forwards;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(99, 179, 237, 0.1);
            border: 1px solid rgba(99, 179, 237, 0.25);
            color: var(--color-primary);
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            padding: 6px 16px;
            border-radius: 100px;
            margin-bottom: 24px;
        }

        .hero-badge span.dot {
            width: 6px;
            height: 6px;
            background: var(--color-primary);
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        .hero h1 {
            font-size: clamp(2rem, 5vw, 3.2rem);
            font-weight: 800;
            line-height: 1.15;
            letter-spacing: -0.03em;
            background: linear-gradient(135deg, #e6edf3 30%, #63b3ed 70%, #9f7aea 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 14px;
        }

        .hero p {
            font-size: 1rem;
            color: var(--color-text-muted);
            max-width: 420px;
            margin: 0 auto;
            font-weight: 400;
        }

        /* ======= Search Card ======= */
        .search-card {
            background: var(--color-bg-card);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-card);
            padding: 40px;
            box-shadow: var(--shadow-card);
            transition: box-shadow var(--transition-smooth), border-color var(--transition-smooth);
            animation: fadeInUp 0.7s ease 0.15s both;
        }

        .search-card:hover {
            box-shadow: var(--shadow-card), var(--shadow-glow);
            border-color: var(--color-border-glow);
        }

        .search-card-title {
            font-size: 0.8rem;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--color-text-hint);
            margin-bottom: 24px;
        }

        /* ======= Form Styles ======= */
        .search-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .input-group {
            position: relative;
        }

        .input-label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--color-text-muted);
            margin-bottom: 10px;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            color: var(--color-text-hint);
            font-size: 18px;
            pointer-events: none;
            transition: color var(--transition-fast);
        }

        #search-input {
            width: 100%;
            padding: 14px 16px 14px 48px;
            background: rgba(255, 255, 255, 0.04);
            border: 1.5px solid var(--color-border);
            border-radius: var(--radius-input);
            color: var(--color-text-main);
            font-family: inherit;
            font-size: 1rem;
            font-weight: 500;
            outline: none;
            transition: border-color var(--transition-fast), background var(--transition-fast), box-shadow var(--transition-fast);
            -webkit-appearance: none;
        }

        #search-input::placeholder {
            color: var(--color-text-hint);
            font-weight: 400;
        }

        #search-input:focus {
            border-color: var(--color-primary);
            background: rgba(99, 179, 237, 0.05);
            box-shadow: 0 0 0 3px rgba(99, 179, 237, 0.12);
        }

        #search-input:focus ~ .input-icon,
        .input-wrapper:focus-within .input-icon {
            color: var(--color-primary);
        }

        /* ======= Submit Button ======= */
        .btn-search {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 14px 24px;
            background: var(--gradient-btn);
            border: none;
            border-radius: var(--radius-input);
            color: #fff;
            font-family: inherit;
            font-size: 1rem;
            font-weight: 600;
            letter-spacing: 0.02em;
            cursor: pointer;
            transition: background var(--transition-fast), transform var(--transition-fast), box-shadow var(--transition-fast);
            position: relative;
            overflow: hidden;
        }

        .btn-search::before {
            content: '';
            position: absolute;
            inset: 0;
            background: rgba(255, 255, 255, 0);
            transition: background var(--transition-fast);
        }

        .btn-search:hover {
            background: var(--gradient-btn-hover);
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(49, 130, 206, 0.35);
        }

        .btn-search:hover::before {
            background: rgba(255, 255, 255, 0.05);
        }

        .btn-search:active {
            transform: translateY(0);
            box-shadow: none;
        }

        .btn-icon {
            font-size: 16px;
            transition: transform var(--transition-fast);
        }

        .btn-search:hover .btn-icon {
            transform: translateX(4px);
        }

        /* ======= Hint Section ======= */
        .hint-section {
            margin-top: 32px;
            animation: fadeInUp 0.7s ease 0.3s both;
        }

        .hint-title {
            font-size: 0.78rem;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--color-text-hint);
            margin-bottom: 14px;
        }

        .hint-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .hint-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--color-border);
            border-radius: 100px;
            font-size: 0.82rem;
            color: var(--color-text-muted);
            cursor: pointer;
            transition: border-color var(--transition-fast), color var(--transition-fast), background var(--transition-fast);
            text-decoration: none;
        }

        .hint-chip:hover {
            border-color: var(--color-primary);
            color: var(--color-primary);
            background: rgba(99, 179, 237, 0.06);
        }

        /* ======= Footer ======= */
        .footer {
            margin-top: 48px;
            text-align: center;
            color: var(--color-text-hint);
            font-size: 0.8rem;
            animation: fadeInUp 0.7s ease 0.45s both;
        }

        .footer a {
            color: var(--color-text-muted);
            text-decoration: none;
            transition: color var(--transition-fast);
        }

        .footer a:hover {
            color: var(--color-primary);
        }

        /* ======= Animations ======= */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-24px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(24px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50%       { opacity: 0.5; transform: scale(0.85); }
        }

        /* ======= Responsive ======= */
        @media (max-width: 480px) {
            .search-card { padding: 28px 24px; }
        }
    </style>
</head>
<body>

<div class="container">

    <!-- ===== Hero Header ===== -->
    <header class="hero">
        <div class="hero-badge">
            <span class="dot"></span>
            Từ Điển Anh &mdash; Việt
        </div>
        <h1>JSP Dictionary</h1>
        <p>Tra cứu nghĩa tiếng Việt của từ tiếng Anh một cách nhanh chóng và chính xác.</p>
    </header>

    <!-- ===== Search Card ===== -->
    <main>
        <div class="search-card">
            <p class="search-card-title">🔍 &nbsp;Nhập từ cần tra cứu</p>

            <form id="search-form" action="dictionary.jsp" method="POST" class="search-form">
                <div class="input-group">
                    <label for="search-input" class="input-label">Từ tiếng Anh</label>
                    <div class="input-wrapper">
                        <svg class="input-icon" xmlns="http://www.w3.org/2000/svg"
                             viewBox="0 0 24 24" fill="none" stroke="currentColor"
                             stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                             width="18" height="18">
                            <circle cx="11" cy="11" r="8"/>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                        </svg>
                        <input
                            type="text"
                            id="search-input"
                            name="search"
                            placeholder="Ví dụ: hello, book, computer..."
                            autocomplete="off"
                            spellcheck="false"
                            autofocus
                        />
                    </div>
                </div>

                <button type="submit" id="btn-submit" class="btn-search">
                    <span>Tìm kiếm</span>
                    <svg class="btn-icon" xmlns="http://www.w3.org/2000/svg"
                         viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
                         width="16" height="16">
                        <line x1="5" y1="12" x2="19" y2="12"/>
                        <polyline points="12 5 19 12 12 19"/>
                    </svg>
                </button>
            </form>
        </div>

        <!-- ===== Quick Search Hints ===== -->
        <section class="hint-section" aria-label="Gợi ý từ phổ biến">
            <p class="hint-title">💡 &nbsp;Từ phổ biến</p>
            <div class="hint-list">
                <a href="#" class="hint-chip" onclick="fillSearch('hello')">hello</a>
                <a href="#" class="hint-chip" onclick="fillSearch('book')">book</a>
                <a href="#" class="hint-chip" onclick="fillSearch('computer')">computer</a>
                <a href="#" class="hint-chip" onclick="fillSearch('water')">water</a>
                <a href="#" class="hint-chip" onclick="fillSearch('house')">house</a>
                <a href="#" class="hint-chip" onclick="fillSearch('cat')">cat</a>
                <a href="#" class="hint-chip" onclick="fillSearch('sun')">sun</a>
                <a href="#" class="hint-chip" onclick="fillSearch('happy')">happy</a>
            </div>
        </section>
    </main>

    <!-- ===== Footer ===== -->
    <footer class="footer">
        <p>Được xây dựng với ❤️ bằng <strong>JSP thuần túy</strong> &bull; Tương thích Tomcat 10.1+</p>
    </footer>

</div>

<script>
    // Điền từ gợi ý vào ô tìm kiếm và tự động submit
    function fillSearch(word) {
        event.preventDefault();
        var input = document.getElementById('search-input');
        input.value = word;
        input.focus();
        // Tự động submit sau 300ms để người dùng thấy từ được điền
        setTimeout(function() {
            document.getElementById('search-form').submit();
        }, 300);
    }
</script>

</body>
</html>
