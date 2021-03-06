
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LB03</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
			module : "LabelPrint",
			command : "LB03",
			menuId : "LB03"
	    });
				
		//ReadOnly 설정(그리드 전체 권한 막기)
		gridList.setReadOnly("gridList",true,["DELMAK", "PTNRTY"])

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
				param.put("NORMAL","Y");

			gridList.gridList({
		    	id : "gridList",
		    	param : param
		    });				
		}
	}
	
	function gridListEventRowAddBefore(gridId, rowNum){
		var newData = new DataMap();
 		newData.put("OWNER","OWNRKY");		
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
			print();

		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "LB03");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "LB03");
 		}
	}
	
	
	//ezgen 업체 바코드 인쇄 
 	function print(){

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
					where = "AND OWNRKY = '" + head[i].get("OWNRKY") + "' AND PTNRKY IN (";
				}else{
					where = where+",";
				}
				
				where += "'" + head[i].get("PTNRKY") + "'";
			}
			where += ")";
			
 			//이지젠 호출부(신버전)
 			var langKy = "KO";
 			var map = new DataMap();
 			var width = 640;
 			var height = 300;
 			WriteEZgenElement("/ezgen/bzptn.ezg" , where , "" , langKy, map , width , height );	
 			
 		}
	}	
	
 	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        //업체코드
        if(searchCode == "SHBZPTN" && $inputObj.name == "PTNRKY"){
        	param.put("OWNRKY","<%=ownrky %>");
        	param.put("PTNRTY","0002");
		}
    	return param;
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
					<input type="button" CB="Print PRINT_OUT BTN_PRINT_BZ01" />
				</div>
			</div>
			<div class="search_inner"> <!-- LB03 업체 바코드 라벨 --> 
				<div class="search_wrap" > 
					<dl>
						<dt CL="STD_OWNRKY"></dt> <!-- 화주 -->
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" validate="required(STD_OWNRKY)"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_PTNRKY"></dt> <!-- 업체코드 -->
						<dd>
							<input type="text" class="input" name="PTNRKY" id="PTNRKY" UIInput="SR,SHBZPTN"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_PTNRTY"></dt> <!-- 업체타입 -->
						<dd>
							<input type="text" class="input" name="PTNRTY" id="PTNRTY" UIInput="SR,SHVPTNT"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_NAME01"></dt> <!-- 업체명 -->
						<dd>
							<input type="text" class="input" id="NAME01" name="NAME01" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_EXPTNK"></dt> <!-- 권역코드 -->
						<dd>
							<input type="text" class="input" name="EXPTNK" id="EXPTNK" UIInput="SR"/>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DELMAK"></dt>
						<dd>
							<input type="checkbox" name="DELMAK"/>
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
				</ul>
				<div class="table_box section" id="tab1-1">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridList">
									<tr CGRow="true"> 
										<td GH="40" GCol="rowCheck" ></td>
										<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 20">화주</td> <!--화주-->
										<td GH="80 STD_PTNRKY" GCol="text,PTNRKY" GF="S 20">업체코드</td> <!--업체코드-->
										
										<td GH="100 STD_PTNRTY"  GCol="select,PTNRTY"> 	<!--업체타입-->
											<select class="input" CommonCombo="PTNRTY"></select>
										</td>
										
										<td GH="50 STD_DELMAK" GCol="check,DELMAK">삭제</td> <!--삭제-->
										<td GH="120 STD_DPTNKYNM" GCol="text,NAME01" GF="S 180">업체명</td> <!--업체명-->
										<td GH="80 STD_NAME02" GCol="text,NAME02" GF="S 180">대표자이름</td> <!--대표자이름-->
										<td GH="100 STD_ADDR01" GCol="text,ADDR01" GF="S 180">주소</td> <!--주소-->
										<td GH="50 STD_ADDR02" GCol="text,ADDR02" GF="S 180">납품주소</td> <!--납품주소-->
										<td GH="50 STD_ADDR05" GCol="text,ADDR05" GF="S 200">도착지</td> <!--도착지-->
										<td GH="50 STD_POSTCD" GCol="text,POSTCD" GF="S 30">우편번호  </td> <!--우편번호  -->
										<td GH="80 STD_TELN01" GCol="text,TELN01" GF="S 50">전화번호1</td> <!--전화번호1-->
										<td GH="80 STD_TELN02" GCol="text,TELN02" GF="S 50">전화번호2</td> <!--전화번호2-->
										<td GH="50 STD_FAXTL1" GCol="text,FAXTL1" GF="S 20">팩스번호 </td> <!--팩스번호 -->
										<td GH="120 STD_VATREG" GCol="text,VATREG" GF="S 20">사업자등록번호</td> <!--사업자등록번호-->
										<td GH="50 STD_EMAIL1" GCol="text,EMAIL1" GF="S 120">이메일</td> <!--이메일-->
										<td GH="50 STD_EMAIL2" GCol="text,EMAIL2" GF="S 120">이메일2</td> <!--이메일2-->
										<td GH="80 STD_CTTN01" GCol="text,CTTN01" GF="S 120">거래처 담당자명</td> <!--거래처 담당자명-->
										<td GH="80 STD_CTTT01" GCol="text,CTTT01" GF="S 20">거래처 담당자 휴대폰 번호1</td> <!--거래처 담당자 휴대폰 번호1-->
										<td GH="80 STD_CTTT02" GCol="text,CTTT02" GF="S 20">거래처 담당자 휴대폰 번호2</td> <!--거래처 담당자 휴대폰 번호2-->
										<td GH="80 STD_CTTM01" GCol="text,CTTM01" GF="S 60">거래처담당자 email주소</td> <!--거래처담당자 email주소-->
										<td GH="80 STD_SALN01" GCol="text,SALN01" GF="S 120">영업 담당자명</td> <!--영업 담당자명-->
										<td GH="80 STD_SALT01" GCol="text,SALT01" GF="S 20">영업 담당자 휴대폰번호 1</td> <!--영업 담당자 휴대폰번호 1-->
										<td GH="80 STD_SALT02" GCol="text,SALT02" GF="S 20">영업 담당자 휴대폰번호 2</td> <!--영업 담당자 휴대폰번호 2-->
										<td GH="80 STD_SALM01" GCol="text,SALM01" GF="S 60">영업 담당자 email주소</td> <!--영업 담당자 email주소-->
										<td GH="50 STD_EXPTNK" GCol="text,EXPTNK" GF="S 20">권역코드</td> <!--권역코드-->
										<td GH="50 STD_CUSTMR" GCol="text,CUSTMR" GF="S 10">거래처상태</td> <!--거래처상태-->
										<td GH="50 STD_PTNG01" GCol="text,PTNG01" GF="S 20">유통경로1</td> <!--유통경로1-->
										<td GH="50 STD_PTNG02" GCol="text,PTNG02" GF="S 20">유통경로2</td> <!--유통경로2-->
										<td GH="50 STD_PTNG03" GCol="text,PTNG03" GF="S 20">유통경로3</td> <!--유통경로3-->
										<td GH="50 STD_PTNG04" GCol="text,PTNG04" GF="S 20">유통경로4</td> <!--유통경로4-->
										<td GH="50 STD_PTNG05" GCol="text,PTNG05" GF="S 20">지점사업장</td> <!--지점사업장-->
										<td GH="80 STD_PTNG06" GCol="text,PTNG06" GF="S 20">업태</td> <!--업태-->
										<td GH="80 STD_PTNG07" GCol="text,PTNG07" GF="S 20">업종</td> <!--업종-->
										<td GH="80 STD_FORKYN" GCol="text,FORKYN" GF="S 1">지게차사용여부</td> <!--지게차사용여부-->
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