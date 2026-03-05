<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if user is logged in
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String role = (String) session.getAttribute("role");
    String basePath = request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PaperIQ - View Questions</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #f0f2f5; }
        .container { max-width: 1200px; margin: auto; }
        h1 { color: #2196F3; display: inline-block; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #2196F3; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        tr:hover { background-color: #e8f4f8; }
        .nav { background: white; padding: 15px; border-radius: 8px; margin: 20px 0; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .nav a { margin-right: 20px; text-decoration: none; color: #2196F3; font-weight: bold; }
        .nav a:hover { text-decoration: underline; }
        .logout { float: right; background: #f44336; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; }
        .logout:hover { background: #d32f2f; }
        .note { background: #fff3cd; color: #856404; padding: 15px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #ffc107; }
        .footer { text-align: center; margin-top: 50px; padding: 20px; color: #666; font-size: 12px; border-top: 1px solid #ddd; background: white; border-radius: 8px; }
        .student-info { background: #e3f2fd; padding: 5px 15px; border-radius: 20px; display: inline-block; margin-left: 20px; font-size: 14px; color: #1976D2; }
        .badge { background: #4CAF50; color: white; padding: 3px 8px; border-radius: 12px; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📋 View Questions</h1>
        <span class="student-info">Developed by: Suraj Kumar (BCA, IGNOU)</span>
        <a href="logout.jsp" class="logout">Logout</a>
        
        <div class="nav">
            <a href="teacher/dashboard.jsp">🏠 Dashboard</a>
            <a href="paper-generator.jsp">📄 Generate Paper</a>
            <a href="paper-history.jsp">📊 Paper History</a>
        </div>
        
        <div class="note">
            👁️ You are in <strong>read-only mode</strong>. You can view questions but cannot add, edit, or delete them.
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Question</th>
                    <th>Bloom Level</th>
                    <th>Topic</th>
                    <th>Marks</th>
                    <th>Difficulty</th>
                </tr>
            </thead>
            <tbody>
                <% 
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/paperiq_db?useSSL=false", 
                        "root", "root123");
                    
                    String sql = "SELECT q.*, b.level_name FROM questions q " +
                                 "JOIN bloom_level b ON q.level_id = b.level_id ORDER BY q.question_id";
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);
                    
                    while(rs.next()) {
                        String difficulty = rs.getString("difficulty");
                        String badgeColor = difficulty.equals("Easy") ? "#4CAF50" : 
                                          (difficulty.equals("Medium") ? "#FF9800" : "#f44336");
                %>
                        <tr>
                            <td><%= rs.getInt("question_id") %></td>
                            <td><%= rs.getString("question_text") %></td>
                            <td><span class="badge" style="background:<%= badgeColor %>;"><%= rs.getString("level_name") %></span></td>
                            <td><%= rs.getString("topic") %></td>
                            <td><%= rs.getInt("marks") %></td>
                            <td><span style="color:<%= badgeColor %>; font-weight:bold;"><%= difficulty %></span></td>
                        </tr>
                <%
                    }
                    
                    rs.close();
                    stmt.close();
                    conn.close();
                } catch(Exception e) {
                    out.println("<tr><td colspan='6' style='color:red'>Error: " + e.getMessage() + "</td></tr>");
                }
                %>
            </tbody>
        </table>
        
        <div class="footer">
            <small>
                PaperIQ © 2026 - Automated Question Paper System<br>
                Developed by: <strong>Suraj Kumar</strong> (Enrollment No: 2351352563)<br>
                BCA, IGNOU | Guide: Prof. Baleshwar Yadav<br>
                Study Centre: (0528) St. Columba's College, Hazaribagh | Regional Centre: (032) Ranchi
            </small>
        </div>
    </div>
</body>
</html>