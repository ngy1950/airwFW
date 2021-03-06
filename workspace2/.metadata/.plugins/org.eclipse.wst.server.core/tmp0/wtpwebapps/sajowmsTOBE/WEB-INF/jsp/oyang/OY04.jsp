<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL01</title>
<%@ include file="/common/include/webdek/head.jsp"%>
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
	    	module : "OyangOutbound", 
			command : "OY04_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "SVBELN",
		    menuId : "OY04"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OyangOutbound",
			command : "OY04_ITEM",
		    colorType : true,
		    tempHead : "gridHeadList",
			useTemp : true,
			tempKey : "SVBELN",
		    menuId : "OY04"
	    });
		 
		//콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["WAREKY" , "OWNRKY", "C00103", "DOCUTY", "WARESR"]);
		//gridList.setReadOnly("gridItemList", true, ["WAREKY" ]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	//버튼작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "SetAll"){
			setAll();
		}else if(btnName == "SetChk"){
			setChk();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "OY04");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "OY04");
		}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			
			$('#btnSave').show();
			
			var param = inputList.setRangeDataParam("searchArea");
			param.put("WAREKY",$("#WAREKY").val());
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
			
// 			gridList.setReadOnly("gridHeadList", false, ["rowCheck","OTRQDT", "DIRDVY", "DIRSUP"]);
// 			gridList.setReadOnly("gridItemList", false, ["rowCheck","WAREKY", "QTYREQ", "C00103"]);
		}
	}
	
	//저장
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			//현제 포커스로우 가져오기
			var head = gridList.getSelectData("gridHeadList");
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			 
			//체크한 row중에 수정된 로우
			var item = gridList.getSelectModifyList("gridItemList");
