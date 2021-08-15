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
			module : "WmsAdmin",
			command : "AREMA",
			selectRowDeleteType : false,
			autoCopyRowType : false
// 			pkcol : "WAREKY,AREAKY",
		});
		
		gridList.appendCols("gridList", ["WAREKY"]);
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if( btnName == "Search" ){
			searchList();
			
		}else if( btnName == "Save" ){
			saveData();
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			gridList.setReadOnly("gridList", true, ["AREAKY", "AREATY"]);
			
			var param = inputList.setRangeParam("searchArea");
			param.put("AREATY", "SYST");
			
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
			
			if( head.length == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return;
			}
			
			var param = new DataMap();
			param.put("head", head);
			
			netUtil.send({
				url : "/wms/admin/json/saveMA01.data",
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
	
	// 그리드 로우 추가 이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		
		gridList.setReadOnly("gridList", false, ["AREAKY", "AREATY"]);
		
		var newData = new DataMap();
		newData.put("WAREKY", "<%=wareky%>");
		newData.put("NAME01", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
		
		return newData;
	}
	
	// 그리드 로우 삭제시 zone 여부 체크 이벤트
	function gridListEventRowRemove(gridId, rowNum){
		var areaky = gridList.getColData(gridId, rowNum,"AREAKY");
		var param = new DataMap();
		param.put("WAREKY","<%=wareky%>");
		param.put("AREAKY", areaky);
		param.put("LOADCD", areaky);
		param.put("LOADTP", "A");
		
		var json = netUtil.sendData({
			module : "WmsAdmin",
			command : "ZONEKYchk",
			sendType : "map",
			param : param
		});
		
		if( json && json.data ){
			if( json.data["CNT"] >= 1 ){
				commonUtil.msgBox("VALID_M9266"); //지정된 AREA에 존이 존재하여 삭제할 수 없습니다.
				return false;
				
			}
		}
		
		// 적재기준 존재여부 확인
		var json = netUtil.sendData({
			module : "WmsAdmin",
			command : "LOADMchk",
			sendType : "map",
			param : param
		});
		
		if( json && json.data ){
			if( json.data["CNT"] >= 1 ){
				commonUtil.msgBox("MASTER_M5009", areaky); //적재기준에서 사용중인 AREA[ {0} ]는 삭제할 수 없습니다.
				return false;
				
			} else if ( json.data["CNT"] < 1 ){
				return true;
			}
		}
		
	}
	
	// 그리드 area 명 변경시 validation
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var param = new DataMap();
		param.put("WAREKY","<%=wareky%>");
		
		if( gridId == "gridList" && colName == "AREAKY" ){
			param.put("AREAKY", colValue);
			
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "AREMAval",
				sendType : "map",
				param : param
			});
			
			if( json && json.data ){
				if( json.data["CNT"] >= 1 ){
					commonUtil.msgBox("VALID_M9268",colValue); //[{0}]는 이미 존재하는 AREA 입니다.
					gridList.setColValue(gridId, rowNum, colName, "");
					return false;
					
				} else if ( json.data["CNT"] < 1 ){
					return true;
				}
			}
			
		}else if( gridId == "gridList" && colName == "SORTSQ" ){
			param.put("SORTSQ", colValue);
			param.put("AREATY", "SYST");
			
			if( colValue < 0 ){
				alert("음수는 입력 불가합니다.");
				gridList.setColValue(gridId, rowNum, colName, "");
				return false;
			}
			
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "AREASORTCNT",
				sendType : "count",
				param : param
			});
			
			if( json && json.data ){
				console.log(json);
				if( json.data >= 1 ){
					alert("중복된 정렬순서입니다.");
					gridList.setColValue(gridId, rowNum, colName, "");
					return false;
					
				} else if ( json.data < 1 ){
					return true;
				}
			}
		}
		
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			
			param.put("WARECODE","Y"); //시스템일경우 Y 넘김
			param.put("WAREKY","<%=wareky%>");
			param.put("CODE", "AREATY");
			param.put("USARG1", "SYST");
			
			return param;
			
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
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
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
												<td GH="100 STD_WAREKYNM"   GCol="text,NAME01"></td>
												<td GH="100 STD_AREAKY"     GCol="input,AREAKY" GF="U 5"  validate="required"></td>
												<td GH="100 STD_AREANM"     GCol="input,SHORTX" GF="S 10" validate="required"></td>
												<td GH="100 STD_SORTSQ"     GCol="input,SORTSQ" GF="N 3"  validate="required"></td>
												<td GH="150 STD_AREATY,3"   GCol="select,AREATY" validate="required">
													<select Combo="Common,COMCOMBO" ComboCodeView=false>
														<option value="">선택</option>
													</select>
												</td>
												<td GH="100 STD_CREDAT"     GCol="text,CREDAT"  GF="D"></td>
												<td GH="100 STD_CRETIM"     GCol="text,CRETIM"  GF="T"></td>
												<td GH="100 STD_CREUSR"     GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM"     GCol="text,CUSRNM"></td>
												<td GH="100 STD_LMODAT"     GCol="text,LMODAT"  GF="D"></td>
												<td GH="100 STD_LMOTIM"     GCol="text,LMOTIM"  GF="T"></td>
												<td GH="100 STD_LMOUSR"     GCol="text,LMOUSR"></td>
												<td GH="100 STD_LUSRNM"     GCol="text,LUSRNM"></td>
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