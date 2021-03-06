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
var rangeparam,cmd = "",afsaveSearch = false;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "SajoInbound",
			command : "RETURN",
			menuId : "GR41"

	    });

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
		
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			cmd = "";
			if($('#RCPTTY').val() != '133'){
				cmd = "GR40_NOT133";
			}else if($('#RCPTTY').val() == '133'){
				cmd = "GR40_133";
			}
			afsaveSearch = false;
			rangeparam = inputList.setRangeDataParam("searchArea");
			rangeparam.put("PROGID", configData.MENU_ID);
			gridList.gridList({
		    	id : "gridHeadList",
		    	command : cmd,
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
		    	command : cmd +"_ITEM",
		    	param : rangeparam
		    });
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}else if(gridId == "gridHeadList" && dataCount > 0){
			if(afsaveSearch){
				gridList.setReadOnly(gridId, true);
			}else{
				gridList.setReadOnly(gridId, false);
			}
		}else if(gridId == "gridItemList" && dataCount > 0){
			if(afsaveSearch){
				gridList.setReadOnly(gridId, true);
			}else{
				gridList.setReadOnly(gridId, false);
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
			param.put("DOCCAT", "100");
			param.put("DOCUTY", "132");
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
			
			if(headlist.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			//아이템 템프 가져오기
	        var tempItem = gridList.getSelectTempData("gridHeadList");
			
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
			param.put("itemquery",cmd +"_ITEM");
			
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
				afsaveSearch = true;
				var param = inputList.setRangeDataParam("searchArea");
					param.put("RECVKY",json.data["RECVKY"]);
				gridList.gridList({
			    	id : "gridHeadList",
			    	param : param
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
	 		sajoUtil.openSaveVariantPop("searchArea", "GR41");
 		}else if(btnName == "Getvariant"){
 			sajoUtil.openGetVariantPop("searchArea", "GR41");
		}else if(btnName == "Reprint"){
			print();
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
			
			var param = new DataMap();
			param.put("list",head);
			
			var json = netUtil.sendData({
				url : "/GoodReceipt/json/printGR42.data",
				param : param,
			});
			
			var ownrky = head[0].get("OWNRKY");
			
			var where = " AND IF.SVBELN IN (";
			
			for(var i =0;i < head.length ; i++){
				where += "'" + head[i].get("KEY") + "'";
				if(i+1 < head.length){
					where += ",";
				}
			}
			
			where += ")";
			if ( json && json.data ){
				var url,width,height;
				if(ownrky == '2100' || ownrky == '2500'){
					url = "/ezgen/return_shpdri_list.ezg";
					width = 800;
					height = 700;
				}else {
					url = "/ezgen/return_shpdri_list_dr.ezg";
					width = 625;
					height = 840;
				}
				
				var langKy = "KO";
				var map = new DataMap();
					map.put("i_option",$('#OPTION').val());
				WriteEZgenElement(url , where , "" , langKy, map , width , height );
			}
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if(searchCode == "SHLOCMA" ){
            param.put("WAREKY",$("#WAREKY").val());
            
            var rangeArr = new Array();
    		//배열내 들어갈 데이터 맵 선언
    		
    		var rangeDataMap = new DataMap();
    			rangeDataMap.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    			rangeDataMap.put(configData.INPUT_RANGE_SINGLE_DATA, "SYS");
    		
    		var rangeDataMap2 = new DataMap();
    			rangeDataMap2.put(configData.INPUT_RANGE_OPERATOR,"!="); // =  != > < 표시
    			rangeDataMap2.put(configData.INPUT_RANGE_SINGLE_DATA, "SHP");
    			configData.INPUT_RANGE_SINGLE_DATA

    		rangeArr.push(rangeDataMap);		
    		rangeArr.push(rangeDataMap2);
    		
    		param.put("AREAKY", returnSingleRangeDataArr(rangeArr));
        }else if(searchCode == "SHBZPTN"){
        	param.put("PTNRTY","0007");
        }else if(searchCode == "SHLOTA03CM"){
            param.put("OWNRKY",$('#OWNRKY').val());
            param.put("PTNRTY","0001");
            
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
					<input type="button" CB="Save SAVE BTN_SAVE" />
					<input type="button" CB="Reprint PRINT_OUT BTN_REPRINT" />
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
					<dl>  <!--문서번호-->  
						<dt CL="STD_RECRCKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.RECRKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서일자-->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="S.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOCAKY" UIInput="SR,SHLOCMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--팔렛트ID-->  
						<dt CL="STD_TRNUID"></dt> 
						<dd> 
							<input type="text" class="input" name="S.TRNUI" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKU_INFO"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="S.DESC01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--업체코드-->  
						<dt CL="STD_DPTNKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.DPTNKY" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--업체명-->  
						<dt CL="STD_DPTNKYNM"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ.NAME01" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--상세사유-->  
						<dt CL="STD_RCPRSN"></dt> 
						<dd> 
							<input type="text" class="input" name="S.RCPRSN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--유통기한-->  
						<dt CL="STD_LOTA13"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA13" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>  
					
					<dl>  <!--입고일자 -->  
						<dt CL="STD_LOTA12"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA12" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl>  
					
					<dl>  <!--벤더-->  
						<dt CL="STD_LOTA03"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA03" UIInput="SR,SHLOTA03CM"/> 
						</dd> 
					</dl>  
					
					<dl>  <!--포장구분-->  
						<dt CL="STD_LOTA05"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA05" UIInput="SR,SHLOTA05"/> 
						</dd> 
					</dl> 
					
					<dl>  <!--재고유형-->  
						<dt CL="STD_LOTA06"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOTA06" UIInput="SR,SHLOTA06"/> 
						</dd> 
					</dl> 
				</div>
				<div class="btn_tab">
					<input type="button" class="btn_more" value="more" onclick="searchMore()"/>
				</div>
			</div>
		</div>
        <div class="search_next_wrap">
			<div class="content_layout tabs">
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
										<td GH="80 STD_RECRKY" GCol="text,RECRKY" GF="S 10">문서번호</td>	<!--문서번호-->
			    						<td GH="50 STD_RECRIT" GCol="text,RECRIT" GF="S 6">문서Item</td>	<!--문서Item-->
			    						<td GH="100 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="100 STD_RCPTTY" GCol="text,RCPTTY" GF="S 10">입고유형</td>	<!--입고유형-->
			    						<td GH="100 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="100 STD_CONDAT" GCol="text,DOCCAT" GF="S 4">확정일자</td>	<!--확정일자-->
			    						<td GH="100 STD_DPTNKY" GCol="input,DPTNKY" GF="S 10">업체코드</td>	<!--업체코드-->
			    						<td GH="100 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="50 STD_SKUKEY" GCol="input,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="50 STD_LOCAKY" GCol="input,LOCAKY" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="80 STD_TRNUID" GCol="input,TRNUID" GF="S 30">팔렛트ID</td>	<!--팔렛트ID-->
			    						<td GH="50 STD_UOMKEY" GCol="text,UOMKEY" GF="S 10">단위</td>	<!--단위-->
			    						<td GH="80 STD_RSNCOD" GCol="input,RSNCOD" GF="S 4">사유코드</td>	<!--사유코드-->
			    						<td GH="80 STD_LOTA03" GCol="input,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="50 STD_LOTA05" GCol="input,LOTA05" GF="S 20">포장구분</td>	<!--포장구분-->
			    						<td GH="50 STD_LOTA06" GCol="input,LOTA06" GF="S 20">재고유형</td>	<!--재고유형-->
			    						<td GH="50 STD_LOTA11" GCol="input,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
			    						<td GH="50 STD_LOTA12" GCol="input,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="60 STD_LOTA13" GCol="input,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="50 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="50 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_ASKU02" GCol="text,ASKU02" GF="S 20">세트여부</td>	<!--세트여부-->
			    						<td GH="80 STD_ASKU03" GCol="text,ASKU03" GF="S 20">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 20">제품구분</td>	<!--제품구분-->
			    						<td GH="80 STD_ASKU05" GCol="text,ASKU05" GF="S 20">상온구분</td>	<!--상온구분-->
			    						<td GH="80 STD_EANCOD" GCol="text,EANCOD" GF="S 18">BARCODE(88코드)</td>	<!--BARCODE(88코드)-->
			    						<td GH="80 STD_GTINCD" GCol="text,GTINCD" GF="S 18">BOX BARCODE</td>	<!--BOX BARCODE-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 20">대분류</td>	<!--대분류-->
			    						<td GH="80 STD_SKUG02" GCol="text,SKUG02" GF="S 20">중분류</td>	<!--중분류-->
			    						<td GH="80 STD_SKUG03" GCol="text,SKUG03" GF="S 20">소분류</td>	<!--소분류-->
			    						<td GH="80 STD_SKUG04" GCol="text,SKUG04" GF="S 20">세분류</td>	<!--세분류-->
			    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 50">제품용도</td>	<!--제품용도-->
			    						<td GH="80 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0">포장중량</td>	<!--포장중량-->
			    						<td GH="80 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0">순중량</td>	<!--순중량-->
			    						<td GH="80 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="80 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0">포장가로</td>	<!--포장가로-->
			    						<td GH="80 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0">포장세로</td>	<!--포장세로-->
			    						<td GH="80 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0">포장높이</td>	<!--포장높이-->
			    						<td GH="80 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0">CBM</td>	<!--CBM-->
			    						<td GH="80 STD_CAPACT" GCol="text,CAPACT" GF="N 17,0">CAPA</td>	<!--CAPA-->
			    						<td GH="120 STD_RCPRSN" GCol="input,RCPRSN" GF="S 255">상세사유</td>	<!--상세사유-->
			    						<td GH="50 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="50 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="50 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="50 STD_CUSRNM" GCol="text,CUSRNM" GF="S 50">생성자명</td>	<!--생성자명-->
			    						<td GH="50 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
			    						<td GH="50 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
			    						<td GH="50 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
			    						<td GH="50 STD_LUSRNM" GCol="text,LUSRNM" GF="S 50">수정자명</td>	<!--수정자명-->
			    						<td GH="80 GR41_INPLANQTY" GCol="input,QTYASN" GF="N 17,0"></td>	<!---->
			    						<td GH="80 GR41_QTYRCV" GCol="input,QTYRCV" GF="N 17,0">물류반품입고수량</td>	<!--물류반품입고수량-->
			    						<td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_DPTNKYNM" GCol="text,DPTNKYNM" GF="S 100">업체명</td>	<!--업체명-->
			    						<td GH="80 STD_LOTA03NM" GCol="text,LOTA03" GF="S 20">벤더명</td>	<!--벤더명-->
			    						<td GH="80 STD_OUTDMT" GCol="text,OUTDMT" GF="N 20,0">유통기한(일수)</td>	<!--유통기한(일수)-->
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
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>