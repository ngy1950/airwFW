<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<style>
	.fildSect {width: 98%; position: absolute; left: 16px;}
	.fildSect #tabs-1 {border-top: 2px solid #333;}

	.newBoard{width: 100%; height: 100%;}
	.newBoard .elTr {height:28px;}
	
	.newBoard .elTh{border:1px solid #333; vertical-align:middle; font-weight: bold; background:#f3f3f3; width:100px;text-align:center; color: #000000;} 
	.newBoard .elTd{border:1px solid #333; vertical-align:middle; padding:5px;}
	.newBoard .elTd .msBox {margin-top:-11px;}
	.newBoard .elTr:nth-of-type(1) .elTd input{background:#f9fafc; width: 100%; height:100%; border:none;resize:none;}
	.newBoard .elTr:nth-of-type(2) .elTd{background: rgb(235, 235, 228);}
	.newBoard .elTr:nth-of-type(2) .elTd:nth-of-type(2) input{background: rgb(235, 235, 228); width: 80px; height:100%; border:none;resize:none;}
	.newBoard .elTr:nth-of-type(2) .elTd input{background: rgb(235, 235, 228) ;width: 100%; height:100%; border:none; resize:none;}
	.newBoard .elTr:nth-of-type(4) .pop {width:30px;}
	.newBoard .elTr:nth-of-type(4) .elTd input[type=checkbox]{margin: 0 5px 0 5px; width: 21px; height: 21px;}
	.newBoard .elTr:nth-of-type(6) {height:50%;}
	.newBoard .elTr:nth-of-type(7) {height:150px;}
	.newBoard .elTr:nth-of-type(7) .elTd {height:150px; position:relative;}
	.newBoard .elTr .elTd ul{width: 100%;}
	.newBoard .elTr .elTd ul li:nth-of-type(1){float: left; width: 350px; margin-right: 10px;}
	.newBoard .elTr .elTd ul li:nth-of-type(2){float: left;}
	.newBoard .elTr .elTd ul li input[type=checkbox]{margin: 0 5px 0 5px; width: 21px; height: 21px;}
	.noPadding{padding: 0 !important;}
	.editDisabled{background: rgb(235, 235, 228);}
	.impflg{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn16.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
	.regAft{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn17.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
	#attachBox{width: 100%; height: 100%;}
	.inputRequired{background-image: url(/common/images/icon-red.png); background-repeat: no-repeat; background-position: right top;}
	.gridIcon-center{text-align: center;}
</style>
<%@ include file="/common/include/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/css/innerGridContent.css">
<script type="text/javascript" src="/common/js/head-h.js"></script>
<script type="text/javascript" src="/common/js/pagegrid/notice.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			module : "Notice",
			command : "NT10"
		});
		
		gridList.setGrid({
			id : "gridList2",
			module : "Notice",
			command : "NITBD_ATTACH",
			firstRowFocusType : false,
			editedClassType : false,
			emptyMsgType : false
		});
		
		var linkData = page.getLinkPageData("NT10");
		if(linkData){
			linkSearchList(linkData);
		}else{
			//searchList();
		}
		
		notice.setNotice({areaId :"newBoard"});
		
		
		$("input[name=fileUp]").change(function(){
			var fileSize = this.files[0].size;
			var maxSize = 1024 * 1024 * 10;
			if(fileSize > maxSize) {
				commonUtil.msgBox("VALID_M0219");
				$("input[name=fileUp]").val("");
				return;
			}
		});
		
		
	});
	
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}
	}
	
	function searchList(){
		if(validate.check("searchArea")){
			notice.drawNoticeEditArea("newBoard","init");
			
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
	
	function linkSearchList(param){
		notice.drawNoticeEditArea("newBoard","init");
		gridList.gridList({
			id : "gridList",
			param : param
		});
	}
	
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		
		if(comboAtt == "WmsCommon,ROLCTWAREKY"){
			if($($comboObj).attr("name") == "WAREKY") {
				param.put("USRADM", "V");
				param.put("USERID", "<%=userid%>");
				return param;
			} else {
				//param.put("USRADM", "<%=usradm%>");
				//param.put("WAREKY", "<%=wareky%>");
				//param.put("USERID", "<%=userid%>");
				return param;
			}
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		if(gridId == "gridList2"){
			gridList.appendCols(gridId, ["ATTACH_FILEVIEW","BYTE_FILESIZEVIEW"]);
			var newData = new DataMap();
			return newData;
		}
	}
	
	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			notice.drawNotice("newBoard", gridList.getColData(gridId, rowNum, "NTISEQ"), "");
		}
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridList" && colName == "IMGFLG"){
			if(colValue == "V"){
				return false;	
			}else if(colValue == "X"){
				return "regAft";
			}else{
				return true;
			}
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridList" && dataLength > 0){
			notice.drawNotice("newBoard", gridList.getColData(gridId, notice.rowNum == -1?0:notice.rowNum, "NTISEQ"), "");
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
	</div>
</div>

<!-- content -->
<div class="content">
		<div class="innerContainer">
			<!-- contentContainer -->
			<div class="contentContainer">
								
				<!-- TOP FieldSet -->
				<div class="fildSect" id="searchArea">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs-1"><span CL='STD_SELECTOPTIONS'>탭메뉴1</span></a></li>
						</ul>
						<div id="tabs-1">
							<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col width="420" />
										<col width="50" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" UISave="false" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
											<th CL="STD_NOCDAT"></th>
											<td>
												<input type="text" name="NB1.CREDAT" UIInput="B" UIFormat="C -30" MaxDiff="M3" />
											</td>
											<th CL="STD_NIDTTO">종료된공지 제외</th>
											<td>
												<input type="checkbox" name="NIDTTOCHK" value="V" checked="checked"/>
											</td>
										</tr>
										<tr>
											<th>
												<select name="SRCFLG">
													<option value="0" CL="STD_NOIFTL"></option>
													<option value="1" CL="STD_NOUSER"></option>
													<option value="2" CL="STD_NOINFO"></option>
												</select>
											</th>
											<td>
												<input type="text" name="SRCTXT" GF="S 4" style="width: 220px;"/>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
				
				<div class="bottomSect2 bottom3" style="top:100px;">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL="STD_LIST"></span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableBody">
										<table>
											<tbody id="gridList">
												<tr CGRow="true">
													<td GH="40 STD_NUMBER"  GCol="rownum">1</td>
													<td GH="50 STD_NOTEIC"  GCol="icon,IMGFLG" GB="impflg"></td>
													<td GH="450 STD_NOIFTL" GCol="text,TITNTI"></td>
													<td GH="100 STD_NOCDAT" GCol="text,CREDAT,center" GF="D"></td>
													<td GH="100 STD_NOUSER" GCol="text,CUSRNM,center"></td>
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
									</div>
									<div class="rightArea">
										<p class="record" GInfoArea="true"></p>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<div id="commonCenterArea"></div>
				
				<div class="bottomSect2 bottom4" style="top: 100px;">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL="STD_NOIFLTL"></span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1" id="gridList1">
								<table class="newBoard" id="newBoard">
								
									<tr class="elTr">
										<th class="elTh" CL="STD_NOIFTL">제목</th>
										<td class="elTd inputRequired" colspan="3"><input type="text" name="TITNTI" GF="S 100"/></td> <!-- placeholder="제목을 입력하세요" -->
									</tr>
									
									<tr class="elTr">
										<th class="elTh" CL="STD_NOUSER">작성자</th>
										<td class="elTd"><input type="text" name="CUSRNM" disabled="disabled"/></td>
										<th class="elTh" CL="STD_NOCDAT">작성일자</th>
										<td class="elTd">
											<input type="text" UIInput="D" UIFormat="D" disabled="disabled"/>
											<input type="text" UIInput="T" UIFormat="T" disabled="disabled"/>
										</td>
									</tr>
									
									<tr class="elTr">
										<th class="elTh" CL="STD_NOIFDT">공지지간</th>
										<td class="elTd" colspan="3">
											<ul>
												<li>
													<input type="text" name="NIDTFR" UIFormat="C" /> <span>~</span> <input type="text" name="NIDTTO" UIFormat="C" />
												</li>
												<li>
													<span CL="STD_NOIFIM">주요공지 </span><input type="checkbox" name="IMPFLG" value="V"/>
												</li>
											</ul>
										</td>
									</tr>
									
									<tr class="elTr">
										<th class="elTh" CL="STD_NPOPYN">팝업여부</th>
										<td class="elTd"><input type="checkbox" name="POPFLG" value="V"/></td>
										<th class="elTh">팝업 공지기간</th>
										<td class="elTd">
											<input type="text" name="PFRDAT" UIFormat="C" /> <span>~</span> <input type="text" name="PTODAT" UIFormat="C" />
										</td>
									</tr>
									
									<tr class="elTr">
										<th class="elTh" CL="STD_NOIFTG">공지대상</th>
										<td class="elTd" colspan="3">
											<div class="msBox">
												<select Combo="WmsCommon,ROLCTWAREKY" name="NTTAGT" ComboType="MS"></select>
											</div>
										</td>
									</tr>
									
									<tr class="elTr">
										<th class="elTh" CL="STD_NOINFO">내용</th>
										<td class="elTd noPadding" colspan="3"></td>
									</tr>
									
									<tr class="elTr">
										<th class="elTh" CL="STD_ATTACH">첨부파일</th>
										<td class="elTd noPadding" colspan="3">
											<div id="attachBox">
												<div class="table type2" style="margin: 0;top: 0;bottom: 29px;">
													<div class="tableBody">
														<table>
															<tbody id="gridList2">
																<tr CGRow="true">
																	<td GH="40 STD_NUMBER"  GCol="rownum">1</td>
																	<td GH="40"             GCol="rowCheck"></td>
																	<td GH="200 STD_ATTACH"    GCol="file,ATTACH"/></td>
																	<td GH="200 STD_FILESIZE"  GCol="fileSize,BYTE"/></td>
																</tr>
															</tbody>
														</table>
													</div>
												</div>
												<div class="tableUtil" style="margin: 0;bottom: 0;left: 0;right: 0;">
													<div class="leftArea">
														<button type="button" GBtn="find"></button>
														<button type="button" GBtn="add"></button>
														<button type="button" GBtn="delete"></button>
													</div>
													<div class="rightArea">
														<p class="record" GInfoArea="true"></p>
													</div>
												</div>
											</div>
										</td>
									</tr>
									
								</table>
							</div>
						</div><!-- End of #tabs1-2 -->
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