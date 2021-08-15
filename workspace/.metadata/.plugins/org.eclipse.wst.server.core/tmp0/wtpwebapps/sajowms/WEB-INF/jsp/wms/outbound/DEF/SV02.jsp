<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	midAreaHeightSet = "200px";
	
	var shmsts = "",excelrow = -1 , today="";

    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "SV02",
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList",
	    	name : "gridItemList",
			editable : true,
			module : "WmsOutbound",
			pkcol : "SKUKEY",
			command : "SV02SUB",
            autoCopyRowType : true
	    });
		
		
		var day = new Date();
		day.setDate(day.getDate());
		var dd = day.getDate();
		var mm = day.getMonth() + 1;
		var yyyy = day.getFullYear();

		if( dd < 10 ) {
			dd ='0' + dd;
		} 

		if( mm < 10 ) {
			mm = '0' + mm;
		}
		
		today = String(yyyy) + String(mm) + String(dd);
		
		inputList.setMultiComboValue($("#SHMSTS"), ["REQ","CMP"]);
		gridList.setReadOnly("gridItemList", true , ["LOTA06","QTSHPO"]);
		gridList.setReadOnly("gridHeadList", true , ["RQSHPD"]);

    });
    
    // 공통 버튼 클릭 이벤트
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }else if(btnName == "Reject"){
            rejorcfm("NOT");
        }else if(btnName == "Complete"){
        	rejorcfm("CMP");
        }else if(btnName == "Outfsh"){
        	saveData();
        }else if(btnName == "Transfershipment"){
        	print();
        }
    }

    
  //헤더 조회 
	function searchList(){
		
		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridItemList");
		excelrow = -1;
		
		gridList.setReadOnly("gridHeadList", false , ["RTNTXT","rowCheck"]);
		
		var param = inputList.setRangeParam("searchArea");

        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }
	}
  
  
	 // 그리드 item 조회 이벤트
    function subsearchlist(gridId, rowNum, itemList){  
    	gridList.resetGrid("gridItemList");
        var param = getItemSearchParam(rowNum);
        excelrow = rowNum;
        inddcl = gridList.getColData("gridHeadList", rowNum, "INDDCL");
        
        gridList.setReadOnly("gridItemList", false, ["QTSHPD"]);
        
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
        	param.put("GBN","SEARCH");
        
        return param;
    }
   
	//이동출하 승인
	function rejorcfm(gbn){
		if( gridList.validationCheck("gridItemList", "modify") ){
			var list = gridList.getSelectData("gridHeadList");
			
			if(list.length < 1){
				commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
				return ;
			}
			
			var chk = true;
			
			
			var arraylist = [];
			
			for(var i=0;i<list.length;i++){
				var shmsts = list[i].get("SHMSTS");
				if(shmsts != "REQ"){
					chk = false;
				}
				arraylist[i] = list[i].get("SHPOKY");
			}
			
			var paramchk = new DataMap();
				paramchk.put("SHPOKYLIST",arraylist);
				paramchk.put("PRGID","SV02");
				paramchk.put("WAREKY" , "<%=wareky%>" );
				paramchk.put("SHMSTS" , "REQ");
			
			
			if(!chk){
				commonUtil.msgBox("VALID_M0512"); //요청 이 아닌 상태 값이 존재 합니다.
				return ;
			}
	
			
			var json2 = netUtil.sendData({
	              module : "WmsOutbound",
	              command : "CHK_SHMSTS",
	              sendType : "map",
	              param : paramchk
			});
			
			if(parseInt(json2.data["CNT"]) != list.length){
				commonUtil.msgBox("VALID_M0517"); //요청상태가 변경된 값이 존재 합니다.\n재조회후 실행 하시기 바랍니다.
				return ;
			}
			
			var commmsg = "";
			
			if(gbn == "CMP"){
				commsg = "COMMON_M0114"
			}else{
				commsg = "COMMON_M0115"
			}
			
			if(!commonUtil.msgConfirm(commsg)){
	            return;
	        }
			
			var param = new DataMap();
				param.put("list",list);
				param.put("GBN",gbn);
				
			netUtil.send({
				url : "/wms/outbound/json/saveshmstsSV02.data",
				param : param , 
				successFunction : "succsessRejCallBack"
			});
			
		}
	}
	
	function succsessRejCallBack(json,status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0815", json.data);
			searchList();
			
			//top 재조회
			window.parent.parent.frames["header"].countCall();
		}
	}
    
	//이동출하 완료
	function saveData(){
			
		if( gridList.validationCheck("gridItemList", "modify") ){
		
			var head = gridList.getSelectData("gridHeadList");
			var list = gridList.getGridData("gridItemList");
			
			
			
			
			
			if(head.length < 1){
				commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
				return ;
			}
			
			var chk = true;
			var chk2 = true;
			var chk3 = true;
			
			var arraylist = [];
			
			for(var i=0;i<head.length;i++){
				var shmsts = head[i].get("SHMSTS");
				var inddcl = head[i].get("INDDCL");
				var rqshpd = head[i].get("RQSHPD");
				if(shmsts != "CMP"){
					chk = false;
				}
				if(inddcl == "V"){
					chk2 = false;
				}
				
				if(today != rqshpd){
					chk3 = false;
				}
				
				arraylist[i] = head[i].get("SHPOKY");
				
			}
			
			if(!chk){
				commonUtil.msgBox("VALID_M0518"); //요청상태가 승인이 아닌 값이 존재 합니다.
				return ;
			}
			
			if(!chk2){
				commonUtil.msgBox("출하완료된 문서가 포함 되었습니다."); //요청상태가 승인이 아닌 값이 존재 합니다.
				return ;
			}
			
			if(!chk3){
				commonUtil.msgBox("배송일 이 당일인 건 만 출하완료 가 가능 합니다."); //요청상태가 승인이 아닌 값이 존재 합니다.
				return ;
			}
			
			var paramchk = new DataMap();
				paramchk.put("SHPOKYLIST",arraylist);
				paramchk.put("PRGID","SV02");
				paramchk.put("WAREKY" , "<%=wareky%>" );
				paramchk.put("SHMSTS" , "CMP");
			
			var json = netUtil.sendData({
	              module : "WmsOutbound",
	              command : "CHK_SHMSTS",
	              sendType : "map",
	              param : paramchk
			});
			
			if(parseInt(json.data["CNT"]) != head.length){
				commonUtil.msgBox("VALID_M0517"); //요청상태가 변경된 값이 존재 합니다.\n재조회후 실행 하시기 바랍니다.
				return ;
			}
			
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
	            return;
	        }
			
			var param = new DataMap();
				param.put("list", list);
				param.put("head",head);
			
			netUtil.send({
				url : "/wms/outbound/json/saveSV02.data",
				param : param ,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	
	function succsessSaveCallBack(json,status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0815", json.data);
			searchList();
			
			//top 재조회
			window.parent.parent.frames["header"].countCall();
		}
	}
	
	//이동출하 거절
	function cancelData(){
		var list = gridList.getSelectData("gridHeadList");
		
		if(list.length < 1){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return ;
		}
		
		var chk = true;
		
		for(var i=0;i<list.length;i++){
			var row = list[i];
			var shmsts = row.get("SHMSTS");
			
			if(shmsts != "REQ"){
				chk = false;
				break;
			}
		}
		
		if(!chk){
			commonUtil.msgBox("VALID_M0512"); //요청 이 아닌 상태 값이 존재 합니다.
			return ;
		}
		
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
            return;
        }
		
		var param = new DataMap();
			param.put("list",list);
		
		var json = netUtil.sendData({
			url : "/wms/outbound/json/saveCancelSV01.data",
			param : param
		});
		
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0815", json.data);
			searchList();
		}
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridItemList" && dataLength > 0){
			
			for(var i=0;i<dataLength;i++){
				var qtyorg = gridList.getColData(gridId, i, "QTYORG");
				
				var qtshpo = gridList.getColData(gridId, i, "QTSHPO");
				var inddcl = gridList.getColData(gridId, i, "INDDCL");
				var shmsts = gridList.getColData(gridId, i, "SHMSTS");
				gridList.setReadOnly(gridId, true, ["LOTA06"]);
				
				if(shmsts != "CMP" || inddcl == 'V'){
					gridList.setReadOnly(gridId, true, ["QTSHPD"]);
				}else{
					gridList.setReadOnly(gridId, false, ["QTSHPD"]);
				}
			}
		}else if(gridId == "gridHeadList" && dataLength > 0){
			for(var i=0;i<dataLength;i++){
				var inddcl = gridList.getColData(gridId, i, "INDDCL");
// 				if(inddcl == 'V'){
// 					gridList.setRowReadOnly("gridHeadList", i, true, ["RTNTXT","rowCheck"])
// 				}
			}
			subsearchlist(gridId,0,"gridItemList");
		}

	}
	
    //그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
    function gridExcelDownloadEventBefore(gridId){
        var param = inputList.setRangeParam("searchArea");
        
        if(gridId == "gridItemList"){
            var rowNum = excelrow;
            if(rowNum == -1){
                return false;
            }else{
                 param = getItemSearchParam(rowNum);
            }
        }
        return param;
    }

    
    function gridListEventRowDblclick(gridId, rowNum){
    	if(gridId == "gridHeadList"){
        	subsearchlist(gridId,rowNum,"gridItemList");
        }
    }
    
	// 그리드 클릭 포커스 이벤트(클릭), 수정 데이터가 있을 경우 컨펌메세지 후 이동 또는 복귀
	function gridListEventRowFocus(gridId, rowNum){
		
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
	    if(gridId == "gridItemList"){
			if(colName == "QTSHPD"){
				var qtyorg = parseInt(gridList.getColData(gridId, rowNum, "QTYORG"));
				var qtsiwh = parseInt(gridList.getColData(gridId, rowNum, "QTSIWH"));
				if(qtsiwh < parseInt(colValue)){
					alert("재고수량 이상으로 출하를 할수 없습니다.");
					gridList.setColValue(gridId, rowNum, colName, qtsiwh);
				}else if(qtyorg < parseInt(colValue)){
					alert("요청수량 이상으로 출하를 할수 없습니다.");
					gridList.setColValue(gridId, rowNum, colName, qtyorg);
				}
			}
		}
	}
	
	// 그리드 Row 추가 전 이벤트
    function gridListEventRowAddBefore(gridId, rowNum){
        
    }
    
     // 그리드 Row 추가 후 이벤트
    function gridListEventRowAddAfter(gridId, rowNum){
    	 gridList.setColValue(gridId, rowNum, "QTYORG", 0);
    } 
    
    // 그리드 컬럼 format을 동적으로 변경 가능한 이벤트 
    function gridListEventColFormat(gridId, rowNum, colName){

    }
	
    
	var num = 0;
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		num = rowNum;
		var skukey = gridList.getColData("gridItemList", rowNum, "SKUKEY");
		var wareky = gridList.getColData("gridHeadList", 0, "WAREKY");
		var ownrky = gridList.getColData("gridHeadList", 0, "OWNRKY");
		
		if(wareky == " "){
			commonUtil.msgBox("VALID_M0516"); //출하 물류센터가 선택 되지 않았습니다.\n센터를 먼저 선택해 주세요.
			return false;
		}
		
		if(searchCode == "SHSKUWC"){
			var param = new DataMap();
				param.put("SKUKEY",skukey);
				param.put("WAREKY",wareky);
				param.put("OWNRKY",ownrky);
			return param;
		}
		
	}
	
	// 서치헬프 종료 이벤트
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
// 		gridList.setColValue("gridItemList", num, "DESC01", rowData.get("DESC01"))
	}
    
  //콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
		}else if( comboAtt == "WmsCommon,ROLCTWAREKY2" ){
			param.put("PTRCVR", "<%=wareky%>");
		
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
			}else if(name == "SH.SHMSTS" || name == "SHMSTS"){
				param.put("CODE", "SHMSTS");
			}else if(name == "LOTA06"){
				param.put("CODE", "LOTA06");
				param.put("USARG1","V");
			}
			
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
			url : "/wms/outbound/json/printSV02.data",
			param : param
		});
		
		if ( json && json.data ){
				var url = "<%=systype%>" + "/transfer_shipment_list.ezg";
				var where = "PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				var width =  600;
				var heigth = 840;
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url , where , "" , langKy, map , width , heigth );
				
				
		}
	}  
    
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Complete SEARCH BTN_COMPLETE"></button>
		<button CB="Reject SEARCH BTN_REJECT"></button>
		<button CB="Outfsh SEARCH BTN_OUTFSH"></button>
		<button CB="Transfershipment PRINT BTN_TRANSFERSHIPMENT"></button>
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
									<col width="450" />
									<col width="50" />
				                    <col />
								</colgroup>
								<tbody>
									<tr>
										<th CL="STD_TOWAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
									
										<th CL="STD_RQSHPD"></th>
										<td>
											<input type="text" name="RQSHPD" UISave="false" UIInput="B" UIFormat="C -7"  validate="required(STD_RQSHPD)" MaxDiff="M1" />
										</td>
									
										<th CL="STD_SHMSTS"></th>
										<td>
											<select id="SHMSTS" name="SH.SHMSTS" Combo="Common,COMCOMBO" comboType="MS"  validate="required(STD_SHMSTS)" UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
								
									</tr>
									<tr>
										<th CL="STD_INDDCL"></th>
										<td>
											<select id="INDDCL" name="INDDCL" style="width:160px">
				                            	<option value="0">전체</option>
				                            	<option value="1">출하</option>
				                            	<option value="2">미출하</option>
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
												<td GH="40"               GCol="rownum">1</td>
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="100 STD_SHPOKY"    GCol="text,SHPOKY"  ></td>
												<td GH="100 STD_TOWAREKY"    GCol="text,WAREKYNM"  ></td>
												<td GH="100 STD_PTRCVR"    GCol="text,PTRCVRNM"  ></td>
												<td GH="100 STD_RQSHPD"    GCol="input,RQSHPD" GF="C" ></td>
												<td GH="100 STD_INDDCL"    GCol="text,INDDCLYN" ></td>
												<td GH="100 STD_SHMSTS"    GCol="text,SHMSTSNM"  ></td>
												<td GH="100 STD_REQQTY"    GCol="text,QTYORG"  GF="N" ></td>
												<td GH="100 STD_QTSHPO"    GCol="text,QTSHPO"  GF="N" ></td>
												<td GH="100 STD_QTSHPD"    GCol="text,QTSHPD"  GF="N" ></td>
												<td GH="200 STD_REQTXT"    GCol="text,DOCTXT" disabled="disabled" ></td>
												<td GH="200 STD_RTNTXT"    GCol="input,RTNTXT"  ></td> 
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
												<td GH="130 STD_SKUKEY"    GCol="text,SKUKEY" ></td>
												<td GH="240 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="100 STD_LOTA06"    GCol="select,LOTA06"  >
													<select Combo="Common,COMCOMBO" id="LOTA06" name="LOTA06" ComboCodeView=false></select>
												</td>
												<td GH="100 STD_QTSIWH"    GCol="text,QTSIWH"  GF="N" ></td>
												<td GH="100 STD_REQQTY"    GCol="text,QTYORG" GF="N" ></td>
												<td GH="100 STD_QTSHPD"    GCol="input,QTSHPD"  GF="N 4,0" validate="gt(-1),MASTER_M4002"></td>
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