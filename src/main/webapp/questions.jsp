<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if user is logged in and is admin
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if(!session.getAttribute("role").equals("admin")) {
        response.sendRedirect("view-questions.jsp");
        return;
    }
    String basePath = request.getContextPath() + "/";
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PaperIQ - Question Bank</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .container { max-width: 1200px; margin: auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .btn { padding: 8px 12px; margin: 2px; text-decoration: none; color: white; display: inline-block; border-radius: 3px; }
        .btn-add { background: #FF9800; padding: 10px 15px; margin: 10px 0; display: inline-block; }
        .btn-edit { background: #2196F3; }
        .btn-delete { background: #f44336; }
        .btn-generate { background: #FF9800; }
        .nav-links { margin: 20px 0; }
        .nav-links a { margin-right: 15px; text-decoration: none; color: #4CAF50; font-weight: bold; }
        .nav-links a:hover { text-decoration: underline; }
        .success { color: green; background: #e8f5e9; padding: 10px; border-radius: 4px; }
        .error { color: red; background: #ffebee; padding: 10px; border-radius: 4px; }
        .logout { float: right; background: #f44336; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; }
        .logout:hover { background: #d32f2f; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📋 PaperIQ - Question Bank <a href="logout.jsp" class="logout">Logout</a></h1>
        
        <div class="nav-links">
            <a href="add-question.jsp" class="btn btn-add">➕ Add New Question</a>
            <a href="paper-generator.jsp" class="btn btn-generate">📄 Generate Paper</a>
            <a href="<%= role.equals("admin") ? "admin/dashboard.jsp" : "teacher/dashboard.jsp" %>">🏠 Dashboard</a>
        </div>
        
        <%
        // Show messages
        String msg = request.getParameter("msg");
        String error = request.getParameter("error");
        if(msg != null && msg.equals("deleted")) {
            out.println("<div class='success'>✅ Question deleted successfully!</div>");
        }
        if(error != null) {
            out.println("<div class='error'>❌ Error: " + error + "</div>");
        }
        %>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Question</th>
                    <th>Bloom Level</th>
                    <th>Topic</th>
                    <th>Marks</th>
                    <th>Difficulty</th>
                    <th>Actions</th>
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
                %>
                        <tr>
                            <td><%= rs.getInt("question_id") %></td>
                            <td><%= rs.getString("question_text") %></td>
                            <td><%= rs.getString("level_name") %></td>
                            <td><%= rs.getString("topic") %></td>
                            <td><%= rs.getInt("marks") %></td>
                            <td><%= rs.getString("difficulty") %></td>
                            <td>
                                <a href="edit-question.jsp?id=<%= rs.getInt("question_id") %>" class="btn btn-edit">Edit</a>
                                <a href="delete-question.jsp?id=<%= rs.getInt("question_id") %>" class="btn btn-delete" onclick="return confirm('Are you sure?')">Delete</a>
                            </td>
                        </tr>
                <%
                    }
                    
                    rs.close();
                    stmt.close();
                    conn.close();
                } catch(Exception e) {
                    out.println("<tr><td colspan='7' style='color:red'>Error: " + e.getMessage() + "</td></tr>");
                }
                %>
            </tbody>
        </table>
    </div>
    <!-- Footer -->
<div style="text-align: center; margin-top: 50px; padding: 20px; color: #666; font-size: 12px; border-top: 1px solid #ddd;">
    <small>
        PaperIQ © 2026 - Automated Question Paper System<br>
        Developed by: <strong>Suraj Kumar</strong> <br>
        BCA, IGNOU | 
    </small>
</div>
</body>
</html>