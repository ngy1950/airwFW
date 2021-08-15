<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			pkcol : "FWDKEY",
			module : "TmsAdmin",
			command : "SHCPN",
			validation : "FWDKEY,WADN01"
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
	    	param : param,
	    });
		
		if(json && json.data){
			searchList();
		}			
	}

	function printList(){
		var url = "";
		var recvky ;
		
		var list = gridList.getSelectRowNumList("gridList");

		if(list.length < 1){
			commonUtil.msgBox("VALID_M0006");
			return;
		}

 		var where =   "AND RECVKY IN (" ;
		for(var i=0 ; i<list.length ; i++){
			recvky = gridList.getColData("gridList", list[i], "RECVKY");
			if(i>0){
				where += ", "
			}
			where += "'" + recvky +"'";
		}
		where += ")";
 
 
        var where =   " "; 
		//url = "/ezgen/receiving_list.ezg";
		url = "/ezgen/tms/TPM01.ezg";
		
		var map = new DataMap();
		WriteEZgenElement(url, where, "", '<%= langky%>', map, 900, 650);	
		
	}
		

 	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Create"){
			creatList();
		}else if(btnName == "Print"){
			printList();
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE STD_SAVE"></button>
		<button CB="Print PRINT BTN_PRINT3"></button>
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
						<th CL="STD_COMPKY">사업장</th>
						<td>
							<input type="text" name="COMPKY" value="100"  readonly="readonly" style="width:110px" />  <!-- UIInput="S,SHCOMMA"   -->
						</td>
					</tr>
					 <tr>
						<th CL="STD_DLVDAT">운송일자</th>
						<td>
							<input type="text" name="DLVDAT" UIInput="R" UIFormat="C Y" />
						</td>
					</tr>
					 <tr>
						<th CL="STD_VKBUR">영업팀</th>
						<td>
							<input type="text" name="VKBUR" UIInput="R,VKBUR" />
						</td>
					</tr>
					 <tr>
						<th CL="STD_SPG001">SPG</th>
						<td>
							<input type="text" name="SPG001" UIInput="R,SPG001" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SHPTKY">출하지점</th>
						<td>
							<input type="text" name="SHPTKY" UIInput="R,SHPTKY" />
						</td>
					</tr>
					<tr>
						<th CL="STD_VHCTYP">차량유형</th>
						<td>
							<input type="text" name="SFRGR" UIInput="R,SHCMCDV" />
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
											<col width="50" />
											<col width="130" />
											<col width="130" />
											<col width="130" />
											<col width="130" />
											<col width="130" />
											<col width="130" />
										</colgroup>
										<thead>
											<tr>
												<th  CL='STD_NUMBER'></th>
												<th  CL='STD_VKBUTX'>제품군</th>
												<th  CL='STD_VKBUTXNM'>제품군내역</th>												
												<th  CL='STD_VKBUR'>영업팀</th>
												<th  CL='STD_TOTDNCNT'>총배차수</th>
												<th  CL='STD_URGNTDNCNT'>긴급배차수</th>
												<th  CL='STD_URGNTDNRT'>긴급배차율</th>
												<th  CL='STD_DOCTXT'>비고</th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="50" />
											<col width="130" />
											<col width="130" />
											<col width="130" />
											<col width="130" />
											<col width="130" />
											<col width="130" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,VKBUTX"></td>
												<td GCol="text,VKBUTXNM"></td>
												<td GCol="text,VKBUR"></td>
												<td GCol="text,TOTDNCNT"></td>
												<td GCol="text,URGNTDNCNT"></td>
												<td GCol="text,URGNTDNRT"></td>
												<td GCol="text,DOCTXT"></td>																									
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