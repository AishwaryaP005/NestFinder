package com.realestate.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.realestate.model.User;

public class UserDAO {

    public boolean registerUser(User user) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();

            String query = "INSERT INTO users(name,email,password,role,phone,dob) VALUES(?,?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(query);

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getPhone());
            if (user.getDob() != null) {
                ps.setDate(6, user.getDob());
            } else {
                ps.setNull(6, java.sql.Types.DATE);
            }

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
    public User loginUser(String email, String password) {
        User user = null;

        try {
            Connection conn = DBConnection.getConnection();

            String query = "SELECT * FROM users WHERE email=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(query);

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                user.setDob(rs.getDate("dob"));
                
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }
    public List<User> getChatUsers(int currentUserId) {

        List<User> list = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String query = "SELECT * FROM users WHERE id != ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, currentUserId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                User u = new User();

                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setPhone(rs.getString("phone"));
                u.setDob(rs.getDate("dob"));

                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}