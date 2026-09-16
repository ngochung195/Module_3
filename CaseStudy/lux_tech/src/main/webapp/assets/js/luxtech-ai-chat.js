/**
 * LuxTech AI Chatbox Client Script
 * Powered by Google Gemini 3.5 Flash Backend Service
 */
(function () {
    'use strict';

    document.addEventListener('DOMContentLoaded', function () {
        const root = document.getElementById('luxtech-ai-chat-root');
        if (!root) return;

        const contextPath = root.getAttribute('data-context-path') || '';
        const launcherBtn = document.getElementById('luxtech-ai-launcher');
        const chatWindow = document.getElementById('luxtech-ai-window');
        const closeBtn = document.getElementById('luxtech-ai-close-btn');
        const clearBtn = document.getElementById('luxtech-ai-clear-btn');
        const messagesContainer = document.getElementById('luxtech-ai-messages');
        const typingIndicator = document.getElementById('luxtech-ai-typing');
        const chatForm = document.getElementById('luxtech-ai-form');
        const chatInput = document.getElementById('luxtech-ai-input');
        const sendBtn = document.getElementById('luxtech-ai-send-btn');
        const quickChips = document.getElementById('luxtech-ai-chips');
        const productContextBanner = document.getElementById('luxtech-ai-product-context');
        const productContextName = document.getElementById('luxtech-context-product-name');

        let chatHistory = [];
        let isWaitingResponse = false;
        let currentProductId = null;

        // 1. Phát hiện ngữ cảnh sản phẩm hiện tại từ URL hoặc DOM
        detectProductContext();

        // 2. Event Listeners mở/đóng widget
        if (launcherBtn && chatWindow) {
            launcherBtn.addEventListener('click', function () {
                const isOpen = chatWindow.classList.contains('active');
                toggleChatWindow(!isOpen);
            });
        }

        if (closeBtn) {
            closeBtn.addEventListener('click', function () {
                toggleChatWindow(false);
            });
        }

        // Đóng bằng phím ESC
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && chatWindow && chatWindow.classList.contains('active')) {
                toggleChatWindow(false);
            }
        });

        // Xóa lịch sử hội thoại
        if (clearBtn) {
            clearBtn.addEventListener('click', function () {
                if (confirm('Bạn có muốn xóa toàn bộ lịch sử trò chuyện với AI không?')) {
                    resetConversation();
                }
            });
        }

        // Input change listener để bật/tắt nút gửi
        if (chatInput && sendBtn) {
            chatInput.addEventListener('input', function () {
                const val = chatInput.value.trim();
                sendBtn.disabled = val.length === 0 || isWaitingResponse;
            });
        }

        // Quick Suggestion Chips
        if (quickChips) {
            quickChips.addEventListener('click', function (e) {
                const chip = e.target.closest('.quick-chip, .chip-item');
                if (!chip || isWaitingResponse) return;

                const promptText = chip.getAttribute('data-prompt');
                if (promptText) {
                    sendMessage(promptText);
                }
            });
        }

        // Submit Form
        if (chatForm) {
            chatForm.addEventListener('submit', function (e) {
                e.preventDefault();
                if (isWaitingResponse) return;

                const message = chatInput.value.trim();
                if (message) {
                    sendMessage(message);
                    chatInput.value = '';
                    sendBtn.disabled = true;
                }
            });
        }

        function toggleChatWindow(show) {
            if (!chatWindow) return;
            const robotIcon = launcherBtn ? launcherBtn.querySelector('.launcher-icon-robot') : null;
            const closeIcon = launcherBtn ? launcherBtn.querySelector('.launcher-icon-close') : null;

            if (show) {
                chatWindow.classList.add('active');
                if (robotIcon) robotIcon.style.display = 'none';
                if (closeIcon) closeIcon.style.display = 'block';
                setTimeout(function () {
                    if (chatInput) chatInput.focus();
                    scrollToBottom();
                }, 150);
            } else {
                chatWindow.classList.remove('active');
                if (robotIcon) robotIcon.style.display = 'block';
                if (closeIcon) closeIcon.style.display = 'none';
            }
        }

        function detectProductContext() {
            try {
                const urlParams = new URLSearchParams(window.location.search);
                const action = urlParams.get('action');
                const id = urlParams.get('id');

                if (action === 'detail' && id) {
                    currentProductId = parseInt(id, 10);
                    // Lấy tên sản phẩm trên trang nếu có
                    const titleEl = document.querySelector('.detail-name') || document.querySelector('h1');
                    const prodName = titleEl ? titleEl.textContent.trim() : 'Sản phẩm #' + id;

                    if (productContextBanner && productContextName) {
                        productContextName.textContent = prodName;
                        productContextBanner.style.display = 'block';

                        // Thêm chip câu hỏi nhanh về sản phẩm đang xem
                        if (quickChips) {
                            const wrapper = quickChips.querySelector('.chips-wrapper');
                            if (wrapper && !document.getElementById('chip-current-product')) {
                                const prodChip = document.createElement('button');
                                prodChip.type = 'button';
                                prodChip.id = 'chip-current-product';
                                prodChip.className = 'chip-item chip-highlight';
                                prodChip.setAttribute('data-prompt', 'Sản phẩm này có ưu điểm gì nổi bật và phù hợp với ai?');
                                prodChip.innerHTML = '✨ Tư vấn sản phẩm đang xem';
                                wrapper.prepend(prodChip);
                            }
                        }
                    }
                }
            } catch (err) {
                console.error('[LuxTech AI] Error detecting product context:', err);
            }
        }

        function sendMessage(text) {
            if (!text || text.trim().length === 0 || isWaitingResponse) return;

            const trimmedText = text.trim();

            // 1. Render tin nhắn của User
            appendMessage('user', trimmedText);

            // 2. Cập nhật lịch sử
            chatHistory.push({ role: 'user', content: trimmedText });
            if (chatHistory.length > 10) {
                chatHistory.shift();
            }

            // 3. Hiển thị typing indicator & disable form
            setLoadingState(true);

            // 4. Gửi Request tới POST /chat
            const payload = {
                message: trimmedText,
                currentProductId: currentProductId,
                history: chatHistory
            };

            const endpoint = contextPath + '/chat';

            fetch(endpoint, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(payload)
            })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('Server returned status ' + response.status);
                }
                return response.json();
            })
            .then(function (data) {
                setLoadingState(false);
                if (data && data.success) {
                    const aiReply = data.message || 'Xin lỗi, tôi chưa hiểu rõ câu hỏi của bạn.';
                    appendMessage('ai', aiReply);
                    chatHistory.push({ role: 'model', content: aiReply });
                    if (chatHistory.length > 10) {
                        chatHistory.shift();
                    }
                } else {
                    const errMsg = (data && data.message) ? data.message : 'Xin lỗi, hiện tại AI chưa thể trả lời. Vui lòng thử lại sau.';
                    appendMessage('ai', errMsg);
                }
            })
            .catch(function (error) {
                console.error('[LuxTech AI] Lỗi gửi tin nhắn:', error);
                setLoadingState(false);
                appendMessage('ai', 'Xin lỗi, kết nối tới trợ lý AI bị gián đoạn. Vui lòng kiểm tra mạng và thử lại sau.');
            });
        }

        function appendMessage(sender, text) {
            if (!messagesContainer) return;

            const bubbleWrap = document.createElement('div');
            bubbleWrap.className = 'msg-row ' + (sender === 'user' ? 'msg-user' : 'msg-ai');

            if (sender === 'ai') {
                const avatar = document.createElement('div');
                avatar.className = 'msg-avatar';
                avatar.innerHTML = '<i class="bi bi-robot"></i>';
                bubbleWrap.appendChild(avatar);
            }

            const contentDiv = document.createElement('div');
            contentDiv.className = 'msg-bubble';

            if (sender === 'ai') {
                contentDiv.innerHTML = formatMarkdown(text);
            } else {
                contentDiv.textContent = text;
            }

            bubbleWrap.appendChild(contentDiv);
            messagesContainer.appendChild(bubbleWrap);
            scrollToBottom();
        }

        function setLoadingState(loading) {
            isWaitingResponse = loading;
            if (typingIndicator) {
                if (loading) {
                    typingIndicator.classList.add('active');
                } else {
                    typingIndicator.classList.remove('active');
                }
            }
            if (sendBtn) {
                sendBtn.disabled = loading || (chatInput && chatInput.value.trim().length === 0);
            }
            if (chatInput) {
                chatInput.disabled = loading;
                if (!loading) {
                    chatInput.focus();
                }
            }
            scrollToBottom();
        }

        function scrollToBottom() {
            if (messagesContainer) {
                setTimeout(function () {
                    messagesContainer.scrollTop = messagesContainer.scrollHeight;
                }, 50);
            }
        }

        function resetConversation() {
            chatHistory = [];
            if (messagesContainer) {
                messagesContainer.innerHTML = `
                    <div class="msg-row msg-ai">
                        <div class="msg-avatar">
                            <i class="bi bi-robot"></i>
                        </div>
                        <div class="msg-bubble">
                            <p class="mb-1">Xin chào! 👋 Tôi là <strong>LuxTech AI</strong> – trợ lý thông minh của LuxTech Store.</p>
                            <p class="mb-0">Tôi có thể tư vấn laptop, điện thoại, phụ kiện phù hợp hoặc giải đáp thắc mắc của bạn. Bạn cần tìm sản phẩm gì?</p>
                        </div>
                    </div>
                `;
            }
            if (chatInput) {
                chatInput.value = '';
                chatInput.disabled = false;
                chatInput.focus();
            }
            if (sendBtn) {
                sendBtn.disabled = true;
            }
            isWaitingResponse = false;
            if (typingIndicator) typingIndicator.classList.remove('active');
        }

        /**
         * Chuyển đổi cú pháp Markdown cơ bản thành HTML an toàn
         */
        function formatMarkdown(rawText) {
            if (!rawText) return '';

            // Escape HTML cơ bản để ngăn XSS
            let safe = rawText
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;');

            // In đậm **text**
            safe = safe.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');

            // In nghiêng *text*
            safe = safe.replace(/\*(.*?)\*/g, '<em>$1</em>');

            // Danh sách gạch đầu dòng: - item hoặc * item
            const lines = safe.split('\n');
            let formattedLines = [];
            let inList = false;

            for (let i = 0; i < lines.length; i++) {
                let line = lines[i].trim();
                if (line.startsWith('- ') || line.startsWith('* ')) {
                    if (!inList) {
                        formattedLines.push('<ul class="chat-list">');
                        inList = true;
                    }
                    formattedLines.push('<li>' + line.substring(2) + '</li>');
                } else {
                    if (inList) {
                        formattedLines.push('</ul>');
                        inList = false;
                    }
                    if (line.length > 0) {
                        formattedLines.push('<p class="mb-1">' + line + '</p>');
                    }
                }
            }
            if (inList) {
                formattedLines.push('</ul>');
            }

            return formattedLines.join('');
        }
    });
})();
