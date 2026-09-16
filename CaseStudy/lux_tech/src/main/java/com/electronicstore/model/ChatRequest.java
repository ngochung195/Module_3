package com.electronicstore.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class ChatRequest implements Serializable {
    private static final long serialVersionUID = 1L;

    private String message;
    private Integer currentProductId;
    private String currentPath;
    private List<ChatMessage> history = new ArrayList<>();

    public ChatRequest() {
    }

    public ChatRequest(String message) {
        this.message = message;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Integer getCurrentProductId() {
        return currentProductId;
    }

    public void setCurrentProductId(Integer currentProductId) {
        this.currentProductId = currentProductId;
    }

    public String getCurrentPath() {
        return currentPath;
    }

    public void setCurrentPath(String currentPath) {
        this.currentPath = currentPath;
    }

    public List<ChatMessage> getHistory() {
        return history;
    }

    public void setHistory(List<ChatMessage> history) {
        this.history = history;
    }
}
