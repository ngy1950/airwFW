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
			command : "RS05",
            autoCopyRowType : false
	    });
		makeYead();        
		gridList.setReadOnly("gridHeadList", true, ["SHIT01"]);
		
		
		searchShpdgr();
		$("#searchArea [name=YEAR]").on("change",function(){
			searchShpdgr();
			
		});
		
		$("#searchArea [name=RQSHPD]").on("change",function(){
			searchShpdgr();
			
		});
		
    });
    
    function searchShpdgr(val){
		var param = new DataMap();
		param.put("RQSHPD",$('#RQSHPD').val());
		param.put("YEAR",$('#YEAR').val());
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
		$("#SHPDGR").append(optionHtml)
	}
    
    function makeYead(){
    	var param = new DataMap();
    		param.put("WAREKY","<%=wareky%>");
    	
    	var json = netUtil.sendData({
            module : "WmsOutbound",
            command : "GET_STARTYEAR",
            sendType : "map",
            param : param
		});
    	
    	var syear = parseInt(json.data["SYEAR"]);
    	
    	var dt = new Date();
    	var year = dt.getFullYear();
    	var month = dt.getMonth()+1;
    	
    	if(month < 10 ){
    		month = '0' + month;
    	}
    	
    	for(var i=syear; i <= year;i++){
    		$('#YEAR').append("<option value='" + i + "'>" + i + "??????</option>");
    	}
    	
    	$('#YEAR').val(year);
    	$('#RQSHPD').val(month);
    	
    }
    
    // ?????? ?????? ?????? ?????????
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }
    }
    
  //?????? ?????? 
	function searchList(){
		
		gridList.resetGrid("gridHeadList");
		
		var param = inputList.setRangeParam("searchArea");

        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
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
			}else if(name == "RQSHPD"){
				param.put("CODE", "MONTH");
			}
			
			return param;
		}else if ( comboAtt == "WmsCommon,DOCTMCOMBO"){
            var param = new DataMap();
            param.put("PROGID", configData.MENU_ID);
            return param;
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

			<div class="bottomSect top" style="height:70px" id="searchArea">
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
											<select id="YEAR" name="YEAR" UISave="false" ComboCodeView=false style="width:80px">
											</select>
											<select id="RQSHPD" name="RQSHPD" Combo="Common,COMCOMBO"  UISave="false" ComboCodeView=false style="width:80px">
											</select>
										</td>
									
										<th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="">??????</option>
											</select>
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
												<td GH="100 STD_WAREKYNM"    GCol="text,WAREKYNM"  ></td>
												<td GH="100 STD_VEHINO"    GCol="text,VEHINO"  ></td>
												<td GH="150 STD_DRITEL"    GCol="text,DRITEL"  ></td>
												<td GH="80 1"    GCol="text,DAY1" GF="N" ></td>
												<td GH="80 2"    GCol="text,DAY2" GF="N" ></td>
												<td GH="80 3"    GCol="text,DAY3" GF="N" ></td>
												<td GH="80 4"    GCol="text,DAY4" GF="N" ></td>
												<td GH="80 5"    GCol="text,DAY5" GF="N" ></td>
												<td GH="80 6"    GCol="text,DAY6" GF="N" ></td>
												<td GH="80 7"    GCol="text,DAY7" GF="N" ></td>
												<td GH="80 8"    GCol="text,DAY8" GF="N" ></td>
												<td GH="80 9"    GCol="text,DAY9" GF="N" ></td>
												<td GH="80 10"    GCol="text,DAY10" GF="N" ></td>
												<td GH="80 11"    GCol="text,DAY11" GF="N" ></td>
												<td GH="80 12"    GCol="text,DAY12" GF="N" ></td>
												<td GH="80 13"    GCol="text,DAY13" GF="N" ></td>
												<td GH="80 14"    GCol="text,DAY14" GF="N" ></td>
												<td GH="80 15"    GCol="text,DAY15" GF="N" ></td>
												<td GH="80 16"    GCol="text,DAY16" GF="N" ></td>
												<td GH="80 17"    GCol="text,DAY17" GF="N" ></td>
												<td GH="80 18"    GCol="text,DAY18" GF="N" ></td>
												<td GH="80 19"    GCol="text,DAY19" GF="N" ></td>
												<td GH="80 20"    GCol="text,DAY20" GF="N" ></td>
												<td GH="80 21"    GCol="text,DAY21" GF="N" ></td>
												<td GH="80 22"    GCol="text,DAY22" GF="N" ></td>
												<td GH="80 23"    GCol="text,DAY23" GF="N" ></td>
												<td GH="80 24"    GCol="text,DAY24" GF="N" ></td>
												<td GH="80 25"    GCol="text,DAY25" GF="N" ></td>
												<td GH="80 26"    GCol="text,DAY26" GF="N" ></td>
												<td GH="80 27"    GCol="text,DAY27" GF="N" ></td>
												<td GH="80 28"    GCol="text,DAY28" GF="N" ></td>
												<td GH="80 29"    GCol="text,DAY29" GF="N" ></td>
												<td GH="80 30"    GCol="text,DAY30" GF="N" ></td>
												<td GH="80 31"    GCol="text,DAY31" GF="N" ></td>
												<td GH="100 STD_DAYAVERAGE"    GCol="text,DAYAVERAGE" GF="N" ></td>
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