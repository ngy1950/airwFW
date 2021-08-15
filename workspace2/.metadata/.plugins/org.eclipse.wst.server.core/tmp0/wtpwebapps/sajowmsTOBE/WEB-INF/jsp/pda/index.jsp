<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.DataMap,java.util.ArrayList,project.common.bean.CommonConfig"%>
<%@ page import="java.net.*"%>
<%@ page import="project.common.util.*"%>
<%
	DataMap row;

	Object SES_USER_ID = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY);
	
	String env = "";
	if(request.getAttribute("ENV") != null){
		env = request.getAttribute("ENV").toString();
	}
	
	String isBack = "";
	if(request.getAttribute("isBack") != null){
		isBack = request.getAttribute("isBack").toString();
	}
	
	String isFullScreen = "N";
	if(request.getParameter("isFullScreen") != null){
		isFullScreen = request.getParameter("isFullScreen").toString();
	}
	
	String isAppDown = "";
	if(request.getAttribute("isAppDown") != null){
		isAppDown = request.getAttribute("isAppDown").toString();
	}
%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi" />
<meta name="format-detection" content="telephone=no" />
<title>WMS PDA</title>
<%if("PROD".equals(env)){%>
<link rel="manifest" href="/pda/manifest/manifest.json">
<%}%>
<link rel="stylesheet" type="text/css" href="/pda/css/mobile.css" />
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/input.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script type="text/javascript" src="/common/js/validateUtil.js"></script>
<script type="text/javascript" src="/common/js/label.js"></script>
<script type="text/javascript" src="/common/theme/webdek/js/theme.js"></script>
<script type="text/javascript" src="/pda/js/mobileCommon.js"></script>
<script type="text/javascript" src="/pda/js/mobileKeyPad.js"></script>
<style type="text/css">
input:-webkit-autofill{
	transition: background-color 5000s ease-in-out 0s;
	-webkit-text-fill-color: #fff !important;
	caret-color: #fff;
}
</style>
<script>
var isBack = "<%=isBack%>";
var isFullScreen = "<%=isFullScreen%>";
configData.isMobile = true;
configData.MENU_ID = "index";

var appList = [];

var pdaFullScreenSize = 584;

window.onpageshow = function (e) {
	if(e.persisted || (window.performance && window.performance.navigation.type == 2)){
		location.replace("/pda/main.page?isBack=Y");
	}else{
		if(isBack == "Y"){
			isBack == "N";
			var browser = navigator.userAgent;
			if(browser.indexOf("GsWmsPda") > -1){
				mobileCommon.confirm({
					message : "WMS 앱을 종료 하시겠습니까?",
					confirm : function(){
						isBack == "N";
						window.wmsBridge.exit();
					}
				});
			}
		}
	}
};

history.pushState(null, null, "/pda/index.page");
window.onpopstate = function () {
	history.go(1);
	var browser = navigator.userAgent;
	if(browser.indexOf("GsWmsPda") > -1){
		mobileCommon.confirm({
			message : "WMS 앱을 종료 하시겠습니까?",
			confirm : function(){
				isBack == "N";
				window.wmsBridge.exit();
			}
		});
	}else{
		isBack == "N";
	}
};

var env = "<%=env%>";
var userAgent = navigator.userAgent.toLowerCase();
if(userAgent.match("android")){
	switch (env) {
	case "DEV":
		document.write('<link rel="shortcut icon" href="/common/theme/webdek/images/logo01.png" type="image/x-ico">');
		break;
	case "PROD":
		document.write('<link rel="shortcut icon" href="/common/theme/webdek/images/logo01.png" type="image/x-ico">');
		break;
	default:
		document.write('<link rel="shortcut icon" href="/common/theme/webdek/images/logo01.png" type="image/x-ico">');
		break;
	}
}else{
	document.write('<link rel="shortcut icon" href="/common/theme/webdek/images/logo01.png" type="image/x-ico">');
}

var windowHeight = $(window).height();
$(window).resize(function(){
	if(this.resizeTO) {
		clearTimeout(this.resizeTO);
	}
	this.resizeTO = setTimeout(function(){
		$(this).trigger("keyPad");
	},0);
});

