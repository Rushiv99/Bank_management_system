package com.bank.controller;

import com.bank.entity.*;
import com.bank.util.HibernateUtil;
import org.hibernate.Session;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/PrepareDownloadServlet")
public class PrepareDownloadServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String uidStr = req.getParameter("uid");
        HttpSession session = req.getSession();

        // 1. Logic Check: Ensure session and Map exist
        Map<Long, Account> userMap = (Map<Long, Account>) session.getAttribute("userMap");

        try {
            if (uidStr == null || userMap == null) {
                res.sendRedirect("login.jsp");
                return;
            }

            Account acc = userMap.get(Long.parseLong(uidStr));
            if (acc == null) {
                res.sendRedirect("login.jsp");
                return;
            }

            try (Session s = HibernateUtil.getSessionFactory().openSession()) {
                // Fix: Ensure 'accountNumber' matches the field name in your Transaction.java entity
                List<Transaction> list = s.createQuery("FROM Transaction WHERE accountNumber = :a ORDER BY id DESC", Transaction.class)
                        .setParameter("a", acc.getAccountNumber())
                        .list();

                req.setAttribute("transactions", list);
                req.setAttribute("account", acc);
                req.setAttribute("uid", uidStr);

                req.getRequestDispatcher("download_statement.jsp").forward(req, res);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Check your console/log for the real error!
            res.sendRedirect("dashboard.jsp?uid=" + uidStr + "&status=fail&msg=Statement Error: " + e.getMessage());
        }
    }
}