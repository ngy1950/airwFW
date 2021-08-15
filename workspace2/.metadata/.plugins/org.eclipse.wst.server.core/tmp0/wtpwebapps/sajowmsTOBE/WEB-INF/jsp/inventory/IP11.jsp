<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>IP11</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var reparam = new DataMap();
var currentSearchData = new DataMap();
var searchType = '';
var createchk = false;	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Inventory",
			command : "IP11_HEAD",
	    	itemGrid : "gridItemList",
		    menuId : "IP11"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Inventory",
			command : "IP11_ITEM",
		    menuId : "IP11"
	    });
		
		// 콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["PHSCTY", "DOCUTY_COMCOMBO"]);	
		
		uiList.setActive("Save", false);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		//setVarriantDef();
	});

	// 
	function linkPopCloseEvent(data){ //팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea", data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	} // end linkPopCloseEvent()
	
	function commonBtnClick(btnName){ // 구버전의 doCommand
		
		if (btnName == 'Savevariant') {
			sajoUtil.openSaveVariantPop("searchArea", "IP11");
		} else if (btnName == 'Getvariant') {
			sajoUtil.openGetVariantPop("searchArea", "IP11");
		} else if(btnName == "Search"){
			gridList.getGridBox('gridHeadList').itemSearch = true;
			searchList();
		} else if (btnName == 'Create') {
			gridList.getGridBox('gridHeadList').itemSearch = false;
			create();
		} else if (btnName == 'Save') {
			saveData();
		}else if(btnName == "SetChk"){
			setChk();
		}
	}// end commonBtnClick()
	
	function setChk(){
		//인풋값 가져오기
		var rsnadj = $('#SEL_RSNADJ').val();
		
		if(rsnadj == ""){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}
		
		// 그리드에서 선택 된 값 가져오기
		var selectDataList = gridList.getSelectData("gridItemList", true);
		
		for(var i=0; i<selectDataList.length; i++){
			gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "RSNADJ", rsnadj);	// 그리드 조정사유코드 값 셋팅
			
		}
	}// end setChk()
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
			
		// 조사타입 및 조정사유코드 공통코드
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "500");
			param.put("DOCUTY", "553");
			
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("OWNRKY", $("#OWNRKY").val());
			param.put("DOCCAT", "500");
			param.put("DOCUTY", "553");

		}
		return param;
	}// end comboEventDataBindeBefore()
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if(searchCode == "SHLOCMA"){ // 동
        	param.put("WAREKY",$("#WAREKY").val());
        } else if(searchCode == '"SHZONMA"') {
        	param.put("WAREKY",$("#WAREKY").val());
        } else if(searchCode == 'SHLOCMA') {
        	param.put("WAREKY",$("#WAREKY").val());
        } else if(searchCode == 'SHSKUMA') {
        	param.put("OWNRKY",$("#OWNRKY").val());
        	param.put("WAREKY",$("#WAREKY").val());        
        } else if(searchCode == 'SHLOTA03CM') {
        	param.put("OWNRKY",$("#OWNRKY").val());
        }
        
    	return param;
    }
	
	// 서치헬프가 닫히기 직전 호출
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData)  {
		var gridId = 'gridItemList';
		var rowNum = gridList.getSelectIndex(gridId); // 현재 수정되는 행의 rowNum Index
		if(searchCode == 'SHLOCMA') { // 로케이션
			gridList.setColValue(gridId, rowNum, 'AREAKY', rowData.get('AREAKY'));
			gridList.setColValue(gridId, rowNum, 'ZONEKY', rowData.get('ZONEKY'));
		} else if(searchCode == 'SHSKUMA') { // 제품코드
			param = rowData;
			param.put('ROWNUM', rowNum);
			
			netUtil.send({
				url : "/inventory/json/getDataIP11.data",
				param : param,
				successFunction : "successGetCallBack"
			});
		}
	}// end searchHelpEventCloseAfter()
	
	// 서치헬프에서 모자란 데이터를 채우려 요청보냄
	function successGetCallBack(json) {
		if(json) {
			var gridId = 'gridItemList';
			var data = json.data;
			gridList.setColValue(gridId, data.ROWNUM, 'DESC01', data.DESC01);
			gridList.setColValue(gridId, data.ROWNUM, 'DESC02', data.DESC02);
			gridList.setColValue(gridId, data.ROWNUM, 'UOMKEY', data.DUOMKY);
			gridList.setColValue(gridId, data.ROWNUM, 'QTDUOM', data.QTDUOM);
			gridList.setColValue(gridId, data.ROWNUM, 'LOTA12', data.LOTA12);
			currentSearchData.put(data.ROWNUM + '', {"rowNum" : data.ROWNUM, "outdmt" : data.OUTDMT});
		}
	}
	
	// grid column value 변경 시 호출되는 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue) {
		if(gridId == 'gridItemList') {
			var rowNum = gridList.getSelectIndex(gridId);
			if(colName == 'QTSPHY') {	
				var qtyStl = gridList.getColData(gridId, rowNum, "QTYSTL"); //QTYSTL(전산재고)에 가용QTY를 넣고  
				var value = eval(eval(colValue)-eval(qtyStl));
				
				gridList.setColValue(gridId, rowNum, 'QTADJU', value);
			} else if(colName == "LOTA13"){
				var skukey = gridList.getColData(gridId, rowNum, "SKUKEY");
				if(skukey == "" || skukey == " "){
					commonUtil.msgBox("제품코드를 입력해주세요");
					gridList.setColValue(gridId, rowNum, "LOTA13", " "); // 제품코드 미입력 시 유통기한 입력불가
					return;
				}
				var outdmt = gridList.getColData(gridId, rowNum, "OUTDMT");
				var lota13 = gridList.getColData(gridId, rowNum, "LOTA13");
				
				var lota11 = dateParser(lota13 , 'S', 0 , 0 , -Number(outdmt));
				gridList.setColValue(gridId, rowNum, "LOTA11", lota11);	
				
			} else if(colName == "SKUKEY"){
				gridList.setColValue(gridId, rowNum, "QTADJU", 0);
				gridList.setColValue(gridId, rowNum, "QTSPHY", 0);
				
				 //제품코드 변경시
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
				
			}else if(colName == "LOTA11"){
				var outdmt = gridList.getColData(gridId, rowNum, "OUTDMT");
				var lota11 = gridList.getColData(gridId, rowNum, "LOTA11");
				var lota13 = dateParser(lota11 , 'S', 0 , 0 , Number(outdmt));
				var skukey = gridList.getColData(gridId, rowNum, "SKUKEY");
				
				if(skukey == "" || skukey == " "){
					commonUtil.msgBox("제품코드를 입력해주세요");
					gridList.setColValue(gridId, rowNum, "LOTA11", " "); // 제품코드 미입력 시 유통기한 입력불가
					return;
				}
				
				if(lota11.trim() == "") return;
				
				lota13 = dateParser(lota11 , 'S', 0 , 0 , Number(outdmt));
				gridList.setColValue(gridId, rowNum, "LOTA13", lota13);
				
			}
		}
	} //end gridListEventColValueChange()
	
	// 조회
	function searchList(){
		if(validate.check("searchArea")) {
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
		
			param.put('PHYIKY', "");
			param.put('DOCCAT', '500');
			param.put('PHSCTY', '553');
			param.put('INDDCL', 'V');
			param.put('PHSCTYNM', '재고조정');
			param.put('WAREKY', $('#WAREKY').val());
			param.put('OWNRKY', $('#OWNRKY').val());
			
 			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
 			uiList.setActive("Save", true);
 			$('.addBtn').show();
		}
	}// end searchList()
	
	// 아이템 그리드
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList) {
		if(gridId == 'gridHeadList') {			
			var id = 'gridItemList';	
			var param = new DataMap();
			if(searchType == 'checked') {
				searchType = '';
				var selectHeadData = gridList.getRowData(gridId, rowNum);
				// console.log(selectHeadData);
				var wareky = head.get('WAREKY');
				// console.log(wareky);
				param = selectHeadData;
			} else {
				if(validate.check('searchArea')) {
					var rowData = gridList.getRowData(gridId, rowNum);
					param = inputList.setRangeParam('searchArea');
					param.putAll(rowData);
				}			
			}
			gridList.gridList({
				id : id,
				param : param
			});
		}
	}// end gridListEventItemGridSearch()
	
	// var headRow = -1;
	// 1. 해더에서 더블클릭한 row의 checkBox를 체크한다.
	function gridListEventRowDblclick(gridId, rowNum) {
		// console.log('1 - gridListEventRowDblclick(gridId, rowNum) : ', gridId, rowNum);
		if(gridId == "gridHeadList"){
			// if(rowNum == headRow){
				// return false;
			// } else {
				// headRow = rowNum;
				// gridList.setRowCheck(gridId, rowNum, true);
			// }
			searchType = 'checked';
			// gridList.setRowCheck(gridId, rowNum, true);
		}
	} // end gridListEventRowDblclick()
	
	// 2. checkBox의 check된 값으로 itemGrid만 조회 한다.
	/* function gridListEventRowCheck(gridId, rowNum, checkType) {
		console.log('2 - gridListEventRowCheck(gridId, rowNum, checkType) : ', gridId, rowNum, checkType);
		if(checkType){
			if(rowNum == headRow){
				return;
			} else {
				headRow = rowNum;
				gridListEventItemGridSearch("gridHeadList", rowNum ,"gridItemList");	
			}
		}
	} // end gridListEventRowCheck() */
	
	
	function gridListEventRowCheck(gridId, rowNum, checkType){
		if(checkType){
			var qtsphy = Number(gridList.getColData(gridId, rowNum, "QTSPHY"));
			
			// 재고조사수량 0입력 시 조정수량 계산
			if(qtsphy == 0){
				gridListEventColValueChange(gridId, rowNum, "QTSPHY", 0);
			}
		}
	}
	
	
	// 3. check시 변수화 했던 headRow를 초깃값으로 변경
	// grid 조회 시 data 적용이 완료된 후
	function  gridListEventDataBindEnd(gridId, dataLength, excelLoadType) { 
		// console.log('3 - gridListEventDataBindEnd(gridId, dataLength, excelLoadType) : ', gridId, dataLength, excelLoadType);
		
		gridList.getGridBox(gridId).viewTotal(true);
		if(gridId == "gridItemList"){
			gridList.setReadOnly("gridItemList", true, ["LOCAKY", "SKUKEY","LOTA06","LOTA11","LOTA13"]);
			
		}
		// headRow = -1;
	} // end gridListEventDataBindEnd()
	
	// 생성
	function create() {
		createchk = true;
		searchList();
		gridList.resetGrid('gridItemList');
		gridList.setAddRow('gridItemList');
		gridList.setReadOnly("gridItemList", false, ["LOCAKY", "SKUKEY","LOTA06","LOTA11","LOTA13"]);
		uiList.setActive("Save", true);
		$('.addBtn').show();
	} // end create()
	
	// 저장
	function saveData() {

		var headList = gridList.getGridData('gridHeadList');
		var head = gridList.getGridData('gridHeadList')[0];
		if(head.get('INDDCL') == 'V' || head.get('INDDCL') == '1') {
			var docdat = head.get('DOCDAT');
			var yy = docdat.substr(0,4);
			var mm = docdat.substr(4,2);
		    var dd = docdat.substr(6,2);
		    var sysdate = new Date(); 
		 	var date = new Date(Number(yy), Number(mm)-1, Number(dd));
		    if(Math.abs((date-sysdate)/1000/60/60/24) > 10){
				commonUtil.msgBox("VALID_DATECHK") ;
				return;
			}
		    
		    var item = gridList.getSelectData('gridItemList');
		    
		    if(item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
		    
			    for(var i=0; i<item.length; i++){
			    	var itemMap = item[i].map;
			    	
			    	if(itemMap.LOTA06 == "" || itemMap.LOTA06 == " "){
						gridList.setColValue("gridItemList", item[i].get("GRowNum"), "LOTA06", "00"); // 재고유형 미 선택시 "정상재고" 셋팅
					}
			    	
			    	if(itemMap.RSNADJ == "" || itemMap.RSNADJ == " "){
						commonUtil.msgBox("조정사유코드를 입력해주세요.");
						return;
					}
			    	
			    	if(itemMap.LOTA11 == "" || itemMap.LOTA11 == " "){
						commonUtil.msgBox("제조일자를 입력해주세요.");
						return;
					}
			    }
		    
		    param = inputList.setRangeParam('searchArea');
		    item = gridList.getSelectData("gridItemList", true);
		    param.put('head', headList);
		    param.put('item', item);
		    param.put("CREUSR", "<%=userid%>");
			param.put("LMOUSR", "<%=userid%>");
			param.put("INDDCL", "V");
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
				// 저장하시겠습니까?
				return;
			}

			netUtil.send({
				/* url : "/inventory/json/saveIP11.data", */
				url : "/inventory/json/saveIP04.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	// end saveData()
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				gridList.setColValue("gridHeadList", 0, "PHYIKY", json.data["PHYIKY"]);
				commonUtil.msgBox("SYSTEM_SAVEOK");
	
				//저장 후  재조회
 				var param = new DataMap();
 				param.put("PHYIKY", json.data["PHYIKY"]);
 				param.put("OWNRKY", $("#OWNRKY").val());
 				param.put("WAREKY", $("#WAREKY").val());
 				
 				netUtil.send({
 		    		module : "Inventory",
 					command : "IP13_ITEM",
 					bindType : "grid",
 					sendType : "list",
 					bindId : "gridItemList",
 			    	param : param
 				});
 				
 				uiList.setActive("Save", false);

			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
/* 	
	// 저장 후 타는 함수
	function successSaveCallBack(json, status) {
		if(json && json.data){
			if(json.data["RESULT"] == "M"){ //saveData() 성공 시 // 재고이동(TASDH,TASDI,TASDR) Insert 로직태움
				switch(json.data["M"]) {
					case "S":
						// key, value, column
						commonUtil.msgBox(json.data["C"], json.data["PHYIKY"], "PHYIKY");
						reSearch(json.data);
						$('.addBtn').hide();
						break;
					case "F":
						commonUtil.msgBox(json.data["C"]);
						break;
				}
			} else {
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}// end successSaveCallBack
	 */

	// 재조회
	function reSearch(data) {
		param = new DataMap();
		param.put("OWNRKY", data.OWNRKY);
		param.put("WAREKY", data.WAREKY);
		param.put("head", data.head);
		param.put("item", data.item);
		
		netUtil.send({
			url : "/inventory/json/reSearchIP11.data",
			param : param,
			successFunction : "successReSearchCallBack"
		});	
	} // end reSearch()
	
	// 재조회 콜백
	function successReSearchCallBack(json) {
		if(json && json.data) {
			var headList = json.data.head
			var itemList = json.data.item
			
			// 그리드에 데이터 적용
			// addNewRow(gridId, [rowData]) : 새로운 행 추가
			var gridId = 'gridHeadList';
			for(var i = 0; i < headList.length; i++) {
				for(var key in headList[i]) {
					gridList.setColValue(gridId, i, key, headList[i][key]);	
				}
			}
			
			gridId = 'gridItemList';
			var readonlyCol = ["rowCheck"];
			for(var i = 0; i < itemList.length; i++) {
				for(var key in itemList[i]) {
					readonlyCol.push(key);
					gridList.setColValue(gridId, i, key, itemList[i][key]);	
				}				
			// - setRowReadOnly(gridId, rowNum, readonlyType, [colList]) : 그리드 행 또는 행의 컬럼에 readonly 지정
				gridList.setRowReadOnly(gridId, i, true, readonlyCol);
			}
			
			
			uiList.setActive("Save", false);
		}
	}
	
	// 날짜 계산 함수
	function getNewDate(colName, colValue, outdmt) { // colValue => 20210325
		var colYear = Number(colValue.substring(0, 4));
		var colMonth = Number(colValue.substring(4, 6));
		var colDate = Number(colValue.substring(6, 8));
		var colDay = new Date(colYear, colMonth, colDate);
		
		var result = null;
		var resultYear = '';
		var resultMonth = '';
		var resultDate = '';
		if(colName == 'LOTA11') {			
			colDay.setDate(colDate + Number(outdmt));
			
			position(colDay);
		} else if(colName == 'LOTA13') {
			colDay.setDate(colDate - Number(outdmt));
			
			position(colDay);
		}
		
		function position(value) {
			resultYear = value.getFullYear();
			
			resultMonth = value.getMonth();
			if(resultMonth < 10) {
				resultMonth = "0" + resultMonth;
			}
			
			resultDate = value.getDate();
			if(resultDate < 10) {
				resultDate = "0" + resultDate; 
			}
		}
		
		result = resultYear + resultMonth + resultDate;
		return result;
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
					<input type="button" CB="Search POPUP BTN_RUN" />
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

					<dl>  <!--동-->  
						<dt CL="STD_AREAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.AREAKY" UIInput="SR,SHAREMA"/> 
						</dd> 
					</dl> 
					
					<!-- 존 -->
					<dl>
						<dt CL="STD_ZONEKY"></dt> 
						<dd>
							<input type="text" class="input" name="S.ZONEKY" UIInput="SR,SHZONMA"/>
						</dd>
					</dl>
					<!-- 로케이션 -->
					<dl>
						<dt CL="STD_LOCAKY"></dt> 
						<dd>
							<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA"/>
						</dd>
					</dl>
					<!-- 제품코드 -->
					<dl>
						<dt CL="STD_SKUKEY"></dt> 
						<dd>
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/>
						</dd>
					</dl>
					<!-- 제품명 -->
					<dl>
						<dt CL="STD_DESC01"></dt> 
						<dd>
							<input type="text" class="input" name="S.DESC01" UIInput="SR"/>
						</dd>
					</dl>
					<!-- 팔레트ID -->
					<dl>
						<dt CL="STD_TRNUID"></dt> 
						<dd>
							<input type="text" class="input" name="S.TRNUID" UIInput="SR"/>
						</dd>
					</dl>
					<!-- 유통기한 -->
					<dl>
						<dt CL="STD_LOTA13"></dt> 
						<dd>
							<input type="text" class="input" name="S.LOTA13" UIInput="R" UIFormat="C"/>
						</dd>
					</dl>
					<!-- 입고일자 -->
					<dl>
						<dt CL="STD_LOTA12"></dt> 
						<dd>
							<input type="text" class="input" name="S.LOTA12" UIInput="R" UIFormat="C"/>
						</dd>
					</dl>
					<!-- 벤더 -->
					<dl>
						<dt CL="STD_LOTA03"></dt> 
						<dd>
							<input type="text" class="input" name="S.LOTA03" UIInput="SR,SHLOTA03CM"/>
						</dd>
					</dl>
					<!-- 포장구분 -->
					<dl>
						<dt CL="STD_LOTA05"></dt> 
						<dd>
							<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05"/>
						</dd>
					</dl>
					<!-- 재고유형 -->
					<dl>
						<dt CL="STD_LOTA06"></dt> 
						<dd>
							<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA06"/>
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
										<!-- <td GH="40" GCol="rowCheck"></td> -->
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="80 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td>	<!-- 재고조사번호 -->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!-- 거점 -->
			    						<td GH="50 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!-- 문서유형 -->
			    						<td GH="90 STD_PHSCTY" GCol="select,PHSCTY"> 	<!-- 조사타입 -->
			    							<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO">
			    							</select>
			    						</td>
			    						<td GH="120 STD_DOCDAT" GCol="input,DOCDAT" GF="D 10">문서일자</td>	<!-- 문서일자 -->
			    						<td GH="90 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td>	<!-- 생성일자 -->
			    						<td GH="90 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td>	<!-- 생성시간 -->
			    						<td GH="90 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!-- 생성자 -->
			    						<td GH="90 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td>	<!-- 비고 -->
									</tr>
								</tbody>
							</table>
						</div> 
					</div>
					<div class="btn_lit tableUtil">
					    <button type="button" GBtn="find"></button>      
					    <button type="button" GBtn="sortReset"></button> 
					    <button type="button" GBtn="layout"></button>       
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
					
					<!-- 사유코드 -->
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 10PX 0 2px;">
					 	<span CL="STD_RSNADJ" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
					 	<select id="SEL_RSNADJ" name="SEL_RSNADJ" Combo="SajoCommon,RSNCOD_COMCOMBO" class="input"></select>
					</li>
								
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
						<input type="button" CB="SetChk SAVE BTN_PART" />
					</li>
<!-- 					반영
					<li style="TOP: 4PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 10PX"> 
						<input type="button" CB="SetAll SAVE BTN_REFLECT" /> 
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
										<!--화면에 조회 값과 상관없이 로우 선택하는 체크박스 확인   -->
										<td GH="40" GCol="rowCheck"></td>
										<td GH="90 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td>	<!--재고조사번호-->
			    						<td GH="80 STD_PHYIIT" GCol="text,PHYIIT" GF="S 6">재고조사item</td>	<!--재고조사item-->
			    						<td GH="60 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="60 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
			    						<td GH="100 STD_LOCAKY" GCol="input,LOCAKY,SHLOCMA" GF="S 20" validate="required">로케이션</td>	<!--로케이션-->
			    						<td GH="160 STD_SKUKEY" GCol="input,SKUKEY,SHSKUMA" GF="S 20" validate="required">제품코드</td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="200 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="50 STD_QTSIWH" GCol="text,QTSIWH" GF="N 20,0">재고수량</td>	<!--재고수량-->
			    						<td GH="60 STD_QTSPHY" GCol="input,QTSPHY" GF="N 20,0" validate="required">재고조사수량</td>	<!--재고조사수량-->
			    						<td GH="80 STD_QTADJU" GCol="text,QTADJU" GF="N 20">조정수량</td>	<!--조정수량-->
			    						<td GH="110 STD_RSNADJ" GCol="select,RSNADJ" > 	<!--조정사유코드-->
			    							<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option value=" "></option>
											</select>
			    						</td>
			    						<td GH="50 STD_UOMKEY" GCol="input,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="160 STD_QTDUOM" GCol="text,QTDUOM" GF="N 20,0">입수</td>	<!--입수-->
			    						<td GH="160 STD_LOTA06" GCol="select,LOTA06">	<!--재고유형-->
			    							<select class="input" CommonCombo="LOTA06">재고유형</select>
			    						</td>
			    						<td id="LOTA11" GH="112 STD_LOTA11" GCol="input,LOTA11" GF="C 10" validate="required">제조일자</td>	<!--제조일자-->
			    						<td GH="112 STD_LOTA12" GCol="text,LOTA12" GF="C 14">입고일자</td>	<!--입고일자-->
			    						<td id="LOTA13" GH="112 STD_LOTA13" GCol="input,LOTA13" GF="C 14" validate="required">유통기한</td>	<!--유통기한-->
			    						<td GH="112 STD_QTYSTL" GCol="text,QTYSTL" GF="N 14">전산재고</td>	<!--전산재고-->
			    						<td GH="112 STD_USEQTY" GCol="text,USEQTY" GF="N 14">가용수량</td>	<!--가용수량	-->
			    						<td GH="112 STD_QTSALO" GCol="text,QTSALO" GF="N 14">할당수량</td>	<!--할당수량-->
			    						<td GH="112 STD_QTSPMI" GCol="text,QTSPMI" GF="N 14">입고중</td>	<!--입고중-->
			    						<td GH="112 STD_QTSPMO" GCol="text,QTSPMO" GF="N 14">이동중</td>	<!--이동중-->
			    						<td GH="112 STD_QTSBLK" GCol="text,QTSBLK" GF="N 14">보류수량</td>	<!--보류수량-->
			    						<td GH="112 STD_ENDCK" GCol="text,INDDCL" GF="S 14">완료</td>	<!--완료-->
			    						<td GH="160 STD_OUTDMT" GCol="input,OUTDMT" GF="N 20,0">LOTA16</td>	<!--LOTA16-->
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
						<button type="button" GBtn="add" class="addBtn"></button>    
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