<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Open Account | United Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-navy: #1a237e;
            --accent-blue: #3949ab;
            --success-green: #2e7d32;
            --error-red: #c62828;
            --bg-gray: #f0f2f5;
            --white: #ffffff;
        }

        body {
            margin: 0;
            padding: 40px 20px;
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-gray);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .register-card {
            background: var(--white);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            box-sizing: border-box;
        }

        /* ACKNOWLEDGEMENT STYLE */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            text-align: center;
            border: 1px solid transparent;
        }
        .alert-success { background: #e8f5e9; color: var(--success-green); border-color: #c8e6c9; }
        .alert-error { background: #ffebee; color: var(--error-red); border-color: #ffcdd2; }

        .bank-logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-navy);
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        h2 { font-size: 1.5rem; color: #1e293b; margin: 0 0 10px 0; font-weight: 700; }
        p.subtitle { color: #64748b; font-size: 0.95rem; margin: 0 0 30px 0; }

        .input-group { margin-bottom: 20px; width: 100%; }
        .form-row { display: flex; gap: 15px; width: 100%; }
        .form-row .input-group { flex: 1; }

        label {
            display: block;
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--primary-navy);
            margin-bottom: 8px;
            text-transform: uppercase;
        }

        input, select {
            width: 100% !important;
            padding: 12px 14px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 0.95rem;
            background-color: #fcfcfc;
        }

        button {
            width: 100%;
            padding: 14px;
            background-color: var(--success-green);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
        }

        .footer-links { margin-top: 25px; font-size: 0.9rem; color: #64748b; text-align: center; }
        .footer-links a { color: var(--accent-blue); text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>

    <div class="register-card">
        <div class="bank-logo">
            <span>🏦</span> UNITED BANK
        </div>

        <%
            String status = request.getParameter("status");
            String msg = request.getParameter("msg");
            if (status != null && msg != null) {
        %>
            <div class="alert <%= status.equals("success") ? "alert-success" : "alert-error" %>">
                <%= status.equals("success") ? "✅" : "⚠️" %> <%= msg %>
            </div>
        <% } %>

        <h2>Create Account</h2>
        <p class="subtitle">Join United Bank and experience modern banking.</p>

        <form action="RegisterServlet" method="post">
            <div class="input-group">
                <label>Full Name</label>
                <input type="text" name="fullName" placeholder="John Doe" required>
            </div>

            <div class="input-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="john@example.com" required>
            </div>

            <div class="form-row">
                <div class="input-group">
                    <label>Username</label>
                    <input type="text" name="username" placeholder="jdoe24" required>
                </div>
                <div class="input-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="••••••••" required>
                </div>
            </div>

            <div class="input-group">
                <label>Account Type</label>
                <select name="accType">
                    <option value="SAVINGS">SAVINGS ACCOUNT</option>
                    <option value="CURRENT">CURRENT ACCOUNT</option>
                </select>
            </div>

            <button type="submit">Verify & Open Account</button>
        </form>

        <div class="footer-links">
            <p>Already have an account? <a href="login.jsp">Login here</a></p>
        </div>
    </div>

</body>
</html>