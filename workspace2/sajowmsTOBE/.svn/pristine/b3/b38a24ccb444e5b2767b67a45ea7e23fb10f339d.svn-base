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
var newrow = false;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Master",
			command : "TP01",
			pkcol : "OWNRKY,WAREKY,PASTKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			menuId : "TP01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Master",
	    	pkcol : "OWNRKY,WAREKY,PASTKY,STEPNO",
			command : "TP01_ITEM",
			menuId : "TP01"
	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
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
			var head = gridList.getSelectData("gridHeadList", true);
			var list = gridList.getModifyData("gridItemList", "A");				//getSelectData("gridItemList", true);
			
			if(head.length + list.length == 0){
				commonUtil.msgBox("SYSTEM_SAVEEMPTY");
				return;
			}
			
			if(head.length == 0){
				var hlist = gridList.getRowNumList("gridHeadList");
				for(var i=0;i<hlist.length;i++){
					var pastky = gridList.getColData("gridHeadList", i, "PASTKY");
					if(pastky == list[0].get("PASTKY")){
						gridList.setRowCheck("gridHeadList", i, true);
						break;
					}
				}
				head = gridList.getSelectData("gridHeadList", true);
			}
			
			var param = new DataMap();
			param.put("head",head);
			param.put("list",list);
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/master/json/saveTP01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(parseInt(json.data["CNT"]) > 1){
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
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "TP01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "TP01");
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
	
	function gridListEventDataBindEnd(gridId, dataCount){
		
		if(gridId == "gridItemList" ){
			if(newrow){
				var row = gridList.getFocusRowNum("gridHeadList");
				if(row == -1) return false;
				var ownrky = gridList.getColData("gridHeadList", row, "OWNRKY");
				var wareky = gridList.getColData("gridHeadList", row, "WAREKY");
				var pastky = gridList.getColData("gridHeadList", row, "PASTKY");
				var stepno = findNextStepNo(row);
				
				var newData = new DataMap();
					newData.put("OWNRKY",ownrky);
					newData.put("WAREKY",wareky);
					newData.put("PASTKY",pastky);
					newData.put("STEPNO",stepno);
					newData.put("CAPACR",' ');
				gridList.addNewRow(gridId, newData);
				newrow = false;
			}
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == "gridHeadList"){
			var newData = new DataMap();
				newData.put("OWNRKY",$('#OWNRKY').val());
				newData.put("WAREKY",$('#WAREKY').val());
			return newData;
		}else if(gridId == "gridItemList"){
			var row = gridList.getFocusRowNum("gridHeadList");
			if(row == -1) return false;
			var ownrky = gridList.getColData("gridHeadList", row, "OWNRKY");
			var wareky = gridList.getColData("gridHeadList", row, "WAREKY");
			var pastky = gridList.getColData("gridHeadList", row, "PASTKY");
			var stepno = findNextStepNo(row);
			
			if(stepno == "search"){
				return false;
			}else{
				var newData = new DataMap();
					newData.put("OWNRKY",ownrky);
					newData.put("WAREKY",wareky);
					newData.put("PASTKY",pastky);
					newData.put("STEPNO",stepno);
					newData.put("CAPACR",' ');
				return newData;				
			}
		}
	}
	
	function findNextStepNo(row){
		var gridId = "gridItemList";
		var list = gridList.getGridData(gridId);
		
		if(list.length == 0 && !newrow){
			if(gridList.getRowStatus("gridHeadList", row) != "C"){
				gridListEventItemGridSearch("gridHeadList", row, gridId);
				newrow = true;
				return "search";
			}
		}
		
		var maxNum = 0;
		if(list.length > 0){
			for(var i = 0 ; i < list.length ; i++){
				var stepno = list[i].get("STEPNO")

				if(stepno >= maxNum){
					maxNum = stepno;
				}
			}
		}
		var nextStepNo = Number(maxNum) + 1;
		var charValue;
		if(nextStepNo <10)
			charValue = "00" + nextStepNo;
		else if(nextStepNo <100)
			charValue = "0" + nextStepNo;
		else
			charValue = nextStepNo;
		return charValue;
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
					
					<dl>  <!--적치전략키-->  
						<dt CL="STD_PASTKY"></dt> 
						<dd> 
							<input type="text" class="input" name="PASTKY" UIInput="SR,SHPASTH" /> 
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
										<td GH="100 STD_OWNRKY" GCol="text,OWNRKY"></td>
										<td GH="100 STD_WAREKY" GCol="text,WAREKY"></td>
										<td GH="100 STD_PASTKY"   GCol="input,PASTKY" validate="required" GF="U 10"></td>
										<td GH="200 STD_SHORTX"   GCol="input,SHORTX" validate="required" GF="S 50"></td>
										<td GH="100 STD_CREDAT"   GCol="text,CREDAT"  GF="D"></td>
										<td GH="100 STD_CRETIM"   GCol="text,CRETIM"  GF="T"></td>
										<td GH="100 STD_CREUSR"   GCol="text,CREUSR"></td>
										<td GH="100 STD_LMODAT"   GCol="text,LMODAT"  GF="D"></td>
										<td GH="100 STD_LMOTIM"   GCol="text,LMOTIM"  GF="T"></td>
										<td GH="100 STD_LMOUSR"   GCol="text,LMOUSR"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="add"></button>
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
										<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 4">화주</td>	<!--화주-->
			    						<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 4">거점</td>	<!--거점-->
			    						<td GH="100 STD_PASTKY" GCol="text,PASTKY" GF="S 20">적치전략키</td>	<!--적치전략키-->
										<td GH="100 STD_STEPNO" GCol="input,STEPNO" GF="S 3" validate="required">단계 번호</td>	<!--단계 번호-->
										<td GH="100 STD_LOCASR" GCol="input,LOCASR,SHLOCMA" GF="S 20">로케이션</td>	<!--로케이션-->
										<td GH="200 STD_RMTGLS"   GCol="select,RMTGLS" validate="required">
											<select CommonCombo="PATYPE" ComboCodeView=false>
												<option value="">선택</option>
											</select>
										</td><!--적치로케이션 탐색 방법-->
										<td GH="100 STD_LOCATG" GCol="input,LOCATG,SHLOCMA" GF="U 20">To 로케이션</td>	<!--To 로케이션-->
										<td GH="100 STD_ZONETG" GCol="input,ZONETG" GF="S 10">도착 구역</td>	<!--도착 구역-->
										<td GH="100 STD_CAPACR" GCol="check,CAPACR">Capa.체크 여부</td>	<!--Capa.체크 여부-->
			    						<td GH="100 STD_SRMEKY" GCol="input,SRMEKY" GF="S 10">전략/규칙 Mthd키</td>	<!--전략/규칙 Mthd키-->
			    						<td GH="100 STD_USDOCT" GCol="input,USDOCT" GF="S 4">단계에서 사용: 문서 타입</td>	<!--단계에서 사용: 문서 타입-->
			    						<td GH="100 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td>	<!--생성일자-->
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
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="add"></button>
                     	<button type='button' GBtn="delete"></button>
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