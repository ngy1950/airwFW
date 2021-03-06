<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL97</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "OutBoundReport",
	    	pkcol : "OWNRKY, SKUKEY",
			command : "DL97_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "OutBoundReport",
			command : "DL97_ITEM"
	    });
		
		gridList.setReadOnly("gridItemList", true, ["WARESR","DIRDVY","DIRSUP"]);
		
		//OTRQDT 날짜 수정
		inputList.rangeMap["map"]["I.OTRQDT"].$from.val(dateParser(null, "SD", 0, 0, 1));   //fromval
		
 		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"AND");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "RCVLOC");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);
	 	
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SETLOC");
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"AND");
		rangeArr.push(rangeDataMap); 
		
		setSingleRangeData('S.LOCAKY', rangeArr); 

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	
	function searchList(){
			
		if(validate.check("searchArea")){
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			var param = inputList.setRangeDataParam("searchArea");
			
			//라디오 버튼 값
			if ($('#Op1').prop("checked") == true ) {
				param.put("CHKMAK","1");
			}else if ($('#Op2').prop("checked") == true ){
				param.put("CHKMAK","2");
			};
			if($('#OWNRKY').val() == '2200' || $('#OWNRKY').val() == '2500'){
				netUtil.send({
					url : "/OutBoundReport/json/displayDL97.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : "gridHeadList" //그리드ID
				});
			} else {
				commonUtil.msgBox("STD_DR001");
				return;
			}
		}
		
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
 			/* gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    }); */ 
			 netUtil.send({
				url : "/OutBoundReport/json/displayDL97Item.data",
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
		else if(gridId == "gridItemList" && dataCount > 0){

			var itemGridBox = gridList.getGridBox('gridItemList');
			var itemList = itemGridBox.getDataAll();
			
			for(var i=0; i<itemList.length; i++){
								
				//출고작업지시하지 않았을 경우 행 수정 불가 (ITEM)
				if(gridList.getColData("gridItemList", i, "C00102") != 'Y'){
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["rowCheck" , "WAREKY" , "QTYREQ", "C00103", "BOXQTY", "REMQTY"]); 
				}else{
					gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), false, ["WAREKY" , "QTYREQ", "C00103", "BOXQTY", "REMQTY"]); 
				}
			}
		}
	}
	
 	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
	        param.put("DOCCAT", "300");
	        param.put("DOCUTY", "399");
	        param.put("DIFLOC", "1");
	        param.put("OWNRKY", $("#OWNRKY").val());
			}
		return param;
	} 
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			 if(colName == "QTYREQ" || colName == "BOXQTY" || colName == "REMQTY" ){
					var qtyreq = 0;
					var boxqty = 0;
					var remqty = 0;
					var pltqty = 0;
					var grswgt = 0;
					var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
					var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
					var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
					var remqtyChk = 0;
				  if( colName == "QTYREQ" ) { 
					qtyreq = Number(gridList.getColData(gridId, rowNum, "QTYREQ"));
				  	boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
				  	boxqty = floatingFloor((Number)(qtyreq)/(Number)(bxiqty), 1);
				  	remqty = (Number)(qtyreq)%(Number)(bxiqty);
				  	pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
				  					  	
				  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				  }
				  if( colName == "BOXQTY" ){ //박스수량 변경시
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
				  	qtyreq = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				  	pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
				  	
				  	gridList.setColValue(gridId, rowNum, "QTYREQ", qtyreq);
				  	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
				  }
				  if( colName == "REMQTY" ){//잔량변경시
				  	qtyreq = Number(gridList.getColData(gridId, rowNum, "QTYREQ"));
				  	boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));					  	
				  	
				  	remqtyChk = (Number)(remqty)%(Number)(bxiqty);
				  	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
				  	qtyreq = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
				  	pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
				  	
				  	gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
				  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
				  	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);	
				  	gridList.setColValue(gridId, rowNum, "QTYREQ", qtyreq); 
				  }	
				  
				  var tmpqtyreq = Number(gridList.getColData(gridId, rowNum, "QTYREQ"));
				  var tmpqtyorg = Number(gridList.getColData(gridId, rowNum, "QTYORG"));
				  if( Number(tmpqtyorg)!= Number(tmpqtyreq) ){
					gridList.setRowReadOnly(gridId, rowNum, false, ["C00103"]);
				  	//item.lockCellById(rowId, "C00103", false);
				  }else {
					gridList.setRowReadOnly(gridId, rowNum, true, ["C00103"]);
				  	//item.lockCellById(rowId, "C00103", true);
				  }
				  
				}
			} else if( colName == "C00103" ){
				var c00103 = Number(gridList.getColData(gridId, rowNum, "C00103"));
				if(Number(c00103) < 900){
					alert('사용할 수 없는 사유코드 입니다.');
					gridList.setColValue(gridId, rowNum, "C00103", " ");
				}
			} 
	}
