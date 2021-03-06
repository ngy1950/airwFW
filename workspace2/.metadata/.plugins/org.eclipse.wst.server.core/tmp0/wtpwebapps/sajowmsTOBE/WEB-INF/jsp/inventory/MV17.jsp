<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>MV17</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "taskOrder",
	    	pkcol : "OWNRKY, SKUKEY",
			command : "MV17_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "MV17"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "taskOrder",
			command : "MV17_ITEM",
		    menuId : "MV17"
	    });
		
		gridList.setReadOnly("gridItemList", true, ["LOTA05", "LOTA06", "ASKU02", "SKUG01", "SKUG05", "LOTA02"]);
		
		
 		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "RCVFAC");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);
		
		setSingleRangeData('S.LOCAKY', rangeArr); 
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});
	
	
	function Create(){
		if ($("#OWNRKY").val() == '2500'){
			if(validate.check("searchArea")){
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				uiList.setActive("Save",true);
				
				var param = inputList.setRangeDataParam("searchArea");
				reparam = new DataMap();			
				
				param.put("CREUSR", "<%=userid%>");
				param.put("WARETG",$("#WAREKY").val());
				param.put("DOCCAT","300");
				param.put("STATDO","NEW");
				param.put("TASOTY",$("#TASOTY").val()); // 작업타입
				
	 			gridList.gridList({
			    	id : "gridHeadList",
			    	param : param
			    });
			}
		}else {
			commonUtil.msgBox("* 화주 2500에서 검색 가능합니다. *");
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
 		if(!reparam.isEmpty()){ // [저장 시 저장 된 데이터를 보여주기 위해 분기 태움]
			var param = gridList.getRowData(gridId, rowNum);
			param.put("OWNRKY",$('#OWNRKY').val());
			
			gridList.gridList({
		    	id : "gridItemList",
		    	module : "taskOrder",
				command : "MV17_REITEM",
		    	param : reparam
		    });
		}else{  
			var param = inputList.setRangeDataParam("searchArea");
			
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	// 저장 성공 시 재조회 쿼리
	function reSearchList(json){
		if(validate.check("searchArea")){
			reparam = inputList.setRangeDataParam("searchArea");
			reparam.put("TASKKY",json.data["TASKKY"]);
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : reparam,
		    	command : "MV17_REHEAD"
		    });
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
// 		}else if(gridId == "gridItemList" && dataCount == 0){
// 			gridList.resetGrid("gridHeadList");
		}
	}
	
 	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if( comboAtt == "SajoCommon,DOCUTY_COMCOMBO" ){
			param.put("DOCCAT", "300");
	        param.put("DOCUTY", "320");
		}
		return param;
	} 

 	
 	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			sLocasr = "";
			sLota06 = "";
			var head = gridList.getGridData("gridHeadList");
			
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//체크한 row중에 수정된 로우
			var item = gridList.getSelectData("gridItemList");
			if(head.length == 0 && item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}	
			
			//item 저장불가 조건 체크
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if(sLocasr != "" && sLocasr != itemMap["LOCASR"]){
					commonUtil.msgBox("재고병합은 하나의 로케이션에서만 가능합니다. 동일 로케이션을 선택하세요.");
					return;
				}
				sLocasr = itemMap["LOCASR"];
				
				if(sLota06 != "" && sLota06 != itemMap["LOTA06"]){
					alert("재고병합은 하나의 재고유형만 가능합니다. 동일 재고유형을 선택하세요.");
					return;
				}
				sLota06 = itemMap["LOTA06"];

			}// end for

			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			param.put("CREUSR", "<%=userid%>");
			
	    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }

			netUtil.send({
				url : "/taskOrder/json/saveMV17.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}	
	//재고이동 Insert 로직
	function saveTaskData(){
		var param = inputList.setRangeDataParam("searchArea");
		
		var head = gridList.getGridData("gridHeadList");
		var item = gridList.getSelectData("gridItemList");

		param.put("head",head);
		param.put("item",item)
		param.put("CREUSR", "<%=userid%>");

		 netUtil.send({
			url : "/taskOrder/json/saveTaskMV17.data",
			param : param,
			successFunction : "successSaveCallBack"
		}); 
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "moving_Sucess"){ //saveData() 성공 시 // 재고이동(TASDH,TASDI,TASDR) Insert 로직태움
				saveTaskData();
				
			}else if(json.data["RESULT"] == "S"){		// 저장 성공 시
				commonUtil.msgBox("SYSTEM_SAVEOK");	
				uiList.setActive("Save",false);
				reSearchList(json);						
				
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
	}
	
	function reloadLabel() {
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}
	
	function commonBtnClick(btnName) {
		if (btnName == "Create") {
			Create();
		} else if (btnName == "Save") {
			saveData();
		} else if (btnName == "Reload") {
			reloadLabel();
		} else if (btnName == "Apply") {
			Apply();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "MV17");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "MV17");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	function Apply(){

   		//수정불가조건 체크 를 위해 체크박스 체크한 리스트만 들고온다.
		var itemList = gridList.getSelectData("gridItemList");
   		
		for(var i=0; i<itemList.length; i++){

			gridList.setColValue("gridItemList", itemList[i].get("GRowNum"), "LOCATG", $("#ALLLOCATG").val());
			//사유코드 gridChange이벤트를 강제발생시킨다.
			gridListEventColValueChange("gridItemList", itemList[i].get("GRowNum"), "LOCATG", $("#ALLLOCATG").val());

		}
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
				var remqtyChk = 0;
				
				// 그리드에서 선택 된 값 가져오기
				var selectDataList = gridList.getSelectData("gridItemList", true);

				if( colName == "QTTAOR" ) {
					qttaor = colValue;
				  	
					boxqty = floatingFloor((Number)(qttaor)/ (Number)(bxiqty),1);
				  	remqty = floatingFloor((Number)(qttaor)%(Number)(bxiqty),0);
				  	pltqty = floatingFloor((Number)(qttaor)/(Number)(pliqty),2);
				  	gridList.setColValue("gridItemList", rowNum, "PLTQTY", pltqty);	
				  	gridList.setColValue("gridItemList", rowNum, "BOXQTY", boxqty);	
				  	gridList.setColValue("gridItemList", rowNum, "REMQTY", remqty);	
				}		
				if( colName == "PLTQTY" ){
					pltqty = colValue;
				  	
				  	qttaor = floatingFloor((Number)(pltqty) * (Number)(pliqty),0);
				  	boxqty = floatingFloor((Number)(pltqty) * (Number)(pliqty) /(Number)(bxiqty),1);
				  	gridList.setColValue("gridItemList", rowNum, "QTTAOR", qttaor);	
				  	gridList.setColValue("gridItemList", rowNum, "BOXQTY", boxqty);	
				  	gridList.setColValue("gridItemList", rowNum, "REMQTY", remqty);
				}
				if( colName == "BOXQTY" ){ 
				  	boxqty = colValue;
			  	
				  	qttaor = floatingFloor((Number)(boxqty) * (Number)(bxiqty),0);
				  	pltqty = floatingFloor((Number)(qttaor) / (Number)(pliqty),2);
				  	gridList.setColValue("gridItemList", rowNum, "QTTAOR", qttaor);	
				  	gridList.setColValue("gridItemList", rowNum, "PLTQTY", pltqty);	
				  	gridList.setColValue("gridItemList", rowNum, "REMQTY", 0);
				  }
				var qttaorSum = 0;
				var pltqtySum = 0;
				var boxqtySum = 0;
			 }
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();
	      
	    //로케이션
	    if(searchCode == "SHLOCMA" && $inputObj.name == "S.LOCAKY"){
		    param.put("WAREKY",$("#WAREKY").val());
		  //배열선언
    		var rangeArr = new Array();
    		//배열내 들어갈 데이터 맵 선언
    		var rangeDataMap = new DataMap();
    		// 필수값 입력
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SYS");
    		//배열에 맵 탑제 
    		rangeArr.push(rangeDataMap);
    	 	
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SHP");
    		rangeArr.push(rangeDataMap); 

            param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
         //로케이션 그리드
	    }else if(searchCode == "SHLOCMA"){
    		param.put("WAREKY",$("#WAREKY").val());
        //대분류
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG01"){
	        param.put("CMCDKY","SKUG01");
	    //세트여부
		} else if(searchCode == "SHCMCDV" && $inputObj.name == "S.ASKU02"){
	        param.put("CMCDKY","ASKU02");
	    //제품용도
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG05"){
	        param.put("CMCDKY","SKUG05"); 
	    //벤더
		}else if(searchCode == "SHLOTA03CM"){
	        param.put("PTNRTY","0001"); 
	    } return param;
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
					<input type="button" CB="Create ADD BTN_CREATE" />
					<input type="button" CB="Save SAVE BTN_SAVE" /> 
					<!-- <input type="button" CB="Reload RESET STD_REFLBL" /> -->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
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
					<dl>
						<dt CL="STD_TASOTY"></dt> <!-- 작업타입 -->
						<dd>
							<select name="TASOTY" id="TASOTY" class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_AREAKY"></dt> <!-- 동 -->
						<dd>
							<input type="text" class="input" name="S.AREAKY" UIInput="SR,SHAREMA" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ZONEKY"></dt> <!-- 존 -->
						<dd>
							<input type="text" class="input" name="S.ZONEKY" UIInput="SR,SHZONMA" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOCAKY"></dt> <!-- 로케이션 -->
						<dd>
							<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt> <!-- 제품코드 -->
						<dd>
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DESC01"></dt> <!-- 제품명 -->
						<dd>
							<input type="text" class="input" name="S.DESC01" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUG01"></dt> <!-- 대분류 -->
						<dd>
							<input type="text" class="input" name="S.SKUG01" UIInput="SR,SHCMCDV" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ASKU02"></dt> <!-- 세트여부 -->
						<dd>
							<input type="text" class="input" name="S.ASKU02" UIInput="SR,SHCMCDV" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUG05"></dt> <!-- 제품용도 -->
						<dd>
							<input type="text" class="input" name="S.SKUG05" UIInput="SR,SHCMCDV" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA13"></dt> <!-- 유통기한 -->
						<dd>
							<input type="text" class="input" name="LOTA13" UIInput="B" UIFormat="C"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA12"></dt> <!-- 입고일자 -->
						<dd>
							<input type="text" class="input" name="LOTA12" UIInput="B" UIFormat="C"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA03"></dt> <!-- 벤더 -->
						<dd>
							<input type="text" class="input" name="LOTA03" UIInput="SR,SHLOTA03CM" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA05"></dt> <!-- 포장구분 -->
						<dd>
							<input type="text" class="input" name="LOTA05" UIInput="SR,SHLOTA05" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA06"></dt> <!-- 재고유형 -->
						<dd>
							<input type="text" class="input" name="LOTA06" UIInput="SR,SHLOTA06" />
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
			    						<td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="S 10"></td>	       <!-- 작업지시번호 -->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10"></td>	       <!-- 거점 -->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100"></td>	   <!-- 거점명 -->
			    						<td GH="80 STD_TASOTY" GCol="text,TASOTY" GF="N 4,0"></td>	       <!-- 작업타입 -->
			    						<td GH="80 STD_TASOTYNM" GCol="text,TASOTYNM" GF="S 100"></td>	   <!-- 작업타입명 -->
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8"></td>	       <!-- 문서일자 -->
			    						<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0"></td>         <!-- 문서유형 -->
			    						<td GH="200 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100"></td>	   <!-- 문서유형명 -->
			    						<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4"></td>	       <!-- 문서상태 -->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 100"></td>	   <!-- 문서상태명 -->
			    						<td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0"></td>	       <!-- 작업수량 -->
			    						<td GH="80 STD_QTCOMP" GCol="text,QTCOMP" GF="N 20,0"></td>	       <!-- 완료수량 -->
			    						<td GH="50 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100"></td>	       <!-- 비고 -->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8"></td>	       <!-- 생성일자 -->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 8"></td>	       <!-- 생성시간 -->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 60"></td>	       <!-- 생성자 -->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60"></td>	       <!-- 생성자명 -->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 60"></td>	       <!-- 수정일자 -->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60"></td>	       <!-- 수정시간 -->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60"></td>	       <!-- 수정자 -->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60"></td>	       <!-- 수정자명 -->
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
			<div class="content_layout tabs bottom_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX"> <!-- 로케이션 -->
						<span CL="STD_LOCAKY" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<input type="text" class="input" id="ALLLOCATG" name="ALLLOCATG"  UIInput="SR,SHLOCMA"/>
						<input type="button" CB="Apply APPLY BTN_REFLECT" />
					</li>
<!--                		<li style="TOP: 4PX;VERTICAL-ALIGN: middle;"> 저장
						<input type="button" CB="Save SAVE BTN_SAVE" />
					</li> -->
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
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="80 STD_STOKKY" GCol="text,STOKKY" GF="S 10"></td>	         <!-- 재고키 -->
			    						<td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10"></td>	         <!-- 동 -->
			    						<td GH="80 STD_LOCATG" GCol="input,LOCATG,SHLOCMA" GF="U 20"></td>	 <!-- To 로케이션 -->
			    						<td GH="50 STD_QTSAVLB" GCol="text,AVAILABLEQTY" GF="N 20,0"></td>	 <!-- 가용수량 -->
			    						<td GH="50 STD_TASKTY" GCol="text,TASKTY" GF="S 3"></td>	         <!-- 작업타입 -->
			    						<td GH="150 STD_TASRSN" GCol="text,TASRSN" GF="S 127"></td>	         <!-- 상세사유 -->
			    						<td GH="50 STD_QTTAOR" GCol="input,QTTAOR" GF="N 20,0"></td>	     <!-- 작업수량 -->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10"></td>	         <!-- 화주 -->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20"></td>	         <!-- 제품코드 -->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60"></td>	         <!-- 제품명 -->
			    						<td GH="120 STD_LOTA05" GCol="select,LOTA05" >   				<!--포장구분-->
								        	<select class="input" CommonCombo="LOTA05"></select>
								        </td> 
			    						<td GH="120 STD_LOTA06" GCol="select,LOTA06">			<!--재고유형-->
								        	<select class="input" CommonCombo="LOTA06"></select>	
								        </td>
			    						<td GH="80 STD_LOCASR" GCol="text,LOCASR" GF="S 20"></td>	         <!-- 로케이션 -->
			    						<td GH="50 STD_TRNUSR" GCol="text,TRNUSR" GF="S 20"></td>	         <!-- 팔렛트ID -->
			    						<td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10"></td>	         <!-- 단위구성 -->
			    						<td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3"></td>	         <!-- 단위 -->
			    						<td GH="60 STD_QTSPUM" GCol="text,QTSPUM" GF="S 11"></td>	         <!-- UPM -->
			    						<td GH="50 STD_SDUOKY" GCol="text,SDUOKY" GF="S 3"></td>	         <!-- 기본단위 -->
			    						<td GH="60 STD_QTSDUM" GCol="text,QTSDUM" GF="S 11"></td>	         <!-- 기본UPM -->
			    						<td GH="80 STD_AREATG" GCol="text,AREATG" GF="S 10"></td>	         <!-- To 동 -->
			    						<td GH="80 STD_TRNUTG" GCol="input,TRNUTG" GF="S 20"></td>	         <!-- To 팔렛트ID -->
			    						<td GH="120 STD_ASKU02" GCol="select,ASKU02">				  <!--세트여부-->
								        	<select class="input" CommonCombo="ASKU02"></select>
								        </td> 
								        <td GH="120 STD_SKUG01" GCol="select,SKUG01" >				  <!--대분류-->
								        	<select class="input" CommonCombo="SKUG01"></select>
								        </td> 
								        <td GH="120 STD_SKUG05" GCol="select,SKUG05">				  <!--제품용도-->
										    <select class="input" CommonCombo="SKUG05"></select>
								        </td> 
			    						<td GH="88 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11"></td>	         <!-- 포장중량 -->
			    						<td GH="88 STD_NETWGT" GCol="text,NETWGT" GF="S 11"></td>	         <!-- 순중량 -->
			    						<td GH="88 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3"></td>	         <!-- 중량단위 -->
			    						<td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="S 11"></td>	         <!-- 포장가로 -->
			    						<td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="S 11"></td>	         <!-- 가로길이 -->
			    						<td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="S 11"></td>	         <!-- 포장높이 -->
			    						<td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="S 11"></td>	         <!-- CBM -->
			    						<td GH="88 STD_CAPACT" GCol="text,CAPACT" GF="S 11"></td>	         <!-- CAPA -->
			    						<td GH="88 STD_LOTA01" GCol="text,LOTA01" GF="S 20"></td>	         <!-- LOTA01 -->
			    						<td GH="120 STD_LOTA02" GCol="select,LOTA02">	         <!-- BATCH NO -->
			    							<select class="input" CommonCombo="LOTA02"></select>
			    						</td>
			    						<td GH="50 STD_LOTA03" GCol="text,LOTA03" GF="S 20"></td>	         <!-- 벤더 -->
			    						<td GH="50 STD_LOTA04" GCol="text,LOTA04" GF="S 10"></td>	         <!-- LOTA04 -->
			    						<td GH="50 STD_LOTA07" GCol="text,LOTA07" GF="S 20"></td>	         <!-- 위탁구분 -->
			    						<td GH="50 STD_LOTA08" GCol="text,LOTA08" GF="S 20"></td>	         <!-- LOTA08 -->
			    						<td GH="50 STD_LOTA09" GCol="text,LOTA09" GF="S 20"></td>	         <!-- LOTA09 -->
			    						<td GH="50 STD_LOTA10" GCol="text,LOTA10" GF="S 20"></td>	         <!-- LOTA10 -->
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14"></td>	         <!-- 제조일자 -->
			    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14"></td>	         <!-- 입고일자 -->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14"></td>	         <!-- 유통기한 -->
			    						<td GH="50 STD_LOTA14" GCol="text,LOTA14" GF="D 14"></td>	         <!-- LOTA14 -->
			    						<td GH="50 STD_LOTA15" GCol="text,LOTA15" GF="D 14"></td>	         <!-- LOTA15 -->
			    						<td GH="50 STD_LOTA16" GCol="text,LOTA16" GF="S 11"></td>	         <!-- LOTA16 -->
			    						<td GH="50 STD_LOTA17" GCol="text,LOTA17" GF="S 11"></td>	         <!-- LOTA17 -->
			    						<td GH="50 STD_LOTA18" GCol="text,LOTA18" GF="S 11"></td>	         <!-- LOTA18 -->
			    						<td GH="50 STD_LOTA19" GCol="text,LOTA19" GF="S 11"></td>	         <!-- LOTA19 -->
			    						<td GH="50 STD_LOTA20" GCol="text,LOTA20" GF="S 11"></td>	         <!-- LOTA20 -->
			    						<td GH="80 STD_LOCASR_L7141" GCol="text,PACK" GF="S 20"></td>	     <!-- 피킹로케이션 -->
			    						<td GH="50 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1"></td>	     <!-- 박스수량 -->
			    						<td GH="50 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" ></td>	         <!-- 박스입수 -->
			    						<td GH="50 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0"></td>	         <!-- 잔량 -->
			    						<td GH="50 STD_PLTQTY" GCol="input,PLTQTY" GF="N 17,2"></td>	     <!-- 팔레트수량 -->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" ></td>          <!-- 팔렛당수량 -->
			    						<td GH="50 STD_PLBQTY" GCol="text,PLBQTY" GF="S 17"></td>          <!-- 팔렛당박스수량 -->
			    						<td GH="50 STD_BOXQTYOR" GCol="input,BOXQTYOR" GF="N 17,1"></td>	 <!-- 박스수량 -->
			    						<td GH="50 STD_PLTQTYOR" GCol="input,PLTQTYOR" GF="N 17,1"></td>	 <!-- 팔레트수량 -->
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