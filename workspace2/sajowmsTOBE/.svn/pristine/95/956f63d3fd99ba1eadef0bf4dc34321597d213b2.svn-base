
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LB02</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "LabelPrint",
			command : "LB02",
			menuId : "LB02"
	    });

		//ReadOnly 설정(그리드 전체 권한 막기)
		gridList.setReadOnly("gridList",true,["LOCATY","INDCPC","INDUPA","INDUPK","STATUS"]);
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
		$("#WAREKY").val("<%=wareky%>");
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
	
	
		
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] > 0){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				gridList.resetGrid("gridList");
			}
		}
	}
	
	//row 더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}	 
		
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print"){
			print("small");
			
		}else if(btnName == "Print2"){
			print("open");
		
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "LB02");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "LB02");
 		}
	}
	
	//ezgen 로케이션 바코드 인쇄 
 	function print(gbn){

		if(gridList.validationCheck("gridList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var where = "" ;
			// 반복문을 돌리며 특정검색조건을 생성한다.
			for(var i =0;i < head.length ; i++){
				
				if(where == ""){
					where = "AND WAREKY = '" + head[i].get("WAREKY") + "' AND LOCAKY IN (";
				}else{
					where = where+",";
				}
				
				where += "'" + head[i].get("LOCAKY") + "'";
			}
			where += ")";
			
 			//이지젠 호출부(신버전)
 			var langKy = "KO";
 			var map = new DataMap();
 			var width = 640;
 			var height = 300;
 			if(gbn == "small"){
 				WriteEZgenElement("/ezgen/locba_s.ezg" , where , "" , langKy, map , width , height );	
 			}else if(gbn == "open"){
 				WriteEZgenElement("/ezgen/locba_s_1.ezg" , where , "" , langKy, map , width , height );
 			}
				
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

		
	
</script>
</head>
<body>
<%@ include file="/common/include/webdek/layout.jsp" %>
<!-- content -->
<div class="content_wrap">
	<div class="content_inner" style="padding: 5px 30px 55px;">
		<%@ include file="/common/include/webdek/title.jsp" %>
		<div class="content_serch" id="searchArea">
			<div class="btn_wrap">
				<div class="fl_l">
					<input type="button" CB="Getvariant POPUP BTN_GETVARIANT" />
					<input type="button" CB="Savevariant POPUP BTN_SAVEVARIANT" />
				</div>
				<div class="fl_r">
					<input type="button" CB="Search SEARCH STD_SEARCH" />
				</div>
			</div>
			<div class="search_inner"> <!-- LB02 로케이션 바코드 라벨 --> 
				<div class="search_wrap" > 
					<dl>
						<dt CL="STD_WAREKY"></dt> <!-- 거점 -->
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" Combo="SajoCommon,WAREKY_COMCOMBO" ComboCodeView="false" validate="required(STD_WAREKY)">
							</select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_AREAKY"></dt> <!-- 동 -->
						<dd>
							<input type="text" class="input" name="AREAKY" id="AREAKY" UIInput="SR,SHAREMA" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ZONEKY"></dt> <!-- 존 -->
						<dd>
							<input type="text" class="input" name="ZONEKY" id="ZONEKY" UIInput="SR,SHZONMA" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_TKZONE"></dt> <!-- 작업구역 -->
						<dd>
							<input type="text" class="input" id="TKZONE" name="TKZONE" UIInput="SR,SHZONMA"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOCAKY"></dt> <!-- 로케이션 -->
						<dd>
							<input type="text" class="input" name="LOCAKY" id="LOCAKY" UIInput="SR,SHLOCMA"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_LOCATY"></dt> <!-- 로케이션 유형-->
						<dd>
							<select name="LOCATY" id="LOCATY" class="input" CommonCombo="LOCATY">
								<option value="" selected>ALL</option>
							</select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_STATUS"></dt> <!-- 상태 -->
						<dd>
							<select name="STATUS" id="STATUS" class="input" CommonCombo="STATUS">
								<option value="" selected>ALL</option>
							</select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_INDUPA"></dt> <!-- 입고가능 -->
						<dd>
							<input type="checkbox" class="input" name="INDUPA" id="INDUPA" style="margin-top:0";/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_INDUPK"></dt> <!-- 피킹가능 -->
						<dd>
							<input type="checkbox" class="input" name="INDUPK" id="INDUPK" style="margin-top:0";/>
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
					<li><a href="#tab1-1" ><span>일반</span></a></li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING:0 10PX"> <!-- 인쇄 -->
						<input type="button" CB="Print PRINT_OUT BTN_PNTLOCSL" style="VERTICAL-ALIGN: MIDDLE;"/> 
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle";> <!-- 안성물류 인쇄 -->
						<input type="button" CB="Print2 PRINT_OUT BTN_PRINT_OPEN" style="VERTICAL-ALIGN: MIDDLE;"/> 
					</li>
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true"> 
										<td GH="40" GCol="rowCheck" ></td>
										<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="100 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
			    						
			    						<td GH="100 STD_LOCATY"  GCol="select,LOCATY"> 	<!--로케이션유형-->
											<select class="input" CommonCombo="LOCATY"></select>
										</td>
										
			    						<td GH="80 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="120 STD_SHORTX" GCol="text,SHORTX" GF="S 60">설명</td>	<!--설명-->
			    						<td GH="80 STD_ZONEKY" GCol="text,ZONEKY" GF="S 10">존</td>	<!--존-->
			    						<td GH="80 STD_TKZONE" GCol="text,TKZONE" GF="S 10">작업구역</td>	<!--작업구역-->
			    						<td GH="50 STD_FACLTY" GCol="text,FACLTY" GF="S 10">동-층</td>	<!--동-층-->
			    						<td GH="50 STD_INDCPC" GCol="check,INDCPC">Capa체크</td>	<!--Capa체크-->
			    						<td GH="50 STD_OBROUT" GCol="text,OBROUT" GF="S 20">출고순서</td>	<!--출고순서-->
			    						
			    						<td GH="100 STD_STATUS"  GCol="select,STATUS"> 	<!--상태-->
											<select class="input" CommonCombo="STATUS"></select>
										</td>
										
			    						<td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="N 20,0">포장가로</td>	<!--포장가로-->
			    						<td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="N 20,0">포장세로</td>	<!--포장세로-->
			    						<td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="N 20,0">포장높이</td>	<!--포장높이-->
			    						<td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="N 20,0">CBM</td>	<!--CBM-->
			    						<td GH="88 STD_MAXCPC" GCol="text,MAXCPC" GF="N 20,0">Capa.(Max)</td>	<!--Capa.(Max)-->
			    						<td GH="80 STD_LOCSID" GCol="text,NEDSID" GF="S 20">로케이션담당자</td>	<!--로케이션담당자-->
			    						<td GH="50 STD_INDUPA" GCol="check,INDUPA">입고가능</td>	<!--입고가능-->
			    						<td GH="50 STD_INDUPK" GCol="check,INDUPK">피킹가능</td>	<!--피킹가능-->
			    						<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 250">비고</td>	<!--비고-->
<!-- 			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td>	생성일자 -->
<!-- 			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td>	생성시간 -->
<!-- 			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td>	생성자 -->
<!-- 			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 30">생성자명</td>	생성자명 -->
<!-- 			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 10">수정일자</td>	수정일자 -->
<!-- 			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 10">수정시간</td>	수정시간 -->
<!-- 			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 10">수정자</td>	수정자 -->
<!-- 			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 30">수정자명</td>	수정자명 -->
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
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>