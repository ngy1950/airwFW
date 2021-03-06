<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL50</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
	var syschk = "";

	var TOTALPICKING = 'N';
	var PROGID = 'DL50';
	var SHPOKYS = '' , ITEMKEY = '';
	
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "DL50_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "SHPOKY",
		    menuId : "DL50"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "Outbound",
			command : "DL50_ITEM",
			pkcol : "OWNRKY,WAREKY,TASKKY",
			emptyMsgType : false,
			tempHead : "gridHeadList",
			useTemp : true,
			tempKey : "SHPOKY",
		    menuId : "DL50"
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
		setSingleRangeData('SH.STATDO', rangeArr);


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
			var group = $('input[name="GROUP"]:checked').attr('id');
			if (SHPOKYS != "") {
				var param = new DataMap();			
				param.put('PROGID',PROGID)	
				param.put('SHPOKYS',SHPOKYS);
				
				gridList.gridList({
			    	id : "gridHeadList",
			    	command : "DL50_AFTER_SAVE_HEAD",
			    	param : param
			    });
			}else{
				var param = inputList.setRangeParam("searchArea");
				param.put('CLOSE', 'V')
				param.put('PROGID',PROGID)	
				gridList.gridList({
			    	id : "gridHeadList",
			    	param : param
			    });
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
			if (SHPOKYS != "") {
				param.put('SHPOKYS',SHPOKYS);
				param.put('ITEMKEY',ITEMKEY);
				gridList.gridList({
			    	id : "gridItemList",
			    	command : "DL50_AFTER_SAVE_ITEM",
			    	param : param
			    });

			}else{
				gridList.gridList({
			    	id : "gridItemList",
			    	param : param
			    });
			}
			
							
		}
	}
	
	function gridListEventDataBindEnd(gridId, dataCount){
		if(gridId == "gridHeadList" && dataCount == 0){
			gridList.resetGrid("gridItemList");
		}else if(gridId == "gridHeadList" && dataCount > 0){
			if (SHPOKYS != "") {
				gridList.setReadOnly(gridId, true);
			}else{
				gridList.setReadOnly(gridId, false);
			}
		}else if(gridId == "gridItemList" && dataCount > 0){
			
			if (SHPOKYS != "") {
				gridList.setReadOnly(gridId, true);
			}else{
				gridList.setReadOnly(gridId, false);
			}
			
			var itemGridBox = gridList.getGridBox('gridItemList');
			var itemList = itemGridBox.getDataAll();
			gridList.getGridBox(gridId).viewTotal(true);
// 			gridList.setReadOnly(gridId, true, ["rowCheck"]);
			
			for(var i=0; i<itemList.length; i++){
				if(gridList.getColData("gridItemList", itemList[i].get("GRowNum"), "STATIT") == 'FSH' || gridList.getColData("gridItemList", itemList[i].get("GRowNum"), "STATIT") == 'PSH' || gridList.getColData("gridItemList", itemList[i].get("GRowNum"), "STATIT") == 'NEW'){	
					if(gridList.getColData("gridItemList", itemList[i].get("GRowNum"), "QTJCMP") != gridList.getColData("gridItemList", itemList[i].get("GRowNum"), "QTSHPD")){
						alert("[RL09]SYSTEM 에리어처리가 필요합니다."); 
					}
				}
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

			var boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
			var qtshpd = Number(gridList.getColData(gridId, rowNum, "QTSHPD"));
			var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
							
		  	if( colName == "QTSHPD" ){ 		  		
			  	var boxqty = floatingFloor((Number)(qtshpd)/(Number)(qtduom), 1);
			  	
			  	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
			}else if( colName == "BOXQTY" ){ 		  		
				var qtshpd = (Number)(boxqty)*(Number)(qtduom);
			  	
			  	gridList.setColValue(gridId, rowNum, "QTSHPD", qtshpd);
			}
		}
	}
	
	function close(){    
		var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getGridData("gridItemList");
        //아이템 템프 가져오기
        var tempItem = gridList.getSelectTempData("gridHeadList");
	          
	    if(head.length == 0){
	      commonUtil.msgBox("SYSTEM_ROWSEMPTY");
	      return;
	    }
	    
	    var qtychk = "";
	    syschk = "";
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
		
		if(!confirm("출고완료 하시겠습니까?")) {
			return false;
		}
		
	    netUtil.send({
	      url : "/outbound/json/closeDL50.data",
	      param : param,
	      successFunction : "successSaveCallBack"
	    });
	  }
	  
	function closeAll(){    
		gridList.checkAll("gridHeadList",true);
		close();
	}	
	function successSaveCallBack(json, status){
		if(json && json.data){
			
			if(json.data != ""){
				commonUtil.msgBox("SYSTEM_SAVEOK");
				if (syschk == "Y") {
					alert("[RL09]SYSTEM 에리어처리가 필요합니다."); 
				}	
				SHPOKYS = json.data["SHPOKYS"];
				ITEMKEY = json.data["ITEMKEY"];
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
			SHPOKYS = '';
			ITEMKEY = '';
			searchList();
		}else if(btnName == "Create"){
			CreateOrderDocData();
	    }else if(btnName == "close"){
	    	
	        close();
	    }else if(btnName == "closeAll"){
	    	closeAll();
		}else if(btnName == "Reload"){
			reload();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL50");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL50");
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
     	 //출고유형     
       	if(searchCode == "SHDOCTM" && $inputObj.name == "SH.SHPMTY"){
       		param.put("DOCCAT","200");
        //매출처코드
       	}else if(searchCode == "SHBZPTN" && $inputObj.name == "SH.DPTNKY"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        //납품처코드
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "SH.PTRCVR"){
            param.put("PTNRTY","0001");
            param.put("OWNRKY","<%=ownrky %>");
       		
        }else if(searchCode == "SHCARMA2"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
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
	
	function gridListEventRowCheck(gridId, rowNum, checkType){
		if(gridId == "gridItemList" && checkType){
			gridList.checkAll(gridId, checkType, 0);
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
					<input type="button" CB="close SAVE BTN_ERPSEND" />
					<input type="button" CB="closeAll SAVE BTN_ERPSEND_ALL" />
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
							<input type="text" class="input" name="SR.CARDAT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송차수-->  
						<dt CL="STD_SHIPSQ"></dt> 
						<dd> 
							<input type="text" class="input" name="SR.SHIPSQ" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서일자-->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.DOCDAT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고유형-->  
						<dt CL="STD_SHPMTY"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.SHPMTY" UIInput="SR,SHDOCTM"/> 
						</dd> 
					</dl> 
					<dl>  <!--S/O 번호-->  
						<dt CL="STD_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="SI.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl>	
					<dl>  <!--출고문서번호-->  
						<dt CL="STD_SHPOKY"></dt> 
						<dd> 
							<input type="text" class="input" name="SI.SHPOKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서상태-->  
						<dt CL="STD_STATDO"></dt> 
						<dd> 
							<input type="text" class="input" name="SH.STATDO" UIInput="SR" readonly/> 
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
					<dl>  <!--차량번호-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="SR.CARNUM" UIInput="SR,SHCARMA2"/> 
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
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 20">거점명</td>	<!--거점명-->
			    						<td GH="50 STD_SHPMTY" GCol="text,SHPMTY" GF="S 4">출고유형</td>	<!--출고유형-->
			    						<td GH="80 STD_SHPMTYNM" GCol="text,SHPMTYNM" GF="S 20">문서타입명</td>	<!--문서타입명-->
			    						<td GH="50 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 20">문서상태명</td>	<!--문서상태명-->
			    						<td GH="50 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="80 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 20">문서유형명</td>	<!--문서유형명-->
			    						<td GH="100 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="50 STD_ALCCFM" GCol="text,DRELIN" GF="S 1">주문수량전송여부</td>	<!--주문수량전송여부-->
			    						<td GH="50 STD_RQSHPD" GCol="text,RQSHPD" GF="D 8">출고요청일자</td>	<!--출고요청일자-->
			    						<td GH="50 STD_RQARRD" GCol="text,RQARRD" GF="D 8">주문일자</td>	<!--주문일자-->
			    						<td GH="50 STD_RQARRT" GCol="text,RQARRT" GF="T 6">지시시간</td>	<!--지시시간-->
			    						<td GH="50 STD_OPURKY" GCol="text,OPURKY" GF="D 8">바이어 구매오더 번호</td>	<!--바이어 구매오더 번호-->
			    						<td GH="80 STD_ALSTKY" GCol="text,ALSTKY" GF="S 10">할당전략키</td>	<!--할당전략키-->
			    						<td GH="70 IFT_PTNROD" GCol="text,DPTNKY" GF="S 10">매출처코드</td>	<!--매출처코드-->
			    						<td GH="80 IFT_PTNRODNM" GCol="text,DPTNKYNM" GF="S 30">매출처명</td>	<!--매출처명-->
			    						<td GH="70 IFT_PTNRTO" GCol="text,PTRCVR" GF="S 10">납품처코드</td>	<!--납품처코드-->
			    						<td GH="80 IFT_PTNRTONM" GCol="text,PTRCVRNM" GF="S 30">납품처명</td>	<!--납품처명-->
			    						<td GH="50 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="50 STD_STKNUM" GCol="text,STKNUM" GF="S 20">토탈계획번호</td>	<!--토탈계획번호-->
			    						<td GH="80 STD_PGRC01" GCol="text,PGRC01" GF="S 20">권역</td>	<!--권역-->
			    						<td GH="80 STD_PGRC03" GCol="text,PGRC03" GF="S 20">주문구분</td>	<!--주문구분-->
			    						<td GH="80 STD_PGRC04" GCol="text,PGRC04" GF="S 20">주문부서</td>	<!--주문부서-->
			    						<td GH="80 STD_CREDAT" GCol="text,CREDAT" GF="D 8">생성일자</td>	<!--생성일자-->
			    						<td GH="80 STD_CRETIM" GCol="text,CRETIM" GF="T 6">생성시간</td>	<!--생성시간-->
			    						<td GH="80 STD_CREUSR" GCol="text,CREUSR" GF="S 20">생성자</td>	<!--생성자-->
			    						<td GH="80 STD_CUSRNM" GCol="text,CUSRNM" GF="S 20">생성자명</td>	<!--생성자명-->
			    						<td GH="80 STD_LMODAT" GCol="text,LMODAT" GF="D 8">수정일자</td>	<!--수정일자-->
			    						<td GH="80 STD_LMOTIM" GCol="text,LMOTIM" GF="T 6">수정시간</td>	<!--수정시간-->
			    						<td GH="80 STD_LMOUSR" GCol="text,LMOUSR" GF="S 20">수정자</td>	<!--수정자-->
			    						<td GH="80 STD_LUSRNM" GCol="text,LUSRNM" GF="S 20">수정자명</td>	<!--수정자명-->
			    						<td GH="100 STD_DOCTXT" GCol="text,DOCTXT" GF="S 100">비고</td>	<!--비고-->
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
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="80 STD_SHPOIT" GCol="text,SHPOIT" GF="S 6">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="80 STD_ALSTKY" GCol="text,ALSTKY" GF="S 10">할당전략키</td>	<!--할당전략키-->
			    						<td GH="50 STD_STATIT" GCol="text,STATIT" GF="S 4">상태</td>	<!--상태-->
			    						<td GH="80 STD_STATIT" GCol="text,STATITNM" GF="S 20">상태</td>	<!--상태-->
			    						<td GH="100 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						<td GH="70 STD_QTSHPO" GCol="text,QTSHPO" GF="N 20,0">지시수량</td>	<!--지시수량-->
			    						<td GH="70 STD_QTUALO" GCol="text,QTUALO" GF="N 20,0">미할당수량</td>	<!--미할당수량-->
			    						<td GH="70 STD_QTALOC" GCol="text,QTALOC" GF="N 20,0">할당수량</td>	<!--할당수량-->
			    						<td GH="70 STD_PKCMPL" GCol="text,QTJCMP" GF="N 20,0">피킹완료수량</td>	<!--피킹완료수량-->
			    						<td GH="70 STD_SHCMPL" GCol="input,QTSHPD" GF="N 20,0">출고확정수량</td>	<!--출고확정수량-->
			    						<td GH="70 STD_MEASKY" GCol="text,MEASKY" GF="S 10">단위구성</td>	<!--단위구성-->
			    						<td GH="70 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="70 STD_QTDUOM" GCol="text,QTDUOM" GF="N 20,0">입수</td>	<!--입수-->
			    						<td GH="70 STD_BOXQTY" GCol="input,BOXQTY" GF="N 20,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_ASKU01" GCol="text,ASKU01" GF="S 20">포장단위</td>	<!--포장단위-->
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
			    						<td GH="88 STD_ARRIVA" GCol="text,ARRIVA" GF="S 80">도착권역</td>	<!--도착권역-->
			    						<td GH="88 STD_CARDAT" GCol="text,CARDAT" GF="D 60">배송일자</td>	<!--배송일자-->
			    						<td GH="88 STD_CARNUM" GCol="text,CARNUM" GF="S 60">차량번호</td>	<!--차량번호-->
			    						<td GH="88 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 60,0">배송차수</td>	<!--배송차수-->
			    						<td GH="88 STD_SORTSQ" GCol="text,SORTSQ" GF="N 60,0">배송순서</td>	<!--배송순서-->
			    						<td GH="88 STD_DRIVER" GCol="text,DRIVER" GF="S 60">기사명</td>	<!--기사명-->
			    						<td GH="0 STD_STD_ROWCK" GCol="rowCheck"></td>
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