package com.realestate.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.realestate.dao.AppointmentDAO;
import com.realestate.model.Appointment;
import com.realestate.model.User;

/**
 * POST /bookAppointment
 * Books an appointment.
 * Responds with plain text "OK" (200) for AJAX callers.
 * No redirect — popup is shown client-side.
 */
@WebServlet("/bookAppointment")
public class BookAppointmentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Not logged in");
            return;
        }

        try {
            int propertyId = Integer.parseInt(request.getParameter("propertyId"));
            String date    = request.getParameter("date");

            Appointment a = new Appointment();
            a.setUserId(user.getId());
            a.setPropertyId(propertyId);
            a.setDate(date);

            AppointmentDAO dao = new AppointmentDAO();

            if (dao.bookAppointment(a)) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("OK");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
