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
</style> 
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
var tabindex = 1;
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList1",
	    	name : "gridHeadList1",
			editable : true,
			module : "WmsOutbound",
			command : "CL01",
            autoCopyRowType : false
	    });
    	
    	gridList.setGrid({
	    	id : "gridHeadList2",
	    	name : "gridHeadList2",
			editable : true,
			module : "WmsOutbound",
			command : "CL02",
            autoCopyRowType : false
	    });
    	
    	gridList.setReadOnly("gridHeadList1", true, ["WAREKY" , "BOXTYP" , "SKUCLS" , "LOTA06" , "REPMAK"]);
    	
    	gridList.setReadOnly("gridHeadList2", true, ["WAREKY" , "BOXTYP" , "SKUCLS" , "LOTA06"]);
    	
    	var val = day(0);

		searchShpdgr(val,1);
		searchShpdgr(val,2);
		
		$("#searchArea [id=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''),1);
			
		});
		
		$("#searchArea [id=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''),2);
			
		});
		
		getMaxSHPDGR(1);
		getMaxSHPDGR(2);
		
		$('#tab2').hide();
		$('#tab1').show();
		
		$(".top .tabs ul li").on("click",function(){
			
			var tabIdx = $(this).index();
			tabIdx = tabIdx+1;
			
			for(var i=1 ; i <= 2;i++){
				if(tabIdx != i){
					$('#tab'+i).hide();
				}
			}
			
			$('#tab'+tabIdx).show();
			
			tabindex = tabIdx;
			
		});
		
    });
    
    function searchShpdgr(val,tab){
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
		
		$("#SHPDGR"+tab).find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#SHPDGR"+tab).append(optionHtml)
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
    
    function getMaxSHPDGR(tab){
    	var param = new DataMap();
    		param.put("WAREKY","<%=wareky%>");
    	var json = netUtil.sendData({
            module : "WmsOutbound",
            command : "MAX_SHPDGR",
            sendType : "map",
            param : param
        });
    	
    	if($('#searchArea [name=RQSHPD]').val().replace(/\./g,'') == day(0)){
    		$('#SHPDGR'+tab).val(json.data["SHPDGR"]);	
    	}else{
    		$('#SHPDGR'+tab).val("");
    	}
    }
    
    // ?????? ?????? ?????? ?????????
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }else if(btnName == "Pickcl"){
        	saveData();
        }
    }
    
  //?????? ?????? 
	function searchList(){
		var param = dataBind.paramData("searchArea");
		
		gridList.resetGrid("gridHeadList");
		
		var param = inputList.setRangeParam("searchArea #tab1-"+tabindex);
		
		var id = "gridHeadList" + tabindex
		
        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : id,
		    	param : param
		    });
        }
		
	}
  
	function saveData(){
		
		if(tabindex == 1){
			var list = gridList.getSelectData("gridHeadList1");
			
			if(list.length < 1){
				commonUtil.msgBox("VALID_M0006"); //????????? ???????????? ????????????.
				return 
			}
			
			var chk = 0;
			for(var i=0; i < list.length ; i++){
				var cnlqty = parseInt(list[i].get("CNLQTY"));
				
				if(cnlqty < 1){
					chk++;
				}
			}
			
			if(chk > 0){
				alert("??????????????? 0 ?????? ????????? ?????????.");
				return;
			}
			
			var param = new DataMap();
				param.put("list",list);
				
			if(!commonUtil.msgConfirm("COMMON_M0120")){
	            return;
	        }
			
			netUtil.send({
				url : "/wms/outbound/json/saveCL01.data",
				param : param ,
				successFunction : "succsessSaveCallBack"
			});
		}else if(tabindex == 2){
			var list = gridList.getSelectData("gridHeadList2");
			
			if(list.length < 1){
				commonUtil.msgBox("VALID_M0006"); //????????? ???????????? ????????????.
				return 
			}
			
			
			var param = new DataMap();
				param.put("list",list);
				
			if(!commonUtil.msgConfirm("COMMON_M0120")){
	            return;
	        }
			
			netUtil.send({
				url : "/wms/outbound/json/saveCL02.data",
				param : param ,
				successFunction : "succsessSaveCallBack"
			});
		}
		
		
		
	}
	
	function succsessSaveCallBack1(json,status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0502");
			searchList();
		}
	}
	
    //????????? ?????? ???????????? Before?????????(?????? ???????????? ??????, ??????????????? ??????)
    function gridExcelDownloadEventBefore(gridId){
        var param = inputList.setRangeParam("searchArea");
        
        if(gridId == "gridItemList"){
            var rowNum = gridList.getSearchRowNum("gridHeadList");
            if(rowNum == -1){
                return false;
            }else{
                 param = getItemSearchParam(rowNum);
            }
        }
        return param;
    }

	// ????????? ?????? ????????? ?????????(??????), ?????? ???????????? ?????? ?????? ??????????????? ??? ?????? ?????? ??????
	function gridListEventRowFocus(gridId, rowNum){
		
	}
	
	// ????????? ????????? ?????? ??? ?????????
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(colName == "CNLQTY"){
			var qtjcmp = parseInt(gridList.getColData(gridId, rowNum, "QTJCMP"));
			var cnlqty = parseInt(colValue);
			
			if(cnlqty > qtjcmp){
				alert("????????? ?????? ??????????????? ?????? ??? ??? ????????????.");
				
				gridList.setColValue(gridId, rowNum, colName, 0	 );
				return;
			}
		}
	    
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
			
			if(name == "SC.SKUCLS" || name == "SKUCLS"){
				param.put("WARECODE","Y"); //?????????????????? Y ??????
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SKUCLS");	
			}else if(name == "ABCANV"){
				param.put("CODE", "ABCANV");
			}else if(name == "SHPDGR"){
				param.put("WARECODE","Y"); //?????????????????? Y ??????
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SHPDGR");
			}else if(name == "BOXTYP" || name == "GRBOXTYP"){
				param.put("WARECODE","Y"); //?????????????????? Y ??????
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "BOXTYP");
				param.put("USARG2"," ");
			}else if(name == "LOTA06"){
				param.put("CODE", "LOTA06");
				param.put("USARG1","V");
			}
			
			
			return param;
		}else if ( comboAtt == "WmsCommon,DOCTMCOMBO"){
            var param = new DataMap();
            param.put("PROGID", configData.MENU_ID);
            return param;
        }
	}
  
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if(searchCode == "SHSKUMA"){
			var param = new DataMap();

			skumaPopup.open(param,true);
			
			return false;
		}
	}
	
	function linkPopCloseEvent(data){
		var searchCode = data.get("searchCode");
		if(searchCode == "SHSKUMA"){
			skumaPopup.bindPopupData(data);
		}
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "REPMAK"){
				if(colValue == "V"){
					return "impflg";	
				}else if($.trim(colValue) == ""){
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
		<button CB="Pickcl SAVE BTN_PICKCL"></button>
	</div>
</div>

    <!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top" style="height:124px" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span >??????</span></a></li>
						<li><a href="#tabs1-2"><span >??????</span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<table class="table type1">
								<colgroup>
									<col width="50px" />
									<col width="250px" />
									<col width="50px" />
									<col width="250px" />
									<col width="50px" />
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
											<input type="text" name="RQSHPD" id="RQSHPD1" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR1" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px" validate="required(STD_SHPDGR)" >
												<option value="" selected>??????</option>
											</select>
										</td>
								
									</tr>
						
									<tr>
									
										<th CL="STD_BOXTYP"></th>
										<td>
											<select id="BOXTYP" name="BOXTYP"  Combo="Common,COMCOMBO" UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
						
										<th CL="STD_HARMYN2"></th>
										<td>
											<select id="HARMYN" name="HARMYN" style="width:160px">
												<option value="ALL" selected >??????</option>
												<option value="Y" >Y</option>
												<option value="N">N</option>
											</select>
										</td>
										
										<th CL="STD_SVBELN"></th>
										<td>
											<input type="text" name="SH.SVBELN" UIInput="SR" UIformat="U" UiRange="3" />
										</td>
										
									</tr>
									
									<tr>
									
										<th CL="STD_SBOXID"></th>
										<td>
											<input type="text" name="SB.SBOXID" UIInput="SR" UIformat="U" UiRange="3" />
										</td>
										
										<th CL="STD_BOXLAB"></th>
										<td>
											<input type="text" name="SB.BOXLAB" UIInput="SR" UIformat="U" UiRange="3" />
										</td>
										
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="SM.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U" UiRange="3" />
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					
					<div id="tabs1-2">
						<div class="section type1">
							<table class="table type1">
								<colgroup>
									<col width="50px" />
									<col width="250px" />
									<col width="50px" />
									<col width="250px" />
									<col width="50px" />
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
											<input type="text" id="RQSHPD2" name="RQSHPD" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR2" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px" validate="required(STD_SHPDGR)" >
												<option value="" selected>??????</option>
											</select>
										</td>
								
									</tr>
						
									<tr>
						
										<th CL="STD_HARMYN2"></th>
										<td>
											<select id="HARMYN" name="HARMYN" style="width:160px">
												<option value="ALL">??????</option>
												<option value="Y" selected>Y</option>
												<option value="N">N</option>
											</select>
										</td>
										
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="SM.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U" UiRange="3" />
										</td>
										
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					
				</div>
			</div>
			
			<div id="tab1">
				<div class="bottomSect bottomT">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL='STD_SEARCH'></span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2" >
									<div class="tableBody">
										<table>
											<tbody id="gridHeadList1">
												<tr CGRow="true">
													<td GH="40"                GCol="rownum">1</td>
													<td GH="40"                GCol="rowCheck"></td>
													<td GH="80 STD_WAREKY"    GCol="select,WAREKY"  >
														<select Combo="WmsCommon,ROLCTWAREKY" id="WAREKY" name="WAREKY" ComboCodeView=false></select>
													</td>
													<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD" GF="D" ></td>
													<td GH="50 STD_SHPDGR"    GCol="text,SHPDGR"  ></td>
													<td GH="100 STD_VEHINO"    GCol="text,VEHINO"  ></td>
													<td GH="50 STD_DOCKNO"    GCol="text,DOCKNO"  ></td>
													<td GH="50 STD_CARCNT"    GCol="text,CARCNT"  ></td>
													<td GH="100 STD_SVBELN"    GCol="text,SVBELN"  ></td>
													<td GH="130 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
													<td GH="240 STD_DESC01"    GCol="text,DESC01"  ></td>
													<td GH="60 STD_PACKYN"    GCol="text,PACKYN"  ></td>
													<td GH="60 STD_PACQTY"    GCol="text,PACQTY" GF="N" ></td>
													<td GH="100 STD_LOTA06"    GCol="select,LOTA06"  >
														<select Combo="Common,COMCOMBO" id="LOTA06" name="LOTA06" ComboCodeView=false></select>
													</td>
													<td GH="100 STD_QTJCMP"    GCol="text,QTJCMP" GF="N" ></td>
													<td GH="100 STD_CANWORKCNT"    GCol="input,CNLQTY" validate="required gt(0),MASTER_M4002" GF="N 4,0" ></td>
													<td GH="90 STD_BOXTYP"    GCol="select,BOXTYP"  >
														<select Combo="Common,COMCOMBO" id="BOXTYP" name="GRBOXTYP" ComboCodeView=false></select>
													</td>
													<td GH="100 STD_SBOXSQ"    GCol="text,SBOXSQ"  ></td>
													<td GH="70 STD_REPMAK"    GCol="icon,REPMAK" GB="regAft" ></td>
													<td GH="100 STD_SBOXID"    GCol="text,SBOXID"  ></td>
													<td GH="100 STD_BOXLAB"    GCol="text,BOXLAB"  ></td>
													<td GH="100 STD_SKUCLS"    GCol="select,SKUCLS"  >
														<select Combo="Common,COMCOMBO" id="SKUCLS" name="SKUCLS" ComboCodeView=false></select>
													</td>
													<td GH="100 STD_HARMYN"    GCol="text,HARMYN"  ></td>
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
			
			<div id="tab2">
				<div class="bottomSect bottomT">
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL='STD_SEARCH'></span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2" >
									<div class="tableBody">
										<table>
											<tbody id="gridHeadList2">
												<tr CGRow="true">
													<td GH="40"                GCol="rownum">1</td>
													<td GH="40"                GCol="rowCheck"></td>
													<td GH="100 STD_WAREKY"    GCol="select,WAREKY"  >
														<select Combo="WmsCommon,ROLCTWAREKY" id="WAREKY" name="WAREKY" ComboCodeView=false></select>
													</td>
													<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD" GF="D" ></td>
													<td GH="100 STD_SHPDGR"    GCol="text,SHPDGR"  ></td>
													<td GH="100 STD_BOXTYP"    GCol="select,BOXTYP"  >
														<select Combo="Common,COMCOMBO" id="BOXTYP" name="BOXTYP" ComboCodeView=false></select>
													</td>
													<td GH="100 STD_SKUCLS"    GCol="select,SKUCLS"  >
														<select Combo="Common,COMCOMBO" id="SKUCLS" name="SKUCLS" ComboCodeView=false></select>
													</td>
													<td GH="100 STD_HARMYN"    GCol="text,HARMYN"  ></td>
													<td GH="130 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
													<td GH="240 STD_DESC01"    GCol="text,DESC01"  ></td>
													<td GH="100 STD_LOTA06"    GCol="select,LOTA06"  >
														<select Combo="Common,COMCOMBO" id="LOTA06" name="LOTA06" ComboCodeView=false></select>
													</td>
													<td GH="100 STD_QTJCMP"    GCol="text,QTJCMP" GF="N" ></td>
													<td GH="100 STD_CANWORKCNT"    GCol="text,CNLQTY" GF="N" ></td>
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
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>