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

	var GRPRL = 'ERPSO';
	var TOTALPICKING = 'N';
	var PROGID = 'TO30';
	var SHPOKYS = '';
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "TO30_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItemList",
			itemSearch : true,
		    menuId : "TO30"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "Outbound",
			command : "TO30_ITEM",
			pkcol : "OWNRKY,WAREKY,SHPOKY",
			emptyMsgType : false,
		    menuId : "TO30"
	    });
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());
		
	    //배열선언
	    var rangeArr = new Array();
	    //배열내 들어갈 데이터 맵 선언
	    var rangeDataMap = new DataMap();
	    // 필수값 입력
	  
	    rangeDataMap = new DataMap();
	    rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
	    rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
	    rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "331");
	    rangeArr.push(rangeDataMap);  
	    
	    rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "332");
		rangeArr.push(rangeDataMap); 
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "333");
		rangeArr.push(rangeDataMap);  
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "334");
		rangeArr.push(rangeDataMap);  
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "335");
		rangeArr.push(rangeDataMap);  
		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "380");
		rangeArr.push(rangeDataMap);  
	    
	    setSingleRangeData('TASOTY', rangeArr); 
	    
	    //배열선언
		var rangeArr2 = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap2 = new DataMap();
		// 필수값 입력
		rangeDataMap2.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "NEW");
		//배열에 맵 탑제 
		rangeArr2.push(rangeDataMap2);
	 	
		rangeDataMap2 = new DataMap();
		rangeDataMap2.put(configData.INPUT_RANGE_LOGICAL,"OR");
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "PPC");
		rangeArr2.push(rangeDataMap2); 

		setSingleRangeData('STATDO', rangeArr2); 

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
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCCAT", "400");
			param.put("DOCUTY", "425"); //[425]배송량조정
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
			param.put("OWNRKY", $("#OWNRKY").val());
			param.put("DOCCAT", "400");
