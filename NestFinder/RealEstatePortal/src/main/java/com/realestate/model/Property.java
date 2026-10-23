package com.realestate.model;
import java.util.List;

public class Property {
	private List<String> images;
	public List<String> getImages() {
	    return images;
	}
    private int id;
    private String title;
    private double price;
    private String location;
    private int bhk;
    private String description;
    private int sellerId;

    // GETTERS
    public int getId() { return id; }
    public String getTitle() { return title; }
    public double getPrice() { return price; }
    public String getLocation() { return location; }
    public int getBhk() { return bhk; }
    public String getDescription() { return description; }
    public int getSellerId() { return sellerId; }

    // SETTERS
    public void setId(int id) { this.id = id; }
    public void setTitle(String title) { this.title = title; }
    public void setPrice(double price) { this.price = price; }
    public void setLocation(String location) { this.location = location; }
    public void setBhk(int bhk) { this.bhk = bhk; }
    public void setDescription(String description) { this.description = description; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }
    public void setImages(List<String> images) {
        this.images = images;
    }
}