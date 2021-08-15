<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.DataMap,com.common.bean.CommonConfig"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%
	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);
	DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	
	String fileData = sFilter.getXSSFilter(map.getString("data"));
%>
<%=fileData%>