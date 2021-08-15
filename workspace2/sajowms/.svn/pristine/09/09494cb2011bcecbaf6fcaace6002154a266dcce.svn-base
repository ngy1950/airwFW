TreeBox = function(id) {
	this.id = id;
	this.$box = jQuery("#"+this.id);
	this.$box.addClass("ztree");
	this.editable = true;
	this.module;
	this.command;
	this.url = "";
	
	this.nameText = "name";
	this.pkCol = "IDKEY";
	this.pidCol = "PIDKEY";
	this.nameCol = "NAMEKEY";
	this.sortCol = "SORTKEY";
	this.rootData = "root";
	
	this.data;
	this.dataMap = new DataMap();
	this.bindArea;
	
	this.treeObj;
	
	this.validation;
	
	this.cols = new Array();
	
	this.editable = true;
	this.idKey = "id";
	this.pidKey = "pId";
	this.rootPid = "root";
	
	this.msgType = true;
	this.modifyMap = new DataMap();
	this.beforeParentData = null;
	this.beforeDataMap = null;
}

TreeBox.prototype = {
	setTree : function() {
		var treeBox = this;
		
		this.setting = {
				edit: {
					enable: this.editable,
					showRemoveBtn: false,
					showRenameBtn: false
				},
				key: {
					name : this.nameText,
					url : this.url
				},
				data: {
					simpleData: {
						enable: true,
						idKey: this.idKey,
						pIdKey: this.pidKey,
						rootPId: this.rootPid
					}
				},
				view: {
					txtSelectedEnable: true
				},
				callback: {
					onClick : function(event, treeId, treeNode){
						//commonUtil.debugMsg("tree click : ", arguments);
						treeBox.clickEvent(treeNode);
					},
					beforeDrop : function(treeId, treeNodes, targetNode, moveType, isCopy){
						treeBox.beforeParentData = {};
						treeBox.beforeParentData["level"] = treeNodes[0]["level"];
						treeBox.beforeParentData["tId"] = treeNodes[0]["tId"];
						treeBox.beforeParentData["parentTId"] = treeNodes[0]["parentTId"];
					},
					onDrop : function(event, treeId, treeNodes, targetNode, moveType, isCopy){
						//commonUtil.debugMsg("tree onDrop : ", arguments);
						if(isCopy){
							for(var i = 0; i <treeNodes.length; i++){
								treeBox.addRow(treeNodes[i], targetNode);
							}
						}else{
							if(moveType == "inner"){
								var treeNodesLen = treeNodes.length;
								if(treeNodesLen > 0){
									for(var  i = 0; i < treeNodesLen; i++){
										var treeNode = treeNodes[i];
										treeBox.setSortOrder(targetNode,treeNode);
									}
								}
							}else if(moveType == "prev" || moveType == "next"){
								var treeNodesLen = treeNodes.length;
								if(treeNodesLen > 0){
									var targetLevel = targetNode["level"];
									if(targetLevel > 0){
										var targetParentPid = targetNode["parentTId"];
										var targetParent = treeBox.treeObj.getNodeByTId(targetParentPid);
										for(var  i = 0; i < treeNodesLen; i++){
											var treeNode = treeNodes[i];
											treeBox.setSortOrder(targetParent,treeNode);
										}
									}else{
										var allNodes = treeBox.treeObj.getNodes();
										for(var i = 0; i < allNodes.length; i++){
											var allNode = allNodes[i];
											var allNodeTid = allNode["tId"];
											var allNodePid = allNode[treeBox.pidKey];
											var allNodeParentId = allNode[treeBox.pidCol];
											var sort = String(i + 1);
											var allNodeSort = allNode[treeBox.sortCol];
											if(sort != allNodeSort){
												allNode[treeBox.sortCol] = sort;
												
												var data = treeBox.dataMap.get(allNodeTid);
												data[treeBox.sortCol] = sort;
												if(allNodePid != allNodeParentId){
													allNode[treeBox.pidCol] = allNodePid;
													data[treeBox.pidCol] = allNodePid;
												}
												
												treeBox.isChangeData(allNodeTid);
												
												var nodeChildrens = (allNode.children != null && allNode.children != undefined)?allNode.children : [];
												var nodeChildrensLen = (nodeChildrens != null && nodeChildrens != undefined)?nodeChildrens.length : 0;
												if(nodeChildrensLen > 0){
													for(var j = 0; j < nodeChildrensLen; j++){
														var nodeChildren = nodeChildrens[j];
														treeBox.setSortOrder(allNode,nodeChildren);
													}
												}
											}
										}
									}
								}
							}
						}
					},
					beforeRemove : function(treeId, treeNode){
						return treeBox.removeRow(treeNode);
					},
					beforeEditName : function(treeId, treeNode){
						return treeBox.editRow(treeNode);
					}
				},
			};
		
		$.fn.zTree.init(this.$box, this.setting, this.data);
		this.treeObj = $.fn.zTree.getZTreeObj(this.id);
		
		if(this.bindArea){
			var treeBox = this;
			jQuery("#"+this.bindArea).find("input,select,textarea").each(function(i, findElement){
				var $bindObj = jQuery(findElement);
				
				$bindObj.change(function(event){
					var $obj = $(event.target);
					var objName = $obj.attr("name");			
					
					var focusNode = treeBox.getFocusRow();
					if(focusNode){
						var colValue = $obj.val();
						if($obj.attr("type") == "checkbox" && !$obj.prop("checked")){
							colValue = site.emptyValue;
						}
						treeBox.setColValue(focusNode, objName, colValue);
					}
				});
			});
		}
		
		this.setInnerButtonEvent();
	},
	setSortOrder : function(targetNode, treeNode){
		var targetSort = targetNode[this.sortCol];
	    var targetMenuId = targetNode[this.idKey];
		
		var targetNodeChilds = targetNode.children;
		if(targetNodeChilds.length > 0){
			for(var i = 0; i < targetNodeChilds.length; i++){
				var targetNodeChild = targetNodeChilds[i];
				var targetNodeChildTid = targetNodeChild["tId"];
				var targetNodeChildSort = targetNodeChild[this.sortCol];
				var targetNodeChildParentSort = targetSort + String(i + 1);
				var targetNodeChildPid = targetNodeChild[this.pidKey];
				var targetNodeChildParentId = targetNodeChild[this.pidCol];
				if(targetNodeChildSort != targetNodeChildParentSort){
					targetNodeChild[this.sortCol] = targetNodeChildParentSort;
					
					var data = this.dataMap.get(targetNodeChildTid);
					data[this.sortCol] = targetNodeChildParentSort;
					
					if(targetNodeChildPid != targetNodeChildParentId){
						targetNodeChild[this.pidCol] = targetNodeChildPid;
						data[this.pidCol] = targetNodeChildPid;
					}
					
					this.isChangeData(targetNodeChildTid);
				}
			}
		}
		
		var treeNodeChildrens = (treeNode.children != undefined && treeNode.children != null)?treeNode.children:[];
		var treeNodeChildrensLen = (treeNodeChildrens != undefined && treeNodeChildrens != null)?treeNodeChildrens.length:0;
		
		if(treeNodeChildrensLen > 0){
			for(var i = 0; i < treeNodeChildrensLen; i++){
				var treeNodeChildren = treeNodeChildrens[i];
				var treeNodeChildrenMenuId = treeNodeChildren[this.idKey];
				var treeNodeChildrenSort = treeNodeChildren[this.sortCol];
				var treeNodeChildrenName = treeNodeChildren[this.nameCol];
				
				this.setSortOrder(treeNode,treeNodeChildren);
			}
		}
	},
	isChangeData : function(treeId){
		if(treeId != "" && treeId != undefined){
			var dataMap = this.dataMap.get(treeId);
			var beforeMapData = this.beforeDataMap.get(treeId);
			var pid  = dataMap[this.pidCol];
			var name = dataMap[this.nameCol];
			var sort = dataMap[this.sortCol];
			
			var beforePid  = beforeMapData[this.pidCol];
			var beforeName = beforeMapData[this.nameCol];
			var beforeSort = beforeMapData[this.sortCol];
			if((pid != beforePid) || (name != beforeName) || (sort != beforeSort)){
				if(dataMap[configData.GRID_ROW_STATE_ATT] == configData.GRID_ROW_STATE_READ){
					dataMap[configData.GRID_ROW_STATE_ATT] = configData.GRID_ROW_STATE_UPDATE;
					this.modifyMap.put(treeId,dataMap);
				}
			}else{
				if(dataMap[configData.GRID_ROW_STATE_ATT] == configData.GRID_ROW_STATE_UPDATE){
					dataMap[configData.GRID_ROW_STATE_ATT] = configData.GRID_ROW_STATE_READ;
					this.modifyMap.remove(treeId);
				}
			}
		}
	},
	setInnerButtonEvent : function(){
		var treeBox = this;
		
		var $body = $("body");
		var $div = $("<div>");
		var $ul = $("<ul>");
		var $li = $("<li>");
		var $button = $("<button>");
		var $span = $("<span>");
		
		var $contextMenu = $div.clone().addClass("context_menu").attr("id",treeBox.id + "_menu");
		var $root = $li.clone().attr({"id":treeBox.id + "_root_btn","onclick":"treeList.addNewRow('"+treeBox.id+"');"}).append($button.clone().addClass("root").append($span.clone().addClass("root_txt").text("ROOT 추가")));
		var $add = $li.clone().attr({"id":treeBox.id + "_add_btn","onclick":"treeList.addNewRow('"+treeBox.id+"');"}).append($button.clone().addClass("add").append($span.clone().text("추가")));
		var $del = $li.clone().attr({"id":treeBox.id + "_del_btn","onclick":"treeList.removeRow('"+treeBox.id+"');"}).append($button.clone().addClass("del").append($span.clone().text("삭제")));
		
		$body.append($contextMenu.append($ul.append($root).append($add).append($del)));
		
		document.addEventListener("mousedown", function() {
			if ((event.button == 2) || (event.which == 3)) {
				var arr = [];
				var $treeObject = $("#"+treeBox.id).find("ul,li,a,span");
				$treeObject.each(function(){
					var treeObjId = $(this).attr("id");
					arr.push(treeObjId);
				});
				arr.push($("#"+treeBox.id).parent().attr("id"));
				
				var targetId = $(event.target).attr("id");
				
				var isSelect = false;
				if(arr.indexOf(targetId) > -1){
					isSelect = true;
				}
				
				if(isSelect){
					$(document).contextmenu(function(){
						event.preventDefault();
					});
					
					treeBox.setSelectNodeInit(event);
					
					var top = (event.clientY - 40) + 35;
					var left = event.clientX;
					
					var showType = "root";
					var $nodeObjs = treeBox.treeObj.getSelectedNodes();
					if($nodeObjs.length > 0){
						if($nodeObjs.length == 1){
							showType = "add";
						}else{
							showType = "del";
						}
						var $nodeObj = $nodeObjs[$nodeObjs.length - 1];
						var id = $nodeObj["tId"];
						var $tLi = $("#"+id);
						var $tA = $("#"+id+"_a");
						
						var wWrap = 48;
						var wPadding = 0;
						var wIcon = $tA.prev().outerWidth(true);
						var wA = $tA.outerWidth(true);
						
						var $tUl = $tA.parents("ul");
						var $tUlLen = $tUl.length;
						$tUl.each(function(i){
							if((i + 1) < $tUlLen){
								wPadding = wPadding + 18;
							}
						});
						
						left = wWrap + wPadding + wIcon + wA;
						
						var docTarget = document.getElementById(id + "_a");
						top = docTarget.getBoundingClientRect().top;
					}
					var $context = $("#"+treeBox.id+"_menu");
					if($context.hasClass("on")){
						$context.hide();
						$context.removeClass("on");
						$context.css({"top": 0,"left": 0});
					}else{
						if(showType == "root"){
							$("#"+treeBox.id+"_root_btn").show();
							$("#"+treeBox.id+"_add_btn").hide();
							$("#"+treeBox.id+"_del_btn").hide();
						}else if(showType == "add"){
							$("#"+treeBox.id+"_root_btn").hide();
							$("#"+treeBox.id+"_add_btn").show();
							$("#"+treeBox.id+"_del_btn").show();
						}else{
							$("#"+treeBox.id+"_root_btn").hide();
							$("#"+treeBox.id+"_add_btn").hide();
							$("#"+treeBox.id+"_del_btn").show();
						}
						
						$context.show();
						$context.addClass("on");
						$context.css({"top": top,"left":left});
					}
				}else{
					$(document).unbind();
					var $context = $("#"+treeBox.id+"_menu");
					$context.hide();
					$context.removeClass("on");
					$context.css({"top": 0,"left": 0});
				}
		 	}
		});
		$("html").unbind("click").on("click",function(e){
			var $context = $("#"+treeBox.id+"_menu");
			
			var btnArr = [];
			$context.find("li").each(function(){
				var id = $(this).attr("id");
				if(id != undefined){
					if(id.indexOf("_del") == -1){
						btnArr.push($(this).attr("id"));
					}
				}
			});
			var btnId = $(e.target).parent().parent().attr("id");
			if(btnArr.indexOf(btnId) == -1){
				$context.hide();
				$context.removeClass("on");
				$context.css({"top": 0,"left": 0});
			}
			
			treeBox.setSelectNodeInit(e);
		});
	},
	setSelectNodeInit : function (e){
		var treeBox = this;
		
		var arr = [];
		var $treeObject = $("#"+this.id).find("a,span");
		$treeObject.each(function(){
			var treeObjId = $(this).attr("id");
			arr.push(treeObjId);
		});
		
		$("#"+treeBox.id+"_menu li").each(function(){
			arr.push($(this).attr("id"));
		});
		
		var isInit = false;
		var node = this.treeObj;
		var id = $(e.target).attr("id");
		if(id != undefined){
			if(arr.indexOf(id) == -1){
				var selectNodes = treeBox.treeObj.getSelectedNodes();
				for(var i = 0; i < selectNodes.length; i++){
					var selectNode = selectNodes[i];
					treeBox.treeObj.cancelSelectedNode(selectNode);
				}
				isInit = true;
			}
		}else{
			var selectNodes = treeBox.treeObj.getSelectedNodes();
			if(selectNodes.length > 1){
				isInit = true;
			}
		}
		if(isInit){
			$(".context_menu").hide();
			if(this.bindArea){
				var $bindInput = $("#"+this.bindArea).find("input,select,textarea");
				$bindInput.each(function(){
					var type = $(this).attr("type");
					switch (type) {
					case "select":
						var value = $(this).eq(0).val();
						$(this).val(value);
						break;
					case "checkbox":
						$(this).prop("checked",false);
						break;	
					case "radio":
						$(this).prop("checked",false);
						break;
					default:
						$(this).val("");
						break;
					}
				});
			}
		}
	},
	setData : function(data) {
		var nodes = this.treeObj.getNodes();
		this.data = data;
		
		var id = this.idKey;
		var pidKey = this.pidKey;
		var name = this.nameText;
		
		this.dataMap = new DataMap();
		this.beforeDataMap = new DataMap();
		if(this.data){
			for(var i=0;i<this.data.length;i++){
				var key = this.id + "_" + (i+1);
				
				var putObjData = this.data[i];
				var putObj = {};
				var putObjKeys = Object.keys(putObjData);
				if(putObjKeys.length > 0){
					for(var j = 0; j < putObjKeys.length; j++){
						var putObjKey = putObjKeys[j];
						if(putObjKey != "id" && putObjKey != "name" && putObjKey != "pId"  && putObjKey != "tId"){
							putObj[putObjKey] = putObjData[putObjKey];
						}
					}
				}
				this.beforeDataMap.put(key, putObj);
				
				this.data[i]["tId"] = this.id + "_" + (i+1);
				this.data[i][id] = this.data[i][this.pkCol];
				this.data[i][pidKey] = this.data[i][this.pidCol];
				this.data[i][name] = this.data[i][this.nameCol]; 
				this.data[i][configData.GRID_ROW_STATE_ATT] = configData.GRID_ROW_STATE_READ;
				this.data[i][configData.GRID_ROW_NUM] = i;
				
				this.dataMap.put(key, this.data[i]);
			}
		}
		$.fn.zTree.init(this.$box, this.setting, this.data);
		this.treeObj = $.fn.zTree.getZTreeObj(this.id);
		
		if(commonUtil.checkFn("treeListEventDataBindEnd")){
			treeListEventDataBindEnd(this.id, this.data.length);
		}
	},
	getData : function() {
		var nodes = this.treeObj.transformToArray(this.treeObj.getNodes());
		var list = new Array();
		var node;
		for(var i=0;i<nodes.length;i++){
			node = nodes[i];
			var dataMap = this.dataMap.get(node.tId);
			dataMap["tId"] = node.tId;
			list.push(new DataMap(dataMap));
		}
		return list;
	},
	getModifyData : function() {
		var nodes = this.treeObj.transformToArray(this.treeObj.getNodes());
		var keyList = new Array();
		var list = new Array();
		var node;
		for(var i=0;i<nodes.length;i++){
			node = nodes[i];
			if(this.modifyMap.containsKey(node.tId)){
				var dataMap = new DataMap(this.modifyMap.get(node.tId));
				list.push(dataMap);
			}
			keyList.push(node["tId"]);
		}
		
		var map = new DataMap();
		map.put("list", list);
		map.put("keyList", keyList);
		
		return map;
	},
	getRowData : function(rowNum) {
		var id = this.findRowNumToTid(this.id, rowNum);
		var data = this.dataMap.get(id);
		return new DataMap(data);
	},
	getFocusRow : function() {
		var nodes = this.treeObj.getSelectedNodes();
		if (nodes.length>0) {
			return nodes[0];
		}
		return null;
	},
	setColValue : function(treeNode, colName, colValue) {
		var id = treeNode.tId;
		
		treeNode[colName] = colValue;
		var rowData = this.dataMap.get(id);
		if(colName == this.nameCol){
			treeNode.name = colValue;
			rowData[this.nameText] = colValue;
			this.treeObj.refresh();
			this.treeObj.selectNode(treeNode);
		}
		
		if(colName == this.pkCol){
			if(treeNode.children != undefined && treeNode.children.length > 0){
				for(var  i = 0; i < treeNode.children.length; i++){
					var childNode = treeNode.children[i];
					childNode[this.pidCol] = colValue;
					childNode[this.pidKey] = colValue;
					if(this.modifyMap.containsKey(childNode["tId"])){
						this.modifyMap.get(childNode["tId"])[this.pidCol] = colValue;
					}else{
						var childData = this.dataMap.get(childNode["tId"]);
						if(childData[configData.GRID_ROW_STATE_ATT] == configData.GRID_ROW_STATE_READ){
							childData[configData.GRID_ROW_STATE_ATT] = configData.GRID_ROW_STATE_UPDATE;
						}
						this.modifyMap.put(childNode["tId"],childData);
					}
				}
			}
		}
		
		rowData[colName] = colValue;
		var modify = this.modifyMap;
		if(modify.containsKey(id)){
			modify.get(id)[colName] = colValue;
		}else{
			if(rowData[configData.GRID_ROW_STATE_ATT] == configData.GRID_ROW_STATE_READ){
				rowData[configData.GRID_ROW_STATE_ATT] = configData.GRID_ROW_STATE_UPDATE;
			}
			modify.put(id,rowData);
		}
		
		if(this.bindArea){
			dataBind.dataNameBind(rowData, this.bindArea);
		}
		
		if(commonUtil.checkFn("treeGridColValueChangeEvent")){
			var data = this.dataMap.get(id);
			var rowNum = data[configData.GRID_ROW_NUM];
			
			var beforeData = this.beforeDataMap.get(id);
			var beforeVal = beforeData[colName]; 
			if(beforeVal == undefined ||  beforeVal != colValue){
				treeGridColValueChangeEvent(this.id, rowNum, colName, colValue, treeNode);
			}
		}
	},
	clickEvent : function(treeNode) {
		var selectNodes = this.treeObj.getSelectedNodes();
		var id = treeNode.tId;
		id = selectNodes[0]["tId"];
		var rowData = new DataMap(this.dataMap.get(id));
		if(this.bindArea){
			if(selectNodes.length > 1){
				var $bindInput = $("#"+this.bindArea).find("input,select,textarea");
				$bindInput.each(function(){
					var type = $(this).attr("type");
					switch (type) {
					case "select":
						var value = $(this).eq(0).val();
						$(this).val(value);
						break;
					case "checkbox":
						$(this).prop("checked",false);
						break;	
					case "radio":
						$(this).prop("checked",false);
						break;
					default:
						$(this).val("");
						break;
					}
				});
			}else{
				dataBind.dataNameBind(rowData, this.bindArea);
			}
		}
	},
	removeRows : function() {
		var nodes = this.treeObj.getSelectedNodes();
		if (nodes.length > 0) {
			if(this.msgType && !confirm(commonUtil.getMsg(configData.MSG_MASTER_DELETE_CONFIRM))){
				return false;
			}
			for(var i = 0; i < nodes.length; i++){
				var node = nodes[i];
				this.removeRow(node);
			}
			
			if(this.bindArea){
				var rowData = new DataMap();
				$("#"+this.bindArea).find("input,select").each(function(){
					var key = $(this).attr("name");
					rowData.put(key,"");
				});
				dataBind.dataNameBind(rowData, this.bindArea);
			}
		}
	},
	removeRow : function(treeNode) {
		if(treeNode != undefined){
			this.removeData(treeNode);
			if(treeNode.children != undefined && treeNode.children.length > 0){
				for(var i = 0; i < treeNode.children.length; i++){
					var node = treeNode.children[i];
					this.removeRow(node);
				}
			}
		}
	},
	removeData : function(treeNode) {
		var tId = treeNode["tId"];
		if(this.modifyMap.containsKey(tId)){
			if(this.modifyMap.get(tId)[configData.GRID_ROW_STATE_ATT] == configData.GRID_ROW_STATE_INSERT){
				this.modifyMap.remove(tId);
				this.dataMap.remove(tId);
			}else{
				treeNode[configData.GRID_ROW_STATE_ATT] = configData.GRID_ROW_STATE_DELETE;
				this.dataMap.get(tId)[configData.GRID_ROW_STATE_ATT] = configData.GRID_ROW_STATE_DELETE;
				this.modifyMap.put(tId, this.dataMap.get(tId));
			}	
		}else{
			if(this.dataMap.get(tId)[configData.GRID_ROW_STATE_ATT] == configData.GRID_ROW_STATE_INSERT){
				this.dataMap.remove(tId);
			}else{
				treeNode[configData.GRID_ROW_STATE_ATT] = configData.GRID_ROW_STATE_DELETE;
				this.dataMap.get(tId)[configData.GRID_ROW_STATE_ATT] = configData.GRID_ROW_STATE_DELETE;
				this.modifyMap.put(tId, this.dataMap.get(tId));
			}	
		} 
		this.treeObj.removeNode(treeNode);
	},
	editRow : function(treeNode) {
		var status = "";
		var rowData = new DataMap();
		if(this.modifyMap.containsKey(treeNode.id)){
			rowData = this.modifyMap.get(treeNode.id);
			status = rowData[configData.GRID_ROW_STATE_ATT];
		}else{
			status = configData.GRID_ROW_STATE_UPDATE;
			rowData = this.dataMap.get(treeNode.id);
		}
		
		if(this.bindArea){
			var data = dataBind.paramData(this.bindArea);
			rowData.putAll(data);
			rowData.put(configData.GRID_ROW_STATE_ATT,status);
		}
		
		this.modifyMap.put(treeNode.tId, rowData);
		
		return false;
	},
	addRow : function(treeNode, targetNode) {
		if(targetNode){
			treeNode[this.pidCol] = targetNode[this.pkCol];
			treeNode[this.pidKey] = targetNode[this.idKey];
		}
	},
	addNewRow : function(isNodeFocus) {
		var newNode = new Object();
		for(var i=0;i<this.cols.length;i++){
			newNode[this.cols[i]] = "";
		}
		newNode[this.idKey] = 0;
		newNode[this.pidKey] = 0;
		newNode["name"] = "NEW";
		
		var parentNode;
		var nodes = this.treeObj.getSelectedNodes();
		if (nodes.length > 0) {			
			parentNode = nodes[0];
		}
		
		newNode = this.treeObj.addNodes(parentNode,newNode);
		newNode[0][this.idKey] = newNode[0]["tId"];
		
		var param = null;
		if(commonUtil.checkFn("treeGridAddRowEventBefore")){
			param = treeGridAddRowEventBefore(this.id, parentNode, newNode);
			if(param != undefined && param != null && !param.isEmpty()){
				var obj = {};
				
				var keys = param.keys();
				if(keys.length > 0){
					for(var i in keys){
						var key = keys[i];
						var value = param.get(key);
						
						obj[key] = value;
						newNode[0][key] = value;
					}
				}
				var sort = "";
				if(newNode[0]["level"] > 0){
					var parentSort = parentNode[this.sortCol];
					sort = parentSort + String(parentNode.children.length);
					newNode[0][this.pidCol] = parentNode[this.pkCol];
				}else{
					var allNodes = this.treeObj.getNodes();
					sort = String(allNodes.length);
					newNode[0][this.pidCol] = this.rootData;
				}
				newNode[0][this.sortCol] = sort;
				
				obj["tId"] = newNode[0]["tId"];
				obj["name"] = newNode[0]["name"];
				obj[this.idKey] = newNode[0][this.pkCol];
				obj[this.pidKey] = newNode[0][this.pidKey];
				obj[this.pidCol] = newNode[0][this.pidCol];
				obj[this.sortCol] = newNode[0][this.sortCol];
				obj[configData.GRID_ROW_STATE_ATT] = configData.GRID_ROW_STATE_INSERT;
				var rowNum = 0;
				if(this.dataMap.size() > 0){
					rowNum = this.dataMap.size();
				}
				newNode[0][configData.GRID_ROW_NUM] = rowNum;
				obj[configData.GRID_ROW_NUM] = rowNum;
				
				this.dataMap.put(newNode[0].tId,obj);
				this.modifyMap.put(newNode[0].tId,obj);
			}
		}
		
		if(commonUtil.checkFn("treeGridAddRowEventAfter")){
			param = treeGridAddRowEventAfter(this.id, parentNode, newNode);
			if(param != undefined && param != null && !param.isEmpty()){
				var keys = param.keys();
				if(keys.length > 0){
					for(var i in keys){
						var key = keys[i];
						var value = param.get(key);
						var data = this.dataMap.get(newNode[0]["tId"]);
						data[key] = value;
					}
				}
			}
		}
		
		if(isNodeFocus){
			this.treeObj.selectNode(newNode[0]);
			if(this.bindArea){
				var rowData = this.modifyMap.get(newNode[0].tId);
				dataBind.dataNameBind(param, this.bindArea);
			}
		}
	},
	moveRow : function(treeNode, targetNode) {
		
	},
	findRowNumToTid : function(rowNum){
		var treeBox = this;
		
		var arr = [];
		var keys = treeBox.dataMap.keys();
		if(keys.length > 0){
			for(var i in keys){
				var key = keys[i];
				arr.push(treeBox.dataMap.get(key));
			}
		}
		
		var tId = "";
		var numFilter = arr.filter(function (e) {
			return e[configData.GRID_ROW_NUM] == rowNum;
		});
		if(numFilter.length > 0){
			tId = numFilter[0]["tId"];
		}
		
		return tId;
	},
	toString : function() {
		return "TreeObj";
	}
}

