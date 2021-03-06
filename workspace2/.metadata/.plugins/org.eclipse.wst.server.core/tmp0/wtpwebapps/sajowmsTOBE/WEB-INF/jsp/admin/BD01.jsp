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
var headrow = -1;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Master",
			command : "BD01",
			itemGrid : "gridItemList",
			itemSearch : true,
			pkcol :"OWNRKY,PTNRKY",
			menuId : "BD01"
// 			tempItem : "gridItemList",
// 			useTemp : true,
// 		    tempKey : "PTNRKY",
		    
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Master",
			command : "BD01_ITEM",
			pkcol :"OWNRKY,PTNRKY",
			menuId : "BD01"
// 			tempHead : "gridHeadList",
// 			useTemp : true,
// 			tempKey : "PTNRKY",
		    
	    });
		
		gridList.setReadOnly("gridHeadList", true, ["PTNL09"]);


		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var param = gridList.getRowData(gridId, rowNum);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridItemList", "select")){
			var headlist = gridList.getSelectData("gridHeadList", true);
			var list = gridList.getSelectData("gridItemList", true);
			
			//아이템 템프 가져오기
// 	        var tempItem = gridList.getSelectTempData("gridHeadList");
			
			if(headlist.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var param = new DataMap();
			param.put("headlist",headlist);
			param.put("list",list);
// 			param.put("tempItem",tempItem);
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/master/json/saveBD01.data",
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
	 		sajoUtil.openSaveVariantPop("searchArea", "BD01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "BD01");
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum) {
		if(gridId == 'gridItemList'){
			var hrow = gridList.getRowData("gridHeadList", gridList.getFocusRowNum("gridHeadList"));
			var newData = new DataMap();
				newData.put("OWNRKY",hrow.get("OWNRKY"));
				newData.put("PTNRKY",hrow.get("PTNRKY"));
// 				newData.put("STDDAT",0);
// 				newData.put("ENDDAT",0);
				newData.put("SEQNO",rowNum);
				
			      
			return newData;
		}
    }
	
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			if(colName == "STDDAT" || colName == "ENDDAT"){
				var stddat = gridList.getColData("gridItemList", rowNum, "STDDAT");
				var enddat = gridList.getColData("gridItemList", rowNum, "ENDDAT");
				var rowCount = parseInt(gridList.getGridDataCount("gridItemList"));
				
				if($.trim(stddat) == "" || $.trim(enddat) == ""){
					return ;
				}
				
				if(parseInt(stddat) >= parseInt(enddat)){
					alert("종료일자가 시작일자보다 커야함");
					return;
				}
				
				rowNum = parseInt(rowNum);
				var rowId = rowNum +1;
				
				if(rowCount > 1){
					if(rowNum == 0){//first row
						var nstddat = gridList.getColData("gridItemList", rowNum +1 , "STDDAT");
						if(nstddat != "" && nstddat != " " && nstddat != 0 && parseInt(enddat) >= parseInt(nstddat)){
							alert(rowId+"번의 종료일자는 "+(rowId+1) + "번 아이템의 시작일보다 작아야합니다.");	
							gridList.setColValue("gridItemList", rowNum, "ENDDAT", --nstddat, true);
						}
					}else if(rowNum + 1 < rowCount){//middle row
						var nstddat = gridList.getColData("gridItemList", rowNum +1 , "STDDAT");	
						if(nstddat != "" && nstddat != " " && nstddat != 0 && parseInt(enddat) >= parseInt(nstddat)){
							alert(rowId+"번의 종료일자는 "+(rowId+1) + "번 아이템의 시작일보다 작아야합니다.");	
							gridList.setColValue("gridItemList", rowNum, "ENDDAT", --nstddat, true);
						}					
						
						var benddat = gridList.getColData("gridItemList", rowNum -1 , "ENDDAT");
						if(benddat != "" && benddat != " " && benddat != 0 && parseInt(benddat) >= parseInt(stddat)){
							alert(rowId+"번아이템의 시작일자는 "+(rowId-1) + "번 아이템의 종료일보다 커야합니다.");
							gridList.setColValue("gridItemList", rowNum, "STDDAT", ++benddat, true);
						}
						
					}else if(rowNum + 1 == rowCount){//last row
						var benddat = gridList.getColData("gridItemList", rowNum -1 , "ENDDAT");
						if(benddat != "" && benddat != " " && benddat != 0 && parseInt(benddat) >= parseInt(stddat)){
							alert(rowId+"번아이템의 시작일자는 "+(rowId-1) + "번 아이템의 종료일보다 커야합니다.");
							gridList.setColValue("gridItemList", rowNum, "STDDAT", ++benddat, true);
						}
					}
				}
			}
		}	
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
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
					<dl>  <!--업체코드-->  
						<dt CL="STD_PTNRKY"></dt> 
						<dd> 
							<input type="text" class="input" name="PTNRKY" UIInput="SR,SHZPTN"/> 
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
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>
										<td GH="40 STD_CHECKED" GCol="rowCheck,radio"></td>
			    						<td GH="120 STD_OWNRKY" GCol="text,OWNRKY" GF="S 20">화주</td>	<!--화주-->
			    						<td GH="120 STD_PTNRKY" GCol="input,PTNRKY" GF="S 20">업체코드</td>	<!--업체코드-->
			    						<td GH="120 STD_NAME01B" GCol="text,NAME01" GF="S 180">거래처명</td>	<!--거래처명-->
			    						<td GH="120 STD_NAME03B" GCol="text,NAME03" GF="S 180">출고거점</td>	<!--출고거점-->
			    						<td GH="120 납품처사용여부" GCol="check,PTNL09">납품처사용여부</td>	<!--납품처사용여부-->	
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
			<div class="content_layout tabs bottom_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="40" GCol="rowCheck"></td>
			    						<td GH="120 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="120 STD_PTNRKY" GCol="text,PTNRKY" GF="S 10">업체코드</td>	<!--업체코드-->
			    						<td GH="120 STD_ITEMORD" GCol="text,SEQNO" GF="S 10">아이템번호순</td>	<!--아이템번호순-->
			    						<td GH="120 STD_VALSTD" GCol="input,STDDAT" GF="S 10" validate="required" >유효기간 (시작)</td>	<!--유효기간 (시작)-->
			    						<td GH="120 STD_VALEND" GCol="input,ENDDAT" GF="S 10" validate="required" >유효기간 (종료)</td>	<!--유효기간 (종료)-->
			    						<td GH="120 STD_ALORTO" GCol="input,BBDRTO" GF="S 10" validate="required" >적용률(%)</td>	<!--적용률(%)-->
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
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="add"></button>
                     	<button type='button' GBtn="delete"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
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