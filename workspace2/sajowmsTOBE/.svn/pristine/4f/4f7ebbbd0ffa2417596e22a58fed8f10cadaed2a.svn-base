<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.DataMap,java.util.ArrayList,project.common.bean.CommonConfig"%>
<%@ page import="java.net.*"%>
<%
	String serverName = request.getServerName().toString();
	Object SES_USER_ID = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY);
	
	DataMap loginMap = (DataMap)request.getAttribute("loginData");
	
	String sloId = null;
	String sloPwd = null;
	String sloUrl = null;
	
	if ( loginMap != null ){
		sloId = loginMap.getString("SLOID");
		sloPwd = loginMap.getString("SLOPWD");
		sloUrl = loginMap.getString("SLOURL");
	}
	
	String theme = CommonConfig.SYSTEM_THEME_PATH; 
	
	
/* 	sloId = "PDA1";
	sloPwd = "1";
	sloUrl = "/mobile/MB1201.data"; */
	
	
/* 	System.out.println(sloId);
	System.out.println(sloPwd);
	System.out.println(sloUrl); */
/* 	
	if ( SES_USER_ID != null && (  sloId == null || "".equals(sloId)  ) ){
		sloUrl = "/mobile/error.page";
	} */
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi" />
<title>Login</title>
<!-- <link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/mobile_login.css"> -->
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/site.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/input.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script type="text/javascript" src="/common/js/worker-ajax.js"></script>
<script type="text/javascript" src="/common/js/grid.js"></script>
<script type="text/javascript" src="/common/js/validateUtil.js"></script>
<script type="text/javascript" src="/common/theme/webdek/js/theme.js"></script>
<script>
<%-- if('<%=serverName%>' == '172.21.1.51' // GCLC --%>
<%-- 	|| '<%=serverName%>' == '172.21.1.52' // GCLC --%>
<%-- 	|| '<%=serverName%>' == '172.21.1.50' // GCLC --%>
<%-- 	|| '<%=serverName%>' == '172.21.1.53' // GCCL --%>
<%-- 	|| '<%=serverName%>' == '172.21.1.54' // GCCL --%>
<%-- 	|| '<%=serverName%>' == '172.21.1.55' // GCCL --%>
<%-- 	|| '<%=serverName%>' == '218.235.251.62' // PORTAL --%>
// ) 
// {
// 	this.location.href = "/error.html";	
// }
//로딩 열기
function loadingOpen() {

	var loader = $('<div class="contentLoading"></div>').appendTo('body');

	loader.stop().animate({
		top : '0px'
	}, 30, function() {
	});
}

// 로딩 닫기
function loadingClose() {

	var loader = $('.contentLoading');

	loader.stop().animate({
		top : '100%'
	}, 30, function() {
		loader.remove();
	});
}

$(document).ready(function(){
 	
	/* var LANGKY = "KO";
	if(LANGKY){
		//jQuery("#LANGKY").val(LANGKY);
		$("input[value="+LANGKY+"]").attr("checked","checked");
	} */ 
	<%
		if(SES_USER_ID != null && !SES_USER_ID.toString().equals("")){
	%>
			this.location.href = "<%=sloUrl%>";
	<%
		} else {
	%>
			login(); 
	<%	
		}
	%>
	
	/* 	
 	var USERID = $.cookie("USERID");
	if(USERID){
		jQuery("#USERID").val(USERID);
	}
	var PASSWD = $.cookie("PASSWD");
	if(PASSWD){
		jQuery("#PASSWD").val(PASSWD).focus();
	 }
	*/
	
});

function login(){
	//this.location.href = "/common/main.page";
	if(validate.check("searchArea")){
		
		var param = new DataMap();
		param.put("USERID","<%=sloId%>");
        param.put("ZINDEX",<%=sloPwd%>);
		param.put("LANGKY","KO");
		
	/* 	if( param.get("USERID") == null || param.get("USERID") == "" ) {
			this.location.href = "/mobile/error.page";
			return ;
		} */
		
		var json = netUtil.sendData({
			url : "/mobile/json/login.data",
			param : param
		});
		
		if(json && json.data){
			if(json.data == "N"){
				commonUtil.msg("USER INVALID");
				return;
			}else if(json.data == "F"){
				commonUtil.msg("PWD INVALID. 5 FAIL RESULTS ACCOUNT LOCK");
				return;
			}else if(json.data == "F_LOGIN_LOCK"){
				commonUtil.msg("ACCOUNT LOCKED. CONTACT ADMINISTRATOR");
				return;
			}else if(json.data == "F_LOGIN_INIT"){
				commonUtil.msg("INITIALIZE PASSWORD.");
				return;
			}else{
				for(var prop in param.map){
					$.cookie(prop, param.get(prop),{expires : 7});
				}
				if(json && json.data){
					this.location.href = "<%=sloUrl%>";
				}
			}
		}
	}	
} 

 </script>
</head>
<body>
	<!-- <div class="show">
		<div class="logo">
			<h1 class="GCLC"><span></span></h1>
		</div>
		<div class="signin" id="searchArea">
		    <input type="text" id="USERID" name="USERID" validate="required" onkeypress="commonUtil.enterKeyCheck(event, 'login()')" placeholder="ID"/>
		    <input type="text" id="PASSWD" name="PASSWD" validate="required" onkeypress="commonUtil.enterKeyCheck(event, 'login()')" placeholder="Password"/>
		    <input type="button" name="SignIn" value="LOGIN" onclick="login()">
		</div>
	</div> -->
</body>
</html>