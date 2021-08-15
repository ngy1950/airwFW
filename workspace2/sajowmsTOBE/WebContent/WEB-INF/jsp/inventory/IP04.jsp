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
var reparam = new DataMap();
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Inventory",
	    	itemGrid : "gridItemList",
	    	itemSearch : true,
			command : "IP04_HEAD",
		    menuId : "IP04"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Inventory",
			command : "IP04_ITEM",
		    menuId : "IP04"
	    });
		
		// 콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["PHSCTY"]);
		gridList.setReadOnly("gridItemList", true, ["LOTA06"]);	
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});

	
	function searchList(){
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			var param = inputList.setRangeDataParam("searchArea");
			param.put("PHSCTY","551");
			param.put("CREUSR", "<%=userid%>");
			
			reparam = new DataMap();
			uiList.setActive("Save",true);
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function reSearchList(json){
		if(validate.check("searchArea")){
			reparam = inputList.setRangeDataParam("searchArea");
			reparam.put("CREUSR", "<%=userid%>");
			reparam.put("PHYIKY",json.data["PHYIKY"]);
			reparam.put("WAREKY",json.data["WAREKY"]);
/* 			param.put("LOTNUM",json.data["LOTNUM"]);
			param.put("LOCAKY",json.data["LOCAKY"]);
			param.put("STOKKY",json.data["STOKKY"]); */	
			
			netUtil.send({
	    		module : "Inventory",
				command : "IP04_HEAD",
				bindType : "grid",
				sendType : "list",
				bindId : "gridHeadList",
		    	param : reparam
			});
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){

		if(!reparam.isEmpty()){ // [저장 시 저장 된 데이터를 보여주기 위해 분기 태움]
			var param = gridList.getRowData(gridId, rowNum);
			param.put("OWNRKY",$('#OWNRKY').val());
			param.put("USERID", "<%=userid%>");
			param.put("PHSCTY","551");
			gridList.gridList({
		    	id : "gridItemList",
		    	module : "Inventory",
				command : "GETIP09ILIST",
		    	param : reparam
		    });
		}else{
			var param = inputList.setRangeDataParam("searchArea");
			param.put("PHSCTY","551");
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		
		// 조사타입 및 조정사유코드 공통코드
		if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO" || comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "500");
			param.put("DOCUTY", "551");
			param.put("OWNRKY", $("#OWNRKY").val());
			
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			param.put("CMCDKY", "LOTA06");	
		}
		return param;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			//체크한 row중에 수정된 로우
			var item = gridList.getSelectData("gridItemList", true);
			if(head.length == 0 && item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			//item 저장불가 조건 체크
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if(itemMap.RSNADJ == ""){
					commonUtil.msgBox("조정사유코드를 입력해주세요.")
					return;
				}
				if(itemMap.QTSPHY < 0){
					commonUtil.msgBox("재고조사수량을 확인해주세요.");
					return;
				}		
				// 출고수량 체크
				if(itemMap.QTSHPD == 0){
					commonUtil.msgBox("출고수량을 입력해주세요.");
					return;
				}
				
				
			}

			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);
			param.put("OWNRKY",$("#OWNRKY").val());
			param.put("WAREKY",$("#WAREKY").val());
			param.put("INDDCL", "V");
			param.put("CREUSR", "<%=userid%>");
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {	// 저장하시겠습니까?
				return;	
			}
			
			netUtil.send({
				url : "/inventory/json/saveIP04.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				uiList.setActive("Save",false);
				reSearchList(json); 		
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "SetChk"){
			setChk();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "IP04");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "IP04");
		}
	}
	
	function setChk(){
		//인풋값 가져오기
		var rsnadj = $('#RSNADJCOMBO').val();

		if(rsnadj == ""){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}

		// 그리드에서 선택 된 값 가져오기
		var selectDataList = gridList.getSelectData("gridItemList", true);

		for(var i=0; i<selectDataList.length; i++){
			var qtsiwh = Number(gridList.getColData("gridItemList", selectDataList[i].get("GRowNum"), "QTSIWH")); // 재고조사수량
			var qtshpd = Number(gridList.getColData("gridItemList", selectDataList[i].get("GRowNum"), "QTSHPD")); // 츌고수량

			gridListEventColValueChange("gridItemList", selectDataList[i].get("GRowNum"), "QTSPHY", qtsiwh - qtshpd);
			// 재고조사수량이 없으면 안됨
			if(gridList.getColData("gridItemList", selectDataList[i].get("GRowNum"), "QTSPHY") == ''){
				commonUtil.msgBox("OUT_M0103"); // 재고조사수량이 없습니다. 띄어야 함
				return;
			}
			// 출고수량이 재고수량보다 많으면 안됨
			if(qtsiwh - qtshpd < 0){
				commonUtil.msgBox("OUT_M0103"); // 출고수량이 전산재고수량보다 많습니다. 띄어야 함
				return;
			}
			
			gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "QTSPHY", qtsiwh - qtshpd);  // 그리드에 재고조사수량 값 셋팅
			gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "RSNADJ", rsnadj);	// 그리드 조정사유코드 값 셋팅
		}
	}
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			 if(colName == "QTSPHY" || colName == "QTSHPD"){ //수량변경시연결된 수량 변경
				 var qtshpd = gridList.getColData(gridId, rowNum, "QTSHPD"); // 출고수량
				 var qtystl = gridList.getColData(gridId, rowNum, "QTYSTL"); // 전산재고
				 var qtadju = Number(gridList.getColData(gridId, rowNum, "QTSHPD")) * -1; // 조정수량
				 
				 if(parseInt(qtshpd) < 0){
					 commonUtil.msgBox("출고수량을 확인해주세요.");
					 return;
				 }
				 
				 if( parseInt(qtshpd) > parseInt(qtystl)){
					 commonUtil.msgBox("출고수량이 전산재고 수량보다 많습니다.");
					 gridList.setColValue("gridItemList", rowNum, "QTSHPD", 0);  // 그리드에 재고조사수량 값 셋팅
					 return;
				 }
				 
				 gridList.setColValue(gridId, rowNum, "QTSPHY", qtystl - qtshpd); // 재고조사수량 = 전산재고 - 출고수량
				 gridList.setColValue(gridId, rowNum, "QTADJU", qtadju); // 조정수량 셋팅
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
	
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
		if(searchCode == "SHLOTA03CM"){
            param.put("OWNRKY",$('#OWNRKY').val());
            param.put("PTNRTY","0001");
            
        }
        
    	return param;
    }
	
	function  gridListEventRowCheckAll(gridId, isCheck){
		if(gridId == "gridItemList"){
			var list = gridList.getSelectData(gridId);
			
			//선택 합계
			for(var i=0; i<list.length; i++){
				var data = list[i].map;
				
				// 재고조사수량 0입력 시 조정수량 계산
				if(data.QTSPHY == 0){
					gridListEventColValueChange(gridId, i, "QTSPHY", 0);
				}
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
					<input type="button" CB="Search SEARCH BTN_SEARCH" />
					<input type="button" CB="Save SAVE BTN_SAVE" />
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
				
					<!-- 화주 -->
					<dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required" ></select>
						</dd>
					</dl>
					
					<!-- 거점 -->
					<dl>
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" validate="required"></select>
						</dd>
					</dl>
					
					<!-- 로케이션 -->
					<dl>
						<dt CL="STD_LOCAKY"></dt>
						<dd>
							<input name="LOCAKY" id="LOCAKY" class="input" UIInput="SR,SHLOCMA" />
						</dd>
					</dl>
					
					<!-- 제품코드 -->
					<dl>  
						<dt CL="STD_SKUKEY"></dt>
						<dd>
							<input name="S.SKUKEY" id="S.SKUKEY" class="input" UIInput="SR,SHSKUMA" />
						</dd>
					</dl>
					
					<!-- 제품명 -->
					<dl>
						<dt CL="STD_DESC01"></dt>
						<dd>
							<input name="S.DESC01" id="S.DESC01" class="input" UIInput="SR" />
						</dd>
					</dl>

					<!-- 유통기한 -->
					<dl>
						<dt CL="STD_LOTA13"></dt>
						<dd>
							<input type="text" class="input" name="LOTA13" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					
					<!-- 입고일자 -->
					<dl>
						<dt CL="STD_LOTA12"></dt>
						<dd>
							<input type="text" class="input" name="LOTA12" UIInput="R" UIFormat="C" PGroup="G1,G2"/>
						</dd>
					</dl>
					
					<!-- 벤더 -->
					<dl>
						<dt CL="STD_LOTA03"></dt>
						<dd>
							<input type="text" class="input" name="LOTA03" UIInput="SR,SHLOTA03CM" />
						</dd>
					</dl>
					
					<!-- 포장구분 -->
					<dl>
						<dt CL="STD_LOTA05"></dt>
						<dd>
							<input type="text" class="input" name="LOTA05" UIInput="SR,SHLOTA05" />
						</dd>
					</dl>
					
					<!-- 재고유형 -->
					<dl>
						<dt CL="STD_LOTA06"></dt>
						<dd>
							<input type="text" class="input" name="LOTA06" UIInput="SR,SHLOTA06" value="20" />
						</dd>
					</dl>
					
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs top_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>일반</span></a></li>
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
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
								        <td GH="100 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호</td> <!--재고조사번호-->
								        <td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
								        <td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="S 10"></td> <!--문서 유형-->  
								        <td GH="120 STD_PHSCTY" GCol="select,PHSCTY" > <!--조사타입--> 
											<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO">
												<option></option>
											</select>
								        </td> 
								        <td GH="80 STD_DOCDAT" GCol="input,DOCDAT" GF="C">문서일자</td> <!--문서일자--> 	        
								        <td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td> <!--생성일자-->
								        <td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td> <!--생성시간-->
								        <td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td> <!--생성자-->
								        <td GH="80 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td> <!--비고-->
									</tr>
								</tbody>
							</table>
						</div> 
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
						<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
			</div>
			<div class="content_layout tabs bottom_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
						<span CL="STD_RSNADJ" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<select name="RSNADJCOMBO" id="RSNADJCOMBO"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true"><option></option></select>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
						<input type="button" CB="SetChk SAVE BTN_PART" />
					</li>
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true"> 
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="90 STD_LOCAKY" GCol="text,LOCAKY" GF="S 10">로케이션</td>
			    						<td GH="70 STD_SKUKEY" GCol="text,SKUKEY" GF="S 10" validate="required">제품코드</td>
										<td GH="140 STD_DESC01" GCol="text,DESC01" GF="S 10">제품명</td>
										<td GH="80 STD_QTSPHY" GCol="text,QTSPHY" GF="N20,0" validate="required" >재고조사수량</td>
										<td GH="60 STD_QTADJU" GCol="text,QTADJU" GF="N,20,0">조정수량</td>
										<td GH="60 STD_QTYSTL" GCol="text,QTYSTL" GF="N,20,0">전산재고</td>
										<td GH="60 STD_QTSHPD" GCol="input,QTSHPD" GF="N,20,0">출고수량</td>
										<td GH="140 STD_RSNADJ" GCol="select,RSNADJ" validate="required">
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option></option>
											</select>
										</td> 
										<td GH="120 STD_LOTA06" GCol="select,LOTA06" >
											<select class="input" Combo="SajoCommon,CMCDV_COMBO">
												<option></option>
											</select>
										</td>
										<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="C">제조일자</td>
										<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="C">유통기한</td>
										<td GH="60 STD_DUOMKY" GCol="text,DUOMKY" GF="S 10">단위</td>
										<td GH="60 STD_QTDUOM" GCol="text,QTDUOM" GF="S 10">입수</td>
										<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="C">입고일자</td>
										<td GH="60 STD_DESC02" GCol="text,DESC02" GF="S 10">규격</td>
										<td GH="100 STD_PHYIKY" GCol="text,PHYIKY" GF="S 10">재고조사번호 </td>
										<td GH="80 STD_PHYIIT" GCol="text,PHYIIT" GF="S 10">재고조사item</td>
										<td GH="60 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>
										<td GH="60 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>
										<td GH="60 STD_QTSIWH" GCol="text,QTSIWH" GF="N">재고수량</td>
			    						<td GH="60 STD_USEQTY" GCol="text,USEQTY" GF="N">가용수량</td>
										<td GH="60 STD_QTSALO" GCol="text,QTSALO" GF="N">할당수량</td>
										<td GH="60 STD_QTSPMI" GCol="text,QTSPMI" GF="N">입고중</td>
										<td GH="60 STD_QTSPMO" GCol="text,QTSPMO" GF="N">이동중</td>
										<td GH="60 STD_QTSBLK" GCol="text,QTSBLK" GF="N">보류수량</td>
										<td GH="90 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>
										<!-- <td GH="60 STD_ENDCK" GCol="text,ENDCK" GF="S 10">완료</td> -->
									</tr>
								</tbody> 
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="total"></button>
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