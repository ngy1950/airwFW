<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SKU Image List</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">

	window.resizeTo('1000','650');
	var skukey;
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			editable : true,
			module : "WmsOrder",
			command : "SKU_IMG_POP"
	    });
		
		var data = page.getLinkPopData();
		skukey = data.get("SKUKEY");
		searchList();
	});
	
	function searchList(){
		var param = inputList.setRangeParam("searchArea");
		param.put("SKUKEY", skukey);	
		
		gridList.gridList({
	    	id : "gridList",
	    	param : param
	    }); 
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridList" && dataLength > 0 ){
			var imgfile = gridList.getColData(gridId, 0, "IMGFILE");
			$('#image').attr("src", imgfile);
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Reflect"){
			fn_reflect();
		}else if(btnName == "Check"){
			fn_closing();
		}else if(btnName == "Search"){
			searchList();
		}
	}
	
	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			var fpath = gridList.getColData(gridId, rowNum, "FPATH");
			var fname = gridList.getColData(gridId, rowNum, "FNAME");
			var exename = gridList.getColData(gridId, rowNum, "EXENAME");
			var file = "../../" + fpath + "/"+ fname + "." + exename;
			$('#image').attr("src", file);
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
	<!-- <div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div> -->
</div>

<div class="content">
		<div class="innerContainer">
			<!-- contentContainer -->
			<div class="contentContainer">
				<div class="bottomSect2 top">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span>List</span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="90" />
											<col width="50" />
											<col width="140" />
											<col width="100" />
											<col width="40" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NO'>No.</th>
												<th CL='STD_SKUKEY'>Item Code</th>
												<th CL='STD_FLTYPE'>File Type</th>
												<th CL='STD_IFDTFN'>File Name</th>
												<th CL='STD_FLPATH'>File Path</th>
												<th CL='STD_EXENM'>Exe Name</th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="90" />
											<col width="50" />
											<col width="140" />
											<col width="100" />
											<col width="40" />
										</colgroup>
										<tbody id="gridList">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,FTYPE"></td>
												<td GCol="text,FNAME"></td>
												<td GCol="text,FPATH"></td>
												<td GCol="text,EXENAME"></td>
											</tr>									
										</tbody>
									</table>
								</div>
							</div>
							</div>
						</div>
					</div>
				</div>
				<div id="commonMiddleArea2"></div>
				<div class="bottomSect2 bottom">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span>Image</span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<table>
										<tr>
											<img id="image" />
										</tr>
									</table>
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