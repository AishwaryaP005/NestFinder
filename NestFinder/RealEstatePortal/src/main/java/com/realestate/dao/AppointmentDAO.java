package com.realestate.dao;

import java.sql.*;
import java.util.*;
import com.realestate.model.Appointment;

public class AppointmentDAO {

    // BOOK APPOINTMENT
    public boolean bookAppointment(Appointment a) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();

            String query = "INSERT INTO appointments(user_id, property_id, date, status) VALUES(?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(query);

            ps.setInt(1, a.getUserId());
            ps.setInt(2, a.getPropertyId());
            ps.setString(3, a.getDate());
            ps.setString(4, "pending");

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // GET SELLER APPOINTMENTS
    public List<Appointment> getAppointmentsBySeller(int sellerId) {
        List<Appointment> list = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String query = "SELECT a.* FROM appointments a " +
                           "JOIN properties p ON a.property_id = p.id " +
                           "WHERE p.seller_id=?";

            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, sellerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setUserId(rs.getInt("user_id"));
                a.setPropertyId(rs.getInt("property_id"));
                a.setDate(rs.getString("date"));
                a.setStatus(rs.getString("status"));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // UPDATE STATUS
    public void updateStatus(int id, String status) {
        try {
            Connection conn = DBConnection.getConnection();

            String query = "UPDATE appointments SET status=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(query);

            ps.setString(1, status);
            ps.setInt(2, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}