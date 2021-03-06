<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL28</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

	$(document).ready(function() {
		gridList.setGrid({
	    	id : 'gridList',
	    	module : 'Report',
			command : 'RL28',
			colorType : true,
		    menuId : "RL28"
	    });
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function linkPopCloseEvent(data){ //팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	} 	
	
	// 버튼 클릭
	function commonBtnClick(btnName){
		if (btnName == 'Savevariant') {
			sajoUtil.openSaveVariantPop("searchArea", "RL28");
		} else if (btnName == 'Getvariant') {
			sajoUtil.openGetVariantPop("searchArea", "RL28");
		} else if(btnName == "Search") {
			searchList();
		} else if(btnName == "Print") {
// 			print();
			// 데이터 정합정을 확인할 방법이 없어 막아둠.
			// 기존 구버전 화면 및 리포트가 전혀 동작을 하지 않고 화면의도를 알지 못함.
			printM();
		}
	}	
	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList");
			var param = inputList.setRangeDataParam("searchArea");
			
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	// grid 조회 시 data 적용이 완료된 후
	function  gridListEventDataBindEnd(gridId, dataLength, excelLoadType) { 
		if(gridId == 'gridList') {
			var list = gridList.getGridData(gridId);
			if(list.length > 0) {
				uiList.setActive("Print", true);
			}
		}
	}
	
	function print() {
		var optionMap = new DataMap();	
		var wherestr = '';
		var orderbystr = '';
		var addr = '';
		var langKy = "KO";
		var width = 840;
		var heigth = 640;
		var option2 = $("#OTRQDT").val();
		
		option = " AND I.OWNRKY = '"+ $("#OWNRKY").val() +"' AND I.WAREKY = '" + $("#WAREKY").val() + "'";
		
		var option2 = getMultiRangeDataSQLEzgen("OTRQDT", "I.OTRQDT");
		
		option += option2;
		
		var wherestr = " AND IFT.OWNRKY = '"+ $("#OWNRKY").val() +"' AND IFT.WAREKY = '" + $("#WAREKY").val() + "'";
		optionMap.put('i_option', option);
		
		WriteEZgenElement("/ezgen/" + addr, wherestr, orderbystr, langKy, optionMap , width , heigth ); // 프린트 공통 메소드

	} 
	
	function gridListRowBgColorChange(gridId, rowNum, rowData){
		if(gridId == "gridList"){			
			if(rowData.get("SVBELN") == "거래처계"){
				return configData.GRID_COLOR_BG_YELLOW_CLASS2;
			}
		}
	}
	
	// grid cell background color 변경.
// 	function gridListRowBgColorChange(gridId, rowNum, rowData) {
// 		if(gridId == 'gridList') {
// 			if(colName == 'SVBELN') {
// 				if(colValue == '거래처계') {
// 					return configData.GRID_COLOR_BG_YELLOW_CLASS2;
// 				}
// 			}
// 		}
// 	} // end gridListColBgColorChange()

	function printM(){
		commonUtil.msgBox("사용하지 않는 이지젠 입니다.");
	
}
	
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH STD_SEARCH" />
					<input type="button" CB="Print PRINT_OUT BTN_PRINT" />
<!-- 					<input type="button" CB="Reload RESET STD_REFLBL" /> -->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl>  <!-- 화주 -->
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required" ></select>
						</dd>
					</dl>
					<dl>  <!-- 거점 -->
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" validate="required"></select>
						</dd>
					</dl>
					<dl>  <!--출고예정일-->  
						<dt CL="STD_OTRQDT2"></dt> 
						<dd> 
							<input type="text" class="input" id="OTRQDT" name="OTRQDT" UIInput="I" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="STD_PGRC03"></dt> 
						<dd> 
							<select name="ORDTYP" id="ORDTYP" class="input" CommonCombo="HPORDTYP">
								<option></option>
							</select>
						</dd> 
					</dl> 
					
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 7">화주</td>	<!--화주-->
										<td GH="40 STD_WAREKY" GCol="text,WAREKY" GF="S 7">거점</td>	<!--거점-->
										<td GH="70 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 10">출고요청일</td>	<!--출고요청일-->
										<td GH="120 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
										<td GH="60 STD_IFPGRC03" GCol="text,ORDTYP" GF="S 40">주문구분</td>	<!--주문구분-->
										<td GH="80 STD_IFPGRC04" GCol="text,WARESR" GF="S 40">요청사업장</td>	<!--요청사업장-->
										<td GH="100 STD_IFPGRC04N" GCol="text,NAME01" GF="S 180">요청사업장명</td>	<!--요청사업장명-->
										<td GH="80 STD_RELTCD" GCol="text,PTNRTO" GF="S 20">거래처코드</td>	<!--거래처코드-->
										<td GH="100 STD_PTNRTO" GCol="text,CTNAME" GF="S 20">거래처/요청거점</td>	<!--거래처/요청거점-->
										<td GH="60 STD_SKUKEY" GCol="textt,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
										<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
										<td GH="70 STD_DSTC06" GCol="text,QTDUOM" GF="N 13">BOX</td>	<!--BOX-->
										<td GH="60 STD_QTYPLT" GCol="text,QTYPLT" GF="N 13">수량(PLT)</td>	<!--수량(PLT)-->
										<td GH="60 STD_QTYBOX" GCol="text,QTYBOX" GF="N 13,1">수량(BOX)</td>	<!--수량(BOX)-->
										<td GH="60 IFT_QTYREQ" GCol="textt,QTYREQ" GF="N 13">납품요청수량</td>	<!--납품요청수량-->
										<td GH="70 IFT_SELLPR2" GCol="text,SELLPR" GF="N 13">공급가액</td>	<!--공급가액-->
										<td GH="160 IFT_CUADDR" GCol="text,CUADDR" GF="S 100">배송지 주소</td>	<!--배송지 주소-->
										<td GH="160 IFT_TEXT01" GCol="text,TEXT01" GF="S 100">비고</td>	<!--비고-->
									</tr>
								</tbody>
							</table>
						</div> 
					</div>
					<div class="btn_lit tableUtil">
					    <button type="button" GBtn="find"></button>      
					    <button type="button" GBtn="sortReset"></button> 
					    <button type="button" GBtn="layout"></button>    
					    <button type="button" GBtn="total"></button>     
					    <button type="button" GBtn="excel"></button>     
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>