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
var headrow = -1;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "SajoInbound",
			command : "GR61",
			menuId : "GR61"
	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			headrow = -1 ;
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		
		if(gridId == "gridHeadList" && dataCount > 0){
			var miyipgo = 0;
			for(var i=0;i<dataCount;i++){
				miyipgo += parseInt(gridList.getColData(gridId, i, "ERPWHF"));
			}
			miyipgo = miyipgo / dataCount;
			if(miyipgo > 0){
				alert("오늘 이전 생산취소오더 중 미 처리된 데이터가 "+miyipgo+"개 있습니다. \n생산일자 검색조건 없앤 후 조회해주세요");
			}
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
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
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			
			var list = gridList.getSelectData("gridHeadList", true);
			
			if(list.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
	
			var param = new DataMap();
			param.put("list",list);
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/SajoInbound/json/saveGR61.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] != "0"){
				
				alert("* 생산입고 취소 처리완료 *"); 
				
				searchList();
				
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
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "GR61");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "GR61");
 		}

	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if(searchCode == "SHLOCMA"){
            param.put("WAREKY",$("#WAREKY").val());
        }else if(searchCode == "SHSKUMA"){
            param.put("WAREKY",$("#WAREKY").val());
        }else if(searchCode == "SHWAHMA"){
        	param.put("NOBIND","N");
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
					<dl>
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
					<dl>  <!--From 거점-->  
						<dt CL="STD_WAREFR"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.WARESR" UIInput="SR,SHWAHMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품요청일-->  
						<dt CL="STD_EINDT"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.PRTDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl>
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl>  
					<dl>  <!--제품명-->  
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
			<div class="content_layout tabs">
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
<!-- 										<td GH="40 STD_CHECKED" GCol="rowCheck,radio"></td> -->
										<td GH="40" GCol="rowCheck"></td>
			    						<td GH="190 STD_POPKEY" GCol="text,POPKEY" GF="S 40">생산문서번호</td>	<!--생산문서번호-->
			    						<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="250 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_QTYFCN" GCol="text,QTYRCV" GF="N 17,0">취소수량</td>	<!--취소수량-->
			    						<td GH="120 STD_STKQTY" GCol="text,STKQTY" GF="N 17,0">재고수량</td>	<!--재고수량-->
			    						<td GH="160 STD_LOCAKY" GCol="text,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="120 STD_PRODDT" GCol="text,PRTDAT" GF="D 80">생산일자</td>	<!--생산일자-->
			    						<td GH="120 STD_LOTA11" GCol="text,LOTA11" GF="D 80">제조일자</td>	<!--제조일자-->
			    						<td GH="120 STD_LOTA13" GCol="text,LOTA13" GF="D 80">유통기한</td>	<!--유통기한-->
			    						<td GH="120 STD_PPLOCAT" GCol="text,SLGORT" GF="S 20">생산로케이션</td>	<!--생산로케이션-->
			    						<td GH="120 STD_LMODAT" GCol="text,XDATS" GF="T 20">수정일자</td>	<!--수정일자-->
			    						<td GH="120 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td>	<!--참조문서번호-->
<!-- 			    						<td GH="120 미입고완료숫자" GCol="text,ERPWHF" GF="S 8">미입고완료숫자</td>	미입고완료숫자 -->
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