<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">

	$(document).ready(function(){
		setTopSize(80);
		gridList.setGrid({
			id : "gridList",
			name : "gridList",
			editable : true,
			module : "WmsApproval",
			command : "AP01",
			selectRowDeleteType : false, 
			autoCopyRowType : false
		});
		
		inputList.setMultiComboSelectAll($("#WAREKY"), true);
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
			
		}else if( btnName == "Save" ){
			saveData();
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
			
		}
	}
	
	//저장
	function saveData(){
		if( gridList.validationCheck("gridList", "modify") ){
			var head = gridList.getModifyList("gridList", "A");
			var headLen = head.length;
			
			if( headLen == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return;
			}
			
			// 수임자 리스트 유무 체크
			var chk = new DataMap();
			for(var i=0; headLen>i; i++){
				chk.put("WAREKY", head[i].get("WAREKY"));
				
				var json = netUtil.sendData({
					module : "WmsApproval",
					command : "APUSR_M",
					sendType : "list",
					param : chk
				});
				
				if( json && json.data ){
					var jsonLen = json.data.length;
					if( jsonLen >= 1 ){
						if(!commonUtil.msgConfirm("AP_M0002")){ //변경하려는 물류센터의 수임자가 존재합니다. 진행하시겠습니까?
							return;
						}
						
					} else if ( jsonLen < 1 ){
						break;
					}
				}
			}
			
			//저장,수정,삭제
			var param = new DataMap();
			param.put("head", head);
			
			netUtil.send({
				url : "/wms/approval/json/saveAP01.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	

	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0815", json.data);
			searchList();
		}
	}
	
	// 서치헬프 오픈 이벤트
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();
		
		if( searchCode == "SHROLCT" ){
			var grid = gridList.getRowData("gridList", rowNum);
			param.put("WAREKY", grid.get("WAREKY"));
			return param;
		}
	}
	
	// 서치헬프 종료 이벤트
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		if( searchCode == "SHROLCT" ){
			gridList.setColValue("gridList", gridList.getFocusRowNum("gridList"), "USERNM", rowData.get("NMLAST"));
			
		}
	}
	
	// 그리드 결제권자ID 변경시 validation
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if( gridId == "gridList" && colName == "USERID" ){
			
			if( $.trim(colValue) == "" ){
				gridList.setColValue(gridId, rowNum, "USERNM", " ");
				return;
			}
			
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = new DataMap();
			param.put("WAREKY", rowData.get("WAREKY"));
			param.put("USERID", colValue);
			
			var json = netUtil.sendData({
				module : "WmsApproval",
				command : "ROLCTval",
				sendType : "list",
				param : param
			});
			
			if( json && json.data ){
				var jsonLen = json.data.length;
				if( jsonLen == 0 ){
					commonUtil.msgBox("AP_M0001", colValue); //[{0}]는 등록되지 않거나 권한이 없는 사용자ID입니다.
					gridList.setColValue(gridId, rowNum, colName, " ");
					gridList.setColValue(gridId, rowNum, "USERNM", " ");
					return false;
					
				} else if ( jsonLen >= 1 ){
					gridList.setColValue(gridId, rowNum, "USERNM", json.data[0].NMLAST);
					return;
				}
			}
			
		}
		
	}
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
	</div>
<!-- 	<div class="util2"> -->
<!-- 		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button> -->
<!-- 	</div> -->
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
										<col width="100" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WH.WAREKY" Combo="WmsApproval,WAERECOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 그리드 -->
			<div class="bottomSect bottom">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_GENERAL'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"      GCol="rownum">1</td>
<!-- 												<td GH="100 STD_WAREKY"     GCol="text,WAREKY"></td> -->
												<td GH="100 STD_WAREKY"     GCol="text,NAME01"></td>
												<td GH="100 STD_APUSRID"    GCol="input,USERID,SHROLCT" GF="S 20"  validate="required"></td>
												<td GH="100 STD_APUERNM"    GCol="text,USERNM"></td>
												<td GH="100 STD_CREDAT"     GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_CRETIM"     GCol="text,CRETIM"  GF="T"></td>
												<td GH="100 STD_CREUSR"     GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM"     GCol="text,CUSRNM"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">	
									<button type="button" GBtn="find"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
<!-- 									<button type="button" GBtn="delete"></button> -->
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
			
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>