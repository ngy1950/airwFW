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
	    	id : "gridList1",
			editable : true,
			module : "Erpif",
			command : "IF01TAB_01"
	    }); 
	  	gridList.setGrid({
	    	id : "gridList2",
			editable : true,
			module : "Erpif",
			command : "IFWMS001",
			emptyMsgType : false
	    }); 
	   	gridList.setGrid({
	    	id : "gridList3",
			editable : true,
			module : "Erpif",
			command : "IFWMS002",
			emptyMsgType : false
	    });  
		gridList.setGrid({
	    	id : "gridList4",
			editable : true,
			module : "Erpif",
			command : "IFWMS005",
			emptyMsgType : false
	    }); 
		gridList.setGrid({
	    	id : "gridList5",
			editable : true,
			module : "Erpif",
			command : "IFWMS103",
			emptyMsgType : false
	    });    
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var credat = $('#CREDAT').val(); 
			var param = new DataMap();
			param.put("CREDAT", credat);
				
	 		gridList.gridList({
		    	id : "gridList1",
		    	param : param
		    });
		}
		
		$("#tab1").trigger('click'); 
	}
	
	function update(num){
		var credat = $('#CREDAT').val(); 
		var param = new DataMap();
		param.put("CREDAT", credat);
		param.put("num", num);
		
		var idx = num + 1;
		var json = netUtil.sendData({
			url : "/wms/admin/json/updateIF01.data",
			param : param
		});

		if(json && json.data){
			searchList();
		}
	}
	
 	function check(num){
		var credat = $('#CREDAT').val(); 
		var param = new DataMap();
		param.put("CREDAT", credat);
		param.put("num", num);
	
		var idx = num + 1;
		
		gridList.gridList({
	    	id : "gridList"+idx,
	    	command : "IF01CHK_0"+num,
	    	param : param
	    });
			
		$("#tab"+idx).trigger('click'); 
	} 
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Update1"){
			update(1);
		}else if(btnName == "Update2"){
			update(2);
		}else if(btnName == "Update3"){
			update(3);
		}else if(btnName == "Update4"){
			update(4);
		}else if(btnName == "Check1"){
			check(1);
		}else if(btnName == "Check2"){
			check(2);
		}else if(btnName == "Check3"){
			check(3);
		}else if(btnName == "Check4"){
			check(4);
		} 
	}
	
// 	function changeObject(){
// 		document.getElementById("")
// 	}

</script>
</head>
<!-- <body onload="changeObject()"> -->
<body>

