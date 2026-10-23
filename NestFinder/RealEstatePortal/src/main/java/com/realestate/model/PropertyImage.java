package com.realestate.model;

public class PropertyImage {
    private int id;
    private int propertyId;
    private String imageUrl;

    public int getId() { return id; }
    public int getPropertyId() { return propertyId; }
    public String getImageUrl() { return imageUrl; }

    public void setId(int id) { this.id = id; }
    public void setPropertyId(int propertyId) { this.propertyId = propertyId; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}