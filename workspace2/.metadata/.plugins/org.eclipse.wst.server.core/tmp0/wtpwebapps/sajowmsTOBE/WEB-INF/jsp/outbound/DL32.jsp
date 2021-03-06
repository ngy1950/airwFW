<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL26</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">

  var GRPRL = '';
  var TOTALPICKING = 'N';
  var PROGID = 'DL32';
  var isDO = false;
  var ownrky = "";
  
  var headrow = -1;

	$(document).ready(function(){
		
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "Outbound",
			command : "DL32_HEAD",
			itemGrid : "gridItemList",
			itemSearch : false,
			tempItem : "gridItemList",
			useTemp : true,
			tempKey : "SVBELN",
		    menuId : "DL32"
		});
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "Outbound",
			command : "DL32_ITEM",
			pkcol : "OWNRKY,WAREKY,SKUKEY",
			emptyMsgType : false,
			tempKey : "SVBELN",
			useTemp : true,
			tempHead : "gridHeadList",
		    menuId : "DL32"
	    });
	   
	   $("#searchArea [name=OWNRKY]").on("change",function(){
	     searchwareky($(this).val());
	   });
	   
		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	   
	   searchwareky($('#OWNRKY').val());
	   
		var data = page.getLinkPageData("DL32");
		if(data){
			$('#OWNRKY').val(data.get("OWNRKY"));
			searchwareky(data.get("OWNRKY"));
			$('#WAREKY').val(data.get("WAREKY"));
			$("#SHPOKY").val(data.get("SHPOKY"));

	        searchList()
		}
	   
	//콤보박스 리드온리
	gridList.setReadOnly("gridHeadList", true, ["OWNRKY", "WARESR", "DOCUTY","DIRDVY", "DIRSUP"]);
	gridList.setReadOnly("gridItemList", true, ["LOTA05", "LOTA06"]);
	
