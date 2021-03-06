<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DR03</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<style>
	.red{color: red !important; }
	.black{color: black !important; }
	.green{color: green !important; }
</style>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var color = true;
var skukey = "";
var count = 0;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Daerim",
	    	pkcol : "OWNRKY",
			command : "DR03_HEAD",
			//itemGrid : "gridItemList",
			itemSearch : false,
			colorType : true,
		    menuId : "DR03"
	    });
		gridList.setGrid({
	    	id : "gridHeadList2",
	    	module : "Daerim",
	    	pkcol : "OWNRKY",
			command : "DR03_HEAD2",
			//itemGrid : "gridItemList",
			itemSearch : false,
			colorType : true,
		    menuId : "DR03"
	    });
		gridList.setGrid({
	    	id : "gridHeadList3",
	    	module : "Daerim",
	    	pkcol : "OWNRKY",
			command : "DR03_HEAD3",
			//itemGrid : "gridItemList",
			itemSearch : false,
			colorType : true,
		    menuId : "DR03"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OutBoundPicking",
			command : "DR03_ITEM",
			totalView : true,
		    menuId : "DR03"
	    });
		
		gridList.setReadOnly("gridHeadList", true, ["SKUG03"]);
		gridList.setReadOnly("gridItemList", true, ["WAREKY","WARESR","DOCUTY","PTNG08","DIRSUP","DIRDVY"]);
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "211");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);
	 	
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "212");
		rangeArr.push(rangeDataMap); 
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "213");
		rangeArr.push(rangeDataMap);
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "214");
		rangeArr.push(rangeDataMap); 
		
		setSingleRangeData('IT.DOCUTY', rangeArr); 		
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});
	
	function searchList(){
		$('#atab1-1').trigger("click");
	}
	
	function display1(){
			
		if(validate.check("searchArea")){
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridHeadList2");
			gridList.resetGrid("gridHeadList3");
			var param = inputList.setRangeMultiParam("searchArea");
			param.put("SES_WAREKY", "<%=wareky%>");


			netUtil.send({
				url : "/Daerim/json/displayDR03.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridHeadList" //그리드ID
			});
		}
	}
	function display2(){
			
		if(validate.check("searchArea")){
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridHeadList2");
			gridList.resetGrid("gridHeadList3");
			var param = inputList.setRangeMultiParam("searchArea");
			param.put("SES_WAREKY", "<%=wareky%>");
			/* var orddat = $("#ORDDAT").val().replaceAll("\.","")
			param.put("ORDDAT", orddat); */

			netUtil.send({
				url : "/Daerim/json/display2DR03.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridHeadList2" //그리드ID
			});
		}
	}
	function display3(){
			
		if(validate.check("searchArea")){
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridHeadList2");
			gridList.resetGrid("gridHeadList3");
			var param = inputList.setRangeMultiParam("searchArea");
			param.put("SES_WAREKY", "<%=wareky%>");

			netUtil.send({
				url : "/Daerim/json/display3DR03.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridHeadList3" //그리드ID
			});
		}
	}
	
	function gridListEventItemGridSearch(gridId){
		if(gridId == "gridHeadList"){
			
			//itemSearch (rowData, c00102, ptng08, dirsup, dirdvy)
		}
	}
	
	
	function itemSearch (rowData, skukey, c00102, ptng08, dirsup, dirdvy){
		var param = inputList.setRangeMultiParam("searchArea");
		param.putAll(rowData);
		param.put("SKUKEY",skukey);
			param.put("C00102",c00102);
		param.put("PTNG08",ptng08);
		param.put("DIRSUP",dirsup);
		param.put("DIRDVY",dirdvy);
		
		netUtil.send({
			url : "/Daerim/json/displayDR03Item.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList" //그리드ID
		});
		
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			//gridList.resetGrid("gridItemList");
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
	
	/* function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var item = gridList.getSelectData("gridItemList", true);
			
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			
		
 			netUtil.send({
 				url : "/OutBoundPicking/json/saveDL42.data",
 				param : param,
 				successFunction : "successSaveCallBack"
 			});
		}
	} */
	
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
	

	
	
	//버튼 동작 연결
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print"){
			print();
		}else if(btnName == "Print2"){
			print2();
		}else if(btnName == "Print3"){
			print3();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DR03");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DR03");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//ezgen 구현
	function print(){
	
		var wherestr = "";
		
		wherestr += getMultiRangeDataSQLEzgen('SM.SKUKEY', 'I.SKUKEY');	
		wherestr += getMultiRangeDataSQLEzgen('PK.PICGRP', 'PK.PICGRP');	
		wherestr += getMultiRangeDataSQLEzgen('SM.ASKU05', 'SM.ASKU05');	
		wherestr += getMultiRangeDataSQLEzgen('IT.DOCUTY', 'I.DOCUTY');	
		wherestr += getMultiRangeDataSQLEzgen('IT.DIRSUP', 'I.DIRSUP');	
		wherestr += getMultiRangeDataSQLEzgen('IT.DIRDVY', 'I.DIRDVY');	
		wherestr += getMultiRangeDataSQLEzgen('SW.LOCARV', 'SW.LOCARV');
		
		var orddat = $('#ORDDAT').val();
		orddat = orddat.replace(/\./g,"");
		wherestr += " AND I.ORDDAT = '" +orddat+ "'";

		var langKy = "KO";
		var width = 595;
		var heigth = 880;
		var map = new DataMap();
			map.put("i_orderby","aa ");
			map.put("i_option","aa ");
		WriteEZgenElement("/ezgen/picking_closing_list2.ezg" , wherestr , " " , langKy, map , width , heigth );

	}
	
	function print2(){
		
		var wherestr = "";
		
		wherestr += getMultiRangeDataSQLEzgen('SM.SKUKEY', 'I.SKUKEY');	
		wherestr += getMultiRangeDataSQLEzgen('PK.PICGRP', 'PK.PICGRP');	
		wherestr += getMultiRangeDataSQLEzgen('SM.ASKU05', 'SM.ASKU05');	
		wherestr += getMultiRangeDataSQLEzgen('IT.DOCUTY', 'I.DOCUTY');	
		wherestr += getMultiRangeDataSQLEzgen('IT.DIRSUP', 'I.DIRSUP');	
		wherestr += getMultiRangeDataSQLEzgen('IT.DIRDVY', 'I.DIRDVY');	
		wherestr += getMultiRangeDataSQLEzgen('SW.LOCARV', 'SW.LOCARV');
		
		var orddat = $('#ORDDAT').val();
		orddat = orddat.replace(/\./g,"");
		wherestr += " AND I.ORDDAT = '" +orddat+ "'";

		var langKy = "KO";
		var width = 840;
		var heigth = 625;
		var map = new DataMap();
		map.put("i_orderby","aa ");
		map.put("i_option","aa ");
		WriteEZgenElement("/ezgen/picking_closing_list.ezg" , wherestr , " " , langKy, map , width , heigth );

	}
	
	function print3(){
		
		var wherestr = "";
		
		wherestr += getMultiRangeDataSQLEzgen('SM.SKUKEY', 'I.SKUKEY');	
		wherestr += getMultiRangeDataSQLEzgen('PK.PICGRP', 'PK.PICGRP');	
		wherestr += getMultiRangeDataSQLEzgen('SM.ASKU05', 'SM.ASKU05');	
		wherestr += getMultiRangeDataSQLEzgen('IT.DOCUTY', 'I.DOCUTY');	
		wherestr += getMultiRangeDataSQLEzgen('IT.DIRSUP', 'I.DIRSUP');	
		wherestr += getMultiRangeDataSQLEzgen('IT.DIRDVY', 'I.DIRDVY');	
		wherestr += getMultiRangeDataSQLEzgen('SW.LOCARV', 'SW.LOCARV');
		
		var orddat = $('#ORDDAT').val();
		orddat = orddat.replace(/\./g,"");
		wherestr += " AND I.ORDDAT = '" +orddat+ "'";
		
		var langKy = "KO";
		var width = 595;
		var heigth = 880;
		var map = new DataMap();
		map.put("i_orderby","aa ");
		map.put("i_option","aa ");
		WriteEZgenElement("/ezgen/picking_closing_list3.ezg" , wherestr , " " , langKy, map , width , heigth );
	
	}
	

	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){
		var skukey = "";
		var c00102 = "";
		var ptng08 = colName;
		var dirsup = "";
		var dirdvy = "";
		if(gridId == "gridHeadList"){
			skukey = gridList.getColData("gridHeadList", rowNum, "SKUKEY2");
			c00102 = gridList.getColData("gridHeadList", rowNum, "CDESC1");
		}
		else if(gridId == "gridHeadList2"){
			skukey = gridList.getColData("gridHeadList2", rowNum, "SKUKEY2");
			c00102 = gridList.getColData("gridHeadList2", rowNum, "CDESC1");
		}
		else if(gridId == "gridHeadList3"){
			skukey = gridList.getColData("gridHeadList3", rowNum, "SKUKEY2");
			c00102 = gridList.getColData("gridHeadList3", rowNum, "CDESC1");
		}
		if (colName.match("NUM")){
			if(colName.toString().replace("_BOX","").replace("_REM","") == "NUM99"){
				ptng08 = "%";
				dirsup = "%";
				dirdvy = "04";
			}
			else if(colName.toString().replace("_BOX","").replace("_REM","") == "NUM03_1"){
				ptng08 = "03";
				dirsup = "007";
				dirdvy = "01";
			}
			else if(colName.toString().replace("_BOX","").replace("_REM","") == "NUM03"){
				ptng08 = "03";
				dirsup = "000";
				dirdvy = "01";
			}
			else if(colName.toString().replace("_BOX","").replace("_REM","") == "NUM04_1"){
				ptng08 = "04";
				dirsup = "007";
				dirdvy = "01";
			}
			else if(colName.toString().replace("_BOX","").replace("_REM","") == "NUM04"){
				ptng08 = "04";
				dirsup = "000";
				dirdvy = "01";
			}
			else{
				ptng08 = colName.replace("NUM","").replace("_BOX","").replace("_REM","");
				dirsup = "001";
				dirdvy = "01";
			}
		}
		else {
			ptng08 = "%";
			dirdvy = "%";
		}
		if (c00102 == "전체"){
			c00102 = "%";
		}
		else if (c00102 == "확정"){
			c00102 = "Y";
		}
		if (c00102 == "미확정"){
			c00102 = "X";
		}
		
		if(gridId != "gridItemList"){

			var rowData = gridList.getRowData(gridId, rowNum);
			itemSearch(rowData, skukey, c00102, ptng08, dirsup, dirdvy);
			
			//displayItem(skukey, c00102, ptng08, dirsup, dirdvy);
		}
	}
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();

		//주문구분
		if(searchCode == "SHCMCDV" && $inputObj.name == "IT.DIRSUP"){
	        param.put("CMCDKY","PGRC03");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		//출고유형
		}else if(searchCode == "SHDOCTMIF" && $inputObj.name == "IT.DOCUTY"){
	        param.put("DOCUTY","");
	    	param.put("OWNRKY","<%=ownrky %>");   
		//배송구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "IT.DIRDVY"){
	        param.put("CMCDKY","PGRC02");
	    	param.put("OWNRKY","<%=ownrky %>");   
		//마감구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "BZ2.PTNG08"){
	        param.put("CMCDKY","PTNG08");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//상온구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
	        param.put("CMCDKY","ASKU05");
	    	param.put("OWNRKY","<%=ownrky %>");  		
		//소분류
		} else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG03"){
	        param.put("CMCDKY","SKUG03");
	        param.put("OWNRKY","<%=ownrky %>");
		//피킹그룹
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "PK.PICGRP"){
	        param.put("CMCDKY","PICGRP");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//로케이션
	    } else if(searchCode == "SHLOCMA" && $inputObj.name == "SW.LOCARV"){
		    param.put("WAREKY","<%=wareky %>");	
	    } return param;
	}

	
	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListRowColorChange(gridId, rowNum, rowData){
		if(skukey != rowData.map.SKUKEY.trim() && rowData.map.SKUKEY.trim() != ""){
			skukey = rowData.map.SKUKEY;
			count = Number(count) + 1;
			color = true;
			
			if(count % 2 == 0){
				color = false;
			}
		}
		
		if(color){
			return configData.GRID_COLOR_BG_GREEN_CLASS;
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
					<input type="button" CB="Print PRINT_OUT BTN_PICKCOL" />
					<input type="button" CB="Print2 PRINT_OUT BTN_PICKROW" />
					<input type="button" CB="Print3 PRINT_OUT BTN_PICKUP" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" ></select>
						</dd>
					</dl>
					<dl>  <!--출고일자-->  
						<dt CL="STD_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="ORDDAT" id="ORDDAT" UIFormat="C N"/> <!-- UIInput="B"  -->
						</dd> 
					</dl> 
					<dl>  <!--거점-->  
						<dt CL="STD_WAREKY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.WAREKY" id="WAREKY"  UIInput="SR,SHWAHMA" value="<%=wareky%>"/>
						</dd> 
					</dl> 
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DOCUTY" UIInput="SR,SHDOCTMIF" readonly/> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRSUP" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRDVY" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="IFT_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.OTRQDT" UIInput="B" UIFormat="C" /> 
						</dd> 
					</dl> 
					<dl>  <!--마감구분-->  
						<dt CL="STD_PTNG08"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ2.PTNG08" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.SKUKEY" UIInput="SR,SHSKUMA2" /> 
						</dd> 
					</dl> 
					<dl>  <!--상온구분-->  
						<dt CL="STD_ASKU05"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--소분류-->  
						<dt CL="STD_SKUG03"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.SKUG03" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--피킹그룹-->  
						<dt CL="STD_PICGRP"></dt> 
						<dd> 
							<input type="text" class="input" name="PK.PICGRP" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="SW.LOCARV" UIInput="SR,SHLOCMA"/> 
						</dd> 
					</dl> 
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs top_layout" style="height: calc(100% - 240px);">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1" onclick="display1()" id = "atab1-1"><span>전체</span></a></li>
					<li><a href="#tab1-2" onclick="display2()"><span>본주문/추가주문</span></a></li>
					<li><a href="#tab1-3" onclick="display3()"><span>특정거래선</span></a></li>
					 <li>
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
			    						<td GH="130 STD_SKUG03" GCol="select,SKUG03">
			    							<select class="input" CommonCombo="SKUG03"><option></option></select>  <!--소분류-->
			    						</td>
			    						<td GH="80 STD_SKUKEY" GCol="input,SKUKEY" GF="S 20"></td>	<!--제품코드-->
			    						<td GH="120 STD_DESC01" GCol="input,DESC01" GF="S 200"></td>	<!--제품명-->
			    						<td GH="80 단량" GCol="input,DESC02" GF="S 20">단량</td>	<!--단량-->
			    						<td GH="80 확정구분" GCol="input,CDESC1" GF="S 200">확정구분</td>	<!--확정구분-->
			    						<td GH="80 합계" GCol="input,TOT01" GF="N 80,0">합계</td>	<!--합계-->
			    						<td GH="80 한물" GCol="input,NUM30" GF="N 80,0">한물</td>	<!--한물-->
			    						<td GH="80 식자" GCol="input,NUM01" GF="N 80,0">식자</td>	<!--식자-->
			    						<td GH="80 에1" GCol="input,NUM02" GF="N 80,0">에1</td>	<!--에1-->
			    						<td GH="80 1차" GCol="input,NUM03" GF="N 80,0">1차</td>	<!--1차-->
			    						<td GH="80 2차" GCol="input,NUM04" GF="N 80,0">2차</td>	<!--2차-->
			    						<td GH="80 제주" GCol="input,NUM31" GF="N 80,0">제주</td>	<!--제주-->
			    						<td GH="80 수출" GCol="input,NUM05" GF="N 80,0">수출</td>	<!--수출-->
			    						<td GH="80 GS" GCol="input,NUM06" GF="N 80,0">GS</td>	<!--GS-->
			    						<td GH="80 광릉" GCol="input,NUM07" GF="N 80,0">광릉</td>	<!--광릉-->
			    						<td GH="80 현식" GCol="input,NUM08" GF="N 80,0">현식</td>	<!--현식-->
			    						<td GH="80 아신" GCol="input,NUM09" GF="N 80,0">아신</td>	<!--아신-->
			    						<td GH="80 롯(김해)" GCol="input,NUM10" GF="N 80,0">롯(김해)</td>	<!--롯(김해)-->
			    						<td GH="80 롯(수도)" GCol="input,NUM11" GF="N 80,0">롯(수도)</td>	<!--롯(수도)-->
			    						<td GH="80 홈(함안)" GCol="input,NUM13" GF="N 80,0">홈(함안)</td>	<!--홈(함안)-->
			    						<td GH="80 1차(추가)" GCol="input,NUM03_1" GF="N 80,0">1차(추가)</td>	<!--1차(추가)-->
			    						<td GH="80 2차(추가)" GCol="input,NUM04_1" GF="N 80,0">2차(추가)</td>	<!--2차(추가)-->
			    						<td GH="80 지(벤더)" GCol="input,NUM14" GF="N 80,0">지(벤더)</td>	<!--지(벤더)-->
			    						<td GH="80 수(벤더)" GCol="input,NUM15" GF="N 80,0">수(벤더)</td>	<!--수(벤더)-->
			    						<td GH="80 농협" GCol="input,NUM16" GF="N 80,0">농협</td>	<!--농협-->
			    						<td GH="80 이(수도권)" GCol="input,NUM18" GF="N 80,0">이(수도권)</td>	<!--이(수도권)-->
			    						<td GH="80 이(여주)" GCol="input,NUM19" GF="N 80,0">이(여주)</td>	<!--이(여주)-->
			    						<td GH="80 에(평택)" GCol="input,NUM20" GF="N 80,0">에(평택)</td>	<!--에(평택)-->
			    						<td GH="80 제식" GCol="input,NUM22" GF="N 80,0">제식</td>	<!--제식-->
			    						<td GH="80 한화" GCol="input,NUM23" GF="N 80,0">한화</td>	<!--한화-->
			    						<td GH="80 영식" GCol="input,NUM24" GF="N 80,0">영식</td>	<!--영식-->
			    						<td GH="80 신2" GCol="input,NUM25" GF="N 80,0">신2</td>	<!--신2-->
			    						<td GH="80 아워" GCol="input,NUM26" GF="N 80,0">아워</td>	<!--아워-->
			    						<td GH="80 푸드" GCol="input,NUM27" GF="N 80,0">푸드</td>	<!--푸드-->
			    						<td GH="80 에버" GCol="input,NUM28" GF="N 80,0">에버</td>	<!--에버-->
			    						<td GH="80 기식" GCol="input,NUM29" GF="N 80,0">기식</td>	<!--기식-->
			    						<td GH="80 빙과류" GCol="input,NUM33" GF="N 80,0">빙과류</td>	<!--빙과류-->
			    						<td GH="80 자가배송" GCol="input,NUM99" GF="N 80,0">자가배송</td>	<!--자가배송-->
			    						<td GH="80 합계(BOX)" GCol="input,TOT01_BOX" GF="N 80,1">합계(BOX)</td>	<!--합계(BOX)-->
			    						<td GH="80 합계(낱개)" GCol="input,TOT01_REM" GF="N 80,0">합계(낱개)</td>	<!--합계(낱개)-->
			    						<td GH="80 한물(BOX)" GCol="input,NUM30_BOX" GF="N 80,1">한물(BOX)</td>	<!--한물(BOX)-->
			    						<td GH="80 한물(낱개)" GCol="input,NUM30_REM" GF="N 80,0">한물(낱개)</td>	<!--한물(낱개)-->
			    						<td GH="80 식자(BOX)" GCol="input,NUM01_BOX" GF="N 80,1">식자(BOX)</td>	<!--식자(BOX)-->
			    						<td GH="80 식자(낱개)" GCol="input,NUM01_REM" GF="N 80,0">식자(낱개)</td>	<!--식자(낱개)-->
			    						<td GH="80 에1(BOX)" GCol="input,NUM02_BOX" GF="N 80,1">에1(BOX)</td>	<!--에1(BOX)-->
			    						<td GH="80 에1(낱개)" GCol="input,NUM02_REM" GF="N 80,0">에1(낱개)</td>	<!--에1(낱개)-->
			    						<td GH="80 1차(BOX)" GCol="input,NUM03_BOX" GF="N 80,1">1차(BOX)</td>	<!--1차(BOX)-->
			    						<td GH="80 1차(낱개)" GCol="input,NUM03_REM" GF="N 80,0">1차(낱개)</td>	<!--1차(낱개)-->
			    						<td GH="80 2차(낱개)" GCol="input,NUM04_REM" GF="N 80,0">2차(낱개)</td>	<!--2차(낱개)-->
			    						<td GH="80 2차(BOX)" GCol="input,NUM04_BOX" GF="N 80,1">2차(BOX)</td>	<!--2차(BOX)-->
			    						<td GH="80 제주(BOX)" GCol="input,NUM31_BOX" GF="N 80,1">제주(BOX)</td>	<!--제주(BOX)-->
			    						<td GH="80 제주(낱개)" GCol="input,NUM31_REM" GF="N 80,0">제주(낱개)</td>	<!--제주(낱개)-->
			    						<td GH="80 빙과류(BOX)" GCol="input,NUM33_BOX" GF="N 80,1">빙과류(BOX)</td>	<!--빙과류(BOX)-->
			    						<td GH="80 빙과류(낱개)" GCol="input,NUM33_REM" GF="N 80,0">빙과류(낱개)</td>	<!--빙과류(낱개)-->
			    						<td GH="80 수출(BOX)" GCol="input,NUM05_BOX" GF="N 80,1">수출(BOX)</td>	<!--수출(BOX)-->
			    						<td GH="80 수출(낱개)" GCol="input,NUM05_REM" GF="N 80,0">수출(낱개)</td>	<!--수출(낱개)-->
			    						<td GH="80 GS(BOX)" GCol="input,NUM06_BOX" GF="N 80,1">GS(BOX)</td>	<!--GS(BOX)-->
			    						<td GH="80 GS(낱개)" GCol="input,NUM06_REM" GF="N 80,0">GS(낱개)</td>	<!--GS(낱개)-->
			    						<td GH="80 광릉(BOX)" GCol="input,NUM07_BOX" GF="N 80,1">광릉(BOX)</td>	<!--광릉(BOX)-->
			    						<td GH="80 광릉(낱개)" GCol="input,NUM07_REM" GF="N 80,0">광릉(낱개)</td>	<!--광릉(낱개)-->
			    						<td GH="80 현식(BOX)" GCol="input,NUM08_BOX" GF="N 80,1">현식(BOX)</td>	<!--현식(BOX)-->
			    						<td GH="80 현식(낱개)" GCol="input,NUM08_REM" GF="N 80,0">현식(낱개)</td>	<!--현식(낱개)-->
			    						<td GH="80 아신(BOX)" GCol="input,NUM09_BOX" GF="N 80,1">아신(BOX)</td>	<!--아신(BOX)-->
			    						<td GH="80 아신(낱개)" GCol="input,NUM09_REM" GF="N 80,0">아신(낱개)</td>	<!--아신(낱개)-->
			    						<td GH="80 롯(김해)(BOX)" GCol="input,NUM10_BOX" GF="N 80,1">롯(김해)(BOX)</td>	<!--롯(김해)(BOX)-->
			    						<td GH="80 롯(김해)(낱개)" GCol="input,NUM10_REM" GF="N 80,0">롯(김해)(낱개)</td>	<!--롯(김해)(낱개)-->
			    						<td GH="80 롯(수도)(BOX)" GCol="input,NUM11_BOX" GF="N 80,1">롯(수도)(BOX)</td>	<!--롯(수도)(BOX)-->
			    						<td GH="80 롯(수도)(낱개)" GCol="input,NUM11_REM" GF="N 80,0">롯(수도)(낱개)</td>	<!--롯(수도)(낱개)-->
			    						<td GH="80 홈(함안)(BOX)" GCol="input,NUM13_BOX" GF="N 80,1">홈(함안)(BOX)</td>	<!--홈(함안)(BOX)-->
			    						<td GH="80 홈(함안)(낱개)" GCol="input,NUM13_REM" GF="N 80,0">홈(함안)(낱개)</td>	<!--홈(함안)(낱개)-->
			    						<td GH="80 1차(추가)(BOX)" GCol="input,NUM03_1_BOX" GF="N 80,1">1차(추가)(BOX)</td>	<!--1차(추가)(BOX)-->
			    						<td GH="80 1차(추가)(낱개)" GCol="input,NUM03_1_REM" GF="N 80,0">1차(추가)(낱개)</td>	<!--1차(추가)(낱개)-->
			    						<td GH="80 2차(추가)(BOX)" GCol="input,NUM04_1_BOX" GF="N 80,1">2차(추가)(BOX)</td>	<!--2차(추가)(BOX)-->
			    						<td GH="80 2차(추가)(낱개)" GCol="input,NUM04_1_REM" GF="N 80,0">2차(추가)(낱개)</td>	<!--2차(추가)(낱개)-->
			    						<td GH="80 지(벤더)(BOX)" GCol="input,NUM14_BOX" GF="N 80,1">지(벤더)(BOX)</td>	<!--지(벤더)(BOX)-->
			    						<td GH="80 지(벤더)(낱개)" GCol="input,NUM14_REM" GF="N 80,0">지(벤더)(낱개)</td>	<!--지(벤더)(낱개)-->
			    						<td GH="80 수(벤더)(BOX)" GCol="input,NUM15_BOX" GF="N 80,1">수(벤더)(BOX)</td>	<!--수(벤더)(BOX)-->
			    						<td GH="80 수(벤더)(낱개)" GCol="input,NUM15_REM" GF="N 80,0">수(벤더)(낱개)</td>	<!--수(벤더)(낱개)-->
			    						<td GH="80 농협(BOX)" GCol="input,NUM16_BOX" GF="N 80,1">농협(BOX)</td>	<!--농협(BOX)-->
			    						<td GH="80 농협(낱개)" GCol="input,NUM16_REM" GF="N 80,0">농협(낱개)</td>	<!--농협(낱개)-->
			    						<td GH="80 이(수도권)(BOX)" GCol="input,NUM18_BOX" GF="N 80,1">이(수도권)(BOX)</td>	<!--이(수도권)(BOX)-->
			    						<td GH="80 이(수도권)(낱개)" GCol="input,NUM18_REM" GF="N 80,0">이(수도권)(낱개)</td>	<!--이(수도권)(낱개)-->
			    						<td GH="80 이(여주)(BOX)" GCol="input,NUM19_BOX" GF="N 80,1">이(여주)(BOX)</td>	<!--이(여주)(BOX)-->
			    						<td GH="80 이(여주)(낱개)" GCol="input,NUM19_REM" GF="N 80,0">이(여주)(낱개)</td>	<!--이(여주)(낱개)-->
			    						<td GH="80 에(평택))(BOX)" GCol="input,NUM20_BOX" GF="N 80,1">에(평택)(BOX)</td>	<!--에(평택)(BOX)-->
			    						<td GH="80 에(평택)(낱개)" GCol="input,NUM20_REM" GF="N 80,0">에(평택)(낱개)</td>	<!--에(평택)(낱개)-->
			    						<td GH="80 제식(BOX)" GCol="input,NUM22_BOX" GF="N 80,1">제식(BOX)</td>	<!--제식(BOX)-->
			    						<td GH="80 제식(낱개)" GCol="input,NUM22_REM" GF="N 80,0">제식(낱개)</td>	<!--제식(낱개)-->
			    						<td GH="80 한화(BOX)" GCol="input,NUM23_BOX" GF="N 80,1">한화(BOX)</td>	<!--한화(BOX)-->
			    						<td GH="80 한화(낱개)" GCol="input,NUM23_REM" GF="N 80,0">한화(낱개)</td>	<!--한화(낱개)-->
			    						<td GH="80 영식(BOX)" GCol="input,NUM24_BOX" GF="N 80,1">영식(BOX)</td>	<!--영식(BOX)-->
			    						<td GH="80 영식(낱개)" GCol="input,NUM24_REM" GF="N 80,0">영식(낱개)</td>	<!--영식(낱개)-->
			    						<td GH="80 신2(BOX)" GCol="input,NUM25_BOX" GF="N 80,1">신2(BOX)</td>	<!--신2(BOX)-->
			    						<td GH="80 신2(낱개)" GCol="input,NUM25_REM" GF="N 80,0">신2(낱개)</td>	<!--신2(낱개)-->
			    						<td GH="80 아워(BOX)" GCol="input,NUM26_BOX" GF="N 80,1">아워(BOX)</td>	<!--아워(BOX)-->
			    						<td GH="80 아워(낱개)" GCol="input,NUM26_REM" GF="N 80,0">아워(낱개)</td>	<!--아워(낱개)-->
			    						<td GH="80 푸드(BOX)" GCol="input,NUM27_BOX" GF="N 80,1">푸드(BOX)</td>	<!--푸드(BOX)-->
			    						<td GH="80 푸드(낱개)" GCol="input,NUM27_REM" GF="N 80,0">푸드(낱개)</td>	<!--푸드(낱개)-->
			    						<td GH="80 에버(BOX)" GCol="input,NUM28_BOX" GF="N 80,1">에버(BOX)</td>	<!--에버(BOX)-->
			    						<td GH="80 에버(낱개)" GCol="input,NUM28_REM" GF="N 80,0">에버(낱개)</td>	<!--에버(낱개)-->
			    						<td GH="80 기식(BOX)" GCol="input,NUM29_BOX" GF="N 80,1">기식(BOX)</td>	<!--기식(BOX)-->
			    						<td GH="80 기식(낱개)" GCol="input,NUM29_REM" GF="N 80,0">기식(낱개)</td>	<!--기식(낱개)-->
			    						<td GH="80 자가배송(BOX)" GCol="input,NUM99_BOX" GF="N 80,1">자가배송(BOX)</td>	<!--자가배송(BOX)-->
			    						<td GH="80 자가배송(낱개)" GCol="input,NUM99_REM" GF="N 80,0">자가배송(낱개)</td>	<!--자가배송(낱개)-->
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
				
				<div class="table_box section" id="tab1-2">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList2">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="80 STD_SKUKEY" GCol="input,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="120 STD_DESC01" GCol="input,DESC01" GF="S 200">제품명</td> <!--제품명-->
										<td GH="80 단량" GCol="input,DESC02" GF="S 20">단량</td> <!--단량-->
										<td GH="80 확정구분" GCol="input,CDESC1" GF="S 200">확정구분</td> <!--확정구분-->
										<td GH="80 합계" GCol="input,TOT02" GF="N 80,0">합계</td> <!--합계-->
										<td GH="80 1차" GCol="input,NUM03" GF="N 80,0">1차</td> <!--1차-->
										<td GH="80 2차" GCol="input,NUM04" GF="N 80,0">2차</td> <!--2차-->
										<td GH="80 제주" GCol="input,NUM31" GF="N 80,0">제주</td> <!--제주-->
										<td GH="80 빙과류" GCol="input,NUM33" GF="N 80,0">빙과류</td> <!--빙과류-->
										<td GH="80 자가배송" GCol="input,NUM99" GF="N 80,0">자가배송</td> <!--자가배송-->
										<td GH="80 1차(추가)" GCol="input,NUM03_1" GF="N 80,0">1차(추가)</td> <!--1차(추가)-->
										<td GH="80 2차(추가)" GCol="input,NUM04_1" GF="N 80,0">2차(추가)</td> <!--2차(추가)-->
										<td GH="80 1차(BOX)" GCol="input,NUM03_BOX" GF="N 80,0">1차(BOX)</td> <!--1차(BOX)-->
										<td GH="80 1차(낱개)" GCol="input,NUM03_REM" GF="N 80,0">1차(낱개)</td> <!--1차(낱개)-->
										<td GH="80 2차(낱개)" GCol="input,NUM04_REM" GF="N 80,0">2차(낱개)</td> <!--2차(낱개)-->
										<td GH="80 2차(BOX)" GCol="input,NUM04_BOX" GF="N 80,0">2차(BOX)</td> <!--2차(BOX)-->
										<td GH="80 제주(BOX)" GCol="input,NUM31_BOX" GF="N 80,0">제주(BOX)</td> <!--제주(BOX)-->
										<td GH="80 제주(낱개)" GCol="input,NUM31_REM" GF="N 80,0">제주(낱개)</td> <!--제주(낱개)-->
										<td GH="80 빙과류(BOX)" GCol="input,NUM33_BOX" GF="N 80,0">빙과류(BOX)</td> <!--빙과류(BOX)-->
										<td GH="80 빙과류(낱개)" GCol="input,NUM33_REM" GF="N 80,0">빙과류(낱개)</td> <!--빙과류(낱개)-->
										<td GH="80 1차(추가)(BOX)" GCol="input,NUM03_1_BOX" GF="N 80,0">1차(추가)(BOX)</td> <!--1차(추가)(BOX)-->
										<td GH="80 1차(추가)(낱개)" GCol="input,NUM03_1_REM" GF="N 80,0">1차(추가)(낱개)</td> <!--1차(추가)(낱개)-->
										<td GH="80 2차(추가)(BOX)" GCol="input,NUM04_1_BOX" GF="N 80,0">2차(추가)(BOX)</td> <!--2차(추가)(BOX)-->
										<td GH="80 2차(추가)(낱개)" GCol="input,NUM04_1_REM" GF="N 80,0">2차(추가)(낱개)</td> <!--2차(추가)(낱개)-->
										<td GH="80 자가배송(BOX)" GCol="input,NUM99_BOX" GF="N 80,0">자가배송(BOX)</td> <!--자가배송(BOX)-->
										<td GH="80 자가배송(낱개)" GCol="input,NUM99_REM" GF="N 80,0">자가배송(낱개)</td> <!--자가배송(낱개)-->
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
				
				<div class="table_box section" id="tab1-3">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList3">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="80 STD_SKUKEY" GCol="input,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="120 STD_DESC01" GCol="input,DESC01" GF="S 200">제품명</td> <!--제품명-->
										<td GH="80 단량" GCol="input,DESC02" GF="S 20">단량</td> <!--단량-->
										<td GH="80 확정구분" GCol="input,CDESC1" GF="S 200">확정구분</td> <!--확정구분-->
										<td GH="80 합계" GCol="input,TOT03" GF="N 80,0">합계</td> <!--합계-->
										<td GH="80 한물" GCol="input,NUM30" GF="N 80,0">한물</td> <!--한물-->
										<td GH="80 식자" GCol="input,NUM01" GF="N 80,0">식자</td> <!--식자-->
										<td GH="80 에1" GCol="input,NUM02" GF="N 80,0">에1</td> <!--에1-->
										<td GH="80 수출" GCol="input,NUM05" GF="N 80,0">수출</td> <!--수출-->
										<td GH="80 GS" GCol="input,NUM06" GF="N 80,0">GS</td> <!--GS-->
										<td GH="80 광릉" GCol="input,NUM07" GF="N 80,0">광릉</td> <!--광릉-->
										<td GH="80 현식" GCol="input,NUM08" GF="N 80,0">현식</td> <!--현식-->
										<td GH="80 아신" GCol="input,NUM09" GF="N 80,0">아신</td> <!--아신-->
										<td GH="80 롯(김해)" GCol="input,NUM10" GF="N 80,0">롯(김해)</td> <!--롯(김해)-->
										<td GH="80 롯(수도)" GCol="input,NUM11" GF="N 80,0">롯(수도)</td> <!--롯(수도)-->
										<td GH="80 홈(함안)" GCol="input,NUM13" GF="N 80,0">홈(함안)</td> <!--홈(함안)-->
										<td GH="80 지(벤더)" GCol="input,NUM14" GF="N 80,0">지(벤더)</td> <!--지(벤더)-->
										<td GH="80 수(벤더)" GCol="input,NUM15" GF="N 80,0">수(벤더)</td> <!--수(벤더)-->
										<td GH="80 농협" GCol="input,NUM16" GF="N 80,0">농협</td> <!--농협-->
										<td GH="80 이(수도권)1" GCol="input,NUM18" GF="N 80,0">이(수도권)1</td> <!--이(수도권)1-->
										<td GH="80 이(여주)" GCol="input,NUM19" GF="N 80,0">이(여주)</td> <!--이(여주)-->
										<td GH="80 에(평택)" GCol="input,NUM20" GF="N 80,0">에(평택)</td> <!--에(평택)-->
										<td GH="80 제식" GCol="input,NUM22" GF="N 80,0">제식</td> <!--제식-->
										<td GH="80 한화" GCol="input,NUM23" GF="N 80,0">한화</td> <!--한화-->
										<td GH="80 영식" GCol="input,NUM24" GF="N 80,0">영식</td> <!--영식-->
										<td GH="80 신2" GCol="input,NUM25" GF="N 80,0">신2</td> <!--신2-->
										<td GH="80 아워" GCol="input,NUM26" GF="N 80,0">아워</td> <!--아워-->
										<td GH="80 푸드" GCol="input,NUM27" GF="N 80,0">푸드</td> <!--푸드-->
										<td GH="80 에버" GCol="input,NUM28" GF="N 80,0">에버</td> <!--에버-->
										<td GH="80 기식" GCol="input,NUM29" GF="N 80,0">기식</td> <!--기식-->
										<td GH="80 자가배송" GCol="input,NUM99" GF="N 80,0">자가배송</td> <!--자가배송-->
										<td GH="80 합계(BOX)" GCol="input,TOT03_BOX" GF="N 80,0">합계(BOX)</td> <!--합계(BOX)-->
										<td GH="80 합계(낱개)" GCol="input,TOT03_REM" GF="N 80,0">합계(낱개)</td> <!--합계(낱개)-->
										<td GH="80 한물(BOX)" GCol="input,NUM30_BOX" GF="N 80,0">한물(BOX)</td> <!--한물(BOX)-->
										<td GH="80 한물(낱개)" GCol="input,NUM30_REM" GF="N 80,0">한물(낱개)</td> <!--한물(낱개)-->
										<td GH="80 식자(BOX)" GCol="input,NUM01_BOX" GF="N 80,0">식자(BOX)</td> <!--식자(BOX)-->
										<td GH="80 식자(낱개)" GCol="input,NUM01_REM" GF="N 80,0">식자(낱개)</td> <!--식자(낱개)-->
										<td GH="80 에1(BOX)" GCol="input,NUM02_BOX" GF="N 80,0">에1(BOX)</td> <!--에1(BOX)-->
										<td GH="80 에1(낱개)" GCol="input,NUM02_REM" GF="N 80,0">에1(낱개)</td> <!--에1(낱개)-->
										<td GH="80 수출(BOX)" GCol="input,NUM05_BOX" GF="N 80,0">수출(BOX)</td> <!--수출(BOX)-->
										<td GH="80 수출(낱개)" GCol="input,NUM05_REM" GF="N 80,0">수출(낱개)</td> <!--수출(낱개)-->
										<td GH="80 GS(BOX)" GCol="input,NUM06_BOX" GF="N 80,0">GS(BOX)</td> <!--GS(BOX)-->
										<td GH="80 GS(낱개)" GCol="input,NUM06_REM" GF="N 80,0">GS(낱개)</td> <!--GS(낱개)-->
										<td GH="80 광릉(BOX)" GCol="input,NUM07_BOX" GF="N 80,0">광릉(BOX)</td> <!--광릉(BOX)-->
										<td GH="80 광릉(낱개)" GCol="input,NUM07_REM" GF="N 80,0">광릉(낱개)</td> <!--광릉(낱개)-->
										<td GH="80 현식(BOX)" GCol="input,NUM08_BOX" GF="N 80,0">현식(BOX)</td> <!--현식(BOX)-->
										<td GH="80 현식(낱개)" GCol="input,NUM08_REM" GF="N 80,0">현식(낱개)</td> <!--현식(낱개)-->
										<td GH="80 아신(BOX)" GCol="input,NUM09_BOX" GF="N 80,0">아신(BOX)</td> <!--아신(BOX)-->
										<td GH="80 아신(낱개)" GCol="input,NUM09_REM" GF="N 80,0">아신(낱개)</td> <!--아신(낱개)-->
										<td GH="80 롯(김해)(BOX)" GCol="input,NUM10_BOX" GF="N 80,0">롯(김해)(BOX)</td> <!--롯(김해)(BOX)-->
										<td GH="80 롯(김해)(낱개)" GCol="input,NUM10_REM" GF="N 80,0">롯(김해)(낱개)</td> <!--롯(김해)(낱개)-->
										<td GH="80 롯(수도)(BOX)" GCol="input,NUM11_BOX" GF="N 80,0">롯(수도)(BOX)</td> <!--롯(수도)(BOX)-->
										<td GH="80 롯(수도)(낱개)" GCol="input,NUM11_REM" GF="N 80,0">롯(수도)(낱개)</td> <!--롯(수도)(낱개)-->
										<td GH="80 홈(함안)(BOX)" GCol="input,NUM13_BOX" GF="N 80,0">홈(함안)(BOX)</td> <!--홈(함안)(BOX)-->
										<td GH="80 홈(함안)(낱개)" GCol="input,NUM13_REM" GF="N 80,0">홈(함안)(낱개)</td> <!--홈(함안)(낱개)-->
										<td GH="80 지(벤더)(BOX)" GCol="input,NUM14_BOX" GF="N 80,0">지(벤더)(BOX)</td> <!--지(벤더)(BOX)-->
										<td GH="80 지(벤더)(낱개)" GCol="input,NUM14_REM" GF="N 80,0">지(벤더)(낱개)</td> <!--지(벤더)(낱개)-->
										<td GH="80 수(벤더)(BOX)" GCol="input,NUM15_BOX" GF="N 80,0">수(벤더)(BOX)</td> <!--수(벤더)(BOX)-->
										<td GH="80 수(벤더)(낱개)" GCol="input,NUM15_REM" GF="N 80,0">수(벤더)(낱개)</td> <!--수(벤더)(낱개)-->
										<td GH="80 농협(BOX)" GCol="input,NUM16_BOX" GF="N 80,0">농협(BOX)</td> <!--농협(BOX)-->
										<td GH="80 농협(낱개)" GCol="input,NUM16_REM" GF="N 80,0">농협(낱개)</td> <!--농협(낱개)-->
										<td GH="80 이(수도권)(BOX)" GCol="input,NUM18_BOX" GF="N 80,0">이(수도권)(BOX)</td> <!--이(수도권)(BOX)-->
										<td GH="80 이(수도권)(낱개)" GCol="input,NUM18_REM" GF="N 80,0">이(수도권)(낱개)</td> <!--이(수도권)(낱개)-->
										<td GH="80 이(여주)(BOX)" GCol="input,NUM19_BOX" GF="N 80,0">이(여주)(BOX)</td> <!--이(여주)(BOX)-->
										<td GH="80 이(여주)(낱개)" GCol="input,NUM19_REM" GF="N 80,0">이(여주)(낱개)</td> <!--이(여주)(낱개)-->
										<td GH="80 에(평택)(BOX)" GCol="input,NUM20_BOX" GF="N 80,0">에(평택)(BOX)</td> <!--에(평택)(BOX)-->
										<td GH="80 에(평택)(낱개)" GCol="input,NUM20_REM" GF="N 80,0">에(평택)(낱개)</td> <!--에(평택)(낱개)-->
										<td GH="80 제식(BOX)" GCol="input,NUM22_BOX" GF="N 80,0">제식(BOX)</td> <!--제식(BOX)-->
										<td GH="80 제식(낱개)" GCol="input,NUM22_REM" GF="N 80,0">제식(낱개)</td> <!--제식(낱개)-->
										<td GH="80 한화(BOX)" GCol="input,NUM23_BOX" GF="N 80,0">한화(BOX)</td> <!--한화(BOX)-->
										<td GH="80 한화(낱개)" GCol="input,NUM23_REM" GF="N 80,0">한화(낱개)</td> <!--한화(낱개)-->
										<td GH="80 영식(BOX)" GCol="input,NUM24_BOX" GF="N 80,0">영식(BOX)</td> <!--영식(BOX)-->
										<td GH="80 영식(낱개)" GCol="input,NUM24_REM" GF="N 80,0">영식(낱개)</td> <!--영식(낱개)-->
										<td GH="80 신2(BOX)" GCol="input,NUM25_BOX" GF="N 80,0">신2(BOX)</td> <!--신2(BOX)-->
										<td GH="80 신2(낱개)" GCol="input,NUM25_REM" GF="N 80,0">신2(낱개)</td> <!--신2(낱개)-->
										<td GH="80 아워(BOX)" GCol="input,NUM26_BOX" GF="N 80,0">아워(BOX)</td> <!--아워(BOX)-->
										<td GH="80 아워(낱개)" GCol="input,NUM26_REM" GF="N 80,0">아워(낱개)</td> <!--아워(낱개)-->
										<td GH="80 푸드(BOX)" GCol="input,NUM27_BOX" GF="N 80,0">푸드(BOX)</td> <!--푸드(BOX)-->
										<td GH="80 푸드(낱개)" GCol="input,NUM27_REM" GF="N 80,0">푸드(낱개)</td> <!--푸드(낱개)-->
										<td GH="80 에버(BOX)" GCol="input,NUM28_BOX" GF="N 80,0">에버(BOX)</td> <!--에버(BOX)-->
										<td GH="80 에버(낱개)" GCol="input,NUM28_REM" GF="N 80,0">에버(낱개)</td> <!--에버(낱개)-->
										<td GH="80 기식(BOX)" GCol="input,NUM29_BOX" GF="N 80,0">기식(BOX)</td> <!--기식(BOX)-->
										<td GH="80 기식(낱개)" GCol="input,NUM29_REM" GF="N 80,0">기식(낱개)</td> <!--기식(낱개)-->
										<td GH="80 자가배송(BOX)" GCol="input,NUM99_BOX" GF="N 80,0">자가배송(BOX)</td> <!--자가배송(BOX)-->
										<td GH="80 자가배송(낱개)" GCol="input,NUM99_REM" GF="N 80,0">자가배송(낱개)</td> <!--자가배송(낱개)-->
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
			<div class="content_layout tabs bottom_layout" style="height: 220px;">
				<ul class="tab tab_style02">
					<li><a href="#tab2-1"><span>상세내역</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab2-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
			   							<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10"></td>	<!--화주-->
			    						<td GH="200 STD_WAREKY" GCol="select,WAREKY">
			    							<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>	<!--거점-->
			    						</td>
			    						<td GH="200 STD_PTNG05" GCol="select,WARESR">
			    							<select class="input" commonCombo="PTNG06"></select>	<!--지점사업장-->
			    						</td>
			    						<td GH="150 STD_DOCUTY" GCol="select,DOCUTY">
			    							<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>	<!--출고유형-->
			    						</td>
			    						<td GH="120 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 20"></td>	<!--출고요청일-->
			    						<td GH="100 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 10"></td>	<!--납품처코드-->
			    						<td GH="160 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 200"></td>	<!--납품처명-->
			    						<td GH="120 IFT_PTNROD" GCol="text,PTNROD" GF="S 10"></td>	<!--매출처코드-->
			    						<td GH="160 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 200"></td>	<!--매출처명-->
			    						<td GH="100 STD_PTNG08" GCol="select,PTNG08" >
			    							<select class="input" commonCombo="PTNG08"></select>	<!--마감구분-->
			    						</td>
			    						<td GH="120 STD_PGRC03" GCol="select,DIRSUP" >
			    							<select class="input" commonCombo="PGRC03"></select>	<!--주문구분-->
			    						</td>
			    						<td GH="120 STD_DIRDVY" GCol="select,DIRDVY" >
			    							<select class="input" commonCombo="PGRC02"></select>	<!--배송구분-->
			    						</td>
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 80"></td>	<!--S/O 번호-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20"></td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200"></td>	<!--제품명-->
			    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 80,3"></td>	<!--순중량-->
			    						<td GH="100 STD_BXIQTY" GCol="text,QTDUOM" GF="N 100,0"></td>	<!--박스입수-->
			    						<td GH="80 STD_QTYSTD" GCol="text,QTYSTD" GF="N 80,0"></td>	<!--팔렛트 적재수량-->
			    						<td GH="80 STD_TQTSORG" GCol="text,QTYREQ" GF="N 80,0">주문수량</td>	<!--주문수량-->
			    						<td GH="80 STD_TQTSORGBOX" GCol="text,BOXQTY" GF="N 80,0">주문수량(BOX)</td>	<!--주문수량(BOX)-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 20"></td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 20"></td>	<!--생성시간-->
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