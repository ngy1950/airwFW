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
			module : "WmsReport",
			command : "RL00"
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
			
		}
	}

	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}
	}
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		 if(searchCode == "SHWAHMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode=="SHAREMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode=="SHZONMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode=="SHLOCMA"){
			return dataBind.paramData("searchArea");
		}else if(searchCode=="SHSKUMA"){
			return dataBind.paramData("searchArea");
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
<div class="searchPop" id="searchArea"style="overflow-y:scroll;">
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
					<th CL="STD_WAREKY">거점</th>
					<td>
						<input type="text" name="WAREKY" UIInput="S,SHWAHMA" validate="required,MASTER_M0434" value="<%=wareky%>"/>
					</td>
				</tr>
				<tr>
					<th CL="STD_AREAKY">창고</th>
					<td>
						<input type="text" name="AREAKY" UIInput="R,SHAREMA" />
					</td>
				</tr>
				<tr>
					<th CL="STD_ZONEKY">구역</th>
					<td>
						<input type="text" name="ZONEKY" UIInput="R,SHZONMA" />
					</td>
				</tr>
				<tr>
					<th CL="STD_LOCAKY">지번</th>
					<td>
						<input type="text" name="LOCAKY" UIInput="R,SHLOCMA"/>
					</td>
				</tr>
				<tr>
					<th CL="STD_DOCDAT">문서일자</th>
					<td>
						<input type="text" name="DOCDAT" UIInput="R" UIFormat="C"  />
					</td>
				</tr>
				<tr>
					<th CL="STD_SKUKEY">품번코드</th>
					<td>
						<input type="text" name="SKUKEY"  UIInput="R,SHSKUMA"/>
					</td>
				</tr>
				<tr>
					<th CL="STD_DESC01">품명</th>
					<td>
						<input type="text" name="DESC01" UIInput="R" />
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

			<div class="bottomSect type1 ">
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
												<th CL='STD_NUMBER'></th>
												<th CL='STD_WAREKY'>거점</th>
												<th CL='STD_AREAKY'>영역</th>
												<th CL='STD_ZONEKY'>구역</th>
												<th CL='STD_LOCAKY'>지번</th>
												<th CL='STD_SKUKEY'>품번코드</th>
										        <th CL='STD_DESC01'>품명</th>
										        <th CL='STD_DOCDAT'>문서일자</th>
												<th CL='STD_QTSIWH'>재고수량</th>
												<th CL='STD_USEQTY'>가용수량</th>
												<th CL='STD_QTSALO'>할당수량</th>
												<th CL='STD_QTSPMO'>이동중</th>
												<th CL='STD_QTSBLK'>보류수량</th>
												<th CL='STD_QTYRCV'>입고수량</th>
												<th CL='STD_QTYMVI'>입고이동수량</th>
												<th CL='STD_QTYMVO'>출고이동수량</th>
												<th CL='STD_QTYSHP'>출고수량</th>
												<th CL='STD_QTYADJ'>조정수량</th>
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
								                <td GCol="rownum"></td>
								                <td GCol="text,WAREKY"></td>
												<td GCol="text,AREAKY"></td>
												<td GCol="text,ZONEKY"></td>
												<td GCol="text,LOCAKY"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DOCDAT"></td>
												<td GCol="text,QTSIWH" GF="N"></td>
												<td GCol="text,QTABLE" GF="N"></td>
												<td GCol="text,QTSALO" GF="N"></td>
												<td GCol="text,QTSPMO" GF="N"></td>
												<td GCol="text,QTSBLK" GF="N"></td>
												<td GCol="text,QTYRCV" GF="N"></td>
												<td GCol="text,QTYMVI" GF="N"></td>
												<td GCol="text,QTYMVO" GF="N"></td>
												<td GCol="text,QTYSHP" GF="N"></td>
												<td GCol="text,QTYADJ" GF="N"></td>
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