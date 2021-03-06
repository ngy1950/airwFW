<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>TM03</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">

	var GRPRL = 'ERPSO';
	var TOTALPICKING = 'N';
	var PROGID = 'TM04';
    var SVBELN = '';
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "TM04_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "TM04"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "Outbound",
			command : "TM04_ITEM",
			pkcol : "OWNRKY,WAREKY,SVBELN",
			emptyMsgType : false,
		    menuId : "TM04"
	    });
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val(),"#WARERQ");
		});
		
		$("#searchArea [name=WARERQ]").on("change",function(){
			searchwareky($('#OWNRKY').val(),"#WARETG");
		});
		
		searchwareky($('#OWNRKY').val(),"#WARERQ");
		
		//콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["OWNRKY", "WARESR", "WARERQ","WARETG", "DOCUTY"]);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchwareky(val,target){
		var param = new DataMap();
		param.put("OWNRKY",val);
		
		var json = netUtil.sendData({
			module : "SajoCommon",
			command : "WAREKYNM_IF2_COMCOMBO",
			sendType : "list",
			param : param
		});
		
		$(target).find("[UIOption]").remove();
		var optionHtml = inputList.selectHtml(json.data, false);
		$(target).append(optionHtml);

	}
	
	function searchList(){
		
		if(validate.check("searchArea")){			
			var param = inputList.setRangeParam("searchArea");			
			var group = $('input[name="GROUP"]:checked').attr('id');
			param.put('SVBELN',SVBELN)	

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
			if (SVBELN == ''){				
				gridList.gridList({
			    	id : "gridItemList",
			    	param : param
			    });
			} else {
				SVBELN = '';
			}
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "200");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			} else if(name == "C00102"){
				param.put("CMCDKY", "C00102");	
			} else if(name == "CASTYN"){
				param.put("CMCDKY", "ALLYN");	
			} else if(name == "ALSTKY"){
				param.put("CMCDKY", "ALSTKY");	
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
		}else if( comboAtt == "SajoCommon,ALSTKY_COMCOMBO" ){			
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			return param;
		}
		return param;
	}
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		
		var qtyorg = 0;
		var boxqty = 0;
		var remqty = 0;
		var pltqty = 0;
		var grswgt = 0;
		var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
		var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
		var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
