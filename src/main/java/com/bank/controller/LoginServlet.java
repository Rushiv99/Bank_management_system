package com.bank.controller;

import com.bank.entity.Account;
import com.bank.entity.User;
import com.bank.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String user = req.getParameter("username");
        String pass = req.getParameter("password");

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            // Fetch account and join with user
            Query<Account> q = s.createQuery("FROM Account WHERE user.username = :u AND user.password = :p", Account.class);
            q.setParameter("u", user);
            q.setParameter("p", pass);

            Account account = q.uniqueResult();

            if (account != null) {
                User u = account.getUser();
                HttpSession session = req.getSession();

                // ROLE BASED REDIRECTION
                if ("ADMIN".equalsIgnoreCase(u.getRole())) {
                    // 1. Admin Logic
                    session.setAttribute("adminUser", u);
                    res.sendRedirect("admin_dashboard.jsp");
                } else {
                    // 2. Customer Logic (UID Multi-tab support)
                    Map<Long, Account> userMap = (Map<Long, Account>) session.getAttribute("userMap");
                    if (userMap == null) {
                        userMap = new HashMap<>();
                    }
                    userMap.put(account.getAccountNumber(), account);
                    session.setAttribute("userMap", userMap);

                    res.sendRedirect("dashboard.jsp?uid=" + account.getAccountNumber());
                }
            } else {
                res.sendRedirect("login.jsp?status=fail&msg=Invalid Username or Password");
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("login.jsp?status=fail&msg=System Error");
        }
    }
}