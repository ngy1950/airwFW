<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
var rangeparam;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Master",
			command : "SHPMA",
			itemGrid : "gridItemList1",
			itemSearch : true,
			tempItem : "gridItemList1",
			useTemp : true,
		    tempKey : "KEY",
			menuId : "TC02"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList1",
	    	module : "Master",
			command : "ZIPINFO",
			tempHead : "gridHeadList",
			useTemp : true,
			tempKey : "KEY",
			menuId : "TC02"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList2",
	    	module : "Master",
			command : "ZIPMA",
			menuId : "TC02"
	    });
		
		$("#SIDO").on("change",function(){
			var hrowcnt = gridList.getGridDataCount("gridHeadList");
			
			if(hrowcnt == 0	){
				return;
			}
			
			rangeparam = inputList.setRangeDataParam("searchArea");
			rangeparam.put("SIDO",$(this).val());
			gridList.gridList({
		    	id : "gridItemList2",
		    	param : rangeparam
		    });
		});
		

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef(); 
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.reloadAll("gridItemList1");
			gridList.reloadAll("gridItemList2");
			rangeparam = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : rangeparam
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var param = gridList.getRowData(gridId, rowNum);
			rangeparam.putAll(param);
			gridList.gridList({
		    	id : "gridItemList1",
		    	param : rangeparam
		    });
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		
		if(gridId == "gridItemList1" && dataCount > 0){
			var sido = gridList.getColData("gridItemList1", 0, "SIDO");
			$("#SIDO").val(sido).trigger("change");
		}
		
	}
	
	function saveData(){
		if(gridList.validationCheck("gridItemList1", "select")){
			var headlist = gridList.getSelectData("gridHeadList", true);
			var list = gridList.getSelectData("gridItemList1", true);
			
			//아이템 템프 가져오기
	        var tempItem = gridList.getSelectTempData("gridHeadList");
			
			if(headlist.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var param = new DataMap();
			param.put("headlist",headlist);
			param.put("list",list);
			param.put("tempItem",tempItem);
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/master/json/saveTC02.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] != "0"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();				
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "TC02");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "TC02");
		}else if(btnName == "Addnew"){
			var rowData = new DataMap();
			var rownrky = "";
				if(rangeparam != undefined){
					rownrky = rangeparam.get("OWNRKY");
				}else{
					rownrky = $('#OWNRKY').val();
				}
				rowData.put("OWNRKY",rownrky);
			gridList.addNewRow("gridHeadList", rowData);
			
		}else if(btnName == "Delete"){
			var hlist = gridList.getSelectRowNumList("gridHeadList");
			for(var i=0;i<hlist.length;i++){
				gridList.deleteRow("gridHeadList",hlist[i],true);
			}
		}else if(btnName == "Add"){
			var ziplist = gridList.getSelectData("gridItemList2", true);
			var zipinfolist = gridList.getGridData("gridItemList1");
			
			for(var i=0;i<ziplist.length;i++){
				var row = ziplist[i]; 
				
				var checkrow = zipinfolist.filter(function (e) {
				    return e.get("SEQ") == row.get("SEQ");
				});
				
				if(checkrow.length == 0){
					gridList.addNewRow("gridItemList1", row);
				}
			}
			gridList.checkAll("gridItemList2", false, 0);
			
		}else if(btnName == "Del"){
			var zipinfolist = gridList.getSelectRowNumList("gridItemList1");
			
			for(var i=0;i<zipinfolist.length;i++){
				gridList.deleteRow("gridItemList1", zipinfolist[i], false)
			}
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum) {
		if(gridId == 'gridItemList'){
			var hrow = gridList.getRowData("gridHeadList", gridList.getFocusRowNum("gridHeadList"));
			var newData = new DataMap();
				newData.put("OWNRKY",hrow.get("OWNRKY"));
				newData.put("PTNRKY",hrow.get("PTNRKY"));
				newData.put("SEQNO",rowNum);
				
			      
			return newData;
		}
		
    }
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "110");
			
		}
		
		return param;
	}
	
	 //팝업 종료 
    function linkPopCloseEvent(data){  
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
    }
	
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>  <!--권역코드-->  
						<dt CL="STD_REGNKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.REGNKY" UIInput="SR,SHSHPMA"/> 
						</dd> 
					</dl>
					
					<dl>  <!--우편번호-->  
						<dt CL="STD_POSTCD"></dt> 
						<dd> 
							<input type="text" class="input" name="S.POSTCD" UIInput="SR,SHZIPMA"/> 
						</dd> 
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs top_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
							<input type="button" CB="Addnew SAVE BTN_ADDROW" />
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
							<input type="button" CB="Delete SAVE BTN_DELETEROW" />
						</li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="120 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="120 STD_REGNKY" GCol="input,REGNKY" GF="S 10">권역코드</td>	<!--권역코드-->
			    						<td GH="120 STD_REGNNM" GCol="input,REGNNM" GF="S 100">권역명</td>	<!--권역명-->
			    						<td GH="120 STD_REMAKS" GCol="input,DESC01" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="120 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="120 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="120 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="120 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
			    						<td GH="120 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
			    						<td GH="120 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
			</div>
			
			<div class="content_layout tabs bottom_layout content_left" style="width : calc(100% - 50.5%);">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>일반</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
								<li><button class="btn btn_bigger"><span>확대</span></button></li>
							</ul>
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
							<span CL="STD_RSNREC" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
							<select name="SIDO" id="SIDO"  class="input" Combo="SajoCommon,SIDO_COMBO" ComboCodeView="false"><option></option></select>
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
							<input type="button" CB="Add SAVE BTN_ADDROW" />
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
							<input type="button" CB="Del SAVE BTN_DELETEROW" />
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridItemList1">
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td>
											<td GH="40" GCol="rowCheck"></td>
											<td GH="100 STD_SEQ" GCol="text,SEQ" GF="S 10">Sequence No.</td>	<!--Sequence No.-->
				    						<td GH="100 STD_POSTCD" GCol="text,POSTCD" GF="S 30">우편번호  </td>	<!--우편번호  -->
				    						<td GH="100 STD_SIDO" GCol="text,SIDO" GF="S 20">시도</td>	<!--시도-->
				    						<td GH="100 STD_GUGUN" GCol="text,GUGUN" GF="S 30">구군</td>	<!--구군-->
				    						<td GH="100 STD_DONG" GCol="text,DONG" GF="S 100">동</td>	<!--동-->
				    						<td GH="100 STD_BUNJI" GCol="text,BUNJI" GF="S 50">번지</td>	<!--번지-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="saveLayout"></button>
							<button type='button' GBtn="getLayout"></button>
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
				</div>
				<div class="content_layout tabs bottom_layout content_right" style="width : calc(100% - 50.5%);">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>일반</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<li><button class="btn btn_smaller"><span>축소</span></button></li>
								<li><button class="btn btn_bigger"><span>확대</span></button></li>
							</ul>
						</li>
					</ul>
					<div class="table_box section" id="tab1-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridItemList2">
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td>
											<td GH="40" GCol="rowCheck"></td>
											<td GH="100 STD_SEQ" GCol="text,SEQ" GF="S 10">Sequence No.</td>	<!--Sequence No.-->
				    						<td GH="100 STD_POSTCD" GCol="text,POSTCD" GF="S 30">우편번호  </td>	<!--우편번호  -->
				    						<td GH="100 STD_SIDO" GCol="text,SIDO" GF="S 20">시도</td>	<!--시도-->
				    						<td GH="100 STD_GUGUN" GCol="text,GUGUN" GF="S 30">구군</td>	<!--구군-->
				    						<td GH="100 STD_DONG" GCol="text,DONG" GF="S 100">동</td>	<!--동-->
				    						<td GH="100 STD_BUNJI" GCol="text,BUNJI" GF="S 50">번지</td>	<!--번지-->						
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="saveLayout"></button>
							<button type='button' GBtn="getLayout"></button>
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>
				</div>
			
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>