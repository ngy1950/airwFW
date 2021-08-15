 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<style type="text/css">
	.colInfo{width: 100%;height: 35px;}
	.colInfo ul{width: 350px;height: 100%;float: right;font-weight: bold;color: #6490FF;}
	.colInfo ul li{padding-bottom: 7px;}
</style>
<script language="JavaScript" src="/common/js/head-w.js"> </script>
<script language="JavaScript" src="/common/js/ezgencontrol.js"> </script>
<script type="text/javascript">
	midAreaHeightSet = "300px";
	var todayDate;
	var rcptty;
	var saveAsndky = "";
	var saveyn = false;
	var row = -1;
	$(document).ready(function(){
		
		gridList.setGrid({
			id : "gridHeadList",
			editable : true,
			module : "WmsInbound",
			command : "GR01H",
			autoCopyRowType : false,
			itemGrid : "gridItemList",
			itemSearch : true
		});
		
		gridList.setGrid({
			id : "gridItemList",
			editable : true,
			module : "WmsInbound",
			command : "GR01I",
			autoCopyRowType : false,
			headGrid : "gridHeadList",
			totalCols : ["QTYASN","QTYORG","QTYRCV","RCVQTY","RCVUOM","PRCQTY","QTVIWE"]
		});
		
		gridList.setGrid({
			id : "gridSubList",
			editable : true,
			module : "WmsInbound",
			command : "GR01SUB",
			autoCopyRowType : false,
			emptyMsgType : false
		});
		
		init();
	});
	
	function init(){
		//그리드 컬럼 리드온리
		gridList.setReadOnly("gridItemList", true, ["ENDMAK"]);
		
		$("#STATUS").val("NEW"); //검색조건 입고상태 : 미작업
		$("#ENDMAK").val("N"); //검색조건 마감여부 : 미마감
		
		//오늘날짜
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();
		
		if( dd < 10 ) {dd ='0' + dd;} 
		if( mm < 10 ) {mm = '0' + mm;}
		
		todayDate = String(yyyy) + String(mm) + String(dd);
	}
	
	
	// 공통 버튼 클릭 이벤트
	function commonBtnClick(btnName){
		if( btnName == "Search" ){ //조회
			searchList();
			
		}else if( btnName == "Save" ){ //저장
			saveData("A");
		
		}else if( btnName == "asdSave" ){ //입고완료
			saveData("asdSave");
			
		}else if( btnName == "asdEnd" ){ //마감완료
			saveData("asdEnd");
		
		}else if( btnName == "asdCancel" ){ //입고불가상품
			var param = inputList.setRangeDataParam("searchArea");
			param.put("WAREKY", "<%=wareky%>");
			param.put("USERID", "<%=userid%>");
			param.put("PROGID", "GR01"); 
			
			page.linkPopOpen("/wms/inbound/POP/GR01POP.page", param);
		
		}else if( btnName == "asdLabel" ){ //입고라벨
			print("label");
			
		}else if( btnName == "asdList" ){ //입고리스트notinList
			print("list");
		
		}else if( btnName == "notinList" ){ //미입고상품리스트
			print("notinlist");
		
		}else if( btnName == "Reflect" ){ //입고수량 일괄적용
			reflectAllPrcQty();
		}
	}
	
	//헤더 조회 
	function searchList(){
		if( validate.check("searchArea") ){
			var param = inputList.setRangeMultiParam("searchArea");
			param.put("ASNTYP", $.trim(param.get("ASNTYP")));
			rcptty = param.get("RCPTTY");
			
			gridList.gridList({
				id : "gridHeadList",
				param : param
			});
		}
	}
	
	//헤더 재 조회 
	function reSearchList(data){
		var param = new DataMap();
		param.put("SEBELN", data);
		param.put("WAREKY", "<%=wareky%>");
		param.put("RESERCH", "OK");
		
		gridList.gridList({
			id : "gridHeadList",
			param : param
		});
	}
	
	// 그리드 item 조회 이벤트
	function gridListEventItemGridSearch(gridId, rowNum, itemList){
		var param = inputList.setRangeMultiParam("searchArea");
		var rowData = gridList.getRowData(gridId, rowNum);
		rowData.put("ASDCANCEL", param.get("ASDCANCEL")); //ASDCANCEL 입고불가대상 제외
		rowData.put("ENDMAK", param.get("ENDMAK"));
		rowData.put("ZROQTY", param.get("ZROQTY"));
		
		gridList.gridList({
			id : "gridItemList",
			param : rowData
		});
		
		gridList.gridList({
			id : "gridSubList",
			param : rowData
		});
	}
	
	//저장
	function saveData(saveFlag){
		var head = gridList.getSelectData("gridHeadList", "A");
		var headLen = head.length;
		var item = gridList.getSelectData("gridItemList", "A");
		var itemLen = item.length;
		var param = new DataMap();
		var date_flag = "";
		var Acnt = 0;
		
		if( headLen == 0 ){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return;
		}
		
		if( itemLen == 0 ){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return;
		}
		
		if( headLen > 1 ){ //헤더 두개이상 선택시
			var sameAsndky;
			var itemAsndky = item[0].get("ASNDKY");
			for( var i=0; i<headLen; i++ ){
				var headAsndky = head[i].get("ASNDKY");
				if( headAsndky == itemAsndky ){
					sameAsndky = [head[i]];
				}
			}
			param.put("head", sameAsndky);
			
		}if( headLen == 1 ){
			param.put("head", head);
			
		}
		
		saveAsndky = head[0].get("ASNDKY"); //저장 후 로우 이동 키
		
		param.put("item", item);
		param.put("HHTTID", "WEB");
		param.put("saveFlag", saveFlag);
		
		//저장버튼
		if( saveFlag == "A" ){
			if( !commonUtil.msgConfirm("IN_M0011") ){ //주의 : 입고는 진행되지 않습니다. 저장하시겠습니까? 
				return false;
			}
			
		}else if( saveFlag != "A" ){
			var msgText;
			if( saveFlag == "asdSave" ){
				msgText = "입고완료";
			}else if( saveFlag == "asdEnd" ){
				msgText = "마감완료";
			}
			
			//입고통제일 확인 입고완료, 마감완료
			var dateValid = 0;
			var dateValidSku = "";
			for( var i=0; i<itemLen; i++ ){
				var mngmov = item[i].get("MNGMOV"); //locma 유통기한 관리여부
				var usarg3 = item[i].get("USARG3"); //cmcdw 유통기한 관리여부
				var lotl01 = item[i].get("LOTL01"); //skuma 유통기한 관리여부
				var lotl02 = item[i].get("LOTL02");
				var lota08 = item[i].get("LOTA08"); //제조일자
				var lota09 = item[i].get("LOTA09"); //유통기한
				var skukey = item[i].get("SKUKEY");
				var locaky = item[i].get("LOCAKY");
				var qtyorg = Number(item[i].get("QTYORG"));
				var qtviwe = Number(item[i].get("QTVIWE"));
				
				//피킹로케이션 또는 물류분류 지정해주세요.
				if( qtviwe != 0 && $.trim(locaky) == "" ){
					commonUtil.msgBox("IN_M9033");
					return false;
				}
				
				//유통기한 필수입력 상품입니다.
				if( qtviwe != 0 && mngmov == "0" && usarg3 == "Y" && lotl01 == "Y" ){
					if( $.trim(lota09) == "" ){
						commonUtil.msgBox("IN_M0012");
						return false;
					}
				}
				
				//lotl02(입고기준구분코드) 입고 통제일 조회
				if( lotl01 == "Y" && lotl02 == "1" || lotl01 == "Y" && lotl02 == "2" ){
					if( $.trim(lota09) != "" ){
						var rcvParam = new DataMap();
						rcvParam.put("LOTA08", lota08);
						rcvParam.put("LOTA09", lota09);
						rcvParam.put("SKUKEY", skukey);
						
						//입고통제일 확인
						var json = netUtil.sendData({
							module : "WmsInbound",
							command : "RCV_DAT",
							sendType : "map",
							param : rcvParam
						});
						
						if( json.data["DAT_FLAG"] != "OK" ){
							dateValid++;
							dateValidSku = skukey;
							
						}
					}
					
				}
				
				// 입고예정(QTYORG) > 입고수량(QTVIWE)
				// 102도 부분입고 허용되며 주석처리
				//if( rcptty == "102" && (qtyorg > qtviwe) ){
				//	Acnt ++;
				//}
			}
			
			//입고통제일 1건 이상 조회시 경고
			if( dateValid > 0 ){
				if( !confirm("상품코드["+ dateValidSku +"]는 입고통제일 기준에 미달합니다. 그래도 "+ msgText +" 진행하시겠습니까?") ){
					return false;
				}else{
					date_flag = "Y";
				}
			}
		}
		
		
		if( saveFlag == "asdSave" ){//입고완료
			if( gridList.validationCheck("gridItemList", "select") ){
				
				if( Acnt > 0 ){
					//미입고된 수량은 자동반품되며 취소가 불가능합니다. 그래도 입고진행하시겠습니까?
					if( !commonUtil.msgConfirm("IN_M0005") ){
						return false;
					}
				}else if ( date_flag != "Y" ){
					//입고완료 하시겠습니까?
					if( !commonUtil.msgConfirm("IN_M0014") ){
						return false;
					}
				}
			}else{
				return false;
			}
		
		}else if( saveFlag == "asdEnd" ){//마감완료
			if ( date_flag != "Y" ){
				if( !commonUtil.msgConfirm("IN_M0016") ){ //주의 : 현 입력수량을 제외한 기입고 수량으로 마감되며, 다시 입고하실 수 없습니다.
					return false;
				}
			}
		}
		
		netUtil.send({
			url : "/wms/inbound/json/SaveGR01.data",
			param : param,
			successFunction : "succsessSaveCallBack"
		});
		
		
	}
	
	function succsessSaveCallBack(json,status){
		if( json && json.data ){
			var data = json.data;
			
			if( data ){
				commonUtil.msgBox(data.msg);
				gridList.resetGrid("gridHeadList");
				gridList.resetGrid("gridItemList");
				
				//저장건 재조회
				if(data.reKey == "OK"){
// 					reSearchList(data.key);
					saveyn = true;
					searchList();
				}
				
			}else if( !data ){
				commonUtil.msgBox("MASTER_M0101"); //저장에 실패 하였습니다. 관리자에게 문의 하세요. 내역:[{0}]
			}
		}
	}
	
	// 그리드 데이터 변경 후 이벤트
	function gridListEventColValueChange(gridId, rowNum, colName, colValue){
		var ItemData = gridList.getRowData(gridId, rowNum);
		
		if( gridId == "gridItemList" ){
			if( colName == "PRCUOM" ){//////////////////////////////////////단위////////////////////////////////
				gridList.setColValue(gridId, rowNum, "PRCQTY", 0); //수량
				gridList.setColValue(gridId, rowNum, "QTVIWE", 0); //입고수량
				
			}else if( colName == "PRCQTY" ){////////////////////////////////수량////////////////////////////////
				
				var NumColValue = Number(colValue);
				var rcvqty = Number(ItemData.get("RCVQTY")); //입고가능 (낱개) 수량
				var prcuom = ItemData.get("PRCUOM"); //단위
				
				//음수 입력 불가
				if( NumColValue <= 0 ){
					colChangeNum(gridId, rowNum, "N");
					return false;
				}
				
				//수량 계산
				if( prcuom == "EA" ){
					gridList.setColValue(gridId, rowNum, "QTVIWE", NumColValue); //실수량
					
					if( NumColValue > rcvqty ){
						colChangeNum(gridId, rowNum, "S");
						return false;
					}
					
				}else if( prcuom == "CS" ){//박스
					var csQty = Number(ItemData.get("BOXQTY")) * NumColValue;
					if( csQty == 0 ){
						colChangeNum(gridId, rowNum, "N");
						return false;
					}
					
					if( csQty > rcvqty ){
						colChangeNum(gridId, rowNum, "S");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTVIWE", csQty); //입고수량
					
				}else if( prcuom == "IP" ){ //이너팩
					var ipQty = Number(ItemData.get("INPQTY")) * NumColValue;
					if( ipQty == 0 ){
						colChangeNum(gridId, rowNum, "N");
						return false;
					}
					
					if( ipQty > rcvqty ){
						colChangeNum(gridId, rowNum, "S");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTVIWE", ipQty); //입고수량
					
				}else if( prcuom == "PL" ){ //팔레트
					var plQty = Number(ItemData.get("PALQTY")) * NumColValue;
					if( plQty == 0 ){
						colChangeNum(gridId, rowNum, "N");
						return false;
					}
					
					if( plQty > rcvqty ){
						colChangeNum(gridId, rowNum, "S");
						return false;
					}
					
					gridList.setColValue(gridId, rowNum, "QTVIWE", plQty); //입고수량
				}
			}else if ( colName == "SKUKEY" ){ ////////////////////////////////상품코드////////////////////////////////
				//컬럼초기화
				if( $.trim(colValue) == "" ){
					skukeyColChangeInit(gridId, rowNum, colName);
					return false;
				}
				
				var param = new DataMap();
				param.put("WAREKY", ItemData.get("WAREKY"));
				param.put("OWNRKY", ItemData.get("OWNRKY"));
				param.put("LOTA06", ItemData.get("LOTA06"));
				param.put("SKUKEY", colValue);
				param.put("EANCOD", ItemData.get("ASNSKU")); //상품유효성검사시 필요
				
				//입고상품코드 유효성 검사
				var skuJson = netUtil.sendData({
					module : "WmsInbound",
					command : "EANCODYN",
					sendType : "count",
					param : param
				}); 
				
				if( skuJson.data == 0 ){
					alert("입고상품코드[ " + colValue + " ]는 입고불가능한 상품입니다. 해당 상품에 유효한 상품을 입력해주세요.");
					skukeyColChangeInit(gridId, rowNum, colName);
					return false;
				}
				
				//상품상세조회
				var json = netUtil.sendData({
					module : "WmsInbound",
					command : "GR01SKUKEY",
					sendType : "list",
					param : param
				});
				
				if( json && json.data ){
					var data = json.data;
					var dataLen = data.length;
					
					if( dataLen > 0 ){
						gridList.setColValue(gridId, rowNum, "DESC01", data[0].DESC01);
						gridList.setColValue(gridId, rowNum, "DESC02", data[0].DESC02);
						gridList.setColValue(gridId, rowNum, "LOCAKY", data[0].LOCAKY);
						gridList.setColValue(gridId, rowNum, "SKUCLS", data[0].SKUCLS);
						gridList.setColValue(gridId, rowNum, "ABCANV", data[0].ABCANV);
						gridList.setColValue(gridId, rowNum, "LOTL01", data[0].LOTL01);
						gridList.setColValue(gridId, rowNum, "DUEMON", data[0].DUEMON);
						gridList.setColValue(gridId, rowNum, "DUEDAY", data[0].DUEDAY);
						gridList.setColValue(gridId, rowNum, "BOXQTY", data[0].BOXQTY);
						gridList.setColValue(gridId, rowNum, "INPQTY", data[0].INPQTY);
						gridList.setColValue(gridId, rowNum, "PALQTY", data[0].PALQTY);
						gridList.setColValue(gridId, rowNum, "SKUPACK", data[0].SKUPACK);
						gridList.setRowCheck(gridId, rowNum, true);
						
						if( data[0].LOTL01 == "Y" ){
							gridList.setRowReadOnly(gridId, rowNum, false, ["LOTA08", "LOTA09"]);
						}else if( data[0].LOTL01 == "N" ){
							gridList.setRowReadOnly(gridId, rowNum, true, ["LOTA08", "LOTA09"]);
						}
						
					}else if( json.data.length <= 0 ){
						alert("입고상품코드가 존재하지 않습니다.");
						skukeyColChangeInit(gridId, rowNum, colName);
					}
				}
				
			}else if ( colName == "LOTA08" ){ /////////////////////////////제조일자////////////////////////////////////////////
				// 오늘일자 < 제조일자
				if( todayDate < colValue ){
					commonUtil.msgBox("INV_M1018"); //제조일자는 오늘날짜보다 클 수 없습니다.
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "LOTA09", "");
					return false;
				}
				
				if( ItemData.get("DUEMON") == "0" && ItemData.get("DUEDAY") == "0" || $.trim(colValue) == "" ){
					commonUtil.msgBox("IN_M0027"); //유통기한 일수가 설정되어있지 않습니다.
					gridList.setColValue(gridId, rowNum, colName, "");
					gridList.setColValue(gridId, rowNum, "LOTA09", "");
					return false;
				}
				
				var param = new DataMap();
				param.put("ALOTA08", colValue);
				param.put("DUEMON", ItemData.get("DUEMON"));
				param.put("DUEDAY", ItemData.get("DUEDAY"));
				
				var json = netUtil.sendData({
					module : "WmsInventory",
					command : "SJ01DATE",
					sendType : "list",
					param : param
				});
				
				//일자체크
				if( json && json.data ){
					if( json.data[0].DUEDAY != colValue ){
						gridList.setColValue(gridId, rowNum, "LOTA09", json.data[0].DUEDAY);
					}
				}
				
			}else if ( colName == "LOTA09" ){ /////////////////////////////유통기한////////////////////////////////////////////
				if( $.trim(colValue) == "" ){
					gridList.setColValue(gridId, rowNum, "LOTA08", "");
					gridList.setColValue(gridId, rowNum, colName, "");
					return false;
				}
				
				gridList.setColValue(gridId, rowNum, "LOTA08", "");
				
// 				if( ItemData.get("DUEMON") == "0" && ItemData.get("DUEDAY") == "0" || $.trim(colValue) == "" ){
// 					commonUtil.msgBox("IN_M0027"); //유통기한 일수가 설정되어있지 않습니다.
// 					gridList.setColValue(gridId, rowNum, "LOTA08", "");
// 					gridList.setColValue(gridId, rowNum, colName, "");
// 					return false;
// 				}
				
// 				var param = new DataMap();
// 				param.put("ALOTA09", colValue);
// 				param.put("DUEMON", ItemData.get("DUEMON"));
// 				param.put("DUEDAY", ItemData.get("DUEDAY"));
				
// 				var json = netUtil.sendData({
// 					module : "WmsInventory",
// 					command : "SJ01DATE",
// 					sendType : "list",
// 					param : param
// 				});
				
// 				//일자체크
// 				if( json && json.data ){
					
// 					// 오늘일자 < 제조일자
// 					if( todayDate < json.data[0].DUEDAY ){
// 						commonUtil.msgBox("INV_M1018"); //제조일자는 오늘날짜보다 클 수 없습니다.
// 						gridList.setColValue(gridId, rowNum, colName, "");
// 						gridList.setColValue(gridId, rowNum, "LOTA08", "");
// 						return false;
// 					}
					
// 					if( json.data[0].DUEDAY != colValue ){
// 						gridList.setColValue(gridId, rowNum, "LOTA08", json.data[0].DUEDAY);
// 					}
// 				}
			}
		}
	}
	
	function skukeyColChangeInit(gridId, rowNum, colName){
		gridList.setColValue(gridId, rowNum, colName, "");
		gridList.setColValue(gridId, rowNum, "DESC01", "");
		gridList.setColValue(gridId, rowNum, "DESC02", "");
		gridList.setColValue(gridId, rowNum, "LOCAKY", "");
		gridList.setColValue(gridId, rowNum, "SKUCLS", "");
		gridList.setColValue(gridId, rowNum, "ABCANV", "");
		gridList.setColValue(gridId, rowNum, "LOTL01", "");
		gridList.setColValue(gridId, rowNum, "DUEMON", "");
		gridList.setColValue(gridId, rowNum, "DUEDAY", "");
		gridList.setColValue(gridId, rowNum, "BOXQTY", "");
		gridList.setColValue(gridId, rowNum, "INPQTY", "");
		gridList.setColValue(gridId, rowNum, "PALQTY", "");
		gridList.setColValue(gridId, rowNum, "SKUPACK", "");
	}
	
	//컬럼 초기화
	function colChangeNum(gridId, rowNum, select){
		gridList.setColValue(gridId, rowNum, "PRCQTY", "0"); //수량
		gridList.setColValue(gridId, rowNum, "QTVIWE", "0");
		
		if(select == "N"){
			commonUtil.msgBox("INV_M1011"); //수량은 0보다 커야합니다
			
		}else if( select == "S" ){
// 			commonUtil.msgBox("IN_M0017"); //수량(낱개)은 입고가능(낱개) 갯수보다 클 수 없습니다.
			commonUtil.msgBox("IN_M0032"); //입고가능수량보다 클 수 없습니다.
		}
	}
	
	// 그리드 데이터 바인드 전, 후 이벤트
	function gridListEventDataBindEnd(gridId, dataLength){
		if( gridId == "gridHeadList" && dataLength == 0 ){
			gridList.resetGrid("gridItemList");
			gridList.resetGrid("gridSubList");
		}else if( gridId == "gridHeadList" && dataLength > 0 ){
			if(!saveyn){
				row = 0;
			}else{
				row = findSavegridRow("gridHeadList", "ASNDKY", saveAsndky);
				setTimeout(function() {
					gridList.setColFocus("gridHeadList", row, "rownum");
					$("#gridHeadList tr[grownum="+row+"] td:eq(0)").trigger("dblclick");
				});
			}
		}else if( gridId == "gridItemList" && dataLength > 0 ){
			// 그리드 로우 리드온리
			for( var i=0; i<dataLength; i++ ){
				var rowData = gridList.getRowData(gridId, i);
				var lotl01 = rowData.get("LOTL01");
				var skukey = $.trim(rowData.get("SKUKEY"));
				var skuyn = rowData.get("SKUYN");
				var endmak = rowData.get("ENDMAK");
				var qtyrcv = Number(rowData.get("QTYRCV")); //기입고(낱개)
				var rcvuom = Number(rowData.get("RCVUOM")); //입고가능(발주)
				var rcvqty = Number(rowData.get("RCVQTY")); //입고가능(낱개)
				
				// 유통기한 관리 안하는 상품은 readonly
				if( lotl01 == "N" ){
					gridList.setRowReadOnly(gridId, i, true, ["LOTA08", "LOTA09"]);
				}
				
				// 사은품이 N이면 상품 || 기입고수량 > 0 이면 입고상품코드 은 readonly
				if( skuyn == "N" || qtyrcv > 0){
					gridList.setRowReadOnly(gridId, i, true, ["SKUKEY"]);
				}
				
				// 마감완료된 건 || 입고가능 갯수가 0이면 수정 불가
				if( endmak == "Y" || rcvuom == 0 && rcvqty == 0 ){
					gridList.setRowReadOnly(gridId, i, true, ["SKUKEY", "LOTA08", "LOTA09", "PRCQTY", "PRCUOM"]);
				}
				
				// 입고타입 = '103' 센터납 긴급일때 수량 수정불가
				if( rcptty == "103" ){
					//쿼리로 이동 --> 컬럼변경
					//gridList.setColValue(gridId, i, "PRCUOM", "EA");
					//gridList.setColValue(gridId, i, "PRCQTY", rcvqty);
					//gridList.setColValue(gridId, i, "QTVIWE", rcvqty);
					gridList.setRowReadOnly(gridId, i, true, ["PRCQTY", "PRCUOM"]);
				}
				
			}
			
			saveAsndky = "";
			saveyn = false;
		}
	}
	
	function findSavegridRow(gridId,colName,colVal){
		var list = gridList.getGridData(gridId,true);
		var rownum = 0;
		var filterList = list.filter(function(element,index,array){
			return colVal == element.get(colName);
		});
		if(filterList.length > 0){
			rownum = filterList[0].get(configData.GRID_ROW_NUM);
		}else{
			rownum = list[rownum].get(configData.GRID_ROW_NUM);
		}
		return rownum;
	}
	
	function searchHelpEventOpenBefore(searchCode, multyType, $inputObj, rowNum){
		if(searchCode == "SHLOTL04"){
			var param = new DataMap();
			var itemRowNum = gridList.getFocusRowNum("gridItemList");
			var asnsku = gridList.getColData("gridItemList", itemRowNum, "ASNSKU");
			var wareky = gridList.getColData("gridItemList", itemRowNum, "WAREKY");
			var ownrky = gridList.getColData("gridItemList", itemRowNum, "OWNRKY");
			
			param.put("EANCOD", asnsku);
			param.put("WAREKY", wareky);
			param.put("OWNRKY", ownrky);
			param.put("rowNum", rowNum);
			
			var option = "height=800,width=800,resizable=yes";
			page.linkPopOpen("/wms/inbound/POP/GR01_SKUKEY_POP.page", param, option);
			
			return false;
		}
	}
	
	// 팝업 클로징
	function linkPopCloseEvent(data){
		if( data.get("searchCode") == "SHLOTL04" ){
			gridList.setColValue("gridItemList", data.get("rowNum"), "SKUKEY", data.get("SKUKEY"));
			gridListEventColValueChange("gridItemList", data.get("rowNum"), "SKUKEY", data.get("SKUKEY"));
		}
	}
	
	// 선택 활성화 : 마감여부(ENDMAK) = 'N' 건만 입고 가능
	function gridListCheckBoxDrawBeforeEvent(gridId, rowNum){
		if( gridId == "gridItemList" ){
			var endmak = gridList.getColData(gridId, rowNum, "ENDMAK"); //마감여부
			var statdo = gridList.getColData(gridId, rowNum, "STATDO");
			
			if( endmak == "Y" || statdo == "FRV"){
				return true;
			}
		}
		
		return false;
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		param.put("WAREKY", "<%=wareky%>");
		
		if( comboAtt == "WmsCommon,ROLCTWAREKY" ){
			return param;
			
		}else if( comboAtt == "WmsCommon,DOCTMCOMBO" ){
			param.put("PROGID", "GR01");
			
			return param;
			
		}else if( comboAtt == "Common,COMCOMBO" ){
			var name = $(paramName).attr("name");
			
			if( name == "STATUS" ){
				param.put("CODE","RCVSTATDO");
				param.put("USARG1", "V");
				
			}else if( name == "PRCUOM" ){
				param.put("CODE", "UOMKEY");
				
			}else if( name == "ASNTYP" ){
				var rcptty = $("[name=RCPTTY]").val();
				param.put("CODE", "ASNTYP");
				param.put("USARG1", rcptty);
				
			}
			
			return param;
		}
	}
	
	function fn_changeArea(){
		inputList.reloadCombo($("[name=ASNTYP]"), configData.INPUT_COMBO, "Common,COMCOMBO", false);
	}
	
	//입고라벨 / 입고예정리스트 프린트
	function print(btnName){
		var head = gridList.getSelectData("gridHeadList");
		if ( head.length == 0 ){
			commonUtil.msgBox("VALID_M0006"); //선택된 데이터가 없습니다.
			return;
		}
		var param = dataBind.paramData("searchArea");
		param.put("PROGID", configData.MENU_ID);
		param.put("PRTCNT", 1);
		param.put("head", head);
		
		var json = netUtil.sendData({
			url : "/wms/inbound/json/printGR01.data",
			param : param
		});
		
		if( btnName == "list" ){
			if ( json && json.data ){
				var url =  "<%=systype%>" + "/input_gr01_list.ezg";
				var where = "AND PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				var width =  630;
				var heigth = 850;
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url, where, "", langKy, map, width, heigth);
				
			}
		}else if( btnName == "notinlist" ){
			if ( json && json.data ){
				var url =  "<%=systype%>" + "/noinbound_list.ezg";
				var where = "PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				var width =  850;
				var heigth = 630;
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url, where, "", langKy, map, width, heigth);
				
			}
		}else if(  btnName == "label" ){
			for(var i=0; i<head.length; i++){
				var loccnt = head[i].get("LOCCNT");
				if( loccnt == "Y" ){
					alert("입고불가상품이 존재합니다. 라벨출력이 불가합니다.");
					return false;
				}
			}
			
			if ( json && json.data ){
				var url = "<%=systype%>" + "/inbound_label.ezg"; //변경하기
				var where = "AND PL.PRTSEQ =" + json.data;
				//var langKy = "KR";
				var width =  316;
				var heigth = 203;
				var langKy = "KR";
				var map = new DataMap();
				WriteEZgenElement(url, where, "", langKy, map, width, heigth);
				
			}
		}
	}
	
	function reflectAllPrcQty(){
		var gridId = "gridItemList";
		
		var listLen = gridList.getGridDataCount(gridId);
		var list = gridList.getGridData(gridId, true);
		
		if(listLen > 0){
			var count = 0;
			
			var noSkukeyList = [];
			
			var reflectList = list.filter(function(element,index,array){
				var endMak = element.get("ENDMAK");
				var statdo = element.get("STATDO");
				
				return ((endMak != "Y") && (statdo != "FRV"));
			});
			
			var reflectListLen = reflectList.length;
			if(reflectListLen > 0){
				for(var i = 0; i < reflectListLen; i++){
					var row = reflectList[i];
					
					var rowNum = row.get("GRowNum");
					
					var skukey = row.get("SKUKEY");
					var orgPrc = row.get("ORG_PRCUOM");
					var prcuom = row.get("PRCUOM");
					var rcvbox = row.get("BXRCVQTY");
					var rcvqty = row.get("RCVQTY");
					
					if($.trim(skukey) == ""){
						count++;
					}else{
						if(orgPrc != prcuom){
							gridList.setColValue(gridId, rowNum, "PRCUOM", orgPrc);
						}
						
						if(orgPrc == "CS"){
							gridList.setColValue(gridId, rowNum, "PRCQTY", rcvbox);
							gridList.setColValue(gridId, rowNum, "QTVIWE", rcvqty);
						}else{
							gridList.setColValue(gridId, rowNum, "PRCQTY", rcvqty);
							gridList.setColValue(gridId, rowNum, "QTVIWE", rcvqty);
						}
						
						gridList.setRowCheck(gridId, rowNum, true);
					}
				}
				if(count > 0){
					commonUtil.msgBox("IN_M0033");
				}
			}else{
				commonUtil.msgBox("IN_M0034");
			}
		}else{
			commonUtil.msgBox("IN_M0035");
		}
	}
