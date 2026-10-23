package com.realestate.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.realestate.dao.UserDAO;
import com.realestate.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.loginUser(email, password);

        if (user != null) {

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if ("seller".equals(user.getRole())) {
                response.sendRedirect("jsp/sellerHome.jsp");
            } else {
                response.sendRedirect("jsp/buyerHome.jsp");
            }

        } else {
            // Send error back to same page
            request.setAttribute("error", "Invalid credentials, try again");
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        }
    }
}