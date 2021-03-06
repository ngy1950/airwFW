<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>MV06</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

var param;
var head;
var item;
var sLocasr;
var sLota06;
var check;

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "taskOrder",
			command : "MV06_HEAD",
	    	itemGrid : "gridItemList",
	    	itemSearch : true,
		    menuId : "MV06"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "taskOrder",
			command : "MV06_ITEM",
		    menuId : "MV06"
	    });
		
		// 콤보박스 리드온리
		gridList.setReadOnly("gridItemList", true, ["LOTA06","ASKU02","SKUG01","SKUG05","LOTA02","LOTA05"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});
	
	function linkPopCloseEvent(data){ //팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	} // end linkPopCloseEvent()	
	
	
	function commonBtnClick(btnName){
		if (btnName == 'Savevariant') {
			sajoUtil.openSaveVariantPop("searchArea", "MV06");
		} else if (btnName == 'Getvariant') {
			sajoUtil.openGetVariantPop("searchArea", "MV06");
		} else if(btnName == "Create"){
			uiList.setActive("Save",true); // 저장후 저장버튼을 보여줄것인지 말 것인지
			searchList();
		}else if(btnName == "Save"){
			saveDataCheck();
		}
	}// end commonBtnClick()	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
	    if(searchCode == 'SHSKUMA') { // 제품코드    
			param.put('OWNRKY', $('#OWNRKY').val());		
			param.put('WAREKY', $('#WAREKY').val());		
	    } else if(searchCode == 'SHAREMA') { // 동
			param.put('WAREKY', $('#WAREKY').val());			    	
	    } else if(searchCode == 'SHZONMA') { // 존 
			param.put('WAREKY', $('#WAREKY').val());			    		    	
	    } else if (searchCode == 'SHLOCMA') { // 로케이션
			param.put('WAREKY', $('#WAREKY').val());			    	
	    } else if(searchCode == 'SHLOTA03CM') { // 벤더	    	
			param.put('OWNRKY', $('#OWNRKY').val());	
			param.put("PTNRTY","0001");
	    } else if(searchCode == 'SHCMCDV') { // 공통코드
	    	switch($inputObj.name) {
  			case 'S.SKUG05' : // 제품용도
  				param.put('CMCDKY', 'SKUG05');
  				break;
  			case 'S.ASKU02' : // 세트여부
  				param.put('CMCDKY', 'ASKU02');
  				break;
  			case 'S.SKUG01' : // 대분류
  				param.put('CMCDKY', 'SKUG01');
  				param.put("USARG5"," ");
  				break;
  			} // end switch
  		} // enb if
        
    	return param;
    } // end searchHelpEventOpenBefore()

	function paramCheckHooks(paramObj, myObj) {
		if(!paramObj || !paramObj instanceof Object || !myObj || !myObj instanceof Object) {
			throw new Error("형식에 맞지 않습니다.");
			return;
		}
		
		for(var item in myObj) {
	
			if(!paramObj[item] || paramObj[item] == '') paramObj.put([item], myObj[item]);
			
		}
		return paramObj;
	}
	
	function searchList(){ // create
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			
			var param = inputList.setRangeParam("searchArea");
			
			param = paramCheckHooks(param, {
				"CREUSR" : "<%=userid%>",
				"WAREKY" : $('#WAREKY').val(),
				"OWNRKY" : $('#OWNRKY').val(),
				"TASOTY" : $('#TASOTY').val(),
				"WARETG" : $('#WAREKY').val(),
				"DOCCAT" : "300",
				"STATDO" : "NEW",
				"AREATG" : " "
			});
			
 			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}// end searchList()
	
	
	// 아이템 그리드 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(validate.check("searchArea")) {
			if(gridId === 'gridHeadList') {				
				var rowData = gridList.getRowData(gridId, rowNum); 
				var param = inputList.setRangeParam("searchArea");
				var id = 'gridItemList';
				var taskky = rowData.map.TASKKY;
				var gridOption;
				param.putAll(rowData); 	
				
				//  작업지시번호가 생성 되었다면 재조회 쿼리 태움
				if(taskky.trim() == ""){
					gridOption = {
						id : id,
						param : param
					}	
				}else{
					gridOption = {
						id : id,
						module : "taskOrder",
						command : "MV09_ITEM",
						param : param
					}	
				}
				
				
				/* if(rowData.get('TASKKY') && rowData.get('TASKKY') != ' ') {
					gridOption.command = 'MV06_ITEM_RESEARCH';
				}  */
				
				gridList.gridList(gridOption);
				
			}
		}
		
	}// end gridListEventItemGridSearch()
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "LOTA05" || comboAtt == "LOTA02"){
			param.put("WEARKY", $('#WEARKY').val());
		} else if (comboAtt == 'SajoCommon,DOCUTY_COMCOMBO') {
			param.put("DOCCAT", "300");
			param.put("DOCUTY", "320");
		}
		
		return param;
	}// end comboEventDataBindeBefore()
	
	/* // 서버 요청후 모든 비동기가 끝난 직후 호출
	function gridListEventDataBindEnd(gridId, dataLength, excelLoadType)  {
		const a = gridList.getGridBox('gridItemList').getDataAll();
		console.log(a);
	} // gridListEventDataBindEnd() */
	
	function saveDataCheck() {
		param = new DataMap();
		sLocasr = '';
		sLota06 = '';
		check = false;
		
		
		
		param.putAll(inputList.setRangeParam("searchArea"));
		
		// HEAD
		if(gridList.validationCheck("gridHeadList", "select")) {
			
			head = gridList.getGridData("gridHeadList");
			// console.log(head);
			if(head.length === 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			param.put("head",head);
		} // end if
		
		// ITEM
		if(gridList.validationCheck('gridItemList', 'select')) {
			// item = gridList.getModifyData('gridItemList', 'A');
			item = gridList.getSelectData('gridItemList');
	
			if(item.length === 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			if($.trim($('#SEL_LOTA06').val()) == ""){
				commonUtil.msgBox("재고유형 값을 선택 하세요.");
				return false;
			}
			
			if($.trim($('#SEL_LOTA11').val()) == ""){
				commonUtil.msgBox("제조일자 값을 선택 하세요.");
				return false;
			}
			
			if($.trim($('#SEL_LOTA13').val()) == ""){
				commonUtil.msgBox("유통기한 값을 선택 하세요.");
				return false;
			}
			
			var itemcheck1 = false;
			var itemcheck2 = false;
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if(sLocasr != '' && sLocasr != itemMap["LOCASR"]) {
					itemcheck1 = true;
					break; 
				}
				sLocasr = itemMap["LOCASR"];
				
				if(sLota06 != '' && sLota06 != itemMap["LOTA06"]){
					itemcheck2 = true;
					break; 
				}
				
				sLota06 = itemMap["LOTA06"];
			}
			
			if(itemcheck1){
				commonUtil.msgBox("TASK_M0040");
				return false;
			}
			
			if(itemcheck2){
				commonUtil.msgBox("TASK_M0041");
				return false;
			}
			
			if(check) return;
		
			param.put("item",item);
			
			saveData();
		
	}

	// 데이터 저장
	function saveData() { // savCheck
			
		item.forEach(function(i) {
			var itemMap = i.map;
			
			if(sLocasr != '' && sLocasr != itemMap["LOCASR"]) {
				commonUtil.msgBox("TASK_M0042");
				check = true;
				return;
			}
				
		});
		
		if(check) return;
		
		
		if(item.length == 0) {
			param.put("LOTA03", $("#SEL_LOTA03").val()); // 벤더
			param.put("LOTA05", $("#SEL_LOTA05").val()); // 포장구분
			param.put("LOTA06", $("#SEL_LOTA06").val()); // 재고유형
			param.put("LOTA11", $("#SEL_LOTA11").val()); // 제조일자
			param.put("LOTA12", $("#SEL_LOTA12").val()); // 입고일자
			param.put("LOTA13", $("#SEL_LOTA13").val()); // 유통기한
			param.put("LOCAAC", sLocasr); 
		} else {
			var msgText = "";
			
			var start = 0;
			item.forEach(function(i) {
				var itemMap = i.map;
				if(start != 0) msgText = ',';
				msgText += itemMap.LOCATG;
				start++;
			});
			
			
			param.put("LOTA03", regExp($("#SEL_LOTA03").val())); // 벤더
			param.put("LOTA05", regExp($("#SEL_LOTA05").val())); // 포장구분
			param.put("LOTA06", regExp($("#SEL_LOTA06").val())); // 재고유형
			param.put("LOTA11", regExp($("#SEL_LOTA11").val())); // 제조일자
			param.put("LOTA12", regExp($("#SEL_LOTA12").val())); // 입고일자
			param.put("LOTA13", regExp($("#SEL_LOTA13").val())); // 유통기한
			param.put("LOCAAC", sLocasr); 
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {	// 저장하시겠습니까?
				return;	
			}
			
			netUtil.send({
				url : "/taskOrder/json/saveMV06.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
			
			sLocasr = '';
			sLota06 = '';
			check = false;
			
			/* RRRRRRR 로케이션만을 바라보기 때문에  MV06 화면에서는 체크할 필요 없음  - 2021.05.15 */
/* 			if (confirm("중복 로케이션 : ["+msgText+"] \r계속 진행하시겠습니까?")) {
				param.put("LOTA03", $("#SEL_LOTA03").val()); // 벤더
				param.put("LOTA05", $("#SEL_LOTA05").val()); // 포장구분
				param.put("LOTA06", $("#SEL_LOTA06").val()); // 재고유형
				param.put("LOTA11", $("#SEL_LOTA11").val()); // 제조일자
				param.put("LOTA12", $("#SEL_LOTA12").val()); // 입고일자
				param.put("LOTA13", $("#SEL_LOTA13").val()); // 유통기한
				param.put("LOCAAC", sLocasr); 
				
				
				netUtil.send({
					url : "/taskOrder/json/saveMV06.data",
					param : param,
					successFunction : "successSaveCallBack"
				});
				
				sLocasr = '';
				sLota06 = '';
				check = false;
			} */
		}
			
		}  // end if
		
	} // end saveData()
	
	// ajax success function
	function successSaveCallBack(json, status) {
		if(json && json.data) {
			var condition = json.data['RESULT'];
			if(condition == 'S') {
				uiList.setActive("Save",false); // 저장후 저장버튼을 보여줄것인지 말 것인지
				commonUtil.msgBox("SYSTEM_SAVEOK");
				reSearchList(json);
			} else if(condition == 'F') {
				commonUtil.msgBox("SYSTEM_ROWEMPTY");
			} else if(condition == 'M') {
				commonUtil.msgBox(json.data['M']);
			} else {
				commonUtil.msgBox("EXECUTE_ERROR");
				throw new Error('json data is undefined');
			}
		}
	} // end successSaveCallback()
	
	// 저장 성공 시 재조회 쿼리
	function reSearchList(json){
		if(validate.check("searchArea")){
			var taskky = json.data.TASKKY;
			param = inputList.setRangeDataParam("searchArea");
			param.put("TASKKY", taskky);
			
			console.log(param);
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param,
		    	command : "MV06_HEAD_RESEARCH"
		    });
		}
	}// end reSearchList()
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue) {
		if(gridId == 'gridItemList') {
			if(colName == "QTTAOR" || colName == "BOXQTY" || colName == "REMQTY" || colName == "PLTQTY") {
				var qttaor = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var bxiqty = gridList.getColData(gridId, rowNum, "BXIQTY"); 
				var qtduom = gridList.getColData(gridId, rowNum, "QTDUOM");
				var pliqty = gridList.getColData(gridId, rowNum, "PLIQTY");
				var availableqty = gridList.getColData(gridId, rowNum, "AVAILABLEQTY");
				var remqtyChk = 0;
				
				if( colName == "QTTAOR" ) {
					qttaor = colValue;
	  	
					boxqty = floatingFloor((Number)(qttaor)/ (Number)(bxiqty));
				  	remqty = floatingFloor((Number)(qttaor)%(Number)(bxiqty));
				  	pltqty = floatingFloor((Number)(qttaor)/(Number)(pliqty));
				  	
				  	/* if((Number)(qttaor) > (Number)(availableqty)){
				  		commonUtil.msgBox("VALID_M0923");
				  		gridList.setColValue("gridItemList", rowNum, "QTTAOR", 0);	
						return;
				  	} */
				  	
				  	gridList.setColValue("gridItemList", rowNum, "PLTQTY", pltqty);	
				  	gridList.setColValue("gridItemList", rowNum, "BOXQTY", boxqty);	
				  	gridList.setColValue("gridItemList", rowNum, "REMQTY", remqty);	
				}	
				
				if( colName == "PLTQTY" ){
					pltqty = colValue;

				  	
				  	qttaor = floatingFloor((Number)(pltqty) * (Number)(pliqty));
				  	boxqty = floatingFloor((Number)(pltqty) * (Number)(pliqty) /(Number)(bxiqty));
				  	
				  	gridList.setColValue("gridItemList", rowNum, "QTTAOR", qttaor);	
				  	gridList.setColValue("gridItemList", rowNum, "BOXQTY", boxqty);	
				  	gridList.setColValue("gridItemList", rowNum, "REMQTY", remqty);
				}
				
				if( colName == "BOXQTY" ){ 
				  	boxqty = colValue;
			  	
				  	qttaor = floatingFloor((Number)(boxqty) * (Number)(bxiqty));
				  	pltqty = floatingFloor((Number)(qttaor) / (Number)(pliqty));
				  	
				  	gridList.setColValue("gridItemList", rowNum, "QTTAOR", qttaor);	
				  	gridList.setColValue("gridItemList", rowNum, "PLTQTY", pltqty);	
				  	gridList.setColValue("gridItemList", rowNum, "REMQTY", 0);
				  }
				
				// 작업수량이 가용수량보다 많으면 불가
			  	if(Number(qttaor)> Number(availableqty) ){
			  		commonUtil.msgBox("작업 수량이 가용수량보다 많습니다.");
			  		gridList.setColValue(gridId, rowNum, "QTTAOR", 0);	//	작업수량
			  		gridList.setColValue(gridId, rowNum, "PLTQTY", 0);	//	박스수량	
			  		gridList.setColValue(gridId, rowNum, "BOXQTY", 0);	//	팔레트수량
			  		return;
			  	}
			}
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
					<input type="button" CB="Create ADD BTN_NEW" />
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
							<select name="WAREKY" id="WAREKY" class="input" validate="required"></select>
						</dd>
					</dl>
					
					<dl>  <!--작업타입-->  
						<dt CL="STD_TASOTY"></dt> 
						<dd> 
							<select name="TASOTY" id="TASOTY" class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/> 
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
					
					<!-- 벤더 -->
					<dl>
						<dt CL="STD_LOTA03"></dt>
						<dd>
							<input type="text" class="input" name="S.LOTA03" UIInput="SR,SHLOTA03CM" />
						</dd>
					</dl>
					
					<!-- 포장구분 -->
					<dl>
						<dt CL="STD_LOTA05"></dt>
						<dd>
							<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05" />
						</dd>
					</dl>
					
					<!-- 재고유형 -->
					<dl>
						<dt CL="STD_LOTA06"></dt>
						<dd>
							<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA06" />
						</dd>
					</dl>
					<!-- 입고일자 -->
					<dl>
						<dt CL="STD_LOTA12"></dt>
						<dd>
							<input type="text" class="input" name="S.LOTA12" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					<!-- 유통기한 -->
					<dl>
						<dt CL="STD_LOTA13"></dt>
						<dd>
							<input type="text" class="input" name="S.LOTA13" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
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
			    						<td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="S 10">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_TASOTY" GCol="text,TASOTY" GF="N 4,0">작업타입</td>	<!--작업타입-->
			    						<td GH="80 STD_TASOTYNM" GCol="text,TASOTYNM" GF="S 100">작업타입명</td>	<!--작업타입명-->
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0">문서유형</td>	<!--문서유형-->
			    						<td GH="200 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>	<!--문서유형명-->
			    						<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 100">문서상태명</td>	<!--문서상태명-->
			    						<td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td>	<!--작업수량-->
			    						<td GH="80 STD_QTCOMP" GCol="text,QTCOMP" GF="N 20,0">완료수량</td>	<!--완료수량-->
			    						<td GH="50 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 60">수정일자</td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60">수정시간</td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60">수정자명</td>	<!--수정자명-->
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
					<!-- 벤더 -->
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 10PX 0 2px;">
					 	<span CL="STD_LOTA03" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
					 	<input type="text" id="SEL_LOTA03" name="SEL_LOTA03" UIInput="I" class="input"/>
					</li>
					
					<!-- 포장구분 -->
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 10PX 0 2px;">
					 	<span CL="STD_LOTA05" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
					 	<select id="SEL_LOTA05" name="SEL_LOTA05" CommonCombo="LOTA05" class="input" ></select>  
					</li>
					
							
					<!-- 재고유형 -->
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 10PX 0 2px;">
					 	<span CL="STD_LOTA06" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
					 	<select id="SEL_LOTA06" name="SEL_LOTA06" CommonCombo="LOTA06" class="input" >
					 		<option value="" selected>선택</option>
					 	</select> 

					</li>
					
					<!-- 제조일자 -->
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 10PX 0 2px;">
					 	<span CL="STD_LOTA11" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
					 	<input type="text" id="SEL_LOTA11" name="SEL_LOTA11"  UIFormat="C" class="input"/>
					</li>
					
					<!-- 입고일자 -->
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 10PX 0 2px;">
					 	<span CL="STD_LOTA12" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
					 	<input type="text" id="SEL_LOTA12" name="SEL_LOTA12"  UIFormat="C" class="input"/> 
					</li>
					
					<!-- 유통기한 -->
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 10PX 0 2px;">
					 	<span CL="STD_LOTA13" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
					 	<input type="text" class="input" id="SEL_LOTA13" name="SEL_LOTA13" UIFormat="C" PGroup="G1,G2" />
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true"> 
										<!--화면에 조회 값과 상관없이 로우 선택하는 체크박스 확인   -->
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="50 STD_QTSAVLB" GCol="text,AVAILABLEQTY" GF="N 20,0">가용수량</td>	<!--가용수량-->
			    						<td GH="88 STD_QTTAOR" GCol="input,QTTAOR" GF="N 20,0">작업수량</td>	<!--작업수량-->
			    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="90 STD_LOTA06" GCol="select,LOTA06"> <!--재고유형-->
			    							<select class="input" CommonCombo="LOTA06">
			    								<option>
			    									재고유형
			    								</option>
			    							</select>
			    						</td>
			    						<td GH="80 STD_ASKU02" GCol="select,ASKU02"> <!--세트여부-->
			    							<select class="input" CommonCombo="ASKU02">
			    								<option value="" selected></option>
			    							</select>
			    						</td>	
			    						<td GH="80 STD_SKUG01" GCol="select,SKUG01"> <!--대분류-->
			    							<select class="input" CommonCombo="SKUG01">
			    								대분류
			    							</select>
			    						</td>	
			    						<td GH="88 STD_SKUG05" GCol="select,SKUG05"> <!--제품용도-->
			    							<select class="input" CommonCombo="SKUG05">
			    								<option value="" selected></option>
			    							</select>
			    						</td>	
			    						<td GH="88 STD_GRSWGT" GCol="text,GRSWGT" GF="N 11">포장중량</td>	<!--포장중량-->
			    						<td GH="88 STD_NETWGT" GCol="text,NETWGT" GF="N 11">순중량</td>	<!--순중량-->
			    						<td GH="88 STD_WGTUNT" GCol="text,WGTUNT" GF="N 3">중량단위</td>	<!--중량단위-->
			    						<td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="N 11">포장가로</td>	<!--포장가로-->
			    						<td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="N 11">가로길이</td>	<!--가로길이-->
			    						<td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="N 11">포장높이</td>	<!--포장높이-->
			    						<td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="N 11">CBM</td>	<!--CBM-->
			    						<td GH="88 STD_CAPACT" GCol="text,CAPACT" GF="N 11">CAPA</td>	<!--CAPA-->
			    						<td GH="50 STD_LOTA01" GCol="text,LOTA01" GF="S 20">LOTA01</td>	<!--LOTA01-->
			    						<td GH="90 STD_LOTA02" GCol="select,LOTA02"> <!--BATCH NO-->
			    							<select class="input" CommonCombo="LOTA02">
			    								BATCH NO
			    							</select>
			    						</td>	
			    						<td GH="50 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="50 STD_LOTA04" GCol="text,LOTA04" GF="S 10">LOTA04</td>	<!--LOTA04-->
			    						<td GH="90 STD_LOTA05" GCol="select,LOTA05"> <!--포장구분-->
			    							<select class="input" commonCombo="LOTA05">
			    								포장구분
			    							</select>
			    						</td>			
			    						<td GH="50 STD_LOTA07" GCol="text,LOTA07" GF="S 20">위탁구분</td>	<!--위탁구분-->
			    						<td GH="50 STD_LOTA08" GCol="text,LOTA08" GF="S 20">LOTA08</td>	<!--LOTA08-->
			    						<td GH="50 STD_LOTA09" GCol="text,LOTA09" GF="S 20">LOTA09</td>	<!--LOTA09-->
			    						<td GH="50 STD_LOTA10" GCol="text,LOTA10" GF="S 20">LOTA10</td>	<!--LOTA10-->
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
			    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="50 STD_LOTA14" GCol="text,LOTA14" GF="D 14">LOTA14</td>	<!--LOTA14-->
			    						<td GH="50 STD_LOTA15" GCol="text,LOTA15" GF="D 14">LOTA15</td>	<!--LOTA15-->
			    						<td GH="50 STD_LOTA16" GCol="text,LOTA16" GF="S 11">LOTA16</td>	<!--LOTA16-->
			    						<td GH="50 STD_LOTA17" GCol="text,LOTA17" GF="S 11">LOTA17</td>	<!--LOTA17-->
			    						<td GH="50 STD_LOTA18" GCol="text,LOTA18" GF="S 11">LOTA18</td>	<!--LOTA18-->
			    						<td GH="50 STD_LOTA19" GCol="text,LOTA19" GF="S 11">LOTA19</td>	<!--LOTA19-->
			    						<td GH="50 STD_LOTA20" GCol="text,LOTA20" GF="S 11">LOTA20</td>	<!--LOTA20-->
			    						<td GH="80 STD_LOCASRL7141" GCol="text,PACK" GF="S 20"></td>	<!-- 피킹로케이션 -->
			    						<td GH="50 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="50 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="50 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="50 STD_PLTQTY" GCol="input,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="50 STD_PLBQTY" GCol="text,PLBQTY" GF="S 17" style="text-align:right;" >팔렛당박스수량</td>	<!--팔렛당박스수량-->
			    						<td GH="50 STD_BOXQTYOR" GCol="input,BOXQTYOR" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="50 STD_PLTQTYOR" GCol="input,PLTQTYOR" GF="N 17,1">팔레트수량</td>	<!--팔레트수량-->	
			    						
			    						<td GH="50 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td>	
			    						<td GH="50 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td>
			    						<td GH="200 STD_TASRSN" GCol="text,TASRSN" GF="S 127">상세사유</td>
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>
			    						<td GH="50 STD_TRNUSR" GCol="text,TRNUSR" GF="S 20">팔렛트ID</td>
			    						<td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10">단위구성</td>
			    						<td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3">단위</td>
			    						<td GH="88 STD_QTSPUM" GCol="text,QTSPUM" GF="S 11">UPM</td>
			    						<td GH="50 STD_SDUOKY" GCol="text,SDUOKY" GF="S 3">기본단위</td>
			    						<td GH="88 STD_QTSDUM" GCol="text,QTSDUM" GF="S 11">기본UPM</td>
			    						<!-- <td GH="80 STD_AREATG" GCol="text,AREATG" GF="S 10">To 동</td> -->
			    						<td GH="50 STD_TRNUTG" GCol="input,TRNUTG" GF="S 20">To 팔렛트ID</td>
			    						<td GH="80 STD_LOCATG" GCol="text,LOCATG" GF="S 20">To 로케이션</td>
			    						
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