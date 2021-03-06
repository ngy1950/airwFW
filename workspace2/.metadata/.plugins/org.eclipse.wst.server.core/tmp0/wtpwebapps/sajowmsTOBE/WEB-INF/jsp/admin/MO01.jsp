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
			command : "MO01",
			pkcol : "OWNRKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			menuId : "MO01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Master",
			command : "MO01_ITEM",
			menuId : "MO01"
	    });
		
		inputList.setMultiComboSelectAll($("#OWNRKY"), true);
		gridList.setReadOnly("gridItemList", true, ["WAREKY"]);
		

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
// 			gridList.setRowCheck(gridId, 0, true);
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
			var head = gridList.getSelectData("gridHeadList");
			var item = gridList.getModifyData("gridItemList", "A");
			if(head.length + item.length == 0){
				commonUtil.msgBox("SYSTEM_SAVEEMPTY");
				return;
			}
			
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/master/json/saveMO01.data",
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
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "MO01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "MO01");
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
	
	//그리드 로우 추가 전  이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == "gridItemList"){
			if($.trim(chownrky) == ""){
				alert("선택된 화주가 없습니다.");
				
				return false;
			}
			
			var newData = new DataMap();
			newData.put("OWNRKY",chownrky);
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
			if(colName == "OWNRKY"){
				chownrky = colValue;
			}
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
	
	function searchHelpEventCloseBefore(searchCode, multyType, data, selectData){
		if(searchCode == "SHWAHMA" ){
			data = "WAREKY";
			return 	data;
		}
	}
	
	//서치헬프 종료 이벤트
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		if( searchCode == 'SHWAHMA'){
			console.log(rowData);
			
			var gridId = "gridItemList"
			var rowNum = gridList.getFocusRowNum(gridId);
			gridList.setColValue(gridId, num, "WAREKY", rowData.get("WAREKY") );
			gridList.setColValue(gridId, num, "NAME01", rowData.get("NAME01") );
			gridList.setColValue(gridId, num, "ADDR01", rowData.get("ADDR01") );
			gridList.setColValue(gridId, num, "ADDR02", rowData.get("ADDR02") );
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
					<input type="button" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" comboType="MS" Combo="SajoCommon,ALL_OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DELMAK"></dt>
						<dd>
							<input type="checkbox" class="input" name="DELMAK" id="DELMAK" style="margin-top: 0px;" value="V" />
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
			    						<td GH="80 STD_OWNRKY" GCol="input,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="40 STD_DELMAK" GCol="check,DELMAK" ></td>	<!--삭제-->
			    						<td GH="180 STD_NAME01" GCol="input,NAME01" GF="S 180">업체명</td>	<!--업체명-->
			    						<td GH="120 STD_NAME02" GCol="input,NAME02" GF="S 180">대표자이름</td>	<!--대표자이름-->
			    						<td GH="120 STD_NAME03" GCol="input,NAME03" GF="S 180">대표바코드</td>	<!--대표바코드-->
			    						<td GH="120 STD_ADDR01" GCol="input,ADDR01" GF="S 180">주소</td>	<!--주소-->
			    						<td GH="80 STD_POSTCD" GCol="input,POSTCD" GF="S 30">우편번호  </td>	<!--우편번호  -->
			    						<td GH="80 STD_NATNKY" GCol="input,NATNKY" GF="S 3">국가키  </td>	<!--국가키  -->
			    						<td GH="60 STD_TELN01" GCol="input,TELN01" GF="S 20">전화번호1</td>	<!--전화번호1-->
			    						<td GH="60 STD_FAXTL1" GCol="input,FAXTL1" GF="S 20">팩스번호 </td>	<!--팩스번호 -->
			    						<td GH="80 STD_EMAIL1" GCol="input,EMAIL1" GF="S 120">이메일</td>	<!--이메일-->
			    						
			    						<td GH="200 STD_PTNG01W"   GCol="select,PTNG01">
											<select commonCombo="RECOYN"><option></option></select>
										</td><!--유통경로1-->
			    						
			    						<td GH="200 STD_PTNG02W"   GCol="select,PTNG02">
											<select commonCombo="RECOYN"><option></option></select>
										</td><!--유통경로2-->
			    						
			    						<td GH="200 STD_PTNG03W"   GCol="select,PTNG03">
											<select commonCombo="RECOYN"><option></option></select>
										</td><!--유통경로3-->
			    						
			    						<td GH="200 STD_PTNG03W"   GCol="select,PTNG04">
											<select commonCombo="RECOYN"><option></option></select>
										</td><!--유통경로4-->
			    						
			    						<td GH="200 STD_PTNG05W"   GCol="select,PTNG05">
											<select commonCombo="RECOYN"><option></option></select>
										</td><!--정산여부 Y/N-->
			    						
			    						<td GH="40 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="40 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="40 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="40 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
			    						<td GH="40 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
			    						<td GH="40 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
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
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="80 STD_WAREKY" GCol="input,WAREKY,SHWAHMA" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,NAME01" GF="S 10">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_ADDR01" GCol="text,ADDR01" GF="S 40">주소</td>	<!--주소-->
			    						<td GH="80 STD_ADDR02" GCol="text,ADDR02" GF="S 40">납품주소</td>	<!--납품주소-->							
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