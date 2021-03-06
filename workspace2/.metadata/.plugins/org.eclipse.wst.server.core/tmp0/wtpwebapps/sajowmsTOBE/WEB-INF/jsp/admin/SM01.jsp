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
var headrow = -1 , chownrky = "" , num = 0;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Master",
			command : "SM01",
			pkcol : "OWNRKY,WAREKY,MEASKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			menuId : "SM01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Master",
			command : "SM01_ITEM",
			menuId : "SM01"
	    });
		$('#addbrn').hide();

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			chownrky = "";
			
			var param = inputList.setRangeDataParam("searchArea");

			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			if(gridList.getRowStatus(gridId, rowNum) == "C"){
				return false;
			}
			
			var param = gridList.getRowData(gridId, rowNum);
			chownrky = param.get("OWNRKY");
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	function gridListEventRowCheck(gridId, rowNum, checkType){
		if(checkType){
			if(rowNum == headrow){
				return;
			}else{
				headrow = rowNum;
				gridListEventItemGridSearch("gridHeadList", rowNum ,"gridItemList");	
			}
		}
	}
	
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			if(rowNum == headrow){
				return false;
			}else{
				headrow = rowNum;
				gridList.setRowCheck(gridId, rowNum, true);
			}
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.setRowCheck(gridId, 0, true);
			gridList.resetGrid("gridItemList");
			headrow = -1;
		}else if(gridId == "gridHeadList" && dataCount > 0){
			headrow = 0;
			gridList.setRowCheck(gridId, 0, true);
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList");
			var list = gridList.getSelectData("gridItemList");
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
				url : "/master/json/saveSM01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(parseInt(json.data["CNT"]) > 0){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
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
			create();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "SM01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "SM01");
 		}

	}
	
	function create(){
		var modchk = true;
		if(gridList.checkGridModifyState()){
			modchk = false;
		}
		
		
		if(!modchk && !confirm("수정중인 데이터가 있습니다.\n데이터를 생성 하시겠습니까?")){
			return false;
		}else{
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			
			var map = new DataMap();
				map.put("OWNRKY",$('#OWNRKY').val());
				map.put("WAREKY",$('#WAREKY').val());
				
        	gridList.addNewRow("gridHeadList",map);
		}
		
		
// 		if(numlist > 1)
// 		$('#addbrn').click();
	}
	
	//그리드 로우 추가 전  이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == "gridItemList"){
			
			if(gridList.getSelectRowNumList("gridHeadList").length == 0){
				alert("선택된 단위구성이 없습니다.");
				gridList.resetGrid("gridItemList");
				return false;
			} 
			
			var row = gridList.getRowData("gridHeadList", gridList.getSelectRowNumList("gridHeadList")[0]);
			
			if($.trim(row.get("MEASKY")) == "" ){
				alert("단위 구성을 먼저 설정 하세요.");
				gridList.resetGrid("gridItemList");
				return false;
			}
			
			var newData = new DataMap();
			newData.put("OWNRKY",row.get("OWNRKY"));
			newData.put("WAREKY",row.get("WAREKY"));
			newData.put("MEASKY",row.get("MEASKY"));
			return newData;
		}
	}
	
	//그리드 로우 추가 후 이벤트
	function gridListEventRowAddAfter(gridId, rowNum){
		if(gridId == "gridItemList"){
			gridList.setRowReadOnly(gridId, rowNum, false, ["WAREKY"]);
			gridList.setColFocus(gridId, rowNum, "WAREKY");
		}else if(gridId == "gridHeadList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "MEASKY"){
				var param = gridList.getRowData(gridId, rowNum);
				var json = netUtil.sendData({
					module : "Master",
					command : "SM01",
					sendType : "map",
					param : param
				});
			}
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
<!-- 					<input type="button" CB="Create SAVE BTN_CREATE" /> -->
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
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_MEASKY"></dt> 
						<dd> 
							<input type="text" class="input" name="MEASKY" UIInput="SR,SHMEASH" validate="required(STD_MEASKY)"/> 
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
										<td GH="40 STD_CHECKED" GCol="rowCheck,radio"></td>  
			    						<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_MEASKY" GCol="input,MEASKY" GF="S 20">단위구성</td>	<!--단위구성-->
			    						<td GH="200 STD_SHORTX" GCol="input,SHORTX" GF="S 60">설명</td>	<!--설명-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="add" id="addbrn"></button>
<!--                      	<button type='button' GBtn="delete"></button> -->
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
										<td GH="40" GCol="rowCheck"></td>
				   						<td GH="0 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				   						<td GH="0 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				   						<td GH="50 STD_MEASKY" GCol="text,MEASKY" GF="S 20">단위구성</td>	<!--단위구성-->
				   						<td GH="50 STD_ITEMNO" GCol="input,ITEMNO" GF="N 6,0">LineNo.</td>	<!--LineNo.-->
				   						<td GH="50 STD_UOMKEY" GCol="input,UOMKEY" GF="S 10">단위</td>	<!--단위-->
				   						<td GH="80 STD_QTPUOM" GCol="input,QTPUOM" GF="N 20,0">Units per measure</td>	<!--Units per measure-->
				   						<td GH="50 STD_INDDFU" GCol="check,INDDFU" >기본 단위</td>	<!--기본 단위-->
				   						<td GH="50 STD_DISREC" GCol="check,DISREC" >조회 (입고)</td>	<!--조회 (입고)-->
				   						<td GH="50 STD_DISSHP" GCol="check,DISSHP" >조회 (출고)</td>	<!--조회 (출고)-->
				   						<td GH="50 STD_DISTAS" GCol="check,DISTAS" >조회 (Task)</td>	<!--조회 (Task)-->					
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
<!-- 						<button type='button' GBtn="add"></button> -->
<!--                      	<button type='button' GBtn="delete"></button> -->
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