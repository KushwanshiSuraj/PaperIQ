<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate session (log out the user)
    session.invalidate();
    
    // Redirect to login page with success message
    response.sendRedirect("login.jsp?msg=loggedout");
%>