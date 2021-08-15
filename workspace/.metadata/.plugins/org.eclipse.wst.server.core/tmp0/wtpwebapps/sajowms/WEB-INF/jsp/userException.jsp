<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.common.util.XSSRequestWrapper,com.common.util.ComU"%>
<%
	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);

	Exception ex = (Exception)request.getAttribute("exceptionMsg");
	String errMsg = sFilter.getXSSFilter(ex.getMessage());
	String errorMessage = sFilter.getXSSFilter("user error@" + errMsg);
%>
<%=errorMessage%>