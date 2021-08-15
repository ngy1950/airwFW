<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.DataMap,java.util.*,com.common.bean.CommonConfig"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%
	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);

	String langky = sFilter.getXSSFilter(request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY).toString());
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>WMS</title>
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/page.js"></script>
<script type="text/javascript" src="/wms/js/wms.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script type="text/javascript">
MultiWindow = function(index, pathTitle, title, url, menuId) {
	this.index = index;//생성 옵션
	this.pathTitle = pathTitle;
	this.title = title;
	this.url = url;
	this.menuId = menuId;	
	this.bodyFrame = rightFrame;
}

MultiWindow.prototype = {
	setFrame : function() {
		return "MultiWindow";
	},
	toString : function() {
		return "MultiWindow";
	}
}

window.moveTo(0,0);

var labelFrame = true;
var msgFrame = true;

CommonLabel = function() {
	this.labelHistory = new Array();
	this.label = new DataMap();
};

CommonLabel.prototype = {
	getLabel : function(key, type) {
		if(this.label.containsKey(key)){
			var ltxt = this.label.get(key);
			this.labelHistory.push(key+" "+ltxt.split(configData.DATA_COL_SEPARATOR)[type]);
			return ltxt.split(configData.DATA_COL_SEPARATOR)[type];
		}else{
			return key;
		}
	},
	resetHistory : function(){
		this.labelHistory = new Array();
	},
	showHistory : function() {
		var data = this.labelHistory.join("\n");
		if (window.clipboardData) { // Internet Explorer
	        window.clipboardData.setData("Text", data);
	    } else {  
	    	var temp = prompt("Ctrl+C를 눌러 클립보드로 복사하세요", data);
	    }
	},
	toString : function() {
		return "CommonLabel";
	}
};

