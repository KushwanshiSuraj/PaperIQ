package com.paperiq.controller;

import com.paperiq.dao.QuestionDAO;
import com.paperiq.model.Question;
import com.paperiq.model.BloomLevel;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class QuestionServlet extends HttpServlet {
    private QuestionDAO questionDAO = new QuestionDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            List<BloomLevel> levels = questionDAO.getBloomLevels();
            request.setAttribute("bloomLevels", levels);
            request.getRequestDispatcher("add-question.jsp").forward(request, response);
            
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            // Get question by ID and forward to edit page
            // For now, redirect to edit-question.jsp with ID
            response.sendRedirect("edit-question.jsp?id=" + id);
            
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            questionDAO.deleteQuestion(id);
            response.sendRedirect("questions.jsp?msg=deleted");
            
        } else {
            // List all questions
            List<Question> questions = questionDAO.getAllQuestions();
            request.setAttribute("questions", questions);
            
            // Check if user is admin or teacher
            HttpSession session = request.getSession(false);
            String role = (String) session.getAttribute("role");
            
            if("admin".equals(role)) {
                request.getRequestDispatcher("/admin/questions.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/view-questions.jsp").forward(request, response);
            }
        }
    }
}