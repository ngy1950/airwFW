<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<style>
 button[btnName=Recommend] {
    display : block;
    margin : 0px auto;
}
.gcrc_RECOMM{
	background-color: #efefef;
}
.icon_detail {
   background: url( "/common/images/ico_btn7.png" ) no-repeat;
    border: none;
    cursor: pointer;
    display:inline-block;
    width:20px;
    height:20px;
    vertical-align:middle;
    text-indent:-500em;
    overflow:hidden;
    float:center;
}
.gridIcon-center{text-align: center;}
.y{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.n{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn23.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.P{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn26.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.d{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn25.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}

.init{color: #fff; font-weight: bold;}
.cmp{color: #04c704 !important; font-weight: bold;}
.not{color: orange !important; font-weight: bold;}
.req{color: blue !important; font-weight: bold;}
.end{color: red !important; font-weight: bold;}
</style>
<script type="text/javascript">
	var isReSearch = true;

	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsInventory",
			command : "IP02",
			itemGrid : "gridItemList",
			itemSearch : true,
			emptyMsgType : false,
			colorType : true
		});
			
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsInventory",
			command : "IP02Sub",
			emptyMsgType : false
		});
		
		gridList.setReadOnly("gridItemList",true,["LOCAKY","SKUKEY"]);
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList();
		}else if( btnName == "Save"){
			saveData();
		}else if( btnName == "Approve"){
			var msg = commonUtil.getMsg("INV_M0012");
			
			var rowNum = gridList.getSelectIndex("gridHeadList");
			if(rowNum < 0){
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
			var data = gridList.getRowData("gridHeadList",rowNum);
			
			if(data.get("INDDCL") == "V"){
				commonUtil.msgBox("INV_M0008");
				return;
			}
			
			var list = gridList.getGridData("gridItemList",true);
			var updateList = list.filter(function(element,index,array){
				return (element.get("GRowState") == "U")
			});
			if(updateList.length > 0){
				msg = commonUtil.getMsg("INV_M0040");
			}
			
			var createList = list.filter(function(element,index,array){
				return (element.get("GRowState") == "C")
			});
			if(createList.length > 0){
				commonUtil.msgBox("INV_M0030");
				return;
			}
			
			var isAppr = true;
			var json = netUtil.sendData({
				module : "WmsInventory",
				command : "IP02_APPR_CHK",
				sendType : "map",
				param : data
			});
			
			if(json && json.data){
				if(json.data["CNT"] > 0){
					isAppr= false;
					//msg = commonUtil.getMsg("INV_M0010");
				}
			}
			
			if(!isAppr){
				commonUtil.msgBox("INV_M0010");
				return;
			}else{
				if(!commonUtil.msgConfirm(msg)){
					return;
				}
			}
			
			page.linkPopOpen("/wms/approval/POP/APCOMM.page", data);
		}else if( btnName == "Cancel"){
			cancelData();
		}else if( btnName == "Print"){
			print();
		}
	}
	
	//조회
	function searchList(){
		if( validate.check("searchArea") ){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			
			var param = inputList.setRangeDataMultiParam("searchArea");
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
        if(gridId == "gridHeadList"){
            searchSubList(rowNum);
        }
    }
	
	function searchSubList(rowNum){
		$("#DIFFSR").val("");
		$("#TASKYN").val("");
		
    	var param = getItemSearchParam(rowNum);
		gridList.gridList({
	    	id : "gridItemList",
	    	param : param
	    });
	}
	
	function gridListEventRowClick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			$("#DIFFSR").val("");
			$("#TASKYN").val("");
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList"){
			if(dataLength == 0){
				commonUtil.msgBox("SYSTEM_M0016");
				gridList.resetGrid("gridItemList");
			}else{
				if(dataLength == 0){
					gridList.resetGrid("gridItemList");
				}
			}
		}
		
		if(gridId == "gridItemList"){
			if(dataLength == 0){
				var gridHeadLen = gridList.getGridDataCount("gridHeadList");
				if(gridHeadLen > 0 && isReSearch){
					commonUtil.msgBox("SYSTEM_M0016");
				}
				
				isReSearch = true;
			}else{
				isReSearch = true;
				gridList.checkAll(gridId,false);
			}
		}
	}
	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
		if(gridId == "gridItemList"){
			var state = gridList.getRowState(gridId, rowNum);
			if(state == "C"){
				setTimeout(function(){
					gridList.setRowReadOnly(gridId,rowNum,false,["LOCAKY","SKUKEY"]);
				});
			}
		}
		return false;
	}
    
 	// 아이템 그리드 Parameter
    function getItemSearchParam(rowNum){
        var rowData = gridList.getRowData("gridHeadList", rowNum);
        var param = inputList.setRangeDataMultiParam("searchArea");
        param.putAll(rowData);
        
        if(rowData.get("INDDCL") == "V"){
        	gridList.setBtnActive("gridItemList", configData.GRID_BTN_ADD, false);
        	$("#del").hide();
        	gridList.setReadOnly("gridItemList",true,["LOCAKY","SKUKEY","QTSPHY"]);
        }else{
        	gridList.setBtnActive("gridItemList", configData.GRID_BTN_ADD, true);
        	$("#del").show();
        	gridList.setReadOnly("gridItemList",true,["LOCAKY","SKUKEY"]);
        	gridList.setReadOnly("gridItemList",false,["QTSPHY"]);
        }
        
        return param;
    }
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			if(colName == "LOCAKY"){
				if($.trim(colValue) == ""){
					resetRowData(gridId, rowNum, colName);
				}else{
					setInputLocaky(gridId, rowNum, colName, colValue);
				}
			}else if(colName == "SKUKEY"){
				if($.trim(colValue) == ""){
					resetRowData(gridId, rowNum, colName);
				}else{
					setInputSkukey(gridId, rowNum, colName, colValue);
				}
			}else if(colName == "QTSPHY"){
				var qtsiwh = commonUtil.parseInt(gridList.getColData(gridId, rowNum, "QTSIWH"));
				var qtsphy = commonUtil.parseInt(colValue);
				var difqty = qtsphy - qtsiwh;
				
				if(qtsphy < 0){
					commonUtil.msgBox("MASTER_M4002");
					gridList.setColValue(gridId, rowNum, colName, 0, true);
					setTimeout(function() {
						gridList.setColFocus(gridId, rowNum, colName);
					});
					return;
				}
				
				gridList.setColValue(gridId, rowNum, "DIFQTY", difqty, true);
			}
		}
	}
	
	function setInputLocaky(gridId, rowNum, colName, colValue){
		if(!createDupRowData(gridId,colValue,gridList.getColData(gridId,rowNum,"SKUKEY"))){
			resetRowData(gridId,rowNum,colName);
			commonUtil.msgBox("중복된 행 입니다.");
			return;
		}
		
		var param = new DataMap();
		param.put("PHYIKY",gridList.getColData(gridId,rowNum,"PHYIKY"));
		param.put("WAREKY",gridList.getColData(gridId,rowNum,"WAREKY"));
		param.put("LOCAKY",colValue);
		param.put("SKUKEY",gridList.getColData(gridId,rowNum,"SKUKEY"));
		
		var json = netUtil.sendData({
			url : "/wms/inventory/json/validationIP02Location.data",
			param : param
		});
		
		if(json && json.data){
			var result = json.data["result"];
			var locaky = json.data["LOCAKY"];
			var skukey = json.data["SKUKEY"];
			var rowData = json.data["rowData"];
			
			if(result == "01"){
				var keys = Object.keys(rowData);
				if(keys.length > 0){
					for(var i in keys){
						var key = keys[i];
						gridList.setColValue(gridId,rowNum,key,rowData[key]);
					}
				}
				setTimeout(function(){
					var skukey = gridList.getColData(gridId,rowNum,"SKUKEY");
					if($.trim(skukey) != ""){
						gridList.setColFocus(gridId,rowNum,"QTSPHY");
					}else{
						gridList.setColFocus(gridId,rowNum,"SKUKEY");
					}
				});
			}else if((result == "02") || (result == "90")){
				var keys = ["AREAKY","AREANM","ZONEKY","ZONENM","LOCAKY","LOTA06","LT06NM"];
				if(keys.length > 0){
					for(var i in keys){
						var key = keys[i];
						gridList.setColValue(gridId,rowNum,key,rowData[key]);
					}
				}
				setTimeout(function(){
					var skukey = gridList.getColData(gridId,rowNum,"SKUKEY");
					if($.trim(skukey) != ""){
						gridList.setColFocus(gridId,rowNum,"QTSPHY");
					}else{
						gridList.setColFocus(gridId,rowNum,"SKUKEY");
					}
				});
			}else {
				resetRowData(gridId,rowNum,colName);
				
				if(result == "noKey"){
					commonUtil.msgBox("INV_M0023");
				}else if(result == "emptyLoc"){
					commonUtil.msgBox("MASTER_M4011");
				}else if(result == "dup"){
					commonUtil.msgBox("INV_M0026");
				}else if(result == "noLoc"){
					commonUtil.msgBox("MASTER_M0047");
				}else if(result == "noSku"){
					commonUtil.msgBox("INV_M0027");
				}else if(result == "emptySku"){
					commonUtil.msgBox("INV_M0028");
				}
			}
		}
	}
	
	function setInputSkukey(gridId, rowNum, colName, colValue){
		if(!createDupRowData(gridId,gridList.getColData(gridId,rowNum,"LOCAKY"),colValue)){
			resetRowData(gridId, rowNum, colName);
			commonUtil.msgBox("COMMON_M0060");
			return;
		}
		
		var param = new DataMap();
		param.put("PHYIKY",gridList.getColData(gridId,rowNum,"PHYIKY"));
		param.put("WAREKY",gridList.getColData(gridId,rowNum,"WAREKY"));
		param.put("LOCAKY",gridList.getColData(gridId,rowNum,"LOCAKY"));
		param.put("SKUKEY",colValue);
		
		var json = netUtil.sendData({
			url : "/wms/inventory/json/validationIP02Skuma.data",
			param : param
		});
		
		if(json && json.data){
			var result = json.data["result"];
			var locaky = json.data["LOCAKY"];
			var skukey = json.data["SKUKEY"];
			var rowData = json.data["rowData"];
			
			if((result == "01") || (result == "02")){
				var keys = Object.keys(rowData);
				if(keys.length > 0){
					for(var i in keys){
						var key = keys[i];
						gridList.setColValue(gridId,rowNum,key,rowData[key]);
					}
				}
				setTimeout(function(){
					var locaky = gridList.getColData(gridId,rowNum,"LOCAKY");
					if($.trim(locaky) != ""){
						gridList.setColFocus(gridId,rowNum,"QTSPHY");
					}else{
						gridList.setColFocus(gridId,rowNum,"LOCAKY");
					}
				});
			}else {
				resetRowData(gridId,rowNum,colName);
				
				if(result == "noKey"){
					commonUtil.msgBox("INV_M0023");
				}else if(result == "emptyLoc"){
					commonUtil.msgBox("MASTER_M4011");
				}else if(result == "dup"){
					commonUtil.msgBox("INV_M0024");
				}else if(result == "notSku"){
					commonUtil.msgBox("INV_M1016");
				}else if(result == "noSku"){
					commonUtil.msgBox("MASTER_M0819");
				}else if(result == "emptySku"){
					commonUtil.msgBox("INV_M0025");
				}else if(result == "packSku"){
					commonUtil.msgBox("팩 관리 상품은 추가 할 수 없습니다.");
					gridList.setRowCheck(gridId, rowNum, false);
					gridList.setColValue(gridId,rowNum,"SKUKEY","");
					setTimeout(function(){
						gridList.setColFocus(gridId,rowNum,"SKUKEY");
					},300);
				}
			}
		}
	}
	
	function resetRowData(gridId,rowNum,removeCol){
		var keys = ["AREAKY","AREANM","ZONEKY","ZONENM","LOCAKY","ASKL01","AL01NM","LOTA06","LT06NM",
					"SKUKEY","DESC01","DESC02","OWNRKY","LOTA01","SKUCLS","SKUCNM","ABCANV","ABCANM","DUOMKY"];
		if(removeCol != undefined && removeCol != null && $.trim(removeCol) != ""){
			if(removeCol == "SKUKEY"){
				keys = ["SKUKEY","DESC01","DESC02","OWNRKY","LOTA01","ASKL01","AL01NM","SKUCLS","SKUCNM","ABCANV","ABCANM","DUOMKY"];
			}else if(removeCol == "LOCAKY"){
				keys = ["AREAKY","AREANM","ZONEKY","ZONENM","LOCAKY","LOTA06","LT06NM"];
			}
		}
		
		for(var i in keys){
			var key = keys[i];
			gridList.setColValue(gridId,rowNum,key,"");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var wareky = "<%=wareky%>";
		var param = new DataMap();
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", wareky);
			return param;
		}else if(comboAtt == "WmsTask,MV01_AREACOMBO"){
			param.put("WAREKY",wareky);
			return param;
		}else if(comboAtt == "WmsCommon,DOCTMCOMBO"){
			param.put("PROGID",configData.MENU_ID);
			return param;
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridItemList", "select")){
			var headRowNum = gridList.getFocusRowNum("gridHeadList");
			if(headRowNum < 0){
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
			var INDDCL = gridList.getColData("gridHeadList", headRowNum, "INDDCL");
			if($.trim(INDDCL) == "V"){
				commonUtil.msgBox("INV_M0009");
				return;
			}
			
			var list = gridList.getSelectData("gridItemList",true);
			var listLen = list.length;
			if(listLen == 0){
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
			var createList = list.filter(function(element,index,array){
				return (element.get("GRowState") == "C" && ($.trim(element.get("LOCAKY")) == "" 
						|| $.trim(element.get("SKUKEY")) == "" || commonUtil.parseInt(element.get("QTSPHY")) <= 0))
			});
			if(createList.length > 0){
				var row = createList[0];
				
				var rowNum = row.get("GRowNum");
				var qtsphy = commonUtil.parseInt(row.get("QTSPHY"));
				
				if(qtsphy <= 0){
					commonUtil.msgBox("INV_M0022");
					
					setTimeout(function(){
						gridList.setColFocus("gridItemList",rowNum,"QTSPHY");
					});
					
					return;
				}
			}
			
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
				return;
			}
			
			var param = new DataMap();
			param.put("list",list);
			
			netUtil.send({
				url : "/wms/inventory/json/SaveIP02.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
		}
	}
	
	function succsessSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] > 0){
				commonUtil.msgBox("MASTER_M0815",json.data["CNT"]);
				
				var rowNum = gridList.getFocusRowNum("gridHeadList");
				gridList.checkAll("gridHeadList",false);
				searchSubList(rowNum);
			}
		}
	}
	
	function deleteData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getGridData("gridHeadList");
			var list = gridList.getSelectData("gridItemList",true);
			
			if(head.length == 0){
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_DELETE_CONFIRM)){
				return;
			}
			
			var param = new DataMap();
			param.put("head",head);
			param.put("list",list);
			
			netUtil.send({
				url : "/wms/inventory/json/DeleteIP01.data",
				param : param,
				successFunction : "succsessDeleteCallBack"
			});
		}
	}
	
	function succsessDeleteCallBack(json, status){
		if(json && json.data){
			isReSearch = false;
			
			var isReLoad = true;
			
			var succ = commonUtil.parseInt(json.data["SUCC"]);
			var fail = commonUtil.parseInt(json.data["FAIL"]);
			
			if(succ > 0 && fail == 0){
				commonUtil.msgBox("INV_M0002",succ);
			}else if(succ > 0 && fail > 0){
				commonUtil.msgBox("INV_M0003",succ);
			}else if(succ == 0 && fail > 0){
				commonUtil.msgBox("INV_M0004");
			}else{
				isReLoad = false;
				commonUtil.msgBox("INV_M0005");
			}
			
			if(isReLoad){
				var type = "01";
				
				var param = inputList.setRangeDataMultiParam("searchArea");
				param.put("TYPE",type);
				
				gridList.gridList({
					id : "gridHeadList",
					param : param
				});
			}
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == "gridItemList"){
			if(validAddNewRow(gridId)){
				var gridHeadId = "gridHeadList";
				var headLen = gridList.getGridDataCount(gridHeadId);
				var itemLen = gridList.getGridDataCount(gridId);
				if(headLen == 0 || itemLen == 0){
					commonUtil.msgBox("INV_M0017");
					return false;
				}
				
				var gridHeadRowNum = gridList.getFocusRowNum(gridHeadId);
				if(gridHeadRowNum < 0){
					commonUtil.msgBox("INV_M0018");
					return false;
				}
				
				var WAREKY = gridList.getColData(gridHeadId, gridHeadRowNum, "WAREKY");
				var PHYIKY = gridList.getColData(gridHeadId, gridHeadRowNum, "PHYIKY");
				
				var newData = new DataMap();
				newData.put("WAREKY",WAREKY);
				newData.put("PHYIKY",PHYIKY);
				newData.put("QTSIWH",0);
				newData.put("QTSPHY",0);
				newData.put("HHTTID","N");
				
				return newData;
			}else{
				return false;
			}
		}
	}
	
	function createDupRowData(gridId,locaky,skukey){
		var list = gridList.getGridData(gridId);
		
		var createList = list.filter(function(element,index,array){
			return (element.get("GRowState") == "C" && $.trim(element.get("LOCAKY")) != "" && $.trim(element.get("SKUKEY")) != "")
		});
		
		var chkArr = [];
		if(createList.length > 0){
			for(var i = 0; i < createList.length; i++){
				chkArr.push(createList[i].get("LOCAKY") + createList[i].get("SKUKEY"))
			}
		}
		
		var count = 0;
		for(var i in chkArr){
			if(chkArr[i] == (locaky+skukey)){
				count++;
			}
		}
		
		return count > 1?false:true;
	}
	
	function validAddNewRow(gridId){
		var flag = true;
		
		var list = gridList.getGridData(gridId);
		
		var createList = list.filter(function(element,index,array){
			return (element.get("GRowState") == "C" && ($.trim(element.get("LOCAKY")) == "" 
					|| $.trim(element.get("SKUKEY")) == "" || commonUtil.parseInt(element.get("QTSPHY")) <= 0))
		});
		
		if(createList.length > 0){
			var row = createList[0];
			
			var rowNum = row.get("GRowNum");
			var locaky = row.get("LOCAKY");
			var skukey = row.get("SKUKEY");
			var qtsphy = commonUtil.parseInt(row.get("QTSPHY"));
			
			if($.trim(locaky) == ""){
				commonUtil.msgBox("INV_M0020");
				setTimeout(function(){
					gridList.setColFocus(gridId,rowNum,"LOCAKY");
				});
				return false;
			}
			if($.trim(skukey) == ""){
				commonUtil.msgBox("INV_M0021");
				setTimeout(function(){
					gridList.setColFocus(gridId,rowNum,"SKUKEY");
				});
				return false;
			}
			if(qtsphy <= 0){
				commonUtil.msgBox("INV_M0022");
				setTimeout(function(){
					gridList.setColFocus(gridId,rowNum,"QTSPHY");
				});
				return false;
			}
		}
		
		return true;
	}
	
	function gridListEventRowAddAfter(gridId, rowNum){
		if(gridId == "gridItemList"){
			gridList.setRowReadOnly(gridId,rowNum,false,["LOCAKY","SKUKEY"]);
		}
	}
	
	function gridListEventDelete(){
		var gridId = "gridItemList";
		var gridHeadId = "gridHeadList";
		
		var headLen = gridList.getGridDataCount(gridHeadId);
		var itemLen = gridList.getGridDataCount(gridId);
		if(headLen == 0 || itemLen == 0){
			commonUtil.msgBox("INV_M0017");
			return;
		}
		
		var gridHeadRowNum = gridList.getFocusRowNum(gridHeadId);
		if(gridHeadRowNum < 0){
			commonUtil.msgBox("INV_M0018");
			return;
		}
		
		var rowNum = gridList.getFocusRowNum(gridId);
		if(rowNum < 0){
			commonUtil.msgBox("COMMON_M0061");
			return;
		}
		
		var state = gridList.getRowState(gridId,rowNum);
		if(state != "C"){
			commonUtil.msgBox("INV_M0019");
			return;
		}
		
		if(!confirm(commonUtil.getMsg(configData.MSG_MASTER_DELETE_CONFIRM))){
			return;
		}
		
		gridList.deleteRow(gridId,rowNum,false);
	}
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if((searchCode == "SHLOCMA") && ($inputObj.name == undefined) && (rowNum != undefined)){
			var param = new DataMap();
			param.put("gridId","gridItemList");
			param.put("rowNum",rowNum);
			param.put("multyType",multyType);
			param.put("WAREKY",gridList.getColData("gridHeadList",0,"WAREKY"));
			param.put("WARENM",gridList.getColData("gridHeadList",0,"WARENM"));
			param.put("PHYIKY",gridList.getColData("gridItemList",rowNum,"PHYIKY"));
			param.put("SKUKEY",gridList.getColData("gridItemList",rowNum,"SKUKEY"));
			
			var option = "height=600,width=800,resizable=yes";
			page.linkPopOpen("/wms/inventory/POP/IP02_LOCMA_POP.page",param,option);
			
			return false;
		}else if((searchCode == "SHSKUMA") && ($inputObj.name == undefined) && (rowNum != undefined)){
			var param = new DataMap();
			param.put("gridId","gridItemList");
			param.put("rowNum",rowNum);
			param.put("multyType",multyType);
			param.put("WAREKY",gridList.getColData("gridHeadList",0,"WAREKY"));
			param.put("WARENM",gridList.getColData("gridHeadList",0,"WARENM"));
			param.put("LOCAKY",gridList.getColData("gridItemList",rowNum,"LOCAKY"));
			param.put("PACKYN","N");
			
			var option = "height=600,width=800,resizable=yes";
			page.linkPopOpen("/wms/inventory/POP/IP02_SKUMA_POP.page",param,option);
			
			return false;
		}
	}
	
	function linkPopCloseEvent(data){
        if(data != null && data != undefined){
        	var popNm = data.get("popNm")==undefined?"":data.get("popNm");
        	if(popNm == "IP02_LOCMA"){
        		var gridId = data.get("gridId");
            	var rowNum = data.get("rowNum");
            	var paramData = data.get("data");
            	
            	gridList.setColValue(gridId,rowNum,"LOCAKY",paramData.get("LOCAKY"));
            	
            	setInputLocaky(gridId, rowNum, "LOCAKY", paramData.get("LOCAKY"));
        	}else if(popNm == "IP02_SKUMA"){
        		var gridId = data.get("gridId");
            	var rowNum = data.get("rowNum");
            	var paramData = data.get("data");
            	
            	gridList.setColValue(gridId,rowNum,"SKUKEY",paramData.get("SKUKEY"));
            	
            	setInputSkukey(gridId, rowNum, "SKUKEY", paramData.get("SKUKEY"));
        	}else{
        		var rowNum = gridList.getFocusRowNum("gridHeadList");
        		var head = gridList.getRowData("gridHeadList", rowNum);
        		head.put("REQTXT",data.get("REQTXT"));
        		
        		var param = new DataMap();
        		param.put("head",head);
        		param.put("list",gridList.getGridData("gridItemList", true));
        		
        		netUtil.send({
    				url : "/wms/inventory/json/SaveIP02Approve.data",
    				param : param,
    				successFunction : "succsessApprCallBack"
    			});
        	}
        }
    }
	
	function succsessApprCallBack(json,status){
		if(json && json.data){
			if(json.data["CNT"] > 0){
				commonUtil.msgBox("INV_M0011",json.data["PHYIKY"]);
				searchList();
				
				//top 재조회
				window.parent.parent.frames["header"].countCall();
			}
		}
	}
	
	function cancelData(){
		var rowNum = gridList.getSelectIndex("gridHeadList");
		if(rowNum < 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		
		var head = gridList.getRowData("gridHeadList",rowNum);
		
		if($.trim(head.get("INDDCL")) == ""){
			commonUtil.msgBox("INV_M0013");
			return;
		}
		
		if(head.get("APRSTS") != "REQ" && head.get("APRSTS") != "NOT"){
			commonUtil.msgBox("INV_M0014");
			return;
		}
		
		if(!commonUtil.msgConfirm("INV_M0015")){
			return;
		}
		
		var param = new DataMap();
		param.put("head",head);
		
		netUtil.send({
			url : "/wms/inventory/json/SaveIP02Cancel.data",
			param : param,
			successFunction : "succsessCancelCallBack"
		});
	}
	
	function succsessCancelCallBack(json,status){
		if(json && json.data){
			if(json.data["CNT"] > 0){
				commonUtil.msgBox("INV_M0016",json.data["PHYIKY"]);
				searchList();
				
				//top 재조회
				window.parent.parent.frames["header"].countCall();
			}
		}
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "INDDCL"){
				if(colValue == "V"){
					var aprsts = gridList.getColData(gridId, rowNum, "APRSTS");
					if(aprsts == "END"){
						return "d";
					}else{
						return "y";
					}
				}else if($.trim(colValue) == ""){
					return "n";
				}
			}
		}
	}
	
	function changeDiffSelect(){
		isReSearch = false;
		
		var value1 = $("#DIFFSR").val();
		var value2 = $("#TASKYN").val();
		
		var param = inputList.setRangeDataMultiParam("searchArea");
		param.put("PHYIKY",gridList.getColData("gridHeadList", gridList.getFocusRowNum("gridHeadList"), "PHYIKY"));
		param.put("DIFFSR",value1);
		param.put("TASKYN",value2);
		
		gridList.gridList({
	    	id : "gridItemList",
	    	param : param
	    });
	}
	
	function  gridListEventColBtnclick(gridId, rowNum, btnName){
		if(btnName == "Recommend"){
			var state = gridList.getRowState(gridId, rowNum);
			if(state != "C"){
				var rowData = gridList.getRowData(gridId, rowNum);
				var id = rowData.get("HHTTID");
				if(id == "N"){
					commonUtil.msgBox("INV_M0029");
					return;
				}
				
				rowData.put("WARENM",gridList.getColData("gridHeadList", gridList.getFocusRowNum("gridHeadList"), "WARENM"));
				
				var option = "height=600,width=800,resizable=yes";
				page.linkPopOpen("/wms/inventory/POP/IP02_PHYDI_POP.page",rowData,option);
				
			}
		}
	}
	
	function gridListColTextColorChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "APRSNM"){
				var type = gridList.getColData(gridId, rowNum, "APRSTS");
				switch (type) {
				case "CMP":
					return "cmp";
					break;
				case "REQ":
					return "req";
					break;
				case "NOT":
					return "not";
					break;
				case "END":
					return "end";
					break;	
				default:
					return "init";
					break;
				}
			}
		}
	}
	
	function print(){
		var list = gridList.getGridData("gridItemList");
		if (list.length == 0){
			commonUtil.msgBox("조회된 데이터가 없습니다.");
			return;
		}
		var head = new DataMap();
			head.put("WAREKY","<%=wareky%>");
			head.put("PHYIKY",list[0].get("PHYIKY"));
		
		
		var json = netUtil.sendData({
            module : "WmsInventory",
            command : "IP02_NOT_CHECK",
            sendType : "map",
            param : head
		});
		
		if(parseInt(json.data["CNT"]) == 0){
			commonUtil.msgBox("미조사된 재고가 없습니다."); //요청상태가 변경된 값이 존재 합니다.\n재조회후 실행 하시기 바랍니다.
			return ;
		}
		
		var param = dataBind.paramData("searchArea");
			param.put("PROGID" , configData.MENU_ID);
			param.put("PRTCNT" , 1);
			param.put("head",head);
		var json = netUtil.sendData({
			url : "/wms/inventory/json/printIP02.data",
			param : param
		});

		
		if ( json && json.data ){
				var	url = "<%=systype%>" + "/stock_ip02_list.ezg";
				var	width = 600;
				var	height = 800;
				var where = "AND PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				
				var langKy = "KR";
				var map = new DataMap();
					map.put("PHYIKY",list[0].get("PHYIKY"));
				WriteEZgenElement(url , where , "" , langKy, map , width , height );
				
				
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
		<button CB="Approve SEND BTN_APPROV"></button>
		<button CB="Cancel WCANCLE BTN_APPCAN"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect top" id="searchArea" style="height: 100px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col />
									</colgroup>
									<tbody>
										<tr>
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_PHSCTY"></th>
										<td>
											<select Combo="WmsCommon,DOCTMCOMBO" id="PHSCTY" name="PHSCTY" ComboCodeView=false style="width:160px">
												<option CL="STD_ALL" value=""></option>
											</select>
										</td>
										<th CL="STD_TASDAT"></th>
										<td>
											<input type="text" id="DOCDAT" name="PHD.DOCDAT" UIInput="B" UIformat="C 0 0" UiRange="2" validate="required" MaxDiff="M1" />
										</td>
									</tr>
									<tr>
										<th CL="STD_COMPYN"></th>
										<td>
											<select id="INDDCL" name="INDDCL" style="width:160px">
												<option value=""  CL="STD_ALL"></option>
												<option value="Y" CL="STD_COMPY"></option>
												<option value="N" CL="STD_COMPN"></option>
											</select>
										</td>
										<th CL="STD_AREAKY">창고</th>
										<td>
											<select id="AREAKY" name="STK.AREAKY" Combo="WmsTask,MV01_AREACOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
										</td>
										<th CL="STD_ZONEKY">존</th>
										<td>
											<input type="text" name="STK.ZONEKY" UIInput="SR,SHZONMN" UIFormat="U 10"/>
										</td>
									</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 그리드 -->
			<div class="bottomSect bottom">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_GENERAL'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"    GCol="rownum">1</td>
												<td GH="100 STD_WAREKYNM" GCol="text,WARENM,center"></td>
												<td GH="120 STD_PHYIKY"   GCol="text,PHYIKY,center"></td>
												<td GH="130 STD_PHSCTY"   GCol="text,PHSCNM"></td>
												<td GH="80 STD_COMPYN"    GCol="icon,INDDCL" GB="n"></td>
												<td GH="100 STD_APSTUS"   GCol="text,APRSNM,center"></td>
												<td GH="200 STD_APRTXT"   GCol="text,APRTXT"></td>
												<td GH="100 STD_APRDAT"   GCol="text,APRDAT,center" GF="D"></td>
												<td GH="100 STD_APRTIM"   GCol="text,APRTIM,center" GF="T"></td>
												<td GH="100 STD_APRUSR"   GCol="text,APRUSR,center"></td>
												<td GH="100 STD_AUSRNM"   GCol="text,APRUNM,center"></td>
												<td GH="200 STD_DOCTXT"   GCol="text,DOCTXT"></td>
												<td GH="100 STD_CREDAT"   GCol="text,CREDAT,center" GF="D"></td>
												<td GH="100 STD_CRETIM"   GCol="text,CRETIM,center" GF="T"></td>
												<td GH="100 STD_CREUSR"   GCol="text,CREUSR,center"></td>
												<td GH="100 STD_CUSRNM"   GCol="text,CREUNM,center"></td>
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
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 그리드 -->
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2"  id="commonMiddleArea2">
						<li><a href="#tabs1-1"><span CL="STD_LIST"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="reflect" id="reflect">
								<span CL="STD_DIFFSR" style="margin-right: 10px;color: #000;"></span>
								<select id="DIFFSR" name="DIFFSR" style="width:160px" onchange="changeDiffSelect();">
									<option value=""  CL="STD_ALL"></option>
									<option value="Y">Y</option>
									<option value="N">N</option>
								</select>
								<span CL="STD_TASKYN" style="margin-left: 20px;margin-right: 10px;color: #000;"></span>
								<select id="TASKYN" name="TASKYN" style="width:160px" onchange="changeDiffSelect();">
									<option value=""  CL="STD_ALL"></option>
									<option value="Y">Y</option>
									<option value="N">N</option>
								</select>
								<span CL=" " style="margin-left: 20px;margin-right: 10px;color: #000;"></span>
								<button CB="Print PRINT BTN_NOSEAR"></button>
							</div>
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"  GCol="rownum">1</td>
												<td GH="40"             GCol="rowCheck"></td>
												<td GH="100 STD_AREAKY" GCol="text,AREANM"></td>
												<td GH="100 STD_ZONEKY" GCol="text,ZONEKY"></td>
												<td GH="100 STD_LOCAKY" GCol="input,LOCAKY,SHLOCMA" GF="U" validate="required"></td>
												<td GH="100 STD_SKUL01" GCol="text,AL01NM,center"></td>
												<td GH="100 STD_LOTA06" GCol="text,LT06NM,center"></td>
												<td GH="130 STD_SKUKEY" GCol="input,SKUKEY,SHSKUMA" GF="NS" validate="required"></td>
												<td GH="250 STD_DESC01" GCol="text,DESC01"></td>
												<td GH="100 STD_ORDQTY" GCol="text,QTSIWH" GF="N 20,3"></td>
												<td GH="100 STD_PHIQTY" GCol="input,QTSPHY" GF="N 20,3" validate="required"></td>
												<td GH="100 STD_DIFQTY" GCol="text,DIFQTY" GF="N 20,3"></td>
												<td GH="80 STD_TASKYN"  GCol="text,HHTTID,center"></td>
												<td GH="130 STD_SKUCNM" GCol="text,SKUCNM,center"></td>
												<td GH="100 STD_ABCANV" GCol="text,ABCANM,center"></td>
												<td GH="100 STD_LPTUID" GCol="text,WORKID"></td>
												<td GH="100 STD_LPTUNM" GCol="text,WORUNM"></td>
												<td GH="100 STD_LPTDAT" GCol="text,WORDAT,center" GF="D"></td>
												<td GH="100 STD_LPTTIM" GCol="text,WORTIM,center" GF="T"></td>
												<td GH="100 STD_PHYDTL" GCol="btn2,RECOMM" GB="Recommend icon_detail BTN_RECOMD"></td>
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
									<button type="button" GBtn="add"></button>
									<button type="button" id="del" class="button type4" title="삭제" onclick="gridListEventDelete();">
										<img src="/common/theme/darkness/images/grid_icon_02.png">
									</button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
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