var commonLabel = new CommonLabel();

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
</script>
<script type="text/javascript" src="/common/lang/label-<%=langky%>.js"></script>
<script type="text/javascript" src="/common/lang/message-<%=langky%>.js"></script>
<script type="text/javascript">
	var leftState = true;
	var $topFrame;
	var topRows;
	var $middleFrame;
	var middleCols;
	var $rightFrame;
	var $bodyFrame;
	var $headFrame;
	var $navFrame;
	var bodyUrl;
	var selectMenuId = "root";
	var menuTabMap = new DataMap();
	var menuWindowStat = new Array();
	var bodyIndex = 0;
	
	var singletonMap = new DataMap();
	
	var $mainFrame;
	
	$(document).ready(function(){
		$topFrame = $("#topFrame");
		topRows = $topFrame.attr("rows");
		$middleFrame = $("#middleFrame");
		middleCols = $middleFrame.attr("cols");
		$rightFrame = $("#rightFrame");
		$bodyFrame = $("#body0");
		$headFrame = $("#header");
		$navFrame = $("#nav");
		$mainFrame = $("#main");
		for(var i=0;i<configData.MAX_MENU_TAB;i++){
			menuWindowStat.push(true);
		}
		try{
			if(!opener.window.name){
				opener.window.open("", '_self').close();
			}	
		} catch (e) {
			// TODO: handle exception
		}
		//공지팝업
		//getMainPopList();
	});
	
	//로딩 열기
	function loadingOpen() {
		
	}

	// 로딩 닫기
	function loadingClose() {

	}
	
	function sizeToggle(){
		if(leftState){
			$middleFrame.attr("cols","0px,*");
			$topFrame.attr("rows","0px,*");
			leftState = false;
		}else{
			$middleFrame.attr("cols",middleCols);
			$topFrame.attr("rows",topRows);
			leftState = true;
		}
	}
	function setActivePageInfo(multiWindow){
		bodyUrl = multiWindow.url;
		bodyIndex = multiWindow.index;
		selectMenuId = multiWindow.menuId;
	}
	function menuPage(menuId){
		frames.left.menuSearch(menuId);
	}
	function linkPage(menuId, data){
		singletonMap.put(menuId, data);		
		if(menuTabMap.containsKey(menuId)){
			multiWindow = menuTabMap.get(menuId);
			//bodyIndex = multiWindow.index;
			//selectMenuId = multiWindow.menuId;
			setActivePageInfo(multiWindow);
			this.nav.changeWindow(multiWindow.menuId);
			try{
				frames["body"+bodyIndex].linkPageOpenEvent(data);
			}catch(e){
				
			}
		}else{
			frames.left.menuSearch(menuId);
		}	
	}
	function getLinkData(menuId){
		var data = singletonMap.get(menuId);
		singletonMap.remove(menuId);
		return data;
	}
	function changePage(pathTitle, title, url, menuId){	
		var multiWindow;
		if(menuTabMap.containsKey(menuId)){
			multiWindow = menuTabMap.get(menuId);
			bodyIndex = multiWindow.index;
			this.nav.changeWindow(multiWindow.menuId);
		}else{
			var tmpIndex = getAvailedWindowIndex();
			if(tmpIndex == configData.MAX_MENU_TAB){
				//commonUtil.msgBox("MASTER_MAX_MENU_TAB");
				alert(commonUtil.format(getMessage("MASTER_M9999"),configData.MAX_MENU_TAB));
				//메뉴탭 최대 개수는 {0}개 입니다.
				return false;
			}
			multiWindow = new MultiWindow(tmpIndex, pathTitle, title, url, menuId);
			menuTabMap.put(menuId, multiWindow);		
			
			menuWindowOpen(multiWindow, true);
			menuWindowStat[tmpIndex] = false;
			
			this.nav.setPage(multiWindow.pathTitle, multiWindow.title, multiWindow.url, multiWindow.menuId);
		}
		
		//bodyUrl = multiWindow.url;
		//bodyIndex = multiWindow.index;
		//selectMenuId = multiWindow.menuId;
		setActivePageInfo(multiWindow);
		
		return true;
	}
	function getAvailedWindowIndex(){
		for(var i=0;i<configData.MAX_MENU_TAB;i++){
			if(menuWindowStat[i]){
				return i;
			}
		}
		
		return configData.MAX_MENU_TAB;
	}
	function menuWindowOpen(multiWindow, realodType){
		bIndex = multiWindow.index;	
		var tmpRows = "25px,0";
		for(var i=0;i<configData.MAX_MENU_TAB;i++){
			if(i==bIndex){
				tmpRows += ",*";
			}else{
				tmpRows += ",0";
			}
		}
		$rightFrame.attr("rows", tmpRows);
		
		if(realodType){
			$("#body"+bIndex).attr("src", multiWindow.url);
			bodyUrl = multiWindow.url;
		}
		//bodyIndex = multiWindow.index;
		//selectMenuId = multiWindow.menuId;
		setActivePageInfo(multiWindow);
	}
	function changeWindow(menuId){
		var multiWindow = menuTabMap.get(menuId);
		//bodyUrl = multiWindow.url;
		//selectMenuId = multiWindow.menuId;
		//bodyIndex = multiWindow.index;
		setActivePageInfo(multiWindow);
		menuWindowOpen(multiWindow);
		
		/*
		2017.05.17 탭 클릭시 좌측메뉴 class add
		*/
		frames.left.changeClass(menuId);
	}
	function closeAll(){
		var keys = menuTabMap.keys();
		for(var i=keys.length-1;i>=0;i--){
			frames.nav.closeWindow(keys[i]);
		}
	}
	function closeWindow(menuId, tmpActiveMenuId){
		frames.left.setLastActiveMenuId(menuId,tmpActiveMenuId);
		var multiWindow = menuTabMap.get(menuId);
		var tmpIndex = multiWindow.index;
		$("#body"+tmpIndex).attr("src", "");
		menuWindowStat[tmpIndex] = true;
		menuTabMap.remove(menuId);
		
		if(tmpIndex == bodyIndex){			
			var tmpWin;
			for(var prop in menuTabMap.map){
				tmpWin = menuTabMap.get(prop);
			}
			if(tmpWin){
				menuWindowOpen(tmpWin);
			}
		}
		if(menuTabMap.size() == 0){
			$rightFrame.attr("rows", "25px,*,0,0,0,0,0");
		}
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
	function getLabelHistory(){
		commonLabel.showHistory();
	}
	function resetLabelHistory(){
		commonLabel.resetHistory();
	}	
	function refreshPage(){
		if(menuTabMap.size()){
			$("#body"+bodyIndex).attr("src", bodyUrl);
		}		
	}
	function getMenuId(){
		if(selectMenuId){
			return selectMenuId;
		}else{
			return "MENUID";
		}		
	}
	function reloadPage(){
		location.reload();
	}
	
	function logoEffectStart(){
		this.header.logoEffectStart();
	}

	function logoEffectStop(){
		this.header.logoEffectStop();
	}
	
	function getMainPopList(){
		var json = netUtil.sendData({
			module : "Wms",
			command : "MAINPOPUP",
			sendType : "count",
			param : new DataMap()
		});
		
		if(json){
			if(json.data > 0){
				var sWidth = 500;
				var sHeight = 600;
				window.opener = "_blank";
				window.open("/wms/mainPop.page", "mainPop", "height="+(sHeight)+",width="+(sWidth)+",resizable=yes,location=no");
			}
		}
	} 
</script>
<frameset id="topFrame" name="topFrame" rows="50px,*" noresize framespacing=0 frameborder=no border=0 >
    <frame id="header" name="header" src="/wms/topS.data" noresize framespacing=0 frameborder=no border=0 >
    <frameset id="middleFrame" name="middleFrame" cols="251px,*" noresize framespacing=0 frameborder=no border=0 >
        <frame id="left" name="left" src="/wms/common/json/leftMenu.data" name="lnb" noresize framespacing=0 frameborder=no border=0>
        <frameset id="rightFrame" name="rightFrame" rows="25px,*,0,0,0,0,0" noresize framespacing=0 frameborder=no border=0 >
			<frame id="nav" name="nav" src="/wms/wintabS.page" noresize framespacing=0 frameborder=no border=0 >
			<frame id="main" name="main" src="/wms/info.page" noresize framespacing=0 frameborder=no border=0 >
			<frame id="body0" name="body0" src="" noresize framespacing=0 frameborder=no border=0 >
			<frame id="body1" name="body1" src="" noresize framespacing=0 frameborder=no border=0 >
			<frame id="body2" name="body2" src="" noresize framespacing=0 frameborder=no border=0 >
			<frame id="body3" name="body3" src="" noresize framespacing=0 frameborder=no border=0 >
			<frame id="body4" name="body4" src="" noresize framespacing=0 frameborder=no border=0 >
			<frame id="body5" name="body5" src="" noresize framespacing=0 frameborder=no border=0 >
			<frame id="body6" name="body6" src="" noresize framespacing=0 frameborder=no border=0 >
			<frame id="body7" name="body7" src="" noresize framespacing=0 frameborder=no border=0 >
			<frame id="body8" name="body8" src="" noresize framespacing=0 frameborder=no border=0 >
			<frame id="body9" name="body9" src="" noresize framespacing=0 frameborder=no border=0 >
		</frameset>
    </frameset>
</frameset>
</html>