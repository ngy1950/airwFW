<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.CommonConfig"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%
	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);
	String theme = sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY));
%>
<!doctype html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta charset="utf-8">
<title></title>
<meta name="viewport" content="width=1150">
<link rel="stylesheet" type="text/css" href="/common<%=theme%>/css/common.css">
<link rel="stylesheet" type="text/css" href="/common/theme/gsfresh/css/wintabS.css">
<link rel="stylesheet" type="text/css" href="/common/theme/gsfresh/css/theme.css">
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/ui.js"></script>
<script type="text/javascript">
	var $multiList;
	var $pathTitle;
	
	$(document).ready(function(){
		$multiList = jQuery("#multiList");
		$pathTitle = $("#pathTitle");
		
		uiList.UICheck();
		
		$winTabLeft = $("#winTabLeft");
		$winTabRight = $("#winTabRight");
	});
	$(window).resize(function(event){
		checkTabListSize();
	});
	function sizeToggle(self){
		var self = $(self);
		var src = self.find("img").attr("src");
		window.top.sizeToggle();
	}
	function activeTab($tab){
		$multiList.find("li").removeClass("active");
		$tab.addClass("active");
		var menuId = $tab.attr("menuId");
		window.top.changeWindow(menuId);
	}
	function changeWindow(menuId){
		var $tab = $multiList.find("[menuId="+menuId+"]");
		if($tab.hasClass("active")){
			
		}else{
			activeTab($tab);
		}
		checkTabListSize();
	}
	function closeWindow(menuId){
		var $tabs = $multiList.find("[menuId="+menuId+"]");
		$tabs.remove();
		var tmpActiveMenuId;
		var $tabList = $multiList.find("[menuId]");
		if($tabList.length >= 1){
			var $tmpTab = $tabList.eq($tabList.length-1);
			if($tabs.hasClass("active")){
				activeTab($tmpTab);
				tmpActiveMenuId = $tmpTab.attr("menuId");
			}else{
				if($tmpTab.hasClass("active")){
					tmpActiveMenuId = $tmpTab.attr("menuId");
				}
			}
		}
		
		if($tabList.length == 0){
			parent.$mainFrame[0].contentWindow.infoReload();
		}
		
		window.top.closeWindow(menuId, tmpActiveMenuId);
		
		checkTabListSize();
	}
	
	function closeAll(){
		var tabList = $multiList.find("li");
		var menuId;
		for(var i=0;i<tabList.length;i++){
			menuId = tabList.eq(i).attr("menuId");
			closeWindow(menuId);
		}
		parent.$mainFrame[0].contentWindow.infoReload();
		checkTabListSize();
	}
	function setPage(pathTitle, title, url, menuId){
		var width = $("#multiList").width();
		
		var $li = $("<li>").clone();
		var $div = $("<div>").clone();
		var $span = $("<span>").clone();
		var $img = $("<img>").clone().attr({"src":"/common<%=theme%>/images/btn_null.png","alt":"close"});
		
		$multiList.find("li").removeClass("active");
		
		var $tmpSpan = $span.addClass("txt_wrap").html(title);
		$tmpSpan.click(function(event){
			var $obj = $(event.target);
			var menuId = $obj.parents("[menuId]").attr("menuId");
			changeWindow(menuId);
		});
		
		var $tmpObj = $li.append($div.addClass("tab_right").append($tmpSpan).append($img));
		$tmpObj.addClass("active");
		$tmpObj.attr("menuId",menuId);
		$tmpObj.find("img").click(function(event){
			var $obj = $(event.target);
			var menuId = $obj.parents("[menuId]").attr("menuId");
			closeWindow(menuId);
		});
		
		$multiList.append($tmpObj);
		
		var $tabSpan = $tmpObj.find("span");
		var w = Math.ceil($tabSpan[0].getBoundingClientRect().width);
		
		$tabSpan.css("width",w);
		$tabSpan.parent().css("width",w + 7);
		$tmpObj.css("width",w + 32);
		
		checkTabListSize();
	}
	
	var tabBtnView = true;
	var $winTabLeft;
	var $winTabRight;
	var windTabWidth;
	var activeIndex;
	var $liList;
	var moveTabCount = 0;
	var maxTabCount = 0;
	function checkTabListSize(){
		var tabWidth = $(".menu-item").width() + 1;
		var windTabWidth = 0;
		var activeWidth = 0;
		
		parent.$mainFrame[0].contentWindow.roopChk();
		parent.parent.parent.$headFrame[0].contentWindow.topRoopChk();
		
		$liList = $("#multiList li");
		if($liList.length > 0){
			$("#multiList li").each(function(i){
				if($(this).hasClass("active")){
					activeWidth = $(this).outerWidth(true);
					activeIndex = i;
				}
				windTabWidth += $(this).outerWidth(true);
			});
			
			var actTabSize = activeTabSize();
			if(actTabSize > tabWidth){
				var moveTabWidth = tabWidth - actTabSize + 60;
				$multiList.css("left",moveTabWidth + "px");
			}else{
				$multiList.css("left",60);
			}
		}else{
			$multiList.css("width","");
		}
		
		var tabIdx = $("#multiList").find(".active").index() + 1;
		moveTabCount = tabIdx;
	}
	
	function setMaxTabCount(){
		var result = 0;
		
		var tabWrapWidth = $(".menu-item").width() + 1;
		var tabWidth = $multiList.width();
		var tabCount = $multiList.children().length;
		if(tabCount > 0){
			result = Math.ceil(tabWidth/tabWrapWidth);
		}
		
		return result;
	}
	
	function setCurrentTabCount(){
		var tabIdx = $multiList.find(".active").index();
	}
	
	function activeTabSize(){
		var activeTabSize = 0;
		var isStop = false;
		
		$("#multiList").children().each(function(){
			if(isStop){
				return;
			}
			activeTabSize += $(this).outerWidth(true);
			if($(this).hasClass("active")){
				isStop = true;
			}
		});
		
		return activeTabSize;
	}
	
	function showActiveTab(){
		for(var i=0;i<activeIndex;i++){
			$liList.eq(i).hide();
		}
		for(var i=activeIndex;i<$liList.length;i++){
			$liList.eq(i).show();
		}
	}
	
	function tabLeft(){
		var $tabList = $("#multiList li");
		
		var moveTabSize = commonUtil.parseInt(commonUtil.replaceAll($("#multiList").css("left"),"px",""));
		var activeTabSize  = $tabList.eq(moveTabCount - 1).outerWidth(true);
		
		moveTabSize = moveTabSize + activeTabSize;
		
		if(moveTabSize >= 60){
			moveTabSize = 60;
			moveTabCount = 1;
		}
		
		$("#multiList").css("left",moveTabSize + "px");
		
		if(moveTabCount <= 1){
			moveTabCount = 1;
			return;
		}
		
		moveTabCount--;
	}
	
	function tabRight(){
		var totalMenuCount = $liList.length;
		
		var wrapTabSize = $(".menu-item").width() + 1;
		var currentTabSize = $("#multiList").width();
		
		if(wrapTabSize >= currentTabSize){
			return;
		}
		
		var moveTabSize = commonUtil.parseInt(commonUtil.replaceAll($("#multiList").css("left"),"px",""));
		var activeTabSize  = $("#multiList").children().eq(totalMenuCount - (totalMenuCount - moveTabCount) - 1).outerWidth(true);
		
		moveTabSize = moveTabSize - activeTabSize;
		
		if(wrapTabSize > ((currentTabSize + moveTabSize) -60)){
			moveTabSize = (wrapTabSize - currentTabSize) + 60;
			$("#multiList").css("left",moveTabSize + "px");
			
			return;
		}
		
		if(totalMenuCount <= moveTabCount){
			moveTabCount = totalMenuCount;
			moveTabSize = (($(".menu-item").width() + 1) - $("#multiList").width()) + 60;
			
			$("#multiList").css("left",moveTabSize + "px");
			
			return;
		}
		
		$("#multiList").css("left",moveTabSize + "px");
		
		moveTabCount++;
	}
	
	function isMaxTab(){
		var tabWidth = $(".menu-item").width() + 1;
		var activeTabSize = 0;
		for(var i = 0; i < moveTabCount; i++){
			activeTabSize += $("#multiList").children().eq(i).find(".tab_right").width() + 22;
		}
		
		var winTabSize = $("#multiList").width();
		var moveTabSize = ((activeTabSize * -1) + 60);
		
		if(tabWidth >= (winTabSize + moveTabSize)){
			return true;
		}
		
		return false;
	}
</script>
</head>
<body class="content_header">
<div class="tab type1" id="windowTabs" style="overflow:hidden; height:25px;">
	<button class="menu lnbCloser" onclick="sizeToggle(this)"></button>
	<div class="menu-info" id="pathTitle">
		<div class="all_close" id="allClose">
			<img src="/common/theme/gsfresh/images/login_img/btn_closeAll-black.png" alt="close" onClick="closeAll()" />
		</div>
		 <div class="tab_list" id="tabList">
			<img src="/common/theme/gsfresh/images/login_img/list_left.png" alt="left"  id="winTabLeft" onClick="tabLeft()" />
			<img src="/common/theme/gsfresh/images/login_img/list_right.png" alt="right" id="winTabRight" onClick="tabRight()" />
		</div>
	</div>
	<div class="menu-item">
		<ul id="multiList"></ul>
	</div>
</div>
</body>
</html>