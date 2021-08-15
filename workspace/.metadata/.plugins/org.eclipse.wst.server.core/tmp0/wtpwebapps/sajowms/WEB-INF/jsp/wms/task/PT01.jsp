<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<%
	User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
%>
<script type="text/javascript" src="/wms/js/wms.js"></script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	$(document).ready(function(){
		setTopSize(130);
		
		gridList.setGrid({
			id : "gridHeadList",
			name : "gridHeadList",
			editable : true,
			pkcol : "TASKKY,TASKIT",
			module : "WmsTask",
			command : "STKKYHEAD"
	    });
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsTask",
			command : "STKKY"
	    });
		
		gridList.setGrid({
			id : "gridWorkList",
			editable : true,
			pkcol : "TASKKY,TASKIT",
			module : "WmsTask",
			command : "STKKY"
	    });
		
		gridList.setGrid({
			id : "gridStockList",
			editable : true,
			pkcol : "TASKKY,TASKIT",
			module : "WmsTask",
			command : "STKKY",
			validation : "LOCATG"
	    });
	    
		gridList.setGrid({
			id : "gridConfirmList",
			editable : true,
			module : "WmsTask",
			command : "TASDI"
	    });
			
		gridList.setReadOnly('gridConfirmList', true, ['QTCOMP','PTLT01','PTLT02','PTLT03','PTLT04','PTLT05','PTLT06'
		                                       ,'PTLT07','PTLT08','PTLT09','PTLT10','PTLT11','PTLT12','PTLT13'
		                                       ,'PTLT14','PTLT15','PTLT16','PTLT17','PTLT18','PTLT19','PTLT20']);
		gridList.setReadOnly("gridList", true, ['LOTA06']);
		gridList.setReadOnly("gridWorkList", true, ['LOTA06']);
		gridList.setReadOnly("gridStockList", true, ['LOTA06']);
		gridList.setReadOnly("gridConfirmList", true, ['LOTA06']);
		
 		$(':button[name="fnMove"]').attr("disabled",false);
 		$(':button[name="fnAuto"]').attr("disabled",true);
 		$(':button[name="fnAutoCan"]').attr("disabled",true);
 		$(':button[name="fnStok"]').attr("disabled",true);
 		$(':button[name="fnStokCan"]').attr("disabled",true);
 		$(':button[name="fnSave"]').attr("disabled",true);
		
	});
	
// 	var searchType = true;
	
	function searchList(){
		
 		$('.tabs').tabs("option", "active", 0);
		
		gridList.resetGridReadOnly("gridList");
		gridList.resetGridReadOnly("gridWorkList");
		gridList.resetGridReadOnly("gridStockList");
		gridList.resetGridReadOnly("gridConfirmList");
		gridList.setReadOnly('gridConfirmList', true, ['QTCOMP','PTLT01','PTLT02','PTLT03','PTLT04','PTLT05','PTLT06'
				                                       ,'PTLT07','PTLT08','PTLT09','PTLT10','PTLT11','PTLT12','PTLT13'
				                                       ,'PTLT14','PTLT15','PTLT16','PTLT17','PTLT18','PTLT19','PTLT20']);
		gridList.setReadOnly("gridList", true, ['LOTA06']);
		gridList.setReadOnly("gridWorkList", true, ['LOTA06']);
		gridList.setReadOnly("gridStockList", true, ['LOTA06']);
		gridList.setReadOnly("gridConfirmList", true, ['LOTA06']);
		
		gridList.resetGrid("gridList");
		gridList.resetGrid("gridWorkList");
		gridList.resetGrid("gridStockList");
		gridList.resetGrid("gridConfirmList");
				
 		$(':button[name="fnMove"]').attr("disabled",false);
 		$(':button[name="fnAuto"]').attr("disabled",true);
 		$(':button[name="fnAutoCan"]').attr("disabled",true);
 		$(':button[name="fnStok"]').attr("disabled",true);
 		$(':button[name="fnStokCan"]').attr("disabled",true);
 		$(':button[name="fnSave"]').attr("disabled",true);
 		
 		
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
		

// 		$('#searchArea').searchPop("focus", "true");

		
		gridList.resetGrid("gridHeadList");		
		gridList.gridList({
			id : "gridHeadList",
			param : param
		});
				
// 		uiList.setActive("Work", false);
				
	}
	
