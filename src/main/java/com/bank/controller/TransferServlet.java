package com.bank.controller;

import com.bank.entity.Account;
import com.bank.entity.Transaction;
import com.bank.util.HibernateUtil;
import org.hibernate.Session;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/TransferServlet")
public class TransferServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        // 1. Get UID from URL and Transfer details from Form
        String uidStr = req.getParameter("uid");
        String targetAccStr = req.getParameter("targetAcc");
        String amountStr = req.getParameter("amount");

        if (uidStr == null || targetAccStr == null || amountStr == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        long uid = Long.parseLong(uidStr);
        long targetAccNo = Long.parseLong(targetAccStr);
        double amount = Double.parseDouble(amountStr);

        HttpSession session = req.getSession();
        Map<Long, Account> userMap = (Map<Long, Account>) session.getAttribute("userMap");

        // 2. Get SENDER from the Map (This was the null part!)
        Account senderAcc = (userMap != null) ? userMap.get(uid) : null;

        if (senderAcc == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            org.hibernate.Transaction tx = s.beginTransaction();

            // 3. Find RECEIVER in Database
            Account receiverAcc = s.createQuery("FROM Account WHERE account_number = :acc", Account.class)
                    .setParameter("acc", targetAccNo)
                    .uniqueResult();

            if (receiverAcc == null) {
                res.sendRedirect("dashboard.jsp?uid=" + uid + "&status=fail&msg=Receiver Account Not Found");
                return;
            }

            if (senderAcc.getBalance() < amount) {
                res.sendRedirect("dashboard.jsp?uid=" + uid + "&status=fail&msg=Insufficient Balance");
                return;
            }

            // 4. Perform the Transfer
            senderAcc.setBalance(senderAcc.getBalance() - amount);
            receiverAcc.setBalance(receiverAcc.getBalance() + amount);

            // 5. Save Transactions for both
            Transaction t1 = new Transaction();
            t1.setAccountNumber(senderAcc.getAccountNumber());
            t1.setType("TRANSFER TO " + targetAccNo);
            t1.setAmount(amount);

            Transaction t2 = new Transaction();
            t2.setAccountNumber(receiverAcc.getAccountNumber());
            t2.setType("RECEIVED FROM " + senderAcc.getAccountNumber());
            t2.setAmount(amount);

            s.merge(senderAcc);
            s.merge(receiverAcc);
            s.persist(t1);
            s.persist(t2);

            tx.commit();

            // 6. Update the Map in Session so Dashboard reflects new balance
            userMap.put(uid, senderAcc);

            res.sendRedirect("dashboard.jsp?uid=" + uid + "&status=success&msg=Transfer Successful");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("dashboard.jsp?uid=" + uid + "&status=fail&msg=Transaction Failed");
        }
    }
}