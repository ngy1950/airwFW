<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>GR06POP1</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">

	window.resizeTo('710','600');
	
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsInbound",
			command : "GR06POP1"
	    });
		
		var data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		searchList();
	});
	
	function searchList(){
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    }); 
		
	}
	
	
	function commonBtnClick(btnName){
		if(btnName == "Check"){
			fn_closing();
		}
	}
	
	function fn_closing(){
		this.close();
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<!-- <button CB="Reflect REFLECT BTN_REFLECT">
		</button>
		<button CB="Search SEARCH BTN_CLEAR">
		</button> -->
		<button CB="Check CHECK BTN_CLOSE">
		</button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect type1">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs"><span>QC항목</span></a></li>
					</ul>
					<div id="tabs">
						<div class="section type1">
							<div id="searchArea">
								<input type="hidden" name="OWNRKY" /> <input type="hidden" name="QCTYPE" />
								제품 :  <input type="text" name="SKUKEY" readonly="readonly" style="width:100px"/> <input type="text" name="DESC01" readonly="readonly" style="width:250px"/>
							</div>
							<div class="table type2" style="top:50px">
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
										</colgroup>
										<thead>
											<tr>
												<th CL="STD_NUMBER"></th>
												<th CL="STD_QCITEM"></th>
												<th CL="STD_LVLSIM"></th>
												<th CL="STD_LVLMID"></th>
												<th CL="STD_LVLSTR"></th>
												<th CL="STD_LOLIMIT"></th>
												<th CL="STD_UPLIMIT"></th>
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
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,QCITEM"></td>
												<td GCol="text,LVLSIM"></td>
												<td GCol="text,LVLMID"></td>
												<td GCol="text,LVLSTR"></td>
												<td GCol="text,LOLIMIT" GF="N 20"></td>
												<td GCol="text,UPLIMIT" GF="N 20"></td>
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
		<!-- //contentContainer -->
	    
	    </div>
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</head>
<body>

</body>
</html>