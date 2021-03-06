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

	var itemGridNumber = 3; // default
	var innerParams;
	var searchRowData;
	var ajaxData = new DataMap();
	var param;
	var qttdumList = [];
	
	$(document).ready(
			function() {
				gridList.setGrid({
					id : "gridHeadList",
					module : "taskOrder",
					command : "MV12_HEAD",
				    menuId : "MV12"
				});
	
				gridList.setGrid({
					id : "gridItemList3",
					module : "taskOrder",
					command : "MV12_ITEM",
				    menuId : "MV12"
				});
	
				gridList.setGrid({
					id : "gridItemList4",
					module : "taskOrder",
					command : "MV12_ITEM",
				    menuId : "MV12"
				});
	
				// tab2에서만 나와야하는 search menu 숨김
				$("#activBar").hide();
	
				// 생성전까지 추가버튼 감춤
				$(".addBtn").hide();
	
				// 생성1 전까지 생성2 버튼 감추기
				$('input[CB^="Create2"]').hide();
	
				// 생성 전까지 저장버튼 감춤
				uiList.setActive("Save", false);
	
				// 저장 전까지 확정버튼 감춤
				uiList.setActive("Confirm", false);
	
				// 콤보박스 리드온리
				gridList.setReadOnly("gridItemList4", true, [ "ASKU02", "SKUG01",
						"SKUG05", "LOTA02" ]);
				
				
			});
	
	// GET, SET VARIANT
	function linkPopCloseEvent(data) {
		// 팝업 종료
		if (data.get("TYPE") == "GET") {
			sajoUtil.setVariant("searchArea", data); // 팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	} // end linkPopCloseEvent()
	
	// 버튼 이벤트
	function commonBtnClick(btnName) {
		if (btnName == "Savevariant") {
			sajoUtil.openSaveVariantPop("searchArea", "MV12");
		} else if (btnName == "Getvariant") {
			sajoUtil.openGetVariantPop("searchArea", "MV12");
		} else if (btnName == "Create1") {
			searchList();
		} else if (btnName == "Create2") {
			create();
		} else if (btnName == "Save") {
			saveData();
		} else if (btnName == "Confirm") {
			handleConfirm();
		} else if (btnName == 'Print1') {
			print(btnName);
		} else if (btnName == 'Print2') {
			print(btnName);
		}
	} // end commonBtnClick()
	
	// 콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj) {
		var ownrky = $("#OWNRKY").val();
		var wareky = $("#WAREKY").val();
		var tasoty = "320";
	
		var param = new DataMap();
		param.put("OWNRKY", ownrky);
	
		// 조사타입 및 조정사유코드 공통코드
		if (comboAtt == "LOTA05") {
			param.put("WAREKY", wareky);
		} else if (comboAtt == "SajoCommon,RSNCOD_COMCOMBO") {
			param.put("OWNRKY", ownrky);
			param.put("DOCCAT", "300");
			param.put("DOCUTY", tasoty);
			// console.log('param : ', param)
		} else if (comboAtt == "LOTA02") {
			param.put("WAREKY", wareky);
		} else if (comboAtt == "LOTA05") {
			param.put("WAREKY", wareky);
		}
	
		return param;
	} // end comboEventDataBindeBefore()
	
	// 서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum) {
		var ownrky = $("#OWNRKY").val();
		var wareky = $("#WAREKY").val();
	
		var param = new DataMap();
	
		switch (searchCode) {
		case "SHLOCMA": // TO 로케이션
			param.put("WAREKY", wareky);
			break;
		case "SHSKU_INFO": // 제품코드
			param.put("WAREKY", wareky);
			param.put("OWNRKY", ownrky);
			break;
		case "SHAREMA": // to 동
			param.put("WAREKY", wareky);
			param.put("AREATY", $("#AREATY").val());
			break;
		}
	
		return param;
	} // end searchHelpEventOpenBefore()
	
	// 조회 (생성)
	function searchList() {
		if (validate.check("searchArea")) {
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList3");
			gridList.resetGrid("gridItemList4");
	
			var param = inputList.setRangeDataParam("searchArea"); // OWNRKY,
																	// WAREKY 포함
	
			// sqlParams.put("progid", progid);
			param.put("USERID", "<%=userid%>");
			// sqlParams.put("areaky", areaky);
			param.put("WARETG", param.get("WAREKY"));
			param.put("AREATG", " ");
			param.put("TASOTY", "320");
			param.put("DOCCAT", "300");
			param.put("STATDO", "NEW");
			param.put("DOCUTY", param.get("TASOTY"));
			param.put("CREUSR", "<%=userid%>");
			// sqlParams.put("ptnrky", ptnrky);
			// sqlParams.put("svbeln", svbeln);
			// sqlParams.put("shpoky", shpoky);
			// sqlParams.put("recvky", recvky);
	
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
	
			// 생성 후 하나의 그리드를 추가시켜줌
			// var gridItemList = $('tbody[id^=gridItemList]').get();
			/*
			 * gridItemList.forEach(function(item) { var gridId =
			 * $(item).attr('id'); gridList.setAddRow(gridId, null); })
			 */
			gridList.setAddRow("gridItemList3", null);
	
			// 생성 후 추가버튼 보임
			$(".addBtn").show();
			
			// 생성 후 탭을 누를 수 없게 탭버튼 보임
			$('a[href^="#tab"]').show();
	
			// 생성1 후 생성2 버튼 보이기
			$('input[CB^="Create2"]').show();
	
			$("#atab1-3").trigger("click");
		}
	} // end searchList()
	
	// 서치헬프가 닫히기 직전 호출
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData) {
		if (searchCode == "SHSKU_INFO") {
			if (innerParams.get("GRIDID") == "gridItemList3") {
				if (parseInt(selectData) == parseInt(innerParams.get("COLVALUE"))) {
					searchRowData = rowData;
					gridList.setColValue(innerParams.get("GRIDID"), innerParams
							.get("ROWNUM"), "DESC01", rowData.get("DESC01"));
				}
			}
		}
	} // end searchHelpEventCloseAfter()

	
 	// 그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue) {
		innerParams = new DataMap();
		if (gridId == "gridItemList3") {
			innerParams.put("GRIDID", gridId);
			innerParams.put("ROWNUM", rowNum);
			innerParams.put("COLNAME", colName);
			innerParams.put("COLVALUE", colValue);
	
			if (colName == "QTTAOR" || colName == "BOXQTYOR" || colName == "PLTQTYOR") {
				var qttaor = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var bxiqty = gridList.getColData(gridId, rowNum, "QTDUOM");
				var pliqty = gridList.getColData(gridId, rowNum, "PLIQTY");
				/* var bxiqty = searchRowData.get("QTDUOM");
				var pliqty = searchRowData.get("PLIQTY"); */
				var remqtyChk = 0;
	
				switch (colName) {
				case "QTTAOR":
					qttaor = colValue;
	
					boxqty = decimalPoint(Number(qttaor) / Number(bxiqty), 1);
					remqty = decimalPoint(Number(qttaor) % Number(bxiqty), 0);
					pltqty = decimalPoint(Number(qttaor) / Number(pliqty), 2);
	
					gridList.setColValue(gridId, rowNum, "PLTQTYOR", pltqty);
					gridList.setColValue(gridId, rowNum, "BOXQTYOR", boxqty);
					break;
				case "BOXQTYOR":
					boxqty = colValue;
	
					qttaor = decimalPoint(Number(boxqty) * Number(bxiqty), 0);
					pltqty = decimalPoint(qttaor / Number(pliqty), 2);
	
					gridList.setColValue(gridId, rowNum, "QTTAOR", qttaor);
					gridList.setColValue(gridId, rowNum, "PLTQTYOR", pltqty);
					break;
				case "PLTQTYOR":
					pltqty = colValue;
	
					qttaor = decimalPoint(Number(pltqty) * Number(pliqty), 0);
					boxqty = decimalPoint((Number(pltqty) * Number(pliqty)) / Number(bxiqty), 1);
	
					gridList.setColValue(gridId, rowNum, "QTTAOR", qttaor);
					gridList.setColValue(gridId, rowNum, "BOXQTYOR", boxqty);
					break;
				}
			}else if(colName == "SKUKEY"){ //제품코드 변경시
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
				
			}
		} else if (gridId == "gridItemList4") {
			if (colName == "QTTAOR" || colName == "BOXQTY" || colName == "REMQTY"
					|| colName == "PLTQTY") {
				var qttaor = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var bxiqty = gridList.getColData(gridId, rowNum, "BXIQTY");
				var qtduom = qttdumList[rowNum];
				var pliqty = gridList.getColData(gridId, rowNum, "PLIQTY");
				var remqtyChk = 0;
	
				switch (colName) {
				case "QTTAOR":
					qttaor = colValue;
	
					boxqty = decimalPoint(Number(qttaor) / Number(bxiqty), 1);
					remqty = decimalPoint(Number(qttaor) % Number(bxiqty), 0);
					pltqty = decimalPoint(Number(qttaor) / Number(pliqty), 2);
	
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					break;
				case "BOXQTY":
					boxqty = colValue;
	
					qttaor = decimalPoint(Number(boxqty) * Number(bxiqty), 0);
					pltqty = decimalPoint(qttaor / Number(pliqty), 2);
	
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", 0);
					break;
				case "PLTQTY":
					pltqty = colValue;
	
					qttaor = decimalPoint(Number(pltqty) * Number(pliqty), 0);
					boxqty = decimalPoint((Number(pltqty) * Number(pliqty))
							/ Number(bxiqty), 1);
	
					gridList.setColValue(gridId, rowNum, "QTTAOR", qttaor);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					break;
				}
	
				var qttaorSum = 0;
				var pltqtySum = 0;
				var boxqtySum = 0;
	
				var list = gridList.getGridData(gridId);
				for (var i = 0; i < list.length; i++) {
					var qttaor = Number(list[i].get("QTTAOR"));
					var pltqty = Number(list[i].get("PLTQTY"));
					var boxqty = Number(list[i].get("BOXQTY"));
	
					qttaorSum += Number(qttaor);
					pltqtySum += Number(pltqty);
					boxqtySum += Number(boxqty);
				}
	
				$("#QTTAORSUM").val(qttaorSum);
				$("#PLTQTYSUM").val(decimalPoint(pltqtySum, 1));
				$("#BOXQTYSUM").val(boxqtySum);
			}
		}
	} // end gridListEventColValueChange()
	
	// 소수점 표기를 위한 함수
	function decimalPoint(number, digit) {
		if (number === null || number === undefined || digit === null
				|| digit === undefined)
			throw new Error("인수 부족");
		if (!typeof number === "number" || !typeof digit === "number")
			throw new Error("인자 형식 부적합");
	
		var result = null;
		if (digit != 0) {
			var point = Math.pow(10, digit);
			var value = parseInt(number * point);
			result = value / point;
		} else {
			result = parseInt(number);
		}
	
		return result;
	} // end decimalPoint()
	
	// 생성2
	function create() {
		
		// 저장 후 재 생성 눌렀을시 확정버튼 다시 감춤
		uiList.setActive("Confirm", false);
	
		var resetMenu = gridList.getGridData('gridItemList4');
		if (resetMenu.length > 0) gridList.getGridBox('gridItemList4').reset(); // 기존 그리드 삭제
	
		var param = inputList.getRangeParam("searchArea");
	
		if (gridList.validationCheck("gridHeadList", "select")) {
			var head = gridList.getGridData("gridHeadList");
	
			if (head.length == 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			param.put("head", head);
		}

		
		var item = gridList.getSelectData("gridItemList3");
		
		if (item.length == 0) {
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		//item 저장불가 조건 체크
		for(var i=0; i<item.length; i++){
			var itemMap = item[i].map;
			
			if(itemMap.LOCATG == " " || itemMap.LOCATG == ""){
				commonUtil.msgBox("To 로케이션을 입력해주세요.");
				return;
			}
			
			if(itemMap.LOTA06 == " " || itemMap.LOTA06 == ""){
				commonUtil.msgBox("재고유형을 입력해주세요.");
				return;
			}
			
			if(itemMap.PTLT06 == " " || itemMap.PTLT06 == ""){
				commonUtil.msgBox("To 재고유형을 입력해주세요.");
				return;
			}
			
		}
		param.put("item3", item);
		
/*  		if (gridList.validationCheck("gridItemList3", "select")) {
			var item = gridList.getSelectData("gridItemList3");
	
			if (item.length == 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			param.put("item3", item);
		}  */
	
		param.put("USERID", "<%=userid%>");
		param.put("WARETG", param.get("WAREKY"));
		param.put("AREATG", " ");
		param.put("TASOTY", "320");
		param.put("DOCCAT", "300");
		param.put("STATDO", "NEW");
		param.put("DOCUTY", param.get("TASOTY"));
		param.put("SES_USER_ID", "<%=userid%>");
	
		netUtil.send({
			url : "/taskOrder/json/createMV12.data",
			param : param,
			successFunction : "successCreateCallBack"
		});
	} // end create();
	
	// 생성2 ajax 콜백
	function successCreateCallBack(json, status) {
		if (json && json["data"]) {
			ajaxData.map = json.data;
			var error = json.data.RESULT;
			var message = json.data.M;
			if (message) {
				commonUtil.msgBox(message);
				return;
			} else {
				$("#atab1-4").trigger("click");
	
				var data = json.data.FINDAVAILABLESTOCK;
	
				for (var i = 0; i < data.length; i++) {
					var dataMap = new DataMap();
					dataMap.map = data[i];
					qttdumList.push(data[i].QTTDUM);
					gridList.setAddRow("gridItemList4", dataMap);
				}
				// 생성2 후 생성버튼 감춤
				uiList.setActive("Create2", false);
				// 생성2 후 저장버튼 보임
				uiList.setActive("Save", true);
	
			}
		}
	}
	
	// grid row 추가 후 호출
	function gridListEventRowAddAfter(gridId, rowNum) {
		console.log('row 추가');
	} // end gridListEventRowAddAfter()
	
	// grid 조회 시 data 적용이 완료 된 후
	function gridListEventDataBindEnd(gridId, dataCount) {
		if (gridId == 'gridItemList4') {
			var qttaorSum = 0;
			var pltqtySum = 0;
			var boxqtySum = 0;
	
			var list = gridList.getGridData(gridId);
			for (var i = 0; i < list.length; i++) {
				var qttaor = Number(list[i].get("QTTAOR"));
				var pltqty = Number(list[i].get("PLTQTY"));
				var boxqty = Number(list[i].get("BOXQTY"));
	
				qttaorSum += Number(qttaor);
				pltqtySum += Number(pltqty);
				boxqtySum += Number(boxqty);
			}
	
	
			$("#QTTAORSUM").val(qttaorSum);
			$("#PLTQTYSUM").val(pltqtySum);
			$("#BOXQTYSUM").val(boxqtySum);
		}
	}
	
	// 탭 클릭시 탭 상태변경
	function moveTab(tab) {
		var tabName = $(tab).attr("href");
		var lastIndex = tabName.length - 1;
		itemGridNumber = tabName.slice(lastIndex);
		// var gridId = "gridList"+tabNm.charAt(tabNm.length-1);
	
		var itemGridId = "gridItemList" + itemGridNumber;
	
		if (itemGridNumber == 3) {
			$("#activBar").hide();
		} else {
			$("#activBar").show();
		}
	}
	
	// 저장시 validation 체크
	function saveCheckData() {
		var item = gridList.getSelectData("gridItemList4");
	
		// item 저장불가 validation check
		for (var i = 0; i < item.length; i++) {
			var checkItem = item[i];
	
			var qttaor = checkItem.get("QTTAOR");
			var pltqtyor = checkItem.get("PLTQTYOR");
			var boxqtyor = checkItem.get("BOXQTYOR");
	
			if (qttaor == "" && pltqtyor == "" && boxqtyor == "") {
				commonUtil.msgBox("VALID_Quantity"); // * 수량은 필수 입력 입니다. *
	
				// 위 조건에 어긋난 컬럼에 포커스 주기
				var colName;
				var rowNum = i;
				if (qttaor == "") {
					colName = "QTTAOR";
					setColFocus(gridId, rowNum, colName);
				} else if (pltqtyor == "") {
					colName = "PLTQTYOR";
					setColFocus(gridId, rowNum, colName);
				} else if (boxqtyor == "") {
					colName = "BOXQTYOR";
					setColFocus(gridId, rowNum, colName);
				}
				return false;
			}
		}
		return true;
	}
	
	// 저장
	function saveData() {
		if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
			// 저장하시겠습니까?
			return;
		}
	
		if (gridList.validationCheck("gridItemList4", "select")) {
			if (!saveCheckData())
				return;
	
			var item = gridList.getSelectData("gridItemList4");
	
			if (item.length === 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
	
			var msgTxt = "";
			for (var i = 0; i < item.length; i++) {
				if (i != 0)
					msgTxt += ',';
				msgTxt += item[i].get("LOCATG");
			}
			if (confirm('중복로케이션 : [' + msgTxt + '] \r계속 진행하시겠습니까?')) {
				param = new DataMap();
				ajaxData.put("item4", item);
				ajaxData.put("TASOTY", "320");
				param.put("WAREKY", $("#WAREKY").val());
				ajaxData.put("WARETG", $("#WAREKY").val());
				ajaxData.put("AREATG", " ");
	
				netUtil.send({
					url : "/taskOrder/json/saveMV12.data",
					param : ajaxData,
					successFunction : "successSaveCallBack"
				});
	
				var gridReadOnlyList = gridList.getSelectData('gridItemList4');
				for (var i = 0; i < gridReadOnlyList.length; i++) {
					gridList.setRowReadOnly('gridItemList4', i);
				}
	
				// 저장 후 확정버튼 보임
				uiList.setActive("Confirm", true);
			}
		}
	}
	
	// 저장 ajax 콜백
	function successSaveCallBack(json, status) {
		if (json && json["data"]) {
			ajaxData.map = json.data;
			var error = json.data.RESULT;
			var message = json.data.M;
			if (message) {
				commonUtil.msgBox(message);
				return;
			}
			commonUtil.msgBox("SYSTEM_SAVEOK"); // 저장성공
	
			reSearchList(); // 해더 재조회
	
			// 저장 후 저장버튼 감춤
			uiList.setActive("Save", false);
		}
	} // end successSaveCallBack
	
	// 저장 성공 시 재조회 쿼리
	function reSearchList() {
		var param = new DataMap();
		param.put("OWNRKY", $("#OWNRKY").val());
		param.put("WAREKY", $("#WAREKY").val());
		param.put("TASKKY", ajaxData.get('FIRSTSAVEHEAD')[0].map.TASKKY);
	
		if (ajaxData) {
			gridList.gridList({
				id : "gridHeadList",
				param : param,
				command : "MV12_REHEAD"
			});
		}
	} // end reSearchList()
	
	// 확정
	function handleConfirm() {
		if (!commonUtil.msgConfirm("SYSTEM_CONFIRMCK")) {
			// 입고확정 하시겠습니까?
			return;
		}
	
		if (gridList.validationCheck("gridItemList4", "select")) {
			var item = gridList.getSelectData("gridItemList4");
	
			ajaxData.put("item4", item);
	
			netUtil.send({
				url : "/taskOrder/json/confirmMV12.data",
				param : ajaxData,
				successFunction : "successConfirmCallBack"
			});
		}
	} // end confirm()
	
	// 확정 ajax 콜백
	function successConfirmCallBack(json, status) {
		if (json && json["data"]) {
			ajaxData.map = json.data;
			var error = json.data.RESULT;
			var message = json.data.M;
			if (message) {
				commonUtil.msgBox(message);
				return;
			}
			commonUtil.msgBox("SYSTEM_CONFIRMOK"); // 확정 성공
	
			// 저장 후 저장버튼 감춤
			uiList.setActive("Confirm", false);
		}
	} // end successConfirmCallBack()
	
	// 그리드에 check 되었을시 event (gridItemList4 의 합계 계산에 사용)
	function gridListEventRowCheck(gridId, rowNum, checkType) {
		if(gridId == 'gridItemList4' && checkType) {		
			checkedSum(gridId, checkType);
		}
	}
	
	// 전체 행 선택 check box 선택 시 호출 (gridItemList4 의 합계 계산에 사용)
	function gridListEventRowCheckAl(gridId, checkType) {
		if(gridId == 'gridItemList4' && checkType) {		
			checkedSum(gridId, checkType);
		}
	}
	
	function checkedSum(gridId, checkType) {
		if (gridId == 'gridItemList4' && checkType) {
			var checkData = gridList.getSelectData(gridId);
	
			var qttaorSum = 0;
			var pltqtySum = 0;
			var boxqtySum = 0;
	
			for (var i = 0; i < checkData.length; i++) {
				var qttaor = Number(checkData[i].get("QTTAOR"));
				var pltqty = Number(checkData[i].get("PLTQTY"));
				var boxqty = Number(checkData[i].get("BOXQTY"));
	
				qttaorSum += Number(qttaor);
				pltqtySum += Number(pltqty);
				boxqtySum += Number(boxqty);
			}
	
			$("#QTTAORSUM").val(qttaorSum);
			$("#PLTQTYSUM").val(decimalPoint(pltqtySum, 1));
			$("#BOXQTYSUM").val(boxqtySum);
		}
	}
	
	// 프린트 공통 메소드
	function print(btnName) {
		var map = new DataMap();	
		var wherestr = '';
		var orderbystr = '';
		var addr = '';
		var langKy = "KO";
		var width = 595;
		var heigth = 840;
	
		if(btnName == 'Print1') {
			// 지시서 발행
			var addr = 'move_list.ezg';
			
		} else if(btnName == 'Print2'){		
			// 지시서 발행(세로)
			var addr = 'move_list_22.ezg';	
		} else {
			return;
		}
		
		var headList = gridList.getGridData('gridHeadList');
		if(headList.length > 0) {
			var head = gridList.getGridData('gridHeadList')[0]; // 해더는 0번 index만 존재
			var taskky = head.get('TASKKY');
			if(taskky.trim() != '') {
				wherestr = " AND H.TASKKY IN ('" + taskky + "')";
				WriteEZgenElement("/ezgen/" + addr, wherestr, orderbystr, langKy, map , width , heigth ); // 프린트 공통 메소드
				// 1. ezgen/ 뒤의 주소를 해당 연결된 ezgen 주소로 변경
				// 2. wherestr => 쿼리 조합을 변경
				// 3. map은 option 쿼리 가 담겨 있음 map도 쿼리 조합
			} 
			else commonUtil.msgBox('TASK_M0039'); // * 재고 이동 지시서  생성후에 출력 가능합니다. *
		}
		else commonUtil.msgBox('TASK_M0039'); // * 재고 이동 지시서  생성후에 출력 가능합니다. *
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
					<input type="button" CB="Create1 ADD BTN_NEW" />
					<input type="button" CB="Create2 ADD BTN_NEW" />				
					<input type="button" CB="Save SAVE BTN_SAVE" />
					<input type="button" CB="Confirm CNFIRM BTN_CNFIRM" />				
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
			    						<td GH="80 STD_TASOTY" GCol="text,TASOTY" GF="N 4,0" validate="required">작업타입</td>	<!--작업타입-->
			    						<td GH="80 STD_TASOTYNM" GCol="text,TASOTYNM" GF="S 100">작업타입명</td>	<!--작업타입명-->
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0">문서유형</td>	<!--문서유형-->
			    						<td GH="200 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>	<!--문서유형명-->
			    						<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 100">문서상태명</td>	<!--문서상태명-->
			    						<td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20" validate="required">작업수량</td>	<!--작업수량-->
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
					<li><a href="#tab1-3" onclick="moveTab($(this));"><span id="atab1-3">세트품</span></a></li>
					<li><a href="#tab1-4" onclick="moveTab($(this));"><span id="atab1-4">Item 리스트</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
					<div id="activBar">
						<!-- 반영 -->
						<li style="TOP: 4PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 10PX"> 
							<input type="button" CB="SetAll SAVE BTN_REFLECT" /> 
						</li>
						<!-- 사유코드 -->
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 10PX 0 2px;">
						 	<span CL="STD_RSNADJ" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						 	<select id="SEL_RSNADJ" name="SEL_RSNADJ" Combo="SajoCommon,RSNCOD_COMCOMBO" class="input"></select>
						</li>
						
						<!-- 작업 수량합계 -->
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 10PX 0 2px;">
						 	 <span>≫</span>
						 	 <span CL="STD_QTTAORS" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						 	 <span>: </span>
						 	 <span id="QTTAORSUM"></span>  
						</li>

						<!-- 팔레트 수량합계 -->
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 10PX 0 2px;">
						 	<span>≫</span>
						 	<span CL="STD_PLTQTYS" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						 	<span>: </span>
						 	<span id="PLTQTYSUM"></span>  
						</li>

						<!-- 박스 수량합계 -->
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 10PX 0 2px;">
						 	<span>≫</span>
						 	<span CL="STD_BOXQTYS" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						 	<span>: </span>
						 	<span id="BOXQTYSUM"></span>  
						</li>
					</div>
				</ul>
				<div class="table_box section" id="tab1-3">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList3">
									<tr CGRow="true"> 
										<td GH="40" GCol="rowCheck"></td>
									    <td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="160 STD_SKUKEY" GCol="input,SKUKEY,SHSKU_INFO" GF="S 20" validate="required">제품코드</td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="input,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="50 STD_PLTQTYOR" GCol="input,PLTQTYOR" GF="N 17,2" validate="required(STD_PLTQTYOR)">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="50 STD_BOXQTYOR" GCol="input,BOXQTYOR" GF="N 17,1" validate="required(STD_BOXQTYOR)">박스수량</td>	<!--박스수량-->
			    						<td GH="88 STD_QTTAOR" GCol="input,QTTAOR" GF="N 20" validate="required(STD_QTTAOR)">작업수량</td>	<!--작업수량-->
			    						<td GH="90 STD_LOTA06" GCol="select,LOTA06" validate="required(STD_LOTA06)">	<!--재고유형-->
			    							<select class="input" commonCombo="LOTA06">
			    								<option value=""></option>
			    							</select>
			    						</td>
			    						<td GH="90 STD_PTLT06" GCol="select,PTLT06" validate="required">	<!--To 재고유형-->
			    							<select class="input" commonCombo="LOTA06">
			    								<option value=""></option>
			    							</select>
			    						</td>
			    						<td GH="80 STD_LOCATG" GCol="input,LOCATG,SHLOCMA" GF="U 20" validate="required">To 로케이션</td>	<!--To 로케이션-->
			    						<td GH="90 STD_LOTA05" GCol="select,LOTA05"><!--포장구분-->
			    							<select class="input" commonCombo="LOTA05">
			    							</select>
			    						</td>	
			    						<td GH="90 STD_PTLT05" GCol="select,PTLT05">	<!--To포장구분-->
			    							<select class="input" commonCombo="LOTA05">
			    							</select>
			    						</td>	
			    						<td GH="200 STD_TASRSN" GCol="input,TASRSN">상세사유</td>	<!--상세사유-->		
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" ></td>	<!-- 팔렛당수량 -->
			    						<td GH="50 STD_QTDUOM" GCol="text,QTDUOM" GF="N 17,0"></td>	<!-- 입수 -->
									</tr>
								</tbody> 
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type="button" GBtn="find" class="search"></button>     
						<button type="button" GBtn="add" class="addBtn"></button> 
					    <button type="button" GBtn="sortReset"></button> 
					    <button type="button" GBtn="layout"></button>    
					    <button type="button" GBtn="total"></button>     
					    <button type="button" GBtn="excel"></button>     
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
				<div class="table_box section" id="tab1-4" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList4">
									<tr CGRow="true"> 
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="80 STD_CONFIRM" GCol="check,CONFIRM" GF="S 1">확인</td>	<!-- 확인 -->
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="50 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td>	<!-- 재고키 -->
			    						<td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!-- 동 -->
			    						<td GH="50 STD_QTSAVLB" GCol="text,AVAILABLEQTY" GF="N 20,0">가용수량</td>	<!-- 가용수량 -->
			    						<td GH="50 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td>	<!-- 작업타입 -->
			    						<td GH="50 STD_RSNADJ" GCol="select,RSNADJ">	<!-- 사유코드 -->
				    						<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
				    						</select>
			    						</td>
			    						<td GH="200 STD_TASRSN" GCol="input,TASRSN" GF="S 127">상세사유</td>	<!-- 상세사유 -->
			    						<td GH="88 STD_QTTAOR" GCol="input,QTTAOR" GF="N 20" validate="required">작업수량</td>	<!-- 작업수량 -->
			    						<td GH="50 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!-- 박스수량 -->
			    						<td GH="50 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!-- 박스입수 -->
			    						<td GH="50 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!-- 잔량 -->
			    						<td GH="50 STD_PLTQTY" GCol="input,PLTQTY" GF="N 17,2">팔레트수량</td>	<!-- 팔레트수량 -->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!-- 팔렛당수량 -->
			    						<td GH="50 STD_PLBQTY" GCol="text,PLBQTY" GF="S 17" style="text-align:right;" >팔렛당박스수량</td>	<!-- 팔렛당박스수량 -->
			    						<td GH="50 STD_BOXQTYOR" GCol="input,BOXQTYOR" GF="N 17,1" validate="required">박스수량</td>	<!-- 박스수량 -->
			    						<td GH="50 STD_PLTQTYOR" GCol="input,PLTQTYOR" GF="N 17,1" validate="required">팔레트수량</td>	<!-- 팔레트수량 -->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!-- 화주 -->
			    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY,SHSKU_INFO" GF="S 20" validate="required">제품코드</td>	<!-- 제품코드 -->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!-- 제품명 -->
			    						<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!-- 로케이션 -->
			    						<td GH="50 STD_TRNUSR" GCol="text,TRNUSR" GF="S 20">팔렛트ID</td>	<!-- 팔렛트ID -->
			    						<td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10">단위구성</td>	<!-- 단위구성 -->
			    						<td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3">단위</td>	<!-- 단위 -->
			    						<td GH="88 STD_QTSPUM" GCol="text,QTSPUM" GF="S 11">UPM</td>	<!-- UPM -->
			    						<td GH="50 STD_SDUOKY" GCol="text,SDUOKY" GF="S 3">기본단위</td>	<!-- 기본단위 -->
			    						<td GH="88 STD_QTSDUM" GCol="text,QTSDUM" GF="S 11">기본UPM</td>	<!-- 기본UPM -->
			    						<td GH="80 STD_LOCATG" GCol="input,LOCATG,SHLOCMA" GF="U 20" validate="required">To 로케이션</td>	<!-- To 로케이션 -->
			    						<td GH="80 STD_AREATG" GCol="text,AREATG, SHAREMA" GF="S 10">To 동</td>	<!-- To 동 -->
			    						<td GH="50 STD_TRNUTG" GCol="input,TRNUTG" GF="S 20">To 팔렛트ID</td>	<!-- To 팔렛트ID -->
			    						<td GH="80 STD_ASKU02" GCol="select,ASKU02">	<!-- 세트여부 -->
				    						<select class="input" commonCombo="ASKU02">
				    						</select>
			    						</td>
			    						<td GH="80 STD_SKUG01" GCol="select,SKUG01">	<!-- 대분류 -->
				    						<select class="input" commonCombo="SKUG01">
				    						</select>
			    						</td>
			    						<td GH="80 STD_SKUG05" GCol="select,SKUG05">	<!-- 제품용도 -->
				    						<select class="input" commonCombo="SKUG05">
				    						</select>
			    						</td>
			    						<td GH="88 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11">포장중량</td>	<!-- 포장중량 -->
			    						<td GH="88 STD_NETWGT" GCol="text,NETWGT" GF="S 11">순중량</td>	<!-- 순중량 -->
			    						<td GH="88 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!-- 중량단위 -->
			    						<td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="S 11">포장가로</td>	<!-- 포장가로 -->
			    						<td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="S 11">가로길이</td>	<!-- 가로길이 -->
			    						<td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="S 11">포장높이</td>	<!-- 포장높이 -->
			    						<td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="S 11">CBM</td>	<!-- CBM -->
			    						<td GH="88 STD_CAPACT" GCol="text,CAPACT" GF="S 11">CAPA</td>	<!-- CAPA -->
			    						<td GH="50 STD_LOTA01" GCol="text,LOTA01" GF="S 20">LOTA01</td>	<!-- LOTA01 -->
			    						<td GH="90 STD_LOTA02" GCol="select,LOTA02"> 	<!-- BATCH NO -->
			    							<select class="input" commonCombo="LOTA02">
			    							</select>
			    						</td>
			    						<td GH="50 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!-- 벤더 -->
			    						<td GH="50 STD_LOTA04" GCol="text,LOTA04" GF="S 10">LOTA04</td>	<!-- LOTA04 -->
			    						<td GH="90 STD_LOTA05" GCol="select,LOTA05">	<!-- 포장구분  -->
				    						<select class="input" commonCombo="LOTA05">
				    						</select>
			    						</td>
			    						<td GH="90 STD_LOTA06" GCol="select,LOTA06" validate="required">	<!-- 재고유형 -->
			    							<select class="input" commonCombo="LOTA06">
				    						</select>
			    						</td>
			    						<td GH="50 STD_LOTA07" GCol="text,LOTA07" GF="S 20">위탁구분</td>	<!-- 위탁구분 -->
			    						<td GH="50 STD_LOTA08" GCol="text,LOTA08" GF="S 20">LOTA08</td>	<!-- LOTA08 -->
			    						<td GH="50 STD_LOTA09" GCol="text,LOTA09" GF="S 20">LOTA09</td>	<!-- LOTA09 -->
			    						<td GH="50 STD_LOTA10" GCol="text,LOTA10" GF="S 20">LOTA10</td>	<!-- LOTA10 -->
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!-- 제조일자 -->
			    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!-- 입고일자 -->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!-- 유통기한 -->
			    						<td GH="50 STD_LOTA14" GCol="text,LOTA14" GF="D 14">LOTA14</td>	<!-- LOTA14 -->
			    						<td GH="50 STD_LOTA15" GCol="text,LOTA15" GF="D 14">LOTA15</td>	<!-- LOTA15 -->
			    						<td GH="50 STD_LOTA16" GCol="text,LOTA16" GF="S 11">LOTA16</td>	<!-- LOTA16 -->
			    						<td GH="50 STD_LOTA17" GCol="text,LOTA17" GF="S 11">LOTA17</td>	<!-- LOTA17 -->
			    						<td GH="50 STD_LOTA18" GCol="text,LOTA18" GF="S 11">LOTA18</td>	<!-- LOTA18 -->
			    						<td GH="50 STD_LOTA19" GCol="text,LOTA19" GF="S 11">LOTA19</td>	<!-- LOTA19 -->
			    						<td GH="50 STD_LOTA20" GCol="text,LOTA20" GF="S 11">LOTA20</td>	<!-- LOTA20 -->
			    						<td GH="50 STD_PTLT01" GCol="input,PTLT01" GF="S 20">To LOT01</td>	<!-- To LOT01 -->
			    						<td GH="90 STD_PTLT02" GCol="select,PTLT02">	<!-- To LOT02 -->
				    						<select class="input" commonCombo="LOTA02">
				    						</select>
			    						</td>
			    						<td GH="50 STD_PTLT03" GCol="input,PTLT03" GF="S 20">To벤더</td>	<!-- To벤더 -->
			    						<td GH="50 STD_PTLT04" GCol="input,PTLT04" GF="S 10">To LOT04</td>	<!-- To LOT04 -->
			    						<td GH="90 STD_PTLT05" GCol="select,PTLT05">	<!-- To포장구분  -->
				    						<select class="input" commonCombo="LOTA05">
				    						</select>
			    						</td>
			    						<td GH="90 STD_PTLT06" GCol="select,PTLT06" validate="required">	<!-- To 재고유형 -->
				    						<select class="input" commonCombo="LOTA06">
				    						</select>
			    						</td>
			    						<td GH="50 STD_PTLT07" GCol="input,PTLT07" GF="S 20">To LOT07</td>	<!-- To LOT07 -->
			    						<td GH="50 STD_PTLT08" GCol="input,PTLT08" GF="S 20">To LOT08</td>	<!-- To LOT08 -->
			    						<td GH="50 STD_PTLT09" GCol="input,PTLT09" GF="S 20">To LOT09</td>	<!-- To LOT09 -->
			    						<td GH="50 STD_PTLT10" GCol="input,PTLT10" GF="S 20">To LOT10</td>	<!-- To LOT10 -->
			    						<td GH="80 STD_PTLT11" GCol="input,PTLT11" GF="D 14">To제조일자</td>	<!-- To제조일자 -->
			    						<td GH="80 STD_PTLT12" GCol="input,PTLT12" GF="D 14">To입고일자</td>	<!-- To입고일자 -->
			    						<td GH="80 STD_PTLT13" GCol="input,PTLT13" GF="D 14">To 유통기한</td>	<!-- To 유통기한 -->
			    						<td GH="50 STD_PTLT14" GCol="input,PTLT14" GF="D 14">To LOT14</td>	<!-- To LOT14 -->
			    						<td GH="50 STD_PTLT15" GCol="input,PTLT15" GF="D 14">To LOT15</td>	<!-- To LOT15 -->
			    						<td GH="50 STD_PTLT16" GCol="input,PTLT16" GF="S 11">To LOT16</td>	<!-- To LOT16 -->
			    						<td GH="50 STD_PTLT17" GCol="input,PTLT17" GF="S 11">To LOT17</td>	<!-- To LOT17 -->
			    						<td GH="50 STD_PTLT18" GCol="input,PTLT18" GF="S 11">To LOT18</td>	<!-- To LOT18 -->
			    						<td GH="50 STD_PTLT19" GCol="input,PTLT19" GF="S 11">To LOT19</td>	<!-- To LOT19 -->
			    						<td GH="50 STD_PTLT20" GCol="input,PTLT20" GF="S 11">To LOT20</td>	<!-- To LOT20 -->
			    						<td GH="160 STD_SBKTXT" GCol="input,SBKTXT" GF="S 75">비고</td>	<!-- 비고 -->
			    						<td GH="80 STD_LOCASRL7141" GCol="text,PACK" GF="S 20">피킹로케이션</td>	<!-- 피킹로케이션 -->
			    						<td GH="50 STD_DTREMDAT" GCol="input,DTREMDAT" GF="N 17,0">유통잔여(DAY)</td>	<!-- 유통잔여(DAY) -->
			    						<td GH="50 STD_DTREMRAT" GCol="input,DTREMRAT" GF="S 17">유통잔여(%)</td>	<!-- 유통잔여(%) -->
									</tr>
								</tbody> 
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type="button" GBtn="find"></button>   
						<!-- <button type="button" GBtn="add" class="addBtn"></button> -->   
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