TreeList = function() {
	this.treeMap = new DataMap();
}

TreeList.prototype = {	
	setTree : function(options) {
		var treeBox = new TreeBox(options.id);
		
		var opts = jQuery.extend(treeBox, options);
		
		treeBox.setTree();
		
		this.treeMap.put(options.id, treeBox);
	},
	treeList : function(options) {
		var listDefaults = new Object({
			id : null,
	    	param : null,
	    	command : null
		});
		
		var opts = jQuery.extend(listDefaults, options);
				
		var treeBox = this.treeMap.get(opts.id);

		if(!opts.command){
			opts.command = treeBox.command;
		}
		
		var sendUrl = treeBox.url;
		if(options.url){
			sendUrl = treeBox.url; 
		}
		
		netUtil.send({
			module : treeBox.module,
			command : opts.command,
			url : sendUrl,
			bindType : "tree",
			bindId : treeBox.id,
			sendType : "list",
			param : opts.param
		});
	},
	viewJsonData : function(treeId, json) {
		var treeBox = this.treeMap.get(treeId);
		treeBox.setData(json.data);
		
		if(commonUtil.checkFn("searchOpen")){
			searchOpen(false);
		}
	},
	addNewRow : function(treeId, isNodeFocus) {
		var treeBox = this.treeMap.get(treeId);
		return treeBox.addNewRow(isNodeFocus);
	},
	removeRow : function(treeId) {
		var treeBox = this.treeMap.get(treeId);
		return treeBox.removeRows();
	},
	openNodeAll : function(treeId) {
		var treeBox = this.treeMap.get(treeId);
		return treeBox.treeObj.expandAll(true);
	},
	closeNodeAll : function(treeId) {
		var treeBox = this.treeMap.get(treeId);
		return treeBox.treeObj.expandAll(false);
	},
	toggleNodeAll : function(treeId,$obj){
		$obj = $($obj);
		if($obj.hasClass("node_open")){
			$obj.removeClass("node_open");
			$obj.find("span").text("전체 node 열기");
			this.closeNodeAll(treeId);
		}else{
			$obj.addClass("node_open");
			$obj.find("span").text("전체 node 닫기");
			this.openNodeAll(treeId);
		}
	},
	getData : function(treeId) {
		var treeBox = this.treeMap.get(treeId);
		return treeBox.getData();
	},
	getModifyData : function(treeId) {
		var treeBox = this.treeMap.get(treeId);
		return treeBox.getModifyData();
	},
	getRowData : function(treeId, rowNum) {
		var treeBox = this.treeMap.get(treeId);
		return treeBox.getRowData(rowNum);
	},
	setColValue : function (treeId, rowNum, colName, colValue){
		var treeBox = this.treeMap.get(treeId);
		var tId = treeBox.findRowNumToTid(rowNum);
		var treeNode = treeBox.treeObj.getNodeByTId(tId);
		
		treeBox.setColValue(treeNode, colName, colValue);
	},
	findRowNumToTid : function(treeId, rowNum){
		var treeBox = this.treeMap.get(treeId);
		return treeBox.findRowNumToTid(rowNum);
	},
	toString : function() {
		return "TreeList";
	}
}

var treeList = new TreeList();