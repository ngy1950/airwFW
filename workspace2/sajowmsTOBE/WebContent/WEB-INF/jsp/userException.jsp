<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.common.util.ComU"%>
<%

	Exception ex = (Exception)request.getAttribute("exceptionMsg");
	String errMsg = ex.getMessage();
	String errorMessage = "user error@" + errMsg;
%>
<%=errorMessage%>