<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.DataMap,java.util.*,project.common.bean.CommonConfig"%>
<%
	String langky = request.getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY).toString();
	String isBack = "";
	if(request.getAttribute("isBack") != null){
		isBack = request.getAttribute("isBack").toString();
	}
%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi" />
<meta name="format-detection" content="telephone=no" />
<title>WMS PDA</title>
<link rel="shortcut icon" href="/pda/img/favicon.png" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="/pda/css/mobile.css" />
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript">
configData.isMobile = true;
var isBack = "<%=isBack%>";

var labelFrame = true;
var msgFrame = true;
var menuMap = new DataMap();

var labelObj = new Object();

CommonMessage = function() {
	this.message = new DataMap();
};

CommonMessage.prototype = {
	getMessage : function(key) {
		var mtxt = this.message.get(key);
		if(mtxt){
			commonLabel.labelHistory.push(key+" "+mtxt.split(configData.DATA_COL_SEPARATOR)[1]);
			return mtxt.split(configData.DATA_COL_SEPARATOR)[1];
		}else{
			return key;
		}
	},
	toString : function() {
		return "CommonMessage";
	}
};

var commonMessage = new CommonMessage();

//로딩 열기
function loadingOpen() {
	
}

//로딩 닫기
function loadingClose() {
	
}

function getLabel(key, type){
	if(!type){
		type = 1;
	}
	return commonLabel.getLabel(key, type);
}

function getMessage(key){
	return commonMessage.getMessage(key);
}

function logout(){
	location.href = "/pda/json/logout.page";
}
</script>
<script type="text/javascript" src="/common/lang/label-<%=langky%>.js"></script>
<script type="text/javascript" src="/common/lang/message-<%=langky%>.js"></script>
<script type="text/javascript">
	var menuOpenState = false;
	var $mainFrame;
	var $topFrame;
	var $bodyFrame;
	var toggleIdx = 0;
	var menuPageParam = new DataMap();
	
	$(document).ready(function(){
		$mainFrame = $("#mainFrame");
		$topFrame = $("#topFrame");
		$bodyFrame = $("#bodyFrame");
	});
	function menuOpen(){
		if(menuOpenState){
			$mainFrame.attr("rows","35px,*");/* 47px */
			menuOpenState = false;
		}else{
			$mainFrame.attr("rows","*,0px");
			menuOpenState = true;
		}
	}
	function openPage(menuId, url){
		sessionClear();
		menuMap.put(menuId,url);
		$bodyFrame.attr("src",url);
		menuOpen();
	}
	function goMain() {
		sessionClear();
		var url = "/pda/info.page";
		$bodyFrame.attr("src",url);
		$mainFrame.attr("rows","35px,*");/* 47px */
		menuOpenState = false;
	}
	function goPage(menuId) {
		var url = menuMap.get(menuId);
		$bodyFrame.attr("src",url);
	}
	function linkPage(menuId,data){
		var menuList = frames["topFrame"].contentWindow.g_menu_list;
		var menuData = menuList.get(menuId);
		
		if(menuData != undefined && menuData != null && $.trim(menuData) != ""){
			if(menuPageParam.containsKey(menuId)){
				menuPageParam.put(menuId,new DataMap());
			}
			if(data){
				menuPageParam.put(menuId,data);
			}
			
			var url = menuData.get("url");
			var menuName = menuData.get("menuName");
			
			frames["topFrame"].contentWindow.changeMenuTitle(menuId,menuName);
			
			goUrl(url);
		}
	}
	function getLinkData(menuId){
		var data = menuPageParam.get(menuId);
		return data;
	}
	function initListData(menuId){
		menuPageParam.remove(menuId);
	}
	function goUrl(url) {
		$bodyFrame.attr("src",url);
	}
	function menuHeightReturn(){
		var topH = $topFrame.height();
		return topH;
	}
	function sessionClear(){
		try{
			sessionStorage.clear();
		}catch(e){}
	}
	function isFullScreen(){
		return document.fullscreen;
	}
	function toggleFullScreen() {
		if(toggleIdx == 0){
			if (!document.fullscreenElement) {
				toggleIdx++;
				document.documentElement.requestFullscreen();
			} else {
				if (document.exitFullscreen) {
					document.exitFullscreen();
				}
			}
		}else{
			toggleIdx = 0;
		}
	}
</script>
</head>
<frameset id="mainFrame" name="topFrame" rows="35px,*" noresize framespacing='0' frameborder='no' border='0' style="background-color: #444;">
    <frame id="topFrame" name="header" src="/pda/json/top.data" noresize framespacing='0' frameborder='no' border='0' scrolling="no" style="background-color: #444;">
    <frame id="bodyFrame" name="main" src="/pda/info.page" noresize framespacing='0' frameborder='no' border='0' style="background-color: #444;">
</frameset>