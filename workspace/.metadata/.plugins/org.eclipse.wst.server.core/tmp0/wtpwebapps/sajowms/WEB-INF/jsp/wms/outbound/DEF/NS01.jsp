<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript">
var boxtyp;
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "NS01",
            itemSearch : true,
            autoCopyRowType : false
	    });
                      
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
    
    // ?????? ?????? ?????? ?????????
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }else if(btnName == "Save"){
        	saveData();
        }else if(btnName == "Save2"){
        	alert("????????????..."	);
        }
    }
    
  //?????? ?????? 
	function searchList(){
		boxtyp = $('#BOXTYP').val();
		
		gridList.resetGrid("gridHeadList");
		
		var param = inputList.setRangeParam("searchArea");

        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }
		
	}
    
	function saveData(){
		
		var list = gridList.getSelectData("gridHeadList");
		

		if( list.length == 0 ){
			commonUtil.msgBox("VALID_M0006"); //* ????????? ???????????? ????????????.
			return;
		}
		
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
            return;
        }
		
		var param = new DataMap();
			param.put("list",list);
		
		netUtil.send({
			url : "/wms/outbound/json/saveNS01.data",
			param : param ,
			successFunction : "succsessSaveCallBack"
		});
		
	}
	
	function succsessSaveCallBack(json,status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0815",json.data);
			searchList();
		}
	}
	
	// ????????? AJAX ?????? ????????? ????????? ????????????  ?????????(?????? ????????? ??????)
	function gridListEventDataBindEnd(gridId, dataLength){
	}
	
    // ????????? item ?????? ?????????
    function gridListEventItemGridSearch(gridId, rowNum, itemList){  

    }
    
    // ????????? ????????? Parameter
    function getItemSearchParam(rowNum){

    }
    
    //????????? ?????? ???????????? Before?????????(?????? ???????????? ??????, ??????????????? ??????)
    function gridExcelDownloadEventBefore(gridId){
    	 var param = inputList.setRangeParam("searchArea");
         return param;
    }

    
    function gridListEventRowDblclick(gridId, rowNum){
        
    }
    
	// ????????? ?????? ????????? ?????????(??????), ?????? ???????????? ?????? ?????? ??????????????? ??? ?????? ?????? ??????
	function gridListEventRowFocus(gridId, rowNum){
		
	}
	
	// ????????? ????????? ?????? ??? ?????????
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){

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
			}else if(name == "SHPMTY"){
				param.put("WARECODE","Y"); //?????????????????? Y ??????
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "DOCTMSHP");
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
			param.put("searchCode", searchCode);
			param.put("multyType", multyType);
			param.put("rowNum", rowNum);
			var option = "height=800,width=800,resizable=yes";
			page.linkPopOpen("/wms/inventory/POP/SKUMA_POP.page", param, option);
			
			return false;
		}
	}
	
	// ?????? ?????????
	function linkPopCloseEvent(data){
		if( data.get("multyType") == true && data.get("searchCode") == "SHSKUMA" ){
			var singleList = [];
			var skuList = data.get("SKUKEY");
			for(var i=0; i<skuList.length; i++){
				var rangeMap = new DataMap();
				rangeMap.put(configData.INPUT_RANGE_LOGICAL, "OR");
				rangeMap.put(configData.INPUT_RANGE_OPERATOR, "E");
				rangeMap.put(configData.INPUT_RANGE_SINGLE_DATA, data.get("SKUKEY")[i]);
				singleList.push(rangeMap);
				
			}
			inputList.setRangeData("SI.SKUKEY", configData.INPUT_RANGE_TYPE_SINGLE, singleList);
		}
	}
	
	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
        
        if( gridId == "gridHeadList" ){
        	var inddcl = gridList.getColData("gridHeadList", rowNum, "INDDCL");
			
			if(inddcl == 'V'){
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
		<button CB="Save SAVE BTN_QTSHPCCOMP"></button>
	</div>
</div>

    <!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top" style="height:130px" id="searchArea">
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
											<input type="text" id="RQSHPD" name="RQSHPD" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px" validate="required(STD_SHPDGR)">
												<option value="" selected>??????</option>
											</select>
										</td>
								
									</tr>
						
									<tr>
						
										<th CL="STD_SHPMTY"></th>
										<td>
											<select id="SHPMTY" name="SHPMTY" Combo="Common,COMCOMBO"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="">??????</option>
											</select>
										</td>
										
										<th CL="STD_VEHINO"></th>
										<td>
											<select id="VEHINO" name="VEHINO"  UISave="false" ComboCodeView=false style="width:160px" >
												<option value="" selected>??????</option>
											</select>
										</td>
										
										<th CL="STD_SVBELN"></th>
										<td>
											<input type="text" name="SH.SVBELN" UISave="false"  UIInput="SR" />
										</td>
										
									</tr>
									
									<tr>
										<th CL="STD_BOXTYP"></th>
										<td>
											<select id="BOXTYP" name="BOXTYP"  Combo="Common,COMCOMBO" UISave="false" ComboCodeView=false style="width:160px">
												<option value="">??????</option>
											</select>
										</td>
										
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="SI.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U" UiRange="3" />
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>

			<div class="bottomSect bottomT">
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
												<td GH="100 STD_WAREKYNM"    GCol="text,WAREKYNM"  ></td>
												<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD" GF="D" ></td>
												<td GH="100 STD_SHPDGR"    GCol="text,SHPDGR"  ></td>
												<td GH="100 STD_SHPMTY"    GCol="text,SHPMTY"  ></td>
												<td GH="100 STD_ALLIYN"    GCol="text,ALLIYN"  ></td>
												<td GH="100 STD_CUSREQ"    GCol="text,CUSREQ"  ></td>
												<td GH="100 STD_VEHINO"    GCol="text,VEHINO"  ></td>
												<td GH="100 STD_DOCKNO"    GCol="text,DOCKNO"  ></td>
												<td GH="100 STD_CARCNT"    GCol="text,CARCNT"  ></td>
												<td GH="100 STD_SVBELN"    GCol="text,SVBELN"  ></td>
												<td GH="100 STD_SHCARN"    GCol="text,SHCARN"  ></td>
												<td GH="100 STD_SHDTLN"    GCol="text,SHDTLN"  ></td>
												<td GH="100 STD_SPOSNR"    GCol="text,SPOSNR"  ></td>
												<td GH="130 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
												<td GH="240 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="60 STD_PACKYN"    GCol="text,PACKYN"  ></td>
												<td GH="60 STD_PACQTY"    GCol="text,PACQTY" GF="N" ></td>
												<td GH="100 STD_LOTA06"    GCol="text,LOTA06NM"></td>
												<td GH="100 STD_AREANM"    GCol="text,AREANM"  ></td>
												<td GH="100 STD_LOCAKY"    GCol="text,LOCAKY"  ></td>
												<td GH="100 STD_QTSHPO"    GCol="text,QTSHPO" GF="N" ></td>
												<td GH="100 STD_QTJCMP"    GCol="text,QTJCMP" GF="N" ></td>
												<td GH="100 STD_QTSHPC"    GCol="text,QTSHPC_PROC" GF="N" ></td>
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