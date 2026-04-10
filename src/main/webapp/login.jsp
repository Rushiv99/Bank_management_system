<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Login | United Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-navy: #1a237e;
            --accent-blue: #3949ab;
            --bg-gray: #f0f2f5;
            --text-dark: #1e293b;
            --white: #ffffff;
            --error-red: #d32f2f;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-gray);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-card {
            background: var(--white);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        .bank-logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-navy);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        h2 {
            font-size: 1.25rem;
            color: var(--text-dark);
            margin-bottom: 25px;
            font-weight: 600;
        }

        .input-group {
            margin-bottom: 20px;
            text-align: left;
        }

        label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #64748b;
            margin-bottom: 6px;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 1rem;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input:focus {
            outline: none;
            border-color: var(--accent-blue);
            box-shadow: 0 0 0 3px rgba(57, 73, 171, 0.1);
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: var(--primary-navy);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 10px;
        }

        button:hover {
            background-color: var(--accent-blue);
        }

        .footer-links {
            margin-top: 25px;
            font-size: 0.9rem;
            color: #64748b;
        }

        .footer-links a {
            color: var(--accent-blue);
            text-decoration: none;
            font-weight: 600;
        }

        .footer-links a:hover {
            text-decoration: underline;
        }

        /* Error message styling */
        .status-msg {
            background: #ffebee;
            color: var(--error-red);
            padding: 10px;
            border-radius: 6px;
            font-size: 0.85rem;
            margin-bottom: 20px;
            border: 1px solid #ffcdd2;
        }
    </style>
</head>
<body>

    <div class="login-card">
        <div class="bank-logo">
            <span>🏦</span> UNITED BANK
        </div>
        <h2>Sign in to Online Banking</h2>

        <%
            String status = request.getParameter("status");
            String msg = request.getParameter("msg");
            if ("fail".equals(status)) {
        %>
            <div class="status-msg"><%= msg %></div>
        <% } %>

        <form action="LoginServlet" method="post">
            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="Enter your username" required>
            </div>

            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>

            <button type="submit">Secure Login</button>
        </form>

        <div class="footer-links">
            <p>New user? <a href="register.jsp">Open an account here</a></p>
        </div>
    </div>

</body>
</html>