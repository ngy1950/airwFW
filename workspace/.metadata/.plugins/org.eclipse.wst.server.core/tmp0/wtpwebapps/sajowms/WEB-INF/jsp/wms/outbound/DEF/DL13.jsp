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
.regNot{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn25.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
</style>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript" src="/common/js/pagegrid/skumaPopup.js"></script>
<script type="text/javascript">
var boxtyp;
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "DL13",
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
			param.put("PROGID" , configData.MENU_ID);
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
        }else if(btnName == "Save"){
        	saveData();
        }else if(btnName == "Facilities"){
        	print();
        }else if(btnName == "Dpsreject"){
        	saveData2();
        }
    }
    
  //헤더 조회 
	function searchList(){
		boxtyp = $('#BOXTYP').val();
		
		gridList.resetGrid("gridHeadList");
		gridList.setReadOnly("gridHeadList", false, ["rowCheck","QTJCMP"]);
		
		var param = inputList.setRangeParam("searchArea");

        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }
		
	}
    
	function saveData(){
		if( gridList.validationCheck("gridHeadList", "select") ){
			var list = gridList.getSelectData("gridHeadList");
			
	
			if( list.length == 0 ){
				commonUtil.msgBox("VALID_M0006"); //* 변경된 데이터가 없습니다.
				return;
			}
			
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
	            return;
	        }
			
			var param = new DataMap();
				param.put("list",list);
			
			netUtil.send({
				url : "/wms/outbound/json/saveDL13.data",
				param : param ,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	
	function succsessSaveCallBack(json,status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0815",json.data);
			searchList();
		}
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){
			var list = gridList.getGridData("gridHeadList");
			for(var i=0;i<list.length;i++){
				var qtsiwh = parseInt(list[i].get("QTSIWH"));
				if(qtsiwh == 0){
					gridList.setRowReadOnly("gridHeadList", i, true, ["rowCheck","QTJCMP"]);
				}
			}
		}
	}
	
    // 그리드 item 조회 이벤트
    function gridListEventItemGridSearch(gridId, rowNum, itemList){  

    }
    
    // 아이템 그리드 Parameter
    function getItemSearchParam(rowNum){

    }
    
    //그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
    function gridExcelDownloadEventBefore(gridId){
    	var param = inputList.setRangeParam("searchArea");
        return param;
    }

    
    function gridListEventRowDblclick(gridId, rowNum){
        
    }
    
	// 그리드 클릭 포커스 이벤트(클릭), 수정 데이터가 있을 경우 컨펌메세지 후 이동 또는 복귀
	function gridListEventRowFocus(gridId, rowNum){
		
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(colName == "QTJCMP"){
			var qtjcmp = parseInt(colValue);
			var qtyave = parseInt(gridList.getColData(gridId, rowNum, "QTYAVE"));
			var qtsiwh = parseInt(gridList.getColData(gridId, rowNum, "QTSIWH"));
			
			if(qtjcmp > qtyave){
				alert("피킹 가능수량을 초과 하였습니다.");
				if(qtyave > qtsiwh){
					gridList.setColValue(gridId, rowNum, colName, qtsiwh);
				}else{
					gridList.setColValue(gridId, rowNum, colName, qtyave);
				}
				return;
			}
			
			if(qtjcmp > qtsiwh){
				alert("재고수량 보다 많은 수량으로 피킹을 할수 없습니다.");
				if(qtyave > qtsiwh){
					gridList.setColValue(gridId, rowNum, colName, qtsiwh);
				}else{
					gridList.setColValue(gridId, rowNum, colName, qtyave);
				}
				return;
			}
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
			
			if(name == "SC.SKUCLS" || name == "SKUCLS"){
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
				param.put("USARG1","V");
			}
			
			return param;
		}else if ( comboAtt == "WmsCommon,DOCTMCOMBO"){
            var param = new DataMap();
            param.put("PROGID", configData.MENU_ID);
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
			url : "/wms/outbound/json/printDL13.data",
			param : param
		});
		
		if ( json && json.data ){
				var url = "<%=systype%>" + "/facilities_picking_list.ezg";
				var where = "PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				var width =  600;
				var heigth = 840;
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url , where , "" , langKy, map , width , heigth );
				
				
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
	
	function saveData2(){
		var param = inputList.setRangeParam("searchArea");

        if(validate.check("searchArea")){
        	netUtil.send({
				url : "/wms/outbound/json/saveDL13DPSREJECT.data",
				param : param ,
				successFunction : "succsessSaveCallBack2"
			});
			
		}
	}
	
	function succsessSaveCallBack2(json,status){
		if( json && json.data ){
			commonUtil.msgBox("저장 되었습니다.");
			searchList();
		}
	}
	
	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
        
        if( gridId == "gridHeadList" ){
        	var cnlmak = gridList.getColData("gridHeadList", rowNum, "CNLMAK");
			
			if(cnlmak == 'V'){
				return true;
			}
        }
    }
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "CNLMAK"){
				if(colValue == "V"){
					return "regNot";	
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
		<button CB="Save SAVE BTN_PICKCOMP"></button>
		<button CB="Facilities PRINT BTN_FACIPICKLIST"></button>
		<button CB="Dpsreject SAVE BTN_NOTDPS"></button>
	</div>
</div>

    <!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top" style="height:150px" id="searchArea">
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
										
										<th CL="STD_SVBELN"></th>
										<td>
											<input type="text" name="SI.SVBELN" UIInput="SR" />
										</td>
										
										<th CL="STD_SBOXID"></th>
										<td>
											<input type="text" name="SB.SBOXID" UISave="false"  UIInput="SR" />
										</td>
										
									</tr>
									
									<tr>
										<th CL="STD_BOXLAB"></th>
										<td>
											<input type="text" name="SB.BOXLAB" UISave="false"  UIInput="SR" />
										</td>
										<th CL="STD_SKUKEY"></th>
										<td>
											<input type="text" name="SI.SKUKEY" UIInput="SR,SHSKUMA" UIformat="U" UiRange="3" />
										</td>
									
										<th CL="STD_PKJMAK"></th>
										<td>
											<select id="PKJMAK" name="PKJMAK"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="0">전체</option>
												<option value="1">완료</option>
												<option value="2" selected>미완료</option>
											</select>
										</td>
									</tr>
									<tr>
										<th CL="STD_BOXTYP"></th>
										<td>
											<select id="BOXTYP" name="BOXTYP" Combo="Common,COMCOMBO" UISave="false" ComboCodeView=false style="width:160px">
												<option value="">전체</option>
											</select>
										</td>
										
										<th CL="STD_CNLMAK"></th>
										<td>
											<select id="CNLMAK" name="CNLMAK"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="" selected>전체</option>
												<option value="Y" >Y</option>
												<option value="N" >N</option>
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
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="100 STD_WAREKY"    GCol="text,WAREKYNM"  ></td>
												<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD" GF="D" ></td>
												<td GH="50 STD_SHPDGR"    GCol="text,SHPDGR"  ></td>
												<td GH="100 STD_SHPMTY"    GCol="text,SHPMTY"  ></td>
												<td GH="100 STD_VEHINO"    GCol="text,VEHINO"  ></td>
												<td GH="70 STD_DOCKNO"    GCol="text,DOCKNO"  ></td>
												<td GH="70 STD_CARCNT"    GCol="text,CARCNT"  ></td>
												<td GH="90 STD_SVBELN"    GCol="text,SVBELN"  ></td>
												<td GH="90 STD_CNLMAK"    GCol="icon,CNLMAK" GB="regAft" ></td>
												<td GH="80 STD_SPOSNR"    GCol="text,SPOSNR"  ></td>
												<td GH="80 STD_BOXTYP"    GCol="text,BOXTYP"  ></td>
												<td GH="100 STD_SBOXSQ"    GCol="text,SBOXSQ"  ></td>
												<td GH="100 STD_SBOXID"    GCol="text,SBOXID"  ></td>
												<td GH="100 STD_BOXLAB"    GCol="text,BOXLAB"  ></td>
												<td GH="130 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
												<td GH="240 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="60 STD_PACKYN"    GCol="text,PACKYN"  ></td>
												<td GH="60 STD_PACQTY"    GCol="text,PACQTY" GF="N" ></td>
												<td GH="70 STD_LOTA06NM"    GCol="text,LOTA06NM"  ></td>
												<td GH="100 STD_QTSIWH"    GCol="text,QTSIWH" GF="N"  ></td>
												<td GH="100 STD_LOCAKY"    GCol="text,LOCAKY"  ></td>
												<td GH="70 STD_SHIT01"    GCol="text,SHIT01"  ></td>
												<td GH="100 STD_QTSHPO"    GCol="text,QTSHPO" GF="N" ></td>
												<td GH="100 STD_QTYREF"    GCol="text,QTYREF" GF="N" ></td>
												<td GH="100 STD_QTAPPO"    GCol="text,QTAPPO" GF="N" ></td>
												<td GH="100 STD_PICKQTYAVE"    GCol="text,QTYAVE" GF="N" ></td>
												<td GH="100 STD_QTJCMP"    GCol="input,QTJCMP" GF="N" validate="required gt(0),MASTER_M4002" ></td>
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