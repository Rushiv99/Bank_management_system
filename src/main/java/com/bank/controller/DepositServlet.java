package com.bank.controller;

import com.bank.entity.Account;
import com.bank.entity.Transaction;
import com.bank.util.HibernateUtil;
import org.hibernate.Session;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/DepositServlet")
public class DepositServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        // 1. Get the UID and Amount from the request
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

        // 2. Retrieve the specific account for THIS tab/UID
        Account acc = (userMap != null) ? userMap.get(uid) : null;

        if (acc != null && amount > 0) {
            try (Session s = HibernateUtil.getSessionFactory().openSession()) {
                org.hibernate.Transaction tx = s.beginTransaction();

                // 3. Update Account Balance
                acc.setBalance(acc.getBalance() + amount);
                s.merge(acc);

                // 4. Record Transaction
                Transaction t = new Transaction();
                t.setAccountNumber(acc.getAccountNumber());
                t.setType("DEPOSIT");
                t.setAmount(amount);
                s.persist(t);

                tx.commit();

                // 5. Update the object inside our Session Map
                userMap.put(uid, acc);

                // 6. Redirect back with the UID to stay in the same tab's user context
                res.sendRedirect("dashboard.jsp?uid=" + uid + "&status=success&msg=Rupees " + amount + " Deposited!");
            } catch (Exception e) {
                e.printStackTrace();
                res.sendRedirect("dashboard.jsp?uid=" + uid + "&status=fail&msg=Server Error");
            }
        } else {
            res.sendRedirect("dashboard.jsp?uid=" + uid + "&status=fail&msg=Invalid Amount");
        }
    }
}