<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>UM02</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "System",
			command : "UM02",
			pkcol : "USERID, MENUID",
		    menuId : "UM02"
	    });
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		searchList()
	});
	
	function commonBtnClick(btnName){
		if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "UM02");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "UM02");
 		}
	}

	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	//그리드 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		if(colName == "MENUID"){ //프로그램아이디를 변경할 경우
			var menuid = gridList.getColData(gridId, rowNum, "MENUID");
			
			var param = new DataMap();
			param.put("LABLKY", menuid);
			
			var json = netUtil.sendData({
				module : "System",
				command : "SEARCH_PROGRAM",
				sendType : "list",
				param : param
			}); 
			
			if(json && json.data && json.data.length > 0 ){
				var jsonMap = json.data[0]; //설명 셋팅
				gridList.setColValue(gridId, rowNum, "PROGNM", json.data[0]["PROGNM"]);
			}	
		}
}

	function saveData(){
		if(gridList.validationCheck("gridList", "All")){
			var list = gridList.getModifyList("gridList", "A");
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			var param = inputList.setRangeParam("searchArea");
			param.put("list",list);
			
			netUtil.send({
				url : "/system/json/saveUM02.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
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
					<input type="button" CB="Save SAVE BTN_SAVE" /> 
				</div>
			</div>
 			<%-- <div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_COMPKY"></dt>
						<dd>
							<input type="text" class="input" name="CMCDKY" value="<%=compky%>" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_MENUID"></dt>
						<dd>
							<input type="text" class="input" name="MENUID"  UIFormat="U"/>
						</dd>
					</dl> 
					<dl>
						<dt CL="STD_MENUNAME"></dt>
						<dd>
							<input type="text" class="input" name="MENUNAME"/>
						</dd>
					</dl>
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>  --%>
		</div>
       <!--  <div class="search_next_wrap"> -->
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
										<td GH="40" GCol="rowCheck" ></td>
										<td GH="100 STD_SORTNO"		GCol="add,SORTORDER" GF='N'></td>
										<td GH="100 STD_PROGID"		GCol="add,MENUID"></td>
										<td GH="200 STD_SHORTX"		GCol="text,PROGNM"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
 						<button type='button' GBtn="add"></button>
 						<!-- <button type='button' GBtn="copy"></button> -->
						<button type='button' GBtn="delete"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button> 

						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
			</div>
		<!-- </div> -->
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>