
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
<script type="text/javascript">
midAreaHeightSet = "300px";
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "NS02",
			itemGrid : "gridItemList",
            itemSearch : true,
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList",
	    	name : "gridItemList",
			editable : true,
			module : "WmsOutbound",
			command : "NS02SUB",
			emptyMsgType : false ,
            autoCopyRowType : false
	    });
		gridList.setReadOnly("gridItemList", true, ["BOXTYP"]);
		var val = day(0);

		searchShpdgr(val);
		$("#searchArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
		getMaxSHPDGR();
		
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
        }else if(btnName == "Boxmak"){
        	saveData();
        }else if(btnName == "Boxomz"){
        	saveData2();
        }else if(btnName == "Boxcnl"){
        	cancelData();
        }else if(btnName =="Unoptitem"){
			var data = inputList.setRangeParam("searchArea");
				data.put("PROGID" , configData.MENU_ID);
 			var option = "height=900,width=1600,resizable=no";
 			page.linkPopOpen("/wms/outbound/POP/DL03POP2.page", data , option);
        }
    }
    
  //헤더 조회 
	function searchList(){
		//var param = dataBind.paramData("searchArea");
		
		gridList.resetGrid("gridHeadList");
		
		
		var param = inputList.setRangeParam("searchArea");

        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }else{
        	$('#reflect').empty();
        }
		
	}
    
	
	function succsessSaveCallBack(json, status){
		if( json && json.data ){
			if(json.data == "OK"){
				commonUtil.msgBox("MASTER_M0564");
				searchList();
			}else if(json.data == "FAIL"){
				commonUtil.msgBox("실패 하였습니다.");
			}
			
		}
	}
	
	function saveData2(){

		if(validate.check("searchArea")){
			var row = inputList.setRangeParam("searchArea");
			
			var param = new DataMap();
				param.put("row", row);
			
			if(!commonUtil.msgConfirm("COMMON_M0110")){
	            return;
	        }
			
			netUtil.send({
				url : "/wms/outbound/json/saveBoxOmzDL03.data",
				param : param ,
				successFunction : "succsessaveBoxOmzDL03CallBack"
			});
			
		}
		
	}



	function succsessaveBoxOmzDL03CallBack(json, status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0564");
			searchList();
		}
	}
	
	
	function succsessCancelCallBack(json , status){
		if( json && json.data ){
			if(json.data == "OK"){
				commonUtil.msgBox("MASTER_M0564");
				searchList();
			}else if(json.data == "FAIL"){
				commonUtil.msgBox("VALID_M0524");
			}
			
		}	
	}
	
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){
			var param = inputList.setRangeParam("searchArea");
			$('#reflect').empty();
			
			var json = netUtil.sendData({
	              module : "WmsOutbound",
	              command : "NS02_RESULT",
	              sendType : "map",
	              param : param
			});
			var str = json.data["STR"];
			$('#reflect').append("<span >" + str +"</span>");
		}else if(gridId == "gridHeadList" && dataLength <= 0){
			$('#reflect').empty();
			gridList.resetGrid("gridItemList");
            searchOpen(true);
		}
	}
	
    // 그리드 item 조회 이벤트
    function gridListEventItemGridSearch(gridId, rowNum, itemList){  
        var param = getItemSearchParam(rowNum);

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
			}else if(name == "SD.SHPDGR"){
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
	 
  	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "SHPCYN"){
				if(colValue == "Y"){
					return "impflg";	
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
			
			if(colName == "SIMYN"){
				if(colValue == "Y"){
					return "redflg";
				}else if($.trim(colValue) == "N"){
					return "regAft";
				}
			}
		}else if(gridId == "gridItemList"){
			if(colName == "SIMMAK"){
				if(colValue == "Y"){
					return "redflg";
				}else if($.trim(colValue) == "N"){
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
		<button CB="Boxomz SAVE BTN_SKUWORK"></button>
		<button CB="Unoptitem SEARCH BTN_UNIPTIITEM"></button>
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
										
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
									
										<th CL="STD_RQSHPD"></th>
										<td>
											<input type="text" name="RQSHPD" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false validate="required(STD_SHPDGR)" style="width:160px">
												<option value="">선택</option>
											</select>
										</td>
								
									</tr>
						
									<tr>
						
										<th CL="STD_SVBELN"></th>
										<td>
											<input type="text" name="SH.SVBELN" UIInput="SR" UIformat="U" UiRange="3" />
										</td>
										
										<th CL="STD_SHCARN"></th>
										<td>
											<input type="text" name="SH.SHCARN" UIInput="SR" UIformat="U" UiRange="3" />
										</td>
										
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="SM.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U" UiRange="3" />
										</td>
										
									</tr>
									
									<tr>
										<th CL="STD_SHPCYN"></th>
										<td>
											<select id="SHPCYN" name="SHPCYN"   UISave="false" ComboCodeView=false style="width:160px">
												<option value="" selected>전체</option>
												<option value="Y">처리</option>
												<option value="N">미처리</option>
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
								
							</div>
							<div class="table type2" style="top: 30px;">
								<div class="tableBody">
									<table>
									
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_WAREKYNM"    GCol="text,WAREKYNM"  ></td>
												<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD" GF="D" ></td>
												<td GH="100 STD_SHPDGR"    GCol="text,SHPDGR"  ></td>
												<td GH="100 STD_SHPMTYNM"    GCol="text,SHPMTYNM"  ></td>
												<td GH="100 STD_ALLIYN"    GCol="text,ALLIYN"  ></td>
												<td GH="100 STD_CUSREQ"    GCol="text,CUSREQ"  ></td>
												<td GH="110 STD_SHPCYN"    GCol="icon,SHPCYN" GB="regAft"></td>
												<td GH="100 STD_VEHINO"    GCol="text,VEHINO"  ></td>
												<td GH="100 STD_DOCKNO"    GCol="text,DOCKNO"  ></td>
												<td GH="100 STD_CARCNT"    GCol="text,CARCNT"  ></td>
												<td GH="100 STD_SHPDSQ"    GCol="text,SHPDSQ"  ></td>
												<td GH="100 STD_SVBELN"    GCol="text,SVBELN"  ></td>
												<td GH="170 STD_SHCARN"    GCol="text,SHCARN"  ></td>
												<td GH="100 STD_SHDTLN"    GCol="text,SHDTLN"  ></td>
												<td GH="100 STD_SPOSNR"    GCol="text,SPOSNR"  ></td>
												<td GH="100 STD_SKUCLSNM"    GCol="text,SKUCLSNM"  ></td>
												<td GH="130 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
												<td GH="230 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="100 STD_LOTA06NM"    GCol="text,LOTA06NM"  ></td>
												<td GH="100 STD_QTSHPC"    GCol="text,QTSHPC" GF="N" ></td>
												<td GH="100 STD_POINTB"    GCol="text,NPTQTY" GF="N" ></td>
												<td GH="100 STD_CNLQTY"    GCol="text,MCLQTY" GF="N" ></td>
												<td GH="100 STD_REPQTY"    GCol="text,NCGQTY" GF="N" ></td>
												<td GH="100 STD_SIMMAK"    GCol="icon,SIMYN" GB="regAft"></td>
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
												<td GH="100 STD_SHDTLN"    GCol="text,SHDTLN"  ></td>
												<td GH="100 STD_SPOSNR"    GCol="text,SPOSNR"  ></td>
												<td GH="130 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
												<td GH="230 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="60 STD_PACKYN"    GCol="text,PACKYN"  ></td>
												<td GH="60 STD_PACQTY"    GCol="text,PACQTY" GF="N" ></td>
												<td GH="100 STD_REPQTY"    GCol="text,QTYORG"  GF="N"></td>
												<td GH="80 STD_SIMMAK"    GCol="icon,SIMMAK" GB="regAft"></td>
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