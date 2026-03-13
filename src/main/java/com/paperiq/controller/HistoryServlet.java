package com.paperiq.controller;

import com.paperiq.dao.PaperDAO;
import com.paperiq.model.Paper;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class HistoryServlet extends HttpServlet {
    private PaperDAO paperDAO = new PaperDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("user_id");
        String role = (String) session.getAttribute("role");
        
        List<Paper> papers;
        if ("admin".equals(role)) {
            papers = paperDAO.getAllPapers();
        } else {
            papers = paperDAO.getPapersByUser(userId);
        }
        
        request.setAttribute("papers", papers);
        request.getRequestDispatcher("paper-history.jsp").forward(request, response);
    }
}