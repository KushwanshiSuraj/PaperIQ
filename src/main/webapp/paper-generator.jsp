<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PaperIQ - Generate Paper</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/paperiq.css">
    <style>
        .percentage-total {
            margin-top: 10px;
            font-weight: bold;
            color: var(--primary);
        }
    </style>
</head>
<body>
    <div class="container">
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
                <a href="<%= request.getContextPath() %>/paper-generator.jsp" class="active">📄 Generate Paper</a>
                <a href="<%= request.getContextPath() %>/logout-confirm.jsp" class="logout-btn">🚪 Logout</a>
            </div>
        </div>
        
        <div class="glass-card">
            <h1>📄 Generate Question Paper</h1>
            <p style="color: var(--gray);">Create balanced question papers with Bloom's Taxonomy distribution</p>
            
            <form action="<%= request.getContextPath() %>/generate-paper" method="post" class="form-container" style="margin-top: 30px;">
                <div class="form-group">
                    <label for="topic">📚 Topic:</label>
                    <input type="text" id="topic" name="topic" placeholder="e.g., Data Structures" required>
                </div>
                
                <div class="form-group">
                    <label for="totalMarks">🎯 Total Marks:</label>
                    <input type="number" id="totalMarks" name="totalMarks" value="40" min="10" max="100" required>
                </div>
                
                <h3 style="margin: 20px 0 10px;">Bloom's Taxonomy Distribution</h3>
                
                <div class="level-row">
                    <div class="level-input">
                        <label>Remember:</label>
                        <input type="number" name="rememberPct" value="20" min="0" max="100" onchange="updateTotal()">
                    </div>
                    <div class="level-input">
                        <label>Understand:</label>
                        <input type="number" name="understandPct" value="20" min="0" max="100" onchange="updateTotal()">
                    </div>
                    <div class="level-input">
                        <label>Apply:</label>
                        <input type="number" name="applyPct" value="20" min="0" max="100" onchange="updateTotal()">
                    </div>
                </div>
                
                <div class="level-row">
                    <div class="level-input">
                        <label>Analyze:</label>
                        <input type="number" name="analyzePct" value="15" min="0" max="100" onchange="updateTotal()">
                    </div>
                    <div class="level-input">
                        <label>Evaluate:</label>
                        <input type="number" name="evaluatePct" value="15" min="0" max="100" onchange="updateTotal()">
                    </div>
                    <div class="level-input">
                        <label>Create:</label>
                        <input type="number" name="createPct" value="10" min="0" max="100" onchange="updateTotal()">
                    </div>
                </div>
                
                <div class="percentage-total" id="totalDisplay">Total: <span id="totalValue">100</span>%</div>
                
                <div style="margin-top: 30px;">
                    <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">🎯 Generate Paper</button>
                </div>
            </form>
        </div>
        
        <div class="footer">
            <small>PaperIQ © 2026 - Developed by Suraj Kumar (Enrollment No: 2351352563, BCA, IGNOU) </small>
        </div>
    </div>
    
    <script>
        function updateTotal() {
            let inputs = document.querySelectorAll('input[name="rememberPct"], input[name="understandPct"], input[name="applyPct"], input[name="analyzePct"], input[name="evaluatePct"], input[name="createPct"]');
            let total = 0;
            inputs.forEach(input => {
                total += parseInt(input.value) || 0;
            });
            
            document.getElementById('totalValue').textContent = total;
            
            let totalDisplay = document.getElementById('totalDisplay');
            if(total != 100) {
                totalDisplay.style.color = 'var(--danger)';
            } else {
                totalDisplay.style.color = 'var(--primary)';
            }
        }
    </script>
</body>
</html>