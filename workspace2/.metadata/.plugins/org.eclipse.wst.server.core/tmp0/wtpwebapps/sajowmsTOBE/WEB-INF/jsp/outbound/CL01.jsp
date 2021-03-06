<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CL01</title>
<%@ include file="/common/include/webdek/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "CenterClose",
			command : "CL01",
			pkcol : "OWNRKY,WAREKY,CLSDAT",
			menuId : "CL01"
	    });
		
		//미운영일  search 부분에 년, 월 넣기
		var date = dateParser();
		$("#YEAR").val(date.substring(0,4));
		$("#MONTH").val(date.substring(4,6));

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridList");
			var param = inputList.setRangeParam("searchArea");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		newData.put("LANGCODE","<%=langky%>");
		newData.put("LABELTYPE","WMS");
		return newData;
	}
	
	//로우 추가시 기본값 설정
	function gridListEventRowAddAfter(gridId, rowNum){
		  gridList.setColValue("gridList", rowNum, "WAREKY", $("#WAREKY").val());
		  gridList.setColValue("gridList", rowNum, "CLSDAT", dateParser());
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		
		return param;
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
				url : "/CenterClose/json/saveCL01.data",
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
			sajoUtil.openSaveVariantPop("searchArea", "CL01");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "CL01");
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
						<input type="button" CB="Save SAVE BTN_SAVE" /> 
						<input type="button" CB="Reload RESET STD_REFLBL" />
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl>
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY" class="input"
									Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input"
									Combo="SajoCommon,WAREKY_COMCOMBO" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_CLSDAT"></dt> 
							<!-- 구버전 VALUE : 미운영일(년/월) -->
							<dd>
								<input type="text" class="input" name="YEAR" id="YEAR" validate="required(STD_CLSDAT)" style="width: 60px;" /> / 
								<input type="text" class="input" name="MONTH" id="MONTH" validate="required(STD_CLSDAT)" style="width: 30px;"  />
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
											<!--주문구분-->
											<td GH="150 STD_WAREKY" GCol="select,WAREKY">
												<select class="input" Combo="SajoCommon,WAREKY_COMCOMBO"></select>
											</td>
											<td GH="100 STD_CLSDAT" GCol="input,CLSDAT" GF="C 20" validate="required">미운영일</td>
											<!--미운영일-->
											<td GH="150 STD_TEXT01" GCol="input,TEXT01" GF="S 40">비고</td>
											<!--비고-->
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