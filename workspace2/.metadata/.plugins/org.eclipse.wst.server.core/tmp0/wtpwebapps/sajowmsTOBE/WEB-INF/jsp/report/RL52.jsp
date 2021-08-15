<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL52</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var module = 'Report';
var headCommand = 'RL52_HEAD';
var itemCommand = 'RL52_ITEM';
var gridHeadId = 'gridHeadList';
var gridItemId = 'gridItemList';
var gridAllId = [gridHeadId, gridItemId];
var param = null;

	$(document).ready(function() {
		
		gridList.setGrid({
	    	id : gridHeadId,
	    	module : module,
			command : headCommand,
			itemGrid : gridItemId,
		    itemSearch : true,
		    menuId : "RL52"
	    });

		gridList.setGrid({
			id : gridItemId,
			module : module,
			command : itemCommand,
		    menuId : "RL52"
		});
		
		//uiList.setActive("Reload", false);
		
		// 콤보박스 리드온리
		gridList.setReadOnly(gridHeadId, true, ["WAREKY"]);	
		gridList.setReadOnly(gridItemId, true, ["DOCUTY", "PTNG08", "WARESR", "DIRDVY", "DIRSUP", "C00103", "C00102"]);		
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function linkPopCloseEvent(data) { //팝업 종료 
		if(data.get("TYPE") == "GET") { 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	} // end linkPopCloseEvent()	
	
	// 버튼 클릭
	function commonBtnClick(btnName){
		if (btnName == 'Savevariant') {
			sajoUtil.openSaveVariantPop("searchArea", "MV06");
		} else if (btnName == 'Getvariant') {
			sajoUtil.openGetVariantPop("searchArea", "MV06");
		} else if(btnName == "Search") {
			search();
		} /* else if(btnName == "Reload") {
			reload();
		} */
	}// end commonBtnClick()
	
	// 콤보박스 parameter 셋팅
	function comboEventDataBindeBefore(comboAtt, $comboObj) {
		param = new DataMap();
		if(comboAtt == 'SajoCommon,RSNCOD_COMCOMBO') {
			param.put('OWNRKY', $('#OWNRKY').val());
			param.put('DOCCAT', '200');
			param.put('DOCUTY', '214');
		} 
		return param;
	} // end comboEventDataBindeBefore()
	
	// search(조회)
	function search() {
		if(validate.check('searchArea')) {
			param = inputList.setRangeParam('searchArea');
			gridList.gridList({
				id : gridHeadId,
				param : param
			});				
		}

		
	} // end search()
	
	// grid 조회 시 data 적용이 완료된 후
	function  gridListEventDataBindEnd(gridId, dataLength, excelLoadType) { 
		//uiList.setActive("Reload", true);
	} // end gridListEventDataBindEnd()
	
	//아이템그리드 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			//row데이터 이외에 검색조건 추가가 필요할 떄 
			var rowData = gridList.getRowData(gridId, rowNum);
			param = inputList.setRangeParam("searchArea");
			
			param.putAll(rowData);

			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	// reload(재조회)
	function reload() {
		
		for(var i = 0; i < gridAllId.length; i++) {
			gridList.resetGrid(gridAllId[i]);
			search();			
		}
	} // end reload()
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
					<!-- <input type="button" CB="Reload RESET STD_REFLBL" /> -->
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
					
					<dl>  <!-- 출고요청일 -->  
						<dt CL="IFT_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.OTRQDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
										
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs content_left" style="width: 550px;">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>Header 리스트</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="150 IFT_WAREKY" GCol="select,WAREKY"> <!-- WMS거점(출고사업장) -->
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>	
			    						<td GH="80 STD_NUMOP" GCol="text,NUM01" GF="N 5">미종결주문수</td>	<!--미종결주문수-->
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
			<div class="content_layout tabs content_right" style="width : calc(100% - 570px)">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 IFT_DOCUTY" GCol="select,DOCUTY">	<!-- 출고유형 -->
			    							<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
			    						</td>
			    						<td GH="80 STD_ORDDAT" GCol="text,ORDDAT" GF="D 8"></td>	<!-- 출고일자 -->
			    						<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8"></td>	<!-- 출고요청일 -->
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40"></td>	<!-- S/O번호 -->
			    						<td GH="80 STD_PTNG08" GCol="select,PTNG08"> 	<!-- 마감구분 -->
			    							<select class="input" CommonCombo="PTNG08"></select>
			    						</td>
			    						<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20"></td>	<!-- 납품처코드 -->
			    						<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20"></td>	<!-- 납품처명 -->
			    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20"></td>	<!-- 매출처코드 -->
			    						<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20"></td>	<!-- 매출처명 -->
			    						<td GH="100 IFT_WARESR" GCol="select,WARESR"> 	<!-- 요구사업장 -->
			    							<select class="input" CommonCombo="PTNG06"></select>
			    						</td>
			    						<td GH="80 IFT_DIRDVY" GCol="select,DIRDVY">	<!-- 배송구분 -->
			    							<select class="input" CommonCombo="PGRC02"></select>
			    						</td>
			    						<td GH="80 IFT_DIRSUP" GCol="select,DIRSUP">	<!-- 주문구분 -->
			    							<select class="input" CommonCombo="PGRC03"></select>
			    						</td>
			    						<td GH="80 IFT_C00103" GCol="select,C00103">	<!-- 사유코드 -->
			    							<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
			    								<option value="" selected></option>
			    							</select>
			    						</td>
			    						<td GH="80 IFT_TEXT01" GCol="text,TEXT01"></td>	<!-- 비고 -->
			    						<td GH="80 IFT_C00102" GCol="select,C00102"> 	<!-- 승인여부 -->
			    							<select class="input" CommonCombo="C00102"></select>
			    						</td>
			    						<td GH="80 STD_CTODDT" GCol="text,XDATS" GF="D 10"></td>	<!-- 주문일자 -->
			    						<td GH="80 STD_ORDTIM" GCol="text,XTIMS" GF="T 10">주문시간</td>	<!--주문시간-->
									</tr>
								</tbody>
							</table>
						</div> 
					</div>
					<div class="btn_lit tableUtil">
					    <button type="button" GBtn="find"></button>      
					    <button type="button" GBtn="sortReset"></button> 
					    <button type="button" GBtn="layout"></button>        
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