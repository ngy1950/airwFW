<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%
	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);
	
	String fileName = "/ezgen/wmsEzgen/Forms_" + sFilter.getXSSFilter((String) request.getAttribute("filename"));

	String andValue = sFilter.getXSSFilter((String) request.getAttribute("andvalue")) ;
	
	String width    = sFilter.getXSSFilter((String) request.getAttribute("width"))  ;
	String height   = sFilter.getXSSFilter((String) request.getAttribute("height")) ;
	
	String url      = sFilter.getXSSFilter((String) request.getAttribute("url"));

// 	String platformUrl = url + "/eftpmanager";
	String platformUrl =  "https://ewms.gsretail.com/eftpmanager";
	String hnwUrl = url + fileName;

	String realFile = "wms"+System.currentTimeMillis()+".ezxml";
	
	response.addHeader("content-type", "application/download");
	response.addHeader("Content-Disposition", "inline;filename="+realFile);
	response.addHeader("Pragma", "no-cache;");
%>
<EzApplication
	 noTitle="no" title="" fullScreen="no" addressbar="no" posCenter="yes" width="<%=width %>" height="<%=height %>" noResize="no">
 	<codebase src="EzipFiles/EzPlatform_1_0_0_7.ezip" url="<%=platformUrl%>" AppPath="EZgen/EzPlatform_1_0_0_7.exe" version="1,0,0,7"/> 
	<frameset rows="*" border="4" borderColor="#FFFFFF" bgColor="#ffffff">
		<frame name="top" scrolling="no" noResize="yes">
			<codebase src="EzipFiles/HnwActivw_8_0_0_96.ezip" url="<%=platformUrl%>" AppPath="EZgen/HnwActivw_8_0_0_96/HnwActivw.dll" version="8,0,0,96"/>
			<param name="hnwsrc" value="<%=hnwUrl%>"/>
		    <param name="initvalue" value="<%=andValue%>"/> 
			<param name="UrlEncoding" value="Y"/>
		</frame>
	</frameset>
</EzApplication>  
 

