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
	    	tempItem : "gridItemList",
	    	useTemp : true,
	    	tempKey : "TASKKY",
			command : "MV07_HEAD",
		    menuId : "MV07"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "taskOrder",
	    	tempHead : "gridHeadList",
	    	useTemp : true,
			command : "MV07_ITEM",
			tempKey : "TASKKY",
		    menuId : "MV07"
	    });
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "NEW");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "PPC");
		rangeArr.push(rangeDataMap);
		
		setSingleRangeData("TASDH.STATDO", rangeArr); 
		
		// 콤보박스 리드온리
		gridList.setReadOnly("gridItemList", true, ["RSNCOD","LOCATG"]);	
// 		gridList.setReadOnly("gridItemList", true, ["RSNCOD"]);
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetTempData("gridHeadList");
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			reparam = new DataMap();
			
 			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}// end searchList()
	
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
			var param = gridList.getRowData(gridId, rowNum);
			param.put("OWNRKY",$('#OWNRKY').val());
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
			for(var i=0; i<head.length; i++){
				if(head.STATDO == "NEW" || head.STATDO == "PPC"){
					return;
				}
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
			}
			
			//아이템 템프 가져오기
	        var tempItem = gridList.getSelectTempData("gridHeadList");
	        
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			param.put("CREUSR", "<%=userid%>");
			param.put("tempItem",tempItem);
			
			
			netUtil.send({
				url : "/taskOrder/json/saveMV07.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}// end saveData()
	
	// 삭제
	function deleteData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			
			if(!confirm("정말 삭제하시겠습니까?")){
				return;
			}
			
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
			
			//아이템 템프 가져오기
	        var tempItem = gridList.getSelectTempData("gridHeadList");
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			param.put("tempItem",tempItem);
			
			netUtil.send({
				url : "/taskOrder/json/deleteMV07.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	
	// 재고이동(TASDH,TASDI,TASDR) Insert 로직 TASDH
	function saveTaskData(){
		var param = new DataMap();
		
		var head = gridList.getSelectData("gridHeadList", true);
		var item = gridList.getSelectData("gridItemList", true);

		param.put("head",head);
		param.put("item",item);
		param.put("CREUSR", "<%=userid%>");
		
		
		netUtil.send({
			url : "/inventory/json/saveTaskMV01.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}// end saveTaskData()
	
	
	// 저장 후 타는 함수
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "DELETE_S"){ //saveData() 성공 시 // 재고이동(TASDH,TASDI,TASDR) Insert 로직태움
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
				
			}else if(json.data["RESULT"] == "S"){		// 저장 성공 시			
				commonUtil.msgBox("SYSTEM_SAVEOK");	
				searchList();	
				
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
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
	
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			 if(colName == "QTCOMP" || colName == "BOXQTY" || colName == "REMQTY"){ 
			 	var qtcomp = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var grswgt = 0;
				var qttaor = gridList.getColData(gridId, rowNum, "QTTAOR");
				var bxiqty = gridList.getColData(gridId, rowNum, "BXIQTY");
				var pliqty = gridList.getColData(gridId, rowNum, "PLIQTY");
				var grswgtcnt = gridList.getColData(gridId, rowNum, "GRSWGTCNT");
				
				var remqtyChk = 0;
				
				// 그리드에서 선택 된 값 가져오기
				var selectDataList = gridList.getSelectData("gridItemList", true);

				if( colName == "QTCOMP" ) {
					qtcomp = colValue;
/* 					boxqty = Math.floor((Number)(qtcomp)/ (Number)(bxiqty),0);
				  	remqty = Math.floor((Number)(qtcomp)%(Number)(bxiqty),0);
				  	pltqty = Math.floor((Number)(qtcomp)/(Number)(pliqty),0); */
				  	
					boxqty = (Number)(qtcomp) / (Number)(bxiqty);
				  	remqty = (Number)(qtcomp) % (Number)(bxiqty);
				  	pltqty = (Number)(qtcomp) / (Number)(pliqty);
				  	grswgt = qtcomp * grswgtcnt;
				  	
				  	gridList.setColValue("gridItemList", rowNum, "BOXQTY", boxqty);
				  	gridList.setColValue("gridItemList", rowNum, "REMQTY", remqty);
				  	gridList.setColValue("gridItemList", rowNum, "PLTQTY", pltqty);
				  	gridList.setColValue("gridItemList", rowNum, "GRSWGT", grswgt);
					
				}
				
				if( colName == "BOXQTY" ){ 
				  	boxqty = colValue;
				  	qtcomp =(Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty);
/* 				  	pltqty = Math.floor((Number)(qtcomp)/(Number)(pliqty), 0); */
				  	
				  	pltqty = (Number)(qtcomp) / (Number)(pliqty);
				  	grswgt = qtcomp * grswgtcnt;
				  	
				  	gridList.setColValue("gridItemList", rowNum, "QTCOMP", qtcomp);	
				  	gridList.setColValue("gridItemList", rowNum, "PLTQTY", pltqty);	
				  	gridList.setColValue("gridItemList", rowNum, "GRSWGT", grswgt);
				  	
				}
				
				if( colName == "REMQTY" ){
					remqty = colValue;
					
					remqtyChk = (Number)(remqty)%(Number)(bxiqty);
/* 				  	boxqty = (Number)(boxqty) + (Number)(Math.floor((Number)(remqty)/(Number)(bxiqty), 0)); */
/* 				  	pltqty = Math.floor((Number)(qtcomp)/(Number)(pliqty), 0); */
				  	boxqty = (Number)(boxqty) + (Number)(remqty) / (Number)(bxiqty);
				  	pltqty = (Number)(qtcomp) / (Number)(pliqty);
				  	
				  	qtcomp = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);				  	
				  	grswgt = qtcomp * grswgtcnt;
				  	
				  	gridList.setColValue("gridItemList", rowNum, "REMQTY", remqtyChk);	
				  	gridList.setColValue("gridItemList", rowNum, "BOXQTY", boxqty);	
				  	gridList.setColValue("gridItemList", rowNum, "PLTQTY", pltqty);
				  	gridList.setColValue("gridItemList", rowNum, "QTCOMP", qttaor);
				  	gridList.setColValue("gridItemList", rowNum, "GRSWGT", grswgt);
				  	
				}
				
				if(((Number)(qtcomp) > (Number)(qttaor))){
					commonUtil.msgBox("작업수량보다 완료수량을 많이 입력할 수 없습니다.");
					
					gridList.setColValue("gridItemList", rowNum, "QTCOMP", 0);
					gridList.setColValue("gridItemList", rowNum, "BOXQTY", 0);
					gridList.setColValue("gridItemList", rowNum, "REMQTY", 0);
					gridList.setColValue("gridItemList", rowNum, "PLTQTY", 0);
					gridList.setColValue("gridItemList", rowNum, "GRSWGT", 0);
					return;
				}
			 }
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        // 거래처담당자 주소검색
        if(searchCode == "SHLOCMA"){
        	param.put("WAREKY",$("#WAREKY").val());
        }
        
    	return param;
    }
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Delete"){
			deleteData();
		}
		else if(btnName == "SetChk"){
			setChk();
		}else if(btnName == "Print1"){
			 printEZGenDR16("/ezgen/move_list.ezg");
		}else if(btnName == "Print2"){
			 printEZGenDR16("/ezgen/move_list_22.ezg");
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "MV07");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "MV07");
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
			var width = 840;
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
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Save SAVE BTN_CNFIRM" />
					<input type="button" CB="Delete SAVE BTN_DELETE" />
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
							<input type="text" class="input" name="TASDH.TASOTY" UIInput="SR" value ="320" readonly="readonly"/> 
						</dd> 
					</dl> 
					<dl>  <!--작업지시번호-->  
						<dt CL="STD_TASKKY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.TASKKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서일자-->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서상태-->  
						<dt CL="STD_STATDO"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.STATDO" UIInput="SR" value="NEW" readonly="readonly"/> 
						</dd> 
					</dl> 
					<dl>  <!--동-->  
						<dt CL="STD_AREAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDI.AREAKY" UIInput="SR,SHAREMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDI.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDI.DESC01" UIInput="SR"/> 
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
										<td GH="40" GCol="rowCheck"></td>
								        <td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="S 20">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_TASOTY" GCol="text,TASOTY" GF="N 4,0">작업타입</td>	<!--작업타입-->
			    						<td GH="80 STD_TASOTYNM" GCol="text,TASOTYNM" GF="S 100">작업타입명</td>	<!--작업타입명-->
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0">문서유형</td>	<!--문서유형-->
			    						<td GH="200 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>	<!--문서유형명-->
			    						<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 100">문서상태명</td>	<!--문서상태명-->
			    						<td GH="200 STD_DOCTXT" GCol="input,DOCTXT" GF="S 200">비고</td>	<!--비고-->
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

				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true"> 
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="40" GCol="rowCheck"></td>
										<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
										<td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
										<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
										<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
										<td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10">단위구성</td>	<!--단위구성-->
										<td GH="88 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td>	<!--작업수량-->
										<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
										<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
										<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
										<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
										<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
										<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
										<td GH="80 STD_LOCATG" GCol="input,LOCATG,SHLOCMA" GF="S 20">To 로케이션</td>	<!--To 로케이션-->
										<td GH="130 STD_RSNCOD" GCol="select,RSNCOD">
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">	<!--사유코드-->
												<option></option>
											</select>
										</td>	<!--사유코드-->
										<td GH="100 STD_TASRSN" GCol="text,TASRSN" GF="S 127">상세사유</td>	<!--상세사유-->
										<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
										<td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
										<td GH="80 STD_LOTA05" GCol="select,LOTA05">				<!--포장구분-->
											<select class="input" CommonCombo="LOTA05"></select>
										</td>	
										<td GH="80 STD_LOTA06" GCol="select,LOTA06">
											<select class="input" CommonCombo="LOTA06"></select>		<!--재고유형-->
										</td>	
										<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="50 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td>	<!--작업타입-->		
			    						<td GH="80 STD_QTCOMP" GCol="input,QTCOMP" GF="N 20,0">완료수량</td>	<!--완료수량-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->					
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->			
			    						<td GH="50 STD_SUOMKY" GCol="text,SUOMKY,SHLOCMA" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="88 STD_QTSDUM" GCol="text,QTSDUM" GF="S 11">기본UPM</td>	<!--기본UPM-->						
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="88 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11">포장중량</td>	<!--포장중량-->
			    						<td GH="88 STD_NETWGT" GCol="text,NETWGT" GF="S 11">순중량</td>	<!--순중량-->
			    						<td GH="88 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="S 11">포장가로</td>	<!--포장가로-->
			    						<td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="S 11">포장세로</td>	<!--포장세로-->
			    						<td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="S 11">포장높이</td>	<!--포장높이-->
			    						<td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="S 11">CBM</td>	<!--CBM-->
			    						<td GH="88 STD_CAPACT" GCol="text,CAPACT" GF="S 11">CAPA</td>	<!--CAPA-->		
			    						<td GH="80 STD_LOTA03NM" GCol="text,LOTA03NM" GF="S 20">벤더명</td>	<!--벤더명-->
			    						<td GH="160 STD_SBKTXT" GCol="input,SBKTXT" GF="S 75">비고</td>	<!--비고-->
			    						<td GH="80 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 17,0">유통잔여(DAY)</td>	<!--유통잔여(DAY)-->
			    						<td GH="80 STD_DTREMRAT" GCol="text,DTREMRAT" GF="N 17,0">유통잔여(%)</td>	<!--유통잔여(%)-->
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