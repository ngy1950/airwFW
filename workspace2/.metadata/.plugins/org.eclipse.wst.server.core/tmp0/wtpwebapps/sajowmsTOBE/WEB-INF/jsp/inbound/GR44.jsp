<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>GR44</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<style>
	.red{color: red !important; }
	.black{color: black !important; }
	.blue{color: blue !important; }
</style>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	var headrow = -1;
	var searchParam ;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "GoodReceipt",
			command : "GR44_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
			colorType : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "SVBELN",
			menuId : "GR44"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "GoodReceipt",
			command : "GR44_ITEM",
			totalView : true,
			tempHead : "gridHeadList",
			useTemp : true,
			tempKey : "SVBELN",
			menuId : "GR44"
	    });
		
		//저장버튼 숨김
// 		$('#saveBtn').hide();
				
		//ReadOnly 설정(아이템 그리드  권한 막기)
		gridList.setReadOnly("gridHeadList",true,["SKUG05"]);
		//gridList.setReadOnly("gridItemList",true,["LOTA06"]);
		gridList.setReadOnly("gridItemList",true,["LOTA06"]);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
		

	function searchList(){
		if(validate.check("searchArea")){
			searchParam = null;
			var param = inputList.setRangeDataParam("searchArea");
			
			searchParam = param;
			headrow = -1 ;
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeDataParam("searchArea");
			param.putAll(rowData);
			
			if(gridList.getColData(gridId, rowNum , "RECVKY") == " "){
				netUtil.send({
					url : "/GoodReceipt/json/displayGR44Item.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : "gridItemList" //그리드ID
				});
			}else{
				netUtil.send({
					url : "/GoodReceipt/json/returnGR44Item.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : "gridItemList" //그리드ID
				});
			}
		}
	}
		
	//로케이션으로 focus
	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == 'gridItemList'){
            var newData = new DataMap();
            //생성 버튼 클릭시 아이템 로케이션으로  focus
            gridList.setColFocus(gridId, rowNum, "LOCAKY");
            //출고반품사유 "RSNCOD"
            return newData;
    	}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
		if(gridId == "gridHeadList"){
			var statdo = gridList.getColData(gridId, rowNum , "STATDO");
			if(statdo != "NEW"){
				gridList.setRowReadOnly(gridId, rowNum , true);
				return true;
			}
			
		}else if(gridId == "gridItemList"){
			var statit = gridList.getColData(gridId, rowNum, "STATIT");
			if(statit == "ARV"){
				gridList.setRowReadOnly(gridId, rowNum, true);
				return true;
			}
		}
		return false;
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
			
			if(name == "LOTA01"){ // 인쇄 옵션
				param.put("CMCDKY", "LOTA01");	
			}else if(name == "OPTION"){
				param.put("CMCDKY", "OPTION");	
			}
			
		}else if(comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");			
			return param;
			
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("OWNRKY","<%=ownrky%>");
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "131");
			return param;
	
		}else if(comboAtt == "GoodReceipt,COMBO_RCPTTY"){
			param.put("DOCCAT", "100");
			param.put("PROGID", "GR44");
			return param;
		}
		
		return param;
	}
	
	
	//회수지시 후 
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] != "0"){
				
				//템프 초기화 
				gridList.resetTempData("gridHeadList");

				commonUtil.msgBox("SYSTEM_SAVEOK");
				
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	//저장성공 후 재조회
	function successSaveCallBack2(json, status){
		if(json && json.data){
			if(json.data["CNT"] != "0"){
				
// 				$('#saveBtn').hide();//저장버튼 숨김
				
// 				var recvkylist = json.data["RECVKY"].split(",");
				var recvkystr = " AND IFWMS113.RECVKY IN (";
				
				recvkystr += json.data["SAVEKEY"];
				recvkystr += ")";
								
				var param = inputList.setRangeDataParam("searchArea");
				param.put("RECVKY",json.data["RECVKY"]);
				
				
				netUtil.send({
		    		module : "GoodReceipt",
					command : "GR44_HEAD_2",
					bindType : "grid",
					sendType : "list",
					bindId : "gridHeadList",
			    	param : searchParam
				});
				
// 				gridList.gridList({
// 			    	id : "gridHeadList",
// 			    	param : searchParam
// 			    });
							
				commonUtil.msgBox("SYSTEM_SAVEOK");
				
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	
	
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}
	
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Callback"){
			callback(); //회수지시
			
		}else if(btnName == "Print"){
			print(); //출고반품명세서 인쇄
			
		}else if(btnName == "Save"){
			saveData(); //저장
			
		}else if (btnName == "Reload") {
			reloadLabel();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "GR44");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "GR44");
 		}
	}
	
	function reloadLabel() {
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}
	
	// 회수지시 후 저장버튼 show
	function callback(){
		
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("VALID_M0006");
				return;
			}
	
			var item = gridList.getSelectData("gridItemList", true);
			
			var svbelnstr = " AND IFWMS113.SVBELN IN (";
			
			for(var i =0;i < head.length ; i++){
				svbelnstr += "'" + head[i].get("SVBELN") + "'";
				if(head.length != i+1) svbelnstr += ",";
			}
			
			svbelnstr += ")";
			
			searchParam.put("SVBELNSTR",svbelnstr);
			searchParam.put("GBN","callback");
			
			
			var param = inputList.setRangeParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			
			netUtil.send({
				url : "/GoodReceipt/json/callbackGR44.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
			
			//저장버튼 보이기
// 			$('#saveBtn').show();
			
		}
	}
		
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")&& gridList.validationCheck("gridItemList", "select")){
			var headlist = gridList.getSelectData("gridHeadList", true);
			var list = gridList.getSelectData("gridItemList", true);
			var head = headlist[0];
			
			if(headlist.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//아이템 템프 가져오기
	        var tempItem = gridList.getSelectTempData("gridHeadList");

			var docdat = head.get("DOCDAT");
			var yy = docdat.substr(0,4);
			var mm = docdat.substr(4,2);
		    var dd = docdat.substr(6,2);
		    var sysdate = new Date(); 
		 	var date = new Date(Number(yy), Number(mm)-1, Number(dd));
		    if(Math.abs((date-sysdate)/1000/60/60/24) > 10){
				alert("확정일자는 ±10일로 지정하셔야 합니다.") ;
				return;
			}
			
			//체크한 row중에 수정된 로우
			var item = gridList.getSelectData("gridItemList");
			
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				var headGridBox = gridList.getGridBox('gridHeadList');
				var headList = headGridBox.getDataAll();
				
				if(itemMap.LOCAKY == "" || itemMap.LOCAKY == " "){
					//로케이션은 필수 입력입니다.
					commonUtil.msgBox("VALID_M0404");
					return; 
				}
				
				//출고반품입고사유 체크 , 헤더에 있는 S/O번호 출력
		 		if(itemMap.RSNCOD == "" || itemMap.RSNCOD == " "){
		 			//commonUtil.msgBox("IN_M0110");
		 			commonUtil.msgBox("IN_M0110",gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "SVBELN"));
					return;
		 		}
			}
			
			
			//템프그리드 벨리데이션 체크  
			var keys = Object.keys(tempItem.map);

			for(var i=0; i<keys.length; i++){
				var templist = tempItem.get(keys[i]);

				for(var j=0; j<templist.length; j++){
					var row = templist[j];
					
					var headGridBox = gridList.getGridBox('gridHeadList');
					var headList = headGridBox.getDataAll();
					
					if(itemMap.LOCAKY == "" || itemMap.LOCAKY == " "){
						//로케이션은 필수 입력입니다.
						commonUtil.msgBox("VALID_M0404");
						return; 
					}
					
					//출고반품입고사유 체크 , 헤더에 있는 S/O번호 출력
			 		if(itemMap.RSNCOD == "" || itemMap.RSNCOD == " "){
			 			//commonUtil.msgBox("IN_M0110");
			 			commonUtil.msgBox("IN_M0110",gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "SVBELN"));
						return;
			 		}
				}
			}
			
			var param = new DataMap();
			param.put("headlist",headlist);
			param.put("list",list);
			param.put("tempItem",tempItem);
			param.put("itemquery","GR44_ITEM");
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }		
			
			netUtil.send({
				url : "/GoodReceipt/json/saveGR44.data",
				param : param,
				successFunction : "successSaveCallBack2"
			});
			
			
		}
	}

	
	function print(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var param = new DataMap();
			param.put("list",head);
			
			
			var json = netUtil.sendData({
				url : "/GoodReceipt/json/printGR42.data",
				param : param,
			});
			

			var where = " AND IF.SVBELN IN (";
			
			for(var i =0;i < head.length ; i++){
				where += "'" + head[i].get("KEY") + "'";
				if(i+1 < head.length){
					where += ",";
				}
			}
			
			where += ")";
			
			if ( json && json.data ){
				var ownrky = $('#OWNRKY').val();
				var url,width,height;
				if(ownrky == '2100' || ownrky == '2500'){
					url = "/ezgen/return_shpdri_list.ezg";
					width = 840;
					heigth = 625;
				}else {
				url = "/ezgen/return_shpdri_list_dr.ezg";
				width = 600;
				height = 860;
			}
			
				var langKy = "KO";
				var map = new DataMap();
					map.put("i_option",$('#OPTION').val());
				WriteEZgenElement(url , where , "" , langKy, map , width , height );
			}
		}
	}
	
	
	var num = -1;
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        //요청사업장
        if(searchCode == "SHCMCDV" && $inputObj.name == "IFPGRC04"){
        	param.put("CMCDKY","PTNG05"); 
        //납품처코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "IFWMS113.DPTNKY"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        //매출처코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "IFWMS113.PTNROD"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY","<%=ownrky %>");
        //제품용도
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "IFWMS113.SKUG05"){
            param.put("CMCDKY","SKUG05");
        //로케이션	
        }else if(searchCode == "SHLOCMA"){

			param.put("WAREKY",$("#WAREKY").val());
		}
    	return param;
    }
	
	var colchangeArray = ["QTYRCV" , "BOXQTY" , "REMQTY"];
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			if(colchangeArray.indexOf(colName) != -1){
				var qtyrcv = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var grswgt = 0;
				var ordqty = Number(gridList.getColData(gridId, rowNum, "ORDQTY"));
				var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
				var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
				var pltqtycal = Number(gridList.getColData(gridId, rowNum, "PLTQTYCAL"));
				var grswgtcnt = Number(gridList.getColData(gridId, rowNum, "GRSWGTCNT"));
				
				var remqtyChk = 0;
								
				if( colName == "QTYRCV" ) {
				    
					qtyrcv = colValue;
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
					remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
					boxqty = floatingFloor((Number)(qtyrcv)/(Number)(bxiqty), 1);
					remqty = (Number)(qtyrcv)%(Number)(bxiqty);
					pltqty = floatingFloor((Number)(qtyrcv)/(Number)(pltqtycal), 2);
					grswgt = qtyrcv * grswgtcnt;
					
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty  );
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty  );
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty  );
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt  );
				  	
				}
				if( colName == "BOXQTY" ){ 
					boxqty = colValue;
					remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
					qtyrcv = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty);
					pltqty = floatingFloor((Number)(qtyrcv)/(Number)(pltqtycal), 2);
					grswgt = qtyrcv * grswgtcnt;
									
					gridList.setColValue(gridId, rowNum, "QTYRCV", qtyrcv);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
					
				}
				if( colName == "REMQTY" ){
					qtyrcv = Number(gridList.getColData(gridId, rowNum, "QTYRCV"));
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
					remqty = colValue;	
					 	
					remqtyChk = (Number)(remqty)%(Number)(bxiqty);
					boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
					qtyrcv = boxqty * bxiqty + remqtyChk;
					pltqty = floatingFloor((Number)(qtyrcv)/(Number)(pltqtycal), 2);
					grswgt = qtyrcv * grswgtcnt;
					
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "QTYRCV", qtyrcv);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				}
				
				if( qtyrcv > ordqty ) {
					commonUtil.msgBox("IN_M0092");
			    	
			    	gridList.setColValue(gridId, rowNum, "QTYRCV", 0 );
					gridList.setColValue(gridId, rowNum, "BOXQTY", 0 );
					gridList.setColValue(gridId, rowNum, "REMQTY", 0 );
					gridList.setColValue(gridId, rowNum, "PLTQTY", 0 ); //팔레트수량
					gridList.setColValue(gridId, rowNum, "GRSWGT", 0 );
			    	return false ;
			    }
			}else if( colName == "LOTA11" ){
				var outdmt = gridList.getColData(gridId, rowNum, "OUTDMT");
				var lota11 = gridList.getColData(gridId, rowNum, "LOTA11");
				
				var lota13 = dateParser(lota13 , 'S', 0 , 0 , -Number(outdmt)) ;
				gridList.setColValue(gridId, rowNum, "LOTA13", lota13 );
				
			}else if(colName == "LOTA13"){
				var outdmt = gridList.getColData(gridId, rowNum, "OUTDMT");
				var lota13 = gridList.getColData(gridId, rowNum, "LOTA13");
				
				var lota11 = dateParser(lota13 , 'S', 0 , 0 , -Number(outdmt)) ;
				gridList.setColValue(gridId, rowNum, "LOTA11", lota11 );
				
			}
				
		}
	}
	
	
	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListRowColorChange(gridId, rowNum){
		if(gridId == "gridHeadList"){
			//세트 시 수량 색깔 파란색으로 CHANGE
			if(Number(gridList.getColData("gridHeadList", rowNum, "SKUG05")) == '2'){
				return configData.GRID_COLOR_TEXT_BLUE_CLASS;
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
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Callback CALLBACK BTN_CALLBACK" />
					<input type="button" CB="Save SAVE BTN_SAVE" id="saveBtn" /> 
					<input type="button" CB="Print PRINT_OUT BTN_REPRINT" />
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
					<dl> <!-- 입고유형 -->
						<dt CL="STD_RCPTTY"></dt> 
						<dd>
							<select name="RCPTTY" class="input" Combo="GoodReceipt,COMBO_RCPTTY" validate="required(STD_RCPTTY)"></select>
						</dd>
					</dl>
					<dl>  <!-- S/O번호-->  
						<dt CL="STD_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고반품입고일자-->  
						<dt CL="IFT_OTRQDT2"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.OTRQDT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl> <!-- 요청사업장   -->
						<dt CL="STD_IFPGRC04"></dt> 
						<dd> 
							<input type="text" class="input" name="IFPGRC04" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl> <!-- 요청사업장명   -->
						<dt CL="STD_IFPGRC04N"></dt> 
						<dd> 
							<input type="text" class="input" name="IFPGRC04N" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DPTNKY" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처명-->  
						<dt CL="IFT_PTNRTONM"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DPTNKYNM" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--매출처코드-->  
						<dt CL="IFT_PTNROD"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.PTNROD" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--매출처명-->  
						<dt CL="STD_PTNRODNM"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.PTNRODNM" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--고객명-->  
						<dt CL="STD_CUNAME"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.CUNAME" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--반품지 주소-->  
						<dt CL="STD_CUADDR"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DNAME4" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--규격-->  
						<dt CL="STD_DESC02"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DESC02" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품용도-->  
						<dt CL="STD_SKUG05"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.SKUG05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl> <!-- 인쇄여부 -->
						<dt CL="STD_PRINTCHK"></dt> 
						<dd>
							<select name="PRINTCHK" id="PRINTCHK" class="input" commonCombo="POCLOS">
							</select>
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"><span CL="STD_PRINTOPT1" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;">   </span>
					<select name="OPTION" id="OPTION"  class="input" Combo="SajoCommon,CMCDV_COMBO" ComboCodeView="true"></select></li>
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
								<tbody id="gridHeadList"> <!-- GR44 회송반품입고 Head --> 
									<tr CGRow="true">
										<td GH="40" GCol="rowCheck"></td>  
										<td GH="100 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td> <!--입고문서번호-->
										<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
										<td GH="80 STD_RCPTTY" GCol="text,RCPTTY" GF="S 10">입고유형</td> <!--입고유형-->
										<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td> <!--문서상태-->
										<td GH="100 STD_CONDAT" GCol="input,DOCDAT" GF="C">확정일자</td> <!--확정일자-->
										<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td> <!--문서유형-->
										<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td> <!--출고일자-->
										<td GH="80 IFT_PTNRTO" GCol="text,DPTNKY" GF="S 10">납품처코드</td> <!--납품처코드-->
										<td GH="100 IFT_PTNRTONM" GCol="text,DPTNKYNM" GF="S 100">납품처명</td> <!--납품처명-->
										<td GH="100 IFT_PTNROD" GCol="text,PTNROD" GF="S 10">매출처코드</td> <!--매출처코드-->
										<td GH="100 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 100">매출처명</td> <!--매출처명-->
										<td GH="100 STD_SVBELN" GCol="text,SVBELN" GF="S 30">S/O 번호</td> <!--S/O 번호-->
										<td GH="80 IFT_CTNAME" GCol="text,UNAME1" GF="S 20">거래처 담당자명</td> <!--거래처 담당자명-->
										<td GH="80 IFT_WARESR" GCol="text,DNAME1" GF="S 20">요구사업장</td> <!--요구사업장-->
										<td GH="80 IFT_CTTEL1" GCol="text,UNAME2" GF="S 20">거래처 담당자 전화번호</td> <!--거래처 담당자 전화번호-->
										<td GH="80 IFT_SALENM" GCol="text,UNAME3" GF="S 20">영업사원명</td> <!--영업사원명-->
										<td GH="80 IFT_SALTEL" GCol="text,UNAME4" GF="S 20">영업사원 전화번호</td> <!--영업사원 전화번호-->
										<td GH="80 IFT_CUADDR" GCol="text,DNAME4" GF="S 20">배송지 주소</td> <!--배송지 주소-->
										<td GH="100 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td> <!--비고-->
										<td GH="50 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td> <!--거점명-->
										<td GH="50 STD_RCPTTYNM" GCol="text,RCPTTYNM" GF="S 100">입고유형명</td> <!--입고유형명-->
										<td GH="50 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td> <!--문서유형명-->
										<td GH="50 STD_RCUNAME2" GCol="text,CUNAME" GF="S 100">요구사업장명</td> <!--요구사업장명-->
										<td GH="50 STD_PRTYN" GCol="text,PRINTCHK" GF="S 100">인쇄여부</td> <!--인쇄여부 -->
			    						<td GH="80 STD_DPHONE" GCol="text,DPHONE" GF="S 17">기사연락처</td>	<!--기사연락처-->
			    						<td GH="80 STD_ERDAT" GCol="text,ERDAT" GF="D 17">지시일자</td>	<!--지시일자-->
			    						<td GH="80 STD_RECALLDAT" GCol="text,RECALLDAT" GF="D 17">회수일자</td>	<!--회수일자-->
			    						<td GH="50 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
			    						<td GH="80 STD_SKUG05"  GCol="select,SKUG05"> <!--제품용도-->
											<select class="input" CommonCombo="SKUG05">
											</select>
										</td>
										<td GH="50 STD_WMSCREDAT" GCol="text,WMSCREDAT" GF="S 100">WMS생성일자</td> <!--WMS생성일자-->
										<td GH="50 STD_WMSCRETIM" GCol="text,WMSCRETIM" GF="S 100">WMS생성시간</td> <!--WMS생성시간-->
										<td GH="50 STD_RECNUM" GCol="text,CARNUM" GF="S 100">재배차 차량번호</td> <!--재배차 차량번호-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type="button" GBtn="find"></button>      
						<button type="button" GBtn="sortReset"></button> 
						<button type="button" GBtn="layout"></button>    
						<button type="button" GBtn="total"></button>     
						<button type="button" GBtn="excel"></button>  
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
								<tbody id="gridItemList"> <!-- GR44 회송반품입고 Item -->
									<tr CGRow="true">
										<td GH="40" GCol="rowCheck" ></td>  
										<td GH="100 STD_RECVIT"  GCol="text,RECVIT" GF="S 6">입고문서아이템</td> <!--입고문서아이템-->
										<td GH="80 STD_SKUKEY"   GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="100 STD_LOCAKY" GCol="input,LOCAKY,SHLOCMA" id="LOCAKY" validate="required">로케이션</td>	<!--로케이션-->
										<td GH="80 STD_TRNUID"  GCol="input,TRNUID" GF="S 30">팔렛트ID</td> <!--팔렛트ID-->
										<td GH="80 STD_STATIT"  GCol="text,STATIT" GF="S 20">상태</td>
										<td GH="140 STD_RECRSNCD"  GCol="select,RSNCOD"> <!--출고반품입고사유-->
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option></option>
											</select>
										</td>
										<td GH="40 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td> <!--단위-->
										
										<td GH="80 STD_LOTA05"  GCol="select,LOTA05"> <!--포장구분-->
											<select class="input" CommonCombo="LOTA05">
											</select>
										</td>
																				
										<td GH="80 STD_LOTA06"  GCol="select,LOTA06"> <!--재고유형-->
											<select class="input" CommonCombo="LOTA06"></select>
										</td>
										
										<td GH="80 STD_LOTA11"  GCol="text,LOTA11" GF="D 14">제조일자</td> <!--제조일자-->
										<td GH="100 STD_LOTA13" GCol="input,LOTA13" GF="C 14" validate="required">유통기한</td>	<!--유통기한-->
										<td GH="80 STD_REFDKY"  GCol="text,REFDKY" GF="S 10">참조문서번호</td> <!--참조문서번호 -->
										<td GH="80 STD_REFDIT"  GCol="text,REFDIT" GF="S 6">참조문서Item번호</td> <!--참조문서Item번호 -->
										<td GH="80 STD_REFCAT"  GCol="text,REFCAT" GF="S 4">입출고 구분자</td> <!--입출고 구분자 -->
										<td GH="80 STD_REFDAT"  GCol="text,REFDAT" GF="D 8">참조문서일자</td> <!--참조문서일자 -->
										<td GH="80 STD_DESC01"  GCol="text,DESC01" GF="S 120">제품명</td> <!--제품명-->
										<td GH="80 STD_DESC02"  GCol="text,DESC02" GF="S 120">규격</td> <!--규격-->
										<td GH="80 STD_ASKU01"  GCol="text,ASKU01" GF="S 20">포장단위</td> <!--포장단위-->
										<td GH="80 STD_ASKU02"  GCol="text,ASKU02" GF="S 20">세트여부</td>  <!--세트여부-->
										<td GH="80 STD_ASKU03"  GCol="text,ASKU03" GF="S 20">피킹그룹</td>  <!--피킹그룹-->
										<td GH="80 STD_ASKU04"  GCol="text,ASKU04" GF="S 20">제품구분</td>  <!--제품구분-->
										<td GH="50 STD_ASKU05"  GCol="text,ASKU05" GF="S 20">상온구분</td>  <!--상온구분-->
										<td GH="50 STD_SKUG01"  GCol="text,SKUG01" GF="S 20">대분류</td>  <!--대분류-->
										<td GH="50 STD_SKUG02"  GCol="text,SKUG02" GF="S 20">중분류</td>  <!--중분류-->
										<td GH="50 STD_SKUG03"  GCol="text,SKUG03" GF="S 20">소분류</td>  <!--소분류-->
										<td GH="50 STD_SKUG04"  GCol="text,SKUG04" GF="S 20">세분류</td>  <!--세분류-->
										<td GH="50 STD_SKUG05"  GCol="text,SKUG05" GF="S 50">제품용도</td>  <!--제품용도-->
										<td GH="50 STD_GRSWGT"  GCol="text,GRSWGT" GF="N 17">포장중량</td>  <!--포장중량-->
										<td GH="50 STD_NETWGT"  GCol="text,NETWGT" GF="N 17">순중량</td>  <!--순중량-->
										<td GH="50 STD_WGTUNT"  GCol="text,WGTUNT" GF="S 3">중량단위</td>  <!--중량단위-->
										<td GH="50 STD_LENGTH"  GCol="text,LENGTH" GF="N 17">포장가로</td>  <!--포장가로-->
										<td GH="50 STD_WIDTHW"  GCol="text,WIDTHW" GF="N 17">포장세로</td>  <!--포장세로-->
										<td GH="50 STD_HEIGHT"  GCol="text,HEIGHT" GF="N 17">포장높이</td>  <!--포장높이-->
										<td GH="50 STD_CUBICM"  GCol="text,CUBICM" GF="N 17">CBM</td>  <!--CBM-->
										<td GH="80 STD_SEBELN"  GCol="text,SEBELN" GF="S 20">구매오더 No</td>  <!--구매오더 No-->
										<td GH="50 STD_SEBELP"  GCol="text,SEBELP" GF="S 6">구매오더 Item</td>  <!--구매오더 Item-->
										<td GH="50 STD_QTYRCV" GCol="input,QTYRCV" GF="N 17,0">입고수량</td> <!--입고수량-->
										<td GH="50 STD_ORDQTY"  GCol="text,ORDQTY" GF="N 17,0">지시수량</td> <!--지시수량-->
										<td GH="50 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
										<td GH="50 STD_BXIQTY"  GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="50 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
										<td GH="50 STD_PLTQTY"  GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td> <!--팔레트수량-->
										<td GH="50 STD_PLIQTY"  GCol="text,PLTQTYCAL" GF="S 17" style="text-align:right;" >팔렛당수량</td> <!--팔렛당수량-->
 										<td GH="80 STD_OUTDMT"  GCol="text,OUTDMT" GF="N 20,0">유통기한(일수)</td>  <!--유통기한(일수)-->
			    						<td GH="80 STD_LOCASR_L7141" GCol="text,PACK" GF="S 20"></td>	<!-- 피킹로케이션 -->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type="button" GBtn="find"></button>      
						<button type="button" GBtn="sortReset"></button> 
						<button type="button" GBtn="layout"></button>    
						<button type="button" GBtn="total"></button>     
						<button type="button" GBtn="excel"></button>  
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