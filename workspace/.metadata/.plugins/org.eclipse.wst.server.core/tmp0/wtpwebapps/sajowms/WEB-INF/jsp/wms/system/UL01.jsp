<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<style>
.gridIcon-center{text-align: center;}
.impflg{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.regAft{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn23.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
</style>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript">
midAreaHeightSet = "200px";
var flag;
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			module : "System",
			command : "UL01H",
			itemGrid : "gridItemList",
			itemSearch : true,
			emptyMsgType : false
		});
		
		gridList.setGrid({
			id : "gridItemList",
			module : "System",
			command : "UL01I",
			pkcol : "USRTYP,USERID,NMLAST,SNDTXT",
			emptyMsgType : false
		});
		
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){ //조회
			searchList();
			
		}else if( btnName == "Save" ){ //저장
			saveData();
			
		}
	}
	
	//조회
	function searchList(){
		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridItemList");
		
		var param = inputList.setRangeParam("searchArea");
		
		gridList.gridList({
			id : "gridHeadList",
			param : param
		});
	}
	
	// 공통 itemGrid 조회 및 / 더블 클릭 Event
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if( gridId == "gridHeadList" ){
			if( gridList.getColData("gridHeadList", rowNum, "STATUS") == "C" ){
				return false;
			}
			
			var rowData = gridList.getRowData("gridHeadList", rowNum);
			rowData.put("WAREKY", "<%=wareky%>");
			
			gridList.gridList({
				id : "gridItemList",
				param : rowData
			});
		}
	}
	
	//저장
	function saveData(){
		if( gridList.validationCheck("gridItemList", "modify") ){
			var head = gridList.getRowData("gridHeadList", gridList.getFocusRowNum("gridHeadList"));
			var item = gridList.getModifyList("gridItemList", "A");
			
			if( item.length == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return false;
			}
			
			// 이메일, 전화번호형식 확인
			var sandType = head.get("SNDTYP");
			var mail = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			var tel = /^01(?:0|1|[6-9])-(?:\d{3}|\d{4})-\d{4}$/;
			for( var i=0; i<item.length; i++ ){
				var sndtxt = item[i].get("SNDTXT");
				
				if( sandType == "MAIL" ){
					if( !mail.test(sndtxt) ){
						alert("메일형식에 맞지 않습니다.");
						return false;
					}
					
				}else if( sandType == "SNS" ){
					if( !tel.test(sndtxt) ){
						alert("전화번호 형식에 맞지 않습니다. ex) 000-0000-0000");
						return false;
					}
				}
			}
			
			// 저장, 수정, 삭제
			var param = new DataMap();
			param.put("item", item);
			
			netUtil.send({
				url : "/wms/system/json/saveUL01.data",
				param : param,
				successFunction : "successFunction"
			});
			
			
		}
	}
	
	function successFunction(json,status){
		if( json && json.data ){
//			commonUtil.msgBox("MASTER_M0564");
		alert("저장이 완료되었습니다.");
		searchList();
		}
	}
	
	
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if( gridId == "gridItemList" ){
			var rowUsrtyp = gridList.getColData(gridId, rowNum, "USRTYP");
			if( colName != "USRTYP" && $.trim(rowUsrtyp) == "" ){
				alert("전송자타입을 선택해주세요.");
				gridList.setColValue(gridId, rowNum, colName, "");
				return false;
			}
			
			if( colName == "USERID" ){
				var param = new DataMap();
				param.put("USERID", colValue);
				param.put("USRTYP", rowUsrtyp);
				
				var json = netUtil.sendData({
					module : "System",
					command : "USRMAINFO",
					sendType : "map",
					param : param
				});
			
				if( !json.data ) {
					alert("등록된 사용자가 존재하지 않습니다.");
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "NMLAST", "");
					gridList.setColValue(gridId, rowNum, "SNDTXT", "");
//	 				commonUtil.msgBox("SYSTEM_M0013"); //사용중인 권한키는 삭제할 수 없습니다.
					return false;
				}else{
					gridList.setColValue(gridId, rowNum, "NMLAST", json.data.NMLAST);
					gridList.setColValue(gridId, rowNum, "SNDTXT", json.data.SNDTXT);
				}
				
				
			}else if( colName == "USRTYP" ){
				
				gridList.setColValue(gridId, rowNum, "USERID", "");
				gridList.setColValue(gridId, rowNum, "NMLAST", "");
				gridList.setColValue(gridId, rowNum, "DELMAK", "");
				gridList.setColValue(gridId, rowNum, "SNDTXT", "");
				
				if( colValue == "0" ){
					gridList.setRowReadOnly(gridId, rowNum, false, ["USERID"]);
					gridList.setRowReadOnly(gridId, rowNum, true, ["NMLAST", "SNDTXT"]);
					
				}else if( colValue == "1" ){
					gridList.setRowReadOnly(gridId, rowNum, false, ["NMLAST", "SNDTXT"]);
					gridList.setRowReadOnly(gridId, rowNum, true, ["USERID"]);
					
				}else if( $.trim(colValue) == "" ){
					gridList.setRowReadOnly(gridId, rowNum, false, ["USERID", "NMLAST", "SNDTXT"]);
				}
				
				
			}
		}
	}
	
	// 그리드 로우 추가 이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		var headCnt = gridList.getGridDataCount("gridHeadList");
		if( headCnt == 0 ){
			alert("조회된 데이터가 없습니다.");
			return false;
		}
		
		var headRowData = gridList.getRowData("gridHeadList", gridList.getFocusRowNum("gridHeadList"));
		var newData = new DataMap();
		newData.put("SENDID", headRowData.get("SENDID"));
		newData.put("SNDTYP", headRowData.get("SNDTYP"));
		return newData;
	}
	
	//로우 삭제시 권한키 사용여부 확인
	function gridListEventRowRemove(gridId, rowNum){
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
	}
	
	// 데이터 바인드 이후
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength <= 0 ){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//그리드 아이콘 변경
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if( gridId == "gridHeadList" && colName == "DELMAK" ){
			if( colValue == "V" ){
				return "regAft";
			}else if($.trim(colValue) == ""){
				return "impflg";
			}
		}
	}
	
	//콤보 체인지 이벤트
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			
			if( name == "USRTYP" ){
				param.put("CODE", "USRTYP");
				
			}else if( name == "SENDID" ){
				param.put("CODE","SENDID");
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
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect top" style="height:70px" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="100" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_SENDID"></th>
											<td>
												<select Combo="Common,COMCOMBO" ComboCodeView=false name="SENDID">
													<option value="">전체</option>
												</select>
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottom" style="top:110px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_GENERAL'></span></a></li>
					</ul>
					<div id="tabs1-1"> 
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"    GCol="rownum">1</td>
												<td GH="250 STD_SENDID"   GCol="text,SENDNM"></td>
												<td GH="100 STD_SENDEL"   GCol="icon,DELMAK" GB="regAft"></td>
												<td GH="100 STD_SNDTYP"   GCol="text,SNDTYP"></td>
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
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea2">
						<li><a href="#tabs1-1"><span CL='STD_DETAIL'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"       GCol="rownum">1</td>
												<td GH="100 STD_USRTYP"      GCol="select,USRTYP"  validate="required">
													<select Combo="Common,COMCOMBO" name="USRTYP">
														<option value="">선택</option>
													</select>
												</td>
												<td GH="100 STD_USERID"      GCol="input,USERID,SHROLCT" GF="S 20"></td>
												<td GH="100 STD_NMLAST"      GCol="input,NMLAST"></td>
												<td GH="100 STD_SENDEL,3"    GCol="check,DELMAK"></td>
												<td GH="230 STD_SENDTG"      GCol="input,SNDTXT"></td>
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
<!-- 									<button type="button" GBtn="total"></button> -->
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
		<!-- //contentContainer -->
	</div>
</div>

<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>