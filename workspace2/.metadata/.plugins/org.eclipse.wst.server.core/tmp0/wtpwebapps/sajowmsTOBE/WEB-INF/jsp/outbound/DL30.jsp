<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL30</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

	var GRPRL = '';
	var TOTALPICKING = 'N';
	var PROGID = 'DL30';
	var SHPOKYS = '';
	var tabNum = 0;
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "DL30_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItem01List",
			itemSearch : true,
			tempItem : "gridItem01List",
			useTemp : true,
		    tempKey : "SVBELN",
		    menuId : "DL30"
	    });
		
		gridList.setGrid({
	    	id : "gridItem01List",
			module : "Outbound",
			command : "DL30_ITEM",
			pkcol : "OWNRKY,WAREKY,SHPOKY",
			emptyMsgType : false,
		    tempKey : "SVBELN",
		    useTemp : true,
			tempHead : "gridHeadList",
		    menuId : "DL30"
	    });
		
		gridList.setGrid({
	    	id : "gridItem02List",
			module : "Outbound",
			command : "DL30_ITEM_02",
			pkcol : "OWNRKY,WAREKY,SHPOKY",
			emptyMsgType : false,
		    menuId : "DL30"
	    });
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();

		searchwareky($('#OWNRKY').val());
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력 
 		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "NEW");
		var rangeDataMap2 = new DataMap();
		// 필수값 입력 
		rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "PAL");
		var rangeDataMap3 = new DataMap();
		// 필수값 입력 
		rangeDataMap3.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap3.put(configData.INPUT_RANGE_SINGLE_DATA, "FAL");
		var rangeDataMap4 = new DataMap();
		// 필수값 입력 
		rangeDataMap4.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap4.put(configData.INPUT_RANGE_SINGLE_DATA, "PPC"); 
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);	
 		rangeArr.push(rangeDataMap2);	
		rangeArr.push(rangeDataMap3);	
		rangeArr.push(rangeDataMap4);	 
		setSingleRangeData('SH.STATDO', rangeArr);	
		
		// 다른페이지에서 받아온 데이터가 있을 경우
		var data = page.getLinkPageData("DL30");
		if(data){
	        var group = data.get("GRPRL");
			$('#OWNRKY').val(data.get("OWNRKY"));
			searchwareky(data.get("OWNRKY"));
			$('#WAREKY').val(data.get("WAREKY"));
			
			//배열선언
			var rangeArr = new Array();
			for(var i = 0; i < data.get("SHPOKY").length; i++){
				//배열내 들어갈 데이터 맵 선언
				rangeDataMap = new DataMap();
				// 필수값 입력 
		 		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		 		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, data.get("SHPOKY")[i]);
		 		rangeArr.push(rangeDataMap);
			}
			setSingleRangeData('SH.SHPOKY', rangeArr);
			
	        if (group == 'ERPSO'){
	        	$('input:radio[name=GROUP]').eq(0).attr("checked", true);
	        } else if (group == 'MOVE'){
	        	$('input:radio[name=GROUP]').eq(1).attr("checked", true);
	        } else if (group == 'PTNPUR'){
	        	$('input:radio[name=GROUP]').eq(2).attr("checked", true);
	        }
			searchList()
		}
		
		// 콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["DIRSUP", "DIRDVY", "SHPMTY"]);
		gridList.setReadOnly("gridItem01List", true, ["ASKU01", "ASKU02", "ASKU03","ASKU04","ASKU05"]);
		// DL09에서 던진 데이터가 있을 경우

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
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");			
			var group = $('input[name="GROUP"]:checked').attr('id');
			param.put('GRPRL', group)
			if (SHPOKYS != "") {
				$('#BTN_SAVECRE').hide();
				$('#BTN_ALLOCATE').hide();
				$('#BTN_ALLOCATE_ALL').hide();
				param.put('SHPOKYS',SHPOKYS);
				
				gridList.gridList({
			    	id : "gridHeadList",
			    	command : "DL24_HEAD",
			    	param : param
			    });
				
				var head = gridList.getGridData("gridHeadList");
				if (head.length > 0){
					var shpokys = SHPOKYS.split(",");
					var svbeln = gridList.getColData("gridHeadList", gridList.getFocusRowNum("gridHeadList"), "SVBELN");
					var shpoky = shpokys[0].replace("'","").replace("'","");
					param.put('SHPOKY',shpoky);
					param.put('SVBELN',svbeln);
					gridList.gridList({
				    	id : "gridItem01List",
				    	command : "DL30_ITEM",
				    	param : param
				    });					
						
					gridList.gridList({
				    	id : "gridItem02List",
				    	command : "DL30_ITEM_02",
				    	param : param
				    });		
				}

				SHPOKYS = '';
			} else {
				$('#BTN_SAVECRE').show();
				$('#BTN_ALLOCATE').show();
				$('#BTN_ALLOCATE_ALL').show();
				gridList.gridList({
			    	id : "gridHeadList",
			    	param : param
			    });				
			}
		}
	}
	
	function searchList2(){
		var gridId = 'gridHeadList';
		var rowNum = gridList.getFocusRowNum(gridId);
		var rowData = gridList.getRowData(gridId, rowNum);
		var param = inputList.setRangeParam("searchArea");
		param.put('PROGID',PROGID)	
		param.putAll(rowData);
		gridList.gridList({
	    	id : "gridItem02List",
	    	param : param
	    });
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.put('PROGID',PROGID)			
//			param.put('TOTALPICKING',TOTALPICKING) 
			param.putAll(rowData);
			if (SHPOKYS == ''){		
				
				if(tabNum == 0){
					gridList.gridList({
				    	id : "gridItem01List",
				    	param : param
				    });
				}else if(tabNum == 1){
					gridList.gridList({
				    	id : "gridItem02List",
				    	param : param
				    });
					
				}
				
			} else {
				SHPOKYS = '';
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
			} else if(name == "DRELIN"){
				param.put("CMCDKY", "DRELIN");	
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
		if(gridId == "gridItem01List"){
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
	
	
	function createOrderDoc(){		
        var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getSelectData("gridItem01List");
        //아이템 템프 가져오기
        var tempItem = gridList.getSelectTempData("gridHeadList");
          
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

       var param = new DataMap();
		param.put("head",head);
		param.put("item",item);
		param.put("itemTemp",tempItem);
		
    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
			return;
        }

		netUtil.send({
			url : "/outbound/json/createOrderDocDL01.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
 	}
	
	function remove(){		
        var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getSelectData("gridItem01List");
        //아이템 템프 가져오기
        var tempItem = gridList.getSelectTempData("gridHeadList");
         
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		for(var i=0; i<head.length; i++){

			var drelin = head[i].get("DRELIN");
			var statdo = head[i].get("STATDO");
			
			if("PPC" == statdo || "FPC" == statdo){
				commonUtil.msgBox("VALID_M0009");
				return;
			}else if("V" == drelin){
				alert("D/O전송된 주문은 삭제할 수 없습니다");
				return;
			}
	    }

       var param = new DataMap();
		param.put("head",head);
		param.put("item",item);
		param.put("itemTemp",tempItem);

		netUtil.send({
			url : "/outbound/json/removeDL30.data",
			param : param,
			successFunction : "successDeleteCallBack"
		});
 	}	
	
	function allocate(){		
        var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getSelectData("gridItem01List");
        //아이템 템프 가져오기
        var tempItem = gridList.getSelectTempData("gridHeadList");
          
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

       var param = new DataMap();
		param.put("head",head);
		param.put("item",item);
		param.put("itemTemp",tempItem);

		netUtil.send({
			url : "/outbound/json/allocateDL30.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}
	
	function unallocate(){		
        var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getSelectData("gridItem01List");
        //아이템 템프 가져오기
        var tempItem = gridList.getSelectTempData("gridHeadList");
          
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

       var param = new DataMap();
		param.put("head",head);
		param.put("item",item);
		param.put("itemTemp",tempItem);

		netUtil.send({
			url : "/outbound/json/unallocateDL30.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}
	function confirmOrderDoc(){		
        var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getSelectData("gridItem01List");
        //아이템 템프 가져오기
        var tempItem = gridList.getSelectTempData("gridHeadList");
         
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		for(var i=0; i<head.length; i++){

		var shpmty = head[i].get("SHPMTY");
		var shpoky = head[i].get("SHPOKY");
		var recocd = head[i].get("RECOCD");

		if(shpmty == "266" && (recocd > 0 )){
			alert( shpoky + " 출고문서번호는 미작업된 ITEM이 있어 D/O전송을 할 수 없습니다");
			return;
		}
	}

       var param = new DataMap();
		param.put("head",head);
		param.put("item",item);
		param.put("itemTemp",tempItem);

		netUtil.send({
			url : "/outbound/json/confirmOrderDocDL24.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}
	
	function confirmOrderDocAll(){	
		if(confirm("D/O 전송 하시겠습니까?")) {
			gridList.checkAll("gridHeadList",true);
			confirmOrderDoc();
		}		
	}
	
	function confirmOrderTask(){	

        var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getSelectData("gridItem01List");
        //아이템 템프 가져오기
        var tempItem = gridList.getSelectTempData("gridHeadList");

		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		for(var i=0; i<head.length; i++){

			var drelin = head[i].get("DRELIN");
			
			if("V" != drelin){
				alert("* 주문수량 전송후에 피킹완료 할 수 있습니다. *");
				return;
			}
	   }

       var param = new DataMap();
		param.put("head",head);
		param.put("item",item);
		param.put("itemTemp",tempItem);

		netUtil.send({
			url : "/outbound/json/confirmOrderTaskDL24.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data != ""){
				//템프 초기화
				gridList.resetTempData("gridHeadList");

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

	
	function successDeleteCallBack(json, status){
		if(json && json.data){
			if(json.data != ""){
				//템프 초기화
				gridList.resetTempData("gridHeadList");

				commonUtil.msgBox("SYSTEM_SAVEOK");
				SHPOKYS = "";
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

		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			var count = 0;
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
 
			var where = "";
			//반복문을 돌리며 특정 검색조건을 생성한다.
			for(var i =0;i < head.length ; i++){
				if(head[i].get("SHPOKY") !="299" && head[i].get("STATDO") !="NEW"){
					if(where == ""){
						where = where+" AND SH.SHPOKY IN (";
					}else{
						where = where+",";
					}
					
					where += "'" + head[i].get("SHPOKY") + "'";
					count++;
				}
			}
			where += ")";
			
			if(count < 1 ){
				commonUtil.msgBox("SYSTEM_NOTPR");
				return;
			}
			
			//아래의 구버전 소스를 신버전 소스로 변경(EZGEN IORDERBY 문자열을 생성한다) 			
			var orderby = " ORDER BY ";
			
			//신버전 코드 
			//라디오 버튼 값
			if ($('#PRT_ORD_LOCAKY').prop("checked") == true ) {
				orderby += "LOCASR";
			}else if ($('#PRT_ORD_SKUKEY').prop("checked") == true ){
				orderby += "DESC01,LOCASR";
			}else if ($('#PRT_ORD_TASKIT').prop("checked") == true ){
				orderby += "TASKIT";
			};
			
			//이지젠 호출부(신버전)
			var width = 840;
			var heigth = 600;
			var map = new DataMap();
			map.put("i_option",$('#OPTION').val());
			WriteEZgenElement("/ezgen/order_picking_list.ezg" , where , orderby , "KO", map , width , heigth );
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){			
			createOrderDoc();
		}else if(btnName == "Remove"){
			remove();
		}else if(btnName == "Allocate"){
			allocate();
		}else if(btnName == "Unallocate"){
			unallocate();
		}else if(btnName == "ConfirmOrderDoc"){
			confirmOrderDoc();
		}else if(btnName == "confirmOrderTask"){
			confirmOrderTask();
		}else if(btnName == "ConfirmOrderDocAll"){
			confirmOrderDocAll();
		}else if(btnName == "Reload"){
			reload();
		}else if (btnName == "Print"){
			print();
			
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "DL30");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "DL30");
 		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}else{
	    	gridListEventItemGridSearch("gridHeadList", gridList.getFocusRowNum("gridHeadList"), null);
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        //출고유형     
       	if(searchCode == "SHDOCTM" && $inputObj.name == "SH.SHPMTY"){
       		param.put("DOCCAT","200");
       	//납품처코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "SH.PTRCVR"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY","<%=ownrky %>");	
       	//매출처코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "SH.DPTNKY"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");	
        //제품코드
        }else if(searchCode == "SHSKUMA" && $inputObj.name == "SI.SKUKEY"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        //주문구분
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SH.PGRC03"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        //배송구분
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SH.PGRC02"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY","<%=ownrky %>"); 
        }
    	return param;
    }
	
    //텝이동시 작동
    function moveTab(obj){
    	if(obj == "1"){
    		$("#atab2-2").trigger("click");
    		//부족재고 조회 
			searchList2();
			tabNum = 1;
    	}else{
    		tabNum = 0;
    	}
	}
   
    //데이터가 바인드된후 
    function gridListEventDataBindEnd(gridId, dataLength, excelLoadType){
    	if(gridId=="gridHeadList"){

    		gridList.setReadOnly("gridHeadList", true, ["DIRSUP", "DIRDVY", "SHPMTY"]);
    	}
    }
    
  	//row 더블클릭
	function gridListEventRowDblclick(gridId,rowNum,colName){
		var data = gridList.getRowData(gridId, rowNum);
		var statit = data.map.STATIT;
		data.put("OWNRKY", $("#OWNRKY").val());
		data.put("WAREKY", $("#WAREKY").val());
		
		if(statit != "NEW" && statit != "PAL" && statit != "FAL" && statit != "PPC") 
			return;
		
		if(gridId == "gridItem01List" && colName == "QTALOC"){ 				//	  itemList에 할당수량 클릭 시 팝업 호출s
			var option = "height=480,width=1300,resizable=yes";
			page.linkPopOpen("/wms/outbound/pop/ManualAllocate.page", data, option);
			
		}else if(gridId == "gridItem01List" && colName == "QTUALO"){		//	  itemList에 미할당수량 클릭 시 팝업 호출
			var option = "height=400,width=860,resizable=yes";
			page.linkPopOpen("/wms/outbound/pop/UnallocatedInfo.page", data, option);
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
					<input type="button" CB="Remove SEARCH BTN_REMOVE" />
					<input type="button" CB="Allocate SAVE BTN_ALLOCATE" />
					<input type="button" CB="Unallocate SAVE BTN_UNALLOCATE" />
					<input type="button" CB="ConfirmOrderDoc SAVE BTN_CFM_ORDER_DOC" />
					<input type="button" CB="ConfirmOrderDocAll SAVE BTN_DRELIN_ALL" />
					<input type="button" CB="Print PRINT_OUT BTN_PKPRINT" />
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
					<dl>  <!--영업(D/O) -->
						<dt CL="STD_GROUP"></dt>
						<dd>
							<input type="radio" class="input" id="ERPSO"  name="GROUP" checked /> 영업
							<input type="radio" class="input" id="MOVE"   name="GROUP" /> 이고
							<input type="radio" class="input" id="PTNPUR" name="GROUP" /> 매입반품
						</dd>
					</dl>
					<dl>  <!--문서일자-->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.DOCDAT" id="DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="IFT_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.RQSHPD" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--S/O 번호-->  
						<dt CL="STD_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="SI.SVBELN" id="SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 					
					<dl>  <!--출고문서번호-->  
						<dt CL="STD_SHPOKY"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.SHPOKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고유형-->  
						<dt CL="STD_SHPMTY"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.SHPMTY" UIInput="SR,SHDOCTM"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서상태-->  
						<dt CL="STD_STATDO"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.STATDO" UIInput="SR" readonly="readonly"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.PTRCVR" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처명-->  
						<dt CL="IFT_PTNRTONM"></dt> 
						<dd> 
							<input type="text" class="input" name="BT.NAME01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--매출처코드-->  
						<dt CL="IFT_PTNROD"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.DPTNKY" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--매출처명-->  
						<dt CL="IFT_PTNRODNM"></dt> 
						<dd> 
							<input type="text" class="input" name="BP.NAME01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="SI.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.PGRC03" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.PGRC02" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--생성자-->  
						<dt CL="STD_CREUSR"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.CREUSR" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--D/O전송-->  
						<dt CL="STD_DRELIN"></dt> 
						<dd> 
							<select name="DRELIN" id="DRELIN" class="input" CommonCombo="DRELIN"></select> 
						</dd> 
					</dl> 
					<dl>  <!--오더할당연결번호-->  
						<dt CL="오더할당연결번호"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.USRID3" UIInput="SR"/> 
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
						<span CL="STD_PRINTOPT" style="PADDING: 0 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
						
						<input type="radio" CL="STD_LOCAORD" name="PRT_ORD" id="PRT_ORD_LOCAKY" checked /><label for="PRT_ORD_LOCAKY" style="margin-right:5px; margin-left:-23px">로케이션순 </label>
		        		<input type="radio" CL="STD_SKUORD" name="PRT_ORD" id="PRT_ORD_SKUKEY" /><label for="PRT_ORD_SKUKEY" style="margin-right:5px; margin-left:-23px">제품명순 </label>
		        		<input type="radio" CL="STD_ITEMORD" name="PRT_ORD" id="PRT_ORD_TASKIT" /><label for="PRT_ORD_TASKIT" style="margin-right:5px; margin-left:-23px">아이템번호순 </label>

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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_SHPMTY" GCol="select,SHPMTY">	<!-- 출고유형 -->
			    							<select class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select>
			    						</td>
			    						<td GH="80 STD_SHPMTYNM" GCol="text,SHPMTYNM" GF="S 20">문서타입명</td>	<!--문서타입명-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 20">문서상태명</td>	<!--문서상태명-->
			    						<td GH="50 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 4,0">배송차수</td>	<!--배송차수-->
			    						<td GH="50 STD_CARNUM" GCol="text,CARNUM" GF="S 4">차량번호</td>	<!--차량번호-->
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="55 STD_ALCCFM" GCol="text,DRELIN" GF="S 1">주문수량전송여부</td>	<!--주문수량전송여부-->
			    						<td GH="40 STD_DRELINNM" GCol="text,DRELINNM" GF="S 10">전송여부</td>	<!--전송여부-->
			    						<td GH="80 STD_RQSHPD" GCol="text,RQSHPD" GF="D 8">출고요청일자</td>	<!--출고요청일자-->
			    						<td GH="80 STD_RQARRD" GCol="text,RQARRD" GF="D 8">주문일자</td>	<!--주문일자-->
			    						<td GH="70 IFT_PTNROD" GCol="text,DPTNKY" GF="S 20">매출처코드</td>	<!--매출처코드-->
			    						<td GH="120 IFT_PTNRODNM" GCol="text,DPTNKYNM" GF="S 50">매출처명</td>	<!--매출처명-->
			    						<td GH="70 IFT_PTNRTO" GCol="text,PTRCVR" GF="S 20">납품처코드</td>	<!--납품처코드-->
			    						<td GH="120 IFT_PTNRTONM" GCol="text,PTRCVRNM" GF="S 50">납품처명</td>	<!--납품처명-->
			    						<td GH="40 STD_BOXQTY" GCol="text,SUMQTY" GF="N 13,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="90 IFT_DIRDVY" GCol="select,DIRDVY"><!--배송구분-->
												<select class="input" commonCombo="PGRC02"></select>
			    						</td>			    			
			    						<td GH="90 IFT_DIRSUP" GCol="select,DIRSUP"><!--주문구분-->
												<select class="input" commonCombo="PGRC03"></select>
			    						</td>
			    						<td GH="80 STD_IFNAME01" GCol="text,DEPTID1" GF="S 20">배송고객명</td>	<!--배송고객명-->
			    						<td GH="80 STD_IFNAME03" GCol="text,DNAME1" GF="S 20">배송자 전화번호1</td>	<!--배송자 전화번호1-->
			    						<td GH="80 STD_IFNAME04" GCol="text,USRID2" GF="S 20">배송자 전화번호2</td>	<!--배송자 전화번호2-->
			    						<td GH="80 STD_IFNAME02" GCol="text,USRID1" GF="S 20">배송지 우편번호</td>	<!--배송지 우편번호-->
			    						<td GH="80 STD_IFNAME05" GCol="text,UNAME1" GF="S 20">배송지 주소</td>	<!--배송지 주소-->
			    						<td GH="80 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 20">생성자명</td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 20">수정자명</td>	<!--수정자명-->
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
					<li onclick="moveTab(0);"><a href="#tab2-1" id="atab1"><span>Item리스트</span></a></li>
					<li onclick="moveTab(1);"><a href="#tab2-2" id="atab2"><span>미할당거래처정보</span></a></li>
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
						<span CL="STD_ALLOCATIONINFO" style="PADDING: 0 15PX; VERTICAL-ALIGN: MIDDLE;"></span>

					</li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>									                                                                                                           
				</ul>
				<div class="table_box section" id="tab2-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItem01List">
									<tr CGRow="true">
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_SHPOIT" GCol="text,SHPOIT" GF="N 6,0">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="80 STD_ALSTKY" GCol="text,ALSTKY" GF="S 10">할당전략키</td>	<!--할당전략키-->
			    						<td GH="80 STD_STATIT" GCol="text,STATITNM" GF="S 20">상태</td>	<!--상태-->
			    						<td GH="100 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						<td GH="70 STD_QTSORG" GCol="text,QTYORG" GF="N 20,0">원주문수량</td>	<!--원주문수량-->
			    						<td GH="70 STD_QTSHPO" GCol="text,QTSHPO" GF="N 20,0">지시수량</td>	<!--지시수량-->
			    						<td GH="70 STD_QTUALO" GCol="text,QTUALO" GF="N 20,0">미할당수량</td>	<!--미할당수량-->
			    						<td GH="70 STD_QTALOC" GCol="text,QTALOC" GF="N 20,0">할당수량</td>	<!--할당수량-->
			    						<td GH="70 STD_QTYPRE" GCol="text,QTYPRE" GF="N 20,0">선입고수량</td>	<!--선입고수량-->
			    						<td GH="70 STD_PKCMPL" GCol="text,QTJCMP" GF="N 20,0">피킹완료수량</td>	<!--피킹완료수량-->
			    						<td GH="70 STD_MEASKY" GCol="text,MEASKY" GF="S 10">단위구성</td>	<!--단위구성-->
			    						<td GH="70 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="200 STD_ASKU01"   GCol="select,ASKU01">
											<select commonCombo="ASKU01"><option></option></select>
										</td><!--포장단위-->
			    						
			    						<td GH="200 STD_ASKU02"   GCol="select,ASKU02">
											<select commonCombo="ASKU02"><option></option></select>
										</td><!--세트여부-->
			    						<td GH="200 STD_ASKU03"   GCol="select,ASKU03">
											<select commonCombo="ASKU03"><option></option></select>
										</td><!--피킹그룹-->
			    						
			    						<td GH="200 STD_ASKU04"   GCol="select,ASKU04">
											<select commonCombo="ASKU04"><option></option></select>
										</td><!--제품구분-->
			    						
			    						<td GH="200 STD_ASKU05"   GCol="select,ASKU05">
											<select commonCombo="ASKU05"><option></option></select>
										</td><!--상온구분-->
			    						<td GH="80 STD_GTINCD" GCol="text,GTINCD" GF="S 50">바코드</td>	<!--바코드-->
			    						<td GH="80 STD_EANCOD" GCol="text,EANCOD" GF="S 18">BARCODE(88코드)</td>	<!--BARCODE(88코드)-->
			    						<td GH="80 STD_GRSWGT" GCol="text,GRSWGT" GF="N 20,0">포장중량</td>	<!--포장중량-->
			    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 20,0">순중량</td>	<!--순중량-->
			    						<td GH="80 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="80 STD_LENGTH" GCol="text,LENGTH" GF="S 20">포장가로</td>	<!--포장가로-->
			    						<td GH="80 STD_WIDTHW" GCol="text,WIDTHW" GF="S 20">가로길이</td>	<!--가로길이-->
			    						<td GH="80 STD_HEIGHT" GCol="text,HEIGHT" GF="S 20">포장높이</td>	<!--포장높이-->
			    						<td GH="80 STD_CUBICM" GCol="text,CUBICM" GF="S 20">CBM</td>	<!--CBM-->
			    						<td GH="80 STD_CUBICT" GCol="text,CUBICT" GF="S 20">총CBM</td>	<!--총CBM-->
			    						<td GH="80 STD_CAPACT" GCol="text,CAPACT" GF="S 20">CAPA</td>	<!--CAPA-->
			    						<td GH="100 STD_DOCTXT" GCol="text,NAME01" GF="S 180">비고</td>	<!--비고-->
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
				
				<div class="table_box section" id="tab2-2" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItem02List">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="60 STD_PTNRKY" GCol="text,PTNRKY" GF="S 20">업체코드</td>	<!--업체코드-->
			    						<td GH="80 STD_PTNRNM" GCol="text,PTNRNM" GF="S 180">거래처명</td>	<!--거래처명-->
			    						<td GH="80 STD_TELN01" GCol="text,TELN01" GF="S 100">전화번호1</td>	<!--전화번호1-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 180">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_QTSHPO" GCol="text,QTSHPO" GF="N 17,0">지시수량</td>	<!--지시수량-->
			    						<td GH="80 STD_QTALOC" GCol="text,QTALOC" GF="N 17,0">할당수량</td>	<!--할당수량-->
			    						<td GH="80 STD_QTUALO" GCol="text,QTUALO" GF="N 17,0">미할당수량</td>	<!--미할당수량-->
			    						<td GH="80 STD_CPSTLZ" GCol="text,CPSTLZ" GF="S 10">우편번호</td>	<!--우편번호-->
			    						<td GH="80 STD_LAND1" GCol="text,LAND1" GF="S 3">국가 키 </td>	<!--국가 키 -->
			    						<td GH="80 STD_TELF1" GCol="text,TELF1" GF="S 50">전화번호1</td>	<!--전화번호1-->
			    						<td GH="80 STD_TELE2" GCol="text,TELE2" GF="S 31">전화번호2</td>	<!--전화번호2-->
			    						<td GH="80 STD_ADDR" GCol="text,ADDR" GF="S 360">주소</td>	<!--주소-->
			    						<td GH="80 STD_CNAME" GCol="text,CNAME" GF="S 50">거래처 담당자명</td>	<!--거래처 담당자명-->
			    						<td GH="80 STD_CPHON" GCol="text,CPHON" GF="S 20">거래처 담당자 전화번호</td>	<!--거래처 담당자 전화번호-->
			    						<td GH="80 STD_BNAME" GCol="text,BNAME" GF="S 50">영업사원명</td>	<!--영업사원명-->
			    						<td GH="80 STD_BPHON" GCol="text,BPHON" GF="S 20">영업사원 전화번호</td>	<!--영업사원 전화번호-->
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