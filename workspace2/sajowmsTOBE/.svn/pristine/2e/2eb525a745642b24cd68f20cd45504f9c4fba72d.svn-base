MobileCommon = function(){
	this.gridHeight = 0;
	this.isDetail = false;
	this.gridId = "";
	this.detailId = "";
	this.toastTimer = null;
}

$.fn.setCursorPosition = function( pos )
{
		this.each( function( index, elem ) {
			if( elem.setSelectionRange ) {
				if(elem.type != "number"){
					elem.setSelectionRange(pos, pos);
				}
			} else if( elem.createTextRange ) {
				var range = elem.createTextRange();
				range.collapse(true);
				range.moveEnd('character', pos);
				range.moveStart('character', pos);
				range.select();
			}
		});
	return this;
};

MobileCommon.prototype = {
	useSearchPad : function(isUse){
		if(!isUse){
			if($(".tem6_search").length > 0){
				$(".tem6_search").remove();
			}
			
			if($("html").find(".searchLine").length > 0){
				$(".scan_area").css("padding-top",5);
			}else{
				$(".scan_area").css("padding-top",9);
			}
			var $gridArea = $(".tem6_wrap .tem6_content .gridArea");
			var $gridWrap = $(".tem6_wrap .tem6_content .gridArea .tableWrap_search");
			var $tableBody = $(".tem6_wrap .tem6_content .gridArea .tableWrap_search .tableBody");
			
			var wrapHeight = $(".tem6_wrap .tem6_content").height();
			var scanHeight = $(".tem6_wrap .tem6_content .scan_area").height() + 25;
			
			$gridArea.css("height",wrapHeight - scanHeight);
			$gridWrap.css("height",$gridWrap.height()+16);
			$tableBody.css("height",$tableBody.height()+16);
			
			$(".searchLine th").css("padding-top",10);
			$(".searchLine td").css("padding-top",3);
			$(".searchLine").next().css({"height":"40px","vertical-align":"bottom"});
			$(".searchLine").next().find("th").css("padding-bottom",8);
		}else{
			$(".scan_area").css("padding-top",30);
			
			var $gridArea = $(".tem6_wrap .tem6_content .gridArea");
			var $gridWrap = $(".tem6_wrap .tem6_content .gridArea .tableWrap_search");
			
			$gridArea.css("height",$gridArea.height() - 5);
			$gridWrap.css("height",$gridWrap.height() - 5);
			
			var $detailArea = $(".tem6_wrap .tem6_content .detailArea");
			if($detailArea.length > 0){
				$detailArea.css("height",$detailArea.height() - 5);
			}
		}
	},	
		
	setOpenDetailButton : function(option){
		var isUse = option.isUse; 
		var type = option.type;
		var gridId = option.gridId;
		var detailId = option.detailId;
		if($.trim(detailId) != "" && detailId != null && detailId != undefined){
			mobileCommon.isDetail = true;
		}else{
			mobileCommon.isDetail = false;
		}
		mobileCommon.gridId = gridId;
		mobileCommon.detailId = detailId;
		
		var $gridAreaWrap = $("#"+gridId).parent().parent().parent().parent();
		var $gridArea = $("#"+gridId).parent().parent().parent();
		var $gridAreabutton = $gridArea.find(".excuteArea");
		
		var $detailArea = $("#"+detailId);
		var $detailContent = $detailArea.find(".detailContent");
		var $detailAreabutton = $detailArea.find(".excuteArea");
		
		mobileCommon.gridHeight = $gridArea.height();
		
		$detailArea.css("height",mobileCommon.gridHeight + 35);
		$detailContent.css("height",mobileCommon.gridHeight);
		
		switch (type) {
		case "grid":
			$gridAreaWrap.css("z-index",777);
			$gridAreabutton.show();
			
			$detailArea.css("z-index",0);
			$detailAreabutton.hide();
			break;
		case "detail":
			$gridAreaWrap.css("z-index",0);
			$gridAreabutton.hide();
			
			$detailArea.css("z-index",777);
			$detailAreabutton.show();
			
			$("#" + detailId + " .prev").on("click",function(){mobileCommon.prevView();});
			$("#" + detailId + " .next").on("click",function(){mobileCommon.nextView();});
			
			break;
		default:
			break;
		}
		
		parent.frames["topFrame"].contentWindow.setOpenDetailButton(isUse,type);
	},
	
	openDetail : function(type){
		var gridId = mobileCommon.gridId;
		var detailId = mobileCommon.detailId;
		
		var $gridAreaWrap = $("#"+mobileCommon.gridId).parent().parent().parent().parent();
		var $gridArea = $("#"+gridId).parent().parent().parent();
		var $gridAreabutton = $gridArea.find(".excuteArea");
		var $detailArea = $("#"+mobileCommon.detailId);
		var $detailAreabutton = $detailArea.find(".excuteArea");
		
		var gridCount = gridList.getGridDataCount(gridId);
		
		switch (type) {
		case "grid":
			$gridAreaWrap.css("z-index",777);
			$gridAreabutton.show();
			
			if(gridCount > 0){
				var rowNum = gridList.getFocusRowNum(gridId);
				gridList.setFocus($("#"+gridId+" tr:eq("+rowNum+") td:eq(0)"));
			}
			
			$detailArea.css("z-index",0);
			$detailAreabutton.hide();
			
			$("#" + detailId + " .prev").unbind("click");
			$("#" + detailId + " .next").unbind("click");
			
			break;
		case "detail":
			$gridAreaWrap.css("z-index",0);
			$gridAreabutton.hide();
			
			var $obj = $detailArea.find(".count");
			var rowNum = gridList.getFocusRowNum(gridId);
			var num = rowNum + 1;
			$obj.html(num);
			
			$detailArea.css("z-index",777);
			$detailAreabutton.show();
			
			$("#" + detailId + " .prev").on("click",function(){mobileCommon.prevView();});
			$("#" + detailId + " .next").on("click",function(){mobileCommon.nextView();});
			
			break;
		default:
			break;
		}
		
		$(".tem6_wrap").find(".focus_in").removeClass("focus_in");
		
		if(commonUtil.checkFn("changeGridAndDetailAfter")){
			changeGridAndDetailAfter(type);
		}
	},
	
	setTotalViewCount : function(){
		var gridId = mobileCommon.gridId;
		var detailId = mobileCommon.detailId;
		
		var totalCount = gridList.getGridDataCount(gridId);
		
		var $total = $("#"+detailId+" .detailContent .pageCount .totalCount");
		var $count = $("#"+detailId+" .detailContent .pageCount .count");
		if(totalCount > 0){
			$count.html(1);
		}else{
			$count.html(0);
		}
		$total.html(totalCount);
	},
	
	prevView : function(){
		var gridId = mobileCommon.gridId;
		var detailId = mobileCommon.detailId;
		var totalCount = gridList.getGridDataCount(gridId);
		if(totalCount > 0){
			var $obj = $("#"+detailId+" .detailContent .pageCount .count");
			
			gridList.setPreRowFocus(gridId);
			
			var rowNum = gridList.getFocusRowNum(gridId);
			var num = rowNum + 1;
			
			$obj.html(num);
			
			//2020.05.15 Detail prev 버튼 클릭시 event fn Ahn.JinSeok
			if(commonUtil.checkFn("gridDetailEventPrevView")){
				gridDetailEventPrevView(gridId , rowNum );
			}
		}
	},
	
	nextView : function(){
		var gridId = mobileCommon.gridId;
		var detailId = mobileCommon.detailId;
		var totalCount = gridList.getGridDataCount(gridId);
		if(totalCount > 0){
			var $obj = $("#"+detailId+" .detailContent .pageCount .count");
			
			gridList.setNextRowFocus(gridId);
			
			var rowNum = gridList.getFocusRowNum(gridId);
			var num = rowNum + 1;
			
			$obj.html(num);
			
			//2020.05.15 Detail Next 버튼 클릭시 event fn Ahn.JinSeok
			if(commonUtil.checkFn("gridDetailEventNextView")){
				gridDetailEventNextView(gridId , rowNum );
			}
		}
	},
		
	focus : function(data,area,name){
		var $obj = $("#"+area).find("[name="+name+"]");
		
		if(data != null && data != undefined){
			$obj.val(data);
			mobileKeyPad.focusOnEvent($obj);
		}else{
			$obj.val("");
			mobileKeyPad.focusOnEvent($obj);
		}
		if($obj[0].tagName == "INPUT"){
			setTimeout(function(){
				if($obj.parent().hasClass("scanInputArea")){
					$obj.unbind("focus").on("focus",function(e){
						var inputId = $(this).attr("id");
						$(this).attr("readonly",true);
						setTimeout(function(){
							var $input = $("#"+inputId);
							$input.attr("readonly",false);
						});
					});
					
					$obj.unbind("click").on("click",function(e){
						var inputId = $(this).attr("id");
						$(this).attr("readonly",true);
						
						setTimeout(function(){
							var $input = $("#"+inputId);
							$input.attr("readonly",false);
							
							mobileKeyPad.focusOnEvent($obj);
							
							$obj.select();
						});
					});
					
					setTimeout(function(){
						mobileKeyPad.focusOnEvent($obj);
						$obj.select();
					},2);
				}else{
					mobileKeyPad.focusOnEvent($obj);
					mobileKeyPad.openMobileKeyPad($obj);
					
					if($obj.attr("type") != "number"){
						var valLen = $obj.val().length;
						if(valLen > 0){
							$obj.focus().setCursorPosition(valLen);
						}else{
							$obj.focus();
						}
					}else{
						var v = $obj.val();
						$obj.focus().val("").val(v);
					}
				}
			},1);
		}
	},
	
	select : function(data,area,name){
		var $obj = $("#"+area).find("[name="+name+"]");
		
		if(data != null && data != undefined && $.trim(data) != ""){
			$obj.val(data);
			mobileKeyPad.focusOnEvent($obj);
		}
		if($obj[0].tagName == "INPUT"){
			if($obj.parent().hasClass("scanInputArea")){
				$obj.unbind("focus").on("focus",function(e){
					var inputId = $(this).attr("id");
					$(this).attr("readonly",true);
					setTimeout(function(){
						var $input = $("#"+inputId);
						$input.attr("readonly",false);
					});
				});
				
				$obj.unbind("click").on("click",function(e){
					var inputId = $(this).attr("id");
					$(this).attr("readonly",true);
					
					setTimeout(function(){
						mobileKeyPad.focusOnEvent($obj);
						
						var $input = $("#"+inputId);
						$input.attr("readonly",false);
						
						$obj.focus();
						$obj.select();
					});
				});
				
				setTimeout(function(){
					mobileKeyPad.focusOnEvent($obj);
					
					$obj.focus();
					$obj.select();
				});
			}else{
				setTimeout(function(){
					$obj.focus();
					$obj.select();
					mobileKeyPad.focusOnEvent($obj);
					mobileKeyPad.openMobileKeyPad($obj);
				});
			}
		}
	},
	
	initSearch : function(areaArr,isOpen){
		var isDetail = mobileCommon.isDetail;
		var detailId = mobileCommon.detailId;
		
		if(areaArr == undefined || areaArr == null || areaArr.length == 0){
			areaArr = ["searchArea","scanArea"];
		}
		
		if(isDetail){
			areaArr.push(detailId);
			
			var $total = $("#"+detailId+" .detailContent .pageCount .totalCount");
			var $count = $("#"+detailId+" .detailContent .pageCount .count");
			
			$total.html(0);
			$count.html(0);
		}
		
		if(areaArr.length > 0){
			for(var i in areaArr){
				var data = new DataMap();
				
				var area = areaArr[i];
				var $obj = $("#"+area);
				
				var keys = dataBind.paramData(area).keys();
				for(var j in keys){
					var key = keys[j];
					var $element = $obj.find("[name="+key+"]");
					var $tagName = $element.get(0).tagName;
					if($tagName == "SELECT"){
						data.put(key,$element.find("option").eq(0).val());
					}else if($tagName == "INPUT"){
						$element.val("");
					}
				}
				
				dataBind.dataBind(data,area);
				dataBind.dataNameBind(data,area);
			}
			
			if(isOpen){
				mobileCommon.openSearchArea();
			}
			
		}
	},
	
	initBindArea : function(bindId,colArr){
		if(colArr.length > 0 && (bindId != null && $.trim(bindId) != "" && bindId != undefined)){
			var data = new DataMap();
			var $obj = $("#"+bindId);
			var keys = colArr;
			for(var i in keys){
				var key = keys[i];
				var $element = $obj.find("[name="+key+"]");
				var $tagName = $element.get(0).tagName;
				if($tagName == "SELECT"){
					data.put(key,$element.find("option").eq(0).val());
				}else if($tagName == "INPUT"){
					$element.val("");
				}
			}
			
			dataBind.dataBind(data,bindId);
			dataBind.dataNameBind(data,bindId);
		}
	},
	
	openSearchArea : function(layerId){
		if(layerId != undefined && layerId != null && $.trim(layerId) != ""){
			var $layer = $("#"+layerId);
			var $obj   = $layer.find(".tem6_search");
			var $btn   = $layer.find(".tem6_search_btn");
			
			$layer.find(".tem6_content").css("z-index",0);
			
			$btn.removeClass("on");
			$obj.animate({top:30},300);
			$btn.find(".arrow").css({"margin-bottom":"-6px","transform": "rotate(224deg)","webkit-transform": "rotate(224deg)"});
			
			setTimeout(function(){
				$layer.find(".tem6_content").css("z-index",999);
			}, 300);
		}else{
			var $obj = $(".tem6_wrap").find(".tem6_search");
			var $btn = $(".tem6_wrap").find(".tem6_search_btn");
			
			$btn.removeClass("on");
			$obj.animate({top:0},300);
			$btn.find(".arrow").css({"margin-bottom":"-6px","transform": "rotate(224deg)","webkit-transform": "rotate(224deg)"});
		}
	},
	
	closeSearchArea : function(layerId){
		if(layerId != undefined && layerId != null && $.trim(layerId) != ""){
			var $layer = $("#"+layerId);
			var $obj   = $layer.find(".tem6_search");
			var $btn   = $layer.find(".tem6_search_btn");
			
			var $content = $obj.find(".tem6_search_content");
			var height = $content.height() - 30;
			
			$layer.find(".tem6_content").css("z-index",0);
			
			$obj.animate({top:-(height + 2)},300);
			$btn.find(".arrow").css({"margin-bottom":"3px","transform": "rotate(45deg)","webkit-transform": "rotate(45deg)"});
			
			setTimeout(function(){
				$layer.find(".tem6_content").css("z-index",999);
			}, 300);
		}else{
			var $obj = $(".tem6_wrap").find(".tem6_search");
			var $btn = $(".tem6_wrap").find(".tem6_search_btn");
			var $content = $obj.find(".tem6_search_content");
			var height = $content.height();
			
			$btn.addClass("on");
			$obj.animate({top:-(height + 2)},300);
			$btn.find(".arrow").css({"margin-bottom":"3px","transform": "rotate(45deg)","webkit-transform": "rotate(45deg)"});
		}
	},
	
	alert : function(option){
		var $obj = $("#alert");
		var $p = $("<p>");
		
		var message = option.message;
		var $textArea = $obj.find(".text");
		var $confirmButton = $obj.find(".button").find(".confirm");
		var txt = commonUtil.replaceAll(mobileCommon.filterXSS(message),/(?:\r\n|\r|\n)/g,"<br/>");
			txt = commonUtil.replaceAll(mobileCommon.filterXSS(txt),"\\n","<br/>");
		$textArea.html($p.clone().html(txt));
		$obj.fadeIn(300);
		
		var confirm = option.confirm;
		if(confirm != undefined && confirm != null ){
			if(typeof confirm == "function"){
				$confirmButton.on("click",function(){
					confirm();
					setTimeout(function(){
						$textArea.children().remove();
						$confirmButton.unbind("click");
						$obj.fadeOut(300);
					});
				});
			}else if(typeof confirm == "string"){
				
			}
		}else{
			$confirmButton.on("click",function(){
				$textArea.children().remove();
				$confirmButton.unbind("click");
				$obj.fadeOut(300);
			});
		}
	},
	
	confirm : function(option){
		var $obj = $("#confirm");
		var $p = $("<p>");
		
		var message = option.message;
		var $textArea = $obj.find(".text");
		var $cancelButton = $obj.find(".button").find(".cancel");
		var $confirmButton = $obj.find(".button").find(".confirm");
		var txt = commonUtil.replaceAll(message,/(?:\r\n|\r|\n)/g,"<br/>");
		    txt = commonUtil.replaceAll(txt,"\\n","<br/>");
		
		$textArea.html($p.clone().html(txt));
		$obj.fadeIn(300);
		
		var confirm = option.confirm;
		if(confirm != undefined && confirm != null ){
			if(typeof confirm == "function"){
				$confirmButton.on("click",function(){
					confirm();
					setTimeout(function(){
						$textArea.children().remove();
						$confirmButton.unbind("click");
						$obj.fadeOut(300);
					});
				});
			}else if(typeof confirm == "string"){
				
			}
		}
		
		$cancelButton.on("click",function(){
			setTimeout(function(){
				$textArea.children().remove();
				$confirmButton.unbind("click");
				$obj.fadeOut(300);
			});
		});
	},
	
	toast : function(option){
		var $obj = $("#toast");
		var $txtObj = $obj.find(".txt");
		var $imgObj = $obj.find(".img");
		
		if($obj.css("display") != "none"){
			clearTimeout(mobileCommon.toastTimer);
			mobileCommon.toastTimer = null;
			
			$obj.hide();
			$txtObj.html("");
			
			var cList = ["tsBg1","tsBg2","tsBg3","tsBgNo"];
			for(var i in cList){
				var c = cList[i];
				$txtObj.removeClass(c);
				$imgObj.removeClass(c);
			}
		}
		
		var message = option.message;
		var execute = option.execute;
		var bgClass = "";
		var type = option.type;
		switch (type) {
		case "S":
			bgClass = "tsBg1";
			break;
		case "W":
			bgClass = "tsBg2";
			break;
		case "F":
			bgClass = "tsBg3";
			break;
		case "N":
			bgClass = "tsBgNo";
			break;	
		default:
			bgClass = "tsBgNo";
			break;
		}
		
		if(bgClass != "tsBgNo"){
			$imgObj.addClass(bgClass);
		}else{
			$txtObj.addClass(bgClass);
		}
		
		$txtObj.html(message);
		
		$obj.fadeIn(300);
		
		if(execute != undefined && execute != null ){
			if(typeof execute == "function"){
				execute();
			}else if(typeof confirm == "string"){
				
			}
		}
		
		mobileCommon.toastTimer = setTimeout(function(){
			clearTimeout(mobileCommon.toastTimer);
			mobileCommon.toastTimer = null;
			
			$txtObj.html("");
			$txtObj.removeClass(bgClass);
			$imgObj.removeClass(bgClass);
			$obj.fadeOut(300);
		},3000);
	},
	
	filterXSS: function (str) {
		if(str != null && str != "" && str != undefined){
			str = str.toString();
			str = str.replace("<", "&lt;");
			str = str.replace(">", "&gt;");
			str = str.replace("&lt;br/&gt;", "<br/>");
			
			var spanClass = ["msgColorBlack","msgColorRed","msgColorGreen"];
			for(var i in spanClass){
				var c = spanClass[i];
				str = str.replace("&lt;span class='"+c+"'&gt;", "<span class='"+c+"'>");
			}
		}else{
			str = "";
		}
		return str;
	},
	
	numberComma : function(num){
		return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	},
	
	numberMaxLength : function($obj){
		if ($obj.value.length > $obj.maxLength){
			$obj.value = $obj.value.slice(0, $obj.maxLength);
		}
	}
}

var mobileCommon = new MobileCommon();