<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript" src="/wms/js/wms.js"></script>
<script type="text/javascript">

	var searchCnt = 0; 
	var dblIdx = -1;
	var sFlag = true;
	
	$(document).ready(function(){
		setTopSize(200);
		gridList.setGrid({
	    	id : "gridListHead",
	    	name : "gridListHead",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "EBELN",
			module : "WmsInbound",
			command : "GR00"
	    });
		
		gridList.setGrid({
	    	id : "gridListSub",
	    	name : "gridListSub",
			editable : true,
			checkHead : "gridListSubCheckHead",
			pkcol : "RECVKY,RECVIT",
			module : "WmsInbound",
			command : "GR00Sub"
	    });
	});
	
	
	function searchList(){
		//var param = dataBind.paramData("searchArea");
		if(validate.check("searchArea")){
			
			sFlag = true;
			
			var param = inputList.setRangeParam("searchArea");
			//alert(param);
			gridList.gridList({
		    	id : "gridListHead",
		    	param : param
		    });
			
			gridList.gridList({
				id : "gridListSub",
				param : param
			});
			//searchOpen(false);
			
		}
	}


	function gridListEventDataBindEnd(gridId, dataLength){
		
		if(sFlag){
			if( gridId == "gridListHead" && dataLength > 0  ){
				//alert(" gridId : " + gridId + "\n dataLength : " + dataLength);
				searchSubList(0);
			}
		}
	}
	
	
	function searchSubList(headRowNum){
		//alert("headRowNum :" + headRowNum);
		//var data = gridList.getRowData("gridList", headRowNum);
		var param = inputList.setRangeParam("searchArea");
		
		gridList.gridList({
			id : "gridListSub",
			param : param
		});
		
		dblIdx = headRowNum;
	}
	
	
	function validationCheck(){
		
		var head = gridList.getRowData("gridListHead", 0);
		var listCnt = gridList.getGridDataCount("gridListSub");
		var list = gridList.getGridData("gridListSub");
		
		var vparam = new DataMap();
		vparam.put("head", head);
		vparam.put("list", list);
		vparam.put("key", "DOCCAT,DOCUTY,WAREKY,LOCAKY,OWNRKY,DPTNKY,SKUKEY,MEASKY,UOMKEY,QTYRCV,QTYMAX,MANDT,EBELN,EBELP");
		
		var json = netUtil.sendData({
			url : "/wms/inbound/json/GR00_Validation.data",
			param : vparam
		});
		
		return json;
	}
	
	
	function saveData(){
		
		// all - select, modify
		if( gridList.validationCheck("gridListHead", "modify") && gridList.validationCheck("gridListSub", "modify") ) {
			
			var modifyList = gridList.getModifyRowCount("gridListSub");
			
			if( modifyList == 0){
				commonUtil.msgBox("VALID_M0406");
				//gridList.setFocus("gridListSub", "SKUKEY");
				return;
			}
			
			//searchCnt++;
			var head = gridList.getRowData("gridListHead", 0);

			var listCnt = gridList.getGridDataCount("gridListSub");
	    	var list = gridList.getGridData("gridListSub");
			
	    	
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}
			
			var json = validationCheck();
			
			if(json.data != "OK"){
				var msgList = json.data.split(" ");
				var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
				commonUtil.msg(msgTxt);
				return false;
			}
			
			
			//입하문서번호 - 재조회할때
			var arrDocNum = "";
			
			// 채번
			for(var i = 0; i < 1 ; i++) {
	
				// [120] 기타입하
				var docunum = wms.getDocSeq("120");
				gridList.gridColModify("gridListHead", 0, "RECVKY", docunum);
				if(i == 0){
					arrDocNum += docunum;
				}else{
					arrDocNum += "','"+docunum;
				}
			}
			
			var head = gridList.getRowData("gridListHead", 0);
	    	var list = gridList.getGridData("gridListSub");
	    	
			var param = new DataMap();
			param.put("head", head);
			param.put("list", list);
			
			
			var json = netUtil.sendData({
				url : "/wms/inbound/json/GR00_Save.data",
				param : param
			});
	
			if(json && json.data){
				searchCnt = 1;
				
				var paramH = new DataMap();
				paramH.put("RECVKY", arrDocNum);
				
				var wareky = gridList.getColData("gridListHead", 0, "WAREKY");
				paramH.put("WAREKY", wareky);
				
				gridList.gridList({
			    	id : "gridListHead",
			    	command : "GR09H",
			    	param : paramH
			    });
				
				gridList.gridList({
			    	id : "gridListSub",
			    	command : "GR09I",
			    	param : paramH
			    }); 
				
				gridList.setReadOnly("gridListHead");
				gridList.setReadOnly("gridListSub");
			}
		}
	}

	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		if (gridId == "gridListSub" && colName == "SKUKEY") {
			
			if(colValue != ""){
				//var param = new DataMap();
				var param = inputList.setRangeParam("searchArea");
				
				param.put("SKUKEY", colValue);
				
				
				var json = netUtil.sendData({
					module : "WmsInbound",
					command : "SKUKEYval",
					sendType : "map",
					param : param
				});
				
				if(json.data["CNT"] >= 1) {
					
					var param = new DataMap();
					
					var param = inputList.setRangeParam("searchArea");
					param.put("SKUKEY", colValue);
					
					var json = netUtil.sendData({
						module : "WmsInbound",
						command : "SKUKEY",
						sendType : "map",
						param : param
					});
					
					if(json && json.data){
						
						gridList.setColValue("gridListSub", rowNum, "DESC01", json.data["DESC01"]);	//품명
						
						gridList.setColValue("gridListSub", rowNum, "MEASKY", json.data["MEASKY"]);	// 단위구성
						gridList.setColValue("gridListSub", rowNum, "UOMKEY", json.data["UOMKEY"]);	// 단위 UOMKEY
						gridList.setColValue("gridListSub", rowNum, "DUOMKY", json.data["DUOMKY"]);	// 단위 DUOMKY
						gridList.setColValue("gridListSub", rowNum, "QTDUOM", json.data["QTDUOM"]);	// 입수
						gridList.setColValue("gridListSub", rowNum, "BOXQTY", json.data["BOXQTY"]);	// 박스수
						gridList.setColValue("gridListSub", rowNum, "REMQTY", json.data["REMQTY"]);	// 잔량
						
						gridList.setColValue("gridListSub", rowNum, "SKUG05", json.data["SKUG05"]);	// 모업체품번
						
						gridList.setColValue("gridListSub", rowNum, "GRSWGT", json.data["GRSWGT"]);	// 총중량
						gridList.setColValue("gridListSub", rowNum, "NETWGT", json.data["NETWGT"]);	// KIT순중량
						gridList.setColValue("gridListSub", rowNum, "WGTUNT", json.data["WGTUNT"]);	// 중량단위
						
						gridList.setColValue("gridListSub", rowNum, "LENGTH", json.data["LENGTH"]);	// 길이
						gridList.setColValue("gridListSub", rowNum, "WIDTHW", json.data["WIDTHW"]);	// 가로
						gridList.setColValue("gridListSub", rowNum, "HEIGHT", json.data["HEIGHT"]);	// 높이
						
						gridList.setColValue("gridListSub", rowNum, "CUBICM", json.data["CUBICM"]);	// CBM
						gridList.setColValue("gridListSub", rowNum, "CAPACT", json.data["CAPACT"]);	// CAPA
						
					} 
				} else if (json.data["CNT"] < 1) {
					commonUtil.msgBox("COMMON_M0461", colValue);
					
					gridList.setColValue("gridListSub", rowNum, "SKUKEY", "");
					gridList.setFocus("gridListSub", "SKUKEY");
				}
			}
		}
	}

	
