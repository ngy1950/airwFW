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
	    	module : "OyangOutbound",
			command : "OY15_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "OY15"
	    });
		
		gridList.setGrid({
	    	id : "gridHeadList2",
	    	module : "OyangOutbound",
			command : "OY15_HEAD2",
			itemGrid : "gridItemList2",
			itemSearch : false,
		    menuId : "OY15"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OyangOutbound",
			command : "OY15_ITEM",
			emptyMsgType : false,
		    menuId : "OY15"
	    });

		
		gridList.setGrid({
	    	id : "gridItemList2",
	    	module : "OyangOutbound",
			command : "OY15_ITEM2",
			emptyMsgType : false,
		    menuId : "OY15"
	    });

		gridList.setReadOnly("gridHeadList", true, ["WAREKY", "WARETG"]);
		gridList.setReadOnly("gridItemList", true, ["SHPMTY"]);
		gridList.setReadOnly("gridItemList2", true, ["WAREKY"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();

	});
	
	//버튼 작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			//searchList();
			$('#aHeader1').trigger("click");
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "OY15");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "OY15");
		}
	}

	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridHeadList2");
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridItemList2");
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
			
		}
	}

	//조회(부족재고)
	function searchList2(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridHeadList2");
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridItemList2");
			var param = inputList.setRangeParam("searchArea");
			
			gridList.gridList({
		    	id : "gridHeadList2",
		    	param : param
		    });
			
		}
	}
	
	//출고완료 생성
	function saveData(){

		//체크한 row
		var head = gridList.getSelectData("gridHeadList");
		
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		var param = new DataMap();
		param.put("head",head);
		
	 	netUtil.send({
			url : "/OyangOutbound/json/saveOY15.data",
			param : param,
			successFunction : "successSaveCallBack"
		}); 
	}

	
	//저장성공시 callback
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data.RESULT == "S"){
				searchList();
			}else{
				commonUtil.msgBox("VALID_M0002");
			}
		}
	}
	
	
	//아이템 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			
			
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}else if(gridId == "gridHeadList2"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			
			gridList.gridList({
		    	id : "gridItemList2",
		    	param : param
		    });
			
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "200");
		}
	}
	
    //텝이동시 작동
    function moveTab(obj){
    	if(obj.attr('href') == '#tab1-1'){
    		$("#atab2-1").trigger("click");
    		searchList();
    	}else if(obj.attr('href') == '#tab1-2'){
    		$("#atab2-2").trigger("click");
    		//부족재고 조회 
    		searchList2();
    	}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHCMCDV" && $inputObj.name == "BZ2.PTNG08"){
            param.put("CMCDKY","PTNG08");
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
					<input type="button" CB="Save SAVE BTN_ALOCOM" />
				<!-- 	<input type="button" CB="RestCom SAVE BTN_RESTCOM" />  작업여부 키를 사용하지 않을 것이므로 삭제-->
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
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>  <!--납품요청일-->  
						<dt CL="STD_VDATU"></dt> 
						<dd> 
							<input type="text" class="input" name="OTRQDT" UIFormat="C N" UIInput="B" validate="required(STD_VDATU)"/> 
						</dd> 
					</dl> 
					<dl>  <!--S/O번호-->  
						<dt CL="STD_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
				</div> 
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap h-wrap-min">	
				<div class="content_layout tabs content_left" style="width: 430px;">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1" id="aHeader1" onclick="moveTab($(this));"><span id="atab1-1">일반</span></a></li>
						<li><a href="#tab1-2" onclick="moveTab($(this));"><span id="atab1-2">부족재고조회</span></a></li>
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
									<tbody id="gridHeadList">
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td>
											<td GH="40" GCol="rowCheck"></td>
				    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 10">S/O 번호</td>	<!--S/O 번호-->
				    						<td GH="120 IFT_WAREKY" GCol="select,WAREKY"><!--WMS거점(출고사업장)-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select> 
				    						</td>
				    						<td GH="120 IFT_WARETG" GCol="select,WARETG">	<!--TO ERP창고-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select> 
				    						</td>
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
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab1-2">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridHeadList2">
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td> 
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 20">제품명</td>	<!--제품명-->
				    						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 20,0">납품요청수량</td>	<!--납품요청수량-->
				    						<td GH="80 현재고" GCol="text,TOTQTY" GF="N 20,0">현재고</td>	<!--현재고-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="total"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
				</div>
				<div class="content_layout tabs content_right" style="width : calc(100% - 430px);">
					<ul class="tab tab_style02">
						<li><a href="#tab2-1" onclick="moveTab($(this));"><span id="atab2-1">일반</span></a></li>
						<li style="display:none;"><a href="#tab2-2" onclick="moveTab($(this));"><span id="atab2-2">부족재고조회</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
								<li><button class="btn btn_bigger"><span>확대</span></button></li>
							</ul>
						</li>
					</ul>
					<div class="table_box section" id="tab2-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridItemList">
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td>
				    						<td GH="120 IFT_DOCUTY" GCol="select,SHPMTY"> <!--출고유형-->
												<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select> 
				    						</td>	
				    						<td GH="80 IFT_OTRQDT" GCol="text,DOCDAT" GF="D 6">출고요청일</td>	<!--출고요청일-->
				    						<td GH="100 STD_SVBELN" GCol="text,SVBELN" GF="S 10">S/O 번호</td>	<!--S/O 번호-->
				    						<td GH="80 IFT_PTNRTO" GCol="text,PTRCVR" GF="S 20">납품처코드</td>	<!--납품처코드-->
				    						<td GH="120 IFT_PTNRTONM" GCol="text,PTRCVRNM" GF="S 20">납품처명</td>	<!--납품처명-->
				    						<td GH="80 IFT_PTNROD" GCol="text,DPTNKY" GF="S 20">매출처코드</td>	<!--매출처코드-->
				    						<td GH="80 STD_PTNRODNM" GCol="text,DPTNKYNM" GF="S 20">매출처명</td>	<!--매출처명-->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 20">제품명</td>	<!--제품명-->
				    						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 20,0">납품요청수량</td>	<!--납품요청수량-->
				    						<td GH="150 STD_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	<!--비고-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="total"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab2-2">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridItemList2">
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td>  
				    						<td GH="80 STD_WAREKY" GCol="select,WAREKY">	<!--거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select> 
											</td>
				    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 20">S/O 번호</td>	<!--S/O 번호-->
				    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
				    						<td GH="120 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td>	<!--매출처명-->
				    						<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
				    						<td GH="120 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
				    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 20">제품명</td>	<!--제품명-->
				    						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 20,0">납품요청수량</td>	<!--납품요청수량-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
<!-- 							<button type='button' GBtn="total"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="total"></button>
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