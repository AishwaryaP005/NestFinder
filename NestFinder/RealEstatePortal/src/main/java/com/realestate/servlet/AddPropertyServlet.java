package com.realestate.servlet;

import java.io.File;
import java.io.IOException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.realestate.dao.PropertyDAO;
import com.realestate.model.Property;
import com.realestate.model.User;

@WebServlet("/addProperty")
@MultipartConfig
public class AddPropertyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get seller from session
        User user = (User) request.getSession().getAttribute("user");
        int sellerId = user.getId();

        // Get form data
        String title = request.getParameter("title");
        double price = Double.parseDouble(request.getParameter("price"));
        String location = request.getParameter("location");
        int bhk = Integer.parseInt(request.getParameter("bhk"));
        String description = request.getParameter("description");

        // Create property object
        Property property = new Property();
        property.setTitle(title);
        property.setPrice(price);
        property.setLocation(location);
        property.setBhk(bhk);
        property.setDescription(description);
        property.setSellerId(sellerId);

        PropertyDAO dao = new PropertyDAO();

        // Save property → get ID
        int propertyId = dao.addProperty(property);

        String uploadDir = "C:/realestate_uploads/uploads/";

        File folder = new File(uploadDir);
        if (!folder.exists()) {
            folder.mkdirs();
        }

        Collection<Part> parts = request.getParts();

        for (Part part : parts) {
            if (part.getName().equals("images") && part.getSize() > 0) {

                String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();

                String fullPath = uploadDir + fileName;

                // Save file physically
                part.write(fullPath);

                // Save RELATIVE path in DB
                dao.saveImage(propertyId, "uploads/" + fileName);
            }
        }

        response.sendRedirect("jsp/addProperty.jsp?success=1");
    }
}