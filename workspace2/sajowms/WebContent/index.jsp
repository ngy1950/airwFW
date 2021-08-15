<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String url = request.getRequestURL().toString();
	String serverName = request.getServerName().toString(); 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<title>index</title>
<script>
this.location.href = "/wms/index.page";
//this.location.href = "/wdscm/index.page";
//this.location.href = "/wdscm/html/membership_code.html";
/*
	try{
		if(commonUtil.isMobile()){
	        this.location.href = "/mobile/index.page";
	    }else{ 
	        this.location.href = "/webdek/index.page";
	    }	
	}catch(e){
	    this.location.href = "/wdscm/index.page";
	}
*/
</script>
</head>
<body>
<a href="/webdek/index.page" target="_blank">webdek</a><br/>
<a href="/wdscm/index.page" target="_blank">wdscm</a><br/>
</body>
</html>