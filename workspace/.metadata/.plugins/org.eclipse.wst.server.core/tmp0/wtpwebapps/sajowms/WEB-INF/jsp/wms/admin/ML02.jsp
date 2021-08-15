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
			command : "ML01",
			pkcol: "ZONEKY,LOCAKY"
		});
		
		
		var $comboList = $('#searchArea').find("select[Combo]");
		inputList.setMultiComboSelectAll($("#AREAKY"), true);
		gridList.appendCols("gridList", ["WAREKY"]);
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
			gridList.setReadOnly("gridList", true, ["AREAKY", "MNGMOV", "LOTA06"]);
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
			var grid = gridList.getModifyList("gridList", "A");
			var gridLen = grid.length;
			
			if( gridLen == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return;
			}
			
			var lota06, mngmov;
			for(var i=0; gridLen>i; i++){
				lota06 = grid[i].get("LOTA06")
				mngmov = grid[i].get("MNGMOV")
				
				if( $.trim(lota06) == "" ){
					if( mngmov == "0" || mngmov == "3" ){
						commonUtil.msgBox("MASTER_M4008"); //재고상태를 선택해주세요.
						return;
					}
				}
			}
			
			var param = new DataMap();
			param.put("grid", grid);
			param.put("proId", "ML02");
			
			netUtil.send({
				url : "/wms/admin/json/saveML01.data",
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
	
	//그리드 로우 추가 이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		gridList.setReadOnly("gridList", false, ["MNGMOV"]);
		
		var newData = new DataMap();
		newData.put("WAREKY", "<%=wareky%>");
		newData.put("NAME01", wms.getTypeName(gridId, "WAHMA", "<%=wareky%>", "NAME01"));
		
		return newData;
	}
	
	//그리드 로우 삭제 이벤트
	function gridListEventRowRemove(gridId, rowNum){
		
		var loc = gridList.getColData(gridId, rowNum, "LOCAKY");
		
		if( gridId == "gridList" ){
			var param = new DataMap();
			param.put("WAREKY", "<%=wareky%>");
			param.put("LOCAKY", loc);
			param.put("LOADCD", loc);
			param.put("LOADTP", "L");
			
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "SKUKEYCHK",
				sendType : "list",
				param : param
			});
			
			if( json.data.length > 0 ){
				if( json.data[0].SKU == "Y" ){
					commonUtil.msgBox("MASTER_M4007", loc); //로케이션  [{0}]는 상품이 할당되어있기 때문에 삭제불가합니다.
					return false;
					
				}else if( json.data[0].QTS == "Y" ){
					commonUtil.msgBox("MASTER_M4006", loc); //로케이션 [{0}]에 재고가 존재하여 삭제불가합니다.
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
					commonUtil.msgBox("MASTER_M5011", loc); //적재기준에서 사용중인 로케이션[ {0} ]는 삭제할 수 없습니다.
					return false;
					
				}
			}
			
			// 입고전략 존재여부 확인
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "PASTIchk",
				sendType : "map",
				param : param
			});
			
			if( json && json.data ){
				if( json.data["CNT"] >= 1 ){
					commonUtil.msgBox("MASTER_M5012", loc); //입고전략에서 사용중인 로케이션[ {0} ]은 삭제할 수 없습니다.
					return false;
					
				}
			}
			
			// 문서 존재여부 확인
			var json = netUtil.sendData({
				module : "WmsAdmin",
				command : "DOCTMchk",
				sendType : "map",
				param : param
			});
			
			if( json && json.data ){
				if( json.data["CNT"] >= 1 ){
					commonUtil.msgBox("MASTER_M5013", loc); //문서에 연결되어 있는 로케이션은 삭제할 수 없습니다.
					return false;
					
				} else if ( json.data["CNT"] < 1 ){
					return true;
				}
			}
		}
	}
	
	//그리드 컬럼변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if( gridId == "gridList" ){
			if( colName == "ZONEKY" ){
				var param = new DataMap();
				param.put("WAREKY","<%=wareky%>");
				param.put("ZONEKY", colValue);
				param.put("USARG2", "SYST");
				
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "ZONECLOSE",
					sendType : "list",
					param : param
				});
				
				if( json.data.length > 0 ) {
					gridList.setColValue(gridId, rowNum, "AREAKY", json.data[0].AREAKY);
					param.put("AREAKY", json.data[0].AREAKY);
					
				}else if( json.data.length == 0 ){
					commonUtil.msgBox("MASTER_M0044"); //존재하지 않는 존입니다.
					gridList.setColValue(gridId, rowNum, colName, "");
					return false;
				}
				
				
				//AREA가 시스템인지 아닌지 확인
				var AREAjson = netUtil.sendData({
					module : "WmsAdmin",
					command : "AREATYCMCDW",
					sendType : "list",
					param : param
				});
				
				if( AREAjson.data.length == 0 ) {
					commonUtil.msgBox("MASTER_M4016"); //일반  존 입니다. 시스템 존으로 변경해주세요.
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "AREAKY", "");
					gridList.setColValue(gridId, rowNum, "LOCATY", "");
					return false;
				}
				
			}else if( colName == "LOCAKY" ){
				var param = new DataMap();
				param.put("WAREKY","<%=wareky%>");
				param.put("LOCAKY", colValue);
				
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "LOCAKYCHK",
					sendType : "map",
					param : param
				});
				
				if( json.data["CNT"] > 0 ) {
					commonUtil.msgBox("MASTER_M4005", colValue); //[{0}]는 이미 존재하는 로케이션입니다.
					gridList.setColValue(gridId, rowNum, "LOCAKY","");
					gridList.setColValue(gridId, rowNum, "SHORTX","");
					
					return;
				}
				
			}else if( colName == "MNGMOV" ){
				if( $.trim(colValue) == "0" || $.trim(colValue) == "3" ){
					gridList.setRowReadOnly(gridId, rowNum, false, ["LOTA06"]);
					return false;
				}else{
					gridList.setRowReadOnly(gridId, rowNum, true, ["LOTA06"]);
					gridList.setColValue(gridId, rowNum, "LOTA06", "");
					return false;
				}
				
			}
		}
		
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			return param;
			
		}else if( comboAtt == "WmsAdmin,AREACOMBO" ){
			//검색조건 AREA 콤보
			param.put("USARG1", "SYST");
			
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			
			if( name == "LOTA06" ){
				param.put("CODE","LOTA06");
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
// 				param.put("USARG1", "SYST");

			}else if( name == "MNGMOV" ){
				param.put("CODE","MNGMOV");

			}
			
			
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
											<th CL="STD_AREAKY">area</th>
											<td>
												<select id="AREAKY" name="L.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" validate="required(STD_AREAKY)" UISave="false" ComboCodeView=false style="width:160px">
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
												<td GH="100 STD_WAREKY"     GCol="text,NAME01"></td>
												<td GH="100 STD_AREAKY"     GCol="select,AREAKY">
													<select Combo="WmsAdmin,AREACOMBO" ComboCodeView=false>
														<option value=""></option>
													</select>
												</td>
												<td GH="100 STD_ZONEKY"     GCol="input,ZONEKY,SHZONMA" GF="U"    validate="required"></td>
												<td GH="100 STD_LOCAKY"     GCol="input,LOCAKY"         GF="U 10" validate="required"></td>
												<td GH="100 STD_LOCAKYNM"   GCol="input,SHORTX"         GF="S 20" validate="required"></td>
												<td GH="100 STD_AVLWMS"     GCol="check,AVLSTK"></td>
												<td GH="100 STD_AVLBOS"     GCol="check,AVLBOS"></td>
												<td GH="100 STD_AVLECM"     GCol="check,AVLEHQ"></td>
												<td GH="100 STD_MNGMOV"     GCol="select,MNGMOV">
													<select Combo="Common,COMCOMBO"  name="MNGMOV" ComboCodeView=false validate="required">
														<option value="">선택</option>
													</select>
												</td>
												<td GH="100 STD_MNGLT9"     GCol="check,MNGLT9"></td>
<!-- 												<td GH="100 STD_MNGLT6"     GCol="check,MNGLT6"></td> -->
												<td GH="100 STD_LOTA06"     GCol="select,LOTA06">
													<select Combo="Common,COMCOMBO"  name="LOTA06" ComboCodeView=false>
														<option value="">유지</option>
													</select>
												</td>
												<td GH="100 STD_CREDAT"     GCol="text,CREDAT"   GF="D"></td>
												<td GH="100 STD_CRETIM"     GCol="text,CRETIM"   GF="T"></td>
												<td GH="100 STD_CREUSR"     GCol="text,CREUSR"></td>
												<td GH="100 STD_CUSRNM"     GCol="text,CUSRNM"></td>
												<td GH="100 STD_LMODAT"     GCol="text,LMODAT"   GF="D"></td>
												<td GH="100 STD_LMOTIM"     GCol="text,LMOTIM"   GF="T"></td>
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