<%@ page import="com.itextpdf.text.*, com.itextpdf.text.pdf.*, java.io.*" %>
<%
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "attachment; filename=\"test.pdf\"");
    
    Document document = new Document();
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    PdfWriter.getInstance(document, baos);
    document.open();
    document.add(new Paragraph("PDF Test Working!"));
    document.close();
    
    byte[] pdfBytes = baos.toByteArray();
    response.setContentLength(pdfBytes.length);
    OutputStream os = response.getOutputStream();
    os.write(pdfBytes);
    os.flush();
    os.close();
%>