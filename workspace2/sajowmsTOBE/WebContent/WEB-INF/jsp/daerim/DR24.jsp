<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DR24</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
	var searchParamBak; 
	var headrow = -1;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "DaerimReport",
	    	pkcol : "CMCDKY, CMCDVL",
	    	command : "DR24_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "DR24"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "DaerimReport",
	    	pkcol : "MANDT, SEQNO",
			command : "DR24_ITEM",
		    menuId : "DR24"
	    });

		gridList.setReadOnly("gridHeadList", true, ["PTNG08"]);
		gridList.setReadOnly("gridItemList", true, ["DOCUTY", "PTNG08", "WARESR", "DIRDVY", "DIRSUP", "C00103", "C00102"]);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	                            
	
	//버튼 작동
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DR24");
		}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DR24");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}

	function searchList(){
		
		if(validate.check("searchArea")){
			headrow = -1;
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			var param = inputList.setRangeDataParam("searchArea");
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
		
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			//itemSearch(rowData, ptng08, c00102)
		}
	}
	
	function gridListEventRowDblclick(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			var c00102 = "";
			var ptng08 = gridList.getColData("gridHeadList", rowNum, "PTNG08")
			
			if (colName.toString() == "NUM01"){
				c00102 = "X";
			}
			else if (colName.toString() == "NUM02"){
				c00102 = "N";
			}
			else if (colName.toString() == "NUM03"){
				c00102 = "Y";
			}
			else {
				c00102 = "%";
			} 
			
			var rowData = gridList.getRowData(gridId, rowNum);
			itemSearch(rowData, ptng08, c00102);
		}
	}
	
	function itemSearch(rowData, ptng08, c00102){
		var param = inputList.setRangeMultiParam("searchArea");
		param.putAll(rowData);
		param.put("ptng08",ptng08);
		param.put("C00102",c00102);

		 gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });  
		
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "OWNRKY"){
				chownrky = colValue;
			}
		}
	}
	


	
	
	//저장성공시 callback
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["REUSLT"] == "1"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList();
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if( comboAtt == "SajoCommon,RSNCOD_COMCOMBO" ){
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("DOCCAT", "200");
			param.put("DOCUTY", "214");
			
			return param;
		}
		
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();


		//납품처코드
		if(searchCode == "SHBZPTN" && $inputObj.name == "IT.PTNRTO"){
	        param.put("PTNRTY","0007");
	        param.put("OWNRKY","<%=ownrky %>");
	    //매출처코드
		}else if(searchCode == "SHBZPTN" && $inputObj.name == "IT.PTNROD"){
	        param.put("PTNRTY","0001");
	        param.put("OWNRKY","<%=ownrky %>");	
		//주문구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "IT.DIRSUP"){
	        param.put("CMCDKY","PGRC03");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		//배송구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "IT.DIRDVY"){
	        param.put("CMCDKY","PGRC02");
	    	param.put("OWNRKY","<%=ownrky %>");   
		//마감구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "BZ2.PTNG08"){
	        param.put("CMCDKY","PTNG08");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//유통경로1
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "BZ2.PTNG01"){
	        param.put("CMCDKY","PTNG01");
	    	param.put("OWNRKY","<%=ownrky %>");
		//유통경로2
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "BZ2.PTNG02"){
	        param.put("CMCDKY","PTNG02");
	    	param.put("OWNRKY","<%=ownrky %>");
		//유통경로3
	    }else if(searchCode == "SHCMCDV" && $inputObj.name == "BZ2.PTNG03"){
	        param.put("CMCDKY","PTNG03");
	    	param.put("OWNRKY","<%=ownrky %>");
	    } return param;
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
				</div>
			</div>
			<div class="search_inner">
				<div class="search_wrap ">
					<dl> <!--화주-->  
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>  <!--출고일자-->  
						<dt CL="STD_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.ORDDAT" UIInput="B" UIFormat="C N" validate="required"/> 
						</dd> 
					</dl> 
					<dl>  <!--S/O 번호-->  
						<dt CL="IFT_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl>
					<dl>  <!--출고요청일-->  
						<dt CL="STD_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.OTRQDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.PTNRTO" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl>
					<dl>  <!--매출처코드-->  
						<dt CL="IFT_PTNROD"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.PTNROD" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRSUP" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="IT.DIRDVY" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--마감구분-->  
						<dt CL="STD_PTNG08"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ2.PTNG08" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로1-->  
						<dt CL="STD_PTNG01"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ2.PTNG01" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로2-->  
						<dt CL="STD_PTNG02"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ2.PTNG02" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통경로3-->  
						<dt CL="STD_PTNG03"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ2.PTNG03" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
				</div> 
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content-horizontal-wrap h-wrap-min">	
				<div class="content_layout tabs content_left" style="width: 460px;">
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
											<td GH="40" GCol="rowCheck"></td>
											<td GH="40" GCol="rownum">1</td>
											<td GH="120 STD_PTNG08" GCol="select,PTNG08">	<!--마감구분-->
												<select class="input" commonCombo="PTNG08"></select>
											</td>
				    						<td GH="60 STD_ALL" GCol="text,TOT01" GF="N 4,0">전체</td>	<!--전체-->
				    						<td GH="60 STD_UN_DCSN" GCol="text,NUM01" GF="N 4,0">미확정</td> <!--미확정-->
									        <td GH="70 STD_NOINST" GCol="text,NUM02" GF="N 4,0">미출고지시</td> <!--미출고지시-->
									        <td GH="60 STD_INSTRU" GCol="text,NUM03" GF="N 4,0">출고지시</td> <!--출고지시-->
									        <td GH="60 STD_CNTCUS" GCol="text,NUM04" GF="N 4,0">매출처수</td> <!--매출처수-->
				    						
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
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>0</span></span>
						</div>
					</div>
				</div>
				<div class="content_layout tabs content_right" style="width : calc(100% - 460px);">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1"><span>상세내역</span></a></li>
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
									<tbody id="gridItemList">
										<tr CGRow="true">
											<td GH="120 IFT_DOCUTY" GCol="select,DOCUTY">
												<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select> <!--출고유형-->
											</td>
											<td GH="80 STD_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td> <!--출고일자-->
											<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td> <!--출고요청일-->
											<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40"></td>	<!--S/O 번호-->
											<td GH="80 STD_PTNG08" GCol="select,PTNG08">
												<select class="input" commonCombo="PTNG08"></select>	<!--마감구분-->
											</td>
											<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20"></td>	<!--납품처코드-->
				    						<td GH="160 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20"></td>	<!--납품처명-->
				    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20"></td>	<!--매출처코드-->
				    						<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20"></td>	<!--매출처명-->
				    						<td GH="160 IFT_WARESR" GCol="select,WARESR">
				    							<select class="input" commonCombo="PTNG06"><option></option></select>	<!--요구사업장-->
				    						</td>
				    						<td GH="80 IFT_DIRDVY" GCol="select,DIRDVY">
				    							<select class="input" commonCombo="PGRC02"></select>	<!--배송구분-->
				    						</td>
				    						<td GH="80 IFT_DIRSUP" GCol="select,DIRSUP">
				    							<select class="input" commonCombo="PTNG03"></select>	<!--주문구분-->
				    						</td>
				    						<td GH="80 IFT_C00103" GCol="select,C00103" >
				    							<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"><option></option></select>	<!--사유코드-->
				    						</td>
				    						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="S 20"></td>	<!--납품요청수량-->
				    						<td GH="80 IFT_QTSHPD" GCol="text,QTSHPD" GF="S 20"></td>	<!--출하수량-->
				    						<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 100"></td>	<!--비고-->
				    						<td GH="80 IFT_C00102" GCol="select,C00102">
				    							<select class="input" commonCombo="C00102"><option></option></select>	<!--승인여부-->
				    						</td>
				    						<td GH="80 STD_ERDAT" GCol="text,XDATS" GF="D 10"></td>	<!--지시일자-->
				    						<td GH="80 STD_RQARRT" GCol="text,XTIMS" GF="T 10"></td>	<!--지시시간-->
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