// 	function gridListEventDataBindEnd(gridId, dataCount){
// 		if(gridId == "gridList" && dataCount>0 && searchType){
// 			var param = inputList.setRangeParam("searchArea");
// 			gridList.gridList({
// 				id : "gridHeadList",
// 				param : param
// 			});		
// 			$('.tabs').tabs("option", "active", 0);
// // 			uiList.setActive("Work", false);
// 			gridList.setReadOnly("gridList", true, ['LOTA06']);
// 			gridList.setReadOnly("gridWorkList", true, ['LOTA06']);
// 			gridList.setReadOnly("gridStockList", true, ['LOTA06']);
// 			gridList.setReadOnly("gridConfirmList", true, ['LOTA06']);
// 		}else if(gridId == "gridConfirmList"){
// 			var copyCnt = gridList.getGridDataCount("gridConfirmList");
// 			gridList.checkAll("gridConfirmList", true);
// 		}	
// 	}

	function gridListEventDataBindEnd(gridId, dataCount){
		 if(gridId == "gridConfirmList"){
			gridList.checkAll("gridConfirmList", true);
		 } else if (gridId == "gridList" && dataCount == 0){ 
			$('#showPop').click();
		 }
	}

	
	function print(){
		var url = "";
		var prtseq = "";
		
		var head = gridList.getSelectData("gridList");
		var taskky = gridList.getSelectData("gridList", 0, "TASKKY");
		//var list = gridList.getSelectRowNumList("gridHeadList");

		//taskky = gridList.getColData("gridHeadList", 0, "TASKKY");
		var param = new DataMap();
		//param.put("head",head);
		
		
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SEQPRTSEQ",
			sendType : "map",
			param : param
		});
		
		var prtseq = json.data["PRTSEQ"];
		param.put("PRTSEQ", prtseq);
		
		var json = netUtil.sendData({
			url : "/wms/inbound/json/savePrtseq.data",
			param : param
		});
		param.put("head",head);
		param.put("TASKKY",taskky);

		alert(taskky);
		
		var where =   "AND TASKKY IN ('" + taskky + "')";

		url = "/ezgen/putaway_list.ezg";
		
		WriteEZgenElement(url, where, "", '<%= langky%>', map, 900, 650);
	}
	
	function tagPrint(){
		var url = "";
		var taskky ;
		
		//var list = gridList.getSelectRowNumList("gridHeadList");

		taskky = gridList.getColData("gridHeadList", 0, "TASKKY");
		var where =   "AND TI.TASKKY IN ('" + taskky + "')";

		url = "/ezgen/receiving_tag.ezg";
		
		var map = new DataMap();
		WriteEZgenElement(url, where, "", '<%= langky%>', map, 900, 650);
	}
	
	// 1->2번 탭이동
	function fnMoveWorkTab(){
		
		gridList.resetGrid("gridWorkList");
		gridList.resetGrid("gridStockList");
		gridList.resetGrid("gridConfirmList");
		
		var selectRow = gridList.getSelectRowNumList("gridList");
		if(selectRow.length < 1){
			commonUtil.msgBox("TASK_M0003");
			return false;
		}
		
		if(gridList.validationCheck("gridList", "select")){
			
			gridList.copyData("gridList", "gridWorkList", "select");
			gridList.checkAll("gridWorkList", true);
			
			var gridData = 	gridList.getSelectData("gridWorkList");
			var workType = $(':radio[name="recordSum"]:checked').val();		
			
			if(workType == "2"){
				var dataRowMap = new DataMap();
				var LOTNUM;
				var rowData;
				var tmpData;
				var tmpQty;
				for(var i=0;i<gridData.length;i++){
					rowData = gridData[i];
					LOTNUM = rowData.get("LOTNUM")+rowData.get("LOCASR")+rowData.get("TRNUSR");
					
					if(dataRowMap.containsKey(LOTNUM)){
						tmpData = dataRowMap.get(LOTNUM);
						
						tmpQty = (Number)(tmpData.get("QTSAVLB")) + (Number)(rowData.get("QTSAVLB"));
						tmpData.put("QTSAVLB",tmpQty);
						
						tmpQty = (Number)(tmpData.get("QTTAOR")) + (Number)(rowData.get("QTTAOR"));
						tmpData.put("QTTAOR",tmpQty);
					}else{
						dataRowMap.put(LOTNUM, gridData[i]);
					}
				}
				gridList.resetGrid("gridWorkList");
				
				var keys = dataRowMap.keys();
				for(var i=0; i<keys.length; i++){
					gridList.setAddRow("gridWorkList", dataRowMap.get(keys[i]));
				}
			}
			gridList.setReadOnly("gridList");
	 		$(':button[name="fnMove"]').attr("disabled",true);
	 		$(':button[name="fnAuto"]').attr("disabled",false);
	 		$(':button[name="fnAutoCan"]').attr("disabled",false);
	 		
			$('#bottomTabs').tabs("option", "active", 1);			
			gridList.checkAll("gridWorkList", true);
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print"){
			print();
		}else if(btnName == "Print1"){
			tagPrint();
		}else if(btnName == "Work"){
			fnSaveEnd();
		}
	}
	
	// 2->3번 탭이동 Auto Palletzing
	function fnAutoPalletzing(){

		gridList.resetGrid("gridStockList");
		gridList.resetGrid("gridConfirmList");

		var chkRowCnt = gridList.getSelectRowNumList("gridWorkList").length;
		var chkRowIdx = gridList.getSelectRowNumList("gridWorkList");
		
		if(chkRowCnt < 1){
			commonUtil.msgBox("TASK_M0003");
			return false;
		}
		
		var addRowCnt = 0;
		var qtsiwhMap = new DataMap();
		var qttaorMap = new DataMap();
				
		for(var i = 0; i < chkRowCnt; i++){
    		// 작업수량 가용수량 비교
    		var workSum = gridList.getColData("gridWorkList", chkRowIdx[i],"QTSAVLB");
    		var workAor = gridList.getColData("gridWorkList", chkRowIdx[i],"QTTAOR");
    		var workuom = gridList.getColData("gridWorkList", chkRowIdx[i],"QTPUOM");
    		var skukey = gridList.getColData("gridWorkList", chkRowIdx[i],"SKUKEY");
    		var STOKKY = gridList.getColData("gridWorkList", chkRowIdx[i],"STOKKY");
    		

    		if(qtsiwhMap.containsKey(STOKKY)){
    			var sumQttaor = (Number)(qttaorMap.get(STOKKY)) + (Number)(workAor);
    			qttaorMap.put(STOKKY, sumQttaor);
    		}else{
        		qtsiwhMap.put(STOKKY, workSum);
    			qttaorMap.put(STOKKY, workAor);
    		}
			
    		if((Number)(workSum) < (Number)(workAor)){   		        		
    			commonUtil.msgBox("TASK_M0023",[skukey,workAor,workSum]);
    			return false;
    		}
    		
    		if(workAor == "" || (Number)(workAor) < 1 ){
    			commonUtil.msgBox("TASK_M0019",skukey);
    			return false;
			}
    		
    		if(workuom == null || workuom == "NaN" || workuom == "null" || workuom.trim() == ""){
    			workuom = 9999999999;
    		}
    		
    		// 작업 수량/Unit 값으로 나눈 몫 만큼 행생성. 나머지가 있을경우 1행을 더 추가한다.
 			var divsion = Math.ceil(workAor / workuom) ;   		
			for(var j = 0; j < divsion; j++){
				gridList.setAddRow("gridStockList",gridList.getRowData("gridWorkList", chkRowIdx[i]));
				if(j != divsion - 1 || (workAor % workuom) == 0){
					gridList.setColValue("gridStockList", addRowCnt, "QTTAOR", (workuom));
				}else{
					gridList.setColValue("gridStockList", addRowCnt, "QTTAOR", workAor % workuom);
				}
				addRowCnt++;
			}
    	}
    	
		var keys = qtsiwhMap.keys();
		for(var i=0; i<keys.length; i++){
			var sumQtsiwh = qtsiwhMap.get(keys[i]);
			var sumQttaor = qttaorMap.get(keys[i])

	    	if((Number)(sumQtsiwh) < (Number)(sumQttaor)){  
				commonUtil.msgBox("TASK_M0023",[skukey,sumQttaor,sumQtsiwh]);
	    		gridList.resetGrid("gridStockList");
				return false;
	    	}
		}   
		gridList.setReadOnly("gridWorkList");
// 		uiList.setActive("Work", false);
		
 		$(':button[name="fnAuto"]').attr("disabled",true);
 		$(':button[name="fnAutoCan"]').attr("disabled",true);
 		$(':button[name="fnStok"]').attr("disabled",false); 
 		$(':button[name="fnStokCan"]').attr("disabled",false);
	
		$('#bottomTabs').tabs("option", "active", 2);
	}
	
	function fnWorkCancle(){
		gridList.resetGrid("gridWorkList");
		gridList.resetGrid("gridStockList");
		
		gridList.resetGridReadOnly("gridList");
		gridList.setReadOnly("gridList", true, ['LOTA06']);

		$('#bottomTabs').tabs("option", "active", 0);
 		$(':button[name="fnMove"]').attr("disabled",false);
 		$(':button[name="fnAuto"]').attr("disabled",true);
 		$(':button[name="fnAutoCan"]').attr("disabled",true);			
	}
	
	
	function fnStockCancle(){
		gridList.resetGrid("gridStockList");		
		gridList.resetGridReadOnly("gridWorkList");
		gridList.setReadOnly("gridWorkList", true, ['LOTA06']);

		$('#bottomTabs').tabs("option", "active", 1);
 		$(':button[name="fnAuto"]').attr("disabled",false);
 		$(':button[name="fnAutoCan"]').attr("disabled",false);
 		$(':button[name="fnStok"]').attr("disabled",true);
 		$(':button[name="fnStokCan"]').attr("disabled",true);		
	}
	
	function fnStockDocNum(){
		
		gridList.resetGrid("gridConfirmList");

		var chkRowCnt = gridList.getGridData("gridStockList").length;
		var chkRowIdx = gridList.getGridData("gridStockList");
		var qtsiwhMap = new DataMap();
		var qttaorMap = new DataMap();
		var skukeyMap = new DataMap();

		
		// 화면 작업수량 가용수량 비교
		for(var i = 0; i < chkRowCnt; i++){
    		var workSum = gridList.getColData("gridStockList", chkRowIdx[i].get("GRowNum"),"QTSAVLB");
    		var workAor = gridList.getColData("gridStockList", chkRowIdx[i].get("GRowNum"),"QTTAOR");
    		var skukey  = gridList.getColData("gridStockList", chkRowIdx[i].get("GRowNum"),"SKUKEY");
    		var STOKKY  = gridList.getColData("gridStockList", chkRowIdx[i].get("GRowNum"),"STOKKY");
    		
    		if(qtsiwhMap.containsKey(STOKKY)){
    			var sumQttaor = (Number)(qttaorMap.get(STOKKY)) + (Number)(workAor);
    			qttaorMap.put(STOKKY, sumQttaor);
    		}else{
        		qtsiwhMap.put(STOKKY, workSum);
    			qttaorMap.put(STOKKY, workAor);
        		skukeyMap.put(STOKKY, skukey);
    		}
			
    		if((Number)(workSum) < (Number)(workAor)){   		        		
    			commonUtil.msgBox("TASK_M0023",[skukey,workAor,workSum]);			//상품는 작업수량이 가용재고 수량을 초과하였습니다.
    			return false;
    		}
    		
    		if(workAor == "" || (Number)(workAor) < 1 ){
    			commonUtil.msgBox("TASK_M0019",skukey);								//상품의 작업수량은 1보다 작을수 없습니다.		
    			return false;
			}
    	}
		
		var keys = qtsiwhMap.keys();
		for(var i=0; i<keys.length; i++){
			var sumQtsiwh = qtsiwhMap.get(keys[i]);
			var sumQttaor = qttaorMap.get(keys[i]);
			var rowSkukey = skukeyMap.get(keys[i]);

	    	if((Number)(sumQtsiwh) < (Number)(sumQttaor)){  
				commonUtil.msgBox("TASK_M0023",[rowSkukey,sumQttaor,sumQtsiwh]);		//상품는 작업수량이 가용재고 수량을 초과하였습니다.
				return false;
	    	}
		}   		
				
		// 적치지시 마스터 데이터 밸리데이션
		var list = gridList.getGridData("gridStockList");
		var vparam = new DataMap();
		vparam.put("list", list);
		vparam.put("key", "LOCATG,STOKKY,OWNRKY,SKUKEY,PTLT01,PTLT02,PTLT03,QTTAOR,WAREKY,PASTKY");
		
		var json = netUtil.sendData({
			url : "/wms/task/json/PT01MasterValidation.data",
			param : vparam
		});
		
		if(json.data != "OK"){
			var msgList = json.data.split(" ");
			var msgTxt = commonUtil.getMsg(msgList[0], msgList.pop());
			commonUtil.msg(msgTxt);															//상품,전략,로케이션 에러 메세지
			return false;
		}
		
		// 적치지시 DB 가용재고 밸리데이션
		var workType = $(':radio[name="recordSum"]:checked').val();				
		var chkQtsMap = new DataMap();
				
		for(var i = 0; i < chkRowCnt; i++){
    		var qttaor = gridList.getColData("gridStockList", chkRowIdx[i].get("GRowNum"),"QTTAOR");
    		var wareky = gridList.getColData("gridStockList", chkRowIdx[i].get("GRowNum"),"WAREKY");
    		var lotnum = gridList.getColData("gridStockList", chkRowIdx[i].get("GRowNum"),"LOTNUM");
    		var locasr = gridList.getColData("gridStockList", chkRowIdx[i].get("GRowNum"),"LOCASR");
    		var trnusr = gridList.getColData("gridStockList", chkRowIdx[i].get("GRowNum"),"TRNUSR");
    		var stokky = gridList.getColData("gridStockList", chkRowIdx[i].get("GRowNum"),"STOKKY"); 
    		
    		if (workType == "2") {
    			stokky = "%"
    		}
    		
    		var lotxlocxid  = lotnum + locasr + trnusr + stokky;
    		if(chkQtsMap.containsKey(lotxlocxid)){
    			var TotQttaor = (Number)(chkQtsMap.get(lotxlocxid)[5]) + (Number)(qttaor);
    			chkQtsMap.put(lotxlocxid, [wareky, lotnum, locasr, trnusr, stokky, TotQttaor]);
    		}else{
        		chkQtsMap.put(lotxlocxid, [wareky, lotnum, locasr, trnusr, stokky, qttaor] );
    		}
    	}		
				
		var param = new DataMap();		
		param.put("list",chkQtsMap);
		
		var json = netUtil.sendData({
			url : "/wms/task/json/PT01StockValidation.data",
			param : param
		});
	
		if(json.data != "OK"){
			var msgList = json.data.split("†");
 			var msgTxt = commonUtil.getMsg(msgList[0], (msgList.length > 1 ? msgList[1].split("/") : null));
			commonUtil.msg(msgTxt);
			return;
		}
	
		// 입고지시 저장
		var docunum = wms.getDocSeq("310");
		gridList.gridColModify("gridHeadList", 0, "TASKKY", docunum);
		
		var head = gridList.getRowData("gridHeadList", 0);		
		var param = new DataMap();
		param.put("head", head);
		param.put("list", list);
		param.put("workType", workType);
		
		
		json = netUtil.sendData({
			url : "/wms/task/json/PT01StockSave.data",
			param : param
		});
		
		if(json.data.length != 10){
			gridList.gridColModify("gridHeadList", 0, "TASKKY", " ");
			alert(json.data);
			return;
		}
		
		if(json && json.data){
			commonUtil.msgBox("TASK_M0007", docunum);
		}
		
 		searchType = false;
		
		// 입고지시후 적치완료 데이터 조회
		var paramH = new DataMap();
			paramH.put("TASKKY", docunum);			
		gridList.gridList({
	    	id : "gridHeadList",
	    	command : "PT01HEAD",
	    	param : paramH
	    });
				
		gridList.gridList({
	    	id : "gridConfirmList",
	    	command : "PT01STOCKSUB",
	    	param : paramH
	    }); 
		
		gridList.setReadOnly("gridStockList");
		gridList.setReadOnly("gridHeadList");
		
 		$(':button[name="fnStok"]').attr("disabled",true);
 		$(':button[name="fnStokCan"]').attr("disabled",true);
 		$(':button[name="fnSave"]').attr("disabled",false);
 		
		$('#bottomTabs').tabs("option", "active", 3);
// 		uiList.setActive("Work", true);
		
	}
	
	function fnSaveEnd(){
// 		if(gridList.validationCheck("gridConfirmList", "all")){
		
			var chkRowCnt = gridList.getSelectRowNumList("gridConfirmList").length;
			var chkRowIdx = gridList.getSelectRowNumList("gridConfirmList");			
			if(chkRowCnt < 1){
				commonUtil.msgBox("COMMON_M0048"); 						 		//작업 대상이 선택되지 않았습니다.
				return false;
			}			
			
			if(commonUtil.msgConfirm("HHT_T0007")){								//저장하시겠습니까?
				// 밸리데이션 체크-수량,지번 
				for(var i = 0; i < chkRowCnt; i++){
					var taskit = gridList.getColData("gridConfirmList", chkRowIdx[i], "TASKIT");
					var qtcomp = gridList.getColData("gridConfirmList", chkRowIdx[i], "QTCOMP");
					var qttaor = gridList.getColData("gridConfirmList", chkRowIdx[i], "QTTAOR");					
					var locaac = gridList.getColData("gridConfirmList", chkRowIdx[i], "LOCAAC");					
					if ( parseInt(qtcomp) > parseInt(qttaor) ){
						commonUtil.msgBox("TASK_M0062",[taskit,qttaor,qtcomp]);	//작업아이템번호의 완료량이 지시량이 많습니다.
						return false;					
					}
		    		if(locaac == null || locaac == "NaN" || locaac == "null" || locaac.trim() == ""){
		    			commonUtil.msgBox("TASK_M0063",taskit);					//작업아이템번호의 지번이 입력되지 않았습니다.
						return false;			    		}
				}
				
   				// 지번 밸리데이션
 				var head = gridList.getRowData("gridHeadList", 0);
 				var list = gridList.getSelectData("gridConfirmList");				
				var param = new DataMap();
 				param.put("head", head);
				param.put("list", list);
				var json = netUtil.sendData({
					url : "/wms/task/json/PTLocacValidation.data",			
					param : param
				});								
				if(json.data != "OK"){
					var msgList = json.data.split("†");
		 			var msgTxt = commonUtil.getMsg(msgList[0], (msgList.length > 1 ? msgList[1].split("/") : null));
					commonUtil.msg(msgTxt);										//작업아이템번호에 입력된 지번은 등록되지 않았습니다.
					return;
				}
				
				var workType = $(':radio[name="recordSum"]:checked').val();				
				param.put("workType", workType);				
				json = netUtil.sendData({
					url : "/wms/task/json/PT01SaveEnd.data",
					param : param
				});				
				if(json && json.data){
						commonUtil.msgBox("MASTER_M0564");						// 저장 완료되었습니다.						
						var paramH = new DataMap();
						paramH.put("TASKKY", gridList.getColData("gridHeadList", 0, "TASKKY"));
					
						gridList.gridList({
					    	id : "gridConfirmList",
					    	command : "PT01STOCKSUB",
					    	param : paramH
					    }); 						
						gridList.setReadOnly("gridHeadList");
						gridList.setReadOnly("gridConfirmList");
					}
// 				uiList.setActive("Work", false);
		 		$(':button[name="fnSave"]').attr("disabled",true);
				
			}
// 		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		
		var newData = new DataMap();
		var idx = gridList.getSelectIndex(gridId);
		
		var wareky = gridList.getColData(gridId, idx, "WAREKY");
		var stokky = gridList.getColData(gridId, idx, "STOKKY");
		var taskty = gridList.getColData(gridId, idx, "TASKTY");
		var statit = gridList.getColData(gridId, idx, "STATIT");
		var qtsavlb = gridList.getColData(gridId, idx, "QTSAVLB");
		var qttaor = gridList.getColData(gridId, idx, "QTTAOR");
		var qtcomp = gridList.getColData(gridId, idx, "QTCOMP");
		var locaac = gridList.getColData(gridId, idx, "LOCAAC");
		var trnuac = gridList.getColData(gridId, idx, "TRNUAC");
		var alstky = gridList.getColData(gridId, idx, "ALSTKY");
		var actcdt = gridList.getColData(gridId, idx, "ACTCDT");
		var actcti = gridList.getColData(gridId, idx, "ACTCTI");
		var qtpuom = gridList.getColData(gridId, idx, "QTPUOM");
		var locasr = gridList.getColData(gridId, idx, "LOCASR");
		var sectsr = gridList.getColData(gridId, idx, "SECTSR");
		var paidsr = gridList.getColData(gridId, idx, "PAIDSR");
		var trnusr = gridList.getColData(gridId, idx, "TRNUSR");
		var struty = gridList.getColData(gridId, idx, "STRUTY");
		var smeaky = gridList.getColData(gridId, idx, "SMEAKY");
		var suomky = gridList.getColData(gridId, idx, "SUOMKY");
		var qtspum = gridList.getColData(gridId, idx, "QTSPUM");
		var sduoky = gridList.getColData(gridId, idx, "SDUOKY");
		var qtsdum = gridList.getColData(gridId, idx, "QTSDUM");
		var locatg = gridList.getColData(gridId, idx, "LOCATG");
		var secttg = gridList.getColData(gridId, idx, "SECTTG");
		var paidtg = gridList.getColData(gridId, idx, "PAIDTG");
		var trnutg = gridList.getColData(gridId, idx, "TRNUTG");
		var ttruty = gridList.getColData(gridId, idx, "TTRUTY");
		var tmeaky = gridList.getColData(gridId, idx, "TMEAKY");
		var tuomky = gridList.getColData(gridId, idx, "TUOMKY");
		var qttpum = gridList.getColData(gridId, idx, "QTTPUM");
		var tduoky = gridList.getColData(gridId, idx, "TDUOKY");
		var qttdum = gridList.getColData(gridId, idx, "QTTDUM");
		var ownrky = gridList.getColData(gridId, idx, "OWNRKY");
		var skukey = gridList.getColData(gridId, idx, "SKUKEY");
		var lotnum = gridList.getColData(gridId, idx, "LOTNUM");
		var refdky = gridList.getColData(gridId, idx, "REFDKY");
		var refdit = gridList.getColData(gridId, idx, "REFDIT");
		var refcat = gridList.getColData(gridId, idx, "REFCAT");
		var refdat = gridList.getColData(gridId, idx, "REFDAT");
		var purcky = gridList.getColData(gridId, idx, "PURCKY");
		var purcit = gridList.getColData(gridId, idx, "PURCIT");
		var asndky = gridList.getColData(gridId, idx, "ASNDKY");
		var asndit = gridList.getColData(gridId, idx, "ASNDIT");
		var recvky = gridList.getColData(gridId, idx, "RECVKY");
		var recvit = gridList.getColData(gridId, idx, "RECVIT");
		var shpoky = gridList.getColData(gridId, idx, "SHPOKY");
		var shpoit = gridList.getColData(gridId, idx, "SHPOIT");
		var grpoky = gridList.getColData(gridId, idx, "GRPOKY");
		var grpoit = gridList.getColData(gridId, idx, "GRPOIT");
		var sadjky = gridList.getColData(gridId, idx, "SADJKY");
		var sadjit = gridList.getColData(gridId, idx, "SADJIT");
		var sdifky = gridList.getColData(gridId, idx, "SDIFKY");
		var sdifit = gridList.getColData(gridId, idx, "SDIFIT");
		var phyiky = gridList.getColData(gridId, idx, "PHYIKY");
		var phyiit = gridList.getColData(gridId, idx, "PHYIIT");
		var desc01 = gridList.getColData(gridId, idx, "DESC01");
		var desc02 = gridList.getColData(gridId, idx, "DESC02");
		var asku01 = gridList.getColData(gridId, idx, "ASKU01");
		var asku02 = gridList.getColData(gridId, idx, "ASKU02");
		var asku03 = gridList.getColData(gridId, idx, "ASKU03");
		var asku04 = gridList.getColData(gridId, idx, "ASKU04");
		var asku05 = gridList.getColData(gridId, idx, "ASKU05");
		var eancod = gridList.getColData(gridId, idx, "EANCOD");
		var gtincd = gridList.getColData(gridId, idx, "GTINCD");
		var skug01 = gridList.getColData(gridId, idx, "SKUG01");
		var skug02 = gridList.getColData(gridId, idx, "SKUG02");
		var skug03 = gridList.getColData(gridId, idx, "SKUG03");
		var skug04 = gridList.getColData(gridId, idx, "SKUG04");
		var skug05 = gridList.getColData(gridId, idx, "SKUG05");
		var grswgt = gridList.getColData(gridId, idx, "GRSWGT");
		var netwgt = gridList.getColData(gridId, idx, "NETWGT");
		var wgtunt = gridList.getColData(gridId, idx, "WGTUNT");
		var length = gridList.getColData(gridId, idx, "LENGTH");
		var widthw = gridList.getColData(gridId, idx, "WIDTHW");
		var height = gridList.getColData(gridId, idx, "HEIGHT");
		var cubicm = gridList.getColData(gridId, idx, "CUBICM");
		var capact = gridList.getColData(gridId, idx, "CAPACT");
		var areaky = gridList.getColData(gridId, idx, "AREAKY");
		var lota01 = gridList.getColData(gridId, idx, "LOTA01");
		var lota02 = gridList.getColData(gridId, idx, "LOTA02");
		var lota03 = gridList.getColData(gridId, idx, "LOTA03");
		var lota04 = gridList.getColData(gridId, idx, "LOTA04");
		var lota05 = gridList.getColData(gridId, idx, "LOTA05");
		var lota06 = gridList.getColData(gridId, idx, "LOTA06");
		var lota07 = gridList.getColData(gridId, idx, "LOTA07");
		var lota08 = gridList.getColData(gridId, idx, "LOTA08");
		var lota09 = gridList.getColData(gridId, idx, "LOTA09");
		var lota10 = gridList.getColData(gridId, idx, "LOTA10");
		var lota11 = gridList.getColData(gridId, idx, "LOTA11");
		var lota12 = gridList.getColData(gridId, idx, "LOTA12");
		var lota13 = gridList.getColData(gridId, idx, "LOTA13");
		var lota14 = gridList.getColData(gridId, idx, "LOTA14");
		var lota15 = gridList.getColData(gridId, idx, "LOTA15");
		var lota16 = gridList.getColData(gridId, idx, "LOTA16");
		var lota17 = gridList.getColData(gridId, idx, "LOTA17");
		var lota18 = gridList.getColData(gridId, idx, "LOTA18");
		var lota19 = gridList.getColData(gridId, idx, "LOTA19");
		var lota20 = gridList.getColData(gridId, idx, "LOTA20");
		var awmsno = gridList.getColData(gridId, idx, "AWMSNO");
		var smandt = gridList.getColData(gridId, idx, "SMANDT");
		var sebeln = gridList.getColData(gridId, idx, "SEBELN");
		var sebelp = gridList.getColData(gridId, idx, "SEBELP");
		var svbeln = gridList.getColData(gridId, idx, "SVBELN");
		var smblnr = gridList.getColData(gridId, idx, "SMBLNR");
		var smjahr = gridList.getColData(gridId, idx, "SMJAHR");
		var szeile = gridList.getColData(gridId, idx, "SZEILE");
		var szmipno = gridList.getColData(gridId, idx, "SZMIPNO");
		var sposnr = gridList.getColData(gridId, idx, "SPOSNR");
		var stknum = gridList.getColData(gridId, idx, "STKNUM");
		var stpnum = gridList.getColData(gridId, idx, "STPNUM");
		var slgort = gridList.getColData(gridId, idx, "SLGORT");
		var swerks = gridList.getColData(gridId, idx, "SWERKS");
		var stdlnr = gridList.getColData(gridId, idx, "STDLNR");
		var straid = gridList.getColData(gridId, idx, "STRAID");
		var ssornu = gridList.getColData(gridId, idx, "SSORNU");
		var ssorit = gridList.getColData(gridId, idx, "SSORIT");
		var sxblnr = gridList.getColData(gridId, idx, "SXBLNR");
		var ptlt01 = gridList.getColData(gridId, idx, "PTLT01");
		var ptlt02 = gridList.getColData(gridId, idx, "PTLT02");
		var ptlt03 = gridList.getColData(gridId, idx, "PTLT03");
		var ptlt04 = gridList.getColData(gridId, idx, "PTLT04");
		var ptlt05 = gridList.getColData(gridId, idx, "PTLT05");
		var ptlt06 = gridList.getColData(gridId, idx, "PTLT06");
		var ptlt07 = gridList.getColData(gridId, idx, "PTLT07");
		var ptlt08 = gridList.getColData(gridId, idx, "PTLT08");
		var ptlt09 = gridList.getColData(gridId, idx, "PTLT09");
		var ptlt10 = gridList.getColData(gridId, idx, "PTLT10");
		var ptlt11 = gridList.getColData(gridId, idx, "PTLT11");
		var ptlt12 = gridList.getColData(gridId, idx, "PTLT12");
		var ptlt13 = gridList.getColData(gridId, idx, "PTLT13");
		var ptlt14 = gridList.getColData(gridId, idx, "PTLT14");
		var ptlt15 = gridList.getColData(gridId, idx, "PTLT15");
		var ptlt16 = gridList.getColData(gridId, idx, "PTLT16");
		var ptlt17 = gridList.getColData(gridId, idx, "PTLT17");
		var ptlt18 = gridList.getColData(gridId, idx, "PTLT18");
		var ptlt19 = gridList.getColData(gridId, idx, "PTLT19");
		var ptlt20 = gridList.getColData(gridId, idx, "PTLT20");
		var pastky = gridList.getColData(gridId, idx, "PASTKY");
		var szmblno = gridList.getColData(gridId, idx, "SZMBLNO");
		var sdatbg = gridList.getColData(gridId, idx, "SDATBG");
		var taskit = gridList.getColData(gridId, idx, "TASKIT");
		var taskky = gridList.getColData(gridId, idx, "TASKKY");
		
		if(gridId == "gridWorkList" || gridId == "gridStockList"){
			newData.put("WAREKY", wareky);
			newData.put("STOKKY", stokky);
			newData.put("TASKTY", taskty);
			newData.put("STATIT", statit);
			newData.put("QTSAVLB", qtsavlb);
			newData.put("QTTAOR", qttaor);
			newData.put("QTCOMP", qtcomp);
			newData.put("LOCAAC", locaac);
			newData.put("TRNUAC", trnuac);
			newData.put("ALSTKY", alstky);
			newData.put("ACTCDT", actcdt);
			newData.put("ACTCTI", actcti);
			newData.put("QTPUOM", qtpuom);
			newData.put("LOCASR", locasr);
			newData.put("SECTSR", sectsr);
			newData.put("PAIDSR", paidsr);
			newData.put("TRNUSR", trnusr);
			newData.put("STRUTY", struty);
			newData.put("SMEAKY", smeaky);
			newData.put("SUOMKY", suomky);
			newData.put("QTSPUM", qtspum);
			newData.put("SDUOKY", sduoky);
			newData.put("QTSDUM", qtsdum);
			newData.put("LOCATG", locatg);
			newData.put("SECTTG", secttg);
			newData.put("PAIDTG", paidtg);
			newData.put("TRNUTG", trnutg);
			newData.put("TTRUTY", ttruty);
			newData.put("TMEAKY", tmeaky);
			newData.put("TUOMKY", tuomky);
			newData.put("QTTPUM", qttpum);
			newData.put("TDUOKY", tduoky);
			newData.put("QTTDUM", qttdum);
			newData.put("OWNRKY", ownrky);
			newData.put("SKUKEY", skukey);
			newData.put("LOTNUM", lotnum);
			newData.put("REFDKY", refdky);
			newData.put("REFDIT", refdit);
			newData.put("REFCAT", refcat);
			newData.put("REFDAT", refdat);
			newData.put("PURCKY", purcky);
			newData.put("PURCIT", purcit);
			newData.put("ASNDKY", asndky);
			newData.put("ASNDIT", asndit);
			newData.put("RECVKY", recvky);
			newData.put("RECVIT", recvit);
			newData.put("SHPOKY", shpoky);
			newData.put("SHPOIT", shpoit);
			newData.put("GRPOKY", grpoky);
			newData.put("GRPOIT", grpoit);
			newData.put("SADJKY", sadjky);
			newData.put("SADJIT", sadjit);
			newData.put("SDIFKY", sdifky);
			newData.put("SDIFIT", sdifit);
			newData.put("PHYIKY", phyiky);
			newData.put("PHYIIT", phyiit);
			newData.put("DESC01", desc01);
			newData.put("DESC02", desc02);
			newData.put("ASKU01", asku01);
			newData.put("ASKU02", asku02);
			newData.put("ASKU03", asku03);
			newData.put("ASKU04", asku04);
			newData.put("ASKU05", asku05);
			newData.put("EANCOD", eancod);
			newData.put("GTINCD", gtincd);
			newData.put("SKUG01", skug01);
			newData.put("SKUG02", skug02);
			newData.put("SKUG03", skug03);
			newData.put("SKUG04", skug04);
			newData.put("SKUG05", skug05);
			newData.put("GRSWGT", grswgt);
			newData.put("NETWGT", netwgt);
			newData.put("WGTUNT", wgtunt);
			newData.put("LENGTH", length);
			newData.put("WIDTHW", widthw);
			newData.put("HEIGHT", height);
			newData.put("CUBICM", cubicm);
			newData.put("CAPACT", capact);
			newData.put("AREAKY", areaky);
			newData.put("LOTA01", lota01);
			newData.put("LOTA02", lota02);
			newData.put("LOTA03", lota03);
			newData.put("LOTA04", lota04);
			newData.put("LOTA05", lota05);
			newData.put("LOTA06", lota06);
			newData.put("LOTA07", lota07);
			newData.put("LOTA08", lota08);
			newData.put("LOTA09", lota09);
			newData.put("LOTA10", lota10);
			newData.put("LOTA11", lota11);
			newData.put("LOTA12", lota12);
			newData.put("LOTA13", lota13);
			newData.put("LOTA14", lota14);
			newData.put("LOTA15", lota15);
			newData.put("LOTA16", lota16);
			newData.put("LOTA17", lota17);
			newData.put("LOTA18", lota18);
			newData.put("LOTA19", lota19);
			newData.put("LOTA20", lota20);
			newData.put("AWMSNO", awmsno);
			newData.put("SMANDT", smandt);
			newData.put("SEBELN", sebeln);
			newData.put("SEBELP", sebelp);
			newData.put("SVBELN", svbeln);
			newData.put("SMBLNR", smblnr);
			newData.put("SMJAHR", smjahr);
			newData.put("SZEILE", szeile);
			newData.put("SZMIPNO", szmipno);
			newData.put("SPOSNR", sposnr);
			newData.put("STKNUM", stknum);
			newData.put("STPNUM", stpnum);
			newData.put("SLGORT", slgort);
			newData.put("SWERKS", swerks);
			newData.put("STDLNR", stdlnr);
			newData.put("STRAID", straid);
			newData.put("SSORNU", ssornu);
			newData.put("SSORIT", ssorit);
			newData.put("SXBLNR", sxblnr);
			newData.put("PTLT01", ptlt01);
			newData.put("PTLT02", ptlt02);
			newData.put("PTLT03", ptlt03);
			newData.put("PTLT04", ptlt04);
			newData.put("PTLT05", ptlt05);
			newData.put("PTLT06", ptlt06);
			newData.put("PTLT07", ptlt07);
			newData.put("PTLT08", ptlt08);
			newData.put("PTLT09", ptlt09);
			newData.put("PTLT10", ptlt10);
			newData.put("PTLT11", ptlt11);
			newData.put("PTLT12", ptlt12);
			newData.put("PTLT13", ptlt13);
			newData.put("PTLT14", ptlt14);
			newData.put("PTLT15", ptlt15);
			newData.put("PTLT16", ptlt16);
			newData.put("PTLT17", ptlt17);
			newData.put("PTLT18", ptlt18);
			newData.put("PTLT19", ptlt19);
			newData.put("PTLT20", ptlt20);
			newData.put("PASTKY", pastky);
			newData.put("SZMBLNO", szmblno);
			newData.put("SDATBG", sdatbg);
			newData.put("TASKIT", taskit);
			newData.put("TASKKY", taskky);

		}
		
		return newData;
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHLOCMA" || searchCode == "SHLOCMA_TG"){
			var param = dataBind.paramData("searchArea");
			param.put("AREAKY", param.get("AREA"));
			return param;
		}else if(searchCode == "SHSKUMA"){
			var param = dataBind.paramData("searchArea");
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId=="gridConfirmList" && colName=="LOCAAC"){
			if(colValue != ""){
				var param = new DataMap();
				param.put("LOCAKY", colValue);
				param.put("WAREKY", gridList.getColData(gridId, rowNum, "WAREKY"));
				
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "LOCMAval",
					sendType : "map",
					param : param
				});

				if(json.data["LOCAKY"] < 1){
					commonUtil.msgBox("TASK_M0038"); //실지번을 입력해주세요.
					return;
				}
			}
		}
	}
	
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
 	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop" id="searchArea">

	<button type="button" class="closer">X</button>

	<div class="searchInnerContainer">

		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
		</p>

		<div class="searchInBox">
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">거점</th>
						<td colspan="3">
							<input type="text" name="WAREKY" value="<%=wareky%>" size="8px" readonly/>
						</td>
					</tr>
