package com.codegym.model;

import java.time.LocalDate;

/**
 * Lớp đối tượng đại diện cho một Khách hàng.
 */
public class Customer {

    private String name;
    private String dob;        // Ngày sinh (định dạng dd/MM/yyyy)
    private String address;
    private String image;      // Đường dẫn ảnh tương đối từ thư mục webapp

    // ── Constructors ──────────────────────────────────────────────────────────

    public Customer() {}

    public Customer(String name, String dob, String address, String image) {
        this.name    = name;
        this.dob     = dob;
        this.address = address;
        this.image   = image;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public String getName()                { return name;    }
    public void   setName(String name)     { this.name = name; }

    public String getDob()                 { return dob;     }
    public void   setDob(String dob)       { this.dob = dob; }

    public String getAddress()             { return address; }
    public void   setAddress(String addr)  { this.address = addr; }

    public String getImage()               { return image;   }
    public void   setImage(String image)   { this.image = image; }

    @Override
    public String toString() {
        return "Customer{name='" + name + "', dob='" + dob +
               "', address='" + address + "', image='" + image + "'}";
    }
}
