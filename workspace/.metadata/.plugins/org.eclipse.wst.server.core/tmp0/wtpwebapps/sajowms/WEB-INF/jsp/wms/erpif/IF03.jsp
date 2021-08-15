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
		$("input[UIInput='R']").parent('td').children('input').attr("size",10);
	 	
		gridList.setGrid({
	    	id : "gridList1",
	    	name : "gridList1",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "MANDT,SEQNO",
			module : "Erpif",
			command : "IF01TAB01"
	    }); 
	 	gridList.setGrid({
	    	id : "gridList2",
	    	name : "gridList2",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "MANDT,SEQNO",
			module : "Erpif",
			command : "IF01TAB02"
	    }); 
		gridList.setGrid({
	    	id : "gridList3",
	    	name : "gridList3",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "MANDT,SEQNO",
			module : "Erpif",
			command : "IF01TAB03"
	    }); 
		gridList.setGrid({
	    	id : "gridList4",
	    	name : "gridList4",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "MANDT,SEQNO",
			module : "Erpif",
			command : "IF01TAB04"
	    }); 
		gridList.setGrid({
	    	id : "gridList5",
	    	name : "gridList5",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "MANDT,SEQNO",
			module : "Erpif",
			command : "IF01TAB05"
	    }); 
		gridList.setGrid({
	    	id : "gridList6",
	    	name : "gridList6",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "MANDT,SEQNO",
			module : "Erpif",
			command : "IF01TAB06"
	    }); 
		gridList.setGrid({
	    	id : "gridList7",
	    	name : "gridList7",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "MANDT,SEQNO",
			module : "Erpif",
			command : "IF01TAB07"
	    }); 
		gridList.setGrid({
	    	id : "gridList8",
	    	name : "gridList8",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "MANDT,SEQNO",
			module : "Erpif",
			command : "IF01TAB08"
	    }); 
		gridList.setGrid({
	    	id : "gridList9",
	    	name : "gridList9",
			editable : true,
			checkHead : "gridListCheckHead",
			pkcol : "MANDT,SEQNO",
			module : "Erpif",
			command : "IF01TAB09"
	    }); 
		searchList();
	});
	
	function searchList(){
		var selectedIdx = "";
		selectedIdx = $("#IFTABLE option").index($("#IFTABLE option:selected")) + 1;
		
		$("a[id='tab0"+selectedIdx+"']").click();
		//var param = dataBind.paramData("searchArea");
		var param = inputList.setRangeParam("searchArea");
		gridList.gridList({
	    	id : "gridList1",
	    	param : param
	    });
		 gridList.gridList({
	    	id : "gridList2",
	    	param : param
	    });
		
		gridList.gridList({
	    	id : "gridList3",
	    	param : param
	    });
		gridList.gridList({
	    	id : "gridList4",
	    	param : param
	    });
		gridList.gridList({
	    	id : "gridList5",
	    	param : param
	    });
		gridList.gridList({
	    	id : "gridList6",
	    	param : param
	    });
		gridList.gridList({
	    	id : "gridList7",
	    	param : param
	    });
		gridList.gridList({
	    	id : "gridList8",
	    	param : param
	    });
		gridList.gridList({
	    	id : "gridList9",
	    	param : param
	    });
	}
	
	function saveData(){
		gridList.gridSave({
	    	id : "gridList"
	    }); 
	}
	
	function tabChg(num){
		var gridId = "gridList"+num;
		var param = dataBind.paramData("searchArea");
		
		gridList.gridList({
	    	id : gridId,
	    	param : param
	    });
	}
		
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button class="button type1" type="button"><img src="/common/images/ico_btn1.png" alt="Previous" /></button>
		<button class="button type1" type="button" onclick="saveData()"><img src="/common/images/ico_btn2.png" alt="Save" /></button>
		<button class="button type1 last" type="button"><img src="/common/images/ico_btn3.png" alt="Write" /></button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<!-- <div class="searchPop" id="searchArea">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="searchBtn"><input type="submit" class="button type1 widthAuto" value="검색" onclick="searchList()" CL="BTN_DISPLAY"/></p>
		<div class="searchInBox" >
			<h2 class="tit" CL="STD_SELECTOPTIONS">검색조건</h2>
			<table class="table type1">
				<colgroup>
					<col width="5%"/>
					<col width="10%"/>
					<col width="7%"/>
					<col width="19%"/>
					<col width="5%"/>
					<col width="19%"/>
					<col width="5%"/>
					<col width="17"/>
				</colgroup>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>

