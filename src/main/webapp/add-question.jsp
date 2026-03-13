<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    if(session.getAttribute("user_id") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Hardcoded Bloom levels - no database call needed
    List<Map<String, Object>> levels = new ArrayList<>();
    Map<String, Object> level1 = new HashMap<>(); level1.put("id", 1); level1.put("name", "Remember"); levels.add(level1);
    Map<String, Object> level2 = new HashMap<>(); level2.put("id", 2); level2.put("name", "Understand"); levels.add(level2);
    Map<String, Object> level3 = new HashMap<>(); level3.put("id", 3); level3.put("name", "Apply"); levels.add(level3);
    Map<String, Object> level4 = new HashMap<>(); level4.put("id", 4); level4.put("name", "Analyze"); levels.add(level4);
    Map<String, Object> level5 = new HashMap<>(); level5.put("id", 5); level5.put("name", "Evaluate"); levels.add(level5);
    Map<String, Object> level6 = new HashMap<>(); level6.put("id", 6); level6.put("name", "Create"); levels.add(level6);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperIQ - Add Question</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/paperiq.css">
</head>
<body>
    <div class="container">
        <div class="nav-bar">
            <div style="font-weight: 700; font-size: 1.5rem;">📄 PaperIQ</div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/dashboard">🏠 Dashboard</a>
                <a href="<%= request.getContextPath() %>/admin/questions.jsp">📋 Question Bank</a>
                <a href="<%= request.getContextPath() %>/paper-history">📊 Paper History</a>
                <a href="<%= request.getContextPath() %>/paper-generator.jsp">📄 Generate Paper</a>
                <a href="<%= request.getContextPath() %>/logout-confirm.jsp" class="logout-btn">🚪 Logout</a>
            </div>
        </div>
        
        <div class="glass-card" style="max-width: 800px; margin: 0 auto;">
            <h2>➕ Add New Question</h2>
            
            <form action="<%= request.getContextPath() %>/add-question" method="post" class="form-container">
                <div class="form-group">
                    <label for="question">📝 Question Text:</label>
                    <textarea id="question" name="question" rows="4" required placeholder="Enter your question here..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="level_id">🎯 Bloom Level:</label>
                    <select id="level_id" name="level_id" required>
                        <option value="">Select Level</option>
                        <% for(Map<String, Object> level : levels) { %>
                            <option value="<%= level.get("id") %>"><%= level.get("name") %></option>
                        <% } %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="topic">📚 Topic:</label>
                    <input type="text" id="topic" name="topic" placeholder="e.g., Data Structures, OOP, Database" required>
                </div>
                
                <div class="form-group">
                    <label for="marks">🏷️ Marks:</label>
                    <input type="number" id="marks" name="marks" value="2" min="1" max="10" required>
                </div>
                
                <div class="form-group">
                    <label for="difficulty">📊 Difficulty:</label>
                    <select id="difficulty" name="difficulty" required>
                        <option value="Easy">Easy</option>
                        <option value="Medium" selected>Medium</option>
                        <option value="Hard">Hard</option>
                    </select>
                </div>
                
                <div style="display: flex; gap: 10px; margin-top: 30px;">
                    <button type="submit" class="btn btn-success btn-lg" style="flex: 1;">✅ Add Question</button>
                    <a href="<%= request.getContextPath() %>/admin/questions.jsp" class="btn btn-danger btn-lg" style="flex: 1;">❌ Cancel</a>
                </div>
            </form>
        </div>
        
        <div class="footer">
            <small>PaperIQ © 2026 - Developed by Suraj Kumar (Enrollment No: 2351352563, BCA, IGNOU) </small>
        </div>
    </div>
</body>
</html>