<%@ page import="com.bank.entity.*, java.util.*, org.hibernate.*, com.bank.util.HibernateUtil" %>
<%
    User admin = (User) session.getAttribute("user");
    if(admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<body>
    <h2>Admin Control Panel - All Bank Accounts</h2>
    <table border="1" width="100%">
        <tr>
            <th>User ID</th><th>Full Name</th><th>Account No</th><th>Balance</th><th>Actions</th>
        </tr>
        <%
            try (Session s = HibernateUtil.getSessionFactory().openSession()) {
                List<Account> accounts = s.createQuery("FROM Account", Account.class).list();
                for(Account a : accounts) {
        %>
            <tr>
                <td><%= a.getUser().getUserId() %></td>
                <td><%= a.getUser().getFullName() %></td>
                <td><%= a.getAccountNumber() %></td>
                <td>₹ <%= a.getBalance() %></td>
                <td><button>Freeze Account</button></td>
            </tr>
        <% } } %>
    </table>
</body>
</html>