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
			pkcol : "PTNRKY,PTNRTY",
			module : "WmsAdmin",
			command : "BZPTN",
			bindArea : "tabs1-2",
 			validation : "PTNRKY,PTNRTY",
		    validationType : "C"
	    });
		gridList.setReadOnly('gridList',true, ['DELMAK']);
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
		var param = dataBind.paramData("searchArea");
		var json = gridList.gridSave({
	    	id : "gridList",
	    	param : param
	    });
		
		if(json){
			if(json.data){
				searchList();
			}
		}		
	}
 	
	<%-- function gridListEventRowAddBefore(gridId, rowNum){
		
		var param=new DataMap();
		param.put("WAREKY","<%=wareky%>");
		var json = netUtil.sendData({
			module : "WmsAdmin",
			command : "WAHMA_ADDR05",
			sendType : "map",
			param : param
		});
		
		var newData = new DataMap();
		newData.put("OWNRKY", "<%=ownrky%>");
		newData.put("PTNL05", "<%=ownrky%>");
		
		return newData;
	} --%>
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList" && colName == "PTNRTY"){
			if(colValue != ""){
				var param = new DataMap();
				
				param.put("PTNRTY",colValue);
				var json = netUtil.sendData({
					module : "WmsAdmin",
					command : "PTNRTYval",
					sendType : "map",
					param : param
				});
				 if (json.data["CNT"] < 1) {
					/* alert("업체타입이 정확하지 않습니다.\n다시 입력 해주세요."); */
					commonUtil.msgBox("MASTER_M1005",colValue);
					gridList.setColValue("gridList", rowNum, "PTNRTY", ""); 
				}
			}
		} 
	} 
	
	function gridListEventRowRemove(gridId, rowNum){
		if(gridId == "gridList"){
			var EWGUBN = gridList.getColData(gridId, rowNum, "EWGUBN");
			if(EWGUBN != "W"){
				
				return false;
			}
		}
		return true;
	}
	
	/* function sendSynch2(){
		var list = gridList.getFocusRowNum("gridList");
		var param = new DataMap();
		param.put("list", list);
		
		var json = netUtil.sendData({
			url : "/wms/admin/json/sendSynch2.data",
			param : param
		});
	 } */
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}/* else if(btnName == "Reflect"){
			sendSynch2();
		} */
	}
	 function searchHelpEventOpenBefore(searchCode, gridType){
			if(searchCode == "SHBZPTN"){
				var param = dataBind.paramData("searchArea");
				param.put("OWNRKY", "<%=ownrky%>");
				return param;
			} 
		}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Save SAVE STD_SAVE ">
		</button>
<!-- 		<button CB="Reflect REFLECT BTN_SYNCH"></button> -->
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
					<tr>
							<th CL="STD_WAREKY">거점</th>
							<td><input type="text" name="WAREKY" readonly="readonly"
								value="<%=wareky%>" validation="required,VALID_M0401" /></td>
					</tr>
					<tr>
						<th CL="STD_PTNRTY"></th>
						<td GCol="select,PTNRTY">
							<select Combo="WmsAdmin,BZ01COMBO" name="PTNRTY"></select>
						</td>
					</tr>
					<tr>
						<th CL="STD_PTNRKY">코드</th>
						<td>
							<input type="text" name="PTNRKY" UIInput="R,SHBZPTN" id="PTNRKY"/> 
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_PTNRTY">업체타입</th>
						<td>
							<input type="text" name="PTNRTY" UIInput="R" id="PTNRKY"/> 
						</td>
					</tr> -->
					<tr>
						<th CL="STD_NAME01">이름</th>
						<td>
							<input type="text" name="NAME01" UIInput="R" />
						</td>
					</tr>
					<!-- <tr>
						<th CL="STD_EXPTNK">판매처</th>
						<td>
							<input type="text" id="EXPTNK" name="EXPTNK" UIInput="R" />
						</td>
					</tr> -->
					<!-- <tr>
						<th CL="STD_DELMAK">삭제</th>
						<td>
							<input type="checkbox" id="DELMAK" name="DELMAK" />
						</td>
					</tr> -->
					<tr>
							<th CL="STD_DELMAK,3">삭제여부</th><td>
							<select Combo="WmsAdmin,DELMAKCOMBO" name="DELMAK" id="DELMAK" validate="required">
