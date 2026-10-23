package com.realestate.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.realestate.dao.AppointmentDAO;
import com.realestate.model.Appointment;
import com.realestate.model.User;

@WebServlet("/viewAppointments")
public class ViewAppointmentsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        AppointmentDAO dao = new AppointmentDAO();
        List<Appointment> list = dao.getAppointmentsBySeller(user.getId());

        request.setAttribute("appointments", list);

        request.getRequestDispatcher("jsp/sellerAppointments.jsp").forward(request, response);
    }
}