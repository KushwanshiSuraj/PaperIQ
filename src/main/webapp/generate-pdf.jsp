<%@ page language="java" contentType="application/pdf; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*" %>
<%@ page import="com.itextpdf.text.*, com.itextpdf.text.pdf.*" %>
<%
    response.setContentType("application/pdf");
    
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
        // Create document
        Document document = new Document();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter.getInstance(document, baos);
        document.open();
        
        // Title
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
        Paragraph title = new Paragraph("PaperIQ - Generated Question Paper", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        document.add(new Paragraph(" "));
        
        // Paper info
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 12);
        Font boldFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        
        document.add(new Paragraph("Topic: " + topic, boldFont));
        document.add(new Paragraph("Total Marks: " + totalMarks, normalFont));
        document.add(new Paragraph("Date: " + new java.util.Date().toString(), normalFont));
        document.add(new Paragraph(" "));
        
        // Distribution
        document.add(new Paragraph("Distribution:", boldFont));
        document.add(new Paragraph("  Remember: " + rememberMarks + " marks", normalFont));
        document.add(new Paragraph("  Understand: " + understandMarks + " marks", normalFont));
        document.add(new Paragraph("  Apply: " + applyMarks + " marks", normalFont));
        document.add(new Paragraph("  Analyze: " + analyzeMarks + " marks", normalFont));
        document.add(new Paragraph("  Evaluate: " + evaluateMarks + " marks", normalFont));
        document.add(new Paragraph("  Create: " + createMarks + " marks", normalFont));
        document.add(new Paragraph(" "));
        document.add(new Paragraph("------------------------------------------------"));
        
        // Connect to database
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/paperiq_db?useSSL=false", 
            "root", "root123");
        
        int qNum = 1;
        
        // Arrays for levels
        int[] levelIds = {1, 2, 3, 4, 5, 6};
        int[] levelMarksArray = {rememberMarks, understandMarks, applyMarks, analyzeMarks, evaluateMarks, createMarks};
        String[] levelNames = {"Remember", "Understand", "Apply", "Analyze", "Evaluate", "Create"};
        
        for(int i = 0; i < levelIds.length; i++) {
            int levelId = levelIds[i];
            int levelMarks = levelMarksArray[i];
            String levelName = levelNames[i];
            
            if(levelMarks > 0) {
                document.add(new Paragraph(" "));
                Font sectionFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
                Paragraph section = new Paragraph("Section " + levelName + " (" + levelMarks + " marks)", sectionFont);
                document.add(section);
                
                String sql = "SELECT * FROM questions WHERE topic LIKE ? AND level_id = ? ORDER BY RAND()";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + topic + "%");
                pstmt.setInt(2, levelId);
                ResultSet rs = pstmt.executeQuery();
                
                int marksCollected = 0;
                while(rs.next() && marksCollected < levelMarks) {
                    int marks = rs.getInt("marks");
                    if(marksCollected + marks <= levelMarks) {
                        marksCollected += marks;
                        document.add(new Paragraph("Q" + qNum++ + ". " + rs.getString("question_text") + 
                            " [" + marks + " marks]", normalFont));
                        document.add(new Paragraph("   Difficulty: " + rs.getString("difficulty"), normalFont));
                        document.add(new Paragraph(" "));
                    }
                }
                rs.close();
                pstmt.close();
            }
        }
        
        // Footer
        document.add(new Paragraph(" "));
        document.add(new Paragraph("--- End of Paper ---", normalFont));
        document.add(new Paragraph("Generated by PaperIQ - Automated Question Paper System", normalFont));
        
        conn.close();
        document.close();
        
        // Output PDF
        byte[] pdfBytes = baos.toByteArray();
        response.setContentLength(pdfBytes.length);
        ServletOutputStream os = response.getOutputStream();
        os.write(pdfBytes);
        os.flush();
        os.close();
        
    } catch(Exception e) {
        out.println("Error generating PDF: " + e.getMessage());
    }
%>