package com.paperiq.controller;

import com.paperiq.dao.QuestionDAO;
import com.paperiq.model.Question;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.ByteArrayOutputStream;  // ← THIS WAS MISSING!
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class GeneratePDFServlet extends HttpServlet {
    private QuestionDAO questionDAO = new QuestionDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            // Get parameters
            String topic = request.getParameter("topic");
            if (topic == null || topic.isEmpty()) {
                throw new Exception("Topic is required");
            }
            
            int totalMarks = Integer.parseInt(request.getParameter("totalMarks"));
            int rememberPct = Integer.parseInt(request.getParameter("rememberPct"));
            int understandPct = Integer.parseInt(request.getParameter("understandPct"));
            int applyPct = Integer.parseInt(request.getParameter("applyPct"));
            int analyzePct = Integer.parseInt(request.getParameter("analyzePct"));
            int evaluatePct = Integer.parseInt(request.getParameter("evaluatePct"));
            int createPct = Integer.parseInt(request.getParameter("createPct"));
            
            // Calculate marks per level
            int rememberMarks = (totalMarks * rememberPct) / 100;
            int understandMarks = (totalMarks * understandPct) / 100;
            int applyMarks = (totalMarks * applyPct) / 100;
            int analyzeMarks = (totalMarks * analyzePct) / 100;
            int evaluateMarks = (totalMarks * evaluatePct) / 100;
            int createMarks = (totalMarks * createPct) / 100;
            
            int total = rememberMarks + understandMarks + applyMarks + analyzeMarks + evaluateMarks + createMarks;
            if (total < totalMarks) {
                rememberMarks += (totalMarks - total);
            }
            
            // Set response type
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"PaperIQ_" + topic + "_Paper.pdf\"");
            
            // Create PDF document
            Document document = new Document(PageSize.A4);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();  // Now this works!
            PdfWriter.getInstance(document, baos);
            document.open();
            
            // Fonts
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
            Font headingFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
            Font normalFont = new Font(Font.FontFamily.HELVETICA, 11);
            Font boldFont = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD);
            
            // Title
            Paragraph title = new Paragraph("PaperIQ - Generated Question Paper", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            document.add(new Paragraph(" "));
            
            // Paper info
            document.add(new Paragraph("Topic: " + topic, boldFont));
            document.add(new Paragraph("Total Marks: " + totalMarks, normalFont));
            document.add(new Paragraph("Date: " + new java.util.Date().toString(), normalFont));
            document.add(new Paragraph(" "));
            
            // Distribution
            document.add(new Paragraph("Bloom's Taxonomy Distribution:", boldFont));
            document.add(new Paragraph("  Remember: " + rememberMarks + " marks", normalFont));
            document.add(new Paragraph("  Understand: " + understandMarks + " marks", normalFont));
            document.add(new Paragraph("  Apply: " + applyMarks + " marks", normalFont));
            document.add(new Paragraph("  Analyze: " + analyzeMarks + " marks", normalFont));
            document.add(new Paragraph("  Evaluate: " + evaluateMarks + " marks", normalFont));
            document.add(new Paragraph("  Create: " + createMarks + " marks", normalFont));
            document.add(new Paragraph(" "));
            document.add(new Paragraph("------------------------------------------------"));
            
            // Questions by level
            int qNum = 1;
            int[] levelIds = {1, 2, 3, 4, 5, 6};
            int[] levelMarksArray = {rememberMarks, understandMarks, applyMarks, analyzeMarks, evaluateMarks, createMarks};
            String[] levelNames = {"Remember", "Understand", "Apply", "Analyze", "Evaluate", "Create"};
            
            for (int i = 0; i < levelIds.length; i++) {
                if (levelMarksArray[i] > 0) {
                    document.add(new Paragraph(" "));
                    Paragraph section = new Paragraph("Section " + levelNames[i] + " (" + levelMarksArray[i] + " marks)", headingFont);
                    document.add(section);
                    
                    List<Question> questions = questionDAO.getQuestionsByTopicAndLevel(topic, levelIds[i]);
                    int marksCollected = 0;
                    boolean hasQuestions = false;
                    
                    for (Question q : questions) {
                        if (marksCollected + q.getMarks() <= levelMarksArray[i]) {
                            marksCollected += q.getMarks();
                            hasQuestions = true;
                            
                            document.add(new Paragraph("Q" + qNum++ + ". " + q.getQuestionText(), normalFont));
                            document.add(new Paragraph("   [Marks: " + q.getMarks() + " | Difficulty: " + q.getDifficulty() + "]", normalFont));
                            document.add(new Paragraph(" "));
                        }
                    }
                    
                    if (!hasQuestions) {
                        document.add(new Paragraph("   No questions available for this level.", normalFont));
                        document.add(new Paragraph(" "));
                    }
                }
            }
            
            // Footer
            document.add(new Paragraph(" "));
            document.add(new Paragraph("--- End of Paper ---", normalFont));
            document.add(new Paragraph("Generated by PaperIQ - Automated Question Paper System", normalFont));
            document.add(new Paragraph("Developed by Suraj Kumar (BCA, IGNOU)", normalFont));
            
            document.close();
            
            // Write PDF to response
            byte[] pdfBytes = baos.toByteArray();
            response.setContentLength(pdfBytes.length);
            OutputStream os = response.getOutputStream();
            os.write(pdfBytes);
            os.flush();
            os.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/paper-generator.jsp?error=" + e.getMessage());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}