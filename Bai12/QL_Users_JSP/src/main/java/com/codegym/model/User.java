package com.codegym.model;

/**
 * Lớp User đại diện cho đối tượng người dùng trong hệ thống.
 * Chứa các thuộc tính: id, name, email, country.
 * 
 * NGƯỜI HỌC TỰ THỰC HÀNH:
 * - Khai báo các thuộc tính private: id (int), name (String), email (String),
 * country (String).
 * - Định nghĩa các Constructor (Constructor rỗng, Constructor đầy đủ tham số,
 * Constructor không chứa id cho việc thêm mới).
 * - Định nghĩa các hàm Getter và Setter cho từng thuộc tính.
 */
public class User {
    protected int id;
    protected String name;
    protected String email;
    protected String country;

    public User() {
    }

    public User(String name, String email, String country) {
        this.name = name;
        this.email = email;
        this.country = country;
    }

    public User(int id, String name, String email, String country) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.country = country;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }
}
