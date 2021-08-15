<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DR14</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	var searchParam; 
	var headrow = -1;
	var headcheck = false;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "DaerimReport",
	    	pkcol : "CMCDKY, CMCDVL",
			command : "DR14_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "PTNG08",
		    menuId : "DR14"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "DaerimReport",
	    	pkcol : "MANDT, SEQNO",
			command : "DR14_ITEM",
			emptyMsgType : false,
			tempHead : "gridHeadList",
			useTemp : true,
			tempKey : "PTNG08",
		    menuId : "DR14"
	    });

		gridList.setReadOnly("gridHeadList", true, ["PTNG08"]);
		gridList.setReadOnly("gridItemList", true, ["DOCUTY", "PTNG08", "DIRDVY", "DIRSUP", "C00102" ]);
		
		setVarriantDef();
	});
	
// 	function  gridListEventDataBindEnd(gridId, dataLength, excelLoadType) { 
// 		if("gridItemList" == gridId && dataLength > 0 ){
// 			gridList.checkAll("gridItemList", headcheck );
// 		}
// 	}
	
	
// 	function gridListEventRowCheck(gridId, rowNum, isCheck){	 
// 		if(gridId == "gridHeadList" && isCheck){
// 			if(headrow == rowNum){
// 				gridList.checkAll("gridItemList", isCheck );
// 			}else{
// 				gridListEventItemGridSearch(gridId, rowNum, "gridItemList");	
// 			}
// 		}
// 	}
	
