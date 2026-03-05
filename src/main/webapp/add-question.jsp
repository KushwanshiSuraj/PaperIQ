<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PaperIQ - Add Question</title>
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
        <h1>Add New Question</h1>
        
        <%
        // Handle form submission
        if(request.getMethod().equals("POST")) {
            String question = request.getParameter("question");
            String levelId = request.getParameter("level_id");
            String topic = request.getParameter("topic");
            String marks = request.getParameter("marks");
            String difficulty = request.getParameter("difficulty");
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/paperiq_db?useSSL=false", 
                    "root", "root123");
                
                String sql = "INSERT INTO questions (question_text, level_id, topic, marks, difficulty) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, question);
                pstmt.setString(2, levelId);
                pstmt.setString(3, topic);
                pstmt.setString(4, marks);
                pstmt.setString(5, difficulty);
                
                int result = pstmt.executeUpdate();
                
                if(result > 0) {
                    out.println("<p class='success'>✅ Question added successfully!</p>");
                } else {
                    out.println("<p class='error'>❌ Failed to add question</p>");
                }
                
                pstmt.close();
                conn.close();
            } catch(Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            }
        }
        %>
        
        <form method="post">
            <div class="form-group">
                <label>Question Text:</label>
                <textarea name="question" rows="4" required></textarea>
            </div>
            
            <div class="form-group">
                <label>Bloom Level:</label>
                <select name="level_id" required>
                    <option value="">Select Level</option>
                    <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/paperiq_db?useSSL=false", 
                            "root", "root123");
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM bloom_level");
                        
                        while(rs.next()) {
                            out.println("<option value='" + rs.getInt("level_id") + "'>" + 
                                      rs.getString("level_name") + "</option>");
                        }
                        
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch(Exception e) {
                        out.println("<option>Error loading levels</option>");
                    }
                    %>
                </select>
            </div>
            
            <div class="form-group">
                <label>Topic:</label>
                <input type="text" name="topic" required>
            </div>
            
            <div class="form-group">
                <label>Marks:</label>
                <input type="number" name="marks" value="2" min="1" required>
            </div>
            
            <div class="form-group">
                <label>Difficulty:</label>
                <select name="difficulty">
                    <option value="Easy">Easy</option>
                    <option value="Medium" selected>Medium</option>
                    <option value="Hard">Hard</option>
                </select>
            </div>
            
            <button type="submit" class="btn">Add Question</button>
            <a href="questions.jsp" class="btn btn-cancel">Cancel</a>
        </form>
    </div>
</body>
</html>