$(window).on("keyPad",function(){
	var currentPadHeight = $(window).height();
	setTimeout(function(){
		if(currentPadHeight == windowHeight){
			$(".login_content").css("overflow-y","hidden");
			$(".login_content").scrollTop(0);
			$(".btnWrap").show();
		}
	});
});

var $langky;

function getMsg(msgCode){
	msgCode = $langky.val()+"_"+msgCode;
	return commonMessage.message.get(msgCode);
}

function getLabel(){
	return "";
}

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

var topLabelFrame;

$(document).ready(function(){
	$langky = jQuery("#LANGKY");
	
	topLabelFrame = window;
	
	inputList.setCombo();
<%
	if(SES_USER_ID != null && !"".equals(SES_USER_ID.toString())){
%>
	var paramFullScreen = "N";
	if((windowHeight >= pdaFullScreenSize) || (isFullScreen == "Y")){
		paramFullScreen = "Y";
	}
	this.location.href = "/pda/main.page?fullScreen="+paramFullScreen;
<%
	}else{
%>
	var USERID = $.cookie("USERID");
	if(USERID){
		jQuery("#USERID").val(USERID);
	}
<%
	}
%>
	$("#PASSWD").on("focus",function(){
		$(".login_content").css("overflow-y","auto");
		$(".login_content").scrollTop(270);
		$(".btnWrap").hide();
	});
	
	$("#PASSWD").on("blur",function(){
		$(".login_content").css("overflow-y","hidden");
		$(".login_content").scrollTop(0);
		$(".btnWrap").show();
	});

	$("body").show();
<%	
	if("Y".equals(isAppDown)){ 
%>
	setAppPage();
<%
	}
%>
});

function login(){
	if(validate.check("searchArea")){
		var param = dataBind.paramData("searchArea");
		
		var fullScreen = "N";
		var currentWindowHeight = $(window).height();
		if((currentWindowHeight >= pdaFullScreenSize) || (isFullScreen == "Y")){
			fullScreen = "Y";
		}
		param.put("fullScreen",fullScreen);
		
		var json = netUtil.sendData({
			url : "/pda/json/login.data",
			param : param
		});
		
		if(json && json.data){
			var areaId = "searchArea";
			
			if(json.data == "F"){
				mobileCommon.alert({
					message : "로그인 정보가 틀립니다. 다시 시도해 주세요.",
					confirm : function(){
						mobileCommon.select("",areaId,"USERID");
					}
				});
			}else{
				this.location.href = "/pda/main.page";
			}
		}
	}	
}

function validationEventMsg(valObjType, objIndex, objId, objName, objValue, valType){
	if(objName == "USERID"){
		return getMsg("M0009");
	}else if(objName == "PASSWD"){
		return getMsg("M0010");
	}else if(objName == "WAREKY"){
		return getMsg("M0011");
	}else if(objName == "LANGKY"){
		return getMsg("M0012");
	}
}

// 값 존재 체크
function isNull(sValue) {
    var value = (sValue+"").replace(" ", "");
    
    if( new String(value).valueOf() == "undefined")
        return true;
    if( value == null )
        return true;
    if( value.toString().length == 0 )
        return true;
    
    return false;
}

