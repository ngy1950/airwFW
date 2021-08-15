<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL42</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OutBoundPicking",
	    	pkcol : "TASKKY",
			command : "DL42_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "SEARCHKEY",
		    menuId : "DL42"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OutBoundPicking",
			command : "DL42_ITEM",
			tempHead : "gridHeadList",
			useTemp : true,
			tempKey : "SEARCHKEY",
		    menuId : "DL42"
	    });
		
				
		//CARDAT 하루 더하기 
		inputList.rangeMap["map"]["SR.CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		
		gridList.setReadOnly("gridHeadList", true, ["ASKU01"]);
		
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "210");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);
	 	
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "208");
		rangeArr.push(rangeDataMap);
		
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
	
	//검색 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}else if(gridId == "gridItemList"){
			var ItemList = gridList.getGridBox('gridItemList').getDataAll();
			
			for (var i=0;i<ItemList.length;i++){
				
				var itemGridBox = gridList.getGridBox('gridItemList');
				var itemList = itemGridBox.getDataAll();
				
				for(var i=0; i<itemList.length; i++){
					
					//STATIT가 FPC일경우 수정 불가
					if(gridList.getColData("gridItemList", i, "STATIT") == 'FPC' || gridList.getColData("gridItemList", i, "STATIT") == 'PPC'){
						gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true);
					}else{
						gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), false);
					}
					
				}
				
			}
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
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}	
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var item = gridList.getGridData("gridItemList");
			
			//아이템 템프 가져오기
	        var tempItem = gridList.getTempData("gridHeadList");
			var param = inputList.setRangeDataParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			param.put("tempItem",tempItem)
		
 			netUtil.send({
 				url : "/OutBoundPicking/json/saveDL42.data",
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
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
// 	CB="Search SEAR
// 		CB="Grouping GR
// 		CB="DelGroup DE
// 		CB="Print PRINT
// 		CB="Confirm CON
	
	
	//버튼 동작 연결
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Grouping"){
			grouping();
		}else if(btnName == "DelGroup"){
			delGroup();
		}else if(btnName == "Print"){
			print();
		}else if(btnName == "Confirm"){
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL42");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DL42");
		}
	}

	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//그룹핑
	function grouping(){

		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var item = gridList.getGridData("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			
			//라디오 버튼 값
			if ($('#GRPRL1').prop("checked") == true ) {
				param.put("GRPRL","ERPSO");
			}else if ($('#GRPRL3').prop("checked") == true ){
				param.put("GRPRL","MOVE");
			}else if ($('#GRPRL4').prop("checked") == true ){
				param.put("GRPRL","RTNPUR");
			};
			
			for(var i=0; i<head.length; i++){
				//그룹핑 된 내용은 또 그룹핑 되지 않음
				if(head[i].get("GRPOKY") != ' '){
					alert("* 이미 그룹핑 되었습니다. *") ;
					return;
				}
			}
			
			netUtil.send({
				url : "/OutBoundPicking/json/groupingDL42.data",  // 그룹핑 컨트롤러  url 로 지정 
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	function delGroup(){

		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var item = gridList.getGridData("gridItemList", true);
			
			var param = inputList.setRangeDataParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			

			
			for(var i=0; i<item.length; i++){
				//STATIT가 FPC일경우 삭제 불가
				if(item[i].get("STATIT") == 'FPC' || item[i].get("STATIT") == 'PPC' ){
					alert("* 이미 피킹완료된 데이터 입니다. *") ;
					return;
				}
// 				if(gridList.getColData("gridItemList", i, "STATIT") == 'FPC' || gridList.getColData("gridItemList", i, "STATIT") == 'PPC'){
// 					alert("* 이미 피킹완료된 데이터 입니다. *") ;
// 					return;
// 				}
			}
			
			netUtil.send({
				url : "/OutBoundPicking/json/delGroupDL42.data",  // 그룹핑 컨트롤러  url 로 지정 
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	

	
	//ezgen 구현
	function print(){
		
		var wherestr = " AND GRPOKY IN (";

		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			for(var i=0; i<head.length; i++){
				if(head[i].get("GRPOKY") == ' '){
					alert("* 그룹핑 번호가 없습니다. *") ;
					return;
				}
			}
			

			//구버전 FOR문으로 TASKKY 불러오는 부분 구현 아래는 구버전 소스 
//			if(!checkGroupingNumber()) return;			
//			
//			var count = 0;
//			var wherestr = " AND GRPOKY IN (";
//			for(var i=1; i<=tasdh.RowCount; i++){
//				if(tasdh.GetCellValueById(tasdh.GetRowId(i),"printChk") == "V" || tasdh.GetCellValueById(tasdh.GetRowId(i),"printChk") == "1" ){
//					if(wherestr.length > 16) wherestr += ",";
//					wherestr = wherestr + "'" + tasdh.GetCellValueById(tasdh.GetRowId(i), "grpoky") + "'";
//					count++;
//				}
//			}
//			wherestr+=") ";
			
			var where = "";
			//반복문을 돌리며 특정 검색조건을 생성한다.
			for(var i =0;i < head.length ; i++){
				
				if(where == ""){
					where = where+" AND GRPOKY IN (";
				}else{
					where = where+",";
				}
				
				where += "'" + head[i].get("GRPOKY") + "'";
				
				//그룹핑번호 체크 
				if(head[i].get("GRPOKY") == ""){

					commonUtil.msgBox("SYSTEM_NOGRPNM");
					return;
				}
			}
			where += ")";
			
			
			//이지젠 호출부 (구버전)
			//ezgenPrint("picking_list_sku.ezg", "PICK_LIST", wherestr, " ", "");
			
			//이지젠 호출부(신버전)
			var width = 840;
			var heigth = 600;
			var map = new DataMap();
			WriteEZgenElement("/ezgen/picking_list_sku.ezg" , where , " " , "KO", map , width , heigth ); // 구버전 ezgenPrint와 같다
		}
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
		//제품코드
		} else if(searchCode == "SHSKUMA" && $inputObj.name == "I.SKUKEY"){
	        param.put("WAREKY","<%=wareky %>");
	        param.put("OWNRKY","<%=ownrky %>");
		}
		return param;
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
					<input type="button" CB="Grouping GROUPING STD_PICKINGROUP" />
					<input type="button" CB="DelGroup DELGROUP STD_PICKINGDEL" />
					<input type="button" CB="Print PRINT_OUT BTN_PRINT_PKLIST" />
					<input type="button" CB="Confirm CONFIRM STD_PICKYN" />
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
						<dt CL="STD_GROUP"></dt><!-- 그룹 -->
						<dd style="width:300px">
							<input type="radio" name="GRPRL" id="GRPRL1" value="GRPRL1" checked /><label for="GRPRL1">영업(D/O)</label>
		        			<input type="radio" name="GRPRL" id="GRPRL3" value="GRPRL3"/><label for="GRPRL3">이고(Move)</label>
		        			<input type="radio" name="GRPRL" id="GRPRL4" value="GRPRL4"/><label for="GRPRL4">매입반품(P/R)</label>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TASKDT"></dt> <!-- 작업지시일자 -->
						<dd>
							<input type="text" class="input" name="TASDH.DOCDAT" UIInput="B" UIFormat="C N" />
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
						<dt CL="STD_CARNUM"></dt> <!-- 차량번호 -->
						<dd>
							<input type="text" class="input" name="SR.CARNUM" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TASOTY"></dt> <!-- 작업타입 -->
						<dd>
							<input type="text" class="input" name="TASDH.TASOTY" UIInput="SR,SHDOCTM" readonly/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SHPOKY"></dt> <!-- 출고문서번호 -->
						<dd>
							<input type="text" class="input" name="S.SHPOKY" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TASKKY"></dt> <!-- 작업지시번호 -->
						<dd>
							<input type="text" class="input" name="TASDH.TASKKY" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_AREAKY"></dt> <!-- 동 -->
						<dd>
							<input type="text" class="input" name="S.AREAKY" UIInput="SR,SHAREMA"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt> <!-- 제품코드 -->
						<dd>
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SVBELN"></dt> <!-- S/O 번호 -->
						<dd>
							<input type="text" class="input" name="S.SVBELN" UIInput="SR" />
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
										<td GH="120 STD_GRPOKY" GCol="text,GRPOKY" GF="S 20">제품별피킹번호</td> <!--제품별피킹번호-->
							            <td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
							            <td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td> <!--제품명-->
							            <td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td> <!--규격-->
							            <td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 20">거점</td> <!--거점-->
							            <td GH="160 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 20">거점명</td> <!--거점명-->
							            <td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 20">배송일자</td> <!--배송일자-->
							            <td GH="90 STD_ASKU01" GCol="select,ASKU01">
							            	<select class="input" commonCombo="ASKU01"><option></option></select> <!--포장단위-->
							            </td>
							            <td GH="80 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td> <!--세트여부-->
							            <td GH="80 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td> <!--피킹그룹-->
							            <td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td> <!--제품구분-->
							            <td GH="80 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td> <!--상온구분-->
							            <td GH="120 STD_EANCOD" GCol="text,EANCOD" GF="S 18">BARCODE(88코드)</td> <!--BARCODE(88코드)-->
							            <td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td> <!--대분류-->
							            <td GH="80 STD_SKUG02" GCol="text,SKUG02" GF="S 10">중분류</td> <!--중분류-->
							            <td GH="80 STD_SKUG03" GCol="text,SKUG03" GF="S 10">소분류</td> <!--소분류-->
							            <td GH="80 STD_SKUG04" GCol="text,SKUG04" GF="S 10">세분류</td> <!--세분류-->
							            <td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 20">제품용도</td> <!--제품용도-->
							            <td GH="0 completeCnt" GCol="text,COMPLETECNT" GF="S 8">completeCnt</td> <!--completeCnt-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
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
							            <td GH="80 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td> <!--로케이션-->
							            <td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 60">차량번호</td> <!--차량번호-->
							            <td GH="140 STD_CARNUMNM" GCol="text,CARNUMNM" GF="S 100">차량정보</td> <!--차량정보-->
							            <td GH="100 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td> <!--유통기한-->
							            <td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td> <!--작업수량-->
							            <td GH="80 STD_QTCOMP" GCol="input,QTCOMP" GF="N 20,0">완료수량</td> <!--완료수량-->
							            <td GH="120 STD_GRPOIT" GCol="text,GRPOIT" GF="S 20">제품별피킹Item</td> <!--제품별피킹Item-->
							            <td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td> <!--팔렛당수량-->
							            <td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
							            <td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
							            <td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td> <!--팔레트수량-->
							            <td GH="80 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
							            <td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td> <!--상태-->
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