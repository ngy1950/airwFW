<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "SajoInbound",
			command : "GR70",
			menuId : "GR70"
	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");

			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}

	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "100");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}else if( comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put('OWNRKY', $('#OWNRKY').val());
			param.put('DOCCAT', '100');
			param.put('DOCUTY', '131');
		}
		return param;
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Print"){
			print();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "GR70");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "GR70");
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
	
	//서치헬프 Before 이벤트 (팝업에 넘겨줄 값 세팅)
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
				
		if(searchCode == "SHWAHMA"){
			num = rowNum;
			var param = new DataMap();
				param.put("COMPKY",'SAJO');
			return param;
		}
		
	}
	
	function print(){
		
		var where = "";
		
		var rowcount = gridList.getGridDataCount("gridHeadList");
		
		if(rowcount == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		var row = gridList.getRowData("gridHeadList", 0);
		
		where += " AND OWNRKY IN ('" +row.get("OWNRKY")+ "')";
		where += " AND WAREKY2 IN ('" +row.get("WAREKY")+ "')";
		
		var option = row.get("DOCDAT");
		
		var	url = "/ezgen/pre_receive.ezg";
		var	width = 620;
		var	height = 855;

		
		var langKy = "KO";
		var map = new DataMap();
			map.put("i_option",option);
		WriteEZgenElement(url , where , "" , langKy, map , width , height );
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
					<input type="button" CB="Print PRINT_OUT 입고예정리스트" />
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
					
					<dl>
						<dt CL="STD_SKUKEY"></dt><!-- 제품코드 -->
						<dd>
							<input type="text" class="input" name="SW.SKUKEY" UIInput="SR,SHSKUMA"/>
						</dd>
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--입고일자-->  
						<dt CL="HP_INPLANDT"></dt> 
						<dd> 
							<input type="text" class="input" name="DOCDAT" UIInput="I" UIFormat="C N" validate="required(HP_INPLANDT)"/> 
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
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridHeadList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>
										<td GH="120 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="120 STD_WAREKY" GCol="text,WAREKY" GF="S 6">거점</td>	<!--거점-->
			    						<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 20">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="120 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="120 STD_ORDREQPLT" GCol="text,ORDREQPLT" GF="N 4,0">발주팔렛수량</td>	<!--발주팔렛수량-->
			    						<td GH="120 STD_ORDREQBOX" GCol="text,ORDREQBOX" GF="N 10,0">발주박스수량</td>	<!--발주박스수량-->
			    						<td GH="120 STD_ORDREQPBOX" GCol="text,ORDREQPBOX" GF="N 10,0">발주P박스수량</td>	<!--발주P박스수량-->
			    						<td GH="120 STD_ORDREQQTY" GCol="text,ORDREQQTY" GF="N 10,0">발주수량</td>	<!--발주수량-->
			    						<td GH="120 STD_ASNPLT" GCol="text,ASNPLT" GF="N 17,0">ANS팔렛수량 </td>	<!--ANS팔렛수량 -->
			    						<td GH="120 STD_ASNBOX" GCol="text,ASNBOX" GF="N 10,0">ANS박스수량 </td>	<!--ANS박스수량 -->
			    						<td GH="120 STD_ASNPBOX" GCol="text,ASNPBOX" GF="N 10,0">ASNP박스수량 </td>	<!--ASNP박스수량 -->
			    						<td GH="120 STD_ASNQTY" GCol="text,ASNQTY" GF="N 17,0">ASN수량</td>	<!--ASN수량-->
			    						<td GH="120 STD_TRFREQPLT" GCol="text,TRFREQPLT" GF="N 1,0">창간이고요청팔렛수량</td>	<!--창간이고요청팔렛수량-->
			    						<td GH="120 STD_TRFREQBOX" GCol="text,TRFREQBOX" GF="N 8,0">창간이고요청박스수량</td>	<!--창간이고요청박스수량-->
			    						<td GH="120 STD_TRFREQPBOX" GCol="text,TRFREQPBOX" GF="N 8,0">창간이고요청P박스수량</td>	<!--창간이고요청P박스수량-->
			    						<td GH="120 STD_TRFREQQTY" GCol="text,TRFREQQTY" GF="N 4,0">창간이고요청수량</td>	<!--창간이고요청수량-->
			    						<td GH="120 STD_TRFASNPLT" GCol="text,TRFPLT" GF="N 20,0">창간이고입고예정팔렛수량</td>	<!--창간이고입고예정팔렛수량-->
			    						<td GH="120 STD_TRFASNBOX" GCol="text,TRFBOX" GF="N 180,0">창간이고입고예정박스수량</td>	<!--창간이고입고예정박스수량-->
			    						<td GH="120 STD_TRFASNPBOX" GCol="text,TRFPBOX" GF="N 180,0">창간이고입고예정P박스수량</td>	<!--창간이고입고예정P박스수량-->
			    						<td GH="120 STD_TRFASNQTY" GCol="text,TRFQTY" GF="N 20,0">창간이고입고예정수량</td>	<!--창간이고입고예정수량-->
			    						<td GH="120 STD_PRTDPLT" GCol="text,PRTDPLT" GF="N 20,0">생산입고팔렛수량</td>	<!--생산입고팔렛수량-->
			    						<td GH="120 STD_PRTDBOX" GCol="text,PRTDBOX" GF="N 20,0">생산입고박스수량</td>	<!--생산입고박스수량-->
			    						<td GH="120 STD_PRTDQTY" GCol="text,PRTDQTY" GF="N 20,0">생산입고수량</td>	<!--생산입고수량-->			
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
						<button type='button' GBtn="add"></button>
                     	<button type='button' GBtn="delete"></button>
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