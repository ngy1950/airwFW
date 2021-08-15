<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DC01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "System",
			command : "DOCCM",
			menuId : "DC01"
	    });
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
		if(gridId == "gridList"){
			var rowState = gridList.getRowState(gridId, rowNum);
			if(rowState === configData.GRID_ROW_STATE_INSERT){
				gridList.setRowReadOnly(gridId, rowNum, false, ["DOCCAT"]);
			}else{
				gridList.setRowReadOnly(gridId, rowNum, true, ["DOCCAT"]);
			}
		}
		return false;
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		
		newData.put("DEFLIN","50");
		newData.put("DOCUFM","10");
// 		gridList.setColValue("gridList", rowNum, "DOCUFM", "10");
// 		gridList.setColValue("gridList", rowNum, "DEFLIN", "50");
		return newData;
		
	}
	
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "DOCCAT" && $.trim(colValue) != ""){
				var isDulication = false;
				
				var param = gridList.getRowData(gridId, rowNum);
				var json = netUtil.sendData({
					module : "System",
					command : "DOCCAT_DUPLICATION",
					param : param,
					sendType : "map"
				});
				if(json && json.data){
					var label = uiList.getLabel("STD_DOCCAT");
					if(json.data["CNT"] > 0){
						isDulication = true;
						commonUtil.msgBox("SYSTEM_ISUSEDATA",[label, colValue]);
					}else{
						var duplicationDoccatCheck = gridList.getGridBox(gridId).duplicationCheck(rowNum, colName, colValue);
						if(!duplicationDoccatCheck){
							isDulication = true;
							commonUtil.msgBox("SYSTEM_DUPDATA",[label, colValue]);
						}
					}
				}
				
				if(isDulication){
					gridList.setColValue(gridId, rowNum, colName, "");
				}
			}
		}
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){

			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			var json = gridList.gridSave({
		    	id : "gridList",
		    	modifyType : 'A'
		    });
			
			if(json && json.data){
				if(json.data > 0){
					searchList();
				}
			}
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "DC01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "DC01");
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
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_SHORTX"></dt>
						<dd>
							<input type="text" class="input" name="SHORTX" UIInput="SR"/>
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
										<td GH="140" GCol="input,DOCCAT" validate="required"></td>
										<td GH="140" GCol="input,SHORTX" validate="required"></td>
										<td GH="140" GCol="text,CREDAT" GF="D"></td>
										<td GH="140" GCol="text,CRETIM" GF="T"></td>
										<td GH="140" GCol="text,CREUSR"></td>
										<td GH="130" GCol="text,LMODAT" GF="D"></td>
										<td GH="130" GCol="text,LMOTIM" GF="T"></td>
										<td GH="130" GCol="text,LMOUSR"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add"></button>
						<button type='button' GBtn="delete"></button>
						<button type='button' GBtn="layout"></button>
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