<!-- 								<option value="">Select</option> -->
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
							<li><a href="#tabs1-2"><span CL='STD_PERSONALINFO'>탭메뉴2</span></a></li>
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
													<th CL='STD_OWNRKY'></th>
													<th CL='STD_PTNRKY'></th>
													<th CL='STD_PTNRTY'></th>
													<th CL='STD_DELMAK'></th>
													<th CL='STD_NAME01'></th>
													<th CL='STD_NAME02'></th>
													<!-- <th CL='STD_NAME03'></th> -->
													<th CL='STD_ADDR01'></th>
													<!-- <th CL='STD_ADDR02'></th>
													<th CL='STD_ADDR03'></th>
													<th CL='STD_ADDR04'></th>
													<th CL='STD_ADDR05'></th> -->
													<th CL='STD_CITY01'></th>
													<!-- <th CL='STD_REGN01'></th> -->
													<th CL='STD_POSTCD'></th>
													<th CL='STD_NATNKY'></th>
													<th CL='STD_TELN01'></th>
													<th CL='STD_TELN02'></th>
													<th CL='STD_TELN03'></th>
													<!-- <th CL='STD_FAXTL1'></th>
													<th CL='STD_FAXTL2'></th> -->
													<th CL='STD_TAXCD1'></th>
												<!-- 	<th CL='STD_TAXCD2'></th>
													<th CL='STD_VATREG'></th>
													<th CL='STD_POBOX1'></th>
													<th CL='STD_POBPC1'></th> -->
													<th CL='STD_EMAIL1'></th>
													<!-- <th CL='STD_EMAIL2'></th>
													<th CL='STD_CTTN01'></th>
													<th CL='STD_CTTT01'></th>
													<th CL='STD_CTTT02'></th>
													<th CL='STD_CTTM01'></th>
													<th CL='STD_SALN01'></th>
													<th CL='STD_SALT01'></th>
													<th CL='STD_SALT02'></th>
													<th CL='STD_SALM01'></th> -->
													<th CL='STD_EXPTNK'></th>
													<!-- <th CL='STD_CUSTMR'></th> -->
													<th CL='STD_PTNG01'></th>
													<th CL='STD_PTNG05'></th>
													<!-- <th CL='STD_PTNG02'></th>
													<th CL='STD_PTNG03'></th>
													<th CL='STD_PTNG04'></th>
													<th CL='STD_PTNG05'></th> -->
													<th CL='STD_PTNL01'></th>
													<th CL='STD_PTNL01NM'></th>
													<th CL='STD_PTNL02'></th>
													<th CL='STD_PTNL03'></th>
												<!-- 	<th CL='STD_PTNL04'></th>
													<th CL='STD_PTNL05'></th>
													<th CL='STD_WTOPPM'></th>
													<th CL='STD_WTOPMU'></th>
													<th CL='STD_WTOPDV'></th> -->
													<th CL='STD_PROCHA'>할당제약 변경</th>
													<th CL='STD_CREDAT'>생성일자</th>
													<th CL='STD_CRETIM'>생성시간</th>
													<th CL='STD_CREUSR'>생성자</th>
													<th CL='STD_LMODAT'>수정일자</th>
													<th CL='STD_LMOTIM'>수정시간</th>
													<th CL='STD_LMOUSR'>수정자</th>
													<!-- <th CL='STD_INDBZL'>수정자</th>
													<th CL='STD_INDARC'>수정자</th>
													<th CL='STD_UPDCHK'>수정자</th> -->
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
													<td GCol="text,OWNRKY" ></td>
													<td GCol="text,PTNRKY" ></td>
													<td GCol="text,PTNRTY" ></td>
													<td GCol="check,DELMAK"></td>
													<td GCol="text,NAME01" ></td>
													<td GCol="text,NAME02" ></td>
													<td GCol="text,ADDR01" ></td>
													<td GCol="text,CITY01" ></td>
													<td GCol="text,POSTCD" ></td>
													<td GCol="text,NATNKY" ></td>
													<td GCol="text,TELN01" ></td>
													<td GCol="text,TELN02" ></td>
													<td GCol="text,TELN03" ></td>
													<td GCol="text,TAXCD1" ></td>
													<td GCol="text,EMAIL1" ></td>
													<td GCol="input,EXPTNK" ></td>
													<td GCol="text,PTNG01" ></td>
													<td GCol="check,PTNG05" ></td>
													<td GCol="text,PTNL01" ></td>
													<td GCol="text,PTNL01NM" ></td>
													<td GCol="text,PTNL02" ></td>
													<td GCol="text,PTNL03" ></td>
													<td GCol="check,PROCHA"></td>
													<td GCol="text,CREDAT" GF="D"></td>
													<td GCol="text,CRETIM" GF="T"></td>
													<td GCol="text,CREUSR" ></td>
													<td GCol="text,LMODAT" GF="D"></td>
													<td GCol="text,LMOTIM" GF="T"></td>
													<td GCol="text,LMOUSR" ></td>
													<!-- <td GCol="input,PTNRTY,SHBZPTN" GF="S 4" validate="required,MASTER_M0901"></td>
													<td GCol="input,PTNRKY" GF="S 20" validate="required"></td>
													<td GCol="input,NAME01" GF="S 180" validate="required,MASTER_M0993"></td> 
													<td GCol="input,NAME02" GF="S 180"></td>
													<td GCol="input,ADDR01" GF="S 200"></td>
													<td GCol="input,POSTCD" GF="S 30"></td>
													<td GCol="input,TELN01" GF="S 50"></td>
													<td GCol="input,VATREG" GF="S 30"></td>
													<td GCol="input,PTNL01" GF="S 90"></td>
													<td GCol="input,PTNL02" GF="S 90"></td>
													<td GCol="input,PTNL03" GF="S 90"></td>
													<td GCol="input,PTNL04" GF="S 90"></td>
													<td GCol="input,PTNL05" GF="S 90"></td>
													<td GCol="check,PROCHA"></td>
													<td GCol="input,PTNG01" GF="S 20"></td>
													<td GCol="input,PTNG02" GF="S 20"></td>
													<td GCol="input,PTNG03" GF="S 20"></td>
													<td GCol="input,PTNG04" GF="S 20"></td>
													<td GCol="input,PTNG05" GF="S 20"></td> -->
												</tr>                 
											</tbody>                 
										</table>
									</div>
								</div>
								<div class="tableUtil">
									<div class="leftArea">		
										<button type="button" GBtn="find"></button>
										<button type="button" GBtn="sortReset"></button>
										<!-- <button type="button" GBtn="copy"></button>
										<button type="button" GBtn="add"></button>
										<button type="button" GBtn="delete"></button>	 -->
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

						<div id="tabs1-2">
							<div class="section type1" style="overflow-y:scroll;">
								<div class="controlBtns type2"  GNBtn="gridList">
									<a href="#"><img src="/common/images/btn_first.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_prev.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_next.png" alt="" /></a>
									<a href="#"><img src="/common/images/btn_last.png" alt="" /></a>
								</div>
								<br/>
								<div class="searchInBox">
								<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
									<table class="table type1">
										<colgroup>
											<col width="6%"/>
											<col width="15%"/>
											<col width="6%"/>
										</colgroup>
										<tbody>
											<tr>
											<th CL='STD_PTNRKY'>업체코드</th>
											<td>
												<input type="text" name="PTNRKY" readonly="readonly"/>
											</td>
											<th CL='STD_PTNRTY'>업체타입</th>
											<td GCol="select,PTNRTY">
												<select CommonCombo="PTNRTY" name="PTNRTY" disabled="disabled"></select>
											</td>
										</tr>
										<tr>
											<th CL='STD_PTNL3'>업태</th>
											<td>
												<input type="text" name="PTNL03" readonly="readonly"/>
											</td>
											<th CL='STD_PTNL4'>업종</th>
											<td>
												<input type="text" name="PTNL04" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_VATREG'>사업자등록번호</th>
											<td>
												<input type="text" name="VATREGS" readonly="readonly"/>
											</td>
											<th  CL='STD_DELMAK'>삭제</th>
											<td>
												<input type="checkbox" name="DELMAK">
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							
							<div class="searchInBox">
								<table class="table type1">
									<colgroup>
										<col width="100" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL='STD_NAME01'>이름</th>
											<td>
												<input type="text" size="70" name="NAME01" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_NAME02'>대표자이름</th>
											<td>
												<input type="text" size="70" name="NAME02" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_ADDR01'>주소</th>
											<td>
												<input type="text" size="70" name="ADDR01" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_POSTCD'>우편번호</th>
											<td>
												<input type="text" name="POSTCD" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_TELN01'>전화번호</th>
											<td>
												<input type="text" name="TELN01" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<th CL='STD_PROCHA'>발주불가</th>
											<td>
												<input type="checkbox" name="PROCHA" disabled="disabled"/>
											</td>
										</tr>
										</tbody>
									</table>
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