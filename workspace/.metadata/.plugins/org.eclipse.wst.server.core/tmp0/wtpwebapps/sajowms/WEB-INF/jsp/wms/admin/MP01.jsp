<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<style>
.mp01ContentLoading{
	position: fixed;
	left: 0;
	top: 0;
	bottom: 0;
	right: 0;
	z-index: 999999;
	background: #fff url(/common/theme/darkness/images/loading_icon.gif) no-repeat center center;
	opacity: 0.85;
	display: none;
}
#mp01ExcelUpload{width: 100%;height: 100%;position: absolute;top: 0;z-index: 9999;background: rgba(0,0,0,0.8);display: none;}
#mp01ExcelUpload input[type=file]{display: none;}
#mp01ExcelUpload .excelUploadWrap{width: 50%;max-width: 650px;height: 400px;margin: 0 auto;background-color: #fff;border: 2px solid #000;border-radius: 8px;margin-top: 15%;}
#mp01ExcelUpload .excelUploadWrap .excelUploadTitle .excelUploadClose{width: 50px;height: 100%;background: url("/common/images/ico_closer.png") no-repeat;background-position: center;float: right;border: 0;outline: none;}
#mp01ExcelUpload .excelUploadWrap .excelUploadTitle{width: 100%;height: 50px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadContent{width: 100%;height: 200px;padding: 60px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadContent .offFile{width: 100%;height: 100%;cursor: pointer;}
#mp01ExcelUpload .excelUploadWrap .excelUploadContent .offFile .noFileImg{width: 80px;height: 100%;float: left;}
#mp01ExcelUpload .excelUploadWrap .excelUploadContent .offFile .noFileImg img{width: 80px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadContent .offFile .noFileText{width: calc(100% - 80px);height: 100%;float: left;text-align: center;}
#mp01ExcelUpload .excelUploadWrap .excelUploadContent .offFile .noFileText p{font-size: 24px;font-weight: bold;padding: 6px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadContent .offFile .noFileText p span{font-style: italic;border-bottom: 2px solid #7fc241;border-style: dotted;color: #7fc241;}

