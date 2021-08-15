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
	var headRow = -1;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Inventory",
			command : "IP02",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
	    	useTemp : true,
	    	tempKey : "PHYIKY",
		    menuId : "IP02"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Inventory",
	    	command : "IP02_ITEM",
	    	tempHead : "gridHeadList",
	    	useTemp : true,
	    	tempKey : "PHYIKY",
		    menuId : "IP02"
	    });
		 
		gridList.setReadOnly("gridHeadList", true, ["PHSCTY","INDDCL"]);
		gridList.setReadOnly("gridItemList", true, ["LOTA02","LOTA05","LOTA06"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			gridList.resetTempData("gridHeadList"); //템프 초기화
			
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
			headRow = rowNum;
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
		if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("OWNRKY", $("#OWNRKY").val());
			param.put("DOCCAT", "500");
			param.put("DOCUTY", "520");
			
		}
		return param;
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
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
		var ownrky = $("#OWNRKY").val();
		
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "CONFIRM"){
			confirmData();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "SetChk"){
		 	setChk();
		}else if(btnName == "Print"){
			 if(ownrky == "2100" || ownrky == "2500"){
				 printEZGenDR16("/ezgen/physical_count_stock_list.ezg");	 
			 }else if(ownrky == "2200"){
				 printEZGenDR16("/ezgen/physical_count_stock_list_dr.ezg"); 
			 }					
		}else if(btnName == "Printroc"){
			 if(ownrky == "2100" || ownrky == "2500"){
				 printEZGenDR16("/ezgen/physical_count_stock_group_new.ezg");	 
			 }else if(ownrky == "2200"){
				 printEZGenDR16("/ezgen/physical_count_stock_group_dr.ezg"); 
			 }	
		}else if(btnName == "Printgrp"){
			 if(ownrky == "2100" || ownrky == "2500"){
				 printEZGenDR16("/ezgen/physical_count_stock_group.ezg");	 
			 }else if(ownrky == "2200"){
				 printEZGenDR16("/ezgen/physical_count_stock_group_dr.ezg"); 
			 }		
		}else if(btnName == "Printsku"){
			printEZGenDR16("/ezgen/physical_count_stock_group2.ezg"); 
		}else if(btnName == "Printall"){
			printEZGenDR16("/ezgen/physical_count_stock_list_dr_sum.ezg");
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "IP02");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "IP02");
		}
		
	}
	
    function printEZGenDR16(url){
    	
    	//for문을 돌며 TEXT03 KEY를 꺼낸다.
		var headList = gridList.getSelectData("gridHeadList");
    	
		if(headList.length < 1){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		var wherestr = ""; 
		var count = 0;
		var phyiky;
		for(var i=0; i<headList.length; i++){
			phyiky = gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "PHYIKY");
			
			if(wherestr == ""){
				wherestr = " AND PHYIKY IN ("; 
			}else{
				wherestr += ",";
			}
			wherestr += "'"+phyiky+"'";
		}
		wherestr+=") ";
		
		// phyiky 없을 경우
		if(phyiky < 1){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		//이지젠 호출부(신버전)
		var width = 600;
		var heigth = 920;
		var map = new DataMap();
		map.put("i_option", '\'<%=wareky %>\'');
		WriteEZgenElement(url , wherestr , "" , "KO", map , width , heigth ); // 구버전 ezgenPrint와 같다
		searchList();
		

    }// end printEZGenDR16(url){

    function confirmData(){

		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("선택된  실사문서가 없습니다.");
				return;
			}
			
			for(var i=0; i<head.length; i++){
				var headMap = head[i].map;
				
				if(headMap.INDDCL == "V"){
					commonUtil.msgBox("이미 완료처리된 실사문서입니다.");
					return;
				}	
			}// end for

			var param = new DataMap();
			param.put("head",head);	
		
			netUtil.send({
				url : "/inventory/json/confirmIP02.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
    	
    }
    	
    	
	function saveData(){
		
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("선택된  실사문서가 없습니다.");
				return;
			}
			
			//아이템 템프 가져오기
	        var tempItem = gridList.getSelectTempData("gridHeadList");
			
			for(var i=0; i<head.length; i++){
				var headMap = head[i].map;
				
				if(headMap.INDDCL == "V"){
					commonUtil.msgBox("이미 완료처리된 실사문서입니다.");
					return;
				}	
			}// end for
			
			//체크한 row중에 수정된 로우
			var item = gridList.getSelectData("gridItemList", true);
			if(head.length == 0 && item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
		
			//item 저장불가 조건 체크
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if(itemMap.RSNADJ == "" || itemMap.RSNADJ == " "){
					commonUtil.msgBox("조정사유코드를 입력해주세요.");
					return;
				}else if(itemMap.SKUKEY == "" || itemMap.SKUKEY == ""){
					commonUtil.msgBox("제품코드를 입력해주세요.");
					return;
				}
			}
		
			var keys = Object.keys(tempItem.map);
			
			for(var i=0; i<keys.length; i++){
				var templist = tempItem.get(keys[i]);
				
				
				for(var j=0; j<templist.length; j++){
					var row = templist[j];
					var rsnadj = row.get("RSNADJ");
					var skukey = row.get("SKUKEY");
					
					if(rsnadj == "" || rsnadj == " "){
						commonUtil.msgBox("조정사유코드를 입력해주세요.");
						return;
					}else if(skukey == "" || skukey == ""){
						commonUtil.msgBox("제품코드를 입력해주세요.");
						return;
					}
				}
			}
			
			var param = new DataMap();
			param.put("head",head);	
			param.put("item",item);	
			param.put("tempItem",tempItem);
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {	// 저장하시겠습니까?
				return;	
			}
			
			netUtil.send({
				url : "/inventory/json/saveIP02.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
				//reSearchList(json);
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}// end successSaveCallBack

	function setChk(){
		//인풋값 가져오기
		var rsnadj = $('#RSNADJCOMBO').val();
		
		if(rsnadj == ""){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}
		
		// 그리드에서 선택 된 값 가져오기
		var selectDataList = gridList.getSelectData("gridItemList", true);
		
		for(var i=0; i<selectDataList.length; i++){
			gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "QTADJU", Number(gridList.getColData("gridItemList", selectDataList[i].get("GRowNum"), "QTADJU")));
			gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "BOXQTY", Number(gridList.getColData("gridItemList", selectDataList[i].get("GRowNum"), "BOXQTY")));
			gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "REMQTY", Number(gridList.getColData("gridItemList", selectDataList[i].get("GRowNum"), "REMQTY")));
			gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "QTSPHY", Number(gridList.getColData("gridItemList", selectDataList[i].get("GRowNum"), "QTSPHY")));
			
			gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "RSNADJ", rsnadj);	// 그리드 조정사유코드 값 셋팅
		}
	}// end setChk
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var qtsphy = 0;
		var boxqty = 0;
		var remqty = 0;
		var pltqty = 0;
		var bxiqty = gridList.getColData(gridId, rowNum, "BXIQTY");
		var qtduom = gridList.getColData(gridId, rowNum, "QTDUOM");
		var pliqty = gridList.getColData(gridId, rowNum, "PLIQTY");
		var remqtyChk = 0;
		
		//조정량일 경우
		if(colName == "QTADJU"){
			var qtyStl = gridList.getColData(gridId, rowNum, "QTYSTL"); //QTYSTL(전산재고)에 가용QTY를 넣고  
			gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "QTADJU", 0);
			
			var value = Number(qtyStl) + Number(colValue);
			if(value < 0){
				commonUtil.msgBox("전산재고는 0개 이하일 수 없습니다.");
				gridList.setColValue(gridId, rowNum, "QTADJU", 0); 
				gridList.setColValue(gridId, rowNum, "QTSPHY", 0);
				return;
			} // end if
			gridList.setColValue(gridId, rowNum, "QTSPHY", value);
			
		}else if(colName == "BOXQTY"){
			boxqty = Number(colValue);
			remqty = gridList.getColData(gridId, rowNum, "REMQTY");
			qtsphy = Number(bxiqty) * Number(boxqty) + Number(remqty);
			pltqty = floatingFloor((Number)(qtsphy)/(Number)(pliqty), 2);
// 			pltqty = Math.floor((Number(qtsphy))/(Number(pliqty)),0);
			
			gridList.setColValue(gridId, rowNum, "QTSPHY", qtsphy); 
			gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
			
		}else if(colName == "REMQTY"){
			qtsphy = gridList.getColData(gridId, rowNum, "QTSPHY");
			boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
			remqty = colValue;
			
			remqtyChk = Number(remqty)%Number(bxiqty);
			boxqty = Number(boxqty) + Number(floatingFloor(Number(remqty)/Number(bxiqty), 1));
			qtsphy = Number(boxqty) * Number(bxiqty) + Number(remqtyChk);
			pltqty = floatingFloor((Number)(qtsphy)/(Number)(pliqty), 2);
// 		  	pltqty = Math.floor(Number(qtsphy)/Number(pliqty), 0);
		  	
		  	gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
		  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
		  	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
		  	gridList.setColValue(gridId, rowNum, "QTSPHY", qtsphy);
		  	
		}else if(colName == "QTSPHY"){ // 실물재고
			if(colValue == ""){
				gridList.setColValue(gridId, rowNum, colName, 0);
				gridList.setColValue(gridId, rowNum, "QTSPHY", -1 * Number(gridList.getColData(gridId, rowNum, "QTYSTL")));
				return;
			}
		
			var qtyStl = gridList.getColData(gridId, rowNum, "QTYSTL");  //QTYSTL(전산재고)에 가용QTY를 넣고  
			if(colValue == ""){
				gridList.setColValue(gridId, rowNum, "QTSPHY", 0);
				return;
			}
			
			var value = Number(colValue) - Number(qtyStl);
			gridList.setColValue(gridId, rowNum, "QTADJU", value);
			
			qtsphy = Number(colValue);	
			boxqty = gridList.getColData(gridId, rowNum, "BOXQTY"); 
		  	remqty = gridList.getColData(gridId, rowNum, "REMQTY"); 
		  	boxqty = floatingFloor(Number(qtsphy)/Number(bxiqty), 1);
		  	remqty = Number(qtsphy)%Number(bxiqty);
		  	pltqty = floatingFloor((Number)(qtsphy)/(Number)(pliqty), 2);
// 		  	pltqty = Math.floor(Number(qtsphy)/Number(pliqty), 0);
		  	
		  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
		  	gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
		  	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
		}// end if
		
		if((Number)(qtsphy) < 0){
			commonUtil.msgBox("재고조사수량을 확인해주세요");
			gridList.setColValue(gridId, rowNum, "QTSPHY", 0);
		  	gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
		  	gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
			return;
		}

	} // end gridListEventColValueChange
	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
        
        if( gridId == "gridItemList" ){
         	var cnlcfm = gridList.getColData("gridHeadList", headRow, "INDDCL");
         	 
   			if(cnlcfm == "V" ){
   				return true;
   			}
        }// end if
    }// end gridListCheckBoxDrawBeforeEvent
    
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
        
       if(searchCode == "SHLOTA03CM"){
            param.put("OWNRKY",$('#OWNRKY').val());
            param.put("PTNRTY","0001");
            
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
					<input type="button" CB="Save SAVE BTN_SAVE" />
					<input type="button" CB="CONFIRM SAVE BTN_CLOSING" />
					<input type="button" CB="Print PRINT_OUT BTN_PRINT" />
					<input type="button" CB="Printroc PRINT_OUT BTN_PRINTROC" />
					<input type="button" CB="Printgrp PRINT_OUT BTN_PRINTGRP" />
					<input type="button" CB="Printsku PRINT_OUT BTN_PRINTSKU" />
					<input type="button" CB="Printall PRINT_OUT BTN_PRINTALL" />
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

					<!-- 조사타입 -->
					<dl>
						<dt CL="STD_PHSCTY"></dt>
						<dd>
							<input name="PHSCTY" id="PHSCTY" class="input"  UIInput="SR,SHPHSCTY" validate="required" value="520" readonly="readonly" />
						</dd>
					</dl>
					
					<!-- 문서일자 -->
					<dl>
						<dt CL="STD_DOCDAT"></dt>
						<dd>
							<input type="text" name="DOCDAT" id="DOCDAT" class="input" UIInput="R" UIFormat="C N" PGroup="G1,G2" />
						</dd>
					</dl>
					
					<!-- 재고조사번호 -->
					<dl>
						<dt CL="STD_PHYIKY"></dt> 
						<dd>
							<input name="H.PHYIKY" name="H.PHYIKY" type="text" class="input" UIInput="SR"  PGroup="G1,G2"/>
						</dd>
					</dl>
					
					<!-- 동 -->
					<dl>
						<dt CL="STD_AREAKY"></dt>
						<dd>
							<input name="S.AREAKY" id="S.AREAKY" class="input" UIInput="SR,SHAREMA"></select>
						</dd>
					</dl>
					
					<!-- 존 -->
					<dl>  
						<dt CL="STD_ZONEKY"></dt>
						<dd>
							<select name="ZONEKY" id="ZONEKY" class="input" UIInput="SR,SHZONMA"></select>
						</dd>
					</dl>
					
					<!-- 로케이션 -->
					<dl>
						<dt CL="STD_LOCAKY"></dt>
						<dd>
							<select name="S.LOCAKY" id="S.LOCAKY" class="input" UIInput="SR,SHLOCMA"></select>
						</dd>
					</dl>
					
					<!-- 제품코드 -->
					<dl>
						<dt CL="STD_SKUKEY"></dt>
						<dd>
							<select name="SKUKEY" id="SKUKEY" class="input" UIInput="SR,SHSKUMA"></select>
						</dd>
					</dl>
					
					<!-- 제품명 -->
					<dl>
						<dt CL="STD_DESC01"></dt>
						<dd>
							<input type="text" class="input" name="DESC01" id="DESC01" UIInput="SR" />
						</dd>                                      
					</dl>
					
					<!-- 팔렛트 -->
					<dl>
						<dt CL="STD_TRNUID"></dt>
						<dd>
							<input type="text" class="input" name="TRNUID" id="TRNUID" UIInput="SR" />
						</dd>
					</dl>
					
					<!-- 유통기한 -->
					<dl>
						<dt CL="STD_LOTA13"></dt>
						<dd>
							<input type="text" class="input" name="LOTA13" id="LOTA13" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					
					<!-- 제조일자 -->
					<dl>
						<dt CL="STD_LOTA11"></dt>
						<dd>
							<input type="text" class="input" name="LOTA11" id="LOTA11" UIInput="R,SHLOTA11" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					
					<!-- 벤더 -->
					<dl>
						<dt CL="STD_LOTA03"></dt>
						<dd>
							<input type="text" class="input" name="LOTA03" id="LOTA03" UIInput="SR,SHLOTA03CM" />
						</dd>
					</dl>
					
					<!-- 포장구분 -->
					<dl>
						<dt CL="STD_LOTA05"></dt>
						<dd>
							<input type="text" class="input" name="LOTA05" id="LOTA05" UIInput="SR,SHLOTA05" />
						</dd>
					</dl>
					
					<!-- 재고유형 -->
					<dl>
						<dt CL="STD_LOTA06"></dt>
						<dd>
							<input type="text" class="input" name="LOTA06" id="LOTA06" UIInput="SR,SHLOTA06" />
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
										<td GH="40 STD_NUMBER" GCol="rownum">1</td>     
									    <td GH="40" GCol="rowCheck"></td>                         
										<td GH="100 STD_CMPLET" GCol="check,INDDCL">완료</td>
										<td GH="100 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td>
										<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>
										<td GH="100 STD_DOCDAT" GCol="input,DOCDAT" GF="C">문서일자</td>
										<td GH="100 STD_DOCCAT" GCol="text,DOCCAT" GF="S 10">문서유형</td>
										<td GH="100 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 10">유형명</td>
										<td GH="100 STD_PHYIKY" GCol="text,PHSCTY" GF="S 10">조사타입</td>
										<td GH="100 STD_TISSND" GCol="text,TISSND" GF="S 10">출고확정</td>
										<td GH="100 STD_USRID1" GCol="text,USRID1" GF="S 10">배송지우편번호</td>
										<td GH="100 STD_UNAME1" GCol="text,UNAME1" GF="S 10">배송지주소</td>
										<td GH="100 STD_DEPTID1" GCol="text,DEPTID1" GF="S 10">배송고객명</td>
										<td GH="100 STD_DNAME1" GCol="text,DNAME1" GF="S 10">배송지전화번호</td>
										<td GH="100 STD_USRID2" GCol="text,USRID2" GF="S 10">업무담당자</td>
										<td GH="100 STD_UNAME2" GCol="text,UNAME2" GF="S 10">업무담당자명</td>
										<td GH="100 STD_DEPTID2" GCol="text,DEPTID2" GF="S 10">업무 부서</td>
										<td GH="100 STD_DNAME2" GCol="text,DNAME2" GF="S 10">업무 부서명</td>
										<td GH="100 STD_USRID3" GCol="input,USRID3" GF="S 10">현장담당</td>
										<td GH="100 STD_UNAME3" GCol="text,UNAME3" GF="S 10">현장담당자명</td>
										<td GH="100 STD_DEPTID3" GCol="text,DEPTID3" GF="S 10">현장담당 부서</td>
										<td GH="100 STD_DNAME3" GCol="text,DNAME3" GF="S 10">현장담당 부서명</td>
										<td GH="100 STD_USRID4" GCol="input,USRID4" GF="S 10">현장책임</td>
										<td GH="100 STD_UNAME4" GCol="text,UNAME4" GF="S 10">영업사원명</td>
										<td GH="100 STD_DEPTID4" GCol="text,DEPTID4" GF="S 10">현장책임 부서</td>
										<td GH="100 STD_DNAME4" GCol="text,DNAME4" GF="S 10">영업사원연락처</td>
										<td GH="100 STD_DOCTXT" GCol="input,DOCTXT" GF="S 10">비고</td>
										<td GH="100 STD_CREDAT" GCol="text,CREDAT" GF="S 10">생성일자</td>
										<td GH="100 STD_CRETIM" GCol="text,CRETIM" GF="S 10">생성시간</td>
										<td GH="100 STD_TRNDAT" GCol="text,TRNDAT" GF="S 10">전송일자</td>
										<td GH="100 STD_TRNTIM" GCol="text,TRNTIM" GF="S 10">전송시간</td>
										<td GH="100 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td>
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">                                                                                                           
						<span CL="STD_RSNADJ" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>                                                                  
						<select name="RSNADJCOMBO" id="RSNADJCOMBO"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true"><option></option></select>       
					</li>                                                                                                                                                   
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->                                                                                             
						<input type="button" CB="SetChk SAVE BTN_PART" />                                                                                                   
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
										<td GH="100 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td>   
										<td GH="100 STD_PHYIIT" GCol="text,PHYIIT" GF="S 10">조정 Item</td>  
										<td GH="100 STD_SKUKEY" GCol="text,SKUKEY" GF="S 10">제품코드</td> 
										<td GH="100 STD_DESC01" GCol="text,DESC01" GF="S 10">제품명</td>
										<td GH="100 STD_RSNADJ" GCol="select,RSNADJ" validate="required"> <!--조정사유코드 -->
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option></option>
											</select>
										</td>   
										<td GH="100 STD_QTSPHY" GCol="input,QTSPHY" GF="N 20,0">재고조사수량</td> 
										<td GH="100 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>   
										<td GH="100 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>    
										<td GH="100 STD_QTADJU" GCol="text,QTADJU" GF="N 20,0">조정수량</td>
										<td GH="100 STD_QTYSTL" GCol="text,QTYSTL" GF="N 17,0">전산재고</td>   
										<td GH="100 STD_QTSIWH" GCol="text,QTSIWH" GF="N 17,0">재고수량</td>   
										<td GH="100 STD_USEQTY" GCol="text,USEQTY" GF="N 17,0">가용수량</td>
										<td GH="100 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td>   
										<td GH="100 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>
										<td GH="100 STD_LOCAKY" GCol="text,LOCAKY" GF="S 10">로케이션</td>
										<td GH="100 STD_TRNUID" GCol="text,TRNUID" GF="S 10">팔렛트ID</td>   
										<td GH="100 STD_SECTID" GCol="text,SECTID" GF="S 10">SectionID</td>   
										<td GH="100 STD_PACKID" GCol="text,PACKID" GF="S 10">SET제품코드</td>   
										<td GH="100 STD_QTYPDA" GCol="text,QTYPDA" GF="N 20,0">PDA실사수량</td>   
										<td GH="100 STD_QTYUOM" GCol="text,QTYUOM" GF="S 10">Quantity by unit of measure</td>   
										<td GH="100 STD_PQTY01" GCol="input,PQTY01" GF="S 10">스택패턴 1</td>   
										<td GH="100 STD_PQTY02" GCol="input,PQTY02" GF="S 10">스택패턴 2</td>   
										<td GH="100 STD_PQTY03" GCol="input,PQTY03" GF="S 10">스택패턴 3</td>   
										<td GH="100 STD_PQTY04" GCol="input,PQTY04" GF="S 10">스택패턴 4</td>   
										<td GH="100 STD_PQTY05" GCol="input,PQTY05" GF="S 10">스택패턴 5</td>   
										<td GH="100 STD_PQTY06" GCol="input,PQTY06" GF="S 10">스택패턴 6</td>   
										<td GH="100 STD_TRUNTY" GCol="text,TRUNTY" GF="S 10">팔렛타입</td>   
										<td GH="100 STD_MEASKY" GCol="text,MEASKY" GF="S 10">단위구성</td>   
										<td GH="100 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>   
										<td GH="100 STD_QTPUOM" GCol="text,QTPUOM" GF="S 10">Units per measure</td>   
										<td GH="100 STD_DUOMKY" GCol="text,DUOMKY" GF="S 10">단위</td>   
										<td GH="100 STD_QTDUOM" GCol="text,QTDUOM" GF="S 10">입수</td>   
										<td GH="100 STD_SUBSIT" GCol="text,SUBSIT" GF="S 10">다음 Item번호</td>   
										<td GH="100 STD_SUBSFL" GCol="text,SUBSFL" GF="S 10">서브Item플래그</td>   
										<td GH="100 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td>   
										<td GH="100 STD_REFDIT" GCol="text,REFDIT" GF="S 10">참조문서Item번호</td>   
										<td GH="100 STD_REFCAT" GCol="text,REFCAT" GF="S 10">입출고 구분자</td>   
										<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>   
										<td GH="100 STD_LOTA01" GCol="text,LOTA01" GF="S 10">LOTA01</td>   
										<td GH="100 STD_LOTA02" GCol="text,LOTA02" GF="S 10">BATCH NO</td>   
										<td GH="100 STD_LOTA03" GCol="text,LOTA03" GF="S 10">벤더</td>   
										<td GH="100 STD_LOTA03NM" GCol="text,LOTA03NM" GF="S 10">벤더명</td>
										<td GH="100 STD_LOTA04" GCol="text,LOTA04" GF="S 10">LOTA04</td>   
										<td GH="100 STD_LOTA05" GCol="select,LOTA05"><!--포장구분-->
											<select class="input" CommonCombo="LOTA05"></select>
										</td>   
										<td GH="100 STD_LOTA06" GCol="select,LOTA06">  <!--재고유형 -->
											<select class="input" CommonCombo="LOTA06"></select>
										</td>
										<td GH="100 STD_LOTA07" GCol="text,LOTA07" GF="S 10">위탁구분</td>   
										<td GH="100 STD_LOTA08" GCol="text,LOTA08" GF="S 10">LOTA08</td>   
										<td GH="100 STD_LOTA09" GCol="text,LOTA09" GF="S 10">LOTA09</td>   
										<td GH="100 STD_LOTA10" GCol="text,LOTA10" GF="S 10">LOTA10</td>   
										<td GH="100 STD_LOTA11" GCol="text,LOTA11" GF="S 10">제조일자</td>   
										<td GH="100 STD_LOTA12" GCol="text,LOTA12" GF="S 10">입고일자</td>   
										<td GH="100 STD_LOTA13" GCol="text,LOTA13" GF="S 10">유통기한</td>   
										<td GH="100 STD_LOTA14" GCol="text,LOTA14" GF="S 10">LOTA14</td>   
										<td GH="100 STD_LOTA15" GCol="text,LOTA15" GF="S 10">LOTA15</td>   
										<td GH="100 STD_LOTA16" GCol="text,LOTA16" GF="S 10">LOTA16</td>   
										<td GH="100 STD_LOTA17" GCol="text,LOTA17" GF="S 10">LOTA17</td>   
										<td GH="100 STD_LOTA18" GCol="text,LOTA18" GF="S 10">LOTA18</td>   
										<td GH="100 STD_LOTA19" GCol="text,LOTA19" GF="S 10">LOTA19</td>   
										<td GH="100 STD_LOTA20" GCol="text,LOTA20" GF="S 10">LOTA20</td>   
										<td GH="100 STD_AWMSNO" GCol="text,AWMSNO" GF="S 10">SEQ(상단시스템)</td>   
										<td GH="100 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>   
										<td GH="100 STD_DESC02" GCol="text,DESC02" GF="S 10">규격</td>   
										<td GH="100 STD_ASKU01" GCol="text,ASKU01" GF="S 10">포장단위</td>   
										<td GH="100 STD_ASKU02" GCol="text,ASKU02" GF="S 10">세트여부</td>   
										<td GH="100 STD_ASKU03" GCol="text,ASKU03" GF="S 10">피킹그룹</td>   
										<td GH="100 STD_ASKU04" GCol="text,ASKU04" GF="S 10">제품구분</td>   
										<td GH="100 STD_ASKU05" GCol="text,ASKU05" GF="S 10">상온구분</td>   
										<td GH="100 STD_EANCOD" GCol="text,EANCOD" GF="S 10">BARCODE(88코드)</td>   
										<td GH="100 STD_GTINCD" GCol="text,GTINCD" GF="S 10">BOX BARCODE</td>   
										<td GH="100 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>   
										<td GH="100 STD_SKUG02" GCol="text,SKUG02" GF="S 10">중분류</td>   
										<td GH="100 STD_SKUG03" GCol="text,SKUG03" GF="S 10">소분류</td>   
										<td GH="100 STD_SKUG04" GCol="text,SKUG04" GF="S 10">세분류</td>   
										<td GH="100 STD_SKUG05" GCol="text,SKUG05" GF="S 10">제품용도</td>   
										<td GH="100 STD_GRSWGT" GCol="text,GRSWGT" GF="S 10">포장중량</td>   
										<td GH="100 STD_NETWGT" GCol="text,NETWGT" GF="S 10">순중량</td>   
										<td GH="100 STD_WGTUNT" GCol="text,WGTUNT" GF="S 10">중량단위</td>   
										<td GH="100 STD_LENGTH" GCol="text,LENGTH" GF="S 10">포장가로</td>   
										<td GH="100 STD_WIDTHW" GCol="text,WIDTHW" GF="S 10">포장세로</td>   
										<td GH="100 STD_HEIGHT" GCol="text,HEIGHT" GF="S 10">포장높이</td>  
										<td GH="100 STD_CUBICM" GCol="text,CUBICM" GF="S 10">CBM</td>   
										<td GH="100 STD_CAPACT" GCol="text,CAPACT" GF="S 10">CAPA</td>   
										<td GH="100 STD_WORKID" GCol="text,WORKID" GF="S 10"></td>  
										<td GH="100 STD_WORKNM" GCol="text,WORKNM" GF="S 10">작업자명</td>   
										<td GH="100 STD_HHTTID" GCol="text,HHTTID" GF="S 10"></td>   
										<td GH="100 STD_SMANDT" GCol="text,SMANDT" GF="S 10">Client</td>   
										<td GH="100 STD_SEBELN" GCol="text,SEBELN" GF="S 10">구매오더 No</td>   
										<td GH="100 STD_SEBELP" GCol="text,SEBELP" GF="S 10">구매오더 Item</td>   
										<td GH="100 STD_SZMBLNO" GCol="text,SZMBLNO" GF="S 10">B/L NO</td>
										<td GH="100 STD_SZMIPNO" GCol="text,SZMIPNO" GF="S 10">B/L Item NO</td>
										<td GH="100 STD_STRAID" GCol="text,STRAID" GF="S 10">SCM주문번호</td>   
										<td GH="100 STD_SVBELN" GCol="text,SVBELN" GF="S 10">S/O 번호</td>   
										<td GH="100 STD_SPOSNR" GCol="text,SPOSNR" GF="S 10">주문번호(D/O) item</td>   
										<td GH="100 STD_STKNUM" GCol="text,STKNUM" GF="S 10">토탈계획번호</td>   
										<td GH="100 STD_STPNUM" GCol="text,STPNUM" GF="S 10">예약 It</td>   
										<td GH="100 STD_SWERKS" GCol="text,SWERKS" GF="S 10">출발지</td>   
										<td GH="100 STD_SLGORT" GCol="text,SLGORT" GF="S 10">영업 부문</td>   
										<td GH="100 STD_SDATBG" GCol="text,SDATBG" GF="S 10">출고계획일시</td>   
										<td GH="100 STD_STDLNR" GCol="text,STDLNR" GF="S 10">작업장</td>   
										<td GH="100 STD_SSORNU" GCol="text,SSORNU" GF="S 10">차량별피킹번호</td>   
										<td GH="100 STD_SSORIT" GCol="text,SSORIT" GF="S 10">차량별아이템피킹번호</td>   
										<td GH="100 STD_SMBLNR" GCol="text,SMBLNR" GF="S 10">Mat.Doc.No.</td>   
										<td GH="100 STD_SZEILE" GCol="text,SZEILE" GF="S 10">Mat.Doc.it.</td>   
										<td GH="100 STD_SMJAHR" GCol="text,SMJAHR" GF="S 10">M/D 년도</td>   
										<td GH="100 STD_SXBLNR" GCol="text,SXBLNR" GF="S 10">인터페이스번호</td>   
										<td GH="100 STD_SAPSTS" GCol="text,SAPSTS" GF="S 10">상단시스템 Mvt</td>  
										
										<td GH="100 STD_AUTLOC" GCol="text,AUTLOC" GF="S 10">자동창고 여부</td>   
										<td GH="100 STD_QTSALO" GCol="text,QTSALO" GF="N" 20,0>할당수량</td>   
										<td GH="100 STD_QTSPMI" GCol="text,QTSPMI" GF="S 10">입고중</td>   
										<td GH="100 STD_QTSPMO" GCol="text,QTSPMO" GF="S 10">이동중</td>   
										<td GH="100 STD_QTBLKD" GCol="text,QTBLKD" GF="N 20,0">보류수량</td>   
										<td GH="100 STD_INDDCL" GCol="text,INDDCL" GF="S 10">완료</td>   
										<td GH="100 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>   
										<td GH="100 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>   
										<td GH="100 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>   
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