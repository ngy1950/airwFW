<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">
	window.resizeTo('800','500');
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	name : "gridList",
			editable : true,
			module : "WmsAdmin",
			command : "MV03POP",
            selectRowDeleteType : false,
            autoCopyRowType : false,
            excelCsvType : true
			//bindArea : "tabs1-2" 
	    });
		
		var data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		//searchList();
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

 	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}
	}
 	
 	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			close1(rowNum);
        }
	}
 	
    function close1(rowNum){
        var list = gridList.getRowData("gridList",rowNum);
        page.linkPopClose(list);
    }
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
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
							<input type="text" name="WAREKY" UISave="false"  readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th CL="STD_AREAKY"></th>
						<td>
							<input type="text" name="LM.AREAKY" UIInput="R,SHAREMA" UIFormat="U" />
						</td>
					</tr>
					<tr>
						<th CL="STD_SKUKEY"></th>
						<td>
							<input type="text" name="SKUKEY" UISave="false"  readonly="readonly"/>
						</td>
					</tr>
					<tr>
				    	<th CL="STD_FELCHK"></th>
						<td>
							<input type="checkbox" name="FELCHK" value="V"/>
						</td>
					</tr>
					<!-- 
					<tr>
						<th CL="STD_ZONEKY"></th>
						<td>
							<input type="text" name="ZONEKY" UIInput="R,SHZONMA" UIFormat="U" />
						</td>
					</tr>
					
					<tr>
						<th CL="STD_LOCAKY"></th>
						<td>
							<input type="text" name="LOCAKY" UIInput="R,SHLOCMA" UIFormat="U"/>
						</td>
					</tr>
					 -->
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
						<li><a href="#tabs1-1"><span CL='STD_ITEMLIST'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"   GCol="rownum">1</td>
												<td GH="80 STD_AREAKY"   GCol="text,AREAKY"></td>
												<td GH="80 STD_LOCAKYNM"   GCol="text,SHORTX"></td>	
												<td GH="80 STD_SKUKEY"   GCol="text,SKUKEY"></td>
												<td GH="80 STD_DESC01"   GCol="text,DESC01"></td>
												<td GH="80 STD_QTSIWH"   GCol="text,UOMQTY"></td>
												<td GH="80 STD_UOMKEY"   GCol="text,UOMKEY"></td>
												<td GH="80 STD_FIXLOC"   GCol="text,FIXLOC"></td>	
												<td GH="80 STD_LOTA04"   GCol="text,LOTA04"></td>	
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