// 	function gridListEventRowDblclick(gridId, rowNum) {
// 		if(gridId == "gridHeadList"){
// 			headcheck = gridList.getSelectType(gridId, rowNum);
// 		}
// 	}
	
	//버튼 작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print"){   /* 거래명세표 출력(3P) */   
			if ($('#Op1').prop("checked") == true ) {
				if ($('#CHKMAK').prop("checked") == true ){
					check = "10"; //온도구분
				}else {
					check = "1";
				}
	 		}else if ($('#Op2').prop("checked") == true ){
				if ($('#CHKMAK').prop("checked") == true ){
					check = "11"; //온도구분
				}else {
					check = "2";
				}
	 		};
			saveData()
		}else if(btnName == "Print2"){   /* 거래명세표 출력(A4) */   
			if ($('#CHKMAK').prop("checked") == true ) {
				commonUtil.msgBox("A4용지는 상온,냉장/냉동 구분을 할 수 없습니다");
				return;
			}
		
			if ($('#Op1').prop("checked") == true ) {
					check = "3";
	 		}else if ($('#Op2').prop("checked") == true ){
					check = "4";
	 		};
			saveData()
		}else if(btnName == "Print3"){   /* 홈플러스 출력(3P) */    
			if ($('#Op1').prop("checked") == true ) {
				commonUtil.msgBox("매출처 3P로는 홈플러스 전표를 출력할 수 없습니다");
				return;
	 		}else if ($('#CHKMAK').prop("checked") == true ){
	 			commonUtil.msgBox("홈플러스 전표는 상온냉장/냉동 구분을 할 수 없습니다");
				return;
			}else {
				check = "6";
			}
			saveData()
		}else if(btnName == "Print4"){   /* 거래명세표 출력(바코드-3P) */ 
			if ($('#Op1').prop("checked") == true ) {
				if ($('#CHKMAK').prop("checked") == true ){
					check = "12"; //온도구분
				}else {
					check = "7";
				}
			
	 		}else if ($('#Op2').prop("checked") == true ){
				if ($('#CHKMAK').prop("checked") == true ){
					check = "13"; //온도구분
				}else {
					check = "8";
				}
	 		};
	 		saveData()
		}else if(btnName == "Print5"){   /* 맛살/기타제품 출력(3P) */ 
			if ($('#Op1').prop("checked") == true ) {
				commonUtil.msgBox("매출처 3P로는 맛살/기타제품 전표를 출력할 수 없습니다");
				return;
	 		}else if ($('#CHKMAK').prop("checked") == true ){
	 			commonUtil.msgBox("맛살/기타제품 전표는 상온냉장/냉동 구분을 할 수 없습니다");
				return;
			}else {
				check = "9";
			}
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DR14");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DR14");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}

	function searchList(){
		
		if(validate.check("searchArea")){
			headrow = -1;
			headcheck = false;
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			searchParam = inputList.setRangeDataParam("searchArea");
			searchParam.put("SES_WAREKY", "<%=wareky%>")
			
			//라디오 버튼 값
			if ($('#Op1').prop("checked") == true ) {
				searchParam.put("PTNRTY","0001");
			}else if ($('#Op2').prop("checked") == true ){
				searchParam.put("PTNRTY","0007");
			};
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : searchParam
		    });
		}
		
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			headrow = rowNum;
			var rowData = gridList.getRowData(gridId, rowNum);
			searchParam.putAll(rowData);
			searchParam.put("SES_WAREKY", "<%=wareky%>");
			
			if ($('#Op1').prop("checked") == true ) {
				searchParam.put("PTNRTY","0001");
			}else if ($('#Op2').prop("checked") == true ){
				searchParam.put("PTNRTY","0007");
			};
			
			headrow = rowNum;
			
			netUtil.send({
				url : "/DaerimReport/json/displayDR14Item.data",
				param : searchParam,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList" //그리드ID
			}); 
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			var item = gridList.getSelectData("gridItemList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var tempItem = gridList.getSelectTempData("gridHeadList");
			
			searchParam = inputList.setRangeParam("searchArea");
			searchParam.put("headlist",head);
			searchParam.put("list",item);
			searchParam.put("tempItem",tempItem);
			searchParam.put("itemquery","DR14_ITEM");
			searchParam.put("USERID", "<%=userid%>");
			searchParam.put("SES_WAREKY", "<%=wareky%>");
			searchParam.put("OWNRKY", $("#OWNRKY").val());
			
			if ($('#Op1').prop("checked") == true ) {
				searchParam.put("PTNRTY","0001");
			}else if ($('#Op2').prop("checked") == true ){
				searchParam.put("PTNRTY","0007");
			};
			
			netUtil.send({
				url : "/DaerimReport/json/saveDR14.data",
				param : searchParam,
				successFunction : "returnSAVE"
			});
		}
	}
	
	
	function returnSAVE(json, status){
		var ownrky = $('#OWNRKY').val();
		

// 		var item = gridList.getSelectData("gridItemList", true);
// 		//체크가 없을 경우 
// 		if(item.length == 0){
// 			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
// 			return;
// 		}

		
		var wherestr = "";  
		var orderby = "";
		
		if ($('#Op1').prop("checked") == true ) {
				wherestr = wherestr+" AND I.OWNRKY = '" + ownrky+"' AND I.PTNROD IN (";
				wherestr += json.data["SAVEKEY"];
			wherestr += ")";
		} else if ($('#Op2').prop("checked") == true ) {
				wherestr = wherestr+" AND I.OWNRKY = '" + ownrky+"' AND I.PTNRTO IN (";
				wherestr += json.data["SAVEKEY"];
			wherestr += ")";
		}
				
		orderby += getMultiRangeDataSQLEzgen('B2.NAME03', 'B2.NAME03');	
		orderby += getMultiRangeDataSQLEzgen('IT.DOCUTY', 'I.DOCUTY');	
		orderby += getMultiRangeDataSQLEzgen('IT.ORDDAT', 'I.ORDDAT');	
		orderby += getMultiRangeDataSQLEzgen('IT.OTRQDT', 'I.OTRQDT');	
		orderby += getMultiRangeDataSQLEzgen('IT.TEXT02', 'I.TEXT02');
		orderby += getMultiRangeDataSQLEzgen('IT.DIRSUP', 'I.DIRSUP');
		
		 if ($('#Op1').prop("checked") == true ) {
			 orderby += getMultiRangeDataSQLEzgen('B.PTNRKY', 'I.PTNROD');	
		} else if ($('#Op2').prop("checked") == true ) {
			orderby += getMultiRangeDataSQLEzgen('B.PTNRKY', 'I.PTNRTO');	
		} 
		orderby += getMultiRangeDataSQLEzgen('IT.DIRDVY', 'I.DIRDVY');
		orderby += getMultiRangeDataSQLEzgen('C.CARNUM', 'C.CARNUM');
		orderby += getMultiRangeDataSQLEzgen('B.PTNG01', 'B.PTNG01');	
		orderby += getMultiRangeDataSQLEzgen('B.PTNG02', 'B.PTNG02');	
		orderby += getMultiRangeDataSQLEzgen('B.PTNG03', 'B.PTNG03');	
		orderby += getMultiRangeDataSQLEzgen('SM.ASKU05', 'SM.ASKU05');
				
		var langKy = "KO";
		var width = 595;
		var heigth = 890;
		var map = new DataMap();
			map.put("i_option", '\'<%=wareky %>\'');
			map.put("i_orderby",orderby);
			
		/* PRTSK 테이블에 자재별 출력 순서가 지정되어있음
		어묵은 001 , 나머지 상품은 002 */
		if( check == "1" ){ //거래명세표(매출처_3P)
			WriteEZgenElement("/ezgen/shpdri_sale_list_3P_integrated.ezg" , wherestr , " " , langKy, map , width , heigth );
		}else if( check == "2" ){ //거래명세표(매출처_3P)
			WriteEZgenElement("/ezgen/shpdri_deli_list_3P_integrated.ezg" , wherestr , " " , langKy, map , width , heigth );	
		}else if( check == "3" ){ //거래명세표(매출처_A4)
			WriteEZgenElement("/ezgen/shpdri_sale_list_A4_integrated.ezg" , wherestr , " " , langKy, map , width , heigth );
		}else if( check == "4" ){ //거래명세표(매출처_A4)
			WriteEZgenElement("/ezgen/shpdri_deli_list_A4_integrated.ezg" , wherestr , " " , langKy, map , width , heigth );	
		}else if( check == "6" ){ //홈플러스 거래명세표(납품처_3P)
			WriteEZgenElement("/ezgen/shpdri_deli_list_3P_integrated_prtseq.ezg" , wherestr , " " , langKy, map , width , heigth );	
		}else if( check == "7" ){ //거래명세표 3P 바코드(매출처)
			WriteEZgenElement("/ezgen/shpdri_sale_list_3P_integrated_barcode.ezg" , wherestr , " " , langKy, map , width , heigth );	
		}else if( check == "8" ){ //거래명세표 3P 바코드(납품처)
			WriteEZgenElement("/ezgen/shpdri_deli_list_3P_integrated_barcode.ezg" , wherestr , " " , langKy, map , width , heigth );	
		}else if( check == "9" ){ //맛살 분리 거래명세표 
			WriteEZgenElement("/ezgen/shpdri_deli_list_3P_integrated_skug03.ezg" , wherestr , " " , langKy, map , width , heigth );	
		}else if( check == "10" ){ //거래명세표(온도구분 - 안산 매출처 )
			WriteEZgenElement("/ezgen/shpdri_sale_list_3P_integrated_asku05.ezg" , wherestr , " " , langKy, map , width , heigth );	
		}else if( check == "11" ){ //거래명세표(온도구분 - 안산 납품처 )
			WriteEZgenElement("/ezgen/shpdri_deli_list_3P_integrated_asku05.ezg" , wherestr , " " , langKy, map , width , heigth );	
		}else if( check == "12" ){ //거래명세표 3P 바코드(온도구분 - 매출처 )
			WriteEZgenElement("/ezgen/shpdri_sale_list_3P_integrated_barcode_asku05.ezg" , wherestr , " " , langKy, map , width , heigth );	
		}else if( check == "13" ){ //거래명세표 3P 바코드(온도구분 - 납품처 )
			WriteEZgenElement("/ezgen/shpdri_deli_list_3P_integrated_barcode_asku05.ezg" , wherestr , " " , langKy, map , width , heigth );	
		}
	
		gridListEventItemGridSearch("gridHeadList", headrow , "gridItemList");
	}
	
	
	//저장성공시 callback
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["REUSLT"] == "1"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();

		//차량번호
		if(searchCode == "SHCARMA2" && $inputObj.name == "C.CARNUM"){
	        param.put("WAREKY","<%=wareky %>");	
		//거래처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "B.PTNRKY"){
			param.put("PTNRTY","0002");
	        param.put("OWNRKY","<%=ownrky %>");	
		//주문구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "IT.DIRSUP"){
	        param.put("CMCDKY","PGRC03");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		//배송구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "IT.DIRDVY"){
	        param.put("CMCDKY","PGRC02");
	    	param.put("OWNRKY","<%=ownrky %>");   
		//유통경로1
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG01"){
	        param.put("CMCDKY","PTNG01");
	    	param.put("OWNRKY","<%=ownrky %>");
		//유통경로2
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG02"){
	        param.put("CMCDKY","PTNG02");
	    	param.put("OWNRKY","<%=ownrky %>");
		//유통경로3
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG03"){
	        param.put("CMCDKY","PTNG03");
	    	param.put("OWNRKY","<%=ownrky %>");	
		//상온구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
	        param.put("CMCDKY","ASKU05");
	    	param.put("OWNRKY","<%=ownrky %>");  
		} return param;
	}