// 			if(head.length == 0 && item.length == 0){
// 				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
// 				return;
// 			}
			
			 var tempItem = gridList.getTempData("gridHeadList");
			
			//ORDDAT 와 현재 날짜가 30일 이상 차이나면 저장 불가
			var sysdate = new Date(); 
			var orddat = strToDate(head[0].map.OTRQDT);
			if(Math.abs((orddat-sysdate)/1000/60/60/24) > 30){
				commonUtil.msgBox("DAERIM_DATECHK");
				return;
			}
			
			//item 저장불가 조건 체크
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
			
				//거점정보 체크
				if(itemMap.WAREKY.trim() == "" ){
					commonUtil.msgBox("DAERIM_WAREKNVL");
					return;
				}
			
				//사유코드 체크
				if(itemMap.WAREKY != itemMap.WARETG && itemMap.C00103.trim() == "" ){
					commonUtil.msgBox("DAERIM_C00103NVL");
					return;
				}
			
				//주문수량 체크
				if(Number(itemMap.WMSMGT) > 0){
					commonUtil.msgBox("DAERIM_WMSMGTNVL");
					return;
				}
				
				//출고여부체크
				if(Number(itemMap.QTSHPD) > 0 && itemMap.ORDTYP != "UB"){
					commonUtil.msgBox("DAERIM_QTSHPDNVL");
					return;
				}
				
				//주문수정수량 체크
				if(Number(itemMap.QTYREQ) > Number(itemMap.QTYORG)){
					commonUtil.msgBox("DAERIM_QTYREQVALID");
					return;
				}
			}
			
			//item 저장불가 조건 체크
			for(var i=0; i<tempItem.length; i++){
				var tempItemMap = tempItem[i].map;
			
				//거점정보 체크
				if(tempItemMap.WAREKY.trim() == "" ){
					commonUtil.msgBox("DAERIM_WAREKNVL");
					return;
				}
			
				//사유코드 체크
				if(tempItemMap.C00103.trim() == "" ){
					commonUtil.msgBox("DAERIM_C00103NVL");
					return;
				}
			
				//주문수량 체크
				if(Number(tempItemMap.WMSMGT) > 0){
					commonUtil.msgBox("DAERIM_WMSMGTNVL");
					return;
				}
				
				//출고여부체크
				if(Number(tempItemMap.QTSHPD) > 0 && tempItemMap.ORDTYP != "UB"){
					commonUtil.msgBox("DAERIM_QTSHPDNVL");
					return;
				}
				
				//주문수정수량 체크
				if(Number(tempItemMap.QTYREQ) > Number(tempItemMap.QTYORG)){
					commonUtil.msgBox("DAERIM_QTYREQVALID");
					return;
				}
			}
			
			var param  = inputList.setRangeDataParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			param.put("tempItem",tempItem)
			
	    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
		 	netUtil.send({
				url : "/OyangOutbound/json/saveOY04.data",
				param : param,
				successFunction : "successSaveCallBack"
			}); 
		}
	}

	//체크적용
	function setChk(){
		//인풋값 가져오기
		var warechk = $('#warechk').prop("checked");
		var rsnChk = $("#rsnchk").prop("checked");
		var qtychk = $("#qtychk").prop("checked");
		var result = "";

		if(!warechk && !rsnChk && !qtychk){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}
		
		//수정불가조건 체크 를 위해 체크박스 체크한 리스트만 들고온다.
		var itemList = gridList.getSelectData("gridItemList");

		for(var i=0; i<itemList.length; i++){
			
			// 출고(할당 이후) 작업 했을 시(wmsmgt,qtshpd > 0) 수정 불가
			if(Number(gridList.getColData("gridItemList", i, "WMSMGT")) > 0 || Number(gridList.getColData("gridItemList", i, "QTSHPD")) > 0){ 
				//수정불가 처리안함 
			}else{

				//출고작업지시하지 한 경우에만 적용
				if(gridList.getColData("gridItemList", i, "C00102") == 'Y'){

					//사유코드 변경 변경 체크했을 경우에만
					if(rsnChk){
						gridList.setColValue("gridItemList", itemList[i].get("GRowNum"), "C00103", $("#RSNCOMBO").val());
						//사유코드 gridChange이벤트를 강제발생시킨다.
						gridListEventColValueChange("gridItemList", itemList[i].get("GRowNum"), "C00103", $("#RSNCOMBO").val());
					}

					//수량 변경 변경 체크했을 경우에만
					if(qtychk){
						gridList.setColValue("gridItemList", itemList[i].get("GRowNum"), "QTYREQ", $("#INPUTQTY").val());
						//수량변경시 gridChange이벤트를 강제발생시킨다.
						gridListEventColValueChange("gridItemList", itemList[i].get("GRowNum"), "QTYREQ", $("#INPUTQTY").val());
					}
					
					//이고출고 거점수정 불가
					if(gridList.getColData("gridItemList", i, "DOCUTY") == '266' || gridList.getColData("gridItemList", i, "DOCUTY") == '267'){
						result = "이고주문 거점 변경 불가";
						//commonUtil.msgBox("이고주문 거점 변경 불가");	// 알림창이 계속 뜸으로 수정
					}else{
						//창고값 변경 변경 체크했을 경우에만
						if(warechk) gridList.setColValue("gridItemList", itemList[i].get("GRowNum"), "WAREKY", $("#WARECOMBO").val());
					}
				}
			}
		}
		
		if(result != ""){
			commonUtil.msgBox(result);
		}
	}

	//일괄적용 (데이터 수정시 체크박스가 체크되기 때문에 모든 로우를 체크후 setChk호출)
	function setAll(){
		//인풋값 가져오기
		var warechk = $('#warechk').prop("checked");
		var rsnChk = $("#rsnchk").prop("checked");

		if(!warechk && !rsnChk){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}
		
		gridList.checkAll("gridItemList",true);
		setChk();
	}
	
	//아이템그리드 조회
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			//row데이터 이외에 검색조건 추가가 필요할 떄 
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}else if(gridId == "gridHeadList" && dataCount > 0){

			//var headGridBox = gridList.getGridBox('gridHeadList');
			//var headList = headGridBox.getDataAll();
			//
			//for(var i=0; i<headList.length; i++){
			//	//출고작업지시하지 않았을 경우 행 수정 불가 (HEADER)
			//	if(gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "C00102") != 'Y'){
			//		gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), true, ["DIRDVY", "DIRSUP", "OTRQDT"]);
			//	}else{
			//		gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), false, ["DIRDVY", "DIRSUP", "OTRQDT"]);
			//	}
			//}
			
			
		}else if(gridId == "gridItemList" && dataCount > 0){

			var itemGridBox = gridList.getGridBox('gridItemList');
			var itemList = itemGridBox.getDataAll();
			
			for(var i=0; i<itemList.length; i++){
				
				//이고출고 거점수정 불가
				if(gridList.getColData("gridItemList", i, "DOCUTY") == '266' || gridList.getColData("gridItemList", i, "DOCUTY") == '267'){
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["WAREKY"]);
				}else{
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), false, ["WAREKY"]);
				}
				
				// 출고(할당 이후) 작업 했을 시(wmsmgt,qtshpd > 0) 수정 불가
				if(Number(gridList.getColData("gridItemList", i, "WMSMGT")) > 0 || Number(gridList.getColData("gridItemList", i, "QTSHPD")) > 0 || Number(gridList.getColData("gridItemList", i, "QTYREQ")) == 0){ 
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["WAREKY" , "QTYREQ", "C00103"]); 
				}else{
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), false, ["WAREKY" , "QTYREQ", "C00103"]);
				}

				
				//출고작업지시하지 않았을 경우 행 수정 불가 (ITEM)
				if(gridList.getColData("gridItemList", i, "C00102") != 'Y'){
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["WAREKY" , "QTYREQ", "C00103"]); 
				}else{
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), false, ["WAREKY" , "QTYREQ", "C00103"]); 
				}
			}

			//헤더 체크
			var headGridBox = gridList.getGridBox('gridHeadList');
			var headList = headGridBox.getDataAll();
			
			for(var i=0; i<headList.length; i++){
				//출고작업지시하지 않았을 경우 행 수정 불가 (HEADER)
				if(gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "C00102") == 'Y'){
					gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), false, ["DIRDVY", "DIRSUP", "OTRQDT"]);
				}else{
					gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), true, ["DIRDVY", "DIRSUP", "OTRQDT"]);
				}
			}
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("DOCUTY", "399");
			param.put("OWNRKY", "<%=ownrky%>");
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			return param;
		}else if( comboAtt == "SajoCommon,SEARCH_WAREKY_COMCOMBO" ){
			param.put("USERID", "<%=userid%>");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
		return param;
	}
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			 if(colName == "QTYREQ" || colName == "BOXQTY" || colName == "REMQTY"){ //수량변경시연결된 수량 변경
				var qtyreq = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
				var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
				var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
				var remqtyChk = 0;
				var totshp = 0;			//총출고수량
				var qtyreq2 = 0;		//납품요청수량(수정)
				
			  	if( colName == "QTYREQ" ) { //납품요청수량 변경시
					//납품요청수량과 원주문수량 비고
			  		if(Number(gridList.getColData(gridId, rowNum, "QTYREQ")) > Number(gridList.getColData(gridId, rowNum, "QTYORG"))){
						alert("* 납품요청수량이 원주문수량보다 큽니다. *");
						gridList.setColValue(gridId, rowNum, "QTYREQ", 0);
					}

				  	//박스 수량 등을 계산하여 각 컬럼에 세팅
				  	qtyreq = gridList.getColData(gridId, rowNum, "QTYREQ");
				  	boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
				  	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
				  	
				  	boxqty = floatingFloor((Number)(qtyreq)/(Number)(bxiqty), 1);
				  	remqty = (Number)(qtyreq)%(Number)(bxiqty);
				  	pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
				  	qtyreq2 = (Number)(qtyreq) - (Number)(gridList.getColData(gridId, rowNum, "QTSHPD"));
				  	totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(qtyreq2);
				  	
				  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "QTYREQ2", qtyreq2);
					gridList.setColValue(gridId, rowNum, "TOTSHP", totshp);
				  }
				  if( colName == "BOXQTY" ){ //박스수량 변경시
					//박스수량을 낱개수량으로 변경하여 계산한다.
				  	boxqty = colValue;
				  	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
				  	qtyreq = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty) + (Number)(gridList.getColData(gridId, rowNum, "QTSHPD"));
				  	qtyreq2 = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty);
				  	pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
				  	totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(qtyreq2);
				  	
				  	//수량 CHECK
				  	if(Number(qtyreq) > Number(gridList.getColData(gridId, rowNum, "QTYORG"))){
						alert("* 납품요청수량이 원주문수량보다 큽니다. *");
						gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
						boxqty = 0;
					  	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
					  	qtyreq = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty) + (Number)(gridList.getColData(gridId, rowNum, "QTSHPD"));
					  	qtyreq2 = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty);
					  	pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
					  	totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(qtyreq2);
					}
				  	
				  	//계산한 수량 세팅
				    gridList.setColValue(gridId, rowNum, "QTYREQ", qtyreq);
				    gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
				    gridList.setColValue(gridId, rowNum, "QTYREQ2", qtyreq2);
				    gridList.setColValue(gridId, rowNum, "TOTSHP", totshp);
				  }
				  if( colName == "REMQTY" ){ //잔량변경시
				  	qtyreq = gridList.getColData(gridId, rowNum, "QTYREQ");
				  	boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
				  	remqty = colValue;	
				  	
				  	//잔량으로 박스수량 등 계산
				  	remqtyChk = (Number)(remqty)%(Number)(bxiqty);
				  	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
				  	qtyreq = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
				  	qtyreq2 = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
				  	pltqty = floatingFloor((Number)(qtyreq2)/(Number)(pliqty), 2);
				  	totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(qtyreq2);
				  	
				  	//수량 CHECK
				  	if(Number(qtyreq) > Number(gridList.getColData(gridId, rowNum, "QTYORG"))){
						alert("* 납품요청수량이 원주문수량보다 큽니다. *");
						gridList.setColValue(gridId, rowNum, "REMQTY", 0);
						remqty = 0;
						remqtyChk = (Number)(remqty)%(Number)(bxiqty);
					  	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
					  	qtyreq = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
					  	qtyreq2 = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
					  	pltqty = floatingFloor((Number)(qtyreq2)/(Number)(pliqty), 2);
					  	totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(qtyreq2);
					}
				  	
				  	//수량 세팅
					gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);	
					gridList.setColValue(gridId, rowNum, "QTYREQ", qtyreq);
					gridList.setColValue(gridId, rowNum, "QTYREQ2", qtyreq2);
					gridList.setColValue(gridId, rowNum, "TOTSHP", totshp);	
				  }
				}
		}
	}

	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListRowColorChange(gridId, rowNum){
		if(gridId == "gridItemList"){
			//var colArr = gridList.gridMap.map.gridItemList.cols; //해당그리드의 컬럼 전체 가져오기
			//if(colArr.indexOf(colName)){
			// 가용재고보다 주문수량이 많을 시 글자색 변경
			if(Number(gridList.getColData("gridItemList", rowNum, "ORDTOT")) > Number(gridList.getColData("gridItemList", rowNum, "USEQTY"))){
				return configData.GRID_COLOR_TEXT_RED_CLASS;
			}
			//}
		}
	}
	
	//저장성공시 callback
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				
				$('#btnSave').hide();
				
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				var param = inputList.setRangeDataParam("searchArea");
				param.put("SVBELN", json.data["SVBELN"]);
				gridList.gridList({
			    	id : "gridHeadList",
			    	param : param
			    });
				
