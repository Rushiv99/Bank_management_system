<%@ page import="com.bank.entity.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User admin = (User) session.getAttribute("adminUser");
    if(admin == null) { res.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin HQ | United Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --sidebar-bg: #1e293b; --teal: #0d9488; --bg: #f1f5f9; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); margin: 0; display: flex; }

        .sidebar { width: 260px; background: var(--sidebar-bg); color: white; height: 100vh; position: fixed; padding: 30px 20px; }
        .sidebar h2 { color: var(--teal); font-size: 1.2rem; border-bottom: 1px solid #334155; padding-bottom: 20px; }
        .sidebar a { display: block; color: #94a3b8; padding: 15px 0; text-decoration: none; font-weight: 500; transition: 0.3s; }
        .sidebar a:hover { color: white; transform: translateX(5px); }

        .main-content { margin-left: 260px; padding: 40px; width: calc(100% - 260px); }
        .stat-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }

        .search-box { background: white; padding: 25px; border-radius: 12px; margin-bottom: 30px; }
        input[type="text"] { padding: 12px; border: 1px solid #ddd; border-radius: 8px; width: 300px; }
        .btn-search { background: var(--teal); color: white; padding: 12px 25px; border: none; border-radius: 8px; cursor: pointer; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>🏦 UNITED ADMIN</h2>
    <a href="#">🏠 Dashboard Overview</a>
    <a href="#">👥 Manage Customers</a>
    <a href="#">📜 Master Ledger</a>
    <a href="login.jsp" style="margin-top: 40px; color: #f43f5e;">🚪 Logout</a>
</div>

<div class="main-content">
    <h1>System Administration</h1>

    <div class="stat-grid">
        <div class="stat-card">
            <p style="color: #64748b; margin:0;">Total Liquidity</p>
            <h2 style="margin:10px 0;">₹ 12,45,000.00</h2>
        </div>
        <div class="stat-card">
            <p style="color: #64748b; margin:0;">Total Registered Users</p>
            <h2 style="margin:10px 0;">1,240</h2>
        </div>
    </div>

    <div class="search-box">
        <h3>Find & Edit Customer</h3>
        <form action="AdminSearchServlet" method="get">
            <input type="text" name="searchAcc" placeholder="Enter Account Number..." required>
            <button type="submit" class="btn-search">Search Account</button>
        </form>
    </div>

    <% if(request.getParameter("msg") != null) { %>
        <div style="padding: 15px; background: #fee2e2; color: #b91c1c; border-radius: 8px; margin-bottom: 20px;">
            <%= request.getParameter("msg") %>
        </div>
    <% } %>
</div>

</body>
</html>