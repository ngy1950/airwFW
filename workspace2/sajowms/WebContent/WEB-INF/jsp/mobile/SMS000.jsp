<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/common/js/jquery.js"></script>
<% 
	String TONO = (String) request.getParameter("TONO"); 
	String TELNO = (String) request.getParameter("TELNO");
%>
<script type="text/javascript">
	$(document).ready(function(){
		$("#form1").submit();
	});
	
</script>
</head>
<body > 
	<form id="form1" method="post" action="/mobile/SMS001.ndo">
		<input type="hidden" name="TONO" value="<%=TONO%>">
		<input type="hidden" name="TELNO" value="<%=TELNO%>">
	</form>
</body>
</html>