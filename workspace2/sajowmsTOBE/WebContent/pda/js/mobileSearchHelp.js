MobileSearchHelp = function(){
	this.searchHelpType = "_LAYER";
	this.searchHelpViewType = "_LIST";
	this.searhHelpInputClass = "input_btn";
	this.searhHelpButtonClass = "btn_searh_help";
	this.searhHelpButtonInnerText = "P";
	this.innerSearchViewType = "_INNER_SEARCH";
	this.searchHelp = new DataMap();
}

MobileSearchHelp.prototype = {
	setSearchHelp : function(option){
		var searchHelp = mobileSearchHelp.searchHelp;
		
		var id = option.id;
		var name = option.name;
		var bindId = option.bindId;
		var returnCol =  option.returnCol;
		if(returnCol == false || $.trim(returnCol) == "" || returnCol == null || returnCol == undefined){
			returnCol = false;
		}
		var title = option.title;
		var module = option.module;
		var command = option.command;
		var inputType = option.inputType;
		var buttonShow = option.buttonShow == false?option.buttonShow:true;
		var gridId =  id + mobileSearchHelp.searchHelpViewType;
		var layerId =  id + mobileSearchHelp.searchHelpType;
		var $returnObject = $("#"+bindId + " [name="+name+"]");
		var searchType = (option.searchType != undefined && option.searchType != null && $.trim(option.searchType) != "")?option.searchType:"in";
		var search = option.search;
		var isSearch = (search != undefined && search != null && search != "" && search.length > 0)?true:false;
		var grid = option.grid;
		
		var photoView = (option.photoView != undefined && option.photoView != null && $.trim(option.photoView) != "")?option.photoView:false;
		
		var initMap = new DataMap();
		initMap.put("id",id);
		initMap.put("name",name);
		initMap.put("bindId",bindId);
		initMap.put("layerId",layerId);
		initMap.put("gridId",gridId);
		initMap.put("returnCol",returnCol);
		initMap.put("returnObject",$returnObject);
		initMap.put("title",title);
		initMap.put("module",module);
		initMap.put("command",command);
		initMap.put("inputType",inputType);
		initMap.put("buttonShow",buttonShow);
		initMap.put("searchType",searchType);
		
		initMap.put("photoView",photoView);
		
		var searchMap = new DataMap();
		searchMap.put("useYn",isSearch);
		searchMap.put("list",isSearch?search:[]);
		
		initMap.put("search",searchMap);
		initMap.put("grid",grid);
		
		searchHelp.put(id,initMap);
		
		mobileSearchHelp.drawSearchHelpInput(id);
		mobileSearchHelp.drawSearchHelpGrid(id);
	},
	
	drawSearchHelpInput : function(id){
		var searchHelp = mobileSearchHelp.searchHelp.get(id);
		var bindId = searchHelp.get("bindId");
		var name = searchHelp.get("name");
		var $returnObject = searchHelp.get("returnObject");
		var $buttonObj = $("<button>").clone().addClass(mobileSearchHelp.searhHelpButtonClass).html(mobileSearchHelp.searhHelpButtonInnerText);
		var inputType = searchHelp.get("inputType");
		var buttonShow = searchHelp.get("buttonShow");
		var isSearch = searchHelp.get("isSearch");
		
		$buttonObj.attr("onclick","mobileSearchHelp.selectSearchHelp('"+id+"');");
		
		var inputDrawMap = new DataMap();
		inputDrawMap.put("inputObj",$inputObj);
		inputDrawMap.put("buttonObj",$buttonObj);
		
		searchHelp.put("inputDrawMap",inputDrawMap);
		
		var isSearchArea = $returnObject.parents().hasClass("tem6_search");
		if(inputType == "scan" || inputType == "scanNumber"){
			var $td = $returnObject.parent();
			var type = "text";
			if(inputType == "scanNumber"){
				type = "number";
			}
			scanInput.setScanInput({
				id : id,
				name : name,
				bindId : bindId,
				type : type
			});
			
			if(buttonShow){
				var $scanInputArea = $("#"+id).parent();
				$scanInputArea.css({"width":"calc(100% - 42px)","float":"left"});
				$td.append($buttonObj.css("float","left"));
			}
			
			searchHelp.put("returnObject",$("#"+bindId + " [name="+name+"]"));
		}else{
			var $inputObj = $returnObject.addClass(mobileSearchHelp.searhHelpInputClass);
			if(buttonShow){
				if(!isSearchArea){
					$buttonObj.css("height",30);
				}
				$inputObj.after($buttonObj);
			}else{
				$inputObj.css("width","100%");
			}
			
			$inputObj.unbind("click").on("click",function(){
				mobileKeyPad.focusOnEvent($(this));
			});
		}
	},
	
	drawSearchHelpGrid : function(id){
		var searchHelp = mobileSearchHelp.searchHelp.get(id);
		
		var layerId    = searchHelp.get("layerId");
		var gridId     = searchHelp.get("gridId");
		var bindId     = searchHelp.get("bindId");
		var module     = searchHelp.get("module");
		var command    = searchHelp.get("command");
		var searchType = searchHelp.get("searchType");
		var search     = searchHelp.get("search");
		var useSearch  = search.get("useYn");
		var returnCol  = search.get("returnCol");
		
		var photoView  = searchHelp.get("photoView");
		
		var $bottomLayerPopupArea = $(".mobilePopArea");
		var $div                  = $("<div>");
		var $ul                   = $("<ul>");
		var $li                   = $("<li>");
		var $table                = $("<table>");
		var $colgroup             = $("<colgroup>");
		var $col                  = $("<col>");
		var $thead                = $("<thead>");
		var $tbody                = $("<tbody>");
		var $tr                   = $("<tr>");
		var $th                   = $("<th>");
		var $td                   = $("<td>");
		var $p                    = $("<p>");
		var $span                 = $("<span>");
		var $button               = $("<button>");
		var $input                = $("<input>");
		var $select               = $("<select>");
		
		var $layerPopWrap    = $div.clone().addClass("layerPopWrap");
		var $innerLayer      = $div.clone().addClass("innerLayer");
		var $popupTitle      = $div.clone().addClass("popupTitle");
		var $popupSearchArea = $div.clone().addClass("popupSearchArea");
		var $tem6_content    = $div.clone().addClass("tem6_content");
		
		$layerPopWrap.attr("id",layerId);
		
		/*title*/
		var title = searchHelp.get("title");
		var $popupTitleArea = $li.clone().addClass("text").attr("id","popupTitle").append($p.clone().html(title));
		var $popupCloseArea = $li.clone().addClass("close").append($button.clone().html("X"));
		
		$popupCloseArea.attr("onclick","mobileSearchHelp.searchHelpCloseEvent('"+id+"');");
		
		var $popupTitleUl = $ul.clone();
		$popupTitleUl.append($popupTitleArea).append($popupCloseArea);
		$popupTitle.append($popupTitleUl);
		$innerLayer.append($popupTitle);
		
		/*photo*/
		if(photoView){
			useSearch = true;
			searchType = "in";
		}
		
		/*inner search area*/
		var $tem6Search = $div.clone().addClass("tem6_search");
		var $tem6SearchContent;
		var $searchAreaTable = $table.clone();
		var $tem6Content = $div.clone().addClass("tem6_content");
		if(useSearch){
			if(searchType == "in"){
				$tem6SearchContent = $div.clone().addClass("scan_area");
				$tem6Content.css("top",30);
			}else if(searchType == "out"){
				$tem6SearchContent = $div.clone().addClass("tem6_search_content");
			}
			
			var seachTableId = id + (mobileSearchHelp.innerSearchViewType);
			$searchAreaTable.attr("id",seachTableId);
			
			var colspan = 0;
			var searchList = search.get("list");
			var searchListLen = searchList.length;
			for(var i = 0 ; i < searchListLen; i++){
				var $searchAreaTr = $tr.clone();
				var $searchAreaTh = $th.clone();
				
				var row = searchList[i];
				var isArray = Array.isArray(row);
				if(isArray){
					var rowLen = row.length;
					if(rowLen > colspan){
						colspan = rowLen;
					}
					for(var j = 0; j < rowLen; j++){
						var $searchAreaTd = $td.clone();
						
						var itemRow = row[j];
						
						var type    = itemRow["type"];
						var name    = itemRow["name"];
						var label   = itemRow["label"];
						var format  = itemRow["uiFormat"];
						var colspan = itemRow["colspan"];
						
						if(type != "button" && label != "none"){
							$searchAreaTh.attr("CL",label);
							$searchAreaTr.append($searchAreaTh);
						}
						
						if(colspan != undefined && colspan != null && colspan > 0){
							$searchAreaTd.attr("colspan",colspan);
						}
						
						switch (type) {
						case "text":
							var $textInput = null;
							if(format != undefined && format != null && $.trim(format) != ""){
								$textInput = $input.clone().attr({"type":type,"name":name,"uiFormat":format,"autocomplete":"off"});
							}else{
								$textInput = $input.clone().attr({"type":type,"name":name,"autocomplete":"off"});
							}
							$searchAreaTd.append($textInput);
							break;
						case "select":
							var $selectObj = null;
							var combo      = itemRow["combo"];
							if(combo.indexOf(",") > -1){
								$selectObj = $select.clone().attr({"name":name,"Combo":combo});/*,"comboType":"C,Combo"*/
							}else{
								$selectObj = $select.clone().attr({"name":name,"CommonCombo":combo});/*,"comboType":"C,Combo"*/
							}
							
							var codeView  = itemRow["codeView"];
							if(codeView != undefined && codeView != null && codeView == false){
								$selectObj.attr("ComboCodeView",false);
							}
							
							$searchAreaTd.append($selectObj);
							
							break;
						case "button":
							if(itemRow["width"] != undefined && itemRow["width"] != null &&  itemRow["width"] > 0){
								$searchAreaTd.css("width",itemRow["width"]);
							}
							var innerid = itemRow["id"];
							var $btn = $button.clone().addClass("innerBtn").attr({"id":innerid});
							$btn.on("click",function(){
								mobileSearchHelp.userButtonEvent(layerId,gridId,module,command,seachTableId,innerid);
							});
							var $innerP = $p.clone().attr("CL",name);
							$searchAreaTd.append($btn.append($innerP));
							break;	
						default:
							break;
						}
						$searchAreaTr.append($searchAreaTd);
					}
				}else{
					var $searchAreaTd = $td.clone();
					
					var type    = row["type"];
					var name    = row["name"];
					var label   = row["label"];
					var format  = row["uiFormat"];
					var colspan = row["colspan"];
					
					$searchAreaTh.attr("CL",label);
					$searchAreaTr.append($searchAreaTh);
					
					if(colspan != undefined && colspan != null && colspan > 0){
						$searchAreaTd.attr("colspan",colspan);
					}
					
					switch (type) {
					case "text":
						var $textInput = null;
						if(format != undefined && format != null && $.trim(format) != ""){
							$textInput = $input.clone().attr({"type":type,"name":name,"uiFormat":format,"autocomplete":"off"});
						}else{
							$textInput = $input.clone().attr({"type":type,"name":name,"autocomplete":"off"});
						}
						$searchAreaTd.append($textInput);
						break;
					case "select":
						var $selectObj = null;
						var combo      = row["combo"];
						if(combo.indexOf(",") > -1){
							$selectObj = $select.clone().attr({"name":name,"Combo":combo});/*,"comboType":"C,Combo"*/
						}else{
							$selectObj = $select.clone().attr({"name":name,"CommonCombo":combo});/*,"comboType":"C,Combo"*/
						}
						
						var codeView  = row["codeView"];
						if(codeView != undefined && codeView != null && codeView == false){
							$selectObj.attr("ComboCodeView",false);
						}
						
						$searchAreaTd.append($selectObj);
						
						break;	
					default:
						break;
					}
					$searchAreaTr.append($searchAreaTd);
				}
				$searchAreaTable.append($searchAreaTr);
			}
			
			if(searchListLen > 0){
				$tem6SearchContent.append($searchAreaTable);
			}
			
			var $detailGrid = null;
			if(photoView){
				var toggleId = layerId+"_TOGGLE";
				
				var $photoButtonArea = $div.clone().addClass("photoButtonArea");
				
				var $pu  = $ul.clone();
				var $pl1 = $li.clone().addClass("img");
				var $pl2 = $li.clone().addClass("txt").html("상품 사진");
				var $pl3 = $li.clone().addClass("toggle");
				
				var $label = $("<label>").clone().addClass("switch");
				var $ti    = $input.clone().attr({"type":"checkbox","id":toggleId});
				var $ts    = $span.clone().addClass("slider");
				var $tp1   = $p.clone().html("On");
				var $tp2   = $p.clone().html("Off");
				
				mobileSearchHelp.setToggleButtonEvent($ti);
				
				$label.append($ti).append($ts);
				
				$pl3.append($label).append($tp1.addClass("t1")).append($tp2.addClass("t2"));
				
				$pu.append($pl1).append($pl2).append($pl3);
				$photoButtonArea.append($pu);
				
				$tem6SearchContent.append($photoButtonArea);
				
				$detailGrid = $div.clone().addClass("detailArea");
				
				var $pTable    = $table.clone();
				
				var $pColGroup = $colgroup.clone();
				var $pCol1     = $col.clone().attr("width",60); 
				var $pCol2     = $col.clone().attr("width",70);
				var $pCol3     = $col.clone().attr("width",60);
				var $pCol4     = $col.clone();
				
				var $pTr1      = $tr.clone();
				var $pTr2      = $tr.clone();
				var $pTr3      = $tr.clone();
				var $pTr4      = $tr.clone();
				
				var $pTh1      = $th.clone().html("구분");
				var $pTh2      = $th.clone().html("상품코드");
				var $pTh3      = $th.clone().html("상품명");
				
				var $pTd1   = $td.clone().attr("id","LT04NM");
				var $pTd2   = $td.clone().attr("id","SKUKEY");
				var $pTd3   = $td.clone().attr({"colspan":3,"id":"DESC01"});
				var $pTd4   = $td.clone().attr({"colspan":4,"id":"LOTL10"});
				
				var $img    = $("<img>").clone();
				$img.attr("onerror","mobileSearchHelp.failImageLoad(this)");
				
				$pTd4.css("text-align","center");
				$pTd4.append($img);
				
				$pColGroup.append($pCol1).append($pCol2).append($pCol3).append($pCol4);
				
				$pTr1.append($pTh1).append($pTd1).append($pTh2).append($pTd2);
				$pTr2.append($pTh3).append($pTd3);
				$pTr3.append($pTd4);
				//$pTr4.append($pTd4);
				
				$pTable.append($pColGroup).append($pTr1).append($pTr2).append($pTr3);
				
				var $detailWrap = $div.clone().addClass("detailWrap");
				$detailWrap.append($pTable);
				
				$detailGrid.append($detailWrap);
				//$detailGrid.attr("id",gridId+"DETAIL");
			}
			
			if(searchType == "out"){
				var innerBtnId = seachTableId + "_INNER_BUTTON";
				var $searchBtnArea = $div.clone().addClass("search_btn_area");
				var searchBtnName = uiList.getLabel("BTN_DISPLAY"); 
				var $searchBtn = $button.clone().addClass("search_btn").attr({"id":innerBtnId}).html(searchBtnName);
				
				$searchBtn.on("click",function(){
					mobileSearchHelp.userButtonEvent(layerId,gridId,module,command,seachTableId,innerBtnId);
				});
				
				$searchBtnArea.append($searchBtn);
				$tem6SearchContent.append($searchBtnArea);
				$tem6Search.append($tem6SearchContent);
				
				var $tem6SearchBtn = $div.clone().addClass("tem6_search_btn");
				var $leftLine = $p.clone().addClass("left_line");
				var $arrow = $p.clone().addClass("arrow");
				var $rightLine = $p.clone().addClass("right_line");
				
				$tem6SearchBtn.append($leftLine).append($arrow).append($rightLine);
				
				$tem6Search.append($tem6SearchBtn);
				
				$popupSearchArea.append($tem6Search);
				$innerLayer.append($popupSearchArea);
			}else if(searchType == "in"){
				$tem6Content.append($tem6SearchContent); 
			}
		}
		
		var $gridArea = $div.clone().addClass("gridArea");
		var $tableWrapSearch = $div.clone().addClass("tableWrap_search").addClass("section");
		
		var $tableHeader = $div.clone().addClass("tableHeader");
		var $tableHeaderTable = $table.clone().css("width","100%");
		var $headGroup = $colgroup.clone();
		var $bodyGroup = $colgroup.clone();
		var $headThead = $thead.clone();
		
		var $tableBody = $div.clone().addClass("tableBody");
		var $tableBodyTable = $table.clone().css("width","100%");
		var $tbody = $tbody.clone().attr("id",gridId);
		var $tableBodyTr = $tr.clone().attr("CGRow","true");
		
		var grid = searchHelp.get("grid");
		var gridLen = grid.length;
		for(var i = 0; i < gridLen; i++){
			var row = grid[i];
			var label   = row["label"];
			var width   = row["width"];
			var colName = row["col"];
			var type    = row["type"];
			var gf      = row["GF"];
			
			var $headCol = $col.clone().attr("width",width);
			var $bodyCol = $col.clone().attr("width",width);
			$headGroup.append($headCol);
			$bodyGroup.append($bodyCol);
			
			var $headTh = $th.clone().attr("CL",label);
			$headThead.append($headTh);
			
			var $tableBodyTd = $td.clone().attr({"GCol":(type+","+colName)});
			if(type == "icon"){
				$tableBodyTd.attr("GB","icon");
			}
			
			if(gf != undefined && gf != null && $.trim(gf) != ""){
				$tableBodyTd.attr("GF",gf);
			}
			$tableBodyTr.append($tableBodyTd);
		}
		
		$tableHeaderTable.append($headGroup);
		$tableHeaderTable.append($headThead);
		$tableHeader.append($tableHeaderTable);
		
		$tbody.append($tableBodyTr);
		$tableBodyTable.append($bodyGroup);
		$tableBodyTable.append($tbody);
		$tableBody.append($tableBodyTable);
		
		$tableWrapSearch.append($tableHeader).append($tableBody);
		$gridArea.append($tableWrapSearch);
		$tem6Content.append($gridArea);
		
		if(photoView){
			$tem6Content.append($detailGrid);
		}
		
		var $excuteArea = $div.clone().addClass("excuteArea");
		var $excuteArea2 = null;
		var $excuteButton = $button.clone().addClass("wid1").addClass("hei1");/*.addClass("nr")*/
		var $excuteButtonText = $span.clone().attr("CL","STD_SELECT");
		
		if(photoView){
			$excuteArea.attr("id",layerId + "_BTN1");
			$excuteArea2 = $div.clone().addClass("excuteArea");
			var $buttonArea  = $div.clone().addClass("button");
			var $bUl  = $ul.clone();
			var $bLi1 = $li.clone().addClass("prev").attr("onclick","mobileSearchHelp.movePrevRow('"+id+"');");
			var $bLi2 = $li.clone().addClass("btn");
			var $bLi3 = $li.clone().addClass("next").attr("onclick","mobileSearchHelp.moveNextRow('"+id+"');");
			var $bBtn = $button.clone().addClass("wid1").html("선택")
			
			$bLi1.append($p.clone());
			$bLi2.append($bBtn.attr("onclick","mobileSearchHelp.searchHelpSelectEvent('"+id+"');"));
			$bLi3.append($p.clone());
			
			$bUl.append($bLi1).append($bLi2).append($bLi3);
			
			$buttonArea.append($bUl);
			$excuteArea2.append($buttonArea);
			$excuteArea2.attr({"id":layerId + "_BTN2","display":"none"});
		}
		
		if(bindId == undefined && bindId== null && $.trim(bindId) == ""){
			$excuteButton.addClass("btnBgB");
			$excuteButtonText.attr("CL","BTN_CLOSE");
			$excuteButton.attr("onclick","mobileSearchHelp.searchHelpCloseEvent('"+id+"');");
		}else{
			$excuteButton.attr("onclick","mobileSearchHelp.searchHelpSelectEvent('"+id+"');");
		}
		
		$excuteArea.append($excuteButton.append($excuteButtonText));
		$tem6Content.append($excuteArea);
		if(photoView){
			$tem6Content.append($excuteArea2);
		}
		
		$innerLayer.append($tem6Content);
		
		$layerPopWrap.append($innerLayer);
		$bottomLayerPopupArea.append($layerPopWrap);
		
		mobileSearchHelp.setGridSize(id);
		uiList.UICheck();
		inputList.setCombo();
		
		gridList.setGrid({
			id               : gridId,
			module           : module,
			command          : command,
			gridMobileType   : true,
			emptyMsgType     : false,
			firstRowFocusType: false
		});
		
		var tableBodyHeight = $tableBody.height() - 35;
		$tableBody.css("height",tableBodyHeight);
		
		mobileKeyPad.setInputAreaFormat(layerId);
		
		var $layer = $("#"+layerId);
		$layer.hide();
	},
	
	resizeImage : function(w,h,$obj){
		var resizeWidth  = 0;
		var resizeHeight = 0;
		
		var imgW = $obj.width();
		var imgH = $obj.height();
		if(imgW > w || imgH > h){
			if(imgW > imgH){
				resizeWidth = w;
				resizeHeight = Math.round((imgH * resizeWidth) / imgW);
			}else{
				resizeHeight = h;
				resizeWidth = Math.round((imgW * resizeHeight) / imgH);
			}
		}else{
			resizeWidth = imgW;
			resizeHeight = imgH;
		}
		
		var src = $obj.attr("src");
		if(src == "/mobile/img/no_image.png"){
			$obj.css({"width":"50%","height":"auto"});
		}else{
			$obj.css({"width":resizeWidth,"height":resizeHeight});
		}
	},
	
	failImageLoad : function($img){
		if($img.src.search("no_image") > -1){
			return;
		}
		
		$img.src = "/mobile/img/no_image.png";
	},
	
	imageLoad : function(layerId,$obj,imageParam){
		var w = $("#"+layerId+" .detailWrap").width() - 2;
		var h = $obj.parent().height();
		$obj.css({"width":"50%","height":"auto"});
		
		if($.trim(imageParam) != ""){
			if(imageParam.indexOf(".") > -1){
				$obj.attr({"src":"/common/image/view.data?fileName="+imageParam+"&&type=1"});
				$obj.load(function(){
					$(this).css({"width":"100%","height":"auto"});
					mobileSearchHelp.resizeImage(w,h,$(this));
				});
			}else{
				$obj.attr({"src":"/common/image/view.data?fileName="+imageParam+"&&type=2"});
				$obj.load(function(){
					$(this).css({"width":"100%","height":"auto"});
					mobileSearchHelp.resizeImage(w,h,$(this));
				});
			}
		}else{
			$obj.attr({"src":"/mobile/img/no_image.png"});
			$obj.load(function(){
				$(this).css({"width":"50%","height":"auto"});
			});
		}
	},
	
	movePrevRow : function(id){
		var searchHelp = mobileSearchHelp.searchHelp.get(id);
		var gridId     = searchHelp.get("gridId");
		var gridId     = searchHelp.get("gridId");
		var layerId    = searchHelp.get("layerId");
		
		var rowNum = gridList.getFocusRowNum(gridId);
		if(rowNum == 0){
			return;
		}
		
		rowNum = rowNum - 1;
		
		gridList.setRowFocus(gridId,rowNum,true);
		
		var $grid    = $("#"+layerId+" .gridArea");
		var $detail  = $("#"+layerId+" .detailArea");
		
		var data   = gridList.getRowData(gridId,rowNum);
		
		var $dataArea = $detail.find("table").find("td");
		$dataArea.each(function(){
			var $obj    = $(this);
			var colName = $obj.attr("id");
			
			var colValue = data.get(colName);
			if(colName == "LOTL10"){
				var $img = $obj.find("img");
				mobileSearchHelp.imageLoad(layerId,$img,colValue);
			}else{
				$obj.html(colValue);
			}
		});
	},
	
	moveNextRow : function(id){
		var searchHelp = mobileSearchHelp.searchHelp.get(id);
		var gridId     = searchHelp.get("gridId");
		var layerId    = searchHelp.get("layerId");
		
		var rowNum = gridList.getFocusRowNum(gridId);
		if((rowNum + 1) == gridList.getGridDataCount(gridId)){
			return;
		}
		
		rowNum = rowNum + 1;
		
		gridList.setRowFocus(gridId,rowNum,true);
		
		var $grid    = $("#"+layerId+" .gridArea");
		var $detail  = $("#"+layerId+" .detailArea");
		
		var data   = gridList.getRowData(gridId,rowNum);
		
		var $dataArea = $detail.find("table").find("td");
		$dataArea.each(function(){
			var $obj    = $(this);
			var colName = $obj.attr("id");
			
			var colValue = data.get(colName);
			if(colName == "LOTL10"){
				var $img = $obj.find("img");
				mobileSearchHelp.imageLoad(layerId,$img,colValue);
			}else{
				$obj.html(colValue);
			}
		});
	},
	
	setToggleButtonEvent($obj){
		$obj.on("click",function(){
			var objId      = $obj.attr("id");
			var id         = objId.split("_")[0];
			var searchHelp = mobileSearchHelp.searchHelp.get(id);
			var gridId     = searchHelp.get("gridId");
			
			var layerId    = searchHelp.get("layerId");
			
			var $grid    = $("#"+layerId+" .gridArea");
			var $detail  = $("#"+layerId+" .detailArea");
			
			var $btnArea1 = $("#"+layerId+"_BTN1");
			var $btnArea2 = $("#"+layerId+"_BTN2");
			
			if($obj.is(":checked")){
				$grid.hide();
				$detail.show();
				$btnArea1.hide();
				$btnArea2.show();
				
				var rowNum = gridList.getFocusRowNum(gridId);
				if(rowNum < 0){
					rowNum = 0;
					gridList.setRowFocus(gridId,rowNum,true);
				}
				
				var data   = gridList.getRowData(gridId,rowNum);
				
				var $dataArea = $detail.find("table").find("td");
				$dataArea.each(function(){
					var $obj    = $(this);
					var colName = $obj.attr("id");
					
					var colValue = data.get(colName);
					if(colName == "LOTL10"){
						var $img = $obj.find("img");
						mobileSearchHelp.imageLoad(layerId,$img,colValue);
					}else{
						$obj.html(colValue);
					}
				});
			}else{
				$grid.show();
				$detail.hide();
				$btnArea1.show();
				$btnArea2.hide();
			}
		});
	},
	
	imageTransSize : function(){
		
	},
	
	setGridSize : function(id){
		var searchHelp  = mobileSearchHelp.searchHelp.get(id);
		var layerId     = searchHelp.get("layerId");
		var gridId      = searchHelp.get("gridId");
		
		var search      = searchHelp.get("search");
		var isSearch    = search.get("useYn");
		var searchType  = searchHelp.get("searchType");
		
		var $obj        = $("#"+gridId);
		
		var $head       = $obj.parent().parent().prev();
		var $body       = $obj.parent().parent().parent().parent();
		var $bodyWapper = $obj.parent().parent().parent().parent().parent();
		
		var gridWidth   = $head.find("table").width();
		
		var photoView   = searchHelp.get("photoView");
		if(photoView){
			isSearch = true;
			searchType = "in";
		}
		
		$head.next().css("width",gridWidth);
		
		var wrapHeight    = $(".layerPopWrap").height();
		var titleHeight   = $(".popupTitle").height();
		var searchBtnArea = 30;
		var btnArea       = isSearch?20:0;
		var gridHeight    = wrapHeight - titleHeight - searchBtnArea - btnArea;
		
		if(!isSearch){
			$bodyWapper.css("top","40px");
			$body.css("height",(gridHeight - 15));
		}else{
			var $layer = $("#"+layerId);
			var $search = $layer.find(".tem6_search");
			var $searchContent = $layer.find(".tem6_search_content");
			var $searchBtn = $layer.find(".tem6_search_btn");
			
			var height = $searchContent.height() - 30;
			if(searchType == "out"){
				$searchBtn.addClass("on");
				$searchBtn.find(".arrow").css({"margin-bottom":"3px","transform": "rotate(45deg)","webkit-transform": "rotate(45deg)"});
				$search.css("top",-(height + 2) + "px");
				$layer.find(".tem6_content").css("z-index",9999);
			}
			mobileSearchHelp.setInnerSearchButtonEvent(layerId);
			
			var scanAreaHeight = searchType == "in"?($("#"+layerId).find(".scan_area").height() + 5):15;
			$body.css("height",(gridHeight - scanAreaHeight));
			
			if(photoView){
				var $detail = $layer.find(".detailArea");
				if($detail.length > 0){
					$detail.css({"height":(gridHeight - scanAreaHeight)});/*,"position":"relative","display":"none"*/
					$detail.find("table").find("tr").eq(2).find("td").css({"height":(gridHeight - scanAreaHeight - 80)});
				}
			}
		}
	},
	
	userButtonEvent : function(layerId,gridId,module,command,searchId,btnId){
		if(commonUtil.checkFn("searchHelpUserButtonClickEvent")){
			searchHelpUserButtonClickEvent(layerId,gridId,module,command,searchId,btnId);
		}
	},
	
	setInnerSearchButtonEvent : function(layerId){
		var $layer = $("#"+layerId);
		$layer.find(".tem6_search_btn").on("click",function(){
			var $obj = $layer.find(".tem6_search");
			var $btn = $(this);
			var on = $btn.hasClass("on");
			
			$layer.find(".tem6_content").css("z-index",0);
			
			if(on){
				$btn.removeClass("on");
				$obj.animate({top:30},300);
				$btn.find(".arrow").css({"margin-bottom":"-6px","transform": "rotate(224deg)","webkit-transform": "rotate(224deg)"});
			}else{
				$btn.addClass("on");
				
				var $content = $obj.find(".tem6_search_content");
				var height = $content.height() - 30;
				
				$obj.animate({top:-(height + 2)},300);
				$btn.find(".arrow").css({"margin-bottom":"3px","transform": "rotate(45deg)","webkit-transform": "rotate(45deg)"});
			}
			
			setTimeout(function(){
				if(on){
					$layer.find(".tem6_content").css("z-index",0);
				}else{
					$layer.find(".tem6_content").css("z-index",9999);
				}
			}, 300);
		});
	},
	
	selectSearchHelp : function(id){
		var searchHelp = mobileSearchHelp.searchHelp.get(id);
		
		var layerId    = searchHelp.get("layerId");
		var gridId     = searchHelp.get("gridId");
		var bindId     = searchHelp.get("bindId");
		var photoView  = searchHelp.get("photoView");
		var returnCol  = searchHelp.get("returnCol");
		var $returnObj = searchHelp.get("returnObject");
		
		var param = new DataMap();
		if(commonUtil.checkFn("selectSearchHelpBefore")){
			param = selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj);
			if(param == false){
				return;
			}
		}
		
		gridList.gridList({
			id : gridId,
			param : param
		});
		
		var $layer = $("#"+layerId);
		$layer.show();
		
		if(photoView){
			var $toggle = $("#"+layerId+"_TOGGLE");
			if($toggle.is(":checked")){
				$toggle.click();
			}
		}
		
		var $scanArea = $layer.find(".scan_area");
		if($scanArea.length > 0){
			var $select = $scanArea.find("select");
			if($select.length > 0){
				$select.unbind("click").on("click",function(){
					mobileKeyPad.focusOnEvent($(this));
				});
			}
		}
	},
	
	searchHelpCloseEvent : function(id){
		var searchHelp = mobileSearchHelp.searchHelp.get(id);
		
		var layerId    = searchHelp.get("layerId");
		var bindId     = searchHelp.get("bindId");
		var gridId     = searchHelp.get("gridId");
		var photoView  = searchHelp.get("photoView");
		var returnCol  = searchHelp.get("returnCol");
		var $returnObj = searchHelp.get("returnObject");
		
		mobileSearchHelp.initSearhHelpArea(layerId,gridId);
		
		if(photoView){
			var $toggle = $("#"+layerId+"_TOGGLE");
			if($toggle.is(":checked")){
				$toggle.click();
			}
			
			$("#"+layerId).find(".gridArea").show();
			$("#"+layerId).find(".detailArea").hide();
			$("#"+layerId+"_BTN1").show();
			$("#"+layerId+"_BTN2").hide();
		}
		
		var $layer = $("#"+layerId);
		$layer.hide();
		
		if(bindId == undefined && bindId== null && $.trim(bindId) == ""){
			return;
		}else{
			if(returnCol && $returnObj.length > 0){
				setTimeout(function(){
					mobileCommon.select("",bindId,$returnObj.attr("name"));
				});
			}
		}
	},
	
	searchHelpSelectEvent : function(id){
		var searchHelp = mobileSearchHelp.searchHelp.get(id);
		
		var layerId    = searchHelp.get("layerId");
		var bindId     = searchHelp.get("bindId");
		var gridId     = searchHelp.get("gridId");
		var photoView  = searchHelp.get("photoView");
		var returnCol  = searchHelp.get("returnCol");
		var $returnObj = searchHelp.get("returnObject");
		
		var rowNum = gridList.getFocusRowNum(gridId);
		if(rowNum < 0){
			mobileCommon.alert({
				message : "선택한 데이터가 없습니다."
			});
			return;
		}
		
		var data = gridList.getRowData(gridId,rowNum);
		if(returnCol == false){
			returnCol = false;
		}else{
			var rowData = data.get(returnCol);
			$returnObj.val(rowData);
		}
		
		mobileSearchHelp.initSearhHelpArea(layerId,gridId);
		if(photoView){
			var $toggle = $("#"+layerId+"_TOGGLE");
			if(!$toggle.is("checked")){
				$toggle.click();
			}
			
			$("#"+layerId).find(".gridArea").show();
			$("#"+layerId).find(".detailArea").hide();
			$("#"+layerId+"_BTN1").show();
			$("#"+layerId+"_BTN2").hide();
		}
		
		var $layer = $("#"+layerId);
		$layer.hide();
		
		if(commonUtil.checkFn("selectSearchHelpAfter")){
			selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj);
		}
	},
	
	initSearhHelpArea : function(layerId,gridId){
		$("#"+layerId).find("input,select").each(function(){
			if($(this)[0].tagName == "SELECT"){
				var value = $(this).find("option").eq(0).val();
				$(this).val(value);
			}else{
				$(this).val("");
			}
		});
		
		gridList.resetGrid(gridId);
	}
}

var mobileSearchHelp = new MobileSearchHelp();