</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner contentH_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Print PRINT_OUT BTN_PRINT_3P" /> <!-- 거래명세표 출력(3P) -->
					<input type="button" CB="Print2 PRINT_OUT BTN_PRINT_A4" /> <!-- 거래명세표 출력(A4) -->
					<input type="button" CB="Print3 PRINT_OUT BTN_PRTHP_3P" /> <!-- 홈플러스 출력(3P) -->
					<input type="button" CB="Print4 PRINT_OUT BTN_PRTBC_3P" /> <!-- 거래명세표 출력(바코드-3P) -->
					<input type="button" CB="Print5 PRINT_OUT BTN_PRTPD_3P" /> <!-- 맛살/기타제품 출력(3P) -->

				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl> <!--화주-->  
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_BZGBN"></dt><!-- 거래처구분 -->
						<dd>
							<input type="radio" name="OP" id="Op1" value="Op1" checked /><label for="Op1">매출처</label>
		        			<input type="radio" name="OP" id="Op2" value="Op2" /><label for="Op2">납품처</label>
						</dd>
					</dl>
					<dl>  <!--냉장/냉동 구분-->  
						<dt CL="STD_DEFSORT"></dt> 
						<dd> 
							<input type="checkbox" class="input" name="CHKMAK" id="CHKMAK" />
						</dd> 
					</dl>
					<dl>  <!--출고거점-->  
						<dt CL="STD_NAME03B"></dt> 
						<dd> 
							<input type="text" class="input" name="B2.NAME03" UIInput="SR,SHWAHMA" value="<%=wareky%>"/>
						</dd> 
					</dl>  
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고일자-->  
						<dt CL="STD_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.ORDDAT" UIInput="B" UIFormat="C N" validate="required"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="STD_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.OTRQDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>
					<dl>  <!--차량번호-->  
						<dt CL="STD_VEHINO"></dt> 
						<dd> 
							<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHCARMA2" /> 
						</dd> 
					</dl>
					<dl>  <!--거래처코드-->  
						<dt CL="STD_PTNRKY_1"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNRKY" UIInput="SR,SHBZPTN" /> 
						</dd> 
					</dl>
					<dl>  <!--거래명세표출력번호-->  
						<dt CL="STD_DOCSEQ"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.TEXT02" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRSUP" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRDVY" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로1-->  
						<dt CL="STD_PTNG01"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG01" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로2-->  
						<dt CL="STD_PTNG02"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG02" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로3-->  
						<dt CL="STD_PTNG03"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG03" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--상온구분-->  
						<dt CL="STD_ASKU05"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl>
				</div> 
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap h-wrap-min">	
				<div class="content_layout tabs content_left" style="width: 370px;">
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
											<td GH="40" GCol="rowCheck"></td>
											<td GH="40" GCol="rownum">1</td>
											<td GH="120 STD_PTNG08" GCol="select,PTNG08">	<!--마감구분-->
												<select class="input" commonCombo="PTNG08"></select>
											</td>
				    						<td GH="80 STD_CLNT" GCol="text,NUM01" GF="N 4,0">거래처</td>	<!--거래처-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<button type='button' GBtn="saveLayout"></button>
							<button type='button' GBtn="getLayout"></button>
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
				</div>
				<div class="content_layout tabs content_right" style="width : calc(100% - 370px);">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>상세내역</span></a></li>
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
									<tbody id="gridItemList">
										<tr CGRow="true">
