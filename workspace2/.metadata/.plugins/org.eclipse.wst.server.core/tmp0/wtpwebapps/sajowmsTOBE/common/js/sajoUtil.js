SajoUtil = function() {
	this.uid = "";//유저 아이디	
	this.areaId = ""; //에어리어 아이디
}

SajoUtil.prototype = {
		openSaveVariantPop : function(areaId,progId){ // save variant 팝업을 연다
			
			var map = this.getAreadData(areaId);
			map.put("PROGID", progId); 
			map.put("AREAID", areaId);
			
			var option = "height=200,width=900,resizable=yes";
			page.linkPopOpen("/wms/system/pop/SaveVariantDialog.page", map, option);
		},
		openGetVariantPop : function(areaId,progId){ // save variant 팝업을 연다
			
			var map = this.getAreadData(areaId);
			map.put("PROGID", progId);
			
			var option = "height=600,width=900,resizable=yes";
			page.linkPopOpen("/wms/system/pop/GetVariantDialog.page", map, option);
		},
		getAreadData : function(areaId, map){ //서치 데이터를 가져온다.
			if(!map){ 
				map = new DataMap();
			}
			
			map.put("SEARCH", dataBind.paramData(areaId));

			var rParam = inputList.getRangeDataParam();
			//param.put(configData.INPUT_PARAM_GROUP, pgroupMap);
			if(rParam.containsKey(configData.INPUT_PARAM_GROUP)){
				map.put(configData.INPUT_PARAM_GROUP, rParam.get(configData.INPUT_PARAM_GROUP));
				rParam.remove(configData.INPUT_PARAM_GROUP);
			}
			
			map.put(configData.VARIANT_RANGE_PARAM, rParam); 
			 
			return map;
		},
		saveVariant : function(map) {
			if(!map){ 
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
    		var param = window.opener.sajoUtil.getAreadData(map.get("AREAID"));
    		param.put("PROGID", map.get("PROGID"));
    		param.put("PARMKY", map.get("PARMKY"));
    		param.put("SHORTX", map.get("SHORTX"));
    		param.put("USERID", map.get("USERID"));
    		param.put("DEFCHK", map.get("DEFCHK"));
			
			var json = netUtil.sendData({
				url : "/system/json/saveVariant.data",
				param : param,
				successFunction : "successSaveCallBack"
				
			});
			
			if(json && json.data && json.data == "S"){
				commonUtil.msgBox("MASTER_M0999"); 
				page.linkPopClose(json);
			}
		},
		
		deleteVariant : function(map) {
			if(!map){ 
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
    		var param = new DataMap();
	    		param.put("PROGID", map.PROGID);
	    		param.put("PARMKY", map.PARMKY);
	    		param.put("USERID", map.USERID);
			
			var json = netUtil.sendData({
				url : "/system/json/deleteVariant.data",
				param : param,
				successFunction : "successSaveCallBack"
				
			});
			
			if(json && json.data && json.data == "S"){
				commonUtil.msgBox("MASTER_M0999"); 
				searchList();
			}
		},
		
		setVariant : function(areaId, map) { 
			if(!map){ 
				map = new DataMap();
			}
 
			var json = netUtil.sendData({
				url : "/system/json/getVariant.data",
				param : map
			});

			if(json && json.data){
				var list = json.data.list;

				var $dataRange = commonUtil.getArea(areaId);
				
				//전체 input을 reset한다
				$dataRange.find("input").each(function(i, findElement){
					var $obj = jQuery(findElement);
					var type = $obj.attr("type");

					if(!$obj.attr("name")){
						return; 
					}
 
					if(type == "text"){ 
						var $rangeObj = inputList.rangeMap.get($obj.attr('name'));
	                
						if(!inputList.rangeMap.get($obj.attr('name')) || !inputList.rangeMap.get($obj.attr('name')).formatAtt || inputList.rangeMap.get($obj.attr('name')).formatAtt.indexOf("C") == -1){
							//inputList.rangeMap.get($obj.attr('name')).formatAtt
							if(inputList.rangeMap.get($obj.attr('name')) && inputList.rangeMap.get($obj.attr('name')).inputAtt && inputList.rangeMap.get($obj.attr('name')).inputAtt.indexOf("SR") != -1){// SR
								inputList.resetRange($obj.attr('name'));
							}else if(inputList.rangeMap.get($obj.attr('name')) && inputList.rangeMap.get($obj.attr('name')).inputAtt && inputList.rangeMap.get($obj.attr('name')).inputAtt.indexOf("B") != -1){ // BETWEEN
								inputList.resetRange($obj.attr('name'));
							}else{
								if($obj.attr("UIFormat") && $obj.attr("UIFormat").indexOf("C") != -1){
									//미적용
								}else{ 
									$obj.val("");
								}
							}
						}
					}
				});
				  
				if(list.length >  0){
					for(var i=0; i<list.length; i++){
						var dataMap = list[i]; 
						this.setInputValue(areaId, dataMap);
					}
				}
			}
		},
		
		setMultiRange : function (rangeId, data){
			var $rangeObj = inputList.rangeMap.get(rangeId);
			
			if($rangeObj){
				var rangeList = data.split(configData.DATA_ROW_SEPARATOR);
				//초기화 
				inputList.rangeMap.map[rangeId].singleData = new Array(); 
				inputList.rangeMap.map[rangeId].rangeData = new Array(); 
				
				for(var i=0; i<rangeList.length; i++){
					var rangeStrArr =  rangeList[i].split(configData.DATA_COL_SEPARATOR);
					var rangeDataMap = new DataMap();
					 
					if(rangeStrArr[0] && rangeStrArr[0] != ""){
	
						//넘어온 값 세팅
						rangeDataMap.put(configData.INPUT_RANGE_OPERATOR, rangeStrArr[0]);
						rangeDataMap.put(configData.INPUT_RANGE_RANGE_FROM, rangeStrArr[1]);
						rangeDataMap.put(configData.INPUT_RANGE_RANGE_TO, rangeStrArr[2]);
	
						//값이 여러개면 or and 등 조건 추가
						if(rangeList.length > 1){
							rangeDataMap.put(configData.GRID_ROW_NUM, i);
							rangeDataMap.put(configData.GRID_ROW_STATE_ATT, "C");//고정?
						}
						
						inputList.rangeMap.map[rangeId].rangeData.push(rangeDataMap);
					}
				}

				inputList.rangeMap.get(rangeId).setMultiData(false);
			}
			 
		},  
		
		setRange : function (rangeId, data){
			var $rangeObj = inputList.rangeMap.get(rangeId);
			
			if($rangeObj){
				var rangeList = data.split(configData.DATA_ROW_SEPARATOR);
				inputList.rangeMap.map[rangeId].singleData = new Array(); 
				
				for(var i=0; i<rangeList.length; i++){
					var rangeStrArr =  rangeList[i].split(configData.DATA_COL_SEPARATOR);
					var rangeDataMap = new DataMap();
					 
					if(rangeStrArr[0] && rangeStrArr[0] != ""){
	
						//넘어온 값 세팅
						rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, rangeStrArr[1]);
						rangeDataMap.put(configData.INPUT_RANGE_OPERATOR, rangeStrArr[0]);
						rangeDataMap.put(configData.INPUT_RANGE_LOGICAL, rangeStrArr[2]);
	
						//값이 여러개면 or and 등 조건 추가
						if(rangeList.length > 1){
							rangeDataMap.put(configData.GRID_ROW_NUM, i);
							rangeDataMap.put(configData.GRID_ROW_STATE_ATT, "C");//고정?
						}
						
						inputList.rangeMap.map[rangeId].singleData.push(rangeDataMap);
					}
				}

				inputList.rangeMap.get(rangeId).setMultiData(false);
			}
		},
		
		setInputValue : function (areaId, data){
			var $dataRange = commonUtil.getArea(areaId);
			
			// 단순 input의 경우 name을 키로 value를 저장해준다.
			$dataRange.find("input").each(function(i, findElement){
				var $obj = jQuery(findElement);
				var type = $obj.attr("type");	
				
				if(!$obj.attr("name")){
					return; 
				}
				
				if($obj.attr("name") == data.CTRLID){
					
					if(type == "checkbox"){
						if(data.CTRVAL == "on" || data.CTRVAL == "V"){
							$obj.prop("checked",true);
						}else{
							$obj.prop("checked",false);
						}
							
					}else if(type == "radio"){
//						$("input:radio[name='"+$obj.attr('name')+"']:radio[value='"+data.CTRVAL+"']").prop('checked', true);
						
						$("input:radio[name='"+$obj.attr('name')+"']").each(function () {
			    			$(this).attr('checked', false);
			    		});
						if ( $("input:radio[name='"+$obj.attr('name')+"']:radio[value='"+data.CTRVAL+"']").length > 0 ){
							$("input:radio[name='"+$obj.attr('name')+"']:radio[value='"+data.CTRVAL+"']").prop('checked', true);
							$("input:radio[name='"+$obj.attr('name')+"']:radio[value='"+data.CTRVAL+"']").trigger("click");
						}else{

							$("input:radio[name='"+$obj.attr('name')+"']").prop('checked', true);
							$("input:radio[name='"+$obj.attr('name')+"']").trigger("click");
						}
						
						  
					}else{   
						if(!inputList.rangeMap.get($obj.attr('name')) || !inputList.rangeMap.get($obj.attr('name')).formatAtt || inputList.rangeMap.get($obj.attr('name')).formatAtt.indexOf("C") == -1 || data.CTRLTY != "C"){
							if(data.CTRLTY == "SR" || data.CTRLTY == "R"){
								
								if($obj.attr("UIFormat") && $obj.attr("UIFormat").indexOf("C") != -1){ 
								  
								}else{
									//레인지 처리   
									if(data.CTRLTY == "SR"){ 
										sajoUtil.setRange($obj.attr('name'), data.CTRVAL);
									}else if(data.CTRLTY == "R"){ 
										sajoUtil.setMultiRange($obj.attr('name'), data.CTRVAL);
									}
								} 
								
								   
							}else{
								if(data.CTRLTY != "C"){
									$obj.val(data.CTRVAL);
								}
							} 
						}  
					}
				}
			});
			

			// 단순 select 경우 name을 키로 value를 저장해준다.
			$dataRange.find("select").each(function(i, findElement){   
				var $obj = jQuery(findElement);
				if(!$obj.attr("name")){     
					return;
				}

				if($obj.attr("name") == data.CTRLID && data.CTRLTY == "C"){ 

					var comboTypeAttr = $obj.attr(configData.INPUT_COMBO_TYPE);
					if(comboTypeAttr){
						//멀티셀렉트
						var str = data.CTRVAL.replaceAll("'", "");
						var values = str.split(",");
						
						inputList.multiComboMap.get($obj.attr('name')).multipleSelect("setSelects", values);
					}else{
						var multiCheck = $dataRange.find("[name='"+$obj.attr('name')+"']").length;
						if(multiCheck > 1){
							//미구현 
						}else{
							$obj.val(data.CTRVAL).prop("selected", true);
							$obj.trigger('change');	
						}
					}
				} 
			});
			

			// 단순 textarea 경우 name을 키로 value를 저장해준다.
			$dataRange.find("textarea").each(function(i, findElement){
				var $obj = jQuery(findElement);
				if(!$obj.attr("name")){
					return;
				}
				if($obj.attr("name") != data.CTRLID){
					$obj.val(data.CTRVAL);
				}
				 
			});
		},
		
		setDefVariant : function(areaId, map) { 
			if(!map){ 
				map = new DataMap();
			}
 
			var json = netUtil.sendData({
				url : "/system/json/getDefVariant.data",
				param : map
			}); 

			if(json && json.data){
				var list = json.data.list;

				var $dataRange = commonUtil.getArea(areaId);
				    
				if(list.length >  0){
					
					//전체 input을 reset한다
					$dataRange.find("input").each(function(i, findElement){
						var $obj = jQuery(findElement);
						var type = $obj.attr("type");

						if(!$obj.attr("name")){
							return; 
						}

						if(type == "text"){  
							var $rangeObj = inputList.rangeMap.get($obj.attr('name'));
		                
							if(!inputList.rangeMap.get($obj.attr('name')) || !inputList.rangeMap.get($obj.attr('name')).formatAtt || inputList.rangeMap.get($obj.attr('name')).formatAtt.indexOf("C") == -1){
								//inputList.rangeMap.get($obj.attr('name')).formatAtt
								if(inputList.rangeMap.get($obj.attr('name')) && inputList.rangeMap.get($obj.attr('name')).inputAtt && inputList.rangeMap.get($obj.attr('name')).inputAtt.indexOf("SR") != -1){// SR
									inputList.resetRange($obj.attr('name'));
								}else if(inputList.rangeMap.get($obj.attr('name')) && inputList.rangeMap.get($obj.attr('name')).inputAtt && inputList.rangeMap.get($obj.attr('name')).inputAtt.indexOf("B") != -1){ // BETWEEN
									inputList.resetRange($obj.attr('name'));
								}else{
									if($obj.attr("UIFormat") && $obj.attr("UIFormat").indexOf("C") != -1){
										//미적용
									}else{ 
										$obj.val(""); 
									}
								}
							}
						}
					});
					
					
					for(var i=0; i<list.length; i++){
						var dataMap = list[i]; 
						this.setInputValue(areaId, dataMap);
					}
				}
			}
		},openSaveLayoutPop : function(gridId,progId){ // save variant 팝업을 연다
			var layoutData;
			var map = new DataMap();
			map.put("PROGID", progId); 
			map.put("GRIDID", gridId); 

			layoutData = gridList.getGridBox(gridId).getLayOutData()
			
			map.put("GROUPDATA", layoutData); 
			
			var option = "height=200,width=900,resizable=yes";
			page.linkPopOpen("/wms/system/pop/SaveLayoutDialog.page", map, option);
		},
		openGetLayoutPop : function(gridId,progId){ // save variant 팝업을 연다

			var map = new DataMap();
			map.put("PROGID", progId); 
			map.put("GRIDID", gridId); 
			
			var option = "height=600,width=900,resizable=yes";
			page.linkPopOpen("/wms/system/pop/GetLayoutDialog.page", map, option);
		},
		saveLayout : function(map) {
			if(!map){ 
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
			var json = netUtil.sendData({
				url : "/system/json/saveLayOut.data",
				param : map,
				successFunction : "successSaveCallBack"
				
			});
			
			if(json && json.data && json.data == "S"){
				commonUtil.msgBox("MASTER_M0999"); 
				page.linkPopClose(json);
			}
		},
		
		setLayout : function(map) { 
			var gridId = map.get("GRIDID");
			var gridBox = gridList.getGridBox(gridId);
			//gridBox.layoutDataMap.put(map.get("LYOTID"), map.get("LAYDAT"));
			//
			//gridBox.createLayoutData(gridBox.layoutDataMap.get(map.get("LYOTID")));
			gridBox.layoutDataMap.put("DEFAULT", map.get("LAYDAT"));
			gridBox.createLayoutData(gridBox.layoutDataMap.get("DEFAULT"));
			gridBox.setLayout(true);

	
			
		},
		
		deleteLayout : function(map) {
			if(!map){ 
				commonUtil.msgBox("VALID_M0006");
				return;
			}
			
			var param = new DataMap();
			param.put("PROGID", map.PROGID);
			param.put("COMPID", map.COMPID);
			param.put("LYOTID", map.LYOTID);
			
			var json = netUtil.sendData({
				url : "/system/json/deleteLayout.data",
				param : param,
				successFunction : "successSaveCallBack"
				
			});
			
			if(json && json.data && json.data == "S"){
				commonUtil.msgBox("MASTER_M0999"); 
				searchList();
			}
		},bakupLayerPopOpen : function(map){ // save variant 팝업을 연다

			var option = "height=600,width=900,resizable=yes";
			page.linkPopOpen("/wms/system/pop/GetLayoutDialogBak.page", map, option);
		}
}

var sajoUtil = new SajoUtil();


//Date function 확장 
Date.prototype.yyyymmdd = function() {
	var mm = this.getMonth() + 1; // getMonth() is zero-based
	var dd = this.getDate();
	return [this.getFullYear(),	(mm>9 ? '' : '0') + mm, (dd>9 ? '' : '0') + dd].join('');
};

//Date function 확장2
Date.prototype.yyyymmdd2 = function() {
	var mm = this.getMonth() + 1; // getMonth() is zero-based
	var dd = this.getDate();
	return [this.getFullYear(),	(mm>9 ? '' : '0') + mm, (dd>9 ? '' : '0') + dd].join('.');
};

function strToDate(str){
    var y = str.substr(0, 4);
    var m = str.substr(4, 2);
    var d = str.substr(6, 2);
    return new Date(y, m-1, d);
}

//날짜 파싱 ('yyyymmdd', type(D(Date), S(String)), chnage Y, change M, change D)
function dateParser(str, type, cy, cm, cd) {
	var date;
	
	if(str){
		date = strToDate(str);
	}else{
		date = new Date();
	}

    cy = cy ? cy : 0;
    cm = cm ? cm : 0;
    cd = cd ? cd : 0;
    type = type ? type : 'S';
    
    //년월일 변경 있으면 적용
    //년
    if(cy != 0) date = new Date(date.setFullYear(date.getFullYear() + cy));
    
    //월
    if(cm != 0) date = new Date(date.setMonth(date.getMonth() + cm));

    //일
	if(cd != 0) date = new Date(date.setDate(date.getDate() + cd));
    
    if(type ==  'S'){ //일반 날짜 YYYYMMDD
    	return date.yyyymmdd();
    }else if(type ==  'SD'){//캘린더 날짜 YYYY.MM.DD
    	return date.yyyymmdd2();
    }else if(type ==  'D'){//데이트
    	date;
    }
    
    return date;
}