<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>메뉴 아이콘 조회</title>
<%@ include file="/common/include/popHead.jsp" %>
<style type="text/css">
#gridList tr td[gcolname=ICON]{background-color: #444;}
</style>
<script type="text/javascript">
	var popNm = "UM01POP";
	var g_rowNum = -1;
	var g_gridId = "gridList";
	
	$(document).ready(function(){
		window.resizeTo('790','890');
		
		gridList.setGrid({
			id : "gridList",
			dataRequest : false,
			bigdata: false,
			url : "/wms/system/json/selectUM01IconList.data",
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
			url : "/wms/system/json/selectUM01IconList.data",
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
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Check CHECK BTN_CLOSE">
		</button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect" style="top: 10px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_DISPLAY"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40"       GCol="rownum">1</td>
												<td GH="80 STD_ICONIM"   GCol="icon,ICON" GB="icon"></td>
												<td GH="100 STD_ICONNM"  GCol="text,NAME"></td>
												<td GH="100 STD_ICOEXT"  GCol="text,EXT,center"></td>
												<td GH="370 STD_ICOPLS"   GCol="text,PATH"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>