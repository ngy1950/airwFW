Wms = function() {
	this.$inputObj;
	this.searchOpenGridId;;
	this.param;
	this.popData;
};

Wms.prototype = {
	getDocSeq : function(docuty) {
		var param = new DataMap();
		param.put("DOCUTY", docuty);
		
		var json = netUtil.sendData({
			module : "Common",
			command : "DOCUSEQ",
			sendType : "map",
			param : param
		});
		
		return json["data"];
	},
	getTypeName : function (gridId, type, colValue, colName){
		var name = "";
		if ( $.trim(gridList.getColData(gridId,0,colName)) != ""){
			name = gridList.getColData(gridId,0,colName);
        }else{
        	 var param = new DataMap();
             param.put("LABLGR",type);
             param.put("LABLKY",colValue);
             var json = netUtil.sendData({
                 module : "WmsCommon",
                 command : "GETLABELDATA",
                 sendType : "map",
                 param : param
             });
             
        	name = json.data["LBLTXL"];
        }
		return name;
	},
	getLotLabel : function(label, rtnTyp) {
		var rtnStr = "";
		
		if(label.length == 51) {
			if(rtnTyp == "LOTA09") {
				//유통기한
				rtnStr = label.substr(-8);
			} else if(rtnTyp == "SKUKEY") {
				//제품코드
				rtnStr = label.substring(13, 22).replace(eval("/" + "P" + "/gi"), "");
			} else if(rtnTyp == "LOT") {
				//제품코드+유통기한
				rtnStr = label.substring(13, 22).replace(eval("/" + "P" + "/gi"), "") + label.substr(-8);
			}
		} else {
			rtnStr = label;
		}
		return rtnStr;
	},
	toString : function() {
		return "Wms";
	}
};

var wms = new Wms();