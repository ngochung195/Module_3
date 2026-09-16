<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- LuxTech AI Chatbox Widget (Floating Messenger Style) --%>
<div id="luxtech-ai-chat-root" data-context-path="${pageContext.request.contextPath}">

    <!-- Floating Circular Messenger-style Launcher Button -->
    <button id="luxtech-ai-launcher" class="luxtech-ai-circle-launcher shadow-lg" type="button" 
            aria-label="Mở hộp thoại LuxTech AI" title="Trò chuyện với LuxTech AI">
        <div class="launcher-circle-content">
            <i class="bi bi-robot launcher-icon-robot"></i>
            <i class="bi bi-x-lg launcher-icon-close" style="display: none;"></i>
        </div>
        <span class="launcher-online-badge"></span>
        <span class="launcher-circle-pulse"></span>
    </button>

    <!-- AI Chat Window Popup -->
    <div id="luxtech-ai-window" class="luxtech-ai-popup-window shadow-2xl" role="dialog" aria-modal="true" aria-labelledby="luxtech-ai-title">
        
        <!-- Chat Header (Messenger Style) -->
        <div class="chat-header-mes d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center gap-2">
                <div class="ai-header-avatar">
                    <i class="bi bi-robot"></i>
                    <span class="avatar-online-dot"></span>
                </div>
                <div class="header-info">
                    <h6 id="luxtech-ai-title" class="mb-0 fw-bold text-white fs-6">LuxTech AI</h6>
                    <small class="text-white text-opacity-75 d-block" style="font-size: 0.72rem; line-height: 1.1;">Trợ lý tư vấn mua sắm 24/7</small>
                </div>
            </div>
            <div class="d-flex align-items-center gap-1">
                <button type="button" id="luxtech-ai-clear-btn" class="btn btn-sm btn-header-action" title="Xóa lịch sử hội thoại">
                    <i class="bi bi-trash3"></i>
                </button>
                <button type="button" id="luxtech-ai-close-btn" class="btn btn-sm btn-header-action" title="Thu nhỏ">
                    <i class="bi bi-dash-lg fs-6"></i>
                </button>
            </div>
        </div>

        <!-- Current Product Context Banner (Shown on product detail page) -->
        <div id="luxtech-ai-product-context" class="chat-context-banner" style="display: none;">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-info-circle-fill text-orange" style="color: #FF6B00 !important;"></i>
                <div class="text-truncate">
                    <span class="small text-muted">Đang xem:</span>
                    <strong id="luxtech-context-product-name" class="small text-dark fw-bold">Sản phẩm</strong>
                </div>
            </div>
        </div>

        <!-- Chat Message Area -->
        <div id="luxtech-ai-messages" class="chat-messages-body">
            <!-- Welcome Message -->
            <div class="msg-row msg-ai">
                <div class="msg-avatar">
                    <i class="bi bi-robot"></i>
                </div>
                <div class="msg-bubble">
                    <p class="mb-1">Xin chào! 👋 Tôi là <strong>LuxTech AI</strong> – trợ lý thông minh của LuxTech Store.</p>
                    <p class="mb-0">Tôi có thể tư vấn laptop, điện thoại, phụ kiện phù hợp hoặc giải đáp thắc mắc của bạn. Bạn cần tìm sản phẩm gì?</p>
                </div>
            </div>
        </div>

        <!-- Quick Questions Suggestion Chips -->
        <div id="luxtech-ai-chips" class="chat-chips-container">
            <div class="chips-title"><i class="bi bi-stars me-1 text-orange" style="color: #FF6B00;"></i>Gợi ý câu hỏi:</div>
            <div class="chips-scroll">
                <button type="button" class="quick-chip" data-prompt="Laptop nào phù hợp cho sinh viên IT dưới 20 triệu?">
                    💻 Laptop sinh viên IT &lt; 20tr
                </button>
                <button type="button" class="quick-chip" data-prompt="Tư vấn điện thoại chụp ảnh đẹp, pin trâu dưới 10 triệu">
                    📱 Điện thoại &lt; 10 triệu
                </button>
                <button type="button" class="quick-chip" data-prompt="Tư vấn laptop gaming cấu hình mạnh giá tốt">
                    🎮 Laptop Gaming
                </button>
                <button type="button" class="quick-chip" data-prompt="Cửa hàng có tai nghe không dây nào tốt?">
                    🎧 Tai nghe không dây
                </button>
                <button type="button" class="quick-chip" data-prompt="Chính sách bảo hành và giao hàng tại LuxTech thế nào?">
                    🛡️ Chính sách bảo hành
                </button>
            </div>
        </div>

        <!-- Typing Indicator -->
        <div id="luxtech-ai-typing" class="chat-typing-row">
            <div class="msg-avatar">
                <i class="bi bi-robot"></i>
            </div>
            <div class="typing-pill">
                <span class="dot"></span>
                <span class="dot"></span>
                <span class="dot"></span>
                <span class="typing-text ms-2">LuxTech AI đang soạn câu trả lời...</span>
            </div>
        </div>

        <!-- Chat Input Form -->
        <div class="chat-footer-form">
            <form id="luxtech-ai-form" class="d-flex align-items-center gap-2" autocomplete="off">
                <input type="text" id="luxtech-ai-input" class="form-control mes-input" 
                       placeholder="Nhập câu hỏi cho LuxTech AI..." maxlength="1000" aria-label="Nhập câu hỏi cho AI">
                <button type="submit" id="luxtech-ai-send-btn" class="btn mes-send-btn" title="Gửi tin nhắn" disabled>
                    <i class="bi bi-send-fill"></i>
                </button>
            </form>
            <div class="d-flex justify-content-between align-items-center px-1 mt-1">
                <span class="text-muted" style="font-size: 0.68rem;">Nhấn <strong>Enter</strong> để gửi</span>
                <span class="text-muted" style="font-size: 0.68rem;">LuxTech Smart Assistant</span>
            </div>
        </div>

    </div>
