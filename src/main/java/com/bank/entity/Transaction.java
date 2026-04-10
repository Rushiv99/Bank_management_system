package com.bank.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "transactions")
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "transaction_id") // Matches your screenshot
    private int id;

    @Column(name = "account_number")
    private long accountNumber;

    @Column(name = "transaction_type") // Matches your screenshot
    private String type;

    @Column(name = "amount")
    private double amount;

    @Column(name = "transaction_date") // Matches your screenshot
    @Temporal(TemporalType.TIMESTAMP)
    private Date date = new Date();

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public long getAccountNumber() { return accountNumber; }
    public void setAccountNumber(long acc) { this.accountNumber = acc; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
}