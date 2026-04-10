<%@ page import="com.bank.entity.*, com.bank.util.HibernateUtil, org.hibernate.Session, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 1. SECURITY LOGIC
    User admin = (User) session.getAttribute("adminUser");
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect("login.jsp?status=fail&msg=Unauthorized Access");
        return;
    }

    // 2. DATABASE LOGIC: Fetch Real Stats
    Double totalLiquidity = 0.0;
    Long totalUsers = 0L;
    Long todayTransactions = 0L;

    try (Session s = HibernateUtil.getSessionFactory().openSession()) {
        // Get Sum of all account balances
        totalLiquidity = (Double) s.createQuery("SELECT SUM(balance) FROM Account").uniqueResult();
        if(totalLiquidity == null) totalLiquidity = 0.0;

        // Count all registered users
        totalUsers = (Long) s.createQuery("SELECT COUNT(id) FROM User WHERE role = 'CUSTOMER'").uniqueResult();

       String hqlTransactions = "SELECT COUNT(*) FROM Transaction WHERE DATE(date) = CURRENT_DATE";

               // If your Transaction entity uses 'transactionDate' instead of 'date', change it below:
               todayTransactions = (Long) s.createQuery(hqlTransactions).uniqueResult();
               if(todayTransactions == null) todayTransactions = 0L;
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin HQ | United Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary-navy: #1a237e; --sidebar-dark: #0f172a; --teal: #0d9488; --bg: #f8fafc; }
        body { margin: 0; font-family: 'Inter', sans-serif; background-color: var(--bg); display: flex; }

        /* Sidebar */
        .sidebar { width: 260px; background: var(--sidebar-dark); color: white; height: 100vh; position: fixed; display: flex; flex-direction: column; }
        .sidebar-header { padding: 30px 25px; font-size: 1.25rem; font-weight: 700; color: var(--teal); border-bottom: 1px solid #1e293b; }
        .sidebar-menu a { display: block; padding: 15px 25px; color: #94a3b8; text-decoration: none; transition: 0.3s; }
        .sidebar-menu a:hover { background: #1e293b; color: white; border-left: 4px solid var(--teal); }

        /* Main Content */
        .main-content { margin-left: 260px; padding: 40px; width: 100%; }
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 40px; }
        .stat-card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .stat-card small { color: #64748b; font-weight: 700; font-size: 0.7rem; text-transform: uppercase; }
        .stat-card .val { font-size: 1.8rem; font-weight: 700; color: var(--sidebar-dark); margin-top: 10px; }

        .search-section { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .search-form { display: flex; gap: 10px; margin-top: 15px; }
        input[type="text"] { flex: 1; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; }
        .btn-search { background: var(--teal); color: white; border: none; padding: 12px 25px; border-radius: 8px; font-weight: 600; cursor: pointer; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header">UNITED ADMIN</div>
        <div class="sidebar-menu">
            <a href="admin_dashboard.jsp">🏠 Dashboard</a>
            <a href="#">👥 Manage Customers</a>
            <a href="#">📜 Master Ledger</a>
            <a href="login.jsp" style="margin-top:20px; color:#ef4444;">🚪 Logout</a>
        </div>
    </div>

    <div class="main-content">
        <header style="margin-bottom: 30px;">
            <h1 style="margin:0;">System Overview</h1>
            <p style="color: #64748b;">Welcome back, <%= admin.getFullName() %></p>
        </header>

        <div class="stats-grid">
            <div class="stat-card">
                <small>Total Bank Deposits</small>
                <div class="val">₹ <%= String.format("%.2f", totalLiquidity) %></div>
            </div>
            <div class="stat-card">
                <small>Active Customers</small>
                <div class="val"><%= totalUsers %></div>
            </div>
            <div class="stat-card" style="border-right: 4px solid var(--teal);">
                <small>Today's Transactions</small>
                <div class="val"><%= todayTransactions %></div>
            </div>
        </div>

        <div class="search-section">
            <h3>Customer Management</h3>
            <p style="color: #64748b; font-size: 0.9rem;">Search by Account Number to view or edit customer profile.</p>
            <form action="AdminSearchServlet" method="get" class="search-form">
                <input type="text" name="searchAcc" placeholder="e.g. 1001" required>
                <button type="submit" class="btn-search">Search Account</button>
            </form>

            <% if(request.getParameter("msg") != null) { %>
                <div style="margin-top:20px; padding:12px; background:#fee2e2; color:#b91c1c; border-radius:8px; font-size:0.9rem;">
                    ⚠️ <%= request.getParameter("msg") %>
                </div>
            <% } %>
        </div>
    </div>

</body>
</html>