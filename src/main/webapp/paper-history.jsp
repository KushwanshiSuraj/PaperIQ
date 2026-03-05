<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // Check if user is logged in
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    int userId = (Integer) session.getAttribute("user_id");
    String basePath = request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PaperIQ - Paper History</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #f0f2f5; }
        .container { max-width: 1200px; margin: auto; }
        .header { background: #4CAF50; color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .nav { background: white; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .nav a { margin-right: 20px; text-decoration: none; color: #4CAF50; font-weight: bold; }
        .nav a:hover { text-decoration: underline; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .paper-item { border: 1px solid #ddd; margin: 10px 0; padding: 15px; border-radius: 4px; }
        .paper-item:hover { background: #f9f9f9; }
        .paper-date { color: #666; font-size: 14px; }
        .paper-detail { margin-top: 10px; padding: 10px; background: #f5f5f5; border-radius: 4px; display: none; }
        .btn-view { background: #2196F3; color: white; padding: 5px 10px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-view:hover { background: #1976D2; }
        .logout { float: right; background: #f44336; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; }
        .footer { text-align: center; margin-top: 30px; padding: 20px; color: #666; font-size: 12px; border-top: 1px solid #ddd; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #4CAF50; color: white; padding: 10px; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📄 PaperIQ - Paper History</h1>
            <a href="logout.jsp" class="logout">Logout</a>
        </div>
        
        <div class="nav">
            <% if(role.equals("admin")) { %>
                <a href="admin/dashboard.jsp">🏠 Dashboard</a>
                <a href="questions.jsp">📋 Question Bank</a>
            <% } else { %>
                <a href="teacher/dashboard.jsp">🏠 Dashboard</a>
                <a href="view-questions.jsp">📋 View Questions</a>
            <% } %>
            <a href="paper-generator.jsp">📄 Generate Paper</a>
            <a href="paper-history.jsp">📊 Paper History</a>
        </div>
        
        <div class="card">
            <h2>Generated Papers History</h2>
            
            <table>
                <thead>
                    <tr>
                        <th>Paper ID</th>
                        <th>Teacher</th>
                        <th>Topic</th>
                        <th>Total Marks</th>
                        <th>Distribution</th>
                        <th>Date</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/paperiq_db?useSSL=false", 
                            "root", "root123");
                        
                        String sql = "SELECT * FROM generated_papers ";
                        if(role.equals("teacher")) {
                            sql += "WHERE user_id = ? ";
                        }
                        sql += "ORDER BY generated_date DESC";
                        
                        PreparedStatement pstmt = conn.prepareStatement(sql);
                        if(role.equals("teacher")) {
                            pstmt.setInt(1, userId);
                        }
                        ResultSet rs = pstmt.executeQuery();
                        
                        while(rs.next()) {
                    %>
                            <tr>
                                <td><%= rs.getInt("paper_id") %></td>
                                <td><%= rs.getString("username") %></td>
                                <td><%= rs.getString("topic") %></td>
                                <td><%= rs.getInt("total_marks") %></td>
                                <td>
                                    R<%= rs.getInt("remember_marks") %> 
                                    U<%= rs.getInt("understand_marks") %> 
                                    Ap<%= rs.getInt("apply_marks") %> 
                                    An<%= rs.getInt("analyze_marks") %> 
                                    E<%= rs.getInt("evaluate_marks") %> 
                                    C<%= rs.getInt("create_marks") %>
                                </td>
                                <td><%= rs.getTimestamp("generated_date") %></td>
                                <td>
                                    <button class="btn-view" onclick="showDetails(<%= rs.getInt("paper_id") %>)">View Questions</button>
                                </td>
                            </tr>
                            <tr id="details-<%= rs.getInt("paper_id") %>" style="display:none;">
                                <td colspan="7">
                                    <div style="padding: 15px; background: #f9f9f9;">
                                        <h4>Questions in this paper:</h4>
                                        <%
                                        String sql2 = "SELECT * FROM paper_questions WHERE paper_id = ? ORDER BY question_number";
                                        PreparedStatement pstmt2 = conn.prepareStatement(sql2);
                                        pstmt2.setInt(1, rs.getInt("paper_id"));
                                        ResultSet rs2 = pstmt2.executeQuery();
                                        
                                        while(rs2.next()) {
                                        %>
                                            <p>
                                                <strong>Q<%= rs2.getInt("question_number") %>.</strong>
                                                <%= rs2.getString("question_text") %>
                                                <span style="color:#4CAF50;">[<%= rs2.getInt("marks") %> marks]</span>
                                                <br><small>Level: <%= rs2.getString("level_name") %></small>
                                            </p>
                                        <%
                                        }
                                        rs2.close();
                                        pstmt2.close();
                                        %>
                                    </div>
                                </td>
                            </tr>
                    <%
                        }
                        rs.close();
                        pstmt.close();
                        conn.close();
                    } catch(Exception e) {
                        out.println("<tr><td colspan='7' style='color:red'>Error: " + e.getMessage() + "</td></tr>");
                    }
                    %>
                </tbody>
            </table>
        </div>
        
        <div class="footer">
            <small>PaperIQ © 2026 - Developed by Suraj Kumar (BCA, IGNOU) |</small>
        </div>
    </div>
    
    <script>
    function showDetails(paperId) {
        var row = document.getElementById("details-" + paperId);
        if(row.style.display === "none") {
            row.style.display = "table-row";
        } else {
            row.style.display = "none";
        }
    }
    </script>
</body>
</html>