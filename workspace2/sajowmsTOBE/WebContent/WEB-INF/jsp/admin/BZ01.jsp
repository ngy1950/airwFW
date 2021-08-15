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
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridList",
	    	module : "Master",
			command : "BZ01",
			pkcol : "COMPKY,PTNRKY",
			menuId : "BZ01"
	    });
		gridList.setReadOnly("gridList", true, ["PTNRTY","PTNRKY"]);
		
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

	function saveData(){
		if(gridList.validationCheck("gridList", "All")){
			var list = gridList.getModifyList("gridList","A");
			
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			for(var i=0;i < list.length;i++){
				var listMap = list[i].map;
				if(listMap.GRowState != "D"){
					if(listMap.PTNRKY == null || listMap.PTNRKY == ''){
						commonUtil.msgBox("COMMON_M0009",uiList.getLabel("STD_PTNRKY"));
						setColFocus("gridList", list[i].get("GRowNum"), "PTNRKY");
						return;
					}
					if(listMap.PTNRTY == null || listMap.PTNRTY == ''){
						commonUtil.msgBox("COMMON_M0009",uiList.getLabel("STD_PTNRTY"));
						setColFocus("gridList", list[i].get("GRowNum"), "PTNRTY");
						return;
					}
				}
			}

				
			var param = inputList.setRangeDataParam("searchArea");
				param.put("list",list);
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/master/json/saveBZ01.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "OK"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
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
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "BZ01");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "BZ01");
		}
	}
	

