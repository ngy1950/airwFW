<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script type="text/javascript">

	$(document).ready(function(){
		
		setTopSize(200);
		
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsInventory",
			command : "SJ02",
			itemGrid : "gridItemList",
			itemSearch : true,
            autoCopyRowType : false
	    });
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsInventory",
			command : "SJ02Sub",
            totalCols : ["QTSIWH","AQTADJU","CONBOX","CONQTY"],
            autoCopyRowType : false
	    });
	});

	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}
	}

	//헤더 조회 
	function searchList(){
		
		if(validate.check("searchArea")){
			
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}		
	}

	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataCount){
		 if ( gridId == "gridItemList" && dataCount <= 0 ){
			gridList.resetGrid("gridHeadList");
			searchOpen(true);
		}else if(gridId == "gridItemList" && dataCount > 0){
			var param = inputList.setRangeParam("searchArea");
			if(param.get("ADJUTY") == "414"){
				gridList.setReadOnly("gridItemList",true, ['LOTA10']);
			}else{
				gridList.setReadOnly("gridItemList",false, ['LOTA10']);
			}
		}
	}
	
	function searchSubList(){
		
		var param = inputList.setRangeParam("searchArea");
		
		gridList.gridList({
	    	id : "gridItemList",
	    	param : param
	    });
		
	}
	
	// 공통 itemGrid 조회 및 / 더블 클릭 Event
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if( gridId == "gridHeadList" ){
        	searchSubList(rowNum);
        }
	}

	// 그리드 더블 클릭 이벤트(하단 그리드 조회)
	function gridListEventRowDblclick(gridId, rowNum, colName){
		
	}

	// 그리드 클릭 포커스 이벤트(클릭), 수정 데이터가 있을 경우 컨펌메세지 후 이동 또는 복귀
	function gridListEventRowFocus(gridId, rowNum){
		
	}

	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var qtychk = 0;
        var qtychk1 = 0;
		
        if(gridId == 'gridHeadList'){
        	if(colName == "DOCDAT"){
                if($.trim(colValue) != ""){
                    var date = new Date();
                    var year = date.getFullYear();
                    var month = date.getMonth()+1
                    var day = date.getDate();
                    if(month < 10){
                        month = "0"+month;
                    }
                    if(day < 10){
                        day = "0"+day;
                    }
                 
                    var today = year+""+month+""+day;
                    if(colValue > today){
                        commonUtil.msgBox("TASK_M1039");
                        gridList.setColValue(gridId, rowNum, "DOCDAT", today);
                        //전기일자는 오늘일자 이후일 수 없습니다.
                        return;
                    }
                }
            }
        } else if ( gridId == 'gridItemList' ){
			if ( colName == "AQTADJU"  && $.trim(colValue) != "0" ){
				
				if( $.trim(colValue) != "" ){
                    var uomkey = gridList.getColData(gridId,rowNum,"IUOMKEY");
                    
                    if(uomkey != ""){
                        var conqty = gridList.getColData(gridId,rowNum,"CONQTY");
                        var palqty = gridList.getColData(gridId,rowNum,"PALQTY");
                        var staqty = gridList.getColData(gridId,rowNum,"STAQTY");
                        var boxqty = gridList.getColData(gridId,rowNum,"BOXQTY");
                        var facqty = gridList.getColData(gridId,rowNum,"FACQTY");
                        
                        if(uomkey == "TA"){
                            if(staqty == "0"){
                                commonUtil.msgBox("TASK_M1006");
                                //환산할 단위의 수량이 0입니다. 다시 입력해 주세요.
                                gridList.setColValue(gridId, rowNum, "AQTADJU", "0");
                                return;
                            }else{
                                qtychk = staqty * colValue;
                            }
                        }else if(uomkey == "BOX"){
                            if(boxqty == "0"){
                                commonUtil.msgBox("TASK_M1006");
                                gridList.setColValue(gridId, rowNum, "AQTADJU", "0");
                                return;
                            }else{
                                qtychk = boxqty * colValue;
                            }
                        }else if(uomkey == "FAC"){
                            if(facqty == "0"){
                                commonUtil.msgBox("TASK_M1006");
                                gridList.setColValue(gridId, rowNum, "AQTADJU", "0");
                                return;
                            }else{
                                qtychk = facqty * colValue;
                            }
                        }else if(uomkey == "PAL"){
                            if(palqty == "0"){
                                commonUtil.msgBox("TASK_M1006");
                                gridList.setColValue(gridId, rowNum, "AQTADJU", "0");
                                return;
                            }else{
                                qtychk = palqty * colValue;
                            }
                        }else if(uomkey == "EA"){
                            qtychk = colValue;
                        }else if(uomkey == "KG"){
                            qtychk = colValue;
                        }else if(uomkey == "G"){
                            qtychk = colValue;
                        }
                        
                        if(parseInt(conqty) < parseInt(qtychk)){
                            commonUtil.msgBox("INV_M1007");
                            //이동수량이 재고수량을 초과합니다. 다시 입력해 주세요.
                            gridList.setColValue(gridId, rowNum, "AQTADJU", "0");
                            return;
                        }
                    }
                }
			}
			
			if ( colName == "IUOMKEY" ){
                if( $.trim(colValue) != "" ){
                    
                    var uomkeychk = gridList.getColData(gridId,rowNum,"UOMKEYCHK");
                    var uomkeyArr = uomkeychk.split(",");
                    var uomkeySame = false;
                    for (var i=0; uomkeyArr.length > i; i++){
                        if($.trim(colValue) == uomkeyArr[i]){
                            uomkeySame = true;
                            break;
                        }
                    }
                    if (!uomkeySame) {
                        commonUtil.msgBox("TASK_M1010");
                        //존재하지 않는 단위입니다. 다시 입력해 주세요.
                        gridList.setColValue(gridId, rowNum, "IUOMKEY", "");
                        return;
                    }
                    
                    /* if (uomkeychk.indexOf(colValue) == -1) {
                        commonUtil.msgBox("TASK_M1010");
                        //존재하지 않는 단위입니다. 다시 입력해 주세요.
                        gridList.setColValue(gridId, rowNum, "IUOMKEY", "");
                        return;
                    } */
                    
                    if(gridList.getColData(gridId,rowNum,"SDUOMKY") == "EA"){
                        if($.trim(colValue) == "G" || $.trim(colValue) == "KG"){
                            commonUtil.msgBox("TASK_M1007");
                            //기본단위가 EA인 경우 KG, G로 변경 불가능합니다.
                            gridList.setColValue(gridId, rowNum, "IUOMKEY", "");
                            return;
                        }
                    }else if(gridList.getColData(gridId,rowNum,"SDUOMKY") == "G"){
                        if($.trim(colValue) == "G" || $.trim(colValue) == "KG"){
                        }else{
                            commonUtil.msgBox("TASK_M1008");
                            //기본단위가 G인 경우 KG, G로만 변경 가능합니다.
                            gridList.setColValue(gridId, rowNum, "IUOMKEY", "");
                            return;
                        }
                    }
                    
                    if(gridList.getColData(gridId,rowNum,"SUOMKEY") == "KG"){
                        if($.trim(colValue) != "KG"){
                            commonUtil.msgBox("TASK_M1009");
                            //기본단위가 KG인 경우 KG로만 입력 가능합니다.
                            gridList.setColValue(gridId, rowNum, "IUOMKEY", "");
                            return;
                        }
                    }
                    
                    var conqty = gridList.getColData(gridId,rowNum,"CONQTY");
                    var palqty = gridList.getColData(gridId,rowNum,"PALQTY");
                    var staqty = gridList.getColData(gridId,rowNum,"STAQTY");
                    var boxqty = gridList.getColData(gridId,rowNum,"BOXQTY");
                    var facqty = gridList.getColData(gridId,rowNum,"FACQTY");
                    var aqtadju = parseInt(gridList.getColData(gridId,rowNum,"AQTADJU"));
                    
                    if(colValue == "TA"){
                        if(staqty == "0"){
                            commonUtil.msgBox("TASK_M1006");
                            //환산할 단위의 수량이 0입니다. 다시 입력해 주세요.
                            gridList.setColValue(gridId, rowNum, "IUOMKEY", "");
                            return;
                        }else{
                            qtychk1 = staqty * aqtadju;
                        }
                    }else if(colValue == "BOX"){
                        if(boxqty == "0"){
                            commonUtil.msgBox("TASK_M1006");
                            gridList.setColValue(gridId, rowNum, "IUOMKEY", "");
                            return;
                        }else{
                            qtychk1 = boxqty * aqtadju;
                        }
                    }else if(colValue == "FAC"){
                        if(facqty == "0"){
                            commonUtil.msgBox("TASK_M1006");
                            gridList.setColValue(gridId, rowNum, "IUOMKEY", "");
                            return;
                        }else{
                            qtychk1 = facqty * aqtadju;
                        }
                    }else if(colValue == "PAL"){
                        if(palqty == "0"){
                            commonUtil.msgBox("TASK_M1006");
                            gridList.setColValue(gridId, rowNum, "IUOMKEY", "");
                            return;
                        }else{
                            qtychk1 = palqty * aqtadju;
                        }
                    }else if(colValue == "EA"){
                        qtychk1 = aqtadju;
                    }else if(colValue == "KG"){
                        qtychk1 = aqtadju;
                    }else if(colValue == "G"){
                        qtychk1 = aqtadju;
                    }
                    
                    if(parseInt(conqty) < parseInt(qtychk1)){
                        commonUtil.msgBox("INV_M1007");
                        //이동수량이 재고수량을 초과합니다. 다시 입력해 주세요.
                        gridList.setColValue(gridId, rowNum, "IUOMKEY", "");
                        return;
                    }
                }
            }
			
			if(colName == "LOTA10"){
				 if( $.trim(colValue) != "" ){
                    var date = new Date();
                    var year = date.getFullYear();
                    var month = date.getMonth()+1
                    var day = date.getDate();
                    if(month < 10){
                        month = "0"+month;
                    }
                    if(day < 10){
                        day = "0"+day;
                    }
                 
                    var today = year+""+month+""+day;
                    if(colValue <= today){
                        commonUtil.msgBox("INV_M9929");
                        gridList.setColValue(gridId, rowNum, "LOTA10", "");
                        //해지계획일은 오늘일자 이전일 수 없습니다.
                        return;
                    }
                }
			}
		}
	}

	//저장
	function saveData(){
		
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
			return;
		}
		
		var chkItemIdx = gridList.getSelectRowNumList("gridItemList");
		var chkItemLen = chkItemIdx.length;	
		
		if ( chkItemLen <= 0 ){
			commonUtil.msgBox("VALID_M0006");
			return ;
		}
		
		if( gridList.validationCheck("gridItemList", "select") ){
			
			var head = gridList.getRowData("gridHeadList",0);
			var list = gridList.getSelectData("gridItemList");
			
			var adjuty = head.get("ADJUTY");
			
			var befRelrsn = "";
			if(adjuty == "413"){
				for(var i=0; i< list.length; i++){
					var rowData = list[i];
					var relrsn = rowData.get("RELRSN");
					
					if($.trim(relrsn) == ""){
						commonUtil.msgBox("INV_M9930");
	                    return;
					}
					
					if(befRelrsn != "" && befRelrsn != relrsn) {
						commonUtil.msgBox("INV_M9933");
						return;
					}
					
					befRelrsn = relrsn;
				}
			}
			
			var param = new DataMap();
			param.put("head",head);
			param.put("list",list);
			
			netUtil.send({
				url : "/wms/inventory/json/saveSJ02.data",
				param : param,
				failFunction :"",
				successFunction : "saveDataCallBack"
			});
		}
	}
	
	function saveDataCallBack(json, returnParam){
		if ( json && json.data ){
			if ( parseFloat(json.data["CNT"]) > 0 ){
				commonUtil.msgBox("MASTER_M0564");
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				searchList();
			}
		}else{
			commonUtil.msgBox("IN_M9036");
		}
	}

	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, gridType,$inputObj){
		if(searchCode == "SHVCMCDV"){
			var param = new DataMap();
			param.put("CMCDKY","LOTA02")
			return param;
		}
	}

    //콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
    function comboEventDataBindeBefore(comboAtt){
        if(comboAtt == "WmsCommon,OWNERCOMBO"){
            var param = new DataMap();
            param.put("USERID", "<%=userid%>");
            param.put("LANGKY", "<%=langky%>");
            param.put("OWNRKY", "<%=ownrky%>");
            return param;
        }else if ( comboAtt == "WmsCommon,DOCTMCOMBO"){
            var param = new DataMap();
            param.put("PROGID", configData.MENU_ID);
            return param;
        }
    }

	//그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
	function gridExcelDownloadEventBefore(gridId){
		var param = inputList.setRangeParam("searchArea");
		return param;
	}
	
	//아이템그리드 체크시 이벤트
	function gridListEventRowCheck(gridId, rowNum, checkType){
        if(gridId == "gridItemList"){
            var aqtadju = gridList.getColData(gridId,rowNum,"AQTADJU");
            var conqty = gridList.getColData(gridId,rowNum,"CONQTY");
            var iuomkey = gridList.getColData(gridId,rowNum,"IUOMKEY");
            var duomky = gridList.getColData(gridId,rowNum,"DUOMKY");
            
            if(aqtadju == "0" && $.trim(iuomkey) == ""){
                gridList.setColValue(gridId, rowNum, "AQTADJU", conqty);
                gridList.setColValue(gridId, rowNum, "IUOMKEY", duomky);
            }
        }
    }
	
	//아이템그리드 전체 체크시 이벤트
    function gridListEventRowCheckAll(gridId, checkType){
    	if(gridId == "gridItemList"){
            var itemData = gridList.getGridData(gridId);
            for(var i=0; i< itemData.length; i++){
                var rowData = itemData[i];
                var aqtadju = rowData.get("AQTADJU");
                var conqty = rowData.get("CONQTY");
                var iuomkey = rowData.get("IUOMKEY");
                var duomky = rowData.get("DUOMKY");
                
                if(aqtadju == "0" && $.trim(iuomkey) == ""){
                    gridList.setColValue(gridId, i, "AQTADJU", conqty);
                    gridList.setColValue(gridId, i, "IUOMKEY", duomky);
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
		<button CB="Save SAVE BTN_SAVE"></button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop">
	<button type="button" class="closer">X</button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
		</p>
		<div id="searchArea">
			<div class="searchInBox" id="searchArea">
				<h2 class="tit" CL="STD_SELECTOPTIONS"></h2>
				<table class="table type1">
					<colgroup>
						<col width="100" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th CL="STD_WAREKY"></th>
							<td>
								<input type="text" name="WAREKY" UISave="false" value="<%=wareky%>" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_ADJUTY"></th>
							<td>
								<select Combo="WmsCommon,DOCTMCOMBO" name="ADJUTY" >
								</select>
							</td>
						</tr>
						<tr>
                            <th CL="STD_AREAKY"></th>
                            <td>
                                <input type="text" name="SK.AREAKY" UIInput="R,SHAREMA" UIformat="U" />
                            </td>
						</tr>
						<tr>
							<th CL="STD_LOCAKY"></th>
							<td>
								<input type="text" name="SK.LOCAKY" UIInput="R,SHLOCMA" UIformat="U" />
							</td>
						</tr>
						<tr>
							<th CL="STD_SKUKEY"></th>
							<td>
								<input type="text" name="SK.SKUKEY" UIInput="R,SHSKUMA" UIformat="U" />
							</td>
						</tr>
						<tr>
							<th CL="STD_DESC01"></th>
							<td>
								<input type="text" name="SM.DESC01" UIInput="R" />
							</td>
						</tr>
						<tr>
							<th CL="STD_LOTA04"></th>
							<td>
								<input type="text" name="SK.LOTA04" UIInput="R" />
							</td>
						</tr>
						<tr>
							<th CL="STD_LOTA09"></th>
							<td>
								<input type="text" name="SK.LOTA09" UIInput="R" UIFormat="C" />
							</td>
						</tr>
						<tr>
                            <th CL="STD_DUEDAT"></th>
                            <td>
                                <input type="text" name="SK.DUEDAT" UIInput="R" UIFormat="C" />
                            </td>
                        </tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
<!-- //searchPop -->

<!-- content -->
<div class="content">
	<div class="innerContainer">

		<!-- contentContainer -->
		<div class="contentContainer">

			<div class="bottomSect top">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1" CL="STD_GENERAL"><span></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40 STD_NUMBER"     GCol="rownum">1</td>
												<td GH="100 STD_WAREKY"    GCol="text,WAREKY"></td>
												<td GH="100 STD_WAREKYNM"  GCol="text,WARENM"></td>
												<td GH="100 STD_ADJCATNM"  GCol="text,ADJUTYNM"></td>
												<td GH="100 STD_DOCDAT"    GCol="input,DOCDAT" GF="C" validate="required" ></td>
												<!-- <td GH="100 STD_USRID1"    GCol="input,USRID1"  GF="C"></td> -->
												<td GH="200 STD_DOCTXT"    GCol="input,DOCTXT" GF="S 25"></td>
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
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="bottomSect bottom">
				<button type="button" class="button type2 fullSizer"><img src="/common/images/ico_full.png" alt="Full Size"></button>
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea">
						<li><a href="#tabs1-1" ><span CL="STD_ITEMLIST"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
										   <tr CGRow="true">
												<td GH="40 STD_NUMBER"    GCol="rownum">1</td>
												<td GH="40"               GCol="rowCheck"></td>
                                                <td GH="100 STD_SKUKEY"   GCol="text,SKUKEY"></td>
                                                <td GH="100 STD_DESC01"   GCol="text,DESC01"></td>
												<td GH="100 STD_AREAKY"   GCol="text,AREAKY"></td>
												<td GH="100 STD_LOCAKY"   GCol="text,LOCAKY"></td>
												<td GH="100 STD_CELLNM"   GCol="text,SHORTX"></td>
												<td GH="100 STD_QTSIWH"   GCol="text,QTSIWH"    GF="N 20,1"></td>
                                                <td GH="100 STD_UOMKEY"   GCol="text,SUOMKEY"></td>
                                                <td GH="100 STD_QTADJU"   GCol="input,AQTADJU"  GF="N 20" validate="required gt(0),INV_M1010"></td>
                                                <td GH="100 STD_UOMKEY"   GCol="input,IUOMKEY"  GF="U 3"  validate="required"></td>
												<td GH="100 STD_LOTA10"   GCol="input,LOTA10"   GF="C"/></td>
												<td GH="100 STD_RELRSN"   GCol="input,RELRSN"   GF="S 25" /></td>
												<td GH="100 STD_LOTA06"   GCol="text,LOTA06NM"/></td>				
												<td GH="100 STD_LOTA09"   GCol="text,LOTA09"    GF="D"/></td>
												<td GH="100 STD_DUEDAT"   GCol="text,DUEDAT"    GF="D"/></td>
                                                <td GH="100 STD_CONBOX"   GCol="text,CONBOX"    GF="N"></td>
                                                <td GH="100 STD_CONQTY"   GCol="text,CONQTY"    GF="N"></td>
                                                <!-- <td GH="100 STD_LOTA03"   GCol="text,LOTA03" /></td> -->
                                                <td GH="100 STD_LOTA04"   GCol="text,LOTA04" /></td>
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
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
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