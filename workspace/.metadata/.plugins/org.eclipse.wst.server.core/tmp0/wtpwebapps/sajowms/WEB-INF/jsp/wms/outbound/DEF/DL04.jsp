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
</style>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script type="text/javascript">
	midAreaHeightSet = "200px";
    $(document).ready(function(){
    	gridList.setGrid({
	    	id : "gridHeadList",
	    	name : "gridHeadList",
			editable : true,
			module : "WmsOutbound",
			command : "DL04",
			itemGrid : "gridItemList",
            itemSearch : true,
            autoCopyRowType : false
	    });
                      
		gridList.setGrid({
	    	id : "gridItemList",
	    	name : "gridItemList",
			editable : true,
			module : "WmsOutbound",
			command : "DL04SUB",
            autoCopyRowType : false
	    });
		gridList.setReadOnly("gridItemList", true, ["BOXTYP"]);
		var val = day(0);

		searchShpdgr(val);
		$("#searchArea [name=RQSHPD]").on("change",function(){
			searchShpdgr($(this).val().replace(/\./g,''));
			
		});
		
    });
    
    function searchShpdgr(val){
		var param = new DataMap();
			param.put("RQSHPD",val);
			param.put("WAREKY", "<%=wareky%>");
			param.put("CHKENDMAK","N");
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
    
    // 공통 버튼 클릭 이벤트
    function commonBtnClick(btnName){
        if(btnName == "Search"){
            searchList();
        }else if(btnName == "Dangood"){
			var data = inputList.setRangeParam("searchArea");
			
 			page.linkPopOpen("/wms/outbound/POP/DL04POP.page", data); 
        }else if(btnName == "Fwdord"){
        	saveData();
        }
    }
    
  //헤더 조회 
	function searchList(){
		//var param = dataBind.paramData("searchArea");
		
		gridList.resetGrid("gridHeadList");
		
		var param = inputList.setRangeParam("searchArea");

        if(validate.check("searchArea")){
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
        }
		
	}
    
	function saveData(){
			
		var num = gridList.getSelectRowNumList("gridHeadList");
		
		if(num.length < 1){
			commonUtil.msgBox("VALID_M0006");//선택된 데이터가 없습니다.
			return;
		} 
		
		var row = gridList.getRowData("gridHeadList",num[0]);
		
		var shpdic = gridList.getColData("gridHeadList", num[0], "SHPDIC");
		var boxmak = gridList.getColData("gridHeadList", num[0], "BOXMAK");
		var carmak = gridList.getColData("gridHeadList", num[0], "CARMAK");
		var dangood = gridList.getColData("gridHeadList", num[0], "INDANGOOD");
		
		if(shpdic == "V"){
			commonUtil.msgBox("VALID_M0506");//이미 출하지시가 되었습니다.
			return;				
		}
		
		if(boxmak != 'V' || carmak != 'V'){
			alert("오더확정 및 배차가 되어야 출하지시가 가능합니다.");
			return ;
		}

		if( row.length == 0 ){
			commonUtil.msgBox("MASTER_M0545"); //* 변경된 데이터가 없습니다.
			return;
		}
		
		var param = new DataMap();
			param.put("row", row);
		
		var json2 = netUtil.sendData({
			url : "/wms/outbound/json/validateDL04.data",
			param : param
		});
		
		if( json2 && json2.data ){
			if(json2.data == "1"){
				commonUtil.msgBox("VALID_M0507");//피킹로케이션이 미지정된 상품이 존재합니다.\n피킹로케이션을 모두 등록하여 주세요.
				return;
			}
		}
		
		var paramvalid = new DataMap();
			paramvalid.put("WAREKY",row.get("WAREKY"));
			paramvalid.put("OWNRKY",row.get("OWNRKY"));
			paramvalid.put("RQSHPD",row.get("RQSHPD"));
			paramvalid.put("SHPDGR",row.get("SHPDGR"));
		
		var json3 = netUtil.sendData({
            module : "WmsOutbound",
            command : "VALID_DUP_DL04",
            sendType : "map",
            param : paramvalid
        });
		
		if(json3 && json3.data){
			var locaky = json3.data["LOCAKY"]; 
			if(locaky.length > 0){
				commonUtil.msgBox("피킹로케이션 ( " + json3.data["LOCAKY"] + " )에 다른 상품이 있습니다.");//
				return;
			}
		}
		
		if(dangood == 'O'){
			if(!commonUtil.msgConfirm("COMMON_M0113")){//위해상품이 포함되어 있습니다.\n그래도 출하지시를 하시겠습니까?
	            return;
	        }
		}else{
			if(!commonUtil.msgConfirm("COMMON_M0112")){//출하지시를 하시겠습니까?
	            return;
	        }
		}
		
		netUtil.send({
			url : "/wms/outbound/json/saveDL04.data",
			param : param ,
			successFunction : "succsessSaveCallBack"
		});
		
	}
	
	function succsessSaveCallBack(json ,status){
		if( json && json.data ){
			commonUtil.msgBox("MASTER_M0564");
			searchList();
		}
	}
	
	
	// 그리드 AJAX 이후 데이터 그리드 결합이후  이벤트(하단 그리드 조회)
	function gridListEventDataBindEnd(gridId, dataLength){
		if(gridId == "gridHeadList" && dataLength > 0){
			gridList.setReadOnly("gridHeadList", true, ["BOXMAK","CARMAK","SHPDIC","PKJMAK","INDANGOOD"]);
		}else if(gridId == "gridHeadList" && dataLength <= 0){
			gridList.resetGrid("gridItemList");
            searchOpen(true);
		}
	}
	
    // 그리드 item 조회 이벤트
    function gridListEventItemGridSearch(gridId, rowNum, itemList){  
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
			}else if(name == "SH.SHPDGR"){
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
			if(colName == "BOXMAK"){
				if(colValue == "V"){
					return "impflg";	
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
			
			if(colName == "CARMAK"){
				if(colValue == "V"){
					return "impflg";
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			}
			
			if(colName == "SHPDIC"){
				if(colValue == "V"){
					return "impflg";
				}else if($.trim(colValue) == ""){
					return "regAft";
				}
			} 
			
			if(colName == "PKJMAK"){
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
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="Fwdord SAVE BTN_FWDORD"></button>
		<button CB="Dangood SAVE BTN_DANGOOD"></button>
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
										<input type="hidden" id="OWNRKY" name="OWNRKY" value="<%=ownrky%>" />
										<th CL="STD_WAREKY"></th>
										<td>
											<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled UISave="false" ComboCodeView=false style="width:160px">
											</select>
										</td>
									
										<th CL="STD_RQSHPD"></th>
										<td>
											<input type="text" name="RQSHPD" UISave="false"  UIFormat="C N" validate="required(STD_RQSHPD)"  />
										</td>
									
										<th CL="STD_SHPDGR"></th>
										<td>
											<select id="SHPDGR" name="SHPDGR"  UISave="false" ComboCodeView=false style="width:160px">
												<option value="">전체</option>
											</select>
										</td>
								
									</tr>
						
									<tr>
						
										<th CL="STD_BOXMAK"></th>
										<td>
											<select id="BOXMAK" name="BOXMAK" style="width:160px">
												<option value="0">전체</option>
												<option value="1" selected>확정</option>
												<option value="2">미확정</option>
											</select>
										</td>
										
										<th CL="STD_FWDORD"></th>
										<td>
											<select id="SHPDIC" name="SHPDIC" style="width:160px">
												<option value="0">전체</option>
												<option value="1">확정</option>
												<option value="2" selected>미확정</option>
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
												<td GH="40 STD_ROWCK"	   GCol="rowCheck,radio"></td>
												<td GH="80 STD_WAREKY"    GCol="text,WAREKYNM"  ></td>
												<td GH="100 STD_RQSHPD"    GCol="text,RQSHPD" GF="D"  ></td>
												<td GH="50 STD_SHPDGR"    GCol="text,SHPDGR" GF="N"  ></td>
												<td GH="80 STD_BOXMAK"    GCol="icon,BOXMAK" GB="regAft"></td>
												<td GH="80 STD_CARMAK"    GCol="icon,CARMAK" GB="regAft"></td>
												<td GH="80 STD_FWDORD"    GCol="icon,SHPDIC" GB="regAft"></td>
												<td GH="80 STD_PKJMAK"    GCol="icon,PKJMAK" GB="regAft"></td>
												<td GH="80 STD_TOTORD"    GCol="text,TOTORD" GF="N"  ></td>
												<td GH="80 STD_SHPBOXCNT" GCol="text,TOTBOX" GF="N"  ></td>
												<td GH="100 STD_TOTBYQTY"  GCol="text,TOTBYQTY" GF="N"  ></td>
												<td GH="80 STD_TOTSKU"    GCol="text,TOTSKU" GF="N" ></td>
												<td GH="80 STD_TOTQTY"    GCol="text,TOTQTY" GF="N"  ></td>
												<td GH="80 STD_INDANGOOD"    GCol="text,INDANGOOD,center"></td>
												<td GH="80 STD_INDANBOX"    GCol="text,INDANBOX,center"></td>
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
												<td GH="100 STD_SHPDGR"    GCol="text,SHPDGR" GF="N" ></td>
												<td GH="150 STD_BOXTYP"  GCol="select,BOXTYP" validate="required">
													<select Combo="Common,COMCOMBO" id="BOXTYP" name="BOXTYP" ComboCodeView=false></select>
												</td>
												<td GH="100 STD_TOTQTY"    GCol="text,TOTQTY" GF="N" ></td>
												<td GH="100 STD_TOTBOX"    GCol="text,TOTBOX" GF="N" ></td>
												<td GH="100 STD_TOTSKU"    GCol="text,TOTSKU" GF="N" ></td>
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
		<!-- //contentContainer -->
  </div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>