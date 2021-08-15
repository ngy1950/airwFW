<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project.common.bean.DataMap,project.common.bean.DataMap,java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>메뉴 아이콘 조회</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/pop_reset.css"/>
<script type="text/javascript">
	var popNm = "YP01_ICON_POP";
	var g_rowNum = -1;
	var g_gridId = "gridList";
	
	$(document).ready(function(){
		window.resizeTo('790','890');
		
		gridList.setGrid({
			id : "gridList",
			dataRequest : false,
			bigdata: false,
			url : "/system/json/selectIconList.data",
			editable : true,
			firstRowFocusType: false
		});
		
		var paramData = page.getLinkPopData();
		g_gridId = paramData.get("gridId");
		g_rowNum = paramData.get("rowNum");
		
		createStyleSheet();
	});
	
	function createStyleSheet(){
		var styleSheet = document.createElement("style");
		styleSheet.setAttribute("type","text/css");
		styleSheet.setAttribute("id","iconStyle");
		document.getElementsByTagName("head")[0].append(styleSheet);
		
		netUtil.send({
			url : "/system/json/selectIconList.data",
			successFunction: "successCreateStyleSheet"
		});
	}
	
	function successCreateStyleSheet(json, status){
		if(json && json.data){
			var data = json.data;
			var dataLen = data.length;
			if(dataLen > 0){
				for(var i = 0; i < dataLen; i++){
					var row = data[i];
					var path = row["PATH"];
					
					var styleSheet = $("#iconStyle");
					var style = "display: inline-block;width: 100%;height: 50px;background: url("+path+") no-repeat center;text-indent:-500em;"
					var styleTag = ".icon"+(i + 1)+"{"+style+"}";
					styleSheet.append(styleTag);
				}
			}
			
			searchList();
		}
	}
	
	//공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){ 
		if(btnName == "Check"){
			closeData();
		}else if(btnName == "Search"){
			this.location.reload();
		}
	}
	
	//헤더 조회
	function searchList(){
		gridList.gridList({
			id : "gridList"
		});
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)   
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			gridList.addSort(gridId,"NAME",true,true);
		}
	}
	
	// 그리드 더블 클릭 이벤트(하단 그리드 조회)
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			
			var param = new DataMap();
			param.put("gridId",g_gridId);
			param.put("rowNum",g_rowNum);
			param.put("popNm",popNm);
			param.put("data",rowData);
			
			page.linkPopClose(param);
		}
	}
	
	function closeData(){
		this.close();
	}
	
	function isNull(sValue) {
		var value = (sValue+"").replace(" ", "");
		
		if( new String(value).valueOf() == "undefined")
			return true;
		if( value == null )
			return true;
		if( value.toString().length == 0 )
			return true;
		
		return false;
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "ICON"){
				return "icon" + (rowNum + 1);	
			}
		}
	}
</script>
<style type="text/css">
 .content_wrap{background: none;}
 #gridList tr td[gcolname=ICON]{background-color: #444;}
</style>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner">
		<div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1">조회</a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="80 STD_ICONIM"  GCol="icon,ICON" GB="icon"></td>
										<td GH="100 STD_ICONNM"  GCol="text,NAME"></td>
										<td GH="100 STD_ICOEXT"  GCol="text,EXT,center"></td>
										<td GH="370 STD_ICOPLS"  GCol="text,PATH"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
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