<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
    
	$(document).ready(function() {
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInventory",
			command : "SD03_1",
            autoCopyRowType : false
		});
		
		gridList.setGrid({
            id : "gridList2",
            editable : true,
            module : "WmsInventory",
            command : "SD03_2",
            autoCopyRowType : false
        });
		
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
	}

	//헤더 조회 
	function searchList() {
		
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put("SES_LANGUAGE","KR");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			gridList.gridList({
                id : "gridList2",
                param : param
            });
		}
	}
	
	//그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
	function gridExcelDownloadEventBefore(gridId){
		var param = inputList.setRangeParam("searchArea");
		
		return param;
	}
	
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, gridType,$inputObj){
	
	}
	
</script>
</head>
<body>
	<div class="contentHeader">
		<div class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
		</div>
		<div class="util2">
			<button class="button type2" id="showPop" type="button">
				<img src="/common/images/ico_btn4.png" alt="List" />
			</button>
		</div>
	</div>
	<!-- searchPop -->
	<div class="searchPop">
		<button type="button" class="closer">X</button>
		<div class="searchInnerContainer">
		
			<p class="util">
				<button CB="Search SEARCH BTN_DISPLAY"></button>
				<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
				<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
			</p>
			
			<div class="searchInBox"  id="searchArea">
				<h2 class="tit" CL="STD_SELECTOPTIONS"></h2>
				<table class="table type1">
					<colgroup>
						<col width="100" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_WAREKY1"></th>
							<td>
								<input type="text" name="WAREKY" readonly="readonly" UISave="false" value="<%=wareky%>" style="width:110px"  />
							</td>
						</tr>
						<tr>
							<th CL="STD_BOMMKY1"></th>
							<td>
								<input type="text" name="BH.BOMMKY" UIInput="R,SHBOMMKY" UIFormat="U"/>
							</td>
						</tr>
						<tr>
                            <th CL="STD_BOMMNM1"></th>
                            <td>
                                <input type="text" name="BH.BOMMNM" UIInput="R" UIFormat="U"/>
                            </td>
                        </tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- //searchPop -->

	</div>
	<!-- //contentContainer -->
	</div>
	</div>

	<!-- content -->
	<div class="content">
		<div class="innerContainer">
			<div class="contentContainer">
				<div class="bottomSect type1">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL="STD_GENERAL"></span></a></li>
							<li><a href="#tabs1-2"><span CL="STD_DETAIL"></span></a></li>
						</ul>

						<div id="tabs1-1">
							<div class="section type1">
	                            <div class="table type2">
	                                <div class="tableBody">
	                                    <table>
	                                        <tbody id="gridList">
	                                            <tr CGRow="true">
	                                                <td GH="40"               GCol="rownum">1</td>
	                                                <td GH="100 STD_BOMMKY1"  GCol="text,BOMMKY"></td>
	                                                <td GH="100 STD_BOMMNM1"  GCol="text,BOMMNM"></td>
	                                                <td GH="100 STD_QTSIWH"   GCol="text,BOMQTY" GF="N"></td>
	                                            </tr>                           
	                                        </tbody>
	                                    </table>
	                                </div>
	                            </div>
	                            <div class="tableUtil">
	                                <div class="leftArea">      
	                                    <button type="button" GBtn="find"></button>
	                                    <button type="button" GBtn="sortReset"></button>
	                                    <!-- <button type="button" GBtn="add"></button>
	                                    <button type="button" GBtn="delete"></button> -->
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
                            <div class="section type1">
                                <div class="table type2">
                                    <div class="tableBody">
                                        <table>
                                            <tbody id="gridList2">
                                                <tr CGRow="true">
                                                    <td GH="40"               GCol="rownum">1</td>
                                                    <td GH="100 STD_BOMMKY1"  GCol="text,BOMMKY"></td>
                                                    <td GH="100 STD_BOMMNM1"  GCol="text,BOMMNM"></td>
                                                    <td GH="100 STD_QTSIWH"   GCol="text,BOMQTY" GF="N"></td>
                                                    <td GH="100 STD_HSTYPE"   GCol="text,HSTYPE"></td>
                                                </tr>                           
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="tableUtil">
                                    <div class="leftArea">      
                                        <button type="button" GBtn="find"></button>
                                        <button type="button" GBtn="sortReset"></button>
                                        <!-- <button type="button" GBtn="add"></button>
                                        <button type="button" GBtn="delete"></button> -->
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
			<!-- contentContainer -->
		</div>
	</div>
	<%@ include file="/common/include/bottom.jsp" %>

</body>
</html>