package com.bank.controller;

import com.bank.entity.*;
import com.bank.util.HibernateUtil;
import org.hibernate.Session;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ActionServlet")
public class ActionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String actionType = req.getParameter("actionType"); // "DEPOSIT" or "WITHDRAW"
        double amount = Double.parseDouble(req.getParameter("amount"));

        HttpSession session = req.getSession();
        Account acc = (Account) session.getAttribute("account");

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            org.hibernate.Transaction tx = s.beginTransaction();

            if ("WITHDRAW".equals(actionType)) {
                if (acc.getBalance() < amount) {
                    res.sendRedirect("dashboard.jsp?error=LowBalance");
                    return;
                }
                acc.setBalance(acc.getBalance() - amount);
            } else {
                acc.setBalance(acc.getBalance() + amount);
            }

            // Log the Transaction
            Transaction t = new Transaction();
            t.setAccountNumber(acc.getAccountNumber());
            t.setType(actionType);
            t.setAmount(amount);

            s.update(acc);
            s.persist(t);

            tx.commit();
            // Refresh session data
            session.setAttribute("account", acc);
            res.sendRedirect("dashboard.jsp?msg=Success");
        }
    }
}