SkumaPopup = function(){
	this.popData = new DataMap();
	this.width   = 1200;
	this.height  = 800;
}

SkumaPopup.prototype = {
	set : function(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8){
		this.popData.put("searchCode",arg1);
		this.popData.put("multyType",arg2);
		this.popData.put("name",arg3);
		this.popData.put("rowNum",arg4);
		this.popData.put("openType",arg5);
		this.popData.put("gridId",arg6);
		this.popData.put("param",arg7);
		this.popData.put("isLink",arg8);
	},
		
	open : function(paramData,isLink){
		skumaPopup.popData = new DataMap();
		
		var searchCode = "";
		var multyType  = "";
		var $inputObj  = "";
		var rowNum     = "";
		var name       = "";
		var openType   = "";
		var gridId     = "";
		var param      = (paramData != undefined && paramData != null && (typeof paramData == "object" && !paramData.isEmpty()))?paramData:new DataMap();
		var link       = isLink == true?isLink:false; 
		
		var arg = searchHelpEventOpenBefore.arguments;
		if(arg != undefined && arg != null && arg.length > 0){
			searchCode = arg[0];
			multyType  = arg[1];
			$inputObj  = arg[2];
			rowNum     = arg[3];
			openType   = this.getOpenType(rowNum);
			name       = (this.isObject($inputObj) && openType == "search")?$inputObj.name:(this.isObject($inputObj) && openType == "grid")?$inputObj.attr("name"):"";
			gridId     = openType =="grid"?$inputObj.attr("gridId"):"";
		}
		
		if(link && openType == "search"){
			var singleDataLength = inputList.rangeMap.get(name).singleData.length;
			var rangeDataLength  = inputList.rangeMap.get(name).rangeData.length;
			
			if(singleDataLength == 0 && rangeDataLength == 0){
				var $inputObj = inputList.rangeMap.get(name).$obj;
				var inputData = $inputObj.next().val();
				param.put("LINK_DATA",inputData);
			}
		}
		
		this.set(searchCode,multyType,name,rowNum,openType,gridId,param,link);
		
		this.openPopup();
	},
	
	openPopup : function(){
		var url   = "/wms/inventory/POP/SKUMA_POP.page";
		var param = this.popData;
		var option = "height=" + (this.height) + ",width=" + (this.width) + ",resizable=yes";
		
		page.linkPopOpen(url, param, option);
	},
	
	bindPopupData : function(bindData){
		var popupData = this.popData;
		var data = bindData;
		
		var openType = popupData.get("openType");
		switch (openType) {
		case "search":
			var name = popupData.get("name");
			
			var singleList = [];
			var dataList = data.get("returnData");
			var dataLen  = dataList.length;
			for(var i = 0; i < dataLen; i++){
				var rangeMap = new DataMap();
				rangeMap.put(configData.INPUT_RANGE_LOGICAL, "OR");
				rangeMap.put(configData.INPUT_RANGE_OPERATOR, "E");
				rangeMap.put(configData.INPUT_RANGE_SINGLE_DATA, dataList[i]);
				singleList.push(rangeMap);
			}
			
			inputList.setRangeData(name, configData.INPUT_RANGE_TYPE_SINGLE, singleList);
			
			break;
		case "grid":
			var dataList = data.get("returnData");
			
			var openType = popupData.get("openType");
			var colName  = popupData.get("name");
			var gridId   = popupData.get("gridId");
			var rowNum   = popupData.get("rowNum");
			var colValue = dataList[0];
			
			gridList.setColValue(gridId, rowNum, colName, colValue);
			
			var returnData = new DataMap();
			returnData.put("openType",openType);
			returnData.put("gridId",gridId);
			returnData.put("rowNum",rowNum);
			returnData.put("colName",colName);
			returnData.put("colValue",colValue);
			
			return returnData;
			
			break;
		default:
			break;
		}
		
		return new DataMap();
	},
	
	exit : function(){
		this.popData = new DataMap();
	},
	
	getOpenType : function(rowNum){
		return rowNum == undefined?"search":"grid";
	},
	
	isObject : function($obj){
		if($obj == undefined && $obj == null && $obj.length == 0){
			return false;
		}
		
		return true;
	}
}

var skumaPopup = new SkumaPopup();