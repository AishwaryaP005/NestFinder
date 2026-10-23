package com.realestate.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.realestate.dao.DBConnection;
import com.realestate.model.User;

/**
 * GET /sellerProperties
 * Returns all properties listed by the logged-in seller as a JSON array.
 * Each element: { id, title, price, location, bhk }
 */
@WebServlet("/sellerProperties")
public class SellerPropertiesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.getWriter().write("[]");
            return;
        }

        StringBuilder json = new StringBuilder("[");

        try (Connection conn = DBConnection.getConnection()) {

            String sql = "SELECT id, title, price, location, bhk FROM properties WHERE seller_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user.getId());
            ResultSet rs = ps.executeQuery();

            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{")
                    .append("\"id\":").append(rs.getInt("id")).append(",")
                    .append("\"title\":\"").append(escape(rs.getString("title"))).append("\",")
                    .append("\"price\":").append(rs.getDouble("price")).append(",")
                    .append("\"location\":\"").append(escape(rs.getString("location"))).append("\",")
                    .append("\"bhk\":").append(rs.getInt("bhk"))
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
