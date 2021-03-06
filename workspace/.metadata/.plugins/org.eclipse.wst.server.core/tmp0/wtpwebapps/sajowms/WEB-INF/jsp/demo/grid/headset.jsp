<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Demo",
			command : "DEMOITEM",
			bindArea : "tabs1-2",
			colNameIndex : "rownum,WAREKY,AREAKY,ZONEKY,LOCAKY"
	    });
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){
			var json = gridList.gridSave({
		    	id : "gridList"
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
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE STD_SAVE"></button>
	</div>
	<div class="util3">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
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
			<h2 class="tit" CL="STD_SELECTOPTIONS"></h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY"></th>
						<td>
							<input type="text" id="WAREKY" name="WAREKY" UIInput="S,SHAREMA" IAname="WAREKY"/>
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
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_ITEMLST'>Item?????????</span></a></li>
						<li><a href="#tabs1-2"><span CL='STD_ITEMDET'>Item??????</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>??????</th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_AREAKY'></th>
												<th CL='STD_ZONEKY'></th>
												<th CL='STD_LOCAKY'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
											<col width="80" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td  GCol="rownum" rowspan="2"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="input,ZONEKY,SHZONMA" GF="S 10"></td> 
												<td GCol="input,LOCAKY" validate="required,HHT_T0032" GF="S 20"></td>
											</tr>
											<tr CGRow="true">
												<td GCol="check,MIXLOT"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
											</tr>									
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="copy"></button>
									<button type="button" GBtn="delete"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">0 Record</p>
								</div>
							</div>
						</div>
					</div>
					<div id="tabs1-2">
						<div class="section type1" style="overflow-y:scroll;">
							<div class="controlBtns type2"  GNBtn="gridList">
								<a href="#"><img src="/common/images/btn_first.png" alt="" /></a>
								<a href="#"><img src="/common/images/btn_prev.png" alt="" /></a>
								<a href="#"><img src="/common/images/btn_next.png" alt="" /></a>
								<a href="#"><img src="/common/images/btn_last.png" alt="" /></a>
							</div>
							<div class="searchInBox">
								<table class="table type1">
									<colgroup>
										<col width="8%"/>
										<col width="15%"/>
										<col width="2%"/>
										<col width="15%"/>
										<col width="2%"/>
									</colgroup>
									<tbody>
										<tr>
											<th CL='STD_WAREKY'>??????</th>
											<td>
												<input type="text" name="WAREKY" readonly="readonly"/>
											</td>
											<th CL='STD_LOCAKY'>??????</th>
											<td>
												<input type="text" name="LOCAKY" readonly="readonly"/>
											</td>
											<th CL='STD_STATUS'>??????</th>
											<td GCol="select,STATUS">
												<select CommonCombo="STATUS" name="STATUS"></select>
											</td>
										</tr>
										<tr>
											<th CL='STD_LOCATY'>??????????????????</th>
											<td GCol="select,LOCATY">
												<select CommonCombo="LOCATY" name="LOCATY"></select>
											</td>
											<th CL='STD_AREAKY'>??????</th>
											<td>
												<input type="text" name="AREAKY" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_ZONEKY'>??????</th>
											<td>
												<input type="text" name="ZONEKY"/>
											</td>
											<th CL='STD_TKZONE'>????????????</th>
											<td>
												<input type="text" name='TKZONE'/>
											</td>
										</tr>
										<tr>
											<th CL='STD_INDCPC'>Capa??????</th>
											<td>
												<input type="checkbox" name='INDCPC' value="V"/>
											</td>
											<th CL='STD_MAXCPC'>??????Capa.</th>
											<td>
												<input type="text" name='MAXCPC'/>
											</td>
										</tr>
										<tr>
											<th CL='STD_INDUPA'>????????????</th>
											<td>
												<input type="checkbox" name='INDUPA' value="V"/>
											</td>
											<th CL='STD_INDUPK'>????????????</th>
											<td>
												<input type="checkbox" name='INDUPK' value="V"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_LENWIDHGT,2'>??????*??????*??????</th>
											<td colspan="3">
												<input type="text" name="LENGTH"/> *
												<input type="text" name="WIDTHW"/> *
												<input type="text" name="HEIGHT"/> *
												<input type="text" name="CUBICM"/>
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
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>