// 				gridList.setReadOnly("gridHeadList", true);
// 				gridList.setReadOnly("gridItemList", true);
				
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        
        if(searchCode == "SHWAHMA"){ //거점
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNROD"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
            param.put("CMCDKY","ASKU05");
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG03"){
            param.put("CMCDKY","SKUG03");
            param.put("OWNRKY",$("#OWNRKY").val());
        }else if(searchCode == "SHSKUMA"){
            param.put("OWNRKY",$("#OWNRKY").val());
            param.put("WAREKY", inputList.rangeMap.map["I.WAREKY"].singleData);
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
	<%@ include file="/common/include/webdek/layout.jsp"%>
	<!-- content -->
	<div class="content_wrap">
		<div class="content_inner">
			<%@ include file="/common/include/webdek/title.jsp"%>
			<div class="content_serch" id="searchArea">
				<div class="btn_wrap">
					<div class="fl_l">
						<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT"/>
					</div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" /> 
						<input type="button" CB="Save SAVE BTN_SAVE"  id="btnSave" /> 
						<input type="button" CB="Reload RESET STD_REFLBL" />
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
						<dl>  <!--출고지시여부-->  
							<dt CL="STD_C00102"></dt> 
							<dd> 
								<select name="C00102" id="ORDTYPE" class="input" CommonCombo="C00102_DR"></select>  
							</dd> 
						</dl> 
						<dl>  <!--거점-->  
							<dt CL="STD_WAREKY"></dt> 
							<dd> 
								<input type="text" class="input" name="I.WAREKY" UIInput="SR,SHWAHMA" value="<%=wareky %>"/> 
							</dd> 
						</dl> 
						<dl>  <!--S/O 번호-->  
							<dt CL="IFT_SVBELN"></dt> 
							<dd> 
								<input type="text" class="input" name="I.SVBELN" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고유형-->  
							<dt CL="IFT_DOCUTY"></dt> 
							<dd> 
								<input type="text" class="input" name="I.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
							</dd> 
						</dl>  
						<dl>  <!--납품요청일 -->  
							<dt CL="STD_VDATU"></dt> 
							<dd> 
								<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
						<dl>  <!--주문구분-->  
							<dt CL="IFT_DIRSUP"></dt> 
							<dd> 
								<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--배송구분-->  
							<dt CL="IFT_DIRDVY"></dt> 
							<dd> 
								<input type="text" class="input" name="I.DIRDVY" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl>
						<dl>  <!--차수-->  
							<dt CL="IFT_N00105"></dt> 
							<dd> 
								<input type="text" class="input" name="I.N00105" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--납품처코드-->  
							<dt CL="IFT_PTNRTO"></dt> 
							<dd> 
								<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!--매출처코드-->  
							<dt CL="IFT_PTNROD"></dt> 
							<dd> 
								<input type="text" class="input" name="I.PTNROD" UIInput="SR,SHBZPTN"/> 
							</dd> 
						</dl> 
						<dl>  <!--차량번호-->  
							<dt CL="STD_CARNUM"></dt> 
							<dd> 
								<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHCARMA2"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="IFT_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--소분류-->  
							<dt CL="STD_SKUG03"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.SKUG03" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--상온구분-->  
							<dt CL="STD_ASKU05"></dt> 
							<dd> 
								<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more" onclick="searchMore()" />
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
			    						<td GH="80 IFT_OWNRKY" GCol="select,OWNRKY"><!--화주-->
												<select class="input" Combo="SajoCommon,OWNRKYNM_COMCOMBO"></select>
			    						</td>	
			    						<td GH="60 IFT_N00105" GCol="text,N00105" GF="N 18,0">차수</td>	<!--차수-->
			    						<td GH="60 IFT_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="70 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
			    						<td GH="120 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
			    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
			    						<td GH="120 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td>	<!--매출처명-->
			    						<td GH="100 IFT_DOCUTY" GCol="select,DOCUTY"><!--출고유형-->
			    							<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
			    						</td>	
			    						<td GH="80 IFT_C00103" GCol="select,C00103"><!--`-->
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"></select>
			    						</td>	
			    						<td GH="70 STD_VDATU" GCol="input,OTRQDT" GF="C"></td><!--납품요청일 -->	
			    						<td GH="90 IFT_DIRDVY" GCol="select,DIRDVY"><!--배송구분-->
												<select class="input" commonCombo="PGRC02"></select>
			    						</td>	
			    						<td GH="90 IFT_DIRSUP" GCol="select,DIRSUP">	<!--주문구분-->
												<select class="input" commonCombo="PGRC03"></select>
			    						</td>
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="70 IFT_BOXQTYORG" GCol="text,BOXQTY" GF="N 13,1">원주문수량(BOX)</td>	<!--원주문수량(BOX)-->
			    						<td GH="70 IFT_BOXQTYREQ" GCol="text,BXIQTY" GF="N 13,1">납품요청수량(BOX)</td>	<!--납품요청수량(BOX)-->
			    						<td GH="80 STD_PTNG08" GCol="text,PTNG08NM" GF="S -2">마감구분</td>	<!--마감구분-->
			    						<td GH="50 IFT_C00102" GCol="text,C00102" GF="S 100">승인여부</td>	<!--승인여부-->
			    						<td GH="100 IFT_WARESR" GCol="select,WARESR"><!--요구사업장-->
												<select class="input" commonCombo="PTNG06"><option></option></select>
										</td>	
			    						<td GH="70 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td>	<!--영업사원명-->
			    						<td GH="80 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td>	<!--영업사원 전화번호-->
			    						<td GH="100 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	<!--비고-->
			    						<td GH="80 STD_DEWARE" GCol="text,NAME03B" GF="S 80">기본출고거점</td>	<!--기본출고거점-->
			    						<td GH="80 STD_ERDAT" GCol="text,XDATS" GF="D 10">지시일자</td>	<!--지시일자-->
			    						<td GH="80 STD_RQARRT" GCol="text,XTIMS" GF="T 10">지시시간</td>	<!--지시시간-->
			    						<td GH="80 IFT_CUSRID" GCol="text,CUSRID" GF="S 20">배송고객 아이디</td>	<!--배송고객 아이디-->
			    						<td GH="80 IFT_CUNAME" GCol="text,CUNAME" GF="S 35">배송고객명</td>	<!--배송고객명-->
			    						<td GH="80 IFT_CUPOST" GCol="text,CUPOST" GF="S 10">배송지 우편번호</td>	<!--배송지 우편번호-->
			    						<td GH="80 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td>	<!--배송지 주소-->
			    						<td GH="80 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td>	<!--거래처 담당자명-->
			    						<td GH="80 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td>	<!--거래처 담당자 전화번호-->
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
					<li><a href="#tab1-1" ><span>상세내역</span></a></li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 20PX 0 15px;">
						<input type="checkbox" id="warechk" style="VERTICAL-ALIGN: MIDDLE;"/> 
						<span CL="IFT_WAREKY" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<select name="WARECOMBO" id="WARECOMBO"  class="input" Combo="SajoCommon,SEARCH_WAREKY_COMCOMBO" ComboCodeView="true"><option></option></select>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX"> <!-- 사유코드 -->
						<input type="checkbox" id="rsnchk" style="VERTICAL-ALIGN: MIDDLE;"/> 
						<span CL="IFT_C00103" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<select name="RSNCOMBO" id="RSNCOMBO"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true"><option></option></select>
					</li>
					<li style="TOP: 4PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 10PX"> <!-- 일괄적용 -->
						<input type="button" CB="SetAll SAVE BTN_ALL" /> 
					</li>
					<li style="TOP: 4PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
						<input type="button" CB="SetChk SAVE BTN_PART" />
					</li>
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
			    						<td GH="70 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="60 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td>	<!--주문아이템번호-->
			    						<td GH="150 IFT_WAREKY" GCol="select,WAREKY"> <!--WMS거점(출고사업장)-->
											<select class="input" Combo="SajoCommon,OY_WAREKYNM_COMCOMBO"></select>
										</td>	
			    						<td GH="70 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="50 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">요청수량</td>	<!--요청수량-->
			    						<td GH="50 IFT_QTYREQ" GCol="input,QTYREQ" GF="N 13,1">납품요청수량</td>	<!--납품요청수량-->
			    						<td GH="50 STD_ORDTOT" GCol="text,ORDTOT" GF="N 13,0">누적주문수량</td>	<!--누적주문수량-->
			    						<td GH="50 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="50 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="50 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="50 STD_QTSDIF" GCol="text,USEQTY" GF="N 13,0">가용재고</td>	<!--가용재고-->
			    						<td GH="50 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS관리수량</td>	<!--WMS관리수량-->
			    						<td GH="50 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td>	<!--출하수량-->
			    						<td GH="100 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	<!--비고-->
			    						<td GH="80 IFT_C00102" GCol="text,C00102" GF="S 100">승인여부</td>	<!--승인여부-->
			    						<td GH="80 IFT_C00103" GCol="select,C00103">
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"><option></option></select>
			    						</td>	<!--사유코드-->
			    						<td GH="80 IFT_LMODAT" GCol="text,LMODAT" GF="D 8">LMODAT</td>	<!--LMODAT-->
			    						<td GH="80 IFT_LMOTIM" GCol="text,LMOTIM" GF="T 6">LMOTIM</td>	<!--LMOTIM-->
			    						<td GH="80 IFT_STATUS" GCol="text,STATUS" GF="S 1">C:신규,M:변경,D:삭제)</td>	<!--C:신규,M:변경,D:삭제)-->
			    						<td GH="80 IFT_TDATE" GCol="text,TDATE" GF="D 14">yyyymmddhhmmss(생성일자)</td>	<!--yyyymmddhhmmss(생성일자)-->
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
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>