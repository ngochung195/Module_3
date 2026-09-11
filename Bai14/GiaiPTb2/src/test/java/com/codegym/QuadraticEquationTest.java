package com.codegym;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class QuadraticEquationTest {

    @Test
    @DisplayName("Kiem thu phuong trinh co 2 nghiem phan biet (Delta > 0)")
    void testTwoDistinctRoots() {
        QuadraticEquation eq = new QuadraticEquation(1, -5, 6);
        assertEquals(1.0, eq.getDiscriminant(), "Delta phai bang 1.0");
        assertEquals(3.0, eq.getRoot1(), 0.0001, "Root 1 phai bang 3.0");
        assertEquals(2.0, eq.getRoot2(), 0.0001, "Root 2 phai bang 2.0");
    }

    @Test
    @DisplayName("Kiem thu phuong trinh co nghiem kep (Delta == 0)")
    void testOneDoubleRoot() {
        QuadraticEquation eq = new QuadraticEquation(1, -4, 4);
        assertEquals(0.0, eq.getDiscriminant(), "Delta phai bang 0.0");
        assertEquals(2.0, eq.getRoot1(), 0.0001, "Root 1 phai bang 2.0");
        assertEquals(2.0, eq.getRoot2(), 0.0001, "Root 2 phai bang 2.0");
    }

    @Test
    @DisplayName("Kiem thu phuong trinh vo nghiem thuc (Delta < 0)")
    void testNoRealRoots() {
        QuadraticEquation eq = new QuadraticEquation(1, 2, 3);
        assertTrue(eq.getDiscriminant() < 0, "Delta phai nho hon 0");
        assertEquals(0.0, eq.getRoot1(), "Root 1 phai la 0 khi Delta < 0");
        assertEquals(0.0, eq.getRoot2(), "Root 2 phai la 0 khi Delta < 0");
    }

    @Test
    @DisplayName("Kiem thu voi he so a = 0")
    void testLinearEquation() {
        QuadraticEquation eq = new QuadraticEquation(0, 2, -4);
        assertEquals(0.0, eq.getRoot1(), "Root 1 tra ve 0 khi a = 0");
        assertTrue(eq.getResult().contains("phuong trinh bac nhat"));
    }
}