<div class="contentHeader">
	<div class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<!-- TOP FieldSet -->
			<div class="foldSect" id="foldSect">
				<div class="tabs" id="bottomTabs">
				  <ul class="tab type2">
					<li><a href="#tabs-1"><span CL='STD_SAUFNR_TYP'></span></a></li>
				  </ul>
				  <div id="tabs-1">
					<div class="section type1">
						<table>
							<tbody>
								<tr>
									<td CL="STD_IFDATE"></td>
									<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
									<td>
										<input type="text" name="CREDAT" id="CREDAT" UIFormat="C N" validate="required" />
									</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td style="padding: 3px; size:100px" colspan="3"> <!-- bgcolor="#5f6062" -->
										<button CB="Update1 SEARCH BTN_SKUERR"></button>
									</td>
									<td>&nbsp;</td>
									<td>
										<button CB="Check1 SEARCH BTN_SKUERC"></button>
									</td>
								</tr>
								<tr>
									<td style="padding: 3px; size:100px" colspan="3">
										<button CB="Update2 SEARCH BTN_PTNERR"></button>
									</td>
									<td>&nbsp;</td>
									<td>
										<button CB="Check2 SEARCH BTN_PTNERC"></button>
									</td>
								</tr>
								<tr>
									<td style="padding: 3px; size:100px" colspan="3">
										<button CB="Update3 SEARCH BTN_BUYERR"></button>
									</td>
									<td>&nbsp;</td>
									<td>
										<button CB="Check3 SEARCH BTN_BUYERC"></button>
									</td>
								</tr>
								<tr>
									<td style="padding: 3px; size:100px" colspan="3">
										<button CB="Update4 SEARCH BTN_INBERR"></button>
									</td>
									<td>&nbsp;</td>
									<td>
										<button CB="Check4 SEARCH BTN_INBERC"></button>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				  </div>
				</div>
			</div>
			
			<!-- BOTTOM FieldSet -->
			<div class="bottomSect" style="top:225px;">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" id="tab1"><span CL='STD_LIST'></span></a></li>
						<li><a href="#tabs1-2" id="tab2"><span CL='STD_IFWMS001'>IFWMS001</span></a></li>
						<li><a href="#tabs1-3" id="tab3"><span CL='STD_IFWMS002'>IFWMS002</span></a></li>
						<li><a href="#tabs1-4" id="tab4"><span CL='STD_IFWMS005'>IFWMS005</span></a></li>
						<li><a href="#tabs1-5" id="tab5"><span CL='STD_IFWMS103'>IFWMS103</span></a></li>
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
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='MENU_IFCATE'></th>
												<th CL='STD_IFTABLE'></th>
												<th CL='STD_TOTCOUNT'></th> <!-- 총건수 -->
												<th CL='ITF_NOTCNT'></th> <!-- 미처리건수 -->
												<th CL='ITF_GODCNT'></th> <!-- 정상처리건수 -->
												<th CL='ITF_PRCQTY'></th>
												<th CL='ITF_ERRQTY'></th>
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
										</colgroup>
										<tbody id="gridList1">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,IFTYPE"></td>
												<td GCol="text,IFTABL" ></td>
												<td GCol="text,CNTTOT" ></td>
												<td GCol="text,CNTNOT"></td>
												<td GCol="text,CNTCMP"></td>
												<td GCol="text,CNTING"></td>
												<td GCol="text,CNTERR"></td>
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
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div> <!-- tab1-1 End -->
					<!-- tab1-2 Start -->
					<div id="tabs1-2">
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_IF001_MANDT'></th>
												<th CL='STD_IF001_SEQNO'></th>
												<th CL='STD_IF001_MATNR'></th>
												<th CL='STD_IF001_WERKS'></th>
												<th CL='STD_IF001_LGORT'></th>
												<th CL='STD_IF001_MAKTX_K'></th>
												<th CL='STD_IF001_MAKTX_E'></th>
												<th CL='STD_IF001_MAKTX_C'></th>
												<th CL='STD_IF001_MTART'></th>
												<th CL='STD_IF001_MTBEZ'></th>
												<th CL='STD_IF001_MEINS'></th>
												<th CL='STD_IF001_MATKL'></th>
												<th CL='STD_IF001_GROES'></th>
												<th CL='STD_IF001_NTGEW'></th>
												<th CL='STD_IF001_BRGEW'></th>
												<th CL='STD_IF001_GEWEI'></th>
												<th CL='STD_IF001_MVGR2'></th>
												<th CL='STD_IF001_BEZEI2'></th>
												<th CL='STD_IF001_MVGR3'></th>
												<th CL='STD_IF001_BEZEI3'></th>
												<th CL='STD_IF001_UMREZ'></th>
												<th CL='STD_IF001_LVORM'></th>
												<th CL='STD_IF001_TDATE'></th>
												<th CL='STD_IF001_CDATE'></th>
												<th CL='STD_IF001_IFFLG'></th>
												<th CL='STD_IF001_ERTXT'></th>
												<th CL='STD_IF001_SKUKEY'></th>
												<th CL='STD_IF001_DESC01'></th>
												<th CL='STD_IF001_DESC02'></th>
												<th CL='STD_IF001_EANCOD'></th>
												<th CL='STD_IF001_GTINCD'></th>
												<th CL='STD_IF001_NETPR'></th>
												<th CL='STD_IF001_MHDHB'></th>
												<th CL='STD_IF001_CREDAT'></th>
												<th CL='STD_IF001_CRETIM'></th>
												<th CL='STD_IF001_LMODAT'></th>
												<th CL='STD_IF001_LMOTIM'></th>
												<th CL='STD_IF001_ORDTRM'></th>
												<th CL='STD_IF001_LEADTM'></th>
												<th CL='STD_IF001_SEPRGB'></th>
												<th CL='STD_IF001_SNPTYP'></th>
												<th CL='STD_IF001_USER_ID'></th>
												<th CL='STD_IF001_USER_NAME'></th>
												<th CL='STD_IF001_CELL_PHONE_NO'></th>
												<th CL='STD_IF001_TEL_NO'></th>
												<th CL='STD_IF001_EMAIL_NO1'></th>
												<th CL='STD_IF001_EMAIL_NO2'></th>
												<th CL='STD_IF001_ERCNT'></th>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridList2">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,MANDT"></td>
												<td GCol="text,SEQNO"></td>
												<td GCol="text,MATNR"></td>
												<td GCol="text,WERKS"></td>
												<td GCol="text,LGORT"></td>
												<td GCol="text,MAKTX_K"></td>
												<td GCol="text,MAKTX_E"></td>
												<td GCol="text,MAKTX_C"></td>
												<td GCol="text,MTART"></td>
												<td GCol="text,MTBEZ"></td>
												<td GCol="text,MEINS"></td>
												<td GCol="text,MATKL"></td>
												<td GCol="text,GROES"></td>
												<td GCol="text,NTGEW"></td>
												<td GCol="text,BRGEW"></td>
												<td GCol="text,GEWEI"></td>
												<td GCol="text,MVGR2"></td>
												<td GCol="text,BEZEI2"></td>
												<td GCol="text,MVGR3"></td>
												<td GCol="text,BEZEI3"></td>
												<td GCol="text,UMREZ"></td>
												<td GCol="text,LVORM"></td>
												<td GCol="text,TDATE"></td>
												<td GCol="text,CDATE"></td>
												<td GCol="text,IFFLG"></td>
												<td GCol="text,ERTXT"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,DESC01"></td>
												<td GCol="text,DESC02"></td>
												<td GCol="text,EANCOD"></td>
												<td GCol="text,GTINCD"></td>
												<td GCol="text,NETPR"></td>
												<td GCol="text,MHDHB"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,ORDTRM"></td>
												<td GCol="text,LEADTM"></td>
												<td GCol="text,SEPRGB"></td>
												<td GCol="text,SNPTYP"></td>
												<td GCol="text,USER_ID"></td>
												<td GCol="text,USER_NAME"></td>
												<td GCol="text,CELL_PHONE_NO"></td>
												<td GCol="text,TEL_NO"></td>
												<td GCol="text,EMAIL_NO1"></td>
												<td GCol="text,EMAIL_NO2"></td>
												<td GCol="text,ERCNT"></td>
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
					<div id="tabs1-3">
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
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'></th>
												<th CL='STD_IF002_MANDT'></th>
												<th CL='STD_IF002_SEQNO'></th>
												<th CL='STD_IF002_ZCLASSIFIER'></th>
												<th CL='STD_IF002_ZCODE'></th>
												<th CL='STD_IF002_NAME1'></th>
												<th CL='STD_IF002_PSTLZ'></th>
												<th CL='STD_IF002_LAND1'></th>
												<th CL='STD_IF002_TELF1'></th>
												<th CL='STD_IF002_TELF2'></th>
												<th CL='STD_IF002_TELFX'></th>
												<th CL='STD_IF002_SMTP_ADDR'></th>
												<th CL='STD_IF002_STCD2'></th>
												<th CL='STD_IF002_J_1KFREPRE'></th>
												<th CL='STD_IF002_ERDAT'></th>
												<th CL='STD_IF002_AEDAT'></th>
												<th CL='STD_IF002_LOEVM'></th>
												<th CL='STD_IF002_TDATE'></th>
												<th CL='STD_IF002_CDATE'></th>
												<th CL='STD_IF002_IFFLG'></th>
												<th CL='STD_IF002_ERTXT'></th>
												<th CL='STD_IF002_ADDR'></th>
												<th CL='STD_IF002_ADDR2'></th>
												<th CL='STD_IF002_ADDR3'></th>
												<th CL='STD_IF002_ADDR4'></th>
												<th CL='STD_IF002_ADDR5'></th>
												<th CL='STD_IF002_STRAS'></th>
												<th CL='STD_IF002_ORT01'></th>
												<th CL='STD_IF002_CNAME'></th>
												<th CL='STD_IF002_CPHON'></th>
												<th CL='STD_IF002_BNAME'></th>
												<th CL='STD_IF002_BPHON'></th>
												<th CL='STD_IF002_CREDAT'></th>
												<th CL='STD_IF002_CRETIM'></th>
												<th CL='STD_IF002_LMODAT'></th>
												<th CL='STD_IF002_LMOTIM'></th>
												<th CL='STD_IF002_WERKS'></th>
												<th CL='STD_IF002_ORT02'></th>
												<th CL='STD_IF002_ORT03'></th>
												<th CL='STD_IF002_ERCNT'></th>
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
										</colgroup>
										<tbody id="gridList3">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,MANDT"></td>
												<td GCol="text,SEQNO"></td>
												<td GCol="text,ZCLASSIFIER"></td>
												<td GCol="text,ZCODE"></td>
												<td GCol="text,NAME1"></td>
												<td GCol="text,PSTLZ"></td>
												<td GCol="text,LAND1"></td>
												<td GCol="text,TELF1"></td>
												<td GCol="text,TELF2"></td>
												<td GCol="text,TELFX"></td>
												<td GCol="text,SMTP_ADDR"></td>
												<td GCol="text,STCD2"></td>
												<td GCol="text,J_1KFREPRE"></td>
												<td GCol="text,ERDAT"></td>
												<td GCol="text,AEDAT"></td>
												<td GCol="text,LOEVM"></td>
												<td GCol="text,TDATE"></td>
												<td GCol="text,CDATE"></td>
												<td GCol="text,IFFLG"></td>
												<td GCol="text,ERTXT"></td>
												<td GCol="text,ADDR"></td>
												<td GCol="text,ADDR2"></td>
												<td GCol="text,ADDR3"></td>
												<td GCol="text,ADDR4"></td>
												<td GCol="text,ADDR5"></td>
												<td GCol="text,STRAS"></td>
												<td GCol="text,ORT01"></td>
												<td GCol="text,CNAME"></td>
												<td GCol="text,CPHON"></td>
												<td GCol="text,BNAME"></td>
												<td GCol="text,BPHON"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,WERKS"></td>
												<td GCol="text,ORT02"></td>
												<td GCol="text,ORT03"></td>
												<td GCol="text,ERCNT"></td>
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
					<div id="tabs1-4">
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
												<th CL='STD_IF005_MANDT'></th>
												<th CL='STD_IF005_SEQNO'></th>
												<th CL='STD_IF005_MATNR'></th>
												<th CL='STD_IF005_WERKS'></th>
												<th CL='STD_IF005_MAKTX_K'></th>
												<th CL='STD_IF005_MAKTX_E'></th>
												<th CL='STD_IF005_MAKTX_C'></th>
												<th CL='STD_IF005_BEZEI2'></th>
												<th CL='STD_IF005_LVORM'></th>
												<th CL='STD_IF005_TDATE'></th>
												<th CL='STD_IF005_CDATE'></th>
												<th CL='STD_IF005_IFFLG'></th>
												<th CL='STD_IF005_ERTXT'></th>
												<th CL='STD_IF005_SKUKEY'></th>
												<th CL='STD_IF005_COMPY'></th>
												<th CL='STD_IF005_PLANT'></th>
												<th CL='STD_IF005_ERCNT'></th>
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
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
											<col width="100" />
										</colgroup>
										<tbody id="gridList4">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,MANDT"></td>
												<td GCol="text,SEQNO"></td>
												<td GCol="text,MATNR"></td>
												<td GCol="text,WERKS"></td>
												<td GCol="text,MAKTX_K"></td>
												<td GCol="text,MAKTX_E"></td>
												<td GCol="text,MAKTX_C"></td>
												<td GCol="text,BEZEI2"></td>
												<td GCol="text,LVORM"></td>
												<td GCol="text,TDATE"></td>
												<td GCol="text,CDATE"></td>
												<td GCol="text,IFFLG"></td>
												<td GCol="text,ERTXT"></td>
												<td GCol="text,SKUKEY"></td>
												<td GCol="text,COMPY"></td>
												<td GCol="text,PLANT"></td>
												<td GCol="text,ERCNT"></td>
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
					<div id="tabs1-5">
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
										</colgroup>
										<thead>
											<tr>
											    <th CL='STD_NUMBER'></th>
												<th CL='STD_IF103_MANDT'></th>
												<th CL='STD_IF103_SEQNO'></th>
												<th CL='STD_IF103_EBELN'></th>
												<th CL='STD_IF103_EBELP'></th>
												<th CL='STD_IF103_LIFNR'></th>
												<th CL='STD_IF103_BWART'></th>
												<th CL='STD_IF103_BEDAT'></th>
												<th CL='STD_IF103_ZEKKO_AEDAT'></th>
												<th CL='STD_IF103_LOEKZ'></th>
												<th CL='STD_IF103_MATNR'></th>
												<th CL='STD_IF103_MAKTX_K'></th>
												<th CL='STD_IF103_MAKTX_E'></th>
												<th CL='STD_IF103_MAKTX_C'></th>
												<th CL='STD_IF103_MENGE'></th>
												<th CL='STD_IF103_MEINS'></th>
												<th CL='STD_IF103_WERKS'></th>
												<th CL='STD_IF103_LGORT'></th>
												<th CL='STD_IF103_EINDT'></th>
												<th CL='STD_IF103_ZEKPO_AEDAT'></th>
												<th CL='STD_IF103_MENGE_B'></th>
												<th CL='STD_IF103_MENGE_R'></th>
												<th CL='STD_IF103_BWTAR'></th>
												<th CL='STD_IF103_VGBEL'></th>
												<th CL='STD_IF103_VGPOS'></th>
												<th CL='STD_IF103_VGDAT'></th>
												<th CL='STD_IF103_ELIKZ'></th>
												<th CL='STD_IF103_STATUS'></th>
												<th CL='STD_IF103_TDATE'></th>
												<th CL='STD_IF103_CDATE'></th>
												<th CL='STD_IF103_IFFLG'></th>
												<th CL='STD_IF103_ERTXT'></th>
												<th CL='STD_IF103_WAREKY'></th>
												<th CL='STD_IF103_SKUKEY'></th>
												<th CL='STD_IF103_DESC01'></th>
												<th CL='STD_IF103_DESC02'></th>
												<th CL='STD_IF103_USRID1'></th>
												<th CL='STD_IF103_DEPTID1'></th>
												<th CL='STD_IF103_USRID2'></th>
												<th CL='STD_IF103_DEPTID2'></th>
												<th CL='STD_IF103_USRID3'></th>
												<th CL='STD_IF103_DEPTID3'></th>
												<th CL='STD_IF103_USRID4'></th>
												<th CL='STD_IF103_DEPTID4'></th>
												<th CL='STD_IF103_CREDAT'></th>
												<th CL='STD_IF103_CRETIM'></th>
												<th CL='STD_IF103_LMODAT'></th>
												<th CL='STD_IF103_LMOTIM'></th>
												<th CL='STD_IF103_MBLNO'></th>
												<th CL='STD_IF103_MIPNO'></th>
												<th CL='STD_IF103_C00101'></th>
												<th CL='STD_IF103_C00102'></th>
												<th CL='STD_IF103_C00103'></th>
												<th CL='STD_IF103_C00104'></th>
												<th CL='STD_IF103_C00105'></th>
												<th CL='STD_IF103_C00106'></th>
												<th CL='STD_IF103_C00107'></th>
												<th CL='STD_IF103_C00108'></th>
												<th CL='STD_IF103_C00109'></th>
												<th CL='STD_IF103_C00110'></th>
												<th CL='STD_IF103_N00101'></th>
												<th CL='STD_IF103_N00102'></th>
												<th CL='STD_IF103_N00103'></th>
												<th CL='STD_IF103_N00104'></th>
												<th CL='STD_IF103_N00105'></th>
												<th CL='STD_IF103_N00106'></th>
												<th CL='STD_IF103_N00107'></th>
												<th CL='STD_IF103_N00108'></th>
												<th CL='STD_IF103_N00109'></th>
												<th CL='STD_IF103_N00110'></th>
												<th CL='STD_IF103_TRANS_DIV'></th>
												<th CL='STD_IF103_GR_DLV_CNTR_CODE'></th>
												<th CL='STD_IF103_GI_DLV_CNTR_CODE'></th>
												<th CL='STD_IF103_BUYER_NAME'></th>
												<th CL='STD_IF103_BUYER_PLANT_NAME'></th>
												<th CL='STD_IF103_BUYER_DIVISION'></th>
												<th CL='STD_IF103_BUYER_DIVISION_NAME'></th>
												<th CL='STD_IF103_BUYER_DEPT'></th>
												<th CL='STD_IF103_BUYER_DEPT_NAME'></th>
												<th CL='STD_IF103_BUYER_CHRG_ID'></th>
												<th CL='STD_IF103_BUYER_CHRG_NAME'></th>
												<th CL='STD_IF103_CELL_PHONE_NO'></th>
												<th CL='STD_IF103_TEL_NO'></th>
												<th CL='STD_IF103_TOV_CHRG_ID'></th>
												<th CL='STD_IF103_TOV_CHRG_NAME'></th>
												<th CL='STD_IF103_TOV_CHRG_TEL_NO'></th>
												<th CL='STD_IF103_TOV_CHRG_CELL_PHONE_NO'></th>
												<th CL='STD_IF103_TRANSPORT_TYPE'></th>
												<th CL='STD_IF103_BOX_CNT'></th>
												<th CL='STD_IF103_WAYBILL_ID'></th>
												<th CL='STD_IF103_REQ_CONT'></th>
												<th CL='STD_IF103_INVOICE_DESCRIPTION'></th>
												<th CL='STD_IF103_BOX_NO'></th>
												<th CL='STD_IF103_ERCNT'></th>
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
										</colgroup>
										<tbody id="gridList5">
											<tr CGRow="true">
												<td GCol="rownum"></td>
												<td GCol="text,MANDT"></td>                 
												<td GCol="text,SEQNO"></td>                 
												<td GCol="text,EBELN"></td>                 
												<td GCol="text,EBELP"></td>                 
												<td GCol="text,LIFNR"></td>                  
												<td GCol="text,BWART"></td>                  
												<td GCol="text,BEDAT"></td>                  
												<td GCol="text,ZEKKO_AEDAT"></td>            
												<td GCol="text,LOEKZ"></td>                 
												<td GCol="text,MATNR"></td>                 
												<td GCol="text,MAKTX_K"></td>               
												<td GCol="text,MAKTX_E"></td>               
												<td GCol="text,MAKTX_C"></td>               
												<td GCol="text,MENGE"></td>                  
												<td GCol="text,MEINS"></td>                  
												<td GCol="text,WERKS"></td>                  
												<td GCol="text,LGORT"></td>                  
												<td GCol="text,EINDT"></td>                  
												<td GCol="text,ZEKPO_AEDAT"></td>            
												<td GCol="text,MENGE_B"></td>                
												<td GCol="text,MENGE_R"></td>                
												<td GCol="text,BWTAR"></td>                 
												<td GCol="text,VGBEL"></td>                 
												<td GCol="text,VGPOS"></td>                 
												<td GCol="text,VGDAT"></td>                 
												<td GCol="text,ELIKZ"></td>                 
												<td GCol="text,STATUS"></td>                 
												<td GCol="text,TDATE"></td>                  
												<td GCol="text,CDATE"></td>                  
												<td GCol="text,IFFLG"></td>                  
												<td GCol="text,ERTXT"></td>                  
												<td GCol="text,WAREKY"></td>                 
												<td GCol="text,SKUKEY"></td>                 
												<td GCol="text,DESC01"></td>                 
												<td GCol="text,DESC02"></td>                 
												<td GCol="text,USRID1"></td>                 
												<td GCol="text,DEPTID1"></td>                
												<td GCol="text,USRID2"></td>                 
												<td GCol="text,DEPTID2"></td>                
												<td GCol="text,USRID3"></td>                 
												<td GCol="text,DEPTID3"></td>                
												<td GCol="text,USRID4"></td>                 
												<td GCol="text,DEPTID4"></td>                
												<td GCol="text,CREDAT"></td>                 
												<td GCol="text,CRETIM"></td>                 
												<td GCol="text,LMODAT"></td>                 
												<td GCol="text,LMOTIM"></td>                 
												<td GCol="text,MBLNO"></td>                  
												<td GCol="text,MIPNO"></td>                  
												<td GCol="text,C00101"></td>                 
												<td GCol="text,C00102"></td>                 
												<td GCol="text,C00103"></td>                 
												<td GCol="text,C00104"></td>                 
												<td GCol="text,C00105"></td>                 
												<td GCol="text,C00106"></td>                 
												<td GCol="text,C00107"></td>                 
												<td GCol="text,C00108"></td>                 
												<td GCol="text,C00109"></td>                 
												<td GCol="text,C00110"></td>                 
												<td GCol="text,N00101"></td>                 
												<td GCol="text,N00102"></td>                 
												<td GCol="text,N00103"></td>                 
												<td GCol="text,N00104"></td>                 
												<td GCol="text,N00105"></td>                 
												<td GCol="text,N00106"></td>                 
												<td GCol="text,N00107"></td>                 
												<td GCol="text,N00108"></td>                 
												<td GCol="text,N00109"></td>                 
												<td GCol="text,N00110"></td>                 
												<td GCol="text,TRANS_DIV"></td>              
												<td GCol="text,GR_DLV_CNTR_CODE"></td>       
												<td GCol="text,GI_DLV_CNTR_CODE"></td>       
												<td GCol="text,BUYER_NAME"></td>             
												<td GCol="text,BUYER_PLANT_NAME"></td>       
												<td GCol="text,BUYER_DIVISION"></td>         
												<td GCol="text,BUYER_DIVISION_NAME"></td>    
												<td GCol="text,BUYER_DEPT"></td>             
												<td GCol="text,BUYER_DEPT_NAME"></td>        
												<td GCol="text,BUYER_CHRG_ID"></td>          
												<td GCol="text,BUYER_CHRG_NAME"></td>        
												<td GCol="text,CELL_PHONE_NO"></td>          
												<td GCol="text,TEL_NO"></td>                 
												<td GCol="text,TOV_CHRG_ID"></td>            
												<td GCol="text,TOV_CHRG_NAME"></td>          
												<td GCol="text,TOV_CHRG_TEL_NO"></td>        
												<td GCol="text,TOV_CHRG_CELL_PHONE_NO"></td> 
												<td GCol="text,TRANSPORT_TYPE"></td>         
												<td GCol="text,BOX_CNT"></td>                
												<td GCol="text,WAYBILL_ID"></td>             
												<td GCol="text,REQ_CONT"></td>               
												<td GCol="text,INVOICE_DESCRIPTION"></td>    
												<td GCol="text,BOX_NO"></td>                 
												<td GCol="text,ERCNT"></td> 
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
		<!-- //contentContainer -->

	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>