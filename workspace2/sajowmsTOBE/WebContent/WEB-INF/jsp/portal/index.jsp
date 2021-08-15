<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.DataMap,java.util.ArrayList,project.common.bean.CommonConfig"%>
<%
	ArrayList<DataMap> list = (ArrayList)request.getAttribute("LANGKY");
	String serverName = request.getServerName().toString(); 
	
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
	//inputList.setCombo();
	$('#KO').prop('checked',true);
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
	// 통합테스트기간 요청(임시)
	//checkEZPlatformApp();
});

function login(){
	//this.location.href = "/common/main.page";
	if(validate.check("searchArea")){
		var param = dataBind.paramData("searchArea");
		param.put("LANGKY",$('input[name=LANGKY]:checked').val());
        param.put("ZINDEX",param.map.PASSWD);
        param.remove("PASSWD");
		var json = netUtil.sendData({
			url : "/portal/json/login.data",
			param : param
		});
		if(json && json.data){
			if(json.data == "N"){
				commonUtil.msg("가입하지 않은 아이디이거나, 잘못된 비밀번호입니다.");
				return;
			} else if(json.data == "F"){
				commonUtil.msg("비밀번호가 일치하지 않습니다.(5회 이상 LOCK)");
				return;
			}else if(json.data == "F_LOGIN_LOCK"){
				commonUtil.msg("계정 LOCK");
				return;
			}else if(json.data == "F_LOGIN_INIT"){
				commonUtil.msg("비밀번호를 변경해주세요.");
	            page.linkPopOpen("/GCLC/CM/CM10/CM1107_POP.page","", "height=335,width=500,resizable=yes");
				return;
			}else{
				for(var prop in param.map){
					$.cookie(prop, param.get(prop),{expires : 7});
				}
				if(json && json.data){
					this.location.href = "/portal/main.page";
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

function checkEZPlatformApp(){
   if(typeof window.localStorage == 'undefined') {
      //alert("로컬 스토리지를 지원하지 않습니다."); //LOGIN_M0006
      //alert(getMsg("SYSTEM_NOLOCALSTORAGE"));
      commonUtil.msgBox("SYSTEM_NOLOCALSTORAGE");
      return;
   }
   var version = window.localStorage.getItem('EZPlatformApp');
   if( version != "1.0.0.11" ){
	   window.open('/downloadPlatformApp.html','egzen','width=500,height=300');
   }
}
</script>
</head>
<body class="GCCL">
	<!-- <div class="bg-gradient"></div>
	<div class="bg-gradient"></div> -->
	<div class="show">
		<div class="logos">
			<img src="/common/theme/webdek/images/login/LOGO_BLUE_1.png" />
			<img src="/common/theme/webdek/images/login/LOGO_BLUE_2.png" />
			<img src="/common/theme/webdek/images/login/LOGO_BLUE_TEXT.png" />
		</div>
		<div class="signin" id="searchArea">
		    <div class="inputbox">
		    	<label>User Name</label>
			    <div class="idbox"><input type="text" id="USERID" name="USERID" validate="required" onkeypress="commonUtil.enterKeyCheck(event, 'login()')" placeholder="ID"/></div>
			    <label>Password</label>
			    <div class="pwbox"><input type="password" id="PASSWD" name="PASSWD" validate="required" onkeypress="commonUtil.enterKeyCheck(event, 'login()')" placeholder="Password"/></div>
				<input type="text" id="COMPID" name="COMPID" style="display: none;"/>
		    </div>
		     <div class="radio">
		    <%
		    	DataMap row;
		    	for(int i=0;i<list.size();i++){
		    		row = (DataMap)list.get(i);
		    %>
		      <input type="radio" id="<%=row.getString("VALUE_COL")%>" name="LANGKY" value="<%=row.getString("VALUE_COL")%>" /><label for="<%=row.getString("VALUE_COL")%>"><%=row.getString("TEXT_COL")%></label>
		    <%
		    	}
		    %>
		    </div>
		    <div class="radio" style="display:none">
		        <input type="radio" id="RED" name="COLOR" value="red"  /><label for="RED">Red</label>
		        <input type="radio" id="SKYBLUE" name="COLOR" value="skyblue" /><label for="SKYBLUE">Sky Blue</label>
		        <input type="radio" id="navy" name="COLOR" value="navy" checked="checked"/><label for="navy">Navy</label>
		        <input type="radio" id="GRAY" name="COLOR" value="gray" /><label for="GRAY">Gray</label>
		        <input type="radio" id="BLACK" name="COLOR" value="black" /><label for="BLACK">Black</label>
		    </div>
		    <div class="float_btn">
			    <button class="ezgenDW" onClick="window.open('/downloadPlatformApp.html','egzen','width=500,height=300,location=no,status=no,scrollbars=no');">Ezgen download</button>
			    <button class="find_IDPW" onClick="window.open('/FIND_IDPW_POP.jsp','idfind','width=500,height=900,location=no,status=no,scrollbars=no');">ID/비밀번호 찾기</button>
			    <!-- <button class="change_pw" onClick="window.open('/CHANGE_PW.jsp','아이디 / 비밀번호 찾기','width=500,height=900,location=no,status=no,scrollbars=no');">비밀번호 변경</button> -->
			    <!-- button class="find_IDPW">ID/비밀번호 찾기</button-->
			    <!-- button class="change_pw">비밀번호 변경</button-->
		    </div>
		    <div class="login_btn">
		   		<input type="button" name="SignIn" value="Login" onclick="login()">
		    </div>
		</div>
	</div>
	<footer>
		<p>Copyright ⓒ 2020 Green Cross Labcell. All rights reserved.</p>
		<select onchange="if(this.value) location.href=(this.value);">
			<option>GC Family Site</option>
			<option value="http://greencross.com/">GC녹십자</option>
			<option value="http://www.gclabcell.com/">GC녹십자랩셀</option>
			<option value="http://www.gccl.co.kr/">GCCL</option>
			<option value="http://www.gclabs.co.kr/">GC녹십자의료재단</option>
			<option value="http://greencross.com/">GC녹십자지놈</option>
			<option value="http://www.greencrossms.com/">GC녹십자MS</option>
			<option value="http://www.gcem.co.kr/">GC녹십자EM</option>
			<option value="https://www.gchealthcare.com/">GC녹십자헬스케어</option>
			<option value="https://www.greencrosswb.com/">GC녹십자웰빙</option>
			<option value="https://www.gclabtech.com/">GCLabTech</option>
			<option value="http://www.gcimed.com/">GC아이메드</option>
			<option value="http://www.mogam.re.kr">목암연구소</option>
		</select>
        <span>v1.0.0</span>
	</footer>
</body>
</html>