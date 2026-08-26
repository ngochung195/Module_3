package com.codegym.model;

/**
 * Calculator model class that provides static calculation functionality.
 */
public class Calculator {

    /**
     * Performs arithmetic calculation based on the given operator.
     *
     * @param firstOperand  the first operand
     * @param secondOperand the second operand
     * @param operator      the operator (+, -, *, /)
     * @return the result of the calculation
     * @throws RuntimeException if division by zero is attempted
     */
    public static float calculate(float firstOperand, float secondOperand, char operator) {
        switch (operator) {
            case '+':
                return firstOperand + secondOperand;
            case '-':
                return firstOperand - secondOperand;
            case '*':
                return firstOperand * secondOperand;
            case '/':
                if (secondOperand == 0) {
                    throw new RuntimeException("Cannot divide by zero");
                }
                return firstOperand / secondOperand;
            default:
                throw new RuntimeException("Unknown operator: " + operator);
        }
    }
}
