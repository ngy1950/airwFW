<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<html>
<head>
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<style>
	body {margin:0; padding:0 3%; background: #fff;overflow: hidden;}
	ul, li {list-style:none; margin:0; padding:0}
	.container {position:relative; width:100%; height:100%; height:500px;}
	
	/* header */
	.noteTitle {width: 100%; height:44px; margin-top:10px;}
	.noteTitle div {align-items:center; border-bottom:3px solid #a9a9a9;}
	.noteTitle h4 {width:40px; min-width:40px; margin-left:10px; margin-right:10px;}
	.noteTitle p {width: 90%; color: #74bd3b; font-weight: bold; margin: 0; float:left; line-height: 33px; font-size: 25px;border-left: 6px solid #74bd3b;padding-left: 10px;}
	
	.content {width: 100%; position:absolute;left:0; top:20px; border-bottom: 1px solid #a9a9a9;}
	.content ul:after {display:block; content:""; clear:both;}
	/* 탭 */
	.tabArea {width:100%;position: absolute;}
	.tabArea:after {display:block; content:""; clear:both;}
	.tabArea li {position:relative; font-weight: bold; border: 1px solid #e2e2e2; text-align: center; width: 100px; line-height: 35px; background: #fbfbfb;}
	.tabArea li:first-of-type{margin-left:0;}
	.tabArea li a {cursor:pointer; display:block;}
	.tabArea li a p {font-size:12px; margin:0;}
	.tabArea li.on {background: #fff; color: #74bd3b;}
	
	.conTop {border: 1px solid #efefef;}
	.conTop ul {width:100%;}
	.conTop li {float:left; box-sizing: border-box; height: 35px;}
	.liMargin{margin-right:1px;}
	.conTop > li:nth-of-type(1) {width: 40px;border: 1px solid #e2e2e2;background: #fbfbfb;}
	.conTop > li:nth-of-type(2) {width: calc(100% - 80px);overflow: hidden;position: relative;}
	.conTop > li:nth-of-type(3) {width: 40px;border: 1px solid #e2e2e2;background: #fbfbfb;}
	.conTop .btn {background:#fbfbfb; font-weight:bold ; cursor:pointer; width:100%; border:none;display:inline-block; height: 100%; position: relative;}
	.conTop > li:nth-of-type(1):hover button,
	.conTop > li:nth-of-type(3):hover button{background: #fff;}	
	.conTop > li:nth-of-type(1):hover button span,
	.conTop > li:nth-of-type(3):hover button span{background: #74bd3b;}	
	
	/* 버튼 에로우 */
	.larrow1, .larrow2,
	.rarrow1, .rarrow2 {display: inline-block;width: 3px;height: 15px;background: #000;position: absolute;}
	.larrow1 {transform: rotate(45deg);-webkit-transform: rotate(45deg);left: 45%;top: 19%;}
	.larrow2 {transform: rotate(-45deg);-webkit-transform: rotate(-45deg);left: 45%;top: 43%;}
	.rarrow1 {transform: rotate(-45deg);-webkit-transform: rotate(-45deg);left: 50%;top: 19%;}
	.rarrow2 {transform: rotate(45deg);-webkit-transform: rotate(45deg);left: 50%;top: 43%;}
	
	.textBox {height: 300px;background:#fff;border-bottom: 1px solid #a9a9a9;overflow: hidden;}
	
	/* footer */
	.footer {width: 100%; position:fixed; left:3%; bottom:5px; z-index:21;}
	.footer a {cursor:pointer;}
	.footer .fCont{width: 100%; height: 100%; line-height:23px;}
	.footer .fCont .fTextArea{float: left;width: 45px;}
	.footer .fCont .fCheckArea{float: left;width: 32px;}
	.footer .fCont .fCheckArea input[type=checkbox]{margin: 0;height: 23px;width: 19px;}
	.footer .fCont .fClickArea a:hover{color: #3f48cc;}
</style>
<script type="text/javascript">
	var data;
	var startBtn = 0;
	var endBtn = 0;
	var current = "";
	
	var maxClickBtn = 0; 
	var lastTabWidth = 0;
	var tabClickCount = 0;
	var maxTabAreaWidth = 0;
	
	$(window).resize(function(){
		setContentHeight();
		drawTabArea();
		setShowTabButton();
	});
	
	$(document).ready(function(){
		getPopupData();
		
		$(".tabArea li").on("click", function() {
			$(".tabArea li").removeClass();
			
			if( $(this).hasClass('on') ){
				$(this).removeClass('on');
			}else{
				$(this).addClass('on');
			}
		});
		
		setContentHeight();
		drawTabArea();
		setShowTabButton();
		
		current = data[0]["NTISEQ"];
		$("#title").text(data[0]["TITNTI"]);
		
		setNote(current);
	});
	
	function loadingOpen(){}
	function loadingClose(){}
	function logoEffectStart(){}
	function logoEffectStop(){}
	
	function reloadNotice(){
		getPopupData();
		
		setContentHeight();
		drawTabArea();
		setShowTabButton();
		
		current = data[0]["NTISEQ"];
		$("#title").text(data[0]["TITNTI"]);
		
		setNote(current);
	}
	
	function setNote(seq){
		var frm = $("<form>").attr({"id":"frm","name":"frm","action":"/wms/notice/mainPop/mainPopNote.page","method":"POST"});
		frm.append($("<input>").attr({"type":"hidden","name":"seq"}).val(seq));
		$("#noteArea").append(frm);
		
		var $form = document.frm;
		$form.target = "note";
		
		if(Browser.ie || Browser.ie11){
			var frmObj = document.getElementById("frm");
			frmObj.submit();
			frmObj.parentNode.removeChild(frmObj);
		}else{
			$form.submit();
			$form.remove();	
		}
	}
	
	function setContentHeight(){
		var bodyHeight = $(window).height();
		var headerHeight = $(".header").height() + 20;
		var tabHeight = $(".tabArea").height() + 20;
		var footerHeight = $(".footer").height();
		var titleHeight =  $(".noteTitle").height();
		var contentHeight = (bodyHeight - (headerHeight + tabHeight + footerHeight) - (titleHeight + 5)) + "px";
		
		$(".textBox").css("height",contentHeight);
	}
	
	function tapMaxWidth(){
		var result = 0;
		$(".tabArea ul li").each(function(){
			var width = $(this).width();
			if(result < width){
				result = width;
			}
		});
		
		return result;
	}
	
	function setShowTabButton(){
		var tabLeft = 0;
		
		var isTab = $(".tabArea").css("left")?true:false;
		if(isTab){
			tabLeft = commonUtil.parseInt(commonUtil.replaceAll($(".tabArea").css("left"),"px",""));	
		}
		
		if(maxClickBtn == 0){
			$("#leftBtn").hide();
			$("#rightBtn").hide();
		}
		if(tabClickCount == 0){
			$("#leftBtn").hide();
			if(maxClickBtn > 0){
				$("#rightBtn").show();
			}else{
				$("#rightBtn").hide();
			}
		}else if(tabClickCount > 0){
			if(maxClickBtn <= tabClickCount){
				$("#leftBtn").show();
				$("#rightBtn").hide();
			}else if(maxClickBtn > tabClickCount){
				$("#leftBtn").show();
				$("#rightBtn").show();
			}
		}
	}
	
	function getPopupData(){
		var json = netUtil.sendData({
			module : "Wms",
			command : "MAINPOPUP",
			sendType : "list",
			param : new DataMap()
		});
		
		if(json && json.data){
			var dataLen = json.data.length;
			if(dataLen > 0){
				$(".conTop li").eq(1).attr("style","width: calc(100% - 80px);");
				
				data = json.data;
 				setTabArea(data);
			}else{
				window.close();	
			}
		}else{
			window.close();
		}
	}
	
 	function setTabArea(data){
 		var dataLen = data.length;
 		var $tabArea = $(".tabArea");
 		var $ul = $("<ul>");
 		var $li = $("<li>");
 		var $a = $("<a>");
 		var $p = $("<p>");
 		for(var i = 0; i < dataLen; i++){
 			var dataRow = data[i];
 			var $appendLi;
 			if(i == 0){
 				$appendLi = $li.clone().addClass("on");
 			}else{
 				$appendLi = $li.clone();
 			}
			
 			var $appendA = $a.clone();
 			var $appnedP = $p.clone().text("공지사항" + (i+1));
 			$appendLi.append($appendA.append($appnedP));
 			$appendLi.attr("onclick","moveTab('" + (dataRow["NTISEQ"]) + "'," + i + ")")
 			$ul.append($appendLi);
 		}
 		
 		$tabArea.html($ul);
 		
 		maxTabAreaWidth = dataLen*100;
 		$(".tabArea").css("width",maxTabAreaWidth);
 	}
 	
 	function drawTabArea(){
 		var tabWidth       = 100;
		var tabAreaWidth   = maxTabAreaWidth;
		var innerAreaWidth = $(".conTop").width() - 80; 
		var otherAreaWidth = tabAreaWidth - innerAreaWidth;
		
		maxClickBtn = Math.floor(otherAreaWidth/tabWidth);
		var overBtn = Math.ceil(otherAreaWidth/tabWidth);
		
		lastTabWidth = overBtn > maxClickBtn?otherAreaWidth-(maxClickBtn*100):100;
 	}
	
	function moveTab(seq,tabNum){
		current = seq;
		
		$(".tabArea ul li").removeClass("on");
		$(".tabArea ul li:eq("+tabNum+")").addClass("on");
		
		$("#title").text(data[tabNum]["TITNTI"]);

		setNote(current);
	}
	
	function moveRightTap(){
		tabClickCount++;
		if(tabClickCount < maxClickBtn){
			$(".tabArea").animate({left:-100*tabClickCount});
		}else if(tabClickCount == maxClickBtn){
			$(".tabArea").animate({left:((100*tabClickCount)+lastTabWidth)*-1});
		}else if(tabClickCount > maxClickBtn){
			tabClickCount = maxClickBtn;
			$(".tabArea").animate({left:((100*tabClickCount)+lastTabWidth)*-1});
		}
		
		setShowTabButton();
	}
	
	function moveLeftTap(){
		tabClickCount--;
		if(tabClickCount < maxClickBtn){
			if(tabClickCount <= 0){
				tabClickCount = 0;
				$(".tabArea").animate({left:0});
			}else{
				$(".tabArea").animate({left:-100*tabClickCount});	
			}
		}
		
		setShowTabButton();
	}
	
	function todayNotViewNotice(){
		var param = new DataMap();
		
		var isChk = $("#chk").is(":checked");
		if(isChk){
			param.put("list",data);
		}else{
			var arr = new Array();
			var mapData = new DataMap();
			mapData.put("NTISEQ",current);
			arr.push(mapData);
			
			param.put("list",arr);		
		}
		
		netUtil.send({
			url: "/wms/common/json/saveTodayNotNotice.data",
			param : param,
			successFunction : "saveCallBack"
		});
	}
	
	function saveCallBack(json,status){
		if(json && json.data){
			if(json.data > 0){
				reloadNotice();
			}
		}
	}
</script>
<title>공지사항</title>
</head>
<body>
	<div class="container">
		<main class="content">
			<ul class="conTop">
				<li>
					<button id="leftBtn" class="btn" onclick="moveLeftTap();">
						<span class="larrow1"></span>
						<span class="larrow2"></span>
					</button>
				</li>
				<li>
					<div class="tabArea">
						<ul></ul>
					</div>
				</li>
				<li>
					<button id="rightBtn" class="btn" onclick="moveRightTap();">
						<span class="rarrow1"></span>
						<span class="rarrow2"></span>
					</button>
				</li>
			</ul>
			<div class="noteTitle">
				<p id="title"></p>
			</div>
			<div class="textBox" id="noteArea">
				<iframe id="note" name="note" width="99.8%" height="100%" scrolling="auto" style="border: none;"></iframe>
			</div>
		</main>
		<footer class="footer">
			<div class="fCont">
				<div class="fTextArea">전체</div>
				<div class="fCheckArea"><input type="checkbox" id="chk"/></div>
				<div class="fClickArea"><a onclick="todayNotViewNotice();">오늘 하루 그만보기</a></div>
			</div>
		</footer>
	</div>
<!-- <h1>메인 팝업</h1> -->
</body>
</html>