// keyPress Enter 처리 함수
function checkList(){
    // 필수입력값 체크 
    // 모두 입력 sendData
    // 미입력 빈값 포커스
    
    var param  = dataBind.paramData("searchArea");
    
    var USERID = $.trim(param.get("USERID"));
    var PASSWD = $.trim(param.get("PASSWD"));
    var WAREKY = $.trim(param.get("WAREKY"));
    
    if( isNull( USERID ) ||  isNull( PASSWD ) ||  isNull( WAREKY )){
        if(isNull( USERID )){
            $("[name='USERID']").focus();
        }else if ( isNull( PASSWD ) ){
            $("[name='PASSWD']").focus();
        }else if ( isNull( WAREKY ) ){
        	$("[name='USERID']").blur();
        	$("[name='PASSWD']").blur();
        }
    }else{
        login();
    }
}
<%	
	if("Y".equals(isAppDown)){ 
%>
	function setAppPage(){
		var browser = navigator.userAgent;
		if(browser.indexOf("GsWmsPda") > -1){
			$(".appDownWrap").remove();
			return;
		}
		
		appList = [];
		var $obj = $("[name=appVervion]");
		$obj.children().remove();
		
		var $app = $("#appDownPage");
		$(".appDownWrap .appDown .info p").unbind("click").on("click",function(){
			var $obj = $(this);
			$obj.addClass("appDownFocus");
			setTimeout(function(){
				$obj.removeClass("appDownFocus");
				
				searchVersion();
				
				$app.show();
			}, 100);
		});
		
		$("#back").unbind("click").on("click",function(){
			$app.hide();
			var value = $obj.find("option").eq(0).val();
			$obj.val(value);
		});
		
		var width = $("body").width();
		var $content = $(".appDownPageWrap .appDownPage .content");
		$content.css({"width":width});
	}
	
	function searchVersion(){
		appList = [];
		var $obj = $(".version");
		$obj.children().remove();
		
		var param = new DataMap();
		param.put("ISTYPE","N");
		var json = netUtil.sendData({
			url : "/pda/json/appDownList.data",
			sendType : "list"
		});
		
		if(json && json.data){
			var data = json.data;
			var len = data.length;
			if(len > 0){
				var $select = $("<select>");
				var $option = $("<option>");
				
				var $versionBox = $select.clone().attr({"name":"appVervion","onchange":"changeAppInf()"});
				for(var i = 0; i < len; i++){
					var row = data[i];
					var seq = row["SEQ"];
					var appVersion = row["APPVER"];
					
					appList.push(row);
					
					var $item = $option.clone().text(appVersion);
					$item.attr({"value":seq});
					
					$versionBox.append($item);
					
					$obj.append($versionBox);
					
					changeAppInf();
				}
			}
		}
	}
	
	function changeAppInf(){
		var $obj = $("[name=appVervion]");
		var seq = $obj.val();
		var app = appList.filter(function(element,index,array){
			return element["SEQ"] == seq 
		});
		if(app.length > 0){
			var row = app[0];
			var uuid    = row["IMGFKY"];
			var appName = row["APPFNM"];
			var appVer  = row["APPVER"];
			var appSize = row["APKSIZ"];
			
			var $img = $(".appIcon img");
			if($.trim(uuid) == ""){
				if(env == "PROD"){
					$img.attr("src","/pda/img/ico/ic_prod_pda.png");
				}else{
					$img.attr("src","/pda/img/ico/ic_dev_pda.png");
				}
			}else{
				$img.attr("src","/pda/icon/view.data?uuid="+uuid);
			}
			$("#appName").text(appName);
			$("#appVer").text(appVer);
			$("#appSize").text(appSize);
			
			var $infImg = $(".infImg").find("img");
			var i1 = "/common/images/ico_btn20.png";
			var i2 = "/common/images/ico_btn16.png";
			
			var t1 = "최신 버전 O";
			var t2 = "최신 버전 X";
			
			var currentVersion = $obj.find("option").eq(0).text();
			if(currentVersion != appVer){
				$infImg.attr("src",i2);
				$("#appCheck").text(t2);
			}else{
				$infImg.attr("src",i1);
				$("#appCheck").text(t1);
			}
		}
	}
	
	function appDownload(){
		var $obj = $("[name=appVervion]");
		var seq = $obj.val();
		var app = appList.filter(function(element,index,array){
			return element["SEQ"] == seq 
		});
		if(app.length > 0){
			var row = app[0];
			var uuid = row["APKFKY"];
			
			$("#fileDownloadForm").remove();
			var $form = $("<form>");
			var $input = $("<input>");
			var $f = $form.clone().attr({
				"action":"/pda/apk/fileDown/file.data",
				"method": "post",
				"id":"fileDownloadForm" 
			});
			var $i =$input.clone().attr({
				"type":"hidden",
				"name":"UUID"
			});
			$i.val(uuid);
			$f.append($i);
			$f.hide().appendTo("body");
			$("#fileDownloadForm").submit();
		}
	}
	
	function failIcon($img){
		if(env == "PROD"){
			$img.src = "/pda/img/ico/ic_prod_pda.png";
		}else{
			$img.src = "/pda/img/ico/ic_dev_pda.png";
		}
	}
<%
	}
