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
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>  
<script type="text/javascript">
	midAreaHeightSet = "200px";
	var excelrow = -1;
	
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "RS03",
            autoCopyRowType : false,
            itemGrid : "gridItemList",
            itemSearch : true,
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList",
	    	name : "gridItemList",
			editable : true,
			module : "WmsOutbound",
			command : "RS03Sub",
            autoCopyRowType : false
	    });
		var val = day(0);

		searchShpdgr(val);
		$("#searchArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
		gridList.setReadOnly("gridHeadList", true, ["INDDCL" , "CNLMAK" , "WORKCMP"])
		gridList.setReadOnly("gridItemList", true, ["BOXSTR" , "WORKCMP" , "REPMAK" , "CNLMAK" , "CNLBOX"])

		
    });
    
    function searchShpdgr(val){
		var param = new DataMap();
			param.put("RQSHPD",val);
			param.put("WAREKY", "<%=wareky%>");
			param.put("ORDERCOFM","V");
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SHPDGR_S",
			sendType : "list",
			param : param
		});
		
		$("#SHPDGR").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#SHPDGR").append(optionHtml);
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
        
    // ?????? ?????? ?????? ?????????
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }
    }
    
  //?????? ?????? 
	function searchList(){
		//var param = dataBind.paramData("searchArea");
		excelrow = -1;
		gridList.resetGrid("gridHeadList");
		var param = inputList.setRangeParam("searchArea");
		
        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }
		
	}
  
	// ????????? item ?????? ?????????
    function gridListEventItemGridSearch(gridId, rowNum, itemList){  
        var param = getItemSearchParam(rowNum);

        gridList.gridList({
            id : "gridItemList",
            param : param
        });
    }
    
    // ????????? ????????? Parameter
    function getItemSearchParam(rowNum){
        var rowData = gridList.getRowData("gridHeadList", rowNum);
        var param = inputList.setRangeParam("searchArea");
        param.putAll(rowData);
        
        return param;
    }
    
	
	
	// ????????? AJAX ?????? ????????? ????????? ????????????  ?????????(?????? ????????? ??????)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){