<!-- 					<tr> -->
<!-- 						<th CL="STD_OWNRKY">화주</th> -->
<!-- 						<td> -->
<!-- 							<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY"> -->
<!-- 							</select> -->
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<th CL="STD_AREAKY,2">입고창고</th> -->
<!-- 						<td> -->
<!-- 							<select Combo="WmsOrder,AREAKYCOMBO" name="AREA" id="AREA" validate="required"> -->
<!-- 								<option value="">선택</option> -->
<!-- 							</select> -->
<!-- 						</td> -->
<!-- 					</tr> -->
				    <tr>
						<th CL="STD_TASOTY">작업오더유형</th>
						<td>
							<select Combo="WmsTask,TK310DOCUTYCOMBO" name="TASOTY" id="TASOTY" validate="required">
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_LOTA12">입고일자</th>
						<td>
							<input type="text" name="A.LOTA12" UIInput="R" UIFormat="C" />
						</td>											
					</tr>
					<tr>
						<th CL="STD_RECVKY,3">입하문서번호2</th>
						<td>
							<input type="text" name="A.RECVKY" UIInput="R" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="searchInBox">
		<h2 class="tit type1" CL="STD_SKUINFO">품목정보</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_LOCAKY">지번</th>
						<td>
							<input type="text" name="A.LOCAKY" UIInput="R" value="RCVLOC" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUKEY">품번코드</th>
						<td>
							<input type="text" name="A.SKUKEY" UIInput="R,SHSKUMA" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DESC01">품명</th>
						<td>
							<input type="text" name="A.DESC01" UIInput="R" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- //searchPop -->

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs" CL="STD_LIST"><span>리스트</span></a></li>
					</ul>
					<div id="tabs">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<!-- <col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_TASKKY'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WAREKYNM'></th>
