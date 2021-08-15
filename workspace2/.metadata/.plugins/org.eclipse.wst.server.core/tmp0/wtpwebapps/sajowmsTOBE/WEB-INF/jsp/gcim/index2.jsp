<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.DataMap,java.util.ArrayList,project.common.bean.CommonConfig"%>
<%
	ArrayList<DataMap> list = (ArrayList)request.getAttribute("LANGKY");
	
	//Object SES_USER_ID = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY);
	Object SES_USER_ID = null;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>Log in</title>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/login.css">
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
<script>
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
	//inputList.setCombo();
<%
	if(SES_USER_ID != null && !SES_USER_ID.toString().equals("")){
%>
	this.location.href = "/common/main.page";
<%
	}else{
%>
	//$("input[value=KO]").attr("checked","checked");
	var COLOR = $.cookie("COLOR");
	if(COLOR){
		//jQuery("#LANGKY").val(LANGKY);
		$("input[value="+COLOR+"]").attr("checked","checked");
	}
	
	var LANGKY = $.cookie("LANGKY");
	if(LANGKY){
		//jQuery("#LANGKY").val(LANGKY);
		$("input[value="+LANGKY+"]").attr("checked","checked");
	}
	var USERID = $.cookie("USERID");
	if(USERID){
		jQuery("#USERID").val(USERID);
	}
	var PASSWD = $.cookie("PASSWD");
	if(PASSWD){
		jQuery("#PASSWD").val(PASSWD).focus();
	}
<%
	}
%>
});

function login(){
	//this.location.href = "/common/main.page";
	if(validate.check("searchArea")){
		var param = dataBind.paramData("searchArea");
		param.put("LANGKY","<%=list.get(0).get("VALUE_COL")%>");
		var json = netUtil.sendData({
			url : "/gcim/json/login.data",
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
					this.location.href = "/gcim/main.page";
				}
			}
		}
	}	
}

function validationEventMsg(valObjType, objIndex, objId, objName, objValue, valType){
	//commonUtil.debugMsg("validationEventMsg : ", arguments);
	if(objName == "USERID"){
		return "ID required.";
	}else if(objName == "PASSWD"){
		return "Password required.";
	}else if(objName == "LANGKY"){
		return "Language required.";
	}
}
</script>
</head>
<body>
	<!-- <div class="bg-gradient"></div>
	<div class="bg-gradient"></div> -->
	<div class="show">
		<h1><img src="/common/theme/webdek/navy/logo_w.png"></h1>
		<div class="signin" id="searchArea">
		    <h2>Great Challenge</h2>
		    <p class="side_text">인류의 건강한 미래와 함께 하는 기업</p>
		    <input type="text" id="USERID" name="USERID" validate="required" onkeypress="commonUtil.enterKeyCheck(event, 'login()')" placeholder="ID"/>
		    <input type="password" id="PASSWD" name="PASSWD" validate="required" onkeypress="commonUtil.enterKeyCheck(event, 'login()')" placeholder="Password"/>
		    <%-- <div class="radio">
		    <%
		    	DataMap row;
		    	for(int i=0;i<list.size();i++){
		    		row = (DataMap)list.get(i);
		    %>
		      <input type="radio" id="<%=row.getString("VALUE_COL")%>" name="LANGKY" value="<%=row.getString("VALUE_COL")%>" /><label for="<%=row.getString("VALUE_COL")%>"><%=row.getString("TEXT_COL")%></label>
		    <%
		    	}
		    %>
		    </div> --%>
		    <div class="radio" style="display:none">
		      <input type="radio" id="RED" name="COLOR" value="red"  /><label for="RED">Red</label>
		      <input type="radio" id="SKYBLUE" name="COLOR" value="skyblue" /><label for="SKYBLUE">Sky Blue</label>
		      <input type="radio" id="navy" name="COLOR" value="navy" checked="checked"/><label for="navy">Navy</label>
		      <input type="radio" id="GRAY" name="COLOR" value="gray" /><label for="GRAY">Gray</label>
		      <input type="radio" id="BLACK" name="COLOR" value="black" /><label for="BLACK">Black</label>
		    </div>
		    <input type="button" name="SignIn" value="LOGIN" onclick="login()">
		    <button class="change_pw">비밀번호 변경</button>
		</div>
		<footer>
			<p>Copyright ⓒ 2019 Green Cross Labcell. All rights reserved.</p>
			<select>
				<option>GC Family Site</option>
				<option>GC Family Site</option>
				<option>GC Family Site</option>
				<option>GC Family Site</option>
			</select>
		</footer>
	</div>
</body>
</html>