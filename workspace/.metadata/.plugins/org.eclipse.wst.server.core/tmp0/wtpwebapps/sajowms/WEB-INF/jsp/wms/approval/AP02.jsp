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
		
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsApproval",
			command : "AP02H",
			excelRequestGridData : true 
		});
		
		gridList.setGrid({
			id : "gridItemList",
			name : "gridItemList",
			editable : true,
			module : "WmsApproval",
			command : "AP02I",
			selectRowDeleteType : false,
			autoCopyRowType : false,
			emptyMsgType : false
		});
		
		gridList.appendCols("gridItemList", ["DELMAK"]);
		
		// 결재권자id와 로그인 id 같을때 활성화
		uiList.setActive("Save", false);
		gridList.setBtnActive("gridItemList", configData.GRID_BTN_ADD, false);
		gridList.setBtnActive("gridItemList", configData.GRID_BTN_DELETE, false);
		
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
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		gridList.gridList({
			id : "gridHeadList",
			param : param
		});
		
		gridList.gridList({
			id : "gridItemList",
			param : param
		});
		
		gridList.setReadOnly("gridItemList", true, ["USERID", "APFDAT", "APTDAT"]);
		gridList.setReadOnly("gridItemList", false, ["DELMAK"]);
	}
	
	
	
	//저장
	function saveData(){
		if( gridList.validationCheck("gridItemList", "modify") ){
			var head = gridList.getModifyList("gridItemList", "A");
			
			if( head.length == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return;
			}
			
			//저장,수정,삭제
			var param = new DataMap();
			param.put("head", head);
			param.put("USERID", "<%=userid%>");
			param.put("WAREKY", "<%=wareky%>");
			
			netUtil.send({
				url : "/wms/approval/json/saveAP02.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			commonUtil.msgBox(json.data["resultMsg"]);
			searchList();
		}
	}
	
	// 서치헬프 오픈 이벤트
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();
		
		if( searchCode == "SHROLCT" ){
			param.put("WAREKY", "<%=wareky%>");
			return param;
		}
	}
	
	// 서치헬프 종료 이벤트
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		if( searchCode == "SHROLCT" ){
			var gridId = "gridItemList";
			var rowNum = gridList.getFocusRowNum(gridId);
			var gridData = gridList.getRowData(gridId, rowNum);
			
			if( $.trim(gridData.get("USERID")) == "" ){
				gridList.setColValue(gridId, rowNum, "AUSRNM", " ");
				return;
			}
			
			gridList.setColValue(gridId, rowNum, "AUSRNM", rowData.get("NMLAST"));
			
		}
	}
	
	// 그리드 로우 추가 이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		
		gridList.setReadOnly("gridItemList", false, ["USERID", "APFDAT", "APTDAT"]);
		gridList.setRowReadOnly("gridItemList", rowNum, true, ["DELMAK"]);
		
		var newData = new DataMap();
		newData.put("WAREKY", "<%=wareky%>");
		newData.put("NAME01", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
		
		return newData;
	}
	
	// 그리드 로우 삭제 이벤트
	function gridListEventRowRemove(gridId, rowNum){
		var rowData = gridList.getRowData(gridId, rowNum);
		
		if( rowData.get("GRowState") != "C" ){
			commonUtil.msgBox("AP_M0004"); //저장하지 않은 수임자 건만 삭제 가능합니다. 위임종료 선택 후 저장해주세요.
			return false;
		}
		
	}
	
	
	// 그리드 결제권자ID 변경시 validation
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var itemRowData = gridList.getRowData("gridItemList", rowNum);
		
		if( gridId == "gridItemList" && colName == "USERID" ){
			
			if( $.trim(colValue) == "" ){
				gridList.setColValue(gridId, rowNum, "AUSRNM", " ");
				return;
			}
			
			//결재권자 동일여부
			var headGridId = "gridHeadList";
			var headRowNum = gridList.getFocusRowNum(headGridId);
			var headId = gridList.getRowData(headGridId, headRowNum);
			if( colValue == headId.get("USERID") ){
				commonUtil.msgBox("AP_M0003"); //수임자는 결재권자와 같을 수 없습니다.
				gridList.setColValue(gridId, rowNum, "USERID", " ");
				gridList.setColValue(gridId, rowNum, "AUSRNM", " ");
				return;
			}
			
			//권한확인
			var param = new DataMap();
			param.put("WAREKY", itemRowData.get("WAREKY"));
			param.put("USERID", colValue);
			
			var json = netUtil.sendData({
				module : "WmsApproval",
				command : "ROLCTval",
				sendType : "list",
				param : param
			});
			
			if( json && json.data ){
				if( json.data.length == 0 ){
					commonUtil.msgBox("AP_M0001",colValue); //[{0}]는 등록되지 않거나 권한이 없는 사용자ID입니다.
					gridList.setColValue(gridId, rowNum, colName, " ");
					gridList.setColValue(gridId, rowNum, "AUSRNM", " ");
					return false;
					
				} else if ( json.data.length >= 1 ){
					gridList.setColValue(gridId, rowNum, "AUSRNM", json.data[0].NMLAST);
					return;
				}
			}
			
		}else if( gridId == "gridItemList" && colName == "APFDAT" ){
			gridList.setColValue(gridId, rowNum, "APTDAT", " ");
			
			var param = new DataMap();
			param.put(colName, colValue);
			
			var json = netUtil.sendData({
				module : "WmsApproval",
				command : "TODATE",
				sendType : "list",
				param : param
			});
			
			if( json && json.data ){
				if( json.data[0].VALID == "Y" ){
					commonUtil.msgBox("AP_M0005"); //위임시작일자는 오늘날짜보다 커야합니다.
					gridList.setColValue(gridId, rowNum, colName, " ");
					gridList.setColValue(gridId, rowNum, "APTDAT", " ");
					return false;
				}
			}
			
			
		}else if( gridId == "gridItemList" && colName == "APTDAT" ){
			
			//위임시작일자부터 입력
			var apfdat = itemRowData.get("APFDAT");
			if( $.trim(apfdat) == "" ){
				commonUtil.msgBox("AP_M0006"); //위임시작일자를 입력해주세요.
				gridList.setColValue(gridId, rowNum, colName, " ");
				return;
			}
			
			var param = new DataMap();
			param.put("APFDAT", apfdat);
			param.put("APTDAT", colValue);
			
			var json = netUtil.sendData({
				module : "WmsApproval",
				command : "BETWEENDATE",
				sendType : "list",
				param : param
			});
			
			//일자체크
			if( json && json.data ){
				if( json.data[0].DAY > 16 ){
					commonUtil.msgBox("AP_M0008"); //위임시작일자부터 16일 이내로 입력해주세요.
	 				gridList.setColValue(gridId, rowNum, colName, " ");
					return false;
					
				}else if( json.data[0].UPFROM == "N" ){
					//위임시작일보다 커야함
					commonUtil.msgBox("AP_M0007"); //위임시작일자보다 커야합니다.
					gridList.setColValue(gridId, rowNum, colName, " ");
					return false;
				}
			}
			
		}
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength > 0 ){
			
			var gridUser = gridList.getColData(gridId, 0, "USERID");
			var loginId = "<%=userid%>";
			if( gridUser == loginId ){
				uiList.setActive("Save", true);
				gridList.setBtnActive("gridItemList", configData.GRID_BTN_ADD, true);
				gridList.setBtnActive("gridItemList", configData.GRID_BTN_DELETE, true);
				
			}else{
				uiList.setActive("Save", false);
				gridList.setBtnActive("gridItemList", configData.GRID_BTN_ADD, false);
				gridList.setBtnActive("gridItemList", configData.GRID_BTN_DELETE, false);
			}
			
		}else if( gridId == "gridHeadList" && dataLength <= 0){
			gridList.resetGrid("gridItemList");
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
			<div class="bottomSect top">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_APUERNM'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"     GCol="rownum">1</td>
												<td GH="100 STD_WAREKY"    GCol="text,NAME01"></td>
												<td GH="100 STD_APUSRID"   GCol="text,USERID"></td>
												<td GH="100 STD_APUERNM"   GCol="text,AUSRNM"></td>
												<td GH="100 STD_CREDAT"    GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_CRETIM"    GCol="text,CRETIM"  GF="T"></td>
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
			<div class="bottomSect bottom">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_ASUBNM'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"     GCol="rownum">1</td>
<!-- 												<td GH="40"                GCol="rowCheck"></td> -->
												<td GH="100 STD_ASUBID"    GCol="input,USERID,SHROLCT" GF="S 20" validate="required"></td>
												<td GH="100 STD_ASUBNM"    GCol="text,AUSRNM"></td>
												<td GH="100 STD_ASUBFDT"   GCol="input,APFDAT" GF="C" validate="required"></td>
												<td GH="100 STD_ASUBTDT"   GCol="input,APTDAT" GF="C" validate="required"></td>
												<td GH="100 STD_SUBFIN"    GCol="check,DELMAK"></td>
												<td GH="100 STD_CREDAT"    GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_CRETIM"    GCol="text,CRETIM"  GF="T"></td>
												
												
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">	
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>
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