<!-- 											<td GH="40" GCol="rowCheck"></td> -->
											<td GH="40 STD_CHECKED" GCol="rowCheck"></td>
											<td GH="120 STD_DOCSEQ" GCol="text,TEXT02" GF="S 20">거래명세표출력번호</td> <!--거래명세표출력번호-->
											<td GH="120 IFT_DOCUTY" GCol="select,DOCUTY">
												<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select> <!--출고유형-->
											</td>
											<td GH="80 STD_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td> <!--출고일자-->
											<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td> <!--출고요청일-->
											<td GH="80 STD_PTNG08" GCol="select,PTNG08">
												<select class="input" commonCombo="PTNG08"></select>	<!--마감구분-->
											</td>
											<td GH="80 STD_PTNRKY" GCol="text,PTNRKY" GF="S 20">업체코드</td> <!--업체코드-->
											<td GH="100 STD_PTNRNM" GCol="text,PTNRNM" GF="S 20">거래처명</td> <!--거래처명-->
											<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td> <!--차량번호-->
											<td GH="90 STD_DESC01_C" GCol="text,CARNUMNM" GF="S 20"></td> <!--차량등번-->
											<td GH="80 IFT_DIRDVY" GCol="text,DIRDVY">
												<select class="input" commonCombo="PTNG02"></select>	 <!--배송구분-->
											</td>
											<td GH="150 IFT_DIRSUP" GCol="select,DIRSUP">
												<select class="input" commonCombo="PTNG03"></select>	<!--주문구분-->
											</td> 
											<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 100">비고</td> <!--비고-->
											<td GH="80 IFT_C00102" GCol="select,C00102">
												<select class="input" commonCombo="C00102"></select> <!--승인여부-->
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!--  							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<button type='button' GBtn="saveLayout"></button>
							<button type='button' GBtn="getLayout"></button>
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
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