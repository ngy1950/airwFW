<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL85</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

	var GRPRL = 'ERPSO';
	var TOTALPICKING = 'N';
	var PROGID = 'DL85';
	var SHPOKYS = '';
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "DL85_HEAD",
			itemGrid : "gridItemList",
			itemSearch : true ,
		    menuId : "DL85"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "Outbound",
			command : "DL85_ITEM",
			emptyMsgType : false,
		    menuId : "DL85"
	    });
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());
		
		//SR.CARDAT 하루 더하기 
		inputList.rangeMap["map"]["SR.CARDAT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		inputList.rangeMap["map"]["SR.CARDAT"].valueChange();
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "PPC");
		var rangeDataMap2 = new DataMap();
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "FPC");
		var rangeDataMap3 = new DataMap();
		rangeDataMap3.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap3.put(configData.INPUT_RANGE_SINGLE_DATA, "REF");
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);		
		rangeArr.push(rangeDataMap2);		
		rangeArr.push(rangeDataMap3);		
		setSingleRangeData('STATDO', rangeArr);

		gridList.setReadOnly("gridItemList", true, ["VGBEL"]);

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
	}
	
	function searchList(){
		gridList.resetGrid("gridItemList");
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");			
			var group = $('input[name="GROUP"]:checked').attr('id');
			param.put('PROGID',PROGID)	
			param.put('CLOSE', 'V')
			param.put("RECAYN",$("#RECAYN").val())
			param.put("RECOYN",$("#RECOYN").val())
			if (SHPOKYS != "") {
				param.put('SHPOKYS',SHPOKYS);
			}
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
			param.put('PROGID',PROGID)			
//			param.put('TOTALPICKING',TOTALPICKING)
			param.putAll(rowData);		
			if (SHPOKYS != "") {
				param.put('SHPOKYS',SHPOKYS);
			} 
			
			gridList.gridList({
		    	id : "gridItemList",
		    	param : param
		    });
			
			SHPOKYS = '';							
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
			}else if(name == "RECOYN"){
				param.put("CMCDKY", "GATSTS");
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
		}else if( comboAtt == "SajoCommon,ALSTKY_COMCOMBO" ){			
			param.put("OWNRKY", "<%=ownrky%>");
			param.put("WAREKY", "<%=wareky%>");
			return param;
		}else if( comboAtt == "SajoCommon,RSNCOD_COMCOMBO" ){	
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "RSNCOMBO_ITEM"){
				param.put("OWNRKY", "<%=ownrky%>");
				param.put("DOCCAT", "200");
				param.put("DOCUTY", "210");
			}
			return param;
		}
		
		return param;
	}
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			if(colName == "RECOYN"){
				if(colValue == "Y"){
					gridList.setColValue(gridId, rowNum, "RECODT", dateParser(null, "S", 0, 0, 0));
				}else{
					gridList.setColValue(gridId, rowNum, "RECODT", " ");
				}
			}
				
		}else if(gridId == "gridItemList"){
			if(colName == "QTSHPO" || colName == "BOXQTY" || colName == "REMQTY"){
				var qtshpo = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var grswgt = 0;
				var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
				var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
				var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
				var grswgtcnt = Number(gridList.getColData(gridId, rowNum, "GRSWGTCNT"));
				var remqtyChk = 0;
								
			  	if( colName == "QTSHPO" ) { 		  		
			  		boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
				  	boxqty = floatingFloor((Number)(qtshpo)/(Number)(bxiqty), 1);
				  	remqty = (Number)(qtshpo)%(Number)(bxiqty);
				  	pltqty = floatingFloor((Number)(qtshpo)/(Number)(pliqty), 2);
				  	grswgt = qtshpo * grswgtcnt;
				  	
				  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				  }
				  if( colName == "BOXQTY" ){ //박스수량 변경시
					remqty = shpdi.GetCellValueById(rowId, "remqty");
				  	qtshpo = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				  	pltqty = floatingFloor((Number)(qtshpo)/(Number)(pliqty), 2);
				  	grswgt = qtshpo * grswgtcnt;
					  	
					//박스수량을 낱개수량으로 변경하여 계산한다.
				  	qtshpo = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				  	pltqty = floatingFloor((Number)(qtshpo)/(Number)(pliqty), 2);
				  	grswgt = qtshpo * grswgtcnt;
				  				  	
				  	//계산한 수량 세팅
				    gridList.setColValue(gridId, rowNum, "QTSHPO", qtshpo);
				    gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
				    gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				  }
				  if( colName == "REMQTY" ){ //잔량변경시
					qtshpo = Number(gridList.getColData(gridId, rowNum, "QTSHPO"));
			  		boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
						  
				  	remqtyChk = (Number)(remqty)%(Number)(bxiqty);
				  	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
				  	qtshpo = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
				  	pltqty = floatingFloor((Number)(qtshpo)/(Number)(pliqty), 2);
				  	grswgt = qtshpo * grswgtcnt;
				  	
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
				  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "QTSHPO", qtshpo);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
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
	    	    
	    var param = new DataMap();
	    param.put("head",head);
	    param.put("item",item);
	    
    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
			return;
        }

	    netUtil.send({
	      url : "/outbound/json/saveDL85.data",
	      param : param,
	      successFunction : "successSaveCallBack"
	    });
	  }
	  
	function successSaveCallBack(json, status){
		if(json && json.data){
			
			if(json.data != ""){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				SHPOKYS = json.data;
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

	
	//ezgen 구현
	function print(){
		var wherestr = " AND H.TASKKY IN (";

		var head = gridList.getSelectData("gridHeadList", true);
		var count = 0;
		//체크가 없을 경우 
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

		var where = "";
		var wherecar = "";
		//반복문을 돌리며 특정 검색조건을 생성한다.
		for(var i =0;i < head.length ; i++){
			if(where == ""){
				where = where+" AND SH.SHPOKY IN (";
				wherecar = wherecar+" AND (NVL(SR.CARNUM,' ')||TO_CHAR(NVL(SR.SHIPSQ,0))||NVL(SR.CARDAT,' ')) IN (";
			}else{
				where = where+",";
				wherecar = wherecar+",";
			}
			
			where += "'" + head[i].get("SHPOKY") + "'";
			wherecar += "'" + head[i].get("EZKEY") + "'";
			count++;
		}
		where += ")";
		wherecar+=") ";
				

		
		if(count < 1 ){
			commonUtil.msgBox("SYSTEM_NOTPR");
			return;
		}

		where = where + wherecar;	
		//아래의 구버전 소스를 신버전 소스로 변경(EZGEN IORDERBY 문자열을 생성한다) 			
		var orderby = " ";
		
		//이지젠 호출부(신버전)
		var width = 840;
		var heigth = 600;
		var map = new DataMap();
		map.put("i_option",$('#OPTION').val());
		WriteEZgenElement("/ezgen/shpdri_list2.ezg" , where , orderby , "KO", map , width , heigth );
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Create"){
			CreateOrderDocData();
	    }else if(btnName == "Save"){
	        save();
		}else if(btnName == "Reload"){
			reload();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL85");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL85");
		}else if(btnName == "Print"){
			print();
		}else if(btnName == "SetRecoyn"){
			setCode(btnName);
		}else if(btnName == "SetRsn"){
			setCode(btnName);
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
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "DIRDVY"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG08"){
            param.put("CMCDKY","PTNG08");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "SH.DPTNKY"){
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
            param.put("WAREKY","<%=wareky %>");
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
	
	function setCode(name){
		var target;
		var value;
		if(name=="SetRecoyn"){
			value = $("#RECOYN_ITEM").val();
			target = "RECOYN";
		}else if(name=="SetRsn"){
			value = $("#RSNCOMBO_ITEM").val();
			target = "RECOCD";
		}

		//체크한 값만 적용  
		var headList = gridList.getSelectData("gridHeadList");

		for(var i=0; i<headList.length; i++){
			gridList.setColValue("gridHeadList",headList[i].get("GRowNum"), target,  value);
			
			if(target == "RECOYN"){
				if(value == "Y"){
					gridList.setColValue("gridHeadList",headList[i].get("GRowNum"), "RECODT", dateParser(null, "S", 0, 0, 0));
				}else{
					gridList.setColValue("gridHeadList",headList[i].get("GRowNum"), "RECODT", " ");
				}
			}
				
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
					<input type="button" CB="Print PRINT_OUT BTN_SPDPRT" />
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
					<dl>  <!--배송일자-->  
						<dt CL="STD_CARDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="SR.CARDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송차수-->  
						<dt CL="STD_SHIPSQ"></dt> 
						<dd> 
							<input type="text" class="input" name="SR.SHIPSQ" UIInput="R"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고유형-->  
						<dt CL="STD_SHPMTY"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.SHPMTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고문서번호-->  
						<dt CL="STD_SHPOKY"></dt> 
						<dd> 
							<input type="text" class="input" name="SI.SHPOKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서일자-->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--업체코드-->  
						<dt CL="STD_DPTNKY"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.DPTNKY" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="SI.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--회수여부-->  
						<dt CL="STD_RECOYN"></dt> 
						<dd> 
							<select name="SR.RECOYN" id="RECOYN" class="input" CommonCombo="RECOYN">							
							<option value="ALL">[ALL] 전체</option>
							</select> 
						</dd> 
					</dl> 
					<dl>  <!--재배차 여부-->  
						<dt CL="STD_RECAYN"></dt> 
						<dd> 
							<select name="SR.RECAYN" id="RECAYN" class="input" CommonCombo="RECOYN">
							<option value="ALL">[ALL] 전체</option>
							</select> 
						</dd> 
					</dl> 
					<dl>  <!--차량번호-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="SR.CARNUM" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--차량 구분-->  
						<dt CL="STD_CARGBN"></dt> 
						<dd> 
							<input type="text" class="input" name="CM.CARGBN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--S/O 번호-->  
						<dt CL="STD_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="SI.SVBELN" UIInput="SR"/> 
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
					인쇄 - 아이템  <select name="OPTION" id="OPTION"  class="input" commonCombo="OPTION" ComboCodeView="true" ></select>
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 20PX 0 15px;">
						<span CL="STD_RECOYN" style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;"></span>
						<select name="RECOYN" id="RECOYN_ITEM"  class="input" Combo="SajoCommon,CMCDV_COMBO" ComboCodeView="true"></select>
						<input type="button" CB="SetRecoyn SAVE BTN_REFLECT" /> 
					</li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 20PX"> <!-- 사유코드 -->
						사유입력
						<select name="RSNCOMBO_ITEM" id="RSNCOMBO_ITEM"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true"></select>
						<input type="button" CB="SetRsn SAVE BTN_REFLECT" /> 
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
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="50 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="70 STD_SHIPTO" GCol="text,DPTNKY" GF="S 10">납품처</td>	<!--납품처-->
			    						<td GH="80 STD_SHIPTONM" GCol="text,DPTNKYNM" GF="S 30">납품처명</td>	<!--납품처명-->
			    						<td GH="80 STD_BOXQTYS" GCol="text,SUMQTY" GF="N 30">박스수량합계</td>	<!--박스수량합계-->
			    						<td GH="80 STD_SHPMTYNM" GCol="text,SHPMTYNM" GF="S 20">문서타입명</td>	<!--문서타입명-->
			    						<td GH="85 STD_CARDAT" GCol="text,CARDAT" GF="D 8">배송일자</td>	<!--배송일자-->
			    						<td GH="80 STD_RECOYN" GCol="select,RECOYN">
			    							<select class="input" name="RECOYN" Combo="SajoCommon,CMCDV_COMBO"></select>
			    						</td>	<!--회수여부-->
			    						<td GH="80 STD_RECOCD" GCol="select,RECOCD">
			    							<select class="input" name="RSNCOMBO_ITEM" Combo="SajoCommon,RSNCOD_COMCOMBO"><option></option></select>
										</td>	<!--미회수사유-->
			    						<td GH="80 STD_RECODT" GCol="input,RECODT" GF="C 100">회수일시</td>	<!--회수일시-->
			    						<td GH="80 STD_TEXT01" GCol="input,TEXT01" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 20">거점명</td>	<!--거점명-->
			    						<td GH="50 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="50 STD_RECNUM" GCol="text,RECNUM" GF="S 20">재배차 차량번호</td>	<!--재배차 차량번호-->
			    						<td GH="50 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 5,0">배송차수</td>	<!--배송차수-->
			    						<td GH="50 STD_SHPMTY" GCol="text,SHPMTY" GF="S 4">출고유형</td>	<!--출고유형-->
			    						<td GH="50 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 20">문서상태명</td>	<!--문서상태명-->
			    						<td GH="50 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="80 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 20">문서유형명</td>	<!--문서유형명-->
			    						<td GH="100 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="50 STD_RQSHPD" GCol="text,RQSHPD" GF="D 8">출고요청일자</td>	<!--출고요청일자-->
			    						<td GH="50 STD_RQARRD" GCol="text,RQARRD" GF="D 8">주문일자</td>	<!--주문일자-->
			    						<td GH="50 STD_RQARRT" GCol="text,RQARRT" GF="T 6">지시시간</td>	<!--지시시간-->
			    						<td GH="80 STD_CARGBN" GCol="text,CARGBN" GF="S 20">차량 구분</td>	<!--차량 구분-->
			    						<td GH="80 STD_RECAYN" GCol="text,RECAYN" GF="S 20">재배차 여부</td>	<!--재배차 여부-->
			    						<td GH="80 IFT_WARESRC" GCol="text,WARESR" GF="S 30">요구사업장</td>	<!--요구사업장-->
			    						<td GH="80 STD_RCUNAME2" GCol="text,NAME01" GF="S 30">요구사업장명</td>	<!--요구사업장명-->
			    						<td GH="80 배차메모" GCol="text,TEXT02" GF="S 100">배차메모</td>	<!--배차메모-->
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
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_FCARFLAG" GCol="select,VGBEL">
			    							<select class="input" commonCombo="FCARFLAG"></select>
			    						</td>	<!--최초배차여부-->
			    						<td GH="88 STD_ARRIVA" GCol="text,ARRIVA" GF="S 80">도착권역</td>	<!--도착권역-->
			    						<td GH="88 STD_CARDAT" GCol="text,CARDAT" GF="D 60">배송일자</td>	<!--배송일자-->
			    						<td GH="88 STD_CARNUM" GCol="text,CARNUM" GF="S 60">차량번호</td>	<!--차량번호-->
			    						<td GH="88 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 60,0">배송차수</td>	<!--배송차수-->
			    						<td GH="88 STD_SORTSQ" GCol="text,SORTSQ" GF="N 60,0">배송순서</td>	<!--배송순서-->
			    						<td GH="88 STD_DRIVER" GCol="text,DRIVER" GF="S 60">기사명</td>	<!--기사명-->
			    						<td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="80 STD_STATIT" GCol="text,STATITNM" GF="S 20">상태</td>	<!--상태-->
			    						<td GH="100 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="70 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="70 STD_QTSORG" GCol="text,QTYORG" GF="N 20,0">원주문수량</td>	<!--원주문수량-->
			    						<td GH="70 STD_QTSHPO" GCol="text,QTSHPO" GF="N 20,0">지시수량</td>	<!--지시수량-->
			    						<td GH="70 STD_QTALLM" GCol="text,QTALLM" GF="N 20,0">할당제한수량</td>	<!--할당제한수량-->
			    						<td GH="70 STD_QTUALO" GCol="text,QTUALO" GF="N 20,0">미할당수량</td>	<!--미할당수량-->
			    						<td GH="70 STD_QTALOC" GCol="text,QTALOC" GF="N 20,0">할당수량</td>	<!--할당수량-->
			    						<td GH="70 STD_PKCMPL" GCol="text,QTJCMP" GF="N 20,0">피킹완료수량</td>	<!--피킹완료수량-->
			    						<td GH="70 STD_SHCMPL" GCol="text,QTSHPD" GF="N 20,0">출고확정수량</td>	<!--출고확정수량-->
			    						<td GH="70 STD_MEASKY" GCol="text,MEASKY" GF="S 10">단위구성</td>	<!--단위구성-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_GRSWGT" GCol="text,GRSWGT" GF="N 20,0">포장중량</td>	<!--포장중량-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="80 STD_SHPOIT" GCol="text,SHPOIT" GF="N 6,0">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 20,0">순중량</td>	<!--순중량-->
			    						<td GH="80 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="80 STD_LENGTH" GCol="text,LENGTH" GF="S 20">포장가로</td>	<!--포장가로-->
			    						<td GH="80 STD_WIDTHW" GCol="text,WIDTHW" GF="S 20">가로길이</td>	<!--가로길이-->
			    						<td GH="80 STD_HEIGHT" GCol="text,HEIGHT" GF="S 20">포장높이</td>	<!--포장높이-->
			    						<td GH="80 STD_CUBICM" GCol="text,CUBICM" GF="S 20">CBM</td>	<!--CBM-->
			    						<td GH="80 STD_CUBICT" GCol="text,CUBICT" GF="S 20">총CBM</td>	<!--총CBM-->
			    						<td GH="80 STD_CAPACT" GCol="text,CAPACT" GF="S 20">CAPA</td>	<!--CAPA-->
			    						<td GH="88 STD_RECNUM" GCol="text,RECNUM" GF="S 60">재배차 차량번호</td>	<!--재배차 차량번호-->
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