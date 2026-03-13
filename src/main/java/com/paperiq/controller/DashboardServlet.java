package com.paperiq.controller;

import com.paperiq.dao.QuestionDAO;
import com.paperiq.model.Question;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DashboardServlet extends HttpServlet {
    private QuestionDAO questionDAO = new QuestionDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        
        // Get statistics for dashboard
        List<Question> allQuestions = questionDAO.getAllQuestions();
        int totalQuestions = allQuestions.size();
        
        // Count questions per level
        int[] levelCounts = new int[7]; // Index 1-6
        for (Question q : allQuestions) {
            levelCounts[q.getLevelId()]++;
        }
        
        request.setAttribute("totalQuestions", totalQuestions);
        request.setAttribute("levelCounts", levelCounts);
        
        if ("admin".equals(role)) {
            request.getRequestDispatcher("admin/dashboard.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("teacher/dashboard.jsp").forward(request, response);
        }
    }
}