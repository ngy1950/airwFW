<%@ page language="java" pageEncoding="UTF-8"%>

<%
	response.setStatus(HttpServletResponse.SC_OK);
%>

<HTML>
<HEAD>
<title>404 - 파일 또는 디렉터리를 찾을 수 없습니다.</title>
<style type="text/css">
<!--
body{margin:0;font-size:.7em;font-family:Verdana, Arial, Helvetica, sans-serif;background:#EEEEEE;}
fieldset{padding:0 15px 10px 15px;} 
h1{font-size:2.4em;margin:0;color:#FFF;}
h2{font-size:1.7em;margin:0;color:#CC0000;} 
h3{font-size:1.2em;margin:10px 0 0 0;color:#000000;} 
#header{width:96%;margin:0 0 0 0;padding:6px 2% 6px 2%;font-family:"trebuchet MS", Verdana, sans-serif;color:#FFF;
background-color:#555555;}
#content{margin:0 0 0 2%;position:relative;}
.content-container{background:#FFF;width:96%;margin-top:8px;padding:10px;position:relative;}
-->
</style>
</HEAD>
<body>
<div id="header"><h1>서버 오류</h1></div>
<div id="content">
 <div class="content-container"><fieldset>
  <h2>404 - 파일 또는 디렉터리를 찾을 수 없습니다.</h2>
  <h3>URL을 다시 잘 보고 주소가 올바로 입력되었는지를 확인하시기 바랍니다.</h3>
 </fieldset></div>
</div>
</body>
</html>