</script>
</head>
<body>

<div class="contentHeader">
	<div class="util">
		<button CB="Search SEARCH BTN_DISPLAY"></button>
		<button CB="asdSave REFLECT BTN_ASDFIN"></button>
		<button CB="asdEnd CLOSE BTN_ENDFIN"></button>
		<button CB="asdCancel NOTE BTN_ASDCAN"></button>
		<button CB="asdLabel PRINT BTN_ASDLAB"></button>
		<button CB="asdList PRINT BTN_ASDLIST"></button>
		<button CB="notinList PRINT BTN_NOTINLIST"></button>
		<button CB="Save SAVE BTN_RVSCSV"></button>
	</div>
</div>

<!-- content -->
<div class="content">
	<div class="innerContainer">
		<!-- contentContainer -->
		<div class="contentContainer">
		
			<div class="bottomSect top" style="height:150px" id="searchArea">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-1"><span CL='STD_SELECTOPTIONS'></span></a></li>
					</ul>
					<div id="tabs1-1">
						<div class="section type1">
								<table class="table type1">
									<colgroup>
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col width="250" />
										<col width="50" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th CL="STD_WAREKY"></th>
											<td>
												<select id="WAREKY" name="WAREKY" Combo="WmsCommon,ROLCTWAREKY" value="<%=wareky%>" disabled  UISave="false" ComboCodeView=false style="width:160px">
												</select>
											</td>
											<th CL="STD_ASDTTY">입고타입</th>
											<td>
												<select id="RCPTTY" name="RCPTTY" Combo="WmsCommon,DOCTMCOMBO" ComboCodeView=false UISave="false" style="width:160px" onchange="fn_changeArea();">
												</select>
											</td>
											<th CL="STD_RCPTTY">입고유형</th>
											<td>
												<select Combo="Common,COMCOMBO" name="ASNTYP" id="ASNTYP" comboType="C,Combo" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
										</tr>
										<tr>
											<th CL="STD_ASDDKY">공급사코드</th>
											<td>
												<input type="text" name="AO.DPTNKY" UIInput="SR" />
											</td>
											<th CL="STD_ASDSKU">발주상품코드</th>
											<td>
												<input type="text" name="AO.ASNSKU" UIInput="SR" />
											</td>
											<th CL="STD_ASDNUM">발주번호</th>
											<td>
												<input type="text" name="AO.SEBELN" UIInput="SR" />
											</td>
										</tr>
										<tr>
											<th CL="STD_RCPSTU">입고상태</th>
											<td>
												<select Combo="Common,COMCOMBO" name="STATUS" id="STATUS" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
												</select>
											</td>
											<th CL="STD_ENDMAK">마감여부</th>
											<td>
												<select id="ENDMAK" name="ENDMAK" ComboCodeView=false style="width:160px">
													<option value="">전체</option>
													<option value="N">미마감</option>
													<option value="Y">마감완료</option>
												</select>
											</td>
											<th CL="STD_ASDDAT">입고예정일자</th>
											<td>
												<input type="text" name="AO.DOCDAT" UIInput="B" UIFormat="C N" validate="required"  MaxDiff="M1"/>
											</td>
										</tr>
										<tr>
											<th CL="STD_ASDCAN">미등록 상품</th>
											<td>
												<input type="checkbox" name="ASDCANCEL" value="V" />
											</td>
											<th CL="STD_ZROQTY">입고 가능 상품</th>
											<td>
												<input type="checkbox" name="ZROQTY" value="V"/>
											</td>
										</tr>
									</tbody>
								</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="bottomSect bottom" style="top:110px;">
				<div class="tabs">
					<ul class="tab type2">
						<li><a href="#tabs1-3" ><span CL="STD_RECDLI"></span></a></li>
					</ul>
					<div id="tabs1-3">
						<div class="section type1">
							<div class="colInfo">
								<ul>
									<li>*미등록 상품 : 물류분류/피킹로케이션 미등록</li>
									<li>*상품 미지정 : 실 입고(연관상품) 상품이 선택되어 있지 않음</li>
								</ul>
							</div>
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridHeadList">
										<tr CGRow="true">
												<td GH="40"                GCol="rownum">1</td>
												<td GH="40"                GCol="rowCheck"></td>
												<td GH="100 STD_WAREKY"    GCol="text,WARENM"></td>
												<td GH="100 STD_ASDTTY"    GCol="text,RCTYNM"></td>
												<td GH="100 STD_RCPTTY"    GCol="text,ASNTNM"></td>
												<td GH="100 STD_ASDDAT"    GCol="text,DOCDAT"  GF="D"></td>
												<td GH="100 STD_ASDNUM"    GCol="text,SEBELN"></td>
												<td GH="100 STD_ASDDTY"    GCol="text,DPTYNM"></td>
												<td GH="140 STD_ASDDKY"    GCol="text,DPTNKY"></td>
												<td GH="240 STD_ASDDNM"    GCol="text,DPTNMST"></td>
												<td GH="100 STD_ASDCAN"    GCol="text,LOCCNT,center"></td>
												<td GH="100 STD_ANOSKU"    GCol="text,SKUCNT,center"></td>
												<td GH="100 STD_RCPSTU"    GCol="text,RCVSATANM"></td>
												<td GH="100 STD_ASNDKY,3"  GCol="text,ASNDKY"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
