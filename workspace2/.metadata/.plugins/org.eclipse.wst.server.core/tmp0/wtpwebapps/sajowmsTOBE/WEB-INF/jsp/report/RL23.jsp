<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL00</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	var selectIdx = "";
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
	    	module : "Report",
			command : "RL26",
		    menuId : "RL23"
	    });
		
		gridList.setGrid({
	    	id : "gridList2",
	    	module : "Report",
			command : "RL26",
		    menuId : "RL23"
	    });
		
		inputList.rangeMap["map"]["DR.CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		searchwareky("<%=ownrky %>");
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});
	
	function searchwareky(val){
		var param = new DataMap();
		param.put("OWNRKY",val);
		
		var json = netUtil.sendData({
			module : "SajoCommon",
			command : "WAREKY_COMCOMBO",
			sendType : "list",
			param : param
		});
		
		$("#WAREKY").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#WAREKY").append(optionHtml);
	}
	
	//조회
	function searchList(){
		$('#atab1-1').trigger("click");
	}

    //텝이동시 작동
    function moveTab(obj){
    	var tabNm = obj.attr('href');
    	var param = inputList.setRangeParam("searchArea");
    	var goUrl = "";	
    	var gridId =  "";
  		var cardat_from= inputList.rangeMap["map"]["DR.CARDAT"].$from.val();
  		var cardat_to= inputList.rangeMap["map"]["DR.CARDAT"].$to.val();
  		
  		if(cardat_from.trim() == "" && cardat_to.trim() == ""){
  			commonUtil.msgBox("배송일자를 입력해주세요.");
			return;
  		}
  		
  		/* 선입고수량 체크여부 */ 
  		if($('#CHPRECHK').prop("checked")){
  			param.put("CHPRECHK", "0");
  		}else{
  			param.put("CHPRECHK", "1");
  		}
  		
  		/* 차이수량 체크여부 */ 
  		if($('#CHQTYCHK').prop("checked")){
  			param.put("CHQTYCHK", "0");
  		}else{
  			param.put("CHQTYCHK", "1");
  		}
    	
    	switch (tabNm.charAt(tabNm.length-1)){
		case "1":
			$('.tab1ty').show();
			gridId = "gridList1";
			goUrl = "/Report/json/RL23_01.data";
			break;
		case "2":
			$('.tab1ty').hide();
			gridId = "gridList2";
			goUrl = "/Report/json/RL23_02.data";
			break;
		}
    	
    	netUtil.send({
			url : goUrl,
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : gridId //그리드ID
		});
	}
    
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "RL23");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "RL23");
		}else if(btnName == "Print"){
			printEZGenDR16("/ezgen/picking_validation.ezg"); //프린트
			
		}
	}

    function gridListEventRowAddBefore(gridId, rowNum) {
    	if(gridId == 'gridList'){
            var newData = new DataMap();
            newData.put("COMPKY","<%=compky%>");
            
            return newData;
    	}
    }
    
	function printEZGenDR16(url){
    	
    	//for문을 돌며 TEXT03 KEY를 꺼낸다.
		var headList = gridList.getSelectData("gridList1");
    	
		if(headList.length < 1){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		/* 2개이상 선택 금지 */
		if(headList.length >= 2){
			commonUtil.msgBox("프린트는 1장씩 가능합니다.");
			return;
		}
		
		var count = 0;
		var wherestr = whereFilter();
		var option = optionFilter();
		
		//이지젠 호출부(신버전)
		var width = 600;
		var heigth = 920;
		var map = new DataMap();
		map.put("i_option", option);
		WriteEZgenElement(url , wherestr , "" , "KO", map , width , heigth ); // 구버전 ezgenPrint와 같다

	}// end printEZGenDR16(url){
		
	function whereFilter() {
		var docdat_from= inputList.rangeMap["map"]["PH.DOCDAT"].$from.val();
		var docdat_to= inputList.rangeMap["map"]["PH.DOCDAT"].$to.val();
		docdat_from = docdat_from.replace(/\./gi, "");
		docdat_to = docdat_to.replace(/\./gi, "");
  		
		var strFilter = " AND PI.OWNRKY = " + "'" + $("#OWNRKY").val() + "'";
		strFilter += "AND PH.WAREKY = " + "'" + $("#WAREKY").val() + "'";
		
		if(docdat_from.trim() != "" && docdat_to.trim() != ""){
			strFilter += " AND PH.DOCDAT " +  "BETWEEN '" + docdat_from + "' AND '"  + docdat_to + "'";
		}else{
			strFilter += " AND PH.DOCDAT = " +  "'" + docdat_from + "'";	
		}
		return strFilter;
	}
	
	function optionFilter() {
		var cardat_from= inputList.rangeMap["map"]["DR.CARDAT"].$from.val();	//배송일자
		var cardat_to= inputList.rangeMap["map"]["DR.CARDAT"].$to.val();	//배송일자
		cardat_from = cardat_from.replace(/\./gi, "");
		cardat_to = cardat_to.replace(/\./gi, "");
		
		var carnum = $("#CARNUM").val();	// 차량번호
		var shipsq = $("#SHIPSQ").val();	// 배송차수
		
		var strFilter = " AND DH.OWNRKY = " + "'" + $("#OWNRKY").val() + "'";
		strFilter += " AND DH.WAREKY = "  + "'" + $("#WAREKY").val() + "'";
		
		if($("#S_SKUKEY").val().trim() != ""){
			strFilter += " AND DI.SKUKEY = " +  "'" + $("#S_SKUKEY").val() + "'";
		}
		
		if(cardat_from.trim() != "" && cardat_to.trim() != ""){
			strFilter += " AND DR.CARDAT " +  "BETWEEN '" + cardat_from + "' AND '"  + cardat_to + "'";
		}else{
			strFilter += " AND DR.CARDAT = " +  "'" + cardat_from + "'";
		}
		
		if(carnum.trim() != ""){
			strFilter += " AND DR.CARNUM = " +  "'" + carnum + "'";
		}
		if(shipsq.trim() != ""){
			strFilter += " AND DR.SHIPSQ = " +  "'" + shipsq + "'";
		}
		if($('#CHQTYCHK').prop("checked")){
			strFilter += " AND PP.SKUKEY != ' '";
		}
		return strFilter;
	}
    
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // skuma 화주 세팅
        if(searchCode == "SHSKUMA"){
            param.put("OWNRKY",$("#OWNRKY").val());
        }
        
    	return param;
    }
	
	function linkPopCloseEvent(data){//팝업 종료 
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
    }
	
	/* rowCheck 클릭 이벤트  */
	function gridListEventRowCheck(gridId, rowNum, checkType){
		if(checkType){
			var s_skukey =  gridList.getColData(gridId, rowNum, "DISKUKEY");
			var s_desc01 =  gridList.getColData(gridId, rowNum, "DIDESC01");
			
			$("#S_SKUKEY").val(s_skukey);
			$("#S_DESC01").val(s_desc01);
		}else{
			$("#S_SKUKEY").val("");
			$("#S_DESC01").val("");
		}
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
					<!--  <input type="button" CB="Save SAVE BTN_SAVE" />-->
				</div>
			</div>
			<div class="search_inner">
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
		                <select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
		              </dd>
		            </dl>
		            <dl>  <!--배송일자-->  
						<dt CL="STD_CARDAT"></dt> 
						<dd> 
							<input type="text" class="input" id="CARDAT" name="DR.CARDAT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
		            <dl>  <!--배송차수-->  
						<dt CL="STD_SHIPSQ"></dt> 
						<dd> 
							<input type="text" class="input" id="SHIPSQ" name="DR.SHIPSQ" UIInput="SR"/> 
						</dd> 
					</dl>
					<dl>  <!--차이수량-->  
						<dt CL="STD_CONQTY"></dt> 
						<dd>
							<input type="checkbox" class="input" id="CHQTYCHK" name="CHQTYCHK" style="margin:0;" /> 
						</dd>
					</dl> 
					<dl>  <!--선입고수량-->  
						<dt CL="STD_QTYPRE"></dt>
						<dd>
							<input type="checkbox" class="input" id="CHPRECHK" name="CHPRECHK" style="margin:0;"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="DI.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서일자-->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="PH.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl>
					<dl>  <!--차량번호-->  
						<dt CL="IFT_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" id="CARNUM" name="DR.CARNUM" UIInput="SR"/> 
						</dd> 
					</dl> 
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap">	
				<div class="content_layout tabs">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1" onclick="moveTab($(this));"><span id="atab1-1"><span>일반</span></a></li>
						<li><a href="#tab1-2" onclick="moveTab($(this));"><span id="atab1-2"><span>일반</span></a></li>
						<li class="tab1ty" style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 20PX 0 15px;">
							<span CL="STD_SELSKU" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
							<input type="text" id="S_SKUKEY" name="S_SKUKEY" class="input" readonly="readonly"/> <!--제품코드 SKUKEY-->  
							<input type="text" id="S_DESC01" name="S_DESC01" class="input" readonly="readonly"/> <!--제품명--> 
						</li>
						<li class="tab1ty" style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX"> <!-- 프린트 출력 -->
							<input type="button" CB="Print PRINT_OUT BTN_PRINT" style="VERTICAL-ALIGN: MIDDLE;"/> 
							<span CL="STD_PRINTINFO" style="PADDING-LEFT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						</li>
						
<!-- 						<div id="tab1ty" name="tab1ty"> -->
<!-- 							※선택품목  -->
<!-- 							<input type="text" id="S_SKUKEY" name="S_SKUKEY" class="input" readonly="readonly"> -->
<!-- 							<input type="text" id="S_DESC01" name="S_DESC01" class="input" readonly="readonly">   -->
<!-- 							<input type="button" CB="Print PRINT_OUT BTN_PRINT" /> -->
<!-- 						    &nbsp;&nbsp;※ 프린트는 1장씩 가능합니다. -->
<!-- 						</div> -->
						
						<li class="btn_zoom_wrap">
							<ul>
								<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
								<li><button class="btn btn_bigger"><span>확대</span></button></li>
							</ul>
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList1">
									<tr CGRow="true">                         
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="40 STD_SELECT" GCol="rowCheck,radio"></td>
			    						<td GH="70 IFT_CARNUM" GCol="text,CARNUM" GF="S 10">차량번호</td>	<!--차량번호-->
			    						<td GH="90 STD_CADESC01" GCol="text,CADESC01" GF="S 20">차량이름</td>	<!--차량이름-->
			    						<td GH="70 STD_CARDAT" GCol="text,CARDAT" GF="D 10">배송일자</td>	<!--배송일자-->
			    						<td GH="50 STD_SHIPSQ" GCol="text,SHIPSQ" GF="S 10">배송차수</td>	<!--배송차수-->
			    						<td GH="80 STD_SKUKEY" GCol="text,DISKUKEY" GF="S 40">제품코드</td>	<!--제품코드-->
			    						<td GH="90 STD_DIDESC01" GCol="text,DIDESC01" GF="S 20">제품명</td>	<!--제품명-->
			    						<td GH="50 RL23_QTYORG" GCol="text,QTYORG" GF="N 10">주문수량</td>	<!--주문수량-->
			    						<td GH="50 RL23_QTSHPO" GCol="text,QTSHPO" GF="N 10">지시수량</td>	<!--지시수량-->
			    						<td GH="50 RL23_QTJCMP" GCol="text,QTJCMP" GF="N 10">피킹수량</td>	<!--피킹수량-->
			    						<td GH="50 RL23_QTYREF" GCol="text,QTYREF" GF="N 10">조정수량</td>	<!--조정수량-->
			    						<td GH="50 RL23_QTYSHP" GCol="text,QTYSHP" GF="N 10">출고수량</td>	<!--출고수량-->
			    						<td GH="50 RL23_QTYSTD" GCol="text,QTYSTD" GF="N 10">팔레트입수</td>	<!--팔레트입수-->
			    						<td GH="50 RL23_QTDUOM" GCol="text,QTDUOM" GF="N 10">박스입수</td>	<!--박스입수-->
			    						<td GH="50 RL23_PLTQTY" GCol="text,PLTQTY" GF="N 10,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="50 RL23_QTBXKY" GCol="text,QTBXKY" GF="N 10,1">박스수량</td>	<!--박스수량-->
			    						<td GH="50 RL23_REMXKY" GCol="text,REMXKY" GF="N 10">잔량</td>	<!--잔량-->
			    						<td GH="50 RL23_STKPLT" GCol="text,STKPLT" GF="N 10">재고(PT)</td>	<!--재고(PT)-->
			    						<td GH="50 RL23_STKBOX" GCol="text,STKBOX" GF="N 10,1">재고(BOX)</td>	<!--재고(BOX)-->
			    						<td GH="50 RL23_STKQTY" GCol="text,STKQTY" GF="N 10">재고(EA)</td>	<!--재고(EA)-->
			    						<td GH="50 RL23_PREPLT" GCol="text,PREPLT" GF="N 10">선입고(PT)</td>	<!--선입고(PT)-->
			    						<td GH="50 RL23_PREBOX" GCol="text,PREBOX" GF="N 10,1">선입고(BOX)</td>	<!--선입고(BOX)-->
			    						<td GH="50 RL23_PREQTY" GCol="text,PREQTY" GF="N 10">선입고(EA)</td>	<!--선입고(EA)-->
			    						<td GH="80 STD_SKUKEY" GCol="text,PPSKUKEY" GF="S 10">제품코드</td>	<!--제품코드-->
			    						<td GH="60 STD_CONQTY" GCol="text,CONQTY" GF="N 10">차이수량</td>	<!--차이수량-->
			    						<td GH="60 STD_QTYPRE" GCol="text,QTCOMP" GF="N 10">선입고수량</td>	<!--선입고수량-->
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
				
				<div class="table_box section" id="tab1-2">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList2">
									<tr CGRow="true">                         
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="70 IFT_CARNUM" GCol="text,CARNUM" GF="S 10">차량번호</td>	<!--차량번호-->
			    						<td GH="90 STD_CADESC01" GCol="text,CADESC01" GF="S 20">차량이름</td>	<!--차량이름-->
			    						<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 10">배송일자</td>	<!--배송일자-->
			    						<td GH="80 STD_SKUKEY" GCol="text,DISKUKEY" GF="S 10">제품코드</td>	<!--제품코드-->
			    						<td GH="100 STD_DIDESC01" GCol="text,DIDESC01" GF="S 20">제품명</td>	<!--제품명-->
			    						<td GH="50 STD_QTSHPO" GCol="text,QTSHPO" GF="S 10">지시수량</td>	<!--지시수량-->
			    						<td GH="50 STD_QTJCMP" GCol="text,QTJCMP" GF="S 10">완료수량</td>	<!--완료수량-->
			    						<td GH="50 STD_QTDUOM" GCol="text,QTDUOM" GF="S 10">입수</td>	<!--입수-->
			    						<td GH="50 STD_QTBXKY" GCol="text,QTBXKY" GF="S 10,1" style="text-align:right;">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_SKUKEY" GCol="text,PPSKUKEY" GF="S 10">제품코드</td>	<!--제품코드-->
			    						<td GH="70 WOS_LOCAKY" GCol="text,LOCAKY" GF="S 10">로케이션</td>	<!--로케이션-->
			    						<td GH="70 STD_CONQTY" GCol="text,CONQTY" GF="S 10">차이수량</td>	<!--차이수량-->
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
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>