%>
</script>
</head>
<body>
	<div class="index_wrap">
		<div class="login_content">
			<div class="cmp_img"><p></p></div>
			<div class="head">
				<span class="e">e</span><span>WMS</span>
			</div>
			<div class="main" id="searchArea">
				<input type="hidden" id="LANGKY" name="LANGKY" value="KR" />
				<div class="inputWrap">
					<ul>
						<li class="img usr_img"></li>
						<li class="txt">
							<input type="text" id="USERID"  name="USERID" validate="required" placeholder="ID" onkeypress="commonUtil.enterKeyCheck(event, 'checkList()')">
						</li>
					</ul>
				</div>
				<div class="inputWrap">
					<ul>
						<li class="img pwd_img"></li>
						<li class="txt">
							<input type="password" id="PASSWD"  name="PASSWD" validate="required" placeholder="Password" onkeypress="commonUtil.enterKeyCheck(event, 'checkList()')" />
						</li>
					</ul>
				</div>
				<div class="btnWrap">
					<button onClick="login()">로그인</button>
				</div>
<%	
	if("Y".equals(isAppDown)){ 
%>				
				<div class="appDownWrap">
					<div class="appDown">
						<div class="info">
							<img src="/pda/img/ico/info-white.png">
							<p>App 다운로드</p>
						</div>
					</div>
				</div>
<% 
	}
%>				
			</div>
		</div>
	</div>
</body>
<!-- layerPop -->
<div class="mobilePopArea">
	<div class="modalWrap" id="alert">
		<div class="modal">
			<div class="modalContent">
				<div class="text">
				</div>
				<div class="button">
					<button class="confirm btnWid1 btnBod1">
						<span>확인</span>
					</button>
				</div>
			</div>
		</div>
	</div>
	<div class="toastWrap" id="toast">
		<div class="toast">
			<div class="text">
				<p class="img"></p>
				<p class="txt"></p>
			</div>
		</div>
	</div>
	<div class="modalWrap" id="confirm">
		<div class="modal">
			<div class="modalContent">
				<div class="text">
				</div>
				<div class="button">
					<button class="cancel btnWid2 btnBod2 btnAlinL">
						<span>취소</span>
					</button>
					<button class="confirm btnWid2 btnBod1 btnAlinR">
						<span>확인</span>
					</button>
				</div>
			</div>
		</div>
	</div>
<%	
	if("Y".equals(isAppDown)){ 
%>	
	<div class="appDownPageWrap" id="appDownPage">
		<div class="appDownPage">
			<div class="header">
				<div class="back" id="back">
					<img src="/pda/img/ico/arrow-l-white.png">
				</div>
				<div class="version">
					<select name="appVervion"></select>
				</div>
			</div>
			<div class="content">
				<div class="appInfo">
					<div class="appInfoHead">
						<div class="appIcon">
							<img src="/pda/img/ico/ic_prod_pda.png" onerror="failIcon(this);">
						</div>	
						<div class="appName">
							<p class="anm" id="appName"></p>
						</div>
					</div>
					<div class="appInfoBody">
						<div class="appInfo">
							<div class="inf">
								<ul>
									<li class="c">Version</li>
									<li id="appVer"></li>
								</ul>
							</div>
							<div class="ds"><p></p></div>
							<div class="inf">
								<ul>
									<li class="c">Size</li>
									<li id="appSize"></li>
								</ul>
							</div>
							<div class="ds"><p></p></div>
							<div class="inf">
								<ul>
									<li class="infImg">
										<img src="/common/images/ico_btn20.png"/>
									</li>
									<li>
										<span id="appCheck"></span>
										<!-- <span class="pl">
											<img src="/mobile/img/ico/info-white.png">
										</span> -->
									</li>
								</ul>
							</div>
						</div>
						<div class="downBtn">
							<button onclick="appDownload();">다운로드</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
<% 
	}
%>	
</div>	