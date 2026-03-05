<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PaperIQ - Edit Question</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .container { max-width: 600px; margin: auto; }
        .form-group { margin: 10px 0; }
        input, select, textarea { width: 100%; padding: 8px; margin: 5px 0; }
        .btn { padding: 10px; background: #4CAF50; color: white; border: none; cursor: pointer; }
        .btn-cancel { background: #f44336; }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Edit Question</h1>
        
        <%
        String questionId = request.getParameter("id");
        
        // Handle form submission
        if(request.getMethod().equals("POST")) {
            String question = request.getParameter("question");
            String levelId = request.getParameter("level_id");
            String topic = request.getParameter("topic");
            String marks = request.getParameter("marks");
            String difficulty = request.getParameter("difficulty");
            String qid = request.getParameter("question_id");
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/paperiq_db?useSSL=false", 
                    "root", "root123");
                
                String sql = "UPDATE questions SET question_text=?, level_id=?, topic=?, marks=?, difficulty=? WHERE question_id=?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, question);
                pstmt.setString(2, levelId);
                pstmt.setString(3, topic);
                pstmt.setString(4, marks);
                pstmt.setString(5, difficulty);
                pstmt.setString(6, qid);
                
                int result = pstmt.executeUpdate();
                
                if(result > 0) {
                    out.println("<p class='success'>✅ Question updated successfully!</p>");
                    response.sendRedirect("questions.jsp");
                } else {
                    out.println("<p class='error'>❌ Failed to update question</p>");
                }
                
                pstmt.close();
                conn.close();
            } catch(Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            }
        }
        
        // Fetch question data
        if(questionId != null && !questionId.isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/paperiq_db?useSSL=false", 
                    "root", "root123");
                
                String sql = "SELECT * FROM questions WHERE question_id = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, questionId);
                ResultSet rs = pstmt.executeQuery();
                
                if(rs.next()) {
        %>
        
        <form method="post">
            <input type="hidden" name="question_id" value="<%= rs.getInt("question_id") %>">
            
            <div class="form-group">
                <label>Question Text:</label>
                <textarea name="question" rows="4" required><%= rs.getString("question_text") %></textarea>
            </div>
            
            <div class="form-group">
                <label>Bloom Level:</label>
                <select name="level_id" required>
                    <%
                    // Get bloom levels
                    Statement stmt = conn.createStatement();
                    ResultSet levelRs = stmt.executeQuery("SELECT * FROM bloom_level");
                    
                    int currentLevel = rs.getInt("level_id");
                    while(levelRs.next()) {
                        int levelId = levelRs.getInt("level_id");
                        String selected = (levelId == currentLevel) ? "selected" : "";
                        out.println("<option value='" + levelId + "' " + selected + ">" + 
                                  levelRs.getString("level_name") + "</option>");
                    }
                    levelRs.close();
                    stmt.close();
                    %>
                </select>
            </div>
            
            <div class="form-group">
                <label>Topic:</label>
                <input type="text" name="topic" value="<%= rs.getString("topic") %>" required>
            </div>
            
            <div class="form-group">
                <label>Marks:</label>
                <input type="number" name="marks" value="<%= rs.getInt("marks") %>" min="1" required>
            </div>
            
            <div class="form-group">
                <label>Difficulty:</label>
                <select name="difficulty">
                    <option value="Easy" <%= rs.getString("difficulty").equals("Easy") ? "selected" : "" %>>Easy</option>
                    <option value="Medium" <%= rs.getString("difficulty").equals("Medium") ? "selected" : "" %>>Medium</option>
                    <option value="Hard" <%= rs.getString("difficulty").equals("Hard") ? "selected" : "" %>>Hard</option>
                </select>
            </div>
            
            <button type="submit" class="btn">Update Question</button>
            <a href="questions.jsp" class="btn btn-cancel">Cancel</a>
        </form>
        
        <%
                } else {
                    out.println("<p class='error'>Question not found!</p>");
                }
                
                rs.close();
                pstmt.close();
                conn.close();
            } catch(Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p class='error'>No question ID provided!</p>");
        }
        %>
    </div>
</body>
</html>