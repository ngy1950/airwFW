<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi" />
<meta name="format-detection" content="telephone=no" />
<title>IMV Mobile WMS</title>
<%@ include file="/mobile/include/head.jsp" %>
<script>
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridItemList",
			editable : true,
			module : "Mobile",
			command : "MOM05Sub",
			gridMobileType : true
	    });
		
		var data = mobile.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		
		searchList();
	});
	
	function searchList(){
		var param = inputList.setRangeParam("searchArea");
		
		gridList.resetGrid("gridItemList");
		gridList.setReadOnly("gridItemList", false);
		gridList.setReadOnly("gridItemList", true, ['RSNCOD']);
		
		gridList.gridList({
	    	id : "gridItemList",
	    	param : param
	    });
		
		showMain();
	}
	
	function showMain() {
		$("#main").show();
	}
	
	function popClose(){
 		this.close();
 	}
</script>
</head>
<body>
	<div class="main_wrap" id="main">
		<div id="searchArea">
			<input type="hidden" name="SHPRQK" />
		</div>
		<div id="main_container">
			<div class="tem5_content">
				<div class="tableWrap_search section">
					<div class="tableHeader">
						<table style="width: 100%">
							<colgroup>
								<col width="30px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
							</colgroup>
							<thead>
								<tr>
									<th CL='STD_NUMBER'>??????</th>
									<th CL='STD_SHPRQK'>??????????????????</th>
									<th CL='STD_SHPRQI'>??????????????????</th>
									<th CL='STD_SKUKEY'>??????</th>
									<th CL='STD_DESC01'>??????</th>
									<th CL='STD_MATNR,3'>??????</th>
									<th CL='STD_DESC02'>??????</th>
									<th CL='STD_SKUG05'>??????</th>
									<th CL='STD_QTYORD'>??????????????????</th>
									<th CL='STD_UOMKEY'>??????</th>
									<th CL='STD_QTYTRN'>??????????????????</th>
									<th CL='STD_QTYTRS'>??????????????????</th>
									<th CL='STD_QTYTRR'>??????????????????</th>
									<th CL='STD_QTALOC'>????????????</th>
									<th CL='STD_QTJCMP'>??????????????????</th>
									<th CL='STD_QTSHPD'>??????????????????</th>
									<th CL='STD_QTUSHP'>????????????</th>
									<th CL='STD_TRNSHP'>????????????????????????</th>
									<th CL='STD_TRNITM'>????????????????????????</th>
									<th CL='STD_SHPOKY'>??????????????????</th>
									<th CL='STD_SHPOIT'>??????????????????</th>
									<th CL='STD_LOTA10'></th>
									<!-- <th CL='STD_LOTA16'></th> -->
									<th CL='STD_LOTA17'></th>
									<th CL='STD_LOTA02'></th>
									<th CL='STD_RSNCOD'></th>
									<th CL='STD_TASRSN'></th>
									<th CL='STD_DOCTXT'></th>
								</tr>
							</thead>
						</table>				
					</div>					
					<div class="tableBody">
						<table style="width: 100%">
							<colgroup>
								<col width="30px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
								<col width="100px" />
							</colgroup>
							<tbody id="gridItemList">
								<tr CGRow="true">
									<td GCol="rownum"></td>                 
									<td GCol="text,SHPRQK"></td>           <!-- ?????????????????? -->
									<td GCol="text,SHPRQI"></td>           <!-- ?????????????????? -->
									<td GCol="text,SKUKEY"></td>           <!-- ??????             -->
									<td GCol="text,DESC01"></td>           <!-- ??????              -->
									<td GCol="text,MATNR"></td>            <!-- BQMS Code              -->
									<td GCol="text,DESC02"></td>           <!-- ??????              -->
									<td GCol="text,SKUG05"></td>           <!-- ??????              -->
									<td GCol="text,QTYORD" GF="N"></td>    <!-- ??????????????????  -->
									<td GCol="text,UOMKEY"></td>           <!-- ??????              -->
									<td GCol="text,QTYTRN" GF="N"></td>    <!-- ??????????????????  -->
									<td GCol="text,QTYTRS" GF="N"></td>    <!-- ??????????????????  -->
									<td GCol="text,QTYTRR" GF="N"></td>    <!-- ??????????????????  -->
									<td GCol="text,QTALOC" GF="N"></td>    <!-- ????????????        -->
									<td GCol="text,QTJCMP" GF="N"></td>    <!-- ??????????????????  -->
									<td GCol="text,QTSHPD" GF="N"></td>    <!-- ??????????????????  -->
									<td GCol="text,QTUSHP" GF="N"></td>    <!-- ????????????        -->
									<td GCol="text,TRNSHP"></td>           <!-- ???????????????????????? -->
									<td GCol="text,TRNSHI"></td>           <!-- ???????????????????????? -->
									<td GCol="text,SHPOKY"></td>           <!-- ??????????????????  -->
									<td GCol="text,SHPOIT"></td>           <!-- ??????????????????  -->
									<td GCol="text,LOTA10" GF="S 20"></td>
									<!-- <td GCol="text,LOTA16" GF="N 20,3"></td> -->
									<td GCol="text,LOTA17" GF="N 20,3"></td>
									<td GCol="text,LOTA02"></td>           <!-- ??????????????????  -->
									<td GCol="select,RSNCOD">
										<select ReasonCombo="380"></select>
									</td>
									<td GCol="text,TASRSN"></td>    
									<td GCol="text,DOCTXT"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- end table_body -->
				<div class="footer_5">
					<table>
						<tr>
							<td onclick="popClose()"><label CL='BTN_CLOSE'></label></td>
						</tr>
					</table>
				</div><!-- end footer_5 -->	
			</div>
		</div>
	</div>
</body>