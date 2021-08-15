<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">
// var arr = ["ALLURORCT","ALLUROPRG","ALLMENUKY","ALLPDAMKY"];
var selid = "ALLURORCT";
	$(document).ready(function() { 
		setTopSize(100);
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "System",
			command : "UI00",
			autoCopyRowType : false
		});
		
		$('#ALLUROPRG').hide();
		$('#ALLMENUKY').hide();
		$('#ALLPDAMKY').hide();
		$('#ALLDELMAK').hide();
		
		$("#REFLECTCHOICE").change(function(){
			$('#'+selid+'').val("");
			$('#'+selid+'').hide();
			selid = $("#REFLECTCHOICE").val();
			setTimeout(function() {
				$('#'+selid+'').show();	
			},200);
			
		});
		
	}); 

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData('INSERT');
		}else if(btnName == "Userexc"){
			saveData('EXC');
		}else if(btnName == "Reflect"){
			reflect();
		}
	}
	function searchList() {
		var param = dataBind.paramData("searchArea");
		
		gridList.resetGrid("gridHeadList");
		
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
		}
		$('.tabs').tabs("option","active",0);
	}
	
	function saveData(gbn) {
		
		if(gbn=="INSERT"){
			if(!gridList.validationCheck("gridHeadList", "select")){
				return false;
			}	
		}
		
		
		var list = gridList.getSelectData("gridHeadList");
		
		var param = new DataMap();
			param.put("list", list);
			param.put("GBN",gbn);
			
		if( list.length == 0 ){
			commonUtil.msgBox("VALID_M0006"); //* 변경된 데이터가 없습니다.
			return;
		}
		
		
		
		if(!commonUtil.msgConfirm("COMMON_M0100")){
			return;
		}
		
		var json = netUtil.sendData({
		url : "/wms/system/json/saveUI00.data",
			param : param
		});  
		
		if(json && json.data){
			commonUtil.msgBox("MASTER_M0564");
			searchList();
		}
		
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){

	}
	
	function gridListEventColValueChange(gridId, rowNUE, colName, colValue){

	}
	
	 // 그리드 Row 추가 후 이벤트
    function gridListEventRowAddAfter(gridId, rowNUE){

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
			}else if(name == "ORGNCD"){
				param.put("CODE", "ORGNCD");
				param.put("USARG1","V");
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
  
	function reflect(){
		var rownumlist = gridList.getSelectRowNumList("gridHeadList");
		
		if(rownumlist.length == 0){
			alert("선택된 데이터가 없습니다.");
			return false;
		}
		
		if($('#'+selid+'').val() == ""){
			alert("일괄적용할 값을 선택 하세요");
			return false;
		}
		
		for(var i=0;i<rownumlist.length;i++){
			gridList.setColValue("gridHeadList", rownumlist[i], selid.replace("ALL","") , $('#'+selid+'').val());
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Save SAVE BTN_USERREG"></button>
		<button CB="Userexc DELETE BTN_USEREXC"></button>
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
							<table class="table type1" >
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
										<th CL="STD_EMPNUM"></th>
										<td><input type="text" name="UE.USERID" UIInput="SR" /></td>
										
										<th CL="STD_NMLAST"></th>
										<td><input type="text" name="UE.NMLAST" UIInput="SR" /></td>
										
										<th CL="STD_USASTS"></th>
										<td>
											<select id="DELMAK" name="DELMAK"  UISave="false" ComboCodeView=false style="width:160px">
												<option value=" " selected>WMS 사용</option>
												<option value="V">WMS 미사용</option>
											</select>
										</td>

									</tr>
									<tr>
										<th CL="STD_ORGNNM"></th>
										<td><input type="text" name="UE.ORGNNM" UIInput="SR" /></td>
										
										<th CL="STD_JOBDNM"></th>
										<td><input type="text" name="UE.JOBDNM" UIInput="SR" /></td>
										
										<th CL="STD_WMSUSAORGN"></th>
										<td>
											<select id="ORGNCD" name="ORGNCD"  style="width:160px">
												<option value=" " selected>사용</option>
												<option value="V">미사용</option>
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
								
									<div class="reflect" id="reflect">
									<select id="REFLECTCHOICE" name="REFLECTCHOICE" ComboCodeView=false style="width: 160px;">
										<option value="ALLURORCT">접속센터권한</option>
										<option value="ALLUROPRG">프로그램권한</option>
										<option value="ALLMENUKY">메뉴키</option>
										<option value="ALLPDAMKY">PDA메뉴키</option>
										<option value="ALLDELMAK">WMS미사용</option>
									</select>
									
									<select Combo="WmsCommon,ROLDF" id="ALLURORCT" name="URORCT"  ComboCodeView=false style="width: 160px;">
										<option value="">선택</option>
									</select>
									<select Combo="WmsCommon,ROLDF" id="ALLUROPRG" name="UROPRG"  ComboCodeView=false style="width: 160px;">
										<option value="">선택</option>
									</select>
									<select Combo="WmsCommon,MNUDF" id="ALLMENUKY" name="MENUKY"  ComboCodeView=false style="width: 160px;">
										<option value="">선택</option>
									</select>
									<select Combo="WmsCommon,MNUDF" id="ALLPDAMKY" name="PDAMKY"  ComboCodeView=false style="width: 160px;">
										<option value="">선택</option>
									</select>
									<select id="ALLDELMAK" name="DELMAK"  ComboCodeView=false style="width: 160px;">
										<option value="">선택</option>
										<option value="V">체크</option>
										<option value=" ">체크해제</option>
									</select>
									<button CB="Reflect REFLECT BTN_REFLECT"></button>
								</div>
								<div class="table type2" style="top: 45px;">
									<div class="tableBody">
										<table>
											<tbody id="gridHeadList">
												<tr CGRow="true">
													<td GH="40"                GCol="rownum">1</td>
													<td GH="40"                GCol="rowCheck"></td>
													<td GH="100 STD_EMPNUM"    GCol="text,USERID"  ></td>
													<td GH="100 STD_NMLAST"    GCol="text,NMLAST"  ></td>
													<td GH="100 STD_TELN01"    GCol="text,TELN01"  ></td>
													<td GH="100 STD_TELN02"    GCol="text,TELN02"  ></td>
													<td GH="200 STD_EMAIL1"    GCol="text,EMAIL1"  ></td>
<!-- 													<td GH="100 STD_ORGNCD"    GCol="text,ORGNCD"  ></td> -->
													<td GH="150 STD_ORGNNM"    GCol="text,ORGNNM"  ></td>
<!-- 													<td GH="100 STD_JOBDCD"    GCol="text,JOBDCD"  ></td> -->
													<td GH="100 STD_JOBDNM"    GCol="text,JOBDNM"  ></td>
													<td GH="100 STD_URORCT"    GCol="select,URORCT" validate="required" >
														<select Combo="WmsCommon,ROLDF" id="URORCT" name="URORCT"  ComboCodeView=false>
															<option value=" ">선택</option>
														</select>
													</td>
													<td GH="100 STD_UROPRG"    GCol="select,UROPRG">
														<select Combo="WmsCommon,ROLDF" id="UROPRG" name="UROPRG"  ComboCodeView=false>
															<option value=" ">선택</option>
														</select>
													</td>
													<td GH="100 STD_MENUKY"    GCol="select,MENUKY">
														<select Combo="WmsCommon,MNUDF" id="MENUKY" name="MENUKY"  ComboCodeView=false>
															<option value=" ">선택</option>
														</select>
													</td>
													<td GH="100 STD_PDAMKY"    GCol="select,PDAMKY">
														<select Combo="WmsCommon,MNUDF" id="PDAMKY" name="PDAMKY"  ComboCodeView=false>
															<option value=" ">선택</option>
														</select>
													</td>
													<td GH="100 STD_DELMAK"    GCol="check,DELMAK" ></td>
												</tr>
											</tbody>                
										</table>
									</div>
								</div>
								<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
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