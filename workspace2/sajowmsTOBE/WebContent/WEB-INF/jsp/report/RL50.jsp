<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL50</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var module = 'Report';
var command = 'RL50';
var gridId = 'gridTabList';
var param = null;
var gridNumber = '1';
var now_tab;

	$(document).ready(function() {
		
		gridList.setGrid({
	    	id : 'gridTabList1',
	    	module : module,
			command : 'RL50_TAB1',
		    menuId : "RL50"
	    });
		
		gridList.setGrid({
	    	id : 'gridTabList2',
	    	module : module,
			command : 'RL50_TAB2',
		    menuId : "RL50"
	    });
		
		gridList.setGrid({
	    	id : 'gridTabList3',
	    	module : module,
			command : 'RL50_TAB3',
		    menuId : "RL50"
	    });
		
		gridList.setGrid({
	    	id : 'gridTabList4',
	    	module : module,
			command : 'RL50_TAB4',
		    menuId : "RL50"
	    });
		
		uiList.setActive("Print", true);
		
		// 콤보박스 리드온리
		gridList.setReadOnly("gridTabList1", true, ["OWNRKY", "WAREKY", "CARTYP", "CARGBN", "CARTMP"]);	
		gridList.setReadOnly("gridTabList2", true, ["OWNRKY", "WAREKY", "CARTYP", "CARGBN", "CARTMP"]);	
		gridList.setReadOnly("gridTabList3", true, ["OWNRKY", "WAREKY", "CARTYP", "CARGBN", "CARTMP"]);	
		gridList.setReadOnly("gridTabList4", true, ["OWNRKY", "WAREKY", "CARTYP", "CARGBN", "CARTMP"]);	
		
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
			sajoUtil.openSaveVariantPop("searchArea", "RL50");
		} else if (btnName == 'Getvariant') {
			sajoUtil.openGetVariantPop("searchArea", "RL50");
		} else if(btnName == "Search") {
			search();
		} else if(btnName == "Print") {
			print();
		} else if(btnName == "rowcheck"){
			rowcheck();
		}
	}// end commonBtnClick()	
	
	function rowcheck(){
		var from = ($("#rowcheck_from").val());
		var to = ($("#rowcheck_to").val());
		
		var item = gridList.getGridData(gridId);
		if(item.length == 0 && item.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		if($.trim(from) == ""){
			commonUtil.msgBox("시작 번호를 입력해주세요");
			return;
		}else if($.trim(to) == ""){
			commonUtil.msgBox("끝 번호를 입력해주세요");
			return;
		}
		
		for(var i= (Number)(from)-1; i < (Number)(to); i++){
			gridList.setRowCheck(gridId, i, true);	
		}
	}
	
	
	// 서치헬프 parameter 셋팅
	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj)  {
		param = new DataMap();
		
		if(searchCode == 'SHCMCDV') { // 상온구분
			param.put('CMCDKY', 'ASKU05');
		} 
		
		return param;
	} // end searchHelpEventOpenBefore()
	
	// search(조회)
	function search() {
		param = inputList.setRangeParam('searchArea');

		// 최초 조회 시
		if(now_tab == "" || now_tab == null){	
			gridList.gridList({
				id : 'gridTabList1',
				param : param
			});
			gridId = "gridTabList1";
		} else{
			moveTab(now_tab);	// 조회 클릭 시 현재 보고있는 그리드 탭에서 조회시킴
		}
 		
		
	} // end search()
	
	// grid 조회 시 data 적용이 완료된 후
	function  gridListEventDataBindEnd(gridId, dataLength, excelLoadType) { 
		if(gridId == 'gridTabList1') {
			var list = gridList.getGridData('gridTabList1');
			if(list.length > 0) uiList.setActive("Print", true);					
		}

		gridList.getGridBox(gridId).viewTotal(true);
	} // end gridListEventDataBindEnd()
	
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		var data = new DataMap();
		var option = "height=900,width=1200,resizable=yes";
		if(gridId == "gridTabList1"){
			var data = gridList.getRowData("gridTabList1", rowNum);
			page.linkPopOpen("/wms/report/pop/DRcarListRL50.page", data, option);
		}else if(gridId == "gridTabList2"){
			var data = gridList.getRowData("gridTabList2", rowNum);
			var sorddat = inputList.rangeMap["map"]["VW.ORDDAT"].$from.val().replace(/\./gi,"");
			var eorddat = inputList.rangeMap["map"]["VW.ORDDAT"].$to.val().replace(/\./gi,"");
			data.put("SORDDAT",sorddat);  
			data.put("EORDDAT",eorddat);
			if(eorddat.trim() != "" &&  eorddat.trim() != ""){
				data.put("WHRTYP","BETWEEN");
			}else{
				data.put("WHRTYP","EQUAL");	
			}

			page.linkPopOpen("/wms/report/pop/DRcarListRL50_SUM.page", data, option);
		}
	}
	
	// 탭이동시 호출
	function moveTab(obj) {
		now_tab = obj;
		var objId = $(obj).find('span').attr('id');
		gridNumber = objId.charAt(objId.length - 1);
		
		if(gridNumber == '1') { // 1번탭에서만 프린트를 사용하기 때문
			uiList.setActive("Print", true);
			$("#rowcheck1").show();	
			$("#rowcheck2").show();	
		} else {
			uiList.setActive("Print", false);
			$("#rowcheck1").hide();	
			$("#rowcheck2").hide();
		}
		
		var tabLength  = $('span[id^=tab]').get().length;
		for(var i = 0; i < tabLength; i++) {
			gridList.resetGrid('gridTabList' + (i + 1));
		}
		
		gridId = 'gridTabList' + gridNumber;
		command = 'RL50_TAB' + gridNumber;
		param = inputList.setRangeParam('searchArea');
		
		gridList.gridList({
			id : gridId,
			command : command,
			param : param
		});
	} // end moveTab()
	
	// 프린트
	function print() {
        // wherestr = carnum 변수, 주문 센터, c00102(출고지시여부) parameter
        // orderbystr = header 출고지시여부 표시 parameter
        // ifflg = 로그인자 센터 parameter
        // option = 주문일자 parameter
        
        var printGridId = 'gridTabList1';
        
        if(gridList.validationCheck(printGridId)) {
	        var gridTabList1 = gridList.getSelectData(printGridId);
        	
	        if(gridTabList1.length <= 0) {
	        	commonUtil.msgBox("VALID_M0006");
	        	return;
	        }
	        
	        var dup_orddat_chk  = "";
	        var dup_orddat_key  = "";	
	        var dup_cnt = 0;
	        
	        var count = 0;
			var carnum = "";
			var orddat = "";
			var c00102 = $("#C00102").val();
			var option = "";
			var orderbystr = "";

			var wherestr = " AND VW.CARNUM IN (";
			for(var i = 0; i < gridTabList1.length; i++) {
				if(carnum.length > 2) carnum += ',';
				carnum += "'" + gridTabList1[i].map.CARNUM + "'";
				count++;
			}

			if(inputList.rangeMap.map['VW.ORDDAT'].singleData[0] == null){ //기준일자가 렌지일떄
	        	var docdat = inputList.rangeMap.map['VW.ORDDAT'].rangeData[0].map.FROM;
	        	orddat = docdat;
	        }else if(inputList.rangeMap.map['VW.ORDDAT'].singleData[0] != null){ //기준일자가 싱글데이터일때
	        	var docdat = inputList.rangeMap.map['VW.ORDDAT'].singleData[0].map.DATA;
	        	orddat = docdat;
	        }
			wherestr = wherestr + carnum;
			wherestr += ')';
			wherestr += " AND VW.ORDDAT = '" + orddat + "' ";
			
			var warekyStr = "AND VW.WAREKY = '" + $('#WAREKY').val() + "'";
			wherestr += warekyStr;
			
			switch(c00102) {
				case 'ALL' :
					wherestr += ' AND 1 = 1';
					orderbystr = "'ALL'";
					console.log(orderbystr)
					break;
				case 'B' :
					wherestr += " AND VW.C00102 = 'X' ";
					orderbystr = "'접수'";
					break;
				case 'C' :
					wherestr += " AND VW.C00102 = 'N' ";
					orderbystr = "'확정'";
					break;
				case 'D' :
					wherestr += " AND VW.C00102 = 'Y' AND VW.QTSHPD = 0 ";
					orderbystr = "'출고지시'";
					break;
				case 'E' :
					wherestr += " AND VW.C00102 = 'Y' AND VW.QTSHPD > 0 ";
					orderbystr = "'출고완료'";
					break;
			}
			
					
			var addr = 'upload_car_dr.ezg';
			var optionMap = new DataMap();
			var langKy = "KO";
			var width = 595;
			var heigth = 840;

			var warehouseTxt = $($('select[Combo="SajoCommon,WAREKY_COMCOMBO"]')[0]).find('option[selected="selected"]').text();
			var warehouseArr = warehouseTxt.split(']');
			var warehouse = warehouseArr[warehouseArr.length-1];
			var ifflg = "'" + warehouse + "'";
			
			var option = "AND 1=1";
			optionMap.put('i_option', option);
			optionMap.put('i_ifflg', ifflg);
			
			
			if(count > 0) {
				WriteEZgenElement("/ezgen/" + addr, wherestr, orderbystr, langKy, optionMap , width , heigth ); // 프린트 공통 메소드
				// 1. ezgen/ 뒤의 주소를 해당 연결된 ezgen 주소로 변경
				// 2. wherestr => 쿼리 조합을 변경
				// 3. map은 option 쿼리 가 담겨 있음 map도 쿼리 조합						
			}
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
					<input type="button" CB="Print PRINT BTN_LDPRINT" />
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
					
					<dl>  <!-- 출고일자 -->  
						<dt CL="STD_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" id="ORDDAT" name="VW.ORDDAT" UIInput="B" UIFormat="C N" validate="required"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--출고지시여부-->  
						<dt CL="STD_C00102"></dt> 
						<dd> 
							<select name="C00102" id="C00102" class="input" CommonCombo="C00102_DR" validate="required"></select> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 상온구분 -->  
						<dt CL="STD_ASKU05"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV"/>
						</dd> 
					</dl>
					
					<dl>  <!-- 배송코스명 -->    
						<dt CL="STD_DRCARNAME"></dt> 
						<dd> 
							<input type="text" class="input" name="VW.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 

					<dl>  <!-- 배송코스 -->  
						<dt CL="STD_DRCARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="VW.CARNUM" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!-- 출고유형 -->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="VW.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
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
					<li onclick="moveTab(this);"><a href="#tab1-1"><span id="tab1">일자별</span></a></li>
					<li onclick="moveTab(this);"><a href="#tab1-2"><span id="tab2" >합계</span></a></li>
					<li onclick="moveTab(this);"><a href="#tab1-3"><span id="tab3">일자/거래처별</span></a></li>
					<li onclick="moveTab(this);"><a href="#tab1-4"><span id="tab4">일자/거래처별 합계</span></a></li>
					<!-- rowCheck 부분적용 -->
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;" id="rowcheck1">                                                                                                           
						<span CL="row선택" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE; font-weight: bold;" ></span>                                                                  
						<input type="text" class="input" id="rowcheck_from" name="rowcheck_from" style="width: 50px;">
						~ 
						<input type="text" class="input" id="rowcheck_to" name="rowcheck_to" style="width: 50px;">	       
					</li>                                                                                                                                                   
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;" id="rowcheck2"> <!-- 부분적용 -->                                                                                             
						<input type="button" CB="rowcheck SAVE BTN_PART" />                                                                                                   
					</li>
				</ul>
				<!-- 탭1 -->
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridTabList1">
									<tr CGRow="true">
										<!--화면에 조회 값과 상관없이 로우 선택하는 체크박스 확인   -->
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_KEY" GCol="text,KEY" GF="S 20">key</td>	<!--key-->
			    						<td GH="80 STD_ORDDAT" GCol="text,ORDDAT" GF="D 20"></td>	<!-- 출고일자 -->
			    						<td GH="50 STD_OWNRKY" GCol="select,OWNRKY">	<!-- 화주 -->
			    							<select class="input" Combo="SajoCommon,OWNRKY_COMCOMBO"></select>
			    						</td>
			    						<td GH="50 STD_WAREKY" GCol="select,WAREKY">	<!-- 거점 -->
			    							<select class="input" Combo="SajoCommon,WAREKY_COMCOMBO"></select>
			    						</td>
			    						<td GH="60 STD_CARNUM" GCol="text,CARNUM" GF="S 20"></td>	<!-- 차량번호 -->
			    						<td GH="130 STD_DRCARNUM" GCol="text,DESC01" GF="S 20"></td>	<!-- 배송코스 -->
			    						<td GH="55 STD_DRIVER" GCol="text,DRIVER" GF="S 20"></td>	<!-- 기사명 -->
			    						<td GH="90 STD_CARTYP" GCol="select,CARTYP">	<!-- 차량톤수 -->
			    							<select class="input" CommonCombo="CARTYP"></select>
			    						</td>
			    						<td GH="90 STD_CARGBN" GCol="select,CARGBN">	<!-- 차량구분 -->
			    							<select class="input" CommonCombo="CARGBN"></select>
			    						</td>
			    						<td GH="90 STD_CARTMP" GCol="select,CARTMP">	<!-- 차량온도 -->
			    							<select calss="input" CommonCombo="CARTMP"></select>
			    						</td>
			    						<td GH="60 STD_TOTQTY" GCol="text,QTJCMP" GF="N 20,0"></td>	<!-- 총수량 -->
			    						<td GH="60 STD_BOXQTY" GCol="text,QTYBOX" GF="N 20,1"></td>	<!-- 박스수량 -->
			    						<td GH="60 EZG_DST_ORDNOT" GCol="text,REMQTY" GF="N 20,0">낱개수량</td>	<!--낱개수량-->
			    						<td GH="90 STD_QTJWGT" GCol="text,QTJWGT" GF="N 20,2">총중량(kg)</td>	<!--총중량(kg)-->
			    						<td GH="90 STD_DIFWGT" GCol="text,DIFQTY" GF="N 20,2">차이중량(kg)</td>	<!--차이중량(kg)-->
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
				
				<!-- 탭2 -->
				<div class="table_box section" id="tab1-2">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridTabList2">
									<tr CGRow="true">
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="50 STD_OWNRKY" GCol="select,OWNRKY">	<!-- 화주 -->
			    							<select class="input" Combo="SajoCommon,OWNRKY_COMCOMBO"></select>
			    						</td>
			    						<td GH="50 STD_WAREKY" GCol="select,WAREKY">	<!-- 거점 -->
			    							<select class="input" Combo="SajoCommon,WAREKY_COMCOMBO"></select>
			    						</td>
			    						<td GH="80 STD_ORDDAT" GCol="text,ORDDAT" GF="D 20"></td>	<!-- 출고일자 -->
			    						<td GH="60 STD_CARNUM" GCol="text,CARNUM" GF="S 20"></td>	<!-- 차량번호 -->
			    						<td GH="130 STD_DRCARNUM" GCol="text,DESC01" GF="S 20"></td>	<!-- 배송코스 -->
			    						<td GH="55 STD_DRIVER" GCol="text,DRIVER" GF="S 20"></td>	<!-- 기사명 -->
			    						<td GH="90 STD_CARTYP" GCol="select,CARTYP">	<!-- 차량톤수 -->
			    							<select class="input" CommonCombo="CARTYP"></select>
			    						</td>
			    						<td GH="90 STD_CARGBN" GCol="select,CARGBN">	<!-- 차량구분 -->
			    							<select class="input" CommonCombo="CARGBN"></select>
			    						</td>
			    						<td GH="90 STD_CARTMP" GCol="select,CARTMP">	<!-- 차량온도 -->
			    							<select calss="input" CommonCombo="CARTMP"></select>
			    						</td>
			    						<td GH="60 STD_TOTQTY" GCol="text,QTJCMP" GF="N 20,0"></td>	<!-- 총수량 -->
			    						<td GH="60 STD_BOXQTY" GCol="text,QTYBOX" GF="N 20,1"></td>	<!-- 박스수량 -->
			    						<td GH="60 EZG_DST_ORDNOT" GCol="text,REMQTY" GF="N 20,0">낱개수량</td>	<!--낱개수량-->
			    						<td GH="90 STD_QTJWGT" GCol="text,QTJWGT" GF="N 20,2">총중량(kg)</td>	<!--총중량(kg)-->
			    						<td GH="90 STD_DIFWGT" GCol="text,DIFQTY" GF="N 20,2">차이중량(kg)</td>	<!--차이중량(kg)-->
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
				
				<!-- 탭3 -->
				<div class="table_box section" id="tab1-3">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridTabList3">
									<tr CGRow="true">
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="50 STD_OWNRKY" GCol="select,OWNRKY">	<!-- 화주 -->
			    							<select class="input" Combo="SajoCommon,OWNRKY_COMCOMBO"></select>
			    						</td>
			    						<td GH="50 STD_WAREKY" GCol="select,WAREKY">	<!-- 거점 -->
			    							<select class="input" Combo="SajoCommon,WAREKY_COMCOMBO"></select>
			    						</td>
			    						<td GH="80 STD_ORDDAT" GCol="text,ORDDAT" GF="D 20"></td>	<!-- 출고일자 -->
			    						<td GH="60 STD_CARNUM" GCol="text,CARNUM" GF="S 20"></td>	<!-- 차량번호 -->
			    						<td GH="130 STD_DRCARNUM" GCol="text,DESC01" GF="S 20"></td>	<!-- 배송코스 -->
			    						<td GH="55 STD_DRIVER" GCol="text,DRIVER" GF="S 20"></td>	<!-- 기사명 -->
			    						<td GH="90 STD_CARTYP" GCol="select,CARTYP">	<!-- 차량톤수 -->
			    							<select class="input" CommonCombo="CARTYP"></select>
			    						</td>
			    						<td GH="90 STD_CARGBN" GCol="select,CARGBN">	<!-- 차량구분 -->
			    							<select class="input" CommonCombo="CARGBN"></select>
			    						</td>
			    						<td GH="90 STD_CARTMP" GCol="select,CARTMP">	<!-- 차량온도 -->
			    							<select calss="input" CommonCombo="CARTMP"></select>
			    						</td>
			    						<td GH="90 IFT_PTNROD" GCol="text,PTNROD" GF="S 20"></td>	<!-- 매출처코드 -->
			    						<td GH="90 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20"></td>	<!-- 매출처명 -->
			    						<td GH="90 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20"></td>	<!-- 납품처코드 -->
			    						<td GH="90 STD_SHIPTONM" GCol="text,PTNRTONM" GF="S 20"></td>	<!-- 납품처 명 -->
			    						<td GH="60 STD_TOTQTY" GCol="text,QTJCMP" GF="N 20,0"></td>	<!-- 총수량 -->
			    						<td GH="60 STD_BOXQTY" GCol="text,QTYBOX" GF="N 20,1"></td>	<!-- 박스수량 -->
			    						<td GH="60 EZG_DST_ORDNOT" GCol="text,REMQTY" GF="N 20,0">낱개수량</td>	<!--낱개수량-->
			    						<td GH="90 STD_QTJWGT" GCol="text,QTJWGT" GF="N 20,2">총중량(kg)</td>	<!--총중량(kg)-->
			    						<td GH="90 STD_DIFWGT" GCol="text,DIFQTY" GF="N 20,2">차이중량(kg)</td>	<!--차이중량(kg)-->
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
				
				<!-- 탭4 -->
				<div class="table_box section" id="tab1-4">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridTabList4">
									<tr CGRow="true">
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="50 STD_OWNRKY" GCol="select,OWNRKY">	<!-- 화주 -->
			    							<select class="input" Combo="SajoCommon,OWNRKY_COMCOMBO"></select>
			    						</td>
			    						<td GH="50 STD_WAREKY" GCol="select,WAREKY">	<!-- 거점 -->
			    							<select class="input" Combo="SajoCommon,WAREKY_COMCOMBO"></select>
			    						</td>
			    						<td GH="60 STD_CARNUM" GCol="text,CARNUM" GF="S 20"></td>	<!-- 차량번호 -->
			    						<td GH="130 STD_DRCARNUM" GCol="text,DESC01" GF="S 20"></td>	<!-- 배송코스 	-->
			    						<td GH="55 STD_DRIVER" GCol="text,DRIVER" GF="S 20"></td>	<!-- 기사명 -->
			    						<td GH="90 STD_CARTYP" GCol="select,CARTYP">	<!-- 차량톤수 -->
			    							<select class="input" CommonCombo="CARTYP"></select>
			    						</td>
			    						<td GH="90 STD_CARGBN" GCol="select,CARGBN">	<!-- 차량구분 -->
			    							<select class="input" CommonCombo="CARGBN"></select>
			    						</td>
			    						<td GH="90 STD_CARTMP" GCol="select,CARTMP">	<!-- 차량온도 -->
			    							<select calss="input" CommonCombo="CARTMP"></select>
			    						</td>
			    						<td GH="90 IFT_PTNROD" GCol="text,PTNROD" GF="S 20"></td>	<!-- 매출처코드 -->
			    						<td GH="90 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20"></td>	<!-- 매출처명 -->
			    						<td GH="90 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20"></td>	<!-- 납품처코드 -->
			    						<td GH="90 STD_SHIPTONM" GCol="text,PTNRTONM" GF="S 20"></td>	<!-- 납품처명 -->
			    						<td GH="60 STD_TOTQTY" GCol="text,QTJCMP" GF="N 20,0"></td>	<!-- 총수량 -->
			    						<td GH="60 STD_BOXQTY" GCol="text,QTYBOX" GF="N 20,1"></td>	<!-- 박스수량 -->
			    						<td GH="60 EZG_DST_ORDNOT" GCol="text,REMQTY" GF="N 20,0">낱개수량</td>	<!--낱개수량-->
			    						<td GH="90 STD_QTJWGT" GCol="text,QTJWGT" GF="N 20,2">총중량(kg)</td>	<!--총중량(kg)-->
			    						<td GH="90 STD_DIFWGT" GCol="text,DIFQTY" GF="N 20,2">차이중량(kg)</td>	<!--차이중량(kg)-->
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