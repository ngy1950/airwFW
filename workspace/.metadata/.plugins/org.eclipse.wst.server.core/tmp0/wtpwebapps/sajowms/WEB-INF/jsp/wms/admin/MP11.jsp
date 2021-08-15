<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/css/location_set.css">
<script type="text/javascript">
	var g_data = new DataMap();
	var g_rate = new DataMap();
	var g_tot_rate = new DataMap();
	var g_tot = new DataMap();
	var g_result = [];
	var g_head = new DataMap();
	
	var pop = null;
	
	var timer = null;
	var totalLocationCount = 0;
	
	$(window).resize(function(){
		init();
	});
	
	$(document).ready(function(){
		gridList.setGrid({
			id :"gridList",
			name : "gridList",
			colorType : true
		});
		
		init();
		
		gridList.setHeadText("gridList","SKURAT",uiList.getLabel("STD_RATE") + "(%)");
		gridList.appendCols("gridList",["WAREKY","OWNRKY","SKUKEY","DESC01","LOTA06","RACKLE","SKURAT","ORDCNT","SUMRAT","ID"]);
		
		var $moveBtn = $(".moveButtonWapper ul li");
		$(".moveButtonWapper ul li").on("mouseenter",function(){
			var $tng = $(this).find(".tng");
			$tng.addClass("tngOn");
		});
		$moveBtn.on("mouseleave",function(){
			var $tng = $(this).find(".tng");
			$tng.removeClass("tngOn");
		});
		
		var json = netUtil.sendData({
			module : "WmsAdmin",
			command : "ABCAVL",
			sendType : "list"
		});
		
		if(json && json.data){
			var data = json.data;
			var len = data.length;
			if(len > 0){
				for(var i = 0; i < len; i++){
					var row = data[i];
					
					var data1 = row["SORTSQ"];
					var data2 = row["CDESC1"];
					var data3 = row["USARG1"] + "%";
					var data4 = row["USARG3"] + "%";
					
					var rowNum = i + 1;
					var $obj =$("#grid3 table tr");
					if(rowNum == len){
						$obj.eq(rowNum).find("td").eq(0).text(data1);
						$obj.eq(rowNum).find("td").eq(1).text(data3);
						$obj.eq(rowNum).find("td").eq(2).text(data4);
					}else{
						$obj.eq(rowNum).find("td").eq(0).text(data1);
						$obj.eq(rowNum).find("td").eq(1).text(data2);
						$obj.eq(rowNum).find("td").eq(2).text(data3);
						$obj.eq(rowNum).find("td").eq(3).text(data4);
					}
				}
			}
		}
	});
	
	function init(){
		var $content = $("#searchArea");
		var $grid1 = $("#grid1");
		var $grid2 = $("#grid2");
		var $grid3 = $("#grid3");
		var $btn   = $(".moveButtonWapper");
		
		var contentWidth = $content.width();
		var contentHeight = $grid1.height();
		
		//화면 비율 width (7.5:2.5)
		var grid2Width = (contentWidth * 2.5) / 7.5;
		var grid1Width = contentWidth - grid2Width;
		
		//화면 비율 height (7.5:2.5)
		var grid3Height = (contentHeight * 2.5) / 7.5;
		var grid2Height = contentHeight - grid3Height;
		
		$grid1.css("width",(grid1Width - 76));
		$grid2.css({"width":grid2Width,"height":grid2Height,"left":(grid1Width + 16)});
		$grid3.css({
			"width":(grid2Width + 66),
			"height":(grid3Height - 21),
			"top":(grid2Height + 121),
			"left": (grid1Width - 50)
		});
		$grid3.find(".tableUtil").remove();
		$btn.css({"height":grid2Height,"left":(grid1Width - 50)})
	}
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}else if( btnName == "Confirm" ){
			confirmList();
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			var frDate = $("#searchArea .calendarInput").eq(0).val();
			var toDate = $("#searchArea .calendarInput").eq(1).val();
			if($.trim(frDate) == ""){
				commonUtil.msgBox("VALIDATE_startdate");
				$("#searchArea .calendarInput").eq(0).focus();
				return;
			}
			if($.trim(toDate) == ""){
				commonUtil.msgBox("VALIDATE_enddate");
				$("#searchArea .calendarInput").eq(1).focus();
				return;
			}
			
			initLocation();
			
			var param = inputList.setRangeDataParam("searchArea");
			var schTyp = param.get("SCHTYP");
			var schlab = "";
			switch (schTyp) {
			case "01":
				schlab = uiList.getLabel("STD_SHPCNT");
				break;
			case "02":
				schlab = uiList.getLabel("STD_SHPQTY");
				break;
			default:
				break;
			}
			
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "MP11_LOCMA_COUNT",
				param : param,	
				sendType : "map"
			});
			
			if(json && json.data){
				totalLocationCount = json.data["CNT"];
				if(totalLocationCount == 0){
					var zone = param.get("ZONEKY");
					var zoneTxt = $("#searchArea [name=ZONEKY] [value='"+zone+"']").text();
					commonUtil.msgBox("ADMIN_M0003",zoneTxt);
					return;
				}
			}
			
			
			gridList.setHeadText("gridList","ORDCNT",schlab);
			
			setTimeout(function(){
				$("#gridSaveHolder").show();
				run(param);
			});
		}
	}
	
	function countTimter(){
		if(timer != null || timer > 0){
			return;
		}
		
		timer = setInterval(function(){
			$.ajax({
				type : "post",
				url : "/wms/admin/json/sessionMP11DataCount.data",
				async : true,
				dataType : "json",
				contentType: "application/json",
				error : function(a, b, c){
					clearInterval(timer);
					timer = null;
					closeTimter();
				},
				success : function (json) {
					var count = json.data;
					var progress = Math.ceil((count/totalLocationCount)*100)
					$("#innerGuage").css("width",progress+"%");
					$("#innerGuageTxt").html(progress + "%");
				}
			});
		},500);
	}
	
	function closeTimter(msg){
		$.ajax({
			type : "post",
			url : "/wms/admin/json/removeSessionMP11DataCount.data",
			async : true,
			dataType : "json",
			contentType: "application/json",
			error : function(a, b, c){
				clearInterval(timer);
				timer = null;
				$("#gridSaveHolder").hide();
			},
			success : function (json) {
				setTimeout(function(){
					clearInterval(timer);
					timer = null;
					
					$("#innerGuage").css("width","0%");
					$("#innerGuageTxt").html("0%");
					$("#gridSaveHolder").hide();
					setTimeout(function(){
						if(msg != undefined && msg != null && $.trim(msg) != ""){
							commonUtil.msgBox(msg);
						}
					},200);
				}, 500);
			}
		});
	}
	
	function run(param){
		var paramStr = param.jsonString();
		while(paramStr.indexOf("??") != -1){
			paramStr = commonUtil.replaceAll(paramStr, "??", "?");
		}
		$.ajax({
			type: "POST",
			url : "/wms/admin/json/SelectMP11TaskAreaData.data",
			async : true,
			data : paramStr,
			dataType : "json",
			contentType: "application/json",
			beforeSend : function(){
				countTimter();
			},
			error : function(a, b, c){
				if(a.status == 200 && a.statusText == "OK"){
					closeTimter(a.responseText);
				}else{
					closeTimter();
				}
			},
			success : function (json) {
				drawLocation(json.data);
			}
		});
	}
	
	function initLocation(){
		$("#skuInfo").children().remove();
		$("#zone").html("");
		$("#taskList").children().remove();
		$("#zone").removeClass();
		g_data = new DataMap();
		g_rate = new DataMap();
		g_tot_rate = new DataMap();
		g_tot = new DataMap();
		g_result = [];
		g_head = new DataMap();
		gridList.resetGrid("gridList");
	}
	
	function drawLocation(data){
		var $content = $("#taskList");
		
		var wareky = data["WAREKY"];
		var wareNm = data["WARENM"];
		var areaky = data["AREAKY"];
		var areaNm = data["AREANM"];
		var zoneky = data["ZONEKY"];
		var zoneNm = data["ZONENM"];
		var frDate = data["FRDATE"];
		var toDate = data["TODATE"];
		
		var schtyp = data["SCHTYP"];
		var maxRow = commonUtil.parseInt(data["MAXROW"]);
		var maxCol = commonUtil.parseInt(data["MAXCOL"]);
		var template = data["TEMPLATE"];
		
		g_head.put("WAREKY",wareky);
		g_head.put("WARENM",wareNm);
		g_head.put("AREAKY",areaky);
		g_head.put("AREANM","[ " + areaky + " ] " + areaNm);
		g_head.put("ZONEKY",zoneky);
		g_head.put("ZONENM","[ " + zoneky + " ] " + zoneNm);
		g_head.put("FRDATE",frDate);
		g_head.put("TODATE",toDate);
		g_head.put("SCHTYP",schtyp);
		g_head.put("TEMPLT",template);
		
		var line = data["SRTLST"];
		var lineLen = line.length;
		if(lineLen > 0){
			var $div = $("<div>");
			var $ul  = $("<ul>");
			var $li  = $("<li>");
			var $p   = $("<p>");
			
			var locBoxWid  = 70;//100
			var locBoxHei  = 35;
			var taskNumWid = 40;
			var margin     = 10;
			var hMargin    = 7;
			
			for(var i = 0; i < lineLen; i++){
				var lineData = line[i];
				
				var lineId = lineData["ID"];
				var lineType = lineData["SRTCOD"];
				
				var lineAreaWid = (((maxCol*locBoxWid) + locBoxWid) + (taskNumWid + margin) + 15);
				
				var $lineArea = $div.clone().addClass((lineType == "01")?"leftArea":"rightArea");
				$lineArea.attr({"id":lineId});
				$lineArea.css({"width": lineAreaWid,"height":"100%"});
				
				var taskArea = lineData["TSKLST"];
				
				var taskAreaLen = taskArea.length;
				if(taskAreaLen > 0){
					for(var j = 0; j < taskAreaLen; j++){
						var taskData = taskArea[j];
						
						var taskId = taskData["ID"];
						var taskTotal = taskData["TSKTOT"];
						var taskRate = taskData["TSKRAT"];
						
						var sectorRow = commonUtil.parseInt(taskData["SCTROW"]);
						var $taskArea = $div.clone().addClass("taskArea");
						$taskArea.attr({"id":taskId});
						
						g_tot_rate.put(taskId,taskRate);
						g_tot.put(taskId,taskTotal);
						
						if(lineType == "01"){
							var taskNum = taskData["TSKNUM"];
							var $taskNumText = $p.clone().html(taskNum);
							var $taskNum = $div.clone().addClass("taskNum").append($taskNumText);
							
							$taskArea.append($taskNum);
						}
						
						var $sectorWapper = $div.clone().addClass("sectorWapper");
						$taskArea.append($sectorWapper);
						
						var taskWapHei = 0;
						
						var sectWapWid = lineAreaWid - (taskNumWid + margin);
						var rackWid = 0;
						
						var sector = taskData["SCTLST"];
						var sectorLen = sector.length;
						if(sectorLen > 0){
							for(var k = 0; k < sectorLen; k++){
								var sectorData = sector[k];
								
								var sectorId = sectorData["ID"];
								var rate = sectorData["RATE"];
								var rackRows = commonUtil.parseInt(sectorData["RCKROW"]);
								if(rackRows < maxCol){
									rackRows = maxCol;
								}
								
								var $sectorArea = $div.clone().addClass("sectArea");
								$sectorArea.attr({"id":sectorId});
								$sectorArea.css({"width": ((rackRows*locBoxWid) + locBoxWid) + margin});
								
								var $rateArea = $div.clone().addClass("rateArea");
								var sectorRateId = (sectorId + "_RATE");
								$rateArea.attr({"id":sectorRateId});
								
								g_rate.put(sectorRateId,rate);
								
								var $rateAreaText = $p.clone().html(rate + "%");
								$rateArea.append($rateAreaText);
								
								$sectorArea.append($rateArea);
								
								rackWid = rackRows*locBoxWid;
								
								var $rackWapper = $div.clone().addClass("rackWapper");
								$rackWapper.css({"width": rackWid});
								
								var gLocRows = 0;
								var rack = sectorData["RCKLST"];
								var sectWapHei = 0;
								
								var rackLen = rack.length;
								if(rackLen > 0){
									for(var l = 0; l < rackLen; l++){
										var rackData = rack[l];
										var locationRow = commonUtil.parseInt(rackData["LOCROW"]);
										var rackId = rackData["ID"];
										
										var $rackArea = $div.clone().addClass("rackArea");
										$rackArea.attr({"id":rackId});
										$rackArea.css({"width": locBoxWid,"height": (35*locationRow)});
										$rateArea.css("height",(locationRow*35));
										$sectorArea.css({"height":(locationRow*35)});
										$rackWapper.css({"height":(locationRow*35)});
										if(gLocRows < locationRow){
											gLocRows = locationRow;
										}
										sectWapHei = ((35*locationRow) + 7);
										
										var location = rackData["LOCLST"];
										var locationLen = location.length;
										if(locationLen > 0){
											for(var m = 0; m < locationLen; m++){
												var locationAreaData = location[m];
												var $locationArea = $ul.clone().addClass("locationArea");
												
												if(locationAreaData.length > 0){
													for(var n = 0; n < locationAreaData.length; n++){
														var locationData = locationAreaData[n];
														
														var locationId = locationData["ID"];
														var locaky = locationData["RACKLE"];
														var status = locationData["CLSRAK"];
														
														var $location = $li.clone().addClass("location").addClass(status);
														$location.attr({"id":locationId,"data-class":status});
														$location.text(locaky);
														$locationArea.append($location);
														
														var locMap = new DataMap();
														var locData = new DataMap(locationData);
														g_data.put(locationId,locData);
													}
												}
												$rackArea.append($locationArea);
											}
										}
										
										$rackWapper.append($rackArea);
									}
									
									$sectorArea.append($rackWapper);
									taskWapHei = taskWapHei + sectWapHei;
								}
								$sectorWapper.css({"width": sectWapWid,"height": (taskWapHei - hMargin) + 3});
								$sectorWapper.append($sectorArea);
							}
							
							var $totalWapper = $div.clone().addClass("totalWapper");
							$totalWapper.css("width",sectWapWid);
							
							var $totRateSumArea = $div.clone().addClass("totalRateSumArea");
							$totRateSumArea.css("width",rackWid);
							
							var $totRateSumAreaText = $p.clone().html(taskTotal + "%");
							$totRateSumArea.append($totRateSumAreaText);
							
							var $totRateArea = $div.clone().addClass("totalRateArea");
							var $totRateAreaText = $p.clone().html(taskRate + "%");
							$totRateArea.append($totRateAreaText);
							
							$totalWapper.append($totRateSumArea).append($totRateArea);
							$taskArea.append($sectorWapper).append($totalWapper);
						}
						
						$taskArea.css("height",((taskWapHei + 42) - hMargin) + 3);
						$lineArea.append($taskArea);
					}
				}
				
				$content.append($lineArea);
				
				if(i == 0){
					var $beltLine = $div.clone().addClass("beltLine");
					$content.append($beltLine);
				}
			}
		}
		
		var beltLineHeightLeft = 0; 
		$("#taskList .leftArea .taskArea").each(function(){
			var $leftObj = $(this);
			var rowNum = $leftObj.index();
			var $rightObj = $("#taskList .rightArea .taskArea").eq(rowNum);
			
			var leftTaskAreaHeight  = $leftObj.height();
			var rightTaskAreaHeight = $rightObj.height();
			
			if(leftTaskAreaHeight >= rightTaskAreaHeight){
				$rightObj.css("height",leftTaskAreaHeight);
			}else{
				$leftObj.css("height",rightTaskAreaHeight);
			}
			
			beltLineHeightLeft = beltLineHeightLeft + ($leftObj.height() + hMargin);
			
		});
		
		var beltLineHeightRight = 0;
		$("#taskList .rightArea .taskArea").each(function(){
			beltLineHeightRight = beltLineHeightRight + ($(this).height() + margin);
		});
		
		$(".beltLine").css("height",(beltLineHeightLeft > beltLineHeightRight)?(beltLineHeightLeft - margin):(beltLineHeightRight - margin));
		
		$("#taskList .rightArea").css("width",$("#taskList .leftArea").width() - 40);
		
		var totWid = 0;
		$content.children().each(function(){
		    var w = $(this).width();
		    totWid = totWid + w;
		});
		$content.css("width",totWid);
		
		var $leftArea = $("#taskList .leftArea .sectorWapper");
		var $rightArea = $("#taskList .rightArea .sectorWapper");
		
		$leftArea.each(function(idx){
			var leftHeight = $(this).height();
			var $rightAreaItem = $rightArea.eq(idx);
			var rightHeight = $rightAreaItem.height();
			if(leftHeight != rightHeight){
				if(leftHeight > rightHeight){
					$rightAreaItem.css("height",leftHeight);
				}else if(leftHeight < rightHeight){
					$(this).css("height",rightHeight);
				}
			}
			
			var $leftSect = $(this).find(".sectArea");
			var $rightSect = $rightAreaItem.find(".sectArea");
			
			$leftSect.each(function(itemIdx){
				var $leftSectItem = $leftSect.eq(itemIdx);
				var $rightSectItem = $rightSect.eq(itemIdx);
				var leftSectHeight = $leftSect.eq(itemIdx).height();
				var rightSectHeight = $rightSectItem.height();
				if(leftSectHeight != rightSectHeight){
					if(leftSectHeight > rightSectHeight){
						$rightSectItem.css("height",leftSectHeight);
						$rightSectItem.find(".rateArea").css("height",leftSectHeight);
					}else if(leftSectHeight < rightSectHeight){
						$leftSectItem.css("height",rightSectHeight);
						$leftSectItem.find(".rateArea").css("height",rightSectHeight);
					}
				}
			});
		});
		
		$leftArea.each(function(idx){
			var resizeLeftHeight = 0;
			var resizeRightHeight = 0;
			
			var $rightAreaItem = $rightArea.eq(idx).find(".sectArea");
			var $leftAreaItem = $(this).find(".sectArea")
			
			$leftAreaItem.each(function(i){
				resizeLeftHeight = resizeLeftHeight + ($leftAreaItem.eq(i).height() + hMargin);
			});
			$rightAreaItem.each(function(i){
				resizeRightHeight = resizeRightHeight + ($rightAreaItem.eq(i).height()+ hMargin);
			});
			
			if(resizeLeftHeight > resizeRightHeight){
				$(this).css("height",resizeLeftHeight);
				$rightArea.eq(idx).css("height",resizeLeftHeight);
				
				$(this).parent().css("height",resizeLeftHeight+42);
				$rightArea.eq(idx).parent().css("height",resizeLeftHeight+42);
			}else if(resizeLeftHeight < resizeRightHeight){
				$rightArea.eq(idx).css("height",resizeRightHeight);
				$(this).css("height",resizeRightHeight);
				
				$(this).parent().css("height",resizeRightHeight+42);
				$rightArea.eq(idx).parent().css("height",resizeRightHeight+42);
			}
		});
		
		var reBeltLineHeightLeft = 0;
		$("#taskList .leftArea .taskArea").each(function(){
			var $leftObj = $(this);
			var leftTaskAreaHeight  = $leftObj.height();
			reBeltLineHeightLeft = reBeltLineHeightLeft + (leftTaskAreaHeight + margin);
		});
		
		$(".beltLine").css("height",reBeltLineHeightLeft);
		
		$("#zone").addClass(template);
		$("#zone").html("[ " + zoneky + " ] " + zoneNm);
		
		var $evt = $("#taskList ul li");
		$evt.on("click",function(){
			$("#skuInfo").children().remove();
			
			$("#taskList ul li").removeClass("on");
			$(this).addClass("on");
			
			var id = $(this).attr("id");
			var data = g_data.get(id);
			
			var skukey = data.get("SKUKEY");
			var desc01 = data.get("DESC01");
			var lotacd = data.get("LOTA06");
			var lota06 = data.get("LT06NM");
			var ordcnt = data.get("ORDCNT");
			var clsrak = data.get("CLSRAK");
			var bagyn  = data.get("BAGYN");
			var bagnam = data.get("BAGNAM");
			
			var $span = $("<span>");
			if(bagyn == "Y"){
				$("#skuInfo").append($span.clone().css({"margin-left":"10px","color":"#ff5a5a"}).text(bagnam));
			}else{
				if(($.trim(skukey) != "" && skukey != undefined) && moveBeforeEvent(locaky)){
					var $skukey = $span.clone().css("margin-right","5px").text(skukey);
					var $desc01 = $span.clone().text(desc01);
					var $lota06 = $span.clone().text(lota06);
					if(lotacd == "00"){
						$lota06.addClass("lt0600");
					}else if(lotacd == "10"){
						$lota06.addClass("lt0610");
					}
					
					var uom = (schtyp == "01")?" 건":" EA"
					var $ordcnt = $span.clone().text(ordcnt + uom);
					$("#skuInfo").append($span.clone().css("margin-right","5px").text("[ ")).append($skukey).append($span.clone().css("margin-right","5px").text(" ]"))
					             .append($desc01).append($lota06).append($ordcnt);
					if(clsrak != "X"){
						$("#skuInfo").append($span.clone().addClass("txLev").addClass(clsrak).html(clsrak));
					}
				}
			}
		});
		
		$evt.on("dblclick",function(){
			$("#skuInfo").children().remove();
			$("#taskList ul li").removeClass("on");
			
			var id = $(this).attr("id");
			var dataClass = $(this).attr("data-class");
			var data = g_data.get(id);
			var locaky = data.get("LOCAKY");
			
			var skukey = data.get("SKUKEY");
			var bagyn = data.get("BAGYN");
			if(bagyn == "Y"){
				commonUtil.msgBox("상품이 [ 종이 봉투 ]인 로케이션은 이동 할 수 없습니다.");
				return;
			}
			
			if(($.trim(skukey) != "" && skukey != undefined) && moveBeforeEvent(locaky)){
				gridList.addNewRow("gridList",data);
				
				setRateData(id,"D");
				
				var result = g_result.find(function(item) {return item.map.LOCAKY === locaky});
				var idx = g_result.indexOf(result)
				if(idx > -1){
					g_result.splice(idx, 1);
				}
				
				var $obj = $("#"+id);
				var initArr = ["OWNRKY","SKUKEY","DESC01","LOTA06","LT06NM","CLSRAK","ORDCNT","SKURAT","SUMRAT"];
				for(var i in initArr){
					var key = initArr[i];
					var changeStringValue = " ";
					var changeIntegerValue = 0.0;
					if(key == "CLSRAK"){
						changeStringValue = "N";
					}
					
					g_data.get(id).put(key,(key == "ORDCNT"||key == "SKURAT"||key == "SUMRAT")?changeIntegerValue:changeStringValue);
				}
				
				var initClass = ["SA","A","B","C","D","X","N"];
				for(var i in initClass){
					var c = initClass[i];
					$obj.removeClass(c)
				}
				$obj.addClass("N");
			}
		});
		
		closeTimter();
	}
	
	function moveBeforeEvent(locaky){
		var list = gridList.getGridData("gridList");
		var listLen = list.length;
		if(listLen > 0){
			var listFilter = list.filter(function(element,index,array){
				var listLocaky = element.get("LOCAKY");
				return (locaky == listLocaky);
			});
			
			var listFilterLen = listFilter.length;
			return listFilterLen > 0 ? false:true;
		}
		
		return true;
	}
	
	function moveToData(type){
		var $evt = $("#taskList ul li");
		if($evt.hasClass("on")){
			var $thisObj = document.querySelector("#taskList .on");
			var id = $thisObj.getAttribute("id");
			var dataClass = $thisObj.getAttribute("data-class");
			var $selectObj = $("#"+id);
			var data = g_data.get(id);
			
			var locaky = data.get("LOCAKY");
			var skukey = data.get("SKUKEY");
			var bagyn  = data.get("BAGYN");
			
			switch (type) {
			case "in":
				if(bagyn == "Y"){
					commonUtil.msgBox("상품이 [ 종이 봉투 ]인 로케이션은 이동 할 수 없습니다.");
					return;
				}
				
				if(($.trim(skukey) != "" && skukey != undefined) && moveBeforeEvent(locaky)){
					gridList.addNewRow("gridList",data);
					
					setRateData(id,"D");
					
					var result = g_result.find(function(item) {return item.map.LOCAKY === locaky});
					var idx = g_result.indexOf(result)
					if(idx > -1){
						g_result.splice(idx, 1);
					}
					
					var initArr = ["OWNRKY","SKUKEY","DESC01","LOTA06","LT06NM","CLSRAK","ORDCNT","SKURAT","SUMRAT"];
					for(var i in initArr){
						var key = initArr[i];
						var changeStringValue = " ";
						var changeIntegerValue = 0.0;
						if(key == "CLSRAK"){
							changeStringValue = "N";
						}
						
						g_data.get(id).put(key,(key == "ORDCNT"||key == "SKURAT"||key == "SUMRAT")?changeIntegerValue:changeStringValue);
					}
					
					var initClass = ["SA","A","B","C","D","X","N"];
					for(var i in initClass){
						var c = initClass[i];
						$selectObj.removeClass(c)
					}
					$selectObj.addClass("N");
				}
				
				break;
			case "out":
				if($selectObj.length > 0){
					var gridId = "gridList";
					var rowNum = gridList.getFocusRowNum(gridId);
					var c = gridList.getColData(gridId,rowNum,"CLSRAK");
					if(rowNum > -1){
						if(bagyn == "Y"){
							commonUtil.msgBox("상품이 [ 종이 봉투 ]로 등록 되어있는 로케이션으로 이동 시킬 수 없습니다.");
							return;
						}
						
						if($.trim(skukey) == ""){
							$selectObj.removeClass("on");
							
							var map = gridList.getRowData(gridId,rowNum);
							
							var locasr = map.get("LOCAKY");
							var locatg =  g_data.get(id).get("LOCAKY");
							if(locatg != locasr){	
								var resultMap = new DataMap();
								resultMap.putAll(map);
								resultMap.put("LOCATG",locatg);
								g_result.push(resultMap);
							}
							
							g_data.get(id).putAll(map);
							
							$selectObj.removeClass("N");
							$selectObj.removeClass("X");
							$selectObj.addClass(c);
							
							gridList.removeRow(gridId, rowNum,false);
							
							setRateData(id,"A");
						}else{
							commonUtil.msgBox("ADMIN_M0004");
						}
					}else{
						commonUtil.msgBox("VALID_M0006");
					}
				}else{
					commonUtil.msgBox("ADMIN_M0005");
				}
				break;
			default:
				break;
			}
			
			$("#skuInfo").children().remove();
			$evt.removeClass("on");
		}else{
			commonUtil.msgBox("ADMIN_M0005");
		}
	}
	
	//저장
	function confirmList(){
		var data = g_result;
		var len  = data.length;
		if(len > 0){
			var result = new DataMap();
			result.put("head",g_head);
			result.put("result",data);

			var url = "/wms/admin/POP/MP11_CONFIRM_POP.page";
			var option = "height=600,width=1000,resizable=yes";
			page.popData = result;
			
			pop = window.open(url, configData.MENU_ID, option);
		}else{
			commonUtil.msgBox("ADMIN_M0006");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			return param;
			
		}else if( comboAtt == "WmsAdmin,AREACOMBO" ){
			param.put("WAREKY","<%=wareky%>");
			param.put("USARG1", "STOR");
			return param;
		}else if( comboAtt == "WmsAdmin,ZONECOMBO" ){
			var areaky = $("[name=AREAKY]").val();
			
			param.put("WAREKY","<%=wareky%>");
			param.put("AREAKY",areaky);
			return param;
		}
	}
	
	function fn_changeArea(){
		inputList.reloadCombo($("[name=ZONEKY]"),configData.INPUT_COMBO,"WmsAdmin,ZONECOMBO",true);
	}
	
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			var $selectObj = $("#taskList").find(".on");
			if($selectObj.length > 0){
				var id = $selectObj.attr("id");
				var c = gridList.getColData(gridId,rowNum,"CLSRAK");
				var data = g_data.get(id);
				var $obj = $("#"+id);
				
				var skukey = data.get("SKUKEY");
				if($.trim(skukey) == ""){
					$obj.removeClass("on");
					
					var map = gridList.getRowData(gridId,rowNum);
					
					var locatg =  g_data.get(id).get("LOCAKY");
					var locaky = map.get("LOCAKY");
					if(locatg != locaky){
						var resultMap = new DataMap();
						resultMap.putAll(map);
						resultMap.put("LOCATG",locatg);
						
						g_result.push(resultMap);
					}
					g_data.get(id).putAll(map);
					
					$obj.removeClass("N");
					$obj.removeClass("X");
					$obj.addClass(c);
					
					gridList.removeRow(gridId, rowNum,false);
					
					setRateData(id,"A");
				}else{
					commonUtil.msgBox("ADMIN_M0004");
				}
			}else{
				commonUtil.msgBox("ADMIN_M0005");
			}
		}	
	}
	
	function gridListColBgColorChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "CLSRAK"){
				return "bg"+colValue;
			}
		}
	}
	
	function getDataSearchId(id){
		var data = new DataMap();
		
		var s = id.split("-");
		
		var taskId = s[0] + "-" + s[1] + "-" + s[2];
		var rateId = taskId + "-" + s[3] + "_RATE";
		
		data.put("taskId",taskId);
		data.put("rateId",rateId);
		data.put("alin",s[1]);
		
		return data;
	}
	
	function setRateData(id,type){
		var map = getDataSearchId(id);
		
		var taskId = map.get("taskId");
		var rateId = map.get("rateId");
		var alin = map.get("alin");
		var rAlin = "";
		if(alin == "01"){
			rAlin = "02";
		}else if(alin == "02"){
			rAlin = "01";
		}
		
		var rate = g_data.get(id).get("SKURAT");
		var taskRate = g_rate.get(rateId);
		var totRate = g_tot_rate.get(taskId);
		var tot = g_tot.get(taskId);
		if(rate <= 0){
			return;
		}
		var changeTaskRate = 0;
		var changeTotRate = 0;
		var changeTot = 0;
		
		switch (type) {
		case "D":
			changeTaskRate = (commonUtil.parseInt(taskRate) - commonUtil.parseInt(rate)).toFixed(3);
			changeTotRate = (commonUtil.parseInt(totRate) - commonUtil.parseInt(rate)).toFixed(3);
			changeTot = (commonUtil.parseInt(tot) - commonUtil.parseInt(rate)).toFixed(3);
			
			changeTaskRate = changeTaskRate <= 0?0:changeTaskRate;
			changeTot = changeTot <= 0?0:changeTot;
			changeTotRate = changeTotRate <= 0?0:changeTotRate;
			break;
		case "A":
			changeTaskRate = (commonUtil.parseInt(taskRate) + commonUtil.parseInt(rate)).toFixed(3);
			changeTotRate = (commonUtil.parseInt(totRate) + commonUtil.parseInt(rate)).toFixed(3);
			changeTot = (commonUtil.parseInt(tot) + commonUtil.parseInt(rate)).toFixed(3);
			
			changeTaskRate = changeTaskRate >= 100?100:changeTaskRate;
			changeTot = changeTot >= 100?100:changeTot;
			changeTotRate = changeTotRate >= 100?100:changeTotRate;
			break;
		default:
			break;
		}
		
		g_rate.put(rateId,commonUtil.parseInt(changeTaskRate));
		g_tot_rate.put(taskId,commonUtil.parseInt(changeTotRate));
		g_tot.put(taskId,commonUtil.parseInt(changeTot));
		
		$("#"+rateId).children().html(changeTaskRate + "%");
		$("#"+taskId+" .totalWapper .totalRateSumArea").children().html(changeTot + "%");
		$("#"+taskId+" .totalWapper .totalRateArea").children().html(changeTotRate + "%");
		
		var s = taskId.split("-");
		var rTaskId = s[0] + "-" + rAlin + s[1];
		var $taskArea = $("#"+rTaskId);
		if($taskArea){
			$("#"+rTaskId+" .totalWapper .totalRateSumArea").children().html(changeTot + "%");
		}
	}
	
	function closeMP11Popup(){
		if(pop != null){
			pop.fn_close();
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Confirm CALENDER BTN_TKBDCF"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect top" id="searchArea" style="height: 100px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col width="450" />
										<col width="50" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_SRHDAT"></th>
											<td>
												<input type="text" name="SH.SHPDAT" UIInput="B" UIFormat="C 0 1" validate="required(STD_SRHDAT)"/>
											</td>
											<th CL="STD_SCHTYP">조회조건</th>
											<td>
												<select name="SCHTYP" CommonCombo="SCHTYP" comboType="C,Combo" validate="required(STD_SCHTYP)" ComboCodeView=false style="width:160px"></select>
											</td>
										</tr>
										<tr>
											<th CL="STD_AREAKY">area</th>
											<td>
												<select name="AREAKY" Combo="WmsAdmin,AREACOMBO" validate="required(STD_AREAKY)" ComboCodeView=false style="width:160px" onchange="fn_changeArea();"></select>
											</td>
											<th CL="STD_ZONEKY">존</th>
											<td>
												<select name="ZONEKY" Combo="WmsAdmin,ZONECOMBO" comboType="C,Combo" validate="required(STD_ZONEKY)" style="width:160px"></select>
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<!-- **그리드1 -->
			<div class="bottomSect bottom" id="grid1" style="top: 100px;">
				<div class="tabs" style="border-bottom: 0;">
					<div id="tabs1-1">
						<div class="section type1" style="border-radius: 5px 5px 5px 5px;border-top-width: 1px;">
							<div class="table type2" style="bottom: 9px;">
								<div id="skuInfo"></div>
								<div id="zone" class="bg00"></div>
								<div class="tableBody" style="top: 90px;">
									<div id="taskList"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 그리드1** -->
			<!-- **이동 버튼 -->
			<div class="moveButtonWapper">
				<ul>
					<li onclick="moveToData('in');">
						<div class="btnArea">
							<div class="tng"></div>
						</div>
					</li>
					<li class="rotate" onclick="moveToData('out');">
						<div class="btnArea">
							<div class="tng"></div>
						</div>
					</li>
				</ul>
			</div>
			<!-- 이동 버튼** -->
			<!-- **그리드2 -->
			<div class="bottomSect bottom" id="grid2" style="top: 121px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_TSKHIS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="250 STD_DESC01" GCol="text,DESC01"></td>
												<td GH="100 STD_SHPCNT" GCol="text,ORDCNT" GF="N 20,4"></td>
												<td GH="100 STD_RATE"   GCol="text,SKURAT" GF="N 20,4"></td>
												<td GH="60 STD_CLSENG" GCol="text,CLSRAK,center"></td>
												<td GH="120 STD_LOCASR" GCol="text,LOCAKY,center"></td>
												<td GH="100 STD_LOTA06" GCol="text,LT06NM,center"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">	
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">0 Record</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 그리드2**-->
			<!-- **그리드3 -->
			<div class="bottomSect bottom" id="grid3" style="top: 121px;">
				<div class="tabs" style="border-bottom: 0;">
					<div id="tabs1-1">
						<div class="section type1" style="border: 1px solid #000;border-top-width: 3px;border-bottom-width: 3px;border-left-width: 0;border-right-width: 0;border-radius: 0;padding: 0;">
							<table class="tableBottom">
								<tr class="header">
									<th class="leftNoLine" CL="STD_GUBUN">구분</th>
									<th CL="STD_CLSENG">Class</th>
									<th CL="STD_RATE">비율</th>
									<th class="rightNoLine" CL="STD_SUMRAT">누적비율</th>
								</tr>
								<tr>
									<td class="leftNoLine">1</td>
									<td class="SA"></td>
									<td class="number SA"></td>
									<td class="number SA rightNoLine"></td>
								</tr>
								<tr>
									<td class="leftNoLine">2</td>
									<td class="A"></td>
									<td class="number A"></td>
									<td class="number A rightNoLine"></td>
								</tr>
								<tr>
									<td class="leftNoLine">3</td>
									<td class="B"></td>
									<td class="number B"></td>
									<td class="number B rightNoLine"></td>
								</tr>
								<tr>
									<td class="leftNoLine">4</td>
									<td class="C"></td>
									<td class="number C"></td>
									<td class="number C rightNoLine"></td>
								</tr>
								<tr>
									<td class="leftNoLine">5</td>
									<td class="D"></td>
									<td class="number D"></td>
									<td class="number D rightNoLine"></td>
								</tr>
								<tr>
									<td class="leftNoLine" colspan="2"></td>
									<td class="number"></td>
									<td class="number rightNoLine"></td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
			<!-- 그리드3**-->
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<div class="gridSavePageHolder" id="gridSaveHolder">
	<div class="innerArea">
		<div class="innerInfoBox">
			<p class="innerInfoTxt1">데이터를 불러오는 중 입니다.</p>
			<p class="innerInfoTxt2">잠시만 기다려주세요.</p>
		</div>
		<div class="innerGuageBox">
			<div id="innerGuage" class="innerGuage" style="width: 0%;"></div>
			<p id="innerGuageTxt" class="innerGuageTxt">0%</p>
		</div>
	</div>
</div>
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>