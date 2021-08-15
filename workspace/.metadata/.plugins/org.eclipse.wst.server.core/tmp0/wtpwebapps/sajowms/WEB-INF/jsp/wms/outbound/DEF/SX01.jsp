<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript">
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "SX01",
            autoCopyRowType : false
	    });
    	
    	gridList.setReadOnly("gridHeadList", true, ["WAREKY"]);
    	
    	searchTotalAndLastnum();
    	
    });
    
    // 공통 버튼 클릭 이벤트
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }else if(btnName == "Barcodeprnt"){
        	print();
        }else if(btnName == "Crebaat"){
        	saveData();
        }
    }
    
  //헤더 조회 
	function searchList(){
		var param = dataBind.paramData("searchArea");
		
		gridList.resetGrid("gridHeadList");
		
		var param = inputList.setRangeParam("searchArea");

        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }
		
	}
  	
	var mkcnt = 0;
	function saveData(){
		mkcnt = parseInt($('#MKCNT').val().replace(/,/g,"")); 
		
		if(mkcnt< 1){
			commonUtil.msgBox("VALID_M0533");//생성매수는 1이상 이여야 합니다.
			return ;
		}
		
		var param = new DataMap();
			param.put("WAREKY", "<%=wareky%>");
			param.put("MKCNT", mkcnt);
			
		if(!commonUtil.msgConfirm("COMMON_M0119")){
            return;
        }
		
		netUtil.send({
			url : "/wms/outbound/json/saveSX01.data",
			param : param ,
			successFunction : "succsessSaveCallBack"
		});
		
	}
	
	function succsessSaveCallBack(json,status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0501", mkcnt);
			searchList();
		}
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){
			searchTotalAndLastnum('S');
		}else if(gridId == "gridHeadList" && dataLength <= 0){
			searchTotalAndLastnum('N');
            searchOpen(true);
		}
	}
	
	function searchTotalAndLastnum(gbn){
		
		if(gbn == 'S'){
			var param = new DataMap();
				param.put("WAREKY","<%=wareky%>");
			
			var json = netUtil.sendData({
	              module : "WmsOutbound",
	              command : "CHK_TOTBOX_LASTNUM",
	              sendType : "map",
	              param : param
			})
			
			$('#TOTBOXUSECNT').val(json.data["TOTBOXUSECNT"]);
			$('#LASTNUM').val(json.data["LASTNUM"]);
		}else{
			$('#TOTBOXUSECNT').val(0);
			$('#LASTNUM').val(' ');
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
			}else if(name == "GH.SHPDGR"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "SHPDGR");
			}else if(name == "BOXTYP"){
				param.put("WARECODE","Y"); //시스템일경우 Y 넘김
				param.put("WAREKY","<%=wareky%>");
				param.put("CODE", "BOXTYP");
			}
			
			
			return param;
		}else if ( comboAtt == "WmsCommon,DOCTMCOMBO"){
            var param = new DataMap();
            param.put("PROGID", configData.MENU_ID);
            return param;
        }
	}

	
	function onlyNumber(event){
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			return false;
	}
	
	function removeChar(event) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			event.target.value = event.target.value.replace(/[^0-9]/g, "");
	}
	
	function print(){
		var prtcnt = parseInt($('#PRTCNT').val().replace(/,/g,"")); 
		var param = dataBind.paramData("searchArea");
			param.put("PROGID" , configData.MENU_ID);
			param.put("PRTCNT" , prtcnt);
		
		
		
		if(prtcnt< 1){
			commonUtil.msgBox("VALID_M0534");//출력매수는 1이상 이여야 합니다.
			return ;
		}
    	
		var head = gridList.getSelectData("gridHeadList");
		
		if( head.length == 0 ){
			commonUtil.msgBox("VALID_M0006");//선택된 데이터가 없습니다.
			return;
		}
		
		param.put("head",head);
		
		var json = netUtil.sendData({
			url : "/wms/outbound/json/printSX01.data",
			param : param
		});
		
		if ( json && json.data ){
				var url = "<%=systype%>" + "/outbound_boxid_label.ezg";
				var where = "PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				var width =  190;
				var heigth = 173;
				var langKy = "KR";
				var map = new DataMap();
					map.put("PRTCNT",prtcnt);
				WriteEZgenElement(url , where , "" , langKy, map , width , heigth );
				
				
		}
	}
  
    
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Barcodeprnt PRINT BTN_BARCODEPRNT"></button>
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
									<col width="50px" />
									<col width="450px" />
									<col width="50px" />
									<col width="450px" />
									<col width="50px" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
										
										<th CL="STD_BOXCOD"></th>
										<td>
											<input type="text" name="BS.BOXTXT" UISave="false" UIInput="R" maxlength="10"  />
										</td>
									
										<th CL="STD_PRNTYN"></th>
										<td>
											<select id="PRNTYN" name="PRNTYN" style="width:160px">
				                            	<option value="0">전체</option>
				                            	<option value="1">발행</option>
				                            	<option value="2">미발행</option>
				                            </select>
										</td>
								
									</tr>
						
									<tr>
						
										<th CL="STD_LSTDAT"></th>
										<td>
											<input type="text" name="BS.LSTDAT" UISave="false"   UIInput="R" UIFormat="C"    />
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
						<li><a href="#tabs1-1"><span CL='STD_GENERAL'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div>
								<span CL="STD_PRTCNT">출력매수</span> <input type="text" name="PRTCNT" ID="PRTCNT" UIformat="N 2" style="text-align: right; padding-left: 15px;" value = 2 />
								<span CL="신규박스" style="padding-left: 30px;">신규박스</span> 
									<input type="text" name="MKCNT" ID="MKCNT" UIformat="N 6" style="text-align: right;padding-left: 15px; padding-right : 15px;" value = 0 /> 
									<button CB="Crebaat SAVE BTN_CREBAT" ></button>
								<span CL="STD_TOTBOXUSECNT" style="padding-left: 30px;">총 사용박스수 : </span>
									<input type="text" name="TOTBOXUSECNT" ID="TOTBOXUSECNT" UIformat="N" disabled="disabled" style="text-align: right;padding-left: 15px;" />
<!-- 								<span CL="STD_LASTNUM" style="padding-left: 30px;">총 사용박스수 : </span> -->
									<input type="hidden" name="LASTNUM" ID="LASTNUM" UIformat="N" disabled="disabled" style="text-align: right;padding-left: 15px;" />
							</div>
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="100 STD_WAREKY"    GCol="select,WAREKY"  >
													<select Combo="WmsCommon,ROLCTWAREKY" id="WAREKY" name="WAREKY" ComboCodeView=false></select>
												</td>
												
												<td GH="100 STD_BOXCOD"    GCol="text,BOXTXT"  ></td>
												<td GH="100 STD_VEHINO"    GCol="text,VEHINO"  ></td>
												<td GH="100 STD_LSTDAT"    GCol="text,LSTDAT" GF="D" ></td>
												<td GH="100 STD_LSTTIM"    GCol="text,LSTTIM" GF="T" ></td>
												<td GH="100 STD_LSTUSR"    GCol="text,LSTUSR"  ></td>
												<td GH="100 STD_NMLAST"    GCol="text,NMLAST"  ></td>
												
												<td GH="100 STD_CREDAT"    GCol="text,CREDAT" GF="D" ></td>
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
			
		<!-- //contentContainer -->
		</div>
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>