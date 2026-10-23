package com.realestate.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.realestate.dao.DBConnection;

/**
 * GET /propertyDetails?id=<propertyId>
 * Returns property details + seller info + images as JSON.
 */
@WebServlet("/propertyDetails")
public class PropertyDetailsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int propertyId = Integer.parseInt(request.getParameter("id"));

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder();

        try (Connection conn = DBConnection.getConnection()) {

            // Property + seller info via JOIN
            String query =
                "SELECT p.*, u.name AS seller_name, u.email AS seller_email, u.phone AS seller_phone " +
                "FROM properties p " +
                "JOIN users u ON p.seller_id = u.id " +
                "WHERE p.id = ?";

            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, propertyId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                json.append("{");
                json.append("\"title\":\"").append(escape(rs.getString("title"))).append("\",");
                json.append("\"price\":").append(rs.getDouble("price")).append(",");
                json.append("\"location\":\"").append(escape(rs.getString("location"))).append("\",");
                json.append("\"bhk\":").append(rs.getInt("bhk")).append(",");
                json.append("\"description\":\"").append(escape(rs.getString("description"))).append("\",");

                // Seller details
                json.append("\"sellerName\":\"").append(escape(rs.getString("seller_name"))).append("\",");
                json.append("\"sellerEmail\":\"").append(escape(rs.getString("seller_email"))).append("\",");
                json.append("\"sellerPhone\":\"").append(escape(rs.getString("seller_phone"))).append("\",");

                // Images
                json.append("\"images\":[");
                String imgQuery = "SELECT image_url FROM property_images WHERE property_id=?";
                PreparedStatement ps2 = conn.prepareStatement(imgQuery);
                ps2.setInt(1, propertyId);
                ResultSet rs2 = ps2.executeQuery();
                boolean first = true;
                while (rs2.next()) {
                    if (!first) json.append(",");
                    json.append("\"").append(escape(rs2.getString("image_url"))).append("\"");
                    first = false;
                }
                json.append("]}");
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
