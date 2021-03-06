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
var headRow = -1,searchparam , choosetype;
var conlist = [{key:"#tab1ty"}, {key:"#tab1ty2"}, {key:"#tab1ty3"} ,{key:"#tab1ty4"}];

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "SajoInbound",
			command : "PT01_HEAD",
			menuId : "PT01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "SajoInbound",
			command : "PT01_ITEM",
			menuId : "PT01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList2",
	    	module : "SajoInbound",
			command : "SJ01_ITEM",
			menuId : "PT01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList3",
	    	module : "SajoInbound",
			command : "SJ01_ITEM",
			menuId : "PT01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList4",
	    	module : "SajoInbound",
			command : "SJ01_ITEM",
			menuId : "PT01"
	    });
		
		moveTab(0);
		hiddenandshow("#tab1ty");
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		
		var rangeDataMap = new DataMap();
			rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
			rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "RCVLOC");
		
		var rangeDataMap2 = new DataMap();
			rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
			rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "DOCLOC");

		rangeArr.push(rangeDataMap);		
		rangeArr.push(rangeDataMap2);		
		setSingleRangeData('LOCAKY', rangeArr);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	//버튼 동작
	function commonBtnClick(btnName){
		var ownrky = $("#OWNRKY").val();
		
		if(btnName == "Search"){
			searchList();
			//텝 초기화
			$('#atab1').trigger("click");
			//버튼 초기화
			hiddenandshow("#tab1ty");
		}else if (btnName == "CHOOSE"){
			
			var list = gridList.getSelectData("gridItemList", true);
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			choosetype = $("input[name='CHOOSETYPE']:checked").val();
			
			searchparam.put("list",list);
			searchparam.put("choosetype",choosetype);
				
			netUtil.send({
				url : "/SajoInbound/json/displayPT01Choose.data",
				param : searchparam,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridItemList2" //그리드ID
			});
			
			$('#atab2').trigger("click");
// 			hiddenandshow("#tab1ty2");
		}else if (btnName == "PREADDROW"){
					
			var row = gridList.getSelectData("gridItemList2");
			
			if(row.length > 0 ){
				//구버전 에서 무조건 첫번쨰 데이터만 복사되서 그대로 구현 
				var tmpCopyData = row[0];
				tmpCopyData.map.ISNEW = 'Y';
				tmpCopyData.map.ISNEW = 'Y';
				
				gridList.setAddRow("gridItemList2", tmpCopyData);
				//gridList.addFocusRow("gridItemList2", tmpCopyData);
				//gridList.getGridBox("gridItemList2").copyRow();
			}else{
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");	
			}
		}else if (btnName == "PREDELETEROW"){ 
			var row = gridList.getSelectData("gridItemList2");
			for(var i=0;i<row.length;i++){
				//추가한 ROW인지 체크 
				if(row[i].map.ISNEW != 'N' ){
					gridList.deleteRow("gridItemList2",i,false);	
				}else{
					commonUtil.msgBox("TASK_M0006");	
				}
			}
		}else if(btnName == "CHCANCEL"){
			gridList.resetGrid("gridItemList2");
			$('#atab1').trigger("click");
			hiddenandshow("#tab1ty");
		}else if (btnName == "AUTPAL"){ //자동 팔렛타이징
			autoPal();
		}else if (btnName == "PHCANCEL"){ //팔렛타이징 취소 
			gridList.resetGrid("gridItemList3");
			$('#atab2').trigger("click");
			hiddenandshow("#tab1ty2");
		}else if(btnName =="SAVECHK"){
			saveTaskData();
		}else if(btnName =="CONFIRM"){
			saveTaskConfirm();
		}else if(btnName =="PRINT"){
			print();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "PT01");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "PT01");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridItemList2");
			gridList.resetGrid("gridItemList3");
			gridList.resetGrid("gridItemList4");
			
			searchparam = inputList.setRangeDataParam("searchArea");
		
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : searchparam
		    });
		}
	}

	

	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount > 0){
			gridList.getSelectData("gridItemList2");
			gridList.gridList({
		    	id : "gridItemList",
		    	param : searchparam
		    });
		}else if(gridId == "gridItemList4" && dataCount > 0){ //재조회
			var itemList = gridList.getGridData("gridItemList4");
			var taskky = itemList[0].map.TASKKY;
			var param = new DataMap();
			param.put("TASKKY", taskky);
			
			netUtil.send({
		    	module : "SajoInbound",
				command : "PT01_SAVE",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridHeadList" //그리드ID
			});
			
			//하나라도 완료가 되면 전체완료로 판단 
			if(itemList[0].map.STATIT != 'NEW' ){ 
				hiddenandshow("#end");
				$('#print').show();
				if(commonUtil.msgConfirm("SYSTEM_M0093")){ //출력물 출력여부 확인
// 					$('#print').trigger("click");
					print();
		        }
			}else{
				hiddenandshow("#tab1ty4");
			}
		}else if(gridId == "gridItemList4" && dataCount < 1){ //재조회
			$('#atab3').trigger("click");
			hiddenandshow("#tab1ty3");
		}else if(gridId == "gridItemList2" && dataCount > 0){
			hiddenandshow("#tab1ty2");
		}else if(gridId == "gridItemList3" && dataCount > 0){
			hiddenandshow("#tab1ty3");
		}
	}
	
	function print(){
		var head = gridList.getGridData("gridHeadList", true);
		var count = 0;
		//체크가 없을 경우 
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

		var where = "";
		//반복문을 돌리며 특정 검색조건을 생성한다.
		for(var i =0;i < head.length ; i++){
			if(where == ""){
				where = where+" AND H.TASKKY IN (";
			}else{
				where = where+",";
			}
			
			where += "'" + head[i].get("TASKKY") + "'";
			count++;
		}
		where += ")";
					
		//이지젠 호출부(신버전)
		var width = 840;
		var heigth = 600;
		var map = new DataMap();
		WriteEZgenElement("/ezgen/putaway_list.ezg" , where , " " , "KO", map , width , heigth );
	}
    

	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			return;
		}
	}

	
	//그리드 컬럼 값 변경시 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		if(gridId == "gridItemList"){
			if(colName == "SKUKEY"){ //제품코드 변경시
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
				
			}else if(colName == "QTADJU" || colName == "BOXQTY" || colName == "PLTQTY"){ //수량변경시 박스 팔렛트 수량 변경
				var qtadju = 0;
				var boxqty = 0;
				var pltqty = 0;
				var bxiqty = gridList.getColData(gridId, rowNum, "BXIQTY");
				var pliqty = gridList.getColData(gridId, rowNum, "PLIQTY");

	  			gridList.setColValue(gridId, rowNum,"QTREMA",0);
				if( colName == "QTADJU" ) {
				  	qtadju = colValue;
				  	boxqty = floatingFloor((Number)(qtadju)/(Number)(bxiqty), 1);
				  	pltqty = floatingFloor((Number)(qtadju)/(Number)(pliqty), 2);
				  	remqty = (Number)(qtadju)%(Number)(bxiqty);
		  			gridList.setColValue(gridId, rowNum,"QTADJU",qtadju);
					gridList.setColValue(gridId, rowNum,"BOXQTY",boxqty);
					gridList.setColValue(gridId, rowNum,"PLTQTY",pltqty);
					gridList.setColValue(gridId, rowNum,"REMQTY",remqty);
				 }if( colName == "BOXQTY" ){ 
				  	boxqty = colValue;
				  	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
				  	qtadju = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				  	pltqty = floatingFloor((Number)(qtadju)/(Number)(pliqty), 2);
				  	
				    gridList.setColValue(gridId, rowNum, "QTADJU", qtadju);
				    gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
				} if( colName == "PLTQTY" ){
					pltqty = colValue;
				  	bxiqty = gridList.getColData(gridId, rowNum, "BXIQTY");
				  				  	
				  	qtadju = (Number)(pltqty)*(Number)(pliqty);
				  	boxqty = floatingFloor((Number)(qtadju)/(Number)(bxiqty), 1);

					gridList.setColValue(gridId, rowNum, "QTADJU", qtadju);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);

				  }
			}
		}
	} // end gridListEventColValueChange
    
    
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "400");
			param.put("DOCUTY", "401");
		}
		
		return param;
	}
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if(searchCode == "SHSKUSETI2" ){
            param.put("WAREKY",$("#WAREKY").val());
            param.put("OWNRKY",$("#OWNRKY").val());
        }else  if(searchCode == "SHLOCMA" ){
            param.put("WAREKY",$("#WAREKY").val());
        }else if(searchCode == "SHLOTA03CM"){
        	param.put("OWNRKY",$("#OWNRKY").val());
        	param.put("PTNRTY","0001");
        }
        
    	return param;
    }
	
	
    //텝이동시 기타 초기화 
    function moveTab(idx){
		switch (idx) {
		case 0:
			$('#tab1ty').show();
        	$('#tab1ty2').hide();
        	$('#tab1ty3').hide();
        	$('#tab1ty4').hide();
			break;
        case 1:
        	$('#tab1ty').hide();
        	$('#tab1ty2').show();
        	$('#tab1ty3').hide();
        	$('#tab1ty4').hide();
			break;
        case 2:
        	$('#tab1ty').hide();
        	$('#tab1ty2').hide();
        	$('#tab1ty3').show();
        	$('#tab1ty4').hide();
			break;
        case 3:
        	$('#tab1ty').hide();
        	$('#tab1ty2').hide();
        	$('#tab1ty3').hide();
        	$('#tab1ty4').show();
			break;
		default:
			break;
		}
	}
    
    
    function hiddenandshow(tabId){
    	var list = conlist.filter(function (e) {
		    return e["key"] != tabId;
		});
    	
    	for(var i = 0 ; i < list.length ; i++){
    		$(list[i]["key"]).find("li").find("input:button").each(function () {
    			$(this).hide();
    		});
    	}
    	
    	$(tabId).find("li").find("input:button").each(function (){
    		$(this).show();
    	});
    	
    	
    }

    
    function autoPal(){
		var list = gridList.getGridData("gridItemList2");
		var chkMap = new DataMap();
		var chkQttaor = 0;
    	//조건 체크 
    	for(var i=0; i< list.length; i++){
    		var key = ""
    		if(choosetype == "1"){
    			key = list[i].map.STOKKY;
    		}else if(choosetype == "2"){
    			key = list[i].map.SSTOKKYS;
    		}
    		var inputQty = list[i].map.QTTAOR;
    		chkQttaor = 0;
    		
    		
    		//수량 0 체크
    		if(Number(inputQty) < 1){
    			commonUtil.msgBox("COMMON_M0009", ["작업수량"]);
    			return;	
    		} 
    		
    		//STOKKY가 존재하는지 체크한다.
    		if(chkMap.containsKey(key)){
    			chkQttaor = Number(chkMap.get(key))+Number(inputQty);
    		}else{
    			chkQttaor = Number(inputQty);
    		}
    		
    		//수량이 넘었는지 체크
    		if(Number(chkQttaor) > Number(list[i].map.AVAILABLEQTY)){
				commonUtil.msgBox("VALID_M0923");
    			return;
    		}else{
    			chkMap.put(key, chkQttaor);
    		}
    		
    		list[i].map.GRowNum = i;
    	}
    	
		var param = new DataMap(); 
		if(list.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		param.put("list",list);
		param.put("choosetype",choosetype);

		netUtil.send({
			url : "/SajoInbound/json/autoPal.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList3" //그리드ID
		});
		
		$('#atab3').trigger("click");
		moveTab(2);
		hiddenandshow("#tab1ty3");
    }


	//팔렛타이징 저장 
	function saveTaskData(){
		var param = inputList.setRangeDataParam("searchArea");
		var list = gridList.getGridData("gridItemList3");
		var head = gridList.getGridData("gridHeadList");
		param.put("list",list);
		param.put("head",head);
		

		var list = gridList.getGridData("gridItemList3");
		var chkMap = new DataMap();
		var chkQttaor = 0;
    	//조건 체크 
    	for(var i=0; i< list.length; i++){
    		var key = ""
       		if(choosetype == "1"){
       			key = list[i].map.STOKKY;
       		}else if(choosetype == "2"){
       			key = list[i].map.SSTOKKYS;
       		}
       		var inputQty = list[i].map.QTTAOR;
       		chkQttaor = 0;
    		
    		//수량 0 체크
    		if(Number(inputQty) < 1){
    			commonUtil.msgBox("COMMON_M0009", ["작업수량"]);
    			return;	
    		} 
    		
    		
    		//STOKKY가 존재하는지 체크한다.
    		if(chkMap.containsKey(key)){
    			chkQttaor = Number(chkMap.get(key))+Number(inputQty);
    		}else{
    			chkQttaor = Number(inputQty);
    		}
    		
    		//수량이 넘었는지 체크
    		if(Number(chkQttaor) > Number(list[i].map.AVAILABLEQTY)){
				commonUtil.msgBox("VALID_M0923");
    			return;
    		}else{
    			chkMap.put(key, chkQttaor);
    		}
    		
//     		//STOKKY가 존재하는지 체크한다.
//     		if(chkMap.containsKey(lotnum)){
//     			chkQttaor = Number(chkMap.get(lotnum))+Number(inputQty);
//     		}else{
//     			chkQttaor = Number(inputQty);
//     		}
    		
//     		//수량이 넘었는지 체크
//     		if(Number(chkQttaor) > Number(list[i].map.AVAILABLEQTY)){
// 				commonUtil.msgBox("VALID_M0923");
//     			return;
//     		}else{
//     			chkMap.put(lotnum, chkQttaor);
//     		}
    	}
    	
    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
			return;
        }
		

		netUtil.send({
			url : "/SajoInbound/json/saveTaskData.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList4" //그리드ID
		});
		
		$('#atab4').trigger("click");
	}


	//팔렛타이징 완료 
	function saveTaskConfirm(){
		var param = inputList.setRangeDataParam("searchArea");
		var list = gridList.getSelectData("gridItemList4", true);
		var head = gridList.getGridData("gridHeadList");
		param.put("list",list);
		param.put("head",head);
		
		if(list.length < 1){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

		netUtil.send({
			url : "/SajoInbound/json/saveTaskConfirm.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList4" //그리드ID
		});
		
		$('#atab4').trigger("click");
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
		if(searchCode == "SHLOCMA"){
            param.put("WAREKY",$("#WAREKY").val());
			//배열선언
    		var rangeArr = new Array();
    		//배열내 들어갈 데이터 맵 선언
    		var rangeDataMap = new DataMap();
    		// 필수값 입력
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SYS");
    		//배열에 맵 탑제 
    		rangeArr.push(rangeDataMap);
    	 	
    		rangeDataMap = new DataMap();
    		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SHP");
    		rangeArr.push(rangeDataMap); 

            param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
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
					<input type="button" CB="Search SEARCH BTN_CREATE" />
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
							<select name="WAREKY" id="WAREKY" class="input" validate="required(STD_WAREKY)"></select>
						</dd>
					</dl>
					
					<dl>  <!--ASN 문서번호-->  
						<dt CL="STD_ASNDKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.ASNDKY" UIInput="SR,SHASN"/> 
						</dd> 
					</dl> 
					<dl>  <!--입고문서번호-->  
						<dt CL="STD_RECVKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.RECVKY" UIInput="SR,SHRECDH"/> 
						</dd> 
					</dl> 
					<dl>  <!--구매오더 No-->  
						<dt CL="STD_SEBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SEBELN" id="SEBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="LOCAKY" UIInput="SR,SHLOCMA"/> 
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
					
					<dl>  <!-- 유통기한-->  
						<dt CL="STD_LOTA13"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA13" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>
					<dl>  <!-- 입고일자-->  
						<dt CL="STD_LOTA12"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA12" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl>
					<dl>  <!-- 벤더-->  
						<dt CL="STD_LOTA03"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA03" UIInput="SR,SHLOTA03CM"/> 
						</dd> 
					</dl>
					<dl>  <!-- 포장구분-->  
						<dt CL="STD_LOTA05"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05"/> 
						</dd> 
					</dl>
					<dl>  <!-- 재고유형-->  
						<dt CL="STD_LOTA06"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA06"/> 
						</dd> 
					</dl>

				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs top_layout" style="height: 170px;">
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
			    						<td GH="100 STD_TASKKY" GCol="text,TASKKY" GF="S 10">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="100 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 20">거점명</td>	<!--거점명-->
			    						<td GH="100 STD_TASOTYNM" GCol="text,TASOTYNM" GF="S 20">작업타입명</td>	<!--작업타입명-->
			    						<td GH="100 STD_WAREKY"  GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="100 STD_TASOTY"  GCol="text,TASOTY" GF="S 4">작업타입</td>	<!--작업타입-->
			    						<td GH="100 STD_DOCDAT"  GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="100 STD_DOCCAT"  GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="100 STD_WARETG"  GCol="text,WARETG" GF="S 4">도착거점</td>	<!--도착거점-->
			    						<td GH="100 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="100 STD_CREDAT"  GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="100 STD_CRETIM"  GCol="text,CRETIM" GF="T 8">생성시간</td>	<!--생성시간-->
			    						<td GH="100 STD_CREUSR"  GCol="text,CREUSR" GF="S 60">생성자</td>	<!--생성자-->
			    						<td GH="100 STD_CUSRNM"  GCol="text,CUSRNM" GF="S 60">생성자명</td>	<!--생성자명-->
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
			<div class="content_layout tabs bottom_layout" style="height: calc(100% - 190px);">
				<ul class="tab tab_style02">
					<li onclick="moveTab(0);"><a href="#tab2-1" id="atab1"><span>입고정보</span></a></li>
					<li onclick="moveTab(1);"><a href="#tab2-2" id="atab2"><span>작업 리스트</span></a></li>
					<li onclick="moveTab(2);"><a href="#tab2-3" id="atab3"><span>입고</span></a></li>
					<li onclick="moveTab(3);"><a href="#tab2-4" id="atab4"><span>확인</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
					<div id="tab1ty" name="tab1ty" >                                                                                                                                               
						<li style="TOP: 8PX;VERTICAL-ALIGN: middle; margin-left: 20px"> <!-- 세트 -->                                                                                             
							<input type="radio"  name="CHOOSETYPE" value="1" checked="checked"/><span CL="STD_CHREC"></span>
						    <input type="radio"  name="CHOOSETYPE" value="2"/><span CL="STD_CHSUM"></span>                                                                                                   
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle; margin-left: 10px"> <!-- 세트 -->
							<input type="button" id="TAB1_CHOOSE" CB="CHOOSE SAVE BTN_CHOOSE" />
						</li>                                        
					</div>
					<div id="tab1ty2" name="tab1ty2" >                                                                                                                                               
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle; margin-left: 20px"> <!-- 취소 -->                                                                                             
							<input type="button" CB="AUTPAL TEMP_SAVE BTN_AUTPAL" />
							<input type="button" CB="PREADDROW ADD BTN_ADDROW"  />
							<input type="button" CB="PREDELETEROW DELETE BTN_DELETEROW" />
							<input type="button" id="TAB2_CANCEL" CB="CHCANCEL CANCEL BTN_CANCEL" />                                                                                                  
						</li>                                        
					</div>
					<div id="tab1ty3" name="tab1ty3" >                                                                                                                                               
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle; margin-left: 20px"> <!-- 취소 -->                                                                                             
							<input type="button" CB="SAVECHK TEMP_SAVE BTN_PUTAWAY" />
							<input type="button" CB="PHCANCEL CANCEL BTN_CANCEL" />                                                                                                      
						</li>                                        
					</div>
					<div id="tab1ty4" name="tab1ty4" >                                                                                                                                               
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle; margin-left: 20px"> <!-- 취소 -->                                                                                             
							<input type="button" CB="CONFIRM SAVE BTN_PCONFIRM" />
							<input type="button" CB="PRINT PRINT_OUT BTN_PAPRINT" id="print" />                                                                                                   
						</li>                                        
					</div>
					                                                                                                           
				</ul>
				<div class="table_box section" id="tab2-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>
										<td GH="40" GCol="rowCheck"></td>   
			    						<td GH="100 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
			    						<td GH="100 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="104 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="100 STD_TRNUSR" GCol="text,TRNUSR" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="100 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="100 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="100 STD_QTSAVLB" GCol="text,AVAILABLEQTY" GF="N 17,0">가용수량</td>	<!--가용수량-->
			    						<td GH="100 STD_QTTAOR" GCol="input,QTTAOR" GF="N 17,0">작업수량</td>	<!--작업수량-->
			    						<td GH="100 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="100 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="130 STD_LOTA05" GCol="select,LOTA05">
								        	<select class="input" CommonCombo="LOTA05"></select>
								        </td><!--포장구분-->
										<td GH="130 STD_LOTA06" GCol="select,LOTA06">
								        	<select class="input" CommonCombo="LOTA06"></select>
								        </td>	<!--재고유형-->
								        <td GH="100 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
			    						<td GH="100 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="100 STD_LOTA03NM" GCol="text,LOTA03NM" GF="S 100">벤더명</td>	<!--벤더명-->
			    						<td GH="100 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="100 STD_RECVIT" GCol="text,RECVIT" GF="N 6,0">입고문서아이템</td>	<!--입고문서아이템-->
			    						<td GH="104 STD_BOXQTY" GCol="text,BOXQTY" GF="N 20,1">박스수량</td>	<!--박스수량-->
			    						<td GH="104 STD_PLTQTY" GCol="text,PLTQTY" GF="N 20,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="104 STD_PLBQTY" GCol="text,PLBQTY" GF="S 17" style="text-align:right;" >팔렛당박스수량</td>	<!--팔렛당박스수량-->
			    						<td GH="100 STD_LOCATG" GCol="text,LOCATG" GF="S 20">To 로케이션</td>	<!--To 로케이션-->
			    						<td GH="100 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td>	<!--재고키-->
			    						<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="100 STD_PACKID" GCol="text,PAIDSR" GF="S 30">SET제품코드</td>	<!--SET제품코드-->
			    						<td GH="100 STD_TRNUTG" GCol="text,TRNUTG" GF="S 20">To 팔렛트ID</td>	<!--To 팔렛트ID-->
			    						<td GH="100 STD_ASNDKY" GCol="text,ASNDKY" GF="S 10">ASN 문서번호</td>	<!--ASN 문서번호-->
			    						<td GH="100 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="100 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="100 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="100 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="100 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="100 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="100 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="100 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="100 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="100 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="100 STD_SKUG05" GCol="text,SKUG05" GF="S 20">제품용도</td>	<!--제품용도-->
			    						<td GH="100 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11">포장중량</td>	<!--포장중량-->
			    						<td GH="100 STD_NETWGT" GCol="text,NETWGT" GF="S 11">순중량</td>	<!--순중량-->
			    						<td GH="100 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="100 STD_LENGTH" GCol="text,LENGTH" GF="S 11">포장가로</td>	<!--포장가로-->
			    						<td GH="100 STD_WIDTHW" GCol="text,WIDTHW" GF="S 11">포장세로</td>	<!--포장세로-->
			    						<td GH="100 STD_HEIGHT" GCol="text,HEIGHT" GF="S 11">포장높이</td>	<!--포장높이-->
			    						<td GH="100 STD_CUBICM" GCol="text,CUBICM" GF="S 11">CBM</td>	<!--CBM-->
			    						<td GH="100 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="100 STD_SEBELN" GCol="text,SEBELN" GF="S 30">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="100 STD_SEBELP" GCol="text,SEBELP" GF="S 5">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="100 STD_PASTKY" GCol="input,PASTKY" GF="S 20">적치전략키</td>	<!--적치전략키-->
			    						<td GH="100 STD_LOCASRL7141" GCol="text,LOCSKU" GF="S 20"></td>	<!---->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add" id="itemGridAdd"></button>
						<button type='button' GBtn="delete" id="itemGridDelete"></button>
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
				
				<div class="table_box section" id="tab2-2" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList2">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>
										<td GH="40" GCol="rowCheck"></td>   
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="100 STD_QTSAVLB" GCol="text,AVAILABLEQTY" GF="N 17,0">가용수량</td>	<!--가용수량-->
			    						<td GH="100 STD_QTTAOR" GCol="input,QTTAOR" GF="N 17,0">작업수량</td>	<!--작업수량-->
			    						<td GH="100 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td>	<!--재고키-->
			    						<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="100 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
			    						<td GH="100 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="100 STD_TRNUSR" GCol="text,TRNUSR" GF="S 20">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="100 STD_SUOMKY" GCol="text,SUOMKY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="100 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="100 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="100 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="100 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="100 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="100 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="100 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="100 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="100 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="100 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="100 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="100 STD_SKUG05" GCol="text,SKUG05" GF="S 20">제품용도</td>	<!--제품용도-->
			    						<td GH="100 STD_LOTA05" GCol="select,LOTA05">
			    							<select class="input" CommonCombo="LOTA05"></select>
			    						</td>	<!--포장구분-->
			    						<td GH="100 STD_LOTA06" GCol="select,LOTA06">
			    							<select class="input" CommonCombo="LOTA06"></select>
			    						</td>	<!--재고유형-->
			    						<td GH="100 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
			    						<td GH="100 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="100 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="100 STD_SEBELN" GCol="text,SEBELN" GF="S 30">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="100 STD_SEBELP" GCol="text,SEBELP" GF="S 5">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="100 STD_LOTA03NM" GCol="text,LOTA03NM" GF="S 100">벤더명</td>	<!--벤더명-->
			    						<td GH="100 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="100 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="100 STD_LOCASRL7141" GCol="text,LOCSKU" GF="S 20"></td>	<!---->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add" style="display:none;"></button>
						<button type='button' GBtn="copy" id="tab2Copybtn" style="display:none;"></button>
						<button type='button' GBtn="delete" id="tab2Delbtn" style="display:none;"></button>
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
					</div>
				</div>
				
				<div class="table_box section" id="tab2-3" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList3">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>
			    						<td GH="80 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td>	<!--재고키-->
			    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="50 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="100 STD_QTSAVLB" GCol="text,AVAILABLEQTYUOM" GF="N 17,0">가용수량</td>	<!--가용수량-->
			    						<td GH="100 STD_QTTAOR" GCol="input,QTTAOR" GF="N 17,0">작업수량</td>	<!--작업수량-->
			    						<td GH="100 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="100 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
			    						<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 20">거점</td>	<!--거점-->
			    						<td GH="100 STD_TASKKY" GCol="text,TASKKY" GF="S 10">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="100 STD_TASKIT" GCol="text,TASKIT" GF="S 6">작업오더아이템</td>	<!--작업오더아이템-->
			    						<td GH="100 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td>	<!--작업타입-->
			    						<td GH="100 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="100 STD_SUOMKY" GCol="text,SUOMKY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="100 STD_LOCATG" GCol="input,LOCATG,SHLOCMA" GF="U 20">To 로케이션</td>	<!--To 로케이션-->
			    						<td GH="100 STD_TRNUTG" GCol="input,TRNUTG" GF="S 20">To 팔렛트ID</td>	<!--To 팔렛트ID-->
			    						<td GH="100 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="100 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="100 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="100 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="100 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="100 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="100 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="100 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="100 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="100 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="100 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="100 STD_SKUG05" GCol="text,SKUG05" GF="S 20">제품용도</td>	<!--제품용도-->
			    						<td GH="100 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11">포장중량</td>	<!--포장중량-->
			    						<td GH="100 STD_NETWGT" GCol="text,NETWGT" GF="S 11">순중량</td>	<!--순중량-->
			    						<td GH="100 STD_LOTA05" GCol="select,LOTA05">
			    							<select class="input" CommonCombo="LOTA05"></select>
			    						</td>	<!--포장구분-->
			    						<td GH="100 STD_LOTA06" GCol="select,LOTA06">
			    							<select class="input" CommonCombo="LOTA06"></select>
			    						</td>	<!--재고유형-->
			    						<td GH="100 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
			    						<td GH="100 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="100 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="100 STD_SEBELN" GCol="text,SEBELN" GF="S 30">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="100 STD_PTLT05" GCol="input,PTLT05" GF="S 20">To포장구분</td>	<!--To포장구분-->
			    						<td GH="100 STD_PTLT06" GCol="input,PTLT06" GF="S 20">To 재고유형</td>	<!--To 재고유형-->
			    						<td GH="100 STD_PTLT13" GCol="input,PTLT13" GF="D 20">To 유통기한</td>	<!--To 유통기한-->
			    						<td GH="100 STD_LOTA03NM" GCol="text,LOTA03NM" GF="S 100">벤더명</td>	<!--벤더명-->
			    						<td GH="100 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="100 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="100 STD_LOCASRL7141" GCol="text,LOCSKU" GF="S 20"></td>	<!---->
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
				
				
				<div class="table_box section" id="tab2-4" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList4">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>
										<td GH="40" GCol="rowCheck"></td>   
			    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="100 STD_QTCOMP" GCol="input,QTCOMP" GF="N 20,0">완료수량</td>	<!--완료수량 -->
			    						<td GH="100 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="100 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
			    						<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="100 STD_TASKKY" GCol="text,TASKKY" GF="S 10">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="100 STD_TASKIT" GCol="text,TASKIT" GF="S 6">작업오더아이템</td>	<!--작업오더아이템-->
			    						<td GH="100 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td>	<!--작업수량-->
			    						<td GH="100 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="100 STD_SUOMKY" GCol="text,SUOMKY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="80 STD_LOCATG" GCol="input,LOCATG,SHLOCMA" GF="S 20"  validate="required">To 로케이션</td>	<!--To 로케이션-->
			    						<td GH="100 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="100 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="100 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="100 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="100 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="100 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="100 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="100 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="100 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="100 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="100 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="100 STD_SKUG05" GCol="text,SKUG05" GF="S 20">제품용도</td>	<!--제품용도-->
			    						<td GH="100 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11">포장중량</td>	<!--포장중량-->
			    						<td GH="100 STD_NETWGT" GCol="text,NETWGT" GF="S 11">순중량</td>	<!--순중량-->
			    						<td GH="100 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
			    						<td GH="100 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="100 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="100 STD_SEBELN" GCol="text,SEBELN" GF="S 30">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="100 STD_PTLT05" GCol="text,PTLT05" GF="S 20">To포장구분</td>	<!--To포장구분-->
			    						<td GH="100 STD_PTLT06" GCol="text,PTLT06" GF="S 20">To 재고유형</td>	<!--To 재고유형-->
			    						<td GH="100 STD_PTLT13" GCol="text,PTLT13" GF="D 20">To 유통기한</td>	<!--To 유통기한-->
			    						<td GH="100 STD_LOTA03NM" GCol="text,LOTA03NM" GF="S 100">벤더명</td>	<!--벤더명-->
			    						<td GH="100 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="100 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="100 STD_LOCASRL7141" GCol="text,LOCSKU" GF="S 20"></td>	<!---->
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