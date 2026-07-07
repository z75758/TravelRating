<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html><body>
<h1>Test JSP</h1>
<%
    String id = request.getParameter("id");
    out.println("id=" + id);
    int n = Integer.parseInt(id);
    out.println(" parsed=" + n);
%>
</body></html>
