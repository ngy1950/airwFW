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
			pkcol : "WAREKY,PLOCOV",
			module : "WmsAdmin",
			command : "WAHMA",
			validation : "WAREKY,PLOCOV"
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
		var param = dataBind.paramData("searchArea");
		
		var json = gridList.gridSave({
	    	id : "gridList",
	    	param : param
	    });

		if(json && json.data){
				searchList();
		}		
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHCOMMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
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
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Save SAVE STD_SAVE" CA="Save">
		</button>
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
						<th CL="STD_COMPKY">Company Code</th>
						<td>
							<input type="text" name="COMPKY" value="<%=compky%>"  readonly="readonly" style="width:110px" />  <!-- UIInput="S,SHCOMMA"   -->
						</td>
					</tr>
					<tr>
						<th CL="STD_WAREKY">Center Code</th>
						<td>
							<!-- <input type="text" name="WAREKY" UIInput="R,SHWAHMA"  value="<%=wareky%>"/> -->
							<input type="text" name="WAREKY" UIInput="R,SHWAHMA"  />
						</td>
					</tr>
				    <tr>
				    	<th CL="STD_DELMAK">삭제</th>
						<td>
							<input type="checkbox" name="DELMAK" value="V"/>
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
											<col width="150" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="150" />
											<col width="100" />
											<!--<col width="100" />
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" /> -->
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>번호</th>
												<th CL='STD_WAREKY'></th>
												<th CL='STD_COMPKY'></th>
												<th CL='STD_WNAME01'></th>
												<th CL='STD_WNAME02'></th>
												<th CL='STD_ADDR01'></th>
												<th CL='STD_POSTCD'></th>
												<th CL='STD_NATNKY'></th>
												<th CL='STD_VATREG'></th>
												<th CL='STD_FAXTL1'></th>
												<th CL='STD_TELN01'></th>
												<th CL='STD_WADM01'></th>
												<th CL='STD_WADN01'></th>
												<!-- <th CL='STD_ETC001'></th>
												<th CL='STD_ETC002'></th>
												<th CL='STD_ETC003'></th>
												<th CL='STD_REGN01'></th>
												<th CL='STD_PLOCOV'></th>
												<th CL='STD_TSPKEY'></th>
												<th CL='STD_DELMAK'></th>
												<th CL='STD_CHKSHA,2'></th>
												<th CL='STD_NAME03,2'></th>
												<th CL='STD_ADDR02'></th>
												<th CL='STD_ADDR03'></th>
												<th CL='STD_ADDR04'></th>
												<th CL='STD_ADDR05'></th>
												<th CL='STD_CITY01'></th>
												<th CL='STD_TELN02'></th>
												<th CL='STD_TELN03,2'></th>
												<th CL='STD_FAXTL2'></th>
												<th CL='STD_TAXCD1'></th>
												<th CL='STD_TAXCD2'></th>
												<th CL='STD_POBOX1'></th>
												<th CL='STD_POBPC1'></th>
												<th CL='STD_WADT02'></th>
												<th CL='STD_INDOVA'></th>
												<th CL='STD_DRECLO'></th>
												<th CL='STD_INDUAC'></th>
												<th CL='STD_DSORKY'></th>
												<th CL='STD_CREDAT'></th>
												<th CL='STD_CRETIM'></th>
												<th CL='STD_CREUSR'></th>
												<th CL='STD_CUSRNM'></th>
												<th CL='STD_LMODAT'></th>
												<th CL='STD_LMOTIM'></th>
												<th CL='STD_LMOUSR'></th>
												<th CL='STD_LUSRNM'></th> -->
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
											<col width="150" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="150" />
											<col width="100" />
											<!--<col width="100" />
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" /> -->
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,WAREKY">거점</td>
												<td GCol="text,COMPKY">회사</td>
												<td GCol="input,NAME01" GF="S 180">설명</td>
												<td GCol="input,NAME02" GF="S 180">대표자이름</td>
												<td GCol="input,ADDR01" GF="S 180">대표주소</td>
												<td GCol="input,POSTCD" GF="S 30">우편번호</td>
												<td GCol="select,NATNKY">
													<select CommonCombo="NATNKY"></select>
												</td>
												<td GCol="input,VATREG" GF="S 20">사업자등록번호</td>
												<td GCol="input,FAXTL1" GF="S 20">팩스번호</td>
												<td GCol="input,TELN01" validate="tel(GRID_COL_TELN01_*)" GF="S 20">전화번호</td>
												<td GCol="input,WADM01" validate="email(GRID_COL_WADM01_*)" GF="S 60">e-Mail</td>
												<td GCol="input,WADN01" GF="S 60">관리자명</td>
												<!--<td GCol="input,ETC001" GF="S 60">기타1</td>
												<td GCol="input,ETC002" GF="S 60">기타2</td>
												<td GCol="input,ETC003" GF="S 60">기타3</td>
												<td GCol="input,REGN01" GF="S 12">관할거점</td>
												<td GCol="input,PLOCOV" GF="S 20">기본출하로케이션</td>
												<td GCol="input,TSPKEY" GF="S 10">분할키</td>
												<td GCol="check,DELMAK">삭제</td>
												<td GCol="check,CHKSHA">작업오더완료시출하영역체크</td>
												<td GCol="input,NAME03" GF="S 180">거래처담당자</td>
												<td GCol="input,ADDR02" GF="S 180">납품주소</td>
												<td GCol="input,ADDR03" GF="S 180">주소3</td>
												<td GCol="input,ADDR04" GF="S 180">봉투라벨주소1</td>
												<td GCol="input,ADDR05" GF="S 180">봉투라벨주소2</td>
												<td GCol="input,CITY01" GF="S 180">도시</td>
												<td GCol="input,TELN02" GF="S 20">SMS수신번호</td>
												<td GCol="input,TELN03" validate="tel(GRID_COL_TELN03_*)" GF="S 20">전화번호3</td>
												<td GCol="input,FAXTL2" GF="S 20">영업소레벨</td>
												<td GCol="input,TAXCD1" GF="S 20">색상</td>
												<td GCol="input,TAXCD2" GF="S 20">영업소구분</td>
												<td GCol="input,POBOX1" GF="S 10">P.O.Box1</td>
												<td GCol="input,POBPC1" GF="S 10">POBox우편</td>
												<td GCol="input,WADT01" validate="tel(GRID_COL_WADT01_*)" GF="S 20">전화번호1</td>
												<td GCol="input,WADT02" validate="email(GRID_COL_WADT02_*)" GF="S 20">전화번호2</td>
												<td GCol="check,INDOVA">초과할당 허용</td>
												<td GCol="input,DRECLO" GF="S 20"></td> 
												<td GCol="input,INDUAC" GF="S 1"></td>
												<td GCol="input,DSORKY" GF="S 10"></td>
												<td GCol="text,CREDAT" GF="D"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT" GF="D"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
												<td GCol="text,LMOUSR"></td>
												<td GCol="text,LUSRNM"></td> -->
											</tr>									
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">		
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<!--<button type="button" GBtn="copy"></button>-->
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