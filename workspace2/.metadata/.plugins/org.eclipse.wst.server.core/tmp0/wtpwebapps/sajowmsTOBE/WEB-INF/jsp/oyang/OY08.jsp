<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>OY08</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OyangReport",
			command : "OY08_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "OY08"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OyangReport",
			command : "OY08_ITEM",
		    menuId : "OY08"
	    });	
		
		//ReadOnly 설정(아이템 그리드  권한 막기)
		gridList.setReadOnly("gridHeadList",true,["OWNRKY","DOCUTY","DIRDVY","DIRSUP"]);
		gridList.setReadOnly("gridItemList",true,["WAREKY"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});


	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			
			param.putAll(rowData);	
			param.put("WAREKY",$("#WAREKY").val());
			
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "101");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}

	//저장성공시 callback
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
// 			}else if(json.data["RESULT"] == "Em"){
// 				commonUtil.msgBox("SYSTEM_NOTGROUP");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}	
	
	//버튼 동작 연결
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print"){
			if($('#CHKMAK').prop("checked") == true ){//거래처 제품피킹
				check = "1"; //온도구분
			}else{
				check = "11";
			}
			saveData(); 
			
		}else if(btnName == "Print2"){
			if($('#CHKMAK').prop("checked") == true ){//제품 거래처피킹
				check = "2"; //온도구분
			}else{
				check = "22";
			}
			saveData(); 
			
		}else if(btnName == "Print3"){
			if($('#CHKMAK').prop("checked") == true ){//품목별 총량집계표
				check = "3"; //온도구분
			}else{
				check = "33";
			}
			saveData(); 
		
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "OY08");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "OY08");
 		}
	}
		
	
	function saveData(){
		
		var head = gridList.getSelectData("gridHeadList", true);
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
			
		if(gridList.validationCheck("gridHeadList", "select")){
			var item = gridList.getSelectData("gridItemList", true);
			var param = inputList.setRangeDataParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/OyangReport/json/saveOY08.data",
				param : param,
				successFunction : "returnSAVE"
			});
			
		}
	}
		
	
	//ezgen 
	function returnSAVE(json, status) {
		
		var count = 0;
 
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);

			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}

			var where = "";    
			where = where+" AND TEXT03 IN (";
			where += "'" + json.data.TEXT03 + "'";
			where += ")";
			
			//이지젠 호출부(신버전)
			var langKy = "KO";
			var map = new DataMap();
			var width = 600;
			var height = 860;
			if( check == "1" ){
				//거래처/제품 피킹-온도구분
				WriteEZgenElement("/ezgen/oy_bzptn_picking_sale_list_asku05.ezg" , where , "" , langKy, map , width , height );
			}else if( check == "11" ){
				WriteEZgenElement("/ezgen/oy_bzptn_picking_sale_list.ezg" , where , "" , langKy, map , width , height );
				
				//제품/거래처 피킹 - 온도구분
			}else if( check == "2" ){
				WriteEZgenElement("/ezgen/product_picking_sale_list_oy_asku05.ezg" , where , "" , langKy, map , width , height );
 			}else if( check == "22" ){
 				WriteEZgenElement("/ezgen/product_picking_sale_list_oy.ezg" , where , "" , langKy, map , width , height );
 				
 				//품목별 총량집계 - 온도구분
 			}else if(check == "3" ){
 				WriteEZgenElement("/ezgen/picking_total_sale_list_oy_asku05.ezg" , where , "" , langKy, map , width , height );
 			}else if(check == "33" ){
 				WriteEZgenElement("/ezgen/picking_total_sale_list_oy.ezg" , where , "" , langKy, map , width , height );
 			}
			
			searchList();
 		}
 	}
		


	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        //주문구분
        if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        //배송구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY","<%=ownrky %>");
        //상온구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
            param.put("CMCDKY","ASKU05");
            param.put("OWNRKY","<%=ownrky %>");
        //소분류
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG03"){
		     param.put("CMCDKY","SKUG03");
		     param.put("OWNRKY","<%=ownrky %>");
		//납품처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
	        param.put("PTNRTY","0007");
	        param.put("OWNRKY","<%=ownrky %>");
	    //매출처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNROD"){
	        param.put("PTNRTY","0001");
	        param.put("OWNRKY","<%=ownrky %>");	
        //피킹그룹
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "PK.PICGRP"){
	        param.put("CMCDKY","PICGRP");
	        param.put("OWNRKY","<%=ownrky %>");	
        }
    	return param;
    }
	
	//팝업 종료 
    function linkPopCloseEvent(data){  
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
					<input type="button" CB="Print PRINT_OUT BTN_PTNRSKUPIC" /> <!-- 거래처/제품 피킹 -->
					<input type="button" CB="Print2 PRINT_OUT BTN_SKUPTNRPIC" /> <!-- 제품/거래처 피킹 -->
					<input type="button" CB="Print3 PRINT_OUT BTN_PRTSKU" /> <!-- 품목별 총량집계표 -->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required(STD_OWNRKY)"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" validate="required(STD_WAREKY)"></select>
						</dd>
					</dl>
					<dl>  <!-- S/O 번호 -->  
						<dt CL="IFT_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="I.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 납품요청일 -->  
						<dt CL="STD_VDATU"></dt> 
						<dd> 
							<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl>
					<dl>  <!-- 납품처코드 -->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl>
					<dl>  <!-- 매출처코드 -->  
						<dt CL="IFT_PTNROD"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNROD" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 제품 코드 -->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl>
					<dl>  <!-- 출고유형 -->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DOCUTY" UIInput="S,SHDOCTMIF"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 냉장/냉동 구분 -->  
						<dt CL="STD_DEFSORT"></dt> 
						<dd> 
							<input type="checkbox" class="input" name="CHKMAK" id="CHKMAK" style="margin-top:0";/>
						</dd> 
					</dl> 
					<dl>  <!-- 주문구분 -->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 배송구분 -->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DIRDVY" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 차량번호 -->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHCARMA2"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 상온구분 -->  
						<dt CL="STD_ASKU05"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 소분류 -->  
						<dt CL="STD_SKUG03"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.SKUG03" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!-- 주문차수 -->  
						<dt CL="STD_N00105"></dt> 
						<dd> 
							<input type="text" class="input" name="I.N00105" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--피킹그룹-->  
						<dt CL="STD_PICGRP"></dt> 
						<dd> 
							<input type="text" class="input" name="PK.PICGRP" UIInput="SR,SHCMCDV"/> 
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
										<td GH="40" GCol="rowCheck" ></td> 
			    						<td GH="150 key" GCol="text,KEY" GF="S 30">key</td>	<!--key-->
			    						<td GH="120 IFT_OWNRKY" GCol="select,OWNRKY"><!--화주-->
											<select class="input" Combo="SajoCommon,OWNRKYNM_COMCOMBO"><option></option></select>
			    						</td>	
			    						<td GH="80 IFT_CARNUM" GCol="text,CARNUM" GF="S 20"></td>	<!--차량번호-->
			    						<td GH="80 STD_CARNAME" GCol="text,CARNUMNM" GF="S 20"></td>	<!--차량명-->
			    						<td GH="90 STD_PIKSEQ" GCol="text,TEXT03" GF="S 20"></td>	<!--피킹출력번호-->
			    						<td GH="70 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20"></td>	<!--납품처코드-->
			    						<td GH="120 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20"></td>	<!--납품처명-->
			    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20"></td>	<!--매출처코드-->
			    						<td GH="120 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20"></td>	<!--매출처명-->
			    						<td GH="100 IFT_DOCUTY"  GCol="select,DOCUTY"> <!--출고유형-->
											<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"> 
												<option></option>
											</select>
										</td>
										
			    						<td GH="100 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8"></td> <!--출고요청일-->
			    						
			    						<td GH="100 IFT_DIRDVY"  GCol="select,DIRDVY"> <!--배송구분-->
											<select class="input" commonCombo="PGRC02">
												<option></option>
											</select>
										</td>
			    						<td GH="100 IFT_DIRSUP"  GCol="select,DIRSUP"> <!--주문구분-->
											<select class="input" commonCombo="PGRC03"> 
												<option></option>
											</select>
										</td>
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40"></td>	<!--s/o번호-->
			    						<td GH="80 STD_N00105" GCol="text,N00105" GF="S 20"></td>	<!--주문차수-->
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
										<td GH="40" GCol="rowCheck" ></td> 
			    						<td GH="100 IFT_ORDSEQ" GCol="text,ORDSEQ" GF="S 6"></td>	<!--주문번호아이템-->
			    						<td GH="100 IFT_SVBELN" GCol="text,SVBELN" GF="S 40"></td>	<!--s/o번호-->
			    						<td GH="100 STD_PIKSEQ" GCol="text,TEXT03" GF="S 20"></td>	<!--피킹출력번호-->
			    						<td GH="150 IFT_WAREKY"  GCol="select,WAREKY"> <!--WMS거점(출고사업장)-->
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"> 
											</select>
										</td>
			    						<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20"></td>	<!--제품코드-->
			    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 200"></td>	<!--제품명-->
			    						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13"></td>	<!--납품요청수량-->
			    						<td GH="80 STD_ORDTOT" GCol="text,ORDTOT" GF="N 13"></td>	<!--누적주문수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" ></td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1"></td>	<!--박스수량-->
			    						<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17"></td>	<!--잔량-->
			    						<td GH="80 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13"></td>	<!--출하량-->
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