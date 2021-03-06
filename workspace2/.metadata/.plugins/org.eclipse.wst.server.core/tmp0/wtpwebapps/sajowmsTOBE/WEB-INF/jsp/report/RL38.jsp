<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL01</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<style>
	.red{color: red !important; }
	.black{color: black !important; }
</style>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
var save;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Report", 
			command : "RL38",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "RL38"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Report",
			command : "RL38_ITEM",
		    menuId : "RL38"
	    });
		 
		//콤보박스 리드온리
	});
	
	//버튼작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "RL38");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "RL38");
 		}
	}
	
	function linkPopCloseEvent(data){ //팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");

			  netUtil.send({
			  	url : "/outbound/json/displayRL38.data",
			  	param : param,//gridList.gridList({
			  	sendType : "list",//    id : "gridHeadList",
			  	bindType : "grid",  //bindType grid 고정//    param : param
			  	bindId : "gridHeadList" //그리드ID//  });
			  });
		}
	}
	
	//아이템그리드 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			//row데이터 이외에 검색조건 추가가 필요할 떄 
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
    	return param;
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
						<input type="button" CB="Search SEARCH STD_SEARCH" /> <input
							type="button" CB="Save SAVE BTN_SAVE" /> <input type="button" CB="Reload RESET STD_REFLBL" />
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
						<dl> <!-- 거점 -->
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>  <!--작업일자 -->  
							<dt CL="STD_DOCDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="PP.STDDAT" UIInput="B" UIFormat="C 1"/> 
							</dd> 
						</dl> 
						<dl>  <!--작업자 -->  
							<dt CL="STD_WORKER"></dt> 
							<dd> 
								<input type="text" class="input" name="UM.NMLAST" UIInput="SR"/> 
							</dd> 
						</dl> 
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more" onclick="searchMore()" />
					</div>
				</div>
			</div>
			<div class="search_next_wrap">
			<div class="content_layout tabs top_layout head_tabs">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1" ><span>일반</span></a></li>
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
			    						<td GH="80 STD_GUBUN" GCol="text,GUBUN" GF="S">구분</td>	<!--구분-->
			    						<td GH="80 STD_DOCDAT" GCol="text,STDDAT" GF="D">작업일</td>	<!--작업일-->
			    						<td GH="100 STD_WORKER" GCol="text,WORKER" GF="S">작업자</td>	<!--작업자-->
			    						<td GH="80 STD_USERID" GCol="text,CREUSR" GF="S">작업자ID</td>	<!--작업자ID-->
			    						<td GH="80 STD_QTCOMP" GCol="text,QTCOMP" GF="N">작업수량</td>	<!--총 작업수량-->
			    						<td GH="50 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!-- 박스수량 -->
			    						<td GH="50 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!-- 팔레트수량  -->
			    						<td GH="50 STD_TOTQTY" GCol="text,TOTQTY" GF="N 17,0">당일총수량</td>	<!-- 당일총수량  -->
			    						<td GH="50 STD_WORPER" GCol="text,WORPER" GF="N 17,4">작업퍼센트</td>	<!-- 작업퍼센트  -->
			    					<!-- 	<td GH="50 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	박스입수
			    						<td GH="50 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,0">박스수량</td>	박스수량
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;>팔레트입수</td>	팔레트입수
			    						<td GH="50 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	팔레트수량 -->
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
			</div>
			<div class="content_layout tabs bottom_layout item_tabs">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1" ><span>상세내역</span></a></li>
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
										<td GH="80 STD_WRKTIM" GCol="text,CRETIM" GF="T">작업시간</td> <!--배송일자-->
										<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D">배송일자</td> <!--배송일자-->
								        <td GH="120 STD_SSORNU" GCol="text,SSORNU" GF="S 50">차량별피킹번호</td> <!--차량별피킹번호-->
			    						<!-- <td GH="70 IFT_SVBELN" GCol="text,SVBELN" GF="S">S/O 번호</td>	S/O 번호 -->
			    						<td GH="70 STD_GUBUN" GCol="text,LOCAKYNM" GF="S 20">구분</td>	<!--구분-->
			    						<td GH="70 STD_LOCAKY" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="70 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="190 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="50 STD_QTCOMP" GCol="text,QTYWRK" GF="N 13,0">완료</td>	<!--완료-->
			    						<td GH="50 STD_QTYORG" GCol="text,QTCOMP" GF="N 13,0">오더수량</td>	<!--오더수량-->
			    						<td GH="50 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="50 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--팔렛입수-->
			    						<td GH="50 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔렛수량</td>	<!--팔렛수량-->
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
			</div>
		</div>
		</div>
	</div>
	<!-- // content -->
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>