//     function gridListEventRowAddBefore(gridId, rowNum) {
//     	if(gridId == 'gridList'){
//             var newData = new DataMap();
//             newData.put("WAREKY",$("#WAREKY").val());
//             return newData;
//     	}
//     }
    
    function gridListEventRowAddAfter(gridId, rowNum){
		if(gridId == "gridList"){
			gridList.setRowReadOnly(gridId, rowNum, false, ["PTNRTY","PTNRKY"]);
			gridList.setColValue("gridList", rowNum, "OWNRKY",$("#OWNRKY").val());
		}
    }
    
	function gridListEventRowRemove(gridId, rowNum){
		if(gridList.getRowStatus(gridId, rowNum) != "C"){
			commonUtil.msgBox("VALID_M9999");
			return false;
		}
	}
    
    function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
    	var param = new DataMap();
    	if(searchCode == "SHCMCDV"){
    		var name = $inputObj.name
    		if(name.indexOf(".") != -1){
    			name = name.split("/")[1];
    		}
    			param.put("CMCDKY",name);
    	}else if(searchCode == "SHSHPMA"){
    		var param = new DataMap();
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
					<dl>  <!--업체코드-->  
						<dt CL="STD_PTNRKY"></dt> 
						<dd> 
							<input type="text" class="input" name="PTNRKY" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--업체타입-->  
						<dt CL="STD_PTNRTY"></dt> 
						<dd> 
							<input type="text" class="input" name="PTNRTY" UIInput="SR,SHVPTNT"/> 
						</dd> 
					</dl> 
					<dl>  <!--업체명-->  
						<dt CL="STD_NAME01"></dt> 
						<dd> 
							<input type="text" class="input" name="NAME01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--권역코드-->  
						<dt CL="STD_EXPTNK"></dt> 
						<dd> 
							<input type="text" class="input" name="EXPTNK" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--마감구분-->  
						<dt CL="STD_PTNG08"></dt> 
						<dd> 
							<input type="text" class="input" name="PTNG08" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--영업 담당자명-->  
						<dt CL="STD_SALN01"></dt> 
						<dd> 
							<input type="text" class="input" name="SALN01" UIInput="SR"/> 
						</dd> 
					</dl>
					<dl>
						<dt CL="STD_DELMAK"></dt>
						<dd>
							<input type="checkbox" class="input" name="DELMAK" id="DELMAK" style="margin-top: 0px;" />
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
								<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
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
											<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 20" >화주</td>	<!--화주-->
				    						<td GH="100 STD_PTNRKY" GCol="input,PTNRKY" GF="S 20">업체코드</td>	<!--업체코드-->
				    						<td GH="100 STD_NAME01B" GCol="input,NAME01" GF="S 180">거래처명</td>	<!--거래처명-->
				    						<td GH="100 STD_PTNRTY" GCol="select,PTNRTY">
				    							<select class="input" commonCombo="PTNRTY"><option></option></select>	<!--업체타입-->
											</td>
				    						<td GH="100 STD_PTNG08" GCol="select,PTNG08">
				    							<select class="input" commonCombo="PTNG08"></select>	<!--마감구분-->
											</td>
				    						<td GH="100 STD_EXPTNKB" GCol="input,EXPTNK,SHSHPMA" GF="S 20">권역코드</td>	<!--권역코드-->
				    						<td GH="100 STD_NAME02B" GCol="input,NAME02" GF="S 180">대표자명</td>	<!--대표자명-->
				    						<td GH="100 STD_ADDR01B" GCol="input,ADDR01" GF="S 180">도착지주소1</td>	<!--도착지주소1-->
				    						<td GH="100 STD_ADDR02B" GCol="input,ADDR02" GF="S 180">도착지주소2</td>	<!--도착지주소2-->
				    						<td GH="100 STD_POSTCD" GCol="input,POSTCD" GF="S 30">우편번호  </td>	<!--우편번호  -->
				    						<td GH="100 STD_TELN01B" GCol="input,TELN01" GF="S 50">전화번호1</td>	<!--전화번호1-->
				    						<td GH="100 STD_VATREG" GCol="input,VATREG" GF="S 20">사업자등록번호</td>	<!--사업자등록번호-->
				    						<td GH="100 STD_PTNL05" GCol="input,PTNL05" GF="S 20">총부코드</td>	<!--총부코드-->
				    						<td GH="100 STD_DELMAK" GCol="check,DELMAK" >삭제</td>	<!--삭제-->
				    						<td GH="100 STD_NAME03B" GCol="input,NAME03" GF="S 180">출고거점</td>	<!--출고거점-->
				    						<td GH="100 STD_ADDR05B" GCol="input,ADDR05" GF="S 200">도착지</td>	<!--도착지-->
				    						<td GH="100 STD_TELN02" GCol="input,TELN02" GF="S 50">전화번호2</td>	<!--전화번호2-->
				    						<td GH="100 STD_FAXTL1" GCol="input,FAXTL1" GF="S 20">팩스번호 </td>	<!--팩스번호 -->
				    						<td GH="100 STD_EMAIL1" GCol="input,EMAIL1" GF="S 120">이메일</td>	<!--이메일-->
				    						<td GH="100 STD_EMAIL2" GCol="input,EMAIL2" GF="S 120">이메일2</td>	<!--이메일2-->
				    						<td GH="100 STD_CTTN01B" GCol="input,CTTN01" GF="S 120">거래처 담당자명</td>	<!--거래처 담당자명-->
				    						<td GH="100 STD_CTTT01B" GCol="input,CTTT01" GF="S 20">거래처 담당자 휴대폰 번호1</td>	<!--거래처 담당자 휴대폰 번호1-->
				    						<td GH="100 STD_CTTT02B" GCol="input,CTTT02" GF="S 20">거래처 담당자 휴대폰 번호2</td>	<!--거래처 담당자 휴대폰 번호2-->
				    						<td GH="100 STD_CTTM01B" GCol="input,CTTM01" GF="S 60">거래처담당자 email주소</td>	<!--거래처담당자 email주소-->
				    						<td GH="100 STD_SALN01B" GCol="input,SALN01" GF="S 120">영업 담당자명</td>	<!--영업 담당자명-->
				    						<td GH="100 STD_SALT01B" GCol="input,SALT01" GF="S 20">영업 담당자 휴대폰번호 1</td>	<!--영업 담당자 휴대폰번호 1-->
				    						<td GH="100 영업 담당자명2" GCol="input,SALT02" GF="S 20">영업 담당자명2</td>	<!--영업 담당자명2-->
				    						<td GH="100 STD_SALM01B" GCol="input,SALM01" GF="S 60">영업 담당자 email주소</td>	<!--영업 담당자 email주소-->
				    						<td GH="100 STD_CUSTMRB" GCol="input,CUSTMR" GF="S 10">거래처상태</td>	<!--거래처상태-->
				    						<td GH="100 STD_PTNG01B" GCol="select,PTNG01">
				    							<select class="input" commonCombo="PTNG01"></select>	<!--유통경로1-->
				    						</td>
				    						<td GH="100 STD_PTNG02B" GCol="select,PTNG02">
				    							<select class="input" commonCombo="PTNG02"><option></option></select>	<!--유통경로2-->
											</td>
				    						<td GH="100 STD_PTNG03B" GCol="select,PTNG03">
				    							<select class="input" commonCombo="PTNG03"><option></option></select>	<!--유통경로3-->
											</td>
				    						<td GH="100 STD_PTNG04B" GCol="input,PTNG04" GF="S 20">매출처그룹</td>	<!--매출처그룹-->
				    						<td GH="100 STD_PTNG06B" GCol="select,PTNG06">
				    							<select class="input" commonCombo="POSBYN"><option></option></select>	<!--창간이동 가능한 창고 및 공장-->
											</td>
				    						<td GH="100 STD_PTNG07B" GCol="select,PTNG07">
				    							<select class="input" commonCombo="CARTYP"></select>	<!--최대진입가능차량-->
											</td>
				    						<td GH="100 STD_PTNL01B" GCol="input,PTNL01" GF="S 90">위탁점</td>	<!--위탁점-->
				    						<td GH="100 STD_PTNL02B" GCol="input,PTNL02" GF="S 90">영업시간</td>	<!--영업시간-->
				    						<td GH="100 STD_PTNL06B" GCol="input,PTNL06" GF="S 90">업태</td>	<!--업태-->
				    						<td GH="100 STD_PTNL07B" GCol="input,PTNL07" GF="S 90">업종</td>	<!--업종-->
				    						<td GH="100 STD_RPOCHAB" GCol="select,PROCHA">
				    							<select class="input" commonCombo="POSBYNR"></select>	<!--발주불가능여부-->
											</td>
				    						<td GH="100 STD_FORKYNB" GCol="select,FORKYN">
				    							<select class="input" commonCombo="FORKDS"><option></option></select>	<!--지게차사용여부-->
											</td>
				    						<td GH="100 STD_PTNL10B" GCol="input,PTNL10" GF="S 90">구코드</td>	<!--구코드-->
				    						<td GH="100 STD_PTNL09" GCol="check,PTNL09">납품처사용여부</td>	<!--납품처사용여부-->
				    						<td GH="100 STD_CREDAT" GCol="text,CREDAT" GF="D 10">생성일자</td>	<!--생성일자-->
				    						<td GH="100 STD_CRETIM" GCol="text,CRETIM" GF="T 10">생성시간</td>	<!--생성시간-->
				    						<td GH="100 STD_CREUSR" GCol="text,CREUSR" GF="S 10">생성자</td>	<!--생성자-->
				    						<td GH="100 STD_LMODAT" GCol="text,LMODAT" GF="D 10">수정일자</td>	<!--수정일자-->
				    						<td GH="100 STD_LMOTIM" GCol="text,LMOTIM" GF="T 10">수정시간</td>	<!--수정시간-->
				    						<td GH="100 STD_LMOUSR" GCol="text,LMOUSR" GF="S 10">수정자</td>	<!--수정자-->
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
<!-- 							<button type='button' GBtn="total"></button> -->
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