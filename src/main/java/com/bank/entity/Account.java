package com.bank.entity;
import jakarta.persistence.*;

@Entity @Table(name="accounts")
public class Account {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    private long account_number;
    private double balance;
    private String account_type;

    @OneToOne(fetch = FetchType.EAGER) @JoinColumn(name="user_id")
    private User user;

    // ADD THIS GETTER METHOD
    public User getUser() {
        return user;
    }

    // Existing Getters and Setters
    public long getAccountNumber() { return account_number; }
    public double getBalance() { return balance; }
    public void setBalance(double b) { this.balance = b; }
    public void setAccountType(String t) { this.account_type = t; }
    public void setUser(User u) { this.user = u; }
}