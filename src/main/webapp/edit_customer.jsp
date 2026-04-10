<%@ page import="com.bank.entity.Account" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Account acc = (Account) request.getAttribute("customerAcc");
    if (acc == null) {
        response.sendRedirect("admin_dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Customer | United Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --navy: #1a237e; --teal: #0d9488; --bg: #f8fafc; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .edit-card { background: white; padding: 40px; border-radius: 16px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); width: 100%; max-width: 500px; }
        .header { border-bottom: 2px solid #f1f5f9; margin-bottom: 25px; padding-bottom: 15px; }
        .input-group { margin-bottom: 15px; }
        label { display: block; font-size: 0.8rem; font-weight: 700; color: var(--navy); margin-bottom: 5px; text-transform: uppercase; }
        input { width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; box-sizing: border-box; font-size: 1rem; background: #fcfcfc; }
        .btn-update { width: 100%; padding: 14px; background: var(--teal); color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; margin-top: 10px; }
        .back-link { display: block; text-align: center; margin-top: 20px; color: #64748b; text-decoration: none; font-size: 0.9rem; }
    </style>
</head>
<body>

    <div class="edit-card">
        <div class="header">
            <h2 style="margin:0; color: var(--navy);">Customer Profile</h2>
            <p style="color: #64748b; margin: 5px 0 0;">Managing Account: <%= acc.getAccountNumber() %></p>
        </div>

        <form action="UpdateCustomerServlet" method="post">
            <input type="hidden" name="accNo" value="<%= acc.getAccountNumber() %>">

            <div class="input-group">
                <label>Full Name</label>
                <input type="text" name="fullName" value="<%= acc.getUser().getFullName() %>">
            </div>

            <div class="input-group">
                <label>Email Address</label>
                <input type="email" name="email" value="<%= acc.getUser().getEmail() %>"
                       style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #e2e8f0;">
            </div>

            <div class="input-group">
                <label>Available Balance (₹)</label>
                <input type="number" name="balance" step="0.01" value="<%= acc.getBalance() %>">
            </div>

            <button type="submit" class="btn-update">Save Changes</button>
        </form>

        <a href="admin_dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>

</body>
</html>