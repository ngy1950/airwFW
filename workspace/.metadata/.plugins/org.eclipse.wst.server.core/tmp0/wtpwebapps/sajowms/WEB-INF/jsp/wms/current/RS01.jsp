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
<script type="text/javascript">
var tbindex = 1;
midAreaHeightSet = "200px";
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList1",
	    	name : "gridHeadList1",
			editable : true,
			module : "WmsOutbound",
			command : "RS01",
            itemGrid : "gridItemList1",
            itemSearch : true,
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList1",
	    	name : "gridItemList1",
			editable : true,
			module : "WmsOutbound",
			command : "RS01Sub",
            autoCopyRowType : false
	    });
		
		gridList.setGrid({
	    	id : "gridHeadList2",
	    	name : "gridHeadList2",
			editable : true,
			module : "WmsOutbound",
			command : "RS02",
            autoCopyRowType : false,
            itemGrid : "gridItemList2",
            itemSearch : true,
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList2",
	    	name : "gridItemList2",
			editable : true,
			module : "WmsOutbound",
			command : "RS02Sub",
            autoCopyRowType : false
	    });
		
		gridList.setGrid({
	    	id : "gridHeadList3",
	    	name : "gridHeadList3",
			editable : true,
			module : "WmsOutbound",
			command : "RS03",
            autoCopyRowType : false,
            itemGrid : "gridItemList3",
            itemSearch : true,
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList3",
	    	name : "gridItemList3",
			editable : true,
			module : "WmsOutbound",
			command : "RS03Sub",
            autoCopyRowType : false
	    });
		
		var val = day(0);

		searchShpdgr(val,1);
		searchShpdgr(val,2);
		searchShpdgr(val,3);
		$("#searchArea [id=RQSHPD1]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''),1);
			
		});
		
		$("#searchArea [id=RQSHPD2]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''),2);
			
		});
		
		$("#searchArea [id=RQSHPD3]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''),3);
			
		});
		
		$("#searchArea [id=SHPDGR2]").on("change",function(){
			searchvehino($('#RQSHPD2').val().replace(/\./g,''),$(this).val());
			
		});
		
		
		$('#tab2').hide();
		$('#tab3').hide();
		$('#tab1').show();
		
		$(".top .tabs ul li").on("click",function(){
			
			var tabIdx = $(this).index();
			tabIdx = tabIdx+1;
			
			for(var i=1 ; i <= 3;i++){
				if(tabIdx != i){
					$('#tab'+i).hide();
				}
			}
			
			$('#tab'+tabIdx).show();
			
			tbindex = tabIdx;
			
		});
		
    });
    
    function searchShpdgr(val,tab){
		var param = new DataMap();
			param.put("RQSHPD",val);
			param.put("WAREKY", "<%=wareky%>");
		if(tab == 3){
			param.put("ORDERCOFM","V");
		}	
		
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
		
		$("#VEHINO2").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#VEHINO2").append(optionHtml);
		$('#VEHINO2').val("");
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
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}
	}
	
	//헤더 조회 
	function searchList(){
		//var param = dataBind.paramData("searchArea");
		var param = inputList.setRangeParam("searchArea #tabs1-"+tbindex);
        
		var headid = "gridHeadList"+tbindex;
		
        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : headid,
		    	param : param
		    });
        }
		
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList"+tbindex && dataLength > 0){

		}else if(gridId == "gridHeadList"+tbindex && dataLength <= 0){
			gridList.resetGrid("gridItemList"+tbindex);
            searchOpen(true);
		}
	}
	
    // 그리드 item 조회 이벤트
    function gridListEventItemGridSearch(gridId, rowNum, itemList){  
        var param = getItemSearchParam(rowNum);
		
        var itemid = "gridItemList"+tbindex;
        
        gridList.gridList({
            id : itemid,
            param : param
        });
    }
    
    // 아이템 그리드 Parameter
    function getItemSearchParam(rowNum){
        var rowData = gridList.getRowData("gridHeadList"+tbindex, rowNum);
        var param = inputList.setRangeParam("searchArea #tabs1-"+tbindex);
        param.putAll(rowData);
        
        return param;
    }
    
    //그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
    function gridExcelDownloadEventBefore(gridId){
        var param = inputList.setRangeParam("searchArea #tabs1-"+tbindex);
        
        if(gridId == "gridItemList"+tbindex){
            var rowNum = gridList.getSearchRowNum("gridHeadList"+tbindex);
            if(rowNum == -1){
                return false;
            }else{
                 param = getItemSearchParam(rowNum);
            }
            
            switch (tbindex) {
			case 1:
				param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "출하현황(차수)아이템");
				break;
			case 2:
				param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "출하현황(차량)아이템");
				break;
			case 3:
				param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "출하현황(주문)아이템");
				break;
			default:
				break;
			}
        }
        
        if(gridId == "gridHeadList"+tbindex){
        	switch (tbindex) {
			case 1:
				param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "출하현황(차수)헤더");
				break;
			case 2:
				param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "출하현황(차량)헤더");
				break;
			case 3:
				param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "출하현황(주문)헤더");
				break;
			default:
				break;
			}
        }
        
        return param;
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
			}else if(name == "SL.SHPDGR"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SHPDGR");
			}
			
			
			return param;
		}
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList1"){
			if(colName == "GBN"){
				if(colValue == "V"){
					return "impflg";	
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
		}
		
		if(gridId == "gridItemList2"){
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
		
		if(gridId == "gridItemList3"){
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
		
		if(gridId == "gridHeadList3"){  
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
						<li><a href="#tabs1-1"><span >차수</span></a></li>
						<li><a href="#tabs1-2"><span >차량</span></a></li>
						<li><a href="#tabs1-3"><span >주문</span></a></li>
					</ul>
					<div id="tabs1-1" >
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
				                            <input type="text" name="RQSHPD" id="RQSHPD1" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
				                        </td>
										
										<th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR1" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="">전체</option>
											</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					
					<div id="tabs1-2" >
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
											<input type="text" name="RQSHPD" id="RQSHPD2" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR2" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="">전체</option>
											</select>
										</td>
								
									</tr>
						
									<tr>
										<th CL="STD_VEHINO"></th>
										<td>
											<select id="VEHINO2" name="VEHINO"  UISave="false" ComboCodeView=false style="width:160px" >
												<option value="" selected>전체</option>
											</select>
										</td>
										
										<th CL="STD_DOCKNO"></th>
										<td>
											<input type="text" name="SH.DOCKNO" UIInput="SR" />
										</td>
						
										<th CL="STD_OUTFSH"></th>
										<td>
											<select id="SHSTATUS" name="SHSTATUS" style="width:160px">
												<option value="ALL">전체</option>
												<option value="미완료">미완료</option>
												<option value="부분완료">부분완료</option>
												<option value="완료">완료</option>
											</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					
					<div id="tabs1-3">
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
											<input type="text" name="RQSHPD" id="RQSHPD3" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHPDGR"></th>
										
										<td>
											<select id="SHPDGR3" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="">전체</option>
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
												<option value="" selected>전체</option>
												<option value="Y">완료</option>
												<option value="N">미완료</option>
											</select>
										</td>
										
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					
				</div>
	         </div>
			
			<div id="tab1">
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
											<tbody id="gridHeadList1">
												<tr CGRow="true">
													<td GH="40"                GCol="rownum">1</td>
													<td GH="100 STD_WAREKYNM"  GCol="text,WAREKYNM"  ></td>
													<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD" GF="D" ></td>
													<td GH="100 STD_SHPDGR"    GCol="text,SHPDGR"  ></td>
													<td GH="100 STD_TOTORD"    GCol="text,ORDCNT" GF="N" ></td>
													<td GH="100 STD_FINWOK"    GCol="text,CMPORD" GF="N" ></td>
													<td GH="100 STD_QTSHPO"    GCol="text,QTSHPO" GF="N" ></td>
													<td GH="100 STD_REPQTY"    GCol="text,REPCNT" GF="N" ></td>
													<td GH="100 STD_NQTJCMP"   GCol="text,NQTJCMP" GF="N" ></td>
													<td GH="100 STD_PICKCNT"   GCol="text,PICKCNT" GF="N" ></td>
													<td GH="100 STD_QTJCMP"    GCol="text,QTJCMP" GF="N" ></td>
													<td GH="100 STD_QTSHPC"    GCol="text,QTSHPC" GF="N" ></td>
													<td GH="100 STD_CNLQTY"    GCol="text,CNLCNT" GF="N" ></td>
													<td GH="100 STD_CELQTY"    GCol="text,CNLBOXCNT" GF="N" ></td>
													<td GH="100 STD_QTSHPD"    GCol="text,QTSHPD" GF="N" ></td>
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
						<ul class="tab type2" id="commonMiddleArea2-1">
	                        <li><a href="#tabs1-1"><span CL='STD_DETAIL'></span></a></li>
	                    </ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableBody">
										<table>
											<tbody id="gridItemList1">
												<tr CGRow="true">
													<td GH="40"                GCol="rownum">1</td>
													<td GH="100 STD_BOXTYP"    GCol="text,BOXTYP"  ></td>
													<td GH="100 STD_CNTBOX"    GCol="text,BOXCNT" GF="N" ></td>
													<td GH="100 STD_BOXSTRCNT"    GCol="text,BOXSTRCNT" GF="N" ></td>
													<td GH="100 STD_BOXCMPCNT"    GCol="text,BOXCMPCNT" GF="N" ></td>
													<td GH="100 STD_TOTORD"    GCol="text,ORDCNT" GF="N" ></td>
													<td GH="100 STD_QTSHPO"    GCol="text,QTSHPO" GF="N" ></td>
													<td GH="100 STD_REPQTY"    GCol="text,REPCNT" GF="N" ></td>
													<td GH="100 STD_NQTJCMP"   GCol="text,NQTJCMP" GF="N" ></td>
													<td GH="100 STD_PICKCNT"   GCol="text,PICKCNT" GF="N" ></td>
													<td GH="100 STD_QTJCMP"    GCol="text,QTJCMP" GF="N" ></td>
													<td GH="100 STD_QTSHPC"    GCol="text,QTSHPC" GF="N" ></td>
													<td GH="100 STD_CNLQTY"    GCol="text,CNLCNT" GF="N" ></td>
													<td GH="100 STD_CELQTY"    GCol="text,CNLBOXCNT" GF="N" ></td>
													<td GH="100 STD_QTSHPD"    GCol="text,QTSHPD" GF="N" ></td>
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
											<tbody id="gridHeadList2">
												<tr CGRow="true">
													<td GH="40"                GCol="rownum">1</td>
													<td GH="100 STD_WAREKYNM"  GCol="text,WAREKYNM"  ></td>
													<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD"    GF="D" ></td>
													<td GH="100 STD_SHPDGR"    GCol="text,SHPDGR"    GF="N" ></td>
													<td GH="100 STD_SHPMTYNM"  GCol="text,SHPMTYNM"  ></td>
													<td GH="100 STD_VEHINO"    GCol="text,VEHINO"  ></td>
													<td GH="100 STD_DOCKNO"    GCol="text,DOCKNO"  ></td>
													<td GH="100 STD_CARCNT"    GCol="text,CARCNT"  ></td>
													<td GH="100 STD_SHPSTATDO" GCol="text,SHSTATUS"  ></td>
													<td GH="100 STD_TOTORD"    GCol="text,ORDCNT"    GF="N" ></td>
													<td GH="100 STD_FINWOK"    GCol="text,CMPORD"    GF="N" ></td>
													<td GH="100 STD_FINSHP"    GCol="text,OUTCNT"    GF="N" ></td>
													<td GH="100 STD_QTSHPO"    GCol="text,QTSHPO"    GF="N" ></td>
													<td GH="100 STD_REPQTY"    GCol="text,REPCNT"    GF="N" ></td>
													<td GH="100 STD_NQTJCMP"   GCol="text,NQTJCMP"   GF="N" ></td>
													<td GH="100 STD_PICKCNT"   GCol="text,PICKCNT"   GF="N" ></td>
													<td GH="100 STD_QTJCMP"    GCol="text,QTJCMP"    GF="N" ></td>
													<td GH="100 STD_QTSHPC"    GCol="text,QTSHPC"    GF="N" ></td>
													<td GH="100 STD_CNLQTY"    GCol="text,CNLCNT"    GF="N" ></td>
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
						<ul class="tab type2" id="commonMiddleArea2-2">
	                        <li><a href="#tabs1-1"><span CL='STD_DETAIL'></span></a></li>
	                    </ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableBody">
										<table>
											<tbody id="gridItemList2">
												<tr CGRow="true">
													<td GH="40"                GCol="rownum">1</td>
													<td GH="100 STD_SVBELN"    GCol="text,SVBELN"  ></td>
													<td GH="100 STD_SHCARN"    GCol="text,SHCARN"  ></td>
													<td GH="100 STD_SHPDSQ"    GCol="text,SHPDSQ"  GF="N" ></td>
													<td GH="100 STD_INDDCL"    GCol="icon,INDDCL"  GB="regAft" ></td> 
													<td GH="100 STD_CNLMAK"    GCol="icon,CNLMAK"  GB="regAft" ></td>
													<td GH="100 STD_ORDEND"    GCol="icon,WORKCMP" GB="regAft" ></td>
													<td GH="100 STD_QTSHPO"    GCol="text,QTSHPO"  GF="N" ></td>
													<td GH="100 STD_REPQTY"    GCol="text,REPCNT"  GF="N" ></td>
													<td GH="100 STD_NQTJCMP"   GCol="text,NQTJCMP" GF="N" ></td>
													<td GH="100 STD_PICKCNT"   GCol="text,PICKCNT" GF="N" ></td>
													<td GH="100 STD_QTJCMP"    GCol="text,QTJCMP"  GF="N" ></td>
													<td GH="100 STD_QTSHPC"    GCol="text,QTSHPC"  GF="N" ></td>
													<td GH="100 STD_CELQTY"    GCol="text,CNLCMPCNT" GF="N" ></td>
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
			
			<div id="tab3">
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
											<tbody id="gridHeadList3">
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
						<ul class="tab type2" id="commonMiddleArea2-3">
	                        <li><a href="#tabs1-1"><span CL='STD_DETAIL'></span></a></li>
	                    </ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableBody">
										<table>
											<tbody id="gridItemList3">
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
			
			
		</div>
		<!-- //contentContainer -->
  </div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>