<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL01</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<style>
	.red{color: red !important; }
	.black{color: black !important; }
</style>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "ConsignOutbound", 
			command : "OD09_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "OD09"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "ConsignOutbound",
	    	colorType : true ,
			command : "OD09_ITEM",
		    menuId : "OD09"
	    });

		gridList.setReadOnly("gridItemList", true, ["CONFIRM","LOTA05","LOTA06","PTLT05","PTLT06","SKUG01","ASKU02","SKUG05"]);

		$("#qttaorSum").html("0");
		$("#pltqtySum").html("0");
		$("#boxqtySum").html("0");
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	
	//버튼작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Print"){
			var taskky = gridList.getColData("gridHeadList", 0, "TASKKY");
			if(taskky && taskky != "" && taskky != " "){
				var wherestr = " AND H.TASKKY IN ('" + taskky + "')";
				var map = new DataMap();
				WriteEZgenElement("/ezgen/move_list.ezg" , wherestr , " " , "KO", map , 880 , 595 );
			}else{
				commonUtil.msgBox("TASK_M0039");//* 재고 이동 지시서  생성후에 출력 가능합니다. *
			}
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "OD09");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "OD09");
		}
	}
	
	
	//조회
	function searchList(){

		$('#btnSave').show();
		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridItemList");
		
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}


	//저장
	function saveData() {
		
		// checkGridColValueDuple : pk중복값 체크
		if (gridList.validationCheck("gridHeadList", "data") && gridList.validationCheck("gridItemList", "select") ) {

			var param = inputList.setRangeDataParam("searchArea");
			var head = gridList.getGridBox("gridHeadList").getDataAll();
			var item = gridList.getSelectData("gridItemList");
			param.put("head",head);
			param.put("item",item);

			if (item.length == 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//item 저장불가 조건 체크
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if(Number(itemMap.QTTAOR) < 1){
					commonUtil.msgBox("VALID_M0952"); //수량이 0 입니다.
					return;
				}
				
				if(Number(itemMap.QTTAOR) > Number(itemMap.AVAILABLEQTY)){
					commonUtil.msgBox("VALID_M0923"); //작업수량은 가용수량을 초과할 수 없습니다.
					return;
				}
			}
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
				// 저장하시겠습니까?
				return;
			}

			netUtil.send({
				url : "/ConsignOutbound/json/saveOD09.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}

	
	//저장성공시 callback
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data != "F"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				$('#btnSave').hide();

				searchListSaveAfter(json.data.TASKKY);
			}else{
				commonUtil.msgBox("VALID_M0009");
			}
		}
	}
	
	//아이템그리드 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			//row데이터 이외에 검색조건 추가가 필요할 떄 
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			
			if(rowData.map.TASKKY && rowData.map.TASKKY != '' && rowData.map.TASKKY != ' '){ //입고문서번호가 생성된 경우 
				//아이템 재조회
				netUtil.send({
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
			    	module : "ConsignOutbound", 
					command : "OD09_ITEM2",
					bindId : "gridItemList" //그리드ID
				});
			}else{
				gridList.gridList({
			    	id : "gridItemList",
			    	param : param
			    });
			}
		}
	}
	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}

	
	//저장 후 조회 
	function searchListSaveAfter(taskky){
		var param = inputList.setRangeParam("searchArea");
		param.put("TASKKY",taskky);
		
		// 재조회
		netUtil.send({
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
	    	module : "ConsignOutbound", 
			command : "OD09_HEAD2",
			bindId : "gridHeadList" //그리드ID
		});
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("DOCUTY", "320");
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("DOCCAT", "300");
			param.put("DOCUTY", "320");
		}
		
		return param;
	}

	
	//그리드 컬럼 값 변경시 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){

		if(gridId == "gridItemList"){
			if(colName == "QTTAOR" || colName == "BOXQTY" || colName == "REMQTY" || colName == "PLTQTY"){ //수량변경시연결된 수량 변경
				var qttaor = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var grswgt = 0;
				var bxiqty = gridList.getColData(gridId, rowNum, "BXIQTY");
				var qtduom = gridList.getColData(gridId, rowNum, "QTDUOM");
				var pliqty = gridList.getColData(gridId, rowNum, "PLIQTY");
				//var grswgtcnt = gridList.getColData(gridId, rowNum, "GRSWGTCNT");
				
				
				if(gridList.getColData(gridId, rowNum, "SKUKEY") == "" ||gridList.getColData(gridId, rowNum, "SKUKEY") == " " ){
					commonUtil.msgBox("VALID_M0958"); //품번 입력 후 수량을 입력하실 수 있습니다.
			    	gridList.setColValue(gridId, rowNum, "QTTAOR", 0);
					gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
					gridList.setColValue(gridId, rowNum, "REMQTY", 0);
					gridList.setColValue(gridId, rowNum, "PLTQTY", 0);
					return;
				}
				
				if( colName == "QTTAOR" ) {
				 	qttaor = colValue;
				 	boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
				 	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
				 	boxqty = floatingFloor((Number)(qttaor)/(Number)(bxiqty), 1);
				 	remqty = (Number)(qttaor)%(Number)(bxiqty);
				 	pltqty = floatingFloor((Number)(qttaor)/(Number)(pliqty), 2);
				 	//grswgt = qttaor * grswgtcnt;
				 	
				 	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
					
				}else if( colName == "BOXQTY" ){ 
					boxqty = colValue;
				 	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
				 	qttaor = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				 	pltqty = floatingFloor((Number)(qttaor)/(Number)(pliqty), 2);
				 	//grswgt = qttaor * grswgtcnt;
				 	
					gridList.setColValue(gridId, rowNum, "QTTAOR", qttaor);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				}else if( colName == "REMQTY" ){
					qttaor = gridList.getColData(gridId, rowNum, "QTTAOR");
					boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
					remqty = colValue;	
					
					
					remqtyChk = (Number)(remqty)%(Number)(bxiqty);
					boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
					qttaor = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
					pltqty = floatingFloor((Number)(qttaor)/(Number)(pliqty), 2);
					//grswgt = qttaor * grswgtcnt;
					
					gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);	
					gridList.setColValue(gridId, rowNum, "QTTAOR", qttaor); 	
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				}

				if( colName == "PLTQTY" ){ 
					  	pltqty = colValue;
					  	qttaor = floatingFloor((Number)(pltqty) * (Number)(pliqty),0);
					  	boxqty = floatingFloor((Number)(pltqty) * (Number)(pliqty) /(Number)(bxiqty), 1);
					  	gridList.setColValue(gridId, rowNum, "QTTAOR", qttaor);
					  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					  	gridList.setColValue(gridId, rowNum, "REMQTY", remqty);	
				}
				if(Number(gridList.getColData(gridId, rowNum, "QTTAOR")) > Number(gridList.getColData(gridId, rowNum, "AVAILABLEQTY"))){

					commonUtil.msgBox("VALID_M0923");//작업수량은 가용수량을 초과할 수 없습니다.
					gridList.setColValue(gridId, rowNum, "REMQTY", 0);
					gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
					gridList.setColValue(gridId, rowNum, "PLTQTY", 0);	
					gridList.setColValue(gridId, rowNum, "QTTAOR", 0); 	
					gridList.setColValue(gridId, rowNum, "GRSWGT", 0);
					
				}
				
				calSum(true);
			} //수량변경 끝
		}
	}
	
	//전체 체크일 경우 
	function gridListEventRowCheckAll(gridId, checkType){
		gridListEventRowCheck(gridId, 0, checkType);
	}
	
	//체크 이벤트
	function gridListEventRowCheck(gridId, rowNum, checkType){
		if(gridId == "gridItemList"){
			calSum(checkType);
		}
	}
	
	//합계계산
	function calSum(checkType){
		if(checkType){
			var qttaorSum = 0;
			var pltqtySum = 0;
			var boxqtySum = 0;

			var item = gridList.getSelectData("gridItemList");
			//sum값 재 계산
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				var qttaor = Number(itemMap.QTTAOR);
				var pltqty = Number(itemMap.PLTQTY);
				var boxqty = Number(itemMap.BOXQTY);

			  	qttaorSum += Number(qttaor);
			  	pltqtySum += Number(pltqty);
			  	boxqtySum += Number(boxqty);
			}
			$("#qttaorSum").html(floatingFloor(qttaorSum, 0));
			$("#pltqtySum").html(floatingFloor(pltqtySum, 2));
			$("#boxqtySum").html(floatingFloor(boxqtySum, 0));
		}else{
			$("#qttaorSum").html(0);
			$("#pltqtySum").html(0);
			$("#boxqtySum").html(0);
		}
	}
	
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
		if(searchCode == "SHLOCMA"){
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
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG01"){
            param.put("CMCDKY","SKUG01");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.ASKU02"){
        	param.put("CMCDKY","ASKU02");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG05"){
        	param.put("CMCDKY","SKUG05");
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
					<input type="button" id="btnSave" CB="Save SAVE BTN_SAVE" />
					<input type="button" CB="Print PRINT BTN_PRINT17" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
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
							<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true" ></select>
						</dd>
					</dl>
					<dl>  <!--작업타입-->  
						<dt CL="STD_TASOTY"></dt> 
						<dd> 
							<select name="TASOTY" id="TASOTY" class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select> 
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
					<dl>  <!--제조일자-->  
						<dt CL="STD_LOTA11"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA11" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통잔여(%)-->  
						<dt CL="STD_DTREMRAT"></dt> 
						<dd> 
							<input type="text" class="input" name="NVL(DECODE(SM.OUTDMT,0,0,TRUNC((TO_NUMBER(TO_DATE(TRIM(S.LOTA13),'YYYYMMDD') - TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')))/SM.OUTDMT) * 100)), 0)" UIInput="SR"/> 
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
			    						<td GH="80 STD_DOCDAT" GCol="input,DOCDAT" GF="C"  validate="required">문서일자</td>	<!--문서일자-->
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
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 20PX 0 15px;">
						<span CL="STD_RSNCOD" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<select name="WARECOMBO" id="WARECOMBO"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true"><option></option></select>
					</li>
					<li style="TOP: 4PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 10PX"> <!-- 적용 -->
						<input type="button" CB="SetAll SAVE BTN_REFLECT" /> 
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 20PX 0 15px; width: ">
						≫<span CL="STD_QTTAORS" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span> : <span id="qttaorSum"></span>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 20PX 0 15px;">
						≫<span CL="STD_PLTQTYS" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span> : <span id="pltqtySum"></span>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 20PX 0 15px;">
						≫<span CL="STD_BOXQTYS" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span> : <span id="boxqtySum"></span>
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
			    						<td GH="80 STD_CONFIRM" GCol="check,CONFIRM">확인</td>	<!--확인-->
			    						<td GH="50 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td>	<!--재고키-->
			    						<td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="50 STD_QTSAVLB" GCol="text,AVAILABLEQTY" GF="N 20,0">가용수량</td>	<!--가용수량-->
			    						<td GH="50 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td>	<!--작업타입-->
			    						<td GH="50 STD_RSNCOD" GCol="select,RSNCOD">
												<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"><option></option></select>
			    						</td>	<!--사유코드-->
			    						<td GH="200 STD_TASRSN" GCol="input,TASRSN" GF="S 127">상세사유</td>	<!--상세사유-->
			    						<td GH="88 STD_QTTAOR" GCol="input,QTTAOR" GF="N 20,0">작업수량</td>	<!--작업수량-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="50 STD_TRNUSR" GCol="text,TRNUSR" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10">단위구성</td>	<!--단위구성-->
			    						<td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="88 STD_QTSPUM" GCol="text,QTSPUM" GF="S 11">UPM</td>	<!--UPM-->
			    						<td GH="50 STD_SDUOKY" GCol="text,SDUOKY" GF="S 3">기본단위</td>	<!--기본단위-->
			    						<td GH="88 STD_QTSDUM" GCol="text,QTSDUM" GF="S 11">기본UPM</td>	<!--기본UPM-->
			    						<td GH="80 STD_LOCATG" GCol="input,LOCATG,SHLOCMA" GF="U 20"  validate="required">To 로케이션</td>	<!--To 로케이션-->
			    						<td GH="80 STD_AREATG" GCol="text,AREATG" GF="S 10">To 동</td>	<!--To 동-->
			    						<td GH="50 STD_TRNUTG" GCol="text,TRNUTG" GF="S 20">To 팔렛트ID</td>	<!--To 팔렛트ID-->
			    						<td GH="80 STD_ASKU02" GCol="select,ASKU02"><!--세트여부-->
												<select class="input" commonCombo="ASKU02"></select>
			    						</td>	
			    						<td GH="80 STD_SKUG01" GCol="select,SKUG01">	<!--대분류-->
												<select class="input" commonCombo="SKUG01"></select>
			    						</td>
			    						<td GH="88 STD_SKUG05" GCol="select,SKUG05">	<!--제품용도-->
												<select class="input" commonCombo="SKUG05"></select>
			    						</td>
			    						<td GH="88 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11">포장중량</td>	<!--포장중량-->
			    						<td GH="88 STD_NETWGT" GCol="text,NETWGT" GF="S 11">순중량</td>	<!--순중량-->
			    						<td GH="88 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="S 11">포장가로</td>	<!--포장가로-->
			    						<td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="S 11">포장세로</td>	<!--포장세로-->
			    						<td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="S 11">포장높이</td>	<!--포장높이-->
			    						<td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="S 11">CBM</td>	<!--CBM-->
			    						<td GH="88 STD_CAPACT" GCol="text,CAPACT" GF="S 11">CAPA</td>	<!--CAPA-->
			    						<td GH="50 STD_LOTA01" GCol="text,LOTA01" GF="S 20">LOTA01</td>	<!--LOTA01-->
			    						<td GH="90 STD_LOTA02" GCol="text,LOTA02" GF="S 20">BATCH NO</td>	<!--BATCH NO-->
			    						<td GH="50 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="50 STD_LOTA04" GCol="text,LOTA04" GF="S 10">LOTA04</td>	<!--LOTA04-->
			    						<td GH="90 STD_LOTA05" GCol="select,LOTA05">	<!--포장구분-->
												<select class="input" commonCombo="LOTA05"></select>
										</td>
			    						<td GH="90 STD_LOTA06" GCol="select,LOTA06">	<!--재고유형-->
												<select class="input" commonCombo="LOTA06"></select>
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
			    						<td GH="50 STD_PTLT01" GCol="text,PTLT01" GF="S 20">To LOT01</td>	<!--To LOT01-->
			    						<td GH="90 STD_PTLT02" GCol="text,PTLT02" GF="S 20">To LOT02</td>	<!--To LOT02-->
			    						<td GH="50 STD_PTLT03" GCol="text,PTLT03" GF="S 20">To벤더</td>	<!--To벤더-->
			    						<td GH="50 STD_PTLT04" GCol="text,PTLT04" GF="S 10">To LOT04</td>	<!--To LOT04-->
			    						<td GH="90 STD_PTLT05" GCol="select,PTLT05"><!--To포장구분-->
												<select class="input" commonCombo="LOTA05"></select>
			    						</td>	
			    						<td GH="90 STD_PTLT06" GCol="input,PTLT06" GF="S 20"><!--To 재고유형-->
												<select class="input" commonCombo="LOTA06"></select>
			    						</td>	
			    						<td GH="50 STD_PTLT07" GCol="text,PTLT07" GF="S 20">To LOT07</td>	<!--To LOT07-->
			    						<td GH="50 STD_PTLT08" GCol="text,PTLT08" GF="S 20">To LOT08</td>	<!--To LOT08-->
			    						<td GH="50 STD_PTLT09" GCol="text,PTLT09" GF="S 20">To LOT09</td>	<!--To LOT09-->
			    						<td GH="50 STD_PTLT10" GCol="text,PTLT10" GF="S 20">To LOT10</td>	<!--To LOT10-->
			    						<td GH="80 STD_PTLT11" GCol="text,PTLT11" GF="D 14">To제조일자</td>	<!--To제조일자-->
			    						<td GH="80 STD_PTLT12" GCol="text,PTLT12" GF="D 14">To입고일자</td>	<!--To입고일자-->
			    						<td GH="80 STD_PTLT13" GCol="text,PTLT13" GF="D 14">To 유통기한</td>	<!--To 유통기한-->
			    						<td GH="50 STD_PTLT14" GCol="text,PTLT14" GF="D 14">To LOT14</td>	<!--To LOT14-->
			    						<td GH="50 STD_PTLT15" GCol="text,PTLT15" GF="D 14">To LOT15</td>	<!--To LOT15-->
			    						<td GH="50 STD_PTLT16" GCol="text,PTLT16" GF="S 11">To LOT16</td>	<!--To LOT16-->
			    						<td GH="50 STD_PTLT17" GCol="text,PTLT17" GF="S 11">To LOT17</td>	<!--To LOT17-->
			    						<td GH="50 STD_PTLT18" GCol="text,PTLT18" GF="S 11">To LOT18</td>	<!--To LOT18-->
			    						<td GH="50 STD_PTLT19" GCol="text,PTLT19" GF="S 11">To LOT19</td>	<!--To LOT19-->
			    						<td GH="50 STD_PTLT20" GCol="text,PTLT20" GF="S 11">To LOT20</td>	<!--To LOT20-->
			    						<td GH="160 STD_SBKTXT" GCol="input,SBKTXT" GF="S 75">비고</td>	<!--비고-->
			    						<td GH="80 STD_LOCASR_L7141" GCol="text,PACK" GF="S 20"></td>	<!---->
			    						<td GH="50 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="50 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="50 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="50 STD_PLTQTY" GCol="input,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="50 STD_PLBQTY" GCol="text,PLBQTY" GF="S 17" style="text-align:right;" >팔렛당박스수량</td>	<!--팔렛당박스수량-->
			    						<td GH="50 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 17,0">유통잔여(DAY)</td>	<!--유통잔여(DAY)-->
			    						<td GH="50 STD_DTREMRAT" GCol="text,DTREMRAT" GF="N 17,0">유통잔여(%)</td>	<!--유통잔여(%)-->
			    						<td GH="50 STD_BOXQTYOR" GCol="input,BOXQTYOR" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="50 STD_PLTQTYOR" GCol="input,PLTQTYOR" GF="N 17,1">팔레트수량</td>	<!--팔레트수량-->
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