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
var shrow = -1;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	module : "Master",
	    	pkcol : "OWNRKY,WAREKY,CARNUM",
			command : "TC01",
			menuId : "TC01"
	    });
		
// 		inputList.setMultiComboSelectAll($("#CARTYP"), true);
// 		inputList.setMultiComboSelectAll($("#CAROPT"), true);
// 		inputList.setMultiComboSelectAll($("#CARSTS"), true);
// 		inputList.setMultiComboSelectAll($("#CARGBN"), true);
// 		inputList.setMultiComboSelectAll($("#CARTMP"), true);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	

	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			shrow = -1;
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
		}
	}


	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "TC01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "TC01");
 		}
	}

	 //팝업 종료 
    function linkPopCloseEvent(data){  
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
    }
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}
		return param;
	}
	
	
	//그리드 로우 추가 전  이벤트
	function gridListEventRowAddBefore(gridId, rowNum){
			var ownrky="" , wareky = "";
			
			if(gridList.getRowNumList("gridList").length == 0){
				ownrky = $('#OWNRKY').val();
				wareky = $('#WAREKY').val();
			}else{
				var row = gridList.getRowData(gridId, 0);
				ownrky = row.get("OWNRKY");
				wareky = row.get("WAREKY");
			}
			
						
			var newData = new DataMap();
				newData.put("OWNRKY",ownrky);
				newData.put("WAREKY",wareky);
			return newData;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridList", "modify")){
			var list = gridList.getModifyData("gridList", "A")
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
	        if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
	            return;
	        }

			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			netUtil.send({
				url : "/master/json/saveTC01.data",
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
			}
		}
	}
	
	function gridListEventRowRemove(gridId, rowNum){
		if(gridId == "gridList"){
			if(gridList.getRowStatus(gridId, rowNum) != "C"){
				commonUtil.msgBox("VALID_M9999");
				return false;
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
	<div class="content_inner contentH_inner">
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
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" ></select>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_DELMAK"></dt>
						<dd>
							<input type="checkbox" class="input" name="DELMAK" id="DELMAK" style="margin-top: 0px;" value="V" />
						</dd>
					</dl>
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="CARNUM" UIInput="SR"/> 
						</dd> 
					</dl>
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_DCMPNM"></dt> 
						<dd> 
							<input type="text" class="input" name="DCMPNM" UIInput="SR"/> 
						</dd> 
					</dl>
					
					<dl>  <!--출고일자-->  
						<dt CL="STD_DRIVER"></dt> 
						<dd> 
							<input type="text" class="input" name="DRIVER"  UIInput="SR"/> 
						</dd> 
					</dl>
					
					<dl>  <!--출고일자-->  
						<dt CL="STD_DRCARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="DESC01"  UIInput="SR"/> 
						</dd> 
					</dl>
					
					<dl>
						<dt CL="STD_CARTYP"></dt> 
						<dd>
							<select name="CARTYP" id="CARTYP" class="input" CommonCombo="CARTYP" ComboCodeView="true"><option></option></select>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_CAROPT"></dt>
						<dd>
							<select name="CAROPT" id="CAROPT"  class="input" CommonCombo="CAROPT" ComboCodeView="true"><option></option></select>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_CARSTS"></dt>
						<dd>
							<select name="CARSTS" id="CARSTS" class="input" CommonCombo="CARSTS" ComboCodeView="true"><option></option></select>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_CARGBN"></dt>
						<dd>
							<select name="CARGBN" id="CARGBN"  class="input" CommonCombo="CARGBN" ComboCodeView="true"><option></option></select>
						</dd>
					</dl>
					
					<dl>
						<dt CL="STD_CARTMP"></dt>
						<dd>
							<select name="CARTMP" id="CARTMP"  class="input" CommonCombo="CARTMP" ComboCodeView="true"><option></option></select>
						</dd>
					</dl>
					
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap">	
				<div class="content_layout tabs">
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
									<tbody id="gridList">
										<tr CGRow="true">
											<td GH="40" GCol="rownum">1</td>
											<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
				    						<td GH="100 STD_CARNUM" GCol="input,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
				    						<td GH="100 STD_DESC01_C" GCol="input,DESC01" GF="S 30"></td>	<!---->
				    						<td GH="100 STD_DCMPNM" GCol="select,DCMPNM">
												<select class="input" CommonCombo="TRCMPY"></select>
											</td>	<!--운송사-->
				    						<td GH="50 STD_DRIVER" GCol="input,DRIVER" GF="S 30">기사명</td>	<!--기사명-->
				    						<td GH="100 STD_PERHNO" GCol="input,PERHNO" GF="S 20">기사핸드폰</td>	<!--기사핸드폰-->
				    						<td GH="100 STD_CARTYP" GCol="select,CARTYP">
												<select class="input" CommonCombo="CARTYP"></select>
											</td>	<!--차량 톤수-->
				    						<td GH="100 STD_CARORD" GCol="input,CARORD" GF="N 3,0">배차우선순위</td>	<!--배차우선순위-->
				    						<td GH="100 STD_CARWHD" GCol="input,CARWHD" GF="N 22,0">차량 폭</td>	<!--차량 폭-->
				    						<td GH="100 STD_CARHIG" GCol="input,CARHIG" GF="N 22,0">차량 높이</td>	<!--차량 높이-->
				    						<td GH="100 STD_CARLNG" GCol="input,CARLNG" GF="N 22,0">차량 길이</td>	<!--차량 길이-->
				    						<td GH="100 STD_CARWEG" GCol="input,CARWEG" GF="N 22,0">최대적재중량</td>	<!--최대적재중량-->
				    						<td GH="100 STD_CUBICM" GCol="input,CUBICM" GF="N 20,0">CBM</td>	<!--CBM-->
				    						<td GH="100 STD_CAROPT" GCol="select,CAROPT">
												<select class="input" CommonCombo="CAROPT"></select>
											</td>	<!--적재함 구분-->
				    						<td GH="120 STD_CARSTS" GCol="select,CARSTS">
				    							<select class="input" CommonCombo="CARSTS"></select>
				    						</td>	<!--차량 상태-->
				    						<td GH="150 STD_CARGBN" GCol="select,CARGBN">
				    							<select class="input" CommonCombo="CARGBN"></select>
				    						</td>	<!--차량 구분-->
				    						<td GH="120 STD_CARTMP" GCol="select,CARTMP" >
				    							<select class="input" CommonCombo="CARTMP"></select>
				    						</td>	<!--차량 온도-->
				    						<td GH="50 STD_DELMAK" GCol="check,DELMAK">미사용</td>	<!--미사용-->
				    						<td GH="86 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
				    						<td GH="70 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
				    						<td GH="50 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
				    						<td GH="86 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
				    						<td GH="70 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
				    						<td GH="50 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="btn_lit tableUtil">
							<button type='button' GBtn="find"></button>
							<button type='button' GBtn="sortReset"></button>
							<button type='button' GBtn="add"></button>
							<button type='button' GBtn="copy"></button>
							<button type='button' GBtn="delete"></button>
							<button type='button' GBtn="total"></button>
							<button type='button' GBtn="layout"></button>
							<button type='button' GBtn="excel"></button>
							<button type='button' GBtn="saveLayout"></button>
							<button type='button' GBtn="getLayout"></button>
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
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