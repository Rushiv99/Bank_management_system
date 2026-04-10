package com.bank.controller;

import com.bank.entity.Account;
import com.bank.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String user = req.getParameter("username");
        String pass = req.getParameter("password");

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            // Fetch account based on user credentials
            Query<Account> q = s.createQuery("FROM Account a WHERE a.user.username = :u AND a.user.password = :p", Account.class);
            q.setParameter("u", user);
            q.setParameter("p", pass);
            Account account = q.uniqueResult();

            if (account != null) {
                HttpSession session = req.getSession();

                // 1. Get existing Map from session or create a new one
                Map<Long, Account> userMap = (Map<Long, Account>) session.getAttribute("userMap");
                if (userMap == null) {
                    userMap = new HashMap<>();
                }

                // 2. Store this account in the map using its Account Number as the Key
                userMap.put(account.getAccountNumber(), account);
                session.setAttribute("userMap", userMap);

                // 3. Redirect to dashboard with the UID in the URL
                res.sendRedirect("dashboard.jsp?uid=" + account.getAccountNumber());
            } else {
                res.sendRedirect("login.jsp?status=fail&msg=Invalid Credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("login.jsp?status=fail&msg=Database Error");
        }
    }
}