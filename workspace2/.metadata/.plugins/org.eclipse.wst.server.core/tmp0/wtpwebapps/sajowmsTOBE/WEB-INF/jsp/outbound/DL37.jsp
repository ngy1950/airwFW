<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL37</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript" src="/common/js/ezgencontrol.js"></script>
<script type="text/javascript">

	var GRPRL = '';
	var TOTALPICKING = 'N';
	var PROGID = 'DL37';
	var SHPOKYS = '';

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "DL37_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItem01List",
			itemSearch : true,
			tempItem : "gridItem01List",
			useTemp : true,
		    tempKey : "SVBELN",
		    menuId : "DL37"
	    });
		
		gridList.setGrid({
    	id : "gridItem01List",
		module : "Outbound",
		command : "DL36_ITEM",
		pkcol : "OWNRKY,WAREKY,SHPOKY",
		emptyMsgType : false,
	    menuId : "DL37"
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
	}
	
	function searchList(){
		if(validate.check("searchArea")){

			gridList.resetGrid("gridHeadList");
			gridList.resetGrid("gridItem01List");
			var param = inputList.setRangeParam("searchArea");			
			var group = $('input[name="GROUP"]:checked').attr('id');
			param.put('GRPRL', group)
			if (SHPOKYS != "") {
				$('#BTN_SAVECRE').hide()
				$('#BTN_ALLOCATE').hide()
				$('#BTN_ALLOCATE_ALL').hide()
				param.put('SHPOKYS',SHPOKYS);
				param.put('DOCCAT', '300');
				param.put('TASOTY', '305');
				param.put('STATDO', 'NEW');
				
				netUtil.send({
					url : "/outbound/json/displayDL36.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : "gridHeadList" //그리드ID
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
				    	command : "DL36_ITEM",
				    	param : param
				    });		
					
				}
				
			} else {
				$('#BTN_SAVECRE').show()
				$('#BTN_ALLOCATE').show()
				$('#BTN_ALLOCATE_ALL').show()
				gridList.gridList({
			    	id : "gridHeadList",
			    	param : param
			    });				
			}
		}
	}
	

	function print() {
		
		var count = 0;
 
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var wherestr = "";  
			
			for(var i =0;i < head.length ; i++){

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

			//검색조건 출력물에 반영
			var option = " ";
			wherestr += getMultiRangeDataSQLEzgen('S.SKUKEY', 'B.SKUKEY');
			option += getMultiRangeDataSQLEzgen('S.SKUKEY', 'B.SKUKEY');
			wherestr += getMultiRangeDataSQLEzgen('LM.NEDSID', 'LM.NEDSID');
			option += getMultiRangeDataSQLEzgen('LM.NEDSID', 'LM.NEDSID');	
			
			//LOCAKY 레인지 길이확인
			var rangeInput = inputList.rangeMap.map['S.LOCASR'];
			if(rangeInput.singleData.length > 1 || rangeInput.rangeData.length > 1){//RANGE 값 하나 초과
				wherestr += getMultiRangeDataSQLEzgen('S.LOCASR', 'B.LOCASR');
				option += getMultiRangeDataSQLEzgen('S.LOCASR', 'B.LOCASR');	
			}else{
				if(rangeInput.singleData.length > 0){
					option += " AND B.LOCASR LIKE '" + rangeInput.singleData[0].map.DATA+"%'";
					wherestr += " AND B.LOCASR LIKE '" + rangeInput.singleData[0].map.DATA+"%'";
				}
			}
			
			if(!commonUtil.msgConfirm("PRINT_DL35")){  
				return;
	        }
			
			
			//이지젠 호출부(신버전)
			var langKy = "KO";
			var map = new DataMap();
			map.put("i_option",option);
			var width = 890;
			var height = 595;

			WriteEZgenElement("/ezgen/replenish_list.ezg" , wherestr , " " , langKy, map , width , height );
			
		}		
 	}
	

	function print2() {
		
		var count = 0;
 
		if(gridList.validationCheck("gridHeadList", "select")){ //체크된 ROW가 있는지 확인
			var head = gridList.getSelectData("gridHeadList", true);
			//체크가 없을 경우 
			if(head.length == 0){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				return;
			}
			
			var wherestr = "";  
			
			for(var i =0;i < head.length ; i++){

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
			wherestr += getMultiRangeDataSQLEzgen('S.SKUKEY', 'B.SKUKEY');
			option += getMultiRangeDataSQLEzgen('S.SKUKEY', 'B.SKUKEY');
			wherestr += getMultiRangeDataSQLEzgen('LM.NEDSID', 'LM.NEDSID');
			option += getMultiRangeDataSQLEzgen('LM.NEDSID', 'LM.NEDSID');	
			
			//LOCAKY 레인지 길이확인
			var rangeInput = inputList.rangeMap.map['S.LOCASR'];
			if(rangeInput.singleData.length > 1 || rangeInput.rangeData.length > 1){//RANGE 값 하나 초과
				wherestr += getMultiRangeDataSQLEzgen('S.LOCASR', 'B.LOCASR');
				option += getMultiRangeDataSQLEzgen('S.LOCASR', 'B.LOCASR');	
			}else{
				if(rangeInput.singleData.length > 0){
					option += " AND B.LOCASR LIKE '" + rangeInput.singleData[0].map.DATA+"%'";
					wherestr += " AND B.LOCASR LIKE '" + rangeInput.singleData[0].map.DATA+"%'";
				}
			}
			
			
			
			//이지젠 호출부(신버전)
			var langKy = "KO";
			var map = new DataMap();
				map.put("i_option",option);
			var width = 890;
			var height = 595;

			WriteEZgenElement("/ezgen/replenish_list_1H700.ezg" , wherestr , " " , langKy, map , width , height );
			
		}		
 	}
	
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");			
			param.putAll(rowData);
			if (SHPOKYS == ''){		
				gridList.gridList({
			    	id : "gridItem01List",
			    	param : param
			    });
				
			} else {
				SHPOKYS = '';
			}		
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt, $comboObj){
		var param = new DataMap();
		if(comboAtt == "SajoCommon,DOCTM_COMCOMBO"){
			param.put("DOCCAT", "300");
			param.put("DOCUTY", "305");
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
			url : "/outbound/json/saveDL36.data",
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
	
	function reload(){
		gridList.resetGrid("gridItem01List");
		searchList();
	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			searchList();
		}else if(btnName == "Save"){			
			save();
		}else if(btnName == "Confirm"){
			confirm();
		}else if(btnName == "Reload"){
			reload();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL37");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL37");
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
					<input type="button" CB="Print PRINT BTN_REPPRINT_PY" /> <!-- (담당자)-평택-->
					<input type="button" CB="Print2 PRINT BTN_REPPRINT_LOC" /> <!-- (로케이션)-->
				</div>
			</div>
			<div class="search_inner" id="searchArea">
				<div class="search_wrap ">
				    <dl>
						<dt CL="STD_OWNRKY"></dt>
						<dd>
							<select name="OWNRKY" id="S.OWNRKY"  class="input" Combo="SajoCommon,OWNRKY_COMCOMBO" ComboCodeView="true"></select>
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
							<select name="TASOTY" id="A.TASOTY" class="input" Combo="SajoCommon,DOCTM_COMCOMBO"></select> 
						</dd> 
					</dl> 
					<dl>  <!--작업지시번호-->  
						<dt CL="STD_TASKKY"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.TASKKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송일자-->  
	                    <dt CL="STD_CARDAT"></dt> 
	                    <dd> 
						  <input type="text" class="input" name="USRID1" UIFormat="C 1"/> 
	                    </dd> 
                   </dl>
					<dl>  <!--작업지시일자-->  
						<dt CL="STD_TASKDT"></dt> 
						<dd> 
							<input type="text" class="input" name="TASDH.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--작업자명-->  
						<dt CL="STD_WORKNM"></dt> 
						<dd> 
							<input type="text" class="input" name="LM.NEDSID" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--로케이션-->  
						<dt CL="STD_LOCAKY"></dt> 
						<dd> 
							<input type="text" class="input" name="S.LOCASR" UIInput="SR"/> 
						</dd> 
					</dl> 
                  <dl>  <!--배송차수-->  
		              <dt CL="STD_SHIPSQ"></dt> 
		              <dd> 
		                <input type="text" class="input" name="SR.SHIPSQ" UIInput="SR"/> 
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_TASKKY" GCol="text,TASKKY" GF="S 10">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="80 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_TASOTY" GCol="text,TASOTY" GF="N 4,0">작업타입</td>	<!--작업타입-->
			    						<td GH="80 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_DOCCAT" GCol="text,DOCCAT" GF="N 4,0">문서유형</td>	<!--문서유형-->
			    						<td GH="200 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 90">문서유형명</td>	<!--문서유형명-->
			    						<td GH="80 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 20">문서상태명</td>	<!--문서상태명-->
			    						<td GH="80 STD_CARDAT" GCol="text,USRID1" GF="D 20">배송일자</td>	<!--배송일자-->
			    						<td GH="80 STD_SHIPSQ" GCol="text,UNAME1" GF="N 20,0">배송차수</td>	<!--배송차수-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 8">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 60">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 60">생성자명</td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 60">수정일자</td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 60">수정시간</td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 60">수정자</td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 60">수정자명</td>	<!--수정자명-->
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
					<li onclick="moveTab(0);"><a href="#tab2-1" id="atab1"><span>상세내역</span></a></li>
					
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
			    						<td GH="50 STD_TASKKY" GCol="text,TASKKY" GF="S 10">작업지시번호</td>	<!--작업지시번호-->
			    						<td GH="50 STD_TASKIT" GCol="text,TASKIT" GF="S 6">작업오더아이템</td>	<!--작업오더아이템-->
			    						<td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="80 STD_QTTAOR" GCol="text,QTTAOR" GF="N 20,0">작업수량</td>	<!--작업수량-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="160 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_DESC02" GCol="text,DESC02" GF="S 60">규격</td>	<!--규격-->
			    						<td GH="160 STD_LOCASR" GCol="text,LOCASR" GF="S 20">로케이션</td>	<!--로케이션-->
			    						<td GH="80 STD_SMEAKY" GCol="text,SMEAKY" GF="S 10">단위구성</td>	<!--단위구성-->
			    						<td GH="50 STD_SUOMKY" GCol="text,SUOMKY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="160 STD_LOCATG" GCol="text,LOCATG" GF="S 20">To 로케이션</td>	<!--To 로케이션-->
			    						<td GH="80 STD_SKUG01" GCol="text,SKUG01" GF="S 10">대분류</td>	<!--대분류-->
			    						<td GH="88 STD_GRSWGT" GCol="text,GRSWGT" GF="N 11,3">포장중량</td>	<!--포장중량-->
			    						<td GH="88 STD_NETWGT" GCol="text,NETWGT" GF="N 11,3">순중량</td>	<!--순중량-->
			    						<td GH="50 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3">중량단위</td>	<!--중량단위-->
			    						<td GH="88 STD_LENGTH" GCol="text,LENGTH" GF="N 11">포장가로</td>	<!--포장가로-->
			    						<td GH="88 STD_WIDTHW" GCol="text,WIDTHW" GF="N 11">가로길이</td>	<!--가로길이-->
			    						<td GH="88 STD_HEIGHT" GCol="text,HEIGHT" GF="N 11">포장높이</td>	<!--포장높이-->
			    						<td GH="88 STD_CUBICM" GCol="text,CUBICM" GF="N 11">CBM</td>	<!--CBM-->
			    						<td GH="88 STD_CAPACT" GCol="text,CAPACT" GF="N 11">CAPA</td>	<!--CAPA-->
			    						<td GH="80 STD_WORKNM" GCol="text,WORKNM" GF="S 60">작업자명</td>	<!--작업자명-->
			    						<td GH="80 STD_STATITNM" GCol="text,STATITNM" GF="S 20">상태명</td>	<!--상태명-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="88 STD_ARRIVA" GCol="text,ARRIVA" GF="S 80">도착권역</td>	<!--도착권역-->
			    						<td GH="88 STD_CARDAT" GCol="text,CARDAT" GF="D 60">배송일자</td>	<!--배송일자-->
			    						<td GH="88 STD_CARNUM" GCol="text,CARNUM" GF="S 60">차량번호</td>	<!--차량번호-->
			    						<td GH="88 STD_SHIPSQ" GCol="text,SHIPSQ" GF="S 15">배송차수</td>	<!--배송차수-->
			    						<td GH="88 STD_SORTSQ" GCol="text,SORTSQ" GF="S 15">배송순서</td>	<!--배송순서-->
			    						<td GH="88 STD_DRIVER" GCol="text,DRIVER" GF="S 60">기사명</td>	<!--기사명-->
			    						<td GH="88 STD_RECAYN" GCol="text,RECAYN" GF="S 60">재배차 여부</td>	<!--재배차 여부-->
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
				
				
			</div>
		</div>
	</div>
</div>
<!-- // content -->
<%@ include file="/common/include/webdek/bottom.jsp" %>
</body>
</html>