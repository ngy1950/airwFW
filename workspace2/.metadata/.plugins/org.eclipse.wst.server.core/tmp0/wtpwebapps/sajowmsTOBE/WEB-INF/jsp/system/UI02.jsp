<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>UI02</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "System",
			command : "UI02",
			pkcol : "USERID",
		    menuId : "UI02"
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
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		gridList.setColFocus(gridId, rowNum, "WAREKY");		
		return newData;
	}
	
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅), 화주선택 후 거점으로 자동선택
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "101");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}

	
	function saveData(){
		if(gridList.validationCheck("gridList", "modify")){
			var list = gridList.getModifyData("gridList", "A")
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {
				// 저장하시겠습니까?
				return;
			}
			
			netUtil.send({
				url : "/system/json/saveUI02.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	

	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] > 0){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				gridList.resetGrid("gridList");
				searchList();
			}
		}
	}
	
	//row 더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}	 
		
	//리로드
	function reloadLabel(){
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if (btnName == "Reload") {
			reloadLabel();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "UI02");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "UI02");
 		}
	}
	
	//팝업 종료 
    function linkPopCloseEvent(data){  
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
					<input type="button" CB="Search SEARCH STD_SEARCH" /> 
					<input type="button" CB="Save SAVE BTN_SAVE" /> 
					<input type="button" CB="Reload RESET STD_REFLBL" />
				</div>
			</div>
			<div class="search_inner"> <!-- UI02 사용자 계정 잠금 -->
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_OWNRKY"></dt> <!-- 화주 -->
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required(STD_OWNRKY)"></select>
						</dd>
					</dl>
					<dl>  <!--사용자 ID-->  
						<dt CL="STD_USERID"></dt> 
						<dd> 
							<input type="text" class="input" name="UM.USERID" UIInput="SR,SHUSRMA"/>
						</dd> 
					</dl> 
					<dl>  <!--이름-->  
						<dt CL="STD_NMLAST"></dt> 
						<dd> 
							<input type="text" class="input" name="UM.NMLAST" UIInput="SR"/> 
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
										<td GH="40" GCol="rowCheck" ></td>   
			    						<td GH="160 STD_USERID" GCol="input,USERID,SHUSRMA" GF="S 20"></td>	<!--사용자 ID-->
			    						<td GH="200 STD_NMLAST" GCol="text,NMLAST" GF="S 40"></td>	<!--이름-->
			    						<td GH="200 STD_NMFIRS" GCol="text,NMFIRS" GF="S 40"></td>	<!--관련업무-->
			    						<td GH="120 STD_LOCKYN"  GCol="select,LOCKYN"> <!--계정잠금여부 -->
											<select class="input" CommonCombo="LOCKYN">
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
<!-- 						<button type='button' GBtn="add"></button> -->
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="excelUpload"></button>
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