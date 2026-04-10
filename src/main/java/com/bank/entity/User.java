package com.bank.entity;
import jakarta.persistence.*;

@Entity @Table(name="users")
public class User {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int user_id;
    private String full_name, email, username, password;

    // Getters and Setters
    public int getUserId() { return user_id; }
    public String getFullName() { return full_name; }
    public void setFullName(String f) { this.full_name = f; }
    public String getEmail() { return email; }
    public void setEmail(String e) { this.email = e; }
    public String getUsername() { return username; }
    public void setUsername(String u) { this.username = u; }
    public String getPassword() { return password; }
    public void setPassword(String p) { this.password = p; }
}