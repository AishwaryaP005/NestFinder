package com.realestate.model;

import java.sql.Date;

public class User {
    private int id;
    private String name;
    private String email;
    private String password;
    private String role;
    private String phone;
    private Date dob;

    // GETTERS
    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getRole() {
        return role;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public Date getDob() {
        return dob;
    }
    

    // SETTERS
    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setRole(String role) {
        this.role = role;
    }

	public void setPhone(String phone) {
		// TODO Auto-generated method stub
		this.phone=phone;
	}

	public void setDob(Date dob) {
		// TODO Auto-generated method stub
		this.dob=dob;
	}
}