// 	$("#qttaorSum").html("0");
// 	$("#pltqtySum").html("0");
// 	$("#boxqtySum").html("0");

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
			headrow = -1;
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridHeadList");
			ownrky = $("#OWNRKY").val();
			var param = inputList.setRangeDataParam("searchArea");
			
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}
	}
  
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}else if(gridId == "gridItemList"){
			gridList.setRowCheck(gridId, rowNum, true);
		}
	}
  
  function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
    if(gridId == "gridHeadList"){
      var rowData = gridList.getRowData(gridId, rowNum);
      var param = inputList.setRangeParam("searchArea");
      var tasoty = "210";
	  var doccat = "300";
	  var statdo = "NEW";
	  var shpmty = rowData.get("SHPMTY");
	  var svbeln = rowData.get("SVBELN");
	  var ptnrodnm = rowData.get("DPTNKYNM");
	  var ptnrtonm = rowData.get("PTRCVRNM");
	  var postcode = rowData.get("USRID1");
	  var address = rowData.get("UNAME1");
	  var sentyn = rowData.get("DRELIN");
	  var doctxt = rowData.get("DOCTXT");
	  
	  $('#ptnrodnm').text(ptnrodnm);
	  $('#ptnrtonm').text(ptnrtonm);
	  $('#postcode').text(postcode);
	  $('#address').text(address);
	  $('#sentyn').text(sentyn);
	  $('#doctxt').text(doctxt);

	  param.put('PROGID',PROGID);      
	  if("270" == shpmty){
		  param.put('LOTA_06','20')
	  }
	  param.put('TASOTY','210')
	  param.put('DOCCAT','300')
	  param.put('STATDO','NEW')

	  /**
		이고출고일경우 삼아벤처 재고가 안나오게 조치
		// 20190527 최민욱 삼아재고 이동일 경우엔 삼아재고 나오게 수정 
		
	  **/	  	  
	  svbeln = svbeln.substring(0,2);
	  param.put('LOTA07','21SV')	  
	  if("61" != svbeln){
			if(("266" == shpmty || "267" == shpmty) && !"SAJOSV" == $("#OWNRKY").val()){
				param.put('LOTA07','21SV')
			}
	  }	  
	  
      param.putAll(rowData);

      if (sentyn != "YES"){
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
			}else if(name == "OPTION"){
				param.put("CMCDKY", "OPTION");
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
	  
		if(gridId == "gridItemList"){
			if(colName == "QTTAOR" || colName == "BOXQTY" || colName == "REMQTY" || colName == "PLTQTY"){
				var qttaor = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
				var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
				var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
				var remqtyChk = 0;
     
				if( colName == "QTTAOR" ) {  
					
					qttaor = colValue;
					boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
				  	remqty = gridList.getColData(gridId, rowNum, "REMQTY");
// 					pltqty = floatingFloor((Number)(qttaor)/(Number)(pliqty), 2);
					//구버전과 소수점 동일하게 계산되게 수정
					pltqty = Math.round(((Number)(qttaor)/(Number)(pliqty))*10)/10;
					boxqty = Math.round(( (Number)(qttaor)- (floatingFloor((Number)(pltqty), 0)*(Number)(pliqty)) ) / floatingFloor((Number)(bxiqty), 0));    	
					remqty = (Number)(qttaor)%(Number)(bxiqty);
					  	
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
				}
				
				if( colName == "PLTQTY" ){ 
					pltqty = colValue;
					remqty = gridList.getColData(gridId, rowNum, "REMQTY");
					qttaor = (Number)(pltqty)*(Number)(pliqty);
					pltqty = (Number)(qttaor)/(Number)(pliqty);
					boxqty = ((Number)(pliqty)*(Number)(pltqty)) / (Number)(bxiqty);
					remqty =  pltqty / (Number)(bxiqty);       	  
					
					gridList.setColValue(gridId, rowNum, "QTTAOR", qttaor);
					gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
				}
				
				if( colName == "BOXQTY" ){ //박스수량 변경시
					boxqty = colValue;
					qttaor = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty);
// 					pltqty = floatingFloor((Number)(qttaor)/(Number)(pliqty), 2);
					pltqty = Math.round(((Number)(qttaor)/(Number)(pliqty))*10)/10;
					boxqty = Math.round(( (Number)(qttaor)- (floatingFloor((Number)(pltqty), 0)*(Number)(pliqty)) ) / floatingFloor((Number)(bxiqty), 0));
					                    
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "QTTAOR", qttaor); 
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", 0);
				}

				var item = gridList.getSelectData("gridItemList");
				var qttaorSum = 0;
				var pltqtySum = 0;
				var boxqtySum = 0;

				for(var i=0; i<item.length; i++){
					var itemMap = item[i].map;
					var qttaor = Number(itemMap.QTTAOR);
					var pltqty = Number(itemMap.PLTQTY);
					var boxqty = Number(itemMap.BOXQTY);
				  	
					qttaorSum += Number(qttaor);
				  	pltqtySum += Number(pltqty);
				  	boxqtySum += Number(boxqty);
				}

				$("#qttaorSum").html(floatingFloor(qttaorSum, 0));
				$("#pltqtySum").html(floatingFloor(pltqtySum, 2));
				$("#boxqtySum").html(floatingFloor(boxqtySum, 0));
			}
		}
	}
  
  
