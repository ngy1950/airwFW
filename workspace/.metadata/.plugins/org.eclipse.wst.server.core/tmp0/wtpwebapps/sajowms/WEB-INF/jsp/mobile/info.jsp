<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi" />
<meta name="format-detection" content="telephone=no" />
<title>WMS PDA</title>
<%@ include file="/mobile/include/head.jsp" %>
<%
	String isFull = "";
	if(request.getAttribute("isFull") != null){
		isFull = sFilter.getXSSFilter(request.getAttribute("isFull").toString());
	}
%>
<style type="text/css">
.toggleArea{width: calc(50% - 20px);height: calc(30% - 20px);margin: 10px;float: left;}
.toggleArea .title{color: #fff;font-weight: bold;margin-bottom: 10px;margin-top: 25%;}
.toggleArea .title span{padding-left: 7px;}
.toggleArea .toggle{border: 1px solid #737373;width: 100%;color: #666;position: relative;}
.toggleArea .toggle p {margin:0px;display:inline-block;font-size:15px;font-weight:bold;position: absolute;z-index: 1;padding-top: 8px;}
.toggleArea .toggle p.t1{left:112px;color: #7FC241;}
.toggleArea .toggle p.t2{left:172px;color: #f14f4f;}
.switch{position: relative;display: inline-block;width: 100%;height: 35px;vertical-align:middle;z-index: 2;}
.toggleArea .toggle .switch input {display:none;}
.slider {position: absolute;cursor: pointer;top: 0;left: 0;right: 0;bottom: 0;-webkit-transition: .4s;transition: .4s;}
.slider:before {position: absolute;content: "";height: 100%;width: 50%;left: 0px;bottom: 0px;background-color: #666;-webkit-transition: .4s;transition: .4s;}
input:checked + .slider:before {-webkit-transform: translateX(100%);-ms-transform: translateX(100%);transform: translateX(100%);}
.slider.round {border-radius: 34px;}
.slider.round:before {border-radius: 50%;}
</style>
<script type="text/javascript">
var timer = null;
$(window).resize(function(){
	var browser = navigator.userAgent;
	if(browser.indexOf("GsWmsPda") == -1){
		var $obj = $("#screenButton");
		if(window.parent.isFullScreen()){
			$obj.prop("checked",true);
		}else{
			$obj.prop("checked",false);
		}
	}
});

$(document).ready(function(){
	getUserInfo();
	
	var w = $(".toggle").width()/2;
	var t1w = (w/2) - 10;
	var t2w = t1w + w;
	$(".t1").css("left",t1w);
	$(".t2").css("left",t2w);
	
	var browser = navigator.userAgent;
	if(browser.indexOf("GsWmsPda") > -1){
		$(".toggleArea").hide();
	}else{
		var $obj = $("#screenButton");
		if(window.parent.isFullScreen()){
			$obj.prop("checked",true);
		}else{
			$obj.prop("checked",false);
		}
	}
	
	drawMenu();
});

function getUserInfo(){
	//window.parent.configData.MENU_ID = "info";
	
	var usernm = "<%=usernm%>";
	var warenm = "<%=warenm%>";
	
	$("#WARENM").html(isNullChk(warenm));
	if(isNullChk(usernm) == ""){
		usernm = "";
	}else{
		usernm = "안녕하세요, " + usernm + " 님";
	}
	$("#USERNM").html(usernm);
}

function isNullChk(data){
	var str = data;
	if(data == null && $.trim(data) == "" && data == "null" && data == "NULL" && data == undefined){
		str = "";	
	}
	
	return str;
}

function moveLeftMenu(idx){
	parent.frames["topFrame"].contentWindow.leftMenuOpen(idx);
}

function changeScreen(){
	window.parent.toggleFullScreen();
}

function drawMenu(){
	$(".item").remove();
	
	var $div = $("<div>");
	var $ul  = $("<ul>");
	var $li  = $("<li>");
	
	var json = netUtil.sendData({
		module : "Mobile",
		command : "MENU_INFO",
		sendType : "list"
	});
	
	if(json && json.data){
		var list = json.data;
		
		var len = list.length;
		if(len > 0){
			for(var i = 0; i < len; i++){
				var row = list[i];
				var text   = row["LBLTXL"];
				var path   = row["IMGPTH"];
				var mnuid  = row["MENUID"];
				
				var $item   = $div.clone().addClass("item");
				var $itemUl = $ul.clone();
				var $liImg  = $li.clone().addClass("icon").css({"background-image":"url("+path+")"});
				var $liTxt  = $li.clone().addClass("text").text(text);
				
				$item.append($itemUl.append($liImg).append($liTxt));
				$item.attr("onclick","moveLeftMenu('"+mnuid+"')");
				$(".user").after($item);
				
				hidePageHolder();
			}
		}else{
			hidePageHolder();
		}
	}
}

function hidePageHolder(){
	setTimeout(function(){
		$(".infoPageHolder").hide();
	}, 300);
}
</script>
</head>
<body style="background-color: #444;">
	<div class="info_wrap">
		<div class="menu">
			<div class="user">
				<ul>
					<li class="txt1" id="WARENM"></li>
					<li class="txt2" id="USERNM"></li>
				</ul>
			</div>
			<%if(!"Y".equals(isFull)){%>	
			<div class="toggleArea">
				<div class="title"><img src="/common/images/ico_setting.png"/><span>전체화면</span></div>
				<div class="toggle" onclick="changeScreen();">
					<label class="switch">
						<input type="checkbox" id="screenButton">
						<span class="slider"></span>
					</label>
					<p class="t1">On</p>
					<p class="t2">Off</p>
				</div>
			</div>
			<%}%>
		</div>
	</div>
	<!-- layerPop -->
	<div class="mobilePopArea">
		<div class="modalWrap" id="confirm">
			<div class="modal">
				<div class="modalContent">
					<div class="text">
					</div>
					<div class="button">
						<button class="cancel btnWid2 btnBod2 btnAlinL">
							<span CL="BTN_CANCEL"></span>
						</button>
						<button class="confirm btnWid2 btnBod1 btnAlinR">
							<span CL="BTN_CONFIRM"></span>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- page holder -->
	<div class="infoPageHolder">
		<div class="pageHolder"></div>
	</div>
</body>
