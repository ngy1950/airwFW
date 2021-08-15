<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>IP13</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var reparam = new DataMap();
var flag = 'N';  // 전체실사지시   여부 N:false, Y:true 
var create_flag = 'N'; // 생성 여부 N: fasle, Y:true
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Inventory",
	    	itemGrid : "gridItemList",
			command : "IP04_HEAD",
		    menuId : "IP13"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Inventory",
			command : "IP13_ITEM",
			pkcol : "LOCAKY,SKUKEY,LOTA13,LOTA11,LOTA06,LOTA05,LOTA16,LOTA03,LOTA01,LOTA02,LOTA04,LOTA07,OUTDMT,LOTA12",
		    menuId : "IP13"
	    });	
		
		//콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["PHSCTY"]);
		gridList.setReadOnly("gridItemList", true, ["AUTLOC"]); 
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
				
	});
	
	//생성
	function searchList(){
		gridList.resetGrid("gridHeadList");
		create_flag = 'Y';
		var param = inputList.setRangeDataParam("searchArea")
		param.put("CREUSR", "<%=userid%>");
		param.put("PHSCTY","520");
		uiList.setActive("Save",true);
		
		gridList.gridList({
	    	id : "gridHeadList",
	    	param : param
	    });
		
		gridList.resetGrid("gridItemList");
		gridList.setAddRow("gridItemList", null);
	}

		
	//ADD 클릭시
	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == 'gridItemList'){
            var newData = new DataMap();
            newData.put("OWNRKY","<%=ownrky %>"); 
            newData.put("QTYSTL", "0"); //전산재고
            
            //생성 버튼 클릭시 아이템 로케이션으로  focus  
            gridList.setColFocus(gridId, rowNum, "LOCAKY");
            
            return newData;
    	}

	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		gridList.gridList({
	    	id : "gridItemList",
	    	param : param
	    });
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		
		// 조사타입 공통코드
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "500");
			param.put("DOCUTY", "520");
			param.put("OWNRKY", $("#OWNRKY").val());
			
		}
		return param;
	}
	
	//전체재고실사지시 
	function saveAll(){
		gridList.checkAll("gridItemList", true);
		
		if(!confirm(commonUtil.getMsg("전체실사지시하시겠습니까?"))){
			gridList.checkAll("gridItemList", false);
			flag = 'N';  // 전체실사지시 여부
			return;
		}
		flag = 'Y'; 
		saveData();
	}
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getGridData("gridHeadList");
			
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			//체크한 row중에 수정된 로우
			var item = gridList.getSelectData("gridItemList", true);
			if(item.length == 0 && item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if(itemMap.SKUKEY == ""){
					commonUtil.msgBox("제품코드를 입력해주세요.");
					return;
				}
				
				if(itemMap.LOCAKY == ""){
					commonUtil.msgBox("로케이션을 입력해주세요.");
					return;
				}
				
				// 전체실사지시가 아닌 경우 제조일자 현재날짜로 셋팅
				if( (itemMap.LOTA11 == "" || itemMap.LOTA11 == " ") && flag == 'N'){ 
					gridList.setColValue("gridItemList", item[i].get("GRowNum"), "LOTA11", dateParser(null, "S", 0, 0, 0)); // 제조일자 미입력시 현재날짜 셋팅
				}
				
			}	
			item = gridList.getSelectData("gridItemList", true);
			
			var param = new DataMap();
			param.put("create_YN",create_flag);
			param.put("head",head);
			param.put("item",item);
			param.put("OWNRKY",$("#OWNRKY").val());
			param.put("WAREKY",$("#WAREKY").val());
			param.put("CREUSR", "<%=userid%>");
			param.put("LMOUSR", "<%=userid%>");
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
				// 저장하시겠습니까?
				return;
			}
			
			netUtil.send({
				url : "/inventory/json/saveIP01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	
	function successSaveCallBack(json, status){ 
		if(json && json.data){
			
 			$('#nBtn').hide();  //생성버튼 숨기기
 			$('#cBtn').hide();	//실행 버튼 숨기기	
 			$('#aBtn').hide();  //전체실사지시 버튼 숨기기
 			
			if(json.data["RESULT"] == "S"){
				//헤더 재고조사번호 출력
				gridList.setColValue("gridHeadList", 0, "PHYIKY", json.data["PHYIKY"]);
				uiList.setActive("Save",false);
				commonUtil.msgBox("SYSTEM_SAVEOK");
		 		
				//저장 후  재조회
 				var param = new DataMap();
 				param.put("PHYIKY", json.data["PHYIKY"]);
 				param.put("OWNRKY", $("#OWNRKY").val());
 				param.put("WAREKY", $("#WAREKY").val());
 				
 				netUtil.send({
 		    		module : "Inventory",
 					command : "IP13_ITEM",
 					bindType : "grid",
 					sendType : "list",
 					bindId : "gridItemList",
 			    	param : param
 				});
				
 			// "실행" 후 -> 저장 된 데이터만 재조회 
// 				if(create_flag == "N"){
					
// 					gridList.gridList({
// 				    	id : "gridItemList",
// 				    	param : param
// 				    }); 	
					
// 				}
 						 		
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function commonBtnClick(btnName){
		var ownrky = $("#OWNRKY").val();	
		if(btnName == "New"){ //생성
			searchList();
		}else if(btnName == "Save"){ //저장
			saveData();
		}else if(btnName == "Create"){ //실행
			create();
		}else if(btnName == "saveAll"){ //전체실사지시
			saveAll();
		}else if(btnName == "Print"){ //프린트
			 if(ownrky == "2100" || ownrky == "2500"){
				 printEZGenDR16("/ezgen/physical_count_stock_list.ezg");	 
			 }else if(ownrky == "2200"){
				 printEZGenDR16("/ezgen/physical_count_stock_list_dr.ezg"); 
			 }					
		}else if(btnName == "PRINTGRP"){ //프린트(그룹)
			 if(ownrky == "2100" || ownrky == "2500"){
				 printEZGenDR16("/ezgen/physical_count_stock_group.ezg");	 
			 }else if(ownrky == "2200"){//해표메뉴
				 printEZGenDR16("/ezgen/physical_count_stock_group_dr.ezg"); 
			 }					 
		}else if(btnName == "PRINTSHP"){ //프린트(입/출고 포함)
			if(ownrky == "2100" || ownrky == "2500"){
				 printEZGenDR16("/ezgen/physical_shpdi_stock_list.ezg");	  
			 } //2200 해표메뉴 없음	
			 
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "IP13");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "IP13");
 		}
	}
	
	//실행
	function create(){
		var param = inputList.setRangeDataParam("searchArea");
		param.put("STOKKY","");
		flag = 'N';	// 전체실사지시 여부
		
		searchList();
		create_flag = 'N';	// 생성 여부 N: fasle, Y:true
		
		netUtil.send({
    		module : "Inventory",
			command : "IP13_FINDSTKKYLIST_ITEM",
			bindType : "grid",
			sendType : "list",
			bindId : "gridItemList",
	    	param : param
		});
				
	}
	
	
	function printEZGenDR16(url){
		
    	//for문을 돌며 TEXT03 KEY를 꺼낸다.
		var headList = gridList.getGridData("gridHeadList");
    	
		if(headList.length < 1){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

		var wherestr = ""; 
		var count = 0;
		var phyiky;
		//재고조사번호
		phyiky = gridList.getColData("gridHeadList", 0, "PHYIKY");
		
		if(phyiky == "" || phyiky == " "){
			commonUtil.msgBox("재고실사 지시문서가 생성되지 않았습니다.");
			return;
		}
		
		if(wherestr == ""){
			wherestr = " AND PHYIKY IN ("; 
		}else{
			wherestr += ",";
		}
		wherestr += "'"+phyiky+"'";
		
		wherestr+=") ";
		
		// phyiky 없을 경우
		if(phyiky < 1){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		//이지젠 호출부(신버전)
		var width = 620;
		var heigth = 400;
		var map = new DataMap();
		map.put("i_option", '\'<%=wareky %>\'');
		WriteEZgenElement(url , wherestr , "" , "KO", map , width , heigth ); // 구버전 ezgenPrint와 같다
		
		//searchList();
	}
	
	//그리드 컬럼 변경 이벤트
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
					
				// LOTA11 제조일자
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
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        //동
        if(searchCode == "SHAREMA" && $inputObj.name == "I.WAREKY"){
            param.put("CMCDKY","WAREKY");
            param.put("AREAKY","AREAKY");
            param.put("AREATY","AREATY");
        //제품코드
        }else if(searchCode == "SHSKUMA"){
        	param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        //로케이션
        }else if(searchCode == "SHLOCMA"){
            param.put("CMCDKY","WAREKY");
         	param.put("WAREKY", $("#WAREKY").val());
        	param.put("OWNRKY", $("#OWNRKY").val());
                
     		//배열선언
    		var rangeArr = new Array();
    		//배열내 들어갈 데이터 맵 선언
    		var rangeDataMap = new DataMap();
    		// 필수값 입력
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SYS");
    		//배열에 맵 탑제 
    		rangeArr.push(rangeDataMap);
    		param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
    		
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SHP");
    		rangeArr.push(rangeDataMap); 
        	param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
        //세트여부
   		}else if(searchCode == "SHCMCDV" && $inputObj.name == "S.ASKU02"){
        	param.put("CMCDKY","ASKU02");
   		//제품용도
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG05"){
			param.put("CMCDKY","SKUG05");
		//벤더
		}else if(searchCode == "SHLOTA03CM" && $inputObj.name == "S.LOTA03"){
			param.put("CMCDKY","WAREKY");
			param.put("OWNRKY","<%=ownrky %>");
			param.put("PTNRTY","0001");
			
		//그리드 제품코드 검색
        }else if(searchCode == "SHSKU_INFO" ){
            param.put("WAREKY",$("#WAREKY").val());
            param.put("OWNRKY",$("#OWNRKY").val());
        
     	//그리드 벤더 검색
	    }else if(searchCode == "SHLOTA03SJ" ){
	        param.put("OWNRKY",$("#OWNRKY").val());
	        param.put("PTNRTY","0002");
	    }
    	return param;
    }
	
	//아이템그리드'벤더' 서치헬프 종료 이벤트
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		if( searchCode == 'SHLOTA03SJ'){
			gridList.setColValue("gridItemList", gridList.getFocusRowNum("gridItemList"), "LOTA03", rowData.get("PTNRKY"));
			gridList.setColValue("gridItemList", gridList.getFocusRowNum("gridItemList"), "LOTA03NM", rowData.get("NAME01"));
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
	
  //그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
// 	function gridListRowColorChange(gridId, rowNum){
// 		if(gridId == "gridItemList"){
// 			if(Number(gridList.getColData("gridHeadList", rowNum, "BOXQTY3"))){
// 				return configData.GRID_COLOR_TEXT_RED_CLASS;
// 			}
// 		}
// 	}
	
	//?? 구버전 
//     function setColumn(colId, isAll){
//     	for(var i=1; i<=phydiGrid.rowCount; i++){
//     		if(isAll){
//     			phydiGrid.SetFontColor(colId,   i, "#F51633");
//     		}
//     	}
//     }

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
					<input type="button" CB="New ADD BTN_NEW" id="nBtn"/> <!-- 생성  searchList-->
					<input type="button" CB="Save SAVE BTN_SAVE" /> <!-- 저장 save -->
					<input type="button" CB="Create POPUP BTN_RUN" id="cBtn"/><!-- 실행 create-->
					<input type="button" CB="saveAll SAVE BTN_SAVE_ALL" id="aBtn" /> <!-- 전체실사지시 saveAll-->
					<input type="button" CB="Print PRINT_OUT BTN_PRINT" /> <!-- 프린트 -->
					<input type="button" CB="PRINTGRP PRINT_OUT BTN_PRINTGRP" /> <!-- 프린트(그룹) -->
					<input type="button" CB="PRINTSHP PRINT_OUT BTN_PRINTSHP" /> <!-- 프린트(입/출고포함) -->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl> <!-- 화주 -->
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required" ></select>
						</dd>
					</dl>
					<dl> <!-- 거점 -->
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" validate="required"></select>
						</dd>
					</dl>
					<dl>  <!--실사그룹-->  
						<dt CL="STD_PHYGRP"></dt> 
						<dd> 
							<input type="text" class="input" name="Z.GRPOKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--동-->  
						<dt CL="STD_AREAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.AREAKY" UIInput="SR,SHAREMA"/> 
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
							<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="S.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--세트여부-->  
						<dt CL="STD_ASKU02"></dt> 
						<dd> 
							<input type="text" class="input" name="S.ASKU02" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품용도-->  
						<dt CL="STD_SKUG05"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUG05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--팔렛트ID-->  
						<dt CL="STD_TRNUID"></dt> 
						<dd> 
							<input type="text" class="input" name="S.TRNUID" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl> <!-- 유통기한 -->
						<dt CL="STD_LOTA13"></dt>
						<dd>
							<input type="text" class="input" name="LOTA13" UIInput="R" UIFormat="C"/>
						</dd>
					</dl>
					<dl> <!-- 입고일자 -->
						<dt CL="STD_LOTA12"></dt>
						<dd>
							<input type="text" class="input" name="LOTA12" UIInput="R" UIFormat="C"/>
						</dd>
					</dl>
					<dl> <!-- 벤더 -->
						<dt CL="STD_LOTA03"></dt>
						<dd>
							<input type="text" class="input" name="LOTA03" UIInput="SR,SHLOTA03CM"/>
						</dd>
					</dl>
					<dl> <!-- 포장구분 -->
						<dt CL="STD_LOTA05"></dt>
						<dd>
							<input type="text" class="input" name="LOTA05" UIInput="SR,SHLOTA05"/>
						</dd>
					</dl>
					<dl> <!-- 재고유형 -->
						<dt CL="STD_LOTA06"></dt>
						<dd>
							<input type="text" class="input" name="LOTA06" UIInput="SR,SHLOTA06"/>
						</dd>
					</dl>
					<dl>  <!--출고일자-->  
						<dt CL="STD_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="SR.CARDAT" UIFormat="C" UIInput="R"/> 
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
								        <td GH="100 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td> <!--재고조사번호-->
								        <td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
								        <td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="S 10">문서 유형</td> <!--문서 유형-->  
								        
								        <td GH="150 STD_PHSCTY" GCol="select,PHSCTY" > <!--조사타입--> 
											<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO">
												<option></option>
											</select>
								        </td> 
								        <td GH="100 STD_DOCDAT" GCol="input,DOCDAT" GF="C">문서일자</td> <!--문서일자-->
										<td GH="80 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td>	<!--비고-->
								        <td GH="100 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td> <!--생성일자-->
								        <td GH="100 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td> <!--생성시간-->
								        <td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td> <!--생성자-->
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
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
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
										<td GH="40 STD_NUMBER"  GCol="rownum">1</td>   
										<td GH="40" GCol="rowCheck"></td>
										<td GH="100 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td> <!--재고조사번호-->
										<td GH="80 STD_PHYIIT" GCol="text,PHYIIT" GF="S 6">재고조사item</td> <!--재고조사item-->
										<td GH="80 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td> <!--재고키-->
			    						<td GH="50 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
			    						<td GH="150 STD_LOCAKY" GCol="input,LOCAKY,SHLOCMA" GF="S 20" validate="required">로케이션</td>	<!--로케이션-->
			    						<td GH="150 STD_TRNUID" GCol="text,TRNUID" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
										<td GH="50 STD_SECTID" GCol="text,SECTID" GF="S 4">SectionID</td>	<!--SectionID-->
										<td GH="150 STD_PACKID" GCol="text,PACKID" GF="S 30">SET제품코드</td>	<!--SET제품코드-->
										<td GH="160 STD_SKUKEY" GCol="input,SKUKEY,SHSKU_INFO" GF="S 20" validate="required">제품코드</td>	<!--제품코드-->
			    						<td GH="100 STD_LOTA11" GCol="input,LOTA11" GF="C 14">제조일자</td>	<!--제조일자-->
										<td GH="80 STD_LOTA12" GCol="input,LOTA12" GF="C 14">입고일자</td>	<!--입고일자-->	
										<td GH="100 STD_LOTA13" GCol="input,LOTA13" GF="C 14">유통기한</td>	<!--유통기한-->
			    						<td GH="150 STD_QTYUOM" GCol="text,QTYUOM" GF="N 20">Quantity by unit of measure</td>	<!--Quantity by unit of measure-->
			    						<td GH="50 STD_TRUNTY" GCol="text,TRUNTY" GF="S 4">팔렛타입</td>	<!--팔렛타입-->
			    						<td GH="80 STD_MEASKY" GCol="text,MEASKY" GF="S 10">단위구성</td>	<!--단위구성-->
			    						<td GH="50 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="120 STD_QTADJU" GCol="text,QTADJU" GF="N 200">조정수량</td>	<!--조정수량-->	
			    						<td GH="120 STD_QTYPDA" GCol="text,QTYPDA" GF="N 20">PDA실사수량</td>	<!--PDA실사수량-->
			    						<td GH="120 STD_QTPUOM" GCol="text,QTPUOM" GF="N 20">Units per measure</td>	<!--Units per measure-->
			    						<td GH="50 STD_DUOMKY" GCol="text,DUOMKY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="120 STD_QTDUOM" GCol="text,QTDUOM" GF="N 20">입수</td>	<!--입수-->
			    						<td GH="50 STD_SUBSIT" GCol="text,SUBSIT" GF="S 6">다음 Item번호</td>	<!--다음 Item번호-->
			    						<td GH="50 STD_SUBSFL" GCol="text,SUBSFL" GF="S 1">서브Item플래그</td>	<!--서브Item플래그-->
			    						<td GH="80 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td>	<!--참조문서번호-->
			    						<td GH="50 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td>	<!--참조문서Item번호-->
			    						<td GH="50 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td>	<!--입출고 구분자-->
			    						<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10" value="<%=ownrky%>">화주</td> <!--화주-->
			    						<td GH="160 STD_LOTA01" GCol="input,LOTA01" GF="S 20">LOTA01</td>	<!--LOTA01-->
			    						<td GH="160 STD_LOTA02" GCol="input,LOTA02" GF="S 20">BATCH NO</td>	<!--BATCH NO-->
			    						<td GH="160 STD_LOTA03" GCol="input,LOTA03,SHLOTA03SJ" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="160 STD_LOTA03NM" GCol="input,LOTA03NM" GF="S 20">벤더명</td>	<!--벤더명-->
			    						<td GH="100 STD_LOTA04" GCol="input,LOTA04" GF="S 20">LOTA04</td>	<!--LOTA04-->
			    						
			    						<td GH="100 STD_LOTA05" GCol="select,LOTA05"> <!--포장구분-->
			    							<select class="input" CommonCombo="LOTA05"></select>
			    						</td>	
			    						<td GH="100 STD_LOTA06" GCol="select,LOTA06"> <!--재고유형-->
			    							<select class="input" CommonCombo="LOTA06" ></select>
			    						</td>	
			    						
			    						<td GH="100 STD_LOTA07" GCol="input,LOTA07" GF="S 20">위탁구분</td>	<!--위탁구분-->
			    						<td GH="50 STD_LOTA08" GCol="text,LOTA08" GF="S 20">LOTA08</td>	<!--LOTA08-->
			    						<td GH="50 STD_LOTA09" GCol="text,LOTA09" GF="S 20">LOTA09</td>	<!--LOTA09-->
			    						<td GH="50 STD_LOTA10" GCol="text,LOTA10" GF="S 20">LOTA10</td>	<!--LOTA10-->
										
										<td GH="50 STD_LOTA14" GCol="text,LOTA14" GF="S 14">LOTA14</td>	<!--LOTA14-->
			    						<td GH="50 STD_LOTA15" GCol="text,LOTA15" GF="S 14">LOTA15</td>	<!--LOTA15-->
			    						<td GH="50 STD_LOTA16" GCol="text,LOTA16" GF="S 14">LOTA16</td>	<!--LOTA16-->
			    						<td GH="50 STD_LOTA17" GCol="text,LOTA17" GF="S 14">LOTA17</td>	<!--LOTA17-->
			    						<td GH="50 STD_LOTA18" GCol="text,LOTA18" GF="S 14">LOTA18</td>	<!--LOTA18-->
			    						<td GH="50 STD_LOTA19" GCol="text,LOTA19" GF="S 14">LOTA19</td>	<!--LOTA19-->
			    						<td GH="50 STD_LOTA20" GCol="text,LOTA20" GF="S 14">LOTA20</td>	<!--LOTA20-->	
										<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="80 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
			    						<td GH="100 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="50 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="50 STD_QTYSTL" GCol="text,QTYSTL" GF="N 20">전산재고</td>	<!--전산재고-->
			    						<td GH="50 STD_QTSIWH" GCol="text,QTSIWH" GF="N 20">재고수량</td>	<!--재고수량-->
			    						<td GH="50 STD_USEQTY" GCol="text,USEQTY" GF="N 20">가용수량</td>	<!--가용수량-->
			    						<td GH="50 STD_AUTLOC" GCol="check,AUTLOC">자동창고 여부</td>	<!--자동창고 여부-->
			    						<td GH="50 STD_QTSALO" GCol="text,QTSALO" GF="N 20">할당수량</td>	<!--할당수량-->
			    						<td GH="50 STD_QTSPMI" GCol="text,QTSPMI" GF="N 20">입고중</td>	<!--입고중-->
			    						<td GH="50 STD_QTSPMO" GCol="text,QTSPMO" GF="N 20">이동중</td>	<!--이동중-->
			    						<td GH="50 STD_QTSBLK" GCol="text,QTBLKD" GF="N 20">보류수량</td>	<!--보류수량-->
			    						
<!-- 			    						<td GH="160 STD_OUTDMT" GCol="text,OUTDMT" GF="N 20">유통기한(일수)</td>	유통기한  구버전 -2↑T↑T -->
			    						
			    						<td GH="50 STD_QTYRCV" GCol="text,QTYRCV" GF="N 17,0">입고수량</td> <!--금일 입고수량-->
			    						<td GH="50 STD_BOXRCV" GCol="text,BOXRCV" GF="N 17,1">금일 입고 수량(box)</td> <!--금일 입고 수량(box)-->
			    						<td GH="50 STD_PLTRCV" GCol="text,PLTRCV" GF="N 17,0">금일 입고 수량(팔렛)</td> <!--금일 입고 수량(팔렛)-->
			    						<td GH="50 STD_QTSHPO2" GCol="text,QTSHPO" GF="N 17,0">피킹수량</td> <!--피킹 수량-->
			    						<td GH="50 STD_POBQTY" GCol="text,POBQTY" GF="N 17,1">피킹수량(box)</td> <!--피킹 수량(box)-->
			    						<td GH="50 STD_POPQTY" GCol="text,POPQTY" GF="N 17,0">피킹수량(팔렛)</td> <!--피킹 수량(팔렛)-->
			    						<td GH="50 STD_QTSHPD" GCol="text,QTSHPD" GF="N 17,0">출고수량</td> <!-- 내일 출고 수량-->
			    						<td GH="50 STD_SHBQTY" GCol="text,SHBQTY" GF="N 17,1">출고수량(box)</td> <!-- 내일 출고 수량(box)-->
			    						<td GH="50 STD_SHPQTY" GCol="text,SHPQTY" GF="N 17,0">출고수량(팔렛)</td> <!-- 내일 출고 수량(팔렛)-->
			    						<td GH="50 STD_CARNUM" GCol="text,CARNUM" GF="S 100">차량번호</td> <!--차량번호-->
									</tr>
								</tbody> 
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add"></button>
						<button type='button' GBtn="delete"></button>
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