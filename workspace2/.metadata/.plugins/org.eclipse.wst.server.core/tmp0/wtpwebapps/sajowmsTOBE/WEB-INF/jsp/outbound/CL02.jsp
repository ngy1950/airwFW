<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL02</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "CenterClose",
			command : "CL02",
			pkcol : "CLSDAT,CLSTYP",
		    menuId : "CL02"
	    });
				
		if("<%=ownrky%>" != "2200" && "<%=urolky%>" != "DRADMIN"){ <%--    <%=ownrky%> 권한키 <%=urolky%>  --%>  
		  
		 // 이 안쪽에 그리드 밒 버튼 권한 설정
	    $('#saveBt').hide();
		 gridList.setReadOnly("gridList", true, ["STATUS","STATUS2"]);
		}

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	

	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList");
			var param = inputList.setRangeParam("searchArea");
			var clsdat = $("#CLSDAT").val();
			clsdat = clsdat.replace(/\./gi, "");
			
			param.put("CLSDAT",clsdat);
			//gridList.gridList 대체 
			netUtil.send({
				url : "/CenterClose/json/displayCL02.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridList" //그리드ID
			});
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("LANGCODE","<%=langky%>");
		newData.put("LABELTYPE","WMS");
		return newData;
	}
	
	function gridListEventRowAddAfter(gridId, rowNum){
		
		  gridList.setColValue("gridList", rowNum, "WAREKY", $("#WAREKY").val());
	}
	
	function saveData() {
		if (gridList.validationCheck("gridList", "All")) {
			var list = gridList.getModifyList("gridList", "A");
			if (list.length == 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}

			var param = new DataMap();
			param.put("list", list);
			param.put("OWNRKY", $("#OWNRKY").val());
			
	    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }

			netUtil.send({
				url : "/CenterClose/json/saveCL02.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}

	function successSaveCallBack(json, status) {
		if (json && json.data) {
			if (json.data.RESULT == "OK") {
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
	}

	function reloadLabel() {
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}

	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		} else if (btnName == "Save") {
			saveData();
		} else if (btnName == "Reload") {
			reloadLabel();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "CL02");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "CL02");
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
	<%@ include file="/common/include/webdek/layout.jsp"%>
	<!-- content -->
	<div class="content_wrap">
		<div class="content_inner">
			<%@ include file="/common/include/webdek/title.jsp"%>
			<div class="content_serch" id="searchArea">
				<div class="btn_wrap">
					<div class="fl_l">
						<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
						<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
					</div>
					<div class="fl_r">
						<input type="button" CB="Search SEARCH STD_SEARCH" /> 
						<input type="button" CB="Save SAVE BTN_SAVE" id="saveBt"/> 
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl>
							<dt CL="ITF_ORDDAT"></dt>
							<!-- 출고일자  -->
							<dd>
								<input type="text" class="input" id="CLSDAT" name="O.CLSDAT" UIFormat="C N" validate="required(STD_CLSDAT)" />
							</dd>
						</dl>
					</div>
					<div class="btn_tab">
						<input type="button" class="btn_more" value="more"
							onclick="searchMore()" />
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
											<td GH="40 STD_NUMBER" GCol="rownum">1</td>
											<td GH="40" GCol="rowCheck"></td>
											<td GH="85 IFT_ORDDAT" GCol="text,CLSDAT" name="O.CLSDAT" GF="D 8">출고일자</td>
											<!--출고일자-->
											<td GH="200 STD_PTNG08" GCol="text,CDESC1" name="O.CDESC1" GF="S 60">마감구분</td>
											<!--마감구분-->						
											<td GH="200 STD_CLSWHT"  GCol="select,STATUS" name="O.STATUS"> <!--마감여부-->
												<select class="input" CommonCombo="ORDCL">
												</select>
											</td>
											
											<td GH="200 STD_EMCLSWHT"  GCol="select,STATUS2" name="O.STATUS2"> <!--긴급 마감여부-->
												<select class="input" CommonCombo="ORDCL">
												</select>
											</td>
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
							<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- // content -->
	<%@ include file="/common/include/webdek/bottom.jsp"%>
</body>
</html>
