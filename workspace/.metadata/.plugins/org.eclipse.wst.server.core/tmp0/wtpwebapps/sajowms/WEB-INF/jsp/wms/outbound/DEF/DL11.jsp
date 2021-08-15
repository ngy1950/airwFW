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
.redflg{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn25.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
</style>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>  
<script type="text/javascript">
var pkjmak , skucls , excelrow = -1;
var labelNM = "";
	midAreaHeightSet = "200px";
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "DL11",
// 			itemGrid : "gridItemList",
            itemSearch : true,
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList",
	    	name : "gridItemList",
			editable : true,
			module : "WmsOutbound",
			command : "DL11SUB",
            autoCopyRowType : false
	    });
		
		gridList.setReadOnly("gridHeadList", true, ["WAREKY","SKUCLS"]);
		gridList.setReadOnly("gridItemList", true, ["PKJMAK"]);
		
		var val = day(0);

		searchShpdgr(val);
		$("#searchArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
		
		$("#searchArea [name=SHPDGR]").on("change",function(){
			searchvehino($('#RQSHPD').val().replace(/\./g,''),$(this).val());
			
		});
		
		getLabelName();
		
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
			param.put("PROGID" , configData.MENU_ID);
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "VEHINO_S_DL11",
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
    
    function getLabelName(){
    	var param = new DataMap();
    	    param.put("WAREKY","<%=wareky%>");
    	var json = netUtil.sendData({
            module : "WmsOutbound",
            command : "OUTBOUND_LABEL_NAME",
            sendType : "map",
            param : param
        });
    	
    	labelNM = json.data["CDESC1"];
    }
    
    // 공통 버튼 클릭 이벤트
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }else if(btnName == "Pickcomp"){
        	saveData();
        }else if(btnName == "Picklist"){
        	print("list");
        } else if(btnName == "Fwdlabel"){
        	print("label");
        }else if(btnName == "Cnlbypass"){
        	var row = gridList.getFocusRowNum("gridHeadList");
        	if(row == -1){
        		alert("선택된 데이터가 없습니다.");
        		return false;
        	}
        	var data = gridList.getRowData("gridHeadList", row);
 			page.linkPopOpen("/wms/outbound/POP/DL11POP.page", data);
        }else if(btnName == "PickEnd"){
        	pickEnd();
        }
    }
    
  //헤더 조회 
	function searchList(){
		pkjmak = $('#PKJMAK').val();
		skucls = $('#SKUCLS').val();
		gridList.setReadOnly("gridItemList", false, ["PCWORKQTY"]);
		
		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridItemList");
		
		var param = inputList.setRangeParam("searchArea");
			param.put("GBN","WEB");

        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }
		
	}
    
	function saveData(){
		
		
		
		var param = new DataMap();
		
		var head = gridList.getSelectData("gridHeadList");
// 		var head;
		var list = gridList.getGridData("gridItemList");
		
		if( list.length == 0 ){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return;
		}
		
// 		if(list.length > 0){
// 			var grpoky = list[0].get("GRPOKY");
// 			var vehino = list[0].get("VEHINO");
// 			var skucls = list[0].get("SKUCLS");
			

// 			var headlist = gridList.getGridData("gridHeadList");	
			
// 			for(var i=0;i< headlist.length;i++){
// 				var hgrpoky = headlist[i].get("GRPOKY");
// 				var hvehino = headlist[i].get("VEHINO");
// 				var hskucls = headlist[i].get("SKUCLS");
				
// 				if(grpoky == hgrpoky && vehino == hvehino && skucls == hskucls){
// 					//gridList.setRowCheck("gridHeadList", i, true);
// 					//head = gridList.getSelectData("gridHeadList");
// 					head = [headlist[i]];
// 					break;
// 				}
// 			}
// 		}

		
		console.log("head",head);
		
// 		return false;
		
		if(head.length < 1){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return ;
		}
		
		if(pkjmak != "1"){
			alert("작업상태가 미작업 일때만 피킹 완료가 가능합니다.\작업상태 변경후 재조회 후 진행 하시기 바랍니다.");
			return;
		}
		
		var chk = true;
		
		for(var i=0;i<head.length;i++){
			var pkjmak2 = head[i].get("PKJMAK");
			if(pkjmak2 == "V"){
				chk = false;
				break;
			}
			
		}
		
		if(!chk){
			alert("피킹 완료된 정보가 포함 되어 있습니다.");
			return;
		}
		
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
            return;
        }
		
		param.put("PROGTP","WEB");
		param.put("head",head);
		param.put("list",list);
		
		netUtil.send({
			url : "/wms/outbound/json/saveDL11.data",
			param : param ,
			successFunction : "succsessSaveCallBack"
		});
		
	}
	
	function succsessSaveCallBack(json , status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0564");
			searchList();
		}
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){
			gridList.setReadOnly("gridHeadList", true, ["BOXMAK","CARMAK","SHPDIC","PKJMAK","INDANGOOD"]);
			
// 			for(var i=0;i<dataLength;i++){
// 				var pkmak = gridList.getColData(gridId, i, "PKJMAK");
// 				if(pkmak == "V"){
// 					gridList.setRowReadOnly("gridHeadList", i, true, ["rowCheck"]);
// 				}else{
// 					gridList.setRowReadOnly("gridHeadList", i, false, ["rowCheck"]);
// 				}
// 			}
			
			subsearchlist(gridId,0,"gridItemList");
		}else if(gridId == "gridHeadList" && dataLength <= 0){
			excelrow = -1
			gridList.resetGrid("gridItemList");
            searchOpen(true);
		}else if(gridId =="gridItemList"){
			if(pkjmak == '1'){
			}else if(pkjmak == '2'){
				gridList.setReadOnly("gridItemList", true, ["PKJMAK","PCWORKQTY"]);
			}else if(pkjmak == '0'){
				gridList.setReadOnly("gridItemList", true, ["PKJMAK","PCWORKQTY"]);
			}
		}
	}
	
    
    // 그리드 item 조회 이벤트
    function subsearchlist(gridId, rowNum, itemList){  
        var param = getItemSearchParam(rowNum);
        	param.put("PKJMAK",pkjmak);
			
        gridList.gridList({
            id : "gridItemList",
            param : param
        });
    }
    
    // 아이템 그리드 Parameter
    function getItemSearchParam(rowNum){
    	excelrow = rowNum;
        var rowData = gridList.getRowData("gridHeadList", rowNum);
        var param = new DataMap();
        param.putAll(rowData);
        
        return param;
    }
    
    //그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
    function gridExcelDownloadEventBefore(gridId){
        var param = inputList.setRangeParam("searchArea");
        
        if(gridId == "gridItemList"){
            if(excelrow == -1){
                return false;
            }else{
                 param = getItemSearchParam(excelrow);
            }
        }
        return param;
    }

    
    function gridListEventRowDblclick(gridId, rowNum){
    	if(gridId == "gridHeadList"){
    		subsearchlist(gridId, rowNum, "gridItemList");	
    	}
    }
    
	// 그리드 클릭 포커스 이벤트(클릭), 수정 데이터가 있을 경우 컨펌메세지 후 이동 또는 복귀
	function gridListEventRowFocus(gridId, rowNum){

	}
	
	function gridListEventRowClick(id, rowNum, colName){

	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
	    if(gridId == "gridItemList"){
			var qtjcmp	= parseInt(gridList.getColData(gridId, rowNum, "QTJCMP"));
			var pcowrkqty = parseInt(gridList.getColData(gridId, rowNum, "PCWORKQTY"));
			var bepcowrkqty = parseInt(gridList.getColData(gridId, rowNum, "BEPCWORKQTY"));
			var qyshpo = parseInt(gridList.getColData(gridId, rowNum, "QTSHPO")); 
			var itvehino = gridList.getColData(gridId, rowNum, "VEHINO"); var itskucls = gridList.getColData(gridId, rowNum, "SKUCLS");
			var itdockno = gridList.getColData(gridId, rowNum, "DOCKNO"); var itvehino = gridList.getColData(gridId, rowNum, "CARCNT");
			
 			if(pcowrkqty > bepcowrkqty ){
 				alert("입력 가능한 수량이 아닙니다.");
 				if(pkjmak == "1"){
 					gridList.setColValue(gridId, rowNum, "PCWORKQTY", bepcowrkqty);
 				}
 				return ;
 			}
 			var head = gridList.getGridData("gridHeadList");
 			
 			var row = -1;
 			
 			for(var i=0 ;i < head.length ;i ++){
 				var hrow = head[i];
 				var vehino = hrow.get("VEHINO"); 
 				var skucls = hrow.get("SKUCLS");
 				var dockno = hrow.get("DOCKNO"); 
 				var vehino = hrow.get("CARCNT");
 				
 				if(vehino + skucls + dockno + vehino == itvehino + itskucls + itdockno + itvehino){
 					row = i;
 					break;
 				}
 			}
 			gridList.setRowCheck("gridHeadList",  row , true);
	    }
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
    
  //콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			
			if(name == "SKUCLSH" || name == "SKUCLS"){
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
			}
			
			return param;
		}
	}
  
	function print(gbn){
 		var head = gridList.getSelectData("gridHeadList");
		if (head.length == 0){
			commonUtil.msgBox("VALID_M0006");
			return;
		}
		var param = dataBind.paramData("searchArea");
		var chk=0;
		var chk2=0;
		for(var i=0 ; i <head.length; i++){
			var allcancel = head[i].get("ALLCANCEL");
			var pkmak = head[i].get("PKJMAK");
			if(allcancel == "N"){
				chk++;
			}
			
		}
		if(gbn=="label"){
			if(chk > 0){
				commonUtil.msgBox("전체 취소된 차량이 포함 되어 있습니다.");
				return;
			}
			
		}
		
		param.put("PROGID" , configData.MENU_ID);
		param.put("PRTCNT" , 1);
		param.put("head",head);
		param.put("GBN",gbn);
		
		var json = netUtil.sendData({
			url : "/wms/outbound/json/printDL11.data",
			param : param
		});
		
		if ( json && json.data ){
				var url = "",width = 0,height=0;
				if(gbn=='list'){
						url = "<%=systype%>" + "/bypass_picking_list.ezg";
					width = 600;
					height = 800;
				}else if(gbn=="label"){
					url = "<%=systype%>" + "/" + labelNM + ".ezg";
					
					
					
					if(labelNM.indexOf("_b") > 0){
						height = 255;
						width = 316;
					}else{
						height = 203;
						width = 316;
					}
				}
				
				var where = "PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url , where , "" , langKy, map , width , height );
				
				
		}
	}
	
	
	
  	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "PKJMAK"){
				if(colValue == "V"){
					return "impflg";	
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}else if(colName == "ALLCANCEL"){
				if(colValue == "N"){
					return "redflg";	
				}else if(colValue == "Y"){
					return "regAft";
				}
			}else if(colName == "PRINTSTATUS"){
				if(colValue == "Y"){
					return "impflg";	
				}else if(colValue == "N"){
					return "regAft";
				}
			}
		} else if(gridId == "gridItemList"){
			if(colName == "PKJMAK"){
				if(colValue == "V"){
					return "impflg";	
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
		}
	}
  	
	function pickEnd(){
		
		var param = new DataMap();
		var head = gridList.getSelectData("gridHeadList");
		
		if(head.length < 1){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return ;
		}
		
// 		if(pkjmak != "1"){
// 			alert("작업상태가 미작업 일때만 피킹 완료가 가능합니다.\작업상태 변경후 재조회 후 진행 하시기 바랍니다.	");
// 			return;
// 		}
		
// 		var chk = true;
		
// 		for(var i=0;i<head.length;i++){
// 			var pkjmak2 = head[i].get("PKJMAK");
// 			if(pkjmak2 == "V"){
// 				chk = false;
// 				break;
// 			}
			
// 		}
		
// 		if(!chk){
// 			alert("피킹 완료된 정보가 포함 되어 있습니다.");
// 			return;
// 		}
		
		if(!commonUtil.msgConfirm("작업을 취소 하시겠습니까?")){
            return;
        }
		
		param.put("GBN","WEB");
		param.put("head",head);
		
		var json = netUtil.sendData({
			url : "/wms/outbound/json/savePickcancel.data",
			param : param,
		});
		
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0564");
			searchList();
		}
	}
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Picklist PRINT BTN_PICKLIST"></button>
		<button CB="Fwdlabel PRINT BTN_FWDLABEL"></button>
		<button CB="Pickcomp SAVE BTN_PICKCOMP"></button>
		<button CB="Cnlbypass SEARCH BTN_CNLBYPASS"></button>
		<button CB="PickEnd SAVE BTN_PICKEND"></button>
	</div>
