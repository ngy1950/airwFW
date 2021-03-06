<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL32</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
$(document).ready(function(){
	gridList.setGrid({
    	id : "gridList1",
		module : "Report",
		command : "RL32_1",
		pkcol : "DOCDAT, SKUKEY, WAREKY",
	    menuId : "RL32"
    });
	gridList.setGrid({
    	id : "gridList2",
		module : "Report",
		command : "RL32_2",
		pkcol : "SHPOKY",
	    menuId : "RL32"
    });

	//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
	setVarriantDef();
	
	//inputList.rangeMap["map"]["CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
	
});

function searchList(){
	$('#atab1-1').trigger("click");
}

function display1(){
	if(validate.check("searchArea")){
 		gridList.resetGrid("gridList1");
 		gridList.resetGrid("gridList2");
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
		var param = inputList.setRangeMultiParam("searchArea");

		gridList.gridList({
	    	id : "gridList2",
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
	}
	return param;
}

function commonBtnClick(btnName){
	if(btnName == "Search"){
		searchList();
	}else if(btnName == "Savevariant"){
		sajoUtil.openSaveVariantPop("searchArea", "RL32");
	}else if(btnName == "Getvariant"){
	sajoUtil.openGetVariantPop("searchArea", "RL32");
	}
}
function linkPopCloseEvent(data){//팝업 종료 
	if(data.get("TYPE") == "GET"){ 
		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
		sajoUtil.setLayout(data); //팝업 데이터 적용
	}
}

//서치헬프 기본값 세팅
function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
    var param = new DataMap();

      //제품코드
	 if(searchCode == "SHSKUMA"){
        param.put("WAREKY","<%=wareky %>");
        param.put("OWNRKY","<%=ownrky %>");
	} return param;
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
						<dl>
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input" ></select>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_CREDAT"></dt> <!-- 생성일자 -->
							<dd>
								<input type="text" class="input" name="I.DOCDAT" UIInput="B" UIFormat="C N" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_SKUKEY"></dt> <!-- 제품코드 -->
							<dd>
								<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA" />
							</dd>
						</dl>
						<dl>
							<dt CL="STD_DESC01"></dt> <!-- 제품명 -->
							<dd>
								<input type="text" class="input" name="I.DESC01" UIInput="SR" />
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
						<li><a href="#tab1-1" onclick="display1()" id = "atab1-1"><span>일자별 수불</span></a></li>
						<li><a href="#tab1-2" onclick="display2()"><span>일자별 수불(정상재고)</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList1">
										<tr CGRow="true">
											<td GH="40 STD_NUMBER"           GCol="rownum">1</td>  
				    						<td GH="50 STD_DATE" GCol="text,DOCDAT" GF="D 20">일자</td>	<!--일자-->
				    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10"></td>	<!---->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20"></td>	<!--제품코드-->
				    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 20"></td>	<!--제품명-->
				    						<td GH="80 STD_QTINIT" GCol="text,STKPRE" GF="N 20,0">기초재고</td>	<!--기초재고-->
				    						<td GH="80 STD_GENDE" GCol="text,NORSHP" GF="N 20,0">일반출고</td>	<!--일반출고-->
				    						<td GH="80 STD_OUTCS" GCol="text,TRUSHP" GF="N 20,0">위탁점출고</td>	<!--위탁점출고-->
				    						<td GH="80 STD_EXTSH" GCol="text,BNUSHP" GF="N 20,0">할증출고</td>	<!--할증출고-->
				    						<td GH="80 STD_FRESH" GCol="text,FRESHP" GF="N 20,0">무상출고</td>	<!--무상출고-->
				    						<td GH="80 STD_PREDE" GCol="text,RETSHP" GF="N 20,0">매입반품출고</td>	<!--매입반품출고-->
				    						<td GH="80 STD_DELIVE" GCol="text,FILSHP" GF="N 20,0">이고출고</td>	<!--이고출고-->
				    						<td GH="80 STD_NORRCV" GCol="text,NORRCV" GF="N 20,0">일반입고</td>	<!--일반입고-->
				    						<td GH="80 STD_FILRCV" GCol="text,FILRCV" GF="N 20,0">이고입고</td>	<!--이고입고-->
				    						<td GH="80 STD_RETRCV" GCol="text,RETRCV" GF="N 20,0">매출반품입고</td>	<!--매출반품입고-->
				    						<td GH="80 STD_ASSEMB" GCol="text,ASSEMB" GF="N 20,0">세트조립</td>	<!--세트조립-->
				    						<td GH="80 STD_DISMAN" GCol="text,DISMAN" GF="N 20,0">세트해체</td>	<!--세트해체-->
				    						<td GH="80 STD_ETCSHP" GCol="text,ETCSHP" GF="N 20,0">기타출고</td>	<!--기타출고-->
				    						<td GH="80 STD_STOCK" GCol="text,STKAFT" GF="N 20,0">재고</td>	<!--재고-->
				    						<td GH="80 STD_TRCST1" GCol="text,TOTAMT" GF="N 20,0">금액</td>	<!--금액-->
				    						<td GH="80 STD_SHPCHK" GCol="text,SHPCHK" GF="N 20,0">출고차이</td>	<!--출고차이-->
				    						<td GH="80 STD_NRVCHK" GCol="text,NRVCHK" GF="N 20,0">발주입고차이</td>	<!--발주입고차이-->
				    						<td GH="80 STD_RSHCHK" GCol="text,RSHCHK" GF="N 20,0">매입반품차이</td>	<!--매입반품차이-->
				    						<td GH="80 STD_FRVCHK" GCol="text,FRVCHK" GF="N 20,0">이고입고차이</td>	<!--이고입고차이-->
				    						<td GH="80 STD_ETCCHK" GCol="text,ETCCHK" GF="N 20,0">기타출고차이</td>	<!--기타출고차이-->
				    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D -2">생성일자</td>	<!--생성일자-->
				    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T -2">생성시간</td>	<!--생성시간-->
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
					</div><!-- TAB1 -->
					<div class="table_box section" id="tab1-2">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList2">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
				    						<td GH="50 STD_DATE" GCol="text,DOCDAT" GF="D 20">일자</td>	<!--일자-->
				    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10"></td>	<!---->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20"></td>	<!--제품코드-->
				    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 20"></td>	<!--제품명-->
				    						<td GH="80 STD_QTINIT" GCol="text,STKPRE" GF="N 20,0">기초재고</td>	<!--기초재고-->
				    						<td GH="80 STD_GENDE" GCol="text,NORSHP" GF="N 20,0">일반출고</td>	<!--일반출고-->
				    						<td GH="80 STD_OUTCS" GCol="text,TRUSHP" GF="N 20,0">위탁점출고</td>	<!--위탁점출고-->
				    						<td GH="80 STD_EXTSH" GCol="text,BNUSHP" GF="N 20,0">할증출고</td>	<!--할증출고-->
				    						<td GH="80 STD_FRESH" GCol="text,FRESHP" GF="N 20,0">무상출고</td>	<!--무상출고-->
				    						<td GH="80 STD_PREDE" GCol="text,RETSHP" GF="N 20,0">매입반품출고</td>	<!--매입반품출고-->
				    						<td GH="80 STD_DELIVE" GCol="text,FILSHP" GF="N 20,0">이고출고</td>	<!--이고출고-->
				    						<td GH="80 STD_NORRCV" GCol="text,NORRCV" GF="N 20,0">일반입고</td>	<!--일반입고-->
				    						<td GH="80 STD_FILRCV" GCol="text,FILRCV" GF="N 20,0">이고입고</td>	<!--이고입고-->
				    						<td GH="80 STD_RETRCV" GCol="text,RETRCV" GF="N 20,0">매출반품입고</td>	<!--매출반품입고-->
				    						<td GH="80 STD_ASSEMB" GCol="text,ASSEMB" GF="N 20,0">세트조립</td>	<!--세트조립-->
				    						<td GH="80 STD_DISMAN" GCol="text,DISMAN" GF="N 20,0">세트해체</td>	<!--세트해체-->
				    						<td GH="80 STD_ETCSHP" GCol="text,ETCSHP" GF="N 20,0">기타출고</td>	<!--기타출고-->
				    						<td GH="80 STD_STOCK" GCol="text,STKAFT" GF="N 20,0">재고</td>	<!--재고-->
				    						<td GH="80 STD_TRCST1" GCol="text,TOTAMT" GF="N 20,0">금액</td>	<!--금액-->
				    						<td GH="80 STD_SHPCHK" GCol="text,SHPCHK" GF="N 20,0">출고차이</td>	<!--출고차이-->
				    						<td GH="80 STD_NRVCHK" GCol="text,NRVCHK" GF="N 20,0">발주입고차이</td>	<!--발주입고차이-->
				    						<td GH="80 STD_RSHCHK" GCol="text,RSHCHK" GF="N 20,0">매입반품차이</td>	<!--매입반품차이-->
				    						<td GH="80 STD_FRVCHK" GCol="text,FRVCHK" GF="N 20,0">이고입고차이</td>	<!--이고입고차이-->
				    						<td GH="80 STD_ETCCHK" GCol="text,ETCCHK" GF="N 20,0">기타출고차이</td>	<!--기타출고차이-->
				    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D -2">생성일자</td>	<!--생성일자-->
				    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T -2">생성시간</td>	<!--생성시간-->
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
					</div> <!-- TAB2 -->
				</div>
			</div>
		</div>
	</div>
	<!-- // content -->
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>