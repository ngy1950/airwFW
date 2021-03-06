<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
var stkkyField = ["WAREKY", "AREAKY",  "ZONEKY", "LOCAKY", 
        "UOMKEY", "LOTNUM", "TRUNID",  "QTSIWH", "SKUKEY",
        "LOTA03", "LOTA05", "LOTA06",  "LOTA11", "LOTA12", "LOTA13", "OBROUT"];
var stkkyDesc  = ["Warehouse key", "Area", "Zone", "Location", 
       "Unit of measure", "Lot number", "Pallet ID",  "Stock quantity", "Stock keeping unit key",
       "벤더", "포장구분", "재고유형", "제조일자", "입고일자","유통기한",  "배송순서"];
var setItemno = ["010", "020", "030", "040", "050",
       "060", "070", "080", "090", "100",
       "110", "120", "130", "140", "150", "160"];
       
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Master",
			command : "TS01",
			pkcol : "OWNRKY,WAREKY,SSORKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			menuId : "TS01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Master",
			command : "TS01_ITEM",
			menuId : "TS01"
	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "SSORKY"){
				var param = new DataMap();
					param.put("OWNRKY",gridList.getColData(gridId, rowNum, "OWNRKY"));
					param.put("WAREKY",gridList.getColData(gridId, rowNum, "WAREKY"));
					param.put("SSORKY",colValue);
				
				var json = netUtil.sendData({
					module : "Master",
					command : "TS01",
					sendType : "map",
					param : param
				});
				
				if(parseInt(json.data["CHK"]) > 0){
					alert("이미 존재하는 키 값 입니다.");
					gridList.setColValue(gridId, rowNum, colName, " ", true);
					gridList.resetGrid("gridItemList");
				}else{
					createitemrow(colValue);	
				}
			}
		}
	}
	
	function createitemrow(ssorky){
		var list = gridList.getRowNumList("gridItemList");
		if(list.length != 0){
			for(var i=0;i<list.length;i++){
				gridList.setColValue("gridItemList", i, "SSORKY", ssorky, true);
			}
		}else{
			var head = gridList.getGridData("gridHeadList")[0];
			for(var i=0;i<stkkyField.length;i++){
				var row = new DataMap();
			
				row.put("OWNRKY",head.get("OWNRKY"));
				row.put("WAREKY",head.get("WAREKY"));
				row.put("SSORKY",ssorky);
				
				row.put("ITEMNO",setItemno[i]);
				row.put("FIELDN",stkkyField[i]);
				row.put("FLDCMT",stkkyDesc[i]);
				
				gridList.addNewRow("gridItemList", row);
			}
		}
		gridList.setColFocus("gridItemList", 0, "OWNRKY");
		
// 		gridList.setRowFocus("gridItemList", 0, true);
		
	}
	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var param = gridList.getRowData(gridId, rowNum);
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
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			
			var head = gridList.getGridData("gridHeadList");
			var list = gridList.getGridData("gridItemList");
			if(head.length + list.length == 0){
				commonUtil.msgBox("SYSTEM_SAVEEMPTY");
				return;
			}
			
			var param = new DataMap();
			param.put("head",head);
			param.put("list",list);
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/master/json/saveTS01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(parseInt(json.data["CNT"]) > 0){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				gridList.resetGrid("gridItemList");
				var param = inputList.setRangeDataParam("searchArea");
					param.put("SSORKY",json.data["SSORKY"]);
				gridList.gridList({
			    	id : "gridHeadList",
			    	param : param
			    });
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Create"){
			var headnum = gridList.getGridDataCount("gridHeadList");
			if(headnum != 0){
				var sts = gridList.getRowStatus("gridHeadList", 0);
				if(sts == "C" || sts == "U"){
					if(!confirm(commonUtil.getMsg("수정중인 데이터가 존재합니다.\n계속 진행 하시겠습니까?"))){
						return;
					}
				}
			}
			gridList.resetGrid("gridHeadList");
			var row = new DataMap();
				row.put("OWNRKY",$('#OWNRKY').val());
				row.put("WAREKY",$('#WAREKY').val());
			gridList.addNewRow("gridHeadList", row);
			gridList.resetGrid("gridItemList");
			
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "TS01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "TS01");
 		}

	}
	
	 //팝업 종료 
    function linkPopCloseEvent(data){  
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
    }

	
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
				
		if(searchCode == "SHWAHMA"){
			num = rowNum;
			var param = new DataMap();
				param.put("COMPKY",'SAJO');
			return param;
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
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Save SAVE BTN_SAVE" />
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
						<dt CL="STD_ALSRKY"></dt>
						<dd>
							<input type="text" class="input" name="SSORKY" UIInput="S,SHSTSRH" validate="required(STD_ALSRKY)"/>
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs top_layout" style="height: 170px;">
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
										<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
										<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="100 STD_ALSRKY" GCol="input,SSORKY" GF="S 10">할당정렬키</td>	<!--할당정렬키-->
			    						<td GH="250 STD_SHORTX" GCol="input,SHORTX" GF="S 180">설명</td>	<!--설명-->
			    						<td GH="0 STD_STLCAT" GCol="input,STLCAT" GF="S 180">재고리스트유형</td>	<!--재고리스트유형-->
			    						
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
			<div class="content_layout tabs bottom_layout" style="height: calc(100% - 190px);">
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
			    						<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="100 STD_ALSRKY" GCol="text,SSORKY" GF="S 10">할당정렬키</td>	<!--할당정렬키-->
			    						<td GH="100 STD_ITEMNO" GCol="text,ITEMNO" GF="S 6">LineNo.</td>	<!--LineNo.-->
			    						<td GH="100 STD_FIELDN" GCol="text,FIELDN" GF="S 6">필드 명</td>	<!--필드 명-->
			    						<td GH="200 STD_FLDCMT" GCol="text,FLDCMT" GF="S 255">설명</td>	<!--설명-->
			    						<td GH="100 STD_ACTVAT" GCol="check,ACTVAT">활성화</td>	<!--활성화-->
			    						<td GH="100 STD_SORTSQ" GCol="input,SORTSQ" GF="N 4,0">배송순서</td>	<!--배송순서-->
			    						<td GH="150 STD_INDASD" GCol="select,INDASD"><!--Asc/Desc-->
												<select class="input" CommonCombo="INDASD">
													<option value=""></option>
												</select>
			    						</td>
			    						<td GH="100 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td>	<!--생성시간-->
			    						<td GH="100 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td>	<!--생성자-->
			    						<td GH="100 STD_LMODAT" GCol="text,LMODAT" GF="D 10">수정일자</td>	<!--수정일자-->
			    						<td GH="100 STD_LMOTIM" GCol="text,LMOTIM" GF="T 10">수정시간</td>	<!--수정시간-->
			    						<td GH="100 STD_LMOUSR" GCol="text,LMOUSR" GF="S 10">수정자</td>	<!--수정자-->
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
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>