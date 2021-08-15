<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>TM03</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">

	var GRPRL = 'ERPSO';
	var TOTALPICKING = 'N';
	var PROGID = 'TM03';
    var SVBELN = '';
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "TM03_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "TM03"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "Outbound",
			command : "TM03_ITEM",
			pkcol : "OWNRKY,WAREKY,TASKKY",
			emptyMsgType : false,
		    menuId : "TM03"
	    });
		
		

		$("#OWNRKY").val(<%=ownrky%>);
		// 대림 이고 전용 콤보로 세팅 
		$("#OWNRKY").on("change",function(){
			var param = new DataMap();
			param.put("OWNRKY",$(this).val());
			
			var json = netUtil.sendData({
				module : "SajoCommon",
				command : "WAREKYNM_IF2_COMCOMBO",
				sendType : "list",
				param : param
			}); 
			
			$("#WARETG").find("[UIOption]").remove();
			$("#WARERQ").find("[UIOption]").remove();
			
			var optionHtml = inputList.selectHtml(json.data, true);
			$("#WARETG").append(optionHtml);
			$("#WARERQ").append(optionHtml);
			
			var cnt = json.data.filter(function(element,index,array){
				return (element.VALUE_COL == '<%=wareky %>');
			});
			
			if(cnt.length == 0){
				$("#WARETG option:eq(0)").prop("selected",true); 
				$("#WARERQ option:eq(0)").prop("selected",true); 
			}else{
				$("#WARETG").val('<%=wareky %>');	
				$("#WARERQ").val('<%=wareky %>');	
			}
			
		});

		$("#OWNRKY").trigger('change');
		
		//콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["OWNRKY", "WARESR", "WARERQ","WARETG", "DOCUTY"]);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchwareky(val,target){
		var param = new DataMap();
		param.put("OWNRKY",val);
		
		var json = netUtil.sendData({
			module : "SajoCommon",
			command : "WAREKYNM_IF2_COMCOMBO",
			sendType : "list",
			param : param
		});
		
		$(target).find("[UIOption]").remove();
		var optionHtml = inputList.selectHtml(json.data, false);
		$(target).append(optionHtml);

	}
	
	function searchList(){
		
		if( $('#WARERQ').val() == null )
		{
			alert("* 출고거점은 필수 입력  입니다.");
			return ;
		} else if( $('#WARETG').val() == null )
		{
			alert("* 도착거점은 필수 입력  입니다.");
			return ;
		} 

		if($("#WARERQ").val() == $("#WARETG").val()){
			commonUtil.msgBox("VALID_M0959"); //출고거점과 입고거점이 동일합니다.
			return ; 
		
		}

		$('#btnSave').show();
		
		if(validate.check("searchArea")){			
			var param = inputList.setRangeParam("searchArea");			
			var group = $('input[name="GROUP"]:checked').attr('id');
			param.put("SHPMTY","266");
			param.put('SVBELN',SVBELN);	


			if (SVBELN != "") {
				gridList.gridList({
			    	id : "gridHeadList",
			    	command : "TM03_HEAD_SAVED",
			    	param : param
			    });	
			}else{
				gridList.gridList({
			    	id : "gridHeadList",
			    	param : param
			    });
			}
		}

	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			if (SVBELN == ''){				
				gridList.gridList({
			    	id : "gridItemList",
			    	param : param
			    });
			} else {
				SVBELN = '';
			}
		}
	}
	
	
	//그리드 컬럼 값 변경시 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){

		if(gridId == "gridItemList"){
			if(colName == "SKUKEY"){ //제품코드 변경시

				var param = new DataMap();

				param.put("DOCUTY", gridList.getColData("gridHeadList",0, "DOCUTY"));
				param.put("WAREKY", gridList.getColData("gridHeadList",0, "WARESR"));
				param.put("WARERQ", gridList.getColData("gridHeadList",0, "WARESR"));
				param.put("OWNRKY", gridList.getColData("gridHeadList",0, "OWNRKY"));
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
					gridList.setColValue(gridId, rowNum, "QTDUOM", json.data[0].QTDUOM);
					gridList.setColValue(gridId, rowNum, "MEASKY", json.data[0].MEASKY);
					gridList.setColValue(gridId, rowNum, "QTPUOM", json.data[0].QTPUOM);
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
	
	  function save(){    
        var head = gridList.getGridData("gridHeadList"); 
        var item = gridList.getSelectData("gridItemList");
	
	    if(head.length == 0){
	      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
	      return;
	    }
	    
	    var qtychk = "";
		var syschk = "";
		var keychk = "";
		var orddat = head[0].get("ORDDAT");
		var otrqdt = head[0].get("OTRQDT");
    	var ordyy = orddat.substr(0,4);
		var ordmm = orddat.substr(4,2);
	    var orddd = orddat.substr(6,2);
	    var otryy = otrqdt.substr(0,4);
		var otrmm = otrqdt.substr(4,2);
	    var otrdd = otrqdt.substr(6,2);
	    var sysdate = new Date(); 
	    
	 	var orddate = new Date(Number(ordyy), Number(ordmm)-1, Number(orddd));
	 	var otrdate = new Date(Number(otryy), Number(otrmm)-1, Number(otrdd));
	 	
	 	if(Math.abs((orddate-sysdate)/1000/60/60/24) > 10 || Math.abs((otrdate-sysdate)/1000/60/60/24) > 10){
			alert("요청일 또는 출고일은 ±10일로 지정하셔야 합니다.") ;
			return;
		}  
	 	
	    if(item.length == 0){
		      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
		      return;
		    }

		var dupMap = new DataMap();
	    for(i=0; i<item.length; i++){
	    	var skukey = item[i].get("SKUKEY");
	    	if(skukey.trim() == "" ){
				alert("* 제품코드는  필수 입력 입니다. *");			
				return;
			}	  
			
			//아이템 중복 체크
			if(dupMap.get("SKUKEY") != item[i].get("SKUKEY")){
				dupMap.put("SKUKEY", item[i].get("SKUKEY"));
			}else{
				//같은 제품을 두번 입력할 수 없습니다.
				commonUtil.msgBox("VALID_M0951");
				return;
			}
			

			if(Number(item[i].get("QTYORG")) < 1){
				//수량이 0입니다.
				commonUtil.msgBox("VALID_M0952");
				return;
			}
		}

	    var param = new DataMap();
	    param.put("head",head);
	    param.put("item",item);
	    
    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
			return;
        }

	    netUtil.send({
	      url : "/outbound/json/saveTM05.data",
	      param : param,
	      successFunction : "successSaveCallBack"
	    });
	  }
	  
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data != ""){			
				commonUtil.msgBox("SYSTEM_SAVEOK");
				SVBELN = json.data;
				searchList();
				$('#btnSave').hide();
			}else if(json.data == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function reload(){
		gridList.resetGrid("gridItemList");
		searchList();
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
			$('#btnSave').show();
	    }else if(btnName == "Save"){
	    	save();
		}else if(btnName == "Reload"){
			reload();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "TM03");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "TM03");
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHCMCDV"){
            param.put("CMCDKY","PICGRP");
            param.put("USARG1","<%=ownrky %>");
        	
        }else if ($inputObj.name == "SM.SKUKEY" && searchCode == "SHSKUMA"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if (searchCode == "SHSKUMAGD"){
           var head = gridList.getGridData("gridHeadList"); 
           param.put("WAREKY",head[0].get("WARESR"));
           param.put("OWNRKY",head[0].get("OWNRKY"));
        }
        
    	return param;
    }
		
	//서치헬프 종료 이벤트
	 function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		
	  if( searchCode == 'SHSKUMAGD'){
	   var gridId = "gridItemList"
	   var rowNum = gridList.getFocusRowNum(gridId);
	   var head = gridList.getSelectData("gridHeadList");	   
	   var ownrky = head[0].get("OWNRKY");	  
	   var waresr = head[0].get("WARESR");
	   var warerq = $('#WARERQ').val();	   
	   var skukey = rowData.get("SKUKEY")
	   
	   var param = new DataMap();
	   param.put("OWNRKY", ownrky);
	   param.put("WAREKY", waresr);
	   param.put("WARERQ", warerq);
	   param.put("SKUKEY", skukey);
	   
	   var json = netUtil.sendData({
			module : "Outbound",
			command : "TM03_SKUKEY_SHELP",
			sendType : "map",
			param : param
		}); 
	
			gridList.setColValue(gridId, rowNum, "SKUKEY", json.data.SKUKEY);
			gridList.setColValue(gridId, rowNum, "DESC01", json.data.DESC01);
			gridList.setColValue(gridId, rowNum, "DESC02", json.data.DESC02);
			gridList.setColValue(gridId, rowNum, "DUOMKY", json.data.DUOMKY);
			gridList.setColValue(gridId, rowNum, "QTYORG", json.data.QTYORG);
			gridList.setColValue(gridId, rowNum, "PLIQTY", json.data.PLIQTY);
			gridList.setColValue(gridId, rowNum, "PLTQTY", json.data.PLTQTY);
			gridList.setColValue(gridId, rowNum, "BXIQTY", json.data.BXIQTY);
			gridList.setColValue(gridId, rowNum, "BOXQTY", json.data.BOXQTY);
			gridList.setColValue(gridId, rowNum, "REMQTY", json.data.REMQTY);		
			gridList.setColValue(gridId, rowNum, "FMQTSIWH", json.data.FMQTSIWH);
			gridList.setColValue(gridId, rowNum, "TOQTSIWH", json.data.TOQTSIWH);
			gridList.setColValue(gridId, rowNum, "TOLACQTY", json.data.TOLACQTY);
	  }
	 }
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCUTY", "266");
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
					<input type="button" id="btnSave" CB="Save SAVE BTN_SAVE" />
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
					<dl>  <!--출고유형-->  
						<dt CL="STD_RCPTTY"></dt> 
						<dd> 
							<select name="RCPTTY" id="RCPTTY" class="input" Combo="SajoCommon,DOCUTY_COMCOMBO" ComboCodeView="true"></select> 
						</dd> 
					</dl> 
					<dl>  <!--출고일자-->  
						<dt CL="STD_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="ORDDAT" UIFormat="C N" validate="required(STD_ORDDAT)"/> 
						</dd> 
					</dl> 
					<dl> <!--출고거점--> 
						<dt CL="STD_WAREKY2"></dt>
						<dd>
							<select name="WARERQ" id="WARERQ" class="input" ComboCodeView="true"><option></option></select>
						</dd>
					</dl>
					<dl> <!--입고거점--> 
						<dt CL="STD_WARESR3"></dt>
						<dd>
							<select name="WARETG" id="WARETG" class="input" ComboCodeView="true"></select>
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
			    						<td GH="150 IFT_OWNRKY" GCol="select,OWNRKY"><!--화주-->
												<select class="input" Combo="SajoCommon,OWNRKYNM_COMCOMBO"></select>
			    						</td>
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 IFT_OTRQDT" GCol="input,OTRQDT" GF="C 8">출고요청일</td>	<!--출고요청일-->			    						
			    						<td GH="150 IFT_DOCUTY" GCol="select,DOCUTY"><!--출고유형-->
												<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
			    						</td>				    						
			    						<td GH="200 STD_WAREKY2" GCol="select,WARESR"><!--출고거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>				
			    						    						
			    						<td GH="200 STD_WAREKY3" GCol="select,WARETG"><!--도착거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>	
			    						<td GH="200 STD_WAREKY" GCol="select,WAREKY"><!--거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>		    						
    									<td GH="80 IFT_MANDT" GCol="text,MANDT" GF="S 3">클라이언트 </td>	<!--클라이언트 -->
   										<td GH="80 IFT_ORDTYP" GCol="text,ORDTYP" GF="S 7">주문/출고형태</td>	<!--주문/출고형태-->
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
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40" GCol="rowCheck"></td>																			
			    						<td GH="80 IFT_SKUKEY" GCol="input,SKUKEY,SHSKUMAGD" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td> <!--기본단위-->
			    						<td GH="80 STD_BDMNG" GCol="input,QTYORG" GF="N 13,0">요청수량</td>	<!--요청수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->			    						
										<td GH="100 STD_OY01QTY4" GCol="text,FMQTSIWH" GF="N 13,0">입고거점재고수량</td>	<!--입고거점재고수량-->
										<td GH="100 STD_OY01QTY1" GCol="text,TOQTSIWH" GF="N 13,0">출고거점재고수량</td>	<!--출고거점재고수량-->
			    						<td GH="200 STD_TOLACQTY" GCol="input,TOLACQTY" GF="N 13,0">출고거점 부족수량</td>	<!--출고거점 부족수량-->
			    						<td GH="100 IFT_TEXT01" GCol="input,TEXT01" GF="S 100">비고</td>	<!--비고-->
<!-- 			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S -2">S/O 번호</td>	S/O 번호 -->
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