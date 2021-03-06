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
			command : "SP02",
			menuId : "SP02"
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
	 		sajoUtil.openSaveVariantPop("searchArea", "SP02");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "SP02");
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
					
					<dl>  <!--SET제품-->  
						<dt CL="STD_SETSKU"></dt> 
						<dd> 
							<input type="text" class="input" name="PACKID" UIInput="SR,SHSKUMA2"/> 
						</dd> 
					</dl>
					
					<dl>  <!--SET제품명-->  
						<dt CL="STD_SETSKUNM"></dt> 
						<dd> 
							<input type="text" class="input" name="SHORTX" UIInput="SR"/> 
						</dd> 
					</dl>
					
					<dl>  <!--BOM제품-->  
						<dt CL="STD_BOMSKU"></dt> 
						<dd> 
							<input type="text" class="input" name="SKUKEY" UIInput="SR,SHSKUMA2"/> 
						</dd> 
					</dl>
					
					<dl>  <!--BOM제품명-->  
						<dt CL="STD_BOMSKUNM"></dt> 
						<dd> 
							<input type="text" class="input" name="DESC01" UIInput="SR" nonUpper="Y"/> 
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
											<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    						<td GH="100 STD_SETSKU" GCol="text,PACKID" GF="S 30">SET 제품</td>	<!--SET 제품-->
				    						<td GH="150 STD_SETSKUNM" GCol="text,SHORTX" GF="S 180">SET 제품명</td>	<!--SET 제품명-->
				    						<td GH="100 STD_BOMSKU" GCol="text,SKUKEY" GF="S 20">BOM 제품</td>	<!--BOM 제품-->
				    						<td GH="150 STD_BOMSKUNM" GCol="text,DESC01" GF="S 180">BOM 제품명</td>	<!--BOM 제품명-->
				    						<td GH="100 STD_PKDUOM" GCol="text,PKDUOM" GF="N 5,0">SET 입수</td>	<!--SET 입수-->
				    						<td GH="100 STD_SKDUOM" GCol="text,SKDUOM" GF="N 5,0">BOM 입수</td>	<!--BOM 입수-->
				    						<td GH="100 STD_SETQTY" GCol="text,PAKQTY" GF="N 5,0">SET 수량</td>	<!--SET 수량-->
				    						<td GH="100 STD_BOMQTY" GCol="text,UOMQTY" GF="N 5,0">BOM 수량</td>	<!--BOM 수량-->
				    						<td GH="100 STD_SORTSQ" GCol="text,SORTSQ" GF="N 4,0">배송순서</td>	<!--배송순서-->
				    						<td GH="100 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
				    						<td GH="100 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
				    						<td GH="100 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
				    						<td GH="100 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td>	<!--생성자명-->
				    						<td GH="100 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
				    						<td GH="100 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
				    						<td GH="100 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
				    						<td GH="100 STD_LUSRNM" GCol="text,LUSRNM" GF="S 50">수정자명</td>	<!--수정자명-->
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