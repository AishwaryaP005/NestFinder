package com.realestate.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.realestate.model.Property;

public class PropertyDAO {

	public int addProperty(Property p) {
	    int propertyId = 0;

	    try {
	        Connection conn = DBConnection.getConnection();

	        String query = "INSERT INTO properties(title,price,location,bhk,description,seller_id) VALUES(?,?,?,?,?,?)";

	        PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);

	        ps.setString(1, p.getTitle());
	        ps.setDouble(2, p.getPrice());
	        ps.setString(3, p.getLocation());
	        ps.setInt(4, p.getBhk());
	        ps.setString(5, p.getDescription());
	        ps.setInt(6, p.getSellerId());

	        ps.executeUpdate();

	        ResultSet rs = ps.getGeneratedKeys();
	        if (rs.next()) {
	            propertyId = rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return propertyId;
	}
	public void saveImage(int propertyId, String imagePath) {
	    try {
	        Connection conn = DBConnection.getConnection();

	        String query = "INSERT INTO property_images(property_id, image_url) VALUES(?,?)";
	        PreparedStatement ps = conn.prepareStatement(query);

	        ps.setInt(1, propertyId);
	        ps.setString(2, imagePath);

	        ps.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	public List<Property> getAllProperties() {
	    List<Property> list = new ArrayList<>();

	    try {
	        Connection conn = DBConnection.getConnection();

	        String query = "SELECT * FROM properties";
	        PreparedStatement ps = conn.prepareStatement(query);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {

	            Property p = new Property();
	            int propertyId = rs.getInt("id");

	            p.setId(propertyId);
	            p.setTitle(rs.getString("title"));
	            p.setPrice(rs.getDouble("price"));
	            p.setLocation(rs.getString("location"));
	            p.setBhk(rs.getInt("bhk"));
	            p.setDescription(rs.getString("description"));

	            // Fetch images
	            List<String> images = new ArrayList<>();

	            String imgQuery = "SELECT image_url FROM property_images WHERE property_id=?";
	            PreparedStatement ps2 = conn.prepareStatement(imgQuery);
	            ps2.setInt(1, propertyId);

	            ResultSet rs2 = ps2.executeQuery();

	            while (rs2.next()) {
	                images.add(rs2.getString("image_url"));
	            }

	            p.setImages(images);

	            list.add(p);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
    
}