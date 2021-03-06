<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL34</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var carRate = new DataMap();
  $(document).ready(function(){
    gridList.setGrid({
        id : "gridHeadList",
        module : "Outbound", 
      command : "DL34_HEAD",
      pkcol : "OWNRKY,WAREKY",
//      itemGrid : "gridItemList",
      itemSearch : true,
	    menuId : "DL34"
      });
    
    gridList.setGrid({
        id : "gridItemList",
        module : "Outbound",
      command : "DL34_ITEM",
      pkcol : "OWNRKY,WAREKY",
      emptyMsgType : false,
	    menuId : "DL34"
      });
     
    $("#searchArea [name=OWNRKY]").on("change",function(){
      searchwareky($(this).val());

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
      
    });
    
    searchwareky($('#OWNRKY').val());
    
	//CARDAT 하루 더하기 
	$("[name=CAR_CARDAT]").val(dateParser(null, "S", 0, 0, 1));
	$("[name=CAR_CARDAT]").change();

    //콤보박스 리드온리
    gridList.setReadOnly("gridHeadList", true, ["WAREKY" , "OWNRKY", "C00103", "DOCUTY", "STATUS", "WARESR", "PTNG06"]);
    gridList.setReadOnly("gridItemList", true, ["WAREKY" , "QTYREQ", "C00103"]);

    //getRate 값 세팅 
    carRate.put('1.5T', 'D1T');
    carRate.put('2.5T', 'D25T')
    carRate.put('3.5T', 'D35T');
    carRate.put('5T', 'D5T');
    carRate.put('8T', 'D8T');
    carRate.put('11T', 'D11T');
    carRate.put('15T', 'D15T');
    
    // 다른페이지에서 받아온 데이터가 있을 경우
	var data = page.getLinkPageData("DL34");
	if(data){
		$('#OWNRKY').val(data.get("OWNRKY"));
		searchwareky(data.get("OWNRKY"));
		$('#WAREKY').val(data.get("WAREKY"));
		inputList.rangeMap["map"]["DOCDAT"].$from.val(dateParser(data.get("DOCDAT"), "SD", 0, 0, 0)); 
		
		searchList()
	}
    
    inputList.setMultiComboSelectAll($("#CARGBN"), false);
    inputList.setMultiComboSelectAll($("#CARTMP"), false);
    
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
  
  //버튼작동
  function commonBtnClick(btnName){
    if(btnName == "Search"){
      searchList();
    }else if(btnName == "Save"){
      save();
    }else if(btnName == "Auto"){
      auto();
    }else if(btnName == "Auto2"){
      auto2();
    }else if(btnName == "Fixed"){
      fixed();
    }else if(btnName == "Fixed2"){
      fixed2();
    }else if(btnName == "ConfirmOrderDoc"){
      confirmOrderDoc();
    }else if(btnName == "SetAll"){
      setAll();
    }else if(btnName == "SetChk"){
      setChk();
	}else if(btnName == "DL30Link"){
		DL30Link();		
	}else if(btnName == "Savevariant"){
		sajoUtil.openSaveVariantPop("searchArea", "DL34");
	}else if(btnName == "Getvariant"){
		sajoUtil.openGetVariantPop("searchArea", "DL34");
	}
  }

  //조회
  function searchList(){
    if(validate.check("searchArea")){
      var param = inputList.setRangeDataParam("searchArea");
      param.put("DOCDAT",regExp(inputList.rangeMap["map"]["DOCDAT"].$from.val()));
      //헤더 조회
	  gridList.gridList({
      	id : "gridHeadList",
      	param : param
      });		

      //아이템 조회
	  netUtil.send({
	  	url : "/outbound/json/displayItemDL34.data",
	  	param : param,//gridList.gridList({
	  	sendType : "list",//    id : "gridHeadList",
	  	bindType : "grid",  //bindType grid 고정//    param : param
	  	bindId : "gridItemList" //그리드ID//  });
	  });
      //gridList.gridList({
      //    id : "gridItemList",
      //    param : param
      //  });
      
	  //차량번호 초기화 
	  $("#CARNUM_ALL").val("");

    }
  }
  
  //저장
  function save(){
        var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getGridData("gridItemList");
          
    if(item.length == 0){
      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      return;
    }
    
    
    for(var i=0; i<item.length; i++){   
      
      var shipsqChk = "";
      
      var ownrky = $("#OWNRKY").val();
      
      if(ownrky == "2100" || ownrky == "2500"){//사통합 수정
        
/*          for(var i=1; i<=carAlc.RowCount; i++){
          var shipsq = gridList.getColData("gridItemList", i, "SHIPSQ");
          var carnum = gridList.getColData("gridItemList", i, "CARNUM");
          if (shipsqChk == "" && parseInt(shipsq) != 0){
            shipsqChk = shipsq;
          }
          else if (shipsqChk != "" && parseInt(shipsqChk) != 0) {
            if(gridList.getColData("gridItemList", i, "SHIPSQ") != 0 && shipsqChk != shipsq){
              alert("1개의 차수만 저장가능합니다.");
              return;
            }
          }
        }
 */     }   
    }
       var param = new DataMap();
    param.put("head",head);
    param.put("item",item);
    
	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
		return;
    }

    netUtil.send({
      url : "/outbound/json/saveDL34.data",
      param : param,
      successFunction : "successSaveCallBack"
    });
  }

  function auto(){
        var head = gridList.getSelectData("gridHeadList");
        //var item = gridList.getSelectData("gridItemList");
        var item = gridList.getGridData("gridItemList");  
    if(item.length == 0){
      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      return;
    }
    
    
    for(var i=0; i<item.length; i++){   
      
      var shipsqChk = "";
      
      var ahipsqAll = $("#SHIPSQ_ALL").val();
      
      if(ahipsqAll == "" || ahipsqAll == "0"){
        commonUtil.msgBox("OUT_M0145");
          return;
        }   
    }
       var param = new DataMap();
    param.put("head",head);
    param.put("item",item);
    param.put("SHIPSQ",ahipsqAll);

    netUtil.send({
      url : "/outbound/json/autoDL34.data",
      param : param,
      successFunction : "successSaveCallBack"
    });
  }

  function auto2(){
        var head = gridList.getSelectData("gridHeadList");
        //var item = gridList.getSelectData("gridItemList");
        var item = gridList.getGridData("gridItemList");  
    if(item.length == 0){
      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      return;
    }
    
    
    for(var i=0; i<item.length; i++){   
      
      var shipsqChk = "";
      
      var ahipsqAll = $("#SHIPSQ_ALL").val();
      
      if(ahipsqAll == "" || ahipsqAll == "0"){
        commonUtil.msgBox("OUT_M0145");
          return;
        }   
    }
       var param = new DataMap();
    param.put("head",head);
    param.put("item",item);
    param.put("SHIPSQ",ahipsqAll);

    netUtil.send({
      url : "/outbound/json/auto2DL34.data",
      param : param,
      successFunction : "successSaveCallBack"
    });
  }

  function fixed(){
        var head = gridList.getSelectData("gridHeadList");
        //var item = gridList.getSelectData("gridItemList");
        var item = gridList.getGridData("gridItemList");  
    if(item.length == 0){
      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      return;
    }
    
    
    for(var i=0; i<item.length; i++){   
      
      var shipsqChk = "";
      
      var ahipsqAll = $("#SHIPSQ_ALL").val();
      
      if(ahipsqAll == "" || ahipsqAll == "0"){
        commonUtil.msgBox("OUT_M0145");
          return;
        }   
    }
       var param = new DataMap();
    param.put("head",head);
    param.put("item",item);
    param.put("SHIPSQ",ahipsqAll);

    netUtil.send({
      url : "/outbound/json/fixedDL34.data",
      param : param,
      successFunction : "successSaveCallBack"
    });
  }
  
  function fixed2(){
        var head = gridList.getSelectData("gridHeadList");
        //var item = gridList.getSelectData("gridItemList");
        var item = gridList.getGridData("gridItemList");  
    if(item.length == 0){
      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      return;
    }
    
    
    for(var i=0; i<item.length; i++){   
      
      var shipsqChk = "";
      
      var ahipsqAll = $("#SHIPSQ_ALL").val();
      
      if(ahipsqAll == "" || ahipsqAll == "0"){
        commonUtil.msgBox("OUT_M0145");
          return;
        }   
    }
       var param = new DataMap();
    param.put("head",head);
    param.put("item",item);
    param.put("SHIPSQ",ahipsqAll);

    netUtil.send({
      url : "/outbound/json/fixed2DL34.data",
      param : param,
      successFunction : "successSaveCallBack"
    });
  }
  
  function confirmOrderDoc(){   
        var head = gridList.getGridData("gridHeadList");
        var item = gridList.getGridData("gridItemList");
          
    if(head.length == 0){
      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
      return;
    }

    var param = new DataMap();
    param.put("head",head);
    param.put("item",item);

    netUtil.send({
      url : "/outbound/json/confirmOrderDocDL34.data",
      param : param,
      successFunction : "successSaveCallBack"
    });
  }
  
  //체크적용
  function setChk(){
    //인풋값 가져오기
    var carnumchk = $('#carnumchk').prop("checked");
    var shipsqchk = $('#shipsqchk').prop("checked");

    if(!carnumchk && !shipsqchk){
      commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
      return;
    }
    //수정불가조건 체크 를 위해 체크박스 체크한 리스트만 들고온다.
    var list = gridList.getGridData("gridItemList");
//    var list = gridList.getSelectData("gridItemList");
    for(var i=0; i<list.length; i++){   
      if (list[i].get("SHIPSQ") == "0"){
	      if(carnumchk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "CARNUM", $("#CARNUM_ALL").val()); 
	      if(carnumchk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "DESC01", $("#DESC01_ALL").val());
	      if(shipsqchk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "SHIPSQ", $("#SHIPSQ_ALL").val());  
      }
    
    }
  }

  //일괄적용 (데이터 수정시 체크박스가 체크되기 때문에 모든 로우를 체크후 setChk호출)
  function setAll(){
    
    var carnumchk = $('#carnumchk').prop("checked");
    var shipsqchk = $('#shipsqchk').prop("checked");

    if(!carnumchk && !shipsqchk){
      commonUtil.msgBox("OUT_M0103"); //선택한 자료가 없습니다.
      return;
    }
    
//    gridList.checkAll("gridItemList",true);
    
    //수정불가조건 체크 를 위해 체크박스 체크한 리스트만 들고온다.
    var list = gridList.getGridData("gridItemList");
//    var list = gridList.getSelectData("gridItemList");
    for(var i=0; i<list.length; i++){   
      if(carnumchk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "CARNUM", $("#CARNUM_ALL").val()); 
      if(carnumchk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "DESC01", $("#DESC01_ALL").val());
      if(shipsqchk) gridList.setColValue("gridItemList", list[i].get("GRowNum"), "SHIPSQ", $("#SHIPSQ_ALL").val());  
    }
  }
  
  //아이템그리드 조회
  function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
    if(gridId == "gridHeadList"){
      //row데이터 이외에 검색조건 추가가 필요할 떄 
      var rowData = gridList.getRowData(gridId, rowNum);
      var param = inputList.setRangeParam("searchArea");
      param.putAll(rowData);
      gridList.gridList({
          id : "gridItemList",
          param : param
        });
    }
  }
  
  //그리드 조회 후 
  function gridListEventDataBindEnd(gridId, dataCount){
    if(gridId == "gridHeadList" && dataCount == 0){
      gridList.resetGrid("gridItemList");
    }else if(gridId == "gridHeadList" && dataCount > 0){

      var headGridBox = gridList.getGridBox('gridHeadList');
      var headList = headGridBox.getDataAll();
      
      for(var i=0; i<headList.length; i++){
        //출고작업지시하지 않았을 경우 행 수정 불가 (HEADER)
        if(gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "C00102") != 'Y'){
          gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), true, ["DIRDVY", "DIRSUP", "ORDDAT"]);
        }else{
          gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), false, ["DIRDVY", "DIRSUP", "ORDDAT"]);
        }
      }
      
      
    }else if(gridId == "gridItemList" && dataCount > 0){

      var itemGridBox = gridList.getGridBox('gridItemList');
      var itemList = itemGridBox.getDataAll();
      
      for(var i=0; i<itemList.length; i++){
        
        //이고출고 거점수정 불가
        if(gridList.getColData("gridItemList", i, "DOCUTY") == '266' || gridList.getColData("gridItemList", i, "DOCUTY") == '267'){
          gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["WAREKY"]);
        }else{
          gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), false, ["WAREKY"]);
        }
        
        // 출고(할당 이후) 작업 했을 시(wmsmgt,qtshpd > 0) 수정 불가
        if(Number(gridList.getColData("gridItemList", i, "WMSMGT")) > 0 || Number(gridList.getColData("gridItemList", i, "QTSHPD")) > 0){ 
          gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["WAREKY" , "QTYREQ", "C00103"]); 
        }else{
          gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), false, ["WAREKY" , "QTYREQ", "C00103"]);
        }

        
        //출고작업지시하지 않았을 경우 행 수정 불가 (ITEM)
        if(gridList.getColData("gridItemList", i, "C00102") != 'Y'){
          gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), true, ["WAREKY" , "QTYREQ", "C00103"]); 
        }else{
          gridList.setRowReadOnly("gridItemList", itemList[i].get("GRowNum"), false, ["WAREKY" , "QTYREQ", "C00103"]); 
        }
      }

      //헤더 체크
      var headGridBox = gridList.getGridBox('gridHeadList');
      var headList = headGridBox.getDataAll();
      
      for(var i=0; i<headList.length; i++){
        //출고작업지시하지 않았을 경우 행 수정 불가 (HEADER)
        if(gridList.getColData("gridHeadList", headList[i].get("GRowNum"), "C00102") != 'Y'){
          gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), true, ["DIRDVY", "DIRSUP", "ORDDAT"]);
        }else{
          gridList.setRowReadOnly("gridHeadList", headList[i].get("GRowNum"), false, ["DIRDVY", "DIRSUP", "ORDDAT"]);
        }
      }
    }
  }
  
  //콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
  function comboEventDataBindeBefore(comboAtt, $comboObj){
    var param = new DataMap();
    if(comboAtt == "SajoCommon,RSNCOD_COMCOMBO"){
      param.put("DOCCAT", "200");
      param.put("DOCUTY", "214");
      param.put("OWNRKY", $("#OWNRKY").val());
    }else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
      param.put("UROLKY", "<%=urolky%>");
      return param;
    }else if( comboAtt == "SajoCommon,SEARCH_WAREKY_COMCOMBO" ){
      param.put("USERID", "<%=userid%>");
      param.put("OWNRKY", $("#OWNRKY").val());
      return param;
    } else if(comboAtt == "Common,CMCDV_COMBO"){
      var cmcdky = "";
      
      var comboName = $comboObj[0].name;
      switch (comboName) {
      case "ALFTKY":
        cmcdky = "ALSSRT"
        break;
      case "SSORKY":
        cmcdky = "SORTCD"
        break;  
      default:
        break;
      } 
      param.put("CMCDKY", cmcdky);
    }
    return param;
  }
  
  //그리드 컬럼 변경 이벤트
  function gridListEventColValueChange(gridId, rowNum, colName, colValue){
    if(gridId == "gridItemList"){
       if(colName == "QTYREQ" || colName == "BOXQTY" || colName == "REMQTY"){ //수량변경시연결된 수량 변경
        var qtyreq = 0;
        var boxqty = 0;
        var remqty = 0;
        var pltqty = 0;
        var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
        var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
        var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
        var remqtyChk = 0;
        var totshp = 0;     //총출고수량
        var qtyreq2 = 0;    //납품요청수량(수정)
        
          if( colName == "QTYREQ" ) { //납품요청수량 변경시
          //납품요청수량과 원주문수량 비고
            if(Number(gridList.getColData(gridId, rowNum, "QTYREQ")) > Number(gridList.getColData(gridId, rowNum, "QTYORG"))){
            alert("* 납품요청수량이 원주문수량보다 큽니다. *");
            gridList.setColValue(gridId, rowNum, "QTYREQ", 0);
          }

            //박스 수량 등을 계산하여 각 컬럼에 세팅
            qtyreq = gridList.getColData(gridId, rowNum, "QTYREQ");
            boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
            remqty = gridList.getColData(gridId, rowNum, "REMQTY");
            
            boxqty = floatingFloor(Math.floor((Number)(qtyreq)/(Number)(bxiqty), 0), 1);
            remqty = (Number)(qtyreq)%(Number)(bxiqty);
            pltqty = floatingFloor(Math.floor((Number)(qtyreq)/(Number)(pliqty), 0), 2);
            qtyreq2 = (Number)(qtyreq) - (Number)(gridList.getColData(gridId, rowNum, "QTSHPD"));
            totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(qtyreq2);
            
            gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
          gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
          gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
          gridList.setColValue(gridId, rowNum, "QTYREQ2", qtyreq2);
          gridList.setColValue(gridId, rowNum, "TOTSHP", totshp);
          }
          if( colName == "BOXQTY" ){ //박스수량 변경시
          //박스수량을 낱개수량으로 변경하여 계산한다.
            boxqty = colValue;
            remqty = gridList.getColData(gridId, rowNum, "REMQTY");
            qtyreq = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty) + (Number)(gridList.getColData(gridId, rowNum, "QTSHPD"));
            qtyreq2 = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty);
            pltqty = floatingFloor(Math.floor((Number)(qtyreq)/(Number)(pliqty), 0), 2);
            totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(qtyreq2);
            
            //수량 CHECK
            if(Number(qtyreq) > Number(gridList.getColData(gridId, rowNum, "QTYORG"))){
            alert("* 납품요청수량이 원주문수량보다 큽니다. *");
            gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
            boxqty = 0;
              remqty = gridList.getColData(gridId, rowNum, "REMQTY");
              qtyreq = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty) + (Number)(gridList.getColData(gridId, rowNum, "QTSHPD"));
              qtyreq2 = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty);
              pltqty = floatingFloor(Math.floor((Number)(qtyreq)/(Number)(pliqty), 0), 2);
              totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(qtyreq2);
          }
            
            //계산한 수량 세팅
            gridList.setColValue(gridId, rowNum, "QTYREQ", qtyreq);
            gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
            gridList.setColValue(gridId, rowNum, "QTYREQ2", qtyreq2);
            gridList.setColValue(gridId, rowNum, "TOTSHP", totshp);
          }
          if( colName == "REMQTY" ){ //잔량변경시
            qtyreq = gridList.getColData(gridId, rowNum, "QTYREQ");
            boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
            remqty = colValue;  
            
            //잔량으로 박스수량 등 계산
            remqtyChk = (Number)(remqty)%(Number)(bxiqty);
            boxqty = floatingFloor((Number)(boxqty) + (Number)(Math.floor((Number)(remqty)/(Number)(bxiqty), 0)), 1);
            qtyreq = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
            qtyreq2 = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
            pltqty = floatingFloor(Math.floor((Number)(qtyreq2)/(Number)(pliqty), 0), 2);
            totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(qtyreq2);
            
             //수량 CHECK
            if(Number(qtyreq) > Number(gridList.getColData(gridId, rowNum, "QTYORG"))){
            alert("* 납품요청수량이 원주문수량보다 큽니다. *");
            gridList.setColValue(gridId, rowNum, "REMQTY", 0);
            remqty = 0;
            remqtyChk = (Number)(remqty)%(Number)(bxiqty);
            boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
            qtyreq = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
            qtyreq2 = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
            pltqty = floatingFloorfloatingFloor((Number)(qtyreq2)/(Number)(pliqty), 2);
            totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(qtyreq2);
          }
            
            //수량 세팅
          gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
          gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
          gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty); 
          gridList.setColValue(gridId, rowNum, "QTYREQ", qtyreq);
          gridList.setColValue(gridId, rowNum, "QTYREQ2", qtyreq2);
          gridList.setColValue(gridId, rowNum, "TOTSHP", totshp); 
          }
          //미사용
         /*  if( colName == "QTYREQ2" ) {
            //수량 CHECK
            if(Number(gridList.getColData(gridId, rowNum, "QTYREQ2")) + Number(gridList.getColData(gridId, rowNum, "QTSHPD")) > Number(gridList.getColData(gridId, rowNum, "QTYORG"))){
            alert("* 납품요청수량이 원주문수량보다 큽니다. *");
            gridList.setColValue(gridId, rowNum, "QTYREQ2", 0);
          }
            qtyreq2 = gridList.getColData(gridId, rowNum, "QTYREQ2");
            boxqty = gridList.getColData(gridId, rowNum, "BOXQTY");
            remqty = gridList.getColData(gridId, rowNum, "REMQTY");
            qtyreq = (Number)(qtyreq2) + (Number)(gridList.getColData(gridId, rowNum, "QTSHPD"));
            boxqty = Math.floor((Number)(qtyreq2)/(Number)(bxiqty), 0);
            remqty = (Number)(qtyreq2)%(Number)(bxiqty);
            pltqty = Math.floor((Number)(qtyreq)/(Number)(pliqty), 0);
            totshp = (Number)(gridList.getColData(gridId, rowNum, "QTSHPD")) + (Number)(qtyreq2);
            
            gridList.setColValue(gridId, rowNum, "QTYREQ", qtyreq);
            gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
          gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
          gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
          gridList.setColValue(gridId, rowNum, "TOTSHP", totshp);
          } */
        }else if( colName == "C00103" ){
          var c00103 = gridList.getColData(gridId, rowNum, "C00103");
          if(Number(c00103) < 900){
            alert('사용할 수 없는 사유코드 입니다.');
              gridList.setColValue(gridId, rowNum, "C00103", " ");
          }
       }else if(colName == "CARNUM"){

	   		var param = new DataMap();
	   		param.put("OWNRKY", $("#OWNRKY").val());
	   		param.put("WAREKY", $("#WAREKY").val());
	   		param.put("CARNUM", colValue);
	   		
	   		var json = netUtil.sendData({
	   			module : "Outbound",
	   			command : "DL34_GET_CARDESC",
	   			sendType : "list",
	   			param : param
	   		}); 
	   		
	   		//차량정보가 있을 경우 
	   		if(json && json.data && json.data.length > 0 ){
	   			gridList.setColValue(gridId, rowNum, "CARNUM", json.data[0].CARNUM);
	   			gridList.setColValue(gridId, rowNum, "DESC01", json.data[0].DESC01);
	   		}
			//rtnCarData(gridId, rowNum);
       }
    }
  }
  
  //더블클릭
   function gridListEventRowDblclick(gridId, rowNum){
	  
    if(gridId == "gridHeadList"){
        $("#CARNUM_ALL").val(gridList.getColData("gridHeadList", rowNum, "CARNUM")); 
        $("#DESC01_ALL").val(gridList.getColData("gridHeadList", rowNum, "DESC01"));
          return;
      } else if (gridId == "gridItemList"){
    	var data = new DataMap();
		var data = gridList.getRowData("gridItemList", rowNum);
		var option = "height=1200,width=1200,resizable=yes";
		page.linkPopOpen("/wms/outbound/pop/DL31Dialog2.page", data, option);
      }
  }
  //그리드 컬럼 텍스트 컬러 변경 조회후 자동 호출
  function gridListColTextColorChange(gridId, rowNum, colName, colValue){
    if(gridId == "gridItemList"){
      //var colArr = gridList.gridMap.map.gridItemList.cols; //해당그리드의 컬럼 전체 가져오기
      //if(colArr.indexOf(colName)){
      // 가용재고보다 주문수량이 많을 시 글자색 변경
      if(Number(gridList.getColData("gridItemList", rowNum, "ORDTOT")) > Number(gridList.getColData("gridItemList", rowNum, "USEQTY"))){
        return "red";
      }else{ 
        return "black";
      }
      //}
    }
  }
  
  //저장성공시 callback
  function successSaveCallBack(json, status){
    if (json && json.data) {
      if (json.data == "OK") {
        commonUtil.msgBox("SYSTEM_SAVEOK");
        searchList();
      }else{
        commonUtil.msgBox("SYSTEM_SAVE_ERROR");
      }
    }
  }
  
  //서치헬프 기본값 세팅
  function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
      	//출고유형     
       	if(searchCode == "SHDOCTM" && $inputObj.name == "SHPMTY"){
       		param.put("DOCCAT","200");
        }else if(searchCode == "SHDOCTMIF"){
          //nameArray 미존재
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PGRC03"){
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
            param.put("WAREKY","<%=wareky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "PTNRKY1"){
            param.put("WAREKY",$("#WAREKY").val());
            param.put("OWNRKY",$("OWNRKY").val());
            param.put("PTNRTY","0002");
        }
        
        
      return param;
    }
  
  function gridListEventRowCheck(gridId, rowNum, isCheck){	 
//	  gridList.getGridBox('gridHeadList').resetSelected()
//	  var carnum = gridList.getColData("gridHeadList", rowNum, "CARNUM");
//      $("#CARNUM_ALL").val(carnum); 

  }
	function DL30Link(){	
		
        var head = gridList.getSelectData("gridHeadList");
		var ownrky = $('#OWNRKY').val();
		var wareky = $('#WAREKY').val();		
		var rowData = new DataMap();
	
 		var shpokys = [];
 		for(var i=0; i<head.length; i++){
 			var shpoky = head[i].get("SHPOKY");
 			shpokys[i] = shpoky;
 		}
	    rowData.put("OWNRKY",ownrky);  
	    rowData.put("WAREKY",wareky); 
	    rowData.put("SHPOKY",shpokys);  
	    rowData.put("GRPRL","ERPSO"); //GRPRL1
	    
	    page.linkPageOpen("DL30", rowData , true);
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
    	if(gridId=="gridHeadList"){

    		gridList.setReadOnly("gridHeadList", true, ["CARGBN", "CARTMP"]);
    	}else if(gridId=="gridItemList"){
    		gridList.setReadOnly("gridItemList", true, ["ASKU05"]);

			var item = gridList.getGridData("gridItemList");
			for(var i=0; i<item.length; i++){
				if(Number(item[i].map.CNT) > 0){
					gridList.setRowReadOnly("gridItemList", item[i].map.GRowNum, true, ["CARNUM", "SHIPSQ", "ASKU05"]);
		  
				}
			}
    	}
    }
    

	function chkCarWgt(gridId, rowNum){
		var headGridId = "gridHeadList"; 
		if(gridId =="gridItemList2") headGridId = "gridHeadList2";
		
		//헤더를 단 하나만 체크 가능하게 만들었으므로 0번에서 가져온다.
		var head = gridList.getSelectData(headGridId);
		var headRow = head[0].get("GRowNum");
		
		//헤더그리드 고정값 가져오기  (애초에 이컬럼을 쿼리에서 안가져오나 구버전에 로직 유지 )
		var carweg = Number(gridList.getColData(headGridId, headRow, "CARWEG")) < 1 ? 1 : Number(gridList.getColData(headGridId, headRow, "CARWEG"));
		if(!carweg) carweg = 1;
		
		var headCarNum = gridList.getColData(headGridId, headRow, "CARNUM");
		var gTotal1 = gridList.getColData(headGridId, headRow, "GRSWGT1") * carweg;
		var gTotal2 = gridList.getColData(headGridId, headRow, "GRSWGT2") * carweg;	
		var rt1 = gridList.getColData(headGridId, headRow, "RT1");
		var rt2 = gridList.getColData(headGridId, headRow, "RT2");
		var cartmp = gridList.getColData(headGridId, headRow, "CARTMP");
		var cartyp = gridList.getColData(headGridId, headRow, "CARTYP");
		var carmaBoxqty = Number(gridList.getColData(headGridId, headRow, "BOXQTY"));
		var grswgt1 = Number(gridList.getColData(headGridId, headRow, "GRSWGT1"));//무게적재률1
		var grswgt2 = Number(gridList.getColData(headGridId, headRow, "GRSWGT2"));//무게적재률2
		var boxqty = Number(gridList.getColData(headGridId, headRow, "BOXQTY"));//boxqty carma
		var pltqty = Number(gridList.getColData(headGridId, headRow, "PTQTY"));//pltqty carma
		
		//선택된 아이템 그리드의 재배차 차량번호 가져오기
		var curCarAlcCarnum = gridList.getColData(gridId, rowNum, "RECNUM");
		var asku05 = gridList.getColData(gridId, rowNum, "ASKU05");
		var carlAlcBoxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY")); 
		var carlAlcPltqty = Number(gridList.getColData(gridId, rowNum, "PLTQTY")); 
		var grswgt = Number(gridList.getColData(gridId, rowNum, "GRSWGT")); //개당 포장중량
		
		//용차 타입에 맞는 alias 코드를 가져온다 
		var rate = Number(gridList.getColData(gridId, rowNum,carRate.get(cartyp)));
		if(!rate) rate = 0;
		
		//용차 중량 관련세팅(여러개 선택하면 중첩이 되야 할 것 같은데 구버전엔 한줄씩 새로 적용하는식이라 그대로 구현함 )
		if(cartmp == '004' || cartmp == '005'){
			if(asku05 == '001'){
				gridList.setColValue(headGridId, headRow, "RT1", (rt1 - rate));
				gridList.setColValue(headGridId, headRow, "GRSWGT1", (gTotal1 + grswgt*carlAlcBoxqty)/carweg);
			}else{
				gridList.setColValue(headGridId, headRow, "RT2", (rt2 - rate));
				gridList.setColValue(headGridId, headRow, "GRSWGT2", (gTotal2 + grswgt*carlAlcBoxqty)/carweg);
			}
			
		}else if(cartmp == '006'){
			if(asku05 == '002'){
				gridList.setColValue(headGridId, headRow, "RT1", (rt1 - rate));
				gridList.setColValue(headGridId, headRow, "GRSWGT1", (gTotal1 + grswgt*carlAlcBoxqty)/carweg);
			} else{
				gridList.setColValue(headGridId, headRow, "RT2", (rt2 - rate));
				gridList.setColValue(headGridId, headRow, "GRSWGT2", (gTotal2 + grswgt*carlAlcBoxqty)/carweg);
			}
		}else{
			gridList.setColValue(headGridId, headRow, "RT1", (rt1 - rate));
			gridList.setColValue(headGridId, headRow, "GRSWGT1", (gTotal1 + grswgt*carlAlcBoxqty)/carweg);
		}
		
		if(grswgt1 < 0){
			gridList.setColValue(headGridId, headRow, "GRSWGT1", 0);
		}
		gridList.setColValue(headGridId, headRow, "BOXQTY", ""+floatingFloor((Number(boxqty) + Number(carlAlcBoxqty)), 1).toFixed(1));
		gridList.setColValue(headGridId, headRow, "PTQTY", ""+floatingFloor((Number(pltqty) + Number(carlAlcPltqty)), 2).toFixed(2));
		
		gridList.checkGridColor(gridId, rowNum, "RECNUM"); 
		return;
	}
	 
	//차량온도체크 (부분적용이나 일괄적용은 동작 안함 구버전 그대로 적용)
	function chkAsku05(gridId, rowNum){
		var headGridId = "gridHeadList"; 
		if(gridId =="gridItemList2") headGridId = "gridHeadList2";
		//헤더를 단 하나만 체크 가능하게 만들었으므로 0번에서 가져온다.
		var head = gridList.getSelectData(headGridId);
		var headRow = head[0].get("GRowNum");
		
		var asku05 = gridList.getColData(gridId, rowNum, "ASKU05");
		var cartmp = gridList.getColData(headGridId, headRow, "CARTMP");
		
		//거지같게 만들어놓은 로직정리 구버전 if case문 복합체 소스 부분
		if(cartmp == "001" && asku05 =="001" && asku05 != "002" && asku05 != "003"){
			return true;
		}else if(cartmp == "002" && asku05 != "003"){
			return true;
		}else if(cartmp == "003" && asku05 !="001" && asku05 != "002" && asku05 == "003"){
			return true;
		}else if(cartmp == "004" && (asku05 =="001" || asku05 == "002") && asku05 != "003"){
			return true;
		}else if(cartmp == "005" && (asku05 =="001" || asku05 == "003") && asku05 != "002"){
			return true;
		}else if(cartmp == "006" && (asku05 =="002" || asku05 == "003") && asku05 != "001"){
			return true;
		}else{
			//commonUtil.msgBox("OUT_M0150"); 상온은 온도 체크안함 dl34 600line
			return true;
		}
		
	}
	
	//그리드 한번 클릭시
	function gridListEventRowClick(gridId, rowNum, colName){
		var headGridId = "gridHeadList"; 
		if(gridId =="gridItemList2") headGridId = "gridHeadList2";
		//차량적용 이벤트 체크한게 있을떄만 작동
		var headList = gridList.getSelectData(headGridId);
		if(headList.length > 0 && (gridId == "gridItemList" || gridId == "gridItemList2")){
			if(!$("#SHIPSQ_ALL").val() || $("#SHIPSQ_ALL").val() < 1){

				commonUtil.msgBox("배송차수가 0이거나 입력되지 않았습니다.");
				return;
			} 
			
			var head = gridList.getSelectData(headGridId);
			var headRow = head[0].get("GRowNum");
			var carnum = gridList.getColData(headGridId, headRow, "CARNUM");
			
			//차량온도체크
			if(!chkAsku05(gridId, rowNum)) return;
			//중량 적용
			chkCarWgt(gridId, rowNum);
			
			gridList.setColValue(gridId, rowNum, "CARNUM", carnum);
			gridList.checkGridColor(gridId, rowNum, "CARNUM"); 
			gridList.setColValue(gridId, rowNum, "SHIPSQ", $("#SHIPSQ_ALL").val());
			rtnCarData(gridId, rowNum);
		}
	}
	
	//체크박스 체크시
	function gridListEventRowCheck(gridId, rowNum, checkType){
		if((gridId == "gridHeadList" || gridId == "gridHeadList2" ) && checkType){
	        $("#CARNUM_ALL").val(gridList.getColData(gridId, rowNum, "CARNUM")); 
		}	
	}
	
	//차량데이터가져오기
	function rtnCarData(gridId, rowNum){
		var head = gridList.getSelectData("gridHeadList");
		var headRow = head[0].get("GRowNum");

		var param = new DataMap();
		param.put("OWNRKY", $("#OWNRKY").val());
		param.put("WAREKY", $("#WAREKY").val());
		param.put("CARNUM", gridList.getColData("gridHeadList", headRow, "CARNUM"));
		
		var json = netUtil.sendData({
			module : "Outbound",
			command : "DL34_GET_CARDESC",
			sendType : "list",
			param : param
		}); 
		
		//차량정보가 있을 경우 
		if(json && json.data && json.data.length > 0 ){
			gridList.setColValue(gridId, rowNum, "CARNUM", json.data[0].CARNUM);
			gridList.setColValue(gridId, rowNum, "DESC01", json.data[0].DESC01);
		}
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
					<input type="button" CB="Search SEARCH STD_SEARCH" /> 
		            <input type="button" CB="Save SAVE BTN_SAVE" /> 
		            <input type="button" CB="Auto AUTO BTN_AUTO" />
		            <input type="button" CB="Auto2 AUTO BTN_AUTO2" />
		            <input type="button" CB="Fixed AUTO BTN_FIXED" />
		            <input type="button" CB="Fixed2 AUTO BTN_FIXED2" />
					<input type="button" CB="DL30Link DL01_LINK BTN_MNGLINK" />
		            <input type="button" CB="ConfirmOrderDoc SAVE BTN_DRELIN" />
		            <input type="button" CB="Reload RESET STD_REFLBL" />
				</div>
			</div>
			<div class="search_inner">
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
                  
                  <dl>  <!--문서일자-->  
		              <dt CL="STD_DOCDAT"></dt> 
		              <dd> 
		                <input type="text" class="input" name="DOCDAT" id="DOCDAT" UIInput="B" UIFormat="C N"/> 
		              </dd> 
		            </dl>
                  <dl>  <!--배송일자-->  
                    <dt CL="STD_CARDAT"></dt> 
                    <dd> 
					  <input type="text" class="input" name="CAR_CARDAT" UIFormat="C N" validate="required(STD_CARDAT)"/> 
                    </dd> 
                  </dl> 
		            <dl>  <!--차량번호-->  
		              <dt CL="STD_CARNUM_C"></dt>
		              <dd> 
		                <input type="text" class="input" name="CARNUM" UIInput="SR,SHCARMA2"/> 
		              </dd> 
		            </dl>             
		            <dl>  <!--차량명-->  
		              <dt CL="STD_CARNAME"></dt> 
		              <dd> 
		                <input type="text" class="input" name="CARNAME" UIInput="SR"/> 
		              </dd> 
		            </dl> 
		            <dl>  <!--차량 온도-->  
		              <dt CL="STD_CARTMP"></dt> 
		              <dd> 
		                    <select name="CARTMP" id="CARTMP" class="input" comboType="MS" CommonCombo="CARTMP"></select>                                             
		              </dd> 
		            </dl> 
		            <dl>  <!--배송일자_주문-->  
		              <dt CL="STD_CARDAT_O"></dt> 
		              <dd> 
		                <input type="text" class="input" name="CARDAT_O" UIInput="B" UIFormat="C"/> 
		              </dd> 
		            </dl>          
		            <dl>  <!--차량 구분-->  
		              <dt CL="STD_CARGBN"></dt> 
		              <dd> 
		                  <select name="CARGBN" id="CARGBN" class="input" comboType="MS" CommonCombo="CARGBN"></select> 
		              </dd> 
		            </dl> 
		            <dl>  <!--S/O 번호-->  
		              <dt CL="IFT_SVBELN"></dt> 
		              <dd> 
		                <input type="text" class="input" name="SVBELN" UIInput="SR"/> 
		              </dd> 
		            </dl> 
		            <dl>  <!--출고문서번호-->  
		              <dt CL="STD_SHPOKY"></dt> 
		              <dd> 
		                <input type="text" class="input" name="H.SHPOKY" UIInput="SR"/> 
		              </dd> 
		            </dl> 
		            <dl>  <!--출고유형-->  
		              <dt CL="STD_SHPMTY"></dt> 
		              <dd> 
		                <input type="text" class="input" name="SHPMTY" UIInput="SR,SHDOCTM"/> 
		              </dd> 
		            </dl> 
		            <dl>  <!--주문구분-->  
		              <dt CL="STD_PGRC03"></dt> 
		              <dd> 
		                <input type="text" class="input" name="PGRC03" UIInput="SR,SHCMCDV"/> 
		              </dd> 
		            </dl>  
		            <dl>  <!--차량번호-->  
		              <dt CL="STD_CARNUM_O"></dt>	 
		              <dd> 
		                <input type="text" class="input" name="CARNUM_O" UIInput="SR,SHCARMA2"/> 
		              </dd> 
		            </dl> 
		            <dl>  <!--배송차수-->  
		              <dt CL="STD_SHIPSQ"></dt> 
		              <dd> 
		                <input type="text" class="input" name="R.SHIPSQ" UIInput="SR"/> 
		              </dd> 
		            </dl> 
		            <dl>  <!--거래처코드-->  
		              <dt CL="STD_PTNRKY_1"></dt> 
		              <dd> 
		                <input type="text" class="input" name="PTNRKY1" UIInput="SR,SHBZPTN"/> 
		              </dd> 
		            </dl> 
		            <dl>  <!--거래처명-->  
		              <dt CL="STD_PTNRNM"></dt> 
		              <dd> 
		                <input type="text" class="input" name="B.NAME01" UIInput="SR"/> 
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
				<div class="content_layout tabs content_left" style="width: 500px;">
					<ul class="tab tab_style02">
						<li><a href="#tab1-1" id="aHeader1" onclick="moveTab($(this));"><span id="atab1-1">일반</span></a></li>
						<li class="btn_zoom_wrap">
							<ul>
								<!-- <li><button class="btn btn_smaller"><span>축소</span></button></li> -->
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
											<td GH="40 STD_CHECKED" GCol="rowCheck,radio"></td>
											<td GH="40" GCol="rownum">1</td>
											<td GH="100 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>  <!--차량번호-->
											<td GH="100 STD_CARNAME" GCol="text,DESC01" GF="S 30">차량명</td>  <!--차량명-->
											<td GH="75 STD_CARTYP" GCol="text,CARTYP" GF="S 10">차량 톤수</td>  <!--차량 톤수-->
				    						<td GH="90 STD_CARGBN" GCol="select,CARGBN"><!--차량구분-->
												<select class="input" commonCombo="CARGBN"></select>
				    						</td>	
											<td GH="120 STD_CARTMP" GCol="select,CARTMP"> <!--차량온도-->
												<select class="input" commonCombo="CARTMP"></select> 
											</td>
											<td GH="72 STD_PLTQTY" GCol="text,PTQTY" GF="S 20,2" style="text-align:right;">팔레트수량</td> <!--팔레트수량-->
											<td GH="72 STD_BOXQTY" GCol="text,BOXQTY" GF="S 20,1" style="text-align:right;">박스수량</td> <!--박스수량-->
											<td GH="50 STD_RT1" GCol="text,RT1" GF="N 20,2">적재율1</td> <!--적재율1-->
											<td GH="85 STD_RT2" GCol="text,RT2" GF="N 20,2">적재율2</td> <!--적재율2-->
											<td GH="90 STD_GRSWGT1" GCol="text,GRSWGT1" GF="N 20,2">무게적재율1</td> <!--무게적재율1-->
											<td GH="50 STD_GRSWGT2" GCol="text,GRSWGT2" GF="N 20,2">무게적재율2</td> <!--무게적재율2-->
											<td GH="50 STD_DPTCNT" GCol="text,DPTCNT" GF="N 20,0">거래처수</td> <!--거래처수-->
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
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
						</div>
					</div>					
				</div>
				<div class="content_layout tabs content_right" style="width : calc(100% - 500px);">
					<ul class="tab tab_style02">
<!-- 			          <li><a href="#tab1-1" ><span>일반</span></a></li> -->
			          
			          <li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 10PX">
			            <input type="checkbox" id="carnumchk" style="VERTICAL-ALIGN: MIDDLE;"/> 
			            <span style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;">차량번호</span>
			            <input type="text"   id="CARNUM_ALL" name="CARNUM_ALL"  UIInput="I"  class="input" readonly/>
			            <input type="hidden" id="DESC01_ALL" name="DESC01_ALL"  UIInput="I"  class="input" readonly/>
			          </li>
			          <li style="TOP: 5PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 10PX">
			            <input type="checkbox" id="shipsqchk" style="VERTICAL-ALIGN: MIDDLE;"/> 
			            <span style="PADDING-RIGHT: 5PX; VERTICAL-ALIGN: MIDDLE;">배송차수</span>
			            <input type="text" id="SHIPSQ_ALL" name="SHIPSQ_ALL"  UIInput="I"  class="input"/>
			          </li>
			          <li style="TOP: 4PX;VERTICAL-ALIGN: middle;PADDING-RIGHT: 10PX"> <!-- 일괄적용 -->
			            <input type="button" CB="SetAll SAVE BTN_ALL" /> 
			          </li>
			          <li style="TOP: 4PX;VERTICAL-ALIGN: middle;"> <!-- 부분적용 -->
			            <input type="button" CB="SetChk SAVE BTN_PART" />
			          </li>
			          <li class="btn_zoom_wrap">
			            <ul>
			              <li><button class="btn btn_bigger"><span>확대</span></button></li>
			            </ul>
			          </li>
			        </ul>
					<div class="table_box section" id="tab2-1">
						<div class="table_list01">
							<div class="scroll">
								<table class="table_c">
									<tbody id="gridItemList">
										<tr CGRow="true">
										  <td GH="40 STD_NUMBER" GCol="rownum">1</td>   
					                      <td GH="100 STD_DEPARTURE" GCol="text,DEPART" GF="S 10">출발권역</td> <!--출발권역-->
					                      <td GH="85 STD_CARDAT" GCol="text,CARDAT" GF="D 8">배송일자</td>  <!--배송일자-->
					                      <td GH="100 STD_CARNUM" GCol="input,CARNUM,SHCARMA2" GF="S 20">차량번호</td>  <!--차량번호-->
					                      <td GH="50 STD_SHIPSQ" GCol="input,SHIPSQ"  GF="S 20" style="text-align:right;">배송차수</td> <!--배송차수-->
					                      <td GH="100 STD_CARNAME" GCol="text,DESC01" GF="S 20">차량명</td>  <!--차량명-->
					                      <td GH="50 STD_PGRC03" GCol="text,PGRC03" GF="S 10">주문구분</td> <!--주문구분-->
					                      <td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td> <!--화주-->
					                      <td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td> <!--거점-->
					                      <td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td> <!--출고문서번호-->
					                      <td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td> <!--S/O 번호-->
					                      <td GH="50 STD_DPTNKYCD" GCol="text,DPTNKY" GF="S 20">매출처코드</td>  <!--매출처코드-->
					                      <td GH="50 STD_PTNRODNM" GCol="text,NAME01" GF="S 180">매출처명</td>  <!--매출처명-->
					                      <td GH="50 STD_PTRCVRCD" GCol="text,PTRCVR" GF="S 20">납품처코드</td>  <!--납품처코드-->
					                      <td GH="50 STD_SHIPTONM" GCol="text,PTRCVRNM" GF="S 180">납품처명</td>  <!--납품처명-->
					                      <td GH="50 STD_ARRIVA" GCol="text,ARRIVA" GF="S 10">도착권역</td> <!--도착권역-->
					                      <td GH="50 STD_SKUCNT" GCol="text,SKUCNT" GF="N 3,0">품목수</td> <!--품목수-->
					                      <td GH="50 STD_USRID1" GCol="text,USRID1" GF="S 180">배송지우편번호</td> <!--배송지우편번호-->
					                      <td GH="50 STD_UNAME1" GCol="text,UNAME1" GF="S 180">배송지주소</td> <!--배송지주소-->
					                      <td GH="50 STD_DEPTID1" GCol="text,DEPTID1" GF="S 180">배송고객명</td> <!--배송고객명-->
					                      <td GH="50 STD_DNAME1" GCol="text,DNAME1" GF="S 180">배송지전화번호</td> <!--배송지전화번호-->
					                      <td GH="50 STD_USRID2" GCol="text,USRID2" GF="S 180">업무담당자</td> <!--업무담당자-->
					                      <td GH="50 STD_GRSWGT" GCol="text,GRSWGT" GF="N 20,0">포장중량</td> <!--포장중량-->
					                      <td GH="72 STD_PLTQTY" GCol="text,PLTQTY" GF="N 20,2">팔레트수량</td>  <!--팔레트수량-->
					                      <td GH="50 STD_BOXQTY" GCol="text,BOXQTY" GF="N 20,1">박스수량</td> <!--박스수량-->
											<td GH="200 STD_ASKU05"   GCol="select,ASKU05">
												<select commonCombo="ASKU05"><option></option></select>
											</td><!--상온구분-->
					                      <td GH="65 STD_D1T" GCol="text,D1T" GF="N 30,2">적재율(1.5T)</td>  <!--적재율(1.5T)-->
					                      <td GH="65 STD_D25T" GCol="text,D25T" GF="N 30,2">적재율(2.5T)</td>  <!--적재율(2.5T)-->
					                      <td GH="65 STD_D35T" GCol="text,D35T" GF="N 30,2">적재율(3.5T)</td>  <!--적재율(3.5T)-->
					                      <td GH="65 STD_D5T" GCol="text,D5T" GF="N 30,2">적재율(5T)</td>  <!--적재율(5T)-->
					                      <td GH="65 STD_D8T" GCol="text,D8T" GF="N 30,2">적재율(8T)</td>  <!--적재율(8T)-->
					                      <td GH="65 STD_D11T" GCol="text,D11T" GF="N 30,2">적재율(11T)</td> <!--적재율(11T)-->
					                      <td GH="65 STD_D15T" GCol="text,D15T" GF="N 30,2">적재율(15T)</td> <!--적재율(15T)-->
					                      <td GH="50 STD_PTNG07B" GCol="text,PTNG07" GF="S 20">최대진입가능차량</td>  <!--최대진입가능차량-->
					                      <td GH="50 STD_DOCTXT" GCol="text,DOCTXT" GF="S 100">비고</td>  <!--비고-->
					                      <td GH="50 STD_FORKYN" GCol="text,FORKYN" GF="S 100">지게차사용여부</td> <!--지게차사용여부-->
			    						  <td GH="50 STD_SHPMTY" GCol="text,SHPMTY" GF="S 4">출고유형</td>	<!--출고유형-->
			    						  <td GH="80 STD_SHPMTYNM" GCol="text,SHPMTYNM" GF="S 20">문서타입명</td>	<!--문서타입명-->
					                      
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
<!-- 							<button type='button' GBtn="excelUpload"></button> -->
							<span class='txt_total' >총 건수 : <span GInfoArea='true'>4</span></span>
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