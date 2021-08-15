<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL22POP</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">
	var data;
	var popNm = "IP02_SKUMA";
	var g_grid_id = "";
	var g_row_num = 0;
	
	$(document).ready(function(){
		init();
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInventory",
			command : "IP02_SKUMA_POP"
	    });
		
		searchList();
	});
	
	function init(){
		$("#gridList tr td:eq(1)").remove();
		
		data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		
		var singleList = [];
		var locaky = data.get("LOCAKY");
		if($.trim(locaky) != ""){
			var json = netUtil.sendData({
				module : "WmsInventory",
				command : "IP02_SKUMA_POP_LOCCHK",
				sendType : "map",
				param : data
			});
			if(json && json.data){
				console.log(json.data["CNT"]);
				if(json.data["CNT"] == 0){
					var rangeMap = new DataMap();
					rangeMap.put(configData.INPUT_RANGE_LOGICAL, "OR");
					rangeMap.put(configData.INPUT_RANGE_OPERATOR, "E");
					rangeMap.put(configData.INPUT_RANGE_SINGLE_DATA, data.get("LOCAKY"));
					singleList.push(rangeMap);
					
					inputList.setRangeData("LOC.LOCAKY", configData.INPUT_RANGE_TYPE_SINGLE, singleList);
				}
			}
		}
		
		var multyType = data.get("multyType");
		g_grid_id = data.get("gridId");
		g_row_num = data.get("rowNum");
		
		if(!multyType){
			$("#btn0").remove();
			$("#btn0Txt").remove();
		}
	}

    //공통 버튼 클릭 이벤트
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }
    }
    
	//헤더 조회
	function searchList(){
		var param = inputList.setRangeDataParam("searchArea");
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
			
			var rowData = gridList.getRowData(gridId, rowNum);
			
			var param = new DataMap();
			param.put("gridId",g_grid_id);
			param.put("rowNum",g_row_num);
			param.put("popNm",popNm);
			param.put("data",rowData);
			
			page.linkPopClose(param);
		}
	}
	
	function multiSelect(){
		var list = gridList.getSelectData("gridList",true);
		var len = list.length;
		if(len > 0){
			page.linkPopClose(list);
		}else{
			commonUtil.msgBox("VALID_M0006");
		}
	}
	
    //그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
    function gridExcelDownloadEventBefore(gridId){
        var param = inputList.setRangeDataParam("searchArea");
        if(gridId == "gridList"){
            param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "gridList");
        }
        return param;
        
    }
	
	function closeData(){
		this.close();
	}
	
</script>
</head>
<body>
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

			<div class="bottomSect top" style="height:130px" id="searchArea">
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
											<input type="hidden" id="WAREKY" name="WAREKY"/>
											<input type="text" id="WARENM" name="WARENM" disabled="disabled" style="width: 160px;"/>
										</td>
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="SKM.SKUKEY" UIInput="SR" UIformat="U 20" />
										</td>
									</tr>
									<tr>
										<th CL="STD_DESC01"></th>
										<td>
											<input type="text" name="SKM.DESC01" UIInput="SR" UIformat="S 40" />
										</td>
										<th CL="STD_LOCAKY"></th>
										<td>
											<input type="text" name="LOC.LOCAKY" UIInput="SR" UIformat="U 40" />
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

			<div class="bottomSect bottomT" style="top: 145px;">
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
												<td GH="40 STD_NUMBER"  GCol="rownum">1</td>
												<td GH="40"             GCol="rowCheck"></td>
												<td GH="130 STD_SKUKEY" GCol="text,SKUKEY"></td>
												<td GH="300 STD_DESC01" GCol="text,DESC01"></td>
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