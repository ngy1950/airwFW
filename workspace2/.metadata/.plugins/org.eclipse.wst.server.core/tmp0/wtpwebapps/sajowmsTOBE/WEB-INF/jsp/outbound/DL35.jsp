<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL35</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

	var GRPRL = '';
	var TOTALPICKING = 'N';
	var PROGID = 'DL35';
	var SHPOKYS = '';
	var TASKKY =  "";
	var cmpCnt = 0;

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "DL35_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItem01List",
			itemSearch : true,
		    menuId : "DL35"
			
	    });
		
		gridList.setGrid({
	    	id : "gridItem01List",
			module : "Outbound",
			command : "DL35_ITEM_01",
			pkcol : "OWNRKY,WAREKY,SHPOKY",
			emptyMsgType : false,
		    menuId : "DL35"
        });

		gridList.setGrid({
	    	id : "gridItem02List",
			module : "Outbound",
			command : "DL35_ITEM_02",
			pkcol : "OWNRKY,WAREKY,SHPOKY",
			emptyMsgType : false,
		    menuId : "DL35"
	    });
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val());
		});
		
		searchwareky($('#OWNRKY').val());

	 	$("#CARDAT").val(dateParser(null, "SD", 0, 0, 1));
	 	$("#CARDAT").trigger("chage");
		$('#taskConfirm').hide();


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
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");			
			var group = $('input[name="GROUP"]:checked').attr('id');
			param.put('GRPRL', group)
			if (TASKKY != "") {
				$('#BTN_SAVECRE').hide();
				$('#BTN_ALLOCATE').hide();
				$('#BTN_ALLOCATE_ALL').hide();
				$('#taskConfirm').show()
				$('#taskSave').hide();
				param.put('TASKKY',TASKKY);

				//헤더 조회 
 				netUtil.send({
 		    		module : "Outbound",
 					command : "DL35_HEAD2",
 					bindType : "grid",
 					sendType : "list",
 			    	param : param,
 					bindId : "gridHeadList" //그리드ID
 				});
				
				//아이템 TAB2 조회
				$("#atab2").trigger("click")
				gridList.gridList({
			    	id : "gridItem02List",
			    	param : param
			    });			
				
			} else {
				$('#BTN_SAVECRE').show();
				$('#BTN_ALLOCATE').show()
				$('#BTN_ALLOCATE_ALL').show();
				$('#taskConfirm').hide();

				var rangeInput = inputList.rangeMap.map["R.SHIPSQ"];
				//싱글 레인지
				if(rangeInput.singleData.length > 0){
					param.put("SHIPSQ",rangeInput.singleData[0].map.DATA);
				}
				

			      //아이템 조회
				netUtil.send({
					url : "/outbound/json/displayDL35.data",
				  	param : param,//gridList.gridList({
				  	sendType : "list",//    id : "gridHeadList",
				  	bindType : "grid",  //bindType grid 고정//    param : param
				  	bindId : "gridHeadList" //그리드ID//  });
				});
				
				//완료여부체크
				//var json = netUtil.sendData({
				//	module : "Outbound",
				//	command : "DL35_COMPLET_CHK",
				//	sendType : "list",
				//	param : param
				//}); 
                //
				////완료정보가있을경우  
				//if(json && json.data && json.data.length > 0 ){
				//	commonUtil.msgBox("* 재고보충 지시가  완료 되었습니다. *");
				//	gridList.resetGrid("gridHeadList");
				//	gridList.resetGrid("gridItem01List");
				//	gridList.resetGrid("gridItem02List");
				//	return;
				//}else{
				//	
				//	gridList.gridList({
				//    	id : "gridHeadList",
				//    	param : param
				//    });		
				//}
			}
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.put('PROGID',PROGID)			
//			param.put('TOTALPICKING',TOTALPICKING)
			param.putAll(rowData);
			if (TASKKY == ''){		
				gridList.gridList({
			    	id : "gridItem01List",
			    	param : param
			    });
				
				
			} else {
				TASKKY = '';
			}		
		}
	}

	
	//그리드 조회 후 
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId =="gridItem01List" && dataCount < 1){
			gridList.resetGrid("gridHeadList");
			commonUtil.msgBox("SYSTEM_DATAEMPTY");
		}else if(gridId =="gridItem02List" && dataCount > 0 & cmpCnt == 0){
			// 보충완료 하시겠습니까?
			if(commonUtil.msgConfirm("보충 완료 하시겠습니까?")){ 
				taskWork();
				
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
	
	
	function save(){		
        var head = gridList.getGridData("gridHeadList");
        var item = gridList.getGridData("gridItem01List");
        //아이템 템프 가져오기
          
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

       var param = new DataMap();
		param.put("head",head);
		param.put("item",item);

		netUtil.send({
			url : "/outbound/json/saveDL35.data",
			param : param,
			successFunction : "successSaveCallBackOrd"
		});
 	}
	
	function taskWork(){		
        var head = gridList.getGridData("gridHeadList");
        var item = gridList.getGridData("gridItem02List");
          
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

       var param = new DataMap();
		param.put("head",head);
		param.put("item",item);

		var rangeInput = inputList.rangeMap.map["R.SHIPSQ"];
		//싱글 레인지
		if(rangeInput.singleData.length > 0){
			param.put("SHIPSQ",rangeInput.singleData[0].map.DATA);
		}

		netUtil.send({
			url : "/outbound/json/confirmDL35.data",
			param : param,
			successFunction : "successSaveCallBackConf"
		});
 	}

	

	function print() {
		
		var count = 0;
 
		var head = gridList.getGridBox("gridHeadList").getDataAll(); 
		//체크가 없을 경우 
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		var wherestr = "";  
		
		for(var i =0;i < head.length ; i++){

			if(head[i].get("TASKKY") =="" || head[i].get("TASKKY") == " ") continue;
			
			if(wherestr == ""){
				wherestr = wherestr+" AND B.TASKKY IN (";
			}else{
				wherestr = wherestr+",";
			}
			
			wherestr += "'" + head[i].get("TASKKY") + "'";
			count++;
		}
		wherestr += ")";
		
		if(count < 1 ){
			commonUtil.msgBox("SYSTEM_NOTPR");
			return;
		}
		
		if(!commonUtil.msgConfirm("PRINT_DL35")){  
			return;
        }
		

		//이지젠 호출부(신버전)
		var langKy = "KO";
		var map = new DataMap();
		var width = 890;
		var height = 595;

		WriteEZgenElement("/ezgen/replenish_list_1H760.ezg" , wherestr , " " , langKy, map , width , height );
			
 	}
	

	function print2() {
		
		var count = 0;
 
		var head = gridList.getGridBox("gridHeadList").getDataAll(); 
		//체크가 없을 경우 
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		var wherestr = "";  
		
		for(var i =0;i < head.length ; i++){

			if(head[i].get("TASKKY") =="" || head[i].get("TASKKY") == " ") continue;
			
			if(wherestr == ""){
				wherestr = wherestr+" AND B.TASKKY IN (";
			}else{
				wherestr = wherestr+",";
			}
			
			wherestr += "'" + head[i].get("TASKKY") + "'";
			count++;
		}
		wherestr += ")";
		
		if(count < 1 ){
			commonUtil.msgBox("SYSTEM_NOTPR");
			return;
		}

		
		if(!commonUtil.msgConfirm("PRINT_DL35")){  
			return;
        }
		

		//검색조건 출력물에 반영
		var option = " ";
		
		//이지젠 호출부(신버전)
		var langKy = "KO";
		var map = new DataMap();
			map.put("i_option",option);
		var width = 890;
		var height = 595;

		WriteEZgenElement("/ezgen/replenish_list_1H700.ezg" , wherestr , " " , langKy, map , width , height );
			
 	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data != ""){

				commonUtil.msgBox("SYSTEM_SAVEOK");
				TASKKY = json.data;
				searchList();
				
			}else if(json.data == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}

	function successSaveCallBackOrd(json, status){
		if(json && json.data){
			if(json.data != ""){
				
				if(json.data == "E"){

					commonUtil.msgBox("* 보충할 작업리스트가 없습니다. *");
					return;
				}

				commonUtil.msgBox("SYSTEM_SAVEOK");
				TASKKY = json.data;
				searchList();

				
			}else if(json.data == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
			}
		}
	}
	

	function successSaveCallBackConf(json, status){
		if(json && json.data){
			if(json.data != ""){

				gridList.setColValue("gridHeadList", 0, "STATDO", "FPA");
				gridList.setColValue("gridHeadList", 0, "STATDONM", "보충완료");

		        var item = gridList.getGridData("gridItem02List");
				//아이템 수정
				for(var i=0; i < item.length; i++){
					gridList.setColValue("gridItem02List", i, "STATIT", "FPA");
					gridList.setColValue("gridItem02List", i, "STATITNM", "보충완료");
				}

			    //if (commonUtil.msgConfirm("* 재고보충 리스트가 있습니다. 출력 하시겠습니까? *") && cmpCnt == 0) {
			    //	cmpCnt +=1;
			    //	print(); 
				//}
			    print();
				
				//commonUtil.msgBox("SYSTEM_SAVEOK");
				//searchList();
				
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
			$('#taskSave').show();
			cmpCnt = 0;
			searchList();
		}else if(btnName == "Save"){			
			save();
		}else if(btnName == "TaskConfirm"){
			taskWork();
		}else if(btnName == "Reload"){
			reload();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL35");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL35");
		}else if(btnName == "Print"){
			print();
		}else if(btnName == "Print2"){
			print2();
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
					<input type="button" id="taskSave" CB="Save SAVE BTN_STKREP" />
					<input type="button" id="taskConfirm" CB="TaskConfirm SAVE BTN_CFMREP" />
					<input type="button" CB="Print PRINT_OUT BTN_REPPRINT_COS" /> <!-- (담당자)-->
					<input type="button" CB="Print2 PRINT_OUT BTN_REPPRINT_LOC" /> <!-- (로케이션)-->
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
						  <input type="text" class="input" id="CARDAT" name="CARDAT" UIFormat="C N"/> 
	                    </dd> 
	                  </dl> 
	                  <dl>  <!--배송차수-->  
			              <dt CL="STD_SHIPSQ"></dt> 
			              <dd> 
			                <input type="text" class="input" name="R.SHIPSQ" UIInput="SR" validate="required(STD_SHIPSQ)"/> 
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
			    						<td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="S 100">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 100">거점명</td>	<!--거점명-->
			    						<td GH="80 STD_TASOTY" GCol="text,TASOTY" GF="N 4,0">작업타입</td>	<!--작업타입-->
			    						<td GH="80 STD_TASOTYNM" GCol="text,TASOTYNM" GF="S 100">작업타입명</td>	<!--작업타입명-->
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0">문서유형</td>	<!--문서유형-->
			    						<td GH="200 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100">문서유형명</td>	<!--문서유형명-->
			    						<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 100">문서상태명</td>	<!--문서상태명-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td>	<!--생성자명-->
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
					<li onclick=""><a href="#tab2-1" id="atab1"><span>상세내역</span></a></li>
					<li onclick=""><a href="#tab2-2" id="atab2"><span>재고보충리스트</span></a></li>
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
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 100">화주</td>	<!--화주-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 100">거점</td>	<!--거점-->
			    						<td GH="80 STD_SKUKEY" GCol="text,SKUKEY" GF="S 100">제품코드</td>	<!--제품코드-->
			    						<td GH="80 STD_DESC01" GCol="text,DESC01" GF="S 100">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_STATIT" GCol="text,STATITSO" GF="S 100">상태</td>	<!--상태-->
			    						<td GH="80 STD_UOMKEY" GCol="text,UOMKEY" GF="S 100">단위</td>	<!--단위-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 100">포장단위</td>	<!--포장단위-->
			    						<td GH="80 STD_ASKU02" GCol="text,ASKU02" GF="S 100">세트여부</td>	<!--세트여부-->
			    						<td GH="80 STD_ASKU03" GCol="text,ASKU03" GF="S 100">피킹그룹</td>	<!--피킹그룹-->
			    						<td GH="80 STD_ASKU04" GCol="text,ASKU04" GF="S 100">제품구분</td>	<!--제품구분-->
			    						<td GH="80 STD_ASKU05" GCol="text,ASKU05" GF="S 100">상온구분</td>	<!--상온구분-->
			    						<td GH="80 STD_EANCOD" GCol="text,EANCOD" GF="S 100">BARCODE(88코드)</td>	<!--BARCODE(88코드)-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 100">대분류</td>	<!--대분류-->
			    						<td GH="80 STD_SKUG02" GCol="text,SKUG02" GF="S 100">중분류</td>	<!--중분류-->
			    						<td GH="80 STD_SKUG03" GCol="text,SKUG03" GF="S 100">소분류</td>	<!--소분류-->
			    						<td GH="80 STD_SKUG04" GCol="text,SKUG04" GF="S 100">세분류</td>	<!--세분류-->
			    						<td GH="80 STD_SKUG05" GCol="text,SKUG05" GF="S 100">제품용도</td>	<!--제품용도-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 100">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SPOSNR" GCol="text,SPOSNR" GF="S 100">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						<td GH="80 STD_DOCUTY" GCol="text,DOCUTY" GF="S 100">출고유형</td>	<!--출고유형-->
			    						<td GH="80 STD_DOCTXT" GCol="text,DOCTXT" GF="S 100">비고</td>	<!--비고-->
			    					<!-- 	<td GH="80 STD_PGRC04" GCol="text,PGRC04" GF="S 100">주문부서</td>	주문부서
			    						<td GH="80 STD_PGRC05" GCol="text,PGRC05" GF="S 100">상단시스템운송결재방식</td>	상단시스템운송결재방식 -->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 100">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="80 STD_SHPOIT" GCol="text,SHPOIT" GF="S 100">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="80 STD_SHPOIR" GCol="text,SHPOIR" GF="S 100">출하배차번호</td>	<!--출하배차번호-->
			    						<td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="S 100">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="80 IFT_DEPART" GCol="text,DEPART" GF="S 100">출발지권역코드</td>	<!--출발지권역코드-->
			    						<td GH="80 STD_ARRIVA" GCol="text,ARRIVA" GF="S 100">도착권역</td>	<!--도착권역-->
			    						<td GH="80 STD_CARNUM" GCol="text,CARNUM" GF="S 100">차량번호</td>	<!--차량번호-->
			    						<td GH="80 STD_DRIVER" GCol="text,DRIVER" GF="S 100">기사명</td>	<!--기사명-->
			    						<td GH="80 STD_QTSHPO" GCol="text,QTSHPO" GF="N 20,0">지시수량</td>	<!--지시수량-->
			    						<td GH="80 STD_QTALOC" GCol="text,QTALOC" GF="N 20,0">할당수량</td>	<!--할당수량-->
			    						<td GH="80 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 20,0">배송차수</td>	<!--배송차수-->
			    						<td GH="80 STD_SORTSQ" GCol="text,SORTSQ" GF="N 20,0">배송순서</td>	<!--배송순서-->
			    						<td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="D 10">배송일자</td>	<!--배송일자-->
			    						<td GH="80 STD_RECAYN" GCol="text,RECAYN" GF="S 10">재배차 여부</td>	<!--재배차 여부-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<button type='button' GBtn="add" id="itemGridAdd"></button>
						<button type='button' GBtn="delete" id="itemGridDelete"></button>
						<button type='button' GBtn="total"></button>
						<button type='button' GBtn="layout"></button>
						<button type='button' GBtn="excel"></button>
						<button type='button' GBtn="saveLayout"></button>
						<button type='button' GBtn="getLayout"></button>
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
			    						<td GH="50 STD_AREAKY" GCol="text,AREAKY" GF="S 10">동</td>	<!--동-->
			    						<td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="S 100">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="80 STD_TASKIT" GCol="text,TASKIT" GF="N 6,0">작업오더아이템</td>	<!--작업오더아이템-->
			    						<td GH="80 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="80 STD_STATITNM" GCol="text,STATITNM" GF="S 20">상태명</td>	<!--상태명-->
			    						<td GH="88 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td>	<!--작업수량-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="80 STD_LOCATG" GCol="text,LOCATG" GF="S 20">To 로케이션</td>	<!--To 로케이션-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="80 STD_WORKNM" GCol="text,WORKNM" GF="S 60">작업자명</td>	<!--작업자명-->
			    						<td GH="50 STD_LOTA03" GCol="text,LOTA03" GF="S 20">벤더</td>	<!--벤더-->
			    						<td GH="90 STD_LOTA05" GCol="text,LOTA05" GF="S 20">포장구분</td>	<!--포장구분-->
			    						<td GH="80 STD_LOTA11" GCol="text,LOTA11" GF="D 14">제조일자</td>	<!--제조일자-->
			    						<td GH="80 STD_LOTA12" GCol="text,LOTA12" GF="D 14">입고일자</td>	<!--입고일자-->
			    						<td GH="80 STD_LOTA13" GCol="text,LOTA13" GF="D 14">유통기한</td>	<!--유통기한-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<!-- <td GH="80 STD_CARDAT" GCol="text,CARDAT" GF="S 10">배송일자</td>	배송일자
			    						<td GH="80 STD_RECAYN" GCol="text,RECAYN" GF="S 10">재배차 여부</td>	재배차 여부 -->
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