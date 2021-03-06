<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL00</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<style>
	.red{color: red !important; }
	.black{color: black !important; }
</style>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	var SVBELNS
	var SVWAREKY = '';
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Outbound", 
			command : "DL00_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
			menuId : "DL00"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Outbound",
			command : "DL00_ITEM",
			emptyMsgType : false,
			colorType : true,
			menuId : "DL00"
	    });
		 
		//I.OTRQDT 하루 더하기 
		inputList.rangeMap["map"]["I.OTRQDT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		inputList.rangeMap["map"]["I.OTRQDT"].valueChange();

		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());
		
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력 
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "RCVLOC");
		var rangeDataMap2 = new DataMap();
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "SETLOC");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);	
		rangeArr.push(rangeDataMap2);		
		setSingleRangeData('LOCAKY', rangeArr);
		
		//배열선언
		var rangeArr2 = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap3 = new DataMap();
		// 필수값 입력
		rangeDataMap3.put(configData.INPUT_RANGE_OPERATOR,"=="); // =  != > < 표시
		rangeDataMap3.put(configData.INPUT_RANGE_SINGLE_DATA, "00");
		//배열에 맵 탑제 
		rangeArr2.push(rangeDataMap3);
		
		setSingleRangeData('LOTA06', rangeArr2); 	
		
		//콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["WAREKY", "OWNRKY", "DOCUTY", "WARESR", "DIRSUP"]);
		//gridList.setReadOnly("gridItemList", true, ["N00101"]);

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
		$("#WARECOMBO").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#WAREKY").append(optionHtml);
		$("#WARECOMBO").append(optionHtml);
		
		
	}
	 
	//버튼작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			SVBELNS = "";
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "SetAll"){
			setAll();
		}else if(btnName == "SetChk"){
			setChk();
		}else if (btnName == "Reload") {
			reloadLabel();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL00");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL00");
		}
	}
	
	function reloadLabel() {
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}
	
	//조회
	function searchList(){
		gridList.resetGrid("gridItemList");
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			if (SVBELNS != "") {
				param = new DataMap();
				param.put('SVBELNS',SVBELNS);
				param.put('SVWAREKY',SVWAREKY);
				param.put('WAREKY',SVWAREKY);
				
				//netUtil.send({
				//	url : "/outbound/json/displayHeadDL00Save.data",
				//	param : param,
				//	sendType : "list",
				//	bindType : "grid",  //bindType grid 고정
				//	bindId : "gridHeadList" //그리드ID
				//});
				gridList.gridList({
			    	id : "gridHeadList",
			    	command : "DL00_HEAD_SAVE",
			    	param : param
			    });				
				
			}else{
				netUtil.send({
					url : "/outbound/json/displayHeadDL00.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : "gridHeadList" //그리드ID
				});
			}
		}
		//부분적용 초기화 
		$("#RSNCOMBO").val("선택");
		$("#WARECOMBO").val("선택");
	}
	
	//저장
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")&& gridList.validationCheck("gridItemList", "select")){
	        var head = gridList.getSelectData("gridHeadList");
	        var item = gridList.getSelectData("gridItemList");
	          
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			for(var i=0; i<head.length; i++){	
				
				var docuty = head[i].get("DOCUTY");
				var old    = head[i].get("OTRQDT2");
				var change = head[i].get("OTRQDT");
				var dirdvy = head[i].get("DIRDVY");
				
				if(docuty != "266" && docuty != "267" && dirdvy != "02" && change != old){
					commonUtil.msgBox("* 공장직송,이고,이고반품인 경우만 출고요청일 변경이 가능합니다. *");
			    	return;
			    }
		   }
			
			for(var i=0; i<item.length; i++){	
				var itemMap = item[i].map;
				
				var c00103 = item[i].get("C00103");
				var ordtyp = item[i].get("ORDTYP");
				var qtyorg = item[i].get("QTYORG");
				var qtyreq = item[i].get("QTYREQ");
				var wareky = item[i].get("WAREKY");
				var wmsmgt = item[i].get("WMSMGT");
				var qtshpd = item[i].get("QTSHPD");
				
// 				if(C00103.trim() == "" || C00103.trim() == "N"){
// 					commonUtil.msgBox("OYANG_C00103NVL");
// 					return;
// 				}
				
				if(item[i].get(configData.GRID_ROW_STATE_ATT) == configData.GRID_ROW_STATE_UPDATE){
					
					//사유코드 체크
					if((itemMap.DOCUTY != '266' && itemMap.DOCUTY != '267') &&  (itemMap.C00103.trim() == "" || itemMap.C00103.trim() == "N")){
						commonUtil.msgBox("OYANG_C00103NVL");
						return;
					}
					
					if(Number(wmsmgt) > 0){
						commonUtil.msgBox("* 출고작업중인 주문 아이템은 변경할 수 없습니다. *"); 
						return;
					}
					
					if(Number(qtshpd) > 0 && ordtyp != "UB"){
						commonUtil.msgBox("* 부분출고완료된 주문 아이템 변경은 S/O마감을 통해서만 가능합니다. *"); 
						return;
					}
					
					if(Number(qtyreq) > Number(qtyorg)){
						commonUtil.msgBox("* 납품요청수량이 원주문수량보다 큽니다. *"); 
						return;
					}
				}
			}
		}
	

       var param = new DataMap();
		param.put("head",head);
		param.put("item",item);
		
    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
			return;
        }
    	
		netUtil.send({
			url : "/outbound/json/saveDL00.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}

	//체크적용
	function setChk(){
		//인풋값 가져오기
		var rsnchk = $('#rsnchk').prop("checked");
		var warechk = $("#warechk").prop("checked");

		if(!warechk && !rsnchk){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}
		
		//수정불가조건 체크 를 위해 체크박스 체크한 리스트만 들고온다.
		var list = gridList.getSelectData("gridItemList");
		for(var i=0; i<list.length; i++){		
			var c00103 = gridList.getColData("gridItemList", i, "C00103");
			var docuty = gridList.getColData("gridItemList", i, "DOCUTY");
									
			if((docuty != "266" && docuty != "267") && (c00103 == '' || c00103 == ' ')){	 		
					commonUtil.msgBox(" D/O마감 시 사유코드는 필수 입력 입니다. *");
					return;								
			}else{
				//변경 체크했을 경우에만
				if(rsnchk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "C00103", $("#RSNCOMBO").val());
				if(docuty != "266" && docuty != "267"){
					if(warechk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "WAREKY", $("#WARECOMBO").val());
				}
			}
		}
	}

	//일괄적용 (데이터 수정시 체크박스가 체크되기 때문에 모든 로우를 체크후 setChk호출)
	function setAll(){
		
		//인풋값 가져오기
		var rsnchk = $('#rsnchk').prop("checked");
		var warechk = $("#warechk").prop("checked");

		if(!warechk && !rsnchk){
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
				param = new DataMap();
				param.putAll(rowData);
				param.put('SVBELNS',SVBELNS);
				param.put('OWNRKY',$("#OWNRKY").val());

				gridList.gridList({
			    	id : "gridItemList",
			    	command : "DL00_ITEM_SAVE",
			    	param : param
			    });		
				
			}else{
				
				netUtil.send({
					url : "/outbound/json/displayItemDL00.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : "gridItemList" //그리드ID
				});
			}
		}
	}
	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
			gridList.getGridBox(gridId).viewTotal(true);
		}else if(gridId == "gridHeadList" && dataCount > 0){

			var headGridBox = gridList.getGridBox('gridHeadList');
			var headList = headGridBox.getDataAll();
			gridList.getGridBox(gridId).viewTotal(true);
			
			for(var i=0; i<headList.length; i++){
				//출고작업지시하지 않았을 경우 행 수정 불가 (HEADER)
				if(gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "C00102") == 'N'){
					gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), true, ["DIRDVY", "DIRSUP", "OTRQDT"]);
				}else{
					//공장직송만 출고요청일 변경 가능
					if(gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "DOCUTY") != '266' && gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "DOCUTY")!= '267' && gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "DIRDVY") != '02'){

						gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), true, ["DIRSUP","OTRQDT"]);
					}else{

						gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), false, ["OTRQDT"]);
						gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), true, ["DIRSUP"]);
					}
				}
			}
			
			//DO마감하지 않았을 경우 행 수정 불가 (ITEM)	
		}else if(gridId == "gridItemList" && dataCount > 0){

			gridList.getGridBox(gridId).viewTotal(true);
			var itemGridBox = gridList.getGridBox('gridItemList');
			var itemList = itemGridBox.getDataAll();
			
			for(var i=0; i<itemList.length; i++){
				//DO마감하지 않았을 경우 행 수정 불가 (ITEM)
				if(gridList.getColData("gridItemList", itemList[i].get("GRowNum"), "C00102") == 'N'){
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["WAREKY","C00103","QTYREQ","BOXQTY","REMQTY"]);
				}
				
				if(gridList.getColData("gridItemList", itemList[i].get("GRowNum"), "DOCUTY") == '266' || gridList.getColData("gridItemList", itemList[i].get("GRowNum"), "DOCUTY") == '267'){
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["WAREKY"]);
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
			param.put("DIFLOC", "1");
			param.put("OWNRKY", <%=ownrky%>);
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			return param;
		}else if( comboAtt == "SajoCommon,SEARCH_WAREKY_COMCOMBO" ){
			param.put("USERID", "<%=userid%>");
			param.put("OWNRKY", <%=ownrky%>);
			return param;
		}else if(comboAtt ==  "SajoCommon,WAREKYNM_COMCOMBO_HP"){
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
		return param;
	}
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			if(colName == "QTYREQ" || colName == "QTYREQ2" || colName == "BOXQTY" || colName == "REMQTY"){
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
				
				if( colName == "QTYREQ2" ) {
					//수량 CHECK
					if(Number(gridList.getColData(gridId, rowNum, "QTYREQ2")) + Number(gridList.getColData(gridId, rowNum, "QTSHPD")) > Number(gridList.getColData(gridId, rowNum, "QTYORG"))){
						alert("* 납품요청수량이 원주문수량보다 큽니다. *");
						gridList.setColValue(gridId, rowNum, "QTYREQ2", 0);
					}
					qtyreq2 = gridList.getColData(gridId, rowNum, "QTYREQ2");
					boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
					remqty = gridList.getColData(gridId, rowNum, "REMQTY");
					qtyreq = (Number)(qtyreq2) + (Number)(gridList.getColData(gridId, rowNum, "QTSHPD"));
					boxqty = floatingFloor((Number)(qtyreq2)/(Number)(bxiqty), 1);
					remqty = (Number)(qtyreq2)%(Number)(bxiqty);
					pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
					totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(qtyreq2);
					
					gridList.setColValue(gridId, rowNum, "QTYREQ", qtyreq);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "TOTSHP", totshp);
				}
			}else if( colName == "C00103" ){
				var c00103 = gridList.getColData(gridId, rowNum, "C00103");
				if(c00103 != " " && c00103 != "" && Number(c00103) < 900){
					alert('사용할 수 없는 사유코드 입니다.');
					gridList.setColValue(gridId, rowNum, "C00103", " ");
				}
			}
		}
	}

	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
