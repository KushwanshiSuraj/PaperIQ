package com.paperiq.controller;

import com.paperiq.dao.QuestionDAO;
import com.paperiq.dao.PaperDAO;
import com.paperiq.model.Question;
import com.paperiq.model.Paper;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class PaperServlet extends HttpServlet {
    private QuestionDAO questionDAO = new QuestionDAO();
    private PaperDAO paperDAO = new PaperDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
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
            if (total < totalMarks) {
                rememberMarks += (totalMarks - total);
            }
            
            // Get questions for each level
            List<Question> allQuestions = new ArrayList<>();
            int qNum = 1;
            
            int[] levelIds = {1, 2, 3, 4, 5, 6};
            int[] levelMarks = {rememberMarks, understandMarks, applyMarks, analyzeMarks, evaluateMarks, createMarks};
            String[] levelNames = {"Remember", "Understand", "Apply", "Analyze", "Evaluate", "Create"};
            
            for (int i = 0; i < levelIds.length; i++) {
                if (levelMarks[i] > 0) {
                    List<Question> levelQuestions = questionDAO.getQuestionsByTopicAndLevel(topic, levelIds[i]);
                    int marksCollected = 0;
                    
                    for (Question q : levelQuestions) {
                        if (marksCollected + q.getMarks() <= levelMarks[i]) {
                            marksCollected += q.getMarks();
                            q.setLevelName(levelNames[i]);
                            allQuestions.add(q);
                        }
                    }
                }
            }
            
            // Save paper to database
            int userId = (Integer) session.getAttribute("user_id");
            String username = (String) session.getAttribute("username");
            
            Paper paper = new Paper();
            paper.setUserId(userId);
            paper.setUsername(username);
            paper.setTopic(topic);
            paper.setTotalMarks(totalMarks);
            paper.setRememberMarks(rememberMarks);
            paper.setUnderstandMarks(understandMarks);
            paper.setApplyMarks(applyMarks);
            paper.setAnalyzeMarks(analyzeMarks);
            paper.setEvaluateMarks(evaluateMarks);
            paper.setCreateMarks(createMarks);
            paper.setQuestions(allQuestions);
            
            int paperId = paperDAO.savePaper(paper);
            
            request.setAttribute("paper", paper);
            request.setAttribute("paperId", paperId);
            request.setAttribute("topic", topic);
            request.setAttribute("totalMarks", totalMarks);
            request.setAttribute("rememberPct", rememberPct);
            request.setAttribute("understandPct", understandPct);
            request.setAttribute("applyPct", applyPct);
            request.setAttribute("analyzePct", analyzePct);
            request.setAttribute("evaluatePct", evaluatePct);
            request.setAttribute("createPct", createPct);
            
            request.getRequestDispatcher("paper-result.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("paper-generator.jsp?error=" + e.getMessage());
        }
    }
}