</script>
</head>
<body>

<!-- contentHeader -->
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Save SAVE STD_SAVE false">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>
<!-- //contentHeader -->

<!-- searchPop -->
<div class="searchPop">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="searchBtn"><input type="submit" onclick="searchList()" class="button type1 widthAuto" value="검색" CL="BTN_DISPLAY"/></p>
		<div class="searchInBox" id="searchArea">
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">거점</th>
						<td>
							<input type="text" name="WAREKY" UIInput="S,SHWAHMA" value="WCD1" />
						</td>
					</tr>
					<tr>
						<th CL="STD_RCPTTY">입하유형</th>
						<td GCol="select,RCPTTY">
							<select Combo="WmsInbound,DOCUTY106COMBO" name="RCPTTY"></select>
						</td>
					</tr>
					
					<input type="hidden" name="OWNRKY" value="CMAS" />
					<input type="hidden" name="DOCCAT" value="100" />
					
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- //searchPop -->

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span>일반</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
																				
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												
												<th CL='STD_RECVKY,2'></th>	<!-- 입하문서번호 -->
												<th CL='STD_RCPTTY'></th>	<!-- 입하유형 -->
												<th CL='STD_RCPTTYNM'></th>	<!-- 입하유형명 -->
												<th CL='STD_WAREKY'></th>	<!-- 거점 -->
												<th CL='STD_WAREKYNM'></th>	<!-- 거점명 -->
												<th CL='STD_DOCDAT'></th>	<!-- 문서일자 -->
												
												<th CL='STD_ARCPTD'></th>	<!-- 입하일자 -->
												<th CL='STD_DOCTXT'></th>	<!-- 비고 -->
												
												<th CL='STD_STATDO'></th>	<!-- 문서상태 -->
												<th CL='STD_DOCCAT'></th>	<!-- 문서유형 -->
												<th CL='STD_DOCCATNM'></th>	<!-- 문서유형명 -->
												
												<th CL='STD_DPTNKY'></th>	<!-- 업체코드 -->
												<th CL='STD_DPTNKYNM'></th>	<!-- 업체코드명 -->
												
												<th CL='STD_USRID3'></th>	<!-- 현장담당 -->
												<th CL='STD_UNAME3'></th>	<!-- 현장담당자명 -->
												<th CL='STD_DEPTID3'></th>	<!-- 현장담당 부서 -->
												<th CL='STD_DNAME3'></th>	<!-- 현장담당 부서명 -->
												
												<th CL='STD_USRID4'></th>	<!-- 현장책임 -->
												<th CL='STD_UNAME4'></th>	<!-- 현장책임자명 -->
												<th CL='STD_DEPTID4'></th>	<!-- 현장책임 부서 -->
												<th CL='STD_DNAME4'></th>	<!-- 현장책임 부서명 -->
												
												<th CL='STD_USRID1'></th>	<!-- 입력자 -->
												<th CL='STD_UNAME1'></th>	<!-- 입력자명 -->
												<th CL='STD_DEPTID1'></th>	<!-- 입력자 부서 -->
												<th CL='STD_DNAME1'></th>	<!-- 입력자 부서명 -->
												
												<th CL='STD_USRID2'></th>	<!-- 업무담당자 -->
												<th CL='STD_UNAME2'></th>	<!-- 업무담당자명 -->
												<th CL='STD_DEPTID2'></th>	<!-- 업무 부서 -->
												<th CL='STD_DNAME2'></th>	<!-- 업무 부서명 -->
												
												<th CL='STD_CREDAT'></th>	<!-- 생성일자 -->
												<th CL='STD_CRETIM'></th>	<!-- 생성시간 -->
												<th CL='STD_CREUSR'></th>	<!-- 생성자 -->
												<th CL='STD_CUSRNM'></th>	<!-- 생성자명 -->
												<th CL='STD_LMODAT'></th>	<!-- 수정일자 -->
												<th CL='STD_LMOTIM'></th>	<!-- 수정시간 -->
												<th CL='STD_LMOUSR'></th>	<!-- 수정자 -->
												<th CL='STD_LUSRNM'></th>	<!-- 수정자명 -->
												
												
												<!-- <th CL='STD_SAPSTS'></th> -->	<!-- ERP Mvt -->
												<!-- <th CL='STD_PTNRKY1'></th> -->	<!-- 부서코드 -->
												<!-- <th CL='STD_DRELIN'></th> -->	<!-- 문서연관구분자 -->
												<!-- <th CL='STD_OWNRKY'></th> -->	<!-- 화주 -->
												<!-- <th CL='STD_INDRCN'></th> -->	<!-- 취소됨 -->
												<!-- <th CL='STD_CRECVD'></th> -->	<!-- 입고취소 일자 -->
												<!-- <th CL='STD_RSNCOD'></th> -->	<!-- 사유코드 -->
												<!-- <th CL='STD_ERPWM'></th> -->	<!-- ERP창고 -->
												<!-- <th CL='STD_ERPWMNM'></th> -->	<!-- ERP창고명 -->
												<!-- th CL='STD_DPTNKYNM'></th> -->	<!-- 업체코드명 -->
												
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
										</colgroup>
										<tbody id="gridListHead">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												
												<td GCol="text,RECVKY"></td>	<!-- 입하문서번호 -->
												<td GCol="text,RCPTTY"></td>	<!-- 입하유형 -->
												<td GCol="text,RCPTTYNM"></td>	<!-- 입하유형명 -->
												<td GCol="text,WAREKY"></td>	<!-- 거점 -->
												<td GCol="text,WAREKYNM"></td>	<!-- 거점명 -->
												<td GCol="input,DOCDAT"></td>	<!-- 문서일자 -->
												
												<td GCol="text,ARCPTD"></td>	<!-- 입하일자 -->
												<td GCol="input,DOCTXT"></td>	<!-- 비고 -->
												
												<td GCol="text,STATDO"></td>	<!-- 문서상태 -->
												<td GCol="text,DOCCAT"></td>	<!-- 문서유형 -->
												<td GCol="text,DOCCATNM"></td>	<!-- 문서유형명 -->
												
												<td GCol="input,DPTNKY"></td>	<!-- 업체코드 -->
												<td GCol="text,DPTNKYNM"></td>	<!-- 업체코드명 -->
												
												<td GCol="input,USRID3"></td>	<!-- 현장담당 -->
												<td GCol="text,UNAME3"></td>	<!-- 현장담당자명 -->
												<td GCol="text,DEPTID3"></td>	<!-- 현장담당 부서 -->
												<td GCol="text,DNAME3"></td>	<!-- 현장담당 부서명 -->
												
												<td GCol="input,USRID4"></td>	<!-- 현장책임 -->
												<td GCol="text,UNAME4"></td>	<!-- 현장책임자명 -->
												<td GCol="text,DEPTID4"></td>	<!-- 현장책임 부서 -->
												<td GCol="text,DNAME4"></td>	<!-- 현장책임 부서명 -->
												
												<td GCol="text,USRID1"></td>	<!-- 입력자 -->
												<td GCol="text,UNAME1"></td>	<!-- 입력자명 -->
												<td GCol="text,DEPTID1"></td>	<!-- 입력자 부서 -->
												<td GCol="text,DNAME1"></td>	<!-- 입력자 부서명 -->
												
												<td GCol="text,USRID2"></td>	<!-- 업무담당자 -->
												<td GCol="text,UNAME2"></td>	<!-- 업무담당자명 -->
												<td GCol="text,DEPTID2"></td>	<!-- 업무 부서 -->
												<td GCol="text,DNAME2"></td>	<!-- 업무 부서명 -->
												
												<td GCol="text,CREDAT" GF="D"></td>	<!-- 생성일자 -->
												<td GCol="text,CRETIM" GF="T"></td>	<!-- 생성시간 -->
												<td GCol="text,CREUSR"></td>	<!-- 생성자 -->
												<td GCol="text,CUSRNM"></td>	<!-- 생성자명 -->
												<td GCol="text,LMODAT" GF="D"></td>	<!-- 수정일자 -->
												<td GCol="text,LMOTIM" GF="T"></td>	<!-- 수정시간 -->
												<td GCol="text,LMOUSR"></td>	<!-- 수정자 -->
												<td GCol="text,LUSRNM"></td>	<!-- 수정자명 -->
												
												
											</tr>		
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span>Item 리스트</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												
												<!-- <th CL='STD_RECVKY'></th> -->	<!-- 입하문서번호 -->
												
												<th CL='STD_RECVIT,2'></th>	<!-- 입하문서아이템 -->
												<th CL='STD_SKUKEY'></th>	<!-- 품번코드 -->
												<th CL='STD_DESC01'></th>	<!-- 품명 -->
												<th CL='STD_LOCAKY'></th>	<!-- 지번 -->
												<th CL='STD_TRNUID'></th>	<!-- P/T ID -->
												
												
												<th CL='STD_QTYRCV'></th>	<!-- 입고수량 -->
												<th CL='STD_UOMKEY'></th>	<!-- 단위 -->
												<th CL='STD_QTDUOM'></th>	<!-- 입수 -->
												<th CL='STD_BOXQTY'></th>	<!-- 박스수 -->
												<th CL='STD_REMQTY'></th>	<!-- 잔량 -->
												
												
												<th CL='STD_LOTA11'></th>	<!-- 제조일자 -->
												<th CL='STD_LOTA01'></th>	<!-- S/N번호 -->
												<th CL='STD_LOTA06'></th>	<!-- 재고상태 -->
												<th CL='STD_AREAKY'></th>	<!-- 창고 -->
												<th CL='STD_MEASKY'></th>	<!-- 단위구성 -->
												
												<th CL='STD_DUOMKY'></th>	<!-- 단위 -->
												<th CL='STD_LOTA01NM'></th>	<!-- 영업부문명 -->
												
												<th >ERP플랜트</th>
												<th >훌하 LOT</th>
												<th >등급</th>
												<th >포장상태</th>
																								
												
												<th CL='STD_LOTA12'></th>	<!-- 입고일자 -->
												<th CL='STD_DESC02'></th>	<!-- 규격 -->
																								
												
												
												<!-- <th CL='STD_LOTA05'></th> -->	<!-- 재고분류 -->
												<!-- <th CL='STD_LOTA02'></th> -->	<!-- 재고유형 -->
												<!-- <th CL='STD_RSNCOD'></th> -->	<!-- 사유코드 -->
												
												<!-- <th CL='STD_LOTA03'></th> -->	<!-- 벤더 -->
												<!-- <th CL='STD_LOTA04'></th> -->	<!-- 문서번호 -->
												
												<!-- <th CL='STD_LOTA13'></th> -->	<!-- 유효기간 -->

												
												<th CL='STD_ASKU01'></th>	<!-- WMS 통합코드 -->
												<th CL='STD_ASKU02'></th>	<!-- 수출(E)/내수(D) -->
												<th CL='STD_ASKU03'></th>	<!-- ERP 오더유형 -->
												<th CL='STD_ASKU04'></th>	<!-- 거래처 입고빈 -->
												<th CL='STD_ASKU05'></th>	<!-- 재질 -->
												
												<th CL='STD_EANCOD'></th>	<!-- EAN -->
												<th CL='STD_GTINCD'></th>	<!-- UPC -->
												
												<th CL='STD_SKUG01'></th>	<!-- 품목유형1 -->
												<th CL='STD_SKUG02'></th>	<!-- 품목유형2 -->
												<th CL='STD_SKUG03'></th>	<!-- 품목유형3 -->
												
												<th CL='STD_SKUG04'></th>	<!-- 품종 -->
												<th CL='STD_SKUG05'></th>	<!-- 모업체품번 -->
												<th CL='STD_GRSWGT'></th>	<!-- 총중량  -->
												<th CL='STD_NETWGT'></th>	<!-- KIT순중량 -->
												<th CL='STD_WGTUNT'></th>	<!-- 중량단위 -->
												<th CL='STD_LENGTH'></th>	<!-- 길이 -->
												<th CL='STD_WIDTHW'></th>	<!-- 가로 -->
												<th CL='STD_HEIGHT'></th>	<!-- 높이 -->
												<th CL='STD_CUBICM'></th>	<!-- CBM -->
												<th CL='STD_CAPACT'></th>	<!-- CAPA -->
												
												<th CL='STD_CREDAT'></th>	<!-- 생성일자 -->
												<th CL='STD_CRETIM'></th>	<!-- 생성시간 -->
												<th CL='STD_CREUSR'></th>	<!-- 생성자 -->
												<th CL='STD_CUSRNM'></th>	<!-- 생성자명 -->
												<th CL='STD_LMODAT'></th>	<!-- 수정일자 -->
												<th CL='STD_LMOTIM'></th>	<!-- 수정시간 -->
												<th CL='STD_LMOUSR'></th>	<!-- 수정자 -->
												<th CL='STD_LUSRNM'></th>	<!-- 수정자명 -->
												
												
												<!-- <th CL='STD_STATIT'></th> -->	<!-- 상태 -->
												<!-- <th CL='STD_SAPSTS'></th> -->	<!-- ERP Mvt -->
												<!-- <th CL='STD_LOTNUM'></th> -->	<!-- Lot no. -->
												
												<!-- <th CL='STD_SECTID'></th> -->	<!-- Sect.ID -->
												<!-- <th CL='STD_TRNUID'></th> -->	<!-- P/T -->
												
												<!-- <th CL='STD_PACKID'></th> -->	<!-- SET품번코드 -->
												
												<!-- <th CL='STD_QTYDIF'></th> -->	<!-- 차이량 -->
												<!-- <th CL='STD_QTYUOM'></th> -->	<!-- Quantity -->
												<!-- <th CL='STD_TRUNTY'></th> -->	<!-- 팔렛타입 -->
												
												<!-- <th CL='STD_QTPUOM'></th> -->	<!-- Units pe -->
												
												<!-- <th CL='STD_INDRCN'></th> -->	<!-- 취소됨 -->
												<!-- <th CL='STD_CRECVD'></th> -->	<!-- 입고취소 일자 -->
												
												<!-- <th CL='STD_LOTA07'></th> -->	<!-- LOT속성7 -->
												<!-- <th CL='STD_LOTA08'></th> -->	<!-- LOT속성8 -->
												<!-- <th CL='STD_LOTA09'></th> -->	<!-- LOT속성9 -->
												<!-- <th CL='STD_LOTA10'></th> -->	<!-- LOT속성10 -->
												
												
												<!-- <th CL='STD_LOTA14'></th> -->	<!-- LOT속성14 -->
												<!-- <th CL='STD_LOTA15'></th> -->	<!-- LOT속성15 -->
												<!-- <th CL='STD_LOTA16'></th> -->	<!-- LOT속성16 -->
												<!-- <th CL='STD_LOTA17'></th> -->	<!-- LOT속성17 -->
												<!-- <th CL='STD_LOTA18'></th> -->	<!-- LOT속성18 -->
												<!-- <th CL='STD_LOTA19'></th> -->	<!-- LOT속성19 -->
												<!-- <th CL='STD_LOTA20'></th> -->	<!-- LOT속성20 -->
												
												<!-- <th CL='STD_AWMSNO'></th> -->	<!-- SEQ(ERP) -->
												<!-- <th CL='STD_REFDKY'></th> -->	<!-- 참조문서 -->
												<!-- <th CL='STD_REFDIT'></th> -->	<!-- 참조문서It. -->
												<!-- <th CL='STD_REFCAT'></th> -->	<!-- 참조문서유형 -->
												<!-- <th CL='STDREFDAT'></th> -->	<!-- 참조문서일자 -->
												
												<!-- <th CL='STD_QTYORG'></th> -->	<!-- 실입고량 -->
												<!-- <th CL='STD_SMANDT'></th> -->	<!-- Client -->
												
												<!-- <th CL='STD_SEBELN'></th> -->	<!-- ECMS 주문번호 -->
												<!-- <th CL='STD_SEBELP'></th> -->	<!-- SAP P/O Item -->
												<!-- <th CL='STD_SZMBLNO'></th> -->	<!-- B/L NO -->
												<!-- <th CL='STD_SZMIPNO'></th> -->	<!-- B/L Item NO -->
												<!-- <th CL='STD_STRAID'></th> -->	<!-- SCM주문번호 -->
												<!-- <th CL='STD_SVBELN'></th> -->	<!-- ECMS 주문번호 -->
												<!-- <th CL='STD_SPOSNR'></th> -->	<!-- ECMS 주문Item -->
												<!-- <th CL='STD_STKNUM'></th> -->	<!-- 총괄계획번호 -->
												<!-- <th CL='STD_STPNUM'></th> -->	<!-- 예약 It -->
												<!-- <th CL='STD_SWERKS'></th> -->	<!-- 출발지 -->
												<!-- <th CL='STD_SLGORT'></th> -->	<!-- 영업 부문 -->
												<!-- <th CL='STD_SDATBG'></th> -->	<!-- 출하계획일시 -->
												<!-- <th CL='STD_STDLNR'></th> -->	<!-- 작업장 -->
												<!-- <th CL='STD_SSORNU'></th> -->	<!-- 반품출하문서번호 -->
												<!-- <th CL='STD_SSORIT'></th> -->	<!-- 반품출하 문서아이템 -->
												<!-- <th CL='STD_SMBLNR'></th> -->	<!-- Mat.Doc. -->
												<!-- <th CL='STD_SZEILE'></th> -->	<!-- Mat.Doc.it. -->
												<!-- <th CL='STD_SMJAHR'></th> -->	<!-- M/D 년도 -->
												<!-- <th CL='STD_SXBLNR'></th> -->	<!-- 인터페이스번호 -->
												<!-- <th CL='STD_RCPRSN'></th> -->	<!-- 상세사유 -->
												
												
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											
											<col width="100" />
											
										</colgroup>
										<tbody id="gridListSub">
										<tr CGRow="true">
												<td GCol="rownum">1</td>
												<!-- <td GCol="text,RECVKY"></td> -->	<!-- 입하문서번호 -->
												
												<td GCol="text,RECVIT"></td>	<!-- 입하문서아이템 -->
												<td GCol="input,SKUKEY" validate="required,VALID_M0406" ></td>	<!-- 품번코드 -->
												<td GCol="text,DESC01"></td>	<!-- 품명 -->
												<td GCol="input,LOCAKY" validate="required,VALID_M0404" ></td>	<!-- 지번 -->
												<td GCol="text,TRNUID"></td>	<!-- P/T ID -->
												
												
												<td GCol="input,QTYRCV" validate="required,IN_M0062" GF="N 3"></td>	<!-- 입고수량 -->
												<td GCol="text,UOMKEY"></td>	<!-- 단위 -->
												<td GCol="text,QTDUOM"></td>	<!-- 입수 -->
												<td GCol="text,BOXQTY"></td>	<!-- 박스수 -->
												<td GCol="text,REMQTY"></td>	<!-- 잔량 -->
												
												
												<td GCol="text,LOTA11"></td>	<!-- 제조일자 -->
												<td GCol="text,LOTA01"></td>	<!-- S/N번호 -->
												<td GCol="text,LOTA06"></td>	<!-- 재고상태 -->
												<td GCol="text,AREAKY"></td>	<!-- 창고 -->
												<td GCol="text,MEASKY"></td>	<!-- 단위구성 -->
												
																								
												<td GCol="text,DUOMKY"></td>	<!-- 단위 -->
												<td GCol="text,LOTA01NM"></td>	<!-- 영업부문명 -->
												<td GCol="select,LOTA05">	<!-- ERP플랜트 -->
													<select Combo="WmsInbound,LOTA05COMBO">
														<!-- <option value="">선택</option> -->
													</select>
												</td>
												<td></td>
												<td></td>
												
												
												<td GCol="select,LOTA02">	<!-- 포장상태 -->
													<select Combo="WmsInbound,LOTA02COMBO">
														<!-- <option value="">선택</option> -->
													</select>
												</td>
												<td GCol="text,LOTA12"></td>	<!-- 입고일자 -->
												<td GCol="text,DESC02"></td>	<!-- 규격 -->	
												
												
												<!-- <td GCol="text,LOTA05"></td> -->	<!-- 재고분류 -->
												<!-- <td GCol="text,LOTA02"></td> -->	<!-- 재고유형 -->
												<!-- <td GCol="text,RSNCOD"></td> -->	<!-- 사유코드 -->
												<!-- <td GCol="text,LOTA03"></td> -->	<!-- 벤더 -->
												<!-- <td GCol="text,LOTA04"></td> -->	<!-- 문서번호 -->
												<!-- <td GCol="text,LOTA13"></td> -->	<!-- 유효기간 -->
												
												
												<td GCol="text,ASKU01"></td>	<!-- WMS 통합코드 -->
												<td GCol="text,ASKU02"></td>	<!-- 수출(E)/내수(D) -->
												<td GCol="text,ASKU03"></td>	<!-- ERP 오더유형 -->
												<td GCol="text,ASKU04"></td>	<!-- 거래처 입고빈 -->
												<td GCol="text,ASKU05"></td>	<!-- 재질 -->
												
												<td GCol="text,EANCOD"></td>	<!-- EAN -->
												<td GCol="text,GTINCD"></td>	<!-- UPC -->
												
												<td GCol="text,SKUG01"></td>	<!-- 품목유형1 -->
												<td GCol="text,SKUG02"></td>	<!-- 품목유형2 -->
												<td GCol="text,SKUG03"></td>	<!-- 품목유형3 -->
												
												<td GCol="text,SKUG04"></td>	<!-- 품종 -->
												<td GCol="text,SKUG05"></td>	<!-- 모업체품번 -->
												<td GCol="text,GRSWGT"></td>	<!-- 총중량  -->
												<td GCol="text,NETWGT"></td>	<!-- KIT순중량 -->
												<td GCol="text,WGTUNT"></td>	<!-- 중량단위 -->
												<td GCol="text,LENGTH"></td>	<!-- 길이 -->
												<td GCol="text,WIDTHW"></td>	<!-- 가로 -->
												<td GCol="text,HEIGHT"></td>	<!-- 높이 -->
												<td GCol="text,CUBICM"></td>	<!-- CBM -->
												<td GCol="text,CAPACT"></td>	<!-- CAPA -->
												
												<td GCol="text,CREDAT"></td>	<!-- 생성일자 -->
												<td GCol="text,CRETIM"></td>	<!-- 생성시간 -->
												<td GCol="text,CREUSR"></td>	<!-- 생성자 -->
												<td GCol="text,CUSRNM"></td>	<!-- 생성자명 -->
												<td GCol="text,LMODAT"></td>	<!-- 수정일자 -->
												<td GCol="text,LMOTIM"></td>	<!-- 수정시간 -->
												<td GCol="text,LMOUSR"></td>	<!-- 수정자 -->
												<td GCol="text,LUSRNM"></td>	<!-- 수정자명 -->
																								 
												
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
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
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