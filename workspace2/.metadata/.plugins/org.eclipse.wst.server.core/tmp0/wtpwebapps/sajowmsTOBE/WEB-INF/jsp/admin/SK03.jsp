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
	    	pkcol : "OWNRKY,SKUKEY",
			command : "SK03",
			menuId : "SK03"
	    });

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
				url : "/master/json/saveSK03.data",
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

	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "SK03");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "SK03");
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
			
		
		var newData = new DataMap();
			newData.put("OWNRKY",$('#OWNRKY').val());
		return newData;
	}
	
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
				
		if(searchCode == "SHSKUMA2" && !multyType){
			shrow = rowNum;
			var name = $inputObj.name;
			var param = new DataMap();
				param.put("OWNRKY",gridList.getColData("gridList", rowNum, "OWNRKY"));
			return param;
		}
		
	}
	
	//서치헬프 종료 이벤트
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		if( searchCode == "SHSKUMA2" && !multyType){
			
			var gridId = "gridList"
			gridList.setColValue(gridId, shrow, "SKUKEY", rowData.get("SKUKEY") );
			gridList.setColValue(gridId, shrow, "DESC01", rowData.get("DESC01") );
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
					
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="PT.SKUKEY" UIInput="SR,SHSKUMA2"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--구제품코드-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.DESC01" UIInput="SR"/> 
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
											<td GH="0 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    						<td GH="100 STD_SKUKEY" GCol="input,SKUKEY,SHSKUMA2" GF="S 10">제품코드</td>	<!--제품코드-->
				    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 100">제품명</td>	<!--제품명-->
				    						<td GH="120 STD_PTPTWIDQTY" GCol="input,WIDQTY" GF="N 6,0">팔레트 가로수량</td>	<!--팔레트 가로수량-->
				    						<td GH="120 STD_PTPTLENQTY" GCol="input,LENQTY" GF="N 6,0">팔레트 세로수량</td>	<!--팔레트 세로수량-->
				    						<td GH="120 STD_PTPTADDQTY" GCol="input,ADDQTY" GF="N 6,0">팔레트 추가수량</td>	<!--팔레트 추가수량-->
				    						<td GH="120 STD_PTPTHEIQTY" GCol="input,HEIQTY" GF="N 6,0">팔레트 높이수량</td>	<!--팔레트 높이수량-->
				    						<td GH="120 STD_PTPTGRSQTY" GCol="text,GRSQTY" GF="N 10,0">팔레트당 포장수량</td>	<!--팔레트당 포장수량-->
				    						<td GH="120 STD_PTPTREMQTY" GCol="input,REMQTY" GF="N 10,0">팔레트당 낱개수량</td>	<!--팔레트당 낱개수량-->
				    						<td GH="100 STD_PTPTPLTWGT" GCol="input,PLTWGT" GF="N 10,0">팔레트 중량</td>	<!--팔레트 중량-->
				    						<td GH="50 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td>	<!--생성일자-->
				    						<td GH="50 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td>	<!--생성시간-->
				    						<td GH="50 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td>	<!--생성자-->
				    						<td GH="50 STD_LMODAT" GCol="text,LMODAT" GF="D 10">수정일자</td>	<!--수정일자-->
				    						<td GH="50 STD_LMOTIM" GCol="text,LMOTIM" GF="T 10">수정시간</td>	<!--수정시간-->
				    						<td GH="50 STD_LMOUSR" GCol="text,LMOUSR" GF="S 10">수정자</td>	<!--수정자-->
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
<!-- 							<button type='button' GBtn="delete"></button> -->
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