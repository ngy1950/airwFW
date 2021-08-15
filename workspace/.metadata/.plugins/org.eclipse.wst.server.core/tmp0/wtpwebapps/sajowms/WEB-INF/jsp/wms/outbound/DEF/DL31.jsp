<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<style>
.gridIcon-center{text-align: center;}
.impflg{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.regAft{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn23.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.regNot{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn26.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
</style>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script> 
<script type="text/javascript">
	midAreaHeightSet = "200px";
	var outfsh = "",excelrow = -1;
	var allcheck = true;
	var rowcheck = true;
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "DL31",
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList",
	    	name : "gridItemList",
			editable : true,
			module : "WmsOutbound",
			command : "DL31SUB",
            autoCopyRowType : false
	    });
		
		gridList.setReadOnly("gridHeadList", true, ["WAREKY"]);
		gridList.setReadOnly("gridItemList", true, ["INDANGOOD" , "INDDCL" , "CNLMAK" , "CNLCFM" , "PICCFM"]);

		var val = day(0);

		searchShpdgr(val);
		$("#searchArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
		
		$("#searchArea [name=SHPDGR]").on("change",function(){
			searchvehino($('#RQSHPD').val().replace(/\./g,''),$(this).val());
			
		});
		
		
    });
    
    function searchShpdgr(val){
		var param = new DataMap();
		param.put("RQSHPD",val);
		param.put("WAREKY", "<%=wareky%>");
		param.put("DGRSTS", "DIRC");
		
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SHPDGR_S",
			sendType : "list",
			param : param
		});
		
		$("#SHPDGR").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#SHPDGR").append(optionHtml);
		getMaxSHPDGR();
		searchvehino($('#RQSHPD').val().replace(/\./g,''),"");
	}
    
    function searchvehino(val1,val2){
		var param = new DataMap();
			param.put("RQSHPD",val1);
			param.put("WAREKY", "<%=wareky%>");
			param.put("SHPDGR",val2);
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "VEHINO_S",
			sendType : "list",
			param : param
		});
		
		$("#VEHINO").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#VEHINO").append(optionHtml);
		$('#VEHINO').val("");
	}
    
    function day(day){
		var today = new Date();
		today.setDate(today.getDate() + day);
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();

		if( dd < 10 ) {
			dd ='0' + dd;
		} 

		if( mm < 10 ) {
			mm = '0' + mm;
		}
		
		return String(yyyy) + String(mm) + String(dd);
	}
    
    function getMaxSHPDGR(){
    	var param = new DataMap();
    		param.put("WAREKY","<%=wareky%>");
    	var json = netUtil.sendData({
            module : "WmsOutbound",
            command : "MAX_SHPDGR",
            sendType : "map",
            param : param
        });
    	
    	if($('#searchArea [name=RQSHPD]').val().replace(/\./g,'') == day(0)){
    		$('#SHPDGR').val(json.data["SHPDGR"]);	
    	}else{
    		$('#SHPDGR').val("");
    	}
    	
    	
    }
    
    // 공통 버튼 클릭 이벤트
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }else if(btnName == "Shpcfm"){
        	saveData();
        }else if(btnName == "Loadlist"){
        	print();
        }
    }
    
  //헤더 조회 
	function searchList(){
		//var param = dataBind.paramData("searchArea");
		
		gridList.resetGrid("gridHeadList");
		excelrow = -1;
		var param = inputList.setRangeParam("searchArea");
		
		outfsh = $('#OUTFSH').val();

        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }
		
	}
    
	function saveData(){
		if( gridList.validationCheck("gridItemList", "select") ){
			
			var head = gridList.getSelectData("gridHeadList", "E");
			var list = gridList.getSelectData("gridItemList", "E");
			var chklist = gridList.getGridData("gridItemList");
			
			if(head.length < 1 ){
				commonUtil.msgBox("VALID_M0006");//선택된 데이터가 없습니다.
				return;
			}
			
			var rowchk = true;
			
			for(var i=0; i<head.length;i++){
				var headgrpoky = head[i].get("GRPOKY");
				var headvehino = head[i].get("VEHINO");
				var headdockno = head[i].get("DOCKNO");
				var headcarcnt = head[i].get("CARCNT");

				var listgrpoky = chklist[0].get("GRPOKY");
				var listvehino = chklist[0].get("VEHINO");
				var listdockno = chklist[0].get("DOCKNO");
				var listcarcnt = chklist[0].get("CARCNT");
				
				if(headgrpoky == listgrpoky && headvehino == listvehino && headdockno == listdockno && headcarcnt == listcarcnt){
					rowchk = false;
					break;
				}
			}
			
			if(!rowchk && list.length < 1){
				commonUtil.msgBox("VALID_M0006");//선택된 데이터가 없습니다.
				return;
			}
			
// 			if(head.length == 1){
// 				var headgrpoky = head[0].get("GRPOKY");
// 				var headvehino = head[0].get("VEHINO");
// 				var headdockno = head[0].get("DOCKNO");
// 				var headcarcnt = head[0].get("CARCNT");

// 				var listgrpoky = list[0].get("GRPOKY");
// 				var listvehino = list[0].get("VEHINO");
// 				var listdockno = list[0].get("DOCKNO");
// 				var listcarcnt = list[0].get("CARCNT");
				
				
// 				if(headgrpoky != listgrpoky || headvehino != listvehino || headdockno != listdockno || headcarcnt != listcarcnt){
// 					commonUtil.msgBox("선택된 데이터와 상세 정보가 일치 하지 않습니다. 다시 선택해 주세요.");
// 					return;
// 				}
// 			}
			
			
			
			
			var chk = true;
			for(var i=0;i<list.length;i++){
				var indangood = list[i].get("INDANGOOD");
				
				if(indangood == 'V'){
					chk = false;
					break;
				}
			}
			
			var chk2 = true , chk3 = true , chk4 = true , chk5 = true;
			for(var i=0;i<head.length;i++){
				var indangood = head[i].get("INDANGOOD");
				var shpmty = head[i].get("SHPMTY");
				var simtyn = head[i].get("SIMYN");
				
				var cnlcfm = head[i].get("CNLCFM");
				var fwdbox = head[i].get("FWDCFM");
				
				if(indangood == 'V' && shpmty == '220'){
					chk2 = false;
					break;
				}
				if(simtyn == "Y"){
					chk3 = false;
					break;
				}
				
				if(cnlcfm == 'Y'  ){
					chk4 = false;
					break;
				}
				
				if(fwdbox == "Y"  ){
					chk5 = false;
					break;
				}
				
			}
			
			if(!chk || !chk2){
				commonUtil.msgBox("VALID_M0532");//위해상품이 포함되어 출하완료를 할수 없습니다.
				return;
			}
			
			
			if(!chk5){
				commonUtil.msgBox("이미 출하 완료된 데이터가 포함 되어 있습니다.");
				return;
			}
			
			var param = new DataMap();
				param.put("head", head);
				param.put("list", list);
			
			
			if(!commonUtil.msgConfirm("COMMON_M0118")){//출하완료를 진행 하시겠습니까?
	            return;
	        }
			
			netUtil.send({ 
				url : "/wms/outbound/json/saveDL31.data",
				param : param ,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	
	function succsessSaveCallBack(json,status){
		if( json && json.data ){
			if(json.data == "OK"){
				commonUtil.msgBox("MASTER_M0564");
				searchList();
			}
		}
	}
	
    function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
        
        if( gridId == "gridItemList" ){
        	var cnlcfm = gridList.getColData("gridItemList", rowNum, "CNLCFM");
 
			var piccfm = gridList.getColData("gridItemList", rowNum, "PICCFM");
			var indangood = gridList.getColData("gridItemList", rowNum, "INDANGOOD");
			var inddcl = gridList.getColData("gridItemList", rowNum, "INDDCL");
			var cnlmak = gridList.getColData("gridItemList", rowNum, "CNLMAK");
			var simyn = gridList.getColData("gridItemList", rowNum, "SIMYN");
			
			if(cnlcfm == 'V' || piccfm == ' ' || indangood == 'Y' || inddcl == 'Y' || cnlmak == 'V' || simyn == "Y"){
				return true;
			}
        }
    }
	
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){
			
			subsearchlist(gridId,0,"gridItemList");
		}else if(gridId == "gridHeadList" && dataLength <= 0){
			gridList.resetGrid("gridItemList");
            searchOpen(true);
		}
	}
    
 	// 그리드 item 조회 이벤트
    function subsearchlist(gridId, rowNum, itemList){  
        var param = getItemSearchParam(rowNum);
			param.put("OUTFSH",outfsh);
			excelrow = rowNum;
        gridList.gridList({
            id : "gridItemList",
            param : param
        });
    }
    
    // 아이템 그리드 Parameter
    function getItemSearchParam(rowNum){
        var rowData = gridList.getRowData("gridHeadList", rowNum);
        var param = inputList.setRangeParam("searchArea");
        param.putAll(rowData);
        
        return param;
    }
    
    //그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
    function gridExcelDownloadEventBefore(gridId){
        var param = inputList.setRangeParam("searchArea");
        
        if(gridId == "gridItemList"){
            var rowNum = excelrow;
            if(rowNum == -1){
                return false;
            }else{
                 param = getItemSearchParam(rowNum);
            }
        }
        return param;
    }

    
    function gridListEventRowDblclick(gridId, rowNum){
        if(gridId == "gridItemList"){
            var row = gridList.getRowData(gridId, rowNum);
			page.linkPopOpen("/wms/outbound/POP/DL21POP.page", row); 
        }else if(girdId = "gridHeadList"){
        	gridList.setRowCheck(gridId, rowNum, false);
        	subsearchlist(gridId,rowNum,"gridItemList");
        }
    }
    
	// 그리드 클릭 포커스 이벤트(클릭), 수정 데이터가 있을 경우 컨펌메세지 후 이동 또는 복귀
	function gridListEventRowFocus(gridId, rowNum){
		
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
	    
	}
	
	// 그리드 Row 추가 전 이벤트
    function gridListEventRowAddBefore(gridId, rowNum){
        
    }
    
     // 그리드 Row 추가 후 이벤트
    function gridListEventRowAddAfter(gridId, rowNum){
    } 
    
    // 그리드 컬럼 format을 동적으로 변경 가능한 이벤트 
    function gridListEventColFormat(gridId, rowNum, colName){

    }
	
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, gridType){

	}
	
	function gridListEventRowCheck(gridId , rowNum , checkType){
		if(!allcheck){
			return false;
		}
		
		if(gridId == "gridItemList"){
			rowcheck = false;
			if(checkType){
				var vehino = gridList.getColData(gridId, rowNum, "VEHINO");
				var head = gridList.getGridData("gridHeadList");
				
				for(var i=0;i<head.length;i++){
					var hvehino = head[i].get("VEHINO");
					if(vehino == hvehino){
						gridList.setRowCheck("gridHeadList", i, true);
						break;
					}
				}
			}else{
				var rown = gridList.getSelectRowNumList("gridItemList");
				if(rown.length == 0){
					var vehino = gridList.getColData(gridId, rowNum, "VEHINO");
					var head = gridList.getGridData("gridHeadList");
					
					for(var i=0;i<head.length;i++){
						var hvehino = head[i].get("VEHINO");
						if(vehino == hvehino){
							gridList.setRowCheck("gridHeadList", i, false);
							break;
						}
					}
				}
			}
			rowcheck = true;
		}else if(gridId == "gridHeadList"){
			if(!rowcheck){
				return false;
			}
			
			if(checkType){
				var hvehino = gridList.getColData(gridId, rowNum, "VEHINO");
				var mvehino = gridList.getColData("gridItemList", 0, "VEHINO");
				if(hvehino == mvehino){
					gridList.checkAll("gridItemList", true);	
				}
				
			}else{
				var hvehino = gridList.getColData(gridId, rowNum, "VEHINO");
				var mvehino = gridList.getColData("gridItemList", 0, "VEHINO");
				if(hvehino == mvehino){
					gridList.checkAll("gridItemList", false);	
				}
				
			}
		}
		
// 		console.log(id);gridItemList
// 		console.log(rowNum);
// 		console.log(checkType);
	}
	
	function gridListEventRowCheckAll(gridId, checkType){
		allcheck = false;
		if(gridId == "gridItemList"){
			if(checkType){
				var vehino = gridList.getColData(gridId, 0, "VEHINO");
				var head = gridList.getGridData("gridHeadList");
				
				for(var i=0;i<head.length;i++){
					var hvehino = head[i].get("VEHINO");
					if(vehino == hvehino){
						gridList.setRowCheck("gridHeadList", i, true);
						break;
					}
				}
			}else{
					var vehino = gridList.getColData(gridId, 0, "VEHINO");
					var head = gridList.getGridData("gridHeadList");
					
					for(var i=0;i<head.length;i++){
						var hvehino = head[i].get("VEHINO");
						if(vehino == hvehino){
							gridList.setRowCheck("gridHeadList", i, false);
							break;
					
					}
				}
			}
		}else if(gridId == "gridHeadList"){
			if(checkType){
				gridList.checkAll("gridItemList", true);
			}else{
				gridList.checkAll("gridItemList", false);
			}
		}
		
		allcheck = true;
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
			}
			
			
			return param;
		}
	}
  
	function print(){
 		var head = gridList.getSelectData("gridHeadList");
		if (head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		var param = dataBind.paramData("searchArea");
		
		param.put("PROGID" , configData.MENU_ID);
		param.put("PRTCNT" , 1);
		param.put("head",head);
		
		var json = netUtil.sendData({
			url : "/wms/outbound/json/printDL31.data",
			param : param
		});
		
		if ( json && json.data ){
				var url = "<%=systype%>" + "/loading_list.ezg";
				var where = "PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				var width =  840;
				var heigth = 600;
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url , where , "" , langKy, map , width , heigth );
				
				
		}
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "CNLMAK" || colName == "CNLCFM" || colName == "PICCFM" || colName == "FWDCFM" || colName == "INDANGOOD" ){
				if(colValue == "V" || colValue == "Y"){
					return "impflg";	
				}else if($.trim(colValue) == "" || $.trim(colValue) == "N"){
					return "regAft";
				}
			}else if(colName == "SIMYN"){
				if(colValue == "V" || colValue == "Y"){
						return "regNot";	
				}else if($.trim(colValue) == "" || $.trim(colValue) == "N"){
					return "regAft";
				}
			}
		  
		} else if(gridId == "gridItemList"){
			if(colName == "INDDCL" || colName == "CNLMAK" || colName == "CNLCFM" || colName == "PICCFM" || colName == "INDANGOOD" || colName == "ALLNOT" || colName == "SIMYN" ){
				if(colValue == "V" || colValue == "Y"){
					if(colName == "ALLNOT" || colName == "SIMYN" ) {
						return "regNot";	
					} else {
						return "impflg";	
					}
				}else if($.trim(colValue) == "" || $.trim(colValue) == "N"){
					return "regAft";
				}
			}
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Shpcfm SAVE BTN_SHPCFM"></button>
		<button CB="Loadlist PRINT BTN_LOADLIST"></button>
	</div>
</div>

    <!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">

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
										
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
									
										<th CL="STD_RQSHPD"></th>
										<td>
											<input type="text" id="RQSHPD" name="RQSHPD" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px" validate="required(STD_SHPDGR)">
												<option value="" selected>선택</option>
											</select>
										</td>
								
									</tr>
						
									<tr>
										<th CL="STD_VEHINO"></th>
										<td>
											<select id="VEHINO" name="VEHINO"  UISave="false" ComboCodeView=false style="width:160px" >
												<option value="" selected>전체</option>
											</select>
										</td>
										
										<th CL="STD_DOCKNO"></th>
										<td>
											<input type="text" name="SH.DOCKNO" UIInput="SR" />
										</td>
						
										<th CL="STD_OUTFSH"></th>
										<td>
											<select id="OUTFSH" name="OUTFSH" style="width:160px">
												<option value="">전체</option>
												<option value="Y">Y</option>
												<option value="N" selected>N</option>
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
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="80 STD_WAREKY"    GCol="text,WARENM"></td>
												<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD" GF="D" ></td>
												<td GH="50 STD_SHPDGR"    GCol="text,SHPDGR"  ></td>
												<td GH="100 STD_VEHINO"    GCol="text,VEHINO"  ></td>
												<td GH="60 STD_DOCKNO"    GCol="text,DOCKNO"  ></td>
												<td GH="60 STD_CARCNT"    GCol="text,CARCNT"  ></td>
												<td GH="70 STD_CNLMAK"    GCol="icon,CNLMAK" GB="regAft"></td>
												<td GH="70 STD_ALLCNL"    GCol="icon,CNLCFM"  GB="regAft"></td>
												<td GH="70 STD_PKJMAK"    GCol="icon,PICCFM"  GB="regAft"></td>
												<td GH="70 STD_OUTFSH"    GCol="icon,FWDCFM"  GB="regAft"></td>
												<td GH="70 STD_INDANGOOD"    GCol="icon,INDANGOOD" GB="regAft"></td>
												<td GH="100 STD_SIMYN"    GCol="icon,SIMYN" GB="regAft"></td>
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
									<button type="button" GBtn="excel"></button>
									<!-- <button type="button" GBtn="total"></button> -->
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea2">
                        <li><a href="#tabs1-1"><span CL='STD_DETAIL'></span></a></li>
                    </ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="70 STD_SHPDSQ"    GCol="text,SHPDSQ" GF="N" ></td>
												<td GH="100 STD_SVBELN"    GCol="text,SVBELN"  ></td>
												<td GH="175 STD_SHCARN"    GCol="text,SHCARN"  ></td>
<!-- 												<td GH="70 STD_ALLNOT"    GCol="icon,ALLNOT" GB="regAft"></td> -->
												<td GH="70 STD_OUTFSH"    GCol="icon,INDDCL" GB="regAft"></td>
												<td GH="70 STD_CNLMAK"    GCol="icon,CNLMAK" GB="regAft"></td>
												<td GH="70 STD_ALLCNL"    GCol="icon,CNLCFM" GB="regAft"></td>
												<td GH="70 STD_PKJMAK"    GCol="icon,PICCFM" GB="regAft"></td>
												<td GH="70 STD_INDANGOOD"    GCol="icon,INDANGOOD" GB="regAft"></td>
												<td GH="100 STD_SIMYN"    GCol="icon,SIMYN" GB="regAft"></td>
												<td GH="70 STD_RTEMQTY"    GCol="text,RTEMQTY" GF="N" ></td>
												<td GH="70 STD_LTEMQTY"    GCol="text,LTEMQTY" GF="N" ></td>
												<td GH="100 STD_BYPQTY"    GCol="text,BYPQTY" GF="N" ></td>
												<td GH="70 STD_SUBQTY"    GCol="text,SUBQTY" GF="N" ></td>
												<td GH="70 STD_QTSHPC"    GCol="text,QTSHPC" GF="N" ></td>
												<td GH="100 STD_SHPDAT"    GCol="text,SHPDAT" GF="D" ></td>
												<td GH="100 STD_SHPTIM"    GCol="text,SHPTIM" GF="T" ></td>
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
									<button type="button" GBtn="excel"></button>
									<button type="button" GBtn="total"></button>
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
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>