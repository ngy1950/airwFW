<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
</head>
<body>
<script type="text/javascript">
	var sWidth = window.screen.availWidth;
	var sHeight = window.screen.availHeight;
	
	var windowName = "WMS";
	//this.location.href = "/wms/main.page?height="+sHeight+"&sWidth="+sWidth;
	window.opener = self;
	window.open("/wms/main.page",windowName,"height="+sHeight+",width="+sWidth+",resizable=yes");
</script>
</body>
</html>