package com.realestate.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.realestate.dao.PropertyDAO;
import com.realestate.model.Property;

@WebServlet("/viewProperties")
public class ViewPropertiesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PropertyDAO dao = new PropertyDAO();
        List<Property> properties = dao.getAllProperties();

        // ── Read filter params ──────────────────────────────────────────────
        String location     = request.getParameter("location");
        String bhk          = request.getParameter("bhk");
        String maxPriceStr  = request.getParameter("maxPrice");
        String propertyType = request.getParameter("propertyType");
        String sort         = request.getParameter("sort");   // "newest","low","high"

        // ── Filter ──────────────────────────────────────────────────────────
        List<Property> filtered = new ArrayList<>();
        for (Property p : properties) {

            // Location filter (case-insensitive contains)
            if (location != null && !location.trim().isEmpty()) {
                if (!p.getLocation().toLowerCase().contains(location.trim().toLowerCase())) {
                    continue;
                }
            }

            // BHK filter  — "1 BHK" → extract the number before " BHK"
            if (bhk != null && !bhk.trim().isEmpty()) {
                try {
                    String numPart = bhk.trim().replace(" BHK", "").replace("+", "").trim();
                    int filterBhk = Integer.parseInt(numPart);
                    if (bhk.contains("+")) {
                        if (p.getBhk() < filterBhk) continue;
                    } else {
                        if (p.getBhk() != filterBhk) continue;
                    }
                } catch (NumberFormatException ignored) { /* "Any" or unparseable → skip */ }
            }

            // Max price filter
            if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                try {
                    double maxPrice = Double.parseDouble(maxPriceStr.trim());
                    if (p.getPrice() > maxPrice) continue;
                } catch (NumberFormatException ignored) {}
            }

            // Property type filter — match against title (a simple heuristic since
            // the DB has no type column; swap with p.getType() if you add that field)
            if (propertyType != null && !propertyType.trim().isEmpty()
                    && !propertyType.equalsIgnoreCase("Any")) {
                if (!p.getTitle().toLowerCase().contains(propertyType.trim().toLowerCase())
                    && (p.getDescription() == null
                        || !p.getDescription().toLowerCase().contains(propertyType.trim().toLowerCase()))) {
                    continue;
                }
            }

            filtered.add(p);
        }

        // ── Sort ─────────────────────────────────────────────────────────────
        if ("low".equals(sort)) {
            filtered.sort(Comparator.comparingDouble(Property::getPrice));
        } else if ("high".equals(sort)) {
            filtered.sort(Comparator.comparingDouble(Property::getPrice).reversed());
        }
        // "newest" (default) — keeps DB insertion order (descending id)
        else {
            filtered.sort(Comparator.comparingInt(Property::getId).reversed());
        }

        // ── Forward ──────────────────────────────────────────────────────────
        request.setAttribute("propertyList",  filtered);
        request.setAttribute("totalCount",    properties.size());

        // Pass filter values back so the sidebar stays populated
        request.setAttribute("filterLocation",     location     != null ? location     : "");
        request.setAttribute("filterBhk",          bhk          != null ? bhk          : "");
        request.setAttribute("filterMaxPrice",     maxPriceStr  != null ? maxPriceStr  : "");
        request.setAttribute("filterPropertyType", propertyType != null ? propertyType : "");
        request.setAttribute("filterSort",         sort         != null ? sort         : "newest");

        request.getRequestDispatcher("jsp/viewProperties.jsp").forward(request, response);
    }
}
