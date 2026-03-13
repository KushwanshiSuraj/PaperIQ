<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PaperIQ - Error</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/paperiq.css">
</head>
<body>
    <div class="login-container">
        <div class="login-card" style="text-align: center;">
            <h2 style="color: var(--danger);">❌ Error</h2>
            <p>Something went wrong. Please try again.</p>
            <%
                Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
                if(statusCode != null) {
            %>
                <p style="color: var(--gray);">Status Code: <%= statusCode %></p>
            <% } %>
            <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-primary" style="margin-top: 20px;">Go to Login</a>
        </div>
    </div>
</body>
</html>