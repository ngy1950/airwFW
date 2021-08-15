<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>YM01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "System",
			command : "RC01",
 			pkcol : "DOCCAT,DOCUTY,RSNCOD,SHORTX,SHORTX",
			menuId : "RC01"
	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
// 		gridList.setReadOnly("gridList", true, ["DOCUTY"]);
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
		var hrowNum = gridList.getFocusRowNum("gridList");
		var ownrky = gridList.getColData("gridList", hrowNum, "OWNRKY");
		
		newData.put("LANGCODE","<%=langky%>");
		newData.put("MESSAGETYPE","WMS");
		newData.put("OWNRKY", ownrky);
		
		return newData;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){
			var list = gridList.getModifyData("gridList", "A")
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			for(var i=0; i<list.length; i++){
				var itemMap = list[i].map;
				
				if(itemMap.DOCCAT == ""){
					commonUtil.msgBox("문서유형을 입력해주세요.");
					return;
				}
				if(itemMap.DOCUTY == ""){
					commonUtil.msgBox("출고유형을 입력해주세요.");
					return;
				}		
				if(itemMap.RSNCOD == ""){
					commonUtil.msgBox("사유코드를 입력해주세요.");
					return;
				}
			}
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			
			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			netUtil.send({
				url : "/wms/system/json/saveRC01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}
		}
	}
	
	function reloadMessage(){
		netUtil.send({
			url : "/common/message/json/reload.data"
		});
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Reload"){
			reloadMessage();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "RC01");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "RC01");
		}
	}
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();
        
        if(!multyType){
        	if(searchCode == "SHDOCTM"){
        		param.put("DOCCAT","200");
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
<!-- 					<input type="button" CB="Reload RESET BTN_REFMSG" /> -->
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<!-- 화주 -->
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required" ></select>
						</dd>
					</dl>
					<dl>  <!--문서유형-->  
						<dt CL="STD_DOCCAT"></dt> 
						<dd> 
							<input type="text" class="input" name="DOCCAT" UIInput="I"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고유형-->  
						<dt CL="STD_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="DOCUTY" UIInput="I"/> 
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
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="70 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="70 STD_DOCCAT" GCol="input,DOCCAT,SHDOCCAT" GF="S 4" validate="required">문서유형</td>	<!--문서유형-->
			    						<td GH="70 STD_DOCUTY" GCol="input,DOCUTY,SHDOCTM" GF="S 4" validate="required">출고유형</td>	<!--출고유형-->
			    						<td GH="60 STD_RSNCOD" GCol="input,RSNCOD" GF="S 4" validate="required">사유코드</td>	<!--사유코드-->
			    						<td GH="200 STD_DOCCAT_EX getLabelShortTextlanguage" GCol="text,SHORTX" GF="S 60"></td>	<!--문서유형 설명-->
			    						<td GH="200 STD_DOCUTY_EX getLabelShortTextlanguage" GCol="text,SHORTX1" GF="S 60"></td>	<!--출고유형 설명-->
			    						<td GH="200 STD_RSNCOD_EX getLabelShortTextlanguage" GCol="input,SHORTX2" GF="S 60"></td>	<!--사유코드 설명-->
			    						<td GH="130 STD_DIFLOC" GCol="input,DIFLOC" GF="S 20">로케이션(Dif.)</td>	<!--로케이션(Dif.)-->
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