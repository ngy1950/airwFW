<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>재고조정결재</title>
<%@ include file="/common/include/popHead.jsp" %>
<style>
.init{color: #fff; font-weight: bold;}
.cmp{color: #04c704 !important; font-weight: bold;}
.not{color: orange !important; font-weight: bold;}
.req{color: blue !important; font-weight: bold;}
.end{color: red !important; font-weight: bold;}
</style>
<script type="text/javascript">
	window.resizeTo('1400','740');
	
	var linkData = new DataMap();
	var searchType = true;
	
	$(document).ready(function(){
		setTopSize(300);
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsInventory",
			command : "IP02_POP_HEAD",
			autoCopyRowType : false,
			itemGrid : "gridItemList",
			itemSearch : true,
			colorType : true,
			emptyMsgType : false
		});
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsInventory",
			command : "IP02_POP_ITEM",
			autoCopyRowType : false,
			headGrid : "gridHeadList",
			emptyMsgType : false
		});
		
		linkData = page.getLinkPopData();
		
		searchList();
	});

	//공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if(btnName == "SaveApproval"){ //승인
			aprrove();
		}else if(btnName == "SaveRejected"){ //부결
			reject();
		}
	}
	
	function init(){
		var progId = linkData.get("PROGID");
		
		var $contentWrap  = $("#contentWrap");
		var $reflectArea  = $("#reflect");
		var $headGridWrap = $("#gridHeadList").parent().parent().parent();
		
		if( progId == "AP11" ){
			var json = netUtil.sendData({
				module : "WmsApproval",
				command : "BTNCHECK",
				sendType : "map",
				param : linkData
			});
			if( json && json.data ){
				if( json.data["VALID"] == "N" ){
					uiList.setActive("SaveApproval", false);
					uiList.setActive("SaveRejected", false);
					
					$reflectArea.hide();
					$headGridWrap.css("top",10);
					$contentWrap.css("top",10);
				}else if( json.data["VALID"] == "Y" ){
					uiList.setActive("SaveApproval", true);
					uiList.setActive("SaveRejected", true);
					
					$reflectArea.show();
					$headGridWrap.css("top",45);
					$contentWrap.css("top",53);
				}
			}
		}else if( progId == "AP12" ){
			uiList.setActive("SaveApproval", false);
			uiList.setActive("SaveRejected", false);
			
			$reflectArea.hide();
			$headGridWrap.css("top",10);
			$contentWrap.css("top",10);
		}
	}
	
	//헤더 조회
	function searchList(){
		init();
		
		gridList.gridList({
			id : "gridHeadList",
			param : linkData
		}); 
		
	}
	
	// 그리드 item 조회 이벤트
	function gridListEventItemGridSearch(gridId, rowNum, itemList){
		var rowData = gridList.getRowData("gridHeadList", rowNum);
		
		gridList.gridList({
			id : "gridItemList",
			param : rowData
		});
	}
	
	function aprrove(){
		var rowNum = gridList.getFocusRowNum("gridHeadList");
		var head = gridList.getRowData("gridHeadList", rowNum);
		if( rowNum < 0 ){
			commonUtil.msgBox("VALID_M0006");
			return false;
		}
		
		var aprsts = head.get("APRSTS");
		if(aprsts == "END"){
			commonUtil.msgBox("INV_M0037");
			return;
		}
		
		var msg = "";
		
		var PHSCTY = gridList.getColData("gridHeadList",rowNum,"PHSCTY");
		switch (PHSCTY) {
		case "520":
			msg = commonUtil.getMsg("INV_M0041");
			break;
		case "522":
			msg = commonUtil.getMsg("INV_M0041");
			break;
		default:
			msg = commonUtil.getMsg("INV_M0038",head.get("APRKEY"));
			break;
		}
		
		if(!commonUtil.msgConfirm(msg)){
			return;
		}
		
		var progId = linkData.get("PROGID");
		var aprtxt = $("input[name=requestText]").val();
		head.put("APRTXT",aprtxt);
		head.put("PROGID",progId);
		
		var param = new DataMap();
		param.put("head", head);
		
		netUtil.send({
			url : "/wms/inventory/json/SaveIP02PopApprove.data",
			param : param,
			successFunction : "succsessApprCallBack"
		});
	}
	
	function succsessApprCallBack(json, status){
		if( json && json.data){
			searchType = false;
			
			if( json.data["CNT"] > 0 ){
				commonUtil.msgBox("INV_M0031",json.data["APRKEY"]); 
				searchList();
			}else{
				searchType = true;
				commonUtil.msgBox("INV_M0033");
			}
		}
	}
	
	function reject(){
		var rowNum = gridList.getFocusRowNum("gridHeadList");
		var head = gridList.getRowData("gridHeadList", rowNum);
		if( rowNum < 0 ){
			commonUtil.msgBox("VALID_M0006");
			return false;
		}
		
		var aprsts = head.get("APRSTS");
		if(aprsts == "END"){
			commonUtil.msgBox("INV_M0037");
			return;
		}
		
		if(!commonUtil.msgConfirm("INV_M0039",head.get("APRKEY"))){
			return;
		}
		
		var progId = linkData.get("PROGID");
		var aprtxt = $("input[name=requestText]").val();
		head.put("APRTXT",aprtxt);
		head.put("PROGID",progId);
		
		var param = new DataMap();
		param.put("head", head);
		
		netUtil.send({
			url : "/wms/inventory/json/SaveIP02PopReject.data",
			param : param,
			successFunction : "succsessRejectCallBack"
		});
	}
	
	function succsessRejectCallBack(json, status){
		if( json && json.data){
			searchType = false;
			
			if( json.data["CNT"] > 0 ){
				commonUtil.msgBox("INV_M0032",json.data["APRKEY"]); 
				searchList();
			}else{
				searchType = true;
				commonUtil.msgBox("INV_M0034");
			}
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList"){
			if(searchType){
				if(dataLength == 0){
					commonUtil.msgBox("SYSTEM_M0016");
					
					gridList.resetGrid("gridHeadList");
					gridList.resetGrid("gridItemList");
					
					page.linkPopClose();
				}
			}else{
				if(dataLength == 0){
					page.linkPopClose();
				}else{
					searchType = true;
				}
			}
		}
		if(gridId == "gridItemList" && dataLength == 0){
			gridList.resetGrid(gridId);
		}
	}	
	
	function gridListColTextColorChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "APSTNM"){
				var type = gridList.getColData(gridId, rowNum, "APRSTS");
				switch (type) {
				case "CMP":
					return "cmp";
					break;
				case "REQ":
					return "req";
					break;
				case "NOT":
					return "not";
					break;
				case "END":
					return "end";
					break;	
				default:
					return "init";
					break;
				}
			}
		}
	}
	
	function changeDiffSelect(){
		var value = $("#DIFFSR").val();
		
		var param = inputList.setRangeDataMultiParam("searchArea");
		param.put("APRKEY",gridList.getColData("gridHeadList", gridList.getFocusRowNum("gridHeadList"), "APRKEY"));
		param.put("DIFFSR",value);
		
		gridList.gridList({
	    	id : "gridItemList",
	    	param : param
	    });
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="SaveApproval SAVE BTN_APPROVAL"></button>
		<button CB="SaveRejected DELETE BTN_REJECTED"></button>
	</div>
</div>

<!-- content -->
<div class="content" id="contentWrap">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
	
			<div class="bottomSect top" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_APLIST"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							
							<div class="reflect" id="reflect">
								결제의견
								<input type="text" name="requestText" UIFormat="S 30" style="width: 395px;" />
							</div>
							
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="80 STD_WAREKY"     GCol="text,WARENM,center"></td>
												<td GH="80 STD_APSTUS"     GCol="text,APSTNM,center"></td>
												<td GH="100 STD_PHYDAT"    GCol="text,DOCDAT,center" GF="D"></td>
												<td GH="100 STD_PHYIKY"    GCol="text,APRKEY,center"></td>
												<td GH="140 STD_PHSCTY"    GCol="text,PHSCNM"></td>
												<td GH="250 STD_PREQTX"    GCol="text,REQTXT"></td>
												<td GH="100 STD_REQDAT"    GCol="text,REQDAT,center"  GF="D"></td>
												<td GH="100 STD_REQTIM"    GCol="text,REQTIM,center"  GF="T"></td>
												<td GH="100 STD_REQUSR"    GCol="text,REQUSR"></td>
												<td GH="100 STD_RUSRNM"    GCol="text,REQUNM"></td>
												<td GH="250 STD_APRTXT"    GCol="text,APRTXT"></td>
												<td GH="100 STD_APRDAT"    GCol="text,APRDAT,center"  GF="D"></td>
												<td GH="100 STD_APRTIM"    GCol="text,APRTIM,center"  GF="T"></td>
												<td GH="100 STD_APRUSR"    GCol="text,APRUSR"></td>
												<td GH="100 STD_AUSRNM"    GCol="text,APRUNM"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 그리드 -->
			<div class="bottomSect bottom">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_DETAIL"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="reflect">
								<span CL="STD_DIFFSR" style="margin-right: 10px;color: #000;"></span>
								<select id="DIFFSR" name="DIFFSR" style="width:160px" onchange="changeDiffSelect();">
									<option value=""  CL="STD_ALL"></option>
									<option value="Y">Y</option>
									<option value="N">N</option>
								</select>
							</div>
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"  GCol="rownum">1</td>
												<td GH="100 STD_AREAKY" GCol="text,AREANM"></td>
												<td GH="100 STD_ZONEKY" GCol="text,ZONEKY,center"></td>
												<td GH="120 STD_ZONENM" GCol="text,ZONENM"></td>
												<td GH="100 STD_LOCAKY" GCol="text,LOCAKY,center"></td>
												<td GH="100 STD_LOTA06" GCol="text,LT06NM,center"></td>
												<td GH="130 STD_SKUKEY" GCol="text,SKUKEY"></td>
												<td GH="250 STD_DESC01" GCol="text,DESC01"></td>
												<td GH="100 STD_ORDQTY" GCol="text,QTSIWH" GF="N 20,3"></td>
												<td GH="100 STD_PHIQTY" GCol="text,QTSPHY" GF="N 20,3"></td>
												<td GH="100 STD_DIFQTY" GCol="text,DIFQTY" GF="N 20,3"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
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