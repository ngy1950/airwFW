<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>박스유형별상세조회</title>
<%@ include file="/common/include/popHead.jsp" %>
<script type="text/javascript">

	
	window.resizeTo('1200','800');
	
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "DL03POP",
            autoCopyRowType : false
	    });
		
		var data = page.getLinkPopData();
		var val = data.get("RQSHPD");
		searchShpdgr(val);
		
		dataBind.dataNameBind(data, "searchArea");
		$("#searchArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
		
		searchList();
		
    });
    
    function searchShpdgr(val){
		var param = new DataMap();
			param.put("RQSHPD",val);
			param.put("WAREKY", "<%=wareky%>");
		var json = netUtil.sendData({
			module : "WmsOutbound",
			command : "SHPDGR_S",
			sendType : "list",
			param : param
		});
		
		$("#SHPDGR").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#SHPDGR").append(optionHtml)
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

    //공통 버튼 클릭 이벤트
    function commonBtnClick(btnName){
       if(btnName == "Check"){
            closeData();
        }else if(btnName == "Search"){
            var data = dataBind.paramData("searchArea");
            searchList(data);
        }
    }
    
	//헤더 조회
	function searchList(){
		var param = dataBind.paramData("searchArea");
			
		 gridList.gridList({
	    	id : "gridHeadList",
	    	param : param
	    }); 
		
	}
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)   
	function gridListEventDataBindEnd(gridId, dataLength){
		
	}
	
	// 그리드 클릭 포커스 이벤트(클릭), 수정 데이터가 있을 경우 컨펌메세지 후 이동 또는 복귀
    function gridListEventRowFocus(gridId, rowNum){

    }
	
    //그리드 엑셀 다운로드 Before이벤트(엑셀 다운로드 이름, 검색조건값 세팅)
    function gridExcelDownloadEventBefore(gridId){
        var param = inputList.setRangeParam("searchArea");
        
        if(gridId == "gridHeadList"){
            param.put(configData.DATA_EXCEL_REQUEST_FILE_NAME, "gridHeadList");
        }
        return param;
        
    }
	
	function closeData(){
		this.close();
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
	
</script>
</head>
<body>
<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY">
		</button>
		<button CB="Check CHECK BTN_CLOSE">
		</button>
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
										<input type="hidden" id="WAREKY" name="WAREKY" value="" />
										<input type="hidden" id="OWNRKY" name="OWNRKY" value="" />
										<th CL="STD_RQSHPD"></th>
										<td>
											<input type="text" name="RQSHPD" UISave="false" disabled="disabled" UIFormat="D" validate="required(STD_RQSHPD)"  />
										</td>
										
				                        <th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
										
										<th CL="STD_BOXTYP"></th>
										<td>
											<select id="BOXTYP" name="BOXTYP" Combo="Common,COMCOMBO" disabled="disabled" validate="required(STD_BOXTYP)" UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
										
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
	         </div>

			<div class="bottomSect bottomT" style="top:100px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL="STD_DISPLAY"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="130 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
												<td GH="240 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="60 STD_PACKYN"    GCol="text,PACKYN"  ></td>
												<td GH="60 STD_PACQTY"    GCol="text,PACQTY" GF="N" ></td>
												<td GH="100 STD_TOTORD"    GCol="text,TOTORD" GF="N" ></td>
												<td GH="100 STD_TOTQTY"    GCol="text,TOTQTY" GF="N" ></td>
												<td GH="100 STD_TOTBOX"    GCol="text,TOTBOX" GF="N" ></td>
<!-- 												<td GH="100 STD_BOXQTY"    GCol="text,BOXQTY" GF="N" ></td> -->
												<td GH="100 STD_WIDTHW"    GCol="text,WIDTHW" GF="N" ></td>
												<td GH="100 STD_LENGTH"    GCol="text,LENGTH" GF="N" ></td>
												<td GH="100 STD_HEIGHT"    GCol="text,HEIGHT" GF="N" ></td>
												<td GH="100 STD_CUBICM"    GCol="text,CUBICM" GF="N" ></td>
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
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>