// 	function gridListColTextColorChange(gridId, rowNum, colName, colValue){
// 		if(gridId == "gridItemList"){
// 			//var colArr = gridList.gridMap.map.gridItemList.cols; //해당그리드의 컬럼 전체 가져오기
// 			//if(colArr.indexOf(colName)){
// 			// 가용재고보다 주문수량이 많을 시 글자색 변경
// 			if(Number(gridList.getColData("gridItemList", rowNum, "ORDTOT")) > Number(gridList.getColData("gridItemList", rowNum, "USEQTY"))){
// 				return "red";
// 			}else{ 
// 				return "black";
// 			}
// 			//}
// 		}
// 	}
	
	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListRowColorChange(gridId, rowNum){
		if(gridId == "gridItemList"){
			// 가용재고보다 주문수량이 많을 시 글자색 변경
			if(Number(gridList.getColData("gridItemList", rowNum, "ORDTOT")) > Number(gridList.getColData("gridItemList", rowNum, "USEQTY"))){
				return configData.GRID_COLOR_TEXT_RED_CLASS;
			}
		}
	}
	
	//저장성공시 callback
	function successSaveCallBack(json, status){	
		if (json && json.data) {
			if(json.data.SVBELNS != ""){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				SVBELNS = json.data.SVBELNS;
				SVWAREKY = json.data.WAREKY;
				searchList();
			}else{
// 				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
		//요청사업장
		if(searchCode == "SHCMCDV" && $inputObj.name == "I.WARESR"){
        	param.put("CMCDKY","PTNG05");
    		param.put("OWNRKY","<%=ownrky %>");
        // 거래처담당자 주소검색
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
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
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG08"){
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
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG03"){
            param.put("CMCDKY","PTNG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG05"){
            param.put("CMCDKY","SKUG05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.ASKU02"){
            param.put("CMCDKY","ASKU02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCARMA2"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHSKUMA"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM2.ASKU05"){
            param.put("CMCDKY","ASKU05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.SKUG03"){
            param.put("CMCDKY","SKUG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "I.SKUG02"){
            param.put("CMCDKY","SKUG02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PICGRP"){
            param.put("CMCDKY","PICGRP");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHLOCMA" && $inputObj.name == "SW.LOCARV"){ 
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
    		param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
    		
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SHP");
    		rangeArr.push(rangeDataMap); 
        	param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
        //권역사업장
        }else if(searchCode == "SHWAHMA" && $inputObj.name == "B.NAME03"){
			param.put("NOBIND","Y");
        	
        	var rangeArr = new Array();
    		//배열내 들어갈 데이터 맵 선언
    		var rangeDataMap = new DataMap();
    		// 필수값 입력
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, $('#WAREKY').val());
    		//배열에 맵 탑제 
    		rangeArr.push(rangeDataMap);

            param.put("WAREKY", returnSingleRangeDataArr(rangeArr));
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
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
					</div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" /> 
						<input type="button" CB="Save SAVE BTN_SAVE" /> 
						<input type="button" CB="Reload RESET STD_REFLBL" />
					</div>
				</div>
				<div class="search_inner">
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
			                <select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
			              </dd>
			            </dl>
			            <dl>  <!--S/O 번호-->  
							<dt CL="IFT_SVBELN"></dt> 
							<dd> 
								<input type="text" class="input" name="I.SVBELN" UIInput="SR"/> 
							</dd> 
						</dl>
			            <dl>  <!--출고요청일-->  
							<dt CL="IFT_OTRQDT"></dt> 
							<dd> 
								<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C N"/> 
							</dd> 
						</dl> 
			            <dl>  <!--출고유형-->  
							<dt CL="IFT_DOCUTY"></dt> 
							<dd> 
								<input type="text" class="input" name="I.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
							</dd> 
						</dl>
						<dl>  <!--출고일자-->  
							<dt CL="IFT_ORDDAT"></dt> 
							<dd> 
								<input type="text" class="input" name="I.ORDDAT" UIInput="B" UIFormat="C"/> 
							</dd> 
						</dl> 
			            <dl>  <!--부족재고S/O조회-->  
 							<dt CL="STD_STOCKSHORT"> </dt> <!--name="scUsetype" -->
							<dd> 
								<select name="USETYPE" id="USETYPE" class="input" Combo="DaerimOutbound,USETYPE_COMBO"></select> 
							</dd> 
						</dl> 
						<dl>  <!--주문/출고형태-->  
							<dt CL="IFT_ORDTYP"></dt> 
							<dd> 
								<input type="text" class="input" name="I.ORDTYP" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--주문일자-->  
							<dt CL="STD_CTODDT"></dt> 
							<dd> 
								<input type="text" class="input" name="I.ERPCDT" UIInput="B" UIFormat="C"/> 
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
						<dl>  <!--요구사업장-->  
							<dt CL="IFT_WARESRC"></dt> 
							<dd> 
								<input type="text" class="input" name="I.WARESR" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--제품코드-->  
							<dt CL="IFT_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--세트여부-->  
							<dt CL="STD_ASKU02"></dt> 
							<dd> 
								<input type="text" class="input" name="I.ASKU02" UIInput="SR,SHCMCDV"/> 
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
						<dl>  <!--요청수량(BOX)-->  
							<dt CL="IFT_BOXQTYREQ"></dt> 
							<dd> 
								<input type="text" class="input" name="I.QTYORG" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--요청수량(낱개)-->  
							<dt CL="STD_QTYREQEA"></dt> 
							<dd> 
								<input type="text" class="input" name="QTYREM" UIInput="SR"/>  <!-- I.QTYORG -->
							</dd> 
						</dl> 
						<dl>  <!--권역사업장-->  
							<dt CL="STD_WEGWRK"></dt> 
							<dd> 
								<input type="text" class="input" name="B.NAME03" UIInput="SR,SHWAHMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--차량번호-->  
							<dt CL="STD_CARNUM"></dt> 
							<dd> 
								<input type="text" class="input" name="CARNUM" UIInput="SR,SHCARMA2"/> 
							</dd> 
						</dl> 
						<dl>  <!--출고지시여부-->  
							<dt CL="STD_C00102"></dt> 
							<dd> 
								<select name="C00102" id="C00102" class="input" CommonCombo="C00102"></select>  
							</dd> 
						</dl> 
						<dl>  <!--마감구분-->  
							<dt CL="STD_PTNG08"></dt> 
							<dd> 
								<input type="text" class="input" name="B.PTNG08" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--상온구분-->  
							<dt CL="STD_ASKU05"></dt> 
							<dd> 
								<input type="text" class="input" name="SM2.ASKU05" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--로케이션-->  
							<dt CL="STD_LOCASR"></dt> 
							<dd> 
							    <input type="text" class="input" name="SW.LOCARV" UIInput="SR,SHLOCMA"/> 
							</dd> 
						</dl> 
						<dl>  <!--거래처 그룹1-->  
							<dt CL="STD_PTNG01G1"></dt> 
							<dd> 
								<input type="text" class="input" name="B.PTNG01" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--거래처 그룹2-->  
							<dt CL="STD_PTNG01G2"></dt> 
							<dd> 
								<input type="text" class="input" name="B.PTNG02" UIInput="SR"/> 
							</dd> 
						</dl> 
						<dl>  <!--중분류-->  
							<dt CL="STD_SKUG02"></dt> 
							<dd> 
								<input type="text" class="input" name="I.SKUG02" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--소분류-->  
							<dt CL="STD_SKUG03"></dt> 
							<dd> 
								<input type="text" class="input" name="I.SKUG03" UIInput="SR,SHCMCDV"/> 
							</dd> 
						</dl> 
						<dl>  <!--포장구분-->  
							<dt CL="STD_LOTA05"></dt> 
							<dd> 
								<input type="text" class="input" name="LOTA05" UIInput="SR,SHLOTA05"/> 
							</dd> 
						</dl> 
						<!-- 재고유형 -->
						<dl>
							<dt CL="STD_LOTA06"></dt>
							<dd>
								<input type="text" class="input" name="LOTA06" UIInput="SR,SHLOTA06"  />
							</dd>
						</dl>
						<dl>  <!--로케이션-->  
							<dt CL="STD_LOCAKY"></dt> 
							<dd> 
								<input type="text" class="input" name="LOCAKY" UIInput="SR,SHLOCMA" readonly/> 
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
					<li><a href="#tab1-1"><span>일반</span></a></li><br>
					>> 배송구분, 출고예정일은 전체 S/O에 반영됩니다. 타 센터에 확인 후 처리바랍니다.
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
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="80 IFT_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="150 IFT_WAREKY" GCol="select,WAREKY"><!--WMS거점(출고사업장)-->
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO_HP"></select>
			    						</td>
			    						<td GH="100 IFT_WARESR" GCol="select,WARESR" ><!--요구사업장-->
											<select class="input" commonCombo="PTNG06"><option></option></select>
			    						</td>	
			    						<td GH="100 IFT_DOCUTY" GCol="select,DOCUTY"><!--출고유형-->
											<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"><option></option></select>
			    						</td>	
			    						<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
			    						<td GH="80 STD_CTODDT" GCol="text,ERPCDT" GF="D 8">주문일자</td>	<!--주문일자-->
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 IFT_OTRQDT" GCol="input,OTRQDT" GF="C 8">출고요청일</td>	<!--출고요청일-->
<!-- 			    						<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT2" GF="D 8">출고요청일</td>	출고요청일 -->
			    						<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
			    						<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
			    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
			    						<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td>	<!--매출처명-->
			    						<td GH="90 IFT_DIRDVY" GCol="select,DIRDVY"><!--배송구분-->
											<select class="input" commonCombo="PGRC02"></select>
			    						</td>
			    						<td GH="90 IFT_DIRSUP" GCol="select,DIRSUP"><!--주문구분-->
											<select class="input" commonCombo="PGRC03"></select>
			    						</td>
			    						<td GH="80 IFT_CUSRID" GCol="text,CUSRID" GF="S 20">배송고객 아이디</td>	<!--배송고객 아이디-->
			    						<td GH="80 IFT_CUNAME" GCol="text,CUNAME" GF="S 35">배송고객명</td>	<!--배송고객명-->
			    						<td GH="80 IFT_CUPOST" GCol="text,CUPOST" GF="S 10">배송지 우편번호</td>	<!--배송지 우편번호-->
			    						<td GH="80 IFT_CUNATN" GCol="text,CUNATN" GF="S 3">배송자 국가 키 </td>	<!--배송자 국가 키 -->
			    						<td GH="80 IFT_CUTEL1" GCol="text,CUTEL1" GF="S 16">배송자 전화번호1</td>	<!--배송자 전화번호1-->
			    						<td GH="80 IFT_CUTEL2" GCol="text,CUTEL2" GF="S 31">배송자 전화번호2</td>	<!--배송자 전화번호2-->
			    						<td GH="80 IFT_CUMAIL" GCol="text,CUMAIL" GF="S 723">배송자 E-MAIL</td>	<!--배송자 E-MAIL-->
			    						<td GH="80 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td>	<!--배송지 주소-->
			    						<td GH="80 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td>	<!--거래처 담당자명-->
			    						<td GH="80 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td>	<!--거래처 담당자 전화번호-->
			    						<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td>	<!--영업사원명-->
			    						<td GH="80 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td>	<!--영업사원 전화번호-->
			    						<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 200">비고</td>	<!--비고-->
			    						<td GH="80 STD_REGNKY" GCol="text,REGNKY" GF="S 10">권역코드</td>	<!--권역코드-->
			    						<td GH="80 STD_REGNNM" GCol="text,REGNNM" GF="S 80">권역명</td>	<!--권역명-->
			    						<td GH="80 STD_WEGWRK" GCol="text,NAME03B" GF="S 80">권역사업장</td>	<!--권역사업장-->
			    						<td GH="50 STD_RQARRT" GCol="text,XTIMS" GF="T 6">지시시간</td>	<!--지시시간--> 
			    						<td GH="50 STD_ERDAT" GCol="text,XDATS" GF="D 10">지시일자</td>	<!--지시일자-->
			    						<td GH="50 IFT_C00102" GCol="text,C00102" GF="S 10">승인여부</td>	<!--승인여부-->
			    						<td GH="72 STD_PLTQTY" GCol="text,PLTQTY" GF="N 20,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="72 IFT_BOXQTYORG" GCol="text,DLBOX" GF="N 20,1">원주문수량(BOX)</td>	<!--원주문수량(BOX)-->
			    						<td GH="80 IFT_BOXQTYREQ" GCol="text,DLBIX" GF="N 13,1">납품요청수량(BOX)</td>	<!--납품요청수량(BOX)-->
			    						<td GH="72 STD_SKUCNT" GCol="text,SKUCNT" GF="N 20">품목 수</td>	<!--품목 수-->
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- WMS거점(출고사업장) -->
						<input type="checkbox" id="warechk" style="VERTICAL-ALIGN: MIDDLE;"/> 
						<span CL="IFT_WAREKY" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<select name="WARECOMBO" id="WARECOMBO"  class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO_HP" ComboCodeView="true">
							<option>선택</option>
						</select>
					</li>
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
										<td GH="40 STD_NUMBER" GCol="rownum">1</td>  
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="80 IFT_CHKSEQ" GCol="text,CHKSEQ" GF="S 10">검수번호</td>	<!--검수번호-->
			    						<td GH="80 IFT_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">주문번호아이템</td>	<!--주문번호아이템-->
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td>	<!--주문아이템번호-->
			    						<td GH="150 IFT_WAREKY" GCol="select,WAREKY"><!--WMS거점(출고사업장)-->
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO_HP"></select>
					                    </td> 
			    						<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="120 IFT_C00103" GCol="select,C00103"><!--사유코드-->
					                        <select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"><option></option></select>
					                    </td>
			    						<td GH="80 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">원주문수량</td>	<!--원주문수량-->
			    						<td GH="80 IFT_QTYREQ" GCol="input,QTYREQ" GF="N 13,0">납품요청수량</td>	<!--납품요청수량-->
			    						<td GH="80 STD_QTSDIF" GCol="text,USEQTY" GF="N 13,0">가용재고</td>	<!--가용재고-->
			    						<td GH="80 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS작업수량</td>	<!--WMS작업수량-->
			    						<td GH="80 기출고수량" GCol="text,QTSHPD" GF="N 13,0">기출고수량</td>	<!--기출고수량-->
			    						<td GH="80 총출고수량" GCol="text,TOTSHP" GF="N 13,0">총출고수량</td>	<!--총출고수량-->
			    						<td GH="80 STD_SHRQTY" GCol="text,SHPQTY" GF="N 13,0">출고잔량</td>	<!--출고잔량-->
			    						<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td>	<!--기본단위-->
			    						<td GH="100 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	<!--비고-->
			    						<td GH="100 IFT_N00101" GCol="select,N00101">	<!--가용재고 체크-->
			    							<select class="input" commonCombo="N00101"></select>
			    						</td>	
			    						<td GH="80 STD_PLTBOX" GCol="text,PLTBOX" GF="N 17,0">PLT별BOX적재수량</td>	<!--PLT별BOX적재수량-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="50 STD_PLBQTY" GCol="text,PLBQTY" GF="S 17" style="text-align:right;" >팔렛당박스수량</td>	<!--팔렛당박스수량-->
			    						<td GH="80 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">박스잔량</td>	<!--박스잔량-->
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