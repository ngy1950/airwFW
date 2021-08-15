ScanInput = function(){
	scanInputMap = new DataMap();
	
}

ScanInput.prototype = {
	setScanInput : function(option){
		var id = option.id;
		var name = option.name;
		var bindId = option.bindId;
		var type = option.type;
		if(type == undefined || type == null || $.trim(type) == ""){
			type = "text";
		}
		
		var $returnObj = $("#"+bindId+" [name="+name+"]");
		
		var initMap = new DataMap();
		initMap.put("id",id);
		initMap.put("name",name);
		initMap.put("bindId",bindId);
		initMap.put("returnObj",$returnObj);
		initMap.put("type",type);
		
		scanInputMap.put(id,initMap);
		
		scanInput.drawScanInput(id);
	},
	
	drawScanInput : function(id){
		var scanInput = scanInputMap.get(id);
		var type = scanInput.get("type");
		var bindId = scanInput.get("bindId");
		var name = scanInput.get("name");
		
		var $obj = scanInput.get("returnObj");
		var $objWrap = $obj.parent();
		
		var $div = $("<div>");
		var $inputWrap = $div.clone().addClass("scanInputArea");
		var $btn = $("<button>");
		var $scanBtn = $btn.clone().addClass("scanInputBtn");
		//if(type == "number"){
		$scanBtn.attr("onclick","scanInput.openKeyPad('"+id+"','"+bindId+"'"+",'"+type+"')");
		//}
		
		var $scanInput = $obj.clone().attr({"id":id,"type":type});
		if(type == "number"){
			if($scanInput.attr("maxlength") != undefined && $scanInput.attr("maxlength") != ""){
				$scanInput.attr("oninput","mobileCommon.numberMaxLength(this)");
			}
		}
		
		$inputWrap.append($scanInput);
		$inputWrap.append($scanBtn);
		$objWrap.append($inputWrap);
		$objWrap.find("input").eq(0).remove();
		
		setTimeout(function(){
			var $reInputObj = $("#"+bindId+" [name="+name+"]");
			$reInputObj.unbind("focus").on("focus",function(e){
				var inputId = $(this).attr("id");
				$(this).attr("readonly",true);
				setTimeout(function(){
					var $input = $("#"+inputId);
					$input.attr("readonly",false);
				});
			});
			
			$reInputObj.unbind("click").on("click",function(e){
				var inputId = $(this).attr("id");
				$(this).attr("readonly",true);
				
				setTimeout(function(){
					var $input = $("#"+inputId);
					$input.attr("readonly",false);
					
					mobileKeyPad.focusOnEvent($input);
					
					$input.focus();
					$input.select();
				});
			});

			scanInput.put("returnObj",$reInputObj);
			scanInput.put("btnObj",$scanBtn);
		});
	},
	
	scanInputEvent : function(id){
		var $obj = scanInput.get("returnObj");
		$obj.unbind("focus").on("focus",function(e){
			var inputId = $(this).attr("id");
			$(this).attr("readonly",true);
			setTimeout(function(){
				var $input = $("#"+inputId);
				$input.attr("readonly",false);
			});
		});
	},
	
	openKeyPad : function(id,bindId,type){
		var scanInput = scanInputMap.get(id);
		var $obj = scanInput.get("returnObj");
		var windowHeight = $(window).height();
		
		$obj.unbind("focus");
		
		$obj.focus();
		$obj.select();
		
		setTimeout(function(){
			mobileKeyPad.openMobileKeyPad($obj);
		});
	},
	
	enterKeyCheck : function(event, fncName) {
		if(event.keyCode == 13){
			try{
				$(event.target).blur();
				setTimeout(function(){
					eval(fncName);
				});
			}catch(e){
				console.debug(fncName);
			}			
		}
	}
}

var scanInput = new ScanInput();