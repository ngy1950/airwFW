<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
	
	var searchCnt = 0; 
	var listFlag  = false;
	var dblIdx = -1;
	
	$(document).ready(function(){
		setTopSize(250);
		gridList.setGrid({
	    	id : "gridListHead",
			editable : true,
			pkcol : "WAREKY,ASNDKY",
			module : "WmsInbound",
			command : "AS02",
			validation : "WAREKY"
	    });
		gridList.setGrid({
	    	id : "gridListSub",
			editable : true,
			pkcol : "WAREKY,ASNDKY,ASNTTY",
			module : "WmsInbound",
			command : "AS02Sub"
	    });
	});
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}/* else if(btnName == "Print"){
			printList()
		} */
	}

	function searchList(){
		//var param = dataBind.paramData("searchArea");
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			//alert(param);
			gridList.gridList({
		    	id : "gridListHead",
		    	param : param
		    });
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridListHead" && dataLength > 0 ){
			searchSubList(0);
		}
	}

	function searchSubList(headRowNum){
		var rowVal  = gridList.getColData("gridListHead", headRowNum, "ASNDKY");
		
		var param = inputList.setRangeParam("searchArea");
		
		param.put("ASNDKY", rowVal);
		
		gridList.gridList({
			id : "gridListSub",
			param : param
		});
		
		dblIdx = headRowNum;
	}
	
	function gridListEventRowDblclick(gridId, rowNum){
		if( gridId == "gridListHead" ){
			searchSubList(rowNum);
		}	
	}
	
	function gridListEventRowFocus(gridId, rowNum){
		if(gridId == "gridListHead"){
			var modRowCnt = gridList.getModifyRowCount("gridListSub");
			if(modRowCnt == 0){
				if(dblIdx != rowNum){
					gridList.resetGrid("gridListSub");
					dblIdx = -1;
				}
			}else if(modRowCnt > 0 && dblIdx != -1){
				//if(confirm(commonUtil.getMsg("COMMON_M0024"))){
				if(commonUtil.msgConfirm("COMMON_M0462")){
					gridList.resetGrid("gridListSub");
				}else{
					gridList.setRowFocus("gridListHead", dblIdx, false);
					return false;
				}
			}
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, gridType){
		//commonUtil.debugMsg("searchHelpEventOpenBefore : ", arguments);
		var param = new DataMap();
		
		if(searchCode == "SHBZPTN"){
			param.put("OWNRKY", "<%= ownrky%>");
			return param;
		}else if(searchCode == "SHASNEBELN"){
			param.put("WAREKY", "<%= wareky%>");
			return param;
		}
	}
	
</script>
</head>
<body>

<!-- contentHeader -->
<div class="contentHeader">
	<div class="util">
		<button CB="Print PRINT BTN_PRINT24">
		</button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>
<!-- //contentHeader -->

<!-- searchPop -->
<div class="searchPop">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer" id="searchArea">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
		</p>
		<div class="searchInBox">
			<h2 class="tit" CL="STD_SELECTOPTIONS">????????????</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_WAREKY">??????</th>
						<td colspan="3">
							<input type="text" name="WAREKY" validate="required,M0434" value="<%= wareky%>" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<th CL="STD_ASNTTY">ASN ??????</th> <!-- selectBox -->
						<td>
							<select name="ASNTTY" style="width: 150px;">
								<option value="051">[051] ????????????(??????)</option>
							</select>
						</td>
					</tr>
					<tr>
						<th CL="STD_ASNDKY">ASN ????????????</th>
						<td>
							<input type="text" name="AH.ASNDKY" UIInput="R,SHASN" />
						</td>
					</tr>
					<tr>
						<th CL="STD_ASNDAT">ASN ?????????</th>
						<td>
							<input type="text" name="AH.DOCDAT" UIInput="R" UIFormat="C" />
						</td>
					</tr>
					<tr>
						<th CL="STD_STATDO">????????????</th>
						<td>
							<input type="text" name="AH.STATDO" UIInput="R,SHVSTATDO" value="NEW"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="searchInBox">
			<h2 class="tit type1">ERP ????????????</h2>
			<table class="table type1">
				<colgroup>
					<col width="100" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th CL="STD_SEBELN">SAP P/O No</th>
						<td >
							<input type="text" name="AI.SEBELN" UIInput="R,SHASNEBELN" />
						</td>
					</tr>
					<tr>
						<th CL="STD_DPTNKY,3">????????????</th>
						<td>
							<input type="text" name="AH.DPTNKY" UIInput="R,SHBZPTN" />
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

			<div class="bottomSect top">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span>??????</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th GBtnCheck="true"></th>
												
												<th Cl='STD_ASNDKY'></th>	<!-- ASN ???????????? -->
												<th Cl='STD_WAREKY'></th>	<!-- ?????? -->
												<th Cl='STD_WAREKYNM'></th>	<!-- ????????? -->
												<th Cl='STD_ASNTTY'></th>	<!-- ASN ?????? -->
												<th Cl='STD_ASNTTYNM'></th>	<!-- ASN ????????? -->
												<th Cl='STD_STATDO'></th>	<!-- ???????????? -->
												<th Cl='STD_DOCDAT'></th>	<!-- ???????????? -->
												<th Cl='STD_DOCCAT'></th>	<!-- ???????????? -->
												<th Cl='STD_DOCCATNM'></th>	<!-- ???????????? -->
												
												<th Cl='STD_OWNRKY'></th>	<!-- ?????? -->
												<th Cl='STD_DPTNKY'></th>	<!-- ???????????? -->
												<th Cl='STD_DPTNKYNM'></th>	<!-- ??????????????? -->
<!-- 												<th Cl='STD_DRELIN'></th>	????????????????????? -->
<!-- 												<th Cl='STD_PRCPTD'></th>   ?????????????????? -->
<!-- 												<th Cl='STD_LRCPTD'></th>   ?????????????????? -->
<!-- 												<th Cl='STD_INDDCL'></th>   ???????????? -->
<!-- 												<th Cl='STD_RSNCOD'></th>   ???????????? -->
<!-- 												<th Cl='STD_RSNRET'></th>   ?????????????????? -->
<!-- 												<th Cl='STD_LGORT'></th>    Fr.ERP?????? -->
												
<!-- 												<th Cl='STD_LGORTNM'></th>  Fr.ERP????????? -->
<!-- 												<th Cl='STD_QTYASN'></th>   ????????? -->
<!-- 												<th Cl='STD_QTYRCV'></th>   ???????????? -->
<!-- 												<th Cl='STD_USRID1'></th>   ????????? -->
<!-- 												<th Cl='STD_UNAME1'></th>   ???????????? -->
<!-- 												<th Cl='STD_DEPTID1'></th>  ????????? ?????? -->
<!-- 												<th Cl='STD_DNAME1'></th>   ????????? ????????? -->
<!-- 												<th Cl='STD_USRID2'></th>   ??????????????? -->
<!-- 												<th Cl='STD_UNAME2'></th>   ?????????????????? -->
<!-- 												<th Cl='STD_DEPTID2'></th>  ?????? ?????? -->
												
<!-- 												<th Cl='STD_DNAME2'></th>   ?????? ????????? -->
<!-- 												<th Cl='STD_USRID3'></th>   ???????????? -->
<!-- 												<th Cl='STD_UNAME3'></th>   ?????????????????? -->
<!-- 												<th Cl='STD_DEPTID3'></th>  ???????????? ?????? -->
<!-- 												<th Cl='STD_DNAME3'></th>   ???????????? ????????? -->
<!-- 												<th Cl='STD_USRID4'></th>   ???????????? -->
<!-- 												<th Cl='STD_UNAME4'></th>   ?????????????????? -->
<!-- 												<th Cl='STD_DEPTID4'></th>  ???????????? ?????? -->
<!-- 												<th Cl='STD_DNAME4'></th>   ???????????? ????????? -->
<!-- 												<th Cl='STD_DOCTXT'></th>   ?????? -->
												
												<th Cl='STD_SEBELN'></th>    <!-- SAP P/O No -->
												<th Cl='STD_CREDAT' GF="D"></th>   <!-- ???????????? -->
												<th Cl='STD_CRETIM' GF="T"></th>   <!-- ???????????? -->
												<th Cl='STD_CREUSR'></th>   <!-- ????????? -->
												<th Cl='STD_CUSRNM'></th>   <!-- ???????????? -->
												<th Cl='STD_LMODAT' GF="D"></th>   <!-- ???????????? -->
												<th Cl='STD_LMOTIM' GF="T"></th>   <!-- ???????????? -->
												<th Cl='STD_LMOUSR'></th>   <!-- ????????? -->
												<th Cl='STD_LUSRNM'></th>   <!-- ???????????? -->
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											<col width="40" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<tbody id="gridListHead">
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												<td GCol="rowCheck"></td>
												
												<td GCol="text,ASNDKY"></td>	<!-- ASN ???????????? -->
												<td GCol="text,WAREKY"></td>	<!-- ?????? -->        
												<td GCol="text,WAREKYNM"></td>	<!-- ????????? -->
												<td GCol="text,ASNTTY"></td>	<!-- ASN ?????? -->    
												<td GCol="text,ASNTTYNM"></td>	<!-- ASN ????????? -->
												<td GCol="text,STATDO"></td>	<!-- ???????????? -->      
												<td GCol="text,DOCDAT"></td>	<!-- ???????????? -->
												<td GCol="text,DOCCAT"></td>	<!-- ???????????? -->
												<td GCol="text,DOCCATNM"></td>	<!-- ??????????????? -->
												
												<td GCol="text,OWNRKY"></td>	<!-- ?????? -->
												<td GCol="text,DPTNKY"></td>	<!-- ???????????? -->
												<td GCol="text,DPTNKYNM"></td>	<!-- ??????????????? -->
<!-- 												<td GCol="text,DRELIN"></td>	????????????????????? -->
<!-- 												<td GCol="text,PRCPTD"></td>	?????????????????? -->
<!-- 												<td GCol="text,LRCPTD"></td>	?????????????????? -->
<!-- 												<td GCol="text,INDDCL"></td>	????????????       -->
<!-- 												<td GCol="text,RSNCOD"></td>	???????????? -->
<!-- 												<td GCol="text,RSNRET"></td>	??????????????????     -->
<!-- 												<td GCol="text,LGORT"></td>		Fr.ERP?????? -->
												
<!-- 												<td GCol="text,LGORTNM"></td>	Fr.ERP????????? -->
<!-- 												<td GCol="text,QTYASN"></td>	????????? -->
<!-- 												<td GCol="text,QTYRCV"></td>	????????????       -->
<!-- 												<td GCol="text,USRID1"></td>	????????? -->
<!-- 												<td GCol="text,UNAME1"></td>	???????????? -->
<!-- 												<td GCol="text,DEPTID1"></td>	????????? ?????? -->
<!-- 												<td GCol="text,DNAME1"></td>	????????? ????????? -->
<!-- 												<td GCol="text,USRID2"></td>	??????????????? -->
<!-- 												<td GCol="text,UNAME2"></td>	??????????????????     -->
<!-- 												<td GCol="text,DEPTID2"></td>	?????? ?????? -->
												
<!-- 												<td GCol="text,DNAME2"></td>	?????? ?????????     -->
<!-- 												<td GCol="text,USRID3"></td>	????????????       -->
<!-- 												<td GCol="text,UNAME3"></td>	??????????????????     -->
<!-- 												<td GCol="text,DEPTID3"></td>	???????????? ??????    -->
<!-- 												<td GCol="text,DNAME3"></td>	???????????? ????????? -->
<!-- 												<td GCol="text,USRID4"></td>	????????????       -->
<!-- 												<td GCol="text,UNAME4"></td>	??????????????????     -->
<!-- 												<td GCol="text,DEPTID4"></td>	???????????? ?????? -->
<!-- 												<td GCol="text,DNAME4"></td>	???????????? ????????? -->
<!-- 												<td GCol="text,DOCTXT"></td>	?????? -->
												
												<td GCol="text,EBELN"></td>		<!-- SAP P/O No -->
												<td GCol="text,CREDAT" GF="D"></td>	<!-- ???????????? -->      
												<td GCol="text,CRETIM" GF="T"></td>	<!-- ???????????? -->      
												<td GCol="text,CREUSR"></td>	<!-- ????????? -->       
												<td GCol="text,CUSRNM"></td>	<!-- ???????????? -->      
												<td GCol="text,LMODAT" GF="D"></td>	<!-- ???????????? -->      
												<td GCol="text,LMOTIM" GF="T"></td>	<!-- ???????????? -->      
												<td GCol="text,LMOUSR"></td>	<!-- ????????? -->       
												<td GCol="text,LUSRNM"></td>	<!-- ???????????? -->      
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
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea">
						<li><a href="#tabs1-1"><span>Item ?????????</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="40" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
<!-- 											<col width="150" /> -->
											<col width="150" />
											
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											<col width="150" />
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												
												<th Cl='STD_ASNDKY'></th>	<!-- ASN ???????????? -->
												<th Cl='STD_ASNDIT'></th>	<!-- ASN Item -->
												<th Cl='STD_STATIT'></th>	<!-- ?????? -->
												<th Cl='STD_SKUKEY'></th>   <!-- ???????????? -->
												<th Cl='STD_QTYASN'></th>	<!-- ????????? -->
												<th CL='STD_QTYASN1,2'></th> <!-- ???????????? -->
												<th CL='STD_QTYORD'></th>	<!-- ???????????? -->
												<th Cl='STD_QTYRCV'></th>   <!-- ???????????? -->     
<!-- 												<th Cl='STD_QTYUOM'></th>   Quantity    -->
												<th Cl='STD_MEASKY'></th>   <!-- ???????????? -->  
												<th Cl='STD_UOMKEY'></th>   <!-- ?????? -->
												
<!-- 												<th Cl='STD_QTPUOM'></th>   Units pe -->
<!-- 												<th Cl='STD_DUOMKY'></th>   ?????? -->
<!-- 												<th Cl='STD_QTDUOM'></th>   ?????? -->
<!-- 												<th Cl='STD_BOXQTY'></th>   ????????? -->
<!-- 												<th Cl='STD_REMQTY'></th>   ?????? -->
<!-- 												<th Cl='STD_RCSTKY'></th>    -->
												<th Cl='STD_LOCARV'></th>   <!-- ?????? ???????????? -->   
<!-- 												<th Cl='STD_LOTA01'></th>   S/N??????    -->
<!-- 												<th Cl='STD_LOTA01NM'></th> ???????????????   -->
<!-- 												<th Cl='STD_LOTA02'></th>   ???????????? -->
												 
												<th CL='STD_LOTA03'></th>	<!-- ?????? -->
												<th CL='STD_LOTA04'></th>	<!-- ???????????? -->
												<th CL='STD_LOTA05'></th>	<!-- ???????????? -->
												<th CL='STD_LOTA06'></th>	<!-- ???????????? -->
<!-- 												<th CL='STD_LOTA07'></th>	LOT??????7 -->
<!-- 												<th CL='STD_LOTA08'></th>	LOT??????8 -->
<!-- 												<th CL='STD_LOTA09'></th>	LOT??????9 -->
<!-- 												<th CL='STD_LOTA10'></th>	LOT??????10 -->
												<th CL='STD_LOTA11'></th>	<!-- ???????????? -->
												<th CL='STD_LOTA12'></th>	<!-- ???????????? -->
												
												<th Cl='STD_LOTA13'></th>   <!-- ???????????? -->   
<!-- 												<th Cl='STD_LOTA14'></th>   LOT??????14    -->
<!-- 												<th Cl='STD_LOTA15'></th>   LOT??????15    -->
<!-- 												<th Cl='STD_LOTA16'></th>   LOT??????16    -->
<!-- 												<th Cl='STD_LOTA17'></th>   LOT??????17    -->
<!-- 												<th Cl='STD_LOTA18'></th>   LOT??????18    -->
<!-- 												<th Cl='STD_LOTA19'></th>   LOT??????19    -->
<!-- 												<th Cl='STD_LOTA20'></th>   LOT??????20    -->
												<th Cl='STD_LRCPTD'></th>   <!-- ?????????????????? -->
												<th Cl='STD_REFDKY'></th>   <!-- ???????????? -->
												
												<th Cl='STD_REFDIT'></th>	<!-- ????????????It. -->
												<th Cl='STD_REFCAT'></th>	<!-- ?????????????????? -->
												<th Cl='STD_EASNKY'></th>   <!-- ??????ASN?????? --> 
												<th Cl='STD_EASNIT'></th>	<!-- ??????ASN It -->
 												<th Cl='STD_DESC01'></th>   <!-- ?????? -->   
												<th Cl='STD_DESC02'></th>   <!-- ?????? -->   
												<th Cl='STD_ASKU01'></th>   <!-- WMS ???????????? -->   
												<th Cl='STD_ASKU02'></th>   <!-- ??????(E)/??????(D) -->   
												<th Cl='STD_ASKU03'></th>   <!-- ERP ???????????? -->   
												<th Cl='STD_ASKU04'></th>   <!-- ????????? ????????? -->
												   
												<th Cl='STD_ASKU05'></th>   <!-- ?????? -->   
												<th Cl='STD_EANCOD'></th>   <!-- EAN -->   
												<th Cl='STD_GTINCD'></th>   <!-- UPC -->   
												<th Cl='STD_SKUG01'></th>   <!-- ????????????1 -->   
												<th Cl='STD_SKUG02'></th>   <!-- ????????????2 -->   
												<th Cl='STD_SKUG03'></th>   <!-- ????????????3 -->   
												<th Cl='STD_SKUG04'></th>   <!-- ?????? -->   
												<th Cl='STD_SKUG05'></th>   <!-- ??????????????? -->   
												<th Cl='STD_GRSWGT'></th>   <!-- ????????? -->   
												<th Cl='STD_NETWGT'></th>   <!-- KIT????????? -->
												   
												<th Cl='STD_WGTUNT'></th>
												<th Cl='STD_LENGTH'></th>
												<th Cl='STD_WIDTHW'></th>
												<th Cl='STD_HEIGHT'></th>
												<th Cl='STD_CUBICM'></th>
												<th Cl='STD_CAPACT'></th>
												<th Cl='STD_SMANDT'></th>
												<th Cl='STD_SEBELN'></th>
												<th Cl='STD_SEBELP'></th>   
												<th Cl='STD_SZMBLNO'></th>
												   
												<th Cl='STD_SZMIPNO'></th>
												<th Cl='STD_STRAID'></th>
												<th Cl='STD_SVBELN'></th>
												<th Cl='STD_SPOSNR'></th>
												<th Cl='STD_STKNUM'></th>
												<th Cl='STD_STPNUM'></th>
												<th Cl='STD_SWERKS'></th>
												<th Cl='STD_SLGORT'></th>
												<th Cl='STD_SDATBG'></th>
												<th Cl='STD_STDLNR'></th>
												
												<th Cl='STD_SSORNU,2'></th>
												<th Cl='STD_SSORIT,2'></th>   
												<th Cl='STD_SMBLNR'></th>   
												<th Cl='STD_SZEILE'></th>   
												<th Cl='STD_SMJAHR'></th>   
												<th Cl='STD_SXBLNR'></th>   
												<th Cl='STD_SBKTXT'></th>   
												<th Cl='STD_AWMSNO'></th>
												<th Cl='STD_CREDAT'></th>   
												<th Cl='STD_CRETIM'></th>
												   
												<th Cl='STD_CREUSR'></th>
												<th Cl='STD_CUSRNM'></th>
												<th Cl='STD_LMODAT'></th>
												<th Cl='STD_LMOTIM'></th>
												<th Cl='STD_LMOUSR'></th>
												<th Cl='STD_LUSRNM'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="40" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
<!-- 											<col width="150" /> -->
											<col width="150" />
											
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											<col width="150" />
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
<!-- 											<col width="150" /> -->
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
											<col width="150" />
										</colgroup>
										<tbody id='gridListSub'>
											<tr CGRow="true">
												<td GCol="rownum">1</td>
												
												<td GCol="text,ASNDKY"></td>
												<td GCol="text,ASNDIT"></td>
												<td GCol="text,STATIT"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,QTYASN" GF="N"></td>
												<td GCol="text,QTYASN1" GF="N"></td>
												<td GCol="text,QTYORD" GF="N"></td>
												<td GCol="text,QTYRCV" GF="N"></td>
<!-- 												<td GCol="text,QTYUOM"></td> -->
												<td GCol="text,MEASKY"></td>
												<td GCol="text,UOMKEY"></td>
												
<!-- 												<td GCol="text,QTPUOM"></td> -->
<!-- 												<td GCol="text,DUOMKY"></td> -->
<!-- 												<td GCol="text,QTDUOM"></td> -->
<!-- 												<td GCol="text,BOXQTY"></td> -->
<!-- 												<td GCol="text,REMQTY"></td> -->
<!-- 												<td GCol="text,RCSTKY"></td> -->
												<td GCol="text,LOCARV"></td>
<!-- 												<td GCol="text,LOTA01"></td> -->
<!-- 												<td GCol="text,LOTA01NM"></td> -->
<!-- 												<td GCol="text,LOTA02"></td> -->
												
												<td GCol="text,LOTA03"></td>
												<td GCol="text,LOTA04"></td>
												<td GCol="text,LOTA05"></td>
												<td GCol="text,LOTA06"></td>
<!-- 												<td GCol="text,LOTA07"></td> -->
<!-- 												<td GCol="text,LOTA08"></td> -->
<!-- 												<td GCol="text,LOTA09"></td> -->
<!-- 												<td GCol="text,LOTA10"></td> -->
												<td GCol="text,LOTA11" GF="D"></td>
												<td GCol="text,LOTA12" GF="D"></td>
												
												<td GCol="text,LOTA13" GF="D"></td>
<!-- 												<td GCol="text,LOTA14"></td> -->
<!-- 												<td GCol="text,LOTA15"></td> -->
<!-- 												<td GCol="text,LOTA16"></td> -->
<!-- 												<td GCol="text,LOTA17"></td> -->
<!-- 												<td GCol="text,LOTA18"></td> -->
<!-- 												<td GCol="text,LOTA19"></td> -->
<!-- 												<td GCol="text,LOTA20"></td> -->
												<td GCol="text,LRCPTD"></td>
												<td GCol="text,REFDKY"></td>
												
												<td GCol="text,REFDIT"></td>
												<td GCol="text,REFCAT"></td>
												<td GCol="text,EASNKY"></td>
												<td GCol="text,EASNIT"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,ASKU01"></td>
												<td GCol="text,ASKU02"></td>
												<td GCol="text,ASKU03"></td>
												<td GCol="text,ASKU04"></td>
												
												<td GCol="text,ASKU05"></td>
												<td GCol="text,EANCOD"></td>
												<td GCol="text,GTINCD"></td>
												<td GCol="text,SKUG01"></td>
												<td GCol="text,SKUG02"></td>
												<td GCol="text,SKUG03"></td>
												<td GCol="text,SKUG04"></td>
												<td GCol="text,SKUG05"></td>
												<td GCol="text,GRSWGT"></td>
												<td GCol="text,NETWGT"></td>
												
												<td GCol="text,WGTUNT"></td>
												<td GCol="text,LENGTH"></td>
												<td GCol="text,WIDTHW"></td>
												<td GCol="text,HEIGHT"></td>
												<td GCol="text,CUBICM"></td>
												<td GCol="text,CAPACT"></td>
												<td GCol="text,SMANDT"></td>
												<td GCol="text,SEBELN"></td>
												<td GCol="text,SEBELP"></td>
												<td GCol="text,SZMBLNO"></td>
												
												<td GCol="text,SZMIPNO"></td>
												<td GCol="text,STRAID"></td>
												<td GCol="text,SVBELN"></td>
												<td GCol="text,SPOSNR"></td>
												<td GCol="text,STKNUM"></td>
												<td GCol="text,STPNUM"></td>
												<td GCol="text,SWERKS"></td>
												<td GCol="text,SLGORT"></td>
												<td GCol="text,SDATBG"></td>
												<td GCol="text,STDLNR"></td>
												
												<td GCol="text,SSORNU"></td>
												<td GCol="text,SSORIT"></td>
												<td GCol="text,SMBLNR"></td>
												<td GCol="text,SZEILE"></td>
												<td GCol="text,SMJAHR"></td>
												<td GCol="text,SXBLNR"></td>
												<td GCol="text,SBKTXT"></td>
												<td GCol="text,AWMSNO"></td>
												<td GCol="text,CREDAT" GF="D"></td>
												<td GCol="text,CRETIM" GF="T"></td>
												
												<td GCol="text,CREUSR"></td>
												<td GCol="text,CUSRNM"></td>
												<td GCol="text,LMODAT" GF="D"></td>
												<td GCol="text,LMOTIM" GF="T"></td>
												<td GCol="text,LMOUSR"></td>
												<td GCol="text,LUSRNM"></td>
												
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
									<p class="record" GInfoArea="true">17 Record</p>
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