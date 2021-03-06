<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>OY25</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
			module : "ConsignOutbound",
			command : "OD08_1",
			pkcol : "OWNRKY",
		    menuId : "OD08"
	    });
		gridList.setGrid({
	    	id : "gridList2",
			module : "ConsignOutbound",
			command : "OD08_2",
			pkcol : "OWNRKY",
		    menuId : "OD08"
	    });

		
		//콤보박스 리드온리
// 		gridList.setReadOnly("gridList1", true, ["OWNRKY", "CARTYP", "CARGBN", "CARTMP"]);
// 		gridList.setReadOnly("gridList2", true, ["OWNRKY", "CARTYP", "CARGBN", "CARTMP"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	
	function searchList(){
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
	 		sajoUtil.openSaveVariantPop("searchArea", "OD08");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "OD08");
 		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();
	
		//출고유형
        if(searchCode == "SHDOCTM" && $inputObj.name == "IFW113.DOCUTY"){
            param.put("DOCCAT","100");
        //업체코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "DPTNKY"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        //제품코드
        }else if(searchCode == "SHSKUMA" && $inputObj.name == "IFW623.SKUKEY"){
            param.put("CMCDKY","WAREKY");
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
								<select name="OWNRKY" id="OWNRKY" class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl> <!--거점-->
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>  <!--출고유형-->  
							<dt CL="STD_SHPMTY"></dt> 
							<dd> 
								<input type="text" class="input" name="IFW113.DOCUTY" UIInput="SR,SHDOCTM"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고문서번호-->  
							<dt CL="STD_SHPOKY"></dt> 
							<dd> 
								<input type="text" class="input" name="IFW623.SHPOKY" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--문서일자-->  
							<dt CL="STD_DOCDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="IFW623.CREDAT" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
						<dl>  <!--업체코드-->  
							<dt CL="STD_DPTNKY"></dt> 
							<dd> 
								<input type="text" class="input" name="IFW113.PTNRTO" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="STD_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="IFW623.SKUKEY" UIInput="SR,SHSKUMA"/> 
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
						<li><a href="#tab1-1" onclick="searchList()"><span>일반</span></a></li>
						<li><a href="#tab1-2" onclick="display2()"><span>일별</span></a></li>
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
				    						<td GH="40 STD_NUMBER" GCol="rownum">1</td> 
				    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
				    						<td GH="100 IFT_WAREKY" GCol="text,WAREKY" GF="S 10">WMS거점(출고사업장)</td> <!--WMS거점(출고사업장)-->
				    						<td GH="80 STD_SZMIPDA" GCol="text,CREDAT" GF="D 8">매입일자</td>	<!--매입일자-->
				    						<td GH="80 STD_ODTYPE" GCol="text,ODTYPE" GF="S 10">매입구분</td>	<!--매입구분-->
				    						<td GH="80 IFT_DOCUTY" GCol="text,DOCUTY" GF="S 10">출고유형</td>	<!--출고유형-->
				    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
				    						<td GH="80 STD_SADJKY" GCol="text,SADJKY" GF="S 10">조정문서번호</td>	<!--조정문서번호-->
				    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 10">s/o번호</td>	<!--s/o번호-->
				    						<td GH="80 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 10">주문아이템번호</td><!--주문아이템번호-->
				    						<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 10">제품코드</td>	<!--제품코드-->
				    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 10">제품명</td>	<!--제품명-->
				    						<td GH="80 STD_OWNORG" GCol="text,OWNORG" GF="S 10">매출화주</td>	<!--매출화주-->
				    						<td GH="80 STD_WARORG" GCol="text,WARORG" GF="S 10">매출거점</td>	<!--매출거점-->
				    						<td GH="80 STD_PURNUM" GCol="text,SEBELN" GF="S 10">매입번호</td>	<!--매입번호-->
				    						<td GH="80 STD_SALENUM" GCol="text,SALENUM" GF="S 10">매출번호</td>	<!--매출번호-->
				    						<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 10">납품처코드</td>	<!--납품처코드-->
				    						<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 10">납품처명</td>	<!--납품처명-->
				    						<td GH="80 IFT_DOCUTYNM" GCol="text,DOCUTYNM" GF="S 10">문서타입명</td>	<!--문서타입명-->
				    						<td GH="80 STD_SALQTY" GCol="text,QTSHPD" GF="N 10">매입수량</td>	<!--매입수량-->
				    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 10,1">박스수량</td>	<!--박스수량-->
				    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 10,2">팔레트수량</td>	<!--팔레트수량-->
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
				    						<td GH="40 STD_NUMBER" GCol="rownum">1</td>
				    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
				    						<td GH="120 IFT_WAREKY" GCol="text,WAREKY" GF="S 10">WMS거점(출고사업장)</td> <!--WMS거점(출고사업장)-->
				    						<td GH="100 STD_SZMIPDA" GCol="text,CREDAT" GF="D 8">매입일자</td>	<!--매입일자-->
				    						<td GH="100 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 10">제품코드</td>	<!--제품코드-->
				    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 20">제품명</td>	<!--제품명-->
				    						<td GH="80 STD_SALQTY" GCol="text,QTSHPD" GF="N 10">매입수량</td>	<!--매입수량-->
				    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 10,1">박스수량</td>	<!--박스수량-->
				    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 10,2">팔레트수량</td>	<!--팔레트수량-->
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