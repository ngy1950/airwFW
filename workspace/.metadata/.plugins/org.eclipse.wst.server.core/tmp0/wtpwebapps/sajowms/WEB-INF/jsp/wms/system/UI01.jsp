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
		setTopSize(100);
		
		gridList.setGrid({
			id : "gridList",
			editable : true,
			pkcol : "USERID",
			module : "System",
			command : "USER",
			autoCopyRowType : false
		});
	}); 

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData('S');
		}else if(btnName == "Delete"){
			saveData('D');
		}else if(btnName == "Reset"){
			saveData('reset');
		}
	}
	function searchList() {
		var param = dataBind.paramData("searchArea");
		
		gridList.resetGrid("gridList");
		
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
		$('.tabs').tabs("option","active",0);
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		var certyp = gridList.getColData(gridId, rowNum, "CRETYP");
		var delmak = gridList.getColData(gridId, rowNum, "DELMAK");
		
		if(delmak == "V"){
			gridList.setRowReadOnly("gridList", rowNum, false, ['DELMAK']);
		}else{
			if(certyp == "PG"){
				gridList.setRowReadOnly("gridList", rowNum, false, ['USERID','NMLAST','DELMAK','URORCT','UROPRG','MENUKY','PDAMKY','ORGNNM','JOBDNM','TELN01','TELN02','EMAIL1']);//,'USERG5'
			}else if(certyp == "IF"){
				gridList.setRowReadOnly("gridList", rowNum, false, ['DELMAK','URORCT','UROPRG','MENUKY','PDAMKY']); //,'USERG5'
				gridList.setRowReadOnly("gridList", rowNum, true, ['USERID','NMLAST','ORGNNM','JOBDNM','TELN01','TELN02','EMAIL1']); 
			}	
		}
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(colName == "DELMAK"){
			if(colValue == "V"){
				gridList.setRowReadOnly("gridList", rowNum, true, ['USERID','NMLAST','URORCT','UROPRG','MENUKY','PDAMKY','ORGNNM','JOBDNM','TELN01','TELN02','EMAIL1']); //,'USERG5'
			}else{
				var certyp = gridList.getColData(gridId, rowNum, "CRETYP");
				var rowsts = gridList.getColData(gridId, rowNum, "GRowState");
				
				if(certyp == "PG" || rowsts == "C"){
					gridList.setRowReadOnly("gridList", rowNum, false, ['USERID','NMLAST','DELMAK','URORCT','UROPRG','MENUKY','PDAMKY','ORGNNM','JOBDNM','TELN01','TELN02','EMAIL1']); //,'USERG5'
				}else if(certyp == "IF"){
					gridList.setRowReadOnly("gridList", rowNum, false, ['DELMAK','URORCT','UROPRG','MENUKY','PDAMKY']); //,'USERG5'
				}	
			}
		}
	}

	function saveData(gbn) {
		if(gbn == 'S') {
			if(!gridList.validationCheck("gridList", "select")){
				return;
			}
		}
		
		var list = gridList.getSelectData("gridList");
		
		var param = new DataMap();
			param.put("list", list);
			param.put("GBN", gbn);
			
		if( list.length == 0 ){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return;
		}
		
		if(gbn == 'S'){
			var arraylist = [];
			
			for(var i=0;i<list.length;i++){
				var userid = list[i].get("USERID");
				var rowsts = list[i].get("GRowState");
				if(rowsts == "C"){
					arraylist[i] = userid;
				}
				
			}
			
			if(arraylist.length > 0){
				var paramchk = new DataMap();
					paramchk.put("USERIDLIST",arraylist);
			
				var json2 = netUtil.sendData({
		              module : "System",
		              command : "USERval",
		              sendType : "map",
		              param : paramchk
				});
				
				if(parseInt(json2.data["CNT"])){
					commonUtil.msgBox("이미 생성된 사용자ID가 포함되어 있습니다.\n확인후 저장 하시기 바랍니다."); 
					return ;
				}
			}
		}else{
			var chk = 0;
			for(var i=0;i<list.length;i++){
				var rowsts = list[i].get("GRowState");
				if(rowsts == "C"){
					chk++;
				}
				
			}
			
			if(chk > 0){
				commonUtil.msgBox("신규 데이터가 포함되어 있어 삭제를 진행할 수 없습니다."); 
				return ;
			}
		}
		
		var msgcode = "";
		
		if(gbn == "S"){
			msgcode = configData.MSG_MASTER_SAVE_CONFIRM;
		}else if(gbn == "reset"){
			msgcode = "사용자의 로그인 실패횟수를 초기화 하시겠습니까?";
		}else{
			msgcode = configData.MSG_MASTER_DELETE_CONFIRM;
		}
		
		if(!commonUtil.msgConfirm(msgcode)){
			return;
		}
		
		var json = netUtil.sendData({
		url : "/wms/system/json/saveUI01.data",
			param : param
		});  
		
		if(json && json.data){
			commonUtil.msgBox("MASTER_M0564");
			searchList();
		}
	}
	
	 // 그리드 Row 추가 후 이벤트
    function gridListEventRowAddAfter(gridId, rowNum){
		gridList.setColValue(gridId, rowNum, "MUSERG4", 30);
    	gridList.setRowReadOnly(gridId, rowNum, false, ['USERID','NMLAST','URORCT','UROPRG','MENUKY','PDAMKY','ORGNNM','JOBDNM','TELN01','TELN02','EMAIL1']); //,'USERG5'
    } 
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			
			if(name == "SC.SKUCLS" || name == "SKUCLS"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SKUCLS");	
				param.put("USARG1","03");
			}else if(name == "ABCANV"){
				param.put("CODE", "ABCANV");
			}else if(name == "SHPDGR"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SHPDGR");
			}else if(name == "BOXTYP"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "BOXTYP");
			}else if(name == "SH.SHMSTS" || name == "SHMSTS"){
				param.put("CODE", "SHMSTS");
			}else if(name == "LOTA06"){
				param.put("CODE", "LOTA06");
				param.put("USARG1","V");
			}else if(name == "CRETYP"){
				param.put("CODE", "USRCRETYP");
			}
			
			return param;
		}else if( comboAtt == "WmsCommon,ROLDF" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			
			if(name == "URORCT"){
				param.put("UROTYP", "WH");
			}else if(name == "UROPRG"){
				param.put("UROTYP", "PG");
			}
			return param;
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_SAVE"></button>
		<button CB="Delete DELETE BTN_DELETE"></button>
		<button CB="Reset DELETE BTN_LOGRESET"></button>
	</div>
</div>
	
	<!-- content -->
	<div class="content">
		<div class="innerContainer">
			<!-- contentContainer -->
			<div class="contentContainer">
<!-- 			 style="height:80px" -->
			<div class="bottomSect top" style="height:100px" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="table type1">
								<colgroup>
									<col width="50" />
									<col width="250" />
									<col width="50" />
									<col width="250" />
									<col width="50" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_CRETPYNM"></th>
										<td>
											<select id="USRCRETYP" name="CRETYP" Combo="Common,COMCOMBO" UISave="false" ComboCodeView=false style="width:160px">
												<option value="">전체</option>
											</select>
										</td>
									
									
										<th CL="STD_USERID"></th>
										<td><input type="text" name="UM.USERID" UIInput="SR" /></td>
										
										<th CL="STD_NMLAST"></th>
										<td><input type="text" name="UM.NMLAST" UIInput="SR" /></td>

									</tr>
									<tr>
										<th CL="STD_ORGNNM"></th>
										<td><input type="text" name="UM.ORGNNM" UIInput="SR" /></td>
										
										<th CL="STD_JOBDNM"></th>
										<td><input type="text" name="UM.JOBDNM" UIInput="SR" /></td>
										
										<th CL="STD_LOGINPASYN"></th>
										<td>
											<select id="DELMAK" name="DELMAK"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="">전체</option>
												<option value=" " selected >가능</option>
												<option value="V">불가능</option>
											</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottom">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL='STD_SEARCH'></span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableBody">
										<table>
											<tbody id="gridList">
												<tr CGRow="true">
													<td GH="40"                GCol="rownum">1</td>
													<td GH="40"                GCol="rowCheck"></td>
													<td GH="100 STD_CRETPYNM"    GCol="text,CRETPYNM"  ></td>
													<td GH="100 STD_USERID"    GCol="input,USERID" validate="required" ></td>
													<td GH="100 STD_NMLAST"    GCol="input,NMLAST" validate="required" ></td>
													<td GH="100 STD_USRDELMAK"    GCol="check,DELMAK"  ></td>
													<td GH="100 STD_URORCT"    GCol="select,URORCT"  >
														<select Combo="WmsCommon,ROLDF" id="URORCT" name="URORCT"  ComboCodeView=false>
															<option value=" ">선택</option>
														</select>
													</td>
													<td GH="100 STD_UROPRG"    GCol="select,UROPRG"  >
														<select Combo="WmsCommon,ROLDF" id="UROPRG" name="UROPRG"  ComboCodeView=false>
															<option value=" ">선택</option>
														</select>
													</td>
													<td GH="100 STD_MENUKY"    GCol="select,MENUKY"  >
														<select Combo="WmsCommon,MNUDF" id="MENUKY" name="MENUKY"  ComboCodeView=false>
															<option value=" ">선택</option>
														</select>
													</td>
													<td GH="100 STD_PDAMKY"    GCol="select,PDAMKY"  >
														<select Combo="WmsCommon,MNUDF" id="PDAMKY" name="PDAMKY"  ComboCodeView=false>
															<option value=" ">선택</option>
														</select>
													</td>
													<td GH="100 STD_ORGNCD"    GCol="text,ORGNCD"  ></td>
													<td GH="100 STD_ORGNNM"    GCol="input,ORGNNM"  ></td>
													<td GH="100 STD_JOBDCD"    GCol="text,JOBDCD"  ></td>
													<td GH="100 STD_JOBDNM"    GCol="input,JOBDNM"  ></td>
													<td GH="100 STD_TELN01"    GCol="input,TELN01" GF="NS 15"></td>
													<td GH="100 STD_TELN02"    GCol="input,TELN02" GF="NS 15" validate="required"></td>
													<td GH="100 STD_EMAIL1"    GCol="input,EMAIL1" validate="email,VALID_email" ></td>
													<td GH="100 STD_MUSERG4"   GCol="input,MUSERG4" GF="N" validate="required gt(0),MASTER_M4002 lt(91),MASTER_M4018"></td>
<!-- 													<td GH="100 STD_USERG5"    GCol="check,USERG5"  ></td> -->
													<td GH="100 STD_LLOGID"    GCol="text,LLOGID" GF="D" ></td>
													<td GH="100 STD_LLOGIT"    GCol="text,LLOGIT" GF="T" ></td>
													<td GH="120 STD_USERG1"    GCol="text,USERG1" GF="D" ></td>
													<td GH="120 STD_USERG2"    GCol="text,USERG2" GF="D" ></td>
													<td GH="120 STD_USERG4"    GCol="text,USERG4" GF="N" ></td>
													<td GH="100 STD_CREDAT"    GCol="text,CREDAT" GF="D"  ></td>
													<td GH="100 STD_CRETIM"    GCol="text,CRETIM" GF="T" ></td>
													<td GH="100 STD_CREUSR"    GCol="text,CREUSR"  ></td>
													<td GH="100 STD_LMODAT"    GCol="text,LMODAT" GF="D" ></td>
													<td GH="100 STD_LMOTIM"    GCol="text,LMOTIM" GF="T" ></td>
													<td GH="100 STD_LMOUSR"    GCol="text,LMOUSR"  ></td>
												</tr>
											</tbody>                 
										</table>
									</div>
								</div>
								<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="add"></button>
									<button type="button" GBtn="layout"></button>
                                    <!-- <button type="button" GBtn="total"></button> -->
<!-- 									<button type="button" GBtn="excel"></button> -->
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true">17 Record</p>
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