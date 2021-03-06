<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "InventoryAdjustment",
			command : "SJ09_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "SJ09"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "InventoryAdjustment",
			command : "SJ09_ITEM",
		    menuId : "SJ09"
	    });
		
		// 콤보박스 리드온리
		gridList.setReadOnly("gridItemList", true, ["RSNADJ", "LOTA06"]);	
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "401");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "402");
		rangeArr.push(rangeDataMap);
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "403");
		rangeArr.push(rangeDataMap);
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "410");
		rangeArr.push(rangeDataMap);
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "430");
		rangeArr.push(rangeDataMap);
		
		setSingleRangeData("H.ADJUTY", rangeArr); 
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		
		var param = gridList.getRowData(gridId, rowNum);
		
		if(gridId == "gridHeadList"){
			gridList.gridList({
	    	id : "gridItemList",
	    	param : param
	    });
		}
	}
	
	//버튼 동작
	function commonBtnClick(btnName){
		var ownrky = $("#OWNRKY").val();
		
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "SJ09");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "SJ09");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "400");
			param.put("DOCUTY", "410");
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("OWNRKY", $("#OWNRKY").val());
			param.put("DOCCAT", "400");
			param.put("DOCUTY", "410");
		}
		return param;
		
	}
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");

			var param = inputList.setRangeDataParam("searchArea");
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}


	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if(searchCode == "SHSKUSETI2" ){
            param.put("WAREKY",$("#WAREKY").val());
            param.put("OWNRKY",$("#OWNRKY").val());
        }else  if(searchCode == "SHLOCMA" ){
            param.put("WAREKY",$("#WAREKY").val());
        }else if(searchCode == "SHAREMA"){
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHZONMA"){
            param.put("WAREKY",$('#WAREKY').val());
        }else if(searchCode == "SHLOCMA"){
            param.put("WAREKY",$('#WAREKY').val());
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
<!-- 					<input type="button" CB="Save SAVE BTN_SAVE" /> -->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
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
							<select name="WAREKY" id="WAREKY" class="input" validate="required(STD_WAREKY)"></select>
						</dd>
					</dl>
					
					<dl>  <!--조정일자-->  
						<dt CL="STD_ADJDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="H.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--조정문서번호-->  
						<dt CL="STD_SADJKY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.SADJKY" UIInput="SR,SHADJDH"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--조정문서 유형-->  
						<dt CL="STD_ADJUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="H.ADJUTY" UIInput="SR"  disabled="disabled"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--동-->  
						<dt CL="STD_AREAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.AREAKY" UIInput="SR,SHAREMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--존-->  
						<dt CL="STD_ZONEKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.ZONEKY" UIInput="SR,SHZONMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.LOCAKY" UIInput="SR,SHLOCMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DESC01" UIInput="SR"/> 
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
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>
			    						<td GH="80 STD_SADJKY" GCol="text,SADJKY" GF="S 10">조정문서번호</td>	<!--조정문서번호-->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="50 STD_ADJUTY" GCol="text,ADJUTY" GF="S 4">조정문서 유형</td>	<!--조정문서 유형-->
			    						<td GH="130 STD_ADJDSC" GCol="text,ADJDSC" GF="S 20">조정문서설명</td>	<!--조정문서설명-->
			    						<td GH="60 STD_DOCTXT" GCol="text,DOCTXT" GF="S 20">비고</td>	<!--비고-->
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 10">문서일자</td>	<!--문서일자-->
			    						<td GH="50 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="60 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 20">문서유형명</td>	<!--문서유형명-->
			    						<td GH="50 STD_ADJUCA" GCol="text,ADJUCA" GF="S 4">조정 카테고리</td>	<!--조정 카테고리-->
			    						<td GH="60 STD_ADJUCANM" GCol="text,ADJUCANM" GF="S 20">조정카테고리명</td>	<!--조정카테고리명-->
			    						<td GH="50 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td>	<!--생성시간-->
			    						<td GH="100 STD_CUSRNM" GCol="text,CUSRNM" GF="S 20">생성자명</td>	<!--생성자명-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
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
					<li><a href="#tab2-1" id="atab1"><span>조정 가능 목록</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>                                                                                                    
				</ul>
				<div class="table_box section" id="tab2-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>      
										<td GH="80 STD_SADJKY" GCol="text,SADJKY" GF="S 10">조정문서번호</td>	<!--조정문서번호-->
			    						<td GH="100 STD_SADJIT" GCol="text,SADJIT" GF="S 6">조정 Item</td>	<!--조정 Item-->
			    						<td GH="90 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="80 STD_TRNUID" GCol="text,TRNUID" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="90 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="160 STD_QTADJU" GCol="text,QTADJU" GF="S 20">조정수량</td>	<!--조정수량-->
			    						<td GH="50 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 10">제조일자</td>	<!--제조일자-->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="130 STD_RSNADJ" GCol="select,RSNADJ">
			    							<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option></option>
											</select>
			    						</td>	<!--조정사유코드-->
			    						<td GH="100 STD_ADJRSN" GCol="text,ADJRSN" GF="S 255">조정상세사유</td>	<!--조정상세사유-->
			    						<td GH="80 STD_LOTA05" GCol="text,LOTA05" GF="S 20">포장구분</td>	<!--포장구분-->
			    						<td GH="120 STD_LOTA06" GCol="select,LOTA06">
			    							<select class="input" CommonCombo="LOTA06"></select>
			    						</td>	<!--재고유형-->
			    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td>	<!--재고키-->
			    						<td GH="160 STD_QTBLKD" GCol="text,QTBLKD" GF="S 20">보류수량</td>	<!--보류수량-->
			    						<td GH="50 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td>	<!--참조문서번호-->
			    						<td GH="50 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td>	<!--참조문서Item번호-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="80 STD_LOTA01" GCol="text,LOTA01" GF="S 20">LOTA01</td>	<!--LOTA01-->
			    						<td GH="80 STD_LOTA02" GCol="text,LOTA02" GF="S 20">BATCH NO</td>	<!--BATCH NO-->
			    						<td GH="80 STD_LOTA04" GCol="text,LOTA04" GF="S 20">LOTA04</td>	<!--LOTA04-->
			    						<td GH="80 STD_LOTA07" GCol="text,LOTA07" GF="S 20">위탁구분</td>	<!--위탁구분-->
			    						<td GH="80 STD_LOTA08" GCol="text,LOTA08" GF="S 20">LOTA08</td>	<!--LOTA08-->
			    						<td GH="80 STD_LOTA09" GCol="text,LOTA09" GF="S 20">LOTA09</td>	<!--LOTA09-->
			    						<td GH="80 STD_LOTA10" GCol="text,LOTA10" GF="S 20">LOTA10</td>	<!--LOTA10-->
			    						<td GH="80 STD_LOTA14" GCol="text,LOTA14" GF="S 14">LOTA14</td>	<!--LOTA14-->
			    						<td GH="80 STD_LOTA15" GCol="text,LOTA15" GF="S 14">LOTA15</td>	<!--LOTA15-->
			    						<td GH="80 STD_LOTA16" GCol="text,LOTA16" GF="S 20">LOTA16</td>	<!--LOTA16-->
			    						<td GH="80 STD_LOTA17" GCol="text,LOTA17" GF="S 20">LOTA17</td>	<!--LOTA17-->
			    						<td GH="80 STD_LOTA18" GCol="text,LOTA18" GF="S 20">LOTA18</td>	<!--LOTA18-->
			    						<td GH="80 STD_LOTA19" GCol="text,LOTA19" GF="S 20">LOTA19</td>	<!--LOTA19-->
			    						<td GH="80 STD_LOTA20" GCol="text,LOTA20" GF="S 20">LOTA20</td>	<!--LOTA20-->		    						
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="50 STD_SEBELN" GCol="text,SEBELN" GF="S 15">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="50 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="50 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="50 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						
			    						
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<!-- <button type='button' GBtn="add" id="itemGridAdd"></button>
						<button type='button' GBtn="delete" id="itemGridDelete"></button> -->
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