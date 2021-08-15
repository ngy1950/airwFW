<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>KP01POP1</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">

	window.resizeTo('800','600');
	
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsReport",
			command : "KP01_NOTSHP"
	    });
		
		searchList();
	});
	
	function searchList(){
		var data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
			
		 gridList.gridList({
	    	id : "gridList",
	    	param : data
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
						<li><a href="#tabs"><span CL="STD_LIST">리스트</span></a></li>
					</ul>
					<div id="tabs">
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
										</colgroup>
										<thead>
											<tr>
												<th CL="STD_NUMBER"></th>
												<th CL="STD_VBELN"></th>
												<th CL="STD_POSNR"></th>
												<th CL="STD_WADAT"></th>
												<th CL="STD_SKUKEY"></th>
												<th CL="STD_DESC01"></th>
												<th CL="STD_DESC02"></th>
												<th CL="STD_AREAKY"></th>
												<th CL="STD_DEPTID1"></th>
												<th CL="STD_LFIMG"></th>
												<th CL="STD_QTSHP,2"></th>
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
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,VBELN"></td>
												<td GCol="text,POSNR"></td>
												<td GCol="text,WADAT"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,MBLNO"></td>
												<td GCol="text,DEPTID1"></td>
												<td GCol="text,LFIMG"></td>
												<td GCol="text,QTSHP"></td>
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
</body>
</html>