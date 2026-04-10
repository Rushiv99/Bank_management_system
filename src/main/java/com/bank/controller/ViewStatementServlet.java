package com.bank.controller;

import com.bank.entity.Account;
import com.bank.entity.Transaction;
import com.bank.util.HibernateUtil;
import org.hibernate.Session;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/ViewStatementServlet")
public class ViewStatementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        String uid = req.getParameter("uid");
        HttpSession session = req.getSession();

        // 1. Get the Map of all logged-in users in this browser session
        Map<Long, Account> userMap = (Map<Long, Account>) session.getAttribute("userMap");

        // 2. Identify the specific account for THIS tab
        Account acc = (userMap != null && uid != null) ? userMap.get(Long.parseLong(uid)) : null;

        // 3. Security: If no account matches the UID, it's an invalid session
        if (acc == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            // 4. Fetch the data. Use 'accountNumber' (camelCase) to match your Entity field
            List<Transaction> fullList = s.createQuery("FROM Transaction WHERE accountNumber = :a ORDER BY id DESC", Transaction.class)
                    .setParameter("a", acc.getAccountNumber())
                    .list();

            // 5. Pack the data and the UID into the Request object
            req.setAttribute("statementData", fullList);
            req.setAttribute("uid", uid);

            // 6. Forward to the JSP (Forwarding keeps the Request attributes alive)
            RequestDispatcher rd = req.getRequestDispatcher("full_statement.jsp");
            rd.forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("dashboard.jsp?uid=" + uid + "&status=fail&msg=Error loading statement");
        }
    }
}