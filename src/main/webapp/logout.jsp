<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout - PaperIQ</title>
    <style>
        body { font-family: Arial; margin: 50px; text-align: center; background: #f0f2f5; }
        .container { max-width: 400px; margin: auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #4CAF50; }
        .buttons { margin-top: 30px; }
        .btn { padding: 10px 20px; margin: 0 10px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        .btn-yes { background: #f44336; color: white; }
        .btn-no { background: #4CAF50; color: white; }
        .btn:hover { opacity: 0.9; }
        .footer { margin-top: 30px; color: #666; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>📄 PaperIQ</h2>
        <p>Are you sure you want to logout?</p>
        
        <div class="buttons">
            <button class="btn btn-yes" onclick="confirmLogout()">Yes, Logout</button>
            <button class="btn btn-no" onclick="goBack()">No, Stay</button>
        </div>
        
        <div class="footer">
            <small>Developed by: Suraj Kumar (BCA, IGNOU)</small>
        </div>
    </div>
    
    <script>
        function confirmLogout() {
            // Invalidate session and redirect to login
            window.location.href = "logout-process.jsp";
        }
        
        function goBack() {
            window.history.back();
        }
    </script>
</body>
</html>