</div>

    <!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top" style="height:120px" id="searchArea">
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
										<input type="hidden" id="OWNRKY" name="OWNRKY" value="<%=ownrky%>" />
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
									
										<th CL="STD_RQSHPD"></th>
										<td>
											<input type="text" name="RQSHPD" id="RQSHPD" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px" validate="required(STD_SHPDGR)" >
												<option value="" selected>선택</option>
											</select>
										</td>
								
									</tr>
						
									<tr>
						
										<th CL="STD_WORKCDT"></th>
										<td>
											<select id="PKJMAK" name="PKJMAK" style="width:160px">
												<option value="0" >전체</option>
												<option value="1" selected >미작업</option>
												<option value="2" >피킹완료</option>
											</select>
										</td>
										
										<th CL="STD_VEHINO"></th>
										<td>
											<select id="VEHINO" name="VEHINO"  UISave="false" ComboCodeView=false style="width:160px" >
												<option value="" selected>전체</option>
											</select>
										</td>
										
										<th CL="STD_SKUCLS"></th>
										<td>
											<select id="SKUCLS" name="SKUCLS" Combo="Common,COMCOMBO"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="" >전체</option>
											</select>
										</td>
										
									</tr>
									<tr>
										<th CL="STD_CARCNT"></th>
										<td>
											<input type="text" name="CARCNT" UIformat="U" />
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
												<td GH="40"               GCol="rownum">1</td>
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="80 STD_WAREKY"    GCol="text,WAREKYNM" ></td>
												<td GH="90 STD_RQSHPD"    GCol="text,RQSHPD" GF="D" ></td>
												<td GH="50 STD_SHPDGR"    GCol="text,SHPDGR"  GF="N" ></td>
												<td GH="80 STD_SHPMTY"    GCol="text,SHPMTYNM" ></td>
												<td GH="70 STD_PKJMAK"    GCol="icon,PKJMAK" GB="regAft"></td>
												<td GH="100 STD_VEHINO"    GCol="text,VEHINO"  ></td>
												<td GH="100 STD_SKUCLSNM"    GCol="text,SKUCLSNM"  ></td>
												<td GH="50 STD_DOCKNO"    GCol="text,DOCKNO"  ></td>
												<td GH="50 STD_CARCNT"    GCol="text,CARCNT"  ></td>
												<td GH="70 STD_QTSHPO"    GCol="text,QTSHPO"  GF="N" ></td>
												<td GH="70 STD_QTJCMP"    GCol="text,QTJCMP"  GF="N" ></td>
												<td GH="80 STD_NQTJCMP"    GCol="text,NQTJCMP"  GF="N" ></td>
												<td GH="70 STD_QTSHPC"    GCol="text,QTSHPC"  GF="N" ></td>
												<td GH="100 STD_LMOUSRNM"    GCol="text,LMOUSRNM" ></td>
												<td GH="70 STD_ALLCANCEL"    GCol="icon,ALLCANCEL" GB="regAft"></td>
												<td GH="110 STD_PRINTSTATUS"    GCol="icon,PRINTSTATUS" GB="regAft"></td>
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
												<td GH="40"               GCol="rownum">1</td>
												<td GH="130 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
												<td GH="240 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="60 STD_PACKYN"    GCol="text,PACKYN"  ></td>
												<td GH="60 STD_PACQTY"    GCol="text,PACQTY" GF="N" ></td>
												<td GH="80 STD_LOTA06NM"    GCol="text,LOTA06NM"  ></td>
												<td GH="100 STD_LOCAKY"    GCol="text,LOCAKY"  ></td>
												<td GH="100 STD_PKJMAK"    GCol="icon,PKJMAK" GB="regAft"></td>
												<td GH="80 STD_CURQTY"    GCol="text,QTSIWH"  GF="N" ></td>
												<td GH="80 STD_QTSHPO"    GCol="text,QTSHPO"  GF="N" ></td>
												<td GH="80 STD_QTJCMP"    GCol="text,QTJCMP"  GF="N" ></td>
												<td GH="100 STD_NQTJCMP"    GCol="input,PCWORKQTY" validate="required gt(-1),0&nbsp;이상의&nbsp;값&nbsp;이여야&nbsp;합니다." GF="N 4,0" ></td>
												<td GH="80 STD_QTSHPC"    GCol="text,QTSHPC"  GF="N" ></td>
												<td GH="80 STD_CNLQTY"    GCol="text,CNLQTY"  GF="N" ></td>
												<td GH="100 STD_CNLPCQTY"    GCol="text,CNLPCQTY"  GF="N" ></td>
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