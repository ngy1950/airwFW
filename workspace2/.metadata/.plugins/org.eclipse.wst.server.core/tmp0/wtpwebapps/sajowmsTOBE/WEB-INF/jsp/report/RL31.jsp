<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL31</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var module = 'Report';
var command = 'RL31';
var gridId = 'gridList';
var param = null;

	$(document).ready(function() {
		
		gridList.setGrid({
	    	id : gridId,
	    	module : module,
			command : command,
		    menuId : "RL31"
	    });
		
		uiList.setActive("Print", false);
		
		// 콤보박스 리드온리
		gridList.setReadOnly("gridList", true, ["RSNADJ", "LOTA05", "LOTA06"]);	
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function linkPopCloseEvent(data){ //팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	} // end linkPopCloseEvent()	
	
	// 버튼 클릭
	function commonBtnClick(btnName){
		if (btnName == 'Savevariant') {
			sajoUtil.openSaveVariantPop("searchArea", "RL31");
		} else if (btnName == 'Getvariant') {
			sajoUtil.openGetVariantPop("searchArea", "RL31");
		} else if(btnName == "Search") {
			search();
		} else if(btnName == "Print") {
			print();
		}
	}// end commonBtnClick()	
	
	// 콤보박스 parameter 셋팅
	function comboEventDataBindeBefore(comboAtt, $comboObj) {
		param = new DataMap();
		if(comboAtt == 'SajoCommon,RSNCOD_COMCOMBO') {
			param.put('OWNRKY', $('#OWNRKY').val());
			param.put('DOCCAT', '400');
			param.put('DOCUTY', '425');
		} 
		return param;
	} // end comboEventDataBindeBefore()
	
	// 서치헬프 parameter 셋팅
	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj)  {
		param = new DataMap();
		
		var ownrky = $('#OWNRKY').val();
		var wareky = $('#WAREKY').val();
		
		switch(searchCode) {
		case 'SHLOCMA' :
			param.put('WAREKY', wareky);
			break;
		case 'SHSKUMA' :
			param.put('OWNRKY', ownrky);
			param.put('WAREKY', wareky);
			break;
		case 'SHBZPTN' :
			var ptnrty = '0007';
			param.put('OWNRKY', ownrky);
			param.put('PTNRTY', ptnrty);
			break;
		}
		
		return param;
	} // end searchHelpEventOpenBefore()
	
	// search(조회)
	function search() {
		// param = inputList.getRangeParam('searchArea');
		// console.log(param);
		param = inputList.setRangeParam('searchArea');
		// console.log(param)
			
		gridList.gridList({
			id : gridId,
			param : param
		});		
		
	} // end search()
	
	// grid 조회 시 data 적용이 완료된 후
	function  gridListEventDataBindEnd(gridId, dataLength, excelLoadType) { 
		if(gridId == 'gridList') {
			var list = gridList.getGridData(gridId);
			if(list.length > 0) uiList.setActive("Print", true);					
		}
	} // end gridListEventDataBindEnd()
	
	// print(출력)
	function print() {
		var optionMap = new DataMap();	
		var wherestr = '';
		var option = '';
		var orderbystr = '';
		var addr = '';
		var langKy = "KO";
		var width = 595;
		var heigth = 840;
		var ownrky = $('#OWNRKY').val();
		var wareky = $('#WAREKY').val();
		
		addr = 'adj425_list.ezg"';
		
		wherestr = "AND I.OWNRKY = " + "'" + ownrky + "'";
		wherestr += " AND H.WAREKY = "  + "'" + wareky + "'";
		wherestr += getMultiRangeDataSQLEzgen('i.credat', 'I.CREDAT');	
		
		option = " AND I.OWNRKY = " + "'" + ownrky + "'";
		option += " AND H.WAREKY = "  + "'" + wareky + "'";
		optionMap.put('option', option);
		
		if(getMultiRangeDataSQLEzgen('i.credat', 'I.CREDAT') != '') {
			WriteEZgenElement("/ezgen/" + addr, wherestr, orderbystr, langKy, optionMap , width , heigth ); // 프린트 공통 메소드
			// 1. ezgen/ 뒤의 주소를 해당 연결된 ezgen 주소로 변경
			// 2. wherestr => 쿼리 조합을 변경
			// 3. map은 option 쿼리 가 담겨 있음 map도 쿼리 조합			
		} else {
			commonUtil.msgBox('REPORT_CREDAT'); // 일반검색조건에 조정일자를 입력하십시오.
		}
		
	} // end print()
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
					<!-- <input type="button" CB="Print PRINT BTN_PRINT" /> -->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
				
					<!-- 화주 -->
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required" ></select>
						</dd>
					</dl>
					
					<!-- 거점 -->
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" validate="required"></select>
						</dd>
					</dl>
					
					<dl>  <!-- 조정문서 유형 -->  
						<dt CL="STD_ADJUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="h.adjuty" UIInput="SR" value="425" readonly/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 출고문서일자 -->  
						<dt CL="IFT_DOCDATMV"></dt> 
						<dd> 
							<input type="text" class="input" name="sh.DOCDAT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 배송일자 -->  
						<dt CL="STD_CARDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="sr.cardat" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 출고문서 번호 -->  
						<dt CL="STD_SHPOKY"></dt> 
						<dd> 
							<input type="text" class="input" name="i.refdky" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- S/O번호-->  
						<dt CL="STD_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="i.svbeln" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 조정문서번호 -->  
						<dt CL="STD_SADJKY"></dt> 
						<dd> 
							<input type="text" class="input" name="i.sadjky" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 조정일자 -->  
						<dt CL="STD_ADJDAT"></dt> 
						<dd> 
							<input type="text" class="input" id="CREDAT" name="i.credat" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 로케이션 -->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="i.locaky" UIInput="SR,SHLOCMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 제품코드 -->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="i.skukey" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 제품명 -->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="i.desc01" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 업체코드 -->  
						<dt CL="STD_DPTNKY"></dt> 
						<dd> 
							<input type="text" class="input" name="sh.dptnky" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 업체명 -->  
						<dt CL="STD_DPTNKYNM"></dt> 
						<dd> 
							<input type="text" class="input" name="NVL(BZ.NAME01,WH.NAME01) " UIInput="SR"/> 
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
			    						<td GH="80 STD_SADJKY" GCol="text,SADJKY" GF="S 10"></td>	<!-- 조정문서 번호 -->
			    						<td GH="50 STD_SADJIT" GCol="text,SADJIT" GF="S 6"></td>	<!-- 조정 item -->
			    						<td GH="50 STD_RSNADJ" GCol="select,RSNADJ">	<!-- 조정사유 코드 --> 
			    							<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"></select>
			    						</td>
			    						<td GH="80 STD_STOKKY" GCol="text,STOKKY" GF="S 10"></td>	<!-- 재고키 -->
			    						<td GH="160 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20"></td>	<!-- 로케이션 -->
			    						<td GH="80 STD_TRNUID" GCol="text,TRNUID" GF="S 20"></td>	<!-- 팔레트ID -->
			    						<td GH="160 STD_QTADJU" GCol="text,QTADJU" GF="N 20"></td>	<!-- 조정수량 -->
			    						<td GH="160 STD_QTBLKD" GCol="text,QTBLKD" GF="N 20"></td>	<!-- 보류수량 -->
			    						<td GH="50 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3"></td>	<!-- 단위 -->
			    						<td GH="50 STD_SHPOKY" GCol="text,REFDKY" GF="S 10"></td>	<!-- 출고문서번호 -->
			    						<td GH="50 STD_SHPOIT" GCol="text,REFDIT" GF="S 6"></td>	<!-- 출고문서아이템 -->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10"></td>	<!-- 화주 -->
			    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20"></td>	<!-- 제품코드 -->
			    						<td GH="160 STD_NETWGT" GCol="text,NETWGT" GF="N 20,0"></td>	<!-- 순중량 -->
			    						<td GH="80 STD_LOTA01" GCol="text,LOTA01" GF="S 20"></td>	<!-- LOTA01 -->
			    						<td GH="80 STD_LOTA02" GCol="text,LOTA02" GF="S 20"></td>	<!-- BATCH NO-->
			    						<td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20"></td>	<!-- 벤더 -->
			    						<td GH="80 STD_LOTA04" GCol="text,LOTA04" GF="S 20"></td>	<!-- LOTA04 -->
			    						<td GH="80 STD_LOTA05" GCol="select,LOTA05">	<!-- 포장구분 -->
			    							<select class="input" CommonCombo="LOTA05"></select>
			    						</td>
			    						<td GH="80 STD_LOTA06" GCol="select,LOTA06">
			    							<select class="input" CommonCombo="LOTA06"></select>	<!-- 재고유형 -->
			    						</td>
			    						<td GH="80 STD_LOTA07" GCol="text,LOTA07" GF="S 20"></td>	<!-- 위탁구분 -->
			    						<td GH="80 STD_LOTA08" GCol="text,LOTA08" GF="S 20"></td>	<!--  LOTA08 -->
			    						<td GH="80 STD_LOTA09" GCol="text,LOTA09" GF="S 20"></td>	<!-- LOTA09 -->
			    						<td GH="80 STD_LOTA10" GCol="text,LOTA10" GF="S 20"></td>	<!-- LOTA10 -->
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 10"></td>	<!-- 제조일자 -->
			    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14"></td>	<!-- 입고일자 -->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14"></td>	<!-- 유통기한 -->
			    						<td GH="80 STD_LOTA14" GCol="text,LOTA14" GF="S 14"></td>	<!-- LOTA14 -->
			    						<td GH="80 STD_PGRC03" GCol="text,LOTA15" GF="S 14"></td>	<!-- 주문구분 -->
			    						<td GH="80 RL31_SHPMTY" GCol="text,LOTA16" GF="S 20"></td>	<!-- 출고유형 -->
			    						<td GH="80 ITF_BWTAR" GCol="text,LOTA17" GF="S 20"></td>	<!-- 영업부서 -->
			    						<td GH="80 ITF_BWTARNM" GCol="text,LOTA18" GF="S 20"></td>	<!-- 영업부서명 -->
			    						<td GH="80 IFT_SALENM" GCol="text,LOTA19" GF="S 20"></td>	<!-- 영업사원명 -->
			    						<td GH="80 STD_LOTA20" GCol="text,LOTA20" GF="S 20"></td>	<!-- LOTA20 -->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60"></td>	<!-- 제품명 -->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20"></td>	<!-- 포장단위 -->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10"></td>	<!-- 대분류 -->
			    						<td GH="50 STD_SEBELN" GCol="text,SEBELN" GF="S 15"></td>	<!-- 구매오더 NO -->
			    						<td GH="50 STD_SEBELP" GCol="text,SEBELP" GF="S 6"></td>	<!-- 구매오더 -->
			    						<td GH="50 STD_SVBELN" GCol="text,SVBELN" GF="S 40"></td>	<!-- S/O번호 -->
			    						<td GH="50 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6"></td>	<!-- 주문번호(D/O) -->
			    						<td GH="100 STD_ADJRSN" GCol="text,ADJRSN" GF="S 255"></td>	<!-- 조정상세사유 -->
			    						<td GH="80 IFT_DOCDATMV" GCol="text,SHPIDAT" GF="D 17"></td>	<!-- 출고문서일자 -->
			    						<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 17"></td>	<!-- 배송일자 -->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" ></td>	<!-- 팔렛당수량 -->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" ></td>	<!-- 박스입수 -->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1"></td>	<!-- 박스수량 -->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2"></td>	<!-- 팔레트 수량 -->
			    						<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0"></td>	<!-- 잔량 -->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8"></td>	<!-- 생성일자 -->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6"></td>	<!-- 생성시간 -->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20"></td>	<!-- 생성자 -->
			    						<td GH="88 STD_DPTNKY" GCol="text,DPTNKY" GF="S 60"></td>	<!-- 업체코드 -->
			    						<td GH="88 STD_DPTNKYNM" GCol="text,DPTNKYNM" GF="S 60"></td>	<!-- 업체명 -->
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