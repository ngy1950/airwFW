<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RL01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	var selectIdx = "0";
	var selectGrid = "gridList1";
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
	    	module : "Report",
			command : "RL01_01",
		    menuId : "RL01"
	    });
		
		gridList.setGrid({
	    	id : "gridList2",
	    	module : "Report",
			command : "RL01_02",
		    menuId : "RL01"
	    });
		
		gridList.setGrid({
	    	id : "gridList3",
	    	module : "Report",
			command : "RL01_03",
		    menuId : "RL01"
	    });
		
		gridList.setGrid({
	    	id : "gridList4",
	    	module : "Report",
			command : "RL01_04",
		    menuId : "RL01"
	    });
		
		gridList.setGrid({
	    	id : "gridList5",
	    	module : "Report",
			command : "RL01_05",
		    menuId : "RL01"
	    });
		
		//aria-selected="true"
		//body > div.content_wrap > div > div.search_next_wrap.searchRow2 > div > ul > li.ui-state-default.ui-corner-top.ui-tabs-active.ui-state-active
		var tabs = $("#tabs > li.ui-corner-top");
		tabs.click(function(event){
			var idx = tabs.index(this);
			selectIdx = idx;
			searchList();
		});
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			
			//aria-selected="true"
			switch (selectIdx){
				case 0:
					selectGrid = "gridList1";
					break;
				case 1:
					selectGrid = "gridList2";
					break;
				case 2:
					selectGrid = "gridList3";
					break;
				case 3:
					selectGrid = "gridList4";
					break;
				case 4:
					selectGrid = "gridList5";
					break;
			}
			gridList.resetGrid(selectGrid);
			 gridList.gridList({
		    	id : selectGrid,
		    	param : param
		    }); 
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "RL01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "RL01");
 		}

	}
	
	 //팝업 종료 
    function linkPopCloseEvent(data){  
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
    }
	
    
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // skuma 화주 세팅
        if(searchCode == "SHSKUMA" && $inputObj.name == "A.SKUKEY"){
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHDOCTM" && $inputObj.name == "RH.RCPTTY"){
        	param.put("DOCCAT","100");
        }
        	
        
    	return param;
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
					<!--  <input type="button" CB="Save SAVE BTN_SAVE" />-->
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
		            <dl>
		              <dt CL="STD_OWNRKY"></dt>
		              <dd>
		                <select name="OWNRKY" id="OWNRKY" class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
		              </dd>
		            </dl>
		            <dl>
		              <dt CL="STD_WAREKY"></dt>
		              <dd>
		                <select name="WAREKY" id="WAREKY" class="input" Combo="SajoCommon,WAREKY_COMCOMBO" ComboCodeView="true"></select>
		              </dd>
		            </dl>
		            <dl>  <!--입고유형-->  
						<dt CL="STD_RCPTTY"></dt> 
						<dd> 
							<input type="text" class="input" name="RH.RCPTTY" UIInput="SR,SHDOCTM"/> 
						</dd> 
					</dl> 
					<dl>  <!--기준일자-->  
						<dt CL="STD_STDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="RH.ARCPTD" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서일자-->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="RH.DOCDAT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="RI.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="RI.DESC01" UIInput="SR"/> 
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
				<ul class="tab tab_style02" id="tabs">
					<li><a href="#tab1-1"><span>연/월별</span></a></li>
					<li><a href="#tab1-2"><span>일별</span></a></li>
					<li><a href="#tab1-3"><span>제품별</span></a></li>
					<li><a href="#tab1-4"><span>문서별</span></a></li>
					<li><a href="#tab1-5"><span>문서/제품별</span></a></li>
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
		    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 4">거점</td>	<!--거점-->
		    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
		    						<td GH="80 STD_YEAR" GCol="text,YEAR" GF="S 10">연도</td>	<!--연도-->
		    						<td GH="80 STD_MONTH" GCol="text,MONTH" GF="S 10">월</td>	<!--월-->
		    						<td GH="80 STD_QTSORG" GCol="text,QTYORG" GF="N 20,0">원주문수량</td>	<!--원주문수량-->
		    						<td GH="80 STD_RCVQTY" GCol="text,QTYRCV" GF="N 20,0">WMS입고수량</td>	<!--WMS입고수량-->
		    						<td GH="80 STD_AMOUNT" GCol="text,AMOUNT" GF="N 20,3">총금액</td>	<!--총금액-->
		    						<td GH="80 STD_CUBICT" GCol="text,CUBICT" GF="N 20,3">총CBM</td>	<!--총CBM-->
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
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 4">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_YEAR" GCol="text,YEAR" GF="S 10">연도</td>	<!--연도-->
			    						<td GH="80 STD_MONTH" GCol="text,MONTH" GF="S 10">월</td>	<!--월-->
			    						<td GH="80 STD_DAY" GCol="text,DAY" GF="S 10">일</td>	<!--일-->
			    						<td GH="80 STD_QTSORG" GCol="text,QTYORG" GF="N 20,0">원주문수량</td>	<!--원주문수량-->
			    						<td GH="80 STD_RCVQTY" GCol="text,QTYRCV" GF="N 20,0">WMS입고수량</td>	<!--WMS입고수량-->
			    						<td GH="80 STD_AMOUNT" GCol="text,AMOUNT" GF="N 20,2">총금액</td>	<!--총금액-->
			    						<td GH="80 STD_CUBICT" GCol="text,CUBICT" GF="N 20,2">총CBM</td>	<!--총CBM-->
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
				
				<div class="table_box section" id="tab1-3">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList3">
									<tr CGRow="true">                         
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 4">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 180">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_QTSORG" GCol="text,QTYORG" GF="N 20,0">원주문수량</td>	<!--원주문수량-->
			    						<td GH="80 STD_RCVQTY" GCol="text,QTYRCV" GF="N 20,0">WMS입고수량</td>	<!--WMS입고수량-->
			    						<td GH="80 STD_AMOUNT" GCol="text,AMOUNT" GF="N 20,2">총금액</td>	<!--총금액-->
			    						<td GH="80 STD_CUBICM" GCol="text,CUBICM" GF="N 20,2">CBM</td>	<!--CBM-->
			    						<td GH="80 STD_CUBICT" GCol="text,CUBICT" GF="N 20,2">총CBM</td>	<!--총CBM-->
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
				
				<div class="table_box section" id="tab1-4">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList4">
									<tr CGRow="true">                         
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 4">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_DOCUTY" GCol="text,DOCUTY" GF="S 10">출고유형</td>	<!--출고유형-->
			    						<td GH="80 STD_DOCUTYNM" GCol="text,DOCUTYNM" GF="S 180">문서타입명</td>	<!--문서타입명-->
			    						<td GH="80 STD_QTSORG" GCol="text,QTYORG" GF="N 20,0">원주문수량</td>	<!--원주문수량-->
			    						<td GH="80 STD_RCVQTY" GCol="text,QTYRCV" GF="N 20,0">WMS입고수량</td>	<!--WMS입고수량-->
			    						<td GH="80 STD_AMOUNT" GCol="text,AMOUNT" GF="N 20,2">총금액</td>	<!--총금액-->
			    						<td GH="80 STD_CUBICT" GCol="text,CUBICT" GF="N 20,2">총CBM</td>	<!--총CBM-->
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
				
				<div class="table_box section" id="tab1-5">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList5">
									<tr CGRow="true">                         
			    						<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 4">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="60 STD_DOCUTY" GCol="text,DOCUTY" GF="S 10">출고유형</td>	<!--출고유형-->
			    						<td GH="80 STD_DOCUTYNM" GCol="text,DOCUTYNM" GF="S 180">문서타입명</td>	<!--문서타입명-->
			    						<td GH="60 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 180">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_QTSORG" GCol="text,QTYORG" GF="N 20,0">원주문수량</td>	<!--원주문수량-->
			    						<td GH="80 STD_RCVQTY" GCol="text,QTYRCV" GF="N 20,0">WMS입고수량</td>	<!--WMS입고수량-->
			    						<td GH="80 STD_AMOUNT" GCol="text,AMOUNT" GF="N 20,2">총금액</td>	<!--총금액-->
			    						<td GH="80 STD_CUBICT" GCol="text,CUBICT" GF="N 20,2">총CBM</td>	<!--총CBM-->
			    						<td GH="80 STD_QTDUOM" GCol="text,QTDUOM" GF="N 20,0">입수</td>	<!--입수-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 20,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLTQTYCAL" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_QTPUOM" GCol="text,QTPUOM" GF="N 20,2">Units per measure</td>	<!--Units per measure-->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 20,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
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