//			param.put("DOCUTY", "440"); //[001]화주변경사유
		}
		return param;
	}

	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
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
	
	function confirmOrderTask(){    
      var head = gridList.getSelectData("gridHeadList");
      var item = gridList.getSelectData("gridItemList");
	        alert("!");
	  if(head.length == 0){
	    commonUtil.msgBox("SYSTEM_ROWSEMPTY");
	    return;
	  }
	  	
	  var param = new DataMap();
	  param.put("head",head);
	  param.put("item",item);
	
	  netUtil.send({
	    url : "/outbound/json/pickingTO30.data",
	    param : param,
	    successFunction : "successSaveCallBack"
	  });
	}

	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data != ""){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				TASKKYS = json.data;
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
		}else if(btnName == "Create"){
			CreateOrderDocData();
	    }else if(btnName == "confirmOrderTask"){
	    	confirmOrderTask();
		}else if(btnName == "Reload"){
			reload();
		}else if(btnName == "RsnadjChk"){
		 	setChk("RSNADJ");
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "TO30");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "TO30");
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
        }else if ($inputObj.name == "SKUKEY" && searchCode == "SHSKUMA"){
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
					<input type="button" CB="confirmOrderTask PICKED BTN_PICKED" />
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
					<dl>  <!--작업타입-->  
						<dt CL="STD_TASOTY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASOTY" UIInput="SR,SHDOCTM" readonly /> 
						</dd> 
					</dl> 
					<dl>  <!--작업지시번호-->  
						<dt CL="STD_TASKKY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASKKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서일자-->  
		            <dt CL="STD_DOCDAT"></dt> 
		            <dd> 
		              <input type="text" class="input" name="DOCDAT" UIInput="B" UIFormat="C N"/> 
		            </dd> 
		          </dl> 
		          <dl>  <!--문서상태-->  
		            <dt CL="STD_STATDO"></dt> 
		            <dd> 
		              <input type="text" class="input" name="STATDO" UIInput="SR,SHVSTATDO" readonly /> 
		            </dd> 
		          </dl>           
		          <dl>  <!--동-->  
		            <dt CL="STD_AREAKY"></dt> 
		            <dd> 
		              <input type="text" class="input" name="AREAKY" UIInput="SR,SHAREMA"/> 
		            </dd> 
		          </dl> 
		          <dl>  <!--제품코드-->  
		            <dt CL="STD_SKUKEY"></dt> 
		            <dd> 
		              <input type="text" class="input" name="SKUKEY" UIInput="SR,SHSKUMA"/> 
		            </dd> 
		          </dl> 
		          <dl>  <!--제품명-->  
		            <dt CL="STD_DESC01"></dt> 
		            <dd> 
		              <input type="text" class="input" name="DESC01" UIInput="SR" nonUpper="Y"/> 
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
					<li><a href="#tab1-1"><span>상세내역</span></a></li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle; PADDING:0 20PX 0 15px;">
					인쇄 - 아이템<!-- <input type="radio" class="input"  id="LOCAORD" name="PRINT" checked /> 로케이션
							<input type="radio" class="input" id="SKUORD"  name="PRINT" /> 제품명순
							<input type="radio" class="input" id="ITEMORD" name="PRINT" /> 아이템번호수 --> 
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
										  <td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="N 10,0">작업지시번호</td> <!--작업지시번호-->
					                      <td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
					                      <td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td> <!--거점명-->
					                      <td GH="80 STD_TASOTY" GCol="text,TASOTY" GF="N 4,0">작업타입</td>  <!--작업타입-->
					                      <td GH="80 STD_TASOTYNM" GCol="text,TASOTYNM" GF="S 100">작업타입명</td> <!--작업타입명-->
					                      <td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>  <!--문서일자-->
					                      <td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0">문서유형</td>  <!--문서유형-->
					                      <td GH="200 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>  <!--문서유형명-->
					                      <td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>  <!--문서상태-->
					                      <td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 100">문서상태명</td> <!--문서상태명-->
					                      <td GH="82 STD_WARETG" GCol="text,WARETG" GF="S 10">도착거점</td> <!--도착거점-->
					                      <td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>  <!--생성일자-->
					                      <td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td>  <!--생성시간-->
					                      <td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td>  <!--생성자-->
					                      <td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td> <!--생성자명-->
					                      <td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 60">수정일자</td> <!--수정일자-->
					                      <td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60">수정시간</td> <!--수정시간-->
					                      <td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td>  <!--수정자-->
					                      <td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60">수정자명</td> <!--수정자명-->
					                      <td GH="80 STD_ACCSEL" GCol="input,DOORKY" GF="S 10">계정</td>  <!--계정-->
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
					<li><a href="#tab1-1"><span>일반</span></a></li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
						<input type="checkbox" id="warechk" style="VERTICAL-ALIGN: MIDDLE;"/> 
						<span CL="STD_RSNADJ" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
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
										  <td GH="20 S" GCol="input,ROWCK" GF="S 1">S</td>  <!--S-->
					                      <td GH="50 STD_TASKTY" GCol="text,TASKTY" GF="S 3">작업타입</td>  <!--작업타입-->
					                      <td GH="50 STD_RSNCOD" GCol="text,RSNCOD" GF="S 4">사유코드</td>  <!--사유코드-->
					                      <td GH="200 STD_TASRSN" GCol="text,TASRSN" GF="S 127">상세사유</td> <!--상세사유-->
					                      <td GH="88 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td> <!--작업수량-->
					                      <td GH="80 STD_QTCOMP" GCol="text,QTCOMP" GF="N 20,0">완료수량</td> <!--완료수량-->
					                      <td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
					                      <td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>  <!--제품코드-->
					                      <td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td> <!--제품명-->
					                      <td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td> <!--규격-->
					                      <td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>  <!--로케이션-->
					                      <td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10">단위구성</td> <!--단위구성-->
					                      <td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3">단위</td>  <!--단위-->
					                      <td GH="88 STD_QTSDUM" GCol="text,QTSDUM" GF="S 11">기본UPM</td>  <!--기본UPM-->
					                      <td GH="80 STD_LOCATG" GCol="text,LOCATG" GF="S 20">To 로케이션</td>  <!--To 로케이션-->
					                      <td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>  <!--대분류-->
					                      <td GH="88 STD_GRSWGT" GCol="text,GRSWGT" GF="S 11">포장중량</td> <!--포장중량-->
					                      <td GH="88 STD_NETWGT" GCol="text,NETWGT" GF="S 11">순중량</td>  <!--순중량-->
					                      <td GH="88 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>  <!--중량단위-->
					                      <td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="S 11">포장가로</td> <!--포장가로-->
					                      <td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="S 11">가로길이</td> <!--가로길이-->
					                      <td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="S 11">포장높이</td> <!--포장높이-->
					                      <td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="S 11">CBM</td>  <!--CBM-->
					                      <td GH="88 STD_CAPACT" GCol="text,CAPACT" GF="S 11">CAPA</td> <!--CAPA-->
					                      <td GH="80 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td> <!--벤더-->
					                      <td GH="80 STD_LOTA03NM" GCol="text,LOTA03NM" GF="S 20">벤더명</td>  <!--벤더명-->
					                      <td GH="80 STD_LOTA05" GCol="text,LOTA05" GF="S 20">포장구분</td> <!--포장구분-->
					                      <td GH="80 STD_LOTA06" GCol="text,LOTA06" GF="S 20">재고유형</td> <!--재고유형-->
					                      <td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td> <!--제조일자-->
					                      <td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td> <!--입고일자-->
					                      <td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td> <!--유통기한-->
					                      <td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>  <!--동-->
					                      <td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>  <!--팔렛당수량-->
					                      <td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
					                      <td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td> <!--박스수량-->
					                      <td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>  <!--팔레트수량-->
					                      <td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
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