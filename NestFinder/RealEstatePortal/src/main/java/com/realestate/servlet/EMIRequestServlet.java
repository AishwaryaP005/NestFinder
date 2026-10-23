package com.realestate.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.realestate.rmi.EMIClient;

@WebServlet("/calculateEMI")
public class EMIRequestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        double loan = Double.parseDouble(request.getParameter("loan"));
        double rate = Double.parseDouble(request.getParameter("rate"));
        int tenure = Integer.parseInt(request.getParameter("tenure"));

        double emi = EMIClient.getEMI(loan, rate, tenure);

        request.setAttribute("emi", emi);
        request.getRequestDispatcher("jsp/emi.jsp").forward(request, response);
    }
}