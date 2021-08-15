<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/common/include/webdek/head.jsp" %>
<script type="text/javascript">
var modipyflg = false;
var searchFlg = false;
var headMap = new DataMap();

	$(document).ready(function(){
		gridList.setGrid({
			id : "gridList",
			module : "System",
			command : "YH01ITEM",
			pkcol : "CPOPITEMID",
			editable : true,
			emptyMsgType : false,
			addFocusRow : true
		});
	});
	
	// 공통버튼
	function commonBtnClick(btnName){
		if(btnName == "Create"){
			create();
		}else if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "PwdClen"){
			pwdClen();
		}
	}
	
	//생성
	function create(){
		page.linkPopOpen("./YH01_POP.page", null, "height=200,width=460,resizeble=yes");
	}
	
	//조회
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			
			var json = netUtil.sendData({
				module : "System",
				command : "YH01HEAD",
				param : param,
				sendType: "map"
			});
			
			if(json && json.data){
				if(searchFlg == true){
					dataBind.dataNameBind(searchAreaNull(),"searchArea");
				}
				
				dataBind.dataNameBind(json.data,"searchArea");
				headMap = json.data;
				
			}else {
				if(commonUtil.msgConfirm("현재 해당 팝업아이디가 존재하지 않습니다. 해당 팝업아이디로 공통팝업를 생성하시겠습니까?")){
					create();
				}else {
					return;
				}
			}
			
			gridList.gridList({
				id : "gridList", 
				param : param
			});
			
			inputReadOnlyCheck(false);
			modipyflg = false;
			searchFlg = true;
		}
	}
	
	//저장
	function saveData(){
		var list = gridList.getModifyData("gridList", "A")
		if( list.length == 0 && modipyflg == false){
			commonUtil.msgBox("SYSTEM_SAVEEMPTY");
			//변경된 데이터가 없습니다.
			return false;
		}
		
		var param = new DataMap();
		param.put("list", list);
		param.put("headMap", inputList.setRangeParam("searchArea"));
		param.put("modipyflg", modipyflg);
		
		if(list.length > 0){
			if(!gridList.validationCheck("gridList","modify")){
				return;
			}
		}
		
		netUtil.send({
			url : "/admin/json/saveYH01.data",
			param : param,
			async : true,
			successFunction : "saveDataCallBack"
		});
	}
	
	//저장콜백
	function saveDataCallBack (json, returnParam){
		if(json && json.data){
			if(json.data["saveCk"] == false){
				commonUtil.msgBox(json.data["ERROR_MSG"], json.data["COL_VALUE"]);
			}else {
				commonUtil.msgBox("SYSTEM_SAVEOK");
				gridList.resetGrid("gridList");
				searchList();
			}
		}else{
			commonUtil.msgBox("EXECUTE_ERROR");
		}
	}
