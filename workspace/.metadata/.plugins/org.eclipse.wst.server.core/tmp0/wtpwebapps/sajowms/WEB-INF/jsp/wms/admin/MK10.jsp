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
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsAdmin",
			command : "MK10",
            autoCopyRowType : false
	    });
		inputList.setMultiComboSelectAll($("#AREAKY"), true);
		
	});
	
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
		var param = inputList.setRangeParam("searchArea");
        
        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }
		
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
			}else if(name == "LOCATY"){
				param.put("CODE", "LOCATY");
				param.put("USARG2", "PK");
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
			if(onlyNumber(obj.value) < 10){
				obj.value = "0" + onlyNumber(obj.value);	
			}else{
				obj.value = onlyNumber(obj.value);
			}
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
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											
											<th CL="STD_CHANGEDATE"></th>
											<td>
												<input type="text" name="WT.CREDAT" UISave="false"   UIInput="R" UIFormat="C N"  validate="required(STD_CHANGEDATE)"  MaxDiff="M1" />
											</td>
											
											<th CL="STD_LOCATYNM"></th>
											<td>
												<select  name="LOCATY" id="LOCATY" Combo="Common,COMCOMBO" validate="required(STD_AREAKY)" UISave="false" ComboCodeView=false style="width:160px">
													<option value="ALL">전체</option>
												</select>
											</td>
											
										</tr>
										<tr>
											
											<th CL="STD_AREAKY">area</th>
											<td>
												<select id="AREAKY" name="WT.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" validate="required(STD_AREAKY)" UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											
											<th CL="STD_ZONEKY"></th>
											<td>
												<input type="text" name="WT.ZONEKY" UIInput="SR,SHZONMA" />
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
												<td GH="100 STD_WKHTNO"    GCol="text,WKHTNO" GF="N" ></td>
												<td GH="100 STD_WAREKYNM"    GCol="text,WAREKYNM"  ></td>
												<td GH="100 STD_AREAKY"    GCol="text,AREAKYNM"  ></td>
												<td GH="100 STD_ZONEKY"    GCol="text,ZONEKYNM"  ></td>
												<td GH="100 STD_LOCATYNM"    GCol="text,LOCATYNM"  ></td>
												<td GH="100 STD_RACKWH"    GCol="text,RACKNO"  ></td>
												<td GH="100 STD_WORKZO"    GCol="text,WORKZO"  ></td>
												<td GH="140 STD_WORKTPMK10"    GCol="text,WORKTP"  ></td>
												<td GH="100 STD_BEFRZO"    GCol="text,BEFRZO"  ></td>
												<td GH="160 STD_BEFRTP"    GCol="text,BEFRTP"  ></td>
												<td GH="100 STD_WORDAT"    GCol="text,CREDAT" GF="D" ></td>
												<td GH="100 STD_WORTIM"    GCol="text,CRETIM" GF="T" ></td>
												<td GH="100 STD_WORUSR"    GCol="text,CREUSR"  ></td>
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
		</div>
		<!-- //contentContainer -->
  </div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>