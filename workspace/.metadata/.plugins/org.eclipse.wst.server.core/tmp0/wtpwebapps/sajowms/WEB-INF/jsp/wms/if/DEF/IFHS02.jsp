<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
//TABLE : TE_WM_EH_ASN_PO_SND
	$(document).ready(function(){
		setTopSize(100);
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "Erpif",
			command : "IFHS02",
			autoCopyRowType : false
		});
		
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList");
			var param = inputList.setRangeParam("searchArea");
			
			var json = netUtil.sendData({
				module : "Erpif",
				command : "IFHS02",
				sendType : "count",
				param : param
			}); 
			
			if( json && json.data ){
				var cnt = json.data;
				if( cnt > configData.IF_MAX_ROW_COUNT ){ //10000건
					alert(configData.IF_MAX_ROW_COUNT+ " 건을 넘을 수 없습니다. 조회 조건을 더 설정하고 조회하세요."); 
					return;
					
				}else if( cnt == 0 ){
					commonUtil.msgBox(configData.MSG_MASTER_ROWEMPTY); //검색한 데이터가 없습니다.
					return;
				}
			}else{
				commonUtil.msgBox(configData.MSG_MASTER_ROWEMPTY); //검색한 데이터가 없습니다.
				return;
			}
			
			gridList.gridList({
				id : "gridList",
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
			
		}else if( comboAtt == "Common,COMCOMBO" ){
// 			var name = $(paramName).attr("name");
			param.put("CODE","IFSSTS");
		}
		
		return param;
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
											<th CL="STD_SYSCOD"></th>
											<td>
												<select id="SYSCOD" name="SYSCOD" Combo="Common,COMCOMBO" UISave="false" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_IFDATE"></th>
											<td>
												<input type="text" name="IFDATE" UIFormat="C N" validate="required" />
											</td>
										</tr>
										<tr>
											<th CL="STD_SVBELN"></th>
											<td>
												<input type="test" name="A.SVBELN" UIInput="SR"/>
											</td>
											<th CL="STD_SKUKEY"></th>
											<td>
												<input type="text" name="A.SKUKEY" UIInput="SR" />
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
												<td GH="100 물류센터"       GCol="text,WAREKY"></td>
												<td GH="100 주문번호"       GCol="text,SVBELN"></td>
												<td GH="100 주문순서"       GCol="text,SPOSNR"></td>
												<td GH="100 주문상세번호"    GCol="text,SHDTLN"></td>
												<td GH="100 수불센터코드"    GCol="text,LOTA01"></td>
												<td GH="100 협력사/점포코드"  GCol="text,VTRCOD"></td>
												<td GH="100 상품코드"       GCol="text,SKUKEY"></td>
												<td GH="100 상품그룹"       GCol="text,SKUGRP"></td>
												<td GH="100 매입단위"       GCol="text,DUOMKY"></td>
												<td GH="100 입고수량"       GCol="text,QTYRCV" GF="N"></td>
												<td GH="100 입고예정수량"    GCol="text,QTYORG" GF="N"></td>
												<td GH="100 입고예정일"     GCol="text,DOCDAT" GF="D"></td>
												<td GH="100 프로세스구분"    GCol="text,PRCTYP"></td>
												<td GH="100 처리자ID"      GCol="text,CREUSR"></td>
												<td GH="100 처리자"        GCol="text,CREUNM"></td>
												<td GH="100 생성일시"      GCol="text,FST_REG_DTTM"></td>
												<td GH="100 생성자ID"      GCol="text,FST_REG_USER_ID"></td>
												<td GH="100 처리상태"       GCol="text,EAI_PROC_CD"></td>
												<td GH="100 EAI처리ID"    GCol="text,EAI_PROC_ID"></td>
												<td GH="100 EAI처리일시"    GCol="text,EAI_PROC_DTTM"></td>
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
									<button type="button" GBtn="total"></button>
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