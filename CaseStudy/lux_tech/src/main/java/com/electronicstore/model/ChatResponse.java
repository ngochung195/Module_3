package com.electronicstore.model;

import java.io.Serializable;

public class ChatResponse implements Serializable {
    private static final long serialVersionUID = 1L;

    private boolean success;
    private String message;
    private long timestamp;

    public ChatResponse() {
        this.timestamp = System.currentTimeMillis();
    }

    public ChatResponse(boolean success, String message) {
        this.success = success;
        this.message = message;
        this.timestamp = System.currentTimeMillis();
    }

    public static ChatResponse ok(String message) {
        return new ChatResponse(true, message);
    }

    public static ChatResponse error(String errorMessage) {
        return new ChatResponse(false, errorMessage);
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }
}
