package com.bank.controller;

import com.bank.entity.User;
import com.bank.util.HibernateUtil;
import org.hibernate.Session;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/PasswordServlet")
public class PasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String newPass = req.getParameter("newPassword");

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            org.hibernate.Transaction tx = s.beginTransaction();

            user.setPassword(newPass);
            s.update(user);

            tx.commit();
            res.sendRedirect("dashboard.jsp?msg=PasswordChanged");
        }
    }
}