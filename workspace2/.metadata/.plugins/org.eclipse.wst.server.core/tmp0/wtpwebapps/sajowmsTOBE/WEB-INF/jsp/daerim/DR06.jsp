<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DR06</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Daerim",
			command : "DR06_HEAD",
			pkcol : "MANDT, SEQNO",
			itemGrid : "gridItemList",
			itemSearch : true ,
		    menuId : "DR06"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Daerim",
			command : "DR06_ITEM",
		    menuId : "DR06"
	    });
		
		gridList.setReadOnly("gridHeadList", true, ["OWNRKY", "DOCUTY", "DIRDVY", "DIRSUP"]);
		gridList.setReadOnly("gridItemList", true, ["WAREKY"]);
		
		$("#WAREKY").val("<%=wareky%>");
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	

	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			param.put("SES_WAREKY", "<%=wareky%>")
			
			if($('#CHKMAK').prop("checked") == false){
				param.put("CHKMAK","");
			}else if($('#CHKMAK').prop("checked") == true){
				param.put("CHKMAK","1");
			}
			if($('#CHKMAK2').prop("checked") == false){
				param.put("CHKMAK2","");
			}else if($('#CHKMAK2').prop("checked") == true){
				param.put("CHKMAK2","1");
			}
			
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
	
	function reloadLabel() {
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		} else if (btnName == "Grouping") {
			Grouping();
		}else if (btnName == "GroupingAll") {
			GroupingAll();
		}else if (btnName == "GroupingDel") {
			GroupingDel();
		}else if (btnName == "GrupingDelAll") {
			GrupingDelAll();
		}else if (btnName == "Print") {		/* 거래처별피킹호차 */
			Print();
		}else if (btnName == "Print2") {	/* 품목별피킹호차 */
			Print2();
		}else if (btnName == "Print3") {	/* 총량 피킹(오포) */
			Print3();
		}else if (btnName == "Print4") {	/* 총량 피킹(안산) */
			Print4();
		}else if (btnName == "Print5") {	/* 차수별 소분류 리스트 */
			Print5();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DR06");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DR06");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	function Grouping(){

		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var item = gridList.getSelectData("gridItemList", true);
			
			var param = inputList.setRangeParam("searchArea");
			param.put("head",head);
			param.put("item",item);
			param.put("WAREKY",$("#WAREKY").val());
			param.put("USERID","<%=userid %>");
			if($('#CHKMAK2').prop("checked") == false){
				param.put("CHKMAK2","");
			}else if($('#CHKMAK2').prop("checked") == true){
				param.put("CHKMAK2","1");
			}
			
			netUtil.send({
				url : "/Daerim/json/groupingDR06.data",  // 그룹핑 컨트롤러  url 로 지정 
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	function GroupingAll(){

		if(gridList.validationCheck("gridHeadList", "select")){
			 var head = gridList.getGridData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			} 
			
			 var item = gridList.getGridData("gridItemList", true); 
			
			var param = inputList.setRangeParam("searchArea");
			param.put("head",head);
			param.put("item",item); 
			param.put("WAREKY",$("#WAREKY").val());
			param.put("USERID","<%=userid %>");
			
			netUtil.send({
				url : "/Daerim/json/groupingDR06.data",  // 그룹핑 컨트롤러  url 로 지정 
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	function GroupingDel(){
	
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var item = gridList.getSelectData("gridItemList", true);
			
			var headlist = head.filter(function(element,index,array){
				return ($.trim(element.map["TEXT03"]) != '');
			});
			
			if(headlist.length == 0){
				commonUtil.msgBox("삭제할 그룹핑이 존재하지 않습니다.");
				return false;
			}
			
			var param = inputList.setRangeDataParam("searchArea");
			param.put("head",headlist);
			param.put("item",item);
			
			if(commonUtil.msgConfirm("* 현장에 피킹리스트가 전달되었을 경우에는 새로운 그룹핑 번호로   피킹리스트가 다시  배포 되어야 합니다.\n삭제 하시겠습니까? *")){
				netUtil.send({
					url : "/Daerim/json/delGroupDR06.data",  // 그룹핑 컨트롤러  url 로 지정 
					param : param,
					successFunction : "successSaveCallBack"
				});
			} else{
				return;
			}
		}
	
	}
	function GrupingDelAll(){

		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getGridData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var item = gridList.getGridData("gridItemList", true);
			
			var headlist = head.filter(function(element,index,array){
				return ($.trim(element.map["TEXT03"]) != '');
			});
			
			if(headlist.length == 0){
				commonUtil.msgBox("삭제할 그룹핑이 존재하지 않습니다.");
				return false;
			}
			
			var param = inputList.setRangeParam("searchArea");
			param.put("head",headlist);
			param.put("item",item);
			
			if(commonUtil.msgConfirm("* HEADER리스트의 모든 피킹출력번호가 삭제됩니다.\n 삭제 하시겠습니까? *")){
				netUtil.send({
					url : "/Daerim/json/delGroupDR06.data",  // 그룹핑 컨트롤러  url 로 지정 
					param : param,
					successFunction : "successSaveCallBack"
				});
			} else{
				return;
			}
		}
	}
	
	function Print(){  /* 거래처별피킹호차 */
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var wherestr = "";
			var text03_check = "";
			var text03_val = "";
			
			for(var i =0;i < head.length ; i++){
				text03_check = head[i].get("TEXT03");
				
				if(text03_val !=text03_check){
					if(wherestr == ""){
						wherestr = wherestr+" AND TEXT03 IN (";
					}else{
						wherestr = wherestr+" UNION ALL ";
					}
					
					wherestr += "SELECT '" + head[i].get("TEXT03") + "' FROM DUAL";
				}
				text03_val = text03_check;
			}
			wherestr += ")";
				
			wherestr += getMultiRangeDataSQLEzgen('I.WAREKY', 'WAREKY');	
			wherestr += getMultiRangeDataSQLEzgen('B2.NAME03', 'NAME03');	
			wherestr += getMultiRangeDataSQLEzgen('I.DOCUTY', 'DOCUTY');	
			wherestr += getMultiRangeDataSQLEzgen('I.SVBELN', 'SVBELN');	
			wherestr += getMultiRangeDataSQLEzgen('I.ORDDAT', 'ORDDAT');	
			wherestr += getMultiRangeDataSQLEzgen('I.OTRQDT', 'OTRQDT');	
			wherestr += getMultiRangeDataSQLEzgen('I.PTNRTO', 'PTNRTO');
			wherestr += getMultiRangeDataSQLEzgen('I.PTNROD', 'PTNROD');
			wherestr += getMultiRangeDataSQLEzgen('I.SKUKEY', 'SKUKEY');
			wherestr += getMultiRangeDataSQLEzgen('I.DIRSUP', 'DIRSUP');
			wherestr += getMultiRangeDataSQLEzgen('I.DIRDVY', 'DIRDVY');
			wherestr += getMultiRangeDataSQLEzgen('C.CARNUM', 'CARNUM');
			wherestr += getMultiRangeDataSQLEzgen('B2.PTNG08', 'PTNG08');
			wherestr += getMultiRangeDataSQLEzgen('SM.ASKU05', 'ASKU05');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG01', 'PTNG01');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG02', 'PTNG02');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG03', 'PTNG03');
			wherestr += getMultiRangeDataSQLEzgen('PK.PICGRP', 'PICGRP');
			wherestr += getMultiRangeDataSQLEzgen('SM.SKUG03', 'SKUG03');
			wherestr += getMultiRangeDataSQLEzgen('SW.LOCARV', 'LOCARV');
			
			var wareky = '\'<%=wareky %>\'';;
	
			var langKy = "KO";
			var width = 595;
			var heigth = 840;
			var map = new DataMap();
				map.put("i_option",wareky);

			WriteEZgenElement("/ezgen/bzptn_picking_sale_list2.ezg" , wherestr , " " , langKy, map , width , heigth );

		}
	}
	function Print2(){  /* 품목별피킹호차 */
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var wherestr = "";
			var text03_check = "";
			var text03_val = "";
			
			for(var i =0;i < head.length ; i++){
				text03_check = head[i].get("TEXT03");
				
				if(text03_val !=text03_check){
					if(wherestr == ""){
						wherestr = wherestr+" AND TEXT03 IN (";
					}else{
						wherestr = wherestr+" UNION ALL ";
					}
					
					wherestr += "SELECT '" + head[i].get("TEXT03") + "' FROM DUAL";
				}
				text03_val = text03_check;
			}
			wherestr += ")";
				
			wherestr += getMultiRangeDataSQLEzgen('I.WAREKY', 'WAREKY');	
			wherestr += getMultiRangeDataSQLEzgen('B2.NAME03', 'NAME03');	
			wherestr += getMultiRangeDataSQLEzgen('I.DOCUTY', 'DOCUTY');	
			wherestr += getMultiRangeDataSQLEzgen('I.SVBELN', 'SVBELN');	
			wherestr += getMultiRangeDataSQLEzgen('I.ORDDAT', 'ORDDAT');	
			wherestr += getMultiRangeDataSQLEzgen('I.OTRQDT', 'OTRQDT');	
			wherestr += getMultiRangeDataSQLEzgen('I.PTNRTO', 'PTNRTO');
			wherestr += getMultiRangeDataSQLEzgen('I.PTNROD', 'PTNROD');
			wherestr += getMultiRangeDataSQLEzgen('I.SKUKEY', 'SKUKEY');
			wherestr += getMultiRangeDataSQLEzgen('I.DIRSUP', 'DIRSUP');
			wherestr += getMultiRangeDataSQLEzgen('I.DIRDVY', 'DIRDVY');
			wherestr += getMultiRangeDataSQLEzgen('C.CARNUM', 'CARNUM');
			wherestr += getMultiRangeDataSQLEzgen('B2.PTNG08', 'PTNG08');
			wherestr += getMultiRangeDataSQLEzgen('SM.ASKU05', 'ASKU05');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG01', 'PTNG01');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG02', 'PTNG02');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG03', 'PTNG03');
			wherestr += getMultiRangeDataSQLEzgen('PK.PICGRP', 'PICGRP');
			wherestr += getMultiRangeDataSQLEzgen('SM.SKUG03', 'SKUG03');
			wherestr += getMultiRangeDataSQLEzgen('SW.LOCARV', 'LOCARV');
			
			var wareky = '\'<%=wareky %>\'';;
	
			var langKy = "KO";
			var width = 595;
			var heigth = 840;
			var map = new DataMap();
				map.put("i_option",wareky);

			WriteEZgenElement("/ezgen/product_picking_sale_list2.ezg" , wherestr , " " , langKy, map , width , heigth );

		}
	}
	function Print3(){  /* 총량 피킹(오포) */
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var wherestr = "";
			var text03_check = "";
			var text03_val = "";
			
			for(var i =0;i < head.length ; i++){
				text03_check = head[i].get("TEXT03");
				
				if(text03_val !=text03_check){
					if(wherestr == ""){
						wherestr = wherestr+" AND TEXT03 IN (";
					}else{
						wherestr = wherestr+" UNION ALL ";
					}
					
					wherestr += "SELECT '" + head[i].get("TEXT03") + "' FROM DUAL";
				}
				text03_val = text03_check;
			}
			wherestr += ")";
				
			wherestr += getMultiRangeDataSQLEzgen('I.WAREKY', 'WAREKY');	
			wherestr += getMultiRangeDataSQLEzgen('B2.NAME03', 'NAME03');	
			wherestr += getMultiRangeDataSQLEzgen('I.DOCUTY', 'DOCUTY');	
			wherestr += getMultiRangeDataSQLEzgen('I.SVBELN', 'SVBELN');	
			wherestr += getMultiRangeDataSQLEzgen('I.ORDDAT', 'ORDDAT');	
			wherestr += getMultiRangeDataSQLEzgen('I.OTRQDT', 'OTRQDT');	
			wherestr += getMultiRangeDataSQLEzgen('I.PTNRTO', 'PTNRTO');
			wherestr += getMultiRangeDataSQLEzgen('I.PTNROD', 'PTNROD');
			wherestr += getMultiRangeDataSQLEzgen('I.SKUKEY', 'SKUKEY');
			wherestr += getMultiRangeDataSQLEzgen('I.DIRSUP', 'DIRSUP');
			wherestr += getMultiRangeDataSQLEzgen('I.DIRDVY', 'DIRDVY');
			wherestr += getMultiRangeDataSQLEzgen('C.CARNUM', 'CARNUM');
			wherestr += getMultiRangeDataSQLEzgen('B2.PTNG08', 'PTNG08');
			wherestr += getMultiRangeDataSQLEzgen('SM.ASKU05', 'ASKU05');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG01', 'PTNG01');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG02', 'PTNG02');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG03', 'PTNG03');
			wherestr += getMultiRangeDataSQLEzgen('PK.PICGRP', 'PICGRP');
			wherestr += getMultiRangeDataSQLEzgen('SM.SKUG03', 'SKUG03');
			wherestr += getMultiRangeDataSQLEzgen('SW.LOCARV', 'LOCARV');
			
			var wareky = '\'<%=wareky %>\'';;
	
			var langKy = "KO";
			var width = 595;
			var heigth = 840;
			var map = new DataMap();
				map.put("i_option",wareky);

			WriteEZgenElement("/ezgen/picking_total_carnum_list.ezg" , wherestr , " " , langKy, map , width , heigth );
		}
	}
	function Print4(){  /* 총량 피킹(안산) */
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var wherestr = "";
			var text03_check = "";
			var text03_val = "";
			
			for(var i =0;i < head.length ; i++){
				text03_check = head[i].get("TEXT03");
				
				if(text03_val !=text03_check){
					if(wherestr == ""){
						wherestr = wherestr+" AND TEXT03 IN (";
					}else{
						wherestr = wherestr+" UNION ALL ";
					}
					
					wherestr += "SELECT '" + head[i].get("TEXT03") + "' FROM DUAL";
				}
				text03_val = text03_check;
			}
			wherestr += ")";
				
			wherestr += getMultiRangeDataSQLEzgen('I.WAREKY', 'WAREKY');	
			wherestr += getMultiRangeDataSQLEzgen('B2.NAME03', 'NAME03');	
			wherestr += getMultiRangeDataSQLEzgen('I.DOCUTY', 'DOCUTY');	
			wherestr += getMultiRangeDataSQLEzgen('I.SVBELN', 'SVBELN');	
			wherestr += getMultiRangeDataSQLEzgen('I.ORDDAT', 'ORDDAT');	
			wherestr += getMultiRangeDataSQLEzgen('I.OTRQDT', 'OTRQDT');	
			wherestr += getMultiRangeDataSQLEzgen('I.PTNRTO', 'PTNRTO');
			wherestr += getMultiRangeDataSQLEzgen('I.PTNROD', 'PTNROD');
			wherestr += getMultiRangeDataSQLEzgen('I.SKUKEY', 'SKUKEY');
			wherestr += getMultiRangeDataSQLEzgen('I.DIRSUP', 'DIRSUP');
			wherestr += getMultiRangeDataSQLEzgen('I.DIRDVY', 'DIRDVY');
			wherestr += getMultiRangeDataSQLEzgen('C.CARNUM', 'CARNUM');
			wherestr += getMultiRangeDataSQLEzgen('B2.PTNG08', 'PTNG08');
			wherestr += getMultiRangeDataSQLEzgen('SM.ASKU05', 'ASKU05');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG01', 'PTNG01');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG02', 'PTNG02');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG03', 'PTNG03');
			wherestr += getMultiRangeDataSQLEzgen('PK.PICGRP', 'PICGRP');
			wherestr += getMultiRangeDataSQLEzgen('SM.SKUG03', 'SKUG03');
			wherestr += getMultiRangeDataSQLEzgen('SW.LOCARV', 'LOCARV');
			
			var wareky = '\'<%=wareky %>\'';;
	
			var langKy = "KO";
			var width = 595;
			var heigth = 840;
			var map = new DataMap();
				map.put("i_option",wareky);

			WriteEZgenElement("/ezgen/picking_total_list_ansan.ezg" , wherestr , " " , langKy, map , width , heigth );
		}
	}
	function Print5(){  /* 차수별 소분류 리스트  */
		
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var wherestr = "";
			var text03_check = "";
			var text03_val = "";
			
			for(var i =0;i < head.length ; i++){
				text03_check = head[i].get("TEXT03");
				
				if(text03_val !=text03_check){
					if(wherestr == ""){
						wherestr = wherestr+" AND TEXT03 IN (";
					}else{
						wherestr = wherestr+" UNION ALL ";
					}
					
					wherestr += "SELECT '" + head[i].get("TEXT03") + "' FROM DUAL";
				}
				text03_val = text03_check;
			}
			wherestr += ")";
				
			wherestr += getMultiRangeDataSQLEzgen('I.WAREKY', 'WAREKY');	
			wherestr += getMultiRangeDataSQLEzgen('B2.NAME03', 'NAME03');	
			wherestr += getMultiRangeDataSQLEzgen('I.DOCUTY', 'DOCUTY');	
			wherestr += getMultiRangeDataSQLEzgen('I.SVBELN', 'SVBELN');	
			wherestr += getMultiRangeDataSQLEzgen('I.ORDDAT', 'ORDDAT');	
			wherestr += getMultiRangeDataSQLEzgen('I.OTRQDT', 'OTRQDT');	
			wherestr += getMultiRangeDataSQLEzgen('I.PTNRTO', 'PTNRTO');
			wherestr += getMultiRangeDataSQLEzgen('I.PTNROD', 'PTNROD');
			wherestr += getMultiRangeDataSQLEzgen('I.SKUKEY', 'SKUKEY');
			wherestr += getMultiRangeDataSQLEzgen('I.DIRSUP', 'DIRSUP');
			wherestr += getMultiRangeDataSQLEzgen('I.DIRDVY', 'DIRDVY');
			wherestr += getMultiRangeDataSQLEzgen('C.CARNUM', 'CARNUM');
			wherestr += getMultiRangeDataSQLEzgen('B2.PTNG08', 'PTNG08');
			wherestr += getMultiRangeDataSQLEzgen('SM.ASKU05', 'ASKU05');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG01', 'PTNG01');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG02', 'PTNG02');
			wherestr += getMultiRangeDataSQLEzgen('B.PTNG03', 'PTNG03');
			wherestr += getMultiRangeDataSQLEzgen('PK.PICGRP', 'PICGRP');
			wherestr += getMultiRangeDataSQLEzgen('SM.SKUG03', 'SKUG03');
			wherestr += getMultiRangeDataSQLEzgen('SW.LOCARV', 'LOCARV');
			
			var wareky = '\'<%=wareky %>\'';;
	
			var langKy = "KO";
			var width = 595;
			var heigth = 840;
			var map = new DataMap();
				map.put("i_option",wareky);

			WriteEZgenElement("/ezgen/picking_total_list_ansan.ezg" , wherestr , " " , langKy, map , width , heigth );
		}
	}

	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();

		//거점
		if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
	        param.put("CMCDKY","WAREKY");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		//출고거점
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "B2.NAME03"){
	        param.put("CMCDKY","WAREKY");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		//납품처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
	        param.put("PTNRTY","0007");
	        param.put("OWNRKY","<%=ownrky %>");
	    //매출처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNROD"){
	        param.put("PTNRTY","0001");
	        param.put("OWNRKY","<%=ownrky %>");	
		//주문구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
	        param.put("CMCDKY","PGRC03");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//배송구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
	        param.put("CMCDKY","PGRC02");
	    	param.put("OWNRKY","<%=ownrky %>");   
		//마감구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "B2.PTNG08"){
	        param.put("CMCDKY","PTNG08");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//상온구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
	        param.put("CMCDKY","ASKU05");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//유통경로1
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG01"){
	        param.put("CMCDKY","PTNG01");
	    	param.put("OWNRKY","<%=ownrky %>");
		//유통경로2
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG02"){
	        param.put("CMCDKY","PTNG02");
	    	param.put("OWNRKY","<%=ownrky %>");
		//유통경로3
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG03"){
	        param.put("CMCDKY","PTNG03");
	    	param.put("OWNRKY","<%=ownrky %>");	
		//피킹그룹
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "PK.PICGRP"){
	        param.put("CMCDKY","PICGRP");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//소분류
		} else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG03"){
	        param.put("CMCDKY","SKUG03");
	        param.put("OWNRKY","<%=ownrky %>");
		//로케이션
	    } else if(searchCode == "SHLOCMA" && $inputObj.name == "SW.LOCARV"){
		    param.put("WAREKY","<%=wareky %>");	
	    } else if(searchCode == "SHCARMA2" && $inputObj.name == "C.CARNUM"){
		    param.put("WAREKY","<%=wareky %>");	
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
					<input type="button" CB="Grouping GROUPING BTN_GROUPING" />	<!-- 그룹핑-->
					<input type="button" CB="GroupingAll GROUPING STD_GROUP_ALL" />	<!-- 그룹핑(전체) -->
					<input type="button" CB="GroupingDel GROUPING BTN_DELGROUP" />	<!-- 그룹핑삭제 -->
					<input type="button" CB="GrupingDelAll GROUPING BTN_DELGROUPALL" />	<!-- 그룹핑삭제(전체) -->
					<input type="button" CB="Print PRINT_OUT BTN_CLNT_PKCAR" />	<!-- 거래처별피킹호차 -->
					<input type="button" CB="Print2 PRINT_OUT BTN_SKU_CLNTCAR" />	<!-- 거래처별피킹호차 -->
					<input type="button" CB="Print3 PRINT_OUT STD_CNTPIC_2218" />	<!-- 총량 피킹(오포) -->
					<input type="button" CB="Print4 PRINT_OUT STD_CNTPIC_2213" />	<!-- 총량 피킹(안산) -->
					<input type="button" CB="Print5 PRINT_OUT BTN_DR16PRT" />	<!-- 차수별 소분류 리스트 -->
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
					<dl>  <!--기존 그룹핑내역 제외-->  
						<dt CL="STD_EXGROUPING"></dt> 
						<dd> 
							<input type="checkbox" class="input" name="CHKMAK" id="CHKMAK" />
						</dd> 
					</dl> 
					<dl>  <!--상미기간 포기(온라인 거래처만 포기)-->  
						<dt CL="STD_STDPROD" style="width:110px"></dt> 
						<dd> 
							<input type="checkbox" class="input" name="CHKMAK2" id="CHKMAK2" />
						</dd> 
					</dl>
					<dl>  <!--거점-->  
						<dt CL="STD_WAREKY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.WAREKY" id="WAREKY"  UIInput="SR,SHCMCDV" value="<%=wareky%>"/>
						</dd> 
					</dl>  
					<dl>  <!--출고일자-->  
						<dt CL="STD_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="I.ORDDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="STD_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--부족재고S/O조회-->  
						<dt CL="STD_STOCKSHORT"></dt> 
						<dd> 
							<select name="ORDTYPE" class="input" Combo="Daerim,USETYPE_COMBO"></select>  
						</dd> 
					</dl> 
					<dl>  <!--출고거점-->  
						<dt CL="STD_NAME03B"></dt> 
						<dd> 
							<input type="text" class="input" name="B2.NAME03" UIInput="SR,SHCMCDV" />
						</dd> 
					</dl>  
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl> 
					<dl>  <!--S/O 번호-->  
						<dt CL="STD_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="I.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처코드-->  
						<dt CL="STD_PTRCVRCD"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN"/>
						</dd> 
					</dl> 
					<dl>  <!--매출처코드-->  
						<dt CL="STD_DPTNKYCD"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNROD" UIInput="SR,SHBZPTN"/>
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA" /> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DIRDVY" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--차량번호-->  
						<dt CL="STD_VEHINO"></dt> 
						<dd> 
							<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHCARMA2" /> 
						</dd> 
					</dl> 
					<dl>  <!--마감구분-->  
						<dt CL="STD_PTNG08"></dt> 
						<dd> 
							<input type="text" class="input" name="B2.PTNG08" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--상온구분-->  
						<dt CL="STD_ASKU05"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로1-->  
						<dt CL="STD_PTNG01"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG01" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로2-->  
						<dt CL="STD_PTNG02"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG02" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로3-->  
						<dt CL="STD_PTNG03"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG03" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--피킹그룹-->  
						<dt CL="STD_ASKU03"></dt> 
						<dd> 
							<input type="text" class="input" name="PK.PICGRP" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					<dl>  <!--소그룹-->  
						<dt CL="STD_SKUG03"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.SKUG03" UIInput="SR,SHCMCDV" /> 
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
			<div class="content_layout tabs top_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li>
						<p style="width:80%; white-space:nowrap;"> ※ 출력물에서 매출처가 납품처로 보이는 거래처는 [BZ01] 파트너 에서 '납품처사용여부' 컬럼을 참조하세요. </p>
						<p style="width:80%; white-space:nowrap;"> ※ 상미기간 마스터(BD01) 등록된 거래처는 단일 거래처로 그룹핑 후 피킹지 출력바랍니다.</p>
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="140 IFT_OWNRKY" GCol="select,OWNRKY">
											<select class="input" Combo="SajoCommon,OWNRKYNM_COMCOMBO"></select>	<!--화주-->
										</td> 
										<td GH="80 IFT_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td> <!--차량번호-->
										<td GH="100 STD_CARNAME" GCol="text,CARNUMNM" GF="S 20">차량명</td> <!--차량명-->
										<td GH="90 STD_PIKSEQ" GCol="text,TEXT03" GF="S 20">피킹출력번호</td> <!--피킹출력번호-->
										<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td> <!--납품처코드-->
										<td GH="160 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td> <!--납품처명-->
										<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td> <!--매출처코드-->
										<td GH="160 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td> <!--매출처명-->
										<td GH="130 IFT_DOCUTY" GCol="select,DOCUTY" >
											<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select> <!--출고유형-->
										</td>
										<td GH="100 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td> <!--출고일자-->
										<td GH="100 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td> <!--출고요청일-->
										<td GH="100 IFT_DIRDVY" GCol="select,DIRDVY">
											<select class="input" commonCombo="PGRC02"></select> <!--배송구분-->
										</td> 
										<td GH="100 IFT_DIRSUP" GCol="select,DIRSUP">
											<select class="input" commonCombo="PGRC03"></select>  <!--주문구분-->
										</td>
										<td GH="90 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
										<!-- <td GH="100 STD_CRETIM" GCol="text,CRETIM" GF="S 20">생성시간</td> 생성시간-->
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
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="90 IFT_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">주문번호아이템</td> <!--주문번호아이템-->
										<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
										<td GH="90 STD_PIKSEQ" GCol="text,TEXT03" GF="S 20">피킹출력번호</td> <!--피킹출력번호-->
										<td GH="200 IFT_WAREKY" GCol="select,WAREKY" >
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>	<!--WMS거점(출고사업장)-->
										</td> 
										<td GH="70 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="160 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
										<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td> <!--납품요청수량-->
										<td GH="80 STD_ORDTOT" GCol="text,ORDTOT" GF="N 13,0">누적주문수량</td> <!--누적주문수량-->
										<td GH="70 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="70 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
										<td GH="70 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
										<td GH="80 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td> <!--출하수량-->
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