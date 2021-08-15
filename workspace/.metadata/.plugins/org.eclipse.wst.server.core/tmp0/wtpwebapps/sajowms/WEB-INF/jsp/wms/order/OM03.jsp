<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			module : "WmsOrder",
			command : "OM03"
	    });
	});
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHSKUMA"){
			var param = new DataMap();
			param.put("OWNRKY", $('#OWNRKY').val());
			param.put("WAREKY", "<%=wareky%>");
		}
		return param;
	}
	
	function searchList(){
		var param = inputList.setRangeParam("searchArea");
		
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    });
	}
	
	function saveData(){
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		
		if(gridList.validationCheck("gridList", "select")){
			var chkIdx = gridList.getSelectRowNumList("gridList");
			var chkLen = chkIdx.length;			
			if( chkLen == 0 ){
				// 선택된 데이터가 없습니다.
				commonUtil.msgBox("VALID_M0006");
				return;
			} else if (chkLen > 0){
				var list = "";
				
				var list = gridList.getSelectData("gridList");
				var param = new DataMap();
				param.put("list", list); 

				var json = netUtil.sendData({
					url : "/wms/order/json/saveOM03.data",
					param : param
				});  
				
				if(json.data["ERRMSG"]){
					   var msg = json.data["ERRMSG"];
					   commonUtil.msgBox("VALID_M0009",msg);
				}else{
					if(gridList.checkResult(json)){
						commonUtil.msgBox("MASTER_M0999");  //저장 성공
						gridList.resetGrid("gridList");
						
						searchList();
					}
				}
			}
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
	
</script>
</head>
<body>
	<div class="contentHeader">
		<div class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="Save SAVE STD_SAVE"></button>

		</div>
		<div class="util2">
			<button class="button type2" id="showPop" type="button">
				<img src="/common/images/ico_btn4.png" alt="List" />
			</button>
		</div>
	</div>

	<!-- searchPop -->
	<div class="searchPop" id="searchArea">
		<button type="button" class="closer">X</button>
		<div class="searchInnerContainer">
			<p class="util">
				<button CB="Search SEARCH BTN_DISPLAY"></button>
				<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
				<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
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
							<td><input type="text" name="WAREKY" size="8px" value="<%=wareky%>" id="WAREKY" readonly="readonly" /></td>
						</tr>
						<tr>
							<th CL="STD_OWNRKY">화주</th>
							<td>
								<select Combo="WmsOrder,OWNRKYCOMBO" name="OWNRKY" id="OWNRKY">
								</select>
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUKEY">품번코드</th>
							<td><input type="text" name="C.SKUKEY" UIInput="R,SHSKUMA" /></td>
						</tr>
						<tr>
							<th CL="STD_DESC01">품명</th>
							<td>
								<input type="text" name="SM.DESC01" UIInput="R" />
							</td>
						</tr>
						<tr>
							<th CL='STD_COMPQT'>재고비교량</th>
							<td>
								<input type="radio" name="Opt" value="1" checked="checked" /><label CL="STD_ALL" ></label>
								<input type="radio" name="Opt" value="2"  /><label CL="STD_STOCKST"></label>
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

				<div class="bottomSect type1">
					<button type="button" class="button type2 fullSizer">
						<img src="/common/images/ico_full.png" alt="Full Size">
					</button>
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL='STD_SEARCH'>리스트</span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableHeader">
										<table>
											<colgroup>
												<col width="40" />
												<col width="40" />
												
												<col width="80" />
												<col width="100" />
												<col width="80" />
												<col width="100" />
												<col width="100" />
												
												<col width="150" />
												<col width="100" />
												<col width="80" />
												<col width="150" />
												<col width="100" />
												
												<col width="100" />
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
													<th GBtnCheck="true"></th>
													
													<th CL='STD_OWNRKY'></th>
													<th CL='STD_OWNRNM'></th>
													<th CL='STD_WAREKY'></th>
													<th CL='STD_WARENM'>거점명</th>
													<th CL='STD_SKUKEY'></th>
													
													<th CL='STD_DESC01'></th>
													<th CL='STD_DESC02'></th>
													<th CL='STD_AREAKY'></th>
													<th CL='STD_AREANM'>창고명</th>
													<th CL='STD_AREARK'>창고분배순위</th>
													
													<th CL='STD_QTYROP'></th>
													<th CL='STD_QTYMSL'></th>
													<th CL='ORDER_QTYTRN,3'>통합창고 이고예정수량</th>
													<th CL='ORDER_QTYASN'>입고예정수량</th>
													<th CL='ORDER_QTSIWH'>재고수량</th>
													
													<th CL='STD_QTNEED'>필요수량</th>
													<th CL='STD_QTSV05'>통합창고재고수량</th>
													<th CL='STD_QTACUM'>필요수량누적</th>
													<th CL='STD_QTYREP'>보충수량</th>
												</tr>
											</thead>
										</table>
									</div>
									<div class="tableBody">
										<table>
											<colgroup>
												<col width="40" />
												<col width="40" />
												
												<col width="80" />
												<col width="100" />
												<col width="80" />
												<col width="100" />
												<col width="100" />
												
												<col width="150" />
												<col width="100" />
												<col width="80" />
												<col width="150" />
												<col width="100" />
												
												<col width="100" />
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
													<td GCol="rowCheck"></td>
													
													<td GCol="text,OWNRKY"></td>            
													<td GCol="text,OWNRNM"></td>            
													<td GCol="text,WAREKY"></td>            
													<td GCol="text,WARENM"></td>            
													<td GCol="text,SKUKEY"></td>            
													
													<td GCol="text,DESC01"></td>            
													<td GCol="text,DESC02"></td>            
													<td GCol="text,AREAKY"></td>            
													<td GCol="text,AREANM"></td>            
													<td GCol="text,AREARK"></td>            
													
													<td GCol="text,QTYROP" GF="N"></td>  
													<td GCol="text,QTYMSL" GF="N"></td>  
													<td GCol="text,QTYTRN" GF="N"></td>            
													<td GCol="text,QTYASN" GF="N"></td>            
													<td GCol="text,QTSIWH" GF="N"></td>            
													
													<td GCol="text,QTNEED" GF="N"></td>            
													<td GCol="text,QTSV05" GF="N"></td>            
													<td GCol="text,QTACUM" GF="N"></td>            
													<td GCol="input,QTREPL" GF="N"></td>           
												</tr>
											</tbody>
										</table>
									</div>
								</div>
								<div class="tableUtil">
									<div class="leftArea">
										<button type="button" GBtn="find"></button>
										<button type="button" GBtn="sortReset"></button>
										<button type="button" GBtn="copy"></button>
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
	<%@ include file="/common/include/bottom.jsp"%>
</body>
</html>