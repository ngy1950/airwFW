<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL43</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OutBoundPicking",
			command : "DL43_HEAD",
			pkcol : "OWNRKY,WAREKY,TASKKY",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "DL43",
		    colorType : true
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OutBoundPicking",
			command : "DL43_ITEM_SAVE",
		    menuId : "DL43"
	    });	

		//콤보박스 리드온리 출력여부 
		gridList.setReadOnly("gridHeadList", true, ["DNAME3","PICKED"]);
		
		//CARDAT 하루 더하기 
		inputList.rangeMap["map"]["SR.CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		
		//작업타입 배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "210");
		var rangeDataMap2 = new DataMap();
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "208");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);		
		rangeArr.push(rangeDataMap2);		
		setSingleRangeData('TASDH.TASOTY', rangeArr);


		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});


	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			var param = inputList.setRangeDataParam("searchArea");
			
			//라디오 버튼 값
			if ($('#GRPRL1').prop("checked") == true ) {
				param.put("GRPRL","ERPSO");
			}else if ($('#GRPRL3').prop("checked") == true ){
				param.put("GRPRL","MOVE");
			}else if ($('#GRPRL4').prop("checked") == true ){
				param.put("GRPRL","RTNPUR");
			};

			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "101");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
				
			}else if( name == "OPTION" ){
				param.put("CMCDKY", "ZONEKY");
				
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			return param;
		}
		return param;
	}
	
	function saveData(gbn){
		//피킹완료(전체)
		if(gbn == "cfmall"){
			// "피킹완료(전체)하겠습니까?"
			if(!commonUtil.msgConfirm("SYSTEM_PICKINGALL")){ 
				return; 
			}
			if(!checkGroupingNumberCALL()){
				gridList.checkAll("gridHeadList", true);
				//return false;
			}
		}
		
		var head = gridList.getSelectData("gridHeadList", true);
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		//피킹번호 체번 체크
		for(var i=0; i<head.length; i++){
			var sdifky = head[i].get("SDIFKY");
			if("" == sdifky || " " == sdifky){
				commonUtil.msgBox("그룹핑을 먼저 해주세요.");
				return;
			}
		}
		
		if(gridList.validationCheck("gridHeadList", "select")){
			var item = gridList.getSelectData("gridItemList", true);
			var param = inputList.setRangeDataParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/OutBoundPicking/json/saveDL43.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function saveDL43New(gbn){
		//피킹완료(전체)
		if(gbn == "cfmall"){
			// "피킹완료(전체)하겠습니까?"
			if(!commonUtil.msgConfirm("SYSTEM_PICKINGALL")){ 
				return; 
			}
			if(!checkGroupingNumberCALL()){
				gridList.checkAll("gridHeadList", true);
				//return false;
			}
		}
		
		var head = gridList.getSelectData("gridHeadList", true);
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		//피킹번호 체번 체크
		for(var i=0; i<head.length; i++){
			var sdifky = head[i].get("SDIFKY");
			if("" == sdifky || " " == sdifky){
				commonUtil.msgBox("그룹핑을 먼저 해주세요.");
				return;
			}
		}
		
		if(gridList.validationCheck("gridHeadList", "select")){
			var item = gridList.getSelectData("gridItemList", true);
			var param = inputList.setRangeDataParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/OutBoundPicking/json/saveDL43New.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
		
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "DEL"){
				commonUtil.msgBox("SYSTEM_DELETEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else if(json.data["RESULT"] == "Em"){
				commonUtil.msgBox("SYSTEM_GROUPINGS");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}	
	
	//버튼 동작 연결
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Grouping"){
			grouping('check'); //피킹리스트 그룹핑
		}else if(btnName == "GroupAll"){
			grouping('all'); //그룹핑(전체)
		}else if(btnName == "DelGroup"){
			delGroup(); //피킹리스트 그룹핑삭제
		}else if(btnName == "Print"){
			print(); //피킹리스트 인쇄
		}else if(btnName == "PrintAll"){
			printall(); //인쇄(전체)
		}else if(btnName == "Confirm"){
			saveData(); //피킹완료
		}else if(btnName == "ConfirmNew"){
			
			saveDL43New();
			
		}else if(btnName == "ConfirmAll"){
			
			
			saveData('cfmall'); //피킹완료(전체)
		
		}else if(btnName == "ConfirmNewAll"){
			
			saveDL43New('cfmall');
			
		}
		else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "DL43");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "DL43");
 		}
		
	}
	
	//피킹리스트그룹핑
	function grouping(gbn){
		if(gridList.validationCheck("gridHeadList", "select")){
			//그룹핑(전체)
			if(gbn == "all"){
				// "그룹핑(전체)하겠습니까?"
				if(!commonUtil.msgConfirm("SYSTEM_GROUPALL")){ 
					return;
				}
				if(!checkGroupingNumberIALL()){
					gridList.checkAll("gridHeadList", true);
				}
			}
			
			var head3 = gridList.getSelectData("gridHeadList", true);
			//var headList = gridList.getSelectData("gridHeadList");
			
			//차량별피킹번호 없는 row만 넘겨준다 	
			var head2 = gridList.getSelectData("gridHeadList", true);
			var head = head2.filter(function (e) {
			    return e.get("SDIFKY") == "" || e.get("SDIFKY") == " ";
			});
			
		
			
			//체크가 없을 경우 
			if(head3.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			/* 작업자피킹번호가 존재하는지 체크 */
			for(var i=0; i<head3.length; i++){
				var itemMap = head3[i].map;
				
				if(itemMap.SDIFKY.trim() != ""){
					commonUtil.msgBox("작업자별피킹번호가 이미 존재합니다.");
					gridList.setColFocus("gridHeadList", i, "SDIFKY");
					return;
				}
			}
			
			var item = gridList.getSelectData("gridItemList", true);
			var param = inputList.setRangeDataParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/OutBoundPicking/json/groupingDL43.data",  
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	
	//피킹리스트 그룹핑삭제
	function delGroup(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var item = gridList.getSelectData("gridItemList", true);
			
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/OutBoundPicking/json/delGroupDL43.data",  
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	
	//ezgen 피킹리스트 인쇄, 인쇄전체
	function print(gbn){
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인

			var head = gridList.getSelectData("gridHeadList", true);
			var item = gridList.getSelectData("gridItemList", true);
			var param = inputList.setRangeDataParam("searchArea");
			
			param.put("item",item);

			var headList = new Array();
			for(var i =0;i < head.length ; i++){
				if(head[i].get("SDIFKY") && head[i].get("SDIFKY") != "" && head[i].get("SDIFKY") != " "){
					headList.push(head[i]);
				}
			}
			param.put("head",headList);
			
			
 			netUtil.send({
 				url : "/OutBoundPicking/json/printDL43.data",
 				param : param,
 				successFunction : "returnPrint"
 			});
		}
	}
	

	//피킹리스트 인쇄 prt 		
	function returnPrint(){
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
		
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var where = " AND TI.SDIFKY IN (";
			
			for(var i =0;i < head.length ; i++){
				where += "'" + head[i].get("SDIFKY") + "'";
				if(i+1 < head.length){
					where += ",";
				}
				
				//그룹핑번호 체크 
				if(head[i].get("SDIFKY") == "" || head[i].get("SDIFKY") == 0){
					commonUtil.msgBox("VALID_NOTGROUP");
					return;
				}
			}
			where += ")";
			
			where += getMultiRangeDataSQLEzgen('SR.CARDAT', 'CARDAT');
			where += getMultiRangeDataSQLEzgen('SR.SHIPSQ', 'SHIPSQ');
			
			//이지젠 호출부(신버전)
			var langKy = "KO";
			var map = new DataMap();
			var width = 840;
			var height = 600;
			map.put("i_option",$('#OPTION').val());
			WriteEZgenElement("/ezgen/picking_list_work2.ezg" , where , "" , langKy, map , width , height );
		}
	}
	
	
	//인쇄전체
	function printall(){
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			//인쇄(전체)
			if(!checkGroupingNumberALL()){
				gridList.checkAll("gridHeadList", true);
				//return false;
			}

			var head = gridList.getSelectData("gridHeadList", true);
			var item = gridList.getSelectData("gridItemList", true);
			var param = inputList.setRangeDataParam("searchArea");
			param.put("item",item);

			var headList = new Array();
			for(var i =0;i < head.length ; i++){
				if(head[i].get("SDIFKY") && head[i].get("SDIFKY") != "" && head[i].get("SDIFKY") != " "){
					headList.push(head[i]);
				}
			}
			param.put("head",headList);
			
 			netUtil.send({
 				url : "/OutBoundPicking/json/printDL43.data",
 				param : param,
 				successFunction : "returnPrintAll"
 			});
		}
	}
	

	//피킹리스트 인쇄 prt 		
	function returnPrintAll(){
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			//인쇄(전체)
			if(!checkGroupingNumberALL()){
				gridList.checkAll("gridHeadList", true);
				//return false;
			}
		
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var where = " AND TI.SDIFKY IN (";
			
			for(var i =0;i < head.length ; i++){
				where += "'" + head[i].get("SDIFKY") + "'";
				if(i+1 < head.length){
					where += ",";
				}
				
				//그룹핑번호 체크 
				if(head[i].get("SDIFKY") == "" || head[i].get("SDIFKY") == 0){
					commonUtil.msgBox("VALID_NOTGROUP");
					return;
				}
			}
			where += ")";
			
			where += getMultiRangeDataSQLEzgen('SR.CARDAT', 'CARDAT');
			where += getMultiRangeDataSQLEzgen('SR.SHIPSQ', 'SHIPSQ');
			
			//이지젠 호출부(신버전)
			var langKy = "KO";
			var map = new DataMap();
			var width = 840;
			var height = 600;
			map.put("i_option",$('#OPTION').val());
			WriteEZgenElement("/ezgen/picking_list_work2.ezg" , where , "" , langKy, map , width , height );
		}
	}
	
	// all (그룹핑 전체)
	function checkGroupingNumberIALL(){
		var list = gridList.getRowNumList("gridHeadList");
		
		for(var i=0;i<list.length;i++){
			if($.trim(gridList.getColData("gridHeadList", list[i], "SDIFKY")) != "" || $.trim(gridList.getColData("gridHeadList", list[i], "SDIFKY")) != "0"){
				return false;
			}
		}
		return true;
	}
	
	// prtall (인쇄전체)
	function checkGroupingNumberALL(){
		var list = gridList.getRowNumList("gridHeadList");
		
		for(var i=0;i<list.length;i++){
			if($.trim(gridList.getColData("gridHeadList", list[i], "SDIFKY")) != "" || $.trim(gridList.getColData("gridHeadList", list[i], "SDIFKY")) != "0"){
				return false;
			}
		}
		return true;
	}
	
	// cfmall (피킹완료전체)
	function checkGroupingNumberCALL(){
		var list = gridList.getRowNumList("gridHeadList");
		
		for(var i=0;i<list.length;i++){
			if($.trim(gridList.getColData("gridHeadList", list[i], "SDIFKY")) != "" || $.trim(gridList.getColData("gridHeadList", list[i], "SDIFKY")) != "0"){
				return false;
			}
		}
		return true;
	}
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();

	    //작업타입
		if(searchCode == "SHDOCTM" && $inputObj.name == "TASDH.TASOTY"){
			param.put("DOCCAT","300");
		//동
		} else if(searchCode == "SHAREMA" && $inputObj.name == "S.AREAKY"){
			param.put("WAREKY","<%=wareky %>");
		}
		return param;
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
	function gridListRowColorChange(gridId, rowNum){
		if(gridId == "gridHeadList"){
			//출력하면 빨강
			if(gridList.getColData("gridHeadList", rowNum, "DNAME3") == 'V'){
				return configData.GRID_COLOR_TEXT_RED_CLASS;
			}
			//}
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
				var qttaor = Number(gridList.getColData(gridId, rowNum, "QTTAOR"));
				var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
				var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
				var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
				var grswgtcnt = Number(gridList.getColData(gridId, rowNum, "GRSWGTCNT"));
				var remqtyChk = 0;
								
				if( colName == "QTCOMP" ) {
				    
					qtcomp = colValue;
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
					remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
					boxqty = floatingFloor((Number)(qtcomp)/(Number)(bxiqty), 1);
					remqty = (Number)(qtcomp)%(Number)(bxiqty);
					pltqty = floatingFloor((Number)(qtcomp)/(Number)(pliqty), 2);
					grswgt = qtcomp * grswgtcnt;
					
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty  );
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty  );
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty  );
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt  );
				  	
				}
				if( colName == "BOXQTY" ){ 
					boxqty = colValue;
					remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
					qtcomp = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty);
					pltqty = floatingFloor((Number)(qtcomp)/(Number)(pltqty), 2);
					grswgt = qtcomp * grswgtcnt;
									
					gridList.setColValue(gridId, rowNum, "QTCOMP", qtcomp);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
					
				}
				if( colName == "REMQTY" ){
					qtcomp = Number(gridList.getColData(gridId, rowNum, "QTCOMP"));
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
					remqty = colValue;	
					 	
					remqtyChk = (Number)(remqty)%(Number)(bxiqty);
					boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
					qtcomp = boxqty * bxiqty + remqtyChk;
					pltqty = floatingFloor((Number)(qtcomp)/(Number)(pltqty), 2);
					grswgt = qtcomp * grswgtcnt;
					
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "QTCOMP", qtcomp);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				}
				
				if( qtcomp > qttaor ) {
					commonUtil.msgBox("TASK_M0036");
			    	gridList.setColValue(gridId, rowNum, "QTCOMP", 0 );
					gridList.setColValue(gridId, rowNum, "BOXQTY", 0 );
					gridList.setColValue(gridId, rowNum, "REMQTY", 0 );
					gridList.setColValue(gridId, rowNum, "PLTQTY", 0 ); //팔레트수량
					gridList.setColValue(gridId, rowNum, "GRSWGT", 0 );
			    	return false ;
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
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Grouping GROUPING STD_PICKINGROUP" /> <!-- 피킹리스트 그룹핑 -->
					<input type="button" CB="GroupAll GROUPING STD_GROUP_ALL" /> <!-- 그룹핑(전체) -->
					<input type="button" CB="DelGroup DELGROUP STD_PICKINGDEL" /> <!-- 피킹리스트 그룹핑 삭제 -->
					<input type="button" CB="Print PRINT_OUT BTN_PRINT_PKLIST" /> <!-- 피킹리스트 (인쇄)-->
					<input type="button" CB="PrintAll PRINT_OUT BTN_PRINT_ALL" /> <!-- 인쇄(전체)-->
					<!-- <input type="button" CB="Confirm CONFIRM STD_PICKYN" /> 피킹완료
					<input type="button" CB="ConfirmAll CONFIRM STD_PICKYN_ALL" /> 피킹완료(전체) -->
					<input type="button" CB="ConfirmNew CONFIRM STD_PICKYNEW" /> <!-- 피킹완료(속도개선)-->
					<input type="button" CB="ConfirmNewAll CONFIRM STD_PICKYNEWALL" /> <!-- 피킹완료전체(속도개선)-->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
						
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" validate="required"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_GROUP"></dt> <!-- 그룹 -->
						<dd style="width:300px">
							<input type="radio" name="GRPRL" id="GRPRL1" value="GRPRL1" checked /><label for="GRPRL1">영업(D/O)</label>
		        			<input type="radio" name="GRPRL" id="GRPRL3" value="GRPRL3"/><label for="GRPRL3">이고(Move)</label>
		        			<input type="radio" name="GRPRL" id="GRPRL4" value="GRPRL4"/><label for="GRPRL4">매입반품(P/R)</label>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TASKDT"></dt> <!-- 작업지시일자 -->
						<dd>
							<input type="text" class="input" name="TASDH.DOCDAT" UIInput="B" UIFormat="C N"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_CARDAT"></dt> <!-- 배송일자 -->
						<dd>
							<input type="text" class="input" name="SR.CARDAT" UIInput="B" UIFormat="C"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHIPSQ"></dt> <!-- 배송차수 -->
						<dd>
							<input type="text" class="input" name="SR.SHIPSQ" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SVBELN"></dt> <!-- S/O 번호 -->
						<dd>
							<input type="text" class="input" name="S.SVBELN" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHPOKY"></dt> <!-- 출고문서번호 -->
						<dd>
							<input type="text" class="input" name="S.SHPOKY" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TASOTY"></dt> <!-- 작업타입 -->
						<dd>
							<input type="text" class="input" name="TASDH.TASOTY" UIInput="SR,SHDOCTM" value="210" readonly/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TASKKY"></dt> <!-- 작업지시번호 -->
						<dd>
							<input type="text" class="input" name="TASDH.TASKKY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SDIFKY"></dt> <!-- 작업자별 피킹번호 -->
						<dd>
							<input type="text" class="input" name="S.SDIFKY" UIInput="SR"/>
						</dd>
					</dl>					
					<dl>
						<dt CL="STD_AREAKY"></dt> <!-- 동 -->
						<dd>
							<input type="text" class="input" name="S.AREAKY" UIInput="SR,SHAREMA"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_CARNUM"></dt> <!-- 차량번호 -->
						<dd>
							<input type="text" class="input" name="SR.CARNUM" UIInput="SR" />
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING-RIGHT: 20PX";><span CL="STD_PRINTOPT1" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;">   </span>
					<select name="OPTION" id="OPTION"  class="input" Combo="SajoCommon,CMCDV_COMBO" ComboCodeView="true" ></select></li>
					 <li>
					 	<p style="width:80% white-space:nowrap;">1. 피킹리스트 인쇄는 그룹핑번호(제품별피킹번호)가 있을 경우에만 출력 가능합니다. </p>
						<p style="width:80% white-space:nowrap;">2. 완료처리된 수량이 있을 경우에는 그룹핑 할 수 없습니다.</p>
					</li>
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
								        <td GH="120 STD_SDIFKY" GCol="text,SDIFKY" GF="S 50">작업자별피킹번호</td> <!--작업자별피킹번호-->
								        <td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 20">거점</td> <!--거점-->
								        <td GH="120 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 20">거점명</td> <!--거점명-->
								        <td GH="80 STD_WORKNM" GCol="text,WORKNM" GF="S 20">작업자명</td> <!--작업자명-->
								        <td GH="100 STD_CARDAT" GCol="text,CARDAT" GF="D 20">배송일자</td> <!--배송일자-->
								        <td GH="120 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td> <!--차량번호-->
								        <td GH="160 STD_CARNUMNM" GCol="text,CARNUMNM" GF="S 100">차량정보</td> <!--차량정보-->
								        <td GH="80 STD_DRIVER" GCol="text,DRIVER" GF="S 20">기사명</td> <!--기사명-->
								        <td GH="80 STD_SHIPSQ" GCol="text,SHIPSQ" GF="S 20">배송차수</td> <!--배송차수-->
								        <td GH="50 STD_COMPLETECNT" GCol="text,COMPLETECNT" GF="S 8">completeCnt</td> <!--completeCnt-->
								        <td GH="50 STD_BOXQTYSQ" GCol="text,BOXQTY" GF="N 8,1">박스수량합계(미처리)</td> <!--박스수량합계(미처리)-->
										<td GH="120 STD_PRITYN2" GCol="check,DNAME3">출력상태</td>	<!--출력상태-->
										<td GH="120 STD_PICKED" GCol="check,PICKED">피킹완료</td>	<!--피킹완료-->
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
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>
										<td GH="120 STD_SDIFIT" GCol="text,SDIFIT" GF="S 50">작업자별피킹아이템</td> <!--작업자별피킹아이템-->
										<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td> <!--로케이션-->
										<td GH="160 STD_GUBUN" GCol="text,LOCAKYNM" GF="S 100">구분</td> <!--구분-->
										<td GH="88 STD_SKUKEY" GCol="text,SKUKEY" GF="S 60">제품코드</td> <!--제품코드-->
										<td GH="88 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td> <!--제품명-->
										<td GH="88 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td> <!--규격-->
										<td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td> <!--작업수량-->
										<td GH="80 STD_QTCOMP" GCol="input,QTCOMP" GF="N 20,0">완료수량</td> <!--완료수량-->
										<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td> <!--팔렛당수량-->
										<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
										<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td> <!--팔레트수량-->
										<td GH="80 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
										<td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td> <!--상태-->
										<td GH="120 STD_SDIFKY" GCol="text,SDIFKY" GF="S 50">작업자별피킹번호</td> <!--작업자별피킹번호-->
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