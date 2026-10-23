package com.realestate.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.realestate.dao.DBConnection;
import com.realestate.model.User;

/**
 * GET /buyerLatestAppointment
 * Returns the most recent appointment of the logged-in buyer as JSON.
 * JSON shape: { id, propertyTitle, location, date, status }
 */
@WebServlet("/buyerLatestAppointment")
public class BuyerLatestAppointmentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.getWriter().write("{\"error\":\"not logged in\"}");
            return;
        }

        StringBuilder json = new StringBuilder();

        try (Connection conn = DBConnection.getConnection()) {

            String sql =
                "SELECT a.id, a.date, a.status, p.title, p.location " +
                "FROM appointments a " +
                "JOIN properties p ON a.property_id = p.id " +
                "WHERE a.user_id = ? " +
                "ORDER BY a.id DESC LIMIT 1";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user.getId());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                json.append("{")
                    .append("\"id\":").append(rs.getInt("id")).append(",")
                    .append("\"propertyTitle\":\"").append(escape(rs.getString("title"))).append("\",")
                    .append("\"location\":\"").append(escape(rs.getString("location"))).append("\",")
                    .append("\"date\":\"").append(escape(rs.getString("date"))).append("\",")
                    .append("\"status\":\"").append(escape(rs.getString("status"))).append("\"")
                    .append("}");
            } else {
                json.append("{}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            json = new StringBuilder("{\"error\":\"server error\"}");
        }

        response.getWriter().write(json.toString());
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
