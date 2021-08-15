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
var reparam = new DataMap();
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Inventory",
	    	itemGrid : "gridItemList",
			command : "IP04_HEAD",
			itemSearch : false,
		    menuId : "IP05"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Inventory",
	    	command : "IP04_ITEM",
	    	colorType : true,
			/* pkcol : "LOCAKY,SKUKEY,LOTA13,LOTA11,LOTA06,LOTA05,LOTA16,LOTA03,LOTA01,LOTA02,LOTA04,LOTA07,OUTDMT,LOTA12", */
		    menuId : "IP05"
			
	    });	
		gridList.setReadOnly("gridHeadList", true, ["PHSCTY"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});

	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			
			var param = inputList.setRangeDataParam("searchArea")
			param.put("CREUSR", "<%=userid%>");
			param.put("PHSCTY","511");

			uiList.setActive("Save",true);
			gridList.setAddRow("gridItemList", null);	
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	//ADD 클릭시
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		
		return newData;
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		gridList.gridList({
	    	id : "gridItemList",
	    	param : param
	    });
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		
		// 조사타입 공통코드
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "500");
			param.put("DOCUTY", "511");
			param.put("OWNRKY", $("#OWNRKY").val());
			
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("OWNRKY", $("#OWNRKY").val());
			param.put("DOCCAT", "500");
			param.put("DOCUTY", "511");
			
		}
		return param;
	}
	
	function saveData(){
		if(gridList.validationCheck('gridItemList')) {
			var head = gridList.getGridData("gridHeadList");
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			//체크한 row중에 수정된 로우
			var item = gridList.getSelectData("gridItemList", true);
			if(item.length == 0 && item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				// 제품코드 입력 체크				
				if(itemMap.SKUKEY == "" || itemMap.SKUKEY == " "){
					commonUtil.msgBox("제품코드를 입력해주세요.");
					return;
				}
				
				/* //재고조사수량 입력 체크
				if(itemMap.QTSPHY == "" || itemMap.QTSPHY == " "){
					commonUtil.msgBox("재고조사수량을 입력해주세요.");
					return;
				} */
				
				// 조정사유코드 입력 체크
				if(itemMap.RSNADJ == "" || itemMap.RSNADJ == " "){
					commonUtil.msgBox("조정사유코드를 입력해주세요.");
					return;
				}
				
				// 로케이션 입력 체크
				if(itemMap.LOCAKY == "" || itemMap.LOCAKY == " "){
					commonUtil.msgBox("로케이션을 입력해주세요.");
					return;
				}
				
				if(itemMap.LOTA06 == "" || itemMap.LOTA06 == " "){
					gridList.setColValue("gridItemList", item[i].get("GRowNum"), "LOTA06", "00"); // 재고유형 미 선택시 "정상재고" 셋팅
				}
			}			
	
			item = gridList.getSelectData("gridItemList", true);
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			param.put("OWNRKY",$("#OWNRKY").val());
			param.put("WAREKY",$("#WAREKY").val());
			param.put("CREUSR", "<%=userid%>");
			param.put("LMOUSR", "<%=userid%>");
			param.put("INDDCL", "V");

			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
				// 저장하시겠습니까?
				return;
			}
			
			netUtil.send({
				url : "/inventory/json/saveIP04.data",
				param : param,
				successFunction : "successSaveCallBack"
			}); 
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				gridList.setColValue("gridHeadList", 0, "PHYIKY", json.data["PHYIKY"]);
				uiList.setActive("Save",false);
				commonUtil.msgBox("SYSTEM_SAVEOK");
				
				//저장 후  재조회
 				var param = new DataMap();
 				param.put("PHYIKY", json.data["PHYIKY"]);
 				
 				netUtil.send({
 		    		module : "Inventory",
 					command : "GETIP05ILIST",
 					bindType : "grid",
 					sendType : "list",
 					bindId : "gridItemList",
 			    	param : param
 				});
 				
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
		}else if(btnName == "SetChk"){
			setChk();
		}else if(btnName == "Create"){
			create();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "IP05");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "IP05");
		}
	}
	
	//생성
	function create(){
		var param = inputList.setRangeDataParam("searchArea");
		searchList();
		
		netUtil.send({
    		module : "Inventory",
			command : "IP04_ITEM",
			bindType : "grid",
			sendType : "list",
			bindId : "gridItemList",
	    	param : param
		});
	}

	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 로케이션 검색
        if(searchCode == "SHLOCMA"){
            param.put("WAREKY", $("#WAREKY").val());
            param.put("OWNRKY", $("#OWNRKY").val());
            
        // 제품코드 검색
        }else if(searchCode == "SHSKU_INFO" ){
            param.put("WAREKY",$("#WAREKY").val());
            param.put("OWNRKY",$("#OWNRKY").val());
        }
        
    	return param;
    }

	
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
			gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "RSNADJ", rsnadj);	// 그리드 조정사유코드 값 셋팅
			
		}
	}// end setChk()
	
	function gridListEventRowCheck(gridId, rowNum, checkType){
		if(checkType){
			var qtsphy = Number(gridList.getColData(gridId, rowNum, "QTSPHY"));
			
			// 재고조사수량 0입력 시 조정수량 계산
			if(qtsphy == 0){
				gridListEventColValueChange(gridId, rowNum, "QTSPHY", 0);
			}
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var qtsphy = 0;
		var boxqty = 0;
		var remqty = 0;
		var pltqty = 0;
		var bxiqty = gridList.getColData(gridId, rowNum, "bxiqty");
		var qtduom = gridList.getColData(gridId, rowNum, "qtduom");
		var pliqty = gridList.getColData(gridId, rowNum, "pliqty");
		var remqtyChk = 0;
		
		if(colName == "QTADJU"){
			var qtyStl = gridList.getColData(gridId, rowNum, "qtystl");
			if(colValue == ""){
				gridList.setColValue(gridId, rowNum, "USEQTY", 0);
			}
			var value = eval(eval(qtyStl) + eval(colValue));
			if(value<0){
				commonUtil.msgBox("전산재고는 0개 이하일 수 없습니다.");
				gridList.setColValue(gridId, rowNum, "QTADJU", 0);
				gridList.setColValue(gridId, rowNum, "QTSPHY", 0);
			}
			gridList.setColValue(gridId, rowNum, "QTSPHY", value);
			
		}else if(colName == "BOXQTY"){
			boxqty = colValue;
			
			remqty = gridList.getColData(gridId, rowNum, "REMQTY");
		  	qtsphy = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
		  	pltqty = floatingFloor((Number)(qtsphy)/(Number)(pliqty), 2);
		  	
		  	gridList.setColValue(gridId, rowNum, "QTSPHY", qtsphy);
			gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
			
		}else if(colName == "REMQTY"){
			qtsphy = gridList.getColData(gridId, rowNum, "QTSPHY");
		  	boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
		  	remqty = colValue;	
		  	
		  	remqtyChk = (Number)(remqty)%(Number)(bxiqty);
		  	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
		  	qtsphy = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
		  	pltqty = floatingFloor((Number)(qtsphy)/(Number)(pliqty), 2);
		  	
		  	gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
		  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
		  	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
		  	gridList.setColValue(gridId, rowNum, "QTSPHY", qtsphy);
	
		}else if(colName == "QTSPHY"){	// 실물재고
			var qtyStl = gridList.getColData(gridId, rowNum, "QTYSTL"); //QTYSTL(전산재고)에 가용QTY를 넣고  
			var value = eval(eval(colValue)-eval(qtyStl));
			
			qtsphy = colValue;
			
			if(qtsphy < 0){
				commonUtil.msgBox("재고조사수량이 0보다 작습니다.");
				gridList.setColValue(gridId, rowNum, colName, 0);	
				return;
			}
			
			boxqty =gridList.getColData(gridId, rowNum, "BOXQTY"); 
		  	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
		  	boxqty = floatingFloor((Number)(qtsphy)/(Number)(bxiqty), 1);
		  	remqty = (Number)(qtsphy)%(Number)(bxiqty);
		  	pltqty = floatingFloor((Number)(qtsphy)/(Number)(pliqty), 2);
		  	
		  	gridList.setColValue(gridId, rowNum, "QTADJU", value);
		  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
		  	gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
		  	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
		  	
		}else if(colName == "SKUKEY"){
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
			
			lota13 = getDate(lota11, Number(outdmt));
			gridList.setColValue(gridId, rowNum, "LOTA13", lota13);
			
		}else if(colName == "LOTA13"){
			var outdmt = gridList.getColData(gridId, rowNum, "OUTDMT");
			var lota13 = gridList.getColData(gridId, rowNum, "LOTA13");
			var lota11 = dateParser(lota13 , 'S', 0 , 0 , -Number(outdmt));
			
			if(lota13.trim() == "") return;
			
			gridList.setColValue(gridId, rowNum, "LOTA11", lota11);	
		}else if(colName == "LOCAKY"){
			var param = new DataMap();
			param.put("LOCAKY", gridList.getColData(gridId, rowNum, colName));
			param.put("WAREKY", $("#WAREKY").val());
			
			var json = netUtil.sendData({
				module : "Inventory",
				command : "LOCMA",
				sendType : "list",
				param : param
			}); 
			
			//AREAKY가 있을 경우 
			if(json && json.data && json.data.length > 0 ){
				gridList.setColValue(gridId, rowNum, "AREAKY", json.data[0].AREAKY);
			}else{
				gridList.setColValue(gridId, rowNum, "AREAKY", "");
			}
		}
	} // end gridListEventColValueChange()
	
	function linkPopCloseEvent(data){//팝업 종료 
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
    }
	
	function addZero(i){
		var rtn = i + 100;
		return rtn.toString().substring(1,3);
	}
	
	
	function converDateString(dt){
		return dt.getFullYear() +addZero(eval(dt.getMonth()+1)) +  addZero(dt.getDate());
	}

	function getDate(s, i){
		var year = s.substr(0,4);
		var month = Number(s.substr(4,2)) - 1;
		var day = s.substr(6,2);
		var newDt = new Date(year, month, day);
		newDt.setDate( newDt.getDate() + Number(i) );
		
		return converDateString(newDt);
	}
	
	function  gridListEventRowCheckAll(gridId, isCheck){
		if(gridId == "gridItemList"){
			var list = gridList.getSelectData(gridId);
			
			//선택 합계
			for(var i=0; i<list.length; i++){
				var data = list[i].map;
				
				// 재고조사수량 0입력 시 조정수량 계산
				if(data.QTSPHY == 0){
					gridListEventColValueChange(gridId, i, "QTSPHY", 0);
				}
			}
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
					<input type="button" CB="Search SEARCH BTN_CREATE" />
					<input type="button" CB="Create SEARCH BTN_RUN" />
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
					
					<dl>  <!--존-->  
						<dt CL="STD_ZONEKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.ZONEKY" UIInput="SR,SHZONMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="S.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--세트여부-->  
						<dt CL="STD_ASKU02"></dt> 
						<dd> 
							<input type="text" class="input" name="S.ASKU02" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품용도-->  
						<dt CL="STD_SKUG05"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUG05" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--팔렛트ID-->  
						<dt CL="STD_TRNUID"></dt> 
						<dd> 
							<input type="text" class="input" name="S.TRNUID" UIInput="SR"/> 
						</dd> 
					</dl> 

					<!-- 유통기한 -->
					<dl>
						<dt CL="STD_LOTA13"></dt>
						<dd>
							<input type="text" class="input" name="LOTA13" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					
					<!-- 입고일자 -->
					<dl>
						<dt CL="STD_LOTA12"></dt>
						<dd>
							<input type="text" class="input" name="LOTA12" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					
					<!-- 벤더 -->
					<dl>
						<dt CL="STD_LOTA03"></dt>
						<dd>
							<input type="text" class="input" name="LOTA03" UIInput="SR,SHLOTA03CM" />
						</dd>
					</dl>
					
					<!-- 포장구분 -->
					<dl>
						<dt CL="STD_LOTA05"></dt>
						<dd>
							<input type="text" class="input" name="LOTA05" UIInput="SR,SHLOTA05" />
						</dd>
					</dl>
					
					<!-- 재고유형 -->
					<dl>
						<dt CL="STD_LOTA06"></dt>
						<dd>
							<input type="text" class="input" name="LOTA06" UIInput="SR,SHLOTA06"/>
						</dd>
					</dl>
					
					<dl>  <!--출고일자-->  
						<dt CL="STD_LOTA13"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA13" id="LOTA13" UIFormat="C" UIInput="R"/> 
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
								        <td GH="100 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td> <!--재고조사번호-->
								        <td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
								        <td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="S 10"></td> <!--문서 유형-->  
								        <td GH="140 STD_PHSCTY" GCol="select,PHSCTY" > <!--조사타입--> 
											<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO">
												<option></option>
											</select>
								        </td> 
								        <td GH="80 STD_DOCDAT" GCol="input,DOCDAT" GF="D 10">문서일자</td> <!--문서일자--> 	        
								        <td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td> <!--생성일자-->
								        <td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td> <!--생성시간-->
								        <td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td> <!--생성자-->
								        <td GH="80 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td> <!--비고-->
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
										<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="80 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
			    						<td GH="90 STD_LOCAKY" GCol="input,LOCAKY,SHLOCMA" GF="S 20" validate="required">로케이션</td>	<!--로케이션-->
			    						<td GH="90 STD_SKUKEY" GCol="input,SKUKEY,SHSKU_INFO" GF="S 200" validate="required">제품코드</td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="50 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="60 STD_QTSIWH" GCol="text,QTSIWH" GF="N 20,0">재고수량</td>	<!--재고수량-->
			    						<td GH="90 STD_QTSPHY" GCol="input,QTSPHY" GF="N 20,0">재고조사수량</td>	<!--재고조사수량-->
			    						<td GH="90 STD_QTADJU" GCol="text,QTADJU" GF="N 20,0">조정수량</td>	<!--조정수량-->
			    						<td GH="160 STD_RSNADJ" GCol="select,RSNADJ" validate="required">
			    							<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option></option>
											</select>
			    						</td>	<!--조정사유코드-->
			    						<td GH="90 STD_TRNUID" GCol="input,TRNUID" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="90 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="90 STD_LOTA03" GCol="input,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="130 STD_LOTA05" GCol="select,LOTA05">
			    							<select class="input" CommonCombo="LOTA05"></select>
			    						</td>	<!--포장구분-->
			    						<td GH="130 STD_LOTA06" GCol="select,LOTA06">
			    							<select class="input" CommonCombo="LOTA06"></select>
			    						</td>	<!--재고유형-->
			    						<td GH="112 STD_LOTA11" GCol="input,LOTA11" GF="C 10">제조일자</td>	<!--제조일자-->
			    						<td GH="80 STD_LOTA12" GCol="input,LOTA12" GF="C 14">입고일자</td>	<!--입고일자-->
			    						<td GH="112 STD_LOTA13" GCol="input,LOTA13" GF="C 14">유통기한</td>	<!--유통기한-->
			    						<td GH="80 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td>	<!--재고키-->
			    						<td GH="80 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td>	<!--재고조사번호-->
			    						<td GH="50 STD_PHYIIT" GCol="text,PHYIIT" GF="S 6">재고조사item</td>	<!--재고조사item-->
			    						<td GH="80 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
			    						<td GH="50 STD_SECTID" GCol="text,SECTID" GF="S 4">SectionID</td>	<!--SectionID-->
			    						<td GH="200 STD_PACKID" GCol="text,PACKID" GF="S 30">SET제품코드</td>	<!--SET제품코드-->
			    						<td GH="160 STD_QTBLKD" GCol="text,QTBLKD" GF="N 20,0">보류수량</td>	<!--보류수량-->
			    						<td GH="160 STD_QTYUOM" GCol="text,QTYUOM" GF="N 20,0">Quantity by unit of measure</td>	<!--Quantity by unit of measure-->
			    						<td GH="40 STD_PQTY01" GCol="input,PQTY01" GF="N 4,0">스택패턴 1</td>	<!--스택패턴 1-->
			    						<td GH="40 STD_PQTY02" GCol="input,PQTY02" GF="N 4,0">스택패턴 2</td>	<!--스택패턴 2-->
			    						<td GH="40 STD_PQTY03" GCol="input,PQTY03" GF="N 4,0">스택패턴 3</td>	<!--스택패턴 3-->
			    						<td GH="40 STD_PQTY04" GCol="input,PQTY04" GF="N 4,0">스택패턴 4</td>	<!--스택패턴 4-->
			    						<td GH="40 STD_PQTY05" GCol="input,PQTY05" GF="N 4,0">스택패턴 5</td>	<!--스택패턴 5-->
			    						<td GH="40 STD_PQTY06" GCol="input,PQTY06" GF="N 4,0">스택패턴 6</td>	<!--스택패턴 6-->
			    						<td GH="50 STD_TRUNTY" GCol="text,TRUNTY" GF="S 4">팔렛타입</td>	<!--팔렛타입-->
			    						<td GH="80 STD_MEASKY" GCol="input,MEASKY" GF="S 10">단위구성</td>	<!--단위구성-->
			    						<td GH="160 STD_QTPUOM" GCol="text,QTPUOM" GF="N 20,0">Units per measure</td>	<!--Units per measure-->
			    						<td GH="50 STD_DUOMKY" GCol="input,DUOMKY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="160 STD_QTDUOM" GCol="text,QTDUOM" GF="N 20,0">입수</td>	<!--입수-->
			    						<td GH="50 STD_SUBSIT" GCol="text,SUBSIT" GF="S 6">다음 Item번호</td>	<!--다음 Item번호-->
			    						<td GH="50 STD_SUBSFL" GCol="text,SUBSFL" GF="S 1">서브Item플래그</td>	<!--서브Item플래그-->
			    						<td GH="80 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td>	<!--참조문서번호-->
			    						<td GH="50 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td>	<!--참조문서Item번호-->
			    						<td GH="50 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td>	<!--입출고 구분자-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="160 STD_LOTA03NM" GCol="text,LOTA03NM" GF="S 20">벤더명</td>	<!--벤더명-->	
			    						<td GH="160 STD_LOTA07" GCol="input,LOTA07" GF="S 20">위탁구분</td>	<!--위탁구분-->
			    						<td GH="160 STD_LOTA08" GCol="text,LOTA08" GF="S 20">LOTA08</td>	<!--LOTA08-->
			    						<td GH="160 STD_LOTA09" GCol="text,LOTA09" GF="S 20">LOTA09</td>	<!--LOTA09-->
			    						<td GH="160 STD_LOTA10" GCol="text,LOTA10" GF="S 20">LOTA10</td>	<!--LOTA10-->
			    						<td GH="112 STD_LOTA14" GCol="text,LOTA14" GF="S 14">LOTA14</td>	<!--LOTA14-->
			    						<td GH="112 STD_LOTA15" GCol="text,LOTA15" GF="S 14">LOTA15</td>	<!--LOTA15-->
			    						<td GH="160 STD_LOTA16" GCol="text,LOTA16" GF="N 20,0">LOTA16</td>	<!--LOTA16-->
			    						<td GH="160 STD_LOTA17" GCol="text,LOTA17" GF="N 20,0">LOTA17</td>	<!--LOTA17-->
			    						<td GH="160 STD_LOTA18" GCol="text,LOTA18" GF="N 20,0">LOTA18</td>	<!--LOTA18-->
			    						<td GH="160 STD_LOTA19" GCol="text,LOTA19" GF="N 20,0">LOTA19</td>	<!--LOTA19-->
			    						<td GH="160 STD_LOTA20" GCol="text,LOTA20" GF="N 20,0">LOTA20</td>	<!--LOTA20-->
			    						<td GH="80 STD_AWMSNO" GCol="text,AWMSNO" GF="S 10">SEQ(상단시스템)</td>	<!--SEQ(상단시스템)-->
			    						<td GH="160 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="160 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="160 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="160 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="160 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="144 STD_EANCOD" GCol="text,EANCOD" GF="S 18">BARCODE(88코드)</td>	<!--BARCODE(88코드)-->
			    						<td GH="144 STD_GTINCD" GCol="text,GTINCD" GF="S 18">BOX BARCODE</td>	<!--BOX BARCODE-->
			    						<td GH="80 STD_SKUG02" GCol="text,SKUG02" GF="S 10">중분류</td>	<!--중분류-->
			    						<td GH="80 STD_SKUG03" GCol="text,SKUG03" GF="S 10">소분류</td>	<!--소분류-->
			    						<td GH="80 STD_SKUG04" GCol="text,SKUG04" GF="S 10">세분류</td>	<!--세분류-->
			    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 20">제품용도</td>	<!--제품용도-->
			    						<td GH="160 STD_GRSWGT" GCol="text,GRSWGT" GF="S 20">포장중량</td>	<!--포장중량-->
			    						<td GH="160 STD_NETWGT" GCol="text,NETWGT" GF="S 20">순중량</td>	<!--순중량-->
			    						<td GH="50 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="160 STD_LENGTH" GCol="text,LENGTH" GF="N 20,0">포장가로</td>	<!--포장가로-->
			    						<td GH="160 STD_WIDTHW" GCol="text,WIDTHW" GF="N 20,0">포장세로</td>	<!--포장세로-->
			    						<td GH="160 STD_HEIGHT" GCol="text,HEIGHT" GF="N 20,0">포장높이</td>	<!--포장높이-->
			    						<td GH="160 STD_CUBICM" GCol="text,CUBICM" GF="N 20,0">CBM</td>	<!--CBM-->
			    						<td GH="160 STD_CAPACT" GCol="text,CAPACT" GF="N 20,0">CAPA</td>	<!--CAPA-->
			    						<td GH="80 STD_WORKID" GCol="text,WORKID" GF="S 10"></td>	<!---->
			    						<td GH="200 STD_WORKNM" GCol="text,WORKNM" GF="S 60">작업자명</td>	<!--작업자명-->
			    						<td GH="80 STD_HHTTID" GCol="text,HHTTID" GF="S 10"></td>	<!---->
			    						<td GH="50 STD_SMANDT" GCol="text,SMANDT" GF="S 3">Client</td>	<!--Client-->
			    						<td GH="80 STD_SEBELN" GCol="text,SEBELN" GF="S 10">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="50 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="160 STD_SZMBLNO" GCol="text,SZMBLNO" GF="S 20">B/L NO</td>	<!--B/L NO-->
			    						<td GH="160 STD_SZMIPNO" GCol="text,SZMIPNO" GF="S 20">B/L Item NO</td>	<!--B/L Item NO-->
			    						<td GH="160 STD_STRAID" GCol="text,STRAID" GF="S 20">SCM주문번호</td>	<!--SCM주문번호-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="50 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						<td GH="80 STD_STKNUM" GCol="text,STKNUM" GF="S 10">토탈계획번호</td>	<!--토탈계획번호-->
			    						<td GH="50 STD_STPNUM" GCol="text,STPNUM" GF="S 6">예약 It</td>	<!--예약 It-->
			    						<td GH="80 STD_SWERKS" GCol="text,SWERKS" GF="S 10">출발지</td>	<!--출발지-->
			    						<td GH="80 STD_SLGORT" GCol="text,SLGORT" GF="S 10">영업 부문</td>	<!--영업 부문-->
			    						<td GH="64 STD_SDATBG" GCol="text,SDATBG" GF="S 8">출고계획일시</td>	<!--출고계획일시-->
			    						<td GH="160 STD_STDLNR" GCol="text,STDLNR" GF="S 20">작업장</td>	<!--작업장-->
			    						<td GH="80 STD_SSORNU" GCol="text,SSORNU" GF="S 10">차량별피킹번호</td>	<!--차량별피킹번호-->
			    						<td GH="50 STD_SSORIT" GCol="text,SSORIT" GF="S 6">차량별아이템피킹번호</td>	<!--차량별아이템피킹번호-->
			    						<td GH="80 STD_SMBLNR" GCol="text,SMBLNR" GF="S 10">Mat.Doc.No.</td>	<!--Mat.Doc.No.-->
			    						<td GH="50 STD_SZEILE" GCol="text,SZEILE" GF="S 6">Mat.Doc.it.</td>	<!--Mat.Doc.it.-->
			    						<td GH="50 STD_SMJAHR" GCol="text,SMJAHR" GF="S 4">M/D 년도</td>	<!--M/D 년도-->
			    						<td GH="128 STD_SXBLNR" GCol="text,SXBLNR" GF="S 16">인터페이스번호</td>	<!--인터페이스번호-->
			    						<td GH="50 STD_SAPSTS" GCol="text,SAPSTS" GF="S 4">상단시스템 Mvt</td>	<!--상단시스템 Mvt-->
			    						<td GH="50 STD_QTYSTL" GCol="text,QTYSTL" GF="N 20,0">전산재고</td>	<!--전산재고-->
			    						<td GH="50 STD_QTYBIZ" GCol="input,QTYBIZ" GF="N 20,0">실물재고</td>	<!--실물재고-->
			    						<td GH="50 STD_USEQTY" GCol="text,USEQTY" GF="N 20,0">가용수량</td>	<!--가용수량-->		
			    						<td GH="50 STD_QTSALO" GCol="text,QTSALO" GF="N 20,0">할당수량</td>	<!--할당수량-->
			    						<td GH="50 STD_QTSPMI" GCol="text,QTSPMI" GF="N 20,0">입고중</td>	<!--입고중-->
			    						<td GH="50 STD_QTSPMO" GCol="text,QTSPMO" GF="N 20,0">이동중</td>	<!--이동중-->
			    						<!-- <td GH="50 STD_QTSBLK" GCol="text,QTSBLK" GF="N 20,0">보류수량</td>	보류수량 -->
			    						<td GH="80 STD_INDDCL" GCol="text,INDDCL" GF="S 10">완료</td>	<!--완료-->
			    						<td GH="80 STD_PURCKY" GCol="text,PURCKY" GF="S 10">구매오더 번호</td>	<!--구매오더 번호-->
			    						<td GH="50 STD_PURCIT" GCol="text,PURCIT" GF="S 6">구매오더 아이템번호</td>	<!--구매오더 아이템번호-->
			    						<td GH="80 STD_ASNDKY" GCol="text,ASNDKY" GF="S 10">ASN 문서번호</td>	<!--ASN 문서번호-->
			    						<td GH="50 STD_ASNDIT" GCol="text,ASNDIT" GF="S 6">ASN It.</td>	<!--ASN It.-->
			    						<td GH="80 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="50 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td>	<!--입고문서아이템-->
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="50 STD_SHPOIT" GCol="text,SHPOIT" GF="S 6">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="80 STD_GRPOKY" GCol="text,GRPOKY" GF="S 10">제품별피킹번호</td>	<!--제품별피킹번호-->
			    						<td GH="50 STD_GRPOIT" GCol="text,GRPOIT" GF="S 6">제품별피킹Item</td>	<!--제품별피킹Item-->
			    						<td GH="80 STD_SADJKY" GCol="text,SADJKY" GF="S 10">조정문서번호</td>	<!--조정문서번호-->
			    						<td GH="50 STD_SADJIT" GCol="text,SADJIT" GF="S 6">조정 Item</td>	<!--조정 Item-->
			    						<td GH="80 STD_SDIFKY" GCol="text,SDIFKY" GF="S 10">작업자별피킹번호</td>	<!--작업자별피킹번호-->
			    						<td GH="50 STD_SDIFIT" GCol="text,SDIFIT" GF="S 6">작업자별피킹아이템</td>	<!--작업자별피킹아이템-->
			    						<td GH="50 STD_OUTDMT" GCol="text,OUTDMT" GF="S 6">유통기한(일수)</td>	
									</tr>
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