<!-- 												<th CL='STD_AREAKY'></th> -->
<!-- 												<th CL='STD_AREANM'></th> -->
												<th CL='STD_TASOTY'></th>
												<th CL='STD_TASOTYNM'></th>
												<th CL='STD_DOCDAT'></th>
												<th CL='STD_DOCTXT'></th>
												<!-- <th CL='STD_DOCDAT'></th>
												<th CL='STD_DOCCAT'></th>
												<th CL='STD_DRELIN'></th>
												<th CL='STD_STATDO'></th>
												<th CL='STD_QTTAOR'></th>
												<th CL='STD_QTCOMP'></th>
												<th CL='STD_TSPKEY'></th>
												<th CL='STD_KEEPTS'></th>
												<th CL='STD_WARETG'></th>
												<th CL='STD_USRID1'></th>
												<th CL='STD_UNAME1'></th>
												<th CL='STD_DEPTID1'></th>
												<th CL='STD_DNAME1'></th>
												<th CL='STD_USRID2'></th>
												<th CL='STD_UNAME2'></th>
												<th CL='STD_DEPTID2'></th>
												<th CL='STD_DNAME2'></th>
												<th CL='STD_USRID3'></th>
												<th CL='STD_UNAME3'></th>
												<th CL='STD_DEPTID3'></th>
												<th CL='STD_DNAME3'></th>
												<th CL='STD_USRID4'></th>
												<th CL='STD_UNAME4'></th>
												<th CL='STD_DEPTID4'></th>
												<th CL='STD_DNAME4'></th>
												<th CL='STD_DOCTXT'></th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_CUSRNM'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
												<th CL='STD_LUSRNM'></th> -->
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<!-- <col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" /> -->
										</colgroup>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,TASKKY"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WAREKYNM"></td>
