<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
String questionId = request.getParameter("id");

if(questionId != null && !questionId.isEmpty()) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/paperiq_db?useSSL=false", 
            "root", "root123");
        
        String sql = "DELETE FROM questions WHERE question_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, questionId);
        
        int result = pstmt.executeUpdate();
        
        pstmt.close();
        conn.close();
        
        if(result > 0) {
            response.sendRedirect("questions.jsp?msg=deleted");
        } else {
            response.sendRedirect("questions.jsp?error=delete_failed");
        }
        
    } catch(Exception e) {
        response.sendRedirect("questions.jsp?error=" + e.getMessage());
    }
} else {
    response.sendRedirect("questions.jsp?error=invalid_id");
}
%>