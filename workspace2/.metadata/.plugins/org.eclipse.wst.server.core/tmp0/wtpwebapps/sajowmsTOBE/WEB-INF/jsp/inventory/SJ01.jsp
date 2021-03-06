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
	var headRow = -1;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "InventorySetBom",
			command : "SJ01",
			itemGrid : "gridItemList",
			itemSearch : false,
		    menuId : "SJ01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Inventory",
			command : "SJ01_ITEM",
			pkcol : "SKUKEY,QTADJU,BOXQTY,LOTA13,LOTA11,LOTA12,LOCAKY,PLTQTY",
		    menuId : "SJ01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList2",
	    	module : "Inventory",
			command : "SJ01_ITEM",
		    menuId : "SJ01"
	    });
		 
		gridList.setReadOnly("gridItemList", true, ["LOTA06"]);
		$('#tab1ty2').hide();
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});
	
	//버튼 동작
	function commonBtnClick(btnName){
		var ownrky = $("#OWNRKY").val();
		
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Setjoin"){
			setjoin();
		}else if(btnName == "SetCancel"){
			setCancel();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "SJ01");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "SJ01");
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridItemList2");
			uiList.setActive("Save",true);
			
			var param = inputList.setRangeDataParam("searchArea");
			param.put("ADJUCA", "400");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}

	//저장 
	function saveData(){
		if(gridList.validationCheck("gridItemList2", "data") && gridList.validationCheck("gridHeadList", "data")){
			
			//수량부족 체크 
			var itemGridBox = gridList.getGridBox('gridItemList2');
			var itemList = itemGridBox.getDataAll();
			
			if(itemList.length < 1){
				commonUtil.msgBox("MASTER_M0345");
				return;
			}
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {	// 저장하시겠습니까?
				return;	
			}
			
			for(var i=0; i<itemList.length; i++){
				var qtlack = Number(gridList.getColData("gridItemList2", itemList[i].get("GRowNum"), "QTLACK"));
				
				if(qtlack < 0 ){ //재고가 부족합니다.
					commonUtil.msgBox("IN_M0079",gridList.getColData("gridItemList2", itemList[i].get("GRowNum"), "DESC01"));
					return;
				}
			}

			var param = inputList.setRangeDataParam("searchArea");
			var item = gridList.getModifyList("gridItemList", "A");
			param.put("OWNRKY", gridList.getColData("gridHeadList", 0, "OWNRKY"));
			param.put("WAREKY", gridList.getColData("gridHeadList", 0, "WAREKY"));
			param.put("DOCTXT", gridList.getColData("gridHeadList", 0, "DOCTXT"));
			param.put("ADJUTY", gridList.getColData("gridHeadList", 0, "ADJUTY"));
			param.put("DOCDAT", gridList.getColData("gridHeadList", 0, "DOCDAT"));
			param.put("item",item);	
			
			netUtil.send({
				url : "/inventorySetBom/json/saveSJ01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}

	
	//세트
	function setjoin(){

		if(gridList.validationCheck("gridItemList", "data") && gridList.validationCheck("gridHeadList", "data")){
			
			if(!gridList.getColData("gridHeadList", 0, "ADJUTY") || gridList.getColData("gridHeadList", 0, "ADJUTY") == ""){
				commonUtil.msgBox("MASTER_M0345");
				return;
			}
			
			
			var param = inputList.setRangeDataParam("searchArea");
			var item = gridList.getModifyList("gridItemList", "A");
			param.put("OWNRKY", gridList.getColData("gridHeadList", 0, "OWNRKY"));
			param.put("WAREKY", gridList.getColData("gridHeadList", 0, "WAREKY"));
			param.put("DOCTXT", gridList.getColData("gridHeadList", 0, "DOCTXT"));
			param.put("ADJUTY", gridList.getColData("gridHeadList", 0, "ADJUTY"));
			param.put("DOCDAT", gridList.getColData("gridHeadList", 0, "DOCDAT"));
			param.put("item",item);	

			netUtil.send({
				url : "/inventorySetBom/json/setJoinSJ01.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList2" //그리드ID
			});
		}
	}
	

	//세트 취소
	function setCancel(){
		gridList.resetGrid("gridItemList2");
		$("#atab1").trigger("click");
		$('#itemGridAdd').show();
		$('#itemGridDelete').show();
		gridList.setReadOnly("gridItemList", false, ["LOCAKY", "SKUKEY", "QTADJU", "BOXQTY", "PLTQTY", "LOTA11", "LOTA12", "LOTA13"]);
	}
	
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data != "E"){
				uiList.setActive("Save",false);
				commonUtil.msgBox("SYSTEM_SAVEOK");
				gridList.setColValue("gridHeadList", 0, "SADJKY", json.data);
			}else if(json.data == "F"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
    

	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount > 0){
			gridList.setAddRow("gridItemList", null);
			gridList.setReadOnly("gridItemList", false, ["LOCAKY", "SKUKEY", "QTADJU", "BOXQTY", "PLTQTY", "LOTA11", "LOTA12", "LOTA13"]);
			$("#atab1").trigger("click");
			$('#itemGridAdd').show();
			$('#itemGridDelete').show();
		}else if(gridId == "gridItemList2" && dataCount > 0){
			$("#atab2").trigger("click");
			gridList.setReadOnly("gridItemList", true, ["LOCAKY", "SKUKEY", "QTADJU", "BOXQTY", "PLTQTY", "LOTA06", "LOTA11", "LOTA12", "LOTA13"]);
			$('#itemGridAdd').hide();
			$('#itemGridDelete').hide();
		}
	}
    

	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			return;
		}
	}

	
	//ADD 클릭시
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		//기본값 세팅 
		newData.put("LOCAKY","SETLOC");
		newData.put("LOTA06","00");
		return newData;
	}
	
	
	//그리드 컬럼 값 변경시 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		if(gridId == "gridItemList"){
			if(colName == "SKUKEY"){ //제품코드 변경시
				var param = new DataMap();
				param.put("OWNRKY", $("#OWNRKY").val());
				param.put("WAREKY", $("#WAREKY").val());
				param.put("SKUKEY", gridList.getColData(gridId, rowNum, colName));
				
				var json = netUtil.sendData({
					module : "SajoCommon",
					command : "SKUMA_GETDESC_RECD",
					sendType : "list",
					param : param
				}); 
				
				
				//sku가 있을 경우 
				if(json && json.data && json.data.length > 0 ){
					var jsonMap = json.data[0];
					for(prop in jsonMap)  {
						gridList.setColValue(gridId, rowNum, prop, json.data[0][prop]);
					}
				}else{
					gridList.setColValue(gridId, rowNum, "SKUKEY", "");
					gridList.setColValue(gridId, rowNum, "DESC01", "");
				}
				
			}else if(colName == "QTADJU" || colName == "BOXQTY" || colName == "PLTQTY"){ //수량변경시 박스 팔렛트 수량 변경
				var qtadju = 0;
				var boxqty = 0;
				var pltqty = 0;
				var bxiqty = gridList.getColData(gridId, rowNum, "BXIQTY");
				var pliqty = gridList.getColData(gridId, rowNum, "PLIQTY");

	  			gridList.setColValue(gridId, rowNum,"QTREMA",0);
				if( colName == "QTADJU" ) {
				  	qtadju = colValue;
				  	boxqty = floatingFloor((Number)(qtadju)/(Number)(bxiqty), 1);
				  	pltqty = floatingFloor((Number)(qtadju)/(Number)(pliqty), 2);
				  	remqty = (Number)(qtadju)%(Number)(bxiqty);
		  			gridList.setColValue(gridId, rowNum,"QTADJU",qtadju);
					gridList.setColValue(gridId, rowNum,"BOXQTY",boxqty);
					gridList.setColValue(gridId, rowNum,"PLTQTY",pltqty);
					gridList.setColValue(gridId, rowNum,"REMQTY",remqty);
				 }if( colName == "BOXQTY" ){ 
				  	boxqty = colValue;
				  	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
				  	qtadju = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				  	pltqty = floatingFloor((Number)(qtadju)/(Number)(pliqty), 2);
				  	
				    gridList.setColValue(gridId, rowNum, "QTADJU", qtadju);
				    gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
				} if( colName == "PLTQTY" ){
					pltqty = colValue;
				  	bxiqty = gridList.getColData(gridId, rowNum, "BXIQTY");
				  				  	
				  	qtadju = (Number)(pltqty)*(Number)(pliqty);
				  	boxqty = floatingFloor((Number)(qtadju)/(Number)(bxiqty), 1);

					gridList.setColValue(gridId, rowNum, "QTADJU", qtadju);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);

				  }
			}else if(colName == "LOTA13"){
				var skukey = gridList.getColData(gridId, rowNum, "SKUKEY");
				if(skukey == "" || skukey == " "){
					commonUtil.msgBox("제품코드를 입력해주세요");
					gridList.setColValue(gridId, rowNum, "LOTA13", " "); // 제품코드 미입력 시 유통기한 입력불가
					return;
				}
				var outdmt = gridList.getColData(gridId, rowNum, "OUTDMT");
				var lota13 = gridList.getColData(gridId, rowNum, "LOTA13");
				
				var lota11 = dateParser(lota13 , 'S', 0 , 0 , -Number(outdmt));
				gridList.setColValue(gridId, rowNum, "LOTA11", lota11);	
				
			}
		}
	} // end gridListEventColValueChange
    
    
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "400");
			param.put("DOCUTY", "401");
		}
		
		return param;
	}
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if(searchCode == "SHSKUSETI2" ){
            param.put("WAREKY",$("#WAREKY").val());
            param.put("OWNRKY",$("#OWNRKY").val());
        }else  if(searchCode == "SHLOCMA" ){
            param.put("WAREKY",$("#WAREKY").val());
        }
        
    	return param;
    }
	
	
    //텝이동시 기타 초기화 
    function moveTab(idx){
		switch (idx) {
		case 0:
			$('#tab1ty').show();
        	$('#tab1ty2').hide();
			break;
        case 1:
        	$('#tab1ty').hide();
        	$('#tab1ty2').show();
			break;
		default:
			break;
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
					<input type="button" CB="Search SEARCH BTN_CREATE" />
					<input type="button" CB="Save SAVE BTN_SAVE" />
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
					
					<dl>  <!--작업타입-->  
						<dt CL="STD_TASOTY"></dt> 
						<dd> 
							<select name="ADJUTY" id="ADJUTY" class="input" Combo="SajoCommon,DOCUTY_COMCOMBO" ></select> 
						</dd> 
					</dl> 
					
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="LOCAKY" value="SETLOC" readonly="readonly"/> 
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
										<td GH="40 STD_NUMBER" GCol="rownum">1</td>
			    						<td GH="80 STD_SADJKY" GCol="text,SADJKY" GF="S 10">조정문서번호</td>	<!--조정문서번호-->
			    						<td GH="80 STD_DOCTXT" GCol="text,DOCTXT" GF="S 100">비고</td> <!--비고-->
			    						<td GH="80 STD_ADJUTY" GCol="text,ADJUTY" GF="S 4">조정문서 유형</td>	<!--조정문서 유형-->
			    						<td GH="120 STD_ADJUTYNM" GCol="text,ADJUTYNM" GF="S 100">유형명</td>	<!--유형명-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="100 STD_DOCDAT" GCol="input,DOCDAT" GF="D 8"  validate="required">문서일자</td>	<!--문서일자-->
			    						
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td> <!--생성일자-->
								        <td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td> <!--생성시간-->
								        <td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td> <!--생성자-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="120 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="120 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>	<!--문서유형명-->
			    						<td GH="80 STD_ADJUCA" GCol="text,ADJUCA" GF="S 4">조정 카테고리</td>	<!--조정 카테고리-->
			    						<td GH="80 STD_ADJUCANM" GCol="text,ADJUCANM" GF="S 100">조정카테고리명</td>	<!--조정카테고리명-->
			    						
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
					<li onclick="moveTab(0);"><a href="#tab2-1" id="atab1"><span>세트품</span></a></li>
					<li onclick="moveTab(1);"><a href="#tab2-2" id="atab2"><span>단일품</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
					<div id="tab1ty" name="tab1ty">                                                                                                                                               
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 세트 -->                                                                                             
							<input type="button" CB="Setjoin SAVE BTN_SETJOIN" />                                                                                                   
						</li>                                        
					</div>
					<div id="tab1ty2" name="tab1ty2">                                                                                                                                               
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 취소 -->                                                                                             
							<input type="button" CB="SetCancel SAVE BTN_CANCEL" />                                                                                                   
						</li>                                        
					</div>
					                                                                                                           
				</ul>
				<div class="table_box section" id="tab2-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>      
			    						<td GH="50 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="50 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="70 STD_SADJIT" GCol="text,SADJIT" GF="S 6">조정 Item</td>	<!--조정 Item-->
			    						<td GH="80 STD_SKUKEY" GCol="input,SKUKEY,SHSKUSETI2" GF="S 20" validate="required">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="60 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="60 STD_QTADJU" GCol="input,QTADJU" GF="N 17,0" validate="required">조정수량</td>	<!--조정수량-->
			    						<td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 30,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_LOTA13" GCol="input,LOTA13" GF="C"  validate="required">유통기한</td>	<!--유통기한-->
			    						<td GH="80 STD_LOTA11" GCol="input,LOTA11" GF="C">제조일자</td>	<!--제조일자-->
			    						<td GH="100 STD_LOTA06" GCol="select,LOTA06">	<!--재고유형-->
												<select class="input" commonCombo="LOTA06">
													<option></option>
												</select>
			    						</td>
			    						<td GH="80 STD_LOTA12" GCol="input,LOTA12" GF="C">입고일자</td>	<!--입고일자-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="80 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="60 STD_LOCAKY" GCol="input,LOCAKY,SHLOCMA" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="80 STD_PACKID" GCol="text,PACKID" GF="S 30">SET제품코드</td>	<!--SET제품코드-->
			    						<td GH="80 STD_PLTQTY" GCol="input,PLTQTY" GF="N 30,2">팔렛트수량</td>	<!--팔레트수량-->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17">팔레트입수</td>	<!--팔레트입수-->
			    						<td GH="90 STD_OUTDMT" GCol="text,OUTDMT" GF="N 20,0">유통기한(일수)</td>	<!--유통기한(일수)-->
			    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="80 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="80 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="80 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="80 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 50">제품용도</td>	<!--제품용도-->
			    						<td GH="80 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0">포장중량</td>	<!--포장중량-->
			    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0">순중량</td>	<!--순중량-->
			    						<td GH="80 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="80 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0">포장가로</td>	<!--포장가로-->
			    						<td GH="80 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0">포장세로</td>	<!--포장세로-->
			    						<td GH="80 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0">포장높이</td>	<!--포장높이-->
			    						<td GH="80 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0">CBM</td>	<!--CBM-->
			    						<td GH="80 STD_CAPACT" GCol="text,CAPACT" GF="N 17,0">CAPA</td>	<!--CAPA-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 100">생성자명</td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 100">수정자명</td>	<!--수정자명-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add" id="itemGridAdd"></button>
						<button type='button' GBtn="delete" id="itemGridDelete"></button>
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
				<div class="table_box section" id="tab2-2" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList2">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="80 STD_PACKID" GCol="text,PACKID" GF="S 30">SET제품코드</td>	<!--SET제품코드-->
			    						<td GH="60 STD_QTSIWH" GCol="text,QTSIWH" GF="N 17,0" validate="required">재고수량</td>	<!--재고수량-->
			    						<td GH="60 STD_QTNEED" GCol="text,QTNEED" GF="N 17,0">필요수량</td>	<!--필요수량-->
			    						<td GH="60 STD_QTLACK" GCol="text,QTLACK" GF="N 17,0">부족수량</td>	<!--부족수량-->
			    						<td GH="60 STD_QTREMA" GCol="text,QTREMA" GF="N 17,0">남는수량</td>	<!--남는수량-->
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