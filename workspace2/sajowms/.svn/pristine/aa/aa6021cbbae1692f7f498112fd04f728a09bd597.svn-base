<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<%@ include file="/common/include/webdek/tree.jsp" %>
<script type="text/javascript">
	var g_treeId = "treeList";
	$(document).ready(function(){
		$("#tab1-1 ul").attr("id",g_treeId);
		
		treeList.setTree({
	    	id       : g_treeId,
	    	module   : "Common",
			command  : "MENU_TREE",
			bindArea : "detail",
			pkCol    : "MENUID",
		    pidCol   : "AMNUID",
		    nameCol  : "MENUNAME",
		    sortCol  : "SORTORDER"
	    });
		
		$("#tab1-1 .btn_wrap .fl_r button").each(function(){
			var i = $(this).index();
			switch (i) {
			case 0:
				$(this).attr("onclick","treeList.toggleNodeAll('"+g_treeId+"',this);");
				break;
			case 1:
				$(this).attr("onclick","treeList.addNewRow('"+g_treeId+"');");
				break;
			case 2:
				$(this).attr("onclick","treeList.removeRow('"+g_treeId+"');");
				break;	
			default:
				break;
			}
			
		});
	});

	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			treeList.treeList({
				id : g_treeId,
		    	param : param
			});
		}
	}
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){
			gridList.gridSave({
		    	id : "gridList",
		    	modifyType : "A"
		    });
		}
	}

	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}
	
	function treeListEventDataBindEnd(gridId, dataLength){
		
	}
	
	function treeGridAddRowEventBefore(treeId, parentNode, newNode){
		if(treeId == g_treeId){
			var param = new DataMap();
			param.put("MENUGID","<%=compky%>");
			param.put("MENUID","");
			param.put("AMNUID","");
			param.put("LBLTXL","");
			param.put("MENUNAME","");
			param.put("URI","");
			param.put("PARAM","");
			param.put("MENUTYPE","P");
			
			return param;
		}
	}
	
	function treeGridAddRowEventAfter(treeId, parentNode, newNode){
		if(treeId == g_treeId){
			var param = new DataMap();
			if(parentNode != undefined && parentNode != null){
				if(parentNode.children.length > 0){
					var rowNum = parentNode[configData.GRID_ROW_NUM];
					treeList.setColValue(treeId, rowNum, "MENUTYPE", "F");
				}
			}
			return param;
		}
	}
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp"%>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner contentH_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<input type="hidden" name="COMPID"  value="<%=compky%>"/>
			<input type="hidden" name="MENUGID" value="WDSCM"/>
			<div class="btn_wrap">
				<div class="fl_l">
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="Search"></dt>
						<dd>
							<input type="text" class="input" name="Search" UIInput="S,SHAREMA" IAname="Search" UIFormat="U"/>
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
		<div class="content-horizontal-wrap h-wrap-min" style="height: calc(100% - 90px);">
			<div class="content_layout tabs content_left" style="height:100%">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul> 
				<div class="table_box section" id="tab1-1" style="height: calc(100% - 87px);overflow: auto;">
					<div class="btn_wrap">
						<div class="fl_r">
							<button class="btn_basic"><span>전체 node 열기</span></button>
							<!-- <button class="btn_basic basic_add_new"><span>추가</span></button>
							<button class="btn_basic basic_del"><span>삭제</span></button> -->
						</div>
					</div>
					<ul style="width:260px; overflow:auto;"></ul>
				</div>
			</div>
			
			<div class="handlerH_wrap">
				<div class="handlerH"></div>
			</div>
			
			<div class="content_layout tabs content_right" style="margin-top:0px;height:100%">
				<ul class="tab tab_style02">
					<li><a href="#tab2-1"><span>상세</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab2-1">
					<div class="inner_search_wrap">
						<table class="detail_table" id="detail">
							<colgroup>
	                            <col width="20%" />
	                            <col width="80%"/>
	                        </colgroup>
	                        <tbody>         
	                            <tr>
	                                <th CL="STD_MENUTYPE"></th>
	                                <td>
	                                    <input type="text" class="input" name="MENUTYPE" style="width: 100%;height: 100%;border: 0;margin: 0;"/>
	                                </td>
	                            </tr>   
	                            <tr>
	                                <th CL="STD_AMNUID"></th>
	                                <td>
	                                    <input type="text" class="input" name="AMNUID" style="width: 100%;height: 100%;border: 0;margin: 0;"/>
	                                </td>
	                            </tr>   
	                            <tr>
	                                <th CL="STD_MENUID"></th>
	                                <td>
	                                    <input type="text" class="input" name="MENUID" style="width: 100%;height: 100%;border: 0;margin: 0;"/>
	                                </td>
	                            </tr>   
	                            <tr>
	                                <th CL="STD_MENUNAME"></th>
	                                <td>
	                                    <input type="text" class="input" name="MENUNAME" style="width: 100%;height: 100%;border: 0;margin: 0;"/>
	                                </td>
	                            </tr>   
	                            <tr>
	                                <th CL="STD_URI"></th>
	                                <td>
	                                    <input type="text" class="input" name="URI" style="width: 100%;height: 100%;border: 0;margin: 0;"/>
	                                </td>
	                            </tr>   
	                            <tr>
	                                <th CL="STD_SORTORDER"></th>
	                                <td>
	                                    <input type="text" class="input" name="SORTORDER" UIFormat="NS 20,0" style="width: 100%;height: 100%;border: 0;margin: 0;"/>
	                                </td>
	                            </tr>   
	                        </tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>