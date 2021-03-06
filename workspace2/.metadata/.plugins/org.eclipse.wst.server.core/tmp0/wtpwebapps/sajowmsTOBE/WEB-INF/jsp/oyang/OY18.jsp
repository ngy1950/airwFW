<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>OY18</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){	
		gridList.setGrid({
	    	id : "gridList1",
			module : "OyangOutbound",
			command : "OY18_1",
		    menuId : "OY18"
// 			pkcol : "SKUKEY"
	    });
		gridList.setGrid({
	    	id : "gridList2",
			module : "OyangOutbound",
			command : "OY18_2",
		    menuId : "OY18"
	    });
		
		//검색조건 입고유형 셀렉트
		inputList.setMultiComboSelectAll($("#DIRTYP"), true);
		
		//ReadOnly 설정(아이템 그리드  권한 막기)
		gridList.setReadOnly("gridList1",true,["LABEL","DIRTYP","TYPSN"])
// 		gridList.setReadOnly("gridList1",true,["DIRTYP","TYPSN"])
		$("#sBtn2").hide();
		
	});
		
	function searchList(){
		$('#atab1-1').trigger("click");
	}
	
	function display1(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
			var param = inputList.setRangeMultiParam("searchArea");
			
			gridList.gridList({
		    	id : "gridList1",
		    	param : param
		    });
			
			$("#sBtn1").show();
			$("#sBtn2").hide();
		}
	}
	function display2(){
		if(validate.check("searchArea")){
	 		gridList.resetGrid("gridList1");
	 		gridList.resetGrid("gridList2");
			var param = inputList.setRangeMultiParam("searchArea");
	
			gridList.gridList({
		    	id : "gridList2",
		    	param : param
		    });
		}
		
		$("#sBtn2").show();
		$("#sBtn1").hide();
		
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("LANGCODE","<%=langky%>");
		newData.put("LABELTYPE","WMS");
		return newData;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			return param;
		}else if(comboAtt == "OyangOutbound,COMBO_DIRTYP"){
			param.put("CMCDKY", "DIRTYP"); 
			
		}else if(comboAtt == "OyangOutbound,COMBO_USEYN"){
			param.put("CMCDKY", "USEYN"); 
			//제품코드
        }
		return param;
	}
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(colName == "SKUKEY"){
			
			if(colValue == "NNNNNN") return;
			
			var param = new DataMap();
			param.put("OWNRKY", "2300");
			param.put("SKUKEY", gridList.getColData(gridId, rowNum, colName));
			
			var json = netUtil.sendData({
				module : "SajoCommon",
				command : "SKUMA_GETDESC",
				sendType : "list",
				param : param
			}); 
			
			//sku가 있을 경우 
			if(json && json.data && json.data.length > 0 ){
				gridList.setColValue(gridId, rowNum, "DESC01", json.data[0].DESC01);
			}else{
				gridList.setColValue(gridId, rowNum, "SKUKEY", "");
			}
		}
		
		if(colName == "LABEL"){
			var param = new DataMap();
			param.put("OWNRKY", "2300");
			param.put("LABEL", gridList.getColData(gridId, rowNum, colName));
			
			var json = netUtil.sendData({
				module : "OyangOutbound",
				command : "COMBO_DIRTYP",
				sendType : "map",
				param : param
			}); 
			//select값 가져오기
			if(json && json.data && json.data.length > 0 ){
				$('select[name = DIRTYP]').val(json.data.USARG1);
			}else{
				gridList.setColValue(gridId, rowNum, "DIRTYP", json.data["USARG1"]);
				gridList.setColValue(gridId, rowNum, "TYPSN", json.data["CDESC1"]);
			}
						
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList1", "all")){
			var list = gridList.getModifyList("gridList1", "A")
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			var param = dataBind.paramData("searchArea");
			var param = new DataMap();
			param.put("list",list);
			
			//유효성검사
			for(var i=0; i<list.length; i++){
				var gridMap = list[i].map;
				if (gridList.getColData("gridList1", list[i].get("GRowNum"), "SKUKEY").trim() == "" || gridList.getColData("gridList1", list[i].get("GRowNum"), "SKUKEY").trim() == null){
					commonUtil.msgBox("* 제품코드를 입력해주세요. *");
					return;
			
				}else if (gridList.getColData("gridList1", list[i].get("GRowNum"), "LABEL").trim() == "" || gridList.getColData("gridList1", list[i].get("GRowNum"), "LABEL").trim() == null){
					commonUtil.msgBox("* 라벨을 선택해주세요. *");
					return;
				}	
			}
			
			//저장하시겠습니까?
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ 
				return;
			}
			
			netUtil.send({
				url : "/OyangOutbound/json/saveOY18.data",
				param : param,
				successFunction : "successSaveCallBack",
			});
		}
	}
		
	//OY18_2 update저장 
	function saveData2(){
		if(gridList.validationCheck("gridList2", "all")){
			var list = gridList.getModifyList("gridList2", "A")
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var param = dataBind.paramData("searchArea");
			var param = new DataMap();
			param.put("list",list);
			
			//저장하시겠습니까?
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ 
				return;
			}
			
			netUtil.send({
				url : "/OyangOutbound/json/saveOY18_2.data",
				param : param,
				successFunction : "successSaveCallBack",
			});
		}
	}

	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
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
		}else if(btnName == "Save2"){
			saveData2();
		}else if(btnName == "Reload"){
			reloadLabel();
			
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "OY18");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "OY18");
		}else if(btnName == "Reload"){
			reloadLabel();
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
		//그리드 제품코드
		if(searchCode == "SHSKUMA2" && $inputObj.name == "OS.SKUKEY"){
			param.put("OWNRKY","<%=ownrky %>");	
	    //라벨 설치헬프   
		}else if(searchCode == "SHCMCDV"){
			param.put("CMCDKY","PRODBOX");	
		}
		return param;
	}
	
	
	//아이템그리드'벤더' 서치헬프 종료 이벤트
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		if( searchCode == 'SHSKUMA2'){
			gridList.setColValue("gridList1", gridList.getFocusRowNum("gridList1"), "DESC01", rowData.get("DESC01"));
		}else if(searchCode == "SHCMCDV"){ //라벨 설치헬프 
			gridList.setColValue("gridList1", gridList.getFocusRowNum("gridList1"), "TYPSN", rowData.get("CDESC1"));
			gridList.setColValue("gridList1", gridList.getFocusRowNum("gridList1"), "DIRTYP", rowData.get("USARG1"));
		}
	}
	
	function reloadLabel(){
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
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
						<input type="button" CB="Save SAVE BTN_SAVE" id="sBtn1"/>
						<input type="button" CB="Save2 SAVE BTN_SAVE" id="sBtn2"/>
					<input type="button" CB="Reload RESET STD_REFLBL" />
					</div>
				</div>
				<div class="search_inner">
						<div class="search_wrap ">
						<dl>
							<dt CL="STD_DIRTYP"></dt> <!-- 배송유형 -->
							<dd>
								<select name="DIRTYP" id="DIRTYP" class="input" Combo="OyangOutbound,COMBO_DIRTYP" comboType="MS"></select>
							</dd>
						</dl>
						<dl>  <!--제품코드-->  
							<dt CL="STD_SKUKEY"></dt> 
							<dd> 
								<input type="text" class="input" name="OS.SKUKEY" UIInput="SR,SHSKUMA2"/> 
							</dd> 
						</dl>  
<!-- 						<dl> -->
<!-- 							<dt CL="STD_DELYN"></dt> 사용여부 -->
<!-- 							<dd> -->
<!-- 								<select name="DELYN" id="DELYN" class="input" Combo="OyangOutbound,COMBO_USEYN" comboType="MS"></select> -->
<!-- 							</dd> -->
<!-- 						</dl> -->
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more" onclick="searchMore()" />
					</div>
				</div>
			</div>
			<div class="search_next_wrap">
				<div class="content_layout tabs">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1" onclick="display1()" id = "atab1-1"><span>제품관리</span></a></li>
						<li><a href="#tab1-2" onclick="display2()"><span>라벨관리</span></a></li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList1">
										<tr CGRow="true">
				    						<td GH="40 STD_NUMBER" GCol="rownum">1</td>
				    						<td GH="120 STD_LABEL" GCol="input,LABEL,SHCMCDV" GF="S 100" validate="required">라벨</td><!--라벨-->
				    						<td GH="160 STD_DIRTYP" GCol="select,DIRTYP">	<!--배송유형-->
												<select class="input" Combo="OyangOutbound,COMBO_DIRTYP" name="DIRTYP">
													<option>배송유형을 선택해주세요.</option> 
												</select>
				    						</td> 
				    						<td GH="100 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td>	<!--비고-->
				    						<td GH="60 STD_TYP_SN" GCol="text,TYPSN" GF="S 100">유형순번</td>	<!--유형순번-->
				    						<td GH="120 STD_SKUKEY" GCol="input,SKUKEY,SHSKUMA2" GF="S 20" validate="required">제품코드</td> <!--제품코드-->
				    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 100">제품명</td>	<!--제품명-->
				    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 20">생성일자</td>	<!--생성일자-->
				    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 20">생성시간</td>	<!--생성시간-->
				    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
				    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 20">수정일자</td>	<!--수정일자-->
				    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 20">수정시간</td>	<!--수정시간-->
				    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
<!-- 				    						<td GH="100 STD_DELYN" GCol="select,DELYN">	사용여부 -->
<!-- 												<select class="input" Combo="OyangOutbound,COMBO_USEYN"> -->
<!-- 												</select> -->
<!-- 				    						</td> -->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="total"></button>
<!-- 							<button type='button' GBtn="add"></button> --> <!-- 추가 삭제 주석처리 2021.05.11 -->
<!-- 							<button type='button' GBtn="delete"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
					<div class="table_box section" id="tab1-2">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridList2">
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td>
<!-- 											<td GH="40" GCol="rowCheck"></td> -->
											<td GH="80 STD_LANGKY" GCol="text,LANGCODE"></td> <!-- 언어 -->
											<td GH="80 STD_LABELTYPE" GCol="text,LABELTYPE"></td> <!-- 라벨타입 -->
											<td GH="80 STD_LABLGR" GCol="text,LABELGID"></td> <!-- 라벨그룹 -->
											<td GH="160 STD_LABLKY" GCol="text,LABELID"></td> <!-- 라벨키 -->
											<td GH="200 STD_LBLTXS" GCol="input,LABEL"></td> <!-- 라벨명 -->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="total"></button>
<!-- 							<button type='button' GBtn="add"></button> -->
<!-- 							<button type='button' GBtn="delete"></button> -->
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
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