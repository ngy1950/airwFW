<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HP37</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList1",
	    	module : "Report",
			command : "HP37_1"
			//pkcol : "COMPKY,PTNRKY,PTNRTY"
	    });
		gridList.setGrid({
	    	id : "gridList2",
			module : "Report",
			command : "HP37_2",
	    });
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

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "HP37");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "HP37");
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
		           
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>  <!--문서일자-->  
						<dt CL="STD_CARDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="CARDAT" UIInput="B" UIFormat="C N" validate="required"/> 
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
						<li><a href="#tab1-1" onclick="display1()" id = "atab1-1"><span>월별</span></a></li>
						<li><a href="#tab1-2" onclick="display2()"><span>일별</span></a></li>
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
				    					<td GH="100 STD_CARDAT" GCol="text,CARDAT" GF="C 20">배송일자</td>	<!-- 배송일자 -->
				    					<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!-- 차량번호  -->
				    					<td GH="80 STD_AUSRID1" GCol="text,DRIVER" GF="S 20">차량기사</td>	<!-- 차량기사 -->
				    					<td GH="100 STD_MAXCNT_QTY" GCol="text,MAXCNT" GF="N 20">전송대상(건)</td>	<!-- 전송대상(건) -->
				    					<td GH="100 STD_PRECNT_QTY" GCol="text,PRECNT" GF="N 20">배송예정시간(건)</td>	<!-- 배송예정시간(건) -->
				    					<td GH="80 STD_STSCNT_QTY" GCol="text,STSCNT" GF="N 20">도착시간(건)</td>	<!-- 도착시간(건) -->
				    					<td GH="80 STD_TOTCNT_QTY" GCol="text,TOTCNT" GF="N 20">합계(건)</td>	<!-- 합계(건) -->
				    					<td GH="100 STD_PREAVG" GCol="text,PREAVG" GF="N 20">배송예정시간(%)</td>	<!-- 배송예정시간(%) -->
				    					<td GH="80 STD_STSAVG" GCol="text,STSAVG" GF="N 20">도착시간(%)</td>	<!--도착시간(%) -->
				    					<td GH="80 STD_TOTAVG" GCol="text,TOTAVG" GF="N 20">전체실적(%)</td>	<!-- 전체실적(%) -->
				    					<td GH="80 STD_GUBUN" GCol="text,GID" GF="N 20">구분</td>	<!-- 구분 -->
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
				    						<td GH="100 STD_CARDAT" GCol="text,CARDAT" GF="C 20">배송일자</td>	<!-- 배송일자 -->
				    						<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!-- 차량번호  -->
				    						<td GH="80 STD_AUSRID1" GCol="text,DRIVER" GF="S 20">차량기사</td>	<!-- 차량기사 -->
				    						<td GH="100 STD_MAXCNT_QTY" GCol="text,MAXCNT" GF="N 20">전송대상(건)</td>	<!-- 전송대상(건) -->
				    						<td GH="100 STD_PRECNT_QTY" GCol="text,PRECNT" GF="N 20">배송예정시간(건)</td>	<!-- 배송예정시간(건) -->
				    						<td GH="80 STD_STSCNT_QTY" GCol="text,STSCNT" GF="N 20">도착시간(건)</td>	<!-- 도착시간(건) -->
				    						<td GH="80 STD_TOTCNT_QTY" GCol="text,TOTCNT" GF="N 20">합계(건)</td>	<!-- 합계(건) -->
				    						<td GH="100 STD_PREAVG" GCol="text,PREAVG" GF="N 20">배송예정시간(%)</td>	<!-- 배송예정시간(%) -->
				    						<td GH="80 STD_STSAVG" GCol="text,STSAVG" GF="N 20">도착시간(%)</td>	<!--도착시간(%) -->
				    						<td GH="80 STD_TOTAVG" GCol="text,TOTAVG" GF="N 20">전체실적(%)</td>	<!-- 전체실적(%) -->
				    						<td GH="80 STD_GUBUN" GCol="text,GID" GF="N 20">구분</td>	<!-- 구분 -->
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
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
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