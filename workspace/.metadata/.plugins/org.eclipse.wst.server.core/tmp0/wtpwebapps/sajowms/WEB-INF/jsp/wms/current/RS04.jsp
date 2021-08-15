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
var boxtyp;
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			sortType : false,
			colorType : true,
			module : "WmsOutbound",
			command : "RS04",
            autoCopyRowType : false
	    });
    	inputList.setMultiComboSelectAll($("#AREAKY"), true);
    	
    });
    
    
    // 공통 버튼 클릭 이벤트
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }else if(btnName == "Print"){
        	print();
        }
    }
    
  //헤더 조회 
	function searchList(){
		
		gridList.resetGrid("gridHeadList");
		
		var param = inputList.setRangeParam("searchArea");
		
		if(!commonUtil.datemath($('#FROMRQSHPD'),$('#TORQSHPD'),90 )){
			return false;
		}
		
        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }
		
	}
    
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		gridList.setColGrouping("gridHeadList", "ZONENM");
		gridList.setColGrouping("gridHeadList", "AREANM");
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
    
    function gridListColBgColorChange(gridId, rowNum, colName, colValue){
    	if(colName == 'AREANM' || colName == 'ZONENM'){
    		return configData.GRID_COLOR_BG_WHITE_CLASS;
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
			}else if(name == "RQSHPD"){
				param.put("CODE", "MONTH");
			}
			
			return param;
		}else if ( comboAtt == "WmsCommon,DOCTMCOMBO"){
            var param = new DataMap();
            param.put("PROGID", configData.MENU_ID);
            return param;
        }else if( comboAtt == "WmsAdmin,AREACOMBO" ){
			//검색조건 AREA 콤보
			param.put("WAREKY","<%=wareky%>");
			param.put("USARG1", "STOR");
			
			return param;
		}
	}
  
	function print(){
 		
		if(validate.check("searchArea")){
		
			var param = dataBind.paramData("searchArea");
			
			param.put("PROGID" , configData.MENU_ID);
			param.put("PRTCNT" , 1);
			
			if(validate.check("searchArea")){
				var json = netUtil.sendData({
					url : "/wms/outbound/json/printRS04.data",
					param : param
				});
				
				if ( json && json.data ){
						var url = "<%=systype%>" + "/rs04_list.ezg";
						var where = "PL.PRTSEQ =" + json.data;
						//var langKy = "KR";
						var width =  850;
						var heigth = 630;
						var langKy = "KR";
						var map = new DataMap();
						WriteEZgenElement(url , where , "" , langKy, map , width , heigth );
						
						
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
		<button CB="Print PRINT BTN_PRINT"></button>
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
									
										
										<th CL="STD_RQSHPD"></th>
										<td>
											<input type="text" id="FROMRQSHPD" name="FROMRQSHPD" UISave="false" UIFormat="C -7"  validate="required(STD_RQSHPD)"  />~
											<input type="text" id="TORQSHPD" name="TORQSHPD" UISave="false" UIFormat="C N"  validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_AREAKY">area</th>
										<td>
											<select id="AREAKY" name="AW.AREAKY" Combo="WmsAdmin,AREACOMBO" comboType="MS" validate="required(STD_AREAKY)"  UISave="false" ComboCodeView=false style="width:160px">
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
												<td GH="100 STD_AREANM"    GCol="text,AREANM,left"  ></td>
												<td GH="100 STD_ZONENM"    GCol="text,ZONENM,left"  ></td>
												<td GH="100 STD_WORKZO"    GCol="text,WORKZO"  ></td>
												<td GH="100 STD_QTSHPO"    GCol="text,QTSHPO" GF="N" ></td>
												<td GH="100 STD_QTSHPD"    GCol="text,QTSHPD" GF="N" ></td>
												<td GH="100 STD_WRKCNT"    GCol="text,WRKCNT" GF="N" ></td>
												<td GH="150 STD_QTSHPO100"    GCol="text,QTSHPO100" GF="N" ></td>
												<td GH="150 STD_QTSHPD100"    GCol="text,QTSHPD100" GF="N" ></td>
												<td GH="150 STD_WRKCNT100"    GCol="text,WRKCNT100" GF="N" ></td>
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
		</div>
		<!-- //contentContainer -->
  </div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>