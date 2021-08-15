<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>주문아이템상세조회</title>
<%@ include file="/common/include/popHead.jsp" %>
<style>
.gridIcon-center{text-align: center;}
.impflg{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.regAft{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn23.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
</style>
<script type="text/javascript">

	
	window.resizeTo('1310','800');
	
	$(document).ready(function(){
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "DL21POP",
            autoCopyRowType : false
	    });
		
		gridList.setReadOnly("gridHeadList", true, ["CNLBOX"]);
		
		var data = page.getLinkPopData();
		dataBind.dataNameBind(data, "searchArea");
		searchList();
		
	});

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
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "CNLBOX"){
				if(colValue == "V"){
					return "impflg";	
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
<!-- 		<button CB="Search SEARCH BTN_DISPLAY"> -->
<!-- 		</button> -->
		<button CB="Check CHECK BTN_CLOSE">
		</button>
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
										<input type="hidden" id="WAREKY" name="WAREKY" value="" />
										<input type="hidden" id="OWNRKY" name="OWNRKY" value="" />
										<th CL="STD_RQSHPD"></th>
										<td>
											<input type="text" name="RQSHPD" UISave="false" disabled="disabled" UIFormat="D" validate="required(STD_RQSHPD)"  />
										</td>
										
				                        <th CL="STD_SHPDGR"></th>
										<td>
											<input type="text" name="SHPDGR" id="SHPDGR" disabled="disabled" value="" />
										</td>
										
										<th CL="STD_SVBELN"></th>
										<td>
											<input type="text" name="SVBELN" id="SVBELN" disabled="disabled" value="" />
										</td>
										
										<th CL="STD_SHCARN"></th>
										<td>
											<input type="text" name="SHCARN" id="SHCARN" disabled="disabled" value="" />
										</td>
										
									</tr>
									
									<tr>
										
				                       <th CL="STD_ALLCNL"></th>
										<td>
											<select id="CNLBOX" name="CNLBOX" disabled="disabled" style="width:160px">
												<option value=""></option>
												<option value="V">Y</option>
												<option value=" ">N</option>
											</select>
										</td>
										
										<th CL="STD_SBOXSQ"></th>
										<td>
											<input type="text" name="SBOXSQ" id="SBOXSQ" disabled="disabled" value="" />
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
						<li><a href="#tabs1-1"><span CL="STD_DISPLAY"></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_SBOXSQ"    GCol="text,SBOXSQ"  ></td>
												<td GH="80 STD_BOXTYPNM"    GCol="text,BOXTYPNM"  ></td>
												<td GH="80 STD_SBOXID"    GCol="text,SBOXID"  ></td>
												<td GH="80 STD_BOXLAB"    GCol="text,BOXLAB"  ></td>
												<td GH="100 STD_SKUCLSNM"    GCol="text,SKUCLSNM"  ></td>
												<td GH="70 STD_LOTA06NM"    GCol="text,LOTA06NM"  ></td>
												<td GH="130 STD_SKUKEY"    GCol="text,SKUKEY"  ></td>
												<td GH="240 STD_DESC01"    GCol="text,DESC01"  ></td>
												<td GH="60 STD_PACKYN"    GCol="text,PACKYN"  ></td>
												<td GH="60 STD_PACQTY"    GCol="text,PACQTY" GF="N" ></td>
												<td GH="70 STD_CNLBOX"    GCol="icon,CNLBOX" GB="regAft"></td>
												<td GH="100 STD_QTSHPO"    GCol="text,QTSHPO" GF="N" ></td>
												<td GH="100 STD_QTJCMP"    GCol="text,QTJCMP" GF="N" ></td>
												<td GH="100 STD_QTSHPC"    GCol="text,QTSHPC" GF="N" ></td>
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