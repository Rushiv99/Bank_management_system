<%@ page import="com.bank.entity.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // LOGIC PRESERVED: UID and UserMap handling
    String uid = request.getParameter("uid");
    java.util.Map<Long, Account> userMap = (java.util.Map<Long, Account>) session.getAttribute("userMap");
    Account acc = (userMap != null && uid != null) ? userMap.get(Long.parseLong(uid)) : null;

    if (acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transfer Funds | United Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-navy: #1a237e;
            --accent-blue: #3949ab;
            --bg-soft: #f4f7fa;
            --text-dark: #1e293b;
            --white: #ffffff;
            --success: #2e7d32;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-soft);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            color: var(--text-dark);
        }

        .transfer-card {
            background: var(--white);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            width: 100%;
            max-width: 450px;
        }

        .header { text-align: center; margin-bottom: 30px; }
        .header h2 { margin: 0; color: var(--primary-navy); font-weight: 700; }
        .header p { color: #64748b; font-size: 0.9rem; margin-top: 5px; }

        /* Wallet/Balance Visual */
        .source-box {
            background: #f8f9ff;
            border: 1px dashed var(--accent-blue);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            text-align: center;
        }
        .source-box .label { font-size: 0.75rem; font-weight: 700; color: var(--accent-blue); text-transform: uppercase; letter-spacing: 0.5px; }
        .source-box .acc-no { font-size: 1.1rem; font-weight: 600; color: var(--text-dark); margin: 5px 0; }
        .source-box .balance { font-size: 0.9rem; color: var(--success); font-weight: 600; }

        label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-dark);
        }

        .input-wrapper { position: relative; margin-bottom: 20px; }
        .input-wrapper span {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-weight: 600;
        }

        input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            font-size: 1rem;
            box-sizing: border-box;
            transition: all 0.2s;
            background: #fcfcfc;
        }

        input:focus {
            outline: none;
            border-color: var(--accent-blue);
            background: #fff;
            box-shadow: 0 0 0 4px rgba(57, 73, 171, 0.05);
        }

        .btn-send {
            width: 100%;
            background: var(--primary-navy);
            color: white;
            padding: 15px;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 10px;
        }
        .btn-send:hover { background: var(--accent-blue); }

        .cancel-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 0.9rem;
            color: #64748b;
            text-decoration: none;
            transition: color 0.2s;
        }
        .cancel-link:hover { color: var(--primary-navy); text-decoration: underline; }

        .shield-icon { font-size: 0.8rem; color: var(--success); margin-top: 15px; display: flex; align-items: center; justify-content: center; gap: 5px; }
    </style>
</head>
<body>

    <div class="transfer-card">
        <div class="header">
            <h2>Transfer Funds</h2>
            <p>Send money securely to any United Bank account</p>
        </div>

        <div class="source-box">
            <div class="label">Your Account</div>
            <div class="acc-no">A/C: <%= acc.getAccountNumber() %></div>
            <div class="balance">Available: ₹ <%= String.format("%.2f", acc.getBalance()) %></div>
        </div>

        <form action="TransferServlet?uid=<%= uid %>" method="post">
            <div class="input-group">
                <label>Recipient Account Number</label>
                <input type="number" name="targetAcc" required placeholder="Enter 4 or more digits">
            </div>

            <div style="margin-top: 20px;">
                <label>Transfer Amount</label>
                <div class="input-wrapper">
                    <input type="number" name="amount" min="1" step="0.01" required placeholder="0.00" style="padding-left: 35px;">
                    <span>₹</span>
                </div>
            </div>

            <button type="submit" class="btn-send">Initiate Transfer</button>
        </form>

        <a href="dashboard.jsp?uid=<%= uid %>" class="cancel-link">Cancel and Return to Dashboard</a>

        <div class="shield-icon">
            <span>🛡️</span> Secure 256-bit Encrypted Transaction
        </div>
    </div>

</body>
</html>