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
var reparam = new DataMap();
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	itemGrid : "gridItemList",
	    	itemSearch : true,
	    	module : "taskOrder",
			command : "MV01_HEAD",
		    menuId : "MV01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "taskOrder",
			command : "MV01_ITEM",
		    menuId : "MV01"
	    });
		
		// 콤보박스 리드온리
		gridList.setReadOnly("gridItemList", true, ["ASKU02","SKUG01","SKUG05","LOTA02","LOTA05","LOTA06","LOTA07","LOTA08"]);
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			reparam = new DataMap();
			
			param.put("CREUSR", "<%=userid%>");
			param.put("WARETG",$("#WAREKY").val());
			param.put("DOCCAT","300");
			param.put("STATDO","NEW");
			param.put("TASOTY",$("#TASOTY").val()); // 작업타입
			uiList.setActive("Save",true);
			
 			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}// end searchList()
	
	
	// 저장 성공 시 재조회 쿼리
	function reSearchList(json){
		if(validate.check("searchArea")){
			//reparam = inputList.setRangeDataParam("searchArea");
			reparam.put("TASKKY",json.data["TASKKY"]);
			/* 작업수량합계 초기화 */
			$("#QTTAOR").val(0);
			$("#PLTQTY").val(0.0);
			$("#BOXQTY").val(0);
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : reparam,
		    	command : "MV07_HEAD"
		    });
		}
	}// end reSearchList()
	
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){

		if(!reparam.isEmpty()){ // [저장 시 저장 된 데이터를 보여주기 위해 분기 태움]
			var param = gridList.getRowData(gridId, rowNum);
			param.put("OWNRKY",$('#OWNRKY').val());
			param.put("USERID", "<%=userid%>");
			gridList.gridList({
		    	id : "gridItemList",
		    	module : "taskOrder",
				command : "MV09_ITEM",
		    	param : reparam
		    });
		}else{
			var param = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}// end gridListEventItemGridSearch()
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		param.put("OWNRKY", $("#OWNRKY").val());
		
		// 조사타입 및 조정사유코드 공통코드
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("DOCUTY", "320");
			
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			param.put("CMCDKY", "LOTA06");	
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("DOCUTY", $("#TASOTY").val());

		}
		return param;
	}// end comboEventDataBindeBefore()
	
	
	function saveData(){

		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//체크한 row중에 수정된 로우
			var item = gridList.getSelectData("gridItemList", true);
			if(head.length == 0 && item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//item 저장불가 조건 체크
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if((Number)(itemMap.QTTAOR) <= 0){
					commonUtil.msgBox("작업 수량은 0의 값보다 더 작거나 같을 수 없습니다.");
					return;
				}
				
				if(itemMap.LOCATG == " " || itemMap.LOCATG == ""){
					commonUtil.msgBox("To 로케이션을 입력해주세요.");
					return;
				}
				
				if(Number(itemMap["QTTAOR"]) > Number(itemMap["AVAILABLEQTY"])){
					gridList.setColFocus("gridItemList", i, "QTTAOR");
					alert("\작업 수량이 가용수량보다 많습니다.");
					return;
				}
			}

			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			param.put("INDDCL", "V");
			param.put("CREUSR", "<%=userid%>");
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {	// 저장하시겠습니까?
				return;	
			}
			
			netUtil.send({
				url : "/taskOrder/json/saveMV01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}// end saveData()
	
	
	// 재고이동(TASDH,TASDI,TASDR) Insert 로직 TASDH
	function saveTaskData(){
		var param = new DataMap();
		
		var head = gridList.getSelectData("gridHeadList", true);
		var item = gridList.getSelectData("gridItemList", true);

		param.put("head",head);
		param.put("item",item);
		param.put("CREUSR", "<%=userid%>");
		
		
		netUtil.send({
			url : "/taskOrder/json/saveTaskMV01.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}// end saveTaskData()
	
	
	// 저장 후 타는 함수
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "moving_Sucess"){ //saveData() 성공 시 // 재고이동(TASDH,TASDI,TASDR) Insert 로직태움
				saveTaskData();
				
			}else if(json.data["RESULT"] == "S"){		// 저장 성공 시
				commonUtil.msgBox("SYSTEM_SAVEOK");
				uiList.setActive("Save",false);
				reSearchList(json);						
				
			}else if(json.data["RESULT"] == "F"){		
				commonUtil.msgBox("위탁물류는 하실 수 없습니다.");
				
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				
			}else{
				if(json.data.RESULT.length < 1){
					commonUtil.msgBox("EXECUTE_ERROR");
					return;
				}
				
				var msgText = "중복 로케이션 : ";
				// 중복 로케이션이 있을 경우
				for(var i=0; i<json.data.RESULT.length; i++){
					msgText += json.data.RESULT[i].LOCATG + ", ";
				}
				msgText += "\r계속 진행하시겠습니까?";
				
				if(!commonUtil.msgConfirm(msgText)){ // 중복로케이션 진행여부 
					return;
		        }
				
				saveTaskData();
			}
		}
	}// end successSaveCallBack
	
	
	function setChk(){
		
		var rsncod = $("#RSNCODCOMBO").val();	//인풋값 가져오기
		var selectDataList = gridList.getSelectData("gridItemList", true);	// 그리드에서 선택 된 값 가져오기

		if(rsncod == ""){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}

		for(var i=0; i<selectDataList.length; i++){
			gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "RSNCOD", rsncod);	// 그리드 사유코드 값 셋팅
		}
	}
	
	//체크박스 이벤트 후 
	function gridListEventRowCheck(gridId, rowNum, isCheck){	
		if(gridId == "gridItemList"){
			calTotal();	
		}
	}
	
	//작업수량계산 계산
	function calTotal(){
		var item = gridList.getSelectData("gridItemList", true);
		
		var qttaor = 0;
		var pltqty = 0.0;
		var boxqty = 0;
		
		for(var i = 0; i<item.length; i++){
			var itemMap = item[i].map;
			
			qttaor += (Number)(itemMap.QTTAOR);
			pltqty += floatingFloor((Number)(itemMap.PLTQTY),2);
			boxqty += (Number)(itemMap.BOXQTY);
		}
		$("#QTTAOR").val(qttaor);	//	작업수량합계 계산
		$("#PLTQTY").val(pltqty);	//	팔레트수량합계 계산
		$("#BOXQTY").val(boxqty);	//	박스수량합계 계산
	}
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			 if(colName == "QTTAOR" || colName == "BOXQTY" || colName == "REMQTY" || colName == "PLTQTY"){ 
			 	var qttaor = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var bxiqty = gridList.getColData(gridId, rowNum, "BXIQTY"); 
				var qtduom = gridList.getColData(gridId, rowNum, "QTDUOM");
				var pliqty = gridList.getColData(gridId, rowNum, "PLIQTY");
				var availableqty = gridList.getColData(gridId, rowNum, "AVAILABLEQTY");
				var remqtyChk = 0;
				
				// 그리드에서 선택 된 값 가져오기
				var selectDataList = gridList.getSelectData("gridItemList", true);

				if( colName == "QTTAOR" ) {
					qttaor = colValue;
					
					boxqty = floatingFloor((Number)(qttaor) / (Number)(bxiqty),1);
				  	remqty = floatingFloor((Number)(qttaor) % (Number)(bxiqty),1);
				  	pltqty = floatingFloor((Number)(qttaor) / (Number)(pliqty),2);
				  	
/* 					boxqty = Math.floor((Number)(qttaor)/ (Number)(bxiqty),1);
				  	remqty = Math.floor((Number)(qttaor)%(Number)(bxiqty),0);
				  	pltqty = Math.floor((Number)(qttaor)/(Number)(pliqty),2); */
				  	
				  	// 작업수량이 가용수량보다 많으면 불가
				  	if(Number(qttaor)> Number(availableqty) ){
				  		commonUtil.msgBox("작업 수량이 가용수량보다 많습니다.");
				  		gridList.setColValue(gridId, rowNum,"QTTAOR", 0);
				  		return;
				  	}
				  	
					
				  	gridList.setColValue("gridItemList", rowNum, "PLTQTY", pltqty);	
				  	gridList.setColValue("gridItemList", rowNum, "BOXQTY", boxqty);	
				  	gridList.setColValue("gridItemList", rowNum, "REMQTY", remqty);	
				}
				if( colName == "PLTQTY" ){
					pltqty = colValue;
/* 				  	qttaor = Math.floor((Number)(pltqty) * (Number)(pliqty),0);
				  	boxqty = Math.floor((Number)(pltqty) * (Number)(pliqty) /(Number)(bxiqty),1); */
				  	
				  	qttaor = floatingFloor((Number)(pltqty) * (Number)(pliqty));
				  	boxqty = floatingFloor((Number)(pltqty) * (Number)(pliqty) /(Number)(bxiqty), 1);
				  	gridList.setColValue("gridItemList", rowNum, "QTTAOR", qttaor);	
				  	gridList.setColValue("gridItemList", rowNum, "BOXQTY", boxqty);	
				  	gridList.setColValue("gridItemList", rowNum, "REMQTY", remqty);
				}
				if( colName == "BOXQTY" ){ 
				  	boxqty = colValue;
/* 				  	qttaor = Math.floor((Number)(boxqty) * (Number)(bxiqty),0);
				  	pltqty = Math.floor((Number)(qttaor) / (Number)(pliqty),2); */
				  	
				  	qttaor = floatingFloor((Number)(boxqty) * (Number)(bxiqty));
				  	pltqty = floatingFloor((Number)(qttaor) / (Number)(pliqty), 2);
				  	gridList.setColValue("gridItemList", rowNum, "QTTAOR", qttaor);	
				  	gridList.setColValue("gridItemList", rowNum, "PLTQTY", pltqty);	
				  	gridList.setColValue("gridItemList", rowNum, "REMQTY", 0);
				  }
/* 				var qttaorSum = 0;
				var pltqtySum = 0;
				var boxqtySum = 0; */
				
				calTotal();
			 }
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHLOCMA"){
            param.put("WAREKY",$("#WAREKY").val());
            param.put("OWNRKY",$("#OWNRKY").val());
             
        }else if(searchCode == "SHCMCDV"){
        	var name = $inputObj.name;
        	name = name.substring(2,name.length); // S. <-- 얼라이어스 제거
			param.put("CMCDKY",name);

		}
        
    	return param;
    }
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "SetChk"){
			setChk();
		}else if(btnName == "Print1"){
			 printEZGenDR16("/ezgen/move_list.ezg");
		}else if(btnName == "Print2"){
			 printEZGenDR16("/ezgen/move_list_22.ezg");
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "MV01");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "MV01");
		}
	}// end commonBtnClick()
	
	function printEZGenDR16(url){
	    	
	    	//for문을 돌며 TEXT03 KEY를 꺼낸다.
			var headList = gridList.getSelectData("gridHeadList");
	    	
			if(headList.length < 1){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
		
			var wherestr = ""; 
			var count = 0;
			var taskky;
			for(var i=0; i<headList.length; i++){
				taskky = gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "TASKKY");
				
				if(taskky == "" || taskky == " "){
					commonUtil.msgBox("재고 이동 지시서 생성후에 출력 가능합니다.");
					return;
				}
				
				if(wherestr == ""){
					wherestr = " AND H.TASKKY IN ("; 
				}else{
					wherestr += ",";
				}
				wherestr += "'"+taskky+"'";
			}
			wherestr+=") ";

			//이지젠 호출부(신버전)
			var width = 600;
			var heigth = 920;
			var map = new DataMap();
			map.put("i_option", '\'<%=wareky %>\'');
			WriteEZgenElement(url , wherestr , "" , "KO", map , width , heigth ); // 구버전 ezgenPrint와 같다

	}// end printEZGenDR16(url){
	
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
					<input type="button" CB="Print1 PRINT BTN_PRINT17" />
					<input type="button" CB="Print2 PRINT BTN_PRINT28" />
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
							<select name="WAREKY" id="WAREKY" class="input" validate="required"></select>
						</dd>
					</dl>
					
					<dl>  <!--작업타입-->  
						<dt CL="STD_TASOTY"></dt> 
						<dd> 
							<select name="TASOTY" id="TASOTY" class="input" Combo="SajoCommon,DOCTM_COMCOMBO"></select> 
						</dd> 
					</dl> 
					
					<!-- 재고유형 -->
					<dl>
						<dt CL="STD_LOTA06"></dt>
						<dd>
							<input type="text" class="input" name="LOTA06" UIInput="SR,SHLOTA06" />
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
					
					<dl>  <!--대분류-->  
						<dt CL="STD_SKUG01"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUG01" UIInput="SR,SHCMCDV"/> 
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
					
					<!-- 유통기한 -->
					<dl>
						<dt CL="STD_LOTA13"></dt>
						<dd>
							<input type="text" class="input" name="LOTA13" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					
					<!-- 입고일자 -->
					<dl>
						<dt CL="STD_LOTA12"></dt>
						<dd>
							<input type="text" class="input" name="LOTA12" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					
					<!-- 벤더 -->
					<dl>
						<dt CL="STD_LOTA03"></dt>
						<dd>
							<input type="text" class="input" name="LOTA03" UIInput="SR,SHLOTA03CM" />
						</dd>
					</dl>
					
					<!-- 포장구분 -->
					<dl>
						<dt CL="STD_LOTA05"></dt>
						<dd>
							<input type="text" class="input" name="LOTA05" UIInput="SR,SHLOTA05" />
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
								        <td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="S 20">작업지시번호</td> <!--작업지시번호-->
								        <td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
								        <td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td> <!--거점명-->
								        <td GH="80 STD_TASOTY" GCol="text,TASOTY" GF="N 4,0">작업타입</td> <!--작업타입-->
								        <td GH="80 STD_TASOTYNM" GCol="text,TASOTYNM" GF="S 100">작업타입명</td> <!--작업타입명-->
								        <td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td> <!--문서일자-->
								        <td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0">문서유형</td> <!--문서유형-->
								        <td GH="200 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td> <!--문서유형명-->
								        <td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td> <!--문서상태-->
								        <td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 100">문서상태명</td> <!--문서상태명-->
								        <td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td> <!--작업수량-->
								        <td GH="80 STD_QTCOMP" GCol="text,QTCOMP" GF="N 20,0">완료수량</td> <!--완료수량-->
								        <td GH="50 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td> <!--비고-->
								        <td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td> <!--생성일자-->
								        <td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td> <!--생성시간-->
								        <td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td> <!--생성자-->
								        <td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td> <!--생성자명-->
								        <td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 60">수정일자</td> <!--수정일자-->
								        <td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60">수정시간</td> <!--수정시간-->
								        <td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td> <!--수정자-->
								        <td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60">수정자명</td> <!--수정자명-->
									</tr>
								</tbody>
							</table>
						</div> 
					</div>
					<div class="btn_lit tableUtil">
					    <button type="button" GBtn="find"></button>      
					    <button type="button" GBtn="sortReset"></button> 
					    <button type="button" GBtn="layout"></button>    
					    <button type="button" GBtn="total"></button>     
					    <button type="button" GBtn="excel"></button>  
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
					<!-- 사유코드 -->
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
						<span CL="STD_RSNADJ" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<select name="RSNCODCOMBO" id="RSNCODCOMBO"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true"><option></option></select>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
						<input type="button" CB="SetChk SAVE BTN_PART" />
					</li>
					<li style="font-size: 16px;">
						≫ 작업수량합계 : 
						&nbsp;<input type="text" id="QTTAOR" value="0">
					</li>
					<li style="font-size: 16px;">
						≫ 팔레트수량합계 : 
						&nbsp;<input type="text" id="PLTQTY" value="0.0">
					</li>
					<li style="font-size: 16px;">
						≫ 박스수량합계 : 
						&nbsp;<input type="text" id="BOXQTY" value="0">
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true"> 
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="40" GCol="rowCheck"></td>
										<td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td> <!--동-->
										<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="160 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td> <!--제품명-->
										<td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3">단위</td> <!--단위-->
										<td GH="70 STD_QTSAVLB" GCol="text,AVAILABLEQTY" GF="N 20,0">가용수량</td> <!--가용수량-->
										<td GH="88 STD_QTTAOR" GCol="input,QTTAOR" GF="N 20,0">작업수량</td> <!--작업수량-->
										<td GH="100 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td> <!--팔렛당수량-->
										<td GH="100 STD_PLTQTY" GCol="input,PLTQTY" GF="N 17,2">팔레트수량</td> <!--팔레트수량-->
										<td GH="70 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="90 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
								        <td GH="70 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
										<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td> <!--로케이션-->
										<td GH="80 STD_LOCATG" GCol="input,LOCATG,SHLOCMA" GF="U 20" validate="required">To 로케이션</td> <!--To 로케이션-->
										<td GH="50 STD_TRNUSR" GCol="text,TRNUSR" GF="S 20">팔렛트ID</td> <!--팔렛트ID-->
										<td GH="50 STD_TRNUTG" GCol="input,TRNUTG" GF="S 20">To 팔렛트ID</td> <!--To 팔렛트ID-->
										<td GH="120 STD_RSNCOD" GCol="select,RSNCOD" >
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">	<!--사유코드-->
												<option></option>
											</select>
										</td> 
										<td GH="200 STD_TASRSN" GCol="input,TASRSN" GF="S 127">상세사유</td> <!--상세사유-->
										<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td> <!--제조일자-->
										<td GH="80 STD_PTLT11" GCol="input,PTLT11" GF="C 14">To제조일자</td> <!--To제조일자-->
										<td GH="40 STD_CONFIRM" GCol="text,CONFIRM" GF="S 1">확인</td> <!--확인-->
								        <td GH="100 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td> <!--재고키-->
								        <td GH="60 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td> <!--작업타입-->
								        <td GH="70 STD_PLBQTY" GCol="text,PLBQTY" GF="S 17" style="text-align:right;" >팔렛당박스수량</td> <!--팔렛당박스수량-->
								        <td GH="80 STD_DTREMDAT" GCol="input,DTREMDAT" GF="N 17,0">유통잔여(DAY)</td> <!--유통잔여(DAY)-->
								        <td GH="80 STD_DTREMRAT" GCol="input,DTREMRAT" GF="N 17">유통잔여(%)</td> <!--유통잔여(%)-->
								        <td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
								        <td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10">단위구성</td> <!--단위구성-->
								        <td GH="88 STD_QTSPUM" GCol="text,QTSPUM" GF="S 11">UPM</td> <!--UPM-->
								        <td GH="50 STD_SDUOKY" GCol="text,SDUOKY" GF="S 3">기본단위</td> <!--기본단위-->
								        <td GH="88 STD_QTSDUM" GCol="text,QTSDUM" GF="S 11">기본UPM</td> <!--기본UPM-->
								        <td GH="80 STD_AREATG" GCol="text,AREATG" GF="S 10">To 동</td> <!--To 동-->
								        <td GH="120 STD_ASKU02" GCol="select,ASKU02">				  <!--세트여부-->
								        	<select class="input" CommonCombo="ASKU02"></select>
								        </td> 
								        <td GH="120 STD_SKUG01" GCol="select,SKUG01" >				  <!--대분류-->
								        	<select class="input" CommonCombo="SKUG01"></select>
								        </td> 
								        <td GH="120 STD_SKUG05" GCol="select,SKUG05">				  <!--제품용도-->
										    <select class="input" CommonCombo="SKUG05"></select>
								        </td> 
								        <td GH="88 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11">포장중량</td> <!--포장중량-->
								        <td GH="88 STD_NETWGT" GCol="text,NETWGT" GF="S 11">순중량</td> <!--순중량-->
								        <td GH="88 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td> <!--중량단위-->
								        <td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="S 11">포장가로</td> <!--포장가로-->
								        <td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="S 11">포장세로</td> <!--포장세로-->
								        <td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="S 11">포장높이</td> <!--포장높이-->
								        <td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="S 11">CBM</td> <!--CBM-->
								        <td GH="88 STD_CAPACT" GCol="text,CAPACT" GF="S 11">CAPA</td> <!--CAPA-->
								        <td GH="50 STD_LOTA01" GCol="text,LOTA01" GF="S 20">LOTA01</td> <!--LOTA01-->
								        <td GH="120 STD_LOTA02" GCol="select,LOTA02">
								        	<select class="input" CommonCombo="LOTA02"></select>	<!--BATCH NO-->
								        </td> 
								        <td GH="50 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td> <!--벤더-->
								        <td GH="50 STD_LOTA04" GCol="text,LOTA04" GF="S 10">LOTA04</td> <!--LOTA04-->
								        <td GH="120 STD_LOTA05" GCol="select,LOTA05" >   				<!--포장구분-->
								        	<select class="input" CommonCombo="LOTA05"></select>
								        </td> 
								        <td GH="120 STD_PTLT05" GCol="select,PTLT05">				<!--To포장구분-->
											<select class="input" CommonCombo="LOTA05"></select>
										</td> 
								        <td GH="120 STD_LOTA06" GCol="select,LOTA06">			<!--재고유형-->
								        	<select class="input" CommonCombo="LOTA06"></select>	
								        </td> 
								        <td GH="120 STD_PTLT06" GCol="select,PTLT06">	<!--To 재고유형-->
								        	<select class="input" CommonCombo="LOTA06"></select>
								        </td> 
								        <td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td> <!--입고일자-->
								        <td GH="80 STD_PTLT12" GCol="input,PTLT12" GF="C 14">To입고일자</td> <!--To입고일자-->
								        <td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td> <!--유통기한-->
								        <td GH="80 STD_PTLT13" GCol="input,PTLT13" GF="D 14">To 유통기한</td> <!--To 유통기한-->
								        <td GH="50 STD_LOTA07" GCol="text,LOTA07" GF="S 20">위탁구분</td> <!--위탁구분-->
								        <td GH="50 STD_LOTA08" GCol="text,LOTA08" GF="S 20">LOTA08</td> <!--LOTA08-->
								        <td GH="50 STD_LOTA09" GCol="text,LOTA09" GF="S 20">LOTA09</td> <!--LOTA09-->
								        <td GH="50 STD_LOTA10" GCol="text,LOTA10" GF="S 20">LOTA10</td> <!--LOTA10-->
								        <td GH="50 STD_LOTA14" GCol="text,LOTA14" GF="D 14">LOTA14</td> <!--LOTA14-->
								        <td GH="50 STD_LOTA15" GCol="text,LOTA15" GF="D 14">LOTA15</td> <!--LOTA15-->
								        <td GH="50 STD_LOTA16" GCol="text,LOTA16" GF="S 11">LOTA16</td> <!--LOTA16-->
								        <td GH="50 STD_LOTA17" GCol="text,LOTA17" GF="S 11">LOTA17</td> <!--LOTA17-->
								        <td GH="50 STD_LOTA18" GCol="text,LOTA18" GF="S 11">LOTA18</td> <!--LOTA18-->
								        <td GH="50 STD_LOTA19" GCol="text,LOTA19" GF="S 11">LOTA19</td> <!--LOTA19-->
								        <td GH="50 STD_LOTA20" GCol="text,LOTA20" GF="S 11">LOTA20</td> <!--LOTA20-->
								        <td GH="50 STD_PTLT01" GCol="input,PTLT01" GF="S 20">To LOT01</td> <!--To LOT01-->
								        <td GH="90 STD_PTLT02" GCol="input,PTLT02" GF="S 20">To LOT02</td> <!--To LOT02-->
								        <td GH="50 STD_PTLT03" GCol="input,PTLT03" GF="S 20">To벤더</td> <!--To벤더-->
								        <td GH="50 STD_PTLT04" GCol="input,PTLT04" GF="S 10">To LOT04</td> <!--To LOT04-->
								        <td GH="50 STD_PTLT07" GCol="input,PTLT07" GF="S 20">To LOT07</td> <!--To LOT07-->
								        <td GH="50 STD_PTLT08" GCol="input,PTLT08" GF="S 20">To LOT08</td> <!--To LOT08-->
								        <td GH="50 STD_PTLT09" GCol="input,PTLT09" GF="S 20">To LOT09</td> <!--To LOT09-->
								        <td GH="50 STD_PTLT10" GCol="input,PTLT10" GF="S 20">To LOT10</td> <!--To LOT10-->
								        <td GH="50 STD_PTLT14" GCol="input,PTLT14" GF="D 14">To LOT14</td> <!--To LOT14-->
							    	    <td GH="50 STD_PTLT15" GCol="input,PTLT15" GF="D 14">To LOT15</td> <!--To LOT15-->
							            <td GH="50 STD_PTLT16" GCol="input,PTLT16" GF="S 11">To LOT16</td> <!--To LOT16-->
								        <td GH="50 STD_PTLT17" GCol="input,PTLT17" GF="S 11">To LOT17</td> <!--To LOT17-->
								        <td GH="50 STD_PTLT18" GCol="input,PTLT18" GF="S 11">To LOT18</td> <!--To LOT18-->
								        <td GH="50 STD_PTLT19" GCol="input,PTLT19" GF="S 11">To LOT19</td> <!--To LOT19-->
								        <td GH="50 STD_PTLT20" GCol="input,PTLT20" GF="S 11">To LOT20</td> <!--To LOT20-->
								        <td GH="160 STD_SBKTXT" GCol="input,SBKTXT" GF="S 75">비고</td> <!--비고-->
								        <td GH="80 STD_PACK" GCol="text,PACK" GF="S 20"></td> <!---->
									</tr>
								</tbody> 
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type="button" GBtn="find"></button>      
					    <button type="button" GBtn="sortReset"></button> 
					    <button type="button" GBtn="layout"></button>    
					    <button type="button" GBtn="total"></button>     
					    <button type="button" GBtn="excel"></button>
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