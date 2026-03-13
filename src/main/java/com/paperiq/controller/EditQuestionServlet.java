package com.paperiq.controller;

import com.paperiq.dao.QuestionDAO;
import com.paperiq.model.Question;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class EditQuestionServlet extends HttpServlet {
    private QuestionDAO questionDAO = new QuestionDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            int questionId = Integer.parseInt(request.getParameter("id"));
            Question question = questionDAO.getQuestionById(questionId);
            
            if (question != null) {
                request.setAttribute("question", question);
                request.getRequestDispatcher("/edit-question.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/questions.jsp?error=notfound");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/questions.jsp?error=invalid");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            int questionId = Integer.parseInt(request.getParameter("question_id"));
            String questionText = request.getParameter("question");
            int levelId = Integer.parseInt(request.getParameter("level_id"));
            String topic = request.getParameter("topic");
            int marks = Integer.parseInt(request.getParameter("marks"));
            String difficulty = request.getParameter("difficulty");
            
            Question q = new Question();
            q.setQuestionId(questionId);
            q.setQuestionText(questionText);
            q.setLevelId(levelId);
            q.setTopic(topic);
            q.setMarks(marks);
            q.setDifficulty(difficulty);
            
            boolean success = questionDAO.updateQuestion(q);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/questions.jsp?msg=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/edit-question.jsp?id=" + questionId + "&error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/questions.jsp?error=updatefailed");
        }
    }
}