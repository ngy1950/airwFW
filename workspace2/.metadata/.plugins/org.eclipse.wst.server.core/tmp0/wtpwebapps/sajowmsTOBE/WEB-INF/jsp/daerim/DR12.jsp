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
			module : "DaerimDAS",
			command : "DR12",
			pkcol : "DASTYP,CELLNO,PTNRKY",
		    menuId : "DR12"
	    });

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
			sajoUtil.openSaveVariantPop("searchArea", "DR12");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DR12");
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

		if(gridList.validationCheck("gridList", "modify")){
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
				url : "/daerimDASController/json/saveDR12.data",
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

	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridList"){
			if(colName == "PTNRKY"){
				//업체코드에 따라 업체명 자동 입력
				var param = new DataMap();
				param.put("OWNRKY", "2200");
				param.put("PTNRTY", "0007");
				param.put("PTNRKY", colValue);

				var json = netUtil.sendData({
					module : "SajoCommon",
					command : "BZPTN_DATA",
					param : param,
				});
				
				//가져온 업체 데이터가 있다면 적용
				if(json.data && json.data.length > 0){
				  	gridList.setColValue(gridId, rowNum, "PTNRNM", json.data[0].PTNRNM);
				}else{//업체코드가 유효하지 않다면 경고 메시지 후 ptnrky 초기화
					commonUtil.msgBox("INV_M0064");
				  	gridList.setColValue(gridId, rowNum, "PTNRKY", "");
				}
			}
		}
	}
	
	//ADD 클릭시
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
		//기본값 세팅 
		newData.put("DASTYP",$('#DASTYP').val());
		newData.put("CELTYP","01");//01 기본
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
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if(searchCode == "SHBZPTN"){
            param.put("OWNRKY","2200");
            param.put("PTNRTY","0007");
        }
    	return param;
    }
	
	//서치헬프 리턴 
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		console.log(searchCode + '/'+ multyType + '/' + selectData + "/" + rowData);
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
						<dl>
							<dt CL="STD_DASTYPE"></dt>
							<dd>
								<select name="DASTYP" id="DASTYP" class="input"
									Combo="SajoCommon,CMCDV_COMBO" ComboCodeView="true" validate="required(STD_DASTYPE)"></select>
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
				    						<td GH="80 STD_DASTYP" GCol="select,DASTYP"  validate="required">	<!--DAS유형-->
												<select class="input" Combo="SajoCommon,CMCDV_COMBO">
													<option></option>
												</select>
				    						</td>
				    						<td GH="80 STD_CELLNO" GCol="input,CELLNO" GF="S 20"  validate="required">셀번호</td>	<!--셀번호-->
				    						<td GH="90 STD_PTNRKY" GCol="input,PTNRKY,SHBZPTN" UI GF="S 20"  validate="required">업체코드</td>	<!--업체코드-->
				    						<td GH="90 STD_PTNRNM" GCol="text,PTNRNM" GF="S 20">거래처명</td>	<!--거래처명-->
				    						<td GH="150 STD_TEXT01" GCol="input,TEXT01" GF="S 100">비고</td>	<!--비고-->
				    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 20">생성일자</td>	<!--생성일자-->
				    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 20">생성시간</td>	<!--생성시간-->
				    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
				    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 20">수정일자</td>	<!--수정일자-->
				    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 20">수정시간</td>	<!--수정시간-->
				    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
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