/*  	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		if(gridId == "gridItemList"){
			var qtyreq = Number(gridList.getColData(gridId, rowNum, "QTYREQ"));
			var remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
			gridList.setColValue(gridId, rowNum, "REMQTY", remqty - qtyreq);
		}
	}  */
 	
 	
	function saveData(){
		if(gridList.validationCheck("gridItemList", "select")){
			var item = gridList.getSelectModifyList("gridItemList");
			if(item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var head = gridList.getSelectData("gridHeadList", true); 
			
			for(var i=0; i < item.length; i++){
				var itemMap = item[i].map;
					
					if(Number(itemMap.QTYORG) != Number(itemMap.QTYREQ)){
				 		if(itemMap.C00103.trim() == "" || itemMap.C00103.trim() == "N" ){
							commonUtil.msgBox("DAERIM_C00102NVL");//* 수량변경시 사유코드는 필수 입력 입니다. *
							return;
						}
					}	
			}

			
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			
	    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/OutBoundReport/json/saveDL97.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
		
	}
	
/* 	function saveData(){
		if(gridList.validationCheck("gridItemList", "modify")){
			var item = gridList.getModifyData("gridHeadList", "A")
			if(item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var head = gridList.getModifyData("gridHeadList", "A")
			
			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/OutBoundReport/json/saveDL97.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	} */
	
	
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
	
	function reloadLabel() {
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}
	
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		} else if (btnName == "Save") {
			saveData();
		} else if (btnName == "Reload") {
			reloadLabel();
		} else if (btnName == "Applynumber") {
			Applynumber();
		} else if (btnName == "Apply") {
			Apply();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL97");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DL97");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	function Applynumber(){
		/* saveToGridCopy("ifwms113GridItem","ALLNUMBER","QTYREQ",true);
   		changeNumber(); */
   		
   		//수정불가조건 체크 를 위해 체크박스 체크한 리스트만 들고온다.
		var itemList = gridList.getSelectData("gridItemList");
   		
		for(var i=0; i<itemList.length; i++){

			gridList.setColValue("gridItemList", itemList[i].get("GRowNum"), "QTYREQ", $("#ALLNUMBER").val());
			//사유코드 gridChange이벤트를 강제발생시킨다.
			gridListEventColValueChange("gridItemList", itemList[i].get("GRowNum"), "QTYREQ", $("#ALLNUMBER").val());

		}
	}
	function Apply(){

		var itemList = gridList.getSelectData("gridItemList");

		for(var i=0; i<itemList.length; i++){

			gridList.setColValue("gridItemList", itemList[i].get("GRowNum"), "C00103", $("#ALLRSNADJ").val());
			//사유코드 gridChange이벤트를 강제발생시킨다.
			gridListEventColValueChange("gridItemList", itemList[i].get("GRowNum"), "C00103", $("#ALLRSNADJ").val());

		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();
	    
		//요청사업장
		if(searchCode == "SHCMCDV" && $inputObj.name == "I.WARESR"){
        param.put("CMCDKY","PTNG05");
    	param.put("OWNRKY","<%=ownrky %>");
		//납품처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
	        param.put("PTNRTY","0007");
	        param.put("OWNRKY","<%=ownrky %>");
	    //매출처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNROD"){
	        param.put("PTNRTY","0001");
	        param.put("OWNRKY","<%=ownrky %>");	
	    //제품코드
		}else if(searchCode == "SHSKUMA"){
	        param.put("WAREKY","<%=wareky %>");
	        param.put("OWNRKY","<%=ownrky %>");	
	    //세트여부
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "S.ASKU02"){
	        param.put("CMCDKY","ASKU02");
	        param.put("OWNRKY","<%=ownrky %>");
		//주문구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
	        param.put("CMCDKY","PGRC03");
	    	param.put("OWNRKY","<%=ownrky %>");    
	    //배송구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
	        param.put("CMCDKY","PGRC02");
	    	param.put("OWNRKY","<%=ownrky %>");    
	    //로케이션
	    } else if(searchCode == "SHLOCMA" && $inputObj.name == "S.LOCAKY"){
		    param.put("WAREKY","<%=wareky %>");	
	    } return param;
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
					<input type="button" CB="Reload RESET STD_REFLBL" />
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
						<dt CL="STD_DATA_SPLTR"></dt><!-- 구분자 -->
						<dd style="width:300px">
							<input type="radio" name="CHKMAK" id="Op1" value="Op1" checked /><label for="Op1">주문기준</label>
		        			<input type="radio" name="CHKMAK" id="Op2" value="Op2" /><label for="Op2">재고기준</label>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ORDDAT"></dt> <!-- 출고일자 -->
						<dd>
							<input type="text" class="input" name="I.ORDDAT" UIInput="B" UIFormat="C"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ODDATE"></dt> <!-- 주문일자 -->
						<dd>
							<input type="text" class="input" name="I.ERPCDT" UIInput="B" UIFormat="C"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_OTRQDT"></dt> <!-- 출고요청일 -->
						<dd>
							<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C"/>
						</dd>
					</dl>
					<dl>
						<dt CL="IFT_ORDTYP"></dt> <!-- 주문/출고형태 -->
						<dd>
							<input type="text" class="input" name="I.ORDTYP" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SVBELN"></dt> <!-- S/O 번호 -->
						<dd>
							<input type="text" class="input" name="I.SVBELN" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DOCUTY"></dt> <!-- 출고유형 -->
						<dd>
							<input type="text" class="input" name="I.DOCUTY" UIInput="SR,SHDOCTMIF"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WARESR"></dt> <!-- 요청사업장 -->
						<dd>
							<input type="text" class="input" name="I.WARESR" UIInput="SR,SHCMCDV" />
						</dd>
					</dl>
					<dl>
						<dt CL="IFT_PTNRTO"></dt> <!-- 납품처코드 -->
						<dd>
							<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN" />
						</dd>
					</dl>
					<dl>
						<dt CL="IFT_PTNROD"></dt> <!-- 매출처코드 -->
						<dd>
							<input type="text" class="input" name="I.PTNROD" UIInput="SR,SHBZPTN" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SKUKEY"></dt> <!-- 제품코드 -->
						<dd>
							<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ASKU02"></dt> <!-- 세트여부 -->
						<dd>
							<input type="text" class="input" name="S.ASKU02" UIInput="SR,SHCMCDV" />
						</dd>
					</dl>
					<dl>
						<dt CL="IFT_DIRSUP"></dt> <!-- 주문구분 -->
						<dd>
							<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMCDV" />
						</dd>
					</dl>
					<dl>
						<dt CL="IFT_DIRDVY"></dt> <!-- 배송구분 -->
						<dd>
							<input type="text" class="input" name="I.DIRDVY" UIInput="SR,SHCMCDV" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA05"></dt> <!-- 배송구분 -->
						<dd>
							<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOTA06"></dt> <!-- 재고유형 -->
						<dd>
							<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA06" value="00" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOCAKY"></dt> <!-- 로케이션 -->
						<dd>
							<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA" readonly />
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
										<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
										<td GH="60 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
										<td GH="80 STD_DESC04" GCol="text,DESC04" GF="S 200">품목메모</td> <!--품목메모-->
										<td GH="60 STD_BXIQTY" GCol="text,BXIQTY" GF="S 80" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="90 STD_BOXQTYR1" GCol="text,BOXQTY1" GF="N 80,1">주문내역(BOX)</td> <!--주문내역(BOX)-->
										<td GH="90 STD_QTSIWHR1" GCol="text,QTSIWH1" GF="N 80,0">주문내역(낱개)</td> <!--주문내역(낱개)-->
										<td GH="140 STD_BOXQTYR2" GCol="text,BOXQTY2" GF="N 80,1">출고가능재고수량(BOX)</td> <!--출고가능재고수량(BOX)-->
										<td GH="140 STD_QTSIWHR2" GCol="text,QTSIWH2" GF="N 80,0">출고가능재고수량(낱개)</td> <!--출고가능재고수량(낱개)-->
										<td GH="90 STD_BOXQTYR3" GCol="text,BOXQTY3" GF="N 80,1">부족수량(BOX)</td> <!--부족수량(BOX)-->
										<td GH="90 STD_QTSIWHR3" GCol="text,QTSIWH3" GF="N 80,0">부족수량(낱개)</td> <!--부족수량(낱개)-->
										<td GH="140 STD_BOXQTYR4" GCol="text,BOXQTY4" GF="N 80,1">입고예정수량(BOX)</td> <!--입고예정수량(BOX)-->
										<td GH="140 STD_QTSIWHR4" GCol="text,QTSIWH4" GF="N 80,0">입고예정수량(낱개)</td> <!--입고예정수량(낱개)-->
										<td GH="140 STD_BOXQTYR5" GCol="text,BOXQTY5" GF="N 80,1">이고입고예정수량(BOX)</td> <!--이고입고예정수량(BOX)-->
										<td GH="140 STD_QTSIWHR5" GCol="text,QTSIWH5" GF="N 80,0">이고입고예정수량(낱개)</td> <!--이고입고예정수량(낱개)-->
										<td GH="90 STD_BOXQTYR6" GCol="text,BOXQTY6" GF="N 80,1">보류수량(BOX)</td> <!--보류수량(BOX)-->
										<td GH="90 STD_QTSIWHR6" GCol="text,QTSIWH6" GF="N 80,0">보류수량(낱개)</td> <!--보류수량(낱개)-->
										<td GH="110 STD_BOXQTYR7" GCol="text,BOXQTY7" GF="N 80,1">미적치수량(BOX)</td> <!--미적치수량(BOX)-->
										<td GH="110 STD_QTSIWHR7" GCol="text,QTSIWH7" GF="N 80,0">미적치수량(낱개)</td> <!--미적치수량(낱개)-->
										<td GH="110 STD_QTYPREB" GCol="text,QTYPRE" GF="N 80,1">선입고수량(BOX)</td> <!--선입고수량(BOX)-->
										<td GH="140 STD_QTYPRE2" GCol="text,QTYPRE2" GF="N 80,1">유통선입고수량(낱개)</td> <!--유통선입고수량(낱개)-->
										<td GH="140 STD_BOXPRE2" GCol="text,BOXPRE2" GF="N 80,1">유통선입고수량(BOX)</td> <!--유통선입고수량(BOX)-->
										<td GH="90 STD_BOXWH1" GCol="text,BOXWH1" GF="N 80,1">평택물류(BOX)</td> <!--평택물류(BOX)-->
										<td GH="90 STD_QTYWH1" GCol="text,QTYWH1" GF="N 80,1">평택물류(낱개)</td> <!--평택물류(낱개)-->
										<td GH="90 STD_BOXWH2" GCol="text,BOXWH2" GF="N 80,1">칠서물류(BOX)</td> <!--칠서물류(BOX)-->
										<td GH="90 STD_QTYWH2" GCol="text,QTYWH2" GF="N 80,1">칠서물류(낱개)</td> <!--칠서물류(낱개)-->
										<td GH="90 STD_BOXWH3" GCol="text,BOXWH3" GF="N 80,1">인천물류(BOX)</td> <!--인천물류(BOX)-->
										<td GH="90 STD_QTYWH3" GCol="text,QTYWH3" GF="N 80,1">인천물류(낱개)</td> <!--인천물류(낱개)-->
										<td GH="90 STD_BOXWH4" GCol="text,BOXWH4" GF="N 80,1">양지물류(BOX)</td> <!--양지물류(BOX)-->
										<td GH="90 STD_QTYWH4" GCol="text,QTYWH4" GF="N 80,1">양지물류(낱개)</td> <!--양지물류(낱개)-->
										<td GH="90 STD_BOXWH41" GCol="text,BOXWH4_1" GF="N 80,1">백암물류(BOX)</td> <!--백암물류(BOX)-->
										<td GH="90 STD_QTYWH41" GCol="text,QTYWH4_1" GF="N 80,1">백암물류(낱개)</td> <!--백암물류(낱개)-->
										<td GH="90 STD_BOXWH42" GCol="text,BOXWH4_2" GF="N 80,1">신안물류(BOX)</td> <!--신안물류(BOX)-->
										<td GH="90 STD_QTYWH42" GCol="text,QTYWH4_2" GF="N 80,1">신안물류(낱개)</td> <!--신안물류(낱개)-->
										<td GH="90 STD_BOXWH5" GCol="text,BOXWH5" GF="N 80,1">영천물류(BOX)</td> <!--영천물류(BOX)-->
										<td GH="90 STD_QTYWH5" GCol="text,QTYWH5" GF="N 80,1">영천물류(낱개)</td> <!--영천물류(낱개)-->
										<td GH="90 STD_BOXS30" GCol="text,BOXS30" GF="N 80,1">대기재고(BOX)</td> <!--대기재고(BOX)-->
										<td GH="90 STD_QTYS30" GCol="text,QTYS30" GF="N 80,1">대기재고(낱개)</td> <!--대기재고(낱개)-->
										<td GH="90 STD_BOXQTYR8" GCol="text,BOXQTY8" GF="N 80,1">발주수량(BOX)</td> <!--발주수량(BOX)-->
										<td GH="90 STD_QTSIWHR8" GCol="text,QTSIWH8" GF="N 80,0">발주수량(낱개)</td> <!--발주수량(낱개)-->
										<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 80" style="text-align:right;" >팔렛당수량</td> <!--팔렛당수량-->
										<td GH="140 STD_PLTBOX" GCol="text,PLTBOX" GF="N 80,0">PLT별BOX적재수량</td> <!--PLT별BOX적재수량-->
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX"> <!-- 수량적용 -->
						<span CL="STD_QTYCON" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<input type="text" id="ALLNUMBER" name="ALLNUMBER"  UIInput="I"  class="input"/>
						<input type="button" CB="Applynumber APPLYNUMBER BTN_REFLECT" />
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX"> <!-- 사유코드 -->
                  		<span CL="IFT_C00103" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
                  		<select name="ALLRSNADJ" id="ALLRSNADJ"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true"><option></option></select>
                  		<input type="button" CB="Apply APPLY BTN_REFLECT" />
               		</li>
               		<li style="TOP: 4PX;VERTICAL-ALIGN: middle;"> <!-- 저장 -->
						<input type="button" CB="Save SAVE BTN_SAVE" />
					</li>
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
										<td GH="80 IFT_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
											
										<td GH="200 IFT_WAREKY" GCol="select,WAREKY"> <!--WMS거점(출고사업장)-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
										</td>
										
										<td GH="200 STD_IFPGRC04" GCol="select,WARESR"> <!--요청사업장-->
												<select class="input" CommonCombo="PTNG06"></select>
										</td>
										
										<td GH="80 IFT_DOCUTY" GCol="text,DOCUTY" GF="S 3">출고유형</td> <!--출고유형-->
										<td GH="80 IFT_DOCUTYNM" GCol="text,DOCUTYNM" GF="S 50">문서타입명</td> <!--문서타입명-->
										<td GH="80 IFT_ORDTYP" GCol="text,ORDTYP" GF="S 7">주문/출고형태</td> <!--주문/출고형태-->
										<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td> <!--출고일자-->
										<td GH="80 STD_CTODDT" GCol="text,ERPCDT" GF="D 8">주문일자</td> <!--주문일자-->
										<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
										<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td> <!--출고요청일-->
										<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td> <!--납품처코드-->
										<td GH="180 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td> <!--납품처명-->
										<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td> <!--매출처코드-->
										<!-- <td GH="180 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td> 매출처명 -->
										<td GH="100 IFT_DIRDVY" GCol="select,DIRDVY">
											<select class="input" CommonCombo="PGRC02"></select>	<!--배송구분-->
										</td> <!--배송구분-->
										<td GH="100 IFT_DIRSUP" GCol="select,DIRSUP">
											<select class="input" CommonCombo="PGRC03"></select>	<!--주문구분-->
										</td> <!--주문구분-->
										<td GH="100 IFT_CUSRID" GCol="text,CUSRID" GF="S 20">배송고객 아이디</td> <!--배송고객 아이디-->
										<td GH="80 IFT_CUNAME" GCol="text,CUNAME" GF="S 35">배송고객명</td> <!--배송고객명-->
										<td GH="100 IFT_CUPOST" GCol="text,CUPOST" GF="S 10">배송지 우편번호</td> <!--배송지 우편번호-->
										<td GH="100 IFT_CUNATN" GCol="text,CUNATN" GF="S 3">배송자 국가 키 </td> <!--배송자 국가 키 -->
										<td GH="110 IFT_CUTEL1" GCol="text,CUTEL1" GF="S 16">배송자 전화번호1</td> <!--배송자 전화번호1-->
										<td GH="110 IFT_CUTEL2" GCol="text,CUTEL2" GF="S 31">배송자 전화번호2</td> <!--배송자 전화번호2-->
										<td GH="110 IFT_CUMAIL" GCol="text,CUMAIL" GF="S 723">배송자 E-MAIL</td> <!--배송자 E-MAIL-->
										<td GH="250 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td> <!--배송지 주소-->
										<td GH="110 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td> <!--거래처 담당자명-->
										<td GH="150 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td> <!--거래처 담당자 전화번호-->
										<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td> <!--영업사원명-->
										<td GH="130 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td> <!--영업사원 전화번호-->
										<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td> <!--비고-->
										<td GH="80 IFT_CHKSEQ" GCol="text,CHKSEQ" GF="S 10">검수번호</td> <!--검수번호-->
										<td GH="110 IFT_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">주문번호아이템</td> <!--주문번호아이템-->
										<td GH="110 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td> <!--주문아이템번호-->
										<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
										<td GH="80 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">요청수량</td> <!--요청수량-->
										<td GH="80 IFT_QTYREQ" GCol="input,QTYREQ" GF="N 13,0">납품요청수량</td> <!--납품요청수량-->
										<td GH="80 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS관리수량</td> <!--WMS관리수량-->
										<td GH="80 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td> <!--출하수량-->
										<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td> <!--기본단위-->
										<td GH="250 IFT_C00103" GCol="select,C00103"><!--사유코드-->
		                                    <select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
		                                       <option></option>
		                                    </select>
                               			</td> 
										<td GH="80 IFT_LMODAT" GCol="text,LMODAT" GF="S 8">LMODAT</td> <!--LMODAT-->
										<td GH="80 IFT_LMOTIM" GCol="text,LMOTIM" GF="S 6">LMOTIM</td> <!--LMOTIM-->
										<td GH="80 IFT_STATUS" GCol="text,STATUS" GF="S 1">C:신규,M:변경,D:삭제)</td> <!--C:신규,M:변경,D:삭제)-->
										<td GH="80 IFT_TDATE" GCol="text,TDATE" GF="D 14">yyyymmddhhmiss(생성일자)</td> <!-- yyyymmddhhmiss(생성일자) S->D -->
										<!-- <td GH="80 IFT_CDATE" GCol="text,CDATE" GF="D 14">yyyymmddhhmiss(처리일자)</td> yyyymmddhhmiss(처리일자) S->D -->
										<!-- <td GH="80 IFT_IFFLG" GCol="text,IFFLG" GF="S 1">Default:N, 처리완료시:Y, 미사용:X</td> Default:N, 처리완료시:Y, 미사용:X -->
										<!-- <td GH="80 IFT_ERTXT" GCol="text,ERTXT" GF="S 220">ERR TEXT</td> ERR TEXT -->
										<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td> <!--팔렛당수량-->
										<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
										<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td> <!--팔레트수량-->
										<td GH="80 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
										<td GH="80 STD_PLTBOX" GCol="text,PLTBOX" GF="N 17,1">PLT별BOX적재수량</td> <!--PLT별BOX적재수량-->
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