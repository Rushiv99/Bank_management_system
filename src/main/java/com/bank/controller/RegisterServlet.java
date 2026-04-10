package com.bank.controller;
import com.bank.entity.*;
import com.bank.util.HibernateUtil;
import org.hibernate.Session;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        User u = new User();
        u.setFullName(req.getParameter("fullName"));
        u.setEmail(req.getParameter("email"));
        u.setUsername(req.getParameter("username"));
        u.setPassword(req.getParameter("password"));

        Account a = new Account();
        a.setAccountType(req.getParameter("accType"));
        a.setBalance(0.0);
        a.setUser(u);

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            org.hibernate.Transaction tx = s.beginTransaction();
            s.persist(u);
            s.persist(a);
            tx.commit();
        }
        res.sendRedirect("login.jsp");
    }
}