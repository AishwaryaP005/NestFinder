package com.realestate.model;

public class Appointment {
    private int id;
    private int userId;
    private int propertyId;
    private String date;
    private String status;

    public int getId() { return id; }
    public int getUserId() { return userId; }
    public int getPropertyId() { return propertyId; }
    public String getDate() { return date; }
    public String getStatus() { return status; }

    public void setId(int id) { this.id = id; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setPropertyId(int propertyId) { this.propertyId = propertyId; }
    public void setDate(String date) { this.date = date; }
    public void setStatus(String status) { this.status = status; }
}