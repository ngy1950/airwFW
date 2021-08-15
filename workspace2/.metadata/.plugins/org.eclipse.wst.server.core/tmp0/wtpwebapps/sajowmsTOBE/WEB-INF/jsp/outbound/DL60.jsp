<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL60</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">

	var GRPRL = 'ERPSO';
	var TOTALPICKING = 'N';
	var PROGID = 'DL60';
    var SVBELN = '';
    
	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "DL60_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "SHPOKY",
		    menuId : "DL60"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "Outbound",
			command : "DL60_ITEM",
			pkcol : "OWNRKY,WAREKY,TASKKY",
			emptyMsgType : false,
		    tempKey : "SHPOKY",
		    useTemp : true,
			tempHead : "gridHeadList",
		    menuId : "DL60"
	    });
		
		$("#searchArea [name=OWNRKY]").on("change",function(){
			searchwareky($(this).val(),"#WARERQ");
		});
		
		$("#searchArea [name=WARERQ]").on("change",function(){
			searchwareky($('#OWNRKY').val(),"#WARETG");
		});
		
		searchwareky($('#OWNRKY').val(),"#WARERQ");
		
		//CARDAT 하루 더하기 
		$("#CARDAT").val(dateParser(null, "SD", 0, 0, 1));
		
		//콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["OWNRKY", "WARESR", "WARERQ", "WARETG", "DOCUTY", "CARTYP", "CARGBN"]);


		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();
	});
	
	function searchwareky(val,target){
		var param = new DataMap();
		param.put("OWNRKY",val);
		
		var json = netUtil.sendData({
			module : "SajoCommon",
			command : "WAREKYNM_IF2_COMCOMBO",
			sendType : "list",
			param : param
		});
		
		$(target).find("[UIOption]").remove();
		var optionHtml = inputList.selectHtml(json.data, false);
		$(target).append(optionHtml);

	}
	
	function searchList(){
		gridList.resetGrid("gridItemList");
		if(validate.check("searchArea")){			
			var param = inputList.setRangeParam("searchArea");			
			var group = $('input[name="GROUP"]:checked').attr('id');
			param.put('SVBELN',SVBELN)	

			gridList.gridList({
		    	id : "gridHeadList",
		    	param : param
		    });
		}

	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.putAll(rowData);
			if (SVBELN == ''){				
				gridList.gridList({
			    	id : "gridItemList",
			    	param : param
			    });
			} else {
				SVBELN = '';
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
		
		var qtyorg = 0;
		var boxqty = 0;
		var remqty = 0;
		var pltqty = 0;
		var grswgt = 0;
		var bxiqty = Number(gridList.getColData(gridId, rowNum, "BXIQTY"));
		var qtduom = Number(gridList.getColData(gridId, rowNum, "QTDUOM"));
		var pliqty = Number(gridList.getColData(gridId, rowNum, "PLIQTY"));
//		var grswgtcnt = Number(gridList.getColData(gridId, rowNum, "GRSWGTCNT"));
		var remqtyChk = 0;
		
		if(gridId == "gridHeadList"){
			 if( colName == "RECNUM" ) {
					inputRecnum(gridId, rowNum);
				}
		}
		
		if(gridId == "gridItemList"){
			if(colName == "QTYORG" || colName == "BOXQTY" || colName == "REMQTY" || colName == "RECNUM"){
				if(colName == "SKUKEY"){
					var skukey = gridList.getColData(gridId, rowNum, "SKUKEY");
					if (skukey == '') {
						alert("품번을 입력 후 수량을 입력하실 수 있습니다.");
						gridList.setColValue(gridId, rowNum, "QTYORG", 0);
						gridList.setColValue(gridId, rowNum, "BOXQTY", 0);
						gridList.setColValue(gridId, rowNum, "REMQTY", 0);
						gridList.setColValue(gridId, rowNum, "PLTQTY", 0);
						return;
					}
				}else if( colName == "QTYORG" ) {
					qtyorg = Number(gridList.getColData(gridId, rowNum, "QTYORG"));
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));					
				  	remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
				  	boxqty = floatingFloor((Number)(qtyorg)/(Number)(bxiqty), 1);
				 	remqty = (Number)(qtyorg)%(Number)(bxiqty);
				 	pltqty = floatingFloor((Number)(qtyorg)/(Number)(pliqty), 2);				 	
					gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqty);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
				} else if( colName == "QTYORG" ) {
					remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
					qtyorg = (Number)(bxiqty) * (Number)(boxqty) + (Number)(remqty)
				 	pltqty = floatingFloor((Number)(qtyorg)/(Number)(pliqty), 2);
				 	gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "QTYORG", qtyorg);
				} else if( colName == "REMQTY" ) {
					boxqty = Number(gridList.getColData(gridId, rowNum, "BOXQTY"));
					qtyorg = Number(gridList.getColData(gridId, rowNum, "QTYORG"));
					remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
					remqtyChk = (Number)(remqty)%(Number)(bxiqty);
				 	boxqty = (Number)(boxqty) + (Number)(floatingFloor((Number)(remqty)/(Number)(bxiqty), 0));
				 	qtyorg = (Number)(boxqty) * (Number)(bxiqty) + (Number)(remqtyChk);
				 	pltqty = floatingFloor((Number)(qtyorg)/(Number)(pliqty), 2);
				 	gridList.setColValue(gridId, rowNum, "BOXQTY", boxqty);
					gridList.setColValue(gridId, rowNum, "REMQTY", remqtyChk);
					gridList.setColValue(gridId, rowNum, "PLTQTY", pltqty);
					gridList.setColValue(gridId, rowNum, "QTYORG", qtyorg);
				} else if( colName == "RECNUM" ) {
					inputRecnum(gridId, rowNum);
				}
			}
		}			
	}
	
	  function save(){    
        var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getGridData("gridItemList");
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
		
    	if(!commonUtil.msgConfirm("SYSTEM_SAVECF")){ //저장하시겠습니까?
			return;
        }

	    netUtil.send({
	      url : "/outbound/json/saveDL60.data",
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
				SVBELN = json.data;
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
			searchList();
	    }else if(btnName == "Save"){
	    	save();
		}else if(btnName == "Reload"){
			reload();
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL60");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL60");
		}
	}
	
  //서치헬프 기본값 세팅
  function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        if(searchCode == "SHCMCDV" && $inputObj.name == "PGRC03"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCARMA2"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
            
        }else if(searchCode == "SHCARNUMIF"){
            param.put("WAREKY","<%=wareky %>");
            param.put("OWNRKY","<%=ownrky %>");
        }
      return param;
    }
		
	//서치헬프 종료 이벤트
	 function searchHelpEventCloseAfter(searchCode, multyType, selectData, rowData){
       
	  if( searchCode == 'SHSKUMAGD'){
	   var gridId = "gridItemList"
	   var rowNum = gridList.getFocusRowNum(gridId);
	   var head = gridList.getSelectData("gridHeadList");	   
	   var ownrky = head[0].get("OWNRKY");	  
	   var waresr = head[0].get("WARESR");
	   var warerq = $('#WARERQ').val();	   
	   var skukey = rowData.get("SKUKEY")
	   
	   var param = new DataMap();
	   param.put("OWNRKY", ownrky);
	   param.put("WAREKY", waresr);
	   param.put("WARERQ", warerq);
	   param.put("SKUKEY", skukey);
	   
	   var json = netUtil.sendData({
			module : "Outbound",
			command : "TM05_SKUKEY_SHELP",
			sendType : "map",
			param : param
		}); 
			gridList.setColValue(gridId, rowNum, "SKUKEY", json.data.SKUKEY);
			gridList.setColValue(gridId, rowNum, "DESC01", json.data.DESC01);
			gridList.setColValue(gridId, rowNum, "DESC02", json.data.DESC02);
			gridList.setColValue(gridId, rowNum, "DUOMKY", json.data.DUOMKY);
			gridList.setColValue(gridId, rowNum, "QTYORG", json.data.QTYORG);
			gridList.setColValue(gridId, rowNum, "TOQTSIWH", json.data.TOQTSIWH);
			gridList.setColValue(gridId, rowNum, "PLIQTY", json.data.PLIQTY);
			gridList.setColValue(gridId, rowNum, "PLTQTY", json.data.PLTQTY);
			gridList.setColValue(gridId, rowNum, "BXIQTY", json.data.BXIQTY);
			gridList.setColValue(gridId, rowNum, "BOXQTY", json.data.BOXQTY);
			gridList.setColValue(gridId, rowNum, "REMQTY", json.data.REMQTY);
			
	  } else if (searchCode == 'SHCARNUMIF'){
		   var gridId = page.searchOpenGridId;
		   var rowNum = gridList.getFocusRowNum(gridId);		  
		   var ownrky = rowData.get("OWNRKY");
		   var wareky = rowData.get("WAREKY");
		   var recnum = rowData.get("RECNUM");
		   
		   var param = new DataMap();
		   param.put("OWNRKY", ownrky);
		   param.put("WAREKY", wareky);
		   param.put("RECNUM", recnum);
		   		   
		   var json = netUtil.sendData({
				module : "Outbound",
				command : "DL60_CARMA_INFO",
				sendType : "map",
				param : param
			}); 
		   
			gridList.setColValue(gridId, rowNum, "RECNUM", rowData.get("RECNUM"));
			gridList.setColValue(gridId, rowNum, "RCATYP", rowData.get("RECTYP"));
			gridList.setColValue(gridId, rowNum, "RCAGBN", rowData.get("RECGBN"));
			gridList.setColValue(gridId, rowNum, "CARNUMNMRE", json.data.CARNUMNMRE);
			gridList.setColValue(gridId, rowNum, "DRIVER", json.data.DRIVER);
			gridList.setColValue(gridId, rowNum, "PERHNO", json.data.PERHNO);
			gridList.setColValue(gridId, rowNum, "RETRCP", json.data.RETRCP);
	  }
		  
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
   		//콤보박스 리드온리
      		gridList.setReadOnly("gridHeadList", true, ["OWNRKY", "WARESR", "WARERQ","WARETG", "DOCUTY", "CARTYP", "CARGBN"]);
       		gridList.setReadOnly("gridItemList", true, ["CARTYP", "CARGBN"]);
      }
    }
	 
	function inputRecnum(gridId, rowNum){
		   var recnum = gridList.getColData(gridId, rowNum, "RECNUM");	   
		   var param = new DataMap();
		   param.put("WAREKY","<%=wareky %>");
           param.put("OWNRKY","<%=ownrky %>");         
		   param.put("RECNUM", recnum);
		   var json = netUtil.sendData({
				module : "Outbound",
				command : "DL60_CARMA_INFO",
				sendType : "map",
				param : param
			}); 
		   
			gridList.setColValue(gridId, rowNum, "RECNUM", json.data.RECNUM);
			gridList.setColValue(gridId, rowNum, "RCATYP", json.data.RCATYP);
			gridList.setColValue(gridId, rowNum, "RCAGBN", json.data.RCAGBN);
			gridList.setColValue(gridId, rowNum, "CARNUMNMRE", json.data.CARNUMNMRE);
			gridList.setColValue(gridId, rowNum, "DRIVER", json.data.DRIVER);
			gridList.setColValue(gridId, rowNum, "PERHNO", json.data.PERHNO);
			gridList.setColValue(gridId, rowNum, "RETRCP", json.data.RETRCP);
	}
	
	//더블클릭
	function gridListEventRowDblclick(gridId, rowNum){
		if(gridId == "gridHeadList"){
			gridList.setRowCheck(gridId, rowNum, true);
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
							<input type="text" class="input" name="CARDAT" id="CARDAT" UIInput="I" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송차수-->  
						<dt CL="STD_SHIPSQ"></dt> 
						<dd> 
							<input type="text" class="input" name="R.SHIPSQ" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고문서번호-->  
						<dt CL="STD_SHPOKY"></dt> 
						<dd> 
							<input type="text" class="input" name="H.SHPOKY" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="STD_PGRC03"></dt> 
						<dd> 
							<input type="text" class="input" name="PGRC03" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--문서일자-->  
						<dt CL="STD_DOCDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="H.DOCDAT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--차량번호-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="R.CARNUM" UIInput="SR,SHCARMA2"/> 
						</dd> 
					</dl> 
					<dl>  <!--차량 구분-->  
						<dt CL="STD_CARGBN"></dt> 
						<dd> 
							<select name="CARGBN" id="CARGBN" class="input" CommonCombo="CARGBN"><option></option></select> 
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
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="80 STD_DPTNKY" GCol="text,DPTNKY" GF="S 20">업체코드</td>	<!--업체코드-->
			    						<td GH="80 STD_BIZPART" GCol="text,NAME01" GF="S 180">거래처</td>	<!--거래처-->
			    						<td GH="50 STD_DEPARTURE" GCol="text,DEPART" GF="S 10">출발권역</td>	<!--출발권역-->
			    						<td GH="80 STD_ARRIVA" GCol="text,ARRIVA" GF="S 10">도착권역</td>	<!--도착권역-->
			    						<td GH="100 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->
			    						<td GH="100 STD_CARNUMNMRE" GCol="text,CARNUMNMRE" GF="S 100">재배차 차량정보</td>	<!--재배차 차량정보-->
			    						<td GH="90 STD_CARTYP" GCol="select,CARTYP"><!--차량톤수-->
											<select class="input" commonCombo="CARTYP"></select>
			    						</td>
			    						<td GH="90 STD_CARGBN" GCol="select,CARGBN"><!--차량구분-->
											<select class="input" commonCombo="CARGBN"><option></option></select>
			    						</td>
			    						<td GH="100 STD_RECNUM" GCol="input,RECNUM,SHCARNUMIF" GF="S 20">재배차 차량번호</td>	<!--재배차 차량번호-->
			    						<td GH="90 STD_RECTYP" GCol="select,RCATYP"><!--재배차 차량톤수-->
											<select class="input" commonCombo="CARTYP"></select>
			    						</td>
			    						<td GH="90 STD_RECGBN" GCol="select,RCAGBN"><!--재배차 차량구분-->
											<select class="input" commonCombo="CARGBN"><option></option></select>
			    						</td>			    						
			    						<td GH="100 STD_PERHNO" GCol="input,PERHNO" GF="S 20">기사핸드폰</td>	<!--기사핸드폰-->
			    						<td GH="50 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 5,0">배송차수</td>	<!--배송차수-->
			    						<td GH="80 STD_SHIPSQ" GCol="text,CHKFIELD" GF="S 5">배송차수</td>	<!--배송차수-->
			    						<td GH="85 STD_CARDAT" GCol="text,CARDAT" GF="D 8">배송일자</td>	<!--배송일자-->
			    						<td GH="85 STD_RECDAT" GCol="input,RECDAT" GF="C 8">재배차 배송일자</td>	<!--재배차 배송일자-->
			    						<td GH="50 STD_RETUYN" GCol="check,RETUYN">회송여부</td>	<!--회송여부-->
			    						<td GH="80 STD_USRID1" GCol="text,USRID1" GF="S 180">배송지우편번호</td>	<!--배송지우편번호-->
			    						<td GH="100 STD_UNAME1" GCol="text,UNAME1" GF="S 180">배송지주소</td>	<!--배송지주소-->
			    						<td GH="80 STD_DEPTID1" GCol="text,DEPTID1" GF="S 180">배송고객명</td>	<!--배송고객명-->
			    						<td GH="80 STD_DNAME1" GCol="text,DNAME1" GF="S 180">배송지전화번호</td>	<!--배송지전화번호-->
			    						<td GH="90 STD_FORKYN" GCol="select,FORKYN"><!--지게차사용여부-->
											<select class="input" commonCombo="FORKYN"><option></option></select>
			    						</td>
			    						<td GH="80 STD_USRID2" GCol="text,USRID2" GF="S 180">업무담당자</td>	<!--업무담당자-->
			    						<td GH="75 STD_DRIVER" GCol="input,DRIVER" GF="S 10">기사명</td>	<!--기사명-->
			    						<td GH="65 STD_DCMPNM" GCol="text,TRCMPY" GF="S 10">운송사</td>	<!--운송사-->
			    						<td GH="90 STD_RETRCP" GCol="select,RETRCP"><!--재배차운송사-->
											<select class="input" commonCombo="TRCMPY"><option></option></select>
			    						</td>	
			    						<td GH="100 STD_CARNUMNM" GCol="text,CARNUMNM" GF="S 100">차량정보</td>	<!--차량정보-->
			    						<td GH="100 STD_ASKU05" GCol="text,ASKU05" GF="S 100">상온구분</td>	<!--상온구분-->
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
			    						<td GH="80 STD_SHPOIR" GCol="text,SHPOIR" GF="S 6">출하배차번호</td>	<!--출하배차번호-->
			    						<td GH="80 STD_DPTNKY" GCol="text,DPTNKY" GF="S 20">업체코드</td>	<!--업체코드-->
			    						<td GH="80 STD_BIZPART" GCol="text,NAME01" GF="S 180">거래처</td>	<!--거래처-->
			    						<td GH="100 STD_DEPARTURE" GCol="input,DEPART" GF="S 10">출발권역</td>	<!--출발권역-->
			    						<td GH="200 STD_DESC01" GCol="text,DESC01" GF="S 60">제품명</td>	<!--제품명-->
			    						<td GH="80 STD_ARRIVA" GCol="text,ARRIVA" GF="S 10">도착권역</td>	<!--도착권역-->
			    						<td GH="100 STD_CARNUM" GCol="text,CARNUM" GF="S 20">차량번호</td>	<!--차량번호-->		    						
			    						<td GH="80 STD_CARNUMNM" GCol="text,CARNUMIF" GF="S 80">차량정보</td>	<!--차량정보-->
			    						<td GH="90 STD_CARTYP" GCol="select,CARTYP"><!--차량톤수-->
											<select class="input" commonCombo="CARTYP"><option></option></select>
			    						</td>
			    						<td GH="90 STD_CARGBN" GCol="select,CARGBN"><!--차량구분-->
											<select class="input" commonCombo="CARGBN"><option></option></select>
			    						</td>
			    						<td GH="90 STD_RECTYP" GCol="select,RCATYP"><!--재배차 차량톤수-->
											<select class="input" commonCombo="CARTYP"><option></option></select>
			    						</td>
			    						<td GH="90 STD_RECGBN" GCol="select,RCAGBN"><!--재배차 차량구분-->
											<select class="input" commonCombo="CARGBN"><option></option></select>
			    						</td>
			    						<td GH="100 STD_RECNUM" GCol="input,RECNUM,SHCARNUMIF" GF="S 20">재배차 차량번호</td>	<!--재배차 차량번호-->
			    						<td GH="100 STD_CARNUMNMRE" GCol="text,CARNUMNMRE" GF="S 100">재배차 차량정보</td>	<!--재배차 차량정보-->
			    						<td GH="100 STD_PERHNO" GCol="input,PERHNO" GF="S 20">기사핸드폰</td>	<!--기사핸드폰-->
			    						<td GH="50 STD_SHIPSQ" GCol="text,SHIPSQ" GF="N 5,0">배송차수</td>	<!--배송차수-->
			    						<td GH="50 STD_QTRECN" GCol="input,QTRECN" GF="N 10,0">재배차수량</td>	<!--재배차수량-->
			    						<td GH="85 STD_CARDAT" GCol="text,CARDAT" GF="D 8">배송일자</td>	<!--배송일자-->
			    						<td GH="85 STD_RECDAT" GCol="input,RECDAT" GF="C 8">재배차 배송일자</td>	<!--재배차 배송일자-->
			    						<td GH="40 STD_RETUYN" GCol="check,RETUYN">회송여부</td>	<!--회송여부-->
			    						<td GH="80 STD_USRID1" GCol="text,USRID1" GF="S 180">배송지우편번호</td>	<!--배송지우편번호-->
			    						<td GH="80 STD_UNAME1" GCol="text,UNAME1" GF="S 180">배송지주소</td>	<!--배송지주소-->
			    						<td GH="80 STD_DEPTID1" GCol="text,DEPTID1" GF="S 180">배송고객명</td>	<!--배송고객명-->
			    						<td GH="80 STD_DNAME1" GCol="text,DNAME1" GF="S 180">배송지전화번호</td>	<!--배송지전화번호-->
			    						<td GH="80 STD_USRID2" GCol="text,USRID2" GF="S 180">업무담당자</td>	<!--업무담당자-->
			    						<td GH="75 STD_DRIVER" GCol="input,DRIVER" GF="S 10">기사명</td>	<!--기사명-->
			    						<td GH="65 STD_DCMPNM" GCol="text,TRCMPY" GF="S 10">운송사</td>	<!--운송사-->
			    						<td GH="90 STD_RETRCP" GCol="select,RETRCP"><!--재배차운송사-->
											<select class="input" commonCombo="TRCMPY"><option></option></select>
			    						</td>
			    						<td GH="90 STD_FORKYN" GCol="select,FORKYN"><!--지게차사용여부-->
											<select class="input" commonCombo="FORKYN"><option></option></select>
			    						</td>
			    						<td GH="80 STD_ASKU05" GCol="text,ASKU05" GF="S 30">상온구분</td>	<!--상온구분-->
			    						<td GH="80 STD_RECAYN" GCol="text,RECAYN" GF="S 1">재배차 여부</td>	<!--재배차 여부-->
			    						<td GH="50 STD_PRESHP" GCol="text,PRESHP" GF="N 5,0">기배차수량</td>	<!--기배차수량-->
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_lit tableUtil">
						<button type='button' GBtn="find"></button>
						<button type='button' GBtn="sortReset"></button>
						<!-- 구버전은 추가 제거가 있으나 추가 제거 후 저장하면 shpdr에 shpoky/ shpoit가 복사되어 들어감 (shpdi.shpoky,shpdi.shpoit와 shpdr이 1:1 대응해야함 해당기능 구현하지 말것 -->
<!-- 						<button type='button' GBtn="add"></button> --> 
<!-- 						<button type='button' GBtn="delete"></button> -->
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