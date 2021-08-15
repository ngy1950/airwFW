<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.DataMap,java.util.ArrayList,project.common.bean.CommonConfig"%>
<%
	//ArrayList<DataMap> list = (ArrayList)request.getAttribute("LANGKY");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta charset="utf-8" name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<link rel="stylesheet" type="text/css" href="/mobile/css/mobile.css">
<link rel="shortcut icon" href="/mobile/images/logo01.png" type="image/x-ico" />
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
<script type="text/javascript" src="/common/js/page.js"></script>
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
	$("#COMPID").val("WDSCM");
	
	$("#USERID").bind("keyup",function(){
		$(this).val($(this).val().toUpperCase());
	});
	$("#PASSWD").bind("keyup",function(){
		$(this).val($(this).val().toUpperCase());
	});
	
	//inputList.setCombo();

	var COLOR = $.cookie("COLOR");
	if(COLOR){
		$("input[value="+COLOR+"]").attr("checked","checked");
	}
	
	var LANGKY = $.cookie("LANGKY");
	if(LANGKY){
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
});

function login(){
	if(validate.check("searchArea")){
		var param = dataBind.paramData("searchArea");
		param.put("LANGKY","KO");
		var json = netUtil.sendData({
			url : "/mobile/json/login.data",
			param : param
		});
		if(json && json.data){
			if(json.data == "N"){
				commonUtil.msg("접속 정보가 다릅니다.\n다시 로그인 해주세요.");
				return;
			} else if(json.data == "F"){
				if(json.cnt < 5){
	                commonUtil.msg("로그인 접속 오류 ( "+json.cnt+"/5 )");
				}else{
                    commonUtil.msg("로그인이 제한됩니다.");
				}
				return;
			}else if(json.data == "F_LOGIN_LOCK"){
 				commonUtil.msg("비밀번호 5회 오류로 사용이 제한 되었습니다. \n비밀번호 찾기를 통해 임시 비밀번호를 발급받아주세요.");
				return;
            }else if(json.data == "NoCon"){
                commonUtil.msg("해당 화주에 접속권한이 없습니다.");
                return;
            }else{
            	
				for(var prop in param.map){
					$.cookie(prop, param.get(prop),{expires : 7});
				}
				if(json && json.data){
					this.location.href = "/mobile/main.page";
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


//공통 화주 - 거점 컨트롤 
$(window).load(function(){

	var param = new DataMap();
	
	var json = netUtil.sendData({
		module : "SajoCommon",
		command : "LOGIN_OWNRKY_COMCOMBO",
		sendType : "list",
		param : param
	});
	
	$("#OWNRKY").find("[UIOption]").remove();
	
	var optionHtml = inputList.selectHtml(json.data, false);
	$("#OWNRKY").append(optionHtml);
	var ownrky = $.cookie("OWNRKY");
	
	if(ownrky == ' ' || ownrky == null || ownrky == undefined){
		
	}else{
		$('#OWNRKY').val(ownrky);
	}
	
	searchwareky($('#OWNRKY').val());
});

function searchwareky(val){
	var param = new DataMap();
	param.put("OWNRKY",val);
	
	var json = netUtil.sendData({
		module : "SajoCommon",
		command : "LOGIN_WAREKY_COMCOMBO",
		sendType : "list",
		param : param
	});
	
	$("#WAREKY").find("[UIOption]").remove();
	
	var optionHtml = inputList.selectHtml(json.data, false);
	$("#WAREKY").append(optionHtml);
	
	var wareky = $.cookie("WAREKY");
	
	if(wareky == ' ' || wareky == null || wareky == undefined){
			
	}else{
		$('#WAREKY').val(wareky);
	}
}
</script>
</head>
<body>
	<div class="mmain_container">
		<h1>
			<img src="/mobile/images/LOGO_1.png"alt="logoimg">
			<img src="/mobile/images/LOGO_2.png"alt="logoimg">
			<img src="/mobile/images/LOGO_3.png"alt="logoimg">
			<img src="/mobile/images/WEBDekWMS.png"alt="logoimg">
		</h1>
		<div class="main-title-box" id="searchArea">
			<div class="m_login">
				<div class="idbox">
					<input type="text" id="USERID" name="USERID" placeholder="아이디"/>
				</div>
				<div class="pwbox">
					<input type="password" id="PASSWD" name="PASSWD" placeholder="비밀번호"/>
				</div>
				<div class="m_option_box1">
					<select name="OWNRKY" id ="OWNRKY" onchange="searchwareky($(this).val())">
					</select>
				</div>
				<div class="m_option_box2">
					<select name="WAREKY" id ="WAREKY">
					</select>
				</div>
				<button onclick="login()"><span>로그인</span></button>
			</div>
		</div>
	</div>
</body>
</html>