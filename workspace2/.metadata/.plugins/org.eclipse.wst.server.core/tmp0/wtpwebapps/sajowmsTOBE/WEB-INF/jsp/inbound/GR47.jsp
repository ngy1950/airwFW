<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grid default</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">
var ireadonly = ["rowCheck" , "TRNUID" , "LOCAKY" , "RSNCOD" , "LOTA05" , "LOTA06" , "LOTA13" , "LOTA11" , "QTYRCV" , "BOXQTY" , "REMQTY" ]
var hreadonly = ["rowCheck" , "DOCDAT" ,"DOCTXT" ] //, "SKUG05" ];
var afsaveSearch = false,afsave = false , rangeparam;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "SajoInbound",
			command : "GR40_NOT133",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "SVBELN",
		    colorType : true,
			menuId : "GR47"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "SajoInbound",
			command : "GR40_NOT133_ITEM",
			tempHead : "gridHeadList",
			useTemp : true,
			tempKey : "SVBELN",
			menuId : "GR47"
	    });
		
		uiList.setActive("Disposal", false);
		
		gridList.setReadOnly("gridHeadList", true, ["SKUG05"]);
		gridList.setReadOnly("gridHeadList", true , hreadonly);
		gridList.setReadOnly("gridItemList", true , ireadonly);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			uiList.setActive("Disposal", false);
			afsaveSearch = false;
			rangeparam = inputList.setRangeDataParam("searchArea");
			rangeparam.put("PROGID", configData.MENU_ID);
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : rangeparam
		    });
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var param = gridList.getRowData(gridId, rowNum);
			rangeparam.putAll(param);
			gridList.gridList({
		    	id : "gridItemList",
		    	param : rangeparam
		    });
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}else if(gridId == "gridHeadList" && dataCount > 0){
			gridList.setReadOnly("gridHeadList", true, ["SKUG05"]);
			if(afsaveSearch){
				gridList.setReadOnly(gridId, true , hreadonly);
				if(!afsave){
					gridList.setReadOnly(gridId, false, ["rowCheck"]);
				}
			}else{
				gridList.setReadOnly(gridId, false , hreadonly);
			}
		}else if(gridId == "gridItemList" && dataCount > 0){
			if(afsaveSearch){
				gridList.setReadOnly(gridId, true , ireadonly);
				if(!afsave){
					gridList.setReadOnly(gridId, false, ["rowCheck"]);
				}
			}else{
				gridList.setReadOnly(gridId, false , ireadonly);
			}	
		}
		
	}
	
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
		if(gridId == "gridHeadList"){
			var statdo = gridList.getColData(gridId, rowNum , "STATDO");
			if(statdo != "NEW"){
				gridList.setRowReadOnly(gridId, rowNum , true);
				return true;
			}
			
		}else if(gridId == "gridItemList"){
			var statit = gridList.getColData(gridId, rowNum, "STATIT");
			if(statit == "ARV"){
				gridList.setRowReadOnly(gridId, rowNum, true);
				return true;
			}
		}
		return false;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCUTY_COMCOMBO"){
			param.put("DOCUTY", "136");
			param.put("DOCCAT", "100");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			}else if(name == "PRINTCHK"){
				param.put("CMCDKY", "POCLOS");	
			}else if(name == "OPTION"){
				param.put("CMCDKY", "OPTION");	
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
			return param;
		}else if( comboAtt == "SajoCommon,RSNCOD_COMCOMBO" ){
			param.put("OWNRKY","<%=ownrky%>");
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "131");
		
			return param;
		}
		return param;
	}
	
	function saveData(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var headlist = gridList.getSelectData("gridHeadList", true);
			var list = gridList.getSelectData("gridItemList", true);
			
			//아이템 템프 가져오기
	        var tempItem = gridList.getSelectTempData("gridHeadList");
			
			if(headlist.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			for(var i=0;i<headlist.length;i++){
				var head = headlist[i];
				var docdat = head.get("DOCDAT");
				var yy = docdat.substr(0,4);
				var mm = docdat.substr(4,2);
			    var dd = docdat.substr(6,2);
			    var sysdate = new Date(); 
			 	var date = new Date(Number(yy), Number(mm)-1, Number(dd));
			    if(Math.abs((date-sysdate)/1000/60/60/24) > 10){
					alert("확정일자는 ±10일로 지정하셔야 합니다.") ;
					gridList.setRowFocus("gridHeadList", i, true);
					return;
				}	
			}
			
			for(var i=0; i< list.length; i++){
				var row = list[i];
				var qtyrcv = row.get("QTYRCV");
				var lota13 = row.get("LOTA13");
				
				if(qtyrcv != 0 ){
					if(lota13 == ""){
						alert(getMessage("VALID","M0324"));
						return;
					}
				}
			}
			
			var keys = Object.keys(tempItem.map);
			
			for(var i=0; i<keys.length; i++){
				var templist = tempItem.get(keys[i]);
				
				//headlist 는 저장시 넘길 헤더리스트 입니다. 각자에 맞게 확인 
				//헤더에 체크되지 않은 템프데이터 를 거르는 방식 입니다.
				var head = headlist.filter(function (e) {
				    return e.get("KEY") == keys[i];
				});
				
				if(head.length == 0){
					continue;
				}  
				
				for(var j=0; j<templist.length; j++){
					var row = templist[j];
					var qtyrcv = row.get("QTYRCV");
					var lota13 = row.get("LOTA13");
					
					if(qtyrcv != 0 ){
						if(lota13 == ""){
							commonUtil.msgBox("VALID_M0324");
							return;
						}
					}
				}
			}
			
	
			var param = new DataMap();
			param.put("headlist",headlist);
			param.put("list",list);
			param.put("tempItem",tempItem);
			param.put("itemquery","GR40_NOT133_ITEM");
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/inbound/json/saveReceive.data",
				param : param,
				successFunction : "successSaveCallBack"
			});
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] != "0"){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				uiList.setActive("Disposal", true);
				afsaveSearch = true;
				rangeparam.put("SAVEKEY",json.data["SAVEKEY"]);
				rangeparam.put("PRINTCHK","ALL");
				gridList.gridList({
			    	id : "gridHeadList",
			    	param : rangeparam
			    });
				
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
	 		sajoUtil.openSaveVariantPop("searchArea", "GR47");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "GR47");
		}else if(btnName == "Reprint"){
			print();
		}else if(btnName == "Callback"){
			callback();
		}else if(btnName == "Disposal"){
			disposal();
		}
	}
	
	var colchangeArray = ["QTYRCV" , "BOXQTY" , "REMQTY"];
	
	//그리드 컬럼 변경 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		if(gridId == "gridItemList"){
			if(colchangeArray.indexOf(colName) != -1){
				var qtyrcv = 0;
				var boxqty = 0;
				var remqty = 0;
				var pltqty = 0;
				var grswgt = 0;
				var qtyasn = Number(gridList.getColData(gridId, rowNum, "QTYASN"));
				var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
				var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
				var pltqtycal = Number(gridList.getColData(gridId, rowNum, "PLTQTYCAL"));
				var grswgtcnt = Number(gridList.getColData(gridId, rowNum, "GRSWGTCNT"));
				var asku02 = gridList.getColData(gridId, rowNum, "ASKU02");
				
				var remqtyChk = 0;
								
				if( colName == "QTYRCV" ) {
				    
					qtyrcv = colValue;
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
					remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
					boxqty = parseInt(qtyrcv/bxiqty);
					remqty = qtyrcv%bxiqty;
					
					if(asku02 == "Y"){
						if(remqty>0){
							gridList.setColValue(gridId, rowNum, "PBOXQTY", boxqty + 1 );
						}else{	
							gridList.setColValue(gridId, rowNum, "PBOXQTY", boxqty  );
						}
					}
					
					pltqty = parseInt(qtyrcv/pltqtycal);
					grswgt = qtyrcv * grswgtcnt;
					
					
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty  );
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty  );
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty  );
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt  );
				  	
				}
				if( colName == "BOXQTY" ){ 
					boxqty = colValue;
					remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
					qtyrcv = bxiqty * boxqty + remqty;
					pltqty = parseInt(qtyrcv/pltqtycal);
					grswgt = qtyrcv * grswgtcnt;
					
					if(asku02 == "Y"){
						if(remqty>0){
							gridList.setColValue(gridId, rowNum, "PBOXQTY", boxqty + 1 );
						}else{	
							gridList.setColValue(gridId, rowNum, "PBOXQTY", boxqty  );
						}
					}
					
					gridList.setColValue(gridId, rowNum, "QTYRCV", qtyrcv  );
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty  );
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt  );
					
				}
				if( colName == "REMQTY" ){
					qtyrcv = Number(gridList.getColData(gridId, rowNum, "QTYRCV"));
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
					remqty = colValue;	
					 	
					 	
					remqtyChk = remqty%bxiqty;
					boxqty = boxqty + parseInt(remqty/bxiqty);
					qtyrcv = boxqty * bxiqty + remqtyChk;
					pltqty = parseInt(qtyrcv/pltqtycal);
					grswgt = qtyrcv * grswgtcnt;
					
					if(asku02 == "Y"){
						if(remqty>0){
							gridList.setColValue(gridId, rowNum, "PBOXQTY", boxqty + 1 );
						}else{	
							gridList.setColValue(gridId, rowNum, "PBOXQTY", boxqty  );
						}
					}
					
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty  );
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty  );
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty  );
					gridList.setColValue(gridId, rowNum, "QTYRCV", qtyrcv  );
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt  );
					
				}
				
				if( qtyrcv > qtyasn ) {
					commonUtil.msgBox("VALID_GR000001");
			    	
			    	gridList.setColValue(gridId, rowNum, "BOXQTY", 0  );
					gridList.setColValue(gridId, rowNum, "REMQTY", 0  );
					gridList.setColValue(gridId, rowNum, "PLTQTY", 0  );
					gridList.setColValue(gridId, rowNum, "QTYRCV", 0  );
					gridList.setColValue(gridId, rowNum, "GRSWGT", 0  );
			    	
			    	return false ;
			    }
			}else if( colName == "LOTA11" ){
				var outdmt = gridList.getColData(gridId, rowNum, "OUTDMT");
				var lota11 = gridList.getColData(gridId, rowNum, "LOTA11");
				
				var lota13 = dateParser(lota11 , 'S', 0 , 0 , Number(outdmt)) ;
				
				gridList.setColValue(gridId, rowNum,  "LOTA13", lota13);
				
				var year11 = colValue.substr(0,4);
				var month11 = Number(colValue.substr(4,2)) - 1;
				var day11 = colValue.substr(6,2);
				
				var year13 = lota13.substr(0,4);
				var month13 = Number(lota13.substr(4,2)) - 1;
				var day13 = lota13.substr(6,2);
				
				var d_today = new Date();			
				var d_lota11 = new Date(year11, month11, day11);
				var d_lota13 = new Date(year13, month13, day13);
				
				var diff = d_today - d_lota11;
	    		var currDay = 24 * 60 * 60 * 1000;// 시 * 분 * 초 * 밀리세컨
				
				var dtremdat = outdmt - parseInt(diff/currDay);
				var dtremrat = dtremdat / outdmt * 100;
				
				gridList.setColValue(gridId, rowNum,  "DTREMDAT", dtremdat);
				gridList.setColValue(gridId, rowNum, "DTREMRAT", dtremrat);
	    		
			} else if( colName == "LOTA13" ){
				var outdmt = gridList.getColData(gridId, rowNum, "OUTDMT");
				var lota13 = gridList.getColData(gridId, rowNum, "LOTA13");
				var lota11 = dateParser(lota13 , 'S', 0 , 0 , -Number(outdmt));
				
				gridList.setColValue(gridId, rowNum,  "LOTA11", lota11);
				
				var year11 = gridList.getColData(gridId, rowNum, "LOTA11").substr(0,4);
				var month11 = Number(gridList.getColData(gridId, rowNum, "LOTA11").substr(4,2)) - 1;
				var day11 = gridList.getColData(gridId, rowNum, "LOTA11").substr(6,2);
				
				var year13 = lota13.substr(0,4);
				var month13 = Number(lota13.substr(4,2)) - 1;
				var day13 = lota13.substr(6,2);
				
				var d_today = new Date();			
				var d_lota11 = new Date(year11, month11, day11);
				var d_lota13 = new Date(year13, month13, day13);
				
				var diff = d_today - d_lota11;
	    		var currDay = 24 * 60 * 60 * 1000;// 시 * 분 * 초 * 밀리세컨
				
				var dtremdat = outdmt - parseInt(diff/currDay);
				var dtremrat = dtremdat / outdmt * 100;
				
				gridList.setColValue(gridId, rowNum,  "DTREMDAT", dtremdat);
				gridList.setColValue(gridId, rowNum, "DTREMRAT", dtremrat);
			}
		}
	}
	
	function gridListRowTextColorChange(gridId, rowNum){
		if(gridId == "gridHeadList"){
			if(gridList.getColData(gridId,rowNum,"SKUG05") == "2"){
	            return "gridColorTextBlue";
	        }	
		}
	}
	
	function print(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var head = gridList.getSelectData("gridHeadList", true);
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var ownrky = head[0].get("OWNRKY");
			var where = " AND IF.SVBELN IN (";
			
			for(var i =0;i < head.length ; i++){
				where += "'" + head[i].get("KEY") + "'";
				if(i+1 < head.length){
					where += ",";
				}
				xstat = head[i].get("SHPOKYMV");
			}
			where += ")";
			
			var url,width,height;
			if(ownrky == '2100' || ownrky == '2500'){
				url = "/ezgen/return_shpdri_list.ezg";
				width = 840;
				height = 700;
			}else {
				url = "/ezgen/return_shpdri_list_dr.ezg";
				width = 625;
				height = 840;
			}
			
			var langKy = "KO";
			var map = new DataMap();
				map.put("i_option",$('#OPTION').val());
				map.put("i_ifflg",xstat);
			WriteEZgenElement(url , where , "" , langKy, map , width , height );
		}
	}
	
	var callbackList = new DataMap();
	function callback(){
		if(gridList.validationCheck("gridHeadList", "select")){
			var headlist = gridList.getSelectData("gridHeadList", true);
	
			callbackList.put("list",headlist);
			
			if(headlist.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			if(!commonUtil.msgConfirm("회수 지시를 하시겠습니까?")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/SajoInbound/json/saveCallback.data",
				param : callbackList,
				successFunction : "successCallBack"
			});
		}
	}
	
	function successCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] != "0"){
				commonUtil.msgBox("회수 지시에 성공 하였습니다.");
				
				netUtil.send({
					url : "/SajoInbound/json/dispalyRetrun.data",
					param : callbackList,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : "gridHeadList" //그리드ID
				});
				
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        var name = $inputObj.name;
        if(searchCode == "SHCMCDV" ){
            if(name == "IFWMS113.SKUG05"){
            	param.put("CMCDKY","ASKU05");
            }
        }else if(searchCode == "SHLOCMA"){
            param.put("WAREKY",$("#WAREKY").val());
        }
    	return param;
    }
	
	function disposal(){
		var headlist = gridList.getSelectData("gridHeadList", true);
		
		if(headlist.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		var param = new DataMap();
		param.put("headlist",headlist);
		
		if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
			return;
        }
		
		netUtil.send({
			url : "/SajoInbound/json/saveGR47disposal.data",
			param : param,
			successFunction : "successSaveCallBack2"
		});
	}
	
	function successSaveCallBack2(json, status){
		if(json && json.data){
			if(json.data["CNT"] != "0" || json.data["IP14CNT"] != "0"){
				if(json.data["CNT"] != "0"){
					commonUtil.msgBox("SYSTEM_SAVEOK");	
				}
				if(json.data["IP14CNT"] != "0"){
					commonUtil.msgBox(json.data["SAVEKEY"]);	
				}
				uiList.setActive("Disposal", false);
				uiList.setActive("Save", false);
				afsaveSearch = true;
				afsave = true;
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	
	function linkPopCloseEvent(data){  
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
					<input type="button" CB="Callback SAVE BTN_CALLBACK" />
					<input type="button" CB="Reprint PRINT_OUT BTN_REPRINT" />
					<input type="button" CB="Save SAVE BTN_SAVE" />
					<input type="button" CB="Disposal SAVE 기타출고" />
					
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
							<select name="WAREKY" id="WAREKY" class="input" ></select>
						</dd>
					</dl>
					
					<dl>  <!--입고유형-->  
						<dt CL="STD_RCPTTY"></dt> 
						<dd> 
							<select name="RCPTTY" id="RCPTTY" class="input" Combo="SajoCommon,DOCUTY_COMCOMBO"></select> 
						</dd> 
					</dl> 
					<dl>  <!--S/O 번호-->  
						<dt CL="STD_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고반품입고일자-->  
						<dt CL="IFT_OTRQDT2"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.SDATBG" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--요청사업장-->  
						<dt CL="STD_IFPGRC04"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DNAME1" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--요청사업장명-->  
						<dt CL="STD_IFPGRC04N"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.CUNAME" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.PTNRTO" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처명-->  
						<dt CL="IFT_PTNRTONM"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DPTNKYNM" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--매출처코드-->  
						<dt CL="IFT_PTNROD"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.PTNROD" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--매출처명-->  
						<dt CL="STD_PTNRODNM"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.PTNRODNM" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--고객명-->  
						<dt CL="STD_CUNAME"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.CUNAME" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--반품지 주소-->  
						<dt CL="STD_CUADDR"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.dname4" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.SKUKEY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--규격-->  
						<dt CL="STD_DESC02"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.DESC02" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품용도-->  
						<dt CL="STD_SKUG05"></dt> 
						<dd> 
							<input type="text" class="input" name="IFWMS113.SKUG05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--인쇄여부-->  
						<dt CL="STD_PRINTCHK"></dt> 
						<dd> 
							<select name="PRINTCHK" id="PRINTCHK" class="input" Combo="SajoCommon,CMCDV_COMBO"></select> 
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
					<li style="TOP: 5PX;VERTICAL-ALIGN: middle;"><span CL="STD_PRINTOPT1" style="PADDING-RIGHT: 15PX; VERTICAL-ALIGN: MIDDLE;">   </span>
					<select name="OPTION" id="OPTION"  class="input" Combo="SajoCommon,CMCDV_COMBO" ComboCodeView="false" ></select></li>
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
										<td GH="40" GCol="rowCheck"></td> 
										<td GH="120 STD_RECVKY" GCol="text,RECVKY" GF="S 10">입고문서번호</td>	<!--입고문서번호-->
			    						<td GH="120 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="120 STD_RCPTTY" GCol="text,RCPTTY" GF="S 10">입고유형</td>	<!--입고유형-->
			    						<td GH="120 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="120 STD_CONDAT" GCol="input,DOCDAT" GF="C">확정일자</td>	<!--확정일자-->
			    						<td GH="120 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="120 IFT_ORDDAT" GCol="text,ORDDAT" GF="D 8">출고일자</td>	<!--출고일자-->
			    						<td GH="120 IFT_PTNRTO" GCol="text,DPTNKY" GF="S 10">납품처코드</td>	<!--납품처코드-->
			    						<td GH="120 IFT_PTNRTONM" GCol="text,DPTNKYNM" GF="S 100">납품처명</td>	<!--납품처명-->
			    						<td GH="120 IFT_PTNROD" GCol="text,PTNROD" GF="S 10">매출처코드</td>	<!--매출처코드-->
			    						<td GH="120 IFT_PTNRODNM" GCol="text,PTNRODNM" GF="S 100">매출처명</td>	<!--매출처명-->
			    						<td GH="120 STD_SVBELN" GCol="text,SVBELN" GF="S 30">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="120 IFT_CTNAME" GCol="text,UNAME1" GF="S 20">거래처 담당자명</td>	<!--거래처 담당자명-->
			    						<td GH="120 IFT_WARESR" GCol="text,DNAME1" GF="S 20">요구사업장</td>	<!--요구사업장-->
			    						<td GH="120 IFT_CTTEL1" GCol="text,UNAME2" GF="S 20">거래처 담당자 전화번호</td>	<!--거래처 담당자 전화번호-->
			    						<td GH="120 IFT_SALENM" GCol="text,UNAME3" GF="S 20">영업사원명</td>	<!--영업사원명-->
			    						<td GH="120 IFT_SALTEL" GCol="text,UNAME4" GF="S 20">영업사원 전화번호</td>	<!--영업사원 전화번호-->
			    						<td GH="120 IFT_CUADDR" GCol="text,DNAME4" GF="S 20">배송지 주소</td>	<!--배송지 주소-->
			    						<td GH="120 STD_DOCTXT" GCol="input,DOCTXT" GF="S 200">비고</td>	<!--비고-->
			    						<td GH="120 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="120 STD_RCPTTYNM" GCol="text,RCPTTYNM" GF="S 100">입고유형명</td>	<!--입고유형명-->
			    						<td GH="120 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>	<!--문서유형명-->
			    						<td GH="120 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="120 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="120 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="120 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td>	<!--생성자명-->
			    						<td GH="120 STD_RCUNAME2" GCol="text,CUNAME" GF="S 100">요구사업장명</td>	<!--요구사업장명-->
			    						<td GH="120 STD_CUADDR" GCol="text,CUADDR" GF="S 100">반품지 주소</td>	<!--반품지 주소-->
			    						<td GH="120 STD_PRTYN" GCol="text,PRINTCHK" GF="S 100">인쇄여부</td>	<!--인쇄여부-->
			    						<td GH="120 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="120 STD_DPHONE" GCol="text,DPHONE" GF="S 17">기사연락처</td>	<!--기사연락처-->
			    						<td GH="120 STD_ERDAT" GCol="text,ERDAT" GF="D 17">지시일자</td>	<!--지시일자-->
			    						<td GH="120 STD_RECALLDAT" GCol="text,RECALLDAT" GF="D 17">회수일자</td>	<!--회수일자-->
			    						<td GH="120 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="130 STD_SKUG05" GCol="select,SKUG05">
								        	<select class="input" CommonCombo="SKUG05">
								        		<option value=""></option>
								        	</select>
								        </td><!--제품용도-->
			    						<td GH="120 STD_WMSCREDAT" GCol="text,WMSCREDAT" GF="S 100">WMS생성일자</td>	<!--WMS생성일자-->
			    						<td GH="120 STD_WMSCRETIM" GCol="text,WMSCRETIM" GF="S 100">WMS생성시간</td>	<!--WMS생성시간-->
			    						<td GH="250 배차메모" GCol="text,TEXT02" GF="S 200">배차메모</td>	<!--배차메모-->
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
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="40" GCol="rowCheck"></td>
			    						<td GH="120 STD_RECVIT" GCol="text,RECVIT" GF="S 6">입고문서아이템</td>	<!--입고문서아이템-->
			    						<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_LOCAKY" GCol="input,LOCAKY,SHLOCMA" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="120 STD_TRNUID" GCol="input,TRNUID" GF="S 30">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="120 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="120 STD_RECRSNCD"  GCol="select,RSNCOD"> <!--출고반품입고사유-->
											<select class="input" Combo="SajoCommon,RSNCOD_COMCOMBO">
												<option value=" "></option>
											</select>
										</td>
			    						<td GH="130 STD_LOTA05" GCol="select,LOTA05">
								        	<select class="input" CommonCombo="LOTA05"></select>
								        </td><!--포장구분-->
										<td GH="130 STD_LOTA06" GCol="select,LOTA06">
								        	<select class="input" CommonCombo="LOTA06"></select>
								        </td>	<!--재고유형-->
										<td GH="100 STD_LOTA13" GCol="input,LOTA13" GF="C" validate="required">유통기한</td>	<!--유통기한-->
										<td GH="100 STD_LOTA11" GCol="input,LOTA11" GF="C" validate="required">제조일자</td>	<!--제조일자-->
			    						<td GH="120 STD_REFDKY" GCol="text,REFDKY" GF="S 10">참조문서번호</td>	<!--참조문서번호-->
			    						<td GH="120 STD_REFDIT" GCol="text,REFDIT" GF="S 6">참조문서Item번호</td>	<!--참조문서Item번호-->
			    						<td GH="120 STD_REFCAT" GCol="text,REFCAT" GF="S 4">입출고 구분자</td>	<!--입출고 구분자-->
			    						<td GH="120 STD_REFDAT" GCol="text,REFDAT" GF="D 8">참조문서일자</td>	<!--참조문서일자-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="120 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="120 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="120 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="120 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="120 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="120 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="120 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="120 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="120 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="120 STD_SKUG05" GCol="text,SKUG05" GF="S 50">제품용도</td>	<!--제품용도-->
			    						<td GH="120 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0">포장중량</td>	<!--포장중량-->
			    						<td GH="120 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0">순중량</td>	<!--순중량-->
			    						<td GH="120 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="120 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0">포장가로</td>	<!--포장가로-->
			    						<td GH="120 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0">포장세로</td>	<!--포장세로-->
			    						<td GH="120 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0">포장높이</td>	<!--포장높이-->
			    						<td GH="120 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0">CBM</td>	<!--CBM-->
			    						<td GH="120 STD_SEBELN" GCol="text,SEBELN" GF="S 20">구매오더 No</td>	<!--구매오더 No-->
			    						<td GH="120 STD_SEBELP" GCol="text,SEBELP" GF="S 6">구매오더 Item</td>	<!--구매오더 Item-->
			    						<td GH="120 STD_QTYRCV" GCol="input,QTYRCV" GF="N 17,0">입고수량</td>	<!--입고수량-->
			    						<td GH="120 STD_ORDQTY" GCol="text,ORDQTY" GF="N 17,0">지시수량</td>	<!--지시수량-->
			    						<td GH="120 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="120 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="120 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="120 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="120 STD_PLIQTY" GCol="text,PLTQTYCAL" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="120 STD_OUTDMT" GCol="text,OUTDMT" GF="N 20,0">유통기한(일수)</td>	<!--유통기한(일수)-->							
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