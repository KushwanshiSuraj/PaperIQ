<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // Check if user is logged in
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String role = (String) session.getAttribute("role");
    String basePath = request.getContextPath() + "/";
    int userId = (Integer) session.getAttribute("user_id");
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PaperIQ - Generate Paper</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #f0f2f5; }
        .container { max-width: 900px; margin: auto; }
        .form-group { margin: 15px 0; }
        label { font-weight: bold; display: block; margin-bottom: 5px; }
        input, select { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { background: #4CAF50; color: white; padding: 10px 20px; border: none; cursor: pointer; border-radius: 4px; }
        .btn:hover { background: #45a049; }
        .paper { margin-top: 30px; padding: 20px; border: 1px solid #ddd; background: white; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .question-item { margin: 10px 0; padding: 10px; border-left: 3px solid #4CAF50; background: #f9f9f9; border-radius: 4px; }
        .nav-links { margin: 20px 0; padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .nav-links a { margin-right: 20px; text-decoration: none; color: #4CAF50; font-weight: bold; }
        .nav-links a:hover { text-decoration: underline; }
        .level-row { display: flex; gap: 10px; margin-bottom: 10px; }
        .level-row div { flex: 1; }
        .warning { color: orange; display: none; margin: 10px 0; }
        .logout { float: right; background: #f44336; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; }
        .logout:hover { background: #d32f2f; }
        h1 { display: inline-block; }
        .no-questions { color: #f44336; font-style: italic; padding: 10px; background: #ffebee; border-radius: 4px; }
        .footer { text-align: center; margin-top: 30px; padding: 15px; color: #666; font-size: 12px; border-top: 1px solid #ddd; }
        .student-info { background: #e3f2fd; padding: 5px 10px; border-radius: 4px; display: inline-block; margin-left: 20px; font-size: 14px; }
        .success-msg { background: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📄 Generate Question Paper</h1>
        <span class="student-info">Developed by: Suraj Kumar (BCA, IGNOU)</span>
        <a href="logout.jsp" class="logout">Logout</a>
        
        <div class="nav-links">
            <% if(role.equals("admin")) { %>
                <a href="questions.jsp">📋 Question Bank</a>
                <a href="paper-history.jsp">📊 Paper History</a>
            <% } else { %>
                <a href="view-questions.jsp">📋 View Questions</a>
                <a href="paper-history.jsp">📊 Paper History</a>
            <% } %>
            <a href="<%= role.equals("admin") ? "admin/dashboard.jsp" : "teacher/dashboard.jsp" %>">🏠 Dashboard</a>
        </div>
        
        <form method="post" class="form-group" style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
            <div>
                <label>Topic:</label>
                <input type="text" name="topic" required placeholder="e.g., Data Structures">
            </div>
            
            <div>
                <label>Total Marks:</label>
                <input type="number" name="totalMarks" value="40" min="10" max="100">
            </div>
            
            <h3>Bloom's Taxonomy Distribution (%)</h3>
            <p style="color: #666; font-size: 14px;">Total should equal 100%</p>
            
            <div class="level-row">
                <div>
                    <label>Remember:</label>
                    <input type="number" name="rememberPct" value="20" min="0" max="100" onchange="updateTotal()">
                </div>
                <div>
                    <label>Understand:</label>
                    <input type="number" name="understandPct" value="20" min="0" max="100" onchange="updateTotal()">
                </div>
                <div>
                    <label>Apply:</label>
                    <input type="number" name="applyPct" value="20" min="0" max="100" onchange="updateTotal()">
                </div>
            </div>
            
            <div class="level-row">
                <div>
                    <label>Analyze:</label>
                    <input type="number" name="analyzePct" value="15" min="0" max="100" onchange="updateTotal()">
                </div>
                <div>
                    <label>Evaluate:</label>
                    <input type="number" name="evaluatePct" value="15" min="0" max="100" onchange="updateTotal()">
                </div>
                <div>
                    <label>Create:</label>
                    <input type="number" name="createPct" value="10" min="0" max="100" onchange="updateTotal()">
                </div>
            </div>
            
            <div id="totalWarning" class="warning">⚠️ Total must equal 100%</div>
            
            <button type="submit" class="btn">🎯 Generate Paper</button>
        </form>
        
        <script>
        function updateTotal() {
            let remember = parseInt(document.getElementsByName("rememberPct")[0].value) || 0;
            let understand = parseInt(document.getElementsByName("understandPct")[0].value) || 0;
            let apply = parseInt(document.getElementsByName("applyPct")[0].value) || 0;
            let analyze = parseInt(document.getElementsByName("analyzePct")[0].value) || 0;
            let evaluate = parseInt(document.getElementsByName("evaluatePct")[0].value) || 0;
            let create = parseInt(document.getElementsByName("createPct")[0].value) || 0;
            
            let total = remember + understand + apply + analyze + evaluate + create;
            let warning = document.getElementById("totalWarning");
            
            if(total != 100) {
                warning.style.display = "block";
            } else {
                warning.style.display = "none";
            }
        }
        </script>
        
        <%
        if(request.getMethod().equals("POST")) {
            String topic = request.getParameter("topic");
            int totalMarks = Integer.parseInt(request.getParameter("totalMarks"));
            
            int rememberPct = Integer.parseInt(request.getParameter("rememberPct"));
            int understandPct = Integer.parseInt(request.getParameter("understandPct"));
            int applyPct = Integer.parseInt(request.getParameter("applyPct"));
            int analyzePct = Integer.parseInt(request.getParameter("analyzePct"));
            int evaluatePct = Integer.parseInt(request.getParameter("evaluatePct"));
            int createPct = Integer.parseInt(request.getParameter("createPct"));
            
            int rememberMarks = (totalMarks * rememberPct) / 100;
            int understandMarks = (totalMarks * understandPct) / 100;
            int applyMarks = (totalMarks * applyPct) / 100;
            int analyzeMarks = (totalMarks * analyzePct) / 100;
            int evaluateMarks = (totalMarks * evaluatePct) / 100;
            int createMarks = (totalMarks * createPct) / 100;
            
            int total = rememberMarks + understandMarks + applyMarks + analyzeMarks + evaluateMarks + createMarks;
            if(total < totalMarks) {
                rememberMarks += (totalMarks - total);
            }
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/paperiq_db?useSSL=false", 
                    "root", "root123");
                
                // Arrays for levels
                int[] levelIds = {1, 2, 3, 4, 5, 6};
                int[] levelMarksArray = {rememberMarks, understandMarks, applyMarks, analyzeMarks, evaluateMarks, createMarks};
                String[] levelNames = {"Remember", "Understand", "Apply", "Analyze", "Evaluate", "Create"};
                
                // ===== SAVE PAPER TO DATABASE =====
                int paperId = 0;
                
                // Insert into generated_papers
                String insertPaper = "INSERT INTO generated_papers (user_id, username, topic, total_marks, " +
                    "remember_marks, understand_marks, apply_marks, analyze_marks, evaluate_marks, create_marks) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
                PreparedStatement paperStmt = conn.prepareStatement(insertPaper, Statement.RETURN_GENERATED_KEYS);
                paperStmt.setInt(1, userId);
                paperStmt.setString(2, username);
                paperStmt.setString(3, topic);
                paperStmt.setInt(4, totalMarks);
                paperStmt.setInt(5, rememberMarks);
                paperStmt.setInt(6, understandMarks);
                paperStmt.setInt(7, applyMarks);
                paperStmt.setInt(8, analyzeMarks);
                paperStmt.setInt(9, evaluateMarks);
                paperStmt.setInt(10, createMarks);
                paperStmt.executeUpdate();
                
                // Get generated paper ID
                ResultSet paperKeys = paperStmt.getGeneratedKeys();
                if(paperKeys.next()) {
                    paperId = paperKeys.getInt(1);
                }
                paperKeys.close();
                paperStmt.close();
                
                // Prepare statement for saving questions
                String insertQuestion = "INSERT INTO paper_questions (paper_id, question_id, question_text, level_name, marks, question_number) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement qStmt = conn.prepareStatement(insertQuestion);
                
        %>
        
        <div class="paper">
            <h2>Generated Question Paper</h2>
            <p><strong>Topic:</strong> <%= topic %></p>
            <p><strong>Total Marks:</strong> <%= totalMarks %></p>
            <p><strong>Distribution:</strong> 
                Remember <%= rememberMarks %> | 
                Understand <%= understandMarks %> | 
                Apply <%= applyMarks %> | 
                Analyze <%= analyzeMarks %> | 
                Evaluate <%= evaluateMarks %> | 
                Create <%= createMarks %>
            </p>
            
            <% if(paperId > 0) { %>
                <div class="success-msg">✅ Paper saved to history! Paper ID: <%= paperId %></div>
            <% } %>
            
            <hr>
            
            <%
            int qNum = 1;
            
            for(int i = 0; i < levelIds.length; i++) {
                int levelId = levelIds[i];
                int levelMarks = levelMarksArray[i];
                String levelName = levelNames[i];
                
                if(levelMarks > 0) {
            %>
                    <h3>Section <%= levelName %> ( <%= levelMarks %> Marks )</h3>
            <%
                    String sql = "SELECT * FROM questions WHERE topic LIKE ? AND level_id = ? ORDER BY RAND()";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, "%" + topic + "%");
                    pstmt.setInt(2, levelId);
                    ResultSet rs = pstmt.executeQuery();
                    
                    int marksCollected = 0;
                    boolean hasQuestions = false;
                    
                    while(rs.next() && marksCollected < levelMarks) {
                        int marks = rs.getInt("marks");
                        if(marksCollected + marks <= levelMarks) {
                            marksCollected += marks;
                            hasQuestions = true;
                            
                            // Save question to paper_questions table
                            qStmt.setInt(1, paperId);
                            qStmt.setInt(2, rs.getInt("question_id"));
                            qStmt.setString(3, rs.getString("question_text"));
                            qStmt.setString(4, levelName);
                            qStmt.setInt(5, marks);
                            qStmt.setInt(6, qNum);
                            qStmt.executeUpdate();
            %>
                            <div class="question-item">
                                <strong>Q<%= qNum++ %>.</strong> <%= rs.getString("question_text") %>
                                <span style="float:right; color:#4CAF50;">[<%= marks %> marks]</span>
                                <br><small>Difficulty: <%= rs.getString("difficulty") %></small>
                            </div>
            <%
                        }
                    }
                    
                    if(!hasQuestions) {
                        out.println("<p class='no-questions'>⚠️ No questions found for " + levelName + " level with topic '" + topic + "'. Please add questions first.</p>");
                    }
                    
                    rs.close();
                    pstmt.close();
                }
            }
            
            qStmt.close();
            
            // PDF Button
            %>
            <div style="text-align: center; margin: 30px 0 20px 0;">
                <form action="generate-pdf.jsp" method="post" target="_blank">
                    <input type="hidden" name="topic" value="<%= topic %>">
                    <input type="hidden" name="totalMarks" value="<%= totalMarks %>">
                    <input type="hidden" name="rememberPct" value="<%= rememberPct %>">
                    <input type="hidden" name="understandPct" value="<%= understandPct %>">
                    <input type="hidden" name="applyPct" value="<%= applyPct %>">
                    <input type="hidden" name="analyzePct" value="<%= analyzePct %>">
                    <input type="hidden" name="evaluatePct" value="<%= evaluatePct %>">
                    <input type="hidden" name="createPct" value="<%= createPct %>">
                    <button type="submit" style="background: #FF5722; color: white; padding: 12px 30px; border: none; cursor: pointer; font-size: 16px; border-radius: 4px;">📥 Download as PDF</button>
                </form>
            </div>
            <%
            
            conn.close();
            
            } catch(Exception e) {
                out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
            }
        }
        %>
        
        <div class="footer">
            <small>PaperIQ © 2026 - Developed by Suraj Kumar (Enrollment No: 2351352563, BCA, IGNOU) | Guide: Prof. Baleshwar Yadav</small>
        </div>
    </div>
</body>
</html>