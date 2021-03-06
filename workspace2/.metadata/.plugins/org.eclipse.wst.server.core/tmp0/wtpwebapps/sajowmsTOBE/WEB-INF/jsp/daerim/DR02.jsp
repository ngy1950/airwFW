
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DR02</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Daerim",
			command : "DR02_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			colorType : true ,
		    menuId : "DR02"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Daerim",
			command : "DR02_ITEM",
			colorType : true ,
		    menuId : "DR02"
	    });
		
		gridList.setReadOnly("gridHeadList", true, ["WAREKY"]);
		gridList.setReadOnly("gridItemList", true, ["DIRDVY","DIRSUP","C00103","WARESR"]);
		
		
/* 		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"AND");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "RCVLOC");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);
	 	
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SETLOC");
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"AND");
		rangeArr.push(rangeDataMap); 
		
		setSingleRangeData('S.LOCAKY', rangeArr);  */ /* 쿼리에 안쓰임 확인 필요 */
		
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			var param = inputList.setRangeDataParam("searchArea");
			param.put("LOGIN_OWNRKY","<%=ownrky%>");
			param.put("LOGIN_WAREKY","<%=wareky%>");
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			param.put("LOGIN_WAREKY","<%=wareky%>");
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
			if(json.data["RESULT"] == "S"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function reloadLabel() {
		netUtil.send({
			url : "/common/label/json/reload.data"
		});
	}
	
	//부족수량 음수인 경우 빨간색 표시
	function gridListRowColorChange(gridId, rowNum, rowData){
		if(gridId == "gridHeadList"){			
			if(rowData.get("BOXQTY3")  < 0 || rowData.get("QTSIWH3") < 0){
				return configData.GRID_COLOR_TEXT_RED_CLASS;
			}
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		} else if (btnName == "Reload") {
			reloadLabel();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DR02");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DR02");
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
	    
		//요청사업장
		if(searchCode == "SHCMCDV" && $inputObj.name == "I.WARESR"){
        	param.put("CMCDKY","PTNG05");
    		param.put("OWNRKY","<%=ownrky %>");
		//납품처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNRTO"){
	        param.put("PTNRTY","0007");
	        param.put("OWNRKY","<%=ownrky %>");
	    //매출처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "I.PTNROD"){
	        param.put("PTNRTY","0001");
	        param.put("OWNRKY","<%=ownrky %>");	
		//주문구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
	        param.put("CMCDKY","PGRC03");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		//배송구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
	        param.put("CMCDKY","PGRC02");
	    	param.put("OWNRKY","<%=ownrky %>");   
		//상온구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
	        param.put("CMCDKY","ASKU05");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//마감구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG08"){
	        param.put("CMCDKY","PTNG08");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//피킹그룹
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "PK.PICGRP"){
	        param.put("CMCDKY","PICGRP");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//유통경로1
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG01"){
	        param.put("CMCDKY","PTNG01");
	    	param.put("OWNRKY","<%=ownrky %>");
		//유통경로2
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG02"){
	        param.put("CMCDKY","PTNG02");
	    	param.put("OWNRKY","<%=ownrky %>");
		//유통경로3
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "B.PTNG03"){
	        param.put("CMCDKY","PTNG03");
	    	param.put("OWNRKY","<%=ownrky %>");
		//소분류
		} else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG03"){
	        param.put("CMCDKY","SKUG03");
	        param.put("OWNRKY","<%=ownrky %>");
		//로케이션
	    } else if(searchCode == "SHLOCMA" && $inputObj.name == "W.LOCARV"){
		    param.put("WAREKY","<%=wareky %>");	
		// 차량벊
	    } else if(searchCode == "SHCARMA2"){
            param.put("WAREKY","<%=wareky%>");
            param.put("OWNRKY","<%=ownrky%>");
            param.put("NOBIND", "Y");
	    }
		return param; 
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
					<dl>  <!--주문/출고형태-->  
						<dt CL="IFT_ORDTYP"></dt> 
						<dd> 
							<input type="text" class="input" name="I.ORDTYP" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고일자-->  
						<dt CL="IFT_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="I.ORDDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="IFT_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--S/O번호-->  
						<dt CL="IFT_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="I.SVBELN" UIInput="SR" /><!-- validate="required(IFT_SVBELN)" --> 
						</dd> 
					</dl> 
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl> 
					<dl>  <!--요청사업장-->  
						<dt CL="STD_IFPGRC04"></dt> 
						<dd> 
							<input type="text" class="input" name="I.WARESR" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--매출처코드-->  
						<dt CL="IFT_PTNROD"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNROD" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DIRDVY" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--차량번호-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHCARMA2"/> 
						</dd> 
					</dl> 
					<dl>  <!--상온구분-->  
						<dt CL="STD_ASKU05"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.ASKU05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--마감구분-->  
						<dt CL="STD_PTNG08"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG08" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--피킹그룹-->  
						<dt CL="STD_PICGRP"></dt> 
						<dd> 
							<input type="text" class="input" name="PK.PICGRP" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="W.LOCARV" UIInput="SR,SHLOCMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로1-->  
						<dt CL="STD_PTNG01"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG01" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로2-->  
						<dt CL="STD_PTNG02"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG02" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로3-->  
						<dt CL="STD_PTNG03"></dt> 
						<dd> 
							<input type="text" class="input" name="B.PTNG03" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--소분류-->  
						<dt CL="STD_SKUG03"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.SKUG03" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
 					<!-- <dl>  포장구분  
						<dt CL="STD_LOTA05"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05"/> 
						</dd> 
					</dl> 
					<dl>  재고유형  
						<dt CL="STD_LOTA06"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA06" value="00"/> 
						</dd> 
					</dl>
					<dl>  로케이션  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA"/> 
						</dd> 
					</dl> --><!-- 쿼리에 안쓰임 확인 필요  -->
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
										<td GH="150 STD_WAREKY" GCol="select,WAREKY">
											<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select> <!--거점-->
										<td GH="70 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
										<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
										<td GH="70 STD_NETWGT" GCol="text,NETWGT" GF="N 80,3"></td> <!--순중량-->
										<td GH="70 STD_BXIQTY" GCol="text,BXIQTY" GF="S 80" style="text-align:right;" >박스입수</td> <!--박스입수-->
										<td GH="85 STD_ORDBOX" GCol="text,BOXQTY1" GF="N 80,1">주문내역(BOX)</td> <!--주문내역(BOX)-->
										<td GH="85 STD_ORDREA" GCol="text,QTSIWH1" GF="N 80,0">주문내역(EA)</td> <!--주문내역(EA)-->
										<td GH="85 STD_SHDBOX" GCol="text,BOXQTY6" GF="N 80,1">출고완료(BOX)</td> <!--출고완료(BOX)-->
										<td GH="85 STD_SHDEA" GCol="text,QTSIWH6" GF="N 80,0">출고완료(EA)</td> <!--출고완료(EA)-->
										<td GH="85 STD_BOXQTY2BOX" GCol="text,BOXQTY2" GF="N 80,1">출고가능재고(BOX)</td> <!--출고가능재고(BOX)-->
										<td GH="85 STD_QTSIWH2EZ" GCol="text,QTSIWH2" GF="N 80,0">출고가능재고(EA)</td> <!--출고가능재고(EA)-->
										<td GH="85 STD_BOXQTYR3" GCol="text,BOXQTY3" GF="N 80,1">부족수량(BOX)</td> <!--부족수량(BOX)-->
										<td GH="85 STD_QTSIWH3EA" GCol="text,QTSIWH3" GF="N 80,0">부족수량(EA)</td> <!--부족수량(EA)-->
										<td GH="85 STD_BOXQTY4BOX" GCol="text,BOXQTY4" GF="N 80,1">입고예정(BOX)</td> <!--입고예정(BOX)-->
										<td GH="85 STD_QTSIWH4EA" GCol="text,QTSIWH4" GF="N 80,0">입고예정(EA)</td> <!--입고예정(EA)-->
										<td GH="85 STD_BOXQTY5BOX" GCol="text,BOXQTY5" GF="N 80,1">이고예정(BOX)</td> <!--이고예정(BOX)-->
										<td GH="85 STD_QTSIWH5EA" GCol="text,QTSIWH5" GF="N 80,0">이고예정(EA)</td> <!--이고예정(EA)-->
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
			<div class="content_layout tabs bottom_layout">
				<ul class="tab tab_style02">
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
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
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
								        <td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td> <!--출고일자-->
								        <td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td> <!--출고요청일-->
								        <td GH="70 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
								        <td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td> <!--제품명-->
								        <td GH="50 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">요청수량</td> <!--요청수량-->
								        <td GH="50 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td> <!--납품요청수량-->
								        <td GH="50 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS관리수량</td> <!--WMS관리수량-->
								        <td GH="50 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td> <!--출하수량-->
								        <td GH="70 STD_PTNG08" GCol="text,PTNG08" GF="S 20">마감구분</td> <!--마감구분-->
								        <td GH="70 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td> <!--납품처코드-->
								        <td GH="140 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td> <!--납품처명-->
								        <td GH="70 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td> <!--매출처코드-->
								        <td GH="140 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td> <!--매출처명-->
								        <td GH="100 IFT_DIRDVY" GCol="select,DIRDVY">
											<select class="input" CommonCombo="PGRC02"><!--배송구분-->
											</select>
										</td>
								        <td GH="100 IFT_DIRSUP" GCol="select,DIRSUP">
											<select class="input" CommonCombo="PGRC03"> <!--주문구분-->
											</select>
										</td>
								        <td GH="80 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td> <!--주문아이템번호-->
								        <td GH="70 STD_QTSDIF" GCol="text,USEQTY" GF="N 13,0">가용재고</td> <!--가용재고-->
								        <td GH="70 STD_ORDTOT" GCol="text,ORDTOT" GF="N 13,0">누적주문수량</td> <!--누적주문수량-->
								        <td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td> <!--기본단위-->
								        <td GH="80 IFT_C00102" GCol="text,C00102" GF="S 100">승인여부</td> <!--승인여부-->
								        <td GH="200 IFT_C00103" GCol="select,C00103">
								        	<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"></select> <!--사유코드-->
								        </td>
								        <td GH="80 IFT_CDATE" GCol="text,CDATE" GF="S 14">yyyymmddhhmmss(처리일자)</td> <!--yyyymmddhhmmss(처리일자)-->
								        <td GH="80 IFT_IFFLG" GCol="text,IFFLG" GF="S 1">Default:N, 처리완료시:Y, 미사용:X</td> <!--Default:N, 처리완료시:Y, 미사용:X-->
								        <td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
								        <td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
								        <td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
								        <td GH="80 IFT_CUPOST" GCol="text,CUPOST" GF="S 10">배송지 우편번호</td> <!--배송지 우편번호-->
								        <td GH="80 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td> <!--배송지 주소-->
								        <td GH="80 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td> <!--거래처 담당자명-->
								        <td GH="80 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td> <!--거래처 담당자 전화번호-->
								        <td GH="200 STD_IFPGRC04" GCol="select,WARESR">
								        	<select class="input" CommonCombo="PTNG06">	<!--요청사업장-->
								        	<option></option>
											</select>
								        </td> 
								        <td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td> <!--영업사원명-->
								        <td GH="80 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td> <!--영업사원 전화번호-->
								        <td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td> <!--비고-->			
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