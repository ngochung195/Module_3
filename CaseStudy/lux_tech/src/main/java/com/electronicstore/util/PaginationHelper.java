package com.electronicstore.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * PaginationHelper – Tiện ích phân chia danh sách theo trang cho các Controller.
 */
public class PaginationHelper {

    /**
     * Phân trang một danh sách dữ liệu.
     *
     * @param fullList Danh sách đầy đủ
     * @param page Số trang hiện tại (1-indexed)
     * @param pageSize Số phần tử mỗi trang
     * @param <T> Kiểu thực thể
     * @return Đối tượng PageResult chứa danh sách item của trang và metadata
     */
    public static <T> PageResult<T> paginate(List<T> fullList, int page, int pageSize) {
        if (fullList == null || fullList.isEmpty()) {
            return new PageResult<>(Collections.emptyList(), 1, pageSize, 0);
        }

        int totalItems = fullList.size();
        int safePageSize = Math.max(1, pageSize);
        int totalPages = (int) Math.ceil((double) totalItems / safePageSize);
        int safePage = Math.max(1, Math.min(page, totalPages));

        int fromIndex = (safePage - 1) * safePageSize;
        int toIndex = Math.min(fromIndex + safePageSize, totalItems);

        List<T> pageItems = new ArrayList<>(fullList.subList(fromIndex, toIndex));
        return new PageResult<>(pageItems, safePage, safePageSize, totalItems);
    }

    /**
     * Parse số trang an toàn từ String tham số request.
     *
     * @param pageParam Chuỗi tham số (ví dụ: request.getParameter("page"))
     * @return Số nguyên >= 1 (mặc định = 1 nếu không hợp lệ)
     */
    public static int parsePage(String pageParam) {
        if (pageParam == null || pageParam.trim().isEmpty()) {
            return 1;
        }
        try {
            int page = Integer.parseInt(pageParam.trim());
            return Math.max(1, page);
        } catch (NumberFormatException e) {
            return 1;
        }
    }
}