//체크박스 이벤트 후 
	function gridListEventRowCheck(gridId, rowNum, isCheck){	
		if(gridId == "gridItemList"){
			var qttaorSum = 0;
			var pltqtySum = 0;
			var boxqtySum = 0;
			var item = gridList.getSelectData("gridItemList");
			
		for(var i=0; i<item.length; i++){
			var itemMap = item[i].map;
			var qttaor = Number(itemMap.QTTAOR);
			var pltqty = Number(itemMap.PLTQTY);
			var boxqty = Number(itemMap.BOXQTY);
			
			qttaorSum +=   Number(item[i].get("QTTAOR"));	
			pltqtySum +=   Number(item[i].get("PLTQTY"));	
			boxqtySum +=   Number(item[i].get("BOXQTY"));			  
		}
			$("#qttaorSum").html(floatingFloor(qttaorSum, 0));
			$("#pltqtySum").html(floatingFloor(pltqtySum, 2));
			$("#boxqtySum").html(floatingFloor(boxqtySum, 0));
		}
	}
  
  function save(){    
	
    var head = getfocusGridDataList("gridHeadList");
    var item = gridList.getSelectData("gridItemList");
    var headAll = gridList.getGridData("gridHeadList");
    //아이템 템프 가져오기
    var tempItem = gridList.getTempData("gridHeadList")
    
    if(head.length == 0){
      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      return;
    }
   
    for(var i=0; i<head.length; i++){
    	 
    	var qttaorSum = new Number();
		var shpdiQty = new Number();
		var tasdiSumChk = new Number();
        var cardat = head[i].get("CARDAT");
        var yy = cardat.substr(0,4);
		var mm = cardat.substr(4,2);
		var dd = cardat.substr(6,2);
		var sysdate = new Date();
		var date = new Date(Number(yy), Number(mm)-1, Number(dd));	
		//2021.07.22 CMU TOSS로 배차가 넘어가 가배차 단계라 졔약 해제 
		//if(Number(head[i].get("QTALOC")) > 0){
		//	if(Math.abs((date-sysdate)/1000/60/60/24) > 5){
		//		alert("배송일자는 ±5일로 지정하셔야 합니다.") ;
		//		return;
		//	}
		//}
		 
		var qtshpo = head[i].get("QTSHPO");
		var qtaloc = head[i].get("QTALOC");
		
		shpdiQty = Number(qtshpo) - Number(qtaloc);	

		for(j=0; j<item.length; j++){		
		    	qttaorSum +=   Number(item[j].get("QTTAOR"));		
		}
		if(qttaorSum > shpdiQty){
			alert("* 작업수량이 요청수량을 초과 하였습니다. *\n  할당가능 수량 : "+shpdiQty+"    작업수량 : "+qttaorSum);
			return;
		}
		
		var msgStr =  "재고리스트에서 "+ item.length +"건을 선택 하였습니다.\n저장 하시겠습니까?   \n\n작업수량 : "+qttaorSum+" ";
    	if(item.length != 0 ){
	   		if(confirm(msgStr)){	   			
	   		}
		}
    }

    var param = new DataMap();
    param.put("head",head);
    param.put("headAll",headAll);
    param.put("item",item);
	param.put("itemTemp",tempItem);
	
	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
		return;
    }

    netUtil.send({
      url : "/outbound/json/saveDL26.data",
      param : param,
      successFunction : "successSaveCallBack"
    });
  }
  
  function remove(){    
    var head = gridList.getGridData("gridHeadList");
    var item = gridList.getSelectData("gridItemList");
    //아이템 템프 가져오기
    var tempItem = gridList.getTempData("gridHeadList")
          
    if(head.length == 0){
      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      return;
    }
    
    var shpdiSum = new Number();
		
    for(var i=0; i<head.length; i++){
    	shpdiSum +=  Number(head[i].get("QTJCMP"));
    }
 
	if(shpdiSum > 0 ){
		alert("* 할당완료된 출하문서는 삭제 할 수 없습니다. *");
		return;
	}
	
    var param = new DataMap();
    param.put("head",head);
    param.put("item",item);
	param.put("itemTemp",tempItem);

    netUtil.send({
      url : "/outbound/json/removeDL26.data",
      param : param,
      successFunction : "successSaveCallBack"
    });
  } 
  
  function allocate(){    
	    var head = getfocusGridDataList("gridHeadList");
        var item = gridList.getSelectData("gridItemList");
        //아이템 템프 가져오기
        var tempItem = gridList.getTempData("gridHeadList")
          
    if(head.length == 0){
      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      return;
    }

    var param = new DataMap();
    param.put("head",head);
    param.put("item",item);
	param.put("itemTemp",tempItem);

    netUtil.send({
      url : "/outbound/json/allocateDL01.data",
      param : param,
      successFunction : "successSaveCallBack"
    });
  }
  
  function Unallocate(){    
    var head = getfocusGridDataList("gridHeadList");
    var item = gridList.getSelectData("gridItemList");
    //아이템 템프 가져오기
    var tempItem = gridList.getTempData("gridHeadList")
          
    if(head.length == 0){
      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      return;
    }

    var shpdiSum = new Number();
	var qtshpo   = new Number();
	var qtaloc   = new Number();
	var qtjcmp   = new Number();
	
    for(var i=0; i<head.length; i++){
    	
    	qtshpo +=  Number(head[i].get("QTSHPO"));
    	qtaloc +=  Number(head[i].get("QTALOC"));
    	qtjcmp +=  Number(head[i].get("QTJCMP"));
    }
    
    shpdiSum = Number(qtaloc) -  Number(qtjcmp);
 
	if(shpdiSum == 0 ){
		alert("* 할당 수량이 없습니다. \n\n할당 작업후에 처리해 주십시오. *");
		return;
	}

    var param = new DataMap();
    param.put("head",head);
    param.put("item",item);
	param.put("itemTemp",tempItem);

    netUtil.send({
      url : "/outbound/json/unallocateDL26.data",
      param : param,
      successFunction : "successSaveCallBack"
    });
  }
  
  function confirmOrderDoc(){   
    var head = getfocusGridDataList("gridHeadList");
    var item = gridList.getSelectData("gridItemList");
    //아이템 템프 가져오기
    var tempItem = gridList.getTempData("gridHeadList")

    if(head.length == 0){
      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      return;
    }
    var shpdiSum = new Number();
	var qtshpo   = new Number();
	var qtaloc   = new Number();
	var qtjcmp   = new Number();
  
    for(var i=0; i<head.length; i++){

	    var shpmty = head[i].get("SHPMTY");
	    var statit = head[i].get("STATIT");
	
	    if(shpmty == "266" && (statit == "NEW")){
	      alert(getMessage("VALID","M0009",["이고출고는 수량 0을 출고할 수 없습니다."]));
	      return;
	    }
	    	
	   	qtshpo +=  Number(head[i].get("QTSHPO"));
	   	qtaloc +=  Number(head[i].get("QTALOC"));
	   	qtjcmp +=  Number(head[i].get("QTJCMP"));
	     
	    shpdiSum = Number(qtaloc) -  Number(qtjcmp);
	 
		var msgStr =  "주문량 전송하면 지시수량이 할당 수량으로 변경됩니다.\n주문수량을 전송하시겠습니까? \n\n지시수량합계 : "+ qtshpo +"    할당수량합계 : "+qtaloc;
		if(!confirm(msgStr)){
			return;
		}
    }
    var param = new DataMap();
    param.put("head",head);
    param.put("item",item);
	param.put("itemTemp",tempItem);

    netUtil.send({
      url : "/outbound/json/confirmOrderDocDL26.data",
      param : param,
      successFunction : "successSaveCallBackOrderDocConfirm"
    });
  }
  
  
  function confirmOrderTask(){    
    var head = getfocusGridDataList("gridHeadList");
    var item = gridList.getSelectData("gridItemList");
    //아이템 템프 가져오기
    var tempItem = gridList.getTempData("gridHeadList")
          
    if(head.length == 0){
      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      return;
    }
    
    var shpdiSum = new Number();
	var qtshpo = new Number();
	var qtaloc = new Number();
	var qtjcmp = new Number();
	
    for(var i=0; i<head.length; i++){

	  	qtshpo += head[i].get("QTSHPO");
	  	qtaloc += head[i].get("QTALOC");
	  	qtjcmp += head[i].get("QTJCMP");
	  	var drelin = head[i].get("DRELIN");
	  	shpdiSum = Number(qtaloc) -  Number(qtjcmp);  
	  	if(shpdiSum == 0){
			alert("* 피킹완료 처리할 수량이 없습니다. ");
			return;
	  	}
		if("No" == drelin){
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
  
  function successSaveCallBackOrderDocConfirm(json, status){
    if(json && json.data){
      if(json.data == "OK"){
    	  
    	  $('#BTN_SAVE').hide()
    	  $('#BTN_UNALLOC').hide()
    	  $('#BTN_REMOVE').hide()
    	  $('#BTN_DRELIN').hide()
//    	  $('#BTN_PICKED').hide()
    	  
//    	  gridList.setReadOnly("gridHeadList", true, ["CARNUM", "SHIPSQ", "PERHNO", "CASTIM"]);
  
          commonUtil.msgBox("SYSTEM_SAVEOK");
          searchList();
      }else if(json.data == "F1"){
        commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      }else{
        commonUtil.msgBox("EXECUTE_ERROR");
      }
    }
  }
  
  function successSaveCallBack(json, status){
    if(json && json.data){
      if(json.data != ""){
        commonUtil.msgBox("SYSTEM_SAVEOK");
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
    	
//	  gridList.setReadOnly("gridHeadList", false, ["CARNUM", "SHIPSQ", "PERHNO", "CASTIM"]);
    	
      $('#BTN_SAVE').show()
  	  $('#BTN_UNALLOC').show()
  	  $('#BTN_REMOVE').show()
  	  $('#BTN_DRELIN').show()
  	  $('#BTN_PICKED').show()

      searchList();
    }else if(btnName == "Save"){      
      save();
    }else if(btnName == "Remove"){
      remove();
    }else if(btnName == "Allocate"){
        allocate();
    }else if(btnName == "Unallocate"){
    	Unallocate();
    }else if(btnName == "ConfirmOrderDoc"){
      confirmOrderDoc();
    }else if(btnName == "confirmOrderTask"){
      confirmOrderTask();
    }else if(btnName == "Reload"){
      reload();
	}else if(btnName == "Print"){
		print5();
	}
    else if(btnName == "PRINT"){
		print();
	}else if(btnName == "PRINT4"){
		print4();
    }else if(btnName == "close"){
        close();
	}else if(btnName == "Savevariant"){
		sajoUtil.openSaveVariantPop("searchArea", "DL32");
	}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DL32");
	}
  }
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
    	}
	}
	
	//ezgen 구현
	function print5(){
		var wherestr = " AND H.TASKKY IN (";
		
		var head = gridList.getGridData("gridHeadList", true);
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
		var orderby = " ORDER BY LOCASR";
		
		//이지젠 호출부(신버전)
		var width = 840;
		var heigth = 600;
		var map = new DataMap();
		map.put("i_option",$('#OPTION').val());
		
		if($("#WAREKY").val() == "2114" || $("#WAREKY").val() == "2254"){
			WriteEZgenElement("/ezgen/order_picking_list_urgent_inchun.ezg" , where , orderby , "KO", map , width , heigth );
		}else{
			WriteEZgenElement("/ezgen/order_picking_list_urgent.ezg" , where , orderby , "KO", map , width , heigth );	
		}
	}
	
	function print(){ // 출고명세서 인쇄
//		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getGridData("gridHeadList", true);
			//체크가 없을 경우 

			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var where = "";
			for(var i =0;i < head.length ; i++){
				
				if(where == ""){
					where = where+" AND SH.SHPOKY IN (";
				}else{
					where = where+",";
				}
				
				where += "'" + head[i].get("SHPOKY") + "'";
			}
			where += ") AND SR.DOCSEQ != ' ' ";
			var langKy = "KO";
			var width = 840;
			var heigth = 600;
			var map = new DataMap();
				map.put("i_option",$('#OPTION').val());
				
			if(ownrky == "2100" || ownrky == "2500"){
				WriteEZgenElement("/ezgen/shpdri_direct.ezg" , where , " " , langKy, map , width , heigth );	
			}else{
				WriteEZgenElement("/ezgen/shpdri_direct.ezg" , where , " " , langKy, map , width , heigth );
			}
			searchList();
//		}
	}
	
	function print4(){ // 인쇄(이고출고)
		
//		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
		var head = gridList.getGridData("gridHeadList", true);
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		var where = "";
		for(var i =0;i < head.length ; i++){
			
			if(where == ""){
				where = where+" AND SH.SHPOKY IN (";
			}else{
				where = where+",";
			}
			
			where += "'" + head[i].get("SHPOKY") + "'";
		}
		where += ") AND SR.DOCSEQ != ' ' ";
		var langKy = "KO";
		var width = 840;
		var heigth = 600;
		var map = new DataMap();
			map.put("i_option",$('#OPTION').val());
			
		if(ownrky == "2100" || ownrky == "2500"){
			WriteEZgenElement("/ezgen/shpdri_direct2.ezg" , where , " " , langKy, map , width , heigth );	
		}else{
			WriteEZgenElement("/ezgen/shpdri_direct2.ezg" , where , " " , langKy, map , width , heigth );
		}
		searchList();

//		}
	}
	
	 //데이터가 바인드된후 
    function gridListEventDataBindEnd(gridId, dataLength, excelLoadType){
       if(gridId=="gridHeadList"){
			var headGridBox = gridList.getGridBox('gridHeadList');
			var headList = headGridBox.getDataAll();
			
			for(var i=0; i<headList.length; i++){
				if(gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "QTALOC") != '0'){
					gridList.setReadOnly("gridHeadList", true, ["QTALOC"]);		
				}
				
				if(gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "PGRC02") == '02' || gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "SHPMTY") == '266' || gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "SHPMTY") == '267'){
					//gridList.setReadOnly("gridHeadList", false, ["CARDAT"]);		
				} else { 
					//gridList.setReadOnly("gridHeadList", true, ["CARDAT"]);							
				}
			}
       }else if("gridItemList"){

			gridList.checkAll("gridItemList", false);
       }
    }
	 
	  function close(){    
		  
	        var head = gridList.getGridData("gridHeadList");
	        var item = gridList.getSelectData("gridItemList");
	        //아이템 템프 가져오기
	        var tempItem = gridList.getSelectTempData("gridHeadList");
	        
		    if(head.length == 0){
		      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
		      return;
		    }
		    
		    var qtychk = "";
			var syschk = "";
			var keychk = "";
			
		    for(i=0; i<item.length; i++){
		    	var qtaloc = item[i].get("QTALOC");
		    	var qtjcmp = item[i].get("QTJCMP");
		    	var qtshpd = item[i].get("QTSHPD");
		    	
		    	if (qtaloc != qtjcmp){
		    		qtychk = "Y";
					keychk = item[i].get("SHPOKY");
		    	} else if (qtjcmp != qtshpd) {
		    		syschk = "Y";
		    	}
		    	
		    	if (qtychk == "Y"){
					alert("출고문서번호" + keychk + "의 할당수량과 피킹완료수량이 불일치합니다.");
					return;
				}
			}

		    var param = new DataMap();
		    param.put("head",head);
		    param.put("item",item);
			param.put("itemTemp",tempItem);

		    netUtil.send({
		      url : "/outbound/json/closeDL50.data",
		      param : param,
		      successFunction : "successSaveCallBack"
		    });
		  }
	  
	  
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
		//출고문서번호
		if(searchCode == "VSHPOKY" && $inputObj.name == "SHPOKY"){
			param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
			param.put("NOBIND","Y");
		  	
// 		  	var rangeArr = new Array();
// 				//배열내 들어갈 데이터 맵 선언
// 				var rangeDataMap = new DataMap();
// 				// 필수값 입력
// 				rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"="); // =  != > < 표시
// 				rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, $('#OWNRKY').val());
// 				//배열에 맵 탑제 
// 				rangeArr.push(rangeDataMap);
// 		      param.put("OWNRKY", returnSingleRangeDataArr(rangeArr));
		}else if(searchCode == "SHCARMA2"){ 
			param.put("WAREKY",$("#WAREKY").val());
            param.put("OWNRKY",$("#OWNRKY").val());
			
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
          <input type="button" CB="Save SAVE BTN_SAVE" id="BTN_SAVE"/>
          <input type="button" CB="Unallocate SAVE BTN_UNALLOC" id="BTN_UNALLOC"/>
          <input type="button" CB="Remove SEARCH BTN_REMOVE" id="BTN_REMOVE"/>
          <input type="button" CB="ConfirmOrderDoc SAVE BTN_DRELIN" id="BTN_DRELIN"/>
          <input type="button" CB="Print PRINT_OUT BTN_PKPRINT" />
          <input type="button" CB="confirmOrderTask SAVE BTN_PICKED" id="BTN_PICKED"/>
		  <input type="button" CB="PRINT PRINT_OUT BTN_SHPRINT" /> 
		  <input type="button" CB="PRINT4 PRINT_OUT BTN_YIGOSHIP" /> <!-- 인쇄(이고출고) -->
		  <!-- <input type="button" CB="close SAVE BTN_ERPSEND" /> -->
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
          <dl>  <!--출고문서번호-->  
            <dt CL="STD_SHPOKY"></dt> 
            <dd> 
              <input type="text" class="input" id="SHPOKY"  name="SHPOKY" UIInput="S,VSHPOKY" validate="required"/> 
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
          <li style="TOP: 5PX;VERTICAL-ALIGN: middle;"><span CL="STD_PRINTOPT1" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;"></span>
          <select name="OPTION" id="OPTION"  class="input" Combo="SajoCommon,CMCDV_COMBO" ComboCodeView="true"></select></li>
          >> 매출처명  : <span id="ptnrodnm"></span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        
          >> 납품처명  : <span id="ptnrtonm"></span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>
          >> 배송지 우편번호 : <span id="postcode"></span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          >> 배송지 주소 : <span id="address"></span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          >> 전송여부 : <span id="sentyn"></span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          >> 비고 : <span id="doctxt"></span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;     
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
                      <td GH="40 STD_NUMBER" GCol="rownum">1</td>   
                      <td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 20">출고문서번호</td> <!--출고문서번호-->
                      <td GH="60 STD_SHPOIT" GCol="text,SHPOIT" GF="S 20">출고문서아이템</td>  <!--출고문서아이템-->
                      <td GH="60 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
                      <td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>  <!--제품명-->
                      <td GH="40 STD_DESC02" GCol="text,DESC02" GF="S 200">규격</td>  <!--규격-->
                      <td GH="60 STD_QTSHPO" GCol="text,QTSHPO" GF="N 30,0">지시수량</td> <!--지시수량-->
                      <td GH="60 STD_QTALOC" GCol="text,QTALOC" GF="N 30,0">할당수량</td> <!--할당수량-->
                      <td GH="60 STD_QTJCMP" GCol="text,QTJCMP" GF="N 20,0">완료수량</td> <!--완료수량-->
                      <td GH="80 drelin" GCol="text,DRELIN" GF="S 220">drelin</td>	<!--drelin-->
                      <td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
                      <td GH="80 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>  <!--주문번호(D/O) item-->
                      <td GH="80 IFT_PTNROD" GCol="text,DPTNKY" GF="S 20">매출처코드</td>  <!--매출처코드-->
                      <td GH="80 IFT_PTNRODNM" GCol="text,DPTNKYNM" GF="S 20">매출처명</td>  <!--매출처코드-->
                      <td GH="80 IFT_PTNRTO" GCol="text,PTRCVR" GF="S 20">납품처코드</td>  <!--납품처코드-->
                      <td GH="80 IFT_PTNRTONM" GCol="text,PTRCVRNM" GF="S 20">납품처명</td>  <!--매출처코드-->
                      <td GH="80 STD_CARDAT" GCol="input,CARDAT" GF="C 30">배송일자</td>  <!--배송일자-->
                      <td GH="80 STD_CARNUM" GCol="input,CARNUM,SHCARMA2" GF="S 30">차량번호</td>  <!--차량번호-->
                      <td GH="60 STD_SHIPSQ" GCol="input,SHIPSQ" GF="S 10">배송차수</td> <!--배송차수-->
                      <td GH="70 STD_PERHNO" GCol="input,PERHNO" GF="S 100">기사핸드폰</td>  <!--기사핸드폰-->
                      <td GH="60 STD_CASTIM" GCol="input,CASTIM" GF="T 100">출발시간</td> <!--출발시간-->
                      <td GH="150 STD_DOCTXT" GCol="text,NAME01" GF="S 180">비고</td> <!--비고-->
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          <div class="btn_lit tableUtil">
            <button type='button' GBtn="find"></button>
            <button type='button' GBtn="sortReset"></button>
            <button type='button' GBtn="layout"></button>
            <button type="button" GBtn="total"></button>   
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
          <br> 
          >> 작업 수량 합계  : <span id="qttaorSum"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;       
        >> 팔레트 수량 합계  : <span id="pltqtySum"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
        >> 박스 수량 합계 : <span id="boxqtySum"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
                  <!--화면에 조회 값과 상관없이 로우 선택하는 체크박스 확인   -->
                    <td GH="40" GCol="rowCheck"></td>
                    <td GH="40 STD_NUMBER"   GCol="rownum">1</td>   
                      <td GH="60 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td> <!--로케이션-->
                      <td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td> <!--제품코드-->
                      <td GH="150 STD_DESC01" GCol="text,DESC01" GF="S 200">제품명</td>  <!--제품명-->
                      <td GH="60 STD_DESC02" GCol="text,DESC02" GF="S 200">규격</td>  <!--규격-->
                      <td GH="80 STD_QTSAVLB" GCol="text,AVAILABLEQTY" GF="N 20,0">가용수량</td>
                      <td GH="80 STD_QTTAOR" GCol="input,QTTAOR" GF="N 20,0">작업수량</td>  <!--작업수량-->
                      <td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>  <!--팔렛당수량-->
                      <td GH="80 STD_PLTQTY" GCol="input,PLTQTY" GF="N 17,2">팔레트수량</td> <!--팔레트수량-->
                      <td GH="55 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td> <!--박스입수-->
                      <td GH="55 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>  <!--박스수량-->
                      <td GH="50 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td> <!--잔량-->
                      <td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td> <!--제조일자-->
                      <td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td> <!--입고일자-->
                      <td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td> <!--유통기한-->
                      <td GH="120 STD_LOTA06" GCol="select,LOTA06"> <!--재고유형-->
			        	<select class="input" CommonCombo="LOTA06"></select>
			          </td> 
			          <td GH="130 STD_LOTA05" GCol="select,LOTA05"> <!--포장구분-->
			        	<select class="input" CommonCombo="LOTA05"></select>
			          </td> 
                      <td GH="50 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 20,0">유통잔여(DAY)</td>  <!--유통잔여(DAY)-->
                      <td GH="50 STD_DTREMRAT" GCol="text,DTREMRAT" GF="S 20">유통잔여(%)</td>  <!--유통잔여(%)-->
                      <td GH="100 STD_LOTNUM" GCol="text,LOTNUM" GF="S 10">Lot number</td>	<!--Lot number-->
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          <div class="btn_lit tableUtil">
            <button type='button' GBtn="find"></button>
            <button type='button' GBtn="sortReset"></button>
            <button type='button' GBtn="layout"></button>
            <button type="button" GBtn="total"></button>   
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