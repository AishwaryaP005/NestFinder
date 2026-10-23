package com.realestate.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.realestate.dao.UserDAO;
import com.realestate.model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dob");

        // convert String → SQL Date
        java.sql.Date dob = null;
        if (dobStr != null && !dobStr.isEmpty()) {
            dob = java.sql.Date.valueOf(dobStr);
        }

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole(role);
        user.setPhone(phone);
        user.setDob(dob);

        UserDAO dao = new UserDAO();
        boolean status = dao.registerUser(user);

        if (status) {
            response.sendRedirect("jsp/login.jsp");
        } else {
            response.getWriter().println("Registration Failed");
        }
    }
}