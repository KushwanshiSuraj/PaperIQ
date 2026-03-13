package com.paperiq.controller;

import com.paperiq.dao.QuestionDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DeleteQuestionServlet extends HttpServlet {
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
            
            boolean success = questionDAO.deleteQuestion(questionId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/questions.jsp?msg=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/questions.jsp?error=deletefailed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/questions.jsp?error=invalid");
        }
    }
}