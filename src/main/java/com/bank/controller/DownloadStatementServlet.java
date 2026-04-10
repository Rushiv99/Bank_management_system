package com.bank.controller;

import com.bank.entity.Account;
import com.bank.entity.Transaction;
import com.bank.util.HibernateUtil;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import org.hibernate.Session;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

@WebServlet("/DownloadStatementServlet")
public class DownloadStatementServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        Account acc = (session != null) ? (Account) session.getAttribute("account") : null;

        if (acc == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        // 1. Fetch Data First
        List<com.bank.entity.Transaction> list;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            list = s.createQuery("FROM Transaction WHERE account_number = :a ORDER BY id DESC", com.bank.entity.Transaction.class)
                    .setParameter("a", acc.getAccountNumber())
                    .list();
        }

        // 2. Build PDF in a Byte Array (This is the most stable way)
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document();

        try {
            PdfWriter.getInstance(document, baos);
            document.open();

            document.add(new Paragraph("UNITED BANK STATEMENT"));
            document.add(new Paragraph("Account: " + acc.getAccountNumber()));
            document.add(new Paragraph("Customer: " + acc.getUser().getFullName()));
            document.add(new Paragraph(" "));

            PdfPTable table = new PdfPTable(3);
            table.setWidthPercentage(100);
            table.addCell("Date"); table.addCell("Type"); table.addCell("Amount");

            for (com.bank.entity.Transaction t : list) {
                table.addCell(t.getDate().toString());
                table.addCell(t.getType());
                table.addCell(String.valueOf(t.getAmount()));
            }
            document.add(table);
            document.close(); // MUST CLOSE HERE

            // 3. NOW send to response
            byte[] pdfBytes = baos.toByteArray();
            res.setContentType("application/pdf");
            res.setContentLength(pdfBytes.length);
            res.setHeader("Content-Disposition", "attachment; filename=Statement.pdf");

            OutputStream os = res.getOutputStream();
            os.write(pdfBytes);
            os.flush();
            os.close();

        } catch (DocumentException e) {
            e.printStackTrace();
        }
    }
}