<!-- 												<td GCol="text,AREAKY"></td> -->
<!-- 												<td GCol="text,AREAKYNM"></td> -->
												<td GCol="text,TASOTY"></td>
												<td GCol="text,TASOTYNM"></td>
												<td GCol="text,DOCDAT" GF="D"></td>
												<td GCol="input,DOCTXT"></td>
												<!-- <td GCol="text,DOCDAT"></td>
												<td GCol="text,DOCCAT"></td>
												<td GCol="text,DRELIN"></td>
												<td GCol="text,STATDO"></td>
												<td GCol="text,QTTAOR" GF="N"></td>
												<td GCol="text,QTCOMP" GF="N"></td>
												<td GCol="text,TSPKEY"></td>
												<td GCol="text,KEEPTS"></td>
												<td GCol="text,WARETG"></td>
												<td GCol="text,USRID1"></td>
												<td GCol="text,UNAME1"></td>
												<td GCol="text,DEPTID1"></td>
												<td GCol="text,DNAME1"></td>
												<td GCol="text,USRID2"></td>
												<td GCol="text,UNAME2"></td>
												<td GCol="text,DEPTID2"></td>
												<td GCol="text,DNAME2"></td>
												<td GCol="input,USRID3" GF="S 20"></td>
												<td GCol="text,UNAME3"></td>
												<td GCol="text,DEPTID3"></td>
												<td GCol="input,DNAME3" GF="S 20"></td>
												<td GCol="text,USRID4"></td>
												<td GCol="text,UNAME4"></td>
												<td GCol="text,DEPTID4"></td>
												<td GCol="text,DNAME4"></td>
												<td GCol="input,DOCTXT" GF="S 1000"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
												<td GCol="text,LUSRNM"></td> -->
											</tr>									
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">									
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs" id="bottomTabs">
					<ul class="tab type2" id="commonMiddleArea">
						<li id="liTab1-1"><a href="#tabs1-1"><span CL="STD_RECINF">입하정보</span></a></li>
						<li id="liTab1-2"><a href="#tabs1-2"><span CL="STD_SUMINFO">작업 리스트</span></a></li>
						<li id="liTab1-3"><a href="#tabs1-3"><span CL="STD_PUTWAY">적치지시</span></a></li>
						<li id="liTab1-4"><a href="#tabs1-4"><span CL="STD_CONFIRM">확인</span></a></li>
					</ul>					
					<div id="tabs1-1">
						<div class="section type1">
							<div>      
								<input type="radio" id="recordSum1" name="recordSum" value="1" checked />
								<label for="recordSum" CL="STD_BYRECORD"></label>
								<input type="radio" id="recordSum2" name="recordSum" value="2" />
								<label for="recordSum" CL="STD_SUMMARIZE"></label>
								<button class="button type1 last" type="button" name="fnMove" onclick="fnMoveWorkTab()" title="Play"><img src="/common/images/top_icon_01.png"/></button>
								<span CL='BTN_EXECUTE'>Play</span>
							</div>
							
							<div class="table type2" style="top:35px;">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th GBtnCheck="true"></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_STOKKY'></th>
												<th CL='STD_TASKTY'></th>
												<th CL='STD_STATIT'></th>
												<th CL='STD_QTSAVLB'></th>
												<th CL='STD_QTTAOR'></th>
												<th CL='STD_QTCOMP'></th>
												<th CL='STD_LOCAAC'></th>
												<th CL='STD_TRNUAC'></th>
												<th CL='STD_ALSTKY'></th>
												<th CL='STD_ACTCDT'></th>
												<th CL='STD_ACTCTI'></th>
												<th CL='STD_QTPUOM'></th>
												<th CL='STD_LOCASR'></th>
												<th CL='STD_SECTSR'></th>
												<th CL='STD_PAIDSR'></th>
												<th CL='STD_TRNUSR'></th>
												<th CL='STD_STRUTY'></th>
												<th CL='STD_SMEAKY'></th>
												<th CL='STD_SUOMKY'></th>
												<th CL='STD_QTSPUM'></th>
												<th CL='STD_SDUOKY'></th>
												<th CL='STD_QTSDUM'></th>
												<th CL='STD_LOCATG'></th>
												<th CL='STD_SECTTG'></th>
												<th CL='STD_PAIDTG'></th>
												<th CL='STD_TRNUTG'></th>
												<th CL='STD_TTRUTY'></th>
												<th CL='STD_TMEAKY'></th>
												<th CL='STD_TUOMKY'></th>
												<th CL='STD_QTTPUM'></th>
												<th CL='STD_TDUOKY'></th>
												<th CL='STD_QTTDUM'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_LOTNUM'></th>
												<th CL='STD_REFDKY'></th>
												<th CL='STD_REFDIT'></th>
												<th CL='STD_REFCAT'></th>
												<th CL='STD_REFDAT'></th>
												<th CL='STD_PURCKY'></th>
												<th CL='STD_PURCIT'></th>
												<th CL='STD_ASNDKY'></th>
												<th CL='STD_ASNDIT'></th>
												<th CL='STD_RECVKY,3'></th>
												<th CL='STD_RECVIT,3'></th>
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SHPOIT'></th>
												<th CL='STD_GRPOKY'></th>
												<th CL='STD_GRPOIT'></th>
												<th CL='STD_SADJKY'></th>
												<th CL='STD_SADJIT'></th>
												<th CL='STD_SDIFKY'></th>
												<th CL='STD_SDIFIT'></th>
												<th CL='STD_PHYIKY'></th>
												<th CL='STD_PHYIIT'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_ASKU01'></th>
												<th CL='STD_ASKU02'></th>
												<th CL='STD_ASKU03'></th>
												<th CL='STD_ASKU04'></th>
												<th CL='STD_ASKU05'></th>
												<th CL='STD_EANCOD'></th>
												<th CL='STD_GTINCD'></th>
												<th CL='STD_SKUG01'></th>
												<th CL='STD_SKUG02'></th>
												<th CL='STD_SKUG03'></th>
												<th CL='STD_SKUG04'></th>
												<th CL='STD_SKUG05'></th>
												<th CL='STD_GRSWGT'></th>
												<th CL='STD_NETWGT'></th>
												<th CL='STD_WGTUNT'></th>
												<th CL='STD_LENGTH'></th>
												<th CL='STD_WIDTHW'></th>
												<th CL='STD_HEIGHT'></th>
												<th CL='STD_CUBICM'></th>
												<th CL='STD_CAPACT'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_LOTA01'></th>
												<th CL='STD_LOTA02'></th>
												<th CL='STD_LOTA02NM'></th>
												<th CL='STD_LOTA03'></th>
												<th CL='STD_LOTA04'></th>
												<th CL='STD_LOTA05'></th>
												<th CL='STD_LOTA06'></th>
												<th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA08'></th>
												<th CL='STD_LOTA09'></th>
												<th CL='STD_LOTA10'></th>
												<th CL='STD_LOTA11'></th>
												<th CL='STD_LOTA12'></th>
												<th CL='STD_LOTA13'></th>
												<th CL='STD_LOTA14'></th>
												<th CL='STD_LOTA15'></th>
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<th CL='STD_LOTA18'></th>
												<th CL='STD_LOTA19'></th>
												<th CL='STD_LOTA20'></th>
												<th CL='STD_AWMSNO'></th>
												<th CL='STD_SMANDT'></th>
												<th CL='STD_SEBELN'></th>
												<th CL='STD_SEBELP'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_SMBLNR'></th>
												<th CL='STD_SMJAHR'></th>
												<th CL='STD_SZEILE'></th>
												<th CL='STD_SZMIPNO'></th>
												<th CL='STD_SPOSNR'></th>
												<th CL='STD_STKNUM'></th>
												<th CL='STD_STPNUM'></th>
												<th CL='STD_SLGORT'></th>
												<th CL='STD_SWERKS'></th>
												<th CL='STD_STDLNR'></th>
												<th CL='STD_STRAID'></th>
												<th CL='STD_SSORNU'></th>
												<th CL='STD_SSORIT'></th>
												<th CL='STD_SXBLNR'></th>
												<th CL='STD_PTLT01'></th>
												<th CL='STD_PTLT02'></th>
												<th CL='STD_PTLT03'></th>
												<th CL='STD_PTLT04'></th>
												<th CL='STD_PTLT05'></th>
												<th CL='STD_PTLT06'></th>
												<th CL='STD_PTLT07'></th>
												<th CL='STD_PTLT08'></th>
												<th CL='STD_PTLT09'></th>
												<th CL='STD_PTLT10'></th>
												<th CL='STD_PTLT11'></th>
												<th CL='STD_PTLT12'></th>
												<th CL='STD_PTLT13'></th>
												<th CL='STD_PTLT14'></th>
												<th CL='STD_PTLT15'></th>
												<th CL='STD_PTLT16'></th>
												<th CL='STD_PTLT17'></th>
												<th CL='STD_PTLT18'></th>
												<th CL='STD_PTLT19'></th>
												<th CL='STD_PTLT20'></th>
												<th CL='STD_PASTKY'></th>
												<th CL='STD_SZMBLNO'></th>
												<th CL='STD_SDATBG'></th>
												<th CL='STD_TASKIT'></th>
												<th CL='STD_TASKKY'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,STOKKY"></td>
												<td GCol="text,TASKTY"></td>
												<td GCol="text,STATIT"></td>
												<td GCol="text,QTSAVLB" GF="N"></td>
												<td GCol="input,QTTAOR" GF="N 20,3" validate="max(GRID_COL_QTTAOR_*)"></td>
												<td GCol="text,QTCOMP" GF="N"></td>
												<td GCol="text,LOCAAC"></td>
												<td GCol="text,TRNUAC"></td>
												<td GCol="text,ALSTKY"></td>
												<td GCol="text,ACTCDT"></td>
												<td GCol="text,ACTCTI"></td>
												<td GCol="text,QTPUOM" GF="N"></td>
												<td GCol="text,LOCASR"></td>
												<td GCol="text,SECTSR"></td>
												<td GCol="text,PAIDSR"></td>
												<td GCol="text,TRNUSR"></td>
												<td GCol="text,STRUTY"></td>
												<td GCol="text,SMEAKY"></td>
												<td GCol="text,SUOMKY"></td>
												<td GCol="text,QTSPUM"></td>
												<td GCol="text,SDUOKY"></td>
												<td GCol="text,QTSDUM"></td>
												<td GCol="text,LOCATG"></td>
												<td GCol="text,SECTTG"></td>
												<td GCol="text,PAIDTG"></td>
												<td GCol="text,TRNUTG"></td>
												<td GCol="text,TTRUTY"></td>
												<td GCol="text,TMEAKY"></td>
												<td GCol="text,TUOMKY"></td>
												<td GCol="text,QTTPUM"></td>
												<td GCol="text,TDUOKY"></td>
												<td GCol="text,QTTDUM"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,LOTNUM"></td>
												<td GCol="text,REFDKY"></td>
												<td GCol="text,REFDIT"></td>
												<td GCol="text,REFCAT"></td>
												<td GCol="text,REFDAT"></td>
												<td GCol="text,PURCKY"></td>
												<td GCol="text,PURCIT"></td>
												<td GCol="text,ASNDKY"></td>
												<td GCol="text,ASNDIT"></td>
												<td GCol="text,RECVKY"></td>
												<td GCol="text,RECVIT"></td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SHPOIT"></td>
												<td GCol="text,GRPOKY"></td>
												<td GCol="text,GRPOIT"></td>
												<td GCol="text,SADJKY"></td>
												<td GCol="text,SADJIT"></td>
												<td GCol="text,SDIFKY"></td>
												<td GCol="text,SDIFIT"></td>
												<td GCol="text,PHYIKY"></td>
												<td GCol="text,PHYIIT"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,ASKU01"></td>
												<td GCol="text,ASKU02"></td>
												<td GCol="text,ASKU03"></td>
												<td GCol="text,ASKU04"></td>
												<td GCol="text,ASKU05"></td>
												<td GCol="text,EANCOD"></td>
												<td GCol="text,GTINCD"></td>
												<td GCol="text,SKUG01"></td>
												<td GCol="text,SKUG02"></td>
												<td GCol="text,SKUG03"></td>
												<td GCol="text,SKUG04"></td>
												<td GCol="text,SKUG05"></td>
												<td GCol="text,GRSWGT"></td>
												<td GCol="text,NETWGT"></td>
												<td GCol="text,WGTUNT"></td>
												<td GCol="text,LENGTH"></td>
												<td GCol="text,WIDTHW"></td>
												<td GCol="text,HEIGHT"></td>
												<td GCol="text,CUBICM"></td>
												<td GCol="text,CAPACT"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,LOTA01"></td>
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA02NM"></td>
												<td GCol="text,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<!-- <td GCol="text,LOTA06"></td> -->
												<td GCol="select,LOTA06">
													<select CommonCombo="LOTA06"></select>
												</td>
												<td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td>
												<td GCol="text,LOTA11"></td>
												<td GCol="text,LOTA12"></td>
												<td GCol="text,LOTA13"></td>
												<td GCol="text,LOTA14"></td>
												<td GCol="text,LOTA15"></td>
												<td GCol="text,LOTA16" GF="N"></td>
												<td GCol="text,LOTA17" GF="N"></td>
												<td GCol="text,LOTA18" GF="N"></td>
												<td GCol="text,LOTA19" GF="N"></td>
												<td GCol="text,LOTA20" GF="N"></td>
												<td GCol="text,AWMSNO"></td>
												<td GCol="text,SMANDT"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,SEBELP"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,SMBLNR"></td>
												<td GCol="text,SMJAHR"></td>
												<td GCol="text,SZEILE"></td>
												<td GCol="text,SZMIPNO"></td>
												<td GCol="text,SPOSNR"></td>
												<td GCol="text,STKNUM"></td>
												<td GCol="text,STPNUM"></td>
												<td GCol="text,SLGORT"></td>
												<td GCol="text,SWERKS"></td>
												<td GCol="text,STDLNR"></td>
												<td GCol="text,STRAID"></td>
												<td GCol="text,SSORNU"></td>
												<td GCol="text,SSORIT"></td>
												<td GCol="text,SXBLNR"></td>
												<td GCol="text,PTLT01"></td>
												<td GCol="text,PTLT02"></td>
												<td GCol="text,PTLT03"></td>
												<td GCol="text,PTLT04"></td>
												<td GCol="text,PTLT05"></td>
												<td GCol="text,PTLT06"></td>
												<td GCol="text,PTLT07"></td>
												<td GCol="text,PTLT08"></td>
												<td GCol="text,PTLT09"></td>
												<td GCol="text,PTLT10"></td>
												<td GCol="text,PTLT11"></td>
												<td GCol="text,PTLT12"></td>
												<td GCol="text,PTLT13"></td>
												<td GCol="text,PTLT14"></td>
												<td GCol="text,PTLT15"></td>
												<td GCol="text,PTLT16"></td>
												<td GCol="text,PTLT17"></td>
												<td GCol="text,PTLT18"></td>
												<td GCol="text,PTLT19"></td>
												<td GCol="text,PTLT20"></td>
												<td GCol="input,PASTKY"></td>
												<td GCol="text,SZMBLNO"></td>
												<td GCol="text,SDATBG"></td>
												<td GCol="text,TASKIT"></td>
												<td GCol="text,TASKKY"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">									
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
					<div id="tabs1-2">
						<div class="section type1">
							<div>  
								<button class="button type3" name="fnAuto" onclick="fnAutoPalletzing();" type="button"><img src="/common/images/top_icon_18.png" alt="" /></button>  <!-- ico_enter.png -->
								<span CL='STD_AUTOPALLET'></span>
								<button class="button type1 last" type="button"  name="fnAutoCan" onclick="fnWorkCancle();"><img src="/common/images/top_icon_08.png" alt="" /></button>
								<span CL='BTN_CANCEL'></span>
							</div>
							
							<div class="table type2" style="top:35px;">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th GBtnCheck="true"></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_STOKKY'></th>
												<th CL='STD_TASKTY'></th>
												<th CL='STD_STATIT'></th>
												<th CL='STD_QTSAVLB'></th>
												<th CL='STD_QTTAOR'></th>
												<th CL='STD_QTCOMP'></th>
												<th CL='STD_LOCAAC'></th>
												<th CL='STD_TRNUAC'></th>
												<th CL='STD_ALSTKY'></th>
												<th CL='STD_ACTCDT'></th>
												<th CL='STD_ACTCTI'></th>
												<th CL='STD_QTPUOM'></th>
												<th CL='STD_LOCASR'></th>
												<th CL='STD_SECTSR'></th>
												<th CL='STD_PAIDSR'></th>
												<th CL='STD_TRNUSR'></th>
												<th CL='STD_STRUTY'></th>
												<th CL='STD_SMEAKY'></th>
												<th CL='STD_SUOMKY'></th>
												<th CL='STD_QTSPUM'></th>
												<th CL='STD_SDUOKY'></th>
												<th CL='STD_QTSDUM'></th>
												<th CL='STD_LOCATG'></th>
												<th CL='STD_SECTTG'></th>
												<th CL='STD_PAIDTG'></th>
												<th CL='STD_TRNUTG'></th>
												<th CL='STD_TTRUTY'></th>
												<th CL='STD_TMEAKY'></th>
												<th CL='STD_TUOMKY'></th>
												<th CL='STD_QTTPUM'></th>
												<th CL='STD_TDUOKY'></th>
												<th CL='STD_QTTDUM'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_LOTNUM'></th>
												<th CL='STD_REFDKY'></th>
												<th CL='STD_REFDIT'></th>
												<th CL='STD_REFCAT'></th>
												<th CL='STD_REFDAT'></th>
												<th CL='STD_PURCKY'></th>
												<th CL='STD_PURCIT'></th>
												<th CL='STD_ASNDKY'></th>
												<th CL='STD_ASNDIT'></th>
												<th CL='STD_RECVKY,3'></th>
												<th CL='STD_RECVIT,3'></th>
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SHPOIT'></th>
												<th CL='STD_GRPOKY'></th>
												<th CL='STD_GRPOIT'></th>
												<th CL='STD_SADJKY'></th>
												<th CL='STD_SADJIT'></th>
												<th CL='STD_SDIFKY'></th>
												<th CL='STD_SDIFIT'></th>
												<th CL='STD_PHYIKY'></th>
												<th CL='STD_PHYIIT'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_ASKU01'></th>
												<th CL='STD_ASKU02'></th>
												<th CL='STD_ASKU03'></th>
												<th CL='STD_ASKU04'></th>
												<th CL='STD_ASKU05'></th>
												<th CL='STD_EANCOD'></th>
												<th CL='STD_GTINCD'></th>
												<th CL='STD_SKUG01'></th>
												<th CL='STD_SKUG02'></th>
												<th CL='STD_SKUG03'></th>
												<th CL='STD_SKUG04'></th>
												<th CL='STD_SKUG05'></th>
												<th CL='STD_GRSWGT'></th>
												<th CL='STD_NETWGT'></th>
												<th CL='STD_WGTUNT'></th>
												<th CL='STD_LENGTH'></th>
												<th CL='STD_WIDTHW'></th>
												<th CL='STD_HEIGHT'></th>
												<th CL='STD_CUBICM'></th>
												<th CL='STD_CAPACT'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_LOTA01'></th>
												<th CL='STD_LOTA02'></th>
												<th CL='STD_LOTA02NM'></th>
												<th CL='STD_LOTA03'></th>
												<th CL='STD_LOTA04'></th>
												<th CL='STD_LOTA05'></th>
												<th CL='STD_LOTA06'></th>
												<th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA08'></th>
												<th CL='STD_LOTA09'></th>
												<th CL='STD_LOTA10'></th>
												<th CL='STD_LOTA11'></th>
												<th CL='STD_LOTA12'></th>
												<th CL='STD_LOTA13'></th>
												<th CL='STD_LOTA14'></th>
												<th CL='STD_LOTA15'></th>
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<th CL='STD_LOTA18'></th>
												<th CL='STD_LOTA19'></th>
												<th CL='STD_LOTA20'></th>
												<th CL='STD_AWMSNO'></th>
												<th CL='STD_SMANDT'></th>
												<th CL='STD_SEBELN'></th>
												<th CL='STD_SEBELP'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_SMBLNR'></th>
												<th CL='STD_SMJAHR'></th>
												<th CL='STD_SZEILE'></th>
												<th CL='STD_SZMIPNO'></th>
												<th CL='STD_SPOSNR'></th>
												<th CL='STD_STKNUM'></th>
												<th CL='STD_STPNUM'></th>
												<th CL='STD_SLGORT'></th>
												<th CL='STD_SWERKS'></th>
												<th CL='STD_STDLNR'></th>
												<th CL='STD_STRAID'></th>
												<th CL='STD_SSORNU'></th>
												<th CL='STD_SSORIT'></th>
												<th CL='STD_SXBLNR'></th>
												<th CL='STD_PTLT01'></th>
												<th CL='STD_PTLT02'></th>
												<th CL='STD_PTLT03'></th>
												<th CL='STD_PTLT04'></th>
												<th CL='STD_PTLT05'></th>
												<th CL='STD_PTLT06'></th>
												<th CL='STD_PTLT07'></th>
												<th CL='STD_PTLT08'></th>
												<th CL='STD_PTLT09'></th>
												<th CL='STD_PTLT10'></th>
												<th CL='STD_PTLT11'></th>
												<th CL='STD_PTLT12'></th>
												<th CL='STD_PTLT13'></th>
												<th CL='STD_PTLT14'></th>
												<th CL='STD_PTLT15'></th>
												<th CL='STD_PTLT16'></th>
												<th CL='STD_PTLT17'></th>
												<th CL='STD_PTLT18'></th>
												<th CL='STD_PTLT19'></th>
												<th CL='STD_PTLT20'></th>
												<th CL='STD_PASTKY'></th>
												<th CL='STD_SZMBLNO'></th>
												<th CL='STD_SDATBG'></th>
												<th CL='STD_TASKIT'></th>
												<th CL='STD_TASKKY'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridWorkList">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="rowCheck"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,STOKKY"></td>
												<td GCol="text,TASKTY"></td>
												<td GCol="text,STATIT"></td>
												<td GCol="text,QTSAVLB" GF="N"></td>
												<td GCol="input,QTTAOR" GF="N 20,3" validate="max(GRID_COL_QTTAOR_*)"></td>
												<td GCol="text,QTCOMP" GF="N"></td>
												<td GCol="text,LOCAAC"></td>
												<td GCol="text,TRNUAC"></td>
												<td GCol="text,ALSTKY"></td>
												<td GCol="text,ACTCDT"></td>
												<td GCol="text,ACTCTI"></td>
												<td GCol="text,QTPUOM"></td>
												<td GCol="text,LOCASR"></td>
												<td GCol="text,SECTSR"></td>
												<td GCol="text,PAIDSR"></td>
												<td GCol="text,TRNUSR"></td>
												<td GCol="text,STRUTY"></td>
												<td GCol="text,SMEAKY"></td>
												<td GCol="text,SUOMKY"></td>
												<td GCol="text,QTSPUM"></td>
												<td GCol="text,SDUOKY"></td>
												<td GCol="text,QTSDUM"></td>
												<td GCol="text,LOCATG"></td>
												<td GCol="text,SECTTG"></td>
												<td GCol="text,PAIDTG"></td>
												<td GCol="text,TRNUTG"></td>
												<td GCol="text,TTRUTY"></td>
												<td GCol="text,TMEAKY"></td>
												<td GCol="text,TUOMKY"></td>
												<td GCol="text,QTTPUM"></td>
												<td GCol="text,TDUOKY"></td>
												<td GCol="text,QTTDUM"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,LOTNUM"></td>
												<td GCol="text,REFDKY"></td>
												<td GCol="text,REFDIT"></td>
												<td GCol="text,REFCAT"></td>
												<td GCol="text,REFDAT"></td>
												<td GCol="text,PURCKY"></td>
												<td GCol="text,PURCIT"></td>
												<td GCol="text,ASNDKY"></td>
												<td GCol="text,ASNDIT"></td>
												<td GCol="text,RECVKY"></td>
												<td GCol="text,RECVIT"></td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SHPOIT"></td>
												<td GCol="text,GRPOKY"></td>
												<td GCol="text,GRPOIT"></td>
												<td GCol="text,SADJKY"></td>
												<td GCol="text,SADJIT"></td>
												<td GCol="text,SDIFKY"></td>
												<td GCol="text,SDIFIT"></td>
												<td GCol="text,PHYIKY"></td>
												<td GCol="text,PHYIIT"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,ASKU01"></td>
												<td GCol="text,ASKU02"></td>
												<td GCol="text,ASKU03"></td>
												<td GCol="text,ASKU04"></td>
												<td GCol="text,ASKU05"></td>
												<td GCol="text,EANCOD"></td>
												<td GCol="text,GTINCD"></td>
												<td GCol="text,SKUG01"></td>
												<td GCol="text,SKUG02"></td>
												<td GCol="text,SKUG03"></td>
												<td GCol="text,SKUG04"></td>
												<td GCol="text,SKUG05"></td>
												<td GCol="text,GRSWGT"></td>
												<td GCol="text,NETWGT"></td>
												<td GCol="text,WGTUNT"></td>
												<td GCol="text,LENGTH"></td>
												<td GCol="text,WIDTHW"></td>
												<td GCol="text,HEIGHT"></td>
												<td GCol="text,CUBICM"></td>
												<td GCol="text,CAPACT"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,LOTA01"></td>
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA02NM"></td>
												<td GCol="text,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<!-- <td GCol="text,LOTA06"></td> -->
												<td GCol="select,LOTA06">
													<select CommonCombo="LOTA06"></select>
												</td>
												<td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td>
												<td GCol="text,LOTA11"></td>
												<td GCol="text,LOTA12"></td>
												<td GCol="text,LOTA13"></td>
												<td GCol="text,LOTA14"></td>
												<td GCol="text,LOTA15"></td>
												<td GCol="text,LOTA16" GF="N"></td>
												<td GCol="text,LOTA17" GF="N"></td>
												<td GCol="text,LOTA18" GF="N"></td>
												<td GCol="text,LOTA19" GF="N"></td>
												<td GCol="text,LOTA20" GF="N"></td>
												<td GCol="text,AWMSNO"></td>
												<td GCol="text,SMANDT"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,SEBELP"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,SMBLNR"></td>
												<td GCol="text,SMJAHR"></td>
												<td GCol="text,SZEILE"></td>
												<td GCol="text,SZMIPNO"></td>
												<td GCol="text,SPOSNR"></td>
												<td GCol="text,STKNUM"></td>
												<td GCol="text,STPNUM"></td>
												<td GCol="text,SLGORT"></td>
												<td GCol="text,SWERKS"></td>
												<td GCol="text,STDLNR"></td>
												<td GCol="text,STRAID"></td>
												<td GCol="text,SSORNU"></td>
												<td GCol="text,SSORIT"></td>
												<td GCol="text,SXBLNR"></td>
												<td GCol="text,PTLT01"></td>
												<td GCol="text,PTLT02"></td>
												<td GCol="text,PTLT03"></td>
												<td GCol="text,PTLT04"></td>
												<td GCol="text,PTLT05"></td>
												<td GCol="text,PTLT06"></td>
												<td GCol="text,PTLT07"></td>
												<td GCol="text,PTLT08"></td>
												<td GCol="text,PTLT09"></td>
												<td GCol="text,PTLT10"></td>
												<td GCol="text,PTLT11"></td>
												<td GCol="text,PTLT12"></td>
												<td GCol="text,PTLT13"></td>
												<td GCol="text,PTLT14"></td>
												<td GCol="text,PTLT15"></td>
												<td GCol="text,PTLT16"></td>
												<td GCol="text,PTLT17"></td>
												<td GCol="text,PTLT18"></td>
												<td GCol="text,PTLT19"></td>
												<td GCol="text,PTLT20"></td>
												<td GCol="input,PASTKY"></td>
												<td GCol="text,SZMBLNO"></td>
												<td GCol="text,SDATBG"></td>
												<td GCol="text,TASKIT"></td>
												<td GCol="text,TASKKY"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="copy"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
					<div id="tabs1-3">
						<div class="section type1">
							<div>
								<button class="button type1 last" type="button" name="fnStok" onclick="fnStockDocNum()"><img src="/common/images/top_icon_04.png" alt="" /></button>  <!--top_icon_12.png  -->
								<span CL='BTN_PUTAWAY'>적치지시</span> 
								<button class="button type1 last" type="button" name="fnStokCan"  onclick="fnStockCancle();"><img src="/common/images/top_icon_08.png" alt="" /></button>
								<span CL='BTN_CANCEL'>Closing</span>
							</div>
							
							<div class="table type2" style="top:35px;">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_STOKKY'></th>
												<th CL='STD_TASKTY'></th>
												<th CL='STD_STATIT'></th>
												<th CL='STD_QTSAVLB'></th>
												<th CL='STD_QTTAOR'></th>
												<th CL='STD_QTCOMP'></th>
												<th CL='STD_LOCAAC'></th>
												<th CL='STD_TRNUAC'></th>
												<th CL='STD_ALSTKY'></th>
												<th CL='STD_ACTCDT'></th>
												<th CL='STD_ACTCTI'></th>
												<th CL='STD_QTPUOM'></th>
												<th CL='STD_LOCASR'></th>
												<th CL='STD_SECTSR'></th>
												<th CL='STD_PAIDSR'></th>
												<th CL='STD_TRNUSR'></th>
												<th CL='STD_STRUTY'></th>
												<th CL='STD_SMEAKY'></th>
												<th CL='STD_SUOMKY'></th>
												<th CL='STD_QTSPUM'></th>
												<th CL='STD_SDUOKY'></th>
												<th CL='STD_QTSDUM'></th>
												<th CL='STD_LOCATG'></th>
												<th CL='STD_SECTTG'></th>
												<th CL='STD_PAIDTG'></th>
												<th CL='STD_TRNUTG'></th>
												<th CL='STD_TTRUTY'></th>
												<th CL='STD_TMEAKY'></th>
												<th CL='STD_TUOMKY'></th>
												<th CL='STD_QTTPUM'></th>
												<th CL='STD_TDUOKY'></th>
												<th CL='STD_QTTDUM'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_LOTNUM'></th>
												<th CL='STD_REFDKY'></th>
												<th CL='STD_REFDIT'></th>
												<th CL='STD_REFCAT'></th>
												<th CL='STD_REFDAT'></th>
												<th CL='STD_PURCKY'></th>
												<th CL='STD_PURCIT'></th>
												<th CL='STD_ASNDKY'></th>
												<th CL='STD_ASNDIT'></th>
												<th CL='STD_RECVKY,3'></th>
												<th CL='STD_RECVIT,3'></th>
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SHPOIT'></th>
												<th CL='STD_GRPOKY'></th>
												<th CL='STD_GRPOIT'></th>
												<th CL='STD_SADJKY'></th>
												<th CL='STD_SADJIT'></th>
												<th CL='STD_SDIFKY'></th>
												<th CL='STD_SDIFIT'></th>
												<th CL='STD_PHYIKY'></th>
												<th CL='STD_PHYIIT'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_ASKU01'></th>
												<th CL='STD_ASKU02'></th>
												<th CL='STD_ASKU03'></th>
												<th CL='STD_ASKU04'></th>
												<th CL='STD_ASKU05'></th>
												<th CL='STD_EANCOD'></th>
												<th CL='STD_GTINCD'></th>
												<th CL='STD_SKUG01'></th>
												<th CL='STD_SKUG02'></th>
												<th CL='STD_SKUG03'></th>
												<th CL='STD_SKUG04'></th>
												<th CL='STD_SKUG05'></th>
												<th CL='STD_GRSWGT'></th>
												<th CL='STD_NETWGT'></th>
												<th CL='STD_WGTUNT'></th>
												<th CL='STD_LENGTH'></th>
												<th CL='STD_WIDTHW'></th>
												<th CL='STD_HEIGHT'></th>
												<th CL='STD_CUBICM'></th>
												<th CL='STD_CAPACT'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_LOTA01'></th>
												<th CL='STD_LOTA02'></th>
												<th CL='STD_LOTA02NM'></th>
												<th CL='STD_LOTA03'></th>
												<th CL='STD_LOTA04'></th>
												<th CL='STD_LOTA05'></th>
												<th CL='STD_LOTA06'></th>
												<th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA08'></th>
												<th CL='STD_LOTA09'></th>
												<th CL='STD_LOTA10'></th>
												<th CL='STD_LOTA11'></th>
												<th CL='STD_LOTA12'></th>
												<th CL='STD_LOTA13'></th>
												<th CL='STD_LOTA14'></th>
												<th CL='STD_LOTA15'></th>
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<th CL='STD_LOTA18'></th>
												<th CL='STD_LOTA19'></th>
												<th CL='STD_LOTA20'></th>
												<th CL='STD_AWMSNO'></th>
												<th CL='STD_SMANDT'></th>
												<th CL='STD_SEBELN'></th>
												<th CL='STD_SEBELP'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_SMBLNR'></th>
												<th CL='STD_SMJAHR'></th>
												<th CL='STD_SZEILE'></th>
												<th CL='STD_SZMIPNO'></th>
												<th CL='STD_SPOSNR'></th>
												<th CL='STD_STKNUM'></th>
												<th CL='STD_STPNUM'></th>
												<th CL='STD_SLGORT'></th>
												<th CL='STD_SWERKS'></th>
												<th CL='STD_STDLNR'></th>
												<th CL='STD_STRAID'></th>
												<th CL='STD_SSORNU'></th>
												<th CL='STD_SSORIT'></th>
												<th CL='STD_SXBLNR'></th>
												<th CL='STD_PTLT01'></th>
												<th CL='STD_PTLT02'></th>
												<th CL='STD_PTLT03'></th>
												<th CL='STD_PTLT04'></th>
												<th CL='STD_PTLT05'></th>
												<th CL='STD_PTLT06'></th>
												<th CL='STD_PTLT07'></th>
												<th CL='STD_PTLT08'></th>
												<th CL='STD_PTLT09'></th>
												<th CL='STD_PTLT10'></th>
												<th CL='STD_PTLT11'></th>
												<th CL='STD_PTLT12'></th>
												<th CL='STD_PTLT13'></th>
												<th CL='STD_PTLT14'></th>
												<th CL='STD_PTLT15'></th>
												<th CL='STD_PTLT16'></th>
												<th CL='STD_PTLT17'></th>
												<th CL='STD_PTLT18'></th>
												<th CL='STD_PTLT19'></th>
												<th CL='STD_PTLT20'></th>
												<th CL='STD_PASTKY'></th>
												<th CL='STD_SZMBLNO'></th>
												<th CL='STD_SDATBG'></th>
												<th CL='STD_TASKIT'></th>
												<th CL='STD_TASKKY'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridStockList">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,STOKKY"></td>
												<td GCol="text,TASKTY"></td>
												<td GCol="text,STATIT"></td>
												<td GCol="text,QTSAVLB" GF="N"></td>
												<td GCol="input,QTTAOR" GF="N 20,3" validate="max(GRID_COL_QTTAOR_*)"></td>
												<td GCol="text,QTCOMP" GF="N"></td>
												<td GCol="text,LOCAAC"></td>
												<td GCol="text,TRNUAC"></td>
												<td GCol="text,ALSTKY"></td>
												<td GCol="text,ACTCDT"></td>
												<td GCol="text,ACTCTI"></td>
												<td GCol="text,QTPUOM"></td>
												<td GCol="text,LOCASR"></td>
												<td GCol="text,SECTSR"></td>
												<td GCol="text,PAIDSR"></td>
												<td GCol="text,TRNUSR"></td>
												<td GCol="text,STRUTY"></td>
												<td GCol="text,SMEAKY"></td>
												<td GCol="text,SUOMKY"></td>
												<td GCol="text,QTSPUM"></td>
												<td GCol="text,SDUOKY"></td>
												<td GCol="text,QTSDUM"></td>
												<td GCol="input,LOCATG,SHLOCMA" GF="S 20"></td>
												<td GCol="text,SECTTG"></td>
												<td GCol="text,PAIDTG"></td>
												<td GCol="input,TRNUTG" GF="S 30"></td>
												<td GCol="text,TTRUTY"></td>
												<td GCol="text,TMEAKY"></td>
												<td GCol="text,TUOMKY"></td>
												<td GCol="text,QTTPUM"></td>
												<td GCol="text,TDUOKY"></td>
												<td GCol="text,QTTDUM"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,LOTNUM"></td>
												<td GCol="text,REFDKY"></td>
												<td GCol="text,REFDIT"></td>
												<td GCol="text,REFCAT"></td>
												<td GCol="text,REFDAT"></td>
												<td GCol="text,PURCKY"></td>
												<td GCol="text,PURCIT"></td>
												<td GCol="text,ASNDKY"></td>
												<td GCol="text,ASNDIT"></td>
												<td GCol="text,RECVKY"></td>
												<td GCol="text,RECVIT"></td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SHPOIT"></td>
												<td GCol="text,GRPOKY"></td>
												<td GCol="text,GRPOIT"></td>
												<td GCol="text,SADJKY"></td>
												<td GCol="text,SADJIT"></td>
												<td GCol="text,SDIFKY"></td>
												<td GCol="text,SDIFIT"></td>
												<td GCol="text,PHYIKY"></td>
												<td GCol="text,PHYIIT"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,ASKU01"></td>
												<td GCol="text,ASKU02"></td>
												<td GCol="text,ASKU03"></td>
												<td GCol="text,ASKU04"></td>
												<td GCol="text,ASKU05"></td>
												<td GCol="text,EANCOD"></td>
												<td GCol="text,GTINCD"></td>
												<td GCol="text,SKUG01"></td>
												<td GCol="text,SKUG02"></td>
												<td GCol="text,SKUG03"></td>
												<td GCol="text,SKUG04"></td>
												<td GCol="text,SKUG05"></td>
												<td GCol="text,GRSWGT"></td>
												<td GCol="text,NETWGT"></td>
												<td GCol="text,WGTUNT"></td>
												<td GCol="text,LENGTH"></td>
												<td GCol="text,WIDTHW"></td>
												<td GCol="text,HEIGHT"></td>
												<td GCol="text,CUBICM"></td>
												<td GCol="text,CAPACT"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,LOTA01"></td>
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA02NM"></td>
												<td GCol="text,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<!-- <td GCol="text,LOTA06"></td> -->
												<td GCol="select,LOTA06">
													<select CommonCombo="LOTA06"></select>
												</td>
												<td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td>
												<td GCol="text,LOTA11"></td>
												<td GCol="text,LOTA12"></td>
												<td GCol="text,LOTA13"></td>
												<td GCol="text,LOTA14"></td>
												<td GCol="text,LOTA15"></td>
												<td GCol="text,LOTA16" GF="N"></td>
												<td GCol="text,LOTA17" GF="N"></td>
												<td GCol="text,LOTA18" GF="N"></td>
												<td GCol="text,LOTA19" GF="N"></td>
												<td GCol="text,LOTA20" GF="N"></td>
												<td GCol="text,AWMSNO"></td>
												<td GCol="text,SMANDT"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,SEBELP"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,SMBLNR"></td>
												<td GCol="text,SMJAHR"></td>
												<td GCol="text,SZEILE"></td>
												<td GCol="text,SZMIPNO"></td>
												<td GCol="text,SPOSNR"></td>
												<td GCol="text,STKNUM"></td>
												<td GCol="text,STPNUM"></td>
												<td GCol="text,SLGORT"></td>
												<td GCol="text,SWERKS"></td>
												<td GCol="text,STDLNR"></td>
												<td GCol="text,STRAID"></td>
												<td GCol="text,SSORNU"></td>
												<td GCol="text,SSORIT"></td>
												<td GCol="text,SXBLNR"></td>
												<td GCol="text,PTLT01"></td>
												<td GCol="text,PTLT02"></td>
												<td GCol="text,PTLT03"></td>
												<td GCol="text,PTLT04"></td>
												<td GCol="text,PTLT05"></td>
												<td GCol="text,PTLT06"></td>
												<td GCol="text,PTLT07"></td>
												<td GCol="text,PTLT08"></td>
												<td GCol="text,PTLT09"></td>
												<td GCol="text,PTLT10"></td>
												<td GCol="text,PTLT11"></td>
												<td GCol="text,PTLT12"></td>
												<td GCol="text,PTLT13"></td>
												<td GCol="text,PTLT14"></td>
												<td GCol="text,PTLT15"></td>
												<td GCol="text,PTLT16"></td>
												<td GCol="text,PTLT17"></td>
												<td GCol="text,PTLT18"></td>
												<td GCol="text,PTLT19"></td>
												<td GCol="text,PTLT20"></td>
												<td GCol="text,PASTKY"></td>
												<td GCol="text,SZMBLNO"></td>
												<td GCol="text,SDATBG"></td>
												<td GCol="text,TASKIT"></td>
												<td GCol="text,TASKKY"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button> 
									<button type="button" GBtn="sortReset"></button> 
									<button type="button" GBtn="copy"></button>								
