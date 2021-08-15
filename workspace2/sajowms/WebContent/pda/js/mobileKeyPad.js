MobileKeyPad = function(){
	this.pdaHeight = 0;
	this.keyPadHeight = 244;
	this.fixHeight = 150;
	
	this.currentAreaMap = new DataMap();
	
	this.searchAreaClass = ".tem6_search";
	this.searchAreaButtonClass = ".tem6_search_btn";
	this.searchAreaContentClass = ".tem6_search_content";
	
	this.contentAreaClass = ".tem6_content";
	
	this.virtualKeypadAreaClass = ".virtual-keypad-area";
	this.virtualKeypadArea = "virtual-keypad-area";
	
	this.gridHeight = 0;
	this.isClose = true;
	this.gridId = "";
	this.gridEnterType = false;
	
	this.areaObjHeight = 0;
}

MobileKeyPad.prototype = {
	setInputAreaFormatAll : function(){
		var $searchArea = $(".tem6_search").find("table");
		if($searchArea.length > 0){
			var areaId = $searchArea.attr("id");
			mobileKeyPad.setInputAreaFormat(areaId);
		}
		
		var $scanArea = $(".scan_area").find("table");
		if($scanArea.length > 0){
			var areaId = $scanArea.attr("id");
			mobileKeyPad.setInputAreaFormat(areaId);
		}
		
		var $detailArea = $(".detailArea");
		if($detailArea.length > 0){
			var areaId = $detailArea.attr("id");
			mobileKeyPad.setInputAreaFormat(areaId);
		}
		
		$("#pageTransform").fadeOut(600,function(){
			$(this).remove();
		});
	},	
		
	setInputAreaFormat : function(areaId){
		$("#"+areaId+" input").not("[readonly=readonly],.input_btn,[type=checkbox]").each(function(){
			if(!$(this).parent().hasClass("scanInputArea")){
				mobileKeyPad.formatInput($(this));
			}
		});
	},
	
	formatInput : function($obj){
		if($obj[0].type != "hidden"){
			if(!$obj.hasClass("input_default")){
				$obj.addClass("input_default");
			}
		}
		var isNumber = false;
		var format = $obj.attr("uiformat");
		if(format != undefined && format != null && format != ""){
			if(format.indexOf(" ") > -1){
				var type = format.split(" ")[0];
				if(type == "N" || type == "NS"){
					$obj.attr("type","tel");
					var maxLength = format.split(" ")[1];
					if(maxLength.indexOf(".") > -1){
						
					}else{
						if(maxLength != undefined && maxLength != null && maxLength != ""){
							var max = commonUtil.parseInt(maxLength);
							if(max > 0){
								//$obj.attr("oninput","mobileCommon.numberMaxLength(this)");
							}
						}
					}
					if(type == "N"){
						isNumber = true;
					}
				}
			}
		}
		
		if(!commonUtil.isMobile()){
			$obj.on("click",function(){
				var isReadOnly = $(this).attr("readonly");
				if(isReadOnly == "readonly"){
					return;
				}
				if(isNumber){
					var value = $(this).val();
					$(this).val(commonUtil.replaceAll(value,",",""));
				}
				
				setTimeout(function(){
					if($obj.val().length > 0 && !$obj.hasClass("on")){
						$obj.select();
						$obj.addClass("on");
					}else{
						$obj.focus();
					}
				});
				
				mobileKeyPad.focusOnEvent($obj);
			});
			
			$obj.blur(function(){
				$obj.removeClass("on");
			});
			
			$obj.on("keydown",function(e){
				if(e.keyCode == 13){
					$(this).blur();
					$obj.removeClass("on");
				}
			});	
			
			return;
		}
		
		$obj.on("click",function(){
			var isReadOnly = $(this).attr("readonly");
			if(isReadOnly == "readonly"){
				return;
			}
			
			if(isNumber){
				var value = $(this).val();
				$(this).val(commonUtil.replaceAll(value,",",""));
			}
			
			$obj.blur(function(){
				$obj.removeClass("on");
			});
			
			mobileKeyPad.openMobileKeyPad($obj);
			
			setTimeout(function(){
				if($obj.val().length > 0 && !$obj.hasClass("on")){
					$obj.addClass("on");
					$obj.select();
				}else{
					$obj.focus();
				}
			});
		});
		
		$obj.on("keydown",function(e){
			if(e.keyCode == 13){
				$(this).blur();
				$obj.removeClass("on");
			}
		});	
	},
		
	findArea : function($input){
		var returnMap         = new DataMap();
		var $searchArea       = $input.parents(mobileKeyPad.searchAreaClass);
		var $contentArea      = $input.parents(mobileKeyPad.contentAreaClass);
		
		var searchAreaLength  = $searchArea.length;
		var contentAreaLength = $contentArea.length;
		
		var area = ""; 
		var $currentArea;
		if(searchAreaLength > 0){
			area = "search";
			$currentArea = $searchArea;
		}else if(contentAreaLength > 0){
			area = "content";
			$currentArea = $contentArea;
		}
		
		returnMap.put("area",area);
		returnMap.put("areaObj",$currentArea);
		returnMap.put("inputObj",$input);
		
		mobileKeyPad.currentAreaMap = returnMap;
		
		return returnMap;
	},
	
	openMobileKeyPad : function($obj){
		var isReadOnly = $obj.attr("readonly");
		if(isReadOnly == "readonly"){
			return;
		}
		
		mobileKeyPad.focusOnEvent($obj);
		
		if(!commonUtil.isMobile()){
			return;
		}
		
		var areaData  = null;
		var area      = "";
		var $areaObj  = null;
		var $inputObj = null;
		
		if($obj != undefined && $obj != null && $obj != ""){
			areaData  = mobileKeyPad.findArea($obj);
			area      = areaData.get("area");
			$areaObj  = areaData.get("areaObj");
			$inputObj = areaData.get("inputObj");
		}
		
		switch (area) {
		case "search":
			mobileKeyPad.openSearchArea($areaObj,$inputObj);
			break;
		case "content":
			mobileKeyPad.openContentArea($areaObj,$inputObj);
			break;
		default:
			$(".tem6_wrap .tem6_content .gridArea .excuteArea").hide();
			break;
		}
	},
	
	openSearchArea : function($areaObj,$inputObj){
		$areaObj.parent().css("overflow","hidden");
		$areaObj.css({"overflow-y":"auto"});
		
		var $content = $areaObj.find(mobileKeyPad.searchAreaContentClass);
		$content.css("height",windowHeight);
		$areaObj.find(mobileKeyPad.searchAreaButtonClass).hide();
		
		$(mobileKeyPad.contentAreaClass).hide();
		
		var scrollHeight = 0;
		var wraperHeight = $areaObj.height();
		var $offset      = $inputObj.offset();
		var inputPos     = $offset.top;
		
		var keyPadPos = mobileKeyPad.pdaHeight - mobileKeyPad.keyPadHeight - mobileKeyPad.fixHeight;

		if(keyPadPos >= inputPos){
			scrollHeight = 0;
		}else{
			scrollHeight = inputPos - keyPadPos;
		}
		
		if(scrollHeight > 0){
			$areaObj.animate({scrollTop:scrollHeight});
		}
	},
	
	openContentArea : function($areaObj,$inputObj){
		var $scanArea = $areaObj.find(".scan_area");
		var browser = navigator.userAgent;
		if(browser.indexOf("GsWmsPda") == -1){
			if((mobileKeyPad.keyPadHeight < mobileKeyPad.areaObjHeight) && 
					((mobileKeyPad.pdaHeight - mobileKeyPad.areaObjHeight - 40) < mobileKeyPad.keyPadHeight)){
				$scanArea.css({"height":mobileKeyPad.keyPadHeight - 15});
			}
		}
		
		$areaObj.css({"overflow-y":"auto"});
		
		var $openContent = null;
		var $closeContent = null;
		$areaObj.children().not(".scan_area").each(function(){
			if(commonUtil.parseInt($(this).css("z-index")) == 0){
				$closeContent = $(this);
			}
			if(commonUtil.parseInt($(this).css("z-index")) > 0){
				$openContent = $(this);
			}
		});
		
		if($openContent != null){
			$openContent.find(".excuteArea").hide();
		}
		if($closeContent != null){
			$closeContent.hide();
			$closeContent.find(".excuteArea").hide();
		}
	},
	
	closeMobileKeyPad : function(){
		var areaData = mobileKeyPad.currentAreaMap;
		
		var area      = areaData.get("area");
		var $areaObj  = areaData.get("areaObj");
		var $inputObj = areaData.get("inputObj");
		
		switch (area) {
		case "search":
			mobileKeyPad.closeSearchArea($areaObj,$inputObj);
			break;
		case "content":
			mobileKeyPad.closeContentArea($areaObj,$inputObj);
			break;
		default:
			var gridLen = $(".tem6_wrap .tem6_content .gridArea").length;
			if(gridLen > 0){
				if(!mobileKeyPad.gridEnterType){
					var $input = $(".tem6_wrap .tem6_content .gridArea .tableBody tbody input:focus");
					if(commonUtil.checkFn("closeKeyPadAfterEvent")){
							var areaId = "";
							var $targetObj = $input.parents();
							$targetObj.each(function(){
								if($(this).attr("id")){
									areaId = $(this).attr("id");
								}
							});
							closeKeyPadAfterEvent(areaId,$input.parent().attr("gcolname"),$input.val(),$input);
					}
					$input.blur();
					$(".tem6_wrap .tem6_content .gridArea .excuteArea").show();
				}
				
				mobileKeyPad.gridEnterType = false;
			}
			break;
		}
	},
	
	closeSearchArea : function($areaObj,$inputObj){
		$areaObj.parent().css("overflow","hidden");
		$areaObj.css({"overflow-y":""});
		
		if(!$inputObj.parent().hasClass("scanInputArea")){
			var bindId = mobileKeyPad.currentAreaMap.get("area");
			var name   = $inputObj.attr("name");
			
			var param = dataBind.paramData(bindId);
			var data = new DataMap();
			data.put(name,param.get(name));
			dataBind.dataBind(data, bindId);
			dataBind.dataNameBind(data, bindId);
			
			$inputObj.removeClass("on");
			$inputObj.blur();
		}
		
		var $content = $areaObj.find(mobileKeyPad.searchAreaContentClass);
		$content.css("height","calc(100% - 30px)");
		$areaObj.find(mobileKeyPad.searchAreaButtonClass).show();
		
		$(mobileKeyPad.contentAreaClass).show();
		$(mobileKeyPad.virtualKeypadAreaClass).remove();
		
		mobileKeyPad.currentAreaMap = new DataMap();
		
		mobileKeyPad.isClose = true;
	},
	
	closeContentArea : function($areaObj,$inputObj){
		var browser = navigator.userAgent;
		if(browser.indexOf("GsWmsPda") == -1){
			var $scanArea = $areaObj.find(".scan_area");
			if(mobileKeyPad.areaObjHeight > 0){
				$scanArea.css({"height":mobileKeyPad.areaObjHeight});
			}
		}
		
		$areaObj.css({"overflow-y":""});
		
		var $closeContent = null;
		var $openContent = null;
		
		$areaObj.children().not(".scan_area").each(function(){
			if(commonUtil.parseInt($(this).css("z-index")) == 0){
				$closeContent = $(this);
			}
			if(commonUtil.parseInt($(this).css("z-index")) > 0){
				$openContent = $(this);
			}
		});
		
		if($openContent != null){
			if($openContent.find(".excuteArea").length > 0){
				$openContent.find(".excuteArea").show();
			}
		}
		if($closeContent != null){
			if($closeContent.find(".excuteArea").length > 0){
				$closeContent.show();
				$closeContent.find(".excuteArea").show();
			}
		}
		
		$inputObj.removeClass("on");
		$inputObj.blur();
		
		mobileKeyPad.currentAreaMap = new DataMap();
		
		mobileKeyPad.isClose = true;
		
		if(commonUtil.checkFn("closeKeyPadAfterEvent")){
			var areaId = "";
			var $targetObj = $inputObj.parents();
			$targetObj.each(function(){
				if($(this).attr("id")){
					areaId = $(this).attr("id");
				}
			});
			closeKeyPadAfterEvent(areaId,$inputObj.attr("name"),$inputObj.val(),$inputObj);
		}
	},
	
	focusOnEvent : function($obj){
		if(configData.MENU_ID == "index"){
			return;
		}
		
		$(".tem6_wrap,.innerLayer").find(".focus_in").removeClass("focus_in");
		if($obj[0].type != "checkbox"){
			var $wrap = $obj.parent();
			if($wrap.hasClass("scanInputArea")){
				$wrap.addClass("focus_in");
			}else{
				$obj.addClass("focus_in");
			}
		}
	}
}

var mobileKeyPad = new MobileKeyPad();