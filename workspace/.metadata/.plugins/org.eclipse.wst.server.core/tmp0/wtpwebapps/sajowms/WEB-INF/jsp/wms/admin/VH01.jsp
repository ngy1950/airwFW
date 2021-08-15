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
			pkcol : "VEHIID",
			module : "WmsAdmin",
			command : "VH01"
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
		var modCnt = gridList.getModifyRowCount("gridList");
		
		if(modCnt == 0){
			commonUtil.msgBox("MASTER_M0545");
			return;
		}
		
		if(gridList.validationCheck("gridList", "modify")){
			var param = dataBind.paramData("searchArea");
			
			var json = gridList.gridSave({
		    	id : "gridList",
		    	param : param
		    });
			
			if(json && json.data){
				searchList();
			}	
		}
	}
	
	function commonBtnClick(btnName){
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
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_VEHIID"></th>
						<td>
							<input type="text" name="VEHIID" UIInput="R,SHVEHIID" />
						</td>
					</tr>
					<tr>
						<th CL="STD_VEHINO"></th>
						<td>
							<input type="text" name="VEHINO"  UIInput="R,SHVEHINO" />
						</td>
					</tr>
					<tr>
						<th CL="STD_VEHINM"></th>
						<td>
							<input type="text" name="VEHINM"  UIInput="R,SHVEHINM" />
						</td>
					</tr>
					<tr>
						<th CL="STD_VEHIOW"></th>
						<td>
							<select CommonCombo="VEHIOW" name="VEHIOW">
								<option value="">Select</option>
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_VEHITY"></th>
						<td>
							<select CommonCombo="VEHITY" name="VEHITY">
								<option value="">Select</option>
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_VEHIWG"></th>
						<td>
							<select CommonCombo="VEHIWG" name="VEHIWG">
								<option value="">Select</option>
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_DRIVER"></th>
						<td>
							<input type="text" name="DRIVER" UIInput="R,SHDRIVER" />
						</td>
					</tr>
					<tr>
						<th CL="STD_TELN01"></th>
						<td>
							<input type="text" name="TELN01" UIInput="R,SHTELN01" />
						</td>
					</tr>
					<tr>
						<th CL="STD_VEHSTS"></th>
						<td>
							<select CommonCombo="VEHSTS" name="VEHSTS">
								<option value="">Select</option>
							</select>
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
						<li><a href="#tabs1-1"><span CL='STD_SEARCH'>탭메뉴1</span></a></li>
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
												<th CL='STD_VEHIID'></th>
												<th CL='STD_VEHINO'></th>
												<th CL='STD_VEHINM'></th>
												<th CL='STD_VEHIOW'></th>
												<th CL='STD_VEHITY'></th>
												<th CL='STD_VEHIWG'></th>
												<th CL='STD_DRIVER'></th>
												<th CL='STD_TELN01'></th>
												<th CL='STD_VEHSTS'></th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
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
												<td GCol="input,VEHIID" GF="S 20" validate="required"></td>
												<td GCol="input,VEHINO" GF="S 40"></td>
												<td GCol="input,VEHINM" GF="S 180"></td>
												<td GCol="select,VEHIOW">
													<select CommonCombo="VEHIOW"></select>
												</td>
												<td GCol="select,VEHITY">
													<select CommonCombo="VEHITY"></select>
												</td>
												<td GCol="select,VEHIWG">
													<select CommonCombo="VEHIWG"></select>
												</td>
												<td GCol="input,DRIVER" GF="S 60"></td>
												<td GCol="input,TELN01" GF="S 60"></td>
												<td GCol="select,VEHSTS">
													<select CommonCombo="VEHSTS"></select>
												</td>
												<td GCol="text,CREDAT" GF="D"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT" GF="D"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
												<td GCol="text,LMOUSR"></td>
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
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="delete"></button>
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
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>