#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent{width: 100%;height: 200px;padding: 20px;display: none;}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile{width: 100%;height: 100%;}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile .fileRegHead{width: 100%;height: 40px;padding: 5px 10px 5px 10px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile .fileRegHead button{width: 30px;height: 30px;float: right;outline: none;border: 0;}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile .fileRegHead .fileDelete{
	background: url("/common/theme/gsfresh/images/icon/ico_file_del.png") no-repeat;
	background-size: 25px;
}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile .fileReg{width: 100%;height: calc(100% - 40px);}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile .fileReg .regFileIcon{
	width: 100px;
	height: 100%;
	float: left;
	background: url("/common/theme/gsfresh/images/fileIcon/ico_excel.png") no-repeat;
	background-size: 80px;
	background-position: center;
	padding: 34px 10px 20px 15px;
}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile .fileReg .regFileIcon .icoWrap{width: 80px;height: 80px;border: 2px solid #9d9d9d;border-radius: 5px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile .fileReg .regFileIcon .icoWrap img{width: 76px;height: 100%;border-radius: 3px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile .fileReg .regFileInf{width: calc(100% - 100px);height: calc(100% - 50px);float: left;padding: 10px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile .fileReg .regFileInf .regFileName{width: 100%;height: 70px;white-space: normal;text-overflow: ellipsis;overflow: hidden;}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile .fileReg .regFileInf .regFileName p{width: 100%;height: 100%;font-size: 20px;font-weight: bold;line-height: 1.4;padding-left: 10px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile .fileReg .regFileInf .regFileSize{width: 100%;height: 40px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadRegContent .onFile .fileReg .regFileInf .regFileSize p{font-size: 18px;padding-left: 10px;}

#mp01ExcelUpload .excelUploadWrap .excelUploadGuide{width: 100%;height: 100px;padding: 5px 0px 5px 10px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadGuide .excelUploadGuideContent{width: 100%;height: 100%;}
#mp01ExcelUpload .excelUploadWrap .excelUploadGuide .excelUploadGuideContent ul{width: 100%;height: 100%;}
#mp01ExcelUpload .excelUploadWrap .excelUploadGuide .excelUploadGuideContent ul li{width: 100%;height: 20px;margin-top: 10px;margin-bottom: 10px;background: url(/common/images/ico_record.png) no-repeat;background-position: left;font-size: 13px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadGuide .excelUploadGuideContent ul li p{padding-left: 25px;padding-top: 4px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadGuide .excelUploadGuideContent ul li .excelDown{border-bottom: 2px dashed #7fc241;cursor: pointer;}
#mp01ExcelUpload .excelUploadWrap .excelUploadGuide .excelUploadGuideContent ul li .excelDown.focus{color: #7fc241;}
#mp01ExcelUpload .excelUploadWrap .excelUploadButton{width: 100%;height: 50px;background-color: #7fc241;border-radius: 0px 0px 8px 8px;}
#mp01ExcelUpload .excelUploadWrap .excelUploadButton button{width: 100%;height: 100%;color: #fff;font-size: 15px;font-weight: bold;}
#mp01ExcelUpload .excelUploadWrap .excelUploadButton button:focus {outline: none;border: 0;}

.bagYn{color: red;}
</style>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
	var colVlaueChangeList = [];
	var colVlaueChangeCount = 0;
	var gridRowNum = 0;
	var isPickMapping = false;
	var linkData = null;
	var excelFileList = [];
	
	$(document).ready(function(){
		setTopSize(130);
		
		gridList.setGrid({
			id : "gridList",
			name : "gridList",
			editable : true,
			module : "WmsAdmin",
			command : "MP01",
			colorType : true
		});
		
		linkData = page.getLinkPageData(configData.MENU_ID);
		if(linkData){
			isPickMapping = true;
			
			inputList.resetMultiComboValue("AREAKY");
			inputList.resetRange("LC.ZONEKY");
			inputList.resetRange("LC.LOCAKY");
			inputList.resetRange("LC.SKUKEY");
			inputList.resetMultiComboValue("LOTA06");
			inputList.resetRange("LC.BEFSKU"); //r
			
			var param = new DataMap();
			param.put("STOKYN","");
			dataBind.dataBind(param,"searchArea");
			
			var srchData = linkData.get("head");
			inputList.setMultiComboValue("AREAKY",srchData.get("AREAKY"));
			
			var singleList = [];
			var rangeMap = new DataMap();
			rangeMap.put(configData.INPUT_RANGE_LOGICAL, "OR");
			rangeMap.put(configData.INPUT_RANGE_OPERATOR, "E");
			rangeMap.put(configData.INPUT_RANGE_SINGLE_DATA, srchData.get("ZONEKY"));
			singleList.push(rangeMap);
			inputList.setRangeData("LC.ZONEKY", configData.INPUT_RANGE_TYPE_SINGLE, singleList);
			
			searchList("T");
		}
		
		setExcelFileEvent();
	});
	
	// 공통 버튼
	function commonBtnClick(btnName){
		if( btnName == "Search" ){
			searchList("S");
		}else if( btnName == "Save" ){
			saveData();
		}else if( btnName == "Clear"){
			clearData();
		}else if( btnName == "Print"){
			print();
		}
	}
	
	//조회
	function searchList(type,code){
		if( validate.check("searchArea") ){
			switch (type) {
			case "S":
				linkData = null;
				isPickMapping = false;
				
				uiList.setActive("Save", true);
				gridList.setReadOnly("gridList",false,["TRSSKU","TRLT06"]);
				gridList.getGridBox("gridList").sortReset();
				break;
			case "R":
				linkData = null;
				isPickMapping = false;
				
				uiList.setActive("Save", false);
				gridList.setReadOnly("gridList",true,["TRSSKU","TRLT06"]);
				gridList.getGridBox("gridList").sortReset();
				break;
			case "T":
				uiList.setActive("Save", true);
				gridList.setReadOnly("gridList",false,["TRSSKU","TRLT06"]);
				break;	
			default:
				break;
			}
			
			var param = inputList.setRangeParam("searchArea");
			param.put("TYPE",type=="T"?"S":type);
			if(type == "R" && (code != undefined && code != null && $.trim(code) != "")){
				param.put("LOCHCD",code);
			}
			
			gridList.gridList({
				id : "gridList",
				param : param
			});
			
		}
	}
	
	//저장
	function saveData(){
		var gridId = "gridList";
		if( gridList.validationCheck(gridId, "select") && validGridData(gridId)){
			if(!commonUtil.msgConfirm("COMMON_M0100")){
				return;
			}
			
			var list = gridList.getSelectData("gridList",true);
			
			var param = new DataMap();
			param.put("list",list);
			
			netUtil.send({
				url : "/wms/admin/json/SaveMP01.data",
				param : param,
				successFunction : "succsessSaveCallBack"
			});
		}
	}
	
	function succsessSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				var ucnt = json.data["UCNT"]; //로케이션 신규/변경
				var mcnt = json.data["MCNT"]; //로케이션 변경(재고포함)
				var icnt = json.data["ICNT"]; //로케이션 삭제
				
				commonUtil.msgBox("MASTER_M5000",[ucnt,mcnt,icnt]);
				
				if(isPickMapping){
					linkData = null;
					isPickMapping = false;
					
					var id = "";
					parent.$rightFrame.children().each(function(){
					    var path = $(this).attr("src");
					    if(path.indexOf("MP11") > -1){
					    	id = $(this).attr("id");
					    }
					});
					if(id != ""){
						var frame = parent.frames[id];
						frame.closeMP11Popup();
						frame.searchList();
					}
				}
				
				searchList("R",json.data["LOCHCD"]);
			}
		}
	}
	
	function clearData(){
		if(validGridClearData("gridList")){
			if(!commonUtil.msgConfirm("MASTER_M5016")){
				return;
			}
			
			var list = gridList.getSelectData("gridList",true);
			
			var param = new DataMap();
			param.put("list",list);
			
			netUtil.send({
				url : "/wms/admin/json/SaveMP01Clear.data",
				param : param,
				successFunction : "succsessClearCallBack"
			});
		}
	}
	
	function succsessClearCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("MASTER_M5001",[json.data["ICNT"]]);
				searchList("R",json.data["LOCHCD"]);
			}
		}
	}
	
	function validGridData(gridId){
		var list = gridList.getSelectData(gridId,true);
		var listLen = list.length;
		if(listLen == 0){
			commonUtil.msgBox("VALID_M0006");
			return false;
		}else{
			var chkTrsList = [];
			var gridAllList = gridList.getGridData("gridList",true);
			for(var i in gridAllList){
				chkTrsList.push(gridAllList[i].get("CHKTRS"));
			}
			
			var stockItemsNoTransItems = list.filter(function(element,index,array){
				var skukeyAddLota06 = element.get("SKUKEY") + element.get("LOTA06");
				return ((element.get("STOKYN") == "Y") && (chkTrsList.indexOf(skukeyAddLota06) == -1))
			});
			
			var duplicationItems = list.filter(function(element,index,array){
				return ((element.get("SKUKEY") == element.get("TRSSKU")) && (element.get("LOTA06") == element.get("TRLT06")))
			});
			
			var dupGridItems = gridAllList.filter(function(element,index,array){
				return ($.trim(element.get("CHKTRS")) != "" && (chkTrsList.indexOf(element.get("CHKTRS")) !== index));
			});
			
			if(stockItemsNoTransItems.length > 0){
				var data = stockItemsNoTransItems[0];
				var rowNum = data.get(configData.GRID_ROW_NUM);
				var lota06 = gridList.getGridBox("gridList").comboDataMap.get("TRLT06").get(data.get("LOTA06"));
				
				commonUtil.msgBox("MASTER_M5002",[data.get("SKUKEY"),data.get("DESC01"),lota06]);
				
				setTimeout(function(){
					gridList.setColFocus(gridId,rowNum,"TRSSKU");
				}, 100);
				
				return false;
			}else if(duplicationItems.length > 0){
				var data = duplicationItems[0];
				var rowNum = data.get(configData.GRID_ROW_NUM);

				commonUtil.msgBox("MASTER_M5003",[data.get("LOCANM")]);
				
				setTimeout(function(){
					gridList.setColFocus(gridId,rowNum,"TRSSKU");
				}, 100);
				
				return false;
			}else if(dupGridItems.length > 0){
				var data = dupGridItems[0];
				var rowNum = data.get(configData.GRID_ROW_NUM);
				
				commonUtil.msgBox("MASTER_M5004",[data.get("TRSSKU"),data.get("TRSDSC")]);
				
				setTimeout(function(){
					gridList.setColFocus(gridId,rowNum,"TRSSKU");
				}, 100);
				
				return false;
			}
		}
		
		return true;
	}
	
	function validGridClearData(gridId){
		var list = gridList.getSelectData(gridId,true);
		var listLen = list.length;
		if(listLen == 0){
			commonUtil.msgBox("VALID_M0006");
			return false;
		}else{
			var stockItemsNoTransItems = list.filter(function(element,index,array){
				return (element.get("STOKYN") == "Y")
			});
			if(stockItemsNoTransItems.length > 0){
				var data = stockItemsNoTransItems[0];
				var rowNum = data.get(configData.GRID_ROW_NUM);
				
				commonUtil.msgBox("MASTER_M5005",[data.get("LOCANM")]);
				
				setTimeout(function(){
					gridList.setColFocus(gridId,rowNum,configData.GRID_COL_TYPE_ROWCHECK);
				}, 100);
				
				return false;
			}
		}
		
		return true;
	}
	
	//그리드 컬럼변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if( gridId == "gridList" ){
			if(colName == "TRSSKU"){
				gridList.setRowReadOnly(gridId, rowNum, true, ["TRLT06"]);
				
				var data = new DataMap();
				data.put(configData.GRID_ROW_NUM,rowNum);
				data.put("SKUKEY",colValue);
				colVlaueChangeList.push(data);
				
				colVlaueChangeCount++;
				
				var copyLen = gridList.getGridBox(gridId).copyDataLen;
				var gridLen = gridList.getGridDataCount(gridId);
				var copyDataLen =  copyLen > gridLen?gridLen:copyLen;
				if((colVlaueChangeCount == copyDataLen) || (copyLen == 0)){
					var param = new DataMap();
					param.put("list",colVlaueChangeList);
					
					netUtil.send({
						url : "/wms/admin/json/selectMP01SkuName.data",
						param : param,
						successFunction : "setColSkuNamesCallBack",
						failFunction : "setColSkuNamesFailCallBack"
					});
				}else{
					gridList.setRowReadOnly(gridId, rowNum, false, ["TRLT06"]);
				}
			}else if(colName == "TRLT06"){
				var trssku = gridList.getColData(gridId,rowNum,"TRSSKU");
				if($.trim(trssku) != ""){
					gridList.setColValue("gridList", rowNum, "CHKTRS", (trssku+colValue));
				}
				
				if($.trim(colValue) == ""){
					gridList.setColValue("gridList", rowNum, "CHKTRS", "");
				}
			}
		}
	}
	
	function setColSkuNamesCallBack(json, status){
		var readOnlyMap = gridList.getGridBox("gridList").readOnlyCellMap;
		if(readOnlyMap != null && readOnlyMap != undefined){
			var keys = readOnlyMap.keys();
			for(var i = 0; i < keys.length; i++){
				var key = keys[i];
				var trlt06 = readOnlyMap.get(key).get("TRLT06");
				if(trlt06){
					gridList.setRowReadOnly("gridList", key, false, ["TRLT06"]);
				}
			}
		}
		
		if(json && json.data){
			var data = json.data;
			var len  = data.length;
			if(len > 0){
				$("#mp01ContentLoading").show();
				setTimeout(function() {
					var packSkuList = [];
					
					for(var i in data){
						var row = data[i];
						var rowNum   = row["NUM"]
						var colValue = $.trim(row["DESC01"]);
						var packYn   = $.trim(row["PACKYN"]);
						var bagYn    = gridList.getColData("gridList", rowNum, "BAGYN");
						if(packYn != "Y"){
							if(bagYn == "Y"){
								gridList.setColValue("gridList", rowNum, "TRSSKU", "");
								gridList.setColValue("gridList", rowNum, "TRSDSC", "");
								gridList.setColValue("gridList", rowNum, "TRLT06", "");
								gridList.setColValue("gridList", rowNum, "CHKTRS", "");
								gridList.setRowCheck("gridList", rowNum, false);
							}else{
								gridList.setColValue("gridList", rowNum, "TRSDSC", colValue==""?" ":colValue);
								if($.trim(colValue) == ""){
									gridList.setColValue("gridList", rowNum, "TRLT06", "");
									gridList.setColValue("gridList", rowNum, "CHKTRS", "");
									gridList.setRowCheck("gridList", rowNum, false);
								}else{
									var TRSSKU = gridList.getColData("gridList",rowNum,"TRSSKU");
									var TRLT06 = gridList.getColData("gridList",rowNum,"TRLT06");
									if($.trim(TRLT06) != "" && TRLT06 != undefined && TRLT06 != null){
										gridList.setColValue("gridList", rowNum, "CHKTRS", (TRSSKU+TRLT06));
									}
								}
							}
						}else{
							packSkuList.push(row);
						}
					}
					var packSkuListLen = packSkuList.length;
					if(packSkuListLen > 0){
						if(packSkuListLen == 1){
							var rowNum = packSkuList[0]["NUM"];
							var skukey = gridList.getColData("gridList", rowNum, "TRSSKU");
							var desc01 = packSkuList[0]["DESC01"];
							
							gridList.setRowCheck("gridList", rowNum, false);
							gridList.setColValue("gridList", rowNum, "TRSSKU", "");
							gridList.setColValue("gridList", rowNum, "TRLT06", "");
							gridList.setColValue("gridList", rowNum, "CHKTRS", "");
							
							commonUtil.msgBox("팩 관리 상품 [ "+skukey+" ][ "+desc01+" ]은 추가 할 수 없습니다.");
						}else{
							for(var i = 0; i < packSkuListLen; i++){
								var row = packSkuList[i];
								var rowNum = row["NUM"];
								gridList.setRowCheck("gridList", rowNum, false);
								gridList.setColValue("gridList", rowNum, "TRSSKU", "");
								gridList.setColValue("gridList", rowNum, "TRLT06", "");
								gridList.setColValue("gridList", rowNum, "CHKTRS", "");
							}
							
							commonUtil.msgBox("팩 관리 상품은 추가 할 수 없습니다. [ "+packSkuListLen+" 건 ]");
						}
					}
					$("#mp01ContentLoading").hide();
				},200);
			}
		}
		
		gridList.getGridBox("gridList").copyDataLen = 0;
		colVlaueChangeCount = 0;
		colVlaueChangeList = [];
	}
	
	function setColSkuNamesFailCallBack(a, b, c, json){
		var readOnlyMap = gridList.getGridBox("gridList").readOnlyCellMap;
		if(readOnlyMap != null && readOnlyMap != undefined){
			var keys = readOnlyMap.keys();
			for(var i = 0; i < keys.length; i++){
				var key = keys[i];
				var trlt06 = readOnlyMap.get(key).get("TRLT06");
				if(trlt06){
					gridList.setRowReadOnly("gridList", key, false, ["TRLT06"]);
				}
			}
		}
	}
	
	// 서치헬프 오픈 이벤트
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("FIXLOC","");
			param.put("PACKYN","N");
			
			skumaPopup.open(param,true);
			
			return false;
		}
	}
	
	function linkPopCloseEvent(data){
		var searchCode = data.get("searchCode");
		if(searchCode == "SHSKUMA"){
			var returnData = skumaPopup.bindPopupData(data);
			
			var openType = returnData.get("openType");
			var gridId = returnData.get("gridId");
			
			if(openType != "grid" || gridId != "gridList"){
				return;
			}
			var list = [];
			
			var data = new DataMap();
			data.put(configData.GRID_ROW_NUM,returnData.get("rowNum"));
			data.put("SKUKEY",returnData.get("colValue"));
			
			list.push(data);
			
			var param = new DataMap();
			param.put("list",list);
			
			netUtil.send({
				url : "/wms/admin/json/selectMP01SkuName.data",
				param : param,
				successFunction : "setColSkuNamesCallBack",
				failFunction : "setColSkuNamesFailCallBack"
			});
			
			$("#"+returnData.get("gridId")).find("input").blur();
			gridList.setColFocus(returnData.get("gridId"), returnData.get("rowNum"), "TRLT06")
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var wareky = "<%=wareky%>";
		
		var param = new DataMap();
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", wareky);
			return param;
			
		}else if(comboAtt == "WmsAdmin,AREACOMBO"){
			param.put("WAREKY",wareky);
			param.put("USARG1","STOR");
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var selectName = paramName[0].name;
			if(selectName == "LC.LOTA06" || selectName == "LOTA06"){
				param.put("CODE", "LOTA06");
				param.put("USARG1", "V");
			}
			
			return param;
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0 && isPickMapping){
			gridList.getGridBox("gridList").sortReset(true);
			
			var linkList = linkData.get("list");
			var locArr = [];
			for(var i in linkList){
				locArr.push(linkList[i].get("LOCATG"));
			}
			
			gridList.appendCols("gridList",["SORT"]);
			
			var list = gridList.getGridData(gridId,true);
			list.filter(function(element,index,array){
				var locaky = element.get("LOCAKY");
				var rowNum = element.get("GRowNum");
				var idx = locArr.indexOf(locaky);
				if(idx > -1){
					var mapData = linkList[idx];
					var skukey = mapData.get("SKUKEY");
					var lota06 = mapData.get("LOTA06");
					var chktrs = skukey + lota06;
					gridList.setRowCheck("gridList",rowNum,true);
					gridList.setColValue("gridList",rowNum,"TRSSKU",skukey);
					gridList.setColValue("gridList",rowNum,"TRSDSC",mapData.get("DESC01"));
					gridList.setColValue("gridList",rowNum,"TRLT06",lota06);
					gridList.setColValue("gridList",rowNum,"CHKTRS",chktrs);
				}
			});
			
			setTimeout(function(){
				var newList = [];
				
				var setList = gridList.getGridData(gridId,true);
				var trsList = setList.filter(function(element,index,array){
					var trssku = $.trim(element.get("TRSSKU"));
					return trssku.length > 0;
				});
				
				var trsListLen = trsList.length;
				if(trsListLen > 0){
					var trsSortList = trsList.sort(function(a,b){
						return a.get("LOCAKY") < b.get("LOCAKY") ? -1 : a.get("LOCAKY") > b.get("LOCAKY") ? 1 : 0;
					});
					
					for(var i in trsSortList){
						newList.push(trsList[i]);
					}
				}
				
				var newListLen = newList.length;
				for(var i = 0; i < newListLen; i++){
					var strLen = (newListLen).toString().length;
					var strRow = (i).toString().length;
					var lpad = "";
					var lpadLen = strLen - strRow;
					if(lpadLen > 0){
						for(var j = 0; j < lpadLen; j++){
							lpad = lpad + "0";
						}
					}
					
					var row = newList[i];
					var rowNum = row.get("GRowNum");
					gridList.setColValue(gridId, rowNum, "SORT", lpad + i);
				}
				
				gridList.addSort("gridList","SORT",true,true);
			});
		}
	}
	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
		if( gridId == "gridList" ){
			var bagYn = gridList.getColData(gridId, rowNum, "BAGYN");
			if( bagYn == "Y" ){
				return true;
			}
		}
	}
	
	function gridListRowTextColorChange(gridId, rowNum, removeType){
		if(gridId == "gridList"){
			var bagYn = gridList.getColData(gridId, rowNum, "BAGYN");
			if( bagYn == "Y" ){
				return "bagYn";
			}
		}
	}
	
	function print(){
		var head = gridList.getSelectData("gridList");
		if (head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		var param = dataBind.paramData("searchArea");
		
		param.put("PROGID" , configData.MENU_ID);
		param.put("PRTCNT" , 1);
		param.put("head",head);
		
		var json = netUtil.sendData({
			url : "/wms/admin/json/printMP01.data",
			param : param
		});
		
		if ( json && json.data ){
				var url = "<%=systype%>" + "/location_label2.ezg";
				var width = 316;
				var height=203;

				
				var where = "PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url , where , "" , langKy, map , width , height );
				
				
		}
	}
	
	function showExcelUpload(){
		var listLen = gridList.getGridDataCount("gridList");
		if(listLen == 0){
			commonUtil.msgBox("조회된 데이터가 없습니다.\n조회 후 진행해 주세요.");
			return;
		}
		
		$("#mp01ExcelUpload").show();
	}
	
	function hideExcelUpload(){
		$("#mp01ExcelUpload").hide();
		initFileList();
		cancelFile();
	}
	
	function excelUpload(){
		if(excelFileList.length == 0){
			commonUtil.msgBox("엑셀 파일을 등록해 주세요.");
			return;
		}
		
		var fileName = excelFileList[0].name;
		var fileExt= fileName.split(".")[1].toUpperCase();
		if(fileExt != "XLS" && fileExt != "XLSX"){
			initFileList();
			commonUtil.msgBox("엑셀 파일만 등록 할 수 있습니다.");
			return;
		}
		
		$("#mp01ExcelUpload").hide();
		
		var $form = $("#excelUploadForm").find("form");
		var formData = new FormData($form[0]);
			formData.append("excelFile", (excelFileList.length > 0)?excelFileList[0]:null);
		$.ajax({
			url:"/wms/admin/getMP01ExcelData.data",
			data:formData,
			type:"POST",
			enctype:"multipart/form-data",
			processData:false,
			contentType:false,
			dataType:"json",
			cache:false,
			beforeSend : function(){
				$("#mp01ContentLoading").show();
			},
			error : function(a, b, c){
				cancelFile();
				$("#mp01ContentLoading").hide();
				
				setTimeout(function(){
					var errMsg = a.responseText;
					if(errMsg.indexOf("Session empty") > -1){
						commonUtil.msgBox("세션이 만료되어 로그인 화면으로 이동합니다.");
						window.top.location.href = "/index.jsp";
					}else{
						errMsg = commonUtil.replaceAll(errMsg, "\r\n", "");
						commonUtil.msgBox(errMsg);
					}
				}, 700);
			},
			success:function(json){
				cancelFile();
				
				if(json && json.data){
					var data = json.data;
					var dataLen = data.length;
					if(dataLen > 0){
						var chkList = [];
						for(var i = 0; i < dataLen; i++){
							var row = data[i];
							var locaky = row["LOCAKY"];
							var trssku = row["TRSSKU"];
							if((locaky != null && locaky != undefined && $.trim(locaky) != "")
									&& (trssku != null && trssku != undefined && $.trim(trssku) != "")){
								chkList.push(row);
							}
						}
						
						var chkListLen = chkList.length;
						if(chkListLen > 0){
							var list = gridList.getGridData("gridList", true);
							var listLen = list.length;
							if(listLen > 0){
								for(var i = 0; i < chkListLen; i++){
									var chkListRow = chkList[i];
									var chkKey = chkListRow["LOCAKY"];
									var filterList = list.filter(function(element,index,array){
										var filterKey = element.get("LOCAKY");
										return filterKey == chkKey
									});
									if(filterList.length > 0){
										var rowNum = filterList[0].get("GRowNum");
										var trssku = chkListRow["TRSSKU"];
										var trlt06 = chkListRow["TRLT06"];
										
										if(trlt06 != null && trlt06 != undefined && $.trim(trlt06) != ""){
											var trlt06Len = trlt06.length;
											if(trlt06Len == 1){
												trlt06 = "0" + trlt06;
											}
										}
										
										gridList.setColValue("gridList", rowNum, "TRSSKU", trssku);
										gridList.setColValue("gridList", rowNum, "TRLT06", trlt06);
										gridList.setRowCheck("gridList", rowNum, true);
									}
								}
								
								var colList = gridList.getSelectData("gridList", true);
								var colListLen = colList.length;
								if(colListLen > 0){
									var paramList = [];
									for(var i = 0; i < colListLen; i++){
										var colListRow = colList[i];
										var paramListMap = new DataMap();
										paramListMap.put(configData.GRID_ROW_NUM,colListRow.get("GRowNum"));
										paramListMap.put("SKUKEY",colListRow.get("TRSSKU"));
										
										paramList.push(paramListMap);
									}
										
									var param = new DataMap();
									param.put("list",paramList);
									
									netUtil.send({
										url : "/wms/admin/json/selectMP01SkuName.data",
										param : param,
										successFunction : "setColSkuNamesCallBack",
										failFunction : "setColSkuNamesFailCallBack"
									});	
								}
							}else{
								cancelFile();
								$("#mp01ContentLoading").hide();
							}
						}else{
							cancelFile();
							$("#mp01ContentLoading").hide();
						}
					}else{
						cancelFile();
						$("#mp01ContentLoading").hide();
					}
				}else{
					cancelFile();
					$("#mp01ContentLoading").hide();
				}
			}
		});
	}
	
	function setExcelFileEvent(){
		var $excelDown = $("#mp01ExcelUpload .excelUploadWrap .excelUploadGuide .excelUploadGuideContent ul li .excelDown");
		$excelDown.unbind("mouseover").on("mouseover",function(){
			$(this).addClass("focus");
		});
		$excelDown.unbind("mouseleave").on("mouseleave",function(){
			$(this).removeClass("focus");
		});
		
		var fileOn = "/common/theme/gsfresh/images/icon/ico_drag_on.png";
		var fileOff = "/common/theme/gsfresh/images/icon/ico_drag_off.png";
		var $excelFileDropZone = $("#excelUploadForm");
		var $excelFileInput = $("[name=excelFile]");
		var $fileImg = $(".noFileImg").find("img");
		
		$excelFileDropZone.unbind("click").on("click",function(e){
			e.stopPropagation();
			e.preventDefault();
			$excelFileInput.trigger("click");
		});
		$excelFileDropZone.unbind("dragenter").on("dragenter",function(e){
			e.stopPropagation();
			e.preventDefault();
			$excelFileDropZone.css("background-color","#efefef");
			$excelFileDropZone.attr("src",fileOn);
		});
		$excelFileDropZone.unbind("dragleave").on("dragleave",function(e){
			e.stopPropagation();
			e.preventDefault();
			$excelFileDropZone.css("background-color","#ffffff");
			$fileImg.attr("src",fileOff);
		});
		$excelFileDropZone.unbind("dragover").on("dragover",function(e){
			e.stopPropagation();
			e.preventDefault();
			$excelFileDropZone.css("background-color","#efefef");
			$fileImg.attr("src",fileOn);
		});
		$excelFileDropZone.unbind("drop").on("drop",function(e){
			e.preventDefault();
			
			$fileImg.attr("src",fileOff);
			$excelFileDropZone.css("background-color","#ffffff");

			var files = e.originalEvent.dataTransfer.files;
			if(files != null){
				if(files.length < 1){
					alert("폴더 업로드 불가");
					return;
				}
				selectFile(files,$excelFileInput)
			}else{
				alert("ERROR");
			}
		});
	}
	
	function selectFile(files){
		if(files != null){
			excelFileList = [];
			
			var fileName = files[0].name;
			var fileNameArr = fileName.split("\.");
			var ext = fileNameArr[fileNameArr.length - 1];
			
			var formatSize = "";
			var fileSize = files[0].size;
			if(fileSize < 0){
				formatSize = fileSize + "BYTE";
			}else if(fileSize > 1024 && fileSize < (1024*1024)){
				formatSize = Math.round(fileSize/1024,2) + "KB";
			}else{
				formatSize = Math.round(fileSize/(1024*1024),2) + "MB";
			}
			
			excelFileList.push(files[0]);
			
			drawExcelFile(files[0],fileName,ext,formatSize);
		}else{
			alert("ERROR");
		}	
	}
	
	function changeFile($obj){
		selectFile($obj.files);
	}
	
	function gridExcelDownloadEventBefore(gridId){
		var param  = new DataMap();
		if(gridId == "gridList"){
			param.put(configData.DATA_EXCEL_COL_KEY_VIEW,"true");
		}
		return param;
	}
	
	function initFileList(){
		excelFileList = [];
		var $fileInput = $("input[name=excelFile]"); 
		if (Browser.ie) {
			$fileInput.replaceWith( $fileInput.clone(true) );
		} else {
			$fileInput.val("");
		}
	}
	
	function drawExcelFile(file,fileName,ext,fileSize){
		var $inf = $("#excelUploadRegForm");
		var $init = $("#excelUploadForm");
		
		var $fileNm = $("#regFileName");
		var $fileSize = $("#regFileSize");
		
		$fileNm.text("");
		$fileSize.text("");
		
		$fileNm.text(fileName);
		$fileSize.text(fileSize);
		
		$inf.show();
		$init.hide();
	}
	
	function cancelFile(){
		var $inf = $("#excelUploadRegForm");
		var $init = $("#excelUploadForm");
		
		var $fileNm = $("#regFileName");
		var $fileSize = $("#regFileSize");
		
		$fileNm.text("");
		$fileSize.text("");
		
		$inf.hide();
		$init.show();
		
		initFileList();
	}
	
	function linkExcelDown(){
		$("#gridList").parent().parent().parent().next().find("button[gbtn=excel]").trigger("click");
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
		<button CB="Clear WCANCLE BTN_RMVLOC"></button>
		<button CB="Print PRINT BTN_PRTLOC"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect top" id="searchArea">
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
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_AREAKY">창고</th>
											<td>
												<select id="AREAKY" name="LC.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" UISave="false" ComboCodeView=false style="width:160px"></select>
											</td>
											<th CL="STD_ZONEKY">존</th>
											<td>
												<input type="text" name="LC.ZONEKY" UIInput="SR,SHZONSR" UIFormat="U 10"/>
											</td>
										</tr>
										<tr>
											<th CL="STD_LOCAKY"></th>
											<td>
												<input type="text" name="LC.LOCAKY" UIInput="SR,SHLOCSR" UIFormat="U 13"/>
											</td>
											<th CL="STD_SKUKEY"></th>
											<td>
												<input type="text" name="LC.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U 20" />
											</td>
											<th CL="STD_LOTA06"></th>
											<td>
												<select id="LOTA06" name="LC.LOTA06" Combo="Common,COMCOMBO" comboType="MS" ComboCodeView=false style="width:160px">
													<option value=" " CL="STD_NODATA">없음</option>
												</select>
											</td>
										</tr>
										<tr>
											<th CL="STD_BEFSKU"></th>
											<td>
												<input type="text" name="LC.BEFSKU" UIInput="SR,SHSKUMA" UIformat="U 20" />
											</td>
											<th CL="STD_STOKYN"></th>
											<td>
												<select name="STOKYN" style="width:160px">
													<option value="" CL="STD_ALL"></option>
													<option value="Y">Y</option>
													<option value="N">N</option>
												</select>
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
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"      GCol="rownum">1</td>
												<td GH="40"             GCol="rowCheck"></td>
												<td GH="100 STD_WAREKY" GCol="text,WARENM,center"></td>
												<td GH="100 STD_AREAKY" GCol="text,AREANM"></td>
												<td GH="100 STD_ZONEKY" GCol="text,ZONEKY"></td>
												<td GH="100 STD_LOCAKY" GCol="text,LOCAKY"></td>
												<td GH="100 STD_TASKTY" GCol="text,TASKTY"></td>
												<td GH="120 STD_SKUKEY" GCol="text,SKUKEY"></td>
												<td GH="200 STD_DESC01" GCol="text,DESC01"></td>
												<td GH="100 STD_LOTA06" GCol="text,LT06NM,center"></td>
												<td GH="100 STD_STOKYN" GCol="text,STOKYN,center"></td>
												<td GH="150 STD_TRSSKU" GCol="input,TRSSKU,SHSKUMA" validate="required"></td>
												<td GH="200 STD_TRSDSC" GCol="text,TRSDSC"></td>
												<td GH="100 STD_TRLT06" GCol="select,TRLT06" validate="required">
													<select name="LOTA06" Combo="Common,COMCOMBO">
														<option value="" CL="STD_SELECT"></option>
													</select>
												</td>
												<td GH="120 STD_BEFSKU" GCol="text,BEFSKU"></td>
												<td GH="200 STD_BEFDSC" GCol="text,BEFDSC"></td>
												<td GH="100 STD_BEFLT6" GCol="text,BEL6NM,center"></td>
												<td GH="100 STD_STATIT" GCol="text,INSTNM"></td>
												<td GH="120 STD_TASKKY" GCol="text,TASKKY"></td>
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
									<button type="button" class="button type4" title="EXCEL 업로드" onclick="showExcelUpload();">
										<img src="/common/theme/darkness/images/ico_btn10.png">
									</button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">0 Record</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 그리드 -->
			
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<div id="mp01ExcelUpload">
	<input type="file" name="excelFile" onchange="changeFile(this);">
	<div class="excelUploadWrap">
		<div class="excelUploadTitle">
			<button class="excelUploadClose" onclick="hideExcelUpload();"></button>
		</div>
		<div class="excelUploadContent" id="excelUploadForm">
			<div class="offFile">
				<form autocomplete="off">
					<div class="fileRegWrap">
						<div class="noFileImg">
							<img src="/common/theme/gsfresh/images/icon/ico_drag_off.png">
						</div>
						<div class="noFileText">
							<p>파일을 끌어다가 놓거나 <span>클릭</span>  하여</p><p>파일을 선택 해주세요.</p>
						</div>
					</div>
				</form>
			</div>
		</div>
		<div class="excelUploadRegContent" id="excelUploadRegForm">
			<div class="onFile">
				<div class="fileRegHead">
					<button class="fileDelete" onclick="cancelFile();"></button>
				</div>
				<div class="fileReg">
					<div class="regFileIcon"></div>
					<div class="regFileInf">
						<div class="regFileName">
							<p id="regFileName"></p>
						</div>
						<div class="regFileSize">
							<p id="regFileSize"></p>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="excelUploadForm" class="excelUploadGuide">
			<div class="excelUploadGuideContent">
				<ul>
					<li>
						<p>데이터 조회 후, <span class="excelDown" onclick="linkExcelDown();">[ <img src="/common/theme/darkness/images/ico_btn9.png"> ] 버튼을 클릭</span>하여 피킹 로케이션 엑셀 파일을 다운로드 합니다.</p>
					</li>
					<li>
						<p>변경 상품코드/변경 재고상태는 필수 값 입니다.</p>
					</li>
					<li>
						<p>변경 재고상태 ( 정상  : 00 / 임박 : 10)는 코드로 입력 합니다.</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="excelUploadButton">
			<button onclick="excelUpload();">UPLOAD</button>
		</div>
	</div>
</div>
<div class="mp01ContentLoading" id="mp01ContentLoading"></div>
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>