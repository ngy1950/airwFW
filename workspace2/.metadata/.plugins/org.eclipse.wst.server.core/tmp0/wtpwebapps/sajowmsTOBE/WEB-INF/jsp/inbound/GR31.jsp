<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>GR30</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">
var afsaveSearch = false,rangeparam, savekey,shpokys,recvkys;
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
	    	module : "SajoInbound",
			command : "GR31",
			itemGrid : "gridItemList",
			itemSearch :true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "KEY",
			menuId : "GR31"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
	    	module : "SajoInbound",
			command : "GR31_ITEM",
			tempHead : "gridHeadList",
			useTemp : true,
			tempKey : "KEY",
			menuId : "GR31"
	    });
		
		gridList.setReadOnly("gridItemList", true, ["LOTA06"]);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchList(){
		if(validate.check("searchArea")){
			afsaveSearch = false;
			rangeparam = inputList.setRangeDataParam("searchArea");
			gridList.gridList({
		    	id : "gridHeadList",
		    	param : rangeparam
		    })
		}
	}
	
	// PERHNO RECNUM CASTDT CASTIM SHPOKY CARNUM
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var param = gridList.getRowData(gridId, rowNum);
			rangeparam.putAll(param);
			
			if(recvkys != "" && recvkys !=" "){
				rangeparam.put("SHPOKYS",shpokys);
				rangeparam.put("RECVKYS",recvkys);
				
				gridList.gridList({
			    	id : "gridItemList",
			    	param : rangeparam,
			    	module : "SajoInbound",
					command : "GR31_ITEM_SAVE"
			    });
			}else{
				
				gridList.gridList({
			    	id : "gridItemList",
			    	param : rangeparam
			    });
			}
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
			param.put("DOCUTY", "123");
		}else if(comboAtt == "SajoCommon,CMCDV_COMBO"){
			var name = $($comboObj).attr("name");
			var id = $($comboObj).attr("id");
			
			if(name == "LOTA01"){
				param.put("CMCDKY", "LOTA01");	
			}
		}else if( comboAtt == "SajoCommon,OWNRKY_COMCOMBO" ){
			param.put("UROLKY", "<%=urolky%>");
			
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
				var docdatmv = head.get("DOCDATMV");
				var yy = docdat.substr(0,4);
				var mm = docdat.substr(4,2);
			    var dd = docdat.substr(6,2);
			    var sysdate = new Date(); 
			 	var date = new Date(Number(yy), Number(mm)-1, Number(dd));
			    if(Math.abs((date-sysdate)/1000/60/60/24) > 10){
			    	commonUtil.msgBox("확정일자는 ±10일로 지정하셔야 합니다.") ;
					gridList.setRowFocus("gridHeadList", head.get("GRowNum"), true);
					return;
				}
			    var ownrky = head.get("OWNRKY");
				if(ownrky != "2200"){
				    if(docdat < docdatmv){
						alert("확정일자는 이고 출고일보다 이전일 수 없습니다.") ;
						return;
					}
				} 
			}
				
			rangeparam.put("list",list);
			rangeparam.put("headlist",headlist);
			rangeparam.put("tempItem",tempItem);
			rangeparam.put("itemquery","GR31_ITEM");
			
			if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
				return;
	        }
			
			netUtil.send({
				url : "/inbound/json/saveReceive.data",
				param : rangeparam,
				successFunction : "successSaveCallBack"
			});
			
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data["CNT"] != "0"){
				afsaveSearch = true;
				savekey = json.data["SAVEKEY"];
				shpokys = json.data["SHPOKYS"];
				recvkys = json.data["RECVKYS"];
				rangeparam.put("SAVEKEY",savekey);
				rangeparam.put("SHPOKYS",json.data["SHPOKYS"]);
				rangeparam.put("RECVKYS",json.data["RECVKYS"]);
				
				gridList.gridList({
			    	id : "gridHeadList",
			    	param : rangeparam,
			    	module : "SajoInbound",
					command : "GR31_SAVED"
			    });
				
			}else if(json.data["RESULT"] == "F1"){
				commonUtil.msgBox("SYSTEM_ROWSEMPTY");
				$("#savebtn").show(); //저장실패시 save버튼 활성화
			}else{
				commonUtil.msgBox("EXECUTE_ERROR");
				$("#savebtn").show(); //저장실패시 save버튼 활성화
			}
		}
	}

	
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			savekey = "";
			shpokys = "";
			recvkys = "";
			searchList();
		}else if(btnName == "Save"){
			saveData();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "GR31");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "GR31");
		}
	}
	
	function linkPopCloseEvent(data){//팝업 종료 
		if(data.get("TYPE") == "GET"){ 
			sajoUtil.setVariant("searchArea" ,data); //팝업 데이터 적용
		}else if(data.get("TYPE") == "GETLAYOUT"){//레이아웃
    		sajoUtil.setLayout(data); //팝업 데이터 적용
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
				//var qtyasn = Number(gridList.getColData(gridId, rowNum, "QTYASN"));
				var qtytrf = Number(gridList.getColData(gridId, rowNum, "QTYTRF"));
				var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
				var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
				var pltqtycal = Number(gridList.getColData(gridId, rowNum, "PLTQTYCAL"));
				var grswgtcnt = Number(gridList.getColData(gridId, rowNum, "GRSWGTCNT"));
				//var asku02 = gridList.getColData(gridId, rowNum, "ASKU02");
				
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
							gridList.setColValue(gridId, rowNum, "PBOXQTY", boxqty );
						}
					}
					
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty );
					gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk );
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty );
					gridList.setColValue(gridId, rowNum, "QTYRCV", qtyrcv );
					gridList.setColValue(gridId, rowNum, "GRSWGT", grswgt );
					
				}
				
				if( qtyrcv > qtyasn ) {
					commonUtil.msgBox("VALID_GR000001"); //ASN 수량보다 입고수량을  많이 입력할 수 없습니다.
			    	
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
				var lota13 = dateParser(lota11 , 'S', 0 , 0 , +Number(outdmt)) ;
				
				gridList.setColValue(gridId, rowNum, "LOTA13", lota13 );
				
				var year11 = lota11.substr(0,4);
				var month11 = Number(lota11.substr(4,2)) - 1;
				var day11 = lota11.substr(6,2);
				
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
				var lota11 = dateParser(lota13 , 'S', 0 , 0 , -Number(outdmt)) ;
				
				gridList.setColValue(gridId, rowNum, "LOTA11", lota11 );
				
				var year11 = lota11.substr(0,4);
				var month11 = Number(lota11.substr(4,2)) - 1;
				var day11 = lota11.substr(6,2);
				
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

	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if(searchCode == "SHLOCMA"){
            param.put("WAREKY",$("#WAREKY").val());
        }else if(searchCode == "SHSKUMA"){
            param.put("WAREKY",$("#WAREKY").val());
        }else if(searchCode == "SHWAHMA"){
        	param.put("NOBIND","N");
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
					<input type="button" CB="Save SAVE BTN_SAVE" id="savebtn"/>
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
					<dl>  <!--출고유형-->  
						<dt CL="STD_RCPTTY"></dt> 
						<dd> 
							<select name="RCPTTY" id="RCPTTY" class="input" Combo="SajoCommon,DOCUTY_COMCOMBO" ComboCodeView="true"></select> 
						</dd> 
					</dl> 
					<dl>  <!--출고문서번호-->  
						<dt CL="IFT_SHPOKYMV"></dt> 
						<dd> 
							<input type="text" class="input" name="TRF.SHPOKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고문서일자-->  
						<dt CL="IFT_DOCDATMV"></dt> 
						<dd> 
							<input type="text" class="input" name="TRF.DOCDAT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--From 거점-->  
						<dt CL="STD_WAREFR"></dt> 
						<dd> 
							<input type="text" class="input" name="TRF.WARESR" UIInput="SR,SHWAHMA"/> 
						</dd> 
					</dl>
					<dl>  <!--제품코드-->  
						<dt CL="STD_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="TRF.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품명-->  
						<dt CL="STD_DESC01"></dt> 
						<dd> 
							<input type="text" class="input" name="TRF.DESC01" UIInput="SR"/> 
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="120 STD_RECVKY" GCol="text,RECVKY" GF="S 10"></td>	<!-- 입고문서번호  -->
										<td GH="120 STD_WAREKY" GCol="text,WAREKY" GF="S 10"></td>	<!--거점-->
										<td GH="120 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 120"></td>	<!--거점명-->
										<td GH="120 STD_RCPTTY" GCol="text,RCPTTY" GF="S 10"></td>	<!--입고유형-->
										<td GH="120 STD_RCPTTYNM" GCol="text,RCPTTYNM" GF="S 100"></td>	<!--입고유형명-->
										<td GH="120 STD_STATDO" GCol="text,STATDO" GF="S 4"></td>	<!--문서상태-->
										<td GH="120 STD_DOCDAT" GCol="input,DOCDAT" GF="C"></td>	<!--문서일자--><!-- GF="D 8" --> 
										<td GH="120 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4"></td>	<!--문서유형-->
										<td GH="120 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 100"></td>	<!--문서유형명-->
										<td GH="120 IFT_WARERQ" GCol="text,DPTNKY" GF="S 10"></td>	<!--작업거점-->
										<td GH="120 IFT_WARERQNM" GCol="text,DPTNKYNM" GF="S 100"></td>	<!--출고거점명-->
<!-- 										<td GH="120 STD_ORDDAT" GCol="text,ORDDAT" GF="D 100"></td>	출고일자 -->
<!-- 										<td GH="120 STD_DEDAT" GCol="text,CARDAT" GF="D 100">도착일자</td>	도착일자 -->
										<td GH="120 STD_CARNUM" GCol="text,CARNUM" GF="S 100"></td>	<!--차량번호-->
										<td GH="120 STD_DOCTXT" GCol="input,DOCTXT" GF="S 100"></td>	<!--비고-->
										<td GH="120 STD_CASTDT" GCol="text,CASTDT" GF="D 100"></td>	<!--차량출발일자-->
										<td GH="120 STD_PERHNO" GCol="text,PERHNO" GF="S 100"></td>	<!--기사핸드폰-->
										<td GH="120 STD_CASTIM" GCol="text,CASTIM" GF="T 100"></td>	<!--출발시간-->
										<td GH="120 STD_RECNUM" GCol="text,RECNUM" GF="S 100">재배차 차량번호</td>	<!--재배차 차량번호-->
										<td GH="120 STD_CASTYN" GCol="text,CASTYN" GF="S 1"></td>	<!--차량출발여부-->
										<td GH="120 IFT_SHPOKYMV" GCol="text,SHPOKYMV" GF="S 100"></td>	<!--출고문서번호-->
										<td GH="120 IFT_DOCDATMV" GCol="text,DOCDATMV" GF="D 100"></td>	<!--출고문서일자-->
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
										<td GH="120 STD_RECVIT" GCol="text,RECVIT" GF="S 6"></td>            <!--입고문서아이템-->
										<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 20"></td>           <!--제품코드-->
										<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120"></td>          <!--제품명-->
										<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120"></td>          <!--규격-->
										<td GH="120 STD_LOCAKY" GCol="input,LOCAKY,SHLOCMA" GF="S 20" validate="required"></td>           <!--로케이션-->
										<td GH="120 STD_QTYRCV" GCol="text,QTYRCV" GF="N 17,0"></td>         <!--입고수량-->
										<td GH="120 STD_ORDQTY" GCol="text,ORDQTY" GF="N 17,0"></td>         <!--지시수량-->
										<td GH="120 STD_QTYTRF" GCol="text,QTYTRF" GF="N 17,0"></td>         <!--[KO/STD/QTYTRF]-->
										<td GH="120 STD_BOXQTY" GCol="text,BOXQTY" GF="N 17,1"></td>         <!--박스수량-->
										<td GH="120 STD_PBOXQTY" GCol="text,PBOXQTY" GF="N 17,1"></td>       <!--P박스수량-->
										<td GH="120 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" ></td>         <!--박스입수-->
										<td GH="120 STD_REMQTY" GCol="text,REMQTY" GF="N 17,0"></td>         <!--잔량-->
										<td GH="120 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2"></td>         <!--팔레트수량-->
										<td GH="120 STD_PLIQTY" GCol="text,PLTQTYCAL" GF="S 17" style="text-align:right;" ></td>         <!--팔렛당수량-->
										<td GH="120 STD_OUTDMT" GCol="text,OUTDMT" GF="N 20,0"></td>         <!--유통기한(일수)-->
										<td GH="120 STD_DTREMDAT" GCol="text,DTREMDAT" GF="N 20,0"></td>     <!--유통잔여(DAY)-->
										<td GH="120 STD_DTREMRAT" GCol="text,DTREMRAT" GF="N 20,0"></td>     <!--유통잔여(%)-->
										<td GH="120 STD_LOTA05" GCol="select,LOTA05">
											<select class="input" Combo="SajoInbound,COMBO_LOTA05"></select><!--포장구분-->
										</td>
										<td GH="80 STD_LOTA06" GCol="select,LOTA06">
											<select class="input" Combo="SajoInbound,COMBO_LOTA06"></select><!--재고유형-->
										</td>
										<td GH="120 STD_LOTA11" GCol="input,LOTA11"  GF="C" validate="required"></td>           <!--제조일자--><!-- GF="D 14" -->
										<td GH="120 STD_LOTA12" GCol="text,LOTA12"  GF="C"></td>           <!--입고일자 --><!-- GF="D 14" -->
										<td GH="120 STD_LOTA13" GCol="input,LOTA13"  GF="C" validate="required"></td>           <!--유통기한--><!-- GF="D 14" -->
										<td GH="120 STD_REFDKY" GCol="text,REFDKY" GF="S 30"></td>           <!--참조문서번호-->
										<td GH="120 STD_REFDIT" GCol="text,REFDIT" GF="S 6"></td>            <!--참조문서Item번호-->
										<td GH="120 STD_REFCAT" GCol="text,REFCAT" GF="S 4"></td>            <!--입출고 구분자-->
										<td GH="120 STD_REFDAT" GCol="text,REFDAT" GF="D 8"></td>            <!--참조문서일자-->
										<td GH="120 STD_ASKU01" GCol="text,ASKU01" GF="S 20"></td>           <!--포장단위-->
										<td GH="120 STD_ASKU02" GCol="text,ASKU02" GF="S 20"></td>           <!--세트여부-->
										<td GH="120 STD_ASKU03" GCol="text,ASKU03" GF="S 20"></td>           <!--피킹그룹-->
										<td GH="120 STD_ASKU04" GCol="text,ASKU04" GF="S 20"></td>           <!--제품구분-->
										<td GH="120 STD_ASKU05" GCol="text,ASKU05" GF="S 20"></td>           <!--상온구분-->
										<td GH="120 STD_SKUG01" GCol="text,SKUG01" GF="S 20"></td>           <!--대분류-->
										<td GH="120 STD_SKUG02" GCol="text,SKUG02" GF="S 20"></td>           <!--중분류-->
										<td GH="120 STD_SKUG03" GCol="text,SKUG03" GF="S 20"></td>           <!--소분류-->
										<td GH="120 STD_SKUG04" GCol="text,SKUG04" GF="S 20"></td>           <!--세분류-->
										<td GH="120 STD_SKUG05" GCol="text,SKUG05" GF="S 50"></td>           <!--제품용도-->
										<td GH="120 STD_GRSWGT" GCol="text,GRSWGT" GF="N 17,0"></td>         <!--포장중량-->
										<td GH="120 STD_NETWGT" GCol="text,NETWGT" GF="N 17,0"></td>         <!--순중량-->
										<td GH="120 STD_WGTUNT" GCol="text,WGTUNT" GF="S 3"></td>            <!--중량단위-->
										<td GH="120 STD_LENGTH" GCol="text,LENGTH" GF="N 17,0"></td>         <!--포장가로-->
										<td GH="120 STD_WIDTHW" GCol="text,WIDTHW" GF="N 17,0"></td>         <!--가로길이-->
										<td GH="120 STD_HEIGHT" GCol="text,HEIGHT" GF="N 17,0"></td>         <!--포장높이-->
										<td GH="120 STD_CUBICM" GCol="text,CUBICM" GF="N 17,0"></td>         <!--CBM-->
										<td GH="120 STD_SEBELN" GCol="text,SEBELN" GF="S 20"></td>           <!--구매오더 No-->
										<td GH="120 STD_SEBELP" GCol="text,SEBELP" GF="S 6"></td>            <!--구매오더 Item-->
										<td GH="120 STD_SHPOIT" GCol="text,SHPOIT" GF="S 6"></td>            <!--출고문서아이템-->
										<td GH="120 STD_SBKTXT" GCol="input,SBKTXT" GF="S 150"></td>			<!--비고-->			
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