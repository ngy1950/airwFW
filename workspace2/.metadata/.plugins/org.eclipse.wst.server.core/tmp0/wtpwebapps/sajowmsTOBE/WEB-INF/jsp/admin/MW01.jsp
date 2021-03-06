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
			command : "MW01",
			pkcol : "WAREKY",
			menuId : "MW01"
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
			
			var param = dataBind.paramData("searchArea");
			param.put("list",list);
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/master/json/saveMW01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(parseInt(json.data["CNT"] ) > 0){
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
	 		sajoUtil.openSaveVariantPop("searchArea", "MW01");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "MW01");
 		}
	}
	
	//서치헬프 리턴값 셋팅
	function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		if( searchCode == "SHWAHMA" ){
			gridList.setColValue("gridList", gridList.getFocusRowNum("gridList"), "WAREKY", rowData.get("WAREKY"));
		
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
			<div class="search_inner"> <!-- MW01 거점 -->
				<div class="search_wrap ">
					<dl> 
						<dt CL="STD_WAREKY"></dt>
						<dd>
							<input type="text" name="WAREKY" UIInput="SR,SHWAHMA" />
						</dd>
					</dl>
					<dl>
						<dt CL="STD_DELMAK"></dt>
						<dd>
							<input type="checkbox" name="DELMAK" />
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
									<td GH="50 STD_WAREKY" GCol="input,WAREKY,SHWAHMA" GF="S 10">거점</td> <!--거점-->
									<td GH="80 STD_TSPKEY" GCol="input,TSPKEY" GF="S 10">작업 분할 키</td> <!--작업 분할 키-->
									<td GH="80 STD_DELMAK" GCol="check,DELMAK" >삭제</td> <!--삭제-->
									<td GH="80 STD_CHKSHA" GCol="check,CHKSHA" >작업오더 완료 시 출고영역 체크</td> <!--작업오더 완료 시 출고영역 체크-->
									<td GH="200 STD_NAME01" GCol="input,NAME01" GF="S 60">업체명</td> <!--업체명-->
									<td GH="200 STD_NAME02" GCol="input,NAME02" GF="S 60">대표자이름</td> <!--대표자이름-->
									<td GH="200 STD_NAME03" GCol="input,NAME03" GF="S 60">대표바코드</td> <!--대표바코드-->
									<td GH="200 STD_ADDR01" GCol="input,ADDR01" GF="S 60">주소</td> <!--주소-->
									<td GH="200 STD_ADDR02" GCol="input,ADDR02" GF="S 60">납품주소</td> <!--납품주소-->
									<td GH="200 STD_ADDR03" GCol="input,ADDR03" GF="S 60">주소3</td> <!--주소3-->
									<td GH="200 STD_ADDR04" GCol="input,ADDR04" GF="S 60">봉투라벨주소1</td> <!--봉투라벨주소1-->
									<td GH="200 STD_ADDR05" GCol="input,ADDR05" GF="S 60">도착지</td> <!--도착지-->
									<td GH="200 STD_CITY01" GCol="input,CITY01" GF="S 40">도시</td> <!--도시-->
									<td GH="50 STD_REGN01" GCol="input,REGN01" GF="S 4">관할거점</td> <!--관할거점-->
									<td GH="80 STD_POSTCD" GCol="input,POSTCD" GF="S 10">우편번호  </td> <!--우편번호  -->
									
									<td GH="80 STD_NATNKY"  GCol="select,NATNKY"> <!--국가키 -->
										<select class="input" CommonCombo="NATNKY">
										</select>
									</td>
									
									<td GH="160 STD_TELN01" GCol="input,TELN01" GF="S 20">전화번호1</td> <!--전화번호1-->
									<td GH="160 STD_TELN02" GCol="input,TELN02" GF="S 20">전화번호2</td> <!--전화번호2-->
									<td GH="160 STD_TELN03" GCol="input,TELN03" GF="S 20">거래처담당자전번</td> <!--거래처담당자전번-->
									<td GH="160 STD_FAXTL1" GCol="input,FAXTL1" GF="S 20">팩스번호 </td> <!--팩스번호 -->
									<td GH="160 STD_FAXTL2" GCol="input,FAXTL2" GF="S 20">영업소레벨</td> <!--영업소레벨-->
									<td GH="160 STD_TAXCD1" GCol="input,TAXCD1" GF="S 20">색상</td> <!--색상-->
									<td GH="160 STD_TAXCD2" GCol="input,TAXCD2" GF="S 20">영업소구분</td> <!--영업소구분-->
									<td GH="160 STD_VATREG" GCol="input,VATREG" GF="S 20">사업자등록번호</td> <!--사업자등록번호-->
									<td GH="80 STD_POBOX1" GCol="input,POBOX1" GF="S 10">P.O.Box1</td> <!--P.O.Box1-->
									<td GH="80 STD_POBPC1" GCol="input,POBPC1" GF="S 10">POBox우편번호</td> <!--POBox우편번호-->
									<td GH="200 STD_WADN01" GCol="input,WADN01" GF="S 60">관리자명</td> <!--관리자명-->
									<td GH="160 STD_WADT01" GCol="input,WADT01" GF="S 20">전화번호1</td> <!--전화번호1-->
									<td GH="160 STD_WADT02" GCol="input,WADT02" GF="S 20">전화번호2</td> <!--전화번호2-->
									<td GH="200 STD_WADM01" GCol="input,WADM01" GF="S 60">e-Mail</td> <!--e-Mail-->
									<td GH="160 STD_EXCOMK" GCol="input,EXCOMK" GF="S 20">Ext. 회사코드</td> <!--Ext. 회사코드-->
									<td GH="50 STD_INDOVA" GCol="check,INDOVA" >초과할당 허용</td> <!--초과할당 허용-->
									<td GH="160 STD_PLOCOV" GCol="input,PLOCOV" GF="S 20">기본출고로케이션</td> <!--기본출고로케이션-->
									<td GH="160 STD_DRECLO" GCol="input,DRECLO" GF="S 20"></td> <!---->
									<td GH="50 STD_INDUAC" GCol="check,INDUAC" >미할당 remainds</td> <!--미할당 remainds-->
									<td GH="80 STD_DSORKY" GCol="input,DSORKY" GF="S 10">오더정렬키</td> <!--오더정렬키-->
									<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td> <!--생성일자-->
									<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td> <!--생성시간-->
									<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td> <!--생성자-->
									<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td> <!--생성자명-->
									<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 10">수정일자</td> <!--수정일자-->
									<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 10">수정시간</td> <!--수정시간-->
									<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td> <!--수정자-->
									<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 10">수정자명</td> <!--수정자명-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add"></button>
<!-- 						<button type='button' GBtn="delete"></button> -->
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