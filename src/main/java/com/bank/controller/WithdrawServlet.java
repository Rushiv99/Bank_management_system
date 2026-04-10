package com.bank.controller;

import com.bank.entity.Account;
import com.bank.entity.Transaction;
import com.bank.util.HibernateUtil;
import org.hibernate.Session;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/WithdrawServlet")
public class WithdrawServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String uidStr = req.getParameter("uid");
        String amountStr = req.getParameter("amount");

        if (uidStr == null || amountStr == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        long uid = Long.parseLong(uidStr);
        double amount = Double.parseDouble(amountStr);

        HttpSession session = req.getSession();
        Map<Long, Account> userMap = (Map<Long, Account>) session.getAttribute("userMap");
        Account acc = (userMap != null) ? userMap.get(uid) : null;

        if (acc != null && amount > 0) {
            if (acc.getBalance() < amount) {
                res.sendRedirect("dashboard.jsp?uid=" + uid + "&status=fail&msg=Insufficient Balance");
                return;
            }

            try (Session s = HibernateUtil.getSessionFactory().openSession()) {
                org.hibernate.Transaction tx = s.beginTransaction();

                // 1. Update Account Balance
                acc.setBalance(acc.getBalance() - amount);
                s.merge(acc);

                // 2. Record Transaction
                Transaction t = new Transaction();
                t.setAccountNumber(acc.getAccountNumber());
                t.setType("WITHDRAW");
                t.setAmount(amount);
                s.persist(t);

                tx.commit();

                // 3. Update the object inside our Session Map for the Dashboard
                userMap.put(uid, acc);

                res.sendRedirect("dashboard.jsp?uid=" + uid + "&status=success&msg=Rupees " + amount + " Withdrawn!");
            } catch (Exception e) {
                e.printStackTrace();
                res.sendRedirect("dashboard.jsp?uid=" + uid + "&status=fail&msg=Server Error");
            }
        } else {
            res.sendRedirect("dashboard.jsp?uid=" + uid + "&status=fail&msg=Invalid Amount");
        }
    }
}