</div>

<style>
/* ==========================================================================
   Self-contained Styles for LuxTech Floating Messenger AI Chatbox
   ========================================================================== */

#luxtech-ai-chat-root {
    position: fixed !important;
    bottom: 24px !important;
    right: 24px !important;
    z-index: 999999 !important;
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif !important;
}

/* 1. Messenger Circular Button (Hình tròn nổi góc phải) */
.luxtech-ai-circle-launcher {
    position: fixed !important;
    bottom: 24px !important;
    right: 24px !important;
    width: 60px !important;
    height: 60px !important;
    border-radius: 50% !important;
    background: linear-gradient(135deg, #FF6B00 0%, #FF852E 100%) !important;
    border: 2px solid rgba(255, 255, 255, 0.8) !important;
    box-shadow: 0 8px 25px rgba(255, 107, 0, 0.45), 0 4px 10px rgba(0, 0, 0, 0.15) !important;
    cursor: pointer !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    padding: 0 !important;
    transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275) !important;
    z-index: 999999 !important;
    color: #FFFFFF !important;
}

.luxtech-ai-circle-launcher:hover {
    transform: scale(1.1) !important;
    box-shadow: 0 12px 30px rgba(255, 107, 0, 0.6) !important;
}

.luxtech-ai-circle-launcher:active {
    transform: scale(0.95) !important;
}

.launcher-circle-content {
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    font-size: 1.65rem !important;
    color: #FFFFFF !important;
}

.launcher-online-badge {
    position: absolute !important;
    bottom: 2px !important;
    right: 2px !important;
    width: 14px !important;
    height: 14px !important;
    background: #22C55E !important;
    border: 2px solid #FFFFFF !important;
    border-radius: 50% !important;
}

.launcher-circle-pulse {
    position: absolute !important;
    top: -4px !important;
    left: -4px !important;
    right: -4px !important;
    bottom: -4px !important;
    border-radius: 50% !important;
    border: 2px solid rgba(255, 107, 0, 0.6) !important;
    animation: mesPulse 2.4s infinite !important;
    pointer-events: none !important;
}

@keyframes mesPulse {
    0% { transform: scale(1); opacity: 0.8; }
    50% { transform: scale(1.25); opacity: 0; }
    100% { transform: scale(1); opacity: 0; }
}

