<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/pda/include/head.jsp" %>
<title><%=documentTitle%></title>
<style type="text/css">
.dT{
	height: 25px !important;
	text-align: left;
	font-weight: bold;
	font-size: 15px;
	background: url(/pda/img/ico/ico-right-arrow.png) no-repeat;
	background-size: 18px;
	background-position: left;
	padding-left: 25px;
}
.dC{padding-left: 10px;padding-right: 10px;}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		mobileCommon.useSearchPad(false);
		
		mobileCommon.setOpenDetailButton({isUse : false});
		
		scanInput.setScanInput({
			id     : "INPUT2",
			name   : "INPUT2",
			bindId : "scanArea",
			type   : "number"
		});
		
		scanInput.setScanInput({
			id     : "INPUT3",
			name   : "INPUT3",
			bindId : "scanArea",
			type   :"text"
		});
		
		mobileSearchHelp.setSearchHelp({
			id 			: "SHTYPE1",
			name 		: "INPUT4",
			returnCol 	: "COL2",
			bindId 		: "scanArea",
			title 		: "PDA PopUp Type1",
			inputType 	: "scan",
			grid 		: 	[
								{"width":100, "label":"DEMO_COL1", "type":"text", "col":"COL1"},
								{"width":100, "label":"DEMO_COL2", "type":"text", "col":"COL2"},
								{"width":100, "label":"DEMO_COL3", "type":"text", "col":"COL3"}
							],
			module 		: "Pda",
			command 	: "DEMO_POP"
		});
		
		mobileSearchHelp.setSearchHelp({
			id			: "SHTYPE2",
			name		: "INPUT5",
			returnCol	: "COL1",
			bindId		: "scanArea",
			title 		: "PDA PopUp Type2",
			inputType	: "scanNumber",
			searchType	: "in", 
			search 		:	[
								{"type":"select", "label":"DEMO_COMBO", "name":"COMBO1", "combo":"Pda,DEMO_POP_COMBO", "codeView":false, "colspan":2},
								{"type":"text", "label":"DEMO_COL1", "name":"COL1", "colspan":2},
								[
									{"type":"text", "label":"DEMO_COL2", "name":"COL2"},
									{"type":"button", "label":"none", "id":"SHTYPE2_SEARCH", "name":"BTN_DISPLAY", "width":45}
								]
							],
			grid 		:	[
								{"width":100, "label":"DEMO_COL1", "type":"text", "col":"COL1"},
								{"width":100, "label":"DEMO_COL2", "type":"text", "col":"COL2"},
								{"width":100, "label":"DEMO_COL3", "type":"text", "col":"COL3"}
							],
			module		: "Pda",
			command		: "DEMO_POP"
		});
		
		mobileSearchHelp.setSearchHelp({
			id			: "SHTYPE3",
			name		: "INPUT6",
			returnCol	: "COL2",
			bindId		: "scanArea",
			title 		: "Mobile PopUp Type3",
			inputType	: "text",
			searchType	: "out", 
			search 		:	[
								{"type":"select", "label":"DEMO_COMBO", "name":"COMBO2", "combo":"Pda,DEMO_POP_COMBO", "codeView":false},
								{"type":"text", "label":"DEMO_COL1", "name":"COL1"},
								{"type":"text", "label":"DEMO_COL2", "name":"COL2"}
							],
			grid 		:	[
								{"width":100, "label":"DEMO_COL1", "type":"text", "col":"COL1"},
								{"width":100, "label":"DEMO_COL2", "type":"text", "col":"COL2"},
								{"width":100, "label":"DEMO_COL3", "type":"text", "col":"COL3"}
							],
			module		: "Pda",
			command		: "DEMO_POP"
		});
		
		mobileDatePicker.setDatePicker({
			id     : "INPUT7",
			name   : "INPUT7",
			bindId : "scanArea"
		});
	});
	
	function selectSearchHelpBefore(layerId,bindId,gridId,returnCol,$returnObj){
		var param = new DataMap();
		if(layerId == "SHTYPE1_LAYER"){
			param.put("TYPE","TYPE1");
		}else if(layerId == "SHTYPE2_LAYER"){
			param.put("TYPE","TYPE2");
		}else if(layerId == "SHTYPE3_LAYER"){
			param.put("TYPE","TYPE3");
		}
		return param;
	}
	
	function selectSearchHelpAfter(layerId,gridId,data,returnCol,$returnObj){
		var returnParamString = "Layer ID : " + layerId;
		mobileCommon.toast({
			type : "N",
			message : returnParamString
		});
	}
	
	function searchHelpUserButtonClickEvent(layerId,gridId,module,command,searchId,btnId){
		if(searchId == "SHTYPE2_INNER_SEARCH"){
			var param = dataBind.paramData(searchId);
				param.put("TYPE","TYPE2");
			gridList.gridList({
				id : gridId,
				param : param
			});
		}else if(searchId == "SHTYPE3_INNER_SEARCH"){
			var param = dataBind.paramData(searchId);
				param.put("TYPE","TYPE3");
			gridList.gridList({
				id : gridId,
				param : param
			});
			
			mobileCommon.closeSearchArea(layerId);
		}
	}
	
	//콤보 Before 이벤트(콤보 쿼리에 넘겨줄 값 세팅)
	function comboEventDataBindeBefore(comboAtt,paramName){
		var param = new DataMap();
		if(comboAtt == "Pda,DEMO_COMBO"){
			param.put("TYPE","type1");
			return param;
		}else if(comboAtt == "Pda,DEMO_POP_COMBO"){
			var name = $(paramName).attr("name");
			if(name == "COMBO1"){
				param.put("TYPE","TYPE2");
			}else if(name == "COMBO2"){
				param.put("TYPE","TYPE3");
			}
			return param;
		}
	}
	
	function isNull(sValue) {
		var value = (sValue+"").replace(" ", "");
		
		if( new String(value).valueOf() == "undefined")
			return true;
		if( value == null )
			return true;
		if( value.toString().length == 0 )
			return true;
		
		return false;
	}
