package com.codegym;

public class Main {
    public static void main(String[] args) {
        System.out.println("=== THU VIEN GIAI PHUONG TRINH BAC 2 ===");

        // Vi du 1: Delta > 0 (2 nghiem phân biệt)
        QuadraticEquation eq1 = new QuadraticEquation(1, -5, 6);
        System.out.println("Phuong trinh 1: x^2 - 5x + 6 = 0");
        System.out.println("Delta: " + eq1.getDiscriminant());
        System.out.println("Nghiem 1: " + eq1.getRoot1());
        System.out.println("Nghiem 2: " + eq1.getRoot2());
        System.out.println("Ket qua: " + eq1.getResult());
        System.out.println();

        // Vi du 2: Delta = 0 (Nghiem kep)
        QuadraticEquation eq2 = new QuadraticEquation(1, -4, 4);
        System.out.println("Phuong trinh 2: x^2 - 4x + 4 = 0");
        System.out.println("Delta: " + eq2.getDiscriminant());
        System.out.println("Nghiem kep: " + eq2.getRoot1());
        System.out.println("Ket qua: " + eq2.getResult());
        System.out.println();

        // Vi du 3: Delta < 0 (Vo nghiem)
        QuadraticEquation eq3 = new QuadraticEquation(1, 2, 3);
        System.out.println("Phuong trinh 3: x^2 + 2x + 3 = 0");
        System.out.println("Delta: " + eq3.getDiscriminant());
        System.out.println("Ket qua: " + eq3.getResult());
    }
}