<!-- 													<button type="button" GBtn="total"></button> -->
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			
			<div class="bottomSect bottomT">
				<div class="tabs">
					<ul class="tab type2" id="commonMiddleArea2">
						<li><a href="#tabs1-4" ><span CL="STD_ITEMLIST"></span></a></li>
						<li><a href="#tabs1-5" ><span CL="STD_DTITEM"></span></a></li>
					</ul>
					<div id="tabs1-4">
						<div class="section type1">
							<div class="reflect" id="reflect">
								<button CB="Reflect ALLOCATE BTN_RLFRCV"></button>
							</div>
							<div class="table type2" style="top: 45px;">
								<div class="tableBody">
									<table>
										<tbody id="gridItemList">
										<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
												<td GH="40"               GCol="rowCheck"></td>
												<td GH="100 STD_RCPSTU"   GCol="text,RCVSATANM"></td>
												<td GH="100 STD_RCPTTY"   GCol="text,ASNTNM"></td>
												<td GH="130 STD_ASDSKU"   GCol="text,ASNSKU"></td>
												<td GH="240 STD_ASNTNM"   GCol="text,ASNDS1"></td>
												<td GH="130 STD_ASNSKU"   GCol="input,SKUKEY,SHLOTL04" validate="required"></td>
												<td GH="240 STD_ASNSNM"   GCol="text,DESC01"></td>
												<td GH="100 STD_SKUYN"    GCol="text,SKUYN"></td>
												<td GH="100 STD_LOCAKY"   GCol="text,LOCAKY"></td>
												<td GH="80 STD_SKUCNM"    GCol="text,SKCLNM"></td>
												<td GH="80 STD_ABCNM"     GCol="text,ABCANV"></td>
												
												<td GH="100 STD_BXASN"    GCol="text,BXASN"  GF="N">발주수량(박스)</td>
												<td GH="100 STD_BXORG"    GCol="text,BXORG"  GF="N">입고예정(박스)</td>
												<td GH="100 STD_QTYRBX"   GCol="text,BXRCV"  GF="N">입고완료(박스)</td>
												<td GH="100 STD_BXRCVQTY"   GCol="text,BXRCVQTY" GF="N">입고가능(박스)</td>
												
												<td GH="100 STD_QTYASN,3" GCol="text,QTYASN"  GF="N">발주수량(낱)</td>
												<td GH="100 STD_QTYOEA,3" GCol="text,QTYORG"  GF="N">입고예정(낱)</td>
												<td GH="100 STD_QTYREA,3" GCol="text,QTYRCV"  GF="N">입고완료(낱)</td>
												<td GH="100 STD_RCVQTY"   GCol="text,RCVQTY"  GF="N">입고가능(낱)</td>
												<td GH="100 STD_REALQTY"  GCol="text,REALQTY" GF="N"></td>
												<td GH="80 STD_UOMKEY"    GCol="select,PRCUOM" validate="required">
													<select Combo="Common,COMCOMBO" ComboCodeView=false name="PRCUOM">
														<option value="">선택</option>
													</select>
												</td>
												<td GH="80 STD_PRCQTY"    GCol="input,PRCQTY" GF="N 7" validate="required gt(0),MASTER_M4002"></td> <!--  -->
												<td GH="80 STD_QTYRCV"    GCol="text,QTVIWE"  GF="N"></td>
												<td GH="80 STD_LOTA06"    GCol="text,LO06NM"></td>
												<td GH="110 STD_LOTL01"   GCol="text,LOTL01"></td>
												<td GH="100 STD_LOTA08"   GCol="input,LOTA08" GF="C"></td>
												<td GH="100 STD_LOTA09"   GCol="input,LOTA09" GF="C"></td>
												<td GH="100 STD_BOXQNM"   GCol="text,BOXQTY"  GF="N"></td>
												<td GH="100 STD_INPQNM"   GCol="text,INPQTY"  GF="N"></td>
												<td GH="100 STD_PALQNM"   GCol="text,PALQTY"  GF="N"></td>
												<td GH="100 STD_ASDNUM"   GCol="text,SEBELN"></td>
												<td GH="100 STD_SELPNM"   GCol="text,SEBELP"></td>
												<td GH="100 STD_ENDMAK"   GCol="text,ENDMAK,center"></td>
												<td GH="100 STD_RECDAT"   GCol="text,RECDAT"  GF="C"></td>
												<td GH="100 STD_RECTIM"   GCol="text,RECTIM"  GF="T"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
