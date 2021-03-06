<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>MW01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Master",
			command : "TR01",
			pkcol : "WAREKY",
			menuId : "TR01"
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
// 		newData.put("OWNER","OWNRKY");
		
		gridList.setColFocus(gridId, rowNum, "WAREKY");
		
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
				url : "/master/json/saveTR01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(parseInt(json.data["RESULT"] ) ==  "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}
		}
	}
	
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
		}else if(btnName == "Reload"){
			reloadLabel();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "TR01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "TR01");
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
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "110");
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
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if(!multyType){
        	var row = gridList.getRowData("gridList", rowNum);
        	
        	if(searchCode == "SHALSTH"){
        		param.put("WAREKY",row.get("WAREKY"));
        	}else if(searchCode == "SHDOCTM"){
        		param.put("DOCCAT","200");
        	}else if(searchCode == "SHDOCTM"){
        		param.put("OWNRKY",row.get("OWNRKY"));
        	}else if(searchCode == "SHWARESRC"){
        		param.put("OWNRKY",row.get("OWNRKY"));
        		param.put("PTNRTY","0003");
        	}else if(searchCode == "SHBZPTN"){
        		param.put("OWNRKY",row.get("OWNRKY"));
        	}else if(searchCode == "SHSHPMA"){
        		param.put("OWNRKY",row.get("OWNRKY"));
        	}
        }else{
        	if(searchCode == "SHWARESRC"){
        		param.put("PTNRTY","0003");
        	}
        }
        
    	return param;
    }
	

	
	//그리드 컬럼 값 변경시 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){

		if(colName == "CUSTMR"){ //거래처 변경시
			var param = new DataMap();
			param.put("PTNRKY", colValue);
			param.put("PTNRTY", "0001");
			param.put("OWNRKY", $("#OWNRKY").val());
			
			var json = netUtil.sendData({
				module : "Master",
				command : "TR01_PTNRKY",
				sendType : "list",
				param : param
			}); 
			
			//sku가 있을 경우 
			if(json && json.data && json.data.length > 0 ){
				gridList.setColValue(gridId, rowNum, "CUSTMR", json.data[0].PTNRKY);
				gridList.setColValue(gridId, rowNum, "CUSTMRNM", json.data[0].NAME01);

			}else{
				gridList.setColValue(gridId, rowNum, "CUSTMR", " ");
				gridList.setColValue(gridId, rowNum, "CUSTMRNM", " ");
			}
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
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap">
					<<dl>
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
					
					<dl>  <!--할당전략키-->  
						<dt CL="STD_ALSTKY"></dt> 
						<dd> 
							<input type="text" class="input" name="ALSTKY" UIInput="SR,SHALSTH"/> 
						</dd> 
					</dl>
					<dl>  <!--요청사업장-->  
						<dt CL="요청사업장"></dt> 
						<dd> 
							<input type="text" class="input" name="SLGORT" UIInput="SR,SHWARESRC"/> 
						</dd> 
					</dl>					
					<dl>  <!--국가키  -->  
						<dt CL="STD_NATNKY"></dt> 
						<dd> 
							<input type="text" class="input" name="NATNKY" UIInput="SR,SHVNATNKY"/> 
						</dd> 
					</dl> 
					<dl>  <!--거래처상태-->  
						<dt CL="STD_CUSTMR"></dt> 
						<dd> 
							<input type="text" class="input" name="CUSTMR" UIInput="SR,SHBZPTN"/> 
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
									<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
		    						<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
		    						<td GH="100 STD_ALSTKY" GCol="input,ALSTKY,SHALSTH" GF="S 12">할당전략키</td>	<!--할당전략키-->
		    						<td GH="200 STD_SHORTX" GCol="text,SHORTX" GF="S 60">설명</td>	<!--설명-->
		    						<td GH="100 STD_DPTNKY" GCol="input,CUSTMR,SHBZPTN" GF="S 10">업체코드</td>	<!--업체코드-->
		    						<td GH="100 STD_PTNRKYNM" GCol="text,CUSTMRNM" GF="S 10">거래처 명</td>	<!--거래처 명-->
		    						<td GH="100 STD_NATNKY" GCol="input,NATNKY,SHVNATNKY" GF="S 3">국가키  </td>	<!--국가키  -->
		    						<td GH="100 STD_NATNKYNM" GCol="text,NATNKYNM" GF="S 50">국가명</td>	<!--국가명-->
		    						<td GH="100 STD_DOCUTY" GCol="input,DOCUTY,SHDOCTM" GF="S 4">출고유형</td>	<!--출고유형-->
		    						<td GH="160 요청사업장" GCol="input,SLGORT,SHWARESRC" GF="S 20">요청사업장</td>	<!--요청사업장-->
		    						<td GH="160 주문구분" GCol="input,DIRSUP,VSHDIRSUP" GF="S 20">주문구분</td>	<!--주문구분-->
		    						<td GH="160 유통경로1"  GCol="select,PTNG02"> <!--유통경로1-->
											<select class="input" CommonCombo="PTNG02">
										</select>
									</td>
									<td GH="160 유통경로2"  GCol="select,PTNG03"> <!--유통경로2-->
										<select class="input" CommonCombo="PTNG03">
										</select>
									</td>
		    						<td GH="160 STD_EXPTNK" GCol="input,EXPTNK,SHSHPMA" GF="S 20">권역코드</td>	<!--권역코드-->
		    						<td GH="160 배송구분" GCol="input,DIRDVY" GF="S 20">배송구분</td>	<!--배송구분-->
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