<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.common.bean.CommonConfig,com.common.bean.DataMap,java.util.*"%>
<%@ page import="com.common.util.XSSRequestWrapper"%>
<%
	XSSRequestWrapper sFilter = new XSSRequestWrapper(request);
	
	List list = (List)request.getAttribute("list");
	String wareky   = sFilter.getXSSFilter(request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY).toString());
	String langky = sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY));
	String theme =  sFilter.getXSSFilter((String)request.getSession().getAttribute(CommonConfig.SES_USER_THEME_KEY));
	String userid = sFilter.getXSSFilter(request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY).toString());
	
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="/common/theme/gsfresh/css/dash.css">
<link rel="stylesheet" type="text/css" href="/common/chart/jquery.jqplot.min.css">
<script type="text/javascript" src="/common/js/jquery.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.js"></script>
<script type="text/javascript" src="/common/js/jquery-ui.custom.js"></script>
<script type="text/javascript" src="/common/js/jquery.plugin.js"></script>

<script type="text/javascript" src="/common/chart/js/jquery.jqplot.min.js"></script>
<script type="text/javascript" src="/common/chart/js/jqplot.meterGaugeRenderer.js"></script>

<script type="text/javascript" src="/common/js/json2.js"></script>
<script type="text/javascript" src="/common/js/big.js"></script>
<script type="text/javascript" src="/common/js/dataMap.js"></script>
<script type="text/javascript" src="/common/js/configData.js"></script>
<script type="text/javascript" src="/common/js/label.js"></script>
<script type="text/javascript" src="/common/lang/label-<%=langky%>.js?v=<%=System.currentTimeMillis()%>"></script>
<script type="text/javascript" src="/common/lang/message-<%=langky%>.js"></script>
<script type="text/javascript" src="/common/js/site.js"></script>
<script type="text/javascript" src="/common/js/commonUtil.js"></script>
<script type="text/javascript" src="/common/js/dataBind.js"></script>
<script type="text/javascript" src="/common/js/netUtil.js"></script>
<script type="text/javascript" src="/common/js/worker-ajax.js"></script>
<script type="text/javascript" src="/common/js/bigdata.js"></script>
<script type="text/javascript" src="/common/js/dataRequest.js"></script>
<script type="text/javascript" src="/common/js/page.js"></script>
<title>Insert title here</title>
</head>
<style>
	@font-face {
		src: url("/common/css/font/DigitalNormal.otf") format("opentype");
		font-family: "Digital";
	}
	@font-face {
		src: url("/common/css/font/GodoM.woff") format("woff");
		font-family: "Godo";
	} 
	html{background: linear-gradient( to right, #f6f6f6, #f8f8f8 );}
	ul, li, span, h1, h2, h3, h4, h5, h6, p {margin: 0; padding: 0;}
	.wrap{overflow: hidden;}
	.wrap div{box-sizing: border-box;}
	.plot {margin-left: auto;margin-right: auto;}
	.wrap .main .widget{padding: 35px; overflow: hidden;}
	.wrap .main .widget .content .plotLeft{position: absolute;z-index: 1;}
	.wrap .main .widget .content .plotRight{position: absolute;z-index: 1;}
	.plotTitle{width: 100%;height: 40%;padding-top: 25%;}
	.plotTitle p{font-size: 2vmin; font-weight: bold;}
	.plotTitle .tal{text-align: left;color: #bebebe;}
	.plotTitle .tar{text-align: right;color: #00adff}
	.plotContent{width: 100%;height: 60%;}
	.plotContent .plotRightBox{width: 100%;height: 100%;display: inline-block;border-right: 0;background: linear-gradient(to right, #bebebe 0%, transparent 100%);}
	/* .plotRightBox:before {content: "";position: absolute;left: 0;bottom: 0;width: 50%;height: 57.9%;border: 3px solid #ffa500;border-right: 0;} */
	.plotContent .plotRightBox p{margin: 0;}
	.plotContent .plotRightBox .boxData{padding-left: 28%;font-size: 4.5vmin;font-weight: bold;padding-top: 15%;}
	.plotContent .plotRightBox .boxUom{color: #c70202;font-size: 1.7vmin;padding-top: 3%;padding-left: 26%;}
	.plotContent .rightArrow1{position:absolute;width: 44%;height: 44%;border: solid #ffa500;border-width: 0 3px 3px 0;display: inline-block;transform: rotate(-43deg);-webkit-transform: rotate(-43deg);top: 48%;left: 29%;}
	.plotContent .rightArrow2{position:absolute;width: 43%;height: 43%;border: solid #fbc96d;border-width: 0 20px 20px 0;display: inline-block;transform: rotate(-43deg);-webkit-transform: rotate(-43deg);top: 49%;left: 43%;}
	.plotContent .rightArrow3{position:absolute;width: 43%;height: 43%;border: solid #ffe0a7;border-width: 0 10px 10px 0;display: inline-block;transform: rotate(-43deg);-webkit-transform: rotate(-43deg);top: 49%;left: 50%;}
	.plotContent .plotLeftBox{width: 100%;height: 100%;display: inline-block;border-right: 0;background: linear-gradient(to left, #00adff 0%, transparent 100%);}
	/* .plotLeftBox:before {content: "";position: absolute;right: 0;bottom: 0;width: 50%;height: 57.9%;border: 3px solid #00adff;border-left: 0;} */
	.plotContent .plotLeftBox p{margin: 0;}
	.plotContent .plotLeftBox .boxData{padding-left: 28%;font-size: 4.5vmin;font-weight: bold;padding-top: 15%;}
	.plotContent .plotLeftBox .boxUom{color: #c70202;font-size: 1.7vmin;padding-top: 3%;padding-left: 57%;}
	.plotContent .leftArrow1{position:absolute;width: 44%;height: 44%;border: solid #00adff;border-width: 0 3px 3px 0;display: inline-block;transform: rotate(137deg);-webkit-transform: rotate(137deg);top: 48%;left: 27%;}
	.plotContent .leftArrow2{position:absolute;width: 43%;height: 43%;border: solid #50c7ff;border-width: 0 20px 20px 0;display: inline-block;transform: rotate(137deg);-webkit-transform: rotate(137deg);top: 48%;left: 14%;}
	.plotContent .leftArrow3{position:absolute;width: 43%;height: 43%;border: solid #bceaff;border-width: 0 10px 10px 0;display: inline-block;transform: rotate(137deg);-webkit-transform: rotate(137deg);top: 48%;left: 7%;}
	.wrap .main .widget .content .plotBottom{width: 100%;text-align: center;font-weight: bold;position: absolute; bottom: 20px;}
	.wrap .main .widget .content .plotBottom .plotBottomBox{height: 100%; border-radius: 5px;display: inline-block;}
	.wrap .main .widget .content .plotBottom .plotBottomBox .countBox{font-size: 3.1vmin; font-family: "Digital" !important;}
	.wrap .main .widget .content .plotBottom .plotBottomBox .countUom{font-size: 2.3vmin; font-family: "Godo" !important; vertical-align: bottom;}
	.Gbg {background: #83b138; color:#fff;}
	.Wbg {background: #fff;}
	
	@media screen and (max-width: 1920px) {
		.wrap .main .widget{padding: 30px;}
		.present .work tr td, 
		.KPI .work tr td {height: 35px;}
		.notice p {height:40px; line-height:40px;}
		
		/* .plotRightBox:before {width: 50%;height: 59%;border: 2px solid #ffa500;border-right: 0;} */
		.plotContent .rightArrow1{border-width: 0px 2px 2px 0;}
		.plotContent .rightArrow2{border-width: 0 15px 15px 0;top: 49%;left: 43%;}
		.plotContent .rightArrow3{border-width: 0 8px 8px 0;top: 49%;left: 51%;}
		
		/* .plotLeftBox:before{width: 50%;height: 59%;left: 50.8%;border: 2px solid #00adff;border-left: 0;}  */
		.plotContent .leftArrow1{left: 28.9%;width: 44%;height: 44%;top: 47%;border-width: 0 2px 2px 0px;}
		.plotContent .leftArrow2{border-width: 0 15px 15px 0;top: 48%;left: 16%;}
		.plotContent .leftArrow3{border-width: 0 8px 8px 0;top: 48%;left: 7%;}
		
		.plotContent .plotRightBox .boxData{padding-top: 17%;font-size: 3.8vmin;}
		.plotContent .plotRightBox .boxUom{padding-left: 34%;}
		.plotContent .plotLeftBox .boxData{padding-top: 17%;font-size: 3.8vmin;}
/* 		.plotContent .plotLeftBox .boxUom{padding-left: 57%;} */
		
	}/* media end */
	
</style>
<script>
	var option1;
	var option2;
	var plot3;
	var plot4;
	var s1 = [0];
	var s2 = [0];
	var tabNum = "";
	var sysToday = "";
	var sysYesterday = "";
	var roop = true;
	
	//화면 리사이즈
	$(window).resize(function(){
		setWidgetPosition();
		plot3.destroy();
		plot3 = $.jqplot('chart',[s1],option1);
		plot3.redraw();
		
		plot4.destroy();
		plot4 = $.jqplot('chart2',[s2],option2);
		plot4.redraw();
	});
	
	//레디
	$(document).ready(function(){
		setWidgetPosition();
		
		//하단 버튼 링크 조회
		//footerButtonLink();
		
		//피킹, 차량 생산성 게이지
		option1 = {
		    seriesDefaults: {
		        renderer: $.jqplot.MeterGaugeRenderer,
		        rendererOptions: {
		            min: 0,
		            max: 3000,
		            ringColor: '#26323a',
		            tickColor: '#395467',
		            ringWidth: 7
		        }
		    }
		}
		
		option2 = {
			    seriesDefaults: {
			        renderer: $.jqplot.MeterGaugeRenderer,
			        rendererOptions: {
			            min: 0,
			            max: 50,
			            ringColor: '#26323a',
			            tickColor: '#395467',
			            ringWidth: 7
			        }
			    }
			}
			
		
		plot3 = $.jqplot('chart', [s1], option1);
		plot4 = $.jqplot('chart2', [s2], option2);
		
		/* setInterval(function () {
		    s1 = [Math.floor(Math.random() * (401) + 100)];
		    plot3.series[0].data[0] = [1,s1]; //here is the fix to your code
		    plot3.replot();
		}, 1000); */
		
		
		//센터 작업 진행현황 li 클릭 이벤트
		$(".worktab ul.worktabul li").click(function(){
			var tabIndex = $(this).index() + 1;
			tabNum = tabIndex;
			comboSetting(tabIndex);
			
			//초기화
			$(".present .gridTab").hide();
			$(".warpTable"+ tabIndex +" tbody td").remove();
			$(".warpTable1 p").remove();
			
			$(".worktab ul.worktabul li").removeClass('active');
			$(this).addClass('active');
			
			$(".present .warpTable" + tabIndex).show();
			//presentCall(tabIndex);
		});
		
		//센터작업진행현황 차수 select 이벤트
		$(".tab3Combo .weeknumber").hide();
		$(".tab3Combo p").click(function(){
			$(".tab3Combo .weeknumber").slideToggle(200);
		});
		
		//센터작업진행현황 도크 select 이벤트
		$(".tab4ComboDoc .weeknumber").hide();
		$(".tab4ComboDoc p").click(function(){
			$(".tab4ComboDoc .weeknumber").slideToggle(200);
		});
		
		//센터작업진행현황 출하유형 select 이벤트
		$(".shpmtyCombo .weeknumber").hide();
		$(".shpmtyCombo p").click(function(){
			$(".shpmtyCombo .weeknumber").slideToggle(200);
		});
		
		today(); //센터별작업진행현황 오늘날짜
		comboSetting(); //센터별작업진행현황 콤보셋팅
		
		//센터별 작업 진행 형황
		$(".present .warpTable2").hide();
		$(".present .warpTable3").hide();
		$(".present .warpTable4").hide();
		//presentCall("1");
		
		//센터 KPI
		//kpiCall();
		
		//공지사항
		//noticeCall();
		$(".notice p a").on("click",function(e){
			var param = new DataMap();
			param.put("WAREKY", "<%=wareky%>");
			param.put("SES_USER_ID", $(this).find(".noticeUser").text());
			param.put("NTISEQ", $(this).attr("name"));
			
			page.linkPageOpen('NT10', param);
		});
		
		//2분마다 공지사항 리로드
		//setInterval(function(){
//			if(roop){
				//noticeCall();
			//};
		//}, 120000);
		
		
		//피킹생산성
		//pickChart();
		
		//차량생산성
		//carChart();
	});
	
	function roopChk(){
		roop = false;
	}
	
	//오늘날짜 찾기
	function today(){
		//오늘날짜
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();
		if( dd < 10 ) {dd = '0' + dd;} 
		if( mm < 10 ) {mm = '0' + mm;}
		sysToday = String(yyyy) + String(mm) + String(dd);
		
		
		//어제날짜
		var yesterday = new Date();
		yesterday.setTime(new Date().getTime() - (1 * 24 * 60 * 60 * 1000));
		var Ydd = yesterday.getDate();
		var Ymm = yesterday.getMonth() + 1;
		var Yyyyy = yesterday.getFullYear();
		if( Ydd < 10 ) {Ydd = '0' + Ydd;} 
		if( Ymm < 10 ) {Ymm = '0' + Ymm;}
		sysYesterday = String(Yyyyy) + String(Ymm) + String(Ydd);
		
		$(".present .title span").text("(" + String(mm) + "/" + String(dd) + ")");
	}
	
	//차수, 도크 콤보 셋팅
	function comboSetting(index){
		$('.tab3Combo .weeknumber li').remove();
		$('.tab4ComboDoc .weeknumber li').remove();
		$('.shpmtyCombo .weeknumber li').remove();
		$('.tab4ComboDoc p').text("전체");
		$('.tab4ComboDoc p').attr("id", "");
		
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		
		if( index == "2" ){
			
			//탭2 출하유형 콤보
			var jsonComboShp = netUtil.sendData({
				module : "main",
				command : "SHPMTY_COMBO", 
				sendType : "list",
				param : param
			});
			
			if(jsonComboShp && jsonComboShp.data){
				var data = jsonComboShp.data;
				
				for(var i=0; i<data.length; i++){
					var $liTitle = $("<li class='weeknumber-item comboTitle' id='COMBOTT'>전체</li>");
					var $li = $("<li class='weeknumber-item' id=" + data[i].CMCDVL + ">" + data[i].CDESC1 + "</li>");
					
					if( i == 0 ){
						$('.shpmtyCombo .weeknumber').append($liTitle).append($li);
					}else {
						$('.shpmtyCombo .weeknumber').append($li);
					}
				}
			}
			
			
		}
		
		
		if( index == "3" ){
			//탭3, 4 차수 콤보
			var jsonCombo = netUtil.sendData({
				module : "main",
				command : "TAB3_COMBO",
				sendType : "list",
				param : param
			});
			
			if(jsonCombo && jsonCombo.data){
				var data = jsonCombo.data;
				
				for(var i=0; i<data.length; i++){
					var $liTitle = $("<li class='weeknumber-item comboTitle' id=''>차수</li>");
					var $li = $("<li class='weeknumber-item' id=" + data[i].SHPDGR + ">" + data[i].SHPDGR_NM + "</li>");
//	 				$('.tab3Combo .weeknumber').append($li);
					
					if( i == 0 ){
						$('.tab3Combo .weeknumber').append($liTitle).append($li);
					}else {
						$('.tab3Combo .weeknumber').append($li);
					}
					
					if( data[i].DEF_SELECT == "Y" ){
						$(".tab3Combo p").text(data[i].SHPDGR_NM);
						$(".tab3Combo p").attr("id", data[i].SHPDGR);
					}
				}
			}
			
			
		}
		
		if( index == "4" ){
			//탭3, 4 차수 콤보
			var jsonCombo = netUtil.sendData({
				module : "main",
				command : "TAB3_COMBO",
				sendType : "list",
				param : param
			});
			
			var teb4Shpdgr = "";
			if(jsonCombo && jsonCombo.data){
				var data = jsonCombo.data;
				
				for(var i=0; i<data.length; i++){
					var $liTitle = $("<li class='weeknumber-item comboTitle' id=''>차수</li>");
					var $li = $("<li class='weeknumber-item' id=" + data[i].SHPDGR + ">" + data[i].SHPDGR_NM + "</li>");
//	 				$('.tab3Combo .weeknumber').append($li);
					
					if( i == 0 ){
						$('.tab3Combo .weeknumber').append($liTitle).append($li);
					}else {
						$('.tab3Combo .weeknumber').append($li);
					}
					
					if( data[i].DEF_SELECT == "Y" ){
						$(".tab3Combo p").text(data[i].SHPDGR_NM);
						$(".tab3Combo p").attr("id", data[i].SHPDGR);
						teb4Shpdgr = data[i].SHPDGR;
					}
				}
			}
			
			param.put("SHPDGR", teb4Shpdgr);
			tab4docCombo(param);
		}
		
		setComboEvent();
	}
	
	function tab4docCombo(param){
		$('.tab4ComboDoc .weeknumber li').remove();
		$(".tab4ComboDoc p").text("전체");
		$(".tab4ComboDoc p").attr("id", "");
		
		if( param.get("SHPDGR") == undefined ){
			return false;
		}
		
		//탭4 도크 콤보
		var jsonComboDoc = netUtil.sendData({
			module : "main",
			command : "TAB4_DOCCOMBO",
			sendType : "list",
			param : param
		});
		
		if(jsonComboDoc && jsonComboDoc.data){
			var data = jsonComboDoc.data;
			
			for(var i=0; i<data.length; i++){
				var $liTitle = $("<li class='weeknumber-item comboTitle' id=''>전체</li>");
				var $li = $("<li class='weeknumber-item' id=" + data[i].DOCKNO + ">" + data[i].DOCKNM + "</li>");
// 				$('.tab4ComboDoc .weeknumber').append($li);
				
				if( i == 0 ){
					$('.tab4ComboDoc .weeknumber').append($liTitle).append($li);
				}else {
					$('.tab4ComboDoc .weeknumber').append($li);
				}
				
				if( data[0] ){
					$(".tab4ComboDoc p").text(data[i].DOCKNM);
					$(".tab4ComboDoc p").attr("id", data[i].DOCKNO);
				}
			}
		}
		
		setComboEvent();
	}
	
	// 차수, 도크 클릭이벤트
	function setComboEvent(){
		$(".tab3Combo .weeknumber li").unbind("click").on("click",function(e){
			$(this).parent().slideUp();
			$(".tab3Combo p").text($(this).text());
			$(".tab3Combo p").attr("id", $(this).attr("id"));
			
			if( tabNum == 4 ){
				var param = new DataMap();
				param.put("WAREKY", "<%=wareky%>");
				param.put("SHPDGR", $(this).attr("id"));
				tab4docCombo(param)
			}
			
			//presentCall(tabNum);
		});
		
		$(".tab4ComboDoc .weeknumber li").unbind("click").on("click",function(e){
			$(this).parent().slideUp();
			$(".tab4ComboDoc p").text($(this).text());
			$(".tab4ComboDoc p").attr("id", $(this).attr("id"));
			
			//presentCall(4);
		});
		
		$(".shpmtyCombo .weeknumber li").unbind("click").on("click",function(e){
			$(this).parent().slideUp();
			$(".shpmtyCombo p").text($(this).text());
			$(".shpmtyCombo p").attr("id", $(this).attr("id"));
			
			//presentCall(2);
		});
	}
	
	//센터별 작업 진행 현황
	function presentCall(tabIndex){
		$(".warpTable"+ tabIndex +" tbody td").remove();
		$(".weeknumber").css({"display":"none"}) //차수,도크 li
		
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( tabIndex == "1" ){
			$(".weeknumberinner").hide(); //차수 select
			
			//탭1
			var json = netUtil.sendData({
				module : "main",
				command : "PRESENT_TAB1",
				sendType : "list",
				param : param
			});
			
			if(json && json.data){
				$('.warpTable1 tbody').empty();
				
				var data = json.data;
				for(var i=0; i<data.length; i++){
					var $tr = $("<tr>");
					var $p = $("<p class='floor'>" + data[i].AREANM + "</p>");
					var $td1 = $("<td>" + data[i].AREANM + "</td>");
					var $td2 = $("<td>" + numberComma(data[i].ASN_CNT) + "</td>");
					var $td3 = $("<td>" + numberComma(data[i].CMP_CNT) + "</td>");
					var $td4 = $("<td>" + data[i].PROG + "</td>");
					
					if( data[i].BIZ != "FLOOR" ){
						$tr.append($td1).append($td2).append($td3).append($td4);
						$('.warpTable1 tbody').append($tr);
					}else{
						$('.warpTable1').append($p);
					}
				}
			}
			
		}else if( tabIndex == "2" ){
			$(".weeknumberinner").hide(); //차수 select
			$(".weeknumberinner.shpmtyCombo").show(); //출하유형 select
			
			//탭2
			param.put("SHPMTY", $(".shpmtyCombo p").attr("id"));
			var json = netUtil.sendData({
				module : "main",
				command : "PRESENT_TAB2",
				sendType : "list",
				param : param
			});
			
			if(json && json.data){
				$('.warpTable2 tbody').empty();
				
				var data = json.data;
				for(var i=0; i<data.length; i++){
					var $tr = $("<tr>");
					var $td1 = $("<td>" + data[i].SHPDGR + "</td>");
					var $td2 = $("<td>" + numberComma(data[i].ENDCNT) + "</td>");
					var $td3 = $("<td>" + numberComma(data[i].ORDCNT) + "</td>");
					var $td4 = $("<td style='text-align: center;'>" + data[i].ENDMAK + "</td>");
					var $td5 = $("<td>" + data[i].END_RATE + "</td>");
					
					$tr.append($td1).append($td2).append($td3).append($td4).append($td5);
					$('.warpTable2 tbody').append($tr);
				}
			}
			
		}else if( tabIndex == "3" ){
			$(".weeknumberinner.tab3Combo").show(); //차수 select
			$(".weeknumberinner.tab4ComboDoc").hide(); //도크 select
			$(".weeknumberinner.shpmtyCombo").hide(); //출하유형 select
// 			comboSetting();
			
			if($(".tab3Combo p").attr("id") == undefined || $(".tab3Combo p").attr("id") == "" ){
				var json = netUtil.sendData({
					module : "main",
					command : "PRESENT_TAB3_EMPTY",
					sendType : "list",
					param : param
				});
				
				if(json && json.data){
					$('.warpTable3 tbody').empty();
					
					var data = json.data;
					for(var i=0; i<data.length; i++){
						var $tr = $("<tr>");
						var $td1 = $("<td>" + data[i].AREANM + "</td>");
						var $td2 = $("<td>" + numberComma(data[i].ORDCNT) + "</td>");
						var $td3 = $("<td>" + numberComma(data[i].CMPCNT) + "</td>");
						var $td4 = $("<td>" + data[i].PROG_RATE + "</td>");
						var $td5 = $("<td>" + data[i].TASK_HH + "</td>");
						
						if( parseInt(data[i].NOTCNT.substring(0,1)) > 0 ){
							var $td6 = $("<td class='red'>" + data[i].NOTCNT + "</td>");
						}else{
							var $td6 = $("<td>" + data[i].NOTCNT + "</td>");
						}
						
						$tr.append($td1).append($td2).append($td3).append($td4).append($td5).append($td6);
						$('.warpTable3 tbody').append($tr);
					}
				}
			}else{
				//탭3
				param.put("SHPDGR", $(".tab3Combo p").attr("id"));
				var json = netUtil.sendData({
					module : "main",
					command : "PRESENT_TAB3",
					sendType : "list",
					param : param
				});
				
				if(json && json.data){
					$('.warpTable3 tbody').empty();
					
					var data = json.data;
					for(var i=0; i<data.length; i++){
						var $tr = $("<tr>");
						var $td1 = $("<td>" + data[i].AREANM + "</td>");
						var $td2 = $("<td>" + numberComma(data[i].ORDCNT) + "</td>");
						var $td3 = $("<td>" + numberComma(data[i].CMPCNT) + "</td>");
						var $td4 = $("<td>" + data[i].PROG_RATE + "</td>");
						var $td5 = $("<td>" + data[i].TASK_HH + "</td>");
						
						if( parseInt(data[i].NOTCNT.substring(0,1)) > 0 ){
							var $td6 = $("<td class='red'>" + data[i].NOTCNT + "</td>");
						}else{
							var $td6 = $("<td>" + data[i].NOTCNT + "</td>");
						}
						
						$tr.append($td1).append($td2).append($td3).append($td4).append($td5).append($td6);
						$('.warpTable3 tbody').append($tr);
					}
				}
				
				comboClick = "no";
			}
			
			
		
		}else if( tabIndex == "4" ){
			$(".weeknumberinner").show(); //차수 select
			$(".weeknumberinner.shpmtyCombo").hide(); //출하유형 select
// 			comboSetting();
			
			param.put("SHPDGR", $(".tab3Combo p").attr("id"));
			param.put("DOCKNO", $(".tab4ComboDoc p").attr("id"));
			
// 			if( $(".tab4ComboDoc p").attr("id") == undefined || $(".tab4ComboDoc p").attr("id") == "" ){
// 				return false;
// 			}
			
			var json = netUtil.sendData({
				module : "main",
				command : "PRESENT_TAB4",
				sendType : "list",
				param : param
			});
			
			if(json && json.data){
				$('.warpTable4 tbody').empty();
				
				var data = json.data;
				for(var i=0; i<data.length; i++){
					var $tr = $("<tr>");
					var $td3 = $("<td>" + data[i].VEHINO + "</td>");
					var $td4 = $("<td>" + data[i].DRIVER + "</td>");
					
					var $td5 = $("<td>" + data[i].DPS + "</td>");
					var $td6 = $("<td>" + data[i].DRY + "</td>");
					var $td7 = $("<td>" + data[i].WET + "</td>");
					
					if( data[i].CARCNT == "TOTAL" ){
						var $td1 = $("<td colspan='2'>합계</td>");
						$tr.append($td1).append($td3).append($td4).append($td5).append($td6).append($td7);
						
					}else{
						var $td1 = $("<td>" + data[i].CARCNT + "</td>");
						var $td2 = $("<td>" + data[i].DOCKNO + "</td>");
						$tr.append($td1).append($td2).append($td3).append($td4).append($td5).append($td6).append($td7);
					}
					
					$('.warpTable4 tbody').append($tr);
				}
			}
			
			
		}
		
	}
	
	
	
	//센터 KPI
	function kpiCall(){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		var json = netUtil.sendData({
			module : "main",
			command : "KPI",
			sendType : "list",
			param : param
		});
		
		if(json && json.data){
			var data = json.data;
			for(var i=0; i<data.length; i++){
				var month = numberComma(data[i].BEF_MONTH);
				var week = numberComma(data[i].BEF_WEEK);
				var day = numberComma(data[i].BEF_DAY);
				
				var $tr = $("<tr>");
				var $td1 = $("<td>" + data[i].BIZNM + "</td>");
				var $td2 = $("<td>" + month + "</td>");
				var $td3 = $("<td>" + week + "</td>");
				var $td4 = $("<td>" + day + "</td>");
				
// 				if (i==3){
// 					 $td2 = $("<td>" + month + " SKU</td>");
// 					 $td3 = $("<td>" + week + " SKU</td>");
// 					 $td4 = $("<td>" + day + " SKU</td>");
// 				}else if (i==4){
// 					 $td2 = $("<td>" + month + " EA</td>");
// 					 $td3 = $("<td>" + week + " EA</td>");
// 					 $td4 = $("<td>" + day + " EA</td>");
// 				}
				
				$tr.append($td1).append($td2).append($td3).append($td4);
				$('.KPI table tbody').append($tr);
			}
		}
	}
	
	
	//공지사항 리스트
	function noticeCall(){
		$(".notice p").remove(); //재조회 시 초기화
		
		var param = new DataMap();
		param.put("USERID", "<%=userid%>");
		param.put("WAREKY", "<%=wareky%>");
		
		var json = netUtil.sendData({
			module : "main",
			command : "INFONOTICE",
			sendType : "list",
			param : param
		});
		
		if(json && json.data){
			var data = json.data;
			
			for(var i=0; i<data.length; i++){
				var $p = $("<p>");
				var $a = $("<a name=" + data[i].NTISEQ + ">" + data[i].TITNTI + "</a>");
				var $spanDay = $("<span class='noticeday'>" + data[i].CREDAT + "</span>");
				var $spanUser = $("<span class='noticeUser' style='display: none;'>" + data[i].CREUSR + "</span>");
				var $siranTag =  $("<span class='siren'>중요</span>");
				
				$a.append($spanUser).append($spanDay);
				
				if( data[i].IMPFLG == "V" ){
					// 중요
					$a.prepend($siranTag).attr("class", "sirentitle");
					$p.append($a);
				}else{
					//일반
					$p.append($a);
				}
				
				$('.notice').append($p);
			}
		}
	}
	
	
	//피킹생산성
	function pickChart(){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		var json = netUtil.sendData({
			module : "main",
			command : "PICKCHART",
			sendType : "list",
			param : param
		});
		
		if( json && json.data ){
			var data = json.data;
			if(data.length > 0){
				for( var i=0; i<data.length; i++ ){
					
					if( data[i].RQSHPD == sysYesterday ){
						//전일생산성
						if( $.trim(data[i].PRODTY) != "" ){
							$(".pickYesterday .boxData > p").text(data[i].PRODTY);
						}else{
							$(".pickYesterday .boxData > p").text("0");
						}
						
					}else if( data[i].RQSHPD == sysToday ){
						//금일생산성
						if( $.trim(data[i].PRODTY) != "" ){
							$(".pickToday .boxData > p").text(data[i].PRODTY);
							$(".pickCount .countBox").text(data[i].PRODTY);
							s1 = [Number(data[i].PRODTY)];
							$.jqplot('chart', [s1], option1);
						}else{
							$(".pickToday .boxData > p").text("0");
							$(".pickCount .countBox").text("0");
							s1 = [0];
						}
					}
				}
			}else{
				$(".pickToday .boxData > p").text("0");
				$(".pickYesterday .boxData > p").text("0");
				$(".pickCount .countBox").text("0");
				s1 = [0];
			}
		}
	}
	
	//차량생산성
	function carChart(){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		var json = netUtil.sendData({
			module : "main",
			command : "CARCHART",
			sendType : "list",
			param : param
		});
		
		if( json && json.data ){
			var data = json.data;
			
			if(data.length > 0){
				for( var i=0; i<data.length; i++ ){
					
					if( data[i].RQSHPD == sysYesterday ){
						//전일생산성
						if( $.trim(data[i].PRODTY) != "" ){
							$(".carYesterday .boxData > p").text(data[i].PRODTY);
						}else{
							$(".carYesterday .boxData > p").text("0");
						}
						
					}else if( data[i].RQSHPD == sysToday ){
						//금일생산성
						if( $.trim(data[i].PRODTY) != "" ){
							$(".carToday .boxData > p").text(data[i].PRODTY);
							$(".carCount .countBox").text(data[i].PRODTY);
							s2 = [Number(data[i].PRODTY)];
							$.jqplot('chart2', [s2], option2);
						}else{
							$(".carToday .boxData > p").text("0");
							$(".carCount .countBox").text("0");
							s2 = [0];
						}
					}
				}
				
			}else{
				$(".carToday .boxData > p").text("0");
				$(".carYesterday .boxData > p").text("0");
				$(".carCount .countBox").text("0");
				s2 = [0];
			}
		}
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
	
	
	//화면 비율에 따른 박스 크기 조절
	function setWidgetPosition(){
		var screenWidth  = $(window).width();
		var bodyWidth    = (parent.top.frames["main"].innerWidth);
		var bodyHeight   = (parent.top.frames["main"].innerHeight);
		var footerHeight = $(".wrap .mainfooter").height();
		var mainHeight   = bodyHeight - (footerHeight + 10);
		var titleHeight  = $(".title").height();
		
		var top   = screenWidth <= 1920?8:16;
		var left  = screenWidth <= 1920?8:16;
		var right = screenWidth <= 1920?8:16; 
		var pad   = screenWidth <= 1920?10:15;
		
		var widget1Width  = ((bodyWidth*3.6)/6.4 - left);
		var widget1Height = ((mainHeight*3.8)/6.2 - (top*2));
		
		var widget2Width  = (bodyWidth - widget1Width) - (left*3);
		var widget2Height = (mainHeight/3) - (top*2);
		
		$(".wrap").css("height",bodyHeight+"px");
		$(".wrap .main").css("height",mainHeight+"px");
		$(".wrap .main").each(function(){
			var commonElementStyle = {
						position: "absolute",
						background: "#fff",
						"border-radius": "5px",
						"box-shadow": "2px 2px 2px 2px #e3e3e3"
					};
			var widget = $(this).find("div.widget");
			widget.css(commonElementStyle);
			
			widget.eq(0).css({
				width: widget1Width + "px",
				height: widget1Height + "px",
				top: top + "px",
				left: left + "px"
			});
			
			widget.eq(0).find(".content").css({width:"100%",height:(widget1Height-((pad*2)+ titleHeight)) + "px"});
			
			//6:4 비율
			widget.eq(1).css({
				width: widget1Width + "px",
				height: (mainHeight - widget1Height - (top*3)) + "px",
				top: ((top*2) + widget1Height) + "px",
				left: left + "px"
			});
			
			widget.eq(1).find(".content").css({width:"100%",height:((mainHeight - widget1Height - (top*3))-((pad*2)+ titleHeight)) + "px"});
			
			widget.eq(2).css({
				width: widget2Width + "px",
				height: widget2Height + "px",
				top: top + "px",
				left: widget1Width + (left*2) + "px"
			});
			
			widget.eq(2).find(".content").css({width:"100%",height:(widget2Height-((pad*2)+ titleHeight)) + "px"});
			
			widget.eq(3).css({
				width: widget2Width + "px",
				height: widget2Height + "px",
				top: ((top*3) + widget2Height) + "px",
				left: widget1Width + (left*2) + "px"
			});
			
			widget.eq(3).find(".content").css({width:"100%",height:(widget2Height-((pad*2)+ titleHeight)) + "px"});
			
			widget.eq(4).css({
				width: widget2Width + "px",
				height: widget2Height + "px",
				top: ((top*5) + (widget2Height*2)) + "px",
				left: widget1Width + (left*2) + "px"
			});
			
			widget.eq(4).find(".content").css({width:"100%",height:(widget2Height-((pad*2)+ titleHeight)) + "px"});
			
			var innerWidgetHeight = widget2Height - ((pad*2) + titleHeight);
			var chartWidth  = widget2Width - (pad*2) - 30;
			var chartHeight = (screenWidth <= 1920)?((widget2Height*4)/5.2):(innerWidgetHeight - ((innerWidgetHeight*0.9)/9.1));
	
			$("#chart").css({
				//width: chartWidth + "px", 
				//height: chartHeight -30 + "px"
				width: widget2Width,  
				height: chartHeight - 10,
				position: "absolute",
				top : (screenWidth <= 1920)?50:60,
				left: 0
			});
			
			$("#chart2").css({
				/* width: chartWidth + "px", 
				height: chartHeight -30 + "px" */
				width: widget2Width,  
				height: chartHeight - 10,
				position: "absolute",
				top : (screenWidth <= 1920)?50:60,
				left: 0
			});
			
			var chartOuterAreaWidth  = (chartWidth/3) - (pad*3) - 30;
			var chartBottomHeight    = (widget2Height-titleHeight) - chartHeight;
			var chartOuterAreaHeight = innerWidgetHeight - 35;
			
			$(".plotLeft").css({width:chartOuterAreaWidth +"px", height:chartOuterAreaHeight + "px"});
			$(".plotRight").css({width:chartOuterAreaWidth +"px", height:chartOuterAreaHeight + "px",left:((widget2Width - chartOuterAreaWidth) - 36) + "px"});
			$(".plotBottom").css({width:chartWidth + "px",height:(screenWidth <= 1920?chartBottomHeight:chartBottomHeight - 15) + "px"});
			$(".plotBottomBox").css({width:((chartWidth/3)+50) + "px"});
			
			var bottomButtonWidth = (widget2Width-20)/5;
			$(".wrap .mainfooter button").css("width", bottomButtonWidth);
			
			var gridBoxHeight = $(".present .worktab").height() + $(".present  .title").height() + 24;
			$(".present .gridTab").css("height", "calc(100% - " + gridBoxHeight + "px)");
		});
	}
	
	function footerButtonLink(){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		var json = netUtil.sendData({
			module : "main",
			command : "BUTTON_URL",
			sendType : "map",
			param : param
		});
		
		if( json && json.data ){
			var data = json.data;
			if(data){
				$('.mainfooter .ecommerce').attr("onclick", "window.open('" + data.URL1 + "')");
				$('.mainfooter .BOS').attr("onclick", "window.open('" + data.URL2 + "')");
				$('.mainfooter .TMS').attr("onclick", "window.open('" + data.URL3 + "')");
				$('.mainfooter .Gsfresh').attr("onclick", "window.open('" + data.URL4 + "')");
				$('.mainfooter .happycall').attr("onclick", "window.open('" + data.URL5 + "')");
				$('.mainfooter .portal').attr("onclick", "window.open('" + data.URL6 + "')");
				
			}
		}
	}
	
	
	function numberComma(num){
		return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function infoReload(){
		this.location.reload();
	}
</script>
<body style="margin:0;">
	<div class="wrap">
		<div class="main">
			<div class="widget present">
				<h3 class="title">센터 작업 진행 현황 <span class="number"></span></h3>
				<div class="worktab">
					<ul class="worktabul">
						<li class="active">입고</li>
						<li>주문</li>
						<li>피킹</li>
						<li>상차/출하</li>
					</ul>
					
					<div class="weeknumberinner tab4ComboDoc" style="margin-left: 10px;">
						<p>전체</p>
						<ul class="weeknumber">
						</ul>
					</div>
					
					<div class="weeknumberinner tab3Combo">
						<p>차수</p>
						<ul class="weeknumber">
						</ul>
					</div>
					
					<div class="weeknumberinner shpmtyCombo">
						<p id="COMBOTT">전체</p>
						<ul class="weeknumber">
						</ul>
					</div>
					
				</div>
				<div class="gridTab warpTable1">
					<table class="work">
						<thead>
							<tr>
								<td class="area">AREA</td>
								<td>입고예정</td>
								<td>입고완료</td>
								<td>진행율</td>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				
				
				<div class="gridTab warpTable2">
					<table class="work">
						<thead>
							<tr>
								<td class="area">차수</td>
								<td>설정건수</td>
								<td>주문건수</td>
								<td>마감여부</td>
								<td>주문 마감율</td>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				
				
				<div class="gridTab warpTable3">
					<table class="work">
						<thead>
							<tr>
								<td class="area">AREA</td>
								<td>주문건수</td>
								<td>완료건수</td>
								<td>진행율</td>
								<td>생산성</td>
								<td>결품</td>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				
				<div class="gridTab warpTable4">
					<table class="work">
						<thead>
							<tr>
								<td>회전</td>
								<td>도크</td>
								<td>차량번호</td>
								<td>매니저명</td>
								<td>정상<span class="tdFontSize">(DPS)</span></td>
								<td>상온<span class="tdFontSize">(Bypass)</span></td>
								<td>저온<span class="tdFontSize">(Bypass)</span></td>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				
			</div>
			
			
			
			<div class="widget KPI">
				<h3 class="title">센터 KPI</h3>
				<table class="work">
					<thead>
						<tr>
							<td>항목</td>
							<td>전월</td>
							<td>전주</td>
							<td>전일</td>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
			
			<div class="widget notice">
				<h3 class="title">공지사항</h3>
				<button onclick="page.linkPageOpen('NT10', null)">더보기</button>
				
			</div>
			
			<div class="widget">
				<h3 class="title" style="display:inline-block;">피킹 생산성</h3>
				<img id="picRefresh" src="/common/images/ico_left3.png" alt="refresh" onClick="pickChart()" style="width: 15px; margin-left: 3px; cursor: pointer;"/>
				<div class="content">
					<div class="plotLeft">
						<div class="plotTitle">
							<p class="tal">전일 생산성</p>
						</div>
						<div class="plotContent">
							<div class="plotRightBox pickYesterday">
								<div class="boxData">
									<p></p>
								</div>
								<div class="boxUom">
									<p>건/hr</p>
								</div>
							</div>
<!-- 							<div class="rightArrow2"></div> -->
<!-- 							<div class="rightArrow3"></div> -->
						</div>
					</div>
					<div class="plotRight">
					    <div class="plotTitle">
					    	<p class="tar">금일 생산성</p>
					    </div>
						<div class="plotContent">
							<div class="plotLeftBox pickToday">
								<div class="boxData">
									<p></p>
								</div>
								<div class="boxUom">
									<p>건/hr</p>
								</div>
							</div>
<!-- 							<div class="leftArrow2"></div> -->
<!-- 							<div class="leftArrow3"></div> -->
						</div>
					</div>
					<div id="chart" class="plot"></div>
					<div class="plotBottom">
						<div class="plotBottomBox pickCount">
							<span class="countBox"></span><span class="countUom">건</span>
						</div>
					</div>
				</div>
			</div>
			<div class="widget">
				<h3 class="title" style="display:inline-block;">차량 생산성</h3>
				<img id="carRefresh" src="/common/images/ico_left3.png" alt="refresh" onClick="carChart()" style="width: 15px; margin-left: 3px; cursor: pointer;"/>
				<div class="content">
					<div class="plotLeft">
						<div class="plotTitle">
							<p class="tal">전일 생산성</p>
						</div>
						<div class="plotContent">
							<div class="plotRightBox carYesterday">
								<div class="boxData">
									<p></p>
								</div>
								<div class="boxUom">
									<p>건/차량</p>
								</div>
							</div>
<!-- 							<div class="rightArrow2"></div> -->
<!-- 							<div class="rightArrow3"></div> -->
						</div>
					</div>
					<div class="plotRight">
					    <div class="plotTitle">
					    	<p class="tar">금일 생산성</p>
					    </div>
						<div class="plotContent">
							<div class="plotLeftBox carToday">
								<div class="boxData">
									<p></p>
								</div>
								<div class="boxUom">
									<p>건/차량</p>
								</div>
							</div>
<!-- 							<div class="leftArrow2"></div> -->
<!-- 							<div class="leftArrow3"></div> -->
						</div>
					</div>
					<div id="chart2" class="plot"></div>
					<div class="plotBottom">
						<div class="plotBottomBox carCount">
							<span class="countBox"></span><span class="countUom">건</span>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="mainfooter">
			<button class="ecommerce defult">e본부</button>
			<button class="BOS defult">eBOS</button>
			<button class="TMS defult">TMS</button>
			<!-- <button class="Gsfresh">　</button> -->
			<button class="happycall">해피콜</button>
			<button class="portal">포탈</button>
		</div>
	</div>
</body>
</html>