<!-- 									<button type="button" GBtn="delete"></button> -->
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
					
					<div id="tabs1-5">
						<div class="section type1">
							<div class="table type2">
								<div class="tableBody">
									<table>
										<tbody id="gridSubList">
										<tr CGRow="true">
												<td GH="40"               GCol="rownum">1</td>
<!-- 												<td GH="40"               GCol="rowCheck"></td> -->
												<td GH="100 STD_RCPTTY"   GCol="text,ASNTNM"></td>
												<td GH="130 STD_ASDSKU"   GCol="text,ASNSKU"></td>
												<td GH="240 STD_ASNTNM"   GCol="text,ASNDS1"></td>
												<td GH="130 STD_ASNSKU"   GCol="text,SKUKEY"></td>
												<td GH="240 STD_ASNSNM"   GCol="text,DESC01"></td>
												<td GH="100 STD_LOCAKY"   GCol="text,LOCAKY"></td>
												<td GH="80 STD_SKUCNM"    GCol="text,SKCLNM"></td>
												<td GH="80 STD_ABCNM"     GCol="text,SKUGRD"></td>
												<td GH="100 STD_QTYRCV"   GCol="text,QTYRCV" GF="N"></td>
												<td GH="100 STD_REALQTY"  GCol="text,REALQTY" GF="N"></td>
												<td GH="80 STD_LOTA06"    GCol="text,LO06NM"></td>
												<td GH="100 STD_LOTA08"   GCol="text,LOTA08" GF="C"></td>
												<td GH="100 STD_LOTA09"   GCol="text,LOTA09" GF="C"></td>
												<td GH="100 STD_ASDNUM"   GCol="text,SEBELN"></td>
												<td GH="100 STD_SELPNM"   GCol="text,SEBELP"></td>
												<td GH="100 STD_ENDMAK"   GCol="text,ENDMAK,center"></td>
												<td GH="100 STD_RECVKY"   GCol="text,RECVKY"></td>
												<td GH="100 STD_REITEM"   GCol="text,RECVIT"></td>
												<td GH="100 STD_RECDAT"   GCol="text,CREDAT" GF="C"></td>
												<td GH="100 STD_RECTIM"   GCol="text,CRETIM" GF="T"></td>
												<td GH="100 STD_RECDID"   GCol="text,CREUSR"></td>
												<td GH="100 STD_RECUSR"   GCol="text,CUSRNM"></td>
												
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="tableUtil">
								<div class="leftArea">
									<button type="button" GBtn="find"></button>
<!-- 									<button type="button" GBtn="add"></button> -->
<!-- 									<button type="button" GBtn="delete"></button> -->
									<button type="button" GBtn="sortReset"></button>
									<button type="button" GBtn="layout"></button>
									<button type="button" GBtn="total"></button>
									<button type="button" GBtn="excel"></button>
								</div>
								<div class="rightArea">
									<p class="record" GInfoArea="true"></p>
								</div>
							</div>
						</div>
					</div>
					
				</div>
			</div>
							
							
		</div>
		<!-- //contentContainer -->
	</div>
</div>
<!-- //content -->
<%@ include file="/common/include/bottom.jsp" %>
</body>
</html>