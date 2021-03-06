<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>TC05</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Master",
	    	pkcol : "KEY,OWNRKY,WAREKY,CARNUM,PTNRKY",
			command : "TC05_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
			menuId : "TC05"
// 			tempItem : "gridItemList",
// 			useTemp : true,
// 		    tempKey : "KEY"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Master",
	    	pkcol : "KEY,OWNRKY,WAREKY,CARNUM,PTNRKY",
			command : "TC05_ITEM",
			menuId : "TC05"
// 			tempHead : "gridHeadList",
// 			useTemp : true,
// 			tempKey : "KEY"
	    });
		
		//헤드 리드온리 
		gridList.setReadOnly("gridHeadList", true, ["CARTYP", "CAROPT", "CARSTS","CARGBN", "CARTMP"]);
		gridList.setReadOnly("gridItemList", true, ["PTNRKY"]);
		

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
	
	function searchList(){
			
		if(validate.check("searchArea")){
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			var param = inputList.setRangeDataParam("searchArea");
			

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
			
			netUtil.send({
				url : "/master/json/displayTC05_ITEM.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList" //그리드ID
			});
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	//로우 추가시 기본값 설정
	function gridListEventRowAddAfter(gridId, rowNum){
		if(gridId == "gridItemList"){
			//헤더를 단 하나만 체크 가능하게 만들었으므로 0번에서 가져온다.
// 			var head = gridList.getSelectData("gridHeadList");
			var headRow = gridList.getFocusRowNum("gridHeadList")
			gridList.setRowReadOnly("gridItemList",rowNum, false, ["PTNRKY"]);
			gridList.setColValue("gridItemList", rowNum, "KEY", gridList.getColData("gridHeadList", headRow, "KEY"));
			gridList.setColValue("gridItemList", rowNum, "OWNRKY", gridList.getColData("gridHeadList", headRow, "OWNRKY"));
			gridList.setColValue("gridItemList", rowNum, "WAREKY", gridList.getColData("gridHeadList", headRow, "WAREKY"));
			gridList.setColValue("gridItemList", rowNum, "CARNUM", gridList.getColData("gridHeadList", headRow, "CARNUM"));
		}
	}
	//그리드 컬럼 값 변경시 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){

		if(gridId == "gridItemList"){
			var headRow = gridList.getFocusRowNum("gridHeadList")
			gridList.setRowCheck("gridHeadList", headRow, true);
			if(colName == "PTNRKY"){ //제품코드 변경시

				var param = new DataMap();

				param.put("OWNRKY", gridList.getColData("gridHeadList",0, "OWNRKY"));
				param.put("PTNRKY", gridList.getColData("gridItemList", rowNum,"PTNRKY"));
				
				var json = netUtil.sendData({
					module : "Master",
					command : "TM05_PTNRKY",
					sendType : "list",
					param : param
				}); 
				//값이 있을 경우 
				if(json && json.data && json.data.length > 0 ){
					gridList.setColValue(gridId, rowNum, "PTNRKYNM", json.data[0].NAME01);
				}else{
					gridList.setColValue(gridId, rowNum, "PTNRKYNM", "");
				}
			}
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var headlist = gridList.getSelectData("gridHeadList", true);
			var list = gridList.getModifyData("gridItemList");
			
			if(headlist.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			for(var i=0;i < list.length;i++){
				var listMap = list[i].map;
				if(listMap.PTNRKY == null || listMap.PTNRKY == ''){
					commonUtil.msgBox("COMMON_M0009",["업체코드"]);
					return;
				}
			}
			
			//아이템 템프 가져오기
// 	        var tempItem = gridList.getModifyTempData("gridHeadList");
				
			var param = inputList.setRangeDataParam("searchArea");
				param.put("list",list);
				param.put("headlist",headlist);
// 				param.put("tempItem",tempItem);
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/master/json/saveTC05.data",
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
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
		
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		} else if (btnName == "Save") {
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "TC05");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "TC05");
		}
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

	    //작업타입
		if(searchCode == "SHBZPTN_TC"){
			param.put("OWNRKY",$("#OWNRKY").val());
		}
		return param;
	}
	
	//서치헬프 종료 이벤트
	 function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		
	  	if( searchCode == 'SHBZPTN_TC'){
			gridList.setColValue("gridItemList", gridList.getFocusRowNum("gridItemList"), "PTNRKY", rowData.get("PTNRKY"));
			gridList.setColValue("gridItemList", gridList.getFocusRowNum("gridItemList"), "PTNRKYNM", rowData.get("NAME01"));
	  	}
	 }
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			gridList.setRowCheck(gridId, rowNum, true);
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
						<dt CL="STD_CARNUM"></dt> <!-- 차량번호 -->
						<dd>
							<input type="text" class="input" name="C.CARNUM" UIInput="SR" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_PTNRKY"></dt> <!-- 업체코드 -->
						<dd>
							<input type="text" class="input" name="CF.PTNRKY" UIInput="SR,SHBZPTN_TC"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DRCARNUM"></dt> <!-- 배송코스 -->
						<dd>
							<input type="text" class="input" name="C.DESC01" UIInput="SR"/>
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
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
										<td GH="40 STD_CHECKED" GCol="rowCheck,radio" ></td>  
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>
										<td GH="140 STD_KEY" GCol="text,KEY" GF="S 10">키</td><!--키-->    
										<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td><!--화주--> 
									    <td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td><!--거점--> 
									    <td GH="75 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td><!--차량번호--> 
									    <td GH="65 STD_DESC01_C" GCol="text,DESC01" GF="S 30">차량등번</td><!--차량등번--> 
									    <td GH="72 STD_DCMPNM" GCol="text,DCMPNM" GF="S 100">운송사</td><!--운송사--> 
									    <td GH="50 STD_DRIVER" GCol="text,DRIVER" GF="S 30">기사명</td><!--기사명--> 
									    <td GH="85 STD_PERHNO" GCol="text,PERHNO" GF="S 20">기사핸드폰</td><!--기사핸드폰--> 
									    <td GH="100 STD_CARTYP" GCol="select,CARTYP">
											<select class="input" CommonCombo="CARTYP"><option></option></select>
										</td>	<!--차량 톤수-->
									    <td GH="50 STD_CARORD" GCol="text,CARORD" GF="N 3,0">배차우선순위</td><!--배차우선순위--> 
									    <td GH="50 STD_CARWHD" GCol="text,CARWHD" GF="N 22,0">차량 폭</td><!--차량 폭--> 
									    <td GH="66 STD_CARHIG" GCol="text,CARHIG" GF="N 22,0">차량 높이</td><!--차량 높이--> 
									    <td GH="68 STD_CARLNG" GCol="text,CARLNG" GF="N 22,0">차량 길이</td><!--차량 길이--> 
									    <td GH="85 STD_CARWEG" GCol="text,CARWEG" GF="N 22,0">최대적재중량</td><!--최대적재중량--> 
										<td GH="100 STD_CAROPT" GCol="select,CAROPT"> 
											<select class="input" CommonCombo="CAROPT"><option></option></select>
										</td>	<!--적재함 구분-->
					    				<td GH="120 STD_CARSTS" GCol="select,CARSTS">
					    					<select class="input" CommonCombo="CARSTS"><option></option></select>
					    				</td>	<!--차량 상태-->
					    				<td GH="150 STD_CARGBN" GCol="select,CARGBN">
					    					<select class="input" CommonCombo="CARGBN"><option></option></select>
					    				</td>	<!--차량 구분-->
					    				<td GH="120 STD_CARTMP" GCol="select,CARTMP" >
					    					<select class="input" CommonCombo="CARTMP"><option></option></select>
					    				</td>	<!--차량 온도-->
									    <td GH="86 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td><!--생성일자--> 
									    <td GH="70 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td><!--생성시간--> 
									    <td GH="50 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td><!--생성자--> 
									    <td GH="86 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td><!--수정일자--> 
									    <td GH="70 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td><!--수정시간--> 
									    <td GH="50 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td><!--수정자-->
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
										<td GH="140 STD_KEY" GCol="text,KEY" GF="S 10">키</td><!--키--> 
										<td GH="60 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td><!--화주--> 
									    <td GH="60 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td><!--거점--> 
									    <td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 30">차량번호</td><!--차량번호--> 
									    <td GH="80 STD_DESC01_C" GCol="text,DESC01" GF="S 30">권역코드</td><!--권역코드--> 
									    <td GH="80 STD_DPTNKY" GCol="input,PTNRKY,SHBZPTN_TC" GF="S 10">업체코드</td><!--업체코드--> 
									    <td GH="200 STD_DPTNKYNM" GCol="text,PTNRKYNM" GF="S 180">업체명</td><!--업체명--> 
									    <td GH="200 STD_ADDR01" GCol="text,ADDR01" GF="S 180">주소</td><!--주소--> 
									    <td GH="60 STD_SORTSQ" GCol="input,SORTSQ" GF="N 17,0">배송순서</td><!--배송순서--> 
									    <td GH="60 STD_DISTGR" GCol="input,DISTGR" GF="S 10">셀번호</td><!--셀번호--> 
									    <td GH="60 STD_CTADSC" GCol="input,CTADSC" GF="S 100">추가운임코드설명</td><!--추가운임코드설명--> 
									    <td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td><!--생성일자--> 
									    <td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td><!--생성시간--> 
									    <td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td><!--생성자--> 
									    <td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td><!--수정일자--> 
									    <td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td><!--수정시간--> 
									    <td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td><!--수정자-->
									    <td GH="80 STD_SALN01" GCol="text,SALN01" GF="S 20">영업 담당자명</td><!--영업 담당자명-->
									    
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add"></button>
						<button type='button' GBtn="delete"></button>
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