s	
	function linkPopCloseEvent(data){
		if(data){
			dataBind.dataNameBind(data.map,"searchArea");
			inputReadOnlyCheck(false);
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		var param = new DataMap();
		if(searchCode == "SYSCOMMPOP"){
			param.put("COMMPOPID","");
		}
		return param;
	}
	
	function gridListEventRowAddBefore(gridId, rowNum, beforeData){
		var newData = new DataMap();
		newData.put("ITEMTYPE", $("#itemType option:eq(1)").val());
		return newData;
	}
	
	function inputReadOnlyCheck(check){
		if(check == true){
			$(".input").attr("readonly", true);
		}else {
			$(".input").attr("readonly", false);
		}
	}
	
	function inputChange(inputNm){
		var inputVal = $("input[name='"+inputNm+"']").val();
		var inputType = $("input[name='"+inputNm+"']").attr("type");
		var oldColNm = "OLD_"+inputNm;
		
		if(inputVal.trim().length != 0 || headMap.oldColNm != inputVal || nullchk(headMap.oldColNm) == false){
			modipyflg = true;
		}
		
		if(inputType == "checkbox"){
			if($("input[name='"+inputNm+"']").is(":checked")){
				$("input[name='"+inputNm+"']").val("V");
			}else {
				$("input[name='"+inputNm+"']").val(" ");
			}
		}
	}
	
	function nullchk(val){
		if(val == undefined || val.trim() == "" || val == 0){
			return true;
		}else {r
			return false;
		}
	}
	
	function searchAreaNull(){
		var param = new DataMap();
		param.put("CPOPNAME","");
		param.put("VIEWTNAME","");
		param.put("CPOPDESC","");
		param.put("CPOPTYPE","");
		param.put("EXETYPE","");
		param.put("SIZEW","");
		param.put("SIZEH","");
		
		return param;
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
				</div>
				<div class="fl_r">
					<input type="button" CB="Create ADD BTN_NEW" /><!-- 생성 -->
					<input type="button" CB="Search SEARCH BTN_SEARCH" /><!-- 조회 -->
					<input type="button" CB="Save SAVE BTN_SAVE" /><!-- 저장 -->
<!-- 					<input type="button" CB="PwdClen SAVE BTN_PWDCLEN" />비밀번호 초기화 -->
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl>
						<dt CL="STD_COMMPOPID"></dt><!-- 공통팝엽 ID -->
						<dd>
							<input type="text" class="input" name="COMMPOPID" maxlength="50" UIInput="S,SYSCOMMPOP" validate="required"/>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_CPOPNAME"></dt><!-- 공통 팝업명 -->
						<dd>
							<input type="text" class="input" name="CPOPNAME" maxlength="50" readonly="readonly" onChange="inputChange('CPOPNAME')"/>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_VIEWTNAME"></dt><!-- 공통 팝업 테이블 -->
						<dd>
							<input type="text" class="input" name="VIEWTNAME" maxlength="50" readonly="readonly" onChange="inputChange('VIEWTNAME')"/>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_CPOPDESC"></dt><!-- 공통팝업 설명 -->
						<dd>
							<input type="text" class="input" name="CPOPDESC" maxlength="50" readonly="readonly" onChange="inputChange('CPOPDESC')"/>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_CPOPTYPE"></dt><!-- 공통 팝업 타입 -->
						<dd>
							<input type="checkbox" class="input" name="CPOPTYPE" readonly="readonly" onChange="inputChange('CPOPTYPE')"/>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_EXETYPE"></dt><!-- 초기 조회 타입 -->
						<dd>
							<input type="checkbox" class="input" name="EXETYPE" readonly="readonly" onChange="inputChange('EXETYPE')"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_SIZEW"></dt><!-- 가로 -->
						<dd>
							<input type="text" class="input" name="SIZEW" readonly="readonly" onChange="inputChange('SIZEW')"/>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_SIZEH"></dt><!-- 세로 -->
						<dd>
							<input type="text" class="input" name="SIZEH" readonly="readonly" onChange="inputChange('SIZEH')"/>
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
	                <li class="btn_zoom_wrap">
	                    <ul>
	                        <li><button class="btn btn_bigger"><span>확대</span></button></li>
	                    </ul>
	                </li>
	            </ul>
				<div class="table_box section">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true">
										<td GH="40" GCol="rownum">1</td>
	<!-- 									<td GH="40" GCol="rowCheck"></td> -->
										<td GH="120 STD_CPOPITEMID"  GCol="add,CPOPITEMID" GF="S 10" validate="required"></td><!-- 공통 팝업 아이템 ID -->
										<td GH="100 STD_CPOPITLABEL" GCol="input,CPOPITLABEL,SYSLABEL" GF="S 10"></td><!-- 공통 팝업 라벨 ID -->
										<td GH="120 STD_CPOPITNAME"  GCol="input,CPOPITNAME" GF="S 10"></td><!-- 공통 팝업 아이템명 -->
										<td GH="200 STD_ITEMTYPE"    GCol="select,ITEMTYPE">
											<select commonCombo="ITEMTYPE" id="itemType"><option></option></select>
										</td><!-- 코드 타입 -->
										<td GH="250 STD_SEARCHTYPE"  GCol="select,SEARCHTYPE">
											<select commonCombo="SEARCHTYPE"><option></option></select>
										</td><!-- 조회 형태-->
										<td GH="100 STD_SFORMAT"     GCol="input,SFORMAT" GF="S 10">
	<!-- 										<select commonCombo="SFORMAT"></select> -->
										</td><!-- 조회 포맷-->
										<td GH="100 STD_SOPTION"     GCol="input,SOPTION" GF="S 10">
	<!-- 										<select commonCombo="SOPTION"></select> -->
										</td><!-- 조회 옵션-->
										<td GH="100 STD_SDEFAULT"    GCol="input,SDEFAULT" GF="S 50">
	<!-- 										<select commonCombo="SDEFAULT"></select> -->
										</td><!-- 조회 기본값 -->
										<td GH="100 STD_SREQUIRED"   GCol="check,SREQUIRED"></td><!-- 필수 여부 -->
										<td GH="120 STD_GWIDTH"      GCol="input,GWIDTH" GF="N"></td><!-- 끄리드 조회값 넓이 -->
										<td GH="200 STD_RETURNCOL"   GCol="select,RETURNCOL">
											<select commonCombo="RETURNCOL"><option></option></select>
										</td><!-- Return 여부 -->
										<td GH="100 STD_SORTORDER"   GCol="input,SORTORDER" GF="N"></td><!-- 순번 -->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add"></button>
	<!-- 					<button type='button' GBtn="copy"></button> -->
	<!-- 					<button type='button' GBtn="add"></button> -->
						<button type='button' GBtn="delete"></button>
	<!-- 					<button type='button' GBtn="total"></button> -->
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
<!-- 						<button type='button' GBtn="excelUpload"></button> -->
<!-- 						<button type='button' GBtn="up"></button> -->
<!-- 						<button type='button' GBtn="down"></button> -->
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