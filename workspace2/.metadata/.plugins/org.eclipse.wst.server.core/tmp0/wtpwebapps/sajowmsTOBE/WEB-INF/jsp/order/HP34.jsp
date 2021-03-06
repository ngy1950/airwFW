<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HP34</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "Report",
			command : "HP34"
	    });
		
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });
			
			//콤보박스 리드온리 출력여부 
			gridList.setReadOnly("gridList", true, ["SAMPKY", "WAREKY", "DPTNNM", "ADDR01"]);
		}
	}
	
	//생성
	function create(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea")
			param.put("WAREKY", $("#WAREKY").val());
			param.put("BOXQTY", 0)
			param.put("SAMQTY", 0)
			
			gridList.resetGrid("gridList");
			gridList.setAddRow("gridList", null);
			//콤보박스 리드온리 출력여부 
			gridList.setReadOnly("gridList", false, ["SAMPKY", "WAREKY", "DPTNNM", "ADDR01"]);
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Create"){ //생성 
			create();
		}else if(btnName == "Save"){ //저장
			saveData();	
		}else if(btnName == "Spprint"){ //증정품 출력
			check = "1";
			print();
		}else if(btnName == "SpprintAll"){ //인쇄(전체)
			check = "2";
			print();
		}else if(btnName == "Sppicking"){ //피킹리스트인쇄
			check = "3";
			print();
		}else if(btnName == "Print1"){ //인쇄(속도개선)
			check = "4";
			print();
			
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "HP34");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "HP34");
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
	

    function gridListEventRowAddBefore(gridId, rowNum) {
    	if(gridId == 'gridList'){
            var newData = new DataMap();
            newData.put("COMPKY","<%=compky%>");
            newData.put("WAREKY","<%=wareky %>");
            return newData;
    	}
    }
    
  //콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅), 인쇄 옵션
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "101");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "OPTION"){
				param.put("CMCDKY", "PRINTKY");	
			}else if(name == "OPTION2"){
				param.put("CMCDKY", "OPTION");	
			}
			
		}else if(comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");			
			return param;
		}
		return param;
	}
  
	function saveData(){
		if(gridList.validationCheck("gridList", "all")){
			var list = gridList.getModifyList("gridList", "A")
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			var param = dataBind.paramData("searchArea");
			var param = new DataMap();
			param.put("list",list);
			param.put("WAREKY", $("#WAREKY").val());
			
			//유효성검사
// 			for(var i=0; i<list.length; i++){
// 				var gridMap = list[i].map;
// 				if (gridList.getColData("gridList1", list[i].get("GRowNum"), "SKUKEY").trim() == "" || gridList.getColData("gridList1", list[i].get("GRowNum"), "SKUKEY").trim() == null){
// 					commonUtil.msgBox("* 제품코드를 입력해주세요. *");
// 					return;
			
// 				}else if (gridList.getColData("gridList1", list[i].get("GRowNum"), "LABEL").trim() == "" || gridList.getColData("gridList1", list[i].get("GRowNum"), "LABEL").trim() == null){
// 					commonUtil.msgBox("* 라벨을 선택해주세요. *");
// 					return;
// 				}	
// 			}
			
			//저장하시겠습니까?
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ 
				return;
			}
			
			netUtil.send({
				url : "/Report/json/saveHP34.data",
				param : param,
				successFunction : "successSaveCallBack",
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function print(){
		if(gridList.validationCheck("gridList", "select")){ //체크된 ROW가 있는지 확인
			var list = gridList.getSelectData("gridList", true);
			//체크가 없을 경우 
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var where = " AND SAMPKY IN (";
			var sampky = "";
			
			for(var i =0;i < list.length ; i++){
				where += "'" + list[i].get("SAMPKY") + "'";
				if(i+1 < list.length){
					where += ",";
				}
			}
			where += ")";
			
			var langKy = "KO";
			var width = 840;
			var height = 620;
			var map = new DataMap();

			if( check == "1" || check == "2" ){ //증정품 출력
				map.put("i_option",$('#OPTION').val());
				var orderbystr = $("#WAREKY").val();
				WriteEZgenElement("/ezgen/samplist.ezg" , where , "" , langKy, map , width , height, orderbystr );
			}else if( check == "3" ){ //피킹리스트 인쇄
				WriteEZgenElement("/ezgen/sample_picking.ezg" , where , "" , langKy, map , 600 , 400 );	
				
			}else if( check == "4" ){ //인쇄(속도개선)
				map.put("i_option",$('#OPTION2').val());
				WriteEZgenElement("/ezgen/sample_list.ezg" , where , "" , langKy, map , width , height );
				
			}
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
					<input type="button" CB="Create ADD BTN_NEW" /> <!-- 생성 create-->
					<input type="button" CB="Save SAVE BTN_SAVE" />
					<input type="button" CB="Spprint PRINT_OUT BTN_SPPRINT" /> <!-- 증정품 출력 -->
					<input type="button" CB="SpprintAll PRINT_OUT BTN_PRINT_ALL" /> <!-- 인쇄(전체) -->
					<input type="button" CB="Sppicking PRINT_OUT BTN_PRINT_PKLIST" /> <!-- 피킹리스트인쇄 -->
					<input type="button" CB="Print1 PRINT_OUT BTN_SPDPRT" /> <!-- 인쇄(속도개선)-->
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl> <!-- 화주 -->
						<dt CL="STD_OWNRKY"></dt> 
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl> <!-- 거점 -->
						<dt CL="STD_WAREKY"></dt> 
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>  <!--주문번호-->  
						<dt CL="STD_SAMPKY"></dt>
						<dd> 
							<input type="text" class="input" name="SAMPKY" UIInput="SR"/> 
						</dd> 
					</dl> 
		            <dl>  <!--출고일자-->  
		              <dt CL="STD_WADAT"></dt>
		              <dd> 
		                <input type="text" class="input" name="CARDAT" UIInput="B" UIFormat="C N"/> 
		              </dd> 
		            </dl>
		            <dl>  <!--공급받는자-->  
		              <dt CL="STD_DPTNNM"></dt> 
		              <dd> 
		                  <select class="input" name="DPTNNM" UIInput="SR"></select> 
		              </dd> 
		            </dl>
		            <dl>  <!--제품명-->  
		              <dt CL="STD_DESC01"></dt> 
		              <dd> 
		                  <select class="input" name="DESC01" UIInput="SR"></select> 
		              </dd> 
		            </dl> 
		            <dl>  <!--차량번호-->  
		              <dt CL="STD_CARNUM"></dt> 
		              <dd> 
		                  <select class="input" name="CARNUM" UIInput="SR"></select> 
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
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"><span CL="STD_PRINTOPT1" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;">   </span>
						<select name="OPTION" id="OPTION"  class="input" Combo="SajoCommon,CMCDV_COMBO" ComboCodeView="true"></select></li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"><span CL="STD_PRINTOPT2" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;">   </span>
						<select name="OPTION2" id="OPTION2"  class="input" Combo="SajoCommon,CMCDV_COMBO" ComboCodeView="true"></select></li>
						<li class="btn_zoom_wrap">
							<ul>
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
			    						<td GH="40 STD_NUMBER" GCol="rownum">1</td>
			    						<td GH="40" GCol="rowCheck"></td>  
			    						<td GH="100 STD_SAMPKY" GCol="input,SAMPKY" GF="S 10">주문번호</td><!--주문번호-->  
									    <td GH="60 HP_SAMSEQ" GCol="text,SAMSEQ" >SEQ</td><!--SEQ--> 
									    <td GH="0 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td><!--SEQ--> 
									    <td GH="200 STD_DPTNNM" GCol="input,DPTNNM" GF="S 30">공급받는자</td><!--공급받는자--> 
									    <td GH="260 STD_ADDR01N" GCol="input,ADDR01" GF="S 50">배송주소</td><!--배송주소--> 
									    <td GH="100 HP_TELN01" GCol="input,TELN01" GF="S 30">연락처</td><!--연락처--> 
									    <td GH="80 STD_CARDAT2" GCol="input,CARDAT" GF="C">출고일</td><!--출고일--> 
									    <td GH="100 STD_CARNUM" GCol="input,CARNUM" GF="S 30">차량번호</td><!--차량번호--> 
									    <td GH="200 STD_DESC01" GCol="input,DESC01" GF="S 100">품명</td><!--품명--> 
									    <td GH="80 HP_BOXQTY" GCol="input,BOXQTY" GF="N 30,1">수량(BOX)</td><!--수량(BOX)--> 
									    <td GH="80 HP_SAMQTY" GCol="input,SAMQTY" GF="N 30,0">수량(EA)</td><!--수량(EA)--> 
									    <td GH="100 STD_TEXT01" GCol="input,TEXT01" GF="S 80">비고</td><!--비고--> 
									    <td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td><!--생성일자--> 
									    <td GH="60 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td><!--생성자--> 
									    <td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td><!--수정일자--> 
									    <td GH="60 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td><!--수정자-->
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
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
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