/* 2. Messenger Popup Dialog (Hộp thoại tin nhắn) */
.luxtech-ai-popup-window {
    position: fixed !important;
    bottom: 95px !important;
    right: 24px !important;
    width: 380px !important;
    height: 540px !important;
    max-height: calc(100vh - 120px) !important;
    background: #FFFFFF !important;
    border-radius: 20px !important;
    border: 1px solid rgba(0, 0, 0, 0.08) !important;
    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2), 0 4px 15px rgba(255, 107, 0, 0.15) !important;
    display: none !important;
    flex-direction: column !important;
    overflow: hidden !important;
    z-index: 999999 !important;
}

.luxtech-ai-popup-window.active {
    display: flex !important;
    animation: mesSlideIn 0.3s cubic-bezier(0.16, 1, 0.3, 1) forwards !important;
}

@keyframes mesSlideIn {
    0% { opacity: 0; transform: translateY(20px) scale(0.92); }
    100% { opacity: 1; transform: translateY(0) scale(1); }
}

/* Header */
.chat-header-mes {
    background: linear-gradient(135deg, #FF6B00 0%, #FF7A1A 100%) !important;
    padding: 12px 16px !important;
    color: #FFFFFF !important;
    flex-shrink: 0 !important;
}

.ai-header-avatar {
    width: 38px !important;
    height: 38px !important;
    background: #FFFFFF !important;
    color: #FF6B00 !important;
    border-radius: 50% !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    font-size: 1.25rem !important;
    position: relative !important;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15) !important;
}

.avatar-online-dot {
    position: absolute !important;
    bottom: 0 !important;
    right: 0 !important;
    width: 10px !important;
    height: 10px !important;
    background: #22C55E !important;
    border: 2px solid #FFFFFF !important;
    border-radius: 50% !important;
}

.btn-header-action {
    background: rgba(255, 255, 255, 0.18) !important;
    border: none !important;
    color: #FFFFFF !important;
    border-radius: 8px !important;
    width: 30px !important;
    height: 30px !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    padding: 0 !important;
    transition: all 0.2s ease !important;
}

.btn-header-action:hover {
    background: rgba(255, 255, 255, 0.3) !important;
    color: #FFFFFF !important;
}

/* Context Banner */
.chat-context-banner {
    background: #FFF7F0 !important;
    border-bottom: 1px solid rgba(255, 107, 0, 0.2) !important;
    padding: 6px 14px !important;
    flex-shrink: 0 !important;
}

/* Messages Body */
.chat-messages-body {
    flex: 1 !important;
    overflow-y: auto !important;
    padding: 14px !important;
    display: flex !important;
    flex-direction: column !important;
    gap: 10px !important;
    background: #F8F9FA !important;
    scroll-behavior: smooth !important;
}

.chat-messages-body::-webkit-scrollbar {
    width: 5px !important;
}

.chat-messages-body::-webkit-scrollbar-thumb {
    background: #CBD5E1 !important;
    border-radius: 4px !important;
}

.msg-row {
    display: flex !important;
    gap: 8px !important;
    max-width: 88% !important;
    font-size: 0.885rem !important;
    line-height: 1.45 !important;
}

.msg-ai {
    align-self: flex-start !important;
}

.msg-user {
    align-self: flex-end !important;
    flex-direction: row-reverse !important;
}

.msg-avatar {
    width: 28px !important;
    height: 28px !important;
    background: #FFF7F0 !important;
    border: 1px solid rgba(255, 107, 0, 0.25) !important;
    color: #FF6B00 !important;
    border-radius: 50% !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    font-size: 0.95rem !important;
    flex-shrink: 0 !important;
}

.msg-ai .msg-bubble {
    background: #FFFFFF !important;
    color: #1E293B !important;
    border: 1px solid #E2E8F0 !important;
    border-radius: 4px 16px 16px 16px !important;
    padding: 10px 14px !important;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04) !important;
    word-break: break-word !important;
}

.msg-user .msg-bubble {
    background: #FF6B00 !important;
    color: #FFFFFF !important;
    border-radius: 16px 4px 16px 16px !important;
    padding: 10px 14px !important;
    box-shadow: 0 2px 6px rgba(255, 107, 0, 0.25) !important;
    word-break: break-word !important;
}

/* Suggestion Chips */
.chat-chips-container {
    background: #FFFFFF !important;
    border-top: 1px solid #F1F5F9 !important;
    padding: 6px 12px !important;
    flex-shrink: 0 !important;
}

