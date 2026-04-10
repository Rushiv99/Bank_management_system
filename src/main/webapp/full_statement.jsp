<%@ page import="com.bank.entity.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // LOGIC PRESERVED EXACTLY
    String uid = (String) request.getAttribute("uid");
    List<Transaction> list = (List<Transaction>) request.getAttribute("statementData");
    Map<Long, Account> userMap = (Map<Long, Account>) session.getAttribute("userMap");

    Account acc = null;
    if (userMap != null && uid != null) {
        acc = userMap.get(Long.parseLong(uid));
    }

    if (acc == null || list == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>e-Statement | United Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 40px 20px;
            color: #333;
        }

        .statement-card {
            background: white;
            padding: 50px;
            border-radius: 4px;
            max-width: 1000px;
            margin: auto;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            border-top: 8px solid #1a237e;
        }

        .statement-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 40px;
            border-bottom: 1px solid #e0e0e0;
            padding-bottom: 20px;
        }

        .bank-brand h1 {
            margin: 0;
            color: #1a237e;
            font-size: 28px;
            letter-spacing: 1px;
        }

        .no-print { display: flex; gap: 10px; }
        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            border: 1px solid transparent;
        }
        .btn-back { background: #f5f5f5; color: #333; border-color: #ddd; }
        .btn-print { background: #1a237e; color: white; }

        .account-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 40px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
        }

        .info-item label {
            display: block;
            font-size: 11px;
            text-transform: uppercase;
            color: #666;
            margin-bottom: 4px;
            font-weight: 700;
        }

        .info-item span { font-size: 16px; font-weight: 600; color: #1a237e; }

        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th {
            text-align: left;
            padding: 15px;
            border-bottom: 2px solid #1a237e;
            color: #1a237e;
            font-size: 12px;
            text-transform: uppercase;
        }
        td {
            padding: 18px 15px;
            border-bottom: 1px solid #e0e0e0;
            font-size: 14px;
        }

        .amount-cell { font-weight: 700; font-size: 15px; text-align: right; }

        @media print {
            body { background: white; padding: 0; }
            .statement-card { box-shadow: none; border: none; max-width: 100%; width: 100%; padding: 20px; }
            .no-print { display: none; }
        }
    </style>
</head>
<body>

    <div class="statement-card">
        <div class="statement-header">
            <div class="bank-brand">
                <h1>UNITED BANK</h1>
                <p style="color:#666; font-size:14px; margin:5px 0;">Corporate Head Office: Ahmedabad, Gujarat</p>
            </div>
            <div class="no-print">
                <a href="dashboard.jsp?uid=<%= uid %>" class="btn btn-back">Return Home</a>
                <button class="btn btn-print" onclick="window.print()">Print Statement</button>
            </div>
        </div>

        <div class="account-info-grid">
            <div class="info-item">
                <label>Account Holder</label>
                <span><%= acc.getUser().getFullName() %></span>
            </div>
            <div class="info-item" style="text-align: right;">
                <label>Date of Issue</label>
                <span><%= new SimpleDateFormat("dd MMM yyyy").format(new Date()) %></span>
            </div>
            <div class="info-item">
                <label>Account Number</label>
                <span><%= acc.getAccountNumber() %></span>
            </div>
            <div class="info-item" style="text-align: right;">
                <label>Current Balance</label>
                <span style="font-size: 18px;">₹ <%= String.format("%.2f", acc.getBalance()) %></span>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Transaction Date</th>
                    <th>Type / Description</th>
                    <th style="text-align: right;">Amount (INR)</th>
                </tr>
            </thead>
            <tbody>
                <% for(Transaction t : list) {
                    boolean isCredit = t.getType().contains("DEPOSIT") || t.getType().contains("RECEIVED");
                %>
                    <tr>
                        <td style="color: #666;"><%= t.getDate() %></td>
                        <td style="font-weight: 600; font-size: 12px; letter-spacing: 0.5px;">
                            <%= t.getType() %>
                        </td>
                        <td class="amount-cell" style="color: <%= isCredit ? "#2e7d32" : "#d32f2f" %>;">
                            <%= isCredit ? "+" : "-" %> ₹<%= String.format("%.2f", t.getAmount()) %>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <div style="margin-top: 50px; border-top: 1px solid #e0e0e0; padding-top: 20px; font-size: 11px; color: #999; text-align: center;">
            <p>This is a system-generated statement and does not require a physical signature.</p>
            <p>&copy; 2026 United Bank. All rights reserved.</p>
        </div>
    </div>

</body>
</html>