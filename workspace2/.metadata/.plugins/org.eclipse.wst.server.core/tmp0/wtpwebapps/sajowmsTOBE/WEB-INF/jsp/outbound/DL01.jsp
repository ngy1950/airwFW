<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DL01</title>
<%@ include file="/common/include/webdek/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/common/theme/webdek/css/demo_layout.css">
<script type="text/javascript">

	var GRPRL = 'ERPSO';
	var TOTALPICKING = 'N';
	var PROGID = 'DL01';
	var SHPOKYS = '';

	$(document).ready(function(){
		gridList.setGrid({
	    	id : "gridHeadList",
			module : "Outbound",
			command : "DL01_HEAD",
			pkcol : "OWNRKY,WAREKY",
			itemGrid : "gridItemList",
			itemSearch : true,
			tempItem : "gridItemList",
			useTemp : true,
		    tempKey : "SVBELN",
			menuId : "DL01"
	    });
		
		gridList.setGrid({
	    	id : "gridItemList",
			module : "Outbound",
			command : "DL01_ITEM",
			pkcol : "OWNRKY,WAREKY,SKUKEY",
			emptyMsgType : false,
		    tempKey : "SVBELN",
		    useTemp : true,
			tempHead : "gridHeadList",
			menuId : "DL01"
	    });
		
		$('#BTN_MNGLINK').hide()
		$('#BTN_DITLINK').hide()

		//OTRQDT 하루 더하기 
		inputList.rangeMap["map"]["IF.OTRQDT"].$from.val(dateParser(null, "SD", 0, 0, 1));
		inputList.rangeMap["map"]["IF.OTRQDT"].valueChange();
		
		//콤보박스 리드온리
		gridList.setReadOnly("gridHeadList", true, ["DIRDVY", "DIRSUP"]);
		gridList.setReadOnly("gridItemList", true, ["WAREKY"]);

		//화면 열시 자동으로 기본값을 세팅한다.(save varraiont 기본값이 있을경우에만 )
		setVarriantDef();

	});
	
	
	function searchList(){
		gridList.resetGrid("gridItemList");
		if(validate.check("searchArea")){
			var param = inputList.setRangeParam("searchArea");
			param.put('GRPRL', GRPRL)
			if (SHPOKYS != "") {
				$('#BTN_SAVECRE').hide()
				$('#BTN_ALLOCATE').hide()
				$('#BTN_ALLOCATE_ALL').hide()
				param.put('SHPOKYS',SHPOKYS);
							
				gridList.gridList({
			    	id : "gridHeadList",
			    	command : "DL01_HEAD_SAVED",
			    	param : param
			    });
				
				var head = gridList.getGridData("gridHeadList");
				if (head.length > 0){
					var shpokys = SHPOKYS.split(",");
					var svbeln = gridList.getColData("gridHeadList", gridList.getFocusRowNum("gridHeadList"), "SVBELN");
					var shpoky = shpokys[0].replace("'","").replace("'","");
					param.put('SHPOKY',shpoky);
					param.put('SVBELN',svbeln);
					gridList.gridList({
				    	id : "gridItemList",
				    	command : "DL01_ITEM_SAVED",
				    	param : param
				    });					
				}
				
			} else {
				$('#BTN_SAVECRE').show()
				$('#BTN_ALLOCATE').show()
				$('#BTN_ALLOCATE_ALL').show()
				$('#BTN_MNGLINK').hide()
				$('#BTN_DITLINK').hide()
				param.put('FLAG','IN');
				netUtil.send({
					url : "/outbound/json/displayHeadDL01.data",
					param : param,
					sendType : "list",
					bindType : "grid",  //bindType grid 고정
					bindId : "gridHeadList" //그리드ID
				});
			}
		}
	}
	
	function gridListEventItemGridSearch(gridId, rowNum, itemGridList){
		if(gridId == "gridHeadList"){
			var rowData = gridList.getRowData(gridId, rowNum);
			var param = inputList.setRangeParam("searchArea");
			param.put('PROGID',PROGID)
			param.put('SHPOKYS',SHPOKYS);
	//		param.put('TOTALPICKING',TOTALPICKING)
			param.putAll(rowData);
			if (SHPOKYS == ''){		
				gridList.gridList({
			    	id : "gridItemList",
			    	param : param
			    });
			} else {
				gridList.gridList({
			    	id : "gridItemList",
			    	command : "DL01_ITEM_SAVED",
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
					//납품요청수량과 원주문수량 비고
			  		if(Number(gridList.getColData(gridId, rowNum, "QTALLM")) > Number(gridList.getColData(gridId, rowNum, "QTYORG"))){
						alert("* 지시요청수량이 원주문수량보다 큽니다. *");
						gridList.setColValue(gridId, rowNum, "QTSHPO", 0);
					}

			  		qtshpo = Number(gridList.getColData(gridId, rowNum, "QTSHPO"));
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
					boxqty = colValue;
					remqty = Number(gridList.getColData(gridId, rowNum, "REMQTY"));
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
		
	function CreateOrderDocData(){		
		
        var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getSelectData("gridItemList");
        //아이템 템프 가져오기
        var tempItem = gridList.getTempData("gridHeadList");
          
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}

		validateSave();
		
       var param = new DataMap();
		param.put("head",head);
		param.put("item",item);
		param.put("itemTemp",tempItem);

		netUtil.send({
			url : "/outbound/json/createOrderDocDL01.data",
			param : param,
			successFunction : "successSaveCallBack"
		});
 	}

	function allocate(){		
			
        var head = gridList.getSelectData("gridHeadList");
        var item = gridList.getSelectData("gridItemList");
        
        //아이템 템프 가져오기
        var tempItem = gridList.getSelectTempData("gridHeadList");
          
		if(head.length == 0){
			commonUtil.msgBox("SYSTEM_ROWSEMPTY");
			return;
		}
		
		validateSave();
		
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
	
	function allocateAll(){	
		
		if(confirm("할당 하시겠습니까?")) {
			gridList.checkAll("gridHeadList",true);
			allocate();
		}
 	}
	
	function validateSave() {
        var head = gridList.getSelectData("gridHeadList");
		for(var i=0; i<head.length; i++){
			var docdat = head[i].get("DOCDAT");
			if(docdat.trim() == ""){
				commonUtil.msgBox("VALID_M0007");
				gridList.setColFocus("gridHeadList", head[i].get("GRowNum"), "DOCDAT");
				return;
			}
		}
	}
	
	function successSaveCallBack(json, status){
		if(json && json.data){
			if(json.data != ""){
				//템프 초기화
				gridList.resetTempData("gridHeadList");
				
				commonUtil.msgBox("SYSTEM_SAVEOK");
				SHPOKYS = json.data;
				$('#BTN_MNGLINK').show()
				$('#BTN_DITLINK').show()

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
	
	function DL32Link(){	
		var head = gridList.getSelectData("gridHeadList");
		if (head.length > 1){
			commonUtil.msgBox("* 작업자지정출고(긴급)의 경우는 1 건씩 처리 가능합니다. * ");
		}
		var ownrky = $('#OWNRKY').val();
		var wareky = $('#WAREKY').val();
		var shpoky = head[0].map.SHPOKY;

		var rowData = new DataMap();
	    rowData.put("OWNRKY",ownrky);  
	    rowData.put("WAREKY",wareky); 
	    rowData.put("SHPOKY",shpoky); 
	    rowData.put("GRPRL","ERPSO"); //GRPRL1
	    page.linkPageOpen("DL32", rowData , true);
 	}
	
	function commonBtnClick(btnName){
		if(btnName == "Search"){
			SHPOKYS = '';
			searchList();
		}else if(btnName == "Create"){
			CreateOrderDocData();
		}else if(btnName == "allocate"){
			allocate();
		}else if(btnName == "allocateAll"){
			allocateAll();
		}else if(btnName == "DL30Link"){
			DL30Link();		
		}else if(btnName == "DL32Link"){
			DL32Link();		
		}else if(btnName == "Reload"){	
			reload(); 
		}else if(btnName == "Savevariant"){
			sajoUtil.openSaveVariantPop("searchArea", "DL01");
		}else if(btnName == "Getvariant"){
			sajoUtil.openGetVariantPop("searchArea", "DL01");
		}
	}
	
	//서치헬프 기본값 세팅
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
        var param = new DataMap();
        
        // 거래처담당자 주소검색
        if(searchCode == "SHCMCDV" && $inputObj.name == "I.WAREKY"){
            param.put("CMCDKY","WAREKY");
            param.put("OWNRKY","<%=ownrky %>");
        	
        }else if(searchCode == "SHDOCTMIF"){
        	//nameArray 미존재
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "IF.DIRSUP"){
            param.put("CMCDKY","PGRC03");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "IF.DIRDVY"){
            param.put("CMCDKY","PGRC02");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "PTNG08"){
            param.put("CMCDKY","PTNG08");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "IF.PTNRTO"){
            param.put("PTNRTY","0007");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHBZPTN" && $inputObj.name == "IF.PTNROD"){
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
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "IF.WARESR"){
            param.put("CMCDKY","WARESR");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "SM.SKUG05"){
            param.put("CMCDKY","SKUG05");
            param.put("OWNRKY","<%=ownrky %>");
        }else if(searchCode == "SHCMCDV" && $inputObj.name == "ASKU02"){
            param.put("CMCDKY","ASKU02");
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
	
	 //데이터가 바인드된후 
    function gridListEventDataBindEnd(gridId, dataLength, excelLoadType){
       if(gridId=="gridHeadList"){

          gridList.setReadOnly("gridHeadList", true, ["PGRC04", "DIRSUP", "DIRDVY"]);
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
					<input type="button" CB="Create SAVE BTN_SAVECRE" id="BTN_SAVECRE"/>
					<input type="button" CB="allocate SAVE BTN_ALLOCATE" id="BTN_ALLOCATE"/>
					<input type="button" CB="allocateAll SAVE BTN_ALLOCATE_ALL" id="BTN_ALLOCATE_ALL"/>
					<input type="button" CB="DL30Link DL30_LINK BTN_MNGLINK" id="BTN_MNGLINK"/>
					<input type="button" CB="DL32Link DL32_LINK BTN_DITLINK" id="BTN_DITLINK"/>
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
					<dl>  <!--영업(D/O) -->
						<dt CL="STD_SALES_DO"></dt>
						<dd>
							<input type="radio" class="input" name="SALES_DO" checked style="margin:0;"/> 
						</dd>
					</dl>
					<dl>  <!--출고일자-->  
						<dt CL="IFT_ORDDAT"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.ORDDAT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문일자-->  
						<dt CL="STD_CTODDT"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.ERPCDT" UIInput="B" UIFormat="C"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고요청일-->  
						<dt CL="IFT_OTRQDT"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.OTRQDT" UIInput="B" UIFormat="C N"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문/출고형태-->  
						<dt CL="IFT_ORDTYP"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.ORDTYP" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--S/O 번호-->  
						<dt CL="IFT_SVBELN"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.SVBELN" UIInput="SR"/> 
						</dd> 
					</dl> 
					<dl>  <!--출고유형-->  
						<dt CL="IFT_DOCUTY"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.DOCUTY" UIInput="SR,SHDOCTMIF"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처코드-->  
						<dt CL="IFT_PTNRTO"></dt> 
						<dd> 
							<input type="text" class="input" name="PTNRTO" UIInput="SR,SHBZPTN"/> 
						</dd> 
					</dl> 
					<dl>  <!--납품처명-->  
						<dt CL="IFT_PTNRTONM"></dt> 
						<dd> 
							<input type="text" class="input" name="BZ.NAME01" UIInput="SR"/> 
						</dd> 
					</dl> 
				
					<dl>  <!--요청사업장-->  
						<dt CL="STD_IFPGRC04"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.WARESR" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
<!--요청사업장명 --> 
<!--구버전에도 에러나는 필드로 임시로 제외 : 2021.05.15			
					<dl>  
						<dt CL="STD_IFPGRC04N"></dt> 
						<dd> 
							<input type="text" class="input" name="BZP.NAME01" UIInput="SR"/> 
						</dd> 
					</dl>
-->  
					<dl>  <!--차량번호-->  
						<dt CL="STD_CARNUM"></dt> 
						<dd> 
							<input type="text" class="input" name="C.CARNUM" UIInput="SR,SHCARMA2"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품코드-->  
						<dt CL="IFT_SKUKEY"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.SKUKEY" UIInput="SR,SHSKUMA"/> 
						</dd> 
					</dl> 
					<dl>  <!--제품용도-->  
						<dt CL="STD_SKUG05"></dt> 
						<dd> 
							<input type="text" class="input" name="SM.SKUG05" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--주문구분-->  
						<dt CL="IFT_DIRSUP"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.DIRSUP" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--배송구분-->  
						<dt CL="IFT_DIRDVY"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.DIRDVY" UIInput="SR,SHCMCDV"/> 
						</dd> 
					</dl> 
					<dl>  <!--원주문수량-->  
						<dt CL="STD_QTSORG"></dt> 
						<dd> 
							<input type="text" class="input" name="IF.QTYORG" UIInput="SR"/> 
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
									<!--화면에 조회 값과 상관없이 로우 선택하는 체크박스 확인   -->
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_SHPOKY" GCol="text,SHPOKY" GF="S 10">출고문서번호</td>	<!--출고문서번호-->
			    						<td GH="100 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="50 STD_WAREKY" GCol="text,WAREKY" GF="S 10">거점</td>	<!--거점-->
			    						<td GH="50 STD_STATDO" GCol="text,STATDO" GF="S 4">문서상태</td>	<!--문서상태-->
			    						<td GH="80 STD_STATDONM" GCol="text,STATDONM" GF="S 20">문서상태명</td>	<!--문서상태명-->
			    						<td GH="80 STD_WAREKYNM" GCol="text,WAREKYNM" GF="S 20">거점명</td>	<!--거점명-->
			    						<td GH="50 STD_SHPMTY" GCol="text,SHPMTY" GF="S 4">출고유형</td>	<!--출고유형-->
			    						<td GH="80 STD_SHPMTYNM" GCol="text,SHPMTYNM" GF="S 20">문서타입명</td>	<!--문서타입명-->
			    						<td GH="100 STD_DOCDAT" GCol="text,DOCDAT" GF="D 8">문서일자</td>	<!--문서일자-->
			    						<td GH="50 STD_RQSHPD" GCol="text,RQSHPD" GF="D 8">출고요청일자</td>	<!--출고요청일자-->
			    						<td GH="70 IFT_PTNRTO" GCol="text,DPTNKY" GF="S 20">납품처코드</td>	<!--납품처코드-->
			    						<td GH="80 IFT_PTNRTONM" GCol="text,DPTNKYNM" GF="S 50">납품처명</td>	<!--납품처명-->
			    						<td GH="80 STD_PGRC01" GCol="text,PGRC01" GF="S 20">권역</td>	<!--권역-->
			    						<td GH="50 STD_DOCTXT" GCol="text,DOCTXT" GF="S 100">비고</td>	<!--비고-->
			    						<td GH="80 IFT_BOXQTYORG" GCol="text,ITEMCOUNT" GF="N 13,1">원주문수량(BOX)</td>	<!--원주문수량(BOX)-->
			    						<td GH="80 IFT_BOXQTYREQ" GCol="text,QTAPPO" GF="N 13,1">납품요청수량(BOX)</td>	<!--납품요청수량(BOX)-->
			    						<td GH="50 STD_RQARRD" GCol="text,RQARRD" GF="D 8">주문일자</td>	<!--주문일자-->			    						
			    						<td GH="200 STD_IFPGRC04" GCol="select,PGRC04">
			    							<select class="input" CommonCombo="PTNG05"></select> <!--요청사업장-->
			    						</td> 
			    						<td GH="80 STD_IFUNAME4" GCol="text,UNAME4" GF="S 100">영업사원명</td>	<!--영업사원명-->
			    						<td GH="80 STD_IFDNAME4" GCol="text,DNAME4" GF="S 100">영업사원연락처</td>	<!--영업사원연락처-->
			    						<td GH="90 IFT_DIRDVY" GCol="select,DIRDVY"><!--배송구분-->
												<select class="input" commonCombo="PGRC02"></select>
			    						</td>
			    						<td GH="90 IFT_DIRSUP" GCol="select,DIRSUP"><!--주문구분-->
												<select class="input" commonCombo="PGRC03"></select>
			    						</td>
			    						<td GH="80 STD_IFUNAME1" GCol="text,UNAME1" GF="S 100">배송지주소</td>	<!--배송지주소-->
			    						<td GH="80 STD_IFDEPTID1" GCol="text,DEPTID1" GF="S 100">배송고객명</td>	<!--배송고객명-->
			    						<td GH="80 STD_IFDNAME1" GCol="text,DNAME1" GF="S 100">배송자번화번호1</td>	<!--배송자번화번호1-->
			    						<td GH="80 STD_IFUSRID2" GCol="text,USRID2" GF="S 100">업무담당자</td>	<!--업무담당자-->
			    						<td GH="80 STD_IFNAME02" GCol="text,USRID1" GF="S 20">배송지 우편번호</td>	<!--배송지 우편번호-->
			    						<td GH="50 STD_DOCCAT" GCol="text,DOCCAT" GF="S 4">문서유형</td>	<!--문서유형-->
			    						<td GH="80 STD_DOCCATNM" GCol="text,DOCCATNM" GF="S 20">문서유형명</td>	<!--문서유형명-->
			    						<td GH="80 STD_OWNRKY" GCol="text,OWNRKY" GF="S 10">화주</td>	<!--화주-->
			    						<td GH="50 STD_RQARRT" GCol="text,RQARRT" GF="T 6">지시시간</td>	<!--지시시간-->
			    						<td GH="70 STD_SOLDTO" GCol="text,PTRCVR" GF="S 20">매출처/요청거점</td>	<!--매출처/요청거점-->
			    						<td GH="80 STD_SOLDTONM" GCol="text,PTRCVRNM" GF="S 50">매출처명/거점명</td>	<!--매출처명/거점명-->
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
										<td GH="40" GCol="rowCheck"></td>
										<td GH="40 STD_NUMBER"           GCol="rownum">1</td>   
			    						<td GH="80 STD_SHPOIT" GCol="text,SHPOIT" GF="S 6,0">출고문서아이템</td>	<!--출고문서아이템-->
			    						<td GH="80 STD_STATIT" GCol="text,STATIT" GF="S 20">상태</td>	<!--상태-->
			    						<td GH="80 STD_ALSTKY" GCol="select,ALSTKY"><!--할당전략키-->
												<select class="input" Combo="SajoCommon,ALSTKY_COMCOMBO"></select>
			    						</td>	
			    						<td GH="120 STD_SKUKEY" GCol="text,SKUKEY" GF="S 120">제품코드</td>	<!--제품코드-->
			    						<td GH="120 STD_DESC01" GCol="text,DESC01" GF="S 120">제품명</td>	<!--제품명-->
			    						<td GH="120 STD_DESC02" GCol="text,DESC02" GF="S 120">규격</td>	<!--규격-->
			    						<td GH="70 STD_UOMKEY" GCol="text,UOMKEY" GF="S 3">단위</td>	<!--단위-->
			    						<td GH="70 STD_QTYPRE" GCol="text,QTYPRE" GF="N 20,0">선입고수량</td>	<!--선입고수량-->
			    						<td GH="70 STD_QTSORG" GCol="text,QTYORG" GF="N 20,0">원주문수량</td>	<!--원주문수량-->
			    						<td GH="70 STD_QTSHPO" GCol="input,QTSHPO" GF="N 20,0">지시수량</td>	<!--지시수량-->
			    						<td GH="80 STD_PLIQTY" GCol="text,PLIQTY" GF="S 17" style="text-align:right;" >팔렛당수량</td>	<!--팔렛당수량-->
			    						<td GH="80 STD_PLTQTY" GCol="text,PLTQTY" GF="N 17,2">팔레트수량</td>	<!--팔레트수량-->
			    						<td GH="80 STD_BXIQTY" GCol="text,BXIQTY" GF="S 17" style="text-align:right;" >박스입수</td>	<!--박스입수-->
			    						<td GH="80 STD_BOXQTY" GCol="input,BOXQTY" GF="N 17,1">박스수량</td>	<!--박스수량-->
			    						<td GH="80 STD_REMQTY" GCol="input,REMQTY" GF="N 17,0">잔량</td>	<!--잔량-->
			    						<td GH="70 STD_QTUALO" GCol="text,QTUALO" GF="N 20,0">미할당수량</td>	<!--미할당수량-->
			    						<td GH="70 STD_QTALOC" GCol="text,QTALOC" GF="N 20,0">할당수량</td>	<!--할당수량-->
			    						<td GH="80 STD_SVBELN" GCol="text,SVBELN" GF="S 40">S/O 번호</td>	<!--S/O 번호-->
			    						<td GH="80 STD_SPOSNR" GCol="text,SPOSNR" GF="S 6">주문번호(D/O) item</td>	<!--주문번호(D/O) item-->
			    						<td GH="100 STD_DOCTXT" GCol="text,NAME01" GF="S 180">비고</td>	<!--비고-->
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