.chips-title {
    font-size: 0.72rem !important;
    font-weight: 700 !important;
    color: #64748B !important;
    margin-bottom: 4px !important;
}

.chips-scroll {
    display: flex !important;
    gap: 6px !important;
    overflow-x: auto !important;
    padding-bottom: 4px !important;
    scrollbar-width: none !important;
}

.chips-scroll::-webkit-scrollbar {
    display: none !important;
}

.quick-chip {
    background: #F1F5F9 !important;
    border: 1px solid #E2E8F0 !important;
    color: #334155 !important;
    font-size: 0.75rem !important;
    font-weight: 600 !important;
    padding: 4px 10px !important;
    border-radius: 9999px !important;
    white-space: nowrap !important;
    cursor: pointer !important;
    transition: all 0.2s ease !important;
    flex-shrink: 0 !important;
}

.quick-chip:hover {
    background: #FFF7F0 !important;
    border-color: #FF6B00 !important;
    color: #FF6B00 !important;
    transform: translateY(-1px) !important;
}

.quick-chip.chip-highlight {
    background: #FFF7F0 !important;
    border-color: rgba(255, 107, 0, 0.4) !important;
    color: #FF6B00 !important;
}

/* Typing Indicator */
.chat-typing-row {
    display: none !important;
    align-items: center !important;
    gap: 8px !important;
    padding: 4px 14px !important;
    background: #F8F9FA !important;
    flex-shrink: 0 !important;
}

.chat-typing-row.active {
    display: flex !important;
}

.typing-pill {
    background: #FFFFFF !important;
    border: 1px solid #E2E8F0 !important;
    padding: 5px 12px !important;
    border-radius: 12px !important;
    display: flex !important;
    align-items: center !important;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03) !important;
}

.dot {
    width: 5px !important;
    height: 5px !important;
    margin: 0 2px !important;
    background: #FF6B00 !important;
    border-radius: 50% !important;
    animation: typingBounce 1.4s infinite ease-in-out both !important;
}

.dot:nth-child(1) { animation-delay: -0.32s !important; }
.dot:nth-child(2) { animation-delay: -0.16s !important; }

@keyframes typingBounce {
    0%, 80%, 100% { transform: scale(0.4); opacity: 0.4; }
    40% { transform: scale(1); opacity: 1; }
}

.typing-text {
    font-size: 0.72rem !important;
    color: #64748B !important;
}

/* Footer Input Form */
.chat-footer-form {
    background: #FFFFFF !important;
    border-top: 1px solid #E2E8F0 !important;
    padding: 10px 12px !important;
    flex-shrink: 0 !important;
}

.mes-input {
    border-radius: 9999px !important;
    font-size: 0.88rem !important;
    padding: 8px 14px !important;
    border: 1.5px solid #E2E8F0 !important;
    background: #F8F9FA !important;
}

.mes-input:focus {
    border-color: #FF6B00 !important;
    box-shadow: 0 0 0 3px rgba(255, 107, 0, 0.15) !important;
    background: #FFFFFF !important;
}

.mes-send-btn {
    width: 38px !important;
    height: 38px !important;
    border-radius: 50% !important;
    background: #FF6B00 !important;
    border: none !important;
    color: #FFFFFF !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    font-size: 0.95rem !important;
    flex-shrink: 0 !important;
    transition: all 0.2s ease !important;
    box-shadow: 0 2px 6px rgba(255, 107, 0, 0.3) !important;
}

.mes-send-btn:hover:not(:disabled) {
    background: #FF7A1A !important;
    transform: scale(1.06) !important;
}

.mes-send-btn:disabled {
    background: #E2E8F0 !important;
    color: #94A3B8 !important;
    box-shadow: none !important;
    cursor: not-allowed !important;
}

/* Mobile Responsive */
@media (max-width: 576px) {
    .luxtech-ai-circle-launcher {
        bottom: 16px !important;
        right: 16px !important;
        width: 52px !important;
        height: 52px !important;
    }

    .launcher-circle-content {
        font-size: 1.4rem !important;
    }

    .luxtech-ai-popup-window {
        bottom: 78px !important;
        right: 12px !important;
        left: 12px !important;
        width: auto !important;
        height: 72vh !important;
        max-height: 500px !important;
        border-radius: 16px !important;
    }
}
</style>