</script>
</head>
<body>
	<div class="tem6_wrap">
		<!-- Content Area -->
		<div class="tem6_content">
			<!-- Scan Area -->
			<div class="scan_area">
				<table id="scanArea">
					<colgroup>
						<col />
					</colgroup>
					<tbody>
						<tr>
							<td class="dT">Combo Box</td>
						</tr>
						<tr>
							<td class="dC">
								<select name="DEV_COMBO" Combo="Pda,DEMO_COMBO" UISave="false" ComboCodeView=false></select>
							</td>
						</tr>
						<tr>
							<td class="dT">Scan Input(Number)</td>
						</tr>
						<tr>
							<td class="dC">
								<input type="text" name="INPUT2"/>
							</td>
						</tr>
						<tr>
							<td class="dT">Scan Input(Text)</td>
						</tr>
						<tr>
							<td class="dC">
								<input type="text" name="INPUT3"/>
							</td>
						</tr>
						<tr>
							<td class="dT">Scan Input + Search Help</td>
						</tr>
						<tr>
							<td class="dC">
								<input type="text" name="INPUT4"/>
							</td>
						</tr>
						<tr>
							<td class="dT">Scan Input(Number) + Search Help</td>
						</tr>
						<tr>
							<td class="dC">
								<input type="text" name="INPUT5"/>
							</td>
						</tr>
						<tr>
							<td class="dT">Search Help</td>
						</tr>
						<tr>
							<td class="dC">
								<input type="text" name="INPUT6"/>
							</td>
						</tr>
						<tr>
							<td class="dT">Date</td>
						</tr>
						<tr>
							<td class="dC">
								<input type="text" name="INPUT7"/>
							</td>
						</tr>
						<tr>
							<td class="dT">Default Input</td>
						</tr>
						<tr>
							<td class="dC">
								<input type="text" name="INPUT8"/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<%@ include file="/pda/include/mobileBottom.jsp" %>
</body>