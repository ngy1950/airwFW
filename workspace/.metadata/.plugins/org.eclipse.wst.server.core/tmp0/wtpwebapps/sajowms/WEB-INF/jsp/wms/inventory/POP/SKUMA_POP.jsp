<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>상품 조회</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">
	window.resizeTo('1200','800');
	
	var gSearchCode = "";
	var gOpenType   = "search";
	var gMultyType  = true;
	var gRowNum     = -1;
	var gGridId     = "";
	var gLink       = false;
	var gLinkData   = "";
	
	$(document).ready(function(){
		setTopSize(130);
		
		setInitData();
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInventory",
			command : "SJ01_SKUMA_POP",
			autoCopyRowType : false
		});
		
		if(gLink){
			searchList(1);
		}else{
			searchList(0);
		}
		
	});
	
	function setInitData(){
		var data = page.getLinkPopData();
		
		gSearchCode = data.get("searchCode");
		gOpenType   = data.get("openType");
		gMultyType  = data.get("multyType");
		gRowNum     = data.get("rowNum") == undefined?-1:data.get("rowNum");
		gGridId     = (data.get("gridId") != undefined && $.trim(data.get("gridId")) != "" && data.get("gridId") != null)?data.get("gridId"):"";
		gLink       = data.get("isLink");
		gLinkData   = gLink?data.get("param").get("LINK_DATA"):"";
		
		var param = data.get("param");
		dataBind.dataNameBind(param, "searchArea");
		
		if(!gMultyType){
			$("#gridList td[GCol=rowCheck]").remove();
			
			$("#btn0").remove();
			$("#btn0Txt").remove();
		}
	}
	
	//공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList(0);
		}
	}
	
	//헤더 조회
	function searchList(type){
		var param = inputList.setRangeParam("searchArea");
		param.put("WAREKY", "<%=wareky%>");
		if(type == 1){
			param.put("LINK_DATA",gLinkData);
		}else{
			gLinkData = "";
			gLink     = false;
			
			page.getLinkPopData().put("LINK_DATA","");
			page.getLinkPopData().put("isLink",false);
		}
		gridList.gridList({
			id : "gridList",
			param : param
		}); 
		
	}
	
	
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			var packYn = gridList.getColData(gridId, rowNum, "PACKYN");
			if(packYn == "Y"){
				commonUtil.msgBox("팩 관리 상품은 선택 할 수 없습니다.");
				return;
			}
			
			var data = new Array();
			data.push(gridList.getColData(gridId, rowNum, "SKUKEY"));
			
			var param = new DataMap();
			param.put("searchCode", gSearchCode);
			param.put("returnData", data);
			
			page.linkPopClose(param);
		}
	}
	
	
	function multiSelect(){
		var selectData = gridList.getSelectData("gridList", true);
		var len        = selectData.length;
		
		if( len > 0 ){
			var data = new Array();
			for(var i = 0; i < len; i++){
				var row = selectData[i];
				data.push(row.get("SKUKEY"));
			}
			
			var param = new DataMap();
			param.put("searchCode", gSearchCode);
			param.put("returnData", data);
			
			page.linkPopClose(param);
			
		}else{
			commonUtil.msgBox("VALID_M0006");
		}
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			
			if( name == "LOTL04" ){
				param.put("CODE", "LOTL04");
				
			}else if( name == "SKUCLS" ){
				param.put("CODE", "SKUCLS");
				param.put("WARECODE", "Y");
				
			}
			return param;
		}
	}
	
	function exit(){
		//opener.skumaPopup.exit();
	}
</script>
</head>
<body onbeforeunload="exit()">
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

			<div class="bottomSect top" id="searchArea">
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
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="SM.SKUKEY" UIInput="SR" />
										</td>
										<th CL="STD_DESC01"></th>
										<td>
											<input type="text" name="SM.DESC01" UIInput="SR" UIformat="S 40" />
										</td>
									</tr>
									<tr>
										<th CL="STD_LOTL04">연계상품</th>
										<td>
											<select name="LOTL04" Combo="Common,COMCOMBO" ComboCodeView=false style="width:160px">
												<option value="">전체</option>
											</select>
										</td>
										<th CL="STD_SKUCLS">물류분류</th>
										<td>
											<select name="SKUCLS" Combo="Common,COMCOMBO" ComboCodeView=false style="width:160px">
												<option value="">전체</option>
											</select>
										</td>
										<th CL="STD_FIXLOC">피킹로케이션</th>
										<td>
											<select id="FIXLOC" name="FIXLOC" style="width:160px">
												<option value="">전체</option>
												<option value="V">지정</option>
												<option value=" ">미지정</option>
											</select>
										</td>
									</tr>
									<tr>
										<th>팩상품 여부</th>
										<td>
											<select id="PACKYN" name="PACKYN" style="width:160px">
												<option value="">전체</option>
												<option value="Y">Y</option>
												<option value="N">N</option>
											</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottom" >
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_DISPLAY"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40"                  GCol="rownum">1</td>
												<td GH="40"                  GCol="rowCheck"></td>
												<td GH="100 STD_LOTL04,3"    GCol="text,LO04NM"></td>
												<td GH="130 STD_SKUKEY"      GCol="text,SKUKEY"></td>
												<td GH="240 STD_DESC01"      GCol="text,DESC01"></td>
												<td GH="130 STD_SKUCLSNM"    GCol="text,SCLSNM"></td>
												<td GH="100 STD_PACKSKU" GCol="text,PACKYN,center"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button id="btn0" class="type8" type="button" title="select" onclick="multiSelect()"><img src="/common/theme/darkness/images/grid_icon_01.png"></button>
									<span id="btn0Txt" CL="BTN_CHOOSE" style="vertical-align:middle;padding-left:5px;padding-right:5px"></span>
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
		</div>
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>