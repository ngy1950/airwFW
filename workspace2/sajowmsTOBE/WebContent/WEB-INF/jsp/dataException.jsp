<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	Exception ex = (Exception) request.getAttribute("exceptionMsg");
	StackTraceElement[] erList = ex.getStackTrace();
	String msg = ex.getMessage();
%><%=msg%>