//		var grswgtcnt = Number(gridList.getColData(gridId, rowNum, "GRSWGTCNT"));
		var remqtyChk = 0;
		
		if(gridId == "gridItemList"){
			if(colName == "QTYORG" || colName == "BOXQTY" || colName == "REMQTY"){
				if( colName == "QTYORG" ) {
					qtyorg = Number(gridList.getColData(gridId, rowNum, "QTYORG"));
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));					
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
				  	
				  	boxqty = floatingFloor((Number)(qtyorg)/(Number)(bxiqty), 1);
				 	remqty = (Number)(qtyorg)%(Number)(bxiqty);
				 	pltqty = floatingFloor((Number)(qtyorg)/(Number)(pliqty), 2);	
				 	
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					
				} else if( colName == "QTYORG" ) {
					remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
					qtyorg = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				 	pltqty = floatingFloor((Number)(qtyorg)/(Number)(pliqty), 2);
					
				 	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "QTYORG", qtyorg);
					
				} else if( colName == "REMQTY" ) {
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
					qtyorg = Number(gridList.getColData(gridId, rowNum, "QTYORG"));
					remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
					
					remqtyChk = (Number)(remqty)%(Number)(bxiqty);
				 	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
				 	qtyorg = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
				 	pltqty = floatingFloor((Number)(qtyorg)/(Number)(pliqty), 2);
				 	
				 	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "QTYORG", qtyorg);
				}
			}
		}			
	}
	
	  function save(){    
        var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getSelectData("gridItemList");
	
	    if(head.length == 0){
	      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
	      return;
	    }
		

	    for(i=0; i<head.length; i++){
	    	if(head[i].get("C00102") == "ALL" ){
				alert("* 승인여부는 Y또는 N으로 선택해주세요. *");			
				return;
			}
	    }

	    var param = new DataMap();
	    param.put("head",head);
	    param.put("item",item);
	    
    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
			return;
        }

	    netUtil.send({
	      url : "/outbound/json/saveTM04.data",
	      param : param,
	      successFunction : "successSaveCallBack"
	    });
	  }
	  
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data == "OK"){			
				commonUtil.msgBox("SYSTEM_SAVEOK");
//				SVBELN = json.data;
				searchList();
			}else if(json.data == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function reload(){
		gridList.resetGrid("gridItemList");
		searchList();
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
	    }else if(btnName == "Save"){
	    	save();
		}else if(btnName == "Reload"){
			reload();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "TM04");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "TM04");
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();

	    if(searchCode == "SHSKUMA"){
	    	 param.put("WAREKY","<%=wareky %>");	
	    	param.put("OWNRKY",$("#OWNRKY").val()); 
	    	param.put("NOBIND","N");  
	    	
		//거점
	    }if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
	        param.put("CMCDKY","WAREKY");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		//출고거점
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "A.WAREKY"){
	        param.put("CMCDKY","WAREKY");
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
		//마감구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "B2.PTNG08"){
	        param.put("CMCDKY","PTNG08");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//상온구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.ASKU05"){
	        param.put("CMCDKY","ASKU05");
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
		//피킹그룹
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "PK.PICGRP"){
	        param.put("CMCDKY","PICGRP");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//소분류
		} else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG03"){
	        param.put("CMCDKY","SKUG03");
	        param.put("OWNRKY","<%=ownrky %>");
		//로케이션
	    } else if(searchCode == "SHLOCMA" && $inputObj.name == "SW.LOCARV"){
		    param.put("WAREKY","<%=wareky %>");	
	    } return param;
	}	    
		
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCUTY", "266");
			
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

	 //데이터가 바인드된후 
   function gridListEventDataBindEnd(gridId, dataLength, excelLoadType){
      if(gridId=="gridHeadList"){

			var head = gridList.getGridData("gridHeadList");
			for(var i=0; i<head.length; i++){
				if(head[i].map.C00102 == "Y"){
					gridList.setRowReadOnly("gridHeadList", head[i].map.GRowNum, true, ["rowCheck","C00102"]);
				}
			}
      }else if(gridId=="gridItemList"){

			var item = gridList.getGridData("gridItemList");
			for(var i=0; i<item.length; i++){
				if(item[i].map.C00102 == "Y"){
					gridList.setRowReadOnly("gridItemList", item[i].map.GRowNum, true, ["rowCheck","QTYORG","BOXQTY","REMQTY"]);
				}
			}
    }
   }
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    var param = new DataMap();

	    if(searchCode == "SHSKUMA"){
	        param.put("WAREKY","<%=wareky %>");
	        param.put("OWNRKY","<%=ownrky %>");
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
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<select name="RCPTTY" id="RCPTTY" class="input" Combo="SajoCommon,DOCUTY_COMCOMBO" ComboCodeView="true"></select> 
						</dd> 
					</dl> 
					<dl>  <!--출고거점-->  
						<dt CL="STD_NAME03B"></dt> 
						<dd> 
							<input type="text" class="input" name="A.WAREKY" UIInput="SR,SHCMCDV" />
						</dd> 
					</dl> 
					<dl>  <!--S/O 번호-->  
						<dt CL="IFT_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--요청일자-->  
						<dt CL="IFT_REQDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="OTRQDT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="A.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--승인여부-->  
						<dt CL="IFT_C00102"></dt> 
						<dd> 
							<select name="C00102" id="C00102" class="input" CommonCombo="C00102"></select> 
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
										<td GH="40" GCol="rowCheck"></td>																			
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   			    						
										<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="150 IFT_OWNRKY" GCol="select,OWNRKY"><!--화주-->
												<select class="input" Combo="SajoCommon,OWNRKYNM_COMCOMBO"></select>
			    						</td>
			    						<td GH="90 IFT_C00102" GCol="select,C00102"><!--승인여부-->
												<select class="input" commonCombo="C00102"></select>
			    						</td>
			    						<td GH="150 IFT_DOCUTY" GCol="select,DOCUTY"><!--출고유형-->
												<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
			    						</td>				    						
			    						<td GH="80 IFT_DOCUTYNM" GCol="text,SHORTX" GF="S 50">문서타입명</td>	<!--문서타입명-->
			    						<td GH="200 STD_WAREKY2" GCol="select,WARESR"><!--출고거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>				
			    						<td GH="200 STD_WAREKY3" GCol="select,WARETG"><!--도착거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>	
			    						<td GH="80 IFT_REQDAT" GCol="text,OTRQDT" GF="D 8">요청일자</td>	<!--요청일자-->
			    						<td GH="80 IFT_OTRQDT" GCol="text,ORDDAT" GF="C 8">출고요청일</td>	<!--출고요청일-->			    						
			    						<td GH="80 IFT_ORDTYP" GCol="text,ORDTYP" GF="S 7">주문/출고형태</td>	<!--주문/출고형태-->	    						
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
				</ul>
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList">
									<tr CGRow="true">
										<td GH="40" GCol="rowCheck"></td>																			
			    						<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td> <!--기본단위-->
										<td GH="80 STD_QTYORG" GCol="input,QTYORG" GF="N 13,0">실입고량</td>	<!--실입고량-->
    									<td GH="80 STD_OY01QTY1" GCol="text,TOQTSIWH" GF="N 13,0">출고거점재고수량</td>	<!--출고거점재고수량-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->			    						
			    						<td GH="100 IFT_TEXT01" GCol="text,TEXT01" GF="S 100">비고</td>	<!--비고-->  
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