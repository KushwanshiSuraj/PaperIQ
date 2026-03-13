<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.paperiq.model.Paper, com.paperiq.model.Question, java.util.List" %>
<%
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    String role = (String) session.getAttribute("role");
    Paper paper = (Paper) request.getAttribute("paper");
    
    if(paper == null) {
        response.sendRedirect(request.getContextPath() + "/paper-generator.jsp");
        return;
    }
    
    String topic = (String) request.getAttribute("topic");
    Integer totalMarks = (Integer) request.getAttribute("totalMarks");
    Integer rememberPct = (Integer) request.getAttribute("rememberPct");
    Integer understandPct = (Integer) request.getAttribute("understandPct");
    Integer applyPct = (Integer) request.getAttribute("applyPct");
    Integer analyzePct = (Integer) request.getAttribute("analyzePct");
    Integer evaluatePct = (Integer) request.getAttribute("evaluatePct");
    Integer createPct = (Integer) request.getAttribute("createPct");
    Integer paperId = (Integer) request.getAttribute("paperId");
    
    List<Question> questions = paper.getQuestions();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperIQ - Generated Paper</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/paperiq.css">
    <style>
        .paper-container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .paper-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #4361ee;
        }
        .paper-header h2 {
            color: #4361ee;
            margin-bottom: 10px;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .level-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-right: 8px;
            margin-bottom: 8px;
        }
        .level-1 { background: #4361ee; color: white; }
        .level-2 { background: #4cc9f0; color: white; }
        .level-3 { background: #06d6a0; color: white; }
        .level-4 { background: #ffd166; color: #333; }
        .level-5 { background: #ef476f; color: white; }
        .level-6 { background: #9c89b8; color: white; }
        .difficulty-easy { background: #06d6a0; color: white; }
        .difficulty-medium { background: #ffd166; color: #333; }
        .difficulty-hard { background: #ef476f; color: white; }
        .question-item {
            margin: 20px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #4361ee;
        }
        .question-meta {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        .pdf-btn {
            background: #ef476f;
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        .pdf-btn:hover {
            background: #d63e5e;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(239, 71, 111, 0.3);
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation -->
        <div class="nav-bar">
            <div style="font-weight: 700; font-size: 1.5rem;">📄 PaperIQ</div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/dashboard">🏠 Dashboard</a>
                <% if("admin".equals(role)) { %>
                    <a href="<%= request.getContextPath() %>/admin/questions.jsp">📋 Question Bank</a>
                <% } else { %>
                    <a href="<%= request.getContextPath() %>/view-questions.jsp">📋 View Questions</a>
                <% } %>
                <a href="<%= request.getContextPath() %>/paper-history">📊 Paper History</a>
                <a href="<%= request.getContextPath() %>/paper-generator.jsp">📄 Generate Paper</a>
                <a href="<%= request.getContextPath() %>/logout-confirm.jsp" class="logout-btn">🚪 Logout</a>
            </div>
        </div>
        
        <!-- Paper Content -->
        <div class="paper-container">
            <div class="paper-header">
                <h2>📄 PaperIQ - Generated Question Paper</h2>
                <% if(paperId != null && paperId > 0) { %>
                    <div class="alert alert-success">✅ Paper saved! ID: <%= paperId %></div>
                <% } %>
            </div>
            
            <!-- Info Row -->
            <div class="info-row">
                <div><strong>Topic:</strong> <%= topic %></div>
                <div><strong>Total Marks:</strong> <%= totalMarks %></div>
                <div><strong>Date:</strong> <%= new java.util.Date().toString() %></div>
            </div>
            
            <!-- Distribution -->
            <div style="margin: 30px 0;">
                <h3 style="margin-bottom: 15px;">Bloom's Distribution</h3>
                <div>
                    <span class="level-badge level-1">Remember: <%= paper.getRememberMarks() %></span>
                    <span class="level-badge level-2">Understand: <%= paper.getUnderstandMarks() %></span>
                    <span class="level-badge level-3">Apply: <%= paper.getApplyMarks() %></span>
                    <span class="level-badge level-4">Analyze: <%= paper.getAnalyzeMarks() %></span>
                    <span class="level-badge level-5">Evaluate: <%= paper.getEvaluateMarks() %></span>
                    <span class="level-badge level-6">Create: <%= paper.getCreateMarks() %></span>
                </div>
            </div>
            
            <!-- Questions -->
            <% 
            int qNum = 1;
            String currentLevel = "";
            for(Question q : questions) {
                if(!currentLevel.equals(q.getLevelName())) {
                    currentLevel = q.getLevelName();
            %>
                    <h3 style="margin: 30px 0 15px; color: #4361ee;">Section <%= currentLevel %></h3>
            <%
                }
            %>
                <div class="question-item">
                    <div style="font-weight: 600; margin-bottom: 10px;">
                        <span style="color: #4361ee;">Q<%= qNum++ %>.</span> 
                        <%= q.getQuestionText() %>
                        <span style="float: right; color: #4361ee; font-weight: 700;">[<%= q.getMarks() %> marks]</span>
                    </div>
                    <div class="question-meta">
                        <span class="level-badge level-<%= q.getLevelId() %>"><%= q.getLevelName() %></span>
                        <span class="level-badge difficulty-<%= q.getDifficulty().toLowerCase() %>"><%= q.getDifficulty() %></span>
                    </div>
                </div>
            <% } %>
            
            <!-- PDF Download Button -->
            <div style="text-align: center; margin: 40px 0;">
                <form action="<%= request.getContextPath() %>/generate-pdf" method="post" target="_blank">
    <input type="hidden" name="topic" value="<%= request.getAttribute("topic") %>">
    <input type="hidden" name="totalMarks" value="<%= request.getAttribute("totalMarks") %>">
    <input type="hidden" name="rememberPct" value="<%= request.getAttribute("rememberPct") %>">
    <input type="hidden" name="understandPct" value="<%= request.getAttribute("understandPct") %>">
    <input type="hidden" name="applyPct" value="<%= request.getAttribute("applyPct") %>">
    <input type="hidden" name="analyzePct" value="<%= request.getAttribute("analyzePct") %>">
    <input type="hidden" name="evaluatePct" value="<%= request.getAttribute("evaluatePct") %>">
    <input type="hidden" name="createPct" value="<%= request.getAttribute("createPct") %>">
    <button type="submit" class="btn btn-primary btn-lg">📥 Download PDF</button>
</form>
            </div>
            
            <!-- Back Button -->
            <div style="text-align: center;">
                <a href="<%= request.getContextPath() %>/paper-generator.jsp" class="btn btn-secondary">⬅️ Generate Another</a>
            </div>
        </div>
        
        <!-- Footer -->
        <div class="footer">
            <small>PaperIQ © 2026 - Suraj Kumar (2351352563) </small>
        </div>
    </div>
</body>
</html>