package com.electronicstore.util;

import java.util.ArrayList;
import java.util.List;

/**
 * PageResult – Đối tượng chứa dữ liệu phân trang dùng chung cho toàn bộ ứng dụng.
 *
 * @param <T> Kiểu thực thể (Product, Order, Customer, Category, User,...)
 */
public class PageResult<T> {
    private List<T> items;
    private int currentPage;
    private int pageSize;
    private int totalItems;
    private int totalPages;
    private int startItem;
    private int endItem;

    public PageResult() {
        this.items = new ArrayList<>();
        this.currentPage = 1;
        this.pageSize = 10;
        this.totalItems = 0;
        this.totalPages = 1;
    }

    public PageResult(List<T> items, int currentPage, int pageSize, int totalItems) {
        this.items = (items != null) ? items : new ArrayList<>();
        this.currentPage = Math.max(1, currentPage);
        this.pageSize = Math.max(1, pageSize);
        this.totalItems = Math.max(0, totalItems);
        this.totalPages = (int) Math.ceil((double) this.totalItems / this.pageSize);
        if (this.totalPages == 0) {
            this.totalPages = 1;
        }
        if (this.currentPage > this.totalPages) {
            this.currentPage = this.totalPages;
        }

        if (this.totalItems == 0) {
            this.startItem = 0;
            this.endItem = 0;
        } else {
            this.startItem = (this.currentPage - 1) * this.pageSize + 1;
            this.endItem = Math.min(this.currentPage * this.pageSize, this.totalItems);
        }
    }

    public List<T> getItems() {
        return items;
    }

    public void setItems(List<T> items) {
        this.items = items;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public int getStartItem() {
        return startItem;
    }

    public int getEndItem() {
        return endItem;
    }

    public boolean isHasPrevious() {
        return currentPage > 1;
    }

    public boolean isHasNext() {
        return currentPage < totalPages;
    }

    public int getPreviousPage() {
        return Math.max(1, currentPage - 1);
    }

    public int getNextPage() {
        return Math.min(totalPages, currentPage + 1);
    }
}
