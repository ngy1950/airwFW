<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SD06</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
			module : "InventoryReport",
			command : "SD06_1",
			pkcol : "STOKKY",
		    menuId : "SD06"
	    });
		gridList.setGrid({
	    	id : "gridList2",
			module : "InventoryReport",
			command : "SD06_2",
			pkcol : "STOKKY",
		    menuId : "SD06"
	    });
		gridList.setGrid({
	    	id : "gridList3",
			module : "InventoryReport",
			command : "SD06_3",
			pkcol : "STOKKY",
		    menuId : "SD06"
	    });
		gridList.setGrid({
	    	id : "gridList4",
			module : "InventoryReport",
			command : "SD06_4",
			pkcol : "STOKKY",
		    menuId : "SD06"
	    });
		gridList.setGrid({
	    	id : "gridList5",
			module : "InventoryReport",
			command : "SD06_5",
			pkcol : "STOKKY",
		    menuId : "SD06"
	    });
		gridList.setGrid({
	    	id : "gridList6",
			module : "InventoryReport",
			command : "SD06_6",
			pkcol : "STOKKY",
		    menuId : "SD06"
	    });
		gridList.setGrid({
	    	id : "gridList7",
			module : "InventoryReport",
			command : "SD06_7",
			pkcol : "STOKKY",
		    menuId : "SD06"
	    });
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});
	
	//조회
	function searchList(){
		$('#atab1-1').trigger("click");
	}
	
	function display1(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
	 		gridList.resetGrid("gridList3");
	 		gridList.resetGrid("gridList4");
			var param = inputList.setRangeMultiParam("searchArea");
	
			gridList.gridList({
		    	id : "gridList1",
		    	param : param
		    });
		}
	}
	function display2(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
	 		gridList.resetGrid("gridList3");
	 		gridList.resetGrid("gridList4");
			var param = inputList.setRangeMultiParam("searchArea");
	
			gridList.gridList({
			    	id : "gridList2",
			    	param : param
			    });
		}
	}
	function display3(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
	 		gridList.resetGrid("gridList3");
	 		gridList.resetGrid("gridList4");
			var param = inputList.setRangeMultiParam("searchArea");
	
			gridList.gridList({
		    	id : "gridList3",
		    	param : param
		    });
		}
	}
	function display4(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
	 		gridList.resetGrid("gridList3");
	 		gridList.resetGrid("gridList4");
			var param = inputList.setRangeMultiParam("searchArea");
	
			gridList.gridList({
		    	id : "gridList4",
		    	param : param
		    });
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("LANGCODE","<%=langky%>");
		newData.put("LABELTYPE","WMS");
		return newData;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			return param;
		}else if( comboAtt == "SajoCommon,SEARCH_WAREKY_COMCOMBO" ){
			param.put("USERID", "<%=userid%>");
			param.put("OWNRKY", $("#OWNRKY").val());
			return param;
		}
		return param;
	}
	
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "SD06");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "SD06");
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();
	
	  //제품코드
		if(searchCode == "SHSKUMA"){
	        param.put("WAREKY",$("#WAREKY").val());
	        param.put("OWNRKY",$("#OWNRKY").val());
		//소분류
		} else if(searchCode == "SHCMCDV" && $inputObj.name == "SMA.SKUG03"){
	        param.put("CMCDKY","SKUG03");
		//세트여부
		} else if(searchCode == "SHCMCDV" && $inputObj.name == "SMA.ASKU02"){
	        param.put("CMCDKY","ASKU02");
		//제품구분
		} else if(searchCode == "SHCMCDV" && $inputObj.name == "SMA.ASKU04"){
	        param.put("CMCDKY","ASKU04");
		} return param;
	}
	
	//아이템그리드 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			headrow = rowNum;
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			param.put("SES_WAREKY", "<%=wareky%>")

			netUtil.send({
				url : "/OyangReport/json/displayOY13.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList" //그리드ID
			}); 
		    	
		}
	}
	
	//텝이동시 작동
    function moveTab(obj){
    	var tabNm = obj.attr('href');
    	var gridId = "gridList"+tabNm.charAt(tabNm.length-1);
    	
		if(validate.check("searchArea")){
			gridList.resetGrid(gridId);
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : gridId,
		    	param : param
		    });
		}
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
	<%@ include file="/common/include/webdek/layout.jsp"%>
	<!-- content -->
	<div class="content_wrap">
		<div class="content_inner">
			<%@ include file="/common/include/webdek/title.jsp"%>
			<div class="content_serch" id="searchArea">
				<div class="btn_wrap">
					<div class="fl_l">
						<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
					</div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" />
					</div>
				</div>
				<div class="search_inner">
						<div class="search_wrap ">
						<dl> <!--화주-->
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY" class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required"></select>
							</dd>
						</dl>
						<dl> <!--거점-->
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true" validate="required"></select>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_PRODCD"></dt> 
							<dd> 
								<input type="text" class="input" name="SKY.SKUKEY" UIInput="SR,SHSKUMA"/>    <!--제품코드-->  
							</dd> 
						</dl> 
						<dl>  
							<dt CL="STD_PRODNM"></dt> 
							<dd> 
								<input type="text" class="input" name="SKY.DESC01" UIInput="SR"/>    <!--제품명-->
							</dd> 
						</dl> 
						<dl>
							<dt CL="STD_SKUG03"></dt> 
							<dd> 
								<input type="text" class="input" name="SMA.SKUG03" UIInput="SR,SHCMCDV"/> 	<!--소분류-->
							</dd> 
						</dl> 
						<dl>
							<dt CL="STD_ASKU02"></dt> 
							<dd> 
								<input type="text" class="input" name="SMA.ASKU02" UIInput="SR,SHCMCDV"/> 	<!--세트여부-->
							</dd> 
						</dl> 
						<dl>
							<dt CL="STD_ASKU04"></dt> 
							<dd> 
								<input type="text" class="input" name="SMA.ASKU04" UIInput="SR,SHCMCDV"/> 	<!--제품구분-->
							</dd> 
						</dl>
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more"
							onclick="searchMore()" />
					</div>
				</div>
			</div>
			<div class="search_next_wrap">
				<div class="content_layout tabs">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1" onclick="moveTab($(this))" id="atab1-1"><span>전체</span></a></li>
						<li><a href="#tab1-2" onclick="moveTab($(this))"><span>정상(BOX)</span></a></li>
						<li><a href="#tab1-3" onclick="moveTab($(this))"><span>정상(EA)</span></a></li>
						<li><a href="#tab1-4" onclick="moveTab($(this))"><span>정상(PLT)</span></a></li>
						<li><a href="#tab1-5" onclick="moveTab($(this))"><span>반품</span></a></li>
						<li><a href="#tab1-6" onclick="moveTab($(this))"><span>대기</span></a></li>
						<li><a href="#tab1-7" onclick="moveTab($(this))"><span>대기(PLT)</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<li>
									<button class="btn btn_bigger">
										<span>확대</span>
									</button>
								</li>
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
				    						<td GH="80 STD_NUMBER" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="250 STD_PRODNM" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
				    						<td GH="50 STD_ALL" GCol="text,QTDTOT" GF="N 20,0">전체</td>	<!--전체-->
				    						<td GH="60 STD_2254CT" GCol="text,QTDRIC" GF="N 20,0">인천센터</td>	<!--인천센터-->
				    						<td GH="60 STD_2255CT" GCol="text,QTDRCS" GF="N 20,0">칠서센터</td>	<!--칠서센터-->
				    						<td GH="60 STD_2256CT" GCol="text,QTDRAS" GF="N 20,0">안성센터</td>	<!--안성센터-->
				    						<td GH="60 STD_2257CT" GCol="text,QTDRYG" GF="N 20,0">양지센터</td>	<!--양지센터-->
				    						<td GH="60 STD_2258CT" GCol="text,QTDRYC" GF="N 20,0">영천센터</td>	<!--영천센터-->
				    						<td GH="60 STD_2261CT" GCol="text,QTDRPT" GF="N 20,0">평택센터</td>	<!--평택센터-->
				    						<td GH="60 STD_2263CT" GCol="text,QTDRGS" GF="N 20,0">고성센터</td>	<!--고성센터-->
				    						<td GH="60 STD_2259CT" GCol="text,QTDRGJ" GF="N 20,0">광주센터</td>	<!--광주센터-->
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
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab1-2">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList2">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
											<td GH="80 STD_NUMBER" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="250 STD_PRODNM" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
				    						<td GH="50 STD_ALL" GCol="text,QTTOT00" GF="N 20,0">전체</td>	<!--전체-->
				    						<td GH="60 STD_2254CT" GCol="text,QTIC00" GF="N 20,0">인천센터</td>	<!--인천센터-->
				    						<td GH="60 STD_2255CT" GCol="text,QTCS00" GF="N 20,0">칠서센터</td>	<!--칠서센터-->
				    						<td GH="60 STD_2256CT" GCol="text,QTAS00" GF="N 20,0">안성센터</td>	<!--안성센터-->
				    						<td GH="60 STD_2257CT" GCol="text,QTYG00" GF="N 20,0">양지센터</td>	<!--양지센터-->
				    						<td GH="60 STD_2258CT" GCol="text,QTYC00" GF="N 20,0">영천센터</td>	<!--영천센터-->
				    						<td GH="60 STD_2261CT" GCol="text,QTPT00" GF="N 20,0">평택센터</td>	<!--평택센터-->
				    						<td GH="60 STD_2263CT" GCol="text,QTGS00" GF="N 20,0">고성센터</td>	<!--고성센터-->
				    						<td GH="60 STD_2259CT" GCol="text,QTGJ00" GF="N 20,0">광주센터</td>	<!--광주센터-->
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
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab1-3">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList3">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_PRODCD" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="250 STD_PRODNM" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
				    						<td GH="50 STD_ALL" GCol="text,QTTOT00" GF="N 20,0">전체</td>	<!--전체-->
				    						<td GH="60 STD_2254CT" GCol="text,QTIC00" GF="N 20,0">인천센터</td>	<!--인천센터-->
				    						<td GH="60 STD_2255CT" GCol="text,QTCS00" GF="N 20,0">칠서센터</td>	<!--칠서센터-->
				    						<td GH="60 STD_2256CT" GCol="text,QTAS00" GF="N 20,0">안성센터</td>	<!--안성센터-->
				    						<td GH="60 STD_2257CT" GCol="text,QTYG00" GF="N 20,0">양지센터</td>	<!--양지센터-->
				    						<td GH="60 STD_2258CT" GCol="text,QTYC00" GF="N 20,0">영천센터</td>	<!--영천센터-->
				    						<td GH="60 STD_2261CT" GCol="text,QTPT00" GF="N 20,0">평택센터</td>	<!--평택센터-->
				    						<td GH="60 STD_2263CT" GCol="text,QTGS00" GF="N 20,0">고성센터</td>	<!--고성센터-->
				    						<td GH="60 STD_2259CT" GCol="text,QTGJ00" GF="N 20,0">광주센터</td>	<!--광주센터-->
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
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab1-4">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList4">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_PRODCD" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="250 STD_PRODNM" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
				    						<td GH="50 STD_ALL" GCol="text,QTTOT00" GF="N 20,2">전체</td>	<!--전체-->
				    						<td GH="60 STD_2254CT" GCol="text,QTIC00" GF="N 20,2">인천센터</td>	<!--인천센터-->
				    						<td GH="60 STD_2255CT" GCol="text,QTCS00" GF="N 20,2">칠서센터</td>	<!--칠서센터-->
				    						<td GH="60 STD_2256CT" GCol="text,QTAS00" GF="N 20,2">안성센터</td>	<!--안성센터-->
				    						<td GH="60 STD_2257CT" GCol="text,QTYG00" GF="N 20,2">양지센터</td>	<!--양지센터-->
				    						<td GH="60 STD_2258CT" GCol="text,QTYC00" GF="N 20,2">영천센터</td>	<!--영천센터-->
				    						<td GH="60 STD_2261CT" GCol="text,QTPT00" GF="N 20,2">평택센터</td>	<!--평택센터-->
				    						<td GH="60 STD_2263CT" GCol="text,QTGS00" GF="N 20,2">고성센터</td>	<!--고성센터-->
				    						<td GH="60 STD_2259CT" GCol="text,QTGJ00" GF="N 20,2">광주센터</td>	<!--광주센터-->
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
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab1-5">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList5">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_PRODCD" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="250 STD_PRODNM" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
				    						<td GH="50 STD_ALL" GCol="text,QTTOT20" GF="N 20,0">전체</td>	<!--전체-->
				    						<td GH="60 STD_2254CT" GCol="text,QTIC20" GF="N 20,0">인천센터</td>	<!--인천센터-->
				    						<td GH="60 STD_2255CT" GCol="text,QTCS20" GF="N 20,0">칠서센터</td>	<!--칠서센터-->
				    						<td GH="60 STD_2256CT" GCol="text,QTAS20" GF="N 20,0">안성센터</td>	<!--안성센터-->
				    						<td GH="60 STD_2257CT" GCol="text,QTYG20" GF="N 20,0">양지센터</td>	<!--양지센터-->
				    						<td GH="60 STD_2258CT" GCol="text,QTYC20" GF="N 20,0">영천센터</td>	<!--영천센터-->
				    						<td GH="60 STD_2261CT" GCol="text,QTPT20" GF="N 20,0">평택센터</td>	<!--평택센터-->
				    						<td GH="60 STD_2263CT" GCol="text,QTGS20" GF="N 20,0">고성센터</td>	<!--고성센터-->
				    						<td GH="60 STD_2259CT" GCol="text,QTGJ20" GF="N 20,0">광주센터</td>	<!--광주센터-->
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
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab1-6">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList6">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_PRODCD" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="250 STD_PRODNM" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
				   							<td GH="50 STD_ALL" GCol="text,QTTOT30" GF="N 20,2">전체</td>	<!--전체-->
				    						<td GH="60 STD_2254CT" GCol="text,QTIC30" GF="N 20,2">인천센터</td>	<!--인천센터-->
				    						<td GH="60 STD_2255CT" GCol="text,QTCS30" GF="N 20,2">칠서센터</td>	<!--칠서센터-->
				    						<td GH="60 STD_2256CT" GCol="text,QTAS30" GF="N 20,2">안성센터</td>	<!--안성센터-->
				    						<td GH="60 STD_2257CT" GCol="text,QTYG30" GF="N 20,2">양지센터</td>	<!--양지센터-->
				    						<td GH="60 STD_2258CT" GCol="text,QTYC30" GF="N 20,2">영천센터</td>	<!--영천센터-->
				    						<td GH="60 STD_2261CT" GCol="text,QTPT30" GF="N 20,2">평택센터</td>	<!--평택센터-->
				    						<td GH="60 STD_2263CT" GCol="text,QTGS30" GF="N 20,2">고성센터</td>	<!--고성센터-->
				    						<td GH="60 STD_2259CT" GCol="text,QTGJ30" GF="N 20,2">광주센터</td>	<!--광주센터-->
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
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab1-7">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList7">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="80 STD_PRODCD" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="250 STD_PRODNM" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
				    						<td GH="50 STD_ALL" GCol="text,QTTOT30" GF="N 20,2">전체</td>	<!--전체-->
				    						<td GH="60 STD_2254CT" GCol="text,QTIC30" GF="N 20,2">인천센터</td>	<!--인천센터-->
				    						<td GH="60 STD_2255CT" GCol="text,QTCS30" GF="N 20,2">칠서센터</td>	<!--칠서센터-->
				    						<td GH="60 STD_2256CT" GCol="text,QTAS30" GF="N 20,2">안성센터</td>	<!--안성센터-->
				    						<td GH="60 STD_2257CT" GCol="text,QTYG30" GF="N 20,2">양지센터</td>	<!--양지센터-->
				    						<td GH="60 STD_2258CT" GCol="text,QTYC30" GF="N 20,2">영천센터</td>	<!--영천센터-->
				    						<td GH="60 STD_2261CT" GCol="text,QTPT30" GF="N 20,2">평택센터</td>	<!--평택센터-->
				    						<td GH="60 STD_2263CT" GCol="text,QTGS30" GF="N 20,2">고성센터</td>	<!--고성센터-->
				    						<td GH="60 STD_2259CT" GCol="text,QTGJ30" GF="N 20,2">광주센터</td>	<!--광주센터-->
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
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- // content -->
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>