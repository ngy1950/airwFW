<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<style>
.gridIcon-center{text-align: center;}
.impflg{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn24.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}
.regAft{display:inline-block; width:23px; height:23px; vertical-align:middle; overflow:hidden; background: url(/common/images/ico_btn23.png) no-repeat 3px 3px; background-size:18px; text-indent:-500em;}

.colInfo{width: 100%;height: 35px;}
.colInfo ul{width: 405px;height: 100%;float: right;font-weight: bold;color: #6490FF;}
.colInfo ul li{padding-bottom: 7px;}
</style>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript">
midAreaHeightSet = "350px";
var area="" ; 
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "RS09",
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList",
	    	name : "gridItemList",
			editable : true,
			module : "WmsOutbound",
			command : "RS09SUB",
            autoCopyRowType : false
	    });
		
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
		
		area = $('#AREAKY').val();
		
		if($('#AREAKY').val() == 'ALL'){
			param.put("PKTYPE",'DGR');
		}else{
			param.put("PKTYPE",'AREA');
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
		if(gridId == "gridHeadList" && dataLength > 0){
			itemGridSearch();
		}else if(gridId == "gridHeadList" && dataLength <= 0){
			gridList.resetGrid("gridItemList");
            searchOpen(true);
		}
	}
	
    // 그리드 item 조회 이벤트
    function itemGridSearch(){  
    	var param = inputList.setRangeParam("searchArea");
    	
    	if(area == 'ALL'){
			param.put("PKTYPE",'DGR');
		}else{
			param.put("PKTYPE",'AREA');
		}
    	
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
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			param.put("WAREKY", "<%=wareky%>");
			
			return param;
		}else if(comboAtt == "WmsAdmin,AREACOMBO"){
			param.put("WAREKY", "<%=wareky%>");
			param.put("USARG1","STOR");
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
			}
			
			
			return param;
		}
	}
	
	function gridListColIconRemove(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "GBN"){
				if(colValue == "V"){
					return "impflg";	
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
			
		}
	}
	
	function selectShpdgr(){
		console.log($('#RQSHPD').val());
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
											
					                        <th CL="STD_RQSHPD"></th>
					                        <td>
	 					                        <input type="text" name="RQSHPD" id="RQSHPD" UISave="false"  UIInput="B" UIFormat="C -31 -1" validate="required(STD_RQSHPD)" MaxDiff="M1" />
					                        </td>
					                        
					                        <th CL="STD_AREAKY">창고</th>
											<td>
												<select id="AREAKY" name="AREAKY" Combo="WmsAdmin,AREACOMBO" UISave="false" ComboCodeView=false style="width:160px">
													<option value="ALL">전체</option>
												</select>
											</td>
											
											
										</tr>
										<tr>
											
											
											<th CL="STD_SEARCHTYPE"></th>
											<td>
												<select id="SEARCHTYPE" name="SEARCHTYPE" style="width:160px">
													<option value="1" selected >평균</option>
													<option value="2" >상세</option>
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
									<li>*상품수 : 전체 SKU 중 출하된 SKU 수</li>
									<li>*기간별 생산성은 전일까지, 최대 1개월(31일) 단위로 조회 가능</li>
								</ul>
							</div>
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
											<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_WAREKYNM"  GCol="text,WARENM"  ></td>
												<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD"     GF="D" ></td>
												<td GH="100 STD_ORDERC"    GCol="text,ORDCNT"     GF="N" ></td>
												<td GH="100 STD_ORDCNT"    GCol="text,ITMCNT"     GF="N" ></td>
												<td GH="100 STD_EAPCS"    GCol="text,ORDQTY"     GF="N" ></td>
												<td GH="100 STD_SKUCNT"    GCol="text,SKUCNT"     GF="N" ></td>
												<td GH="100 STD_BOXCNT"    GCol="text,BOXCNT"     GF="N" ></td>
												<td GH="100 STD_STRTIM"    GCol="text,STRTIM"     GF="T" ></td>
												<td GH="100 STD_ENDTIM"    GCol="text,ENDTIM"     GF="T" ></td>
												<td GH="100 STD_WORTIM"    GCol="text,JOBTIM" 	  GF="T" ></td>
												<td GH="100 STD_PKJTIM"    GCol="text,PKJTIM" 	  GF="T" ></td>
												<td GH="140 STD_BOXSEC"    GCol="text,BOXSED" 	  GF="N 9,2" ></td>
												<td GH="140 STD_BOXMIN"    GCol="text,ORDSED"	  GF="N 9,2" ></td>
												<td GH="100 STD_ORDPER"    GCol="text,PRDVAL"     GF="N 9,2" ></td>
												<td GH="100 STD_RS06NOTCNT"    GCol="text,NOTCNT"     GF="N" ></td>
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
<!-- 									<button type="button" GBtn="total"></button> -->
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
												<td GH="40"                GCol="rownum">1</td>
												<td GH="100 STD_WAREKYNM"  GCol="text,WARENM"  ></td>
												<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD"     GF="D" ></td>
												<td GH="100 STD_SHPDGR"    GCol="text,SHPDGR"  ></td>
												<td GH="100 STD_ORDERC"    GCol="text,ORDCNT"     GF="N" ></td>
												<td GH="100 STD_ORDCNT"    GCol="text,ITMCNT"     GF="N" ></td>
												<td GH="100 STD_EAPCS"    GCol="text,ORDQTY"     GF="N" ></td>
												<td GH="100 STD_SKUCNT"    GCol="text,SKUCNT"     GF="N" ></td>
												<td GH="100 STD_BOXCNT"    GCol="text,BOXCNT"     GF="N" ></td>
												<td GH="100 STD_STRTIM"    GCol="text,STRTIM"     GF="T" ></td>
												<td GH="100 STD_ENDTIM"    GCol="text,ENDTIM"     GF="T" ></td>
												<td GH="100 STD_WORTIM"    GCol="text,JOBTIM" 	  GF="T" ></td>
												<td GH="100 STD_PKJTIM"    GCol="text,PKJTIM" 	  GF="T" ></td>
												<td GH="140 STD_BOXSEC"    GCol="text,BOXSED" 	  GF="N 9,2" ></td>
												<td GH="140 STD_BOXMIN"    GCol="text,ORDSED"	  GF="N 9,2" ></td>
												<td GH="100 STD_ORDPER"    GCol="text,PRDVAL"     GF="N 9,2" ></td>
												<td GH="100 STD_RS06NOTCNT"    GCol="text,NOTCNT"     GF="N" ></td>
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
<!-- 									<button type="button" GBtn="total"></button> -->
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