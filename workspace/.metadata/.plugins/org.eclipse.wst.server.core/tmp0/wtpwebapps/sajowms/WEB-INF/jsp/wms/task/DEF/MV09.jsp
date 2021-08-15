<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	
	$(document).ready(function(){
		
		setTopSize(200);
		
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsTask",
			command : "MV09",
			itemGrid : "gridItemList",
			itemSearch : true,
            autoCopyRowType : false
	    });
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsTask",
			command : "MV09Sub",
            totalCols : ["QTCOMP","CONBOX","CONQTY"],
            autoCopyRowType : false
	    });
		
	});
	
	//공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Movlist"){
            movlist();
        }else if(btnName == "Movlabel"){
            movlabel();
        }
	}
	
	//조회
	function searchList(){
		
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}

    
    // 공통 itemGrid 조회 및 / 더블 클릭 Event
    function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
        if(gridId == "gridHeadList"){
            searchSubList(rowNum);
        }
    }

    function searchSubList(rowNum){
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
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength > 0 ){
			
		}else if( gridId == "gridHeadList" && dataLength <= 0){
			gridList.resetGrid("gridItemList");
			searchOpen(true);
		}
	}
	
	// 그리드 더블 클릭 이벤트(하단 그리드 조회)
	function gridListEventRowDblclick(gridId, rowNum){
	}
	
	// 그리드 클릭 포커스 이벤트(클릭), 수정 데이터가 있을 경우 컨펌메세지 후 이동 또는 복귀
	function gridListEventRowFocus(gridId, rowNum){
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
	}
	
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, gridType){
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
        } else if (comboAtt == "WmsCommon,DOCTMCOMBO") {
            var param = new DataMap();
            //param.put("DOCUTY", "320");
            param.put("PROGID" , configData.MENU_ID);
            return param;
        }
    }
    
    function movlist(){
        if ( validprint("list") == false ){
            return ;
        }
    }
    
    function movlabel(){
        if ( validprint("label") == false ){
            return ;
        }
    }
    
    function validprint(type){
    	
        var head = gridList.getSelectData("gridHeadList");
        
        if ( head <= 0 ){
            commonUtil.msgBox("VALID_M0006");
            return ;
        }
        var param = new DataMap();
        param.put("head", head);
        param.put("PROGID" , configData.MENU_ID);
        param.put("type",type);
        
        if ( type == "list" ){
            param.put("EZFILE", "/ezgen/hwmsEzgen/Forms/stock_move_order_list.ezg");
            param.put("width", 700);
            param.put("heigth", 700);
        }else{
            param.put("EZFILE", "/ezgen/hwmsEzgen/Forms/stock_move_order_label.ezg");
            param.put("width", 300);
            param.put("heigth", 340);
        }
        
        var json = netUtil.sendData({
            url : "/wms/task/json/printMV01UpdateCnt.data",
            param : param
        });
        
        if ( json && json.data ){
            if(json.data["PRTSEQ"].length > 0){
                var url = $.trim(json.data["EZFILE"]);
                var rowNum = gridList.getFocusRowNum("gridHeadList");
                var where = "AND PT.PRTSEQ =" + $.trim(json.data["PRTSEQ"]);
                //var langKy = "KR";
                var width =  Number( param.get("width") );
                var heigth = Number( param.get("heigth") );
                var langKy = "KR";
                var map = new DataMap();
                
                WriteEZgenElement(url , where , "" , langKy, map , width , heigth );
            }
        }
    }
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Movlist PRINT BTN_MOVLIST"></button>
        <button CB="Movlabel PRINT BTN_MOVLABEL"></button>
	</div>
	<div class="util2">
		<button class="button type2" id="showPop" type="button"><img src="/common/images/ico_btn4.png" alt="List" /></button>
	</div>
</div>

<!-- searchPop -->
<div class="searchPop">
	<button type="button" class="closer"></button>
	<div class="searchInnerContainer">
		<p class="util">
			<button CB="Search SEARCH BTN_DISPLAY"></button>
			<button CB="GetVariant GETVARIANT BTN_GETVARIANT"></button>
			<button CB="SaveVariant SAVEVARIANT BTN_SAVEVARIANT"></button>
		</p>
		<div id="searchArea">
			<div class="searchInBox">
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
								<input type="text" name="WAREKY"  UISave="false" readonly="readonly" value="<%=wareky%>" style="width:110px"  />
							</td>
						</tr>
						<tr>
							<th CL="STD_TASOTY"></th>
							<td>
								<select Combo="WmsCommon,DOCTMCOMBO" name="TASOTY" style="width:160px">
								    <option value="ALL">전체</option>    
								</select>
							</td>
						</tr>
						<tr>
                            <th CL="STD_TASKKY"></th>
                            <td>
                                <input type="text" name="TI.TASKKY" UIInput="R" />
                            </td>
                        </tr>
						<tr>
                            <th CL="STD_AREAKY"></th>
                            <td>
                                <input type="text" name="LM.AREAKY" UIInput="R,SHAREMA" UIformat="U" />
                            </td>
                        </tr>
                        <!-- <tr>
                            <th CL="STD_ZONEKY"></th>
                            <td>
                                <input type="text" name="LM.ZONEKY" UIInput="R,SHZONMA" UIformat="U" />
                            </td>
                        </tr> -->
                        <tr>
                            <th CL="STD_LOCASR"></th>
                            <td>
                                <input type="text" name="TI.LOCASR" UIInput="R,SHLOCMA" UIformat="U" />
                            </td>
                        </tr>
						<tr>
							<th CL="STD_SKUKEY"></th>
							<td>
								<input type="text" name="TI.SKUKEY" UIInput="R,SHSKUMA" UIformat="U"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_DESC01"></th>
							<td>
								<input type="text" name="SM.DESC01" UIInput="R" />
							</td>
						</tr>
						<tr>
                            <th CL="STD_LOTA09"></th>
                            <td>
                                <input type="text" name="TI.LOTA09" UIInput="R" UIformat="C" UISave="false"/>
                            </td>
                        </tr>
						<tr>
                            <th CL="STD_DUEDAT"></th>
                            <td>
                                <input type="text" name="TI.DUEDAT" UIInput="R" UIformat="C" UISave="false"/>
                            </td>
                        </tr>
						<tr>
							<th CL="STD_APLDAT"></th>
							<td>
								<input type="text" name="TI.TKTL03" UIInput="R" UIformat="C N" UISave="false" validate="required(STD_APLDAT)"/>
							</td>
						</tr>
						<tr>
							<th CL="STD_DATCOMP"></th>
							<td>
								<input type="text" name="TI.LMODAT" UIInput="R" UIformat="C" UISave="false"/>
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
					<button type="button" class="button type2 fullSizer">
						<img src="/common/images/ico_full.png" alt="Full Size">
					</button>
					<div class="tabs">
						<ul class="tab type2">
							<li><a href="#tabs1-1"><span CL="STD_GENERAL"></span></a></li>
						</ul>
						<div id="tabs1-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableBody">
										<table>
											<tbody id="gridHeadList">
												<tr CGRow="true">
													<td GH="40 STD_NUMBER"     GCol="rownum">1</td>
													<td GH="40"                GCol="rowCheck"></td>
													<td GH="100 STD_TASKKY"    GCol="text,TASKKY"></td>
													<td GH="100 STD_WAREKYNM"  GCol="text,WARENM"></td>
													<td GH="100 STD_TASOTY"    GCol="text,TASOTY"></td>
													<td GH="100 STD_TASKTYNM"  GCol="text,DOCTNM"></td>
													<td GH="100 STD_MOVEST"    GCol="text,STATDONM"></td>
													<td GH="100 STD_DOCDAT"    GCol="text,DOCDAT" GF="D"></td>
													<td GH="80 STD_CONBOX"    GCol="text,CONBOX" GF="N"></td>
													<td GH="200 STD_DOCTXT"    GCol="text,DOCTXT"></td>
													<td GH="100 STD_CREDAT"    GCol="text,CREDAT" GF="D"></td>
													<td GH="100 STD_CRETIM"    GCol="text,CRETIM" GF="T"></td>
													<td GH="100 STD_CREUSR"    GCol="text,CREUSR"></td>
													<td GH="100 STD_CUSRNM"    GCol="text,CUSRNM"></td>
													
													<!-- <td GH="100 STD_WAREKY"    GCol="text,WAREKY"></td>
													<td GH="100 STD_OWNRKY"    GCol="text,OWNRKY"></td>
													<td GH="100 STD_OWNERNAME" GCol="text,OWNERNM"></td>
													<td GH="100 STD_STATIT"    GCol="text,STATDO"></td>
													<td GH="100 STD_QTTAOR"    GCol="text,QTTAOR" GF="N"></td>
													<td GH="100 STD_DATCOMP"   GCol="text,LMODAT" GF="D" /></td>
													<td GH="100 STD_TIMCOMP"   GCol="text,LMOTIM" GF="T"/></td>
													<td GH="100 STD_NAMCOMP"   GCol="text,LMOUSR" /></td>
													<td GH="100 STD_NMCOMP"    GCol="text,LUSRNM" /></td> -->
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
					<button type="button" class="button type2 fullSizer">
						<img src="/common/images/ico_full.png" alt="Full Size">
					</button>
					<div class="tabs" id="bottomTabs">
						<ul class="tab type2" id="commonMiddleArea">
							<li><a href="#tabs2-1" ><span CL="STD_ITEMLIST"></span></a></li>							
						</ul>

						<div id="tabs2-1">
							<div class="section type1">
								<div class="table type2">
									<div class="tableBody">
										<table>
											<tbody id='gridItemList'>
												<tr CGRow="true">
													<td GH="40 STD_NUMBER"    GCol="rownum"></td>
													<td GH="100 STD_SKUKEY"   GCol="text,SKUKEY"></td>
													<td GH="100 STD_DESC01"   GCol="text,DESC01"></td>
													<td GH="100 STD_LOCAKY"   GCol="text,LOCASR"></td>
													<td GH="100 STD_MOVEQT"   GCol="text,QTCOMP"   GF="N 20"></td>
													<td GH="100 STD_UOMKEY"   GCol="text,TKTL06"></td>
													<td GH="100 STD_AREAKY"   GCol="text,AREAKY"></td>
													<td GH="100 STD_LOCATG"   GCol="text,LOCATG"></td>
													<td GH="100 STD_CONBOX"   GCol="text,CONBOX"   GF="N"></td>
													<td GH="100 STD_CONQTY"    GCol="text,CONQTY"            GF="N"></td>
													<td GH="100 STD_LOTA09"   GCol="text,LOTA09"   GF="D"></td>
													<td GH="100 STD_DUEDAT"   GCol="text,DUEDAT"   GF="D"></td>
													
													<!-- <td GH="100 STD_DESC02"   GCol="text,DESC02"></td>
													<td GH="100 STD_DESC03"   GCol="text,DESC03"></td>
                                                    <td GH="100 STD_EANCOD"   GCol="text,EANCOD"></td>
													<td GH="100 STD_STATIT"   GCol="text,STATIT"></td>
													<td GH="100 STD_STATITNM" GCol="text,STATITNM"></td>
													<td GH="100 STD_ZONEKY"   GCol="text,ZONEKY"></td>
													<td GH="100 STD_QTTAOR"   GCol="text,QTTAOR"   GF="N 20"></td>
													<td GH="100 STD_PTQTY"    GCol="text,PTQTY"    GF="N"/></td>
													<td GH="100 STD_BXQTY"    GCol="text,BXQTY"    GF="N"/></td>
													<td GH="100 STD_EAQTY"    GCol="text,EAQTY"    GF="N"/></td>
													<td GH="100 STD_PALDQTY"  GCol="text,PLQTPUOM" GF="N"></td>
													<td GH="100 STD_BOXDQTY"  GCol="text,BXQTPUOM" GF="N"></td>
													<td GH="100 STD_DUOMKY"   GCol="text,SUOMKY"></td>
                                                    <td GH="100 STD_LOTA05"   GCol="text,LOTA05"></td>
                                                    <td GH="100 STD_STDLNR"   GCol="text,LOTA10"></td>
                                                    <td GH="100 STD_LOTA06"   GCol="text,LOTA06NM"></td>
                                                    <td GH="100 STD_ALOTA06"  GCol="text,PTLT06NM"></td>
													<td GH="100 STD_LOTA02"   GCol="text,LOTA02"></td>
													<td GH="100 STD_LOTA02NM" GCol="text,LOTA02NM"></td>
													<td GH="100 STD_ASKL01"   GCol="text,ASKL01"></td>
													<td GH="100 STD_ASKL01NM" GCol="text,ASKL01NM"></td>
													<td GH="100 STD_ASKL02"   GCol="text,ASKL02"></td>
													<td GH="100 STD_ASKL02NM" GCol="text,ASKL02NM"></td>
													<td GH="100 STD_ASKL03"   GCol="text,ASKL03"></td>
													<td GH="100 STD_ASKL03NM" GCol="text,ASKL03NM"></td>
													<td GH="100 STD_TASKKY"   GCol="text,TASKKY"></td>
													<td GH="100 STD_TASKIT"   GCol="text,TASKIT"></td> -->
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