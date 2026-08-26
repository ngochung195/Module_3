package com.codegym.controller;

import com.codegym.model.Calculator;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet that handles calculator form submissions.
 * Maps to the URL pattern /calculate.
 */
@WebServlet("/calculate")
public class CalculatorServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String firstOperandStr = request.getParameter("first-operand");
        String secondOperandStr = request.getParameter("second-operand");
        String operatorStr = request.getParameter("operator");

        try {
            float firstOperand = Float.parseFloat(firstOperandStr);
            float secondOperand = Float.parseFloat(secondOperandStr);
            char operator = operatorStr.charAt(0);

            float result = Calculator.calculate(firstOperand, secondOperand, operator);

            request.setAttribute("firstOperand", firstOperand);
            request.setAttribute("secondOperand", secondOperand);
            request.setAttribute("operator", operatorStr);
            request.setAttribute("result", result);

        } catch (RuntimeException e) {
            request.setAttribute("firstOperand", firstOperandStr);
            request.setAttribute("secondOperand", secondOperandStr);
            request.setAttribute("operator", operatorStr);
            request.setAttribute("errorMessage", e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/result.jsp");
        dispatcher.forward(request, response);
    }
}
