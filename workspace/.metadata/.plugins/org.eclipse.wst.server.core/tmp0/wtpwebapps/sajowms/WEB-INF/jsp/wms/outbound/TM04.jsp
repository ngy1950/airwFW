<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	var dblIdx = -1;
	
	$(document).ready(function(){
		setTopSize(250);
		gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "VBELN",
			module : "WmsOutbound",
			command : "TM04HEAD"
	    });
		
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "VBELN",
			module : "WmsOutbound",
			command : "TM04BODY"
	    });
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}

		gridList.setReadOnly("gridHeadList", true);
		gridList.setReadOnly("gridList", true);
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){
			searchSubList(0);
		}
	}
	
	function searchSubList(headRowNum){
		var rowVal = gridList.getColData("gridHeadList", headRowNum,"VBELN");
		
		var param = inputList.setRangeParam("searchArea");
			param.put("VBELN", rowVal);		
		
			gridList.gridList({
			id : "gridList",
			param : param
		});

		dblIdx = headRowNum;
	}
	
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			searchSubList(rowNum);
		}
	}
	
	function saveDelete(){
		if(gridList.validationCheck("gridHeadList", "all")){
			var chkRowCnt = gridList.getSelectRowNumList("gridHeadList").length;
			var chkRowIdx = gridList.getSelectRowNumList("gridHeadList");
			
			if(chkRowCnt < 1){
				commonUtil.msgBox("TASK_M0003");
				return false;
			}
			
			if(commonUtil.msgConfirm(configData.MSG_MASTER_DELETE_CONFIRM)){
				
				var head = gridList.getSelectData("gridHeadList");
				var param = new DataMap();
					param.put("head", head);
				
				var json = netUtil.sendData({
					url : "/wms/outbound/json/TM04Delete.data",
					param : param
				});
			
				if(json && json.data){
					gridList.resetGrid("gridHeadList");
					gridList.resetGrid("gridList");
					searchList();
				}
			}
		}
	}
	
	function gridListEventRowFocus(id, rowNum){
		
		if(id == "gridHeadList"){
			gridList.resetGrid("gridList");
			dblIdx = -1;
		}
	}
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		if(searchCode == "SHAREMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}
	}

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Delete"){
			saveDelete();
		}
	}
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Delete DELETE BTN_DELETE">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop">
	<button type="button" class="closer">X</button>
<div class="searchInnerContainer" id="searchArea">
		<!-- <p class="searchBtn"><input type="submit" class="button type1 widthAuto" value="검색" onclick="searchList()" CL="BTN_DISPLAY" /></p> -->
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
		</p>

		<div class="searchInBox">
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">거점</th>
						<td>
							<input type="text" name="WAREKY" UIInput="S,SHWAHMA" value="<%=wareky%>" />
						</td>
					</tr>
					<tr>
						<th CL="STD_WADAT">출고요청일</th>
						<td>
							<input type="text" name="WADAT" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_VBELN">ECMS 주문Item</th>
						<td>
							<input type="text" name="VBELN" UIInput="R" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>

<!-- //searchPop -->

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect top">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span>리스트</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="20" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th GBtnCheck="true"></th>
												<th CL='STD_VBELN'></th>
												<th CL='STD_BWART'></th>
												<th CL='STD_WADAT'></th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_WARETG'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="20" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												<td GCol="text,VBELN"></td>
												<td GCol="select,BWART">
													<select Combo="WmsOutbound,TMDOCCOMBO">
													</select>
												</td>
												<td GCol="text,WADAT"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WARETG"></td>
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
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea">
						<li><a href="#tabs1-1"><span>ITEM 리스트</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_ORDRNM'></th>
												<th CL='STD_ORDRIT'></th>
												<th CL='STD_SKUKEY'></th>
												<th CL='STD_DESC01'></th>
												<th CL='STD_LFIMG'></th>
												<th CL='STD_UOMKEY'></th>
												<th CL='STD_LOTA05'></th>
												<th CL='STD_LOTA02'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,VBELN"></td>
												<td GCol="text,POSNR"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,LFIMG"></td>
												<td GCol="text,MEINS"></td>
												<td GCol="select,C00104">
													<select Combo="WmsOutbound,LOTA05COMBO">
													</select>
												</td>
												<td GCol="select,C00105">
													<select Combo="WmsOutbound,LOTA02COMBO">
													</select>
												</td>
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
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
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
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>