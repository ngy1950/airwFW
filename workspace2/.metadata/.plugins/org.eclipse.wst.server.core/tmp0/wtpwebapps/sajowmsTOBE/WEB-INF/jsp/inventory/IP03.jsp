<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Inventory",
			command : "IP03",
			itemGrid : "gridItemList",
			itemSearch : true,
			pkcol : "PHYIKY",
		    menuId : "IP03"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Inventory",
			command : "IP03_ITEM",
		    menuId : "IP03"
	    });
		 
		gridList.setReadOnly("gridHeadList", true, ["PHSCTY"]);
		gridList.setReadOnly("gridItemList", true, ["RSNADJ","LOTA02" , "LOTA05", "LOTA06"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var param = gridList.getRowData(gridId, rowNum);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("DOCCAT", "500");
			param.put("DOCUTY", "511");
			param.put("OWNRKY", $("#OWNRKY").val());
			
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA05"){
				param.put("CMCDKY", "LOTA05");	
			}else if(name == "LOTA06"){
				param.put("CMCDKY", "LOTA06");	
			}
			
		}else if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT","500");
		}
		return param;
	}
	
/* 	function parseInt(ta(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var item = gridList.getSelectData("gridItemList", true);
			
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/inbound/json/saveGR01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	} */
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "IP03");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "IP03");
		}/* else if(btnName == "Save"){
			saveData();
		} */
	}

	function linkPopCloseEvent(data){//팝업 종료 
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
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
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<!-- <input type="button" CB="Save SAVE BTN_SAVE" /> -->
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
					
					<!-- 재고조사일자 -->
					<dl>
						<dt CL="STD_PHYDAT"></dt> 
						<dd>
							<input type="text" class="input" name="DOCDAT" UIInput="R" UIFormat="C N" PGroup="G1,G2"/>
						</dd>
					</dl>
					
					<!-- 동 -->
					<dl>
						<dt CL="STD_AREAKY"></dt>
						<dd>
							<input  class="input" name="I.AREAKY" id="AREAKY"  UIInput="SR,SHAREMA"></input>
						</dd>
					</dl>
					
					<!-- 존 -->
					<dl>
						<dt CL="STD_ZONEKY"></dt>
						<dd> 
							<input  class="input" name="ZONEKY" id="ZONEKY" UIInput="SR,SHZONMA" ></input>
						</dd>
					</dl>
					
					<!-- 로케이션 -->
					<dl>
						<dt CL="STD_LOCAKY"></dt>
						<dd>
							<input class="input"  name="I.LOCAKY" id="LOCAKY" UIInput="SR,SHLOCMA"></input>
						</dd>
					</dl>
					
					<!-- 제품코드 -->
					<dl>  
						<dt CL="STD_SKUKEY"></dt>
						<dd>
							<input class="input" name="SKUKEY" id="SKUKEY"  UIInput="SR,SHSKUMA"></input>
						</dd>
					</dl>
					
					<!-- 제품명 -->
					<dl>
						<dt CL="STD_DESC01"></dt>
						<dd>
							<input class="input" name="DESC01" id="DESC01"  UIInput="SR"></input>
						</dd>
					</dl>
					
					<!-- 팔렛트ID -->
					<dl>
						<dt CL="STD_TRNUID"></dt>
						<dd>
							<input class="input" name="TRNUID" id="TRNUID"  UIInput="SR"></input>
						</dd>
					</dl>
					
					<!-- 실사유형 -->
					<dl>
						<dt CL="STD_PHSCTYP"></dt>
						<dd>
							<input type="text" class="input" name="PHSCTY" UIInput="SR,SHDOCTM" />
						</dd>                                      
					</dl>
					
					<!-- 유통기한 -->
					<dl>
						<dt CL="STD_LOTA13"></dt>
						<dd>
							<input type="text" class="input" name="LOTA13" id="LOTA13" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					
					<!-- 입고일자 -->
					<dl>
						<dt CL="STD_LOTA12"></dt>
						<dd>
							<input type="text" class="input" name="LOTA12" id="LOTA12" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					
					<!-- 벤더 -->
					<dl>
						<dt CL="STD_LOTA03"></dt>
						<dd>
							<input type="text" class="input" name="LOTA03" UIInput="SR,SHLOTA03CM" />
						</dd>
					</dl>
					
					<!-- 포장구분 -->
					<dl>
						<dt CL="STD_LOTA05"></dt>
						<dd>
							<input type="text" class="input" name="LOTA05" UIInput="SR,SHLOTA05" />
						</dd>
					</dl>
					
					<!-- 재고유형 -->
					<dl>
						<dt CL="STD_LOTA06"></dt>
						<dd>
							<input type="text" class="input" name="LOTA06" UIInput="SR,SHLOTA06" />
						</dd>
					</dl>

				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs top_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
								        <td GH="100 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td> <!--재고조사번호-->
								        <td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
								        <td GH="80 STD_ENDCK"  GCol="text,INDDCL" GF="S 10">완료</td> <!--완료-->
								        <td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 10">문서일자</td> <!--문서일자-->
								        <td GH="160 STD_PHSCTYP" GCol="select,PHSCTY"><!--실사 유형-->
								        	<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
								        </td>
								        <td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td> <!--문서유형-->
								        <td GH="80 STD_ADJUTYNM" GCol="text,DOCCATNM" GF="S 4">유형명</td> <!--유형명-->
								        <td GH="80 STD_USRID1" GCol="text,USRID1" GF="S 20">배송지우편번호</td> <!--배송지우편번호-->
								        <td GH="80 STD_UNAME1" GCol="text,UNAME1" GF="S 20">배송지주소</td> <!--배송지주소-->
								        <td GH="80 STD_DEPTID1" GCol="text,DEPTID1" GF="S 20">배송고객명</td> <!--배송고객명-->
								        <td GH="80 STD_DNAME1" GCol="text,DNAME1" GF="S 20">배송지전화번호</td> <!--배송지전화번호-->
								        <td GH="80 STD_USRID2" GCol="text,USRID2" GF="S 20">업무담당자</td> <!--업무담당자-->
								        <td GH="80 STD_UNAME2" GCol="text,UNAME2" GF="S 20">업무담당자명</td> <!--업무담당자명-->
								        <td GH="80 STD_DEPTID2" GCol="text,DEPTID2" GF="S 20">업무 부서</td> <!--업무 부서-->
								        <td GH="80 STD_DNAME2" GCol="text,DNAME2" GF="S 20">업무 부서명</td> <!--업무 부서명-->
								        <td GH="80 STD_USRID3" GCol="text,USRID3" GF="S 20">현장담당</td> <!--현장담당-->
								        <td GH="80 STD_UNAME3" GCol="text,UNAME3" GF="S 20">현장담당자명</td> <!--현장담당자명-->
								        <td GH="80 STD_DEPTID3" GCol="text,DEPTID3" GF="S 20">현장담당 부서</td> <!--현장담당 부서-->
								        <td GH="80 STD_DNAME3" GCol="text,DNAME3" GF="S 20">현장담당 부서명</td> <!--현장담당 부서명-->
								        <td GH="80 STD_USRID4" GCol="text,USRID4" GF="S 20">현장책임</td> <!--현장책임-->
								        <td GH="80 STD_UNAME4" GCol="text,UNAME4" GF="S 20">영업사원명</td> <!--영업사원명-->
								        <td GH="80 STD_DEPTID4" GCol="text,DEPTID4" GF="S 20">현장책임 부서</td> <!--현장책임 부서-->
								        <td GH="80 STD_DNAME4" GCol="text,DNAME4" GF="S 20">영업사원연락처</td> <!--영업사원연락처-->
								        <td GH="80 STD_DOCTXT" GCol="text,DOCTXT" GF="S 100">비고</td> <!--비고-->
								        <td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td> <!--생성일자-->
								        <td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td> <!--생성시간-->
								        <td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td> <!--생성자-->
								        <td GH="80 STD_TRNDAT" GCol="text,TRNDAT" GF="D 10">전송일자</td> <!--전송일자-->
								        <td GH="80 STD_TRNTIM" GCol="text,TRNTIM" GF="T 10">전송시간</td> <!--전송시간-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
			</div>
			<div class="content_layout tabs bottom_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="100 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td> <!--재고조사번호-->
							            <td GH="70 STD_SADJIT" GCol="text,PHYIIT" GF="S 6">조정 Item</td> <!--조정 Item-->
								        <td GH="160 STD_RSNADJ" GCol="select,RSNADJ" > <!--조정사유코드-->
								        	<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option></option>
											</select>
										</td>
								        <td GH="80 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td> <!--재고키-->
								        <td GH="80 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td> <!--Lot number-->
								        <td GH="160 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td> <!--로케이션-->
								        <td GH="160 STD_TRNUID" GCol="text,TRNUID" GF="S 20">팔렛트ID</td> <!--팔렛트ID-->
								        <td GH="50 STD_SECTID" GCol="text,SECTID" GF="S 4">SectionID</td> <!--SectionID-->
								        <td GH="200 STD_PACKID" GCol="text,PACKID" GF="S 30">SET제품코드</td> <!--SET제품코드-->
								        <td GH="160 STD_QTADJU" GCol="text,QTADJU" GF="S 20">조정수량</td> <!--조정수량-->
								        <td GH="160 STD_QTYUOM" GCol="text,QTYUOM" GF="N 20,0">Quantity by unit of measure</td> <!--Quantity by unit of measure-->
								        <!-- <td GH="60 STD_PQTY01" GCol="text,PQTY01" GF="N 4,0">스택패턴 1</td> 스택패턴 1
								        <td GH="60 STD_PQTY02" GCol="text,PQTY02" GF="N 4,0">스택패턴 2</td> 스택패턴 2
							            <td GH="60 STD_PQTY03" GCol="text,PQTY03" GF="N 4,0">스택패턴 3</td> 스택패턴 3
							          	<td GH="60 STD_PQTY04" GCol="text,PQTY04" GF="N 4,0">스택패턴 4</td> 스택패턴 4
							          	<td GH="60 STD_PQTY05" GCol="text,PQTY05" GF="N 4,0">스택패턴 5</td> 스택패턴 5
							          	<td GH="60 STD_PQTY06" GCol="text,PQTY06" GF="N 4,0">스택패턴 6</td> 스택패턴 6 -->
							          	<td GH="50 STD_TRUNTY" GCol="text,TRUNTY" GF="S 4">팔렛타입</td> <!--팔렛타입-->
								        <td GH="80 STD_MEASKY" GCol="text,MEASKY" GF="S 10">단위구성</td> <!--단위구성-->
							          	<td GH="50 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td> <!--단위-->
							          	<td GH="160 STD_QTPUOM" GCol="text,QTPUOM" GF="N 20,0">Units per measure</td> <!--Units per measure-->
							          	<td GH="50 STD_DUOMKY" GCol="text,DUOMKY" GF="S 3">단위</td> <!--단위-->								          
							          	<td GH="160 STD_QTDUOM" GCol="text,QTDUOM" GF="N 20,0">입수</td> <!--입수-->
								        <td GH="50 STD_SUBSIT" GCol="text,SUBSIT" GF="S 6">다음 Item번호</td> <!--다음 Item번호-->
								        <td GH="50 STD_SUBSFL" GCol="text,SUBSFL" GF="S 1">서브Item플래그</td> <!--서브Item플래그-->
								        <td GH="100 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td> <!--참조문서번호-->
								        <td GH="50 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td> <!--참조문서Item번호-->
								        <td GH="50 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td> <!--입출고 구분자-->
								        <td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
								        <td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
								        <td GH="160 STD_LOTA01" GCol="text,LOTA01" GF="S 20">LOTA01</td> <!--LOTA01-->
								        <td GH="160 STD_LOTA02" GCol="text,LOTA02" GF="S 20">BATCH NO</td> <!--BATCH NO-->
								        <td GH="160 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td> <!--벤더-->
								        <td GH="160 STD_LOTA03NM" GCol="text,LOTA03NM" GF="S 20">벤더명</td> <!--벤더명-->
								        <td GH="160 STD_LOTA04" GCol="text,LOTA04" GF="S 20">LOTA04</td> <!--LOTA04-->
								        <td GH="160 STD_LOTA05" GCol="select,LOTA05" > <!--포장구분-->
											<select class="input" CommonCombo="LOTA05">
											</select>
										</td> 
								        <td GH="160 STD_LOTA06" GCol="select,LOTA06" > <!--재고유형-->
											<select class="input" Combo="SajoCommon,CMCDV_COMBO">
												<option></option>
											</select>
										</td>
								        <td GH="160 STD_LOTA07" GCol="text,LOTA07" GF="S 20">위탁구분</td> <!--위탁구분-->
								        <td GH="160 STD_LOTA08" GCol="text,LOTA08" GF="S 20">LOTA08</td> <!--LOTA08-->
								        <td GH="160 STD_LOTA09" GCol="text,LOTA09" GF="S 20">LOTA09</td> <!--LOTA09-->
							            <td GH="160 STD_LOTA10" GCol="text,LOTA10" GF="S 20">LOTA10</td> <!--LOTA10-->
								        <td GH="112 STD_LOTA11" GCol="text,LOTA11" GF="D 10">제조일자</td> <!--제조일자-->
								        <td GH="112 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td> <!--입고일자-->
								        <td GH="112 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td> <!--유통기한-->
								        <td GH="112 STD_LOTA14" GCol="text,LOTA14" GF="S 14">LOTA14</td> <!--LOTA14-->
								        <td GH="112 STD_LOTA15" GCol="text,LOTA15" GF="S 14">LOTA15</td> <!--LOTA15-->
								        <td GH="160 STD_LOTA16" GCol="text,LOTA16" GF="N 20,0">LOTA16</td> <!--LOTA16-->
								        <td GH="160 STD_LOTA17" GCol="text,LOTA17" GF="N 20,0">LOTA17</td> <!--LOTA17-->
								        <td GH="160 STD_LOTA18" GCol="text,LOTA18" GF="N 20,0">LOTA18</td> <!--LOTA18-->
								        <td GH="160 STD_LOTA19" GCol="text,LOTA19" GF="N 20,0">LOTA19</td> <!--LOTA19-->
								        <td GH="160 STD_LOTA20" GCol="text,LOTA20" GF="N 20,0">LOTA20</td> <!--LOTA20-->
							     	    <td GH="80 STD_AWMSNO" GCol="text,AWMSNO" GF="S 10">SEQ(상단시스템)</td> <!--SEQ(상단시스템)-->
								        <td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td> <!--동-->
								        <td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td> <!--제품명-->
								        <td GH="200 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td> <!--규격-->
								        <td GH="160 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td> <!--포장단위-->
								        <td GH="160 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td> <!--세트여부-->
								        <td GH="160 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td> <!--피킹그룹-->
								        <td GH="160 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td> <!--제품구분-->
								        <td GH="160 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td> <!--상온구분-->
								        <td GH="144 STD_EANCOD" GCol="text,EANCOD" GF="S 18">BARCODE(88코드)</td> <!--BARCODE(88코드)-->
								        <td GH="144 STD_GTINCD" GCol="text,GTINCD" GF="S 18">BOX BARCODE</td> <!--BOX BARCODE-->
								        <td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td> <!--대분류-->
								        <td GH="80 STD_SKUG02" GCol="text,SKUG02" GF="S 10">중분류</td> <!--중분류-->
								        <td GH="80 STD_SKUG03" GCol="text,SKUG03" GF="S 10">소분류</td> <!--소분류-->
								        <td GH="80 STD_SKUG04" GCol="text,SKUG04" GF="S 10">세분류</td> <!--세분류-->
								        <td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 20">제품용도</td> <!--제품용도-->
								        <td GH="160 STD_GRSWGT" GCol="text,GRSWGT" GF="S 20">포장중량</td> <!--포장중량-->
								        <td GH="160 STD_NETWGT" GCol="text,NETWGT" GF="S 20">순중량</td> <!--순중량-->
								        <td GH="50 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td> <!--중량단위-->
								        <td GH="160 STD_LENGTH" GCol="text,LENGTH" GF="N 20,0">포장가로</td> <!--포장가로-->
								        <td GH="160 STD_WIDTHW" GCol="text,WIDTHW" GF="N 20,0">포장세로</td> <!--포장세로-->
								        <td GH="160 STD_HEIGHT" GCol="text,HEIGHT" GF="N 20,0">포장높이</td> <!--포장높이-->
								        <td GH="160 STD_CUBICM" GCol="text,CUBICM" GF="N 20,0">CBM</td> <!--CBM-->
								        <td GH="160 STD_CAPACT" GCol="text,CAPACT" GF="N 20,0">CAPA</td> <!--CAPA-->
								        <td GH="80 STD_WORKID" GCol="text,WORKID" GF="S 10"></td> <!---->
								        <td GH="200 STD_WORKNM" GCol="text,WORKNM" GF="S 60">작업자명</td> <!--작업자명-->
							      	    <td GH="80 STD_HHTTID" GCol="text,HHTTID" GF="S 10"></td> <!---->
							            <td GH="50 STD_SMANDT" GCol="text,SMANDT" GF="S 3">Client</td> <!--Client-->
								        <td GH="80 STD_SEBELN" GCol="text,SEBELN" GF="S 10">구매오더 No</td> <!--구매오더 No-->
								        <td GH="50 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td> <!--구매오더 Item-->
								        <td GH="160 STD_SZMIPNO" GCol="text,SZMIPNO" GF="S 20">B/L Item NO</td> <!--B/L Item NO-->
								        <td GH="160 STD_STRAID" GCol="text,STRAID" GF="S 20">SCM주문번호</td> <!--SCM주문번호-->
								        <td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
								        <td GH="50 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td> <!--주문번호(D/O) item-->
								        <td GH="80 STD_STKNUM" GCol="text,STKNUM" GF="S 10">토탈계획번호</td> <!--토탈계획번호-->
								        <td GH="50 STD_STPNUM" GCol="text,STPNUM" GF="S 6">예약 It</td> <!--예약 It-->
								        <td GH="80 STD_SWERKS" GCol="text,SWERKS" GF="S 10">출발지</td> <!--출발지-->
								        <td GH="80 STD_SLGORT" GCol="text,SLGORT" GF="S 10">영업 부문</td> <!--영업 부문-->
								        <td GH="64 STD_SDATBG" GCol="text,SDATBG" GF="S 8">출고계획일시</td> <!--출고계획일시-->
								        <td GH="160 STD_STDLNR" GCol="text,STDLNR" GF="S 20">작업장</td> <!--작업장-->
								        <td GH="80 STD_SSORNU" GCol="text,SSORNU" GF="S 10">차량별피킹번호</td> <!--차량별피킹번호-->
								        <td GH="50 STD_SSORIT" GCol="text,SSORIT" GF="S 6">차량별아이템피킹번호</td> <!--차량별아이템피킹번호-->
								        <td GH="80 STD_SMBLNR" GCol="text,SMBLNR" GF="S 10">Mat.Doc.No.</td> <!--Mat.Doc.No.-->
								        <td GH="50 STD_SZEILE" GCol="text,SZEILE" GF="S 6">Mat.Doc.it.</td> <!--Mat.Doc.it.-->
								        <td GH="50 STD_SMJAHR" GCol="text,SMJAHR" GF="S 4">M/D 년도</td> <!--M/D 년도-->
								        <td GH="128 STD_SXBLNR" GCol="text,SXBLNR" GF="S 16">인터페이스번호</td> <!--인터페이스번호-->
								        <td GH="50 STD_SAPSTS" GCol="text,SAPSTS" GF="S 4">상단시스템 Mvt</td> <!--상단시스템 Mvt-->
								        <td GH="50 STD_QTYSTL" GCol="text,QTYSTL" GF="N 20,0">전산재고</td> <!--전산재고-->
								        <td GH="50 STD_QTSIWH" GCol="text,QTSIWH" GF="N 20,0">재고수량</td> <!--재고수량-->
								        <td GH="50 STD_USEQTY" GCol="text,USEQTY" GF="N 20,0">가용수량</td> <!--가용수량-->
								        <td GH="60 STD_QTSPHY" GCol="text,QTSPHY" GF="N 20,0">재고조사수량</td> <!--재고조사수량-->								        
								        <td GH="50 STD_QTSALO" GCol="text,QTSALO" GF="N 20,0">할당수량</td> <!--할당수량-->
<!-- 								        <td GH="50 STD_QTSPMI" GCol="text,QTSPMI" GF="N 20,0">입고중</td> 입고중
								        <td GH="50 STD_QTSPMO" GCol="text,QTSPMO" GF="N 20,0">이동중</td> 이동중 -->
								        <td GH="50 STD_AUTLOC" GCol="rowCheck">자동창고 여부</td> <!-- 자동창고 여부 -->
								        <td GH="50 STD_QTSBLK" GCol="text,QTBLKD" GF="N 20,0">보류수량</td> <!--보류수량-->
							
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
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