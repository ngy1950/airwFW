<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL17</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<style>
	.red{color: red !important; }
	.black{color: black !important; }
</style>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	var SVBELNS = '';

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Outbound", 
			command : "DL17_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "SVBELN",
		    menuId : "DL17"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Outbound",
			command : "DL17_ITEM",
			pkcol : "OWNRKY,WAREKY",
			emptyMsgType : false,
		    tempKey : "SVBELN",
		    useTemp : true,
			tempHead : "gridHeadList",
		    menuId : "DL17"
	    });
		 
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());

		//IF.OTRQDT 하루 더하기 
		inputList.rangeMap["map"]["OTRQDT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		inputList.rangeMap["map"]["OTRQDT"].valueChange();

		//콤보박스 리드온리
//		gridList.setReadOnly("gridItemList", false, ["C00103"]);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchwareky(val){
		var param = new DataMap();
		param.put("OWNRKY",val);
		
		var json = netUtil.sendData({
			module : "SajoCommon",
			command : "WAREKY_COMCOMBO",
			sendType : "list",
			param : param
		});
		
		$("#WAREKY").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#WAREKY").append(optionHtml);
	}
	
	//버튼작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			SVBELNS = "";
			searchList();
		}else if(btnName == "Close"){
			close();
		}else if(btnName == "SetAll"){
			setAll();
		}else if(btnName == "SetChk"){
			setChk();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL17");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL17");
		}
	}
	
	//조회
	function searchList(){
		gridList.resetGrid("gridItemList");
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			if (SVBELNS != "") {
				param.put('SVBELNS',SVBELNS);
				
			}
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
		//사유코드 부분적용 초기화 
		$("#RSNCOMBO").val("선택");
	}
	
	//저장
	function close(){
        var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getSelectData("gridItemList");
        //아이템 템프 가져오기
        var tempItem = gridList.getTempData("gridHeadList")
          
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
    	for(var i=0; i<item.length; i++){	
			var c00103 = item[i].get("C00103");
			
			if(c00103.trim() == "" || c00103.trim() == "N"){
				alert("* 사유코드는 필수 입력 입니다. *"); 
				return;
			}
		}
        if(confirm("S/O마감 하시겠습니까?")) {
            var param = inputList.setRangeDataParam("searchArea");
    		param.put("head",head);
    		param.put("item",item);
    		param.put("itemTemp",tempItem);

    		netUtil.send({
    			url : "/outbound/json/closeDL17.data",
    			param : param,
    			successFunction : "successSaveCallBack"
    		});		
    	}
	}

	//체크적용
	function setChk(){
		//인풋값 가져오기
		var rsnchk = $('#rsnchk').prop("checked");
		if(!rsnchk){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}
				
		//수정불가조건 체크 를 위해 체크박스 체크한 리스트만 들고온다.

		var list = gridList.getSelectData("gridItemList");

		for(var i=0; i<list.length; i++){		
//			var c00103 = gridList.getColData("gridItemList", i, "C00103");		
		
//			if(c00103 == '' || c00103 == ' '){			
//					commonUtil.msgBox(" D/O마감 시 사유코드는 필수 입력 입니다. *");
//					return;								
//			}else{
				//변경 체크했을 경우에만
				if(rsnchk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "C00103", $("#RSNCOMBO").val());				
//			}
		}
	}

	//일괄적용 (데이터 수정시 체크박스가 체크되기 때문에 모든 로우를 체크후 setChk호출)
	function setAll(){
		
		var rsnchk = $('#rsnchk').prop("checked");

		if(!rsnchk){
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
			if (SVBELNS != "") {
				param.put('SVBELNS',SVBELNS);
				
			}
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

			var headGridBox = gridList.getGridBox('gridHeadList');
			var headList = headGridBox.getDataAll();
			
			for(var i=0; i<headList.length; i++){
				//출고작업지시하지 않았을 경우 행 수정 불가 (HEADER)
				if(gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "C00102") != 'Y'){
					gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), true, ["DIRDVY", "DIRSUP", "ORDDAT"]);
				}else{
					gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), false, ["DIRDVY", "DIRSUP", "ORDDAT"]);
				}
			}
			
			
		}else if(gridId == "gridItemList" && dataCount > 0){

			var itemGridBox = gridList.getGridBox('gridItemList');
			var itemList = itemGridBox.getDataAll();
			
/* 			for(var i=0; i<itemList.length; i++){
				
				//이고출고 거점수정 불가
				if(gridList.getColData("gridItemList", i, "DOCUTY") == '266' || gridList.getColData("gridItemList", i, "DOCUTY") == '267'){
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["WAREKY"]);
				}else{
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), false, ["WAREKY"]);
				}
				
				// 출고(할당 이후) 작업 했을 시(wmsmgt,qtshpd > 0) 수정 불가
				if(Number(gridList.getColData("gridItemList", i, "WMSMGT")) > 0 || Number(gridList.getColData("gridItemList", i, "QTSHPD")) > 0){ 
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
				if(gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "C00102") != 'Y'){
					gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), true, ["DIRDVY", "DIRSUP", "ORDDAT"]);
				}else{
					gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), false, ["DIRDVY", "DIRSUP", "ORDDAT"]);
				}
			}
			*/
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("DOCUTY", "399");
			param.put("OWNRKY", $("#OWNRKY").val());
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			return param;
		}else if( comboAtt == "SajoCommon,SEARCH_WAREKY_COMCOMBO" ){
			param.put("USERID", "<%=userid%>");
			param.put("OWNRKY", $("#OWNRKY").val());
			return param;
		}
		return param;
	}
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			if(colName == "QTSHPO" || colName == "BOXQTY" || colName == "REMQTY"){
				var QTSHPO = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
				var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
				var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
				var remqtyChk = 0;
				var totshp = 0;			//총출고수량
				var QTSHPO2 = 0;		//납품요청수량(수정)
				
			  	if( colName == "QTSHPO" ) { //납품요청수량 변경시
					//납품요청수량과 원주문수량 비고
			  		if(Number(gridList.getColData(gridId, rowNum, "QTSHPO")) > Number(gridList.getColData(gridId, rowNum, "QTYORG"))){
						alert("* 납품요청수량이 원주문수량보다 큽니다. *");
						gridList.setColValue(gridId, rowNum, "QTSHPO", 0);
					}

				  	//박스 수량 등을 계산하여 각 컬럼에 세팅
				  	QTSHPO = gridList.getColData(gridId, rowNum, "QTSHPO");
				  	boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
				  	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
				  	
				  	boxqty = floatingFloor((Number)(QTSHPO)/(Number)(bxiqty), 1);
				  	remqty = (Number)(QTSHPO)%(Number)(bxiqty);
				  	pltqty = floatingFloor((Number)(QTSHPO)/(Number)(pliqty), 2);
				  	QTSHPO2 = (Number)(QTSHPO) - (Number)(gridList.getColData(gridId, rowNum, "QTSHPD"));
				  	totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(QTSHPO2);
				  	
				  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "TOTSHP", totshp);
				  }
				  if( colName == "BOXQTY" ){ //박스수량 변경시
					//박스수량을 낱개수량으로 변경하여 계산한다.
				  	boxqty = colValue;
				  	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
				  	QTSHPO = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty) + (Number)(gridList.getColData(gridId, rowNum, "QTSHPD"));
				  	QTSHPO2 = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty);
				  	pltqty = floatingFloor((Number)(QTSHPO)/(Number)(pliqty), 2);
				  	totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(QTSHPO2);
				  	
				  	//수량 CHECK
				  	if(Number(QTSHPO) > Number(gridList.getColData(gridId, rowNum, "QTYORG"))){
						alert("* 납품요청수량이 원주문수량보다 큽니다. *");
						gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
						boxqty = 0;
					  	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
					  	QTSHPO = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty) + (Number)(gridList.getColData(gridId, rowNum, "QTSHPD"));
					  	QTSHPO2 = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty);
					  	pltqty = floatingFloor((Number)(QTSHPO)/(Number)(pliqty), 2);
					  	totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(QTSHPO2);
					}
				  	
				  	//계산한 수량 세팅
				    gridList.setColValue(gridId, rowNum, "QTSHPO", QTSHPO);
				    gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
				    gridList.setColValue(gridId, rowNum, "TOTSHP", totshp);
				  }
				  if( colName == "REMQTY" ){ //잔량변경시
				  	QTSHPO = gridList.getColData(gridId, rowNum, "QTSHPO");
				  	boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
				  	remqty = colValue;	
				  	
				  	//잔량으로 박스수량 등 계산
				  	remqtyChk = (Number)(remqty)%(Number)(bxiqty);
				  	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
				  	QTSHPO = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
				  	QTSHPO2 = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
				  	pltqty = floatingFloor((Number)(QTSHPO2)/(Number)(pliqty), 2);
				  	totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(QTSHPO2);
				  	
				  	//수량 CHECK
				  	if(Number(QTSHPO) > Number(gridList.getColData(gridId, rowNum, "QTYORG"))){
						alert("* 납품요청수량이 원주문수량보다 큽니다. *");
						gridList.setColValue(gridId, rowNum, "REMQTY", 0);
						remqty = 0;
						remqtyChk = (Number)(remqty)%(Number)(bxiqty);
					  	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
					  	QTSHPO = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
					  	QTSHPO2 = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
					  	pltqty = floatingFloor((Number)(QTSHPO2)/(Number)(pliqty), 2);
					  	totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(QTSHPO2);
					}
				  	
				  	//수량 세팅
					gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);	
					gridList.setColValue(gridId, rowNum, "QTSHPO", QTSHPO);
					gridList.setColValue(gridId, rowNum, "TOTSHP", totshp);	
				  }
				  
				}
		}
	}

	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListColTextColorChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			//var colArr = gridList.gridMap.map.gridItemList.cols; //해당그리드의 컬럼 전체 가져오기
			//if(colArr.indexOf(colName)){
			// 가용재고보다 주문수량이 많을 시 글자색 변경
			if(Number(gridList.getColData("gridItemList", rowNum, "ORDTOT")) > Number(gridList.getColData("gridItemList", rowNum, "USEQTY"))){
				return "red";
			}else{ 
				return "black";
			}
			//}
		}
	}
	
	//저장성공시 callback
	function successSaveCallBack(json, status){
		if (json && json.data) {			
			if (json.data != "") {
				//템프 초기화
				gridList.resetTempData("gridHeadList");
				commonUtil.msgBox("SYSTEM_SAVEOK");
				SVBELNS = json.data;
				searchList();
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        	
        }else if(searchCode == "SHDOCTMIF"){
        	//nameArray 미존재
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "B2.PTNG08"){
            param.put("CMCDKY","PTNG08");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNROD"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG01"){
            param.put("CMCDKY","PTNG01");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG02"){
            param.put("CMCDKY","PTNG02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG03"){
            param.put("CMCDKY","PTNG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCARMA2"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHSKUMA"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
            param.put("CMCDKY","ASKU05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG03"){
            param.put("CMCDKY","SKUG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PK.PICGRP"){
            param.put("CMCDKY","PICGRP");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHLOCMA"){
            param.put("WAREKY","<%=wareky %>");
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
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
		//요청사업장
		if(searchCode == "SHCMCDV" && $inputObj.name == "WARESR"){
        	param.put("CMCDKY","PTNG05");
    		param.put("OWNRKY","<%=ownrky %>");
        // 거래처담당자 주소검색
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        	
        }else if(searchCode == "SHDOCTMIF"){
        	//nameArray 미존재
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "DIRDVY"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG08"){
            param.put("CMCDKY","PTNG08");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "PTNRTO"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "PTNROD"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG01"){
            param.put("CMCDKY","PTNG01");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG02"){
            param.put("CMCDKY","PTNG02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG03"){
            param.put("CMCDKY","PTNG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "WARESR"){
            param.put("CMCDKY","WARESR");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG05"){
            param.put("CMCDKY","SKUG05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "ASKU02"){
            param.put("CMCDKY","ASKU02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCARMA2"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHSKUMA"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "ASKU05"){
            param.put("CMCDKY","ASKU05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG03"){
            param.put("CMCDKY","SKUG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG02"){
            param.put("CMCDKY","SKUG02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PICGRP"){
            param.put("CMCDKY","PICGRP");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHLOCMA"){
            param.put("WAREKY","<%=wareky %>");
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
        }
        
    	return param;
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
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
					</div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" />
						<input type="button" CB="Close SO_CLOSE BTN_SO_CLOSE" />
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
			            <dl>
			              <dt CL="STD_OWNRKY"></dt>
			              <dd>
			                <select name="OWNRKY" id="OWNRKY" class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
			              </dd>
			            </dl>
			            <dl>
			              <dt CL="STD_WAREKY"></dt>
			              <dd>
			                <select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
			              </dd>
			            </dl>

			            <dl>  <!--출고일자-->  
			              <dt CL="IFT_ORDDAT"></dt> 
			              <dd> 
			                <input type="text" class="input" name="ORDDAT" UIInput="B" UIFormat="C"/> 
			              </dd> 
			            </dl> 
			            <dl>  <!--출고요청일-->  
			              <dt CL="IFT_OTRQDT"></dt> 
			              <dd> 
			                <input type="text" class="input" name="OTRQDT" UIInput="B" UIFormat="C"/> 
			              </dd> 
			            </dl> 
			            <dl>  <!--납품처코드-->  
			              <dt CL="IFT_PTNRTO"></dt> 
			              <dd> 
			                <input type="text" class="input" name="PTNRTO" UIInput="SR,SHBZPTN"/> 
			              </dd> 
			            </dl> 
			            <dl>  <!--납품처명-->  
			              <dt CL="IFT_PTNRTONM"></dt> 
			              <dd> 
			                <input type="text" class="input" name="B.NAME01" UIInput="SR"/> 
			              </dd> 
			            </dl> 
			            <dl>  <!--매출처코드-->  
			              <dt CL="IFT_PTNROD"></dt> 
			              <dd> 
			                <input type="text" class="input" name="PTNROD" UIInput="SR,SHBZPTN"/> 
			              </dd> 
			            </dl> 
			            <dl>  <!--매출처명-->  
			              <dt CL="IFT_PTNRODNM"></dt> 
			              <dd> 
			                <input type="text" class="input" name="B2.NAME01" UIInput="SR"/> 
			              </dd> 
			            </dl> 
			            <dl>  <!--S/O 번호-->  
			              <dt CL="IFT_SVBELN"></dt> 
			              <dd> 
			                <input type="text" class="input" name="SVBELN" UIInput="SR"/> 
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
										<td GH="40 STD_NUMBER"    GCol="rownum">1</td> 
									    <td GH="40" GCol="rowCheck"></td>
			    						<td GH="70 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 10">출고일자</td>	<!--출고일자-->
			    						<td GH="70 STD_OTRQDT" GCol="text,OTRQDT" GF="D 10">출고요청일</td>	<!--출고요청일-->
			    						<td GH="90 IFT_SVBELN" GCol="text,SVBELN" GF="S 20">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="50 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 10">납품처코드</td>	<!--납품처코드-->
			    						<td GH="130 IFT_PTNRODNM" GCol="text,PTNRTONM" GF="S 30">매출처명</td>	<!--매출처명-->
			    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 10">매출처코드</td>	<!--매출처코드-->
			    						<td GH="130 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 30">매출처명</td>	<!--매출처명-->
			    						<td GH="70 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="70 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="70 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
			    						<td GH="70 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 사유코드 -->
						<input type="checkbox" id="rsnchk" style="VERTICAL-ALIGN: MIDDLE;"/> 
						<span CL="IFT_C00103" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<select name="RSNCOMBO" id="RSNCOMBO"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true">
							<option>선택</option>
						</select>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 일괄적용 -->
						<input type="button" CB="SetAll SAVE BTN_ALL" /> 
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
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
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="70 seq" GCol="text,SPOSNR" GF="S 6">seq</td>	<!--seq-->
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 20">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
			    						<td GH="80 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">원주문수량</td>	<!--원주문수량-->
			    						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,1">납품요청수량</td>	<!--납품요청수량-->
			    						<td GH="80 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td>	<!--출하수량-->
			    						<td GH="80 STD_SHRQTY" GCol="text,SHPQTY" GF="N 13,0">출고잔량</td>	<!--출고잔량-->
			    						<td GH="80 STD_DUOMKY" GCol="text,DUOMKY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="150 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	<!--비고-->
			    						<td GH="180 IFT_C00103" GCol="select,C00103"><!--사유코드-->
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option></option>
											</select>
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