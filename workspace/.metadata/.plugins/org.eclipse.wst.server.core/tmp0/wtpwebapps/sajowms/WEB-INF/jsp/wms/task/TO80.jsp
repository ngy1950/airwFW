<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			editable : true,
			pkcol : "WAREKY",
			module : "WmsTask",
			command : "TO80TAB1"
	    });
		
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			var gridId = "gridList"
				
	 		gridList.gridList({
		    	id : gridId,
		    	param : param
		    });  
		}
	}

	function searchHelpEventOpenBefore(searchCode, gridType, $inputObj){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments); 
		if(searchCode == "SHSKUMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHAREMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHZONMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHLOCMA"){
			return dataBind.paramData("searchArea");
		}else  if(searchCode == "SHCMCDV"){
			var param = new DataMap();
			if($inputObj.name == "S.SKUG01"){
				param.put("CMCDKY", "SKUG01");
			}else{
				param.put("CMCDKY", "LOTA06");
			}
			return param; 
		}else  if(searchCode == "SHDOCTM"){
			var param = new DataMap();
			param.put("DOCCAT", "300");
		
			return param; 
		}
	}
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Execute"){
			test3();
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>

</div>

<!-- searchPop -->
<div class="searchPop" id="searchArea" style="overflow-y:scroll;">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
		</p>
		<div class="searchInBox">
			<h2 class="tit" CL="STD_SELECTOPTIONS">일반정보</h2>
	
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">거점</th>
						<td>
							<input type="text" name="WAREKY" UIInput="S,SHWAHMA" validate="required,MASTER_M0434" value="<%=wareky%>"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_TASOTY">작업타입</th>
						<td>
							<input type="text" name="TASOTY" UIInput="R,SHDOCTM" />
						</td>
					</tr>
					<tr>
						<th CL="STD_TASKKY">작업지시번호</th>
						<td>
							<input type="text" name="TH.TASKKY" UIInput="R" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DOCDAT">문서일자</th>
						<td>
							<input type="text" name="DOCDAT" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_STATDO">문서상태</th>
						<td>
							<input type="text" name="STATDO" UIInput="R" />
						</td>
					</tr>
					
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- //searchPop -->

<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
			<div class="bottomSect type1">
				<div class="tabs"  id="bottomTabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" id="tab01" ><span CL='STD_GENERAL'>탭메뉴1</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										    <col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_TASKKY'>작업문서번호</th>
												<th CL='STD_DOCDAT'>문서일자</th>
												<th CL='STD_TASOTY'>작업타입</th>
												<th CL='STD_TASOTYNM'>작업타입명</th>
												<th CL='STD_STATDO'>문서상태</th>
												<th CL='STD_STATDONM'>문서상태명</th>
												<th CL='STD_QTTAOR'>작업수량</th>
												<th CL='STD_STATUS'>상태</th>
												<th CL='STD_QTCOMP'>완료수량</th>
												<th CL='STD_STATUS'>상태</th>
												<th CL='STD_QTSEND'>전송수량</th>
												<th CL='STD_STATUS'>상태</th>
												<th CL='STD_ESHPKY'>CYS/SM문서번호</th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										    <col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<!-- <col width="150" /> -->
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
													<td GCol="rownum">1</td>
													<td GCol="text,TASKKY"></td>
													<td GCol="text,DOCDAT" GF="D"></td>
													<td GCol="text,TASOTY"></td>
													<td GCol="text,TASOTYNM"></td>
													<td GCol="text,STATDO"></td>
													<td GCol="text,STATDONM"></td>
													<td GCol="text,QTTAOR" GF="N 20,3"></td>
													<td GCol="text,ICSTAT"></td>
													<td GCol="text,QTCOMP"  GF="N 20,3"></td>
													<td GCol="text,ICCOMP"></td> 
													<td GCol="text,QTSEND"  GF="N 20,3"></td>
													<td GCol="text,ICSEND"></td> 
													<td GCol="text,EDOCKY"></td> 
													<!-- <td GCol="text,DRELIN"></td> -->
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