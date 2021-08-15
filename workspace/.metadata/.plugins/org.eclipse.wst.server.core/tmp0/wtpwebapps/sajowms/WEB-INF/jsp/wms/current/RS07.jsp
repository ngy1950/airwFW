<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	var tavH;
	$(window).resize(function(){
		resizeHight();
	});

	$(document).ready(function(){
		
		gridList.setGrid({
			id : "gridList1",
			editable : true,
			module : "WmsOutbound",
			command : "RS07"
		});
		
		gridList.setGrid({
			id : "gridList2",
			editable : true,
			module : "WmsOutbound",
			command : "RS07SUB1"
		});
		
		gridList.setGrid({
			id : "gridList3",
			editable : true,
			module : "WmsOutbound",
			command : "RS07SUB2"
		});
		
		resizeHight();
		var val = day(0);

		searchShpdgr(val);
		$("#searchArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
		
		$("#searchArea [name=SHPDGR]").on("change",function(){
			searchvehino($('#RQSHPD').val().replace(/\./g,''),$(this).val());
			
		});
		
    });
    
    function searchShpdgr(val){
		var param = new DataMap();
		param.put("RQSHPD",val);
		param.put("WAREKY", "<%=wareky%>");
		param.put("DGRSTS", "DIRC");
		
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SHPDGR_S",
			sendType : "list",
			param : param
		});
		
		$("#SHPDGR").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#SHPDGR").append(optionHtml);
		getMaxSHPDGR();
		searchvehino($('#RQSHPD').val().replace(/\./g,''),"");
	}
    
    function searchvehino(val1,val2){
		var param = new DataMap();
			param.put("RQSHPD",val1);
			param.put("WAREKY", "<%=wareky%>");
			param.put("SHPDGR",val2);
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "VEHINO_S_DL11",
			sendType : "list",
			param : param
		});
		
		$("#VEHINO").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#VEHINO").append(optionHtml);
		$('#VEHINO').val("");
	}
    
    function day(day){
		var today = new Date();
		today.setDate(today.getDate() + day);
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();

		if( dd < 10 ) {
			dd ='0' + dd;
		} 

		if( mm < 10 ) {
			mm = '0' + mm;
		}
		
		return String(yyyy) + String(mm) + String(dd);
	}
    
    function getMaxSHPDGR(){
    	var param = new DataMap();
    	    param.put("WAREKY","<%=wareky%>");
    	var json = netUtil.sendData({
            module : "WmsOutbound",
            command : "MAX_SHPDGR",
            sendType : "map",
            param : param
        });
    	
    	if($('#searchArea [name=RQSHPD]').val().replace(/\./g,'') == day(0)){
    		$('#SHPDGR').val(json.data["SHPDGR"]);	
    	}else{
    		$('#SHPDGR').val("");
    	}
    }	
	
	
	function resizeHight(){
		tavH = $(".content").height() - $("#searchArea div").height() -30;
		$(".bottomSect2").css({"height" : tavH + "px"});
	}
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			gridList.resetGrid("gridList1");gridList.resetGrid("gridList2");gridList.resetGrid("gridList3");
			
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridList1",
				param : param
			});
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("USRADM", "<%=usradm%>");
			param.put("WAREKY", "<%=wareky%>");
			param.put("USERID", "<%=userid%>");
			return param;
		}
	}
	
	//그리드 더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
        if(gridId == "gridList1"){
        	gridList.resetGrid("gridList3");
        		
        	var row = gridList.getRowData(gridId, rowNum);
        		row.put("SES_ENV", "<%=usradm%>");
        	gridList.gridList({
                id : "gridList2",
                param : row
            });
        }else if(gridId == "gridList2"){
        	var row = gridList.getRowData(gridId, rowNum);
        	row.put("SES_ENV", "<%=usradm%>");
        	gridList.gridList({
                id : "gridList3",
                param : row
            });
        }
    }
</script>
</head>
<body style="position: relative;">
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
	</div>
</div>


<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="foldSect" id="searchArea">
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
									<col width="250" />
									<col width="50" />
				                    <col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
										
										<th CL="STD_RQSHPD"></th>
										<td>
											<input type="text" name="RQSHPD" id="RQSHPD" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px" validate="required(STD_SHPDGR)" >
												<option value="" selected>선택</option>
											</select>
										</td>
									</tr>
									<tr>
										<th CL="STD_LOCAKY"></th>
										<td>
											<input type="text" name="SI.LOCAKY" UIInput="SR" />
										</td>
										
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="SI.SKUKEY" UIInput="SR" />
										</td>
										
										<th CL="STD_DESC01"></th>
										<td>
											<input type="text" name="DESC01" />
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 그리드 -->
			<div class="bottomSect2 top3" style="top:110px;width: 513px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_RESKUNM'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList1">
											<tr CGRow="true">
<!-- 												<td GH="40 STD_NUMBER"      GCol="rownum">1</td> -->
												<td GH="100 STD_LOCAKY"     GCol="text,LOCAKY"></td>
												<td GH="150 STD_SKUKEY"     GCol="text,SKUKEY"></td>
												<td GH="230 STD_DESC01"     GCol="text,DESC01"></td>
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
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 그리드 -->
			
			<div class="bottomSect2 top4" style="top:110px;width: 351px; left: 545px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_ORDERS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList2">
											<tr CGRow="true">
<!-- 												<td GH="40 STD_NUMBER"      GCol="rownum">1</td> -->
												<td GH="100 STD_SVBELN"     GCol="text,SVBELN"></td>
												<td GH="100 STD_SHCARN"     GCol="text,SHCARN"></td>
												<td GH="100 STD_STARNM"     GCol="text,SUSRNM"></td>
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
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			
			
			<div class="bottomSect2 top5" style="top:110px; left: 912px; width: calc(100% - 932px);">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_ORDSKU'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList3">
											<tr CGRow="true">
<!-- 												<td GH="40 STD_NUMBER"      GCol="rownum">1</td> -->
												<td GH="88 STD_AREANM"    GCol="text,AREANM"  ></td>
												<td GH="49 STD_ZONEKY"    GCol="text,ZONEKY"  ></td>
												<td GH="100 STD_VEHINO"    GCol="text,VEHINO"  ></td>
												<td GH="88 STD_DRIVNM"    GCol="text,DRIVER"  ></td>
												<td GH="72 STD_SHPDSQ"    GCol="text,SHPDSQ" GF="N" ></td>
												<td GH="67 STD_STARNM"    GCol="text,SUSRNM"  ></td>
												<td GH="74 STD_WORKZO"    GCol="text,WORKZO"  ></td>
												<td GH="85 STD_LOCAKY"    GCol="text,LOCAKY"  ></td>
												<td GH="122 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
												<td GH="200 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="84 STD_QTSHPO"    GCol="text,QTSHPO" GF="N" ></td>
												<td GH="84 STD_QTJCMP"    GCol="text,QTJCMP" GF="N" ></td>
												<td GH="84 STD_QTSHPC"    GCol="text,QTSHPC" GF="N" ></td>
												<td GH="82 STD_SBOXID"    GCol="text,SBOXID"  ></td>
												<td GH="82 STD_BOXLAB"    GCol="text,BOXLAB"  ></td>
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
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
		</div>
		<!-- //contentContainer -->
	</div>
</div>

<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>