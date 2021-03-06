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
var allcheck = true;
var rowcheck = true;
	midAreaHeightSet = "200px";
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "DL12",
// 			itemGrid : "gridItemList",
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList",
	    	name : "gridItemList",
			editable : true,
			module : "WmsOutbound",
			command : "DL12SUB",
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
    
    // ?????? ?????? ?????? ?????????
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }else if(btnName == "Pickcomp"){
        	saveData();
        }else if(btnName == "Picklist"){
        	print("list");
        } else if(btnName == "Fwdlabel"){
        	print("label");
        }
    }
    
  //?????? ?????? 
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
		var list = gridList.getSelectData("gridItemList");
		
		if( list.length == 0 ){
			commonUtil.msgBox("VALID_M0006"); //????????? ???????????? ????????????.
			return;
		}

		if(head.length < 1){
			commonUtil.msgBox("VALID_M0006"); //????????? ???????????? ????????????.
			return ;
		}
		
		if(pkjmak != "1"){
			alert("??????????????? ????????? ????????? ?????? ????????? ???????????????.\???????????? ????????? ????????? ??? ?????? ????????? ????????????.");
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
			alert("?????? ????????? ????????? ?????? ?????? ????????????.");
			return;
		}
		
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
            return;
        }
		
		param.put("PROGTP","WEB");
		param.put("head",head);
		param.put("list",list);
		
		netUtil.send({
			url : "/wms/outbound/json/saveDL12.data",
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
	
	// ????????? AJAX ?????? ????????? ????????? ????????????  ?????????(?????? ????????? ??????)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){
// 			gridList.setReadOnly("gridHeadList", true, ["BOXMAK","CARMAK","SHPDIC","PKJMAK","INDANGOOD"]);
			
			subsearchlist(gridId,0,"gridItemList");
		}else if(gridId == "gridHeadList" && dataLength <= 0){
			excelrow = -1
			gridList.resetGrid("gridItemList");
            searchOpen(true);
		}else if(gridId =="gridItemList"){
// 			if(pkjmak == '1'){
// 			}else if(pkjmak == '2'){
// 				gridList.setReadOnly("gridItemList", true, ["PKJMAK","PCWORKQTY"]);
// 			}else if(pkjmak == '0'){
// 				gridList.setReadOnly("gridItemList", true, ["PKJMAK","PCWORKQTY"]);
// 			}
		}
	}
	
    
    // ????????? item ?????? ?????????
    function subsearchlist(gridId, rowNum, itemList){  
        var param = getItemSearchParam(rowNum);
        	param.put("PKJMAK",pkjmak);
			
        gridList.gridList({
            id : "gridItemList",
            param : param
        });
    }
    
    // ????????? ????????? Parameter
    function getItemSearchParam(rowNum){
    	excelrow = rowNum;
        var rowData = gridList.getRowData("gridHeadList", rowNum);
        var param = new DataMap();
        param.putAll(rowData);
        
        return param;
    }
    
    //????????? ?????? ???????????? Before?????????(?????? ???????????? ??????, ??????????????? ??????)
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
    		gridList.setRowCheck(gridId, rowNum, false);
    		subsearchlist(gridId, rowNum, "gridItemList");	
    	}
    }
    
	// ????????? ?????? ????????? ?????????(??????), ?????? ???????????? ?????? ?????? ??????????????? ??? ?????? ?????? ??????
	function gridListEventRowFocus(gridId, rowNum){

	}
	
	function gridListEventRowClick(id, rowNum, colName){

	}
	
	function gridListEventRowCheck(gridId , rowNum , checkType){
		if(!allcheck){
			return false;
		}
		
		if(gridId == "gridItemList"){
			rowcheck = false;
			if(checkType){
				var vehino = gridList.getColData(gridId, rowNum, "VEHINO");
				var skucls = gridList.getColData(gridId, rowNum, "SKUCLS");
				var head = gridList.getGridData("gridHeadList");
				
				for(var i=0;i<head.length;i++){
					var hvehino = head[i].get("VEHINO");
					var hskucls = head[i].get("SKUCLS");
					if(vehino == hvehino && hskucls == skucls ){
						gridList.setRowCheck("gridHeadList", i, true);
						break;
					}
				}
			}else{
				var rown = gridList.getSelectRowNumList("gridItemList");
				if(rown.length == 0){
					var vehino = gridList.getColData(gridId, rowNum, "VEHINO");
					var skucls = gridList.getColData(gridId, rowNum, "SKUCLS");
					var head = gridList.getGridData("gridHeadList");
					
					for(var i=0;i<head.length;i++){
						var hvehino = head[i].get("VEHINO");
						var hskucls = head[i].get("SKUCLS");
						if(vehino == hvehino && hskucls == skucls){
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
				var hskucls = gridList.getColData(gridId, rowNum, "SKUCLS");
				var mvehino = gridList.getColData("gridItemList", 0, "VEHINO");
				var mskucls = gridList.getColData("gridItemList", 0, "SKUCLS");
				if(hvehino == mvehino && hskucls == mskucls){
					gridList.checkAll("gridItemList", true);	
				}
				
			}else{
				var hvehino = gridList.getColData(gridId, rowNum, "VEHINO");
				var hskucls = gridList.getColData(gridId, rowNum, "SKUCLS");
				var mvehino = gridList.getColData("gridItemList", 0, "VEHINO");
				var mskucls = gridList.getColData("gridItemList", 0, "SKUCLS");
				if(hvehino == mvehino && hskucls == mskucls){
					gridList.checkAll("gridItemList", false);	
				}
				
			}
		}
		
	}
	
	// ????????? ????????? ?????? ??? ?????????
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
	    if(gridId == "gridItemList"){
			var qtjcmp	= parseInt(gridList.getColData(gridId, rowNum, "QTJCMP"));
			var pcowrkqty = parseInt(gridList.getColData(gridId, rowNum, "PCWORKQTY"));
			var bepcowrkqty = parseInt(gridList.getColData(gridId, rowNum, "BEPCWORKQTY"));
			var qyshpo = parseInt(gridList.getColData(gridId, rowNum, "QTSHPO")); 
			var itvehino = gridList.getColData(gridId, rowNum, "VEHINO"); var itskucls = gridList.getColData(gridId, rowNum, "SKUCLS");
			var itdockno = gridList.getColData(gridId, rowNum, "DOCKNO"); var itvehino = gridList.getColData(gridId, rowNum, "CARCNT");
			
 			if(pcowrkqty > bepcowrkqty ){
 				alert("?????? ????????? ????????? ????????????.");
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
 			if(pcowrkqty == 0){
 				gridList.setRowCheck("gridHeadList",  row , false);
 			}else{
 				gridList.setRowCheck("gridHeadList",  row , true);
 			}
 			
	    }
	}
	
	function gridListEventRowCheckAll(gridId, checkType){
		allcheck = false;
		if(gridId == "gridItemList"){
			if(checkType){
				var vehino = gridList.getColData(gridId, 0, "VEHINO");
				var skucls = gridList.getColData(gridId, 0, "SKUCLS");
				var head = gridList.getGridData("gridHeadList");
				
				for(var i=0;i<head.length;i++){
					var hskucls = head[i].get("SKUCLS");
					var hvehino = head[i].get("VEHINO");
					if(vehino == hvehino && hskucls == skucls ){
						gridList.setRowCheck("gridHeadList", i, true);
						break;
					}
				}
			}else{
				var vehino = gridList.getColData(gridId, 0, "VEHINO");
				var skucls = gridList.getColData(gridId, 0, "SKUCLS");
					var head = gridList.getGridData("gridHeadList");
					
					for(var i=0;i<head.length;i++){
						var hskucls = head[i].get("SKUCLS");
						var hvehino = head[i].get("VEHINO");
						if(vehino == hvehino && hskucls == skucls ){
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
	
	// ????????? Row ?????? ??? ?????????
    function gridListEventRowAddBefore(gridId, rowNum){
        
    }
    
     // ????????? Row ?????? ??? ?????????
    function gridListEventRowAddAfter(gridId, rowNum){
    } 
    
    // ????????? ?????? format??? ???????????? ?????? ????????? ????????? 
    function gridListEventColFormat(gridId, rowNum, colName){

    }
	
	//???????????? Before ????????? (????????? ????????? ??? ??????)
	function searchHelpEventOpenBefore(searchCode, gridType){

	}
    
  //?????? Before ?????????(?????? ????????? ????????? ??? ??????)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			var id = $(paramName).attr("id");
			
			if(name == "SKUCLSH" || name == "SKUCLS"){
				param.put("WARECODE","Y"); //?????????????????? Y ??????
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SKUCLS");	
				param.put("USARG1","03");
			}else if(name == "ABCANV"){
				param.put("CODE", "ABCANV");
			}else if(name == "SHPDGR"){
				param.put("WARECODE","Y"); //?????????????????? Y ??????
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SHPDGR");
			}else if(name == "BOXTYP"){
				param.put("WARECODE","Y"); //?????????????????? Y ??????
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
		
		param.put("PROGID" , configData.MENU_ID);
		param.put("PRTCNT" , 1);
		param.put("head",head);
		param.put("GBN",gbn);
		
		var json = netUtil.sendData({
			url : "/wms/outbound/json/printDL12.data",
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
			}else if(colName == "CNLMAK"){
				if(colValue == "N"){
					return "redflg";	
				}else if(colValue == "Y"){
					return "regAft";
				}
			}
// 			else if(colName == "PRINTSTATUS"){
// 				if(colValue == "Y"){
// 					return "impflg";	
// 				}else if(colValue == "N"){
// 					return "regAft";
// 				}
// 			}
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
  	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
        
        if( gridId == "gridItemList" ){
        	var pkjmak = gridList.getColData("gridItemList", rowNum, "PKJMAK");
 
			if(pkjmak == 'V' ){
				return true;
			}
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
												<option value="" selected>??????</option>
											</select>
										</td>
								
									</tr>
						
									<tr>
						
										<th CL="STD_WORKCDT"></th>
										<td>
											<select id="PKJMAK" name="PKJMAK" style="width:160px">
												<option value="0" >??????</option>
												<option value="1" selected >?????????</option>
												<option value="2" >????????????</option>
											</select>
										</td>
										
										<th CL="STD_VEHINO"></th>
										<td>
											<select id="VEHINO" name="VEHINO"  UISave="false" ComboCodeView=false style="width:160px" >
												<option value="" selected>??????</option>
											</select>
										</td>
										
										<th CL="STD_SKUCLS"></th>
										<td>
											<select id="SKUCLS" name="SKUCLS" Combo="Common,COMCOMBO"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="" >??????</option>
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
												<td GH="70 STD_CNLMAK"    GCol="icon,CNLMAK" GB="regAft"></td>
												<td GH="100 STD_LMOUSRNM"    GCol="text,LMOUSRNM" ></td>
<!-- 												<td GH="110 STD_PRINTSTATUS"    GCol="icon,PRINTSTATUS" GB="regAft"></td> -->
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
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="100 STD_SVBELN"    GCol="text,SVBELN"  ></td>
												<td GH="230 STD_SHCARN"    GCol="text,SHCARN"  ></td>
												<td GH="100 STD_BOXLAB"    GCol="text,BOXLAB"  ></td>
												<td GH="80 STD_SUSRNM"    GCol="text,SUSRNM"  ></td>
												<td GH="80 STD_LOTA06NM"    GCol="text,LOTA06NM"  ></td>
												<td GH="100 STD_LOCAKY"    GCol="text,LOCAKY"  ></td>
												<td GH="130 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
												<td GH="240 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="60 STD_PACKYN"    GCol="text,PACKYN"  ></td>
												<td GH="60 STD_PACQTY"    GCol="text,PACQTY" GF="N" ></td>
												<td GH="100 STD_PKJMAK"    GCol="icon,PKJMAK" GB="regAft"></td>
												<td GH="80 STD_CURQTY"    GCol="text,QTSIWH"  GF="N" ></td>
												<td GH="80 STD_QTSHPO"    GCol="text,QTSHPO"  GF="N" ></td>
												<td GH="80 STD_QTJCMP"    GCol="text,QTJCMP"  GF="N" ></td>
												<td GH="100 STD_NQTJCMP"    GCol="input,PCWORKQTY" validate="required gt(-1),0&nbsp;?????????&nbsp;???&nbsp;?????????&nbsp;?????????." GF="N 4,0" ></td>
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