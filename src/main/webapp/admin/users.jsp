<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if user is logged in and is admin
    if(session.getAttribute("user_id") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("../login.jsp");
        return;
    }
    String basePath = request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PaperIQ - Manage Users</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .container { max-width: 1000px; margin: auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .btn { padding: 8px 12px; text-decoration: none; color: white; border-radius: 3px; }
        .btn-add { background: #4CAF50; padding: 10px 15px; display: inline-block; margin: 10px 0; }
        .btn-edit { background: #2196F3; }
        .btn-delete { background: #f44336; }
        .nav { margin: 20px 0; }
        .nav a { margin-right: 15px; text-decoration: none; color: #4CAF50; }
    </style>
</head>
<body>
    <div class="container">
        <h1>👥 Manage Users</h1>
        
        <div class="nav">
            <a href="dashboard.jsp">🏠 Dashboard</a>
            <a href="<%= basePath %>questions.jsp">📋 Question Bank</a>
            <a href="<%= basePath %>paper-generator.jsp">📄 Generate Paper</a>
            <a href="<%= basePath %>logout.jsp">🔑 Logout</a>
        </div>
        
        <a href="add-user.jsp" class="btn btn-add">➕ Add New User</a>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Role</th>
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
                    
                    String sql = "SELECT * FROM users ORDER BY user_id";
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);
                    
                    while(rs.next()) {
                %>
                        <tr>
                            <td><%= rs.getInt("user_id") %></td>
                            <td><%= rs.getString("username") %></td>
                            <td><%= rs.getString("full_name") %></td>
                            <td><%= rs.getString("role") %></td>
                            <td>
                                <a href="edit-user.jsp?id=<%= rs.getInt("user_id") %>" class="btn btn-edit">Edit</a>
                                <a href="delete-user.jsp?id=<%= rs.getInt("user_id") %>" class="btn btn-delete" onclick="return confirm('Are you sure?')">Delete</a>
                            </td>
                        </tr>
                <%
                    }
                    
                    rs.close();
                    stmt.close();
                    conn.close();
                } catch(Exception e) {
                    out.println("<tr><td colspan='5' style='color:red'>Error: " + e.getMessage() + "</td></tr>");
                }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>