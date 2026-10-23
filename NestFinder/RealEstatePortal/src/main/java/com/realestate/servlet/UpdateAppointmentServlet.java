package com.realestate.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.realestate.dao.AppointmentDAO;

@WebServlet("/updateAppointment")
public class UpdateAppointmentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        AppointmentDAO dao = new AppointmentDAO();
        dao.updateStatus(id, status);

        response.sendRedirect("viewAppointments");
    }
}