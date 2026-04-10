package com.bank.controller;

import com.bank.entity.Account;
import com.bank.util.HibernateUtil;
import org.hibernate.Session;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AdminSearchServlet")
public class AdminSearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String accNoStr = req.getParameter("searchAcc");

        if (accNoStr == null || accNoStr.trim().isEmpty()) {
            res.sendRedirect("admin_dashboard.jsp?msg=Please enter an account number");
            return;
        }

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            long searchVal = Long.parseLong(accNoStr.trim());

            // FIXED: Used 'Account' (Class Name) instead of 'accounts' (Table Name)
            // FIXED: Used 'accountNumber' (Variable Name) instead of 'account_number' (Column Name)
            Account targetAcc = s.createQuery("FROM Account WHERE accountNumber = :a", Account.class)
                    .setParameter("a", searchVal)
                    .uniqueResult();

            if (targetAcc != null) {
                req.setAttribute("customerAcc", targetAcc);
                req.getRequestDispatcher("edit_customer.jsp").forward(req, res);
            } else {
                res.sendRedirect("admin_dashboard.jsp?msg=Account " + accNoStr + " not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("admin_dashboard.jsp?msg=Search Error: " + e.getMessage());
        }
    }
}