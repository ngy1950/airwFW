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
	midAreaHeightSet = "200px";
	var make = true;
	var wa = " ";
	var today;
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "SV01",
			itemGrid : "gridItemList",
            itemSearch : true,
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList",
	    	name : "gridItemList",
			editable : true,
			module : "WmsOutbound",
			pkcol : "SKUKEY",
			command : "SV01SUB",
            autoCopyRowType : true
	    });
		
		inputList.setMultiComboSelectAll($("#SHMSTS"), true);
		$('#fwdreq').hide();
		$('#reqcnl').hide();
				
				
		var json = netUtil.sendData({
	        module : "WmsCommon",
	        command : "GETDATE",
	        sendType : "map"
	    });
		
		today = json.data["DATA"];
		
		$('#add').hide();
		$('#delete').hide();
		
    });
    
    // 공통 버튼 클릭 이벤트
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }else if(btnName == "Make"){
            makeHead();
        }else if(btnName == "Fwdreq"){
        	saveData();
        }else if(btnName == "Reqcnl"){
        	cancelData();
        }
    }
    
    function makeHead(){
    	make = true;
    	
		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridItemList");
		
		gridList.setReadOnly("gridItemList", false, ["SKUKEY","QTYORG"]);
		gridList.setReadOnly("gridHeadList", false, ["RQSHPD","WAREKY","DOCTXT"]);
		
		$('#add').show();
		$('#delete').show();
		$('#fwdreq').show();
		$('#reqcnl').hide(); PTRCVR
		var param = new DataMap();
			param.put("PTRCVR", "<%=wareky%>");

		gridList.gridList({
	    	id : "gridHeadList",
	    	param : param,
	    	command : "SV01CRE"
	    });
		
	}
    
  //헤더 조회 
	function searchList(){
		make = false;
		
		$('#add').hide();
		$('#delete').hide();
		$('#reqcnl').show();
		$('#fwdreq').hide();
		
		
		gridList.resetGrid("gridHeadList");
		gridList.resetGrid("gridItemList");
		
		gridList.setReadOnly("gridItemList", true, ["SKUKEY","QTYORG","LOTA06"]);
		gridList.setReadOnly("gridHeadList", true, ["RQSHPD","WAREKY","DOCTXT"]);
		
		var param = inputList.setRangeParam("searchArea");

        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }
		
	}
    
	function saveData(){
			
		if( gridList.validationCheck("gridItemList", "modify") ){
		
			var head = gridList.getGridData("gridHeadList");
			var list = gridList.getGridData("gridItemList");
			
			var chk1 = true;
			var chk2 = true;
			var chk3 = true;
			
			for(var i=0;i<list.length;i++){
				if(parseInt(list[i].get("QTYORG")) == 0 ){
					chk1 = false;
					break;
				}else if(list[i].get("LOTA06") == " "){
					chk2 = false;
					break;
				}else if(parseInt(list[i].get("QTSIWH")) == 0 ){
					chk3 = false;
					break;
				}
			}
			
			if(!chk1){
				commonUtil.msgBox("VALID_M0509"); //요청 수량이 존재 하지 않습니다.
				return;
			}
			
			if(!chk2){
				commonUtil.msgBox("VALID_M0510"); //재고상태를 확인 하세요
				return;
			}
			
			if(!chk3){
				commonUtil.msgBox("VALID_M0511"); //재고 수량이 존재 하지 않습니다.
				return;
			}
			
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
	            return;
	        }
			
			var param = new DataMap();
				param.put("list", list);
				param.put("head",head);
			
			netUtil.send({
				url : "/wms/outbound/json/saveSV01.data",
				param : param ,
				successFunction : "succsessSaveCallBack"
			});
			
		}
	}
	
	function succsessSaveCallBack(json,status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0815", json.data);
			searchList();
		}
	}
	
	function cancelData(){
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
			paramchk.put("WAREKY" , "<%=wareky%>" );
			paramchk.put("PRGID","SV01");
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
		
		if(!chk){
			commonUtil.msgBox("VALID_M0512"); //요청 이 아닌 상태 값이 존재 합니다.
			return ;
		}
		
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
            return;
        }
		
		var param = new DataMap();
			param.put("list",list);
			
		netUtil.send({
			url : "/wms/outbound/json/saveCancelSV01.data",
			param : param ,
			successFunction : "succsessCancelCallBack"
		});
		
		
	}
	
	function succsessCancelCallBack(json,status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0815", json.data);
			searchList();
		}
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(make){
			gridList.resetGrid("gridItemList");
			var map = new DataMap();
        	gridList.addNewRow("gridItemList",map);
		}
	}
	
    // 그리드 item 조회 이벤트
    function gridListEventItemGridSearch(gridId, rowNum, itemList){  
    	if(make){
    		return ;
    	}
    	gridList.resetGrid("gridItemList");
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
	    if(gridId == "gridHeadList"){
			if(colName == "WAREKY"){
				var be = gridList.getColData(gridId, rowNum, "BEWAREKY");
				if(be == " "){
					if(be == colValue){
						return ;
					}
					
					gridList.setColValue(gridId, rowNum, "BEWAREKY", colValue);
				}else{
					var cnt = gridList.getGridDataCount("gridItemList");

					if(be != colValue){
						if(!commonUtil.msgConfirm("VALID_M0513")){ //출하물류센터가 변경되면 요청상품이 초기화 됩니다\n진행 하시겠습니까?
				            gridList.setColValue(gridId, rowNum, colName, be);
							return;
				        }else{
				        	gridList.setColValue(gridId, rowNum, "QTYORG", 0);
				        	gridList.setColValue(gridId, rowNum, "BEWAREKY", colValue);
				        	
				        	gridList.resetGrid("gridItemList");
							var map = new DataMap();
								map.put("QTYORG",0);
				        	gridList.addNewRow("gridItemList",map);
				        	
				        }
					}
				}
				
				if(colValue != " "){
					var param = new DataMap();
		        		param.put("WAREKY",colValue);
		        	
		        	var json = netUtil.sendData({
		                module : "WmsCommon",
		                command : "OWNRKY",
		                sendType : "map",
		                param : param
		            });
		        	
		        	gridList.setColValue(gridId, rowNum, "OWNRKY", json.data["OWNRKY"]);
				}
			}else if(colName == "RQSHPD"){
				if(colValue < today){
					commonUtil.msgBox("VALID_M0514"); //배송요청일은  과거로 설정 할수 없습니다. 
					gridList.setColValue(gridId, rowNum, "RQSHPD", today);
					return ;
				}
			}
	    }else if(gridId == "gridItemList"){
			if(colName == "QTYORG"){
				var list = gridList.getGridData("gridItemList");
				var qtsiwh = parseInt(gridList.getColData(gridId, rowNum, "QTSIWH"));
				
				if(qtsiwh == 0){
					commonUtil.msgBox("VALID_M0515"); //선택된 상품이 없거나 재고가 존재 하지 않습니다.
					gridList.setColValue("gridItemList", rowNum, "QTYORG", 0);
					return ; 
				}else if(qtsiwh < parseInt(colValue)){
					alert("재고수량 이상으로 요청할수 없습니다.")
					gridList.setColValue("gridItemList", rowNum, "QTYORG", qtsiwh);
					return ; 
				}
				
				var sum = 0;
				for(var i=0 ;i < list.length ; i++){
					var row = list[i];
					var te = row.get("GRowState");
					
					if(row.get("GRowState") == "C"){
						sum+= parseInt(gridList.getColData(gridId, i, colName));
					}
					
					
				}
				gridList.setColValue("gridHeadList", 0, "QTYORG", sum);
			}else if(colName == "LOTA06"){
				if(colValue != " "){
					var wareky = gridList.getColData("gridHeadList", 0, "WAREKY");
					var skueky = gridList.getColData(gridId, rowNum, "SKUKEY");
					
					if(wareky == " "){
						commonUtil.msgBox("VALID_M0516"); //출하 물류센터가 선택 되지 않았습니다.\n센터를 먼저 선택해 주세요.
						gridList.setColValue(gridId, rowNum, colName, " ");
						return;
					}
					
					var param = new DataMap();
						param.put("WAREKY",wareky);
						param.put("SKUKEY",skueky);
						param.put("LOTA06",colValue);
						
					var json = netUtil.sendData({
		                module : "WmsOutbound",
		                command : "SV01QTSIWH",
		                sendType : "map",
		                param : param
		            });
					gridList.setColValue(gridId, rowNum, "QTSIWH", json.data["QTSIWH"]);
				}else{
					gridList.setColValue(gridId, rowNum, "QTSIWH", 0);
				}
			}else if(colName == "SKUKEY"){
				var wareky = gridList.getColData("gridHeadList", 0, "WAREKY");
				var ownrky = gridList.getColData("gridHeadList", 0, "OWNRKY");
				
				if(wareky == " "){
					commonUtil.msgBox("VALID_M0516"); //출하 물류센터가 선택 되지 않았습니다.\n센터를 먼저 선택해 주세요.
					
					gridList.setColValue(gridId, rowNum, "DESC01", "");
					gridList.setColValue(gridId, rowNum, "SKUKEY", "");
					gridList.setColValue(gridId, rowNum, "LOTA06", " ");
					gridList.setColValue(gridId, rowNum, "QTYORG", 0);
					gridList.setColValue(gridId, rowNum, "QTSIWH", 0);
					
					var list = gridList.getGridData("gridItemList");
					
					var sum = 0;
					for(var i=0 ;i < list.length ; i++){
						var row = list[i];
						var te = row.get("GRowState");
						
						if(row.get("GRowState") == "C"){
							sum+= parseInt(gridList.getColData(gridId, i, "QTYORG"));
						}
					}
					gridList.setColValue("gridHeadList", 0, "QTYORG", sum);
					
					return;
				}
				
				var sku = colValue.split(" ").join("").split("	").join("");
				
				if(sku == ""){
					gridList.setColValue(gridId, rowNum, "DESC01", "");
					gridList.setColValue(gridId, rowNum, "SKUKEY", "");
					gridList.setColValue(gridId, rowNum, "LOTA06", " ");
					gridList.setColValue(gridId, rowNum, "QTYORG", 0);
					gridList.setColValue(gridId, rowNum, "QTSIWH", 0);
					
					var list = gridList.getGridData("gridItemList");
					
					var sum = 0;
					for(var i=0 ;i < list.length ; i++){
						var row = list[i];
						var te = row.get("GRowState");
						
						if(row.get("GRowState") == "C"){
							sum+= parseInt(gridList.getColData(gridId, i, "QTYORG"));
						}
					}
					gridList.setColValue("gridHeadList", 0, "QTYORG", sum);
					
					return;
				}
				
				var wareky = gridList.getColData("gridHeadList", 0, "WAREKY");
				var ownrky = gridList.getColData("gridHeadList", 0, "OWNRKY");
				var param = new DataMap();
					param.put("OWNRKY",ownrky);
					param.put("SKUKEY",colValue);
					
				var json = netUtil.sendData({
	                module : "WmsOutbound",
	                command : "DESC01",
	                sendType : "map",
	                param : param
	            });
				
				gridList.setColValue(gridId, rowNum, "DESC01", json.data["DESC01"]);
				gridList.setColValue(gridId, rowNum, "LOTA06", "00");
				
				var param = new DataMap();
					param.put("WAREKY",wareky);
					param.put("SKUKEY",colValue);
					param.put("LOTA06","00");
				
				var json = netUtil.sendData({
	                module : "WmsOutbound",
	                command : "SV01QTSIWH",
	                sendType : "map",
	                param : param
	            });
				gridList.setColValue(gridId, rowNum, "QTSIWH", json.data["QTSIWH"]);
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
    
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Make SAVE BTN_CREATE"></button>
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Fwdreq SAVE BTN_FWDREQ" id="fwdreq"></button>
		<button CB="Reqcnl SAVE BTN_REQCNL" id="reqcnl"></button>
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
										<th CL="STD_PTRCVR"></th>
										<td>
											<select id="PTRCVR" name="PTRCVR" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
									
										<th CL="STD_RQSHPD"></th>
										<td>
											<input type="text" name="RQSHPD" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHMSTS"></th>
										<td>
											<select id="SHMSTS" name="SH.SHMSTS" Combo="Common,COMCOMBO" comboType="MS"  validate="required(STD_SHMSTS)" UISave="false" ComboCodeView=false style="width:160px">
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
												<td GH="100 STD_PTRCVR"    GCol="text,PTRCVRNM"  ></td>
												<td GH="100 STD_TOWAREKY"    GCol="select,WAREKY"  >
													<select Combo="WmsCommon,ROLCTWAREKY2" id="WAREKY" name="WAREKY"  ComboCodeView=false>
														<option value=" ">선택</option>
													</select>
												</td>
												<td GH="100 STD_RQSHPD"    GCol="input,RQSHPD" GF="C" ></td>
												<td GH="100 STD_SHMSTS"    GCol="text,SHMSTSNM"  ></td>
												<td GH="100 STD_REQQTY"    GCol="text,QTYORG"  GF="N" ></td>
<!-- 												<td GH="100 STD_QTSHPO"    GCol="text,QTSHPO"  GF="N" ></td> -->
												<td GH="100 STD_QTSHPD"    GCol="text,QTSHPD"  GF="N" ></td>
												<td GH="200 STD_REQTXT"    GCol="input,DOCTXT"  ></td>
												<td GH="200 STD_RTNTXT"    GCol="text,RTNTXT"  ></td>
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
												<td GH="130 STD_SKUKEY"    GCol="input,SKUKEY,SHSKUWC"  validate="required" ></td>
												<td GH="240 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="100 STD_LOTA06"    GCol="select,LOTA06"  >
													<select Combo="Common,COMCOMBO" id="LOTA06" name="LOTA06" ComboCodeView=false>
														<option value=" " selected>선택</option>
													</select>
												</td>
												<td GH="100 STD_OUTWAREKYQTY"    GCol="text,QTSIWH"  GF="N" ></td>
												<td GH="100 STD_REQQTY"    GCol="input,QTYORG" validate="required gt(-1),MASTER_M4002" GF="N 4,0" ></td>
<!-- 												<td GH="100 STD_CFMQTY"    GCol="text,QTSHPO"  GF="N" ></td> -->
												<td GH="100 STD_QTSHPD"    GCol="text,QTSHPD"  GF="N" ></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button id="add" type="button" GBtn="add"></button>
									<button id="delete" type="button" GBtn="delete"></button>
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