</div> -->
<!-- //searchPop -->

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<!-- TOP FieldSet -->
			<div class="foldSect" id="searchArea">
				<div class="tabs">
				  <ul class="tab type2">
					<li><a href="#tabs-1"><span CL='STD_GENERAL'>탭메뉴1</span></a></li>
				  </ul>
				  <div id="tabs-1">
					<div class="section type1">
						<table class="table type1">
							<colgroup>
								<col width="5%"/>
								<col width="10%"/>
								<col width="7%"/>
								<col width="19%"/>
								<col width="5%"/>
								<col width="19%"/>
								<col width="5%"/>
								<col width="17"/>
				   			</colgroup>
							<tbody>
								<tr>
									<th CL="STD_IFTABLE">I/F Table</th>
									<td colspan="3">
										<select name="IFTABLE" id="IFTABLE" CommonCombo="IFTABLE"></select>
										<input type="submit" class="button type1 widthAuto" value="검색" onclick="searchList()" CL="BTN_DISPLAY"/>
									</td>
									<th CL="STD_ERPPRC">처리여부</th>
									<td>
										<label for="y"><input type="checkbox" id="y" value="Y">Y</label>&nbsp;
										<label for="n"><input type="checkbox" id="n" value="N">N</label> 
									</td>
								</tr>
								<tr>
									<th CL="STD_WAREKY">거점</th>
									<td>
										<input type="text" name="WAREKY" UIInput="S" size="7" value="PMS0">
									</td>
									<th CL="STD_ERPDNO">ERP 문서번호</th>
									<td>
										<input type="text" name="ERPDNO" UIInput="R" style="width: 2px">
									</td>
									<th CL="STD_CREDAT">생성일자</th>
									<td>
										<input type="text" name="A.CDATE" UIInput="R">
									</td>
									<th CL="STD_RSTAIT">상태</th>
									<td>
										<input type="checkbox" name="RSTAIT" value="V"> WMS정상처리 &nbsp;
										<input type="checkbox" name="RSTAIT" value="V"> 미처리 &nbsp;
										<input type="checkbox" name="RSTAIT" value="V"> ERP정상처리 &nbsp;
										<input type="checkbox" name="RSTAIT" value="V"> ERP처리에러 &nbsp;
										<input type="checkbox" name="RSTAIT" value="V"> 삭제 &nbsp;
									</td>
								</tr>
								<tr>
									<th CL="STD_WERKS,3">회주</th>
									<td>
										<input type="text" name="WERKS" UIInput="S" size="7" value="CMAS">
									</td>
									<th CL="STD_WMSDNO">WMS 문서번호</th>
									<td>
										<input type="text" name="WMSDNO" UIInput="R" >
									</td>
									<th CL="STD_MATNR">품번코드</th>
									<td>
										<input type="text" name="A.MATNR" UIInput="R">
									</td>
									<th CL="STD_PTNRKY"></th>
									<td>
										<input type="text" name="PTNRKY" UIInput="R" >
									</td>
								</tr>
								<tr>
									<th></th>
									<td>
									</td>
									<th CL="ITF_BWART">이동 유형</th>
									<td>
										<input type="text" name="BWART" UIInput="R" >
									</td>
									<th CL="ITF_WADAT">납기요청일</th>
									<td>
										<input type="text" name="WADAT" UIInput="R">
									</td>
									<th></th>
									<td>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				  </div>
				</div>
			</div>
			
			<!-- BOTTOM FieldSet -->
			<div class="bottomSect">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" id="tab01" onclick="tabChg(1);"><span>IFWMS001</span></a></li>
						<li><a href="#tabs1-2" id="tab02" onclick="tabChg(2);"><span>IFWMS002</span></a></li>
						<li><a href="#tabs1-3" id="tab03" onclick="tabChg(3);"><span>IFWMS003</span></a></li>
						<li><a href="#tabs1-4" id="tab04" onclick="tabChg(4);"><span>IFWMS103</span></a></li>
						<li><a href="#tabs1-5" id="tab05" onclick="tabChg(5);"><span>IFWMS113</span></a></li>
						<li><a href="#tabs1-6" id="tab06" onclick="tabChg(6);"><span>IFWMS203</span></a></li>
						<li><a href="#tabs1-7" id="tab07" onclick="tabChg(7);"><span>IFWMS213</span></a></li>
						<li><a href="#tabs1-8" id="tab08" onclick="tabChg(8);"><span>IFWMS301</span></a></li>
						<li><a href="#tabs1-9" id="tab09" onclick="tabChg(9);"><span>IFWMS313</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="200" />
											<col width="120" />
											<col width="200" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>111</th>
												<!-- <th CL='ITF_MANDT'></th> -->
												<th CL='ITF_SEQNO,3'></th>
												<th CL='ITF_MATNR,3'></th>
												<th CL='ITF_WERKS,3'></th>
												<th CL='ITF_WERKSNM,3'></th>
												<th CL='ITF_LGORT,3'></th>
												<th CL='ITF_MAKTX_K,3'></th>
												<th CL='ITF_MAKTX_E,3'></th>
												<th CL='ITF_MAKTX_C,3'></th>
												<th CL='ITF_MTART,3'></th>
												<th CL='ITF_MTBEZ,3'></th>
												<th CL='ITF_MEINS,3'></th>
												<th CL='ITF_MATKL,3'></th>
												<th CL='ITF_GROES,3'></th>
												<th CL='ITF_NTGEW,3'></th>
												<th CL='ITF_BRGEW,3'></th>
												<th CL='ITF_GEWEI,3'></th>
												<th CL='ITF_MVGR2,3'></th>
												<th CL='ITF_BEZEI2,3'></th>
												<th CL='ITF_MVGR3,3'></th>
												<th CL='ITF_BEZEI3,3'></th>
												<th CL='ITF_UMREZ,3'></th>
												<th CL='ITF_LVORM,3'></th>
												<th CL='ITF_TDATE,3'></th>
												<th CL='ITF_CDATE,3'></th>
												<th CL='ITF_IFFLG,3'></th>
												<th CL='ITF_ERTXT,3'></th>
												<th CL='ITF_SKUKEY,3'></th>
												<th CL='ITF_DESC01,3'></th>
												<th CL='ITF_DESC02,3'></th>
												<th CL='ITF_EANCOD,3'></th>
												<th CL='ITF_GTINCD,3'></th>
												<th CL='ITF_NETPR,3'></th>
												<th CL='ITF_MHDHB,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CRETIM,3'></th>
												<th CL='STD_CREUSR,3'></th>
												<th CL='STD_LMODAT,3'></th>
												<th CL='STD_LMOTIM,3'></th>
												<th CL='STD_LMOUSR,3'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="200" />
											<col width="120" />
											<col width="200" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup> 
										<tbody id="gridList1">
											<tr CGRow="true">
												<td GCol="text,MANDT"></td>
												<td GCol="text,SEQNO"></td>
												<td GCol="text,MATNR"></td>
												<td GCol="text,WERKS"></td>
												<td GCol="text,WERKSNM"></td>
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
												<td GCol="text,MVGR2"></td>
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
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button class="button type4" type="button"><img src="/common/images/ico_btn5.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn6.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn7.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn8.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn9.png" alt="" /></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
					
					<div id="tabs1-2">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<thead>
											<tr>
												<th CL="STD_NUMBER">22</th>
												<!-- <th CL='ITF_MANDT'></th> -->
												<th CL='ITF_SEQNO,3'></th>
												<th CL='ITF_ZCLASSIFIER,3'></th>
												<th CL='ITF_ZCODE,3'></th>
												<th CL='ITF_NAME1,3'></th>
												<th CL='ITF_PSTLZ,3'></th>
												<th CL='ITF_LAND1,3'></th>
												<th CL='ITF_TELF1,3'></th>
												<th CL='ITF_TELF2,3'></th>
												<th CL='ITF_TELFX,3'></th>
												<th CL='ITF_SMTP_ADDR,3'></th>
												<th CL='ITF_STCD2,3'></th>
												<th CL='ITF_J_1KFREPRE,3'></th>
												<th CL='ITF_ERDAT,3'></th>
												<th CL='ITF_AEDAT,3'></th>
												<th CL='ITF_LOEVM,3'></th>
												<th CL='ITF_TDATE,3'></th>
												<th CL='ITF_CDATE,3'></th>
												<th CL='ITF_IFFLG,3'></th>
												<th CL='ITF_ERTXT,3'></th>
												<th CL='ITF_ADDR,3'></th>
												<th CL='ITF_ADDR2,3'></th>
												<th CL='ITF_ADDR3,3'></th>
												<th CL='ITF_ADDR4,3'></th>
												<th CL='ITF_ADDR5,3'></th>
												<th CL='ITF_STRAS,3'></th>
												<th CL='ITF_ORT01,3'></th>
												<th CL='ITF_CNAME,3'></th>
												<th CL='ITF_CPHON,3'></th>
												<th CL='ITF_BNAME,3'></th>
												<th CL='ITF_BPHON,3'></th>
												<th CL='ITF_WERKS,3'></th>
												<th CL='ITF_WERKSNM,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<tbody id="gridList2">
											<tr CGRow="true">
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
												<td GCol="text,WERKS"></td>
												<td GCol="text,WERKSNM"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button class="button type4" type="button"><img src="/common/images/ico_btn5.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn6.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn7.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn8.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn9.png" alt="" /></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
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
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>333</th>
												<!-- <th CL='ITF_MANDT'></th> -->
												<th CL='ITF_SEQNO,3'></th>
												<th CL='ITF_ZCLASSIFIER,3'></th>
												<th CL='ITF_ZCODE,3'></th>
												<th CL='ITF_ZCODE_1,3'></th>
												<th CL='ITF_NAME1,3'></th>
												<th CL='ITF_DTGPC,3'></th>
												<th CL='ITF_DTGPN,3'></th>
												<th CL='ITF_LVORM,3'></th>
												<th CL='ITF_TDATE,3'></th>
												<th CL='ITF_CDATE,3'></th>
												<th CL='ITF_IFFLG,3'></th>
												<th CL='ITF_ERTXT,3'></th>
												<th CL='ITF_ADDR,3'></th>
												<th CL='ITF_STATUS,3'></th>
												<th CL='ITF_WERKS,3'></th>
												<th CL='ITF_WERKSNM,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<tbody id="gridList3">
											<tr CGRow="true">
												<td GCol="text,MANDT"></td>
												<td GCol="text,SEQNO"></td>
												<td GCol="text,ZCLASSIFIER"></td>
												<td GCol="text,ZCODE"></td>
												<td GCol="text,ZCODE_1"></td>
												<td GCol="text,NAME1"></td>
												<td GCol="text,DTGPC"></td>
												<td GCol="text,DTGPN"></td>
												<td GCol="text,LVORM"></td>
												<td GCol="text,TDATE"></td>
												<td GCol="text,CDATE"></td>
												<td GCol="text,IFFLG"></td>
												<td GCol="text,ERTXT"></td>
												<td GCol="text,ADDR"></td>
												<td GCol="text,STATUS"></td>
												<td GCol="text,WERKS"></td>
												<td GCol="text,WERKSNM"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button class="button type4" type="button"><img src="/common/images/ico_btn5.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn6.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn7.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn8.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn9.png" alt="" /></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
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
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>444</th>
												<!-- <th CL='ITF_MANDT'></th> -->
												<th CL='ITF_SEQNO,3'></th>
												<th CL='ITF_EBELN,3'></th>
												<th CL='ITF_EBELP,3'></th>
												<th CL='ITF_LIFNR,3'></th>
												<th CL='ITF_BWART,3'></th>
												<th CL='ITF_BEDAT,3'></th>
												<th CL='ITF_ZEKKO_AEDAT,3'></th>
												<th CL='ITF_LOEKZ,3'></th>
												<th CL='ITF_MATNR,3'></th>
												<th CL='ITF_MAKTX_K,3'></th>
												<th CL='ITF_MAKTX_E,3'></th>
												<th CL='ITF_MAKTX_C,3'></th>
												<th CL='ITF_MENGE,3'></th>
												<th CL='ITF_MEINS,3'></th>
												<th CL='ITF_WERKS,3'></th>
												<th CL='ITF_LGORT,3'></th>
												<th CL='ITF_EINDT,3'></th>
												<th CL='ITF_ZEKPO_AEDAT,3'></th>
												<th CL='ITF_MENGE_B,3'></th>
												<th CL='ITF_MENGE_R,3'></th>
												<th CL='ITF_BWTAR,3'></th>
												<th CL='ITF_VGBEL,3'></th>
												<th CL='ITF_VGPOS,3'></th>
												<th CL='ITF_VGDAT,3'></th>
												<th CL='ITF_ELIKZ,3'></th>
												<th CL='ITF_STATUS,3'></th>
												<th CL='ITF_TDATE,3'></th>
												<th CL='ITF_CDATE,3'></th>
												<th CL='ITF_ERTXT,3'></th>
												<th CL='ITF_IFFLG,3'></th>
												<th CL='ITF_ERTXT,3'></th>
												<th CL='ITF_WAREKY,3'></th>
												<th CL='ITF_SKUKEY,3'></th>
												<th CL='ITF_DESC01,3'></th>
												<th CL='ITF_DESC02,3'></th>
												<th CL='ITF_USRID1,3'></th>
												<th CL='ITF_DEPTID1,3'></th>
												<th CL='ITF_USRID2,3'></th>
												<th CL='ITF_DEPTID2,3'></th>
												<th CL='ITF_USRID3,3'></th>
												<th CL='ITF_DEPTID,3'></th>
												<th CL='ITF_USRID,3'></th>
												<th CL='ITF_DEPTID4,3'></th>
												<th CL='ITF_MBLNO,3'></th>
												<th CL='ITF_MIPNO,3'></th>
												<th CL='ITF_C00101,3'></th>
												<th CL='ITF_C00102,3'></th>
												<th CL='ITF_C00103,3'></th>
												<th CL='ITF_C00104,3'></th>
												<th CL='ITF_C00105,3'></th>
												<th CL='ITF_N00101,3'></th>
												<th CL='ITF_N00102,3'></th>
												<th CL='ITF_LIFNRNM,3'></th>
												<th CL='ITF_BWARTNM,3'></th>
												<th CL='ITF_WERKSNM,3'></th>
												<th CL='ITF_LGORTNM,3'></th>
												<th CL='ITF_BWTARNM,3'></th>
												<th CL='ITF_WAREKYNM,3'></th>
												<th CL='ITF_C00104NM,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<tbody id="gridList4">
											<tr CGRow="true">
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
												<td GCol="text,ERTXT"></td>
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
												<td GCol="text,DEPTID"></td>
												<td GCol="text,USRID"></td>
												<td GCol="text,DEPTID4"></td>
												<td GCol="text,MBLNO"></td>
												<td GCol="text,MIPNO"></td>
												<td GCol="text,C00101"></td>
												<td GCol="text,C00102"></td>
												<td GCol="text,C00103"></td>
												<td GCol="text,C00104"></td>
												<td GCol="text,C00105"></td>
												<td GCol="text,N00101"></td>
												<td GCol="text,N00102"></td>
												<td GCol="text,LIFNRNM"></td>
												<td GCol="text,BWARTNM"></td>
												<td GCol="text,WERKSNM"></td>
												<td GCol="text,LGORTNM"></td>
												<td GCol="text,BWTARNM"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,C00104NM"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button class="button type4" type="button"><img src="/common/images/ico_btn5.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn6.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn7.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn8.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn9.png" alt="" /></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
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
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>555</th>
												<!-- <th CL='ITF_MANDT'></th> -->
												<th CL='ITF_SEQNO,3'></th>
												<th CL='ITF_VBELN,3'></th>
												<th CL='ITF_POSNR,3'></th>
												<th CL='ITF_BWART,3'></th>
												<th CL='ITF_PSTYV,3'></th>
												<th CL='ITF_ZLIKP_ERDAT,3'></th>
												<th CL='ITF_ZLIKP_ERZET,3'></th>
												<th CL='ITF_ZLIKP_AEDAT,3'></th>
												<th CL='ITF_VSTEL,3'></th>
												<th CL='ITF_LFART,3'></th>
												<th CL='ITF_WADAT,3'></th>
												<th CL='ITF_KUNNR,3'></th>
												<th CL='ITF_KUNAG,3'></th>
												<th CL='ITF_WERKS,3'></th>
												<th CL='ITF_LGORT,3'></th>
												<th CL='ITF_MATNR,3'></th>
												<th CL='ITF_LFIMG,3'></th>
												<th CL='ITF_QTSHP,3'></th>
												<th CL='ITF_MEINS,3'></th>
												<th CL='ITF_NETPR,3'></th>
												<th CL='ITF_NETWR,3'></th>
												<th CL='ITF_MWSBP,3'></th>
												<th CL='ITF_MWSDC,3'></th>
												<th CL='ITF_WAERK,3'></th>
												<th CL='ITF_BWTAR,3'></th>
												<th CL='ITF_VGBEL,3'></th>
												<th CL='ITF_VGPOS,3'></th>
												<th CL='ITF_VGDAT,3'></th>
												<th CL='ITF_STKNUM,3'></th>
												<th CL='ITF_SDATBG,3'></th>
												<th CL='ITF_STATUS,3'></th>
												<th CL='ITF_TDATE,3'></th>
												<th CL='ITF_CDATE,3'></th>
												<th CL='ITF_IFFLG,3'></th>
												<th CL='ITF_RETRY,3'></th>
												<th CL='ITF_ERCOD,3'></th>
												<th CL='ITF_ERTXT,3'></th>
												<th CL='ITF_CUSRID,3'></th>
												<th CL='ITF_CUNAME,3'></th>
												<th CL='ITF_CPSTLZ,3'></th>
												<th CL='ITF_LAND1,3'></th>
												<th CL='ITF_TELF1,3'></th>
												<th CL='ITF_TELE2,3'></th>
												<th CL='ITF_SMTP_ADDR,3'></th>
												<th CL='ITF_KUKLA,3'></th>
												<th CL='ITF_VTEXT,3'></th>
												<th CL='ITF_ADDR,3'></th>
												<th CL='ITF_CNAME,3'></th>
												<th CL='ITF_CPHON,3'></th>
												<th CL='ITF_BNAME,3'></th>
												<th CL='ITF_BPHON,3'></th>
												<th CL='ITF_WAREKY,3'></th>
												<th CL='ITF_SKUKEY,3'></th>
												<th CL='ITF_DESC01,3'></th>
												<th CL='ITF_DESC02,3'></th>
												<th CL='ITF_USRID1,3'></th>
												<th CL='ITF_DEPTID1,3'></th>
												<th CL='ITF_USRID2,3'></th>
												<th CL='ITF_DEPTID2,3'></th>
												<th CL='ITF_USRID3,3'></th>
												<th CL='ITF_DEPTID3,3'></th>
												<th CL='ITF_USRID4,3'></th>
												<th CL='ITF_DEPTID4,3'></th>
												<th CL='ITF_C0010,3'></th>
												<th CL='ITF_C00102,3'></th>
												<th CL='ITF_C00103,3'></th>
												<th CL='ITF_C00104,3'></th>
												<th CL='ITF_C00105,3'></th>
												<th CL='ITF_N00101,3'></th>
												<th CL='ITF_N00102,3'></th>
												<th CL='ITF_BWARTNM,3'></th>
												<th CL='ITF_PSTYVNM,3'></th>
												<th CL='ITF_KUNAGNM,3'></th>
												<th CL='ITF_WERKSNM,3'></th>
												<th CL='ITF_LGORTNM,3'></th>
												<th CL='ITF_MATNRNM,3'></th>
												<th CL='ITF_BWTARNM,3'></th>
												<th CL='ITF_VGDATNM,3'></th>
												<th CL='ITF_WAREKYNM,3'></th>
												<th CL='ITF_C00104NM,3'></th>
												<th CL='ITF_C00105NM,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<tbody id="gridList5">
											<tr CGRow="true">
												<td GCol="text,MANDT"></td>
												<td GCol="text,SEQNO"></td>
												<td GCol="text,VBELN"></td>
												<td GCol="text,POSNR"></td>
												<td GCol="text,BWART"></td>
												<td GCol="text,PSTYV"></td>
												<td GCol="text,ZLIKP_ERDAT"></td>
												<td GCol="text,ZLIKP_ERZET"></td>
												<td GCol="text,ZLIKP_AEDAT"></td>
												<td GCol="text,VSTEL"></td>
												<td GCol="text,LFART"></td>
												<td GCol="text,WADAT"></td>
												<td GCol="text,KUNNR"></td>
												<td GCol="text,KUNAG"></td>
												<td GCol="text,WERKS"></td>
												<td GCol="text,LGORT"></td>
												<td GCol="text,MATNR"></td>
												<td GCol="text,LFIMG"></td>
												<td GCol="text,QTSHP"></td>
												<td GCol="text,MEINS"></td>
												<td GCol="text,NETPR"></td>
												<td GCol="text,NETWR"></td>
												<td GCol="text,MWSBP"></td>
												<td GCol="text,MWSDC"></td>
												<td GCol="text,WAERK"></td>
												<td GCol="text,BWTAR"></td>
												<td GCol="text,VGBEL"></td>
												<td GCol="text,VGPOS"></td>
												<td GCol="text,VGDAT"></td>
												<td GCol="text,STKNUM"></td>
												<td GCol="text,SDATBG"></td>
												<td GCol="text,STATUS"></td>
												<td GCol="text,TDATE"></td>
												<td GCol="text,CDATE"></td>
												<td GCol="text,IFFLG"></td>
												<td GCol="text,RETRY"></td>
												<td GCol="text,ERCOD"></td>
												<td GCol="text,ERTXT"></td>
												<td GCol="text,CUSRID"></td>
												<td GCol="text,CUNAME"></td>
												<td GCol="text,CPSTLZ"></td>
												<td GCol="text,LAND1"></td>
												<td GCol="text,TELF1"></td>
												<td GCol="text,TELE2"></td>
												<td GCol="text,SMTP_ADDR"></td>
												<td GCol="text,KUKLA"></td>
												<td GCol="text,VTEXT"></td>
												<td GCol="text,ADDR"></td>
												<td GCol="text,CNAME"></td>
												<td GCol="text,CPHON"></td>
												<td GCol="text,BNAME"></td>
												<td GCol="text,BPHON"></td>
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
												<td GCol="text,C0010"></td>
												<td GCol="text,C00102"></td>
												<td GCol="text,C00103"></td>
												<td GCol="text,C00104"></td>
												<td GCol="text,C00105"></td>
												<td GCol="text,N00101"></td>
												<td GCol="text,N00102"></td>
												<td GCol="text,BWARTNM"></td>
												<td GCol="text,PSTYVNM"></td>
												<td GCol="text,KUNAGNM"></td>
												<td GCol="text,WERKSNM"></td>
												<td GCol="text,LGORTNM"></td>
												<td GCol="text,MATNRNM"></td>
												<td GCol="text,BWTARNM"></td>
												<td GCol="text,VGDATNM"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,C00104NM"></td>
												<td GCol="text,C00105NM"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button class="button type4" type="button"><img src="/common/images/ico_btn5.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn6.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn7.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn8.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn9.png" alt="" /></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
					<div id="tabs1-6">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>666</th>
												<!-- <th CL='STD_MANDT'></th> -->
												<th CL='ITF_SEQNO,3'></th>
												<th CL='ITF_EBELN,3'></th>
												<th CL='ITF_EBELP,3'></th>
												<th CL='ITF_LIFNR,3'></th>
												<th CL='ITF_BWART,3'></th>
												<th CL='ITF_BEDAT,3'></th>
												<th CL='ITF_ZEKKO_AEDAT,3'></th>
												<th CL='ITF_LOEKZ,3'></th>
												<th CL='ITF_MATNR,3'></th>
												<th CL='ITF_MAKTX_K,3'></th>
												<th CL='ITF_MAKTX_E,3'></th>
												<th CL='ITF_MAKTX_C,3'></th>
												<th CL='ITF_MENGE,3'></th>
												<th CL='ITF_MEINS,3'></th>
												<th CL='ITF_WERKS,3'></th>
												<th CL='ITF_ERPWHF,3'></th>
												<th CL='ITF_EINDT,3'></th>
												<th CL='ITF_ZEKPO_AEDAT,3'></th>
												<th CL='ITF_MENGE_B,3'></th>
												<th CL='ITF_MENGE_R,3'></th>
												<th CL='ITF_BWTAR,3'></th>
												<th CL='ITF_VGBEL,3'></th>
												<th CL='ITF_VGPOS,3'></th>
												<th CL='ITF_ERPWHT,3'></th>
												<th CL='ITF_ELIKZ,3'></th>
												<th CL='ITF_STATUS,3'></th>
												<th CL='ITF_TDATE,3'></th>
												<th CL='ITF_CDATE,3'></th>
												<th CL='ITF_IFFLG,3'></th>
												<th CL='ITF_ERTXT,3'></th>
												<th CL='ITF_WAREKY,3'></th>
												<th CL='ITF_SKUKEY,3'></th>
												<th CL='ITF_DESC01,3'></th>
												<th CL='ITF_DESC02,3'></th>
												<th CL='ITF_USRID1,3'></th>
												<th CL='ITF_DEPTID1,3'></th>
												<th CL='ITF_USRID2,3'></th>
												<th CL='ITF_DEPTID2,3'></th>
												<th CL='ITF_USRID3,3'></th>
												<th CL='ITF_DEPTID3,3'></th>
												<th CL='ITF_USRID4,3'></th>
												<th CL='ITF_DEPTID4,3'></th>
												<th CL='ITF_ZDOC_NO,3'></th>
												<th CL='ITF_ZDOC_ITEM,3'></th>
												<th CL='ITF_ZWADAT,3'></th>
												<th CL='ITF_SEQITEM,3'></th>
												<th CL='ITF_QTYRCV,3'></th>
												<th CL='ITF_DRELIN,3'></th>
												<th CL='ITF_DRELIN_ITEM,3'></th>
												<th CL='ITF_C00101,3'></th>
												<th CL='ITF_C00102,3'></th>
												<th CL='ITF_C00103,3'></th>
												<th CL='ITF_C00104,3'></th>
												<th CL='ITF_C00105,3'></th>
												<th CL='ITF_N00101,3'></th>
												<th CL='ITF_N00102,3'></th>
												<th CL='ITF_LOGMSG,3'></th>
												<th CL='ITF_LIFNRNM,3'></th>
												<th CL='ITF_BWARTNM,3'></th>
												<th CL='ITF_WERKSNM,3'></th>
												<th CL='ITF_LGORTNM,3'></th>
												<th CL='ITF_BWTARNM,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<tbody id="gridList6">
											<tr CGRow="true">
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
												<td GCol="text,ERPWHF"></td>
												<td GCol="text,EINDT"></td>
												<td GCol="text,ZEKPO_AEDAT"></td>
												<td GCol="text,MENGE_B"></td>
												<td GCol="text,MENGE_R"></td>
												<td GCol="text,BWTAR"></td>
												<td GCol="text,VGBEL"></td>
												<td GCol="text,VGPOS"></td>
												<td GCol="text,ERPWHT"></td>
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
												<td GCol="text,ZDOC_NO"></td>
												<td GCol="text,ZDOC_ITEM"></td>
												<td GCol="text,ZWADAT"></td>
												<td GCol="text,SEQITEM"></td>
												<td GCol="text,QTYRCV"></td>
												<td GCol="text,DRELIN"></td>
												<td GCol="text,DRELIN_ITEM"></td>
												<td GCol="text,C00101"></td>
												<td GCol="text,C00102"></td>
												<td GCol="text,C00103"></td>
												<td GCol="text,C00104"></td>
												<td GCol="text,C00105"></td>
												<td GCol="text,N00101"></td>
												<td GCol="text,N00102"></td>
												<td GCol="text,LOGMSG"></td>
												<td GCol="text,LIFNRNM"></td>
												<td GCol="text,BWARTNM"></td>
												<td GCol="text,WERKSNM"></td>
												<td GCol="text,LGORTNM"></td>
												<td GCol="text,BWTARNM"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button class="button type4" type="button"><img src="/common/images/ico_btn5.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn6.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn7.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn8.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn9.png" alt="" /></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
					<div id="tabs1-7">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>777</th>
												<!-- <th CL='STD_MANDT'></th> -->
												<th CL='ITF_SEQNO,3'></th>
												<th CL='ITF_VBELN,3'></th>
												<th CL='ITF_POSNR,3'></th>
												<th CL='ITF_BWART,3'></th>
												<th CL='ITF_PSTYV,3'></th>
												<th CL='ITF_ZLIKP_ERDAT,3'></th>
												<th CL='ITF_ZLIKP_ERZET,3'></th>
												<th CL='ITF_ZLIKP_AEDAT,3'></th>
												<th CL='ITF_VSTEL,3'></th>
												<th CL='ITF_LFART,3'></th>
												<th CL='ITF_WADAT,3'></th>
												<th CL='ITF_KUNNR,3'></th>
												<th CL='ITF_KUNAG,3'></th>
												<th CL='ITF_WERKS,3'></th>
												<th CL='ITF_ERPWHF,3'></th>
												<th CL='ITF_MATNR,3'></th>
												<th CL='ITF_LFIMG,3'></th>
												<th CL='ITF_MEINS,3'></th>
												<th CL='ITF_NETPR,3'></th>
												<th CL='ITF_NETWR,3'></th>
												<th CL='ITF_MWSBP,3'></th>
												<th CL='ITF_MWSDC,3'></th>
												<th CL='ITF_WAERK,3'></th>
												<th CL='ITF_BWTAR,3'></th>
												<th CL='ITF_VGBEL,3'></th>
												<th CL='ITF_VGPOS,3'></th>
												<th CL='ITF_ERPWHT,3'></th>
												<th CL='ITF_STKNUM,3'></th>
												<th CL='ITF_SDATBG,3'></th>
												<th CL='ITF_STATUS,3'></th>
												<th CL='ITF_TDATE,3'></th>
												<th CL='ITF_CDATE,3'></th>
												<th CL='ITF_IFFLG,3'></th>
												<th CL='ITF_ERTXT,3'></th>
												<th CL='ITF_CUSRID,3'></th>
												<th CL='ITF_CUNAME,3'></th>
												<th CL='ITF_CPSTLZ,3'></th>
												<th CL='ITF_LAND1,3'></th>
												<th CL='ITF_TELF1,3'></th>
												<th CL='ITF_TELE2,3'></th>
												<th CL='ITF_SMTP_ADDR,3'></th>
												<th CL='ITF_KUKLA,3'></th>
												<th CL='ITF_VTEXT,3'></th>
												<th CL='ITF_ADDR,3'></th>
												<th CL='ITF_CNAME,3'></th>
												<th CL='ITF_CPHON,3'></th>
												<th CL='ITF_BNAME,3'></th>
												<th CL='ITF_BPHON,3'></th>
												<th CL='ITF_WAREKY,3'></th>
												<th CL='ITF_SKUKEY,3'></th>
												<th CL='ITF_DESC01,3'></th>
												<th CL='ITF_DESC02,3'></th>
												<th CL='ITF_USRID1,3'></th>
												<th CL='ITF_DEPTID1,3'></th>
												<th CL='ITF_USRID2,3'></th>
												<th CL='ITF_DEPTID2,3'></th>
												<th CL='ITF_USRID3,3'></th>
												<th CL='ITF_DEPTID3,3'></th>
												<th CL='ITF_USRID4,3'></th>
												<th CL='ITF_DEPTID4,3'></th>
												<th CL='ITF_ZDOC_NO,3'></th>
												<th CL='ITF_ZDOC_ITEM,3'></th>
												<th CL='ITF_SEQITEM,3'></th>
												<th CL='ITF_ZQTSACT,3'></th>
												<th CL='ITF_ZWADAT,3'></th>
												<th CL='ITF_ESHPKY,3'></th>
												<th CL='ITF_ESHPKY_ITEM,3'></th>
												<th CL='ITF_C00101,3'></th>
												<th CL='ITF_C00102,3'></th>
												<th CL='ITF_C00103,3'></th>
												<th CL='ITF_C00104,3'></th>
												<th CL='ITF_C00105,3'></th>
												<th CL='ITF_N00101,3'></th>
												<th CL='ITF_N00102,3'></th>
												<th CL='ITF_LOGMSG,3'></th>
												<th CL='ITF_BWARTNM,3'></th>
												<th CL='ITF_PSTYVNM,3'></th>
												<th CL='ITF_KUNAGNM,3'></th>
												<th CL='ITF_WERKSNM,3'></th>
												<th CL='ITF_LGORTNM,3'></th>
												<th CL='ITF_MATNRNM,3'></th>
												<th CL='ITF_BWTARNM,3'></th>
												<th CL='ITF_VGDATNM,3'></th>
												<th CL='ITF_WAREKYNM,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<tbody id="gridList7">
											<tr CGRow="true">
												<td GCol="text,MANDT"></td>
												<td GCol="text,SEQNO"></td>
												<td GCol="text,VBELN"></td>
												<td GCol="text,POSNR"></td>
												<td GCol="text,BWART"></td>
												<td GCol="text,PSTYV"></td>
												<td GCol="text,ZLIKP_ERDAT"></td>
												<td GCol="text,ZLIKP_ERZET"></td>
												<td GCol="text,ZLIKP_AEDAT"></td>
												<td GCol="text,VSTEL"></td>
												<td GCol="text,LFART"></td>
												<td GCol="text,WADAT"></td>
												<td GCol="text,KUNNR"></td>
												<td GCol="text,KUNAG"></td>
												<td GCol="text,WERKS"></td>
												<td GCol="text,ERPWHF"></td>
												<td GCol="text,MATNR"></td>
												<td GCol="text,LFIMG"></td>
												<td GCol="text,MEINS"></td>
												<td GCol="text,NETPR"></td>
												<td GCol="text,NETWR"></td>
												<td GCol="text,MWSBP"></td>
												<td GCol="text,MWSDC"></td>
												<td GCol="text,WAERK"></td>
												<td GCol="text,BWTAR"></td>
												<td GCol="text,VGBEL"></td>
												<td GCol="text,VGPOS"></td>
												<td GCol="text,ERPWHT"></td>
												<td GCol="text,STKNUM"></td>
												<td GCol="text,SDATBG"></td>
												<td GCol="text,STATUS"></td>
												<td GCol="text,TDATE"></td>
												<td GCol="text,CDATE"></td>
												<td GCol="text,IFFLG"></td>
												<td GCol="text,ERTXT"></td>
												<td GCol="text,CUSRID"></td>
												<td GCol="text,CUNAME"></td>
												<td GCol="text,CPSTLZ"></td>
												<td GCol="text,LAND1"></td>
												<td GCol="text,TELF1"></td>
												<td GCol="text,TELE2"></td>
												<td GCol="text,SMTP_ADDR"></td>
												<td GCol="text,KUKLA"></td>
												<td GCol="text,VTEXT"></td>
												<td GCol="text,ADDR"></td>
												<td GCol="text,CNAME"></td>
												<td GCol="text,CPHON"></td>
												<td GCol="text,BNAME"></td>
												<td GCol="text,BPHON"></td>
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
												<td GCol="text,ZDOC_NO"></td>
												<td GCol="text,ZDOC_ITEM"></td>
												<td GCol="text,SEQITEM"></td>
												<td GCol="text,ZQTSACT"></td>
												<td GCol="text,ZWADAT"></td>
												<td GCol="text,ESHPKY"></td>
												<td GCol="text,ESHPKY_ITEM"></td>
												<td GCol="text,C00101"></td>
												<td GCol="text,C00102"></td>
												<td GCol="text,C00103"></td>
												<td GCol="text,C00104"></td>
												<td GCol="text,C00105"></td>
												<td GCol="text,N00101"></td>
												<td GCol="text,N00102"></td>
												<td GCol="text,LOGMSG"></td>
												<td GCol="text,BWARTNM"></td>
												<td GCol="text,PSTYVNM"></td>
												<td GCol="text,KUNAGNM"></td>
												<td GCol="text,WERKSNM"></td>
												<td GCol="text,LGORTNM"></td>
												<td GCol="text,MATNRNM"></td>
												<td GCol="text,BWTARNM"></td>
												<td GCol="text,VGDATNM"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button class="button type4" type="button"><img src="/common/images/ico_btn5.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn6.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn7.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn8.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn9.png" alt="" /></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
					<div id="tabs1-8">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>888</th>
												<!-- <th CL='STD_MANDT'></th> -->
												<th CL='ITF_SEQNO,3'></th>
												<th CL='ITF_ZDOC_NO,3'></th>
												<th CL='ITF_ZDOC_ITEM,3'></th>
												<th CL='ITF_ZDOC_TYPE,3'></th>
												<th CL='ITF_ZMOVE_TYPE,3'></th>
												<th CL='ITF_BWART,3'></th>
												<th CL='ITF_BUDAT,3'></th>
												<th CL='ITF_LIFNR,3'></th>
												<th CL='ITF_AUFNR,3'></th>
												<th CL='ITF_AUFNI,3'></th>
												<th CL='ITF_MATNR,3'></th>
												<th CL='ITF_MAKTX_K,3'></th>
												<th CL='ITF_MAKTX_E,3'></th>
												<th CL='ITF_MAKTX_C,3'></th>
												<th CL='ITF_WERKS,3'></th>
												<th CL='ITF_ERPWHF,3'></th>
												<th CL='ITF_BWTAR,3,3'></th>
												<th CL='ITF_MENGE,3,3'></th>
												<th CL='ITF_MEINS,3,3'></th>
												<th CL='ITF_UMMAT,3,3'></th>
												<th CL='ITF_UMMAT_K,3'></th>
												<th CL='ITF_UNMAT_E,3'></th>
												<th CL='ITF_UMMAT_C,3'></th>
												<th CL='ITF_UMWRK,3'></th>
												<th CL='ITF_ERPWHT,3'></th>
												<th CL='ITF_UMBAR,3'></th>
												<th CL='ITF_GRUND,3'></th>
												<th CL='ITF_TDATE,3'></th>
												<th CL='ITF_CDATE,3'></th>
												<th CL='ITF_IFFLG,3'></th>
												<th CL='ITF_ERTXT,3'></th>
												<th CL='ITF_WAREKY,3'></th>
												<th CL='ITF_WARETG,3'></th>
												<th CL='ITF_SKUKEY,3'></th>
												<th CL='ITF_DESC01,3'></th>
												<th CL='ITF_DESC02,3'></th>
												<th CL='ITF_USRID1,3'></th>
												<th CL='ITF_DEPTID1,3'></th>
												<th CL='ITF_USRID2,3'></th>
												<th CL='ITF_DEPTID2,3'></th>
												<th CL='ITF_USRID3,3'></th>
												<th CL='ITF_DEPTID3,3'></th>
												<th CL='ITF_USRID4,3'></th>
												<th CL='ITF_DEPTID4,3'></th>
												<th CL='ITF_EDOCKY,3'></th>
												<th CL='ITF_EDOCKY_ITEM,3'></th>
												<th CL='ITF_C00101,3'></th>
												<th CL='ITF_C00102,3'></th>
												<th CL='ITF_C00103,3'></th>
												<th CL='ITF_C00104,3'></th>
												<th CL='ITF_C00105,3'></th>
												<th CL='ITF_N00101,3'></th>
												<th CL='ITF_N00102,3'></th>
												<th CL='ITF_LOGMSG,3'></th>
												<th CL='ITF_ZMOVE_TYPENM,3'></th>
												<th CL='ITF_BWARTNM,3'></th>
												<th CL='ITF_LIFNRNM,3'></th>
												<th CL='ITF_WERKSNM,3'></th>
												<th CL='ITF_LGORTNM,3'></th>
												<th CL='ITF_BWTARNM,3'></th>
												<th CL='ITF_UMLGONM,3'></th>
												<th CL='ITF_GRUNDNM,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<tbody id="gridList8">
											<tr CGRow="true">
												<td GCol="text,MANDT"></td>
												<td GCol="text,SEQNO"></td>
												<td GCol="text,ZDOC_NO"></td>
												<td GCol="text,ZDOC_ITEM"></td>
												<td GCol="text,ZDOC_TYPE"></td>
												<td GCol="text,ZMOVE_TYPE"></td>
												<td GCol="text,BWART"></td>
												<td GCol="text,BUDAT"></td>
												<td GCol="text,LIFNR"></td>
												<td GCol="text,AUFNR"></td>
												<td GCol="text,AUFNI"></td>
												<td GCol="text,MATNR"></td>
												<td GCol="text,MAKTX_K"></td>
												<td GCol="text,MAKTX_E"></td>
												<td GCol="text,MAKTX_C"></td>
												<td GCol="text,WERKS"></td>
												<td GCol="text,ERPWHF"></td>
												<td GCol="text,BWTAR"></td>
												<td GCol="text,MENGE"></td>
												<td GCol="text,MEINS"></td>
												<td GCol="text,UMMAT"></td>
												<td GCol="text,UMMAT_K"></td>
												<td GCol="text,UNMAT_E"></td>
												<td GCol="text,UMMAT_C"></td>
												<td GCol="text,UMWRK"></td>
												<td GCol="text,ERPWHT"></td>
												<td GCol="text,UMBAR"></td>
												<td GCol="text,GRUND"></td>
												<td GCol="text,TDATE"></td>
												<td GCol="text,CDATE"></td>
												<td GCol="text,IFFLG"></td>
												<td GCol="text,ERTXT"></td>
												<td GCol="text,WAREKY"></td>
												<td GCol="text,WARETG"></td>
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
												<td GCol="text,EDOCKY"></td>
												<td GCol="text,EDOCKY_ITEM"></td>
												<td GCol="text,C00101"></td>
												<td GCol="text,C00102"></td>
												<td GCol="text,C00103"></td>
												<td GCol="text,C00104"></td>
												<td GCol="text,C00105"></td>
												<td GCol="text,N00101"></td>
												<td GCol="text,N00102"></td>
												<td GCol="text,LOGMSG"></td>
												<td GCol="text,ZMOVE_TYPENM"></td>
												<td GCol="text,BWARTNM"></td>
												<td GCol="text,LIFNRNM"></td>
												<td GCol="text,WERKSNM"></td>
												<td GCol="text,LGORTNM"></td>
												<td GCol="text,BWTARNM"></td>
												<td GCol="text,UMLGONM"></td>
												<td GCol="text,GRUNDNM"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button class="button type4" type="button"><img src="/common/images/ico_btn5.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn6.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn7.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn8.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn9.png" alt="" /></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
								</div>
							</div>
						</div>
					</div>
					<div id="tabs1-9">
						<div class="section type1">
							<div class="table type2">
								<div class="tableHeader">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<thead>
											<tr>
												<th CL='STD_NUMBER'>999</th>
												<!-- <th CL='ITF_MANDT'></th> -->
												<th CL='ITF_SEQNO,3'></th>
												<th CL='ITF_VBELN,3'></th>
												<th CL='ITF_POSNR,3'></th>
												<th CL='ITF_BWART,3'></th>
												<th CL='ITF_PSTYV,3'></th>
												<th CL='ITF_ZLIKP_ERDAT,3'></th>
												<th CL='ITF_ZLIKP_ERZET,3'></th>
												<th CL='ITF_ZLIKP_AEDAT,3'></th>
												<th CL='ITF_VSTEL,3'></th>
												<th CL='ITF_LFART,3'></th>
												<th CL='ITF_WADAT,3'></th>
												<th CL='ITF_KUNNR,3'></th>
												<th CL='ITF_KUNAG,3'></th>
												<th CL='ITF_WERKS,3'></th>
												<th CL='ITF_LGORT,3'></th>
												<th CL='ITF_MATNR,3'></th>
												<th CL='ITF_LFIMG,3'></th>
												<th CL='ITF_MEINS,3'></th>
												<th CL='ITF_NETPR,3'></th>
												<th CL='ITF_NETWR,3'></th>
												<th CL='ITF_MWSBP,3'></th>
												<th CL='ITF_MWSDC,3'></th>
												<th CL='ITF_WAERK,3'></th>
												<th CL='ITF_BWTAR,3'></th>
												<th CL='ITF_VGBEL,3'></th>
												<th CL='ITF_VGPOS,3'></th>
												<th CL='ITF_VGDAT,3'></th>
												<th CL='ITF_STKNUM,3'></th>
												<th CL='ITF_SDATBG,3'></th>
												<th CL='ITF_STATUS,3'></th>
												<th CL='ITF_TDATE,3'></th>
												<th CL='ITF_CDATE,3'></th>
												<th CL='ITF_IFFLG,3'></th>
												<th CL='ITF_ERTXT,3'></th>
												<th CL='ITF_CUSRID,3'></th>
												<th CL='ITF_CUNAME,3'></th>
												<th CL='ITF_CPSTLZ,3'></th>
												<th CL='ITF_LAND1,3'></th>
												<th CL='ITF_TELF1,3'></th>
												<th CL='ITF_TELE2,3'></th>
												<th CL='ITF_SMTP_ADDR,3'></th>
												<th CL='ITF_KUKLA,3'></th>
												<th CL='ITF_VTEXT,3'></th>
												<th CL='ITF_ADDR,3'></th>
												<th CL='ITF_CNAME,3'></th>
												<th CL='ITF_CPHON,3'></th>
												<th CL='ITF_BNAME,3'></th>
												<th CL='ITF_BPHON,3'></th>
												<th CL='ITF_WAREKY,3'></th>
												<th CL='ITF_SKUKEY,3'></th>
												<th CL='ITF_DESC01,3'></th>
												<th CL='ITF_DESC02,3'></th>
												<th CL='ITF_USRID1,3'></th>
												<th CL='ITF_DEPTID1,3'></th>
												<th CL='ITF_USRID2,3'></th>
												<th CL='ITF_DEPTID2,3'></th>
												<th CL='ITF_USRID3,3'></th>
												<th CL='ITF_DEPTID3,3'></th>
												<th CL='ITF_USRID4,3'></th>
												<th CL='ITF_DEPTID4,3'></th>
												<th CL='ITF_CONFIRM,3'></th>
												<th CL='ITF_CONFCNT,3'></th>
												<th CL='ITF_C00101,3'></th>
												<th CL='ITF_C00102,3'></th>
												<th CL='ITF_C00103,3'></th>
												<th CL='ITF_C00104,3'></th>
												<th CL='ITF_C00105,3'></th>
												<th CL='ITF_N00101,3'></th>
												<th CL='ITF_N00102	,3'></th>
												<th CL='ITF_BWARTNM,3'></th>
												<th CL='ITF_PSTYVNM,3'></th>
												<th CL='ITF_KUNAGNM,3'></th>
												<th CL='ITF_WERKSNM,3'></th>
												<th CL='ITF_LGORTNM,3'></th>
												<th CL='ITF_BWTARNM,3'></th>
												<th CL='ITF_VGDATNM,3'></th>
												<th CL='ITF_WAREKYNM,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
												<th CL='STD_CREDAT,3'></th>
											</tr>
										</thead>
									</table>
								</div>
								<div class="tableBody">
									<table>
										<colgroup>
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
											<col width="120" />
										</colgroup>
										<tbody id="gridList9">
											<tr CGRow="true">
												<td GCol="text,MANDT"></td>
												<td GCol="text,SEQNO"></td>
												<td GCol="text,VBELN"></td>
												<td GCol="text,POSNR"></td>
												<td GCol="text,BWART"></td>
												<td GCol="text,PSTYV"></td>
												<td GCol="text,ZLIKP_ERDAT"></td>
												<td GCol="text,ZLIKP_ERZET"></td>
												<td GCol="text,ZLIKP_AEDAT"></td>
												<td GCol="text,VSTEL"></td>
												<td GCol="text,LFART"></td>
												<td GCol="text,WADAT"></td>
												<td GCol="text,KUNNR"></td>
												<td GCol="text,KUNAG"></td>
												<td GCol="text,WERKS"></td>
												<td GCol="text,LGORT"></td>
												<td GCol="text,MATNR"></td>
												<td GCol="text,LFIMG"></td>
												<td GCol="text,MEINS"></td>
												<td GCol="text,NETPR"></td>
												<td GCol="text,NETWR"></td>
												<td GCol="text,MWSBP"></td>
												<td GCol="text,MWSDC"></td>
												<td GCol="text,WAERK"></td>
												<td GCol="text,BWTAR"></td>
												<td GCol="text,VGBEL"></td>
												<td GCol="text,VGPOS"></td>
												<td GCol="text,VGDAT"></td>
												<td GCol="text,STKNUM"></td>
												<td GCol="text,SDATBG"></td>
												<td GCol="text,STATUS"></td>
												<td GCol="text,TDATE"></td>
												<td GCol="text,CDATE"></td>
												<td GCol="text,IFFLG"></td>
												<td GCol="text,ERTXT"></td>
												<td GCol="text,CUSRID"></td>
												<td GCol="text,CUNAME"></td>
												<td GCol="text,CPSTLZ"></td>
												<td GCol="text,LAND1"></td>
												<td GCol="text,TELF1"></td>
												<td GCol="text,TELE2"></td>
												<td GCol="text,SMTP_ADDR"></td>
												<td GCol="text,KUKLA"></td>
												<td GCol="text,VTEXT"></td>
												<td GCol="text,ADDR"></td>
												<td GCol="text,CNAME"></td>
												<td GCol="text,CPHON"></td>
												<td GCol="text,BNAME"></td>
												<td GCol="text,BPHON"></td>
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
												<td GCol="text,CONFIRM"></td>
												<td GCol="text,CONFCNT"></td>
												<td GCol="text,C00101"></td>
												<td GCol="text,C00102"></td>
												<td GCol="text,C00103"></td>
												<td GCol="text,C00104"></td>
												<td GCol="text,C00105"></td>
												<td GCol="text,N00101"></td>
												<td GCol="text,N00102"></td>
												<td GCol="text,BWARTNM"></td>
												<td GCol="text,PSTYVNM"></td>
												<td GCol="text,KUNAGNM"></td>
												<td GCol="text,WERKSNM"></td>
												<td GCol="text,LGORTNM"></td>
												<td GCol="text,BWTARNM"></td>
												<td GCol="text,VGDATNM"></td>
												<td GCol="text,WAREKYNM"></td>
												<td GCol="text,CREDAT"></td>
												<td GCol="text,CRETIM"></td>
												<td GCol="text,CREUSR"></td>
												<td GCol="text,LMODAT"></td>
												<td GCol="text,LMOTIM"></td>
												<td GCol="text,LMOUSR"></td>
											</tr>
										</tbody>
									</table>
								</div>

							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button class="button type4" type="button"><img src="/common/images/ico_btn5.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn6.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn7.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn8.png" alt="" /></button>
									<button class="button type4" type="button"><img src="/common/images/ico_btn9.png" alt="" /></button>
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
</body>
</html>