<!-- 									<button type="button" GBtn="add"></button>    -->
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button> 
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
					
					<div id="tabs1-4">
						<div class="section type1">
							<div>
								<button class="button type1 last" type="button" name="fnSave" onclick="fnSaveEnd();"><img src="/common/images/top_icon_06.png" alt="" /></button> <!-- op_icon_11.png -->
								<span CL='BTN_PCONFIRM'>적치완료</span>
								<button class="button type1 last" type="button" name="fnprint" onclick="print();"><img src="/common/images/top_icon_09.png" alt="" /></button>
								<span CL='BTN_PTPRINT'>적치지시서 발행</span>
								<button class="button type1 last" type="button" name="fnprinttag" onclick="tagprint();"><img src="/common/images/top_icon_barcode.png" alt="" /></button>
								<span CL='BTN_PRINT_TAG'>팔레트 바코드 발행</span>
<!-- 								<button CB="Work WORK BTN_PCONFIRM"></button> -->
<!-- 								<button CB="Print PRINT BTN_PTPRINT"></button> -->
<!-- 								<button CB="Print1 PRINT BTN_PRINT_TAG"></button> -->
							</div>
							
							<div class="table type2" style="top:35px;">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th GBtnCheck="true"></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_TASKTY'></th>
												<th CL='STD_STATIT'></th>
												<th CL='STD_QTTAOR'></th>
												<th CL='STD_QTCOMP'></th>
												<th CL='STD_LOCAAC'></th>
												<th CL='STD_TRNUAC'></th>
												<th CL='STD_ALSTKY'></th>
												<th CL='STD_ACTCDT'></th>
												<th CL='STD_ACTCTI'></th>
												<th CL='STD_LOCASR'></th>
												<th CL='STD_SECTSR'></th>
												<th CL='STD_PAIDSR'></th>
												<th CL='STD_TRNUSR'></th>
												<th CL='STD_STRUTY'></th>
												<th CL='STD_SMEAKY'></th>
												<th CL='STD_SUOMKY'></th>
												<th CL='STD_QTSPUM'></th>
												<th CL='STD_SDUOKY'></th>
												<th CL='STD_QTSDUM'></th>
												<th CL='STD_LOCATG'></th>
												<th CL='STD_SECTTG'></th>
												<th CL='STD_PAIDTG'></th>
												<th CL='STD_TRNUTG'></th>
												<th CL='STD_TTRUTY'></th>
												<th CL='STD_TMEAKY'></th>
												<th CL='STD_TUOMKY'></th>
												<th CL='STD_QTTPUM'></th>
												<th CL='STD_TDUOKY'></th>
												<th CL='STD_QTTDUM'></th>
												<th CL='STD_OWNRKY'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_LOTNUM'></th>
												<th CL='STD_REFDKY'></th>
												<th CL='STD_REFDIT'></th>
												<th CL='STD_REFCAT'></th>
												<th CL='STD_REFDAT'></th>
												<th CL='STD_PURCKY'></th>
												<th CL='STD_PURCIT'></th>
												<th CL='STD_ASNDKY'></th>
												<th CL='STD_ASNDIT'></th>
												<th CL='STD_RECVKY,3'></th>
												<th CL='STD_RECVIT,3'></th>
												<th CL='STD_SHPOKY'></th>
												<th CL='STD_SHPOIT'></th>
												<th CL='STD_GRPOKY'></th>
												<th CL='STD_GRPOIT'></th>
												<th CL='STD_SADJKY'></th>
												<th CL='STD_SADJIT'></th>
												<th CL='STD_SDIFKY'></th>
												<th CL='STD_SDIFIT'></th>
												<th CL='STD_PHYIKY'></th>
												<th CL='STD_PHYIIT'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_DESC02'></th>
												<th CL='STD_ASKU01'></th>
												<th CL='STD_ASKU02'></th>
												<th CL='STD_ASKU03'></th>
												<th CL='STD_ASKU04'></th>
												<th CL='STD_ASKU05'></th>
												<th CL='STD_EANCOD'></th>
												<th CL='STD_GTINCD'></th>
												<th CL='STD_SKUG01'></th>
												<th CL='STD_SKUG02'></th>
												<th CL='STD_SKUG03'></th>
												<th CL='STD_SKUG04'></th>
												<th CL='STD_SKUG05'></th>
												<th CL='STD_GRSWGT'></th>
												<th CL='STD_NETWGT'></th>
												<th CL='STD_WGTUNT'></th>
												<th CL='STD_LENGTH'></th>
												<th CL='STD_WIDTHW'></th>
												<th CL='STD_HEIGHT'></th>
												<th CL='STD_CUBICM'></th>
												<th CL='STD_CAPACT'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_LOTA01'></th>
												<th CL='STD_LOTA02'></th>
												<th CL='STD_LOTA03'></th>
												<th CL='STD_LOTA04'></th>
												<th CL='STD_LOTA05'></th>
												<th CL='STD_LOTA06'></th>
												<th CL='STD_LOTA07'></th>
												<th CL='STD_LOTA08'></th>
												<th CL='STD_LOTA09'></th>
												<th CL='STD_LOTA10'></th>
												<th CL='STD_LOTA11'></th>
												<th CL='STD_LOTA12'></th>
												<th CL='STD_LOTA13'></th>
												<th CL='STD_LOTA14'></th>
												<th CL='STD_LOTA15'></th>
												<th CL='STD_LOTA16'></th>
												<th CL='STD_LOTA17'></th>
												<th CL='STD_LOTA18'></th>
												<th CL='STD_LOTA19'></th>
												<th CL='STD_LOTA20'></th>
												<th CL='STD_AWMSNO'></th>
												<th CL='STD_SMANDT'></th>
												<th CL='STD_SEBELN'></th>
												<th CL='STD_SEBELP'></th>
												<th CL='STD_SVBELN'></th>
												<th CL='STD_SMBLNR'></th>
												<th CL='STD_SMJAHR'></th>
												<th CL='STD_SZEILE'></th>
												<th CL='STD_SZMIPNO'></th>
												<th CL='STD_SPOSNR'></th>
												<th CL='STD_STKNUM'></th>
												<th CL='STD_STPNUM'></th>
												<th CL='STD_SLGORT'></th>
												<th CL='STD_SWERKS'></th>
												<th CL='STD_STDLNR'></th>
												<th CL='STD_STRAID'></th>
												<th CL='STD_SSORNU'></th>
												<th CL='STD_SSORIT'></th>
												<th CL='STD_SXBLNR'></th>
												<th CL='STD_PTLT01'></th>
												<th CL='STD_PTLT02'></th>
												<th CL='STD_PTLT03'></th>
												<th CL='STD_PTLT04'></th>
												<th CL='STD_PTLT05'></th>
												<th CL='STD_PTLT06'></th>
												<th CL='STD_PTLT07'></th>
												<th CL='STD_PTLT08'></th>
												<th CL='STD_PTLT09'></th>
												<th CL='STD_PTLT10'></th>
												<th CL='STD_PTLT11'></th>
												<th CL='STD_PTLT12'></th>
												<th CL='STD_PTLT13'></th>
												<th CL='STD_PTLT14'></th>
												<th CL='STD_PTLT15'></th>
												<th CL='STD_PTLT16'></th>
												<th CL='STD_PTLT17'></th>
												<th CL='STD_PTLT18'></th>
												<th CL='STD_PTLT19'></th>
												<th CL='STD_PTLT20'></th>
												<th CL='STD_PASTKY'></th>
												<th CL='STD_SZMBLNO'></th>
												<th CL='STD_SDATBG'></th>
												<th CL='STD_TASKIT'></th>
												<th CL='STD_TASKKY'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridConfirmList">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="rowCheck"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,TASKTY"></td>
												<td GCol="text,STATIT"></td>
												<td GCol="text,QTTAOR" GF="N"></td>
												<td GCol="input,QTCOMP" GF="N 20,3" validate="max(GRID_COL_QTTAOR_*),TASK_M0033"></td>
												<td GCol="input,LOCAAC,SHLOCMA" GF="S 20" validate="required,TASK_M0038"></td> 
												<td GCol="input,TRNUAC" GF="S 20"></td>
												<td GCol="text,ALSTKY"></td>
												<td GCol="text,ACTCDT"></td>
												<td GCol="text,ACTCTI"></td>
												<td GCol="text,LOCASR"></td>
												<td GCol="text,SECTSR"></td>
												<td GCol="text,PAIDSR"></td>
												<td GCol="text,TRNUSR"></td>
												<td GCol="text,STRUTY"></td>
												<td GCol="text,SMEAKY"></td>
												<td GCol="text,SUOMKY"></td>
												<td GCol="text,QTSPUM"></td>
												<td GCol="text,SDUOKY"></td>
												<td GCol="text,QTSDUM"></td>
												<td GCol="text,LOCATG"></td>
												<td GCol="text,SECTTG"></td>
												<td GCol="text,PAIDTG"></td>
												<td GCol="text,TRNUTG"></td>
												<td GCol="text,TTRUTY"></td>
												<td GCol="text,TMEAKY"></td>
												<td GCol="text,TUOMKY"></td>
												<td GCol="text,QTTPUM"></td>
												<td GCol="text,TDUOKY"></td>
												<td GCol="text,QTTDUM"></td>
												<td GCol="text,OWNRKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,LOTNUM"></td>
												<td GCol="text,REFDKY"></td>
												<td GCol="text,REFDIT"></td>
												<td GCol="text,REFCAT"></td>
												<td GCol="text,REFDAT"></td>
												<td GCol="text,PURCKY"></td>
												<td GCol="text,PURCIT"></td>
												<td GCol="text,ASNDKY"></td>
												<td GCol="text,ASNDIT"></td>
												<td GCol="text,RECVKY"></td>
												<td GCol="text,RECVIT"></td>
												<td GCol="text,SHPOKY"></td>
												<td GCol="text,SHPOIT"></td>
												<td GCol="text,GRPOKY"></td>
												<td GCol="text,GRPOIT"></td>
												<td GCol="text,SADJKY"></td>
												<td GCol="text,SADJIT"></td>
												<td GCol="text,SDIFKY"></td>
												<td GCol="text,SDIFIT"></td>
												<td GCol="text,PHYIKY"></td>
												<td GCol="text,PHYIIT"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,ASKU01"></td>
												<td GCol="text,ASKU02"></td>
												<td GCol="text,ASKU03"></td>
												<td GCol="text,ASKU04"></td>
												<td GCol="text,ASKU05"></td>
												<td GCol="text,EANCOD"></td>
												<td GCol="text,GTINCD"></td>
												<td GCol="text,SKUG01"></td>
												<td GCol="text,SKUG02"></td>
												<td GCol="text,SKUG03"></td>
												<td GCol="text,SKUG04"></td>
												<td GCol="text,SKUG05"></td>
												<td GCol="text,GRSWGT"></td>
												<td GCol="text,NETWGT"></td>
												<td GCol="text,WGTUNT"></td>
												<td GCol="text,LENGTH"></td>
												<td GCol="text,WIDTHW"></td>
												<td GCol="text,HEIGHT"></td>
												<td GCol="text,CUBICM"></td>
												<td GCol="text,CAPACT"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,LOTA01"></td>
												<td GCol="text,LOTA02"></td>
												<td GCol="text,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<!-- <td GCol="text,LOTA06"></td> -->
												<td GCol="select,LOTA06">
													<select CommonCombo="LOTA06"></select>
												</td>
												<td GCol="text,LOTA07"></td>
												<td GCol="text,LOTA08"></td>
												<td GCol="text,LOTA09"></td>
												<td GCol="text,LOTA10"></td>
												<td GCol="text,LOTA11"></td>
												<td GCol="text,LOTA12"></td>
												<td GCol="text,LOTA13"></td>
												<td GCol="text,LOTA14"></td>
												<td GCol="text,LOTA15"></td>
												<td GCol="text,LOTA16" GF="N"></td>
												<td GCol="text,LOTA17" GF="N"></td>
												<td GCol="text,LOTA18" GF="N"></td>
												<td GCol="text,LOTA19" GF="N"></td>
												<td GCol="text,LOTA20" GF="N"></td>
												<td GCol="text,AWMSNO"></td>
												<td GCol="text,SMANDT"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,SEBELP"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,SMBLNR"></td>
												<td GCol="text,SMJAHR"></td>
												<td GCol="text,SZEILE"></td>
												<td GCol="text,SZMIPNO"></td>
												<td GCol="text,SPOSNR"></td>
												<td GCol="text,STKNUM"></td>
												<td GCol="text,STPNUM"></td>
												<td GCol="text,SLGORT"></td>
												<td GCol="text,SWERKS"></td>
												<td GCol="text,STDLNR"></td>
												<td GCol="text,STRAID"></td>
												<td GCol="text,SSORNU"></td>
												<td GCol="text,SSORIT"></td>
												<td GCol="text,SXBLNR"></td>
												<td GCol="input,PTLT01" GF="S 20"></td>
												<td GCol="input,PTLT02" GF="S 20"></td>
												<td GCol="input,PTLT03" GF="S 20"></td>
												<td GCol="input,PTLT04" GF="S 20"></td>
												<td GCol="input,PTLT05" GF="S 20"></td>
												<td GCol="input,PTLT06" GF="S 20"></td>
												<td GCol="input,PTLT07" GF="S 20"></td>
												<td GCol="input,PTLT08" GF="S 20"></td>
												<td GCol="input,PTLT09" GF="S 20"></td>
												<td GCol="input,PTLT10" GF="S 20"></td>
												<td GCol="input,PTLT11" GF="S 20"></td>
												<td GCol="input,PTLT12" GF="S 20"></td>
												<td GCol="input,PTLT13" GF="S 20"></td>
												<td GCol="input,PTLT14" GF="S 20"></td>
												<td GCol="input,PTLT15" GF="S 20"></td>
												<td GCol="input,PTLT16" GF="N 20,3"></td>
												<td GCol="input,PTLT17" GF="N 20,3"></td>
												<td GCol="input,PTLT18" GF="N 20,3"></td>
												<td GCol="input,PTLT19" GF="N 20,3"></td>
												<td GCol="input,PTLT20" GF="N 20,3"></td>
												<td GCol="text,PASTKY"></td>
												<td GCol="text,SZMBLNO"></td>
												<td GCol="text,SDATBG"></td>
												<td GCol="text,TASKIT"></td>
												<td GCol="text,TASKKY"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true" id="rowEndRecord"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- //contentContainer -->

	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>

</body>
</html>