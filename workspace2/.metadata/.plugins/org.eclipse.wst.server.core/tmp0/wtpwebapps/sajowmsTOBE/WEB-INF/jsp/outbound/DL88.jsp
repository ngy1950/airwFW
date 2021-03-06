<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL51</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
var target_gridId = "gridItemList1";
var param;
var itemBLlist = ["WARESR","WAREKY","WARESRNM","DIRDVY","DIRSUP","C00103"];
var SKUKEYS = '';
var SVBELNS = '';

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "OutBoundReport",
			command : "DL99_HEAD",
			pkcol : "OWNRKY,WAREKY,SVBELN",
			itemGrid : "gridItemList1",
			colorType : true,
			itemSearch : true,
			menuId : "DL88"
	    });
		
		// 오더 리스트(Item)
		gridList.setGrid({
	    	id : "gridItemList1",
			module : "OutBoundReport",
			command : "DL99_ITEM",
			menuId : "DL88"
	    });
	    
		//부족수량 오더 리스트(All)
		gridList.setGrid({
	    	id : "gridItemList2",
			menuId : "DL88"
	    });
		
		//오더 리스트(All)
		gridList.setGrid({
	    	id : "gridItemList3",
			menuId : "DL88"
	    });
		
		//WMS Shipment 릿트
		gridList.setGrid({
	    	id : "gridItemList4",
			menuId : "DL88"
	    });
		
    	$('#tab1ty1').show();
    	$('#tab1ty2').hide();
    	$('#tab1ty3').hide();
    	
		gridList.setReadOnly("gridItemList1", true, itemBLlist);
		gridList.setReadOnly("gridItemList2", true, itemBLlist);
		gridList.setReadOnly("gridItemList3", true, itemBLlist);
		gridList.setReadOnly("gridItemList4", true, itemBLlist);
		
		//배열선언
		var rangeArr = new Array();
		//배열내 들어갈 데이터 맵 선언
		var rangeDataMap = new DataMap();
		// 필수값 입력
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, dateParser(null, "S", 0, 0, 1));
		//배열에 맵 탑제 
		rangeArr.push(rangeDataMap);		
		setSingleRangeData("I.OTRQDT", rangeArr);
 		
		//배열선언
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
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"AND");
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SETLOC");
		
		rangeArr.push(rangeDataMap); 
		/*		
		rangeDataMap = new DataMap();
		rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
		rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "RCVFAC");
		rangeDataMap.put(configData.INPUT_RANGE_LOGICAL,"AND");
		rangeArr.push(rangeDataMap); 
		 */		
		setSingleRangeData('S.LOCAKY', rangeArr); 

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function saveData(){
		
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true); 
			
			//체크한 row중에 수정된 로우
			var item = gridList.getSelectData("gridItemList1");
			if(item.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//item 저장불가 조건 체크
			for(var i=0; i<item.length; i++){
				var itemMap = item[i].map;
				
				if(Number(itemMap.QTYORG) != Number(itemMap.QTYREQ)){
			 		if(itemMap.C00103.trim() == "" || itemMap.C00103.trim() == "N" ){
						commonUtil.msgBox("DAERIM_C00102NVL");//* 수량변경시 사유코드는 필수 입력 입니다. *
						return;
					}
				}
				
		 		if(Number(itemMap.WMSMGT) > 0){
					commonUtil.msgBox("DAERIM_WMSMGTNVL");//* 출고작업중인 주문 아이템은 변경할 수 없습니다. *
					return;
				}
		 		
				if(Number(itemMap.QTSHPD) > 0){
					commonUtil.msgBox("DAERIM_QTSHPDNVL");//* 부분출고완료된 주문 아이템 변경은 S/O마감을 통해서만 가능합니다. *
					return;
				}
			}

			var param = new DataMap();
			param.put("head",head);
			param.put("item",item);	
			
			if (!commonUtil.msgConfirm("SYSTEM_SAVECF")) {	// 저장하시겠습니까?
				return;	
			}

			netUtil.send({
				url : "/OutBoundReport/json/saveDL97.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}// end saveData()
	
	function searchList(){
		param = inputList.setRangeDataParam("searchArea");
		
		if($('#OWNRKY').val() == '2200' || $('#OWNRKY').val() == '2500'){
			if (SKUKEYS != "") {
				param.put('SKUKEYS',SKUKEYS);
			} 
			if (SVBELNS != "") {
				param.put('SVBELNS',SVBELNS);
			} 
			netUtil.send({
				url : "/OutBoundReport/json/displayDL88Head.data",
				param : param,
				sendType : "list",
				bindType : "grid",  //bindType grid 고정
				bindId : "gridHeadList" //그리드ID
			});
		} else {
			commonUtil.msgBox("STD_DR001");
			return;
		}
		
		$("#RSNCODCOMBO").val("선택");
		/* $('#atab1-1').trigger("click"); */
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList1");
		}else if(gridId == "gridHeadList" && dataCount > 0){

			var head = gridList.getGridData("gridHeadList");
			param.putAll(head[0]);
			
			if(SVBELNS == ""){
				$('#atab1-1').trigger("click");
			}
			gridList.getGridBox(gridId).viewTotal(true);
		}else if(gridId == "gridItemList1" && dataCount > 0){
			SKUKEYS = '';
			SVBELNS = '';
			var itemGridBox = gridList.getGridBox('gridItemList1');
			var itemList = itemGridBox.getDataAll();
	    	gridList.getGridBox(gridId).viewTotal(true);
			
 			for(var i=0; i<itemList.length; i++){
				gridList.setColValue("gridItemList1", itemList[i].get("GRowNum"), "C00103", "");	// 사유코드 초기 값 셋팅
				
				//이고주문 수정불가
				if(gridList.getColData("gridItemList1", itemList[i].get("GRowNum"), "DOCUTY") == '266' || gridList.getColData("gridItemList1", itemList[i].get("GRowNum"), "DOCUTY") == '267'){
					gridList.setRowReadOnly("gridItemList1", itemList[i].get("GRowNum"), true, ["WAREKY"]);
				}else{
					gridList.setRowReadOnly("gridItemList1", itemList[i].get("GRowNum"), false, ["WAREKY"]); 
				}
				

				//출고작업지시하지 않았을 경우 행 수정 불가 (ITEM)
				if(gridList.getColData("gridItemList1", itemList[i].get("GRowNum"), "C00102") == 'N' || gridList.getColData("gridItemList1", itemList[i].get("GRowNum"), "ORDTYP") == "UB"){
					gridList.setRowReadOnly("gridItemList1", itemList[i].get("GRowNum"), true, ["WAREKY" , "QTYREQ", "C00103"]); 
				}else{
					gridList.setRowReadOnly("gridItemList1", itemList[i].get("GRowNum"), false, ["WAREKY" , "QTYREQ", "C00103"]); 
				}

			} 
		}else if(gridId == "gridItemList3" && dataCount > 0){
			gridList.getGridBox(gridId).viewTotal(true);
		}else if(gridId == "gridItemList4" && dataCount > 0){
			gridList.getGridBox(gridId).viewTotal(true);
		}
	}

	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){

			$('#atab1-1').trigger("click");
		}
	}
 	
    function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
        
        if( gridId == "gridItemList1" ){
        	//gridList.setColValue("gridItemList1", rowNum, "C00103", "");	// 사유코드 초기 값 셋팅
        	var ordtyp = gridList.getColData("gridItemList1", rowNum, "ORDTYP");
        	var c00102 = gridList.getColData("gridItemList1", rowNum, "C00102");
			
        	if( (c00102 == 'N' && ordtyp != 'UB') ){
				gridList.setRowReadOnly("gridItemList1", rowNum, false, ["RSNCOD"]); 
				return true;		/* return true면 rowCheck 감춤 */
			}
        }
    }
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		param = new DataMap();
		if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}else if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
	        param.put("DOCCAT", "300");
	        param.put("DOCUTY", "399");
	        param.put("DIFLOC", "1");
	        param.put("OWNRKY", $("#OWNRKY").val());
		}else if(comboAtt ==  "SajoCommon,WAREKYNM_COMCOMBO_HP"){
			param.put("OWNRKY", "<%=ownrky%>");
			return param;
		}
		return param;
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["RESULT"] == "S"){
				gridList.setColValue("gridHeadList", 0, "PHYIKY", json.data["PHYIKY"]);
				SKUKEYS = json.data["SKUKEYS"];
				SVBELNS = json.data["SVBELNS"];
				commonUtil.msgBox("SYSTEM_SAVEOK");
				searchList()
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	
	function commonBtnClick(btnName) {
		if (btnName == "Search") {
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "DELETENEW"){
			deleteNew();
		}else if(btnName == "DELETEPAL"){
			deletePal();
		}else if(btnName == "DELETE"){
			delete3();
		}else if(btnName == "REALLOC"){
			realLoc();
		}else if(btnName == "UNALLOC"){
			unalLoc();
		}else if(btnName == "DRELIN"){
			drelin();
		}else if(btnName == "SetChk"){
			setChk();
		}else if (btnName == "ALLOC") {
			allocSave();
		}else if (btnName == "allocateSO") {
			allocateSO();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL88");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL88");
		}
	}
	
	// D/O 전송
	function drelin(){
		//체크한 row중에 수정된 로우
		var item = gridList.getGridData("gridItemList4");
		
		if(!commonUtil.msgConfirm("할당취소 하시겠습니까?")){  
			return;
        }
		
		var param = new DataMap();
		param.put("item",item);
		param.put("CREUSR", "<%=userid%>");
		
		netUtil.send({
			url : "/OutBoundReport/json/drelinDL88.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList4" //그리드ID
		});
		
	}
	
	// 할당취소
	function unalLoc(){
		//체크한 row중에 수정된 로우
		var item = gridList.getGridData("gridItemList4");
		
		if(!commonUtil.msgConfirm("할당취소 하시겠습니까?")){  
			return;
        }
		
		var param = new DataMap();
		param.put("item",item);
		param.put("CREUSR", "<%=userid%>");
		
		netUtil.send({
			url : "/OutBoundReport/json/unalLocDL88.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList4" //그리드ID
		});
		
	}
	
	// 할당
	function realLoc(){
		//체크한 row중에 수정된 로우
		var item = gridList.getGridData("gridItemList4");
		
		if(!commonUtil.msgConfirm("할당 하시겠습니까?")){  
			return;
        }
		
		var param = new DataMap();
		param.put("item",item);
		param.put("CREUSR", "<%=userid%>");
		
		netUtil.send({
			url : "/OutBoundReport/json/realLocDL88.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList4" //그리드ID
		});
		
	}
	
	// 전체삭제
	function delete3(){
		//체크한 row중에 수정된 로우
		var item = gridList.getGridData("gridItemList4");
		
		if(!commonUtil.msgConfirm("전체삭제 하시겠습니까?")){  
			return;
        }
		
		var param = new DataMap();
		param.put("item",item);
		param.put("CREUSR", "<%=userid%>");
		
		netUtil.send({
			url : "/OutBoundReport/json/deleteDL88.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList4" //그리드ID
		});
		
	}
	
	// 부분할당삭제
	function deletePal(){
		//체크한 row중에 수정된 로우
		var item = gridList.getGridData("gridItemList4");
		
		if(!commonUtil.msgConfirm("부분할당삭제 하시겠습니까?")){  
			return;
        }
		
		var param = new DataMap();
		param.put("item",item);
		param.put("CREUSR", "<%=userid%>");
		
		netUtil.send({
			url : "/OutBoundReport/json/deletePalDL88.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList4" //그리드ID
		});
		
	}
	
	// 미작업삭제
	function deleteNew(){
		//체크한 row중에 수정된 로우
		var item = gridList.getGridData("gridItemList4");
		
		if(!commonUtil.msgConfirm("미작업삭제 하시겠습니까?")){  
			return;
        }
		
		var param = new DataMap();
		param.put("item",item);
		param.put("CREUSR", "<%=userid%>");
		
		netUtil.send({
			url : "/OutBoundReport/json/deleteNewDL88.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList4" //그리드ID
		});
		
	}
	
	function allocSave(){
		//체크한 row중에 수정된 로우
		var item = gridList.getGridData("gridItemList3");
		
		if (item.length == 0) {
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		if(!commonUtil.msgConfirm("할당하시겠습니까?")){  
			return;
        }
		
		var param = new DataMap();
		param.put("item",item);
		param.put("CREUSR", "<%=userid%>");
		
		netUtil.send({
			url : "/OutBoundReport/json/allocSaveDL88.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList4" //그리드ID
		});
		
		$('#atab1-4').trigger("click");
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
	    param = new DataMap();
	    
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
		//세트여부
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "S.ASKU02"){
	        param.put("CMCDKY","ASKU02");
	    	param.put("OWNRKY","<%=ownrky %>");  
		//주문구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRSUP"){
	        param.put("CMCDKY","PGRC03");
	    	param.put("OWNRKY","<%=ownrky %>"); 
		//배송구분
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "I.DIRDVY"){
	        param.put("CMCDKY","PGRC02");
	    	param.put("OWNRKY","<%=ownrky %>");   
		//중분류
		}else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG02"){
	        param.put("CMCDKY","SKUG02");
	   		param.put("OWNRKY","<%=ownrky %>");
		//소분류
		} else if(searchCode == "SHCMCDV" && $inputObj.name == "S.SKUG03"){
	        param.put("CMCDKY","SKUG03");
	        param.put("OWNRKY","<%=ownrky %>");
		//로케이션
	    } else if(searchCode == "SHLOCMA" && $inputObj.name == "S.LOCAKY"){
		    param.put("WAREKY","<%=wareky %>");	
	    } return param;
	}	   
	
	//그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
	function gridListColTextColorChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridHeadList"){
			var target_col = ["OWNRKY","WAREKY","SKUKEY","DESC01","BXIQTY","BOXQTY1","QTSIWH1","BOXQTY2","QTSIWH2","BOXQTY3","BOXQTY3","QTSIWH3",
			                  "QTSIWH4","BOXQTY4","QTSIWH5","BOXQTY5","QTSIWH6","BOXQTY6","QTSIWH7","BOXQTY7","OTRQDT","QTYPRE" ];
			
			for(var i=0; i<target_col.length; i++){
				if( colName == target_col[i] ){
					var boxqty3 = gridList.getColData(gridId, rowNum, "BOXQTY3");
					var qtsiwh3 = gridList.getColData(gridId, rowNum, "QTSIWH3");
					if(Number(boxqty3) < 0 || Number(qtsiwh3) < 0){
						return configData.GRID_COLOR_TEXT_RED_CLASS;	
					}
				}
			}
		}
	}
	
	//텝이동시 작동
    function moveTab(obj){
    	var tabNm = obj.attr('href');
    	target_gridId = "gridItemList"+tabNm.charAt(tabNm.length-1);
    	$('#tab1ty1').hide();
    	$('#tab1ty2').hide();
    	$('#tab1ty3').hide();
    	
    	
		gridList.resetGrid("gridItemList1");
		gridList.resetGrid("gridItemList2");
		gridList.resetGrid("gridItemList3");
		gridList.resetGrid("gridItemList4");
    	
		if(validate.check("searchArea")){
			//param = inputList.setRangeDataParam("searchArea");
			
			if($('#CHKMAK').prop("checked") == false){
				param.put("CHKMAK","");
			}else if($('#CHKMAK').prop("checked") == true){
				param.put("CHKMAK","1");
			}
			
		 	if($('#OWNRKY').val() == '2200' || $('#OWNRKY').val() == '2500'){
				// 부족수량 오더 리스트(All)
				if(target_gridId == "gridItemList2"){
					netUtil.send({
						url : "/OutBoundReport/json/displayDL88Item2.data",
						param : param,
						sendType : "list",
						bindType : "grid",  //bindType grid 고정
						bindId : target_gridId //그리드ID
					});
					
				// 오더 리스트(All)
				}else if(target_gridId == "gridItemList3"){
					netUtil.send({
						url : "/OutBoundReport/json/displayDL88Item3.data",
						param : param,
						sendType : "list",
						bindType : "grid",  //bindType grid 고정
						bindId : target_gridId //그리드ID
					});
					
					$('#tab1ty2').show();
				// WMS Shipment 리스트
				}else if(target_gridId == "gridItemList4"){
/* 					netUtil.send({
						url : "/OutBoundReport/json/displayDL88Item4.data",
						param : param,
						sendType : "list",
						bindType : "grid",  //bindType grid 고정
						bindId : target_gridId //그리드ID
					}); */
					
					$('#tab1ty3').show();
				// 오더 리스트(item)
				}else{
					netUtil.send({
						url : "/OutBoundReport/json/displayDL55Item.data",
						param : param,
						sendType : "list",
						bindType : "grid",  //bindType grid 고정
						bindId : "gridItemList1" //그리드ID
					});
					$('#tab1ty1').show();
				} 
			} else {
				commonUtil.msgBox("STD_DR001");
				return;
			} 
		}
	}
	
	function setChk(){
		
		var rsncod = $("#RSNCODCOMBO").val();	//인풋값 가져오기
		var selectDataList = gridList.getSelectData("gridItemList1", true);	// 그리드에서 선택 된 값 가져오기

		if(rsncod == ""){
			commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
			return;
		}

		for(var i=0; i<selectDataList.length; i++){
			gridList.setColValue("gridItemList1", selectDataList[i].get("GRowNum"), "C00103", rsncod);	// 그리드 사유코드 값 셋팅
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
						
			
			// 부족수량 오더 리스트(All)
			if(target_gridId == "gridItemList2"){
				netUtil.send({
					url : "/OutBoundReport/json/displayDL88Item2.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : target_gridId //그리드ID
				});
				
			// 오더 리스트(All)
			}else if(target_gridId == "gridItemList3"){
				netUtil.send({
					url : "/OutBoundReport/json/displayDL88Item3.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : target_gridId //그리드ID
				});
				
			// WMS Shipment 리스트
			}else if(target_gridId == "gridItemList4"){
/* 				netUtil.send({
					url : "/OutBoundReport/json/displayDL88Item4.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : target_gridId //그리드ID
				}); */
				
			// 오더 리스트(item)
			}else{
				netUtil.send({
					url : "/OutBoundReport/json/displayDL55Item.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : "gridItemList1" //그리드ID
				});
			} 
			
		}
	}
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList1"){
			 if(colName == "QTYREQ" || colName == "BOXQTY" || colName == "REMQTY" ){
					var qtyreq = 0;
					var boxqty = 0;
					var remqty = 0;
					var pltqty = 0;
					var grswgt = 0;
					var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
					var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
					var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
					var remqtyChk = 0;
					
				  if( colName == "QTYREQ" ) { 
					qtyreq = colValue;
				  	boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
				  	boxqty = floatingFloor((Number)(qtyreq)/(Number)(bxiqty), 1);
				  	remqty = (Number)(qtyreq)%(Number)(bxiqty);
				  	pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
				  					  	
				  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt);
				  }
				  
				  if( colName == "BOXQTY" ){ //박스수량 변경시
					boxqty = colValue;
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
				  	qtyreq = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				  	pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
				  	
				  	gridList.setColValue(gridId, rowNum, "QTYREQ", qtyreq);
				  	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
				  }
				  
				  if( colName == "REMQTY" ){//잔량변경시
				  	qtyreq = Number(gridList.getColData(gridId, rowNum, "QTYREQ"));
				  	boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
				  	remqty = colValue;
				  	
				  	remqtyChk = (Number)(remqty)%(Number)(bxiqty);
				  	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
				  	qtyreq = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
				  	pltqty = floatingFloor((Number)(qtyreq)/(Number)(pliqty), 2);
				  	
				  	gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
				  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
				  	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);	
				  	gridList.setColValue(gridId, rowNum, "QTYREQ", qtyreq); 
				  }	
				  
				  var tmpqtyreq = Number(gridList.getColData(gridId, rowNum, "QTYREQ"));
				  var tmpqtyorg = Number(gridList.getColData(gridId, rowNum, "QTYORG"));
				
				  if( Number(tmpqtyorg)!= Number(tmpqtyreq) ){
					gridList.setRowReadOnly(gridId, rowNum, false, ["C00103"]);
				  }else {
					gridList.setRowReadOnly(gridId, rowNum, true, ["C00103"]);
				  }
				  
			}
			 
			} else if( colName == "C00103" ){
				var c00103 = Number(gridList.getColData(gridId, rowNum, "C00103"));
				if(Number(c00103) < 900){
					alert('사용할 수 없는 사유코드 입니다.');
					gridList.setColValue(gridId, rowNum, "C00103", " ");
				}
			} 
	}
	
    function linkPopCloseEvent(data){//팝업 종료 
    	if(data.get("TYPE") == "GET"){ 
    		sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
    	}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
    }

	function allocateSO(){
		//체크한 row중에 수정된 로우
		var item = gridList.getGridData("gridItemList3");
		
		if (item.length == 0) {
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		if(!commonUtil.msgConfirm("할당하시겠습니까?")){  
			return;
        }
		
		var param = new DataMap();
		param.put("item",item);
		param.put("CREUSR", "<%=userid%>");
		
		netUtil.send({
			url : "/OutBoundReport/json/allocateSODL88.data",
			param : param,
			sendType : "list",
			bindType : "grid",  //bindType grid 고정
			bindId : "gridItemList4" //그리드ID
		});
		
		$('#atab1-4').trigger("click");
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
						<dt CL="STD_OWNRKY"></dt> <!--화주-->
						<dd>
							<select name="OWNRKY" id="OWNRKY" class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true" ></select>
						</dd>
					</dl>
					<dl>
						<dt CL="STD_WAREKY"></dt> <!--거점-->
						<dd>
							<select name="WAREKY" id="WAREKY" class="input" ></select>
						</dd>
					</dl>
					<dl>  <!--S/O 번호-->  
						<dt CL="IFT_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="I.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="IFT_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="I.OTRQDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl>
					<dl>  <!--주문/출고형태-->  
						<dt CL="IFT_ORDTYP"></dt> 
						<dd> 
							<input type="text" class="input" name="I.ORDTYP" UIInput="SR"  /> 
						</dd> 
					</dl> 
					
					<dl>  <!--출고일자-->  
						<dt CL="IFT_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="I.ORDDAT" UIInput="B" UIFormat="C" /> 
						</dd> 
					</dl>  
					<dl>  <!--주문일자-->  
						<dt CL="STD_CTODDT"></dt> 
						<dd> 
							<input type="text" class="input" name="I.ERPCDT" UIInput="B" UIFormat="C" /> 
						</dd> 
					</dl> 
					<dl>  <!--요청사업장-->  
						<dt CL="STD_IFPGRC04"></dt> 
						<dd> 
							<input type="text" class="input" name="I.WARESR" UIInput="SR,SHWAHMA" UiRange="2"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNRTO" UIInput="SR,SHBZPTN" /> 
						</dd> 
					</dl> 
					
					<dl>  <!--매출처코드-->  
						<dt CL="IFT_PTNROD"></dt> 
						<dd> 
							<input type="text" class="input" name="I.PTNROD" UIInput="SR,SHBZPTN" /> 
						</dd> 
					</dl> 
					
					<dl>  <!--제품코드-->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--세트여부-->  
						<dt CL="STD_ASKU02"></dt> 
						<dd> 
							<input type="text" class="input" name="S.ASKU02" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DIRSUP" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="I.DIRDVY" UIInput="SR,SHCMCDV" /> 
						</dd> 
					</dl> 
					
					<dl>  <!--요청수량-->  
						<dt CL="IFT_QTYORG"></dt> 
						<dd> 
							<input type="text" class="input" name="I.QTYORG" UIInput="SR" /> 
						</dd> 
					</dl> 
					
<!-- 					<dl>  차량번호   -->
<!-- 						<dt CL="STD_CARNUM"></dt>  -->
<!-- 						<dd>  -->
<!-- 							<input type="text" class="input" name="C.CARNUM" UIInput="SR" />  -->
<!-- 						</dd>  -->
<!-- 					</dl>  -->
					
<!-- 					<dl>  중분류   -->
<!-- 						<dt CL="STD_SKUG02"></dt>  -->
<!-- 						<dd>  -->
<!-- 							<input type="text" class="input" name="S.SKUG02" UIInput="SR,SHCMCDV"/>  -->
<!-- 						</dd>  -->
<!-- 					</dl>  -->
					
<!-- 					<dl>  소분류   -->
<!-- 						<dt CL="STD_SKUG03"></dt>  -->
<!-- 						<dd>  -->
<!-- 							<input type="text" class="input" name="S.SKUG03" UIInput="SR,SHCMCDV" />  -->
<!-- 						</dd>  -->
<!-- 					</dl>  -->
					<dl>  <!--포장구분-->  
						<dt CL="STD_LOTA05"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--재고유형-->  
						<dt CL="STD_LOTA06"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA06" value="00"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA" value="RCVLOC" readonly="readonly"/> 
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
									<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
		    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
		    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
		    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
		    						<td GH="80 선입고수량(BOX)" GCol="text,QTYPRE" GF="N 80,1">선입고수량(BOX)</td>	<!--선입고수량(BOX)-->
		    						<td GH="80 유통선입고수량(낱개)" GCol="text,QTYPRE2" GF="N 80,1">유통선입고수량(낱개)</td>	<!--유통선입고수량(낱개)-->
		    						<td GH="80 유통선입고수량(BOX)" GCol="text,BOXPRE2" GF="N 80,1">유통선입고수량(BOX)</td>	<!--유통선입고수량(BOX)-->
		    						<td GH="80 안성물류(BOX)" GCol="text,BOXWH1" GF="N 80,1">안성물류(BOX)</td>	<!--안성물류(BOX)-->
		    						<td GH="80 안성물류(낱개)" GCol="text,QTYWH1" GF="N 80,1">안성물류(낱개)</td>	<!--안성물류(낱개)-->
		    						<td GH="80 칠서물류(BOX)" GCol="text,BOXWH2" GF="N 80,1">칠서물류(BOX)</td>	<!--칠서물류(BOX)-->
		    						<td GH="80 칠서물류(낱개)" GCol="text,QTYWH2" GF="N 80,1">칠서물류(낱개)</td>	<!--칠서물류(낱개)-->
		    						<td GH="80 인천물류(BOX)" GCol="text,BOXWH3" GF="N 80,1">인천물류(BOX)</td>	<!--인천물류(BOX)-->
		    						<td GH="80 인천물류(낱개)" GCol="text,QTYWH3" GF="N 80,1">인천물류(낱개)</td>	<!--인천물류(낱개)-->
		    						<td GH="80 양지물류(BOX)" GCol="text,BOXWH4" GF="N 80,1">양지물류(BOX)</td>	<!--양지물류(BOX)-->
		    						<td GH="80 기흥물류(낱개)" GCol="text,QTYWH4" GF="N 80,1">기흥물류(낱개)</td>	<!--기흥물류(낱개)-->
		    						<td GH="80 미확정수량(BOX)" GCol="text,BOXWH4_2" GF="N 80,1">미확정수량(BOX)</td>	<!--미확정수량(BOX)-->
		    						<td GH="80 미확정수량(낱개)" GCol="text,QTYWH4_2" GF="N 80,1">미확정수량(낱개)</td>	<!--미확정수량(낱개)-->
		    						<td GH="80 광주물류(BOX)" GCol="text,BOXWH6" GF="N 80,1">광주물류(BOX)</td>	<!--광주물류(BOX)-->
		    						<td GH="80 광주물류(낱개)" GCol="text,QTYWH6" GF="N 80,1">광주물류(낱개)</td>	<!--광주물류(낱개)-->
		    						<td GH="80 영천물류(BOX)" GCol="text,BOXWH5" GF="N 80,1">영천물류(BOX)</td>	<!--영천물류(BOX)-->
		    						<td GH="80 영천물류(낱개)" GCol="text,QTYWH5" GF="N 80,1">영천물류(낱개)</td>	<!--영천물류(낱개)-->
		    						<td GH="80 평택세트출고센터(BOX)" GCol="text,BOXWH4_1" GF="N 80,1">평택세트출고센터(BOX)</td>	<!--평택세트출고센터(BOX)-->
		    						<td GH="80 평택세트출고센터(낱개)" GCol="text,QTYWH4_1" GF="N 80,1">평택세트출고센터(낱개)</td>	<!--평택세트출고센터(낱개)-->
		    						<td GH="80 고성세트출고센터(BOX)" GCol="text,NUM01_BOX" GF="N 80,1">고성세트출고센터(BOX)</td>	<!--고성세트출고센터(BOX)-->
		    						<td GH="80 고성세트출고센터(낱개)" GCol="text,NUM01" GF="N 80,1">고성세트출고센터(낱개)</td>	<!--고성세트출고센터(낱개)-->
		    						<td GH="80 주문수량+미확정수량(box)" GCol="text,BOXORD" GF="N 80,1">주문수량+미확정수량(box)</td>	<!--주문수량+미확정수량(box)-->
		    						<td GH="80 주문수량+미확정수량(낱개)" GCol="text,QTYORD" GF="N 80,1">주문수량+미확정수량(낱개)</td>	<!--주문수량+미확정수량(낱개)-->
		    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 80" style="text-align:right;" >박스입수</td>	<!--박스입수-->
		    						<td GH="80 STD_BOXQTYR1" GCol="text,BOXQTY1" GF="N 80,1">주문내역(BOX)</td>	<!--주문내역(BOX)-->
		    						<td GH="80 STD_QTSIWHR1" GCol="text,QTSIWH1" GF="N 80,0">주문내역(낱개)</td>	<!--주문내역(낱개)-->
		    						<td GH="80 STD_BOXQTYR2" GCol="text,BOXQTY2" GF="N 80,1">출고가능재고수량(BOX)</td>	<!--출고가능재고수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR2" GCol="text,QTSIWH2" GF="N 80,0">출고가능재고수량(낱개)</td>	<!--출고가능재고수량(낱개)-->
		    						<td GH="80 STD_BOXQTYR3" GCol="text,BOXQTY3" GF="N 80,1">부족수량(BOX)</td>	<!--부족수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR3" GCol="text,QTSIWH3" GF="N 80,0">부족수량(낱개)</td>	<!--부족수량(낱개)-->
		    						<td GH="80 STD_BOXQTYR4" GCol="text,BOXQTY4" GF="N 80,1">입고예정수량(BOX)</td>	<!--입고예정수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR4" GCol="text,QTSIWH4" GF="N 80,0">입고예정수량(낱개)</td>	<!--입고예정수량(낱개)-->
		    						<td GH="80 STD_BOXQTYR5" GCol="text,BOXQTY5" GF="N 80,1">이고입고예정수량(BOX)</td>	<!--이고입고예정수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR5" GCol="text,QTSIWH5" GF="N 80,0">이고입고예정수량(낱개)</td>	<!--이고입고예정수량(낱개)-->
		    						<td GH="80 STD_BOXQTYR6" GCol="text,BOXQTY6" GF="N 80,1">보류수량(BOX)</td>	<!--보류수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR6" GCol="text,QTSIWH6" GF="N 80,0">보류수량(낱개)</td>	<!--보류수량(낱개)-->
		    						<td GH="80 STD_BOXQTYR7" GCol="text,BOXQTY7" GF="N 80,1">미적치수량(BOX)</td>	<!--미적치수량(BOX)-->
		    						<td GH="80 STD_QTSIWHR7" GCol="text,QTSIWH7" GF="N 80,0">미적치수량(낱개)</td>	<!--미적치수량(낱개)-->
		    						<td GH="80 대기수량" GCol="text,QTYS30" GF="N 80,0">대기수량</td>	<!--대기수량-->
		    						<td GH="80 대기수량(BOX)" GCol="text,BOXS30" GF="N 80,1">대기수량(BOX)</td>	<!--대기수량(BOX)-->
		    						<td GH="80 생산입고예정량(BOX)" GCol="text,BOXQTY9" GF="N 80,1">생산입고예정량(BOX)</td>	<!--생산입고예정량(BOX)-->
		    						<td GH="80 생산입고예정량(EA)" GCol="text,QTSIWH9" GF="N 80,0">생산입고예정량(EA)</td>	<!--생산입고예정량(EA)-->
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
					<li><a href="#tab1-1" onclick="moveTab($(this));"><span id="atab1-1">오더 리스트(Item)</span></a></li>
					<li><a href="#tab1-2" onclick="moveTab($(this));"><span id="atab1-2">부족수량 오더 리스트(All)</span></a></li>
					<li><a href="#tab1-3" onclick="moveTab($(this));"><span id="atab1-3">오더 리스트(All)</span></a></li>
					<li><a href="#tab1-4" onclick="moveTab($(this));"><span id="atab1-4">WMS Shipment 리스트</span></a></li>
					<li class="btn_zoom_wrap">
						<ul>
							<li><button class="btn btn_bigger"><span>확대</span></button></li>
						</ul>
					</li>
					
					<!-- 오더 리스트(Item) -->
					<div id="tab1ty1" name="tab1ty1">
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;">
							<span CL="STD_RSNCOD" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
							<select name="RSNCODCOMBO" id="RSNCODCOMBO"  class="input" Combo="SajoCommon,RSNCOD_COMCOMBO" ComboCodeView="true"><option>선택</option></select>
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
							<input type="button" CB="SetChk SAVE BTN_PART" />
						</li>	
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 저장 -->
							<input type="button" CB="Save SAVE BTN_SAVE" />		
						</li>				
					</div>
					
					<!-- 오더 리스트(All) -->
					<div id="tab1ty2" name="tab1ty2">
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 할당 -->
							<input type="button" CB="ALLOC SAVE BTN_ALLOCATE" />
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- S/O별할당 -->
							<input type="button" CB="allocateSO SAVE BTN_ALLOCATESO" />
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 할당 -->
							≫조회된 가용수량 오더리스트(All)가 할당 됩니다.
						</li>	
					</div>
					
					<!-- WMS Shipment 리스트 -->
					<div id="tab1ty3" name="tab1ty3">
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 미작업삭제 -->
							<input type="button" CB="DELETENEW SAVE BTN_DELETE_1" />
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 부분할당삭제 -->
							<input type="button" CB="DELETEPAL SAVE BTN_DELETE_2" />
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 전체삭제 -->
							<input type="button" CB="DELETE SAVE BTN_DELETE_3" />
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 할당 -->
							<input type="button" CB="REALLOC SAVE BTN_ALLOCATE" />
						</li>
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> <!-- 할당 -->
							<input type="button" CB="UNALLOC SAVE BTN_UNALLOC" />
						</li>
						
						
						<!-- 6월 22일	박수현 WMS shipment 리스트 > DO전송 버튼 삭제요청 
						
						<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"> 할당 
							<input type="button" CB="DRELIN SAVE BTN_DRELIN" />
						</li> 
						-->
					</div>
				</ul>
				
				<div class="table_box section" id="tab1-1" >
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList1">
									<tr CGRow="true">
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
										<td GH="40" GCol="rowCheck"></td>
										<td GH="80 IFT_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="130 IFT_WAREKY" GCol="select,WAREKY">
			    							<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO_HP">
			    						</td>	<!--WMS거점(출고사업장)-->
			    						<td GH="80 STD_IFPGRC04" GCol="text,WARESR" GF="S 10">요청사업장</td>	<!--요청사업장-->
			    						<td GH="110 STD_IFPGRC04N" GCol="select,WARESRNM">
			    							<select class="input" CommonCombo="PTNG06"></select>
			    						</td>	<!--요청사업장명-->
			    						<td GH="80 IFT_DOCUTY" GCol="text,DOCUTY" GF="S 3">출고유형</td>	<!--출고유형-->
			    						<td GH="80 IFT_DOCUTYNM" GCol="text,DOCUTYNM" GF="S 50">문서타입명</td>	<!--문서타입명-->
			    						<td GH="80 IFT_ORDTYP" GCol="text,ORDTYP" GF="S 7">주문/출고형태</td>	<!--주문/출고형태-->
			    						<td GH="80 STD_CTODDT" GCol="text,ERPCDT" GF="D 7">주문일자</td>	<!--주문일자-->
			    						<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
			    						<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td>	<!--출고요청일-->
			    						<td GH="100 IFT_DIRDVY" GCol="select,DIRDVY">
											<select class="input" commonCombo="PGRC02"></select> <!--배송구분-->
										</td>
			    						<td GH="110 IFT_DIRSUP" GCol="select,DIRSUP">
											<select class="input" commonCombo="PGRC03"></select> <!--주문구분-->
										</td>
 										<td GH="160 IFT_C00103" GCol="select,C00103"><!--사유코드-->
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option></option>
											</select>
			    						</td>	 
			    						
			    						<td GH="80 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">요청수량</td>	<!--요청수량-->
			    						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td>	<!--납품요청수량-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
<!--  			    						<td GH="80 IFT_C00103" GCol="text,C00103" GF="S 20">사유코드</td>	-->
			    						<td GH="80 IFT_C00102" GCol="text,C00102" GF="S 20">승인여부</td>	<!--승인여부-->
			    						<td GH="80 IFT_CUSRID" GCol="text,CUSRID" GF="S 20">배송고객 아이디</td>	<!--배송고객 아이디-->
			    						<td GH="80 IFT_CUNAME" GCol="text,CUNAME" GF="S 35">배송고객명</td>	<!--배송고객명-->
			    						<td GH="80 IFT_CUPOST" GCol="text,CUPOST" GF="S 10">배송지 우편번호</td>	<!--배송지 우편번호-->
			    						<td GH="80 IFT_CUNATN" GCol="text,CUNATN" GF="S 3">배송자 국가 키 </td>	<!--배송자 국가 키 -->
			    						<td GH="80 IFT_CUTEL1" GCol="text,CUTEL1" GF="S 16">배송자 전화번호1</td>	<!--배송자 전화번호1-->
			    						<td GH="80 IFT_CUTEL2" GCol="text,CUTEL2" GF="S 31">배송자 전화번호2</td>	<!--배송자 전화번호2-->
			    						<td GH="80 IFT_CUMAIL" GCol="text,CUMAIL" GF="S 723">배송자 E-MAIL</td>	<!--배송자 E-MAIL-->
			    						<td GH="80 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td>	<!--배송지 주소-->
			    						<td GH="80 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td>	<!--거래처 담당자명-->
			    						<td GH="80 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td>	<!--거래처 담당자 전화번호-->
			    						<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td>	<!--영업사원명-->
			    						<td GH="80 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td>	<!--영업사원 전화번호-->
			    						<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	<!--비고-->
			    						<td GH="80 IFT_CHKSEQ" GCol="text,CHKSEQ" GF="S 10">검수번호</td>	<!--검수번호-->
			    						<td GH="80 IFT_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">주문번호아이템</td>	<!--주문번호아이템-->
			    						<td GH="80 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td>	<!--주문아이템번호-->
			    						<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
			    						<td GH="80 STD_SHIPTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
			    						<td GH="80 IFT_PTNROD" GCol="text,PTNROD" GF="S 20">매출처코드</td>	<!--매출처코드-->
			    						<td GH="80 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 20">매출처명</td>	<!--매출처명-->
			    						<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
			    						<td GH="80 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS관리수량</td>	<!--WMS관리수량-->
			    						<td GH="80 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td>	<!--출하수량-->
			    						<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td>	<!--기본단위-->
			    						<td GH="80 IFT_LMODAT" GCol="text,LMODAT" GF="S 8">LMODAT</td>	<!--LMODAT-->
			    						<td GH="80 IFT_LMOTIM" GCol="text,LMOTIM" GF="S 6">LMOTIM</td>	<!--LMOTIM-->
			    						<td GH="80 IFT_STATUS" GCol="text,STATUS" GF="S 1">C:신규,M:변경,D:삭제)</td>	<!--C:신규,M:변경,D:삭제)-->
			    						<td GH="80 IFT_TDATE" GCol="text,TDATE" GF="S 14">yyyymmddhhmmss(생성일자)</td>	<!--yyyymmddhhmmss(생성일자)-->
			    						<td GH="80 IFT_CDATE" GCol="text,CDATE" GF="S 14">yyyymmddhhmmss(처리일자)</td>	<!--yyyymmddhhmmss(처리일자)-->
			    						<td GH="80 IFT_IFFLG" GCol="text,IFFLG" GF="S 1">Default:N, 처리완료시:Y, 미사용:X</td>	<!--Default:N, 처리완료시:Y, 미사용:X-->
			    						<td GH="80 IFT_ERTXT" GCol="text,ERTXT" GF="S 220">ERR TEXT</td>	<!--ERR TEXT-->
			    						<td GH="120 STD_PLTBOX" GCol="text,PLTBOX" GF="S 20" style="text-align:right;">PLT별BOX적재수량</td><!--	PLT별BOX적재수량 -->
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
					
				<div class="table_box section" id="tab1-2">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList2">
									<tr CGRow="true">
				    					<td GH="80 IFT_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    					<td GH="130 IFT_WAREKY" GCol="select,WAREKY">
			    							<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"><option></option></select>
			    						</td>	<!--WMS거점(출고사업장)-->
				    					<td GH="80 STD_IFPGRC04" GCol="text,WARESR" GF="S 10">요청사업장</td>	<!--요청사업장-->
				    					<td GH="110 STD_IFPGRC04N" GCol="select,WARESRNM">
			    							<select class="input" CommonCombo="PTNG06"></select>
			    						</td>	<!--요청사업장명-->
				    					<td GH="80 IFT_DOCUTY" GCol="text,DOCUTY" GF="S 3">출고유형</td>	<!--출고유형-->
				    					<td GH="80 IFT_DOCUTYNM" GCol="text,DOCUTYNM" GF="S 50">문서타입명</td>	<!--문서타입명-->
				    					<td GH="80 IFT_ORDTYP" GCol="text,ORDTYP" GF="S 7">주문/출고형태</td>	<!--주문/출고형태-->
				    					<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
				    					<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
				    					<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td>	<!--출고요청일-->
				    					<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
				    					<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
				    					<td GH="100 IFT_DIRDVY" GCol="select,DIRDVY">
											<select class="input" commonCombo="PGRC02"></select> <!--배송구분-->
										</td>
				    					<td GH="110 IFT_DIRSUP" GCol="select,DIRSUP">
											<select class="input" commonCombo="PGRC03"></select> <!--주문구분-->
										</td>
										<td GH="120 IFT_C00103" GCol="text,C00103" GF="S 20"><!--사유코드-->
												<!-- <select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"></select> -->
			    						</td>	
				    					<td GH="80 IFT_CUSRID" GCol="text,CUSRID" GF="S 20">배송고객 아이디</td>	<!--배송고객 아이디-->
				    					<td GH="80 IFT_CUNAME" GCol="text,CUNAME" GF="S 35">배송고객명</td>	<!--배송고객명-->
				   						<td GH="80 IFT_CUPOST" GCol="text,CUPOST" GF="S 10">배송지 우편번호</td>	<!--배송지 우편번호-->
				    					<td GH="80 IFT_CUNATN" GCol="text,CUNATN" GF="S 3">배송자 국가 키 </td>	<!--배송자 국가 키 -->
				   						<td GH="80 IFT_CUTEL1" GCol="text,CUTEL1" GF="S 16">배송자 전화번호1</td>	<!--배송자 전화번호1-->
				   						<td GH="80 IFT_CUTEL2" GCol="text,CUTEL2" GF="S 31">배송자 전화번호2</td>	<!--배송자 전화번호2-->
				   						<td GH="80 IFT_CUMAIL" GCol="text,CUMAIL" GF="S 723">배송자 E-MAIL</td>	<!--배송자 E-MAIL-->
				    					<td GH="80 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td>	<!--배송지 주소-->
				    					<td GH="80 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td>	<!--거래처 담당자명-->
				    					<td GH="80 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td>	<!--거래처 담당자 전화번호-->
				    					<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td>	<!--영업사원명-->
				    					<td GH="80 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td>	<!--영업사원 전화번호-->
				    					<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	<!--비고-->
				    					<td GH="80 IFT_CHKSEQ" GCol="text,CHKSEQ" GF="S 10">검수번호</td>	<!--검수번호-->
				   						<td GH="80 IFT_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">주문번호아이템</td>	<!--주문번호아이템-->
				   						<td GH="80 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td>	<!--주문아이템번호-->
				   						<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				   						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
				   						<td GH="80 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">요청수량</td>	<!--요청수량-->
				  						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td>	<!--납품요청수량-->
				   						<td GH="80 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS관리수량</td>	<!--WMS관리수량-->
				   						<td GH="80 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td>	<!--출하수량-->
				    					<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td>	<!--기본단위-->
				    					<td GH="80 IFT_LMODAT" GCol="text,LMODAT" GF="S 8">LMODAT</td>	<!--LMODAT-->
				    					<td GH="80 IFT_LMOTIM" GCol="text,LMOTIM" GF="S 6">LMOTIM</td>	<!--LMOTIM-->
				    					<td GH="80 IFT_STATUS" GCol="text,STATUS" GF="S 1">C:신규,M:변경,D:삭제)</td>	<!--C:신규,M:변경,D:삭제)-->
				    					<td GH="80 IFT_TDATE" GCol="text,TDATE" GF="S 14">yyyymmddhhmmss(생성일자)</td>	<!--yyyymmddhhmmss(생성일자)-->
				    					<td GH="80 IFT_CDATE" GCol="text,CDATE" GF="S 14">yyyymmddhhmmss(처리일자)</td>	<!--yyyymmddhhmmss(처리일자)-->
				    					<td GH="80 IFT_IFFLG" GCol="text,IFFLG" GF="S 1">Default:N, 처리완료시:Y, 미사용:X</td>	<!--Default:N, 처리완료시:Y, 미사용:X-->
				    					<td GH="80 IFT_ERTXT" GCol="text,ERTXT" GF="S 220">ERR TEXT</td>	<!--ERR TEXT-->
				    					<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
				    					<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
				    					<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
				    					<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
				    					<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="120 STD_PLTBOX" GCol="text,PLTBOX" GF="S 20" style="text-align:right;">PLT별BOX적재수량</td><!--	PLT별BOX적재수량 -->
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
						<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>

				<div class="table_box section" id="tab1-3">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList3">
									<tr CGRow="true">
				    					<td GH="80 IFT_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
				    					<td GH="130 IFT_WAREKY" GCol="select,WAREKY">
			    							<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"><option></option></select>
			    						</td>	<!--WMS거점(출고사업장)-->
				    					<td GH="80 STD_IFPGRC04" GCol="text,WARESR" GF="S 10">요청사업장</td>	<!--요청사업장-->
				    					<td GH="110 STD_IFPGRC04N" GCol="select,WARESRNM">
			    							<select class="input" CommonCombo="PTNG06"></select>
			    						</td>	<!--요청사업장명-->
				    					<td GH="80 IFT_DOCUTY" GCol="text,DOCUTY" GF="S 3">출고유형</td>	<!--출고유형-->
				    					<td GH="80 IFT_DOCUTYNM" GCol="text,DOCUTYNM" GF="S 50">문서타입명</td>	<!--문서타입명-->
				    					<td GH="80 IFT_ORDTYP" GCol="text,ORDTYP" GF="S 7">주문/출고형태</td>	<!--주문/출고형태-->
				    					<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
				    					<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
				    					<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td>	<!--출고요청일-->
				    					<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	<!--납품처코드-->
				    					<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	<!--납품처명-->
				    					<td GH="100 IFT_DIRDVY" GCol="select,DIRDVY">
											<select class="input" commonCombo="PGRC02"></select> <!--배송구분-->
										</td>
				    					<td GH="110 IFT_DIRSUP" GCol="select,DIRSUP">
											<select class="input" commonCombo="PGRC03"></select> <!--주문구분-->
										</td>
										<td GH="120 IFT_C00103" GCol="text,C00103" GF="S 20"><!--사유코드-->
												<!-- <select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"></select> -->
			    						</td>
				    					<td GH="80 IFT_CUSRID" GCol="text,CUSRID" GF="S 20">배송고객 아이디</td>	<!--배송고객 아이디-->
				    					<td GH="80 IFT_CUNAME" GCol="text,CUNAME" GF="S 35">배송고객명</td>	<!--배송고객명-->
				   						<td GH="80 IFT_CUPOST" GCol="text,CUPOST" GF="S 10">배송지 우편번호</td>	<!--배송지 우편번호-->
				    					<td GH="80 IFT_CUNATN" GCol="text,CUNATN" GF="S 3">배송자 국가 키 </td>	<!--배송자 국가 키 -->
				   						<td GH="80 IFT_CUTEL1" GCol="text,CUTEL1" GF="S 16">배송자 전화번호1</td>	<!--배송자 전화번호1-->
				   						<td GH="80 IFT_CUTEL2" GCol="text,CUTEL2" GF="S 31">배송자 전화번호2</td>	<!--배송자 전화번호2-->
				   						<td GH="80 IFT_CUMAIL" GCol="text,CUMAIL" GF="S 723">배송자 E-MAIL</td>	<!--배송자 E-MAIL-->
				    					<td GH="80 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td>	<!--배송지 주소-->
				    					<td GH="80 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td>	<!--거래처 담당자명-->
				    					<td GH="80 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td>	<!--거래처 담당자 전화번호-->
				    					<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td>	<!--영업사원명-->
				    					<td GH="80 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td>	<!--영업사원 전화번호-->
				    					<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	<!--비고-->
				    					<td GH="80 IFT_CHKSEQ" GCol="text,CHKSEQ" GF="S 10">검수번호</td>	<!--검수번호-->
				   						<td GH="80 IFT_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">주문번호아이템</td>	<!--주문번호아이템-->
				   						<td GH="80 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td>	<!--주문아이템번호-->
				   						<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
				   						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	<!--제품명-->
				   						<td GH="80 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">요청수량</td>	<!--요청수량-->
				  						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td>	<!--납품요청수량-->
				   						<td GH="80 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS관리수량</td>	<!--WMS관리수량-->
				   						<td GH="80 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td>	<!--출하수량-->
				    					<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td>	<!--기본단위-->
				    					<td GH="80 IFT_LMODAT" GCol="text,LMODAT" GF="S 8">LMODAT</td>	<!--LMODAT-->
				    					<td GH="80 IFT_LMOTIM" GCol="text,LMOTIM" GF="S 6">LMOTIM</td>	<!--LMOTIM-->
				    					<td GH="80 IFT_STATUS" GCol="text,STATUS" GF="S 1">C:신규,M:변경,D:삭제)</td>	<!--C:신규,M:변경,D:삭제)-->
				    					<td GH="80 IFT_TDATE" GCol="text,TDATE" GF="S 14">yyyymmddhhmmss(생성일자)</td>	<!--yyyymmddhhmmss(생성일자)-->
				    					<td GH="80 IFT_CDATE" GCol="text,CDATE" GF="S 14">yyyymmddhhmmss(처리일자)</td>	<!--yyyymmddhhmmss(처리일자)-->
				    					<td GH="80 IFT_IFFLG" GCol="text,IFFLG" GF="S 1">Default:N, 처리완료시:Y, 미사용:X</td>	<!--Default:N, 처리완료시:Y, 미사용:X-->
				    					<td GH="80 IFT_ERTXT" GCol="text,ERTXT" GF="S 220">ERR TEXT</td>	<!--ERR TEXT-->
				    					<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
				    					<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
				    					<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
				    					<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
				    					<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="120 STD_PLTBOX" GCol="text,PLTBOX" GF="S 20" style="text-align:right;">PLT별BOX적재수량</td><!--	PLT별BOX적재수량 -->
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
						<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
					</div>
				</div>
				
				
				<div class="table_box section" id="tab1-4">
					<div class="table_list01">
						<div class="scroll">
							<table class="table_c">
								<tbody id="gridItemList4">
									<tr CGRow="true">
										<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
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
			    						<td GH="70 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="80 STD_GRSWGT" GCol="text,GRSWGT" GF="N 20,0">포장중량</td>	<!--포장중량-->
			    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 20,0">순중량</td>	<!--순중량-->
			    						<td GH="80 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="80 STD_LENGTH" GCol="text,LENGTH" GF="S 20">포장가로</td>	<!--포장가로-->
			    						<td GH="80 STD_WIDTHW" GCol="text,WIDTHW" GF="S 20">포장세로</td>	<!--포장세로-->
			    						<td GH="80 STD_HEIGHT" GCol="text,HEIGHT" GF="S 20">포장높이</td>	<!--포장높이-->
			    						<td GH="80 STD_CUBICM" GCol="text,CUBICM" GF="S 20">CBM</td>	<!--CBM-->
			    						<td GH="80 STD_CUBICT" GCol="text,CUBICT" GF="S 20">총CBM</td>	<!--총CBM-->
			    						<td GH="80 STD_CAPACT" GCol="text,CAPACT" GF="S 20">CAPA</td>	<!--CAPA-->
			    						<td GH="100 STD_DOCTXT" GCol="text,NAME01" GF="S 180">비고</td>	<!--비고-->
			    						<td GH="50 STD_RQSHPD" GCol="text,RQSHPD" GF="D 8">출고요청일자</td>	<!--출고요청일자-->
			    						<td GH="70 IFT_PTNROD" GCol="text,PTRCVR" GF="S 20">매출처코드</td>	<!--매출처코드-->
			    						<td GH="80 STD_PTRCNM" GCol="text,PTRCVRNM" GF="S 50">매출처명</td>	<!--매출처명-->
			    						<td GH="70 IFT_PTNRTO" GCol="text,DPTNKY" GF="S 20">납품처코드</td>	<!--납품처코드-->
			    						<td GH="80 STD_SHIPTONM" GCol="text,DPTNKYNM" GF="S 50">납품처명</td>	<!--납품처명-->
			    						<td GH="50 STD_CTODDT" GCol="text,ERPCDT" GF="D 8">주문일자</td>	<!--주문일자-->
			    						<td GH="80 STD_IFPGRC02" GCol="text,PGRC02" GF="S 20">배송구분</td>	<!--배송구분-->
			    						<td GH="80 STD_IFPGRC03" GCol="text,PGRC03" GF="S 20">주문구분</td>	<!--주문구분-->
			    						<td GH="88 STD_ARRIVA" GCol="text,ARRIVA" GF="S 80">도착권역</td>	<!--도착권역-->
			    						<td GH="80 STD_IFNAME01" GCol="text,DEPTID1" GF="S 20">배송고객명</td>	<!--배송고객명-->
			    						<td GH="80 STD_IFNAME03" GCol="text,DNAME1" GF="S 20">배송자 전화번호1</td>	<!--배송자 전화번호1-->
			    						<td GH="80 STD_IFNAME04" GCol="text,USRID2" GF="S 20">배송자 전화번호2</td>	<!--배송자 전화번호2-->
			    						<td GH="80 STD_IFNAME02" GCol="text,USRID1" GF="S 20">배송지 우편번호</td>	<!--배송지 우편번호-->
			    						<td GH="80 STD_IFNAME05" GCol="text,UNAME1" GF="S 20">배송지 주소</td>	<!--배송지 주소-->
									
									
				    					<!-- <td GH="80 IFT_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	화주
				    					<td GH="130 IFT_WAREKY" GCol="select,WAREKY">
			    							<select class="input" Combo="SajoCommon,WAREKYNM_COMCOMBO"><option></option></select>
			    						</td>	WMS거점(출고사업장)
				    					<td GH="80 STD_IFPGRC04" GCol="text,WARESR" GF="S 10">요청사업장</td>	요청사업장
				    					<td GH="110 STD_IFPGRC04N" GCol="select,WARESRNM">
			    							<select class="input" CommonCombo="PTNG06"></select>
			    						</td>	요청사업장명
				    					<td GH="80 IFT_DOCUTY" GCol="text,DOCUTY" GF="S 3">출고유형</td>	출고유형
				    					<td GH="80 IFT_DOCUTYNM" GCol="text,DOCUTYNM" GF="S 50">문서타입명</td>	문서타입명
				    					<td GH="80 IFT_ORDTYP" GCol="text,ORDTYP" GF="S 7">주문/출고형태</td>	주문/출고형태
				    					<td GH="80 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	출고일자
				    					<td GH="80 IFT_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	S/O 번호
				    					<td GH="80 IFT_OTRQDT" GCol="text,OTRQDT" GF="D 8">출고요청일</td>	출고요청일
				    					<td GH="80 IFT_PTNRTO" GCol="text,PTNRTO" GF="S 20">납품처코드</td>	납품처코드
				    					<td GH="80 IFT_PTNRTONM" GCol="text,PTNRTONM" GF="S 20">납품처명</td>	납품처명
				    					<td GH="100 IFT_DIRDVY" GCol="select,DIRDVY">
											<select class="input" commonCombo="PGRC02"></select> 배송구분
										</td>
				    					<td GH="110 IFT_DIRSUP" GCol="select,DIRSUP">
											<select class="input" commonCombo="PGRC03"></select> 주문구분
										</td>
										<td GH="120 IFT_C00103" GCol="select,C00103">사유코드
												<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO"></select>
			    						</td>
				    					<td GH="80 IFT_CUSRID" GCol="text,CUSRID" GF="S 20">배송고객 아이디</td>	배송고객 아이디
				    					<td GH="80 IFT_CUNAME" GCol="text,CUNAME" GF="S 35">배송고객명</td>	배송고객명
				   						<td GH="80 IFT_CUPOST" GCol="text,CUPOST" GF="S 10">배송지 우편번호</td>	배송지 우편번호
				    					<td GH="80 IFT_CUNATN" GCol="text,CUNATN" GF="S 3">배송자 국가 키 </td>	배송자 국가 키
				   						<td GH="80 IFT_CUTEL1" GCol="text,CUTEL1" GF="S 16">배송자 전화번호1</td>	배송자 전화번호1
				   						<td GH="80 IFT_CUTEL2" GCol="text,CUTEL2" GF="S 31">배송자 전화번호2</td>	배송자 전화번호2
				   						<td GH="80 IFT_CUMAIL" GCol="text,CUMAIL" GF="S 723">배송자 E-MAIL</td>	배송자 E-MAIL
				    					<td GH="80 IFT_CUADDR" GCol="text,CUADDR" GF="S 60">배송지 주소</td>	배송지 주소
				    					<td GH="80 IFT_CTNAME" GCol="text,CTNAME" GF="S 50">거래처 담당자명</td>	거래처 담당자명
				    					<td GH="80 IFT_CTTEL1" GCol="text,CTTEL1" GF="S 20">거래처 담당자 전화번호</td>	거래처 담당자 전화번호
				    					<td GH="80 IFT_SALENM" GCol="text,SALENM" GF="S 50">영업사원명</td>	영업사원명
				    					<td GH="80 IFT_SALTEL" GCol="text,SALTEL" GF="S 20">영업사원 전화번호</td>	영업사원 전화번호
				    					<td GH="80 IFT_TEXT01" GCol="text,TEXT01" GF="S 1000">비고</td>	비고
				    					<td GH="80 IFT_CHKSEQ" GCol="text,CHKSEQ" GF="S 10">검수번호</td>	검수번호
				   						<td GH="80 IFT_ORDSEQ" GCol="text,ORDSEQ" GF="S 6">주문번호아이템</td>	주문번호아이템
				   						<td GH="80 IFT_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문아이템번호</td>	주문아이템번호
				   						<td GH="80 IFT_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	제품코드
				   						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>	제품명
				   						<td GH="80 IFT_QTYORG" GCol="text,QTYORG" GF="N 13,0">요청수량</td>	요청수량
				  						<td GH="80 IFT_QTYREQ" GCol="text,QTYREQ" GF="N 13,0">납품요청수량</td>	납품요청수량
				   						<td GH="80 IFT_WMSMGT" GCol="text,WMSMGT" GF="N 13,0">WMS관리수량</td>	WMS관리수량
				   						<td GH="80 IFT_QTSHPD" GCol="text,QTSHPD" GF="N 13,0">출하수량</td>	출하수량
				    					<td GH="80 IFT_DUOMKY" GCol="text,DUOMKY" GF="S 220">기본단위</td>	기본단위
				    					<td GH="80 IFT_LMODAT" GCol="text,LMODAT" GF="S 8">LMODAT</td>	LMODAT
				    					<td GH="80 IFT_LMOTIM" GCol="text,LMOTIM" GF="S 6">LMOTIM</td>	LMOTIM
				    					<td GH="80 IFT_STATUS" GCol="text,STATUS" GF="S 1">C:신규,M:변경,D:삭제)</td>	C:신규,M:변경,D:삭제)
				    					<td GH="80 IFT_TDATE" GCol="text,TDATE" GF="S 14">yyyymmddhhmmss(생성일자)</td>	yyyymmddhhmmss(생성일자)
				    					<td GH="80 IFT_CDATE" GCol="text,CDATE" GF="S 14">yyyymmddhhmmss(처리일자)</td>	yyyymmddhhmmss(처리일자)
				    					<td GH="80 IFT_IFFLG" GCol="text,IFFLG" GF="S 1">Default:N, 처리완료시:Y, 미사용:X</td>	Default:N, 처리완료시:Y, 미사용:X
				    					<td GH="80 IFT_ERTXT" GCol="text,ERTXT" GF="S 220">ERR TEXT</td>	ERR TEXT
				    					<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	팔렛당수량
				    					<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	박스입수
				    					<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	박스수량
				    					<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	팔레트수량
				    					<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	잔량 -->
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
						<span class='txt_total'>총 건수 : <span GInfoArea='true'>0</span></span>
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