<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PaperIQ - Login</title>
    <style>
        body { font-family: Arial; margin: 50px; background: #f0f2f5; }
        .container { width: 400px; margin: auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #4CAF50; }
        input { width: 100%; padding: 10px; margin: 8px 0; border: 1px solid #ddd; border-radius: 4px; }
        button { width: 100%; padding: 10px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background: #45a049; }
        .error { color: red; margin: 10px 0; }
        .success { color: green; }
        .role-select { margin: 15px 0; }
        .role-select label { margin-right: 20px; }
    </style>
</head>
<body>
<%
    String msg = request.getParameter("msg");
    if(msg != null && msg.equals("loggedout")) {
        out.println("<div style='max-width:400px; margin:20px auto; padding:10px; background:#e8f5e9; color:#4CAF50; text-align:center; border-radius:4px;'>✅ You have been successfully logged out!</div>");
    }
%>
    <div class="container">
        <h2>📄 PaperIQ Login</h2>
        
        <%
        // Handle login
        if(request.getMethod().equals("POST")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/paperiq_db?useSSL=false", 
                    "root", "root123");
                
                String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                ResultSet rs = pstmt.executeQuery();
                
                if(rs.next()) {
                    // Login successful
                    session.setAttribute("user_id", rs.getInt("user_id"));
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("role", rs.getString("role"));
                    session.setAttribute("full_name", rs.getString("full_name"));
                    
                    // Redirect based on role
                    if(rs.getString("role").equals("admin")) {
                        response.sendRedirect("admin/dashboard.jsp");
                    } else {
                        response.sendRedirect("teacher/dashboard.jsp");
                    }
                } else {
                    out.println("<p class='error'>❌ Invalid username or password</p>");
                }
                
                rs.close();
                pstmt.close();
                conn.close();
            } catch(Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            }
        }
        %>
        
        <form method="post">
            <div>
                <label>Username:</label>
                <input type="text" name="username" required>
            </div>
            <div>
                <label>Password:</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit">Login</button>
        </form>
        
        <p style="text-align: center; margin-top: 20px;">
            <small>Admin | Teacher </small>
        </p>
    </div>
    <!-- Footer -->
<div style="text-align: center; margin-top: 30px; color: #666; font-size: 12px;">
    <small>
        PaperIQ © 2026 - Developed by Suraj Kumar (BCA, IGNOU) | Guide: Prof. Baleshwar Yadav
    </small>
</div>
</body>
</html>