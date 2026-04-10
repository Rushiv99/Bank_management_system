<%@ page import="com.bank.entity.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Safety check to prevent crashing if data is missing
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
    Account acc = (Account) request.getAttribute("account");
    String uid = (String) request.getAttribute("uid");

    if (acc == null || transactions == null) {
        response.sendRedirect("dashboard.jsp?status=fail&msg=Data missing for statement");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Statement_<%= acc.getAccountNumber() %></title>
    <style>
        body { font-family: serif; color: #000; padding: 30px; line-height: 1.4; }
        .header { border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 20px; }
        .info-section { width: 100%; margin-bottom: 20px; }
        .info-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .info-table td { padding: 8px; border: 1px solid #ddd; font-size: 14px; }
        .label { font-weight: bold; background: #f2f2f2; width: 30%; }
        
        .trans-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .trans-table th { background: #333; color: #fff; padding: 10px; text-align: left; font-size: 12px; }
        .trans-table td { padding: 10px; border-bottom: 1px solid #eee; font-size: 11px; }
        
        @media print { .no-print { display: none; } }
    </style>
</head>
<body onload="window.print()">

    <div class="no-print" style="text-align:center; margin-bottom: 20px;">
        <button onclick="window.print()" style="padding:10px 20px; cursor:pointer;">💾 Save Statement</button>
        <a href="dashboard.jsp?uid=<%= uid %>" style="margin-left:10px;">Back to Dashboard</a>
    </div>

    <div class="header">
        <h1 style="margin:0;">UNITED BANK</h1>
        <p style="margin:5px 0; font-size: 14px;">Official Digital Account Statement</p>
    </div>

    <table class="info-table">
        <tr>
            <td class="label">Customer Name</td>
            <td><%= acc.getUser().getFullName() %></td>
        </tr>
        <tr>
            <td class="label">Account Number</td>
            <td><%= acc.getAccountNumber() %></td>
        </tr>
        <tr>
            <td class="label">Report Date</td>
            <td><%= new SimpleDateFormat("dd-MMM-yyyy HH:mm").format(new Date()) %></td>
        </tr>
        <tr>
            <td class="label">Balance</td>
            <td style="font-weight:bold;">INR <%= String.format("%.2f", acc.getBalance()) %></td>
        </tr>
    </table>

    <table class="trans-table">
        <thead>
            <tr>
                <th>Date</th>
                <th>Type</th>
                <th style="text-align: right;">Amount (₹)</th>
            </tr>
        </thead>
        <tbody>
            <% for (Transaction t : transactions) { 
                boolean isCredit = t.getType().contains("DEPOSIT") || t.getType().contains("RECEIVED");
            %>
                <tr>
                    <td><%= t.getDate() %></td>
                    <td><%= t.getType() %></td>
                    <td style="text-align: right; font-weight: bold;">
                        <%= isCredit ? "+" : "-" %> <%= String.format("%.2f", t.getAmount()) %>
                    </td>
                </tr>
            <% } %>
        </tbody>
    </table>

    <div style="margin-top: 40px; text-align: center; font-size: 10px; color: #777;">
        <p>This is an electronically generated statement. No signature is required.</p>
    </div>

</body>
</html>