<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>TM08</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">

	var GRPRL = 'ERPSO';
	var TOTALPICKING = 'N';
	var PROGID = 'TM08';
    var SVBELN = '';
    var searchparam;
    var savecheck = false;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "TM08_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "TM08"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "Outbound",
			command : "TM08_ITEM",
			pkcol : "OWNRKY,WAREKY,TASKKY",
			emptyMsgType : false,
		    menuId : "TM08"
	    });

		$("#OWNRKY").val("2200");
		// 대림 이고 전용 콤보로 세팅 
		$("#OWNRKY").on("change",function(){
			var param = new DataMap();
			param.put("OWNRKY",$(this).val());
			
			var json = netUtil.sendData({
				module : "SajoCommon",
				command : "WAREKYNM_IF2_COMCOMBO",
				sendType : "list",
				param : param
			}); 
			
			$("#WARETG").find("[UIOption]").remove();
			$("#WARERQ").find("[UIOption]").remove();
			
			var optionHtml = inputList.selectHtml(json.data, true);
			$("#WARETG").append(optionHtml);
			$("#WARERQ").append(optionHtml);
			
			var cnt = json.data.filter(function(element,index,array){
				return (element.VALUE_COL == '<%=wareky %>');
			});
			
			if(cnt.length == 0){
				$("#WARETG option:eq(0)").prop("selected",true); 
				$("#WARERQ option:eq(0)").prop("selected",true); 
			}else{
				$("#WARETG").val('<%=wareky %>');	
				$("#WARERQ").val('2219');	
			}

		}); 

		$("#OWNRKY").trigger('change');		
		$("#WARERQ").val('2219');
		
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
		
		if( $('#WARERQ').val() == null )
		{
			alert("* 출고거점은 필수 입력  입니다.");
			return ;
		} else if( $('#WARETG').val() == null )
		{
			alert("* 도착거점은 필수 입력  입니다.");
			return ;
		} 
		
		if(validate.check("searchArea")){
			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItemList");
			searchparam = inputList.setRangeParam("searchArea");			
			var group = $('input[name="GROUP"]:checked').attr('id');
			searchparam.put('SVBELN',SVBELN)	
			searchparam.put("DOCUTY", "266");
			savecheck = false;
			SVBELN = "";
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : searchparam
		    });
		}

	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(savecheck){
			return;
		}
		
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : searchparam
		    });
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
				if(colName == "SKUKEY"){
					var skukey = gridList.getColData(gridId, rowNum, "SKUKEY");
					if (skukey == '') {
						alert("품번을 입력 후 수량을 입력하실 수 있습니다.");
						gridList.setColValue(gridId, rowNum, "QTYORG", 0);
						gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
						gridList.setColValue(gridId, rowNum, "REMQTY", 0);
						gridList.setColValue(gridId, rowNum, "PLTQTY", 0);
						return;
					}
				}else if( colName == "QTYORG" ) {
					qtyorg = Number(gridList.getColData(gridId, rowNum, "QTYORG"));
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));					
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
				  	boxqty = floatingFloor((Number)(qtyorg)/(Number)(bxiqty), 1);
				 	remqty = (Number)(qtyorg)%(Number)(bxiqty);
				 	pltqty = floatingFloor((Number)(qtyorg)/(Number)(pliqty), 2);				 	
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					if(qtyorg == 0){
						gridList.setRowCheck(gridId, rowNum, false);
					}
				} else if( colName == "BOXQTY" ) {
					boxqty = (Number)(colValue);
					remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
					qtyorg = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				 	pltqty = floatingFloor((Number)(qtyorg)/(Number)(pliqty), 2);
				 	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "QTYORG", qtyorg);
					if(qtyorg == 0){
						gridList.setRowCheck(gridId, rowNum, false);
					}
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
					if(qtyorg == 0){
						gridList.setRowCheck(gridId, rowNum, false);
					}
				}
			}
		}			
	}
	
	  function save(){
		  if(savecheck){
				return;
			}
        var head = gridList.getGridData("gridHeadList");
        var item = gridList.getSelectData("gridItemList");
	
	    if(item.length == 0){
	      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
	      return;
	    }
	    
	    var qtychk = "";
		var syschk = "";
		var keychk = "";
		var orddat = head[0].get("ORDDAT");
		var otrqdt = head[0].get("OTRQDT");
    	var ordyy = orddat.substr(0,4);
		var ordmm = orddat.substr(4,2);
	    var orddd = orddat.substr(6,2);
	    var otryy = otrqdt.substr(0,4);
		var otrmm = otrqdt.substr(4,2);
	    var otrdd = otrqdt.substr(6,2);
	    var sysdate = new Date(); 
	    
	 	var orddate = new Date(Number(ordyy), Number(ordmm)-1, Number(orddd));
	 	var otrdate = new Date(Number(otryy), Number(otrmm)-1, Number(otrdd));
	 	
	 	if(Math.abs((orddate-sysdate)/1000/60/60/24) > 10 || Math.abs((otrdate-sysdate)/1000/60/60/24) > 10){
			alert("요청일 또는 출고일은 ±10일로 지정하셔야 합니다.") ;
			return;
		}  
	 	
	    if(item.length == 0){
		      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
		      return;
		    }
	 	
	    for(i=0; i<item.length; i++){
	    	var skukey = item[i].get("SKUKEY");
	    	if(skukey.trim() == "" ){
				alert("* 제품코드는  필수 입력 입니다. *");			
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
	      url : "/outbound/json/saveTM05.data",
	      param : param,
	      successFunction : "successSaveCallBack"
	    });
	  }
	  
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data != ""){			
				commonUtil.msgBox("SYSTEM_SAVEOK");
				SVBELN = json.data;
				savecheck = true;
				gridList.setReadOnly("gridHeadList", true);
				gridList.setColValue("gridHeadList", 0, "SVBELN", SVBELN, true);
				var list = gridList.getSelectData("gridItemList");
				
				var param = new DataMap();
			    param.put("list",list);
				
				netUtil.send({
					url : "/outbound/json/saveTM05return.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : "gridItemList" //그리드ID
				});
				
			}else if(json.data == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridItemList"){
			if(savecheck){
				gridList.setReadOnly("gridItemList", true);
			}else{
				gridList.setReadOnly("gridItemList", false);				
			}
		}else if(gridId == "gridHeadList"){
			if(savecheck){
				gridList.setReadOnly("gridHeadList", true);
			}else{
				gridList.setReadOnly("gridHeadList", false);				
			}
		}
	}

	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
	    }else if(btnName == "Save"){
	    	save();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "TM08");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "TM08");
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHCMCDV"){
            param.put("CMCDKY","PICGRP");
            param.put("USARG1","<%=ownrky %>");
        	
        }else if ($inputObj.name == "SM.SKUKEY" && searchCode == "SHSKUMA"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if (searchCode == "SHSKUMAGD"){
           var head = gridList.getSelectData("gridHeadList");	   
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }
        
    	return param;
    }
		
	//서치헬프 종료 이벤트
	 function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
		
	  if( searchCode == 'SHSKUMAGD'){
	   var gridId = "gridItemList"
	   var rowNum = gridList.getFocusRowNum(gridId);
	   var head = gridList.getSelectData("gridHeadList");	   
	   var ownrky = head[0].get("OWNRKY");	  
	   var waresr = head[0].get("WARESR");
	   var warerq = $('#WARERQ').val();	   
	   var skukey = rowData.get("SKUKEY")
	   
	   var param = new DataMap();
	   param.put("OWNRKY", ownrky);
	   param.put("WAREKY", waresr);
	   param.put("WARERQ", warerq);
	   param.put("SKUKEY", skukey);
	   
	   var json = netUtil.sendData({
			module : "Outbound",
			command : "TM05_SKUKEY_SHELP",
			sendType : "map",
			param : param
		}); 
	
			gridList.setColValue(gridId, rowNum, "SKUKEY", json.data.SKUKEY);
			gridList.setColValue(gridId, rowNum, "DESC01", json.data.DESC01);
			gridList.setColValue(gridId, rowNum, "DESC02", json.data.DESC02);
			gridList.setColValue(gridId, rowNum, "DUOMKY", json.data.DUOMKY);
			gridList.setColValue(gridId, rowNum, "QTYORG", json.data.QTYORG);
			gridList.setColValue(gridId, rowNum, "TOQTSIWH", json.data.TOQTSIWH);
			gridList.setColValue(gridId, rowNum, "PLIQTY", json.data.PLIQTY);
			gridList.setColValue(gridId, rowNum, "PLTQTY", json.data.PLTQTY);
			gridList.setColValue(gridId, rowNum, "BXIQTY", json.data.BXIQTY);
			gridList.setColValue(gridId, rowNum, "BOXQTY", json.data.BOXQTY);
			gridList.setColValue(gridId, rowNum, "REMQTY", json.data.REMQTY);
	  }
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
						<dt CL="STD_RCPTTY"></dt> 
						<dd> 
							<select name="RCPTTY" id="RCPTTY" class="input" Combo="SajoCommon,DOCUTY_COMCOMBO" ComboCodeView="true"></select> 
						</dd> 
					</dl> 
					<dl>  <!--수불조회일자-->  
						<dt CL="수불조회일자"></dt> 
						<dd> 
							<input type="text" class="input" name="ORDDAT" UIFormat="C N" validate="required(STD_ORDDAT)"/> 
						</dd> 
					</dl> 
					<dl> <!--출고거점--> 
						<dt CL="STD_WAREKY2"></dt>
						<dd>
							<select name="WARERQ" id=WARERQ class="input" ComboCodeView="true" disabled><option></option></select>
						</dd>
					</dl>
					<dl> <!--입고거점--> 
						<dt CL="STD_WARESR3"></dt>
						<dd>
							<select name="WARETG" id="WARETG" class="input" ComboCodeView="true"></select>
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
			    						<td GH="150 IFT_OWNRKY" GCol="select,OWNRKY"><!--화주-->
												<select class="input" Combo="SajoCommon,OWNRKYNM_COMCOMBO"></select>
			    						</td>
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 도착일" GCol="input,OTRQDT" GF="C 8">출고일자</td>	<!--출고일자-->
			    						<td GH="80 부산출고요청일" GCol="input,ORDDAT" GF="C 8">출고요청일</td>	<!--출고요청일-->			    						
			    						<td GH="150 IFT_DOCUTY" GCol="select,DOCUTY"><!--출고유형-->
												<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
			    						</td>				    						
			    						<td GH="200 STD_WAREKY" GCol="select,WAREKY"><!--거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>		    						
			    						<td GH="200 STD_WARESRREV" GCol="select,WARESR"><!--출고지시거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>				    						
			    						<td GH="200 STD_WARETG" GCol="select,WARETG"><!--도착거점-->
												<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"></select>
			    						</td>	
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
			    						<td GH="80 IFT_SKUKEY" GCol="input,SKUKEY,SHSKUMAGD" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="80 전일재고" GCol="text,STDQTY" GF="N 13,0">전일재고</td>	<!--전일재고-->
			    						<td GH="80 입고수량" GCol="text,QTYRCV" GF="N 13,0">입고수량</td>	<!--입고수량-->
			    						<td GH="80 출고수량" GCol="text,QTSHPD" GF="N 13,0">출고수량</td>	<!--출고수량-->
			    						<td GH="80 당일재고" GCol="text,STKQTY" GF="N 13,0">당일재고</td>	<!--당일재고-->
			    						<td GH="80 익일입고(D+1)" GCol="text,NUM02" GF="N 13,0">익일입고(D+1)</td>	<!--익일입고(D+1)-->
			    						<td GH="80 익일출고(D+1)" GCol="text,NUM01" GF="N 13,0">익일출고(D+1)</td>	<!--익일출고(D+1)-->
			    						<td GH="80 익일재고(D+1)" GCol="text,NUM03" GF="N 13,0">익일재고(D+1)</td>	<!--익일재고(D+1)-->
			    						<td GH="80 일평균출고량(D-7)" GCol="text,TOTSHP" GF="N 13,0">일평균출고량(D-7)</td>	<!--일평균출고량(D-7)-->
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td> <!--기본단위-->
			    						<td GH="80 요청수량" GCol="input,QTYORG" GF="N 13,0">요청수량</td>	<!--요청수량-->
			    						<td GH="80 출고거점재고수량" GCol="text,TOQTSIWH" GF="N 13,0">재고수량</td>	<!--재고수량-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,0">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->	
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