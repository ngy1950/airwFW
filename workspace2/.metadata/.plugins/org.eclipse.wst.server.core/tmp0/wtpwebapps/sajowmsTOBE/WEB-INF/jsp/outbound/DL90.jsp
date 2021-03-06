<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL90</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">

	var PROGID = 'DL90';
	var SHPOKYS = '';
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "DL90_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "DL90"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "Outbound",
			command : "DL90_ITEM_01",
			emptyMsgType : false,
		    menuId : "DL90"
	    });
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchwareky(val){
		var param = new DataMap();
		param.put("OWNRKY",val);
		
		var json = netUtil.sendData({
			module : "SajoCommon",
			command : "WAREKY_COMCOMBO",
			sendType : "list",
			param : param
		});
		
		$("#WAREKY").find("[UIOption]").remove();
		
		var optionHtml = inputList.selectHtml(json.data, false);
		$("#WAREKY").append(optionHtml);
		
		//SR.CARDAT 하루 더하기 
		inputList.rangeMap["map"]["SR.CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		inputList.rangeMap["map"]["SR.CARDAT"].valueChange();

	}
	
	function searchList(){
		gridList.resetGrid("gridItemList");
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");			
			var group = $('input[name="GROUP"]:checked').attr('id');
			param.put('PROGID',PROGID)	
			param.put('CLOSE', 'V')
			param.put('ADJUCA','400');
			if (SHPOKYS != "") {
				param.put('SADJKY',SHPOKYS);

				gridList.gridList({
			    	id : "gridHeadList",
			    	command : "DL90_HEAD_SAVED",
			    	param : param
			    });
			}else{
				gridList.gridList({
			    	id : "gridHeadList",
			    	param : param
			    });
			}
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.put('PROGID',PROGID)			
			param.putAll(rowData);		
			
			if (SHPOKYS != "") {
				param.put('SADJKY',SHPOKYS);
				param.put('SHPOKY', gridList.getColData("gridHeadList", 0, "SHPOKY"));
				param.put('SHPOIT', gridList.getColData("gridHeadList", 0, "SHPOIT"));


				gridList.gridList({
			    	id : "gridItemList",
			    	command : "DL90_ITEM_SAVED",
			    	param : param
			    });
			}else{
				
				gridList.gridList({
			    	id : "gridItemList",
			    	param : param
			    });
			}
			
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "400");
			param.put("DOCUTY", "425"); //[425]배송량조정
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("OWNRKY", $("#OWNRKY").val());
			param.put("DOCCAT", "400");
			param.put("DOCUTY", "425"); //[001]화주변경사유
		}
		return param;
	}

	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			if(colName == "QTADJU" || colName == "QTCALC" || colName == "BOXQTY" || colName == "PLTQTY" || colName == "REMQTY"){
	  			
				var qtadju = Number(gridList.getColData(gridId, rowNum, "QTADJU"));
				var qtcalc = Number(gridList.getColData(gridId, rowNum, "QTCALC"));
				var qtcavl = Number(gridList.getColData(gridId, rowNum, "QTCAVL"));
				var tmpqty = 0;
				var tmpqty2 = 0;
				var boxqty = 0;
				var pltqty = 0;
				var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY")) ;
				var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM")) ;
				var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
				var remqtyChk = 0;
				var remqty =0;
				
				if(qtadju > qtcavl){ //배송가능 수량 초과
					gridList.setColValue(gridId, rowNum, "QTADJU", 0);
					gridList.setColValue(gridId, rowNum, "QTCALC", qtcalc);
				}else if(qtcalc > qtcavl){ //배송가능 수량 초과
					gridList.setColValue(gridId, rowNum, "QTADJU", 0);
					gridList.setColValue(gridId, rowNum, "QTCALC", qtcalc);
				}else{
					if(colName == "QTADJU"){
						tmpqty  = Number(qtcavl) - Number(qtadju);
						gridList.setColValue(gridId, rowNum, "QTCALC", tmpqty);
						
					  	qtadju = colValue;
					  	boxqty = floatingFloor((Number)(qtadju)/(Number)(bxiqty), 1);
					  	remqty = (Number)(qtadju)%(Number)(bxiqty);
					  	pltqty = floatingFloor((Number)(qtadju)/(Number)(pliqty), 2);
					  	
						
					}else if(colName == "QTCALC" ){
						tmpqty  = Number(qtcavl) - Number(qtcalc);

						gridList.setColValue(gridId, rowNum, "QTADJU", tmpqty);
						qtadju = tmpqty;                                
						boxqty = 0;                                     
						pltqty = 0;                                     
						remqtyChk = 0;     
						
						qtadju = tmpqty;
						boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
						boxqty = floatingFloor((Number)(qtadju)/(Number)(bxiqty), 1); 
					  	remqty = (Number)(qtadju)%(Number)(bxiqty);
					  	pltqty = floatingFloor((Number)(qtadju)/(Number)(pliqty), 2);
					  	
					
					}  else if( colName == "BOXQTY" ){ 

					  	boxqty = colValue;
					  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
					  	qtadju = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty);
					  	pltqty = floatingFloor((Number)(qtadju)/(Number)(pliqty), 2);
					  	
					    remqty = 0;
					    
					    tmpqty  = Number(qtcavl) - Number(qtadju);
						gridList.setColValue(gridId, rowNum, "QTCALC", tmpqty);
						
						qtcavl = Number(gridList.getColData(gridId, rowNum, "QTCAVL"));
						tmpqty = 0;
						tmpqty2 = 0;
						if(Number(qtadju)>Number(qtcavl)){
							//alert("* 배송 가능수량을 초과하였습니다. *");	
							qtadju = 0;
							boxqty = 0;
							remqty = 0;
							gridList.setColValue(gridId, rowNum, "QTCALC", qtcavl);
							
					  	}
					}else if( colName == "remqty" ){

						qtadju = Number(gridList.getColData(gridId, rowNum, "QTADJU"));
						boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
					  	remqty = colValue;	

					  	remqtyChk = (Number)(remqty)%(Number)(bxiqty);
					  	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
					  	qtadju = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
					  	pltqty = floatingFloor((Number)(qtadju)/(Number)(pliqty), 2);
					  	
					  	remqty = remqtyChk;
					  	boxqty = boxqty; 
					  	pltqty = pltqty; 
					  	qtadju = qtadju; 
					  	qtcavl = Number(gridList.getColData(gridId, rowNum, "QTCAVL")); 
					  	tmpqty = Number(qtcavl) - Number(qtadju);
					  	tmpqty2 = 0;
						gridList.setColValue(gridId, rowNum, "QTCALC", tmpqty);
						
						if(Number(qtadju)>Number(qtcavl)){
							//alert("* 배송 가능수량을 초과하였습니다. *");	
							qtadju = 0;	
							gridList.setColValue(gridId, rowNum, "QTCALC", qtcavl);
							boxqty = 0;	
							remqty = 0;
					  	}	
					  }	
					}

					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "QTADJU", qtadju);
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
	    

		if(gridList.validationCheck("gridItemList", "select")){

			//item 저장불가 조건 체크
			var dupMap = new DataMap();
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if(Number(itemMap.QTADJU)< 1){
					//사유코드는 필수 입력입니다.
					commonUtil.msgBox("조정수량이 0 입니다.");
					return; 
				}
			}
		    	    
		    var param = new DataMap();
		    param.put("head",head);
		    param.put("item",item);
		    
	    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
	
		    //commonUtil.msgBox('사판 주문은 마감 되었습니다');
	        //return;
	
		    netUtil.send({
		      url : "/outbound/json/saveDL90.data",
		      param : param,
		      successFunction : "successSaveCallBack"
		    });
		}
	  }
	  
	function successSaveCallBack(json, status){
		if(json && json.data){
			
			if(json.data != ""){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				SHPOKYS = json.data;
				searchList();
				$("#btnTopSave").hide();
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
			SHPOKYS = "";

			$("#btnTopSave").show();
			searchList();
		}else if(btnName == "Create"){
			CreateOrderDocData();
	    }else if(btnName == "Save"){
	        save();
		}else if(btnName == "Reload"){
			reload();
		}else if(btnName == "RsnadjChk"){
		 	setChk("RSNADJ");
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL90");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL90");
		}
	}
	
    function setChk(type){
    	
    	//부분적용 사유코드  가져오기
		var rsnadj = $('#RSNADJCOMBO').val();
 	
		if(rsnadj == ""){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}
		// 그리드에서 선택 된 값 가져오기
		var selectDataList = gridList.getSelectData("gridItemList", true);
		
		for(var i=0; i<selectDataList.length; i++){
			if (type == "RSNADJ"){
				gridList.setColValue("gridItemList", selectDataList[i].get("GRowNum"), "RSNADJ", rsnadj);	// 그리드 조정사유코드 값 셋팅	
			}
		}
    }
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        	
        }else if(searchCode == "SHDOCTMIF"){
        	//nameArray 미존재
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "SH.DPTNKY"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "DIRDVY"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG08"){
            param.put("CMCDKY","PTNG08");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "PTNRTO"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "PTNROD"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG01"){
            param.put("CMCDKY","PTNG01");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG02"){
            param.put("CMCDKY","PTNG02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG03"){
            param.put("CMCDKY","PTNG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "WARESR"){
            param.put("CMCDKY","WARESR");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG05"){
            param.put("CMCDKY","SKUG05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCARMA2"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHSKUMA"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "ASKU05"){
            param.put("CMCDKY","ASKU05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG03"){
            param.put("CMCDKY","SKUG03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SKUG02"){
            param.put("CMCDKY","SKUG02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PICGRP"){
            param.put("CMCDKY","PICGRP");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHLOCMA"){
            param.put("WAREKY",$("#WAREKY").val());
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

	   
    //데이터가 바인드된후 
    function gridListEventDataBindEnd(gridId, dataLength, excelLoadType){
    	if(gridId=="gridItemList"){

    		gridList.setReadOnly("gridItemList", true, ["LOTA06", "ASKU05"]);
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
					<input type="button" id="btnTopSave" CB="Save SAVE BTN_SAVE" />
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
							<select name="WAREKY" id="WAREKY" class="input" ComboCodeView="true"></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_ADJUTY"></dt> <!-- 조정문서 유형 -->
						<dd>
							<select name="ADJUTY" id="ADJUTY" class="input" Combo="SajoCommon,DOCUTY_COMCOMBO" validate="required"></select>
						</dd>
					</dl>
					<dl>  <!--배송차수-->  
						<dt CL="STD_SHIPSQ"></dt> 
						<dd> 
							<input type="text" class="input" name="SR.SHIPSQ" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송일자-->  
						<dt CL="STD_CARDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="SR.CARDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--S/O 번호-->  
						<dt CL="IFT_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="SI.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고문서번호-->  
						<dt CL="STD_SHPOKY"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.SHPOKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서일자-->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.DOCDAT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고유형-->  
						<dt CL="STD_SHPMTY"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.SHPMTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl>  
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="SI.SKUKEY" UIInput="SR,SHSKUMAGD"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="SI.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--차량번호-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="SR.CARNUM" UIInput="SR,SHCARMA2"/> 
						</dd> 
					</dl> 
					<dl>  <!--업체코드-->  
						<dt CL="STD_DPTNKY"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.DPTNKY" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--업체명-->  
						<dt CL="STD_DPTNKYNM"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ.NAME01" UIInput="SR"/> 
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 20PX 0 15px;">
					</li>
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
									<!--화면에 조회 값과 상관없이 로우 선택하는 체크박스 확인   -->
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="150 STD_SADJKY" GCol="text,SADJKY" GF="S 10">조정문서번호</td>	<!--조정문서번호-->
			    						<td GH="150 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="150 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="150 STD_ADJUTY" GCol="text,ADJUTY" GF="S 4">조정문서 유형</td>	<!--조정문서 유형-->
			    						<td GH="150 STD_ADJUTYNM" GCol="text,ADJUTYNM" GF="S 100">유형명</td>	<!--유형명-->
			    						<td GH="150 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="150 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="150 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>	<!--문서유형명-->
			    						<td GH="180 STD_ADJUCA" GCol="text,ADJUCA" GF="S 4">조정 카테고리</td>	<!--조정 카테고리-->
			    						<td GH="180 STD_ADJUCANM" GCol="text,ADJUCANM" GF="S 100">조정카테고리명</td>	<!--조정카테고리명-->			    						
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">                                                                                                           
						<span CL="STD_RSNADJ" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>                                                                  
						<select name="RSNADJCOMBO" id="RSNADJCOMBO"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true"><option></option></select>       
					</li>   
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->                                                                                             
						<input type="button" CB="RsnadjChk SAVE BTN_PART" />                                                                                                   
					</li> 
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
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="100 STD_SHPOKY" GCol="text,REFDKY" GF="S 20">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="100 STD_SHPOIT" GCol="text,REFDIT" GF="S 6">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="88 STD_SHPMTY" GCol="text,SHPMTY" GF="S 60">출고유형</td>	<!--출고유형-->			    						
			    						<td GH="88 STD_SHPMTYNM" GCol="text,SHPMTYNM" GF="S 60">문서타입명</td>	<!--문서타입명-->
			    						<td GH="80 STD_LOCAKY" GCol="input,LOCAKY,SHLOCMA" GF="S 20"  validate="required">로케이션</td>	<!--로케이션-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="50 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="50 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="50 STD_TRNUID" GCol="input,TRNUID" GF="S 30">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="50 STD_QTSHPD" GCol="text,QTSHPD" GF="N 17,0">출고수량</td>	<!--출고수량-->
			    						<td GH="50 STD_QTCOMPD" GCol="text,QTCOMP" GF="N 17,0">피킹완료수량</td>	<!--피킹완료수량-->
			    						<td GH="50 STD_QTYFCNM" GCol="text,QTYFCN" GF="N 17,0">배송회수처리수량</td>	<!--배송회수처리수량-->
			    						<td GH="50 STD_QTCAVLM" GCol="text,QTCAVL" GF="N 17,0">배송량가능수량</td>	<!--배송량가능수량-->
			    						<td GH="50 STD_QTCALC" GCol="input,QTCALC" GF="N 17,0">실배송수량</td>	<!--실배송수량-->
			    						<td GH="50 STD_QTYPRCM" GCol="input,QTADJU" GF="N 17,0">배송회수수량</td>	<!--배송회수수량-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="140 STD_RSNADJ" GCol="select,RSNADJ"  validate="required"> <!--배송량조정사유코드-->
								        	<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option></option>
											</select>
								        </td> 
			    						<td GH="120 STD_ADJRSNRTN" GCol="input,ADJRSN" GF="S 120">배송량조정 상세사유</td>	<!--배송량조정 상세사유-->
			    						<td GH="50 STD_LOTA13" GCol="input,LOTA13" GF="C 14">유통기한</td>	<!--유통기한-->
			    						<td GH="50 STD_LOTA12" GCol="input,LOTA12" GF="C 14">입고일자</td>	<!--입고일자-->
			    						<td GH="120 STD_LOTA05" GCol="select,LOTA05"> <!--포장구분-->
								        	<select class="input" CommonCombo="LOTA05"></select>
								        </td> 
			    						<td GH="80 STD_LOTA06" GCol="select,LOTA06">	<!--재고유형-->
			    							<select class="input" commonCombo="LOTA06"></select>
			    						</td>
			    						<td GH="50 STD_LOTA11" GCol="input,LOTA11" GF="C 14">제조일자</td>	<!--제조일자-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						<td GH="88 STD_CARDAT" GCol="text,CARDAT" GF="D 60">배송일자</td>	<!--배송일자-->
			    						<td GH="88 STD_CARNUM" GCol="text,CARNUM" GF="S 60">차량번호</td>	<!--차량번호-->
			    						<td GH="88 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 60,0">배송차수</td>	<!--배송차수-->
			    						<td GH="88 STD_SORTSQ" GCol="text,SORTSQ" GF="N 60,0">배송순서</td>	<!--배송순서-->
			    						<td GH="88 STD_ARRIVA" GCol="text,ARRIVA" GF="S 80">도착권역</td>	<!--도착권역-->
			    						<td GH="88 STD_DRIVER" GCol="text,DRIVER" GF="S 60">기사명</td>	<!--기사명-->
			    						<td GH="88 STD_RECAYN" GCol="text,RECAYN" GF="S 60">재배차 여부</td>	<!--재배차 여부-->
			    						<td GH="50 STD_STOKKY" GCol="text,STOKKY" GF="S 10">재고키</td>	<!--재고키-->
			    						<td GH="50 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
			    						<td GH="50 STD_MEASKY" GCol="text,MEASKY" GF="S 20">단위구성</td>	<!--단위구성-->
			    						<td GH="50 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="80 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="200 STD_ASKU05"   GCol="select,ASKU05">
											<select commonCombo="ASKU05"><option></option></select><!--상온구분-->
										</td>
			    						<td GH="88 STD_DPTNKY" GCol="text,DPTNKY" GF="S 60">업체코드</td>	<!--업체코드-->
			    						<td GH="88 STD_DPTNKYNM" GCol="text,DPTNKYNM" GF="S 60">업체명</td>	<!--업체명-->
			    						<td GH="88 STD_DOCTXT" GCol="text,DOCTXT" GF="S 60">비고</td>	<!--비고-->
			    						<td GH="88 STD_PGRC02" GCol="text,PGRC02" GF="S 60">운송유형</td>	<!--운송유형-->
			    						<td GH="88 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 60">출고일자</td>	<!--출고일자-->
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