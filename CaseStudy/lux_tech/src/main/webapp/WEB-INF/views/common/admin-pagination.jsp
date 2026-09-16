<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
  Admin & Staff Shared Pagination Component – LuxTech Theme
  Expects:
    - pageResult: PageResult<?> object
    - paramUrl: base URL for pagination links (e.g. "${pageContext.request.contextPath}/products?action=search&keyword=${keyword}")
    - paramConnector: "?" or "&" (default calculated if omitted)
--%>

<c:if test="${not empty pageResult and pageResult.totalItems > 0}">
    <c:set var="connector" value="?"/>
    <c:if test="${not empty paramUrl and paramUrl.contains('?')}">
        <c:set var="connector" value="&"/>
    </c:if>
    <c:if test="${not empty paramConnector}">
        <c:set var="connector" value="${paramConnector}"/>
    </c:if>

    <style>
        .luxtech-pagination .page-item {
            margin: 0 2px;
        }
        .luxtech-pagination .page-link {
            min-width: 36px;
            height: 36px;
            padding: 0 0.75rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50rem !important;
            font-size: 0.875rem;
            font-weight: 600;
            border: 1px solid #E5E7EB;
            color: #374151;
            background-color: #FFFFFF;
            transition: all 0.2s ease-in-out;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
            text-decoration: none;
        }
        .luxtech-pagination .page-link:hover {
            color: #FF6B00 !important;
            background-color: #FFF7F0 !important;
            border-color: #FFD8BF !important;
            transform: translateY(-1px);
        }
        .luxtech-pagination .page-item.active .page-link {
            background: linear-gradient(135deg, #FF6B00 0%, #FF7A1A 100%) !important;
            border-color: #FF6B00 !important;
            color: #FFFFFF !important;
            box-shadow: 0 3px 8px rgba(255, 107, 0, 0.32) !important;
        }
        .luxtech-pagination .page-item.disabled .page-link {
            background: #F9FAFB !important;
            color: #9CA3AF !important;
            border-color: #E5E7EB !important;
            opacity: 0.75;
            box-shadow: none;
            cursor: not-allowed;
            pointer-events: none;
        }
    </style>

    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center px-4 py-3 pb-4 gap-3">
        <!-- Summary information -->
        <div class="text-secondary small d-flex align-items-center flex-wrap gap-2">
            <span>Hiển thị <strong class="text-dark">${pageResult.startItem}</strong> - <strong class="text-dark">${pageResult.endItem}</strong> trong tổng số <strong class="text-dark">${pageResult.totalItems}</strong> bản ghi</span>
            <span class="badge rounded-pill bg-light text-secondary border px-2 py-1 fw-semibold">
                Trang ${pageResult.currentPage}/${pageResult.totalPages}
            </span>
        </div>

        <!-- Pagination Controls -->
        <c:if test="${pageResult.totalPages > 1}">
            <nav aria-label="Admin Page Navigation">
                <ul class="pagination pagination-sm luxtech-pagination mb-0 align-items-center">
                    <!-- Previous Button -->
                    <li class="page-item ${!pageResult.hasPrevious ? 'disabled' : ''}">
                        <c:choose>
                            <c:when test="${pageResult.hasPrevious}">
                                <a class="page-link px-3" href="${paramUrl}${connector}page=${pageResult.previousPage}" aria-label="Trang trước">
                                    <i class="bi bi-chevron-left me-1"></i>Trước
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-link px-3"><i class="bi bi-chevron-left me-1"></i>Trước</span>
                            </c:otherwise>
                        </c:choose>
                    </li>

                    <!-- Page Numbers -->
                    <c:forEach begin="1" end="${pageResult.totalPages}" var="p">
                        <c:choose>
                            <c:when test="${p == 1 or p == pageResult.totalPages or (p >= pageResult.currentPage - 2 and p <= pageResult.currentPage + 2)}">
                                <li class="page-item ${p == pageResult.currentPage ? 'active' : ''}">
                                    <c:choose>
                                        <c:when test="${p == pageResult.currentPage}">
                                            <span class="page-link">${p}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="page-link" href="${paramUrl}${connector}page=${p}">${p}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </c:when>
                            <c:when test="${p == pageResult.currentPage - 3 or p == pageResult.currentPage + 3}">
                                <li class="page-item disabled">
                                    <span class="page-link border-0 bg-transparent text-muted px-1">...</span>
                                </li>
                            </c:when>
                        </c:choose>
                    </c:forEach>

                    <!-- Next Button -->
                    <li class="page-item ${!pageResult.hasNext ? 'disabled' : ''}">
                        <c:choose>
                            <c:when test="${pageResult.hasNext}">
                                <a class="page-link px-3" href="${paramUrl}${connector}page=${pageResult.nextPage}" aria-label="Trang sau">
                                    Sau<i class="bi bi-chevron-right ms-1"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-link px-3">Sau<i class="bi bi-chevron-right ms-1"></i></span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
</c:if>