// 			gridListEventItemGridSearch(gridId,0,["gridItemList"]);
		}else if(gridId == "gridHeadList" && dataLength <= 0){
			gridList.resetGrid("gridItemList");
            searchOpen(true);
		}
	}
    
    // ????????? ????????? Parameter
    function getItemSearchParam(rowNum){
        var rowData = gridList.getRowData("gridHeadList", rowNum);
        var param = inputList.setRangeParam("searchArea");
        param.putAll(rowData);
        
        return param;
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
  
  
	function gridListColIconRemove(gridId, rowNum, colName, colValue){          
		if(gridId == "gridItemList"){
			if(colName == "BOXSTR"){
				if(colValue == "V"){
					return "impflg";	
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
			
			if(colName == "WORKCMP"){
				if(colValue == "V"){
					return "impflg";
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
			
			if(colName == "REPMAK"){
				if(colValue == "V"){
					return "impflg";
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
			
			if(colName == "CNLMAK"){
				if(colValue == "V"){
					return "impflg";
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
			
			if(colName == "CNLBOX"){
				if(colValue == "V"){
					return "impflg";
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
		}
		
		if(gridId == "gridHeadList"){  
			if(colName == "INDDCL"){
				if(colValue == "V"){
					return "impflg";	
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
		
			if(colName == "CNLMAK"){
				if(colValue == "V"){
					return "impflg";	
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
			
			if(colName == "WORKCMP"){
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
											<input type="text" name="RQSHPD" id="RQSHPD" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHPDGR"></th>
										
										<td>
											<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="">??????</option>
											</select>
										</td>
								
									</tr>
						
									<tr>
										<th CL="STD_SVBELN"></th>
										<td>
											<input type="text" name="SH.SVBELN" UIInput="SR" />
										</td>
										
										<th CL="STD_SHCARN"></th>
										<td>
											<input type="text" name="SH.SHCARN" UIInput="SR" />
										</td>
										
										<th CL="STD_OUTFSH"></th>
										<td>
											<select id="INDDCL" name="INDDCL"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="" selected>??????</option>
												<option value="Y">??????</option>
												<option value="N">?????????</option>
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
												<td GH="100 STD_WAREKYNM"  GCol="text,WAREKYNM"></td>
												<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD"    GF="D"  ></td>
												<td GH="100 STD_SHPDGR"    GCol="text,SHPDGR"></td>
												<td GH="100 STD_SHPMTYNM"  GCol="text,SHPMTYNM"></td>
												<td GH="100 STD_SVBELN"    GCol="text,SVBELN"></td>
												<td GH="100 STD_SHCARN"    GCol="text,SHCARN"></td>
												<td GH="100 STD_INDDCL"    GCol="icon,INDDCL"    GB="regAft" ></td>
												<td GH="100 STD_CNLMAK"    GCol="icon,CNLMAK"    GB="regAft" ></td>
												<td GH="100 STD_ORDEND"    GCol="icon,WORKCMP"   GB="regAft" ></td>
												<td GH="100 STD_QTSHPO"    GCol="text,QTSHPO"    GF="N" ></td>
												<td GH="100 STD_REPQTY"    GCol="text,REPCNT"    GF="N" ></td>
												<td GH="100 STD_NQTJCMP"   GCol="text,NQTJCMP"   GF="N" ></td>
												<td GH="100 STD_PICKCNT"   GCol="text,PICKCNT"   GF="N" ></td>
												<td GH="100 STD_QTJCMP"    GCol="text,QTJCMP"    GF="N" ></td>
												<td GH="100 STD_QTSHPC"    GCol="text,QTSHPC"    GF="N" ></td>
												<td GH="100 STD_CNLQTY"    GCol="text,CNLCNT" GF="N" ></td>
												<td GH="100 STD_CELQTY"    GCol="text,CNLCMPCNT" GF="N" ></td>
												<td GH="100 STD_QTSHPD"    GCol="text,QTSHPD"    GF="N" ></td>
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
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_SBOXSQ"    GCol="text,SBOXSQ"></td>
												<td GH="100 STD_BOXTYP"    GCol="text,BOXTYP"></td>
												<td GH="100 STD_BOXPUT"    GCol="icon,BOXSTR"  GB="regAft" ></td> 
												<td GH="100 STD_ORDEND"    GCol="icon,WORKCMP" GB="regAft" ></td>
												<td GH="100 STD_REPMAK"    GCol="icon,REPMAK"  GB="regAft" ></td> 
												<td GH="100 STD_CNLMAK"    GCol="icon,CNLMAK"  GB="regAft" ></td>
												<td GH="100 STD_CNLBOX"    GCol="icon,CNLBOX"  GB="regAft" ></td>
												<td GH="100 STD_SBOXID"    GCol="text,SBOXID"></td>
												<td GH="100 STD_BOXLAB"    GCol="text,BOXLAB"></td>
												<td GH="100 STD_SKUKEY"    GCol="text,SKUKEY"></td>
												<td GH="100 STD_DESC01"    GCol="text,DESC01"></td>
												<td GH="100 STD_LOCAKY"    GCol="text,LOCAKY"></td>
												<td GH="100 STD_LOTA06"    GCol="text,LOTA06"></td>
												<td GH="100 STD_QTSHPO"    GCol="text,QTSHPO"  GF="N" ></td>
												<td GH="100 STD_NQTJCMP"   GCol="text,NQTJCMP" GF="N" ></td>
												<td GH="100 STD_QTJCMP"    GCol="text,QTJCMP"  GF="N" ></td>
												<td GH="100 STD_QTSHPC"    GCol="text,QTSHPC"  GF="N" ></td>
												<td GH="100 STD_QTSHPD"    GCol="text,QTSHPD"  GF="N" ></td>
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