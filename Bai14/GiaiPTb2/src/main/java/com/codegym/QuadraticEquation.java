package com.codegym;

/**
 * Lop gia phuong trinh bac 2: a * x^2 + b * x + c = 0
 */
public class QuadraticEquation {
    private double a;
    private double b;
    private double c;

    /**
     * Ham khoi tao voi 3 he so a, b, c
     *
     * @param a He so cua x^2
     * @param b He so cua x
     * @param c Hang so hieu chinh
     */
    public QuadraticEquation(double a, double b, double c) {
        this.a = a;
        this.b = b;
        this.c = c;
    }

    public double getA() {
        return a;
    }

    public void setA(double a) {
        this.a = a;
    }

    public double getB() {
        return b;
    }

    public void setB(double b) {
        this.b = b;
    }

    public double getC() {
        return c;
    }

    public void setC(double c) {
        this.c = c;
    }

    /**
     * Tinh Delta = b^2 - 4ac
     *
     * @return Gia tri Delta (Discriminant)
     */
    public double getDiscriminant() {
        return b * b - 4 * a * c;
    }

    /**
     * Tinh nghiem thu nhat x1 = (-b + sqrt(Delta)) / (2a)
     *
     * @return Nghiem x1 neu Delta >= 0, nguoc lai tra ve 0
     */
    public double getRoot1() {
        double delta = getDiscriminant();
        if (delta < 0 || a == 0) {
            return 0;
        }
        return (-b + Math.sqrt(delta)) / (2 * a);
    }

    /**
     * Tinh nghiem thu hai x2 = (-b - sqrt(Delta)) / (2a)
     *
     * @return Nghiem x2 neu Delta >= 0, nguoc lai tra ve 0
     */
    public double getRoot2() {
        double delta = getDiscriminant();
        if (delta < 0 || a == 0) {
            return 0;
        }
        return (-b - Math.sqrt(delta)) / (2 * a);
    }

    /**
     * Tra ve chuoi ket qua chi tiet khi gia phuong trinh
     *
     * @return Chuoi thong bao ket qua
     */
    public String getResult() {
        if (a == 0) {
            if (b == 0) {
                return c == 0 ? "Phuong trinh co vo so nghiem" : "Phuong trinh vo nghiem";
            }
            return "Phuong trinh la phuong trinh bac nhat co 1 nghiem x = " + (-c / b);
        }

        double delta = getDiscriminant();
        if (delta > 0) {
            return String.format("Phuong trinh co 2 nghiem phân biêt: x1 = %s, x2 = %s", getRoot1(), getRoot2());
        } else if (delta == 0) {
            return String.format("Phuong trinh co nghiem kep: x1 = x2 = %s", getRoot1());
        } else {
            return "Phuong trinh vo nghiem (khong co nghiem thuc)";
        }
    }
}
