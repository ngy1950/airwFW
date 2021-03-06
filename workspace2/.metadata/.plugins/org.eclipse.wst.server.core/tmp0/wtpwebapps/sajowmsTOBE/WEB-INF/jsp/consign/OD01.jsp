<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL01</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<style>
	.red{color: red !important; }
	.black{color: black !important; }
</style>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "ConsignOutbound", 
			command : "OD01_HEAD",
			itemGrid : "gridItemList",
			itemSearch : false,
		    menuId : "OD01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "ConsignOutbound",
	    	colorType : true ,
			command : "OD01_ITEM",
		    menuId : "OD01"
	    });

		gridList.setReadOnly("gridHeadList", true, ["WAREKY","WARESR", "WARETG", "DOCUTY"]);
		gridList.setReadOnly("gridItemList", true, ["SKUG03"]);

		// 대림 이고 전용 콤보로 세팅 
		$("#OWNRKY2").val('2300');	 
		$("#OWNRKY2").on("change",function(){
			var param = new DataMap();
			param.put("OWNRKY",$(this).val());
			
			var json = netUtil.sendData({
				module : "SajoCommon",
				command : "WAREKYNM_IF2_COMCOMBO",
				sendType : "list",
				param : param
			}); 
			
			$("#WARESR").find("[UIOption]").remove();
			
			var optionHtml = inputList.selectHtml(json.data, true);
			$("#WARESR").append(optionHtml);
			
			var cnt = json.data.filter(function(element,index,array){
				return (element.VALUE_COL == '2316');
			});
			
			if(cnt.length == 0){
				$("#WARESR option:eq(0)").prop("selected",true); 
			}else{
				$("#WARESR").val('2316');	
			}
			
		});

		$("#OWNRKY2").trigger('change');
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	
	//버튼작동
	function commonBtnClick(btnName){
		if(btnName == "Create"){
			create();
		}else if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "OD01");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "OD01");
		}
	}
	
	//생성
	function create(){
		if($("#WARESR").val() == $("#WARETG").val()){
			commonUtil.msgBox("VALID_M0959"); //출고거점과 입고거점이 동일합니다.
			return ; 
		}

		$('#btnSave').show();
		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridItemList");
		gridList.setAddRow("gridHeadList", null);
		gridList.setAddRow("gridItemList", null);
	}
	
	//조회
	function searchList(){

		if($("#WARESR").val() == $("#WARETG").val()){
			commonUtil.msgBox("VALID_M0959"); //출고거점과 입고거점이 동일합니다.
			return ; 
		
		}

		$('#btnSave').show();
		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridItemList");
		
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			
			if($("#GRPRL1").prop("checked") == true){
				param.put("SCCHECK", "001");
			}else if($("#GRPRL2").prop("checked") == true){
				param.put("SCCHECK", "002");
			}
			

			netUtil.send({
				url : "/OyangOutbound/json/displayOY01.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList" //그리드ID
			});

			gridList.setAddRow("gridHeadList", null);
		}
	}


	//저장
	function saveData() {
		
		// checkGridColValueDuple : pk중복값 체크
		if (gridList.validationCheck("gridHeadList", "data") && gridList.validationCheck("gridItemList", "data")) {

			var param = inputList.setRangeDataParam("searchArea");
			var head = getfocusGridDataList("gridHeadList");
			var item = gridList.getModifyList("gridItemList", "A");
			param.put("head",head);
			param.put("item",item);

			if (item.length == 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}

			//item 저장불가 조건 체크
			var dupMap = new DataMap();
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if(itemMap.SKUKEY == "" || itemMap.SKUKEY == " "){
					//제품코드는 필수 입력입니다.
					commonUtil.msgBox("VALID_M0950");
					return; 
				}
				
				//아이템 중복 체크
				if(dupMap.get("SKUKEY") != itemMap.SKUKEY){
					dupMap.put("SKUKEY", itemMap.SKUKEY);
				}else{
					//같은 제품을 두번 입력할 수 없습니다.
					commonUtil.msgBox("VALID_M0951");
					return;
				}
				

				if(Number(itemMap.QTYORG) < 1){
					//수량이 0입니다.
					commonUtil.msgBox("VALID_M0952");
					return;
				}
				
			}
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
				// 저장하시겠습니까?
				return;
			}

			netUtil.send({
				url : "/ConsignOutbound/json/saveOD01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}

	
	//저장성공시 callback
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data != "F"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				$('#btnSave').hide();

				gridList.setColValue("gridHeadList", 0, "SVBELN", json.data);
				searchListSaveAfter(json.data);
			}else{
				commonUtil.msgBox("VALID_M0009");
			}
		}
	}
	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}

	
	//저장 후 조회 
	function searchListSaveAfter(svbeln){
		var param = inputList.setRangeParam("searchArea");
		param.put("SVBELN",svbeln);
		
		//아이템 재조회
		gridList.gridList({
	    	id : "gridItemList",
	    	param : param
	    });
	}
	
	
	//그리드 컬럼 값 변경시 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){

		if(gridId == "gridItemList"){
			if(colName == "SKUKEY"){ //제품코드 변경시

				var param = new DataMap();
				param.put("DOCUTY", $("#RCPTTY").val());
				param.put("WAREKY", $("#WARESR").val());
				param.put("WARERQ", $("#WARESR").val());
				param.put("OWNRKY", $("#OWNRKY2").val());
				param.put("SKUKEY", gridList.getColData(gridId, rowNum, colName));
				
				var json = netUtil.sendData({
					module : "SajoCommon",
					command : "SKUMA_GETDESC_RECD2",
					sendType : "list",
					param : param
				}); 
				
				//sku가 있을 경우 
				if(json && json.data && json.data.length > 0 ){
					gridList.setColValue(gridId, rowNum, "SKUKEY", json.data[0].SKUKEY);
					gridList.setColValue(gridId, rowNum, "DESC01", json.data[0].DESC01);
					gridList.setColValue(gridId, rowNum, "DESC02", json.data[0].DESC02);
					gridList.setColValue(gridId, rowNum, "SKUG02", json.data[0].SKUG02);
					gridList.setColValue(gridId, rowNum, "SKUG03", json.data[0].SKUG03);
					gridList.setColValue(gridId, rowNum, "ASKU02", json.data[0].ASKU02);
					gridList.setColValue(gridId, rowNum, "SKUG05", json.data[0].SKUG05);
					gridList.setColValue(gridId, rowNum, "GRSWGT", json.data[0].GRSWGT);
					gridList.setColValue(gridId, rowNum, "NETWGT", json.data[0].NETWGT);
					gridList.setColValue(gridId, rowNum, "SKUG04", json.data[0].SKUG04);
					gridList.setColValue(gridId, rowNum, "ASKU03", json.data[0].ASKU03);
					gridList.setColValue(gridId, rowNum, "LENGTH", json.data[0].LENGTH);
					gridList.setColValue(gridId, rowNum, "WIDTHW", json.data[0].WIDTHW);
					gridList.setColValue(gridId, rowNum, "HEIGHT", json.data[0].HEIGHT);
					gridList.setColValue(gridId, rowNum, "CUBICM", json.data[0].CUBICM);
					gridList.setColValue(gridId, rowNum, "CAPACT", json.data[0].CAPACT);
					gridList.setColValue(gridId, rowNum, "DUOMKY", json.data[0].DUOMKY);
					gridList.setColValue(gridId, rowNum, "ASKU01", json.data[0].ASKU01);
					gridList.setColValue(gridId, rowNum, "WGTUNT", json.data[0].WGTUNT);
					gridList.setColValue(gridId, rowNum, "UOMKEY", json.data[0].UOMKEY);
					gridList.setColValue(gridId, rowNum, "ASKU04", json.data[0].ASKU04);
					gridList.setColValue(gridId, rowNum, "ASKU05", json.data[0].ASKU05);
					gridList.setColValue(gridId, rowNum, "EANCOD", json.data[0].EANCOD);
					gridList.setColValue(gridId, rowNum, "GTINCD", json.data[0].GTINCD);
					gridList.setColValue(gridId, rowNum, "SKUG01", json.data[0].SKUG01);
					gridList.setColValue(gridId, rowNum, "BXIQTY", json.data[0].BXIQTY);
					gridList.setColValue(gridId, rowNum, "PLIQTY", json.data[0].PLIQTY);
			    	gridList.setColValue(gridId, rowNum, "QTYORG", 0);
					gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
					gridList.setColValue(gridId, rowNum, "REMQTY", 0);
					gridList.setColValue(gridId, rowNum, "PLTQTY", 0);

				}else{
					gridList.setColValue(gridId, rowNum, "SKUKEY", "");
					gridList.setColValue(gridId, rowNum, "DESC01", "");
					gridList.setColValue(gridId, rowNum, "DESC02", "");
					gridList.setColValue(gridId, rowNum, "SKUG02", "");
					gridList.setColValue(gridId, rowNum, "SKUG03", "");
					gridList.setColValue(gridId, rowNum, "ASKU02", "");
					gridList.setColValue(gridId, rowNum, "SKUG05", "");
					gridList.setColValue(gridId, rowNum, "GRSWGT", "");
					gridList.setColValue(gridId, rowNum, "NETWGT", "");
					gridList.setColValue(gridId, rowNum, "SKUG04", "");
					gridList.setColValue(gridId, rowNum, "ASKU03", "");
					gridList.setColValue(gridId, rowNum, "LENGTH", "");
					gridList.setColValue(gridId, rowNum, "WIDTHW", "");
					gridList.setColValue(gridId, rowNum, "HEIGHT", "");
					gridList.setColValue(gridId, rowNum, "CUBICM", "");
					gridList.setColValue(gridId, rowNum, "CAPACT", "");
					gridList.setColValue(gridId, rowNum, "DUOMKY", "");
					gridList.setColValue(gridId, rowNum, "ASKU01", "");
					gridList.setColValue(gridId, rowNum, "WGTUNT", "");
					gridList.setColValue(gridId, rowNum, "UOMKEY", "");
					gridList.setColValue(gridId, rowNum, "ASKU04", "");
					gridList.setColValue(gridId, rowNum, "ASKU05", "");
					gridList.setColValue(gridId, rowNum, "EANCOD", "");
					gridList.setColValue(gridId, rowNum, "GTINCD", "");
					gridList.setColValue(gridId, rowNum, "SKUG01", "");
					gridList.setColValue(gridId, rowNum, "BXIQTY", "");
					gridList.setColValue(gridId, rowNum, "PLIQTY", "");
			    	gridList.setColValue(gridId, rowNum, "QTYORG", 0);
					gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
					gridList.setColValue(gridId, rowNum, "REMQTY", 0);
					gridList.setColValue(gridId, rowNum, "PLTQTY", 0);
				}
			}else if(colName == "QTYORG" || colName == "BOXQTY" || colName == "REMQTY"){ //수량변경시연결된 수량 변경
				var qtyorg = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var grswgt = 0;
				var bxiqty = gridList.getColData(gridId, rowNum, "BXIQTY");
				var qtduom = gridList.getColData(gridId, rowNum, "QTDUOM");
				var pliqty = gridList.getColData(gridId, rowNum, "PLIQTY");
				//var grswgtcnt = gridList.getColData(gridId, rowNum, "GRSWGTCNT");
				
				
				if(gridList.getColData(gridId, rowNum, "SKUKEY") == "" ||gridList.getColData(gridId, rowNum, "SKUKEY") == " " ){
					commonUtil.msgBox("VALID_M0958"); //품번 입력 후 수량을 입력하실 수 있습니다.
			    	gridList.setColValue(gridId, rowNum, "QTYORG", 0);
					gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
					gridList.setColValue(gridId, rowNum, "REMQTY", 0);
					gridList.setColValue(gridId, rowNum, "PLTQTY", 0);
					return;
				}
				
				if( colName == "QTYORG" ) {
				 	qtyorg = colValue;
				 	boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
				 	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
				 	boxqty = floatingFloor((Number)(qtyorg)/(Number)(bxiqty), 1);
				 	remqty = (Number)(qtyorg)%(Number)(bxiqty);
				 	pltqty = floatingFloor((Number)(qtyorg)/(Number)(pliqty), 2);
				 	//grswgt = qtyorg * grswgtcnt;
				 	
				 	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
					
				}else if( colName == "BOXQTY" ){ 
					boxqty = colValue;
				 	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
				 	qtyorg = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				 	pltqty = floatingFloor((Number)(qtyorg)/(Number)(pliqty), 2);
				 	//grswgt = qtyorg * grswgtcnt;
				 	
					gridList.setColValue(gridId, rowNum, "QTYORG", qtyorg);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				}else if( colName == "REMQTY" ){
					qtyorg = gridList.getColData(gridId, rowNum, "QTYORG");
					boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
					remqty = colValue;	
					
					remqtyChk = (Number)(remqty)%(Number)(bxiqty);
					boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
					qtyorg = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
					pltqty = floatingFloor((Number)(qtyorg)/(Number)(pliqty), 2);
					//grswgt = qtyorg * grswgtcnt;
					
					gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);	
					gridList.setColValue(gridId, rowNum, "QTYORG", qtyorg); 	
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				}
			} //수량변경 끝
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "200");
			param.put("DOCUTY", "266");
			param.put("OWNRKY", $("#OWNRKY2").val());
		}
		
		return param;
	}

	
	//ADD 클릭시
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		if(gridId == "gridHeadList"){
			//기본값 세팅 
			newData.put("ORDDAT", dateParser(null, "S", 0, 0, 0));
			newData.put("OTRQDT", dateParser(null, "S", 0, 0, 0));
			newData.put("OWNRKY", $("#OWNRKY2").val());
			newData.put("WAREKY", $("#WARESR").val());
			newData.put("WARESR", $("#WARESR").val());
			newData.put("WARETG", $("#WARETG").val());
			newData.put("DOCUTY", $("#RCPTTY").val());
			newData.put("UOMKEY", "");
		}
		return newData;
	}
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
		if(searchCode == "SHSKU_INFO"){
            param.put("WAREKY",$("#WARESR").val());
            param.put("OWNRKY",$("#OWNRKY2").val());
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "V.WAREKY"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY",$("#WARESR").val());
        	
        }
        
    	return param;
    }

	function linkPopCloseEvent(data){//팝업 종료 
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
					<input type="button" CB="Create SEARCH BTN_CREATE" />
					<input type="button" id="btnSave" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl> <!--화주-->  
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY2"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" disabled></select>
						</dd>
					</dl>
					<dl>  <!--문서유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<select name="RCPTTY" id="RCPTTY" class="input" Combo="SajoCommon,DOCTM_COMCOMBO" ComboCodeView="true"></select>
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="IFT_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="V.EXPDAT" id="ORDDAT" UIFormat="C N"/> 
						</dd> 
					</dl>
					<dl>
						<dt CL="STD_WAREKY2"></dt>
						<dd>
							<select name="WARESR" id="WARESR" class="input" ComboCodeView="true" disabled></select>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_WARESR2"></dt>
						<dd>
							<input type="text" name="WARETG" id="WARETG" class="input" value="2261" readonly/>
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
			    						<td GH="80 IFT_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
    									<td GH="120 STD_WAREKY" GCol="select,WAREKY">	<!--거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"><option></option></select>
										</td>
			    						<td GH="150 STD_WARESRREV" GCol="select,WARESR"><!--출고지시거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>	
			    						<td GH="150 STD_WARETG" GCol="select,WARETG" GF><!--도착거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
										</td>	
			    						<td GH="120 IFT_DOCUTY" GCol="select,DOCUTY"><!--출고유형-->
												<select class="input" Combo="SajoCommon,DOCTM_COMCOMBO"></select>
										</td>	
			    						<td GH="90 STD_DOCDAT" GCol="input,ORDDAT" GF="C">문서일자 </td>	<!--문서일자-->
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_OTRQDT" GCol="input,OTRQDT" GF="C">도착일</td>	<!--출고요청일-->
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
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 IFT_SKUKEY" GCol="input,SKUKEY,SHSKU_INFO" GF="S 20"  validate="required">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_QTSIWH" GCol="text,TOQTSIWH" GF="N 13,0" >재고수량</td>	<!--재고수량-->
			    						<td GH="100 IFT_TEXT01" GCol="input,TEXT01" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="80 IFT_STATUS" GCol="text,STATUS" GF="S 1">C:신규,M:변경,D:삭제)</td>	<!--C:신규,M:변경,D:삭제)-->
			    						<td GH="80 IFT_TDATE" GCol="text,TDATE" GF="S 14">yyyymmddhhmmss(생성일자)</td>	<!--yyyymmddhhmmss(생성일자)-->
			    						<td GH="80 IFT_IFFLG" GCol="text,XDATS" GF="S 1">Default:N, 처리완료시:Y, 미사용:X</td>	<!--Default:N, 처리완료시:Y, 미사용:X-->
			    						<td GH="80 IFT_IFFLG" GCol="text,XTIMS" GF="S 1">Default:N, 처리완료시:Y, 미사용:X</td>	<!--Default:N, 처리완료시:Y, 미사용:X-->
			    						<td GH="80 IFT_IFFLG" GCol="text,XSTAT" GF="S 1">Default:N, 처리완료시:Y, 미사용:X</td>	<!--Default:N, 처리완료시:Y, 미사용:X-->
			    						<td GH="80 IFT_ERTXT" GCol="text,ERTXT" GF="S 220">ERR TEXT</td>	<!--ERR TEXT-->
			    						<td GH="80 위탁수량" GCol="input,QTYORG" GF="N 13,0" validate="required">위탁수량</td>	<!--위탁수량-->
			    						<td GH="50 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="50 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="50 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="50 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="50 STD_PLTQTY" GCol="input,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="50 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="80 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="80 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 50">제품용도</td>	<!--제품용도-->
			    						<td GH="80 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0">포장중량</td>	<!--포장중량-->
			    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0">순중량</td>	<!--순중량-->
			    						<td GH="80 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="80 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="80 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0">포장가로</td>	<!--포장가로-->
			    						<td GH="80 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0">포장세로</td>	<!--포장세로-->
			    						<td GH="80 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0">포장높이</td>	<!--포장높이-->
			    						<td GH="80 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0">CBM</td>	<!--CBM-->
			    						<td GH="80 STD_CAPACT" GCol="text,CAPACT" GF="N 17,0">CAPA</td>	<!--CAPA-->
			    						<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td>	<!--기본단위-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="50 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="80 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="80 STD_EANCOD" GCol="text,EANCOD" GF="S 18">BARCODE(88코드)</td>	<!--BARCODE(88코드)-->
			    						<td GH="80 STD_GTINCD" GCol="text,GTINCD" GF="S 18">BOX BARCODE</td>	<!--BOX BARCODE-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="add"></button>
						<button type='button' GBtn="delete"></button>
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