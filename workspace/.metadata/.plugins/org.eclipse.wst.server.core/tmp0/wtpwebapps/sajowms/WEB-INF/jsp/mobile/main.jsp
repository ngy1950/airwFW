<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.DataMap,java.util.*,com.common.bean.CommonConfig"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%
	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);
	String langky = sFilter.getXSSFilter(request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY).toString());
	String isBack = "";
	if(request.getAttribute("isBack") != null){
		isBack = sFilter.getXSSFilter(request.getAttribute("isBack").toString());
	}
	
	String scheme = request.getScheme();
%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi" />
<meta name="format-detection" content="telephone=no" />
<%if("https".equals(scheme)){%>
<link rel="manifest" href="/mobile/manifest/manifest.json">
<%}%>
<title>WMS PDA</title>
<link rel="shortcut icon" href="/mobile/img/favicon.png" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="/mobile/css/mobile.css" />
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
	location.href = "/mobile/json/logout.page";
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
		var url = "/mobile/info.page";
		$bodyFrame.attr("src",url);
		$mainFrame.attr("rows","35px,*");/* 47px */
		menuOpenState = false;
	}
	function goPage(menuId) {
		var url = menuMap.get(menuId);
		if($.trim(url)== ""){
			//예외처리 발생시 url처리
			if(menuId.indexOf("GR") >-1) menuId = "inbound/"+menuId;
            if(menuId.indexOf("IM") >-1) menuId = "inbound/"+menuId;
            if(menuId.indexOf("IG") >-1) menuId = "inbound/"+menuId; 
            if(menuId.indexOf("IP") >-1) menuId = "inventory/"+menuId;
            if(menuId.indexOf("SD") >-1) menuId = "inventory/"+menuId; 
            if(menuId.indexOf("DL") >-1) menuId = "outbound/"+menuId; 
            if(menuId.indexOf("MV") >-1) menuId = "task/"+menuId; 
            if(menuId.indexOf("PT") >-1) menuId = "task/"+menuId; 
            
		    url = "/mobile/"+menuId+".page";	
		}
		$bodyFrame.attr("src",url);
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
    <frame id="topFrame" name="header" src="/mobile/json/top.data" noresize framespacing='0' frameborder='no' border='0' scrolling="no" style="background-color: #444;">
    <frame id="bodyFrame" name="main" src="/mobile/info.page" noresize framespacing='0' frameborder='no' border='0' style="background-color: #444;">
</frameset>