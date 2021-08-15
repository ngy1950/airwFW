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
		setTopSize(250);
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			pkcol : "DOCUTY",
			module : "WmsAdmin",
			command : "DT01",
			validation : "NUMOBJ,SYSLOC" 
	    });
	});
	
	function searchList(){
		//var param = dataBind.paramData("searchArea");
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });

			netUtil.send({
				module : "WmsAdmin",
				command : "DT01TOP",
				bindId : "DT01top",
				sendType : "map",
				bindType : "field",
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
			
			//alert(json);
			if(json && json.data){
				searchList();
			}	
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var insinc = gridList.getColData("gridList", 0, "INSINC");
		var trnhty = gridList.getColData("gridList", 0, "TRNHTY");
		var itninc = gridList.getColData("gridList", 0, "ITNINC");
		
		var param = inputList.setRangeParam("searchArea");
		
		/* var doccat = inputList.getComboData("DOCCAT"); */
		
		var newData = new DataMap();
		
		/* newData.put("DOCCAT", doccat); */
		newData.put("INSINC", insinc);
		newData.put("TRNHTY", trnhty);
		newData.put("ITNINC", itninc);
		
		return newData;
	}
	
	function docutyCheck(valueTxt, $colObj){
		var rowNum = gridList.getColObjRowNum("gridList", $colObj);
		var rowCount = gridList.getGridDataCount("gridList");
		for(var i = 0 ; i < rowCount ; i ++){
			if(i != rowNum){
				var docuty = gridList.getColData("gridList", i, "DOCUTY");
				
				if(docuty == valueTxt){
					return false;
				}
			}			
		}
		return true;
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
		<button CB="Save SAVE STD_SAVE">
		</button>
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
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<!-- <tr>
						<th CL="STD_DOCCAT">문서유형</th>
						<td>
							<input type="text" name="DOCCAT" validate="required,VALID_M0414" />
						</td>
					</tr> -->
					<tr>
						<th CL="STD_DOCCAT">문서유형</th>
							<td GCol="select,DOCCAT">
								<select Combo="WmsAdmin,DOCCATCOMBO" name="DOCCAT">
								    <option value=""></option>
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
			<div class="foldSect">
				<div class="tabs">
				  <ul class="tab type2">
					<li><a href="#tabs-1"><span CL='STD_GENERAL'></span></a></li>
				  </ul>
				  <div id="tabs1-1">
					<div class="section type1">
						<table class="table type1" id="DT01top">
							<colgroup>
								<col />
							</colgroup>
							<tbody>
								<th CL="STD_DOCCAT">문서유형</th>
								<td>
									<input type="text" name="DOCCAT" readonly="readonly"/>
								</td>
							</tbody>
						</table>
					</div>
				  </div>
				</div>
			</div>
			<div class="bottomSect">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" CL='STD_LIST'><span>리스트</span></a></li>
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
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_DOCCAT'></th>   <!-- 문서유형 -->
												<th CL='STD_DOCUTY'></th>   <!-- 문서타입 -->
												<th CL='STD_SHORTX'></th>   <!-- 설명 -->
												<th CL='STD_NUMOBJ'></th>   <!-- 채번 오브젝트 -->
												<th CL='STD_ITNINC'></th>   <!-- Item 번호 증가 -->
												<th CL='STD_INSINC'></th>   <!-- Item참조 번호 증분 -->
												<th CL='STD_TRNHTY'></th>   <!-- 물동타입 -->
												<th CL='STD_SKUVND'></th>   <!-- 제품벤더 -->
												<th CL='STD_SYSLOC'></th>   <!-- SYSLOC -->
												<th CL='STD_CREDAT'></th>   <!-- 통신유형 -->
												<th CL='STD_CRETIM'></th>   <!-- 생성일자 -->
												<th CL='STD_CREUSR'></th>   <!-- 생성시간 -->
												<th CL='STD_CUSRNM'></th>   <!-- 생성자 -->
												<th CL='STD_LMODAT'></th>   <!-- 수정일자 -->
												<th CL='STD_LMOTIM'></th>   <!-- 수정시간 -->
												<th CL='STD_LMOUSR'></th>   <!-- 수정자 -->
												<th CL='STD_LUSRNM'></th>   <!-- 수정 체크 -->
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
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>                             
												<!-- <td GCol="text,DOCCAT" GF="S 4"></td> -->
												<td GCol="select,DOCCAT" validate="required,VALID_M0402">
													<select Combo="WmsAdmin,DOCCATCOMBO">
													</select>
												</td>
												<td GCol="input,DOCUTY" validate="required,VALID_M0415" GF="S 4" ></td>
												<td GCol="input,SHORTX" GF="S 180"></td>
												<td GCol="input,NUMOBJ" validate="required,MASTER_M0072" GF="S 10"></td>
												<td GCol="text,ITNINC" GF="S 6"></td>
												<td GCol="text,INSINC" GF="S 4"></td>
												<td GCol="text,TRNHTY" GF="S 4"></td>
												<td GCol="check,SKUVND"></td>
												<td GCol="input,SYSLOC" GF="S 20"></td>
												<td GCol="text,CREDAT" GF="D"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT" GF="D"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
												<td GCol="text,LMOUSR"></td>
												<td GCol="text,LUSRNM"></td>
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
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>