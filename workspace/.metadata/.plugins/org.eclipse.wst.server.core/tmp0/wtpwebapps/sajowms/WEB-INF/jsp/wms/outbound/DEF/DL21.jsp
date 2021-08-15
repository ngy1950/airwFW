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
	midAreaHeightSet = "200px";
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "DL21",
			itemGrid : "gridItemList",
            itemSearch : true,
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList",
	    	name : "gridItemList",
			editable : true,
			module : "WmsOutbound",
			command : "DL21SUB",
            autoCopyRowType : false
	    });
		
		gridList.setReadOnly("gridHeadList", true, ["WAREKY" , "ALLCNL"]);
		gridList.setReadOnly("gridItemList", true, ["BOXTYP" ,"CNLBOX"]);
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
			param.put("CANCEL","V");
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
    
    // 공통 버튼 클릭 이벤트
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }else if(btnName == "Fwdcnl"){
        	saveData();
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
        }
		
	}
  
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
        
        if( gridId == "gridItemList" ){
        	var cnlbox = gridList.getColData("gridItemList", rowNum, "CNLBOX");
			
			if(cnlbox == 'V'){
				return true;
			}
        }else if( gridId == "gridHeadList" ){
			var allcnl = gridList.getColData("gridHeadList", rowNum, "ALLCNL");
			
			if(allcnl == 'V'){
				return true;
			}
        }
    }
    
	function saveData(){
		if( gridList.validationCheck("gridItemList", "select") ){
			
			var head = gridList.getSelectData("gridHeadList");
			var list = gridList.getSelectData("gridItemList");
			
			if(list.length < 1 || head.length < 1){
				commonUtil.msgBox("VALID_M0006");//선택된 데이터가 없습니다.
				return;
			}
			
// 			var allcnl = gridList.getColData("gridHeadList", numhead , "ALLCNL");
// 			var head = gridList.getRowData("gridHeadList",numhead);
			
// 			if(allcnl == "V"){
// 				commonUtil.msgBox("VALID_M0527"); //해당 차량의 모든 오더가 이미 취소 되었습니다.
// 				return;				
// 			}
			
			var arraylist = [];
			
			for(var i=0;i<list.length;i++){
				arraylist[i] = list[i].get("SBOXSQ");
			}
			
			var paramchk = new DataMap();
				paramchk.put("SBOXSQLIST",arraylist);
				paramchk.put("WAREKY" , head[0].get("WAREKY") );
				paramchk.put("GRPOKY" , head[0].get("GRPOKY"));
			
			var json2 = netUtil.sendData({
                module : "WmsOutbound",
                command : "CHKECK_CNLCNT",
                sendType : "map",
                param : paramchk
            });
			
			if(list.length != parseInt(json2.data["CNT"])){
				commonUtil.msgBox("VALID_M0528");//취소요청한 주문중에 이미 취소된 주문이 존재 합니다.\n재조회 후 실행 하시기 바랍니다.
				return;
			}
			
			var param = new DataMap();
				param.put("head", head);
				param.put("list", list);
			
			
			if(!commonUtil.msgConfirm("COMMON_M0117")){//출하취소를 진행 하시겠습니까?
	            return;
	        }
			
			netUtil.send({
				url : "/wms/outbound/json/saveDL21.data",
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
			}else if(json.data == "FAIL"){
				commonUtil.msgBox("실패 하였습니다.");
			}
			
		}
	}
	
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){
		}else if(gridId == "gridHeadList" && dataLength <= 0){
			gridList.resetGrid("gridItemList");
            searchOpen(true);
		}else if(gridId = "gridItemList" && dataLength > 0){
			
		}
	}
	
    // 그리드 item 조회 이벤트
    function gridListEventItemGridSearch(gridId, rowNum, itemList){  
        var param = getItemSearchParam(rowNum);
        	param.put("SES_ENV", "<%=usradm%>");
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
        if(gridId == "gridItemList"){
            var row = gridList.getRowData(gridId, rowNum);
			page.linkPopOpen("/wms/outbound/POP/DL21POP.page", row); 
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
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "ALLCNL"){
				if(colValue == "V"){
					return "impflg";	
				}else if($.trim(colValue) == " "){
					return "regAft";
				}
			}
			
		}else if(gridId == "gridItemList"){
			if(colName == "CNLBOX"){
				if(colValue == "V"){
					return "impflg";	
				}else if($.trim(colValue) == " "){
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
		<button CB="Fwdcnl SAVE BTN_FWDCNL"></button>
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
						
										<th CL="STD_ALLCNL"></th>
										<td>
											<select id="ALLCNL" name="ALLCNL" style="width:160px">
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
												<td GH="100 STD_WAREKY"   GCol="select,WAREKY" validate="required">
													<select Combo="WmsCommon,ROLCTWAREKY" disabled="disabled" ComboCodeView=false></select>
												</td>
												<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD" GF="D" ></td>
												<td GH="100 STD_SHPDGR"    GCol="text,SHPDGR" GF="N" ></td>
												<td GH="130 STD_VEHINO"    GCol="text,VEHINO"  ></td>
												<td GH="80 STD_DOCKNO"    GCol="text,DOCKNO"  ></td>
												<td GH="80 STD_CARCNT"    GCol="text,CARCNT"  ></td>
												<td GH="100 STD_ALLCNL"    GCol="icon,ALLCNL" GB="regAft"></td>
												<td GH="100 STD_CNLORD"    GCol="text,CNLORD" GF="N" ></td>
												<td GH="100 STD_CNLTRG"    GCol="text,CNLTRG" GF="N" ></td>
												<td GH="100 STD_ENDCNL"    GCol="text,ENDCNL" GF="N" ></td>
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
										        <td GH="40"                GCol="rowCheck"></td>
										        <td GH="100 STD_SVBELN"    GCol="text,SVBELN"  ></td>
										        <td GH="150 STD_SHCARN"    GCol="text,SHCARN"  ></td>
										        <td GH="100 STD_CNLBOX"    GCol="icon,CNLBOX" GB="regAft"></td>
										        <td GH="100 STD_BOXTYP"    GCol="select,BOXTYP"  >
										            <select Combo="Common,COMCOMBO" id="BOXTYP" name="BOXTYP" ComboCodeView=false></select>
										        </td>
										        <td GH="100 STD_SBOXID"    GCol="text,SBOXID"  ></td>
										        <td GH="100 STD_BOXLAB"    GCol="text,BOXLAB"  ></td>
										        <td GH="100 STD_SUSRNM"    GCol="text,SUSRNM"  ></td>
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