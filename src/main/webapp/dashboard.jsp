<%@ page import="com.bank.entity.User, com.bank.entity.Account, com.bank.util.HibernateUtil, java.util.*, org.hibernate.Session" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 1. LOGIC: Get UID from URL and retrieve specific account from Session Map
    String uidStr = request.getParameter("uid");
    HttpSession sess = request.getSession();
    Map<Long, Account> userMap = (Map<Long, Account>) sess.getAttribute("userMap");

    Account acc = null;
    if (uidStr != null && userMap != null) {
        acc = userMap.get(Long.parseLong(uidStr));
    }

    // 2. SECURITY: Redirect to login if no valid session/UID found
    if(acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    User user = acc.getUser();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | United Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-navy: #1a237e;
            --accent-blue: #3949ab;
            --success-green: #2e7d32;
            --withdraw-red: #c62828;
            --bg-light: #f4f7fa;
            --white: #ffffff;
            --shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        body { font-family: 'Inter', sans-serif; background-color: var(--bg-light); margin: 0; color: #2c3e50; }

        header {
            background: var(--primary-navy);
            color: white;
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--shadow);
        }

        .container { max-width: 1100px; margin: 30px auto; padding: 0 20px; }

        /* ACKNOWLEDGEMENT ALERTS */
        .alert {
            padding: 15px 20px;
            margin-bottom: 25px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
            border: 1px solid transparent;
            animation: fadeInDown 0.4s ease-out;
        }
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* BALANCE SECTION */
        .balance-card {
            background: linear-gradient(135deg, var(--primary-navy) 0%, var(--accent-blue) 100%);
            color: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(26, 35, 126, 0.2);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* GRID FOR CARDS */
        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: var(--white);
            padding: 25px;
            border-radius: 12px;
            box-shadow: var(--shadow);
            display: flex;
            flex-direction: column;
        }

        .card h3 { margin: 0 0 15px 0; font-size: 1.1rem; color: var(--primary-navy); border-bottom: 2px solid #f0f2f5; padding-bottom: 8px; }

        label { font-size: 0.75rem; font-weight: 700; color: #64748b; text-transform: uppercase; margin-bottom: 5px; display: block; }

        input {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 1rem;
        }

        button {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            margin-top: auto; /* Push button to bottom */
        }

        /* RECENT TRANSACTIONS TABLE */
        .statement-box { background: var(--white); padding: 25px; border-radius: 12px; box-shadow: var(--shadow); }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { text-align: left; padding: 12px; background: #f8f9fa; color: var(--primary-navy); font-size: 0.85rem; }
        td { padding: 12px; border-bottom: 1px solid #eee; font-size: 0.9rem; }

        .btn-link {
            text-decoration: none;
            padding: 12px 20px;
            border-radius: 8px;
            background: var(--primary-navy);
            color: white;
            font-weight: 600;
            display: inline-block;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<header>
    <div style="font-weight: 700; font-size: 1.4rem;">🏦 UNITED BANK</div>
    <div style="font-size: 0.9rem;">
        Welcome, <strong><%= user.getFullName() %></strong> |
        <a href="login.jsp" style="color:white; margin-left:10px;">Logout</a>
    </div>
</header>

<div class="container">

    <%
        String status = request.getParameter("status");
        String msg = request.getParameter("msg");
        if (status != null && msg != null) {
            boolean isSuccess = status.equalsIgnoreCase("success");
    %>
        <div class="alert" style="
            background-color: <%= isSuccess ? "#e8f5e9" : "#ffebee" %>;
            color: <%= isSuccess ? "#2e7d32" : "#c62828" %>;
            border-color: <%= isSuccess ? "#a5d6a7" : "#ef9a9a" %>;">
            <span><%= isSuccess ? "✅" : "⚠️" %></span>
            <span><%= msg %></span>
        </div>
    <% } %>

    <div class="balance-card">
        <div>
            <h3 style="margin:0; opacity:0.8; font-weight:400;">Current Balance</h3>
            <div style="font-size: 2.8rem; font-weight: 700; margin: 5px 0;">₹ <%= String.format("%.2f", acc.getBalance()) %></div>
            <div style="font-family: monospace; opacity: 0.8;">Account: <%= acc.getAccountNumber() %></div>
        </div>
        <div style="font-size: 4rem; opacity: 0.2;">💰</div>
    </div>

    <div class="action-grid">
        <div class="card">
            <h3>Transfer Money</h3>
            <form action="TransferServlet?uid=<%= uidStr %>" method="post">
                <label>Receiver A/C</label>
                <input name="targetAcc" placeholder="Account Number" required>
                <label>Amount (₹)</label>
                <input name="amount" placeholder="0.00" required>
                <button type="submit" style="background: var(--accent-blue);">Send Money</button>
            </form>
        </div>

        <div class="card">
            <h3>Deposit Funds</h3>
            <form action="DepositServlet?uid=<%= uidStr %>" method="post">
                <label>Amount (₹)</label>
                <input type="number" name="amount" min="1" step="0.01" placeholder="0.00" required>
                <div style="height:62px"></div> <button type="submit" style="background: var(--success-green);">Deposit Cash</button>
            </form>
        </div>

        <div class="card">
            <h3>Withdraw Cash</h3>
            <form action="WithdrawServlet?uid=<%= uidStr %>" method="post">
                <label>Amount (₹)</label>
                <input type="number" name="amount" min="1" step="0.01" placeholder="0.00" required>
                <div style="height:62px"></div> <button type="submit" style="background: var(--withdraw-red);">Confirm Withdraw</button>
            </form>
        </div>
    </div>

    <div class="statement-box">
        <h3 style="color: var(--primary-navy);">Recent Activity</h3>
        <table>
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Description</th>
                    <th style="text-align: right;">Amount</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (org.hibernate.Session s = HibernateUtil.getSessionFactory().openSession()) {
                        String sql = "SELECT * FROM transactions WHERE account_number = :accNo ORDER BY transaction_id DESC LIMIT 5";
                        List<com.bank.entity.Transaction> miniList = s.createNativeQuery(sql, com.bank.entity.Transaction.class)
                                                                     .setParameter("accNo", acc.getAccountNumber())
                                                                     .getResultList();

                        if (miniList == null || miniList.isEmpty()) {
                %>
                            <tr><td colspan="3" style="text-align:center; padding: 20px; color: #999;">No transactions found.</td></tr>
                <%
                        } else {
                            for (com.bank.entity.Transaction t : miniList) {
                                boolean isCredit = t.getType().contains("DEPOSIT") || t.getType().contains("RECEIVED");
                %>
                            <tr>
                                <td style="color: #7f8c8d; font-size: 0.8rem;"><%= t.getDate() %></td>
                                <td style="font-weight: 600; font-size: 0.85rem;"><%= t.getType() %></td>
                                <td style="text-align: right; font-weight: 700; color: <%= isCredit ? "var(--success-green)" : "var(--withdraw-red)" %>;">
                                    <%= isCredit ? "+" : "-" %> ₹<%= String.format("%.2f", t.getAmount()) %>
                                </td>
                            </tr>
                <%
                            }
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='3' style='color:red;'>System Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
        <div style="text-align: right;">
            <a href="ViewStatementServlet?uid=<%= uidStr %>" class="btn-link">View Full Statement</a>
        </div>
    </div>

</div>

<footer style="text-align: center; padding: 30px; color: #999; font-size: 0.75rem;">
    &copy; 2026 United Bank Digital Banking. All transactions are encrypted.
</footer>

</body>
</html>