<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<style>
.colInfo{width: 100%;height: 35px;}
.colInfo ul{width: 420px;height: 100%;float: right;font-weight: bold;color: #6490FF;}
.colInfo ul li{padding-bottom: 7px;}
</style>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript">
midAreaHeightSet = "200px";
var tabindex = 0;
var row = -1;
var id = "gridItemListRack";
var saveyn = false;
var saveKeyval = "";
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsAdmin",
			command : "MK01",
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemListRack",
	    	name : "gridItemListRack",
			editable : true,
			module : "WmsAdmin",
			command : "MK01SUB_RACK",
            autoCopyRowType : false
	    });
		
		gridList.setGrid({
	    	id : "gridItemListRange",
	    	name : "gridItemListRange",
			editable : true,
			module : "WmsAdmin",
			command : "MK01SUB_RANGE",
            autoCopyRowType : false
	    });
		
		$("#bottomTabs ul.tab li").click(function(){
			tabindex = $('#bottomTabs').tabs("option","active");
			
			if(tabindex == 0){
				id = "gridItemListRack";
			}else if(tabindex == 1){
				id = "gridItemListRange";
			}
			if(row >= 0){
				searchSublist();
			}
		});
		
		inputList.setMultiComboSelectAll($("#AREAKY"), true);
		
	});
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		//commonUtil.debugMsg("commonBtnClick : ", arguments);
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "ReflectRackZO"){
			reflectRackZo();
		}else if(btnName == "ReflectRackTP"){
			reflectRackTp();
		}
	}
	
	//헤더 조회 
	function searchList(){
		//var param = dataBind.paramData("searchArea");
		var param = inputList.setRangeParam("searchArea");
		
        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }
		
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){
			if(!saveyn){
				row = 0 ;
			}else{
				row = findSavegridRow("gridHeadList","ZONEKY",saveKeyval);
				gridList.setColFocus("gridHeadList", row, "rownum");
				
				saveKeyval = "";
				saveyn = true;
			}
			searchSublist(row);
		}else if(gridId == "gridHeadList" && dataLength <= 0){
			gridList.resetGrid("gridItemListRange");
			gridList.resetGrid("gridItemListRacl");
			row = -1 ;
            searchOpen(true);
		}
	}
	
	function findSavegridRow(gridId,colName,colVal){
		var list = gridList.getGridData(gridId);
		var rownum = 0;
		for(var i = 0 ; i < list.length ; i++){
			var chkval = list[i].get(colName);
			if(chkval == colVal){
				rownum = i;
				break;
			}
		}
		return rownum;
	}
	
	function searchSublist(){
		
		var param = getItemSearchParam(row);
		
		gridList.gridList({
	    	id : id,
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
    
    function saveData(){
    	var gbn = "";
    	
    	if(id.replace("gridItemList", "" ) == "Rack"){
    		gbn = "select";
    	}else{
    		gbn = "modify";
    	}
    	
    	if( gridList.validationCheck( id , gbn) ){
    		
			var head = gridList.getRowData("gridHeadList", row);
			var list ;
			
			if(id.replace("gridItemList", "" ) == "Range"){
				list = gridList.getGridData(id);
				
			}else if(id.replace("gridItemList", "" ) == "Rack"){
				list = gridList.getSelectData(id);
				var chk=0;
				for(var i=0;i<list.length;i++){
					var workzo = list[i].get("WORKZO").replace(/\s/g,"").replace(/\t/g,"");
					var worktp = list[i].get("WORKTP").replace(/\s/g,"").replace(/\t/g,"");
					
					if(workzo.length > 0 && worktp.length == 0){
						chk++;
					}
					if(chk > 0){
						alert("작업구역 입력시 최적화 표시는 필수 입니다.");
						return false;
					}
				}
			}
			
			if( list.length == 0 ){
				commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
				return;
			}
			
			if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
	            return;
	        }
			
			var param = new DataMap();
				param.put("list", list);
				param.put("head", head);
				param.put("gbn",id.replace("gridItemList", ""));
			
			saveKeyval = head.get("ZONEKY");
			
			netUtil.send({
				url : "/wms/admin/json/saveMK01.data",
				param : param ,
				successFunction : "succsessSaveCallBack"
			});
			
		}
    }
    
    function succsessSaveCallBack(json,status){
    	if( json && json.data ){
			commonUtil.msgBox("VALID_M0001");
			saveyn = true;
			searchList();
		}
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

    
    // 그리드 더블 클릭 이벤트(하단 그리드 조회)
    function gridListEventRowDblclick(gridId, rowNum, colName){
        if(gridId == "gridHeadList"){
        	gridList.resetGrid("gridItemListRack");
        	gridList.resetGrid("gridItemListRange");
        	row = rowNum;
        	searchSublist(rowNum);	
        }
    }
    
	// 그리드 클릭 포커스 이벤트(클릭), 수정 데이터가 있을 경우 컨펌메세지 후 이동 또는 복귀
	function gridListEventRowFocus(gridId, rowNum){
		
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemListRange"){
			if(colName == "MIN_RACK"){
				if(colValue.length > 0){
					var numchk;
					if(!onlyNumber(colValue)){
						alert("잘못된 값을 입력 하였습니다.");
						gridList.setColValue(gridId, rowNum, colName, " ");
						return false;
					}else{
						numchk = onlyNumber(colValue);
					}
					
					var maxrack = gridList.getColData(gridId, rowNum, "MAX_RACK");  

					var val = "";

					if(numchk < 10){
						val = "0" + numchk;
					}else{
						val = numchk;
					}
					var head = gridList.getRowData("gridHeadList", row);
					
					var param = new DataMap();
						param.put("WAREKY",head.get("WAREKY"));
						param.put("AREAKY",head.get("AREAKY"));
						param.put("ZONEKY",head.get("ZONEKY"));
						param.put("RACKWH",val);
						
					var json = netUtil.sendData({
				        module : "WmsAdmin",
				        command : "RACK_CHK",
				        sendType : "map",
				        param : param
				    });
					if(parseInt(json.data["CNT"]) == 0 ){
						alert("존재하지 않는 RACK 번호 입니다.");
						gridList.setColValue(gridId, rowNum, colName, " ");
						return false;
					}
					
					if(maxrack.length > 0 && typeof onlyNumber(maxrack) == "number"){
						if(onlyNumber(maxrack) < numchk){
							alert("범위 설정이 잘못 되었습니다.");
							gridList.setColValue(gridId, rowNum, colName, " ");
							return false;
						}
					}
					
					gridList.setColValue(gridId, rowNum, colName, val);
					
					return false;
				} 
			}else if(colName == "MAX_RACK"){
				var numchk;
				if(!onlyNumber(colValue)){
					alert("잘못된 값을 입력 하였습니다.");
					gridList.setColValue(gridId, rowNum, colName, " ");
					return false;
				}else{
					numchk = onlyNumber(colValue);
				}
				
				var minrack = gridList.getColData(gridId, rowNum, "MIN_RACK");  

				var val = "";

				if(numchk < 10){
					val = "0" + numchk;
				}else{
					val = numchk;
				}
				
				var head = gridList.getRowData("gridHeadList", row);
				
				var param = new DataMap();
					param.put("WAREKY",head.get("WAREKY"));
					param.put("AREAKY",head.get("AREAKY"));
					param.put("ZONEKY",head.get("ZONEKY"));
					param.put("RACKWH",val);
					
				var json = netUtil.sendData({
			        module : "WmsAdmin",
			        command : "RACK_CHK",
			        sendType : "map",
			        param : param
			    });
				if(parseInt(json.data["CNT"]) == 0 ){
					alert("존재하지 않는 RACK 번호 입니다.");
					gridList.setColValue(gridId, rowNum, colName, " ");
					return false;
				}
				
				if(minrack.length > 0 && typeof onlyNumber(minrack) == "number"){
					if(onlyNumber(minrack) > numchk){
						alert("범위 설정이 잘못 되었습니다.");
						gridList.setColValue(gridId, rowNum, colName, " ");
						return false;
					}
				}
				
				gridList.setColValue(gridId, rowNum, colName, val);
				
				return false;
			}
			
		}else if(gridId == "gridItemListRack"){
			if(colName == "WORKZO"){
				if(colValue.replace(/\s/g,"").replace(/\t/g,"").length == 0){
					gridList.setColValue(gridId, rowNum, "WORKTP", " ");
				}
			}else if(colName == "WORKTP"){
				if(colValue.replace(/\s/g,"").replace(/\t/g,"").length == 0){
					gridList.setColValue(gridId, rowNum, "WORKZO", " ");
				}
			}
		}
	    
	}
	
	// 그리드 Row 추가 전 이벤트
    function gridListEventRowAddBefore(gridId, rowNum){
    	if(gridId == "gridItemListRange"){
    		if(row >= 0){
    			var head = gridList.getRowData("gridHeadList", row);
        		
        		var newData = new DataMap();
    	    		newData.put("ZONEKY", head.get("ZONEKY"));
    	    		newData.put("ZONENM", head.get("ZONENM"));
        		
        		return newData;	
    		}else{
    			alert("조회 먼저 하세요");
    			return false;	
    		}
			
			
    	}
    }
    
     // 그리드 Row 추가 후 이벤트
    function gridListEventRowAddAfter(gridId, rowNum){
    } 
    
    // 그리드 컬럼 format을 동적으로 변경 가능한 이벤트 
    function gridListEventColFormat(gridId, rowNum, colName){

    }
	
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, gridType){
		if(searchCode == "SHAREMA"){
			return dataBind.paramData("searchArea");
		}
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
			}else if(name == "WORKTP"){
				param.put("CODE", "WORKTP");
			}
			return param;
		}else if( comboAtt == "WmsAdmin,AREACOMBO" ){
			//검색조건 AREA 콤보
			param.put("WAREKY","<%=wareky%>");
			param.put("USARG1", "STOR");
			
			return param;
		}
	}
	
	
	function onlyNumber(str) {
		var res = 0;
	    var pattern_special = /[~!@\#$%<>^&*\()\-=+_\’]/gi,
	        pattern_kor = /[ㄱ-ㅎ가-힣]/g,
	        pattern_eng = /[A-za-z]/g,
	        pattern_s = /\s/g,
	        pattern_t = /\t/g;
	    
	    if (pattern_special.test(str) || pattern_kor.test(str) || pattern_eng.test(str) || pattern_s.test(str) || pattern_t.test(str)) {
	    	str = str.replace(pattern_special, "").replace(pattern_kor, "").replace(pattern_eng, "").replace(pattern_s, "").replace(pattern_t, "");	
	    }
		
	    if(str.length > 0 ){
	    	return parseInt(str);
	    }else {
	        return false;
	    }
	}
	
	function workzoChange(obj){
		if(!onlyNumber(obj.value)){
			alert("잘못된 값입니다.");
			obj.value = "";
		}else{
			obj.value = onlyNumber(obj.value);
		}
	}
	
	function reflectRackZo(){
		var rownumlist = gridList.getSelectRowNumList("gridItemListRack");
		
		if(rownumlist.length == 0){
			alert("선택된 데이터가 없습니다.");
			return false;
		}
		
		
		for(var i=0;i<rownumlist.length;i++){
			gridList.setColValue("gridItemListRack", rownumlist[i], "WORKZO", $('#WORKZO_RANK').val());
			if($('#WORKZO_RANK').val() == ""){
				gridList.setColValue("gridItemListRack", rownumlist[i], "WORKTP", " ");
			}
		}
	}
	
	function reflectRackTp(){
		var rownumlist = gridList.getSelectRowNumList("gridItemListRack");
		
		if(rownumlist.length == 0){
			alert("선택된 데이터가 없습니다.");
			return false;
		}
		
		for(var i=0;i<rownumlist.length;i++){
			gridList.setColValue("gridItemListRack", rownumlist[i], "WORKTP", $('#WORKTPALL').val());
			if($('#WORKTPALL').val() == " "){
				gridList.setColValue("gridItemListRack", rownumlist[i], "WORKZO", "");
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
											
											<th CL="STD_AREAKY">area</th>
											<td>
												<select id="AREAKY" name="AM.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" validate="required(STD_AREAKY)" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											
											<th CL="STD_ZONEKY"></th>
											<td>
												<input type="text" name="ZM.ZONEKY" UIInput="SR,SHZONMA" />
											</td>
											
										</tr>
										<tr>
<!-- 											<th CL="STD_WORKZO"></th> -->
<!-- 											<td> -->
<!-- 												<input type="text" name="WZ.WORKZO" UiRange="2" UIInput="SR" /> -->
<!-- 											</td> -->
<!-- 											<td style="display:none;"> -->
<!-- 		                                      <input type="text" name="XXY" UIInput="SR"  /> RANEGE 를 만든기 위한 템프 -->
<!-- 		                                      <input type="text" name="XXX" UIInput="SR" UiRange="2" /> RANEGE2를 만든기 위한 템프 -->
<!-- 		                                 	</td> -->
											<th CL="STD_WORKZOAPT"></th>
					                        <td>
					                            <select id="WORKZOAPT" name="WORKZOAPT" style="width:160px">
					                            	<option value="1" select>전체</option>
					                            	<option value="2">미지정</option>
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
							<div class="colInfo">
								<ul>
									<li>* 동일 존에서 동일하게 설정된 작업구역별로 박스 체적시뮬레이션이 계산</li>
								</ul>
							</div>
							<div class="table type2" style="top: 27px;">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_WAREKYNM"    GCol="text,WAREKYNM"  ></td>
<!-- 												<td GH="100 STD_AREAKY"    GCol="text,AREAKY"  ></td> -->
												<td GH="100 STD_AREANM"    GCol="text,AREANM"  ></td>
												<td GH="100 STD_ZONEKY"    GCol="text,ZONEKY"  ></td>
												<td GH="100 STD_ZONENM"    GCol="text,ZONENM"  ></td>
<!-- 												<td GH="100 STD_LOCATY"    GCol="text,LOCATY"  ></td> -->
												<td GH="100 STD_LOCATYNM"    GCol="text,LOCATYNM"  ></td>
												<td GH="100 STD_WORKQT"    GCol="text,WORKZOCNT" GF="N" ></td>
												<td GH="100 STD_WORNQT"    GCol="text,WORKZOLESSCNT" GF="N" ></td>
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
									<!-- <button type="button" GBtn="total"></button> -->
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
				<div class="tabs" id="bottomTabs">
					<ul class="tab type2" id="commonMiddleArea2">
                        <li><a href="#tabs1-1"><span CL='STD_RACK'></span></a></li>
                        <li><a href="#tabs1-2"><span CL='STD_RANGE'></span></a></li>
                    </ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="reflect" id="reflect">
								<span CL="STD_WORKZO"></span> : 
								<input type="text" id="WORKZO_RANK" name="WORKZO" onchange="workzoChange(this)" maxlength="2" value="">
								<button CB="ReflectRackZO REFLECT BTN_REFLECT"></button>
								
								
								<span CL="STD_WORKTP" style="margin-left: 25px;"></span> : 
								<select Combo="Common,COMCOMBO" id="WORKTPALL" name="WORKTP" ComboCodeView=false style="width: 100px;">
									<option value=" ">선택</option>
								</select>
								<button CB="ReflectRackTP REFLECT BTN_REFLECT"></button>
							</div>
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridItemListRack">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="100 STD_ZONEKY"    GCol="text,ZONEKY"  ></td>
												<td GH="100 STD_ZONENM"    GCol="text,ZONENM"  ></td>
												<td GH="100 STD_RACKWH"    GCol="text,RACKWH"  ></td>
												<td GH="100 STD_WORKZO"    GCol="input,WORKZO"  ></td>
												<td GH="100 STD_WORKTP"    GCol="select,WORKTP"  >
													<select Combo="Common,COMCOMBO" id="WORKTP" name="WORKTP" ComboCodeView=false>
														<option value=" ">선택</option>
													</select>
												</td>
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
									<!-- <button type="button" GBtn="total"></button> -->
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
					
					<div id="tabs1-2">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridItemListRange">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
<!-- 												<td GH="40"                GCol="rowCheck"></td> -->
												<td GH="100 STD_ZONEKY"    GCol="text,ZONEKY"  ></td>
												<td GH="100 STD_ZONENM"    GCol="text,ZONENM"  ></td>
												<td GH="100 STD_MIN_RACK"    GCol="input,MIN_RACK" validate="required" GF="S 2"></td>
												<td GH="100 STD_MAX_RACK"    GCol="input,MAX_RACK" validate="required" GF="S 2" ></td>
												<td GH="100 STD_WORKZO"    GCol="input,WORKZO" validate="required"  ></td>
												<td GH="100 STD_WORKTP"    GCol="select,WORKTP" validate="required"  >
													<select Combo="Common,COMCOMBO" id="WORKTP" name="WORKTP" ComboCodeView=false>
														<option value=" ">선택</option>
													</select>
												</td>
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
									<!-- <button type="button" GBtn="total"></button> -->
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