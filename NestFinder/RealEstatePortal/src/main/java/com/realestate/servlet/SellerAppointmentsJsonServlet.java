package com.realestate.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.realestate.dao.DBConnection;
import com.realestate.model.User;

/**
 * GET /sellerAppointmentsJson?status=pending|confirmed|rejected
 * Returns appointments for the logged-in seller filtered by status.
 * Each element: { id, propertyTitle, buyerName, date, status }
 */
@WebServlet("/sellerAppointmentsJson")
public class SellerAppointmentsJsonServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.getWriter().write("[]");
            return;
        }

        String status = request.getParameter("status");
        if (status == null || status.trim().isEmpty()) status = "pending";

        StringBuilder json = new StringBuilder("[");

        try (Connection conn = DBConnection.getConnection()) {

            String sql =
                "SELECT a.id, a.date, a.status, " +
                "       p.title AS property_title, " +
                "       u.name  AS buyer_name " +
                "FROM appointments a " +
                "JOIN properties p ON a.property_id = p.id " +
                "JOIN users      u ON a.user_id      = u.id " +
                "WHERE p.seller_id = ? AND a.status = ? " +
                "ORDER BY a.id DESC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user.getId());
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();

            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{")
                    .append("\"id\":").append(rs.getInt("id")).append(",")
                    .append("\"propertyTitle\":\"").append(escape(rs.getString("property_title"))).append("\",")
                    .append("\"buyerName\":\"").append(escape(rs.getString("buyer_name"))).append("\",")
                    .append("\"date\":\"").append(escape(rs.getString("date"))).append("\",")
                    .append("\"status\":\"").append(escape(rs.getString("status"))).append("\"")
                    .append("}");
                first = false;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        json.append("]");
        response.getWriter().write(json.toString());
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
