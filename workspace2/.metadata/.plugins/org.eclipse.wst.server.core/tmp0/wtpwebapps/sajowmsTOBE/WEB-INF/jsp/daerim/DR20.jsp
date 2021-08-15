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
			module : "DaerimOutbound",
			command : "DR20",
			pkcol : "WAREKY,SKUKEY",
		    menuId : "DR20"
	    });
		

		gridList.setReadOnly("gridList", true, ["WAREKY" , "OWNRKY"]);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	//버튼 맵핑
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		} else if (btnName == "Save") {
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DR20");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DR20");
		}
	}
	
	//조회
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

	//저장
	function saveData() {
		
		// checkGridColValueDuple : pk중복값 체크
		if (gridList.validationCheck("gridList", "data")) {
			var list = gridList.getModifyList("gridList", "A");
			if (list.length == 0) {
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}

			var param = new DataMap();
			param.put("list", list);
			
	    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }

			netUtil.send({
				url : "/daerimOutbound/json/saveDR20.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}

	//저장완료 콜백
	function successSaveCallBack(json, status) {
		if (json && json.data) {
			if (json.data == "S") {
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("SYSTEM_SAVE_ERROR");
			}
		}
	}
	
	//ADD 클릭시
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		//기본값 세팅 
		newData.put("WAREKY",$('#WAREKY').val());
		newData.put("TRFTYP","010");
		return newData;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			param.put("CMCDKY", "DASTYP");
			param.put("USARG1", "<%=wareky %>");
		}
		
		return param;
	}
	

	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(colName == "SKUKEY"){
			
			var param = new DataMap();
			param.put("OWNRKY", $("#OWNRKY").val());
			param.put("SKUKEY", gridList.getColData(gridId, rowNum, colName));
			
			var json = netUtil.sendData({
				module : "SajoCommon",
				command : "SKUMA_GETDESC",
				sendType : "list",
				param : param
			}); 
			
			//sku가 있을 경우 
			if(json && json.data && json.data.length > 0 ){
				gridList.setColValue(gridId, rowNum, "DESC01", json.data[0].DESC01);
			}else{
				gridList.setColValue(gridId, rowNum, "SKUKEY", "");
			}
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if (searchCode == "SHSKUMAGD"){
            param.put("WAREKY",gridList.getColData("gridList", rowNum, "WAREKY"));
            param.put("OWNRKY",$("#OWNRKY").val());
        }
        
    	return param;
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
					</div>
				</div>
				<div class="search_inner">
					<div class="search_wrap ">
						<dl> <!--화주-->  
							<dt CL="STD_OWNRKY"></dt>
							<dd>
								<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
							</dd>
						</dl>
						<dl>
							<dt CL="STD_WAREKY"></dt>
							<dd>
								<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
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
				    						<td GH="140 STD_WAREKY" GCol="select,WAREKY">	<!--거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO">
													<option></option>
												</select> 
				    						</td>
				    						<td GH="70 STD_SKUKEY" GCol="input,SKUKEY,SHSKUMAGD" GF="S 20" validate="required">제품코드</td>	<!--제품코드-->
				    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 40">제품명</td>	<!--제품명-->
				    						<td GH="140 STD_TRFTYP" GCol="select,TRFTYP"  validate="required">	<!--이고품목유형-->
												<select class="input" commonCombo="TRFTYP">
													<option></option>
												</select> 
											</td>
				    						<td GH="150 STD_TEXT01" GCol="input,TEXT01" GF="S 100">비고</td>	<!--비고-->
				    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 20">생성일자</td>	<!--생성일자-->
				    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 20">생성시간</td>	<!--생성시간-->
				    						<td GH="60 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
				    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 20">수정일자</td>	<!--수정일자-->
				    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 20">수정시간</td>	<!--수정시간-->
				    						<td GH="60 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
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