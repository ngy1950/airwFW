<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
var shrow = -1;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	module : "Master",
	    	pkcol : "OWNRKY,SKUKEY",
			command : "SL01",
			menuId : "SL01"
	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	

	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			shrow = -1;
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
		}
	}


	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "SL01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "SL01");
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

	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
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
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_LOTNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTNUM" UIInput="SR"/> 
						</dd> 
					</dl>
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl>
					
					<dl>  <!--출고일자-->  
						<dt CL="STD_LOTA13"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA13" id="LOTA13" UIFormat="C" UIInput="R"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--출고일자-->  
						<dt CL="STD_LOTA12"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA12" id="LOTA13" UIFormat="C -7" UIInput="R"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_LOTA03"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA03" UIInput="SR,SHLOTA03CM"/> 
						</dd> 
					</dl>
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_LOTA05"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05"/> 
						</dd> 
					</dl>
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_LOTA06"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA05"/> 
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
						<li><a href="#tab1-1"><span>일반</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<li><button class="btn btn_smaller"><span>축소</span></button></li>
								<li><button class="btn btn_bigger"><span>확대</span></button></li>
							</ul>
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList">
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td>
											<td GH="100 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
				    						<td GH="60 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    						<td GH="100 STD_OWNRKYNM" GCol="text,OWNRKYNM" GF="S 100">화주명</td>	<!--화주명-->
				    						<td GH="60 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="120 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
				    						<td GH="100 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 100">제품명</td>	<!--제품명-->
				    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 100">규격</td>	<!--규격-->
				    						<td GH="160 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
				    						<td GH="100 STD_LOTA05" GCol="text,LOTA05" GF="S 20">포장구분</td>	<!--포장구분-->
				    						<td GH="100 STD_LOTA05NM" GCol="text,LOTA05NM" GF="S 100">포장구분명</td>	<!--포장구분명-->
				    						<td GH="160 STD_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
				    						<td GH="100 STD_LOTA06NM" GCol="text,LOTA06NM" GF="S 100">재고유형명</td>	<!--재고유형명-->
				    						<td GH="112 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
				    						<td GH="112 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
				    						<td GH="112 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
				    						<td GH="112 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td>	<!--생성일자-->
				    						<td GH="112 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td>	<!--생성시간-->
				    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td>	<!--생성자-->
				    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 30">생성자명</td>	<!--생성자명-->
				    						<td GH="112 STD_LMODAT" GCol="text,LMODAT" GF="D 10">수정일자</td>	<!--수정일자-->
				    						<td GH="112 STD_LMOTIM" GCol="text,LMOTIM" GF="T 10">수정시간</td>	<!--수정시간-->
				    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 10">수정자</td>	<!--수정자-->
				    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 30">수정자명</td>	<!--수정자명-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="add"></button>
							<button type='button' GBtn="copy"></button>
<!-- 							<button type='button' GBtn="delete"></button> -->
							<button type='button' GBtn="total"></button>
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="saveLayout"></button>
							<button type='button' GBtn="getLayout"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
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