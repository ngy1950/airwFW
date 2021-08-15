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
.dC button{margin-left: 0 !important;}
.dC button.type0{width: 15% !important;}
.dC button.type1{width: 20% !important;}
.dC button.type2{width: 25% !important;}
.dC button.type3{width: 35% !important;}
.dC button.type4{width: 100% !important;}
.dC button.type5{width: 24% !important;}
</style>
<script type="text/javascript">
	var areaId = "scanArea";
	
	$(document).ready(function(){
		mobileCommon.useSearchPad(false);
		
		mobileCommon.setOpenDetailButton({isUse : false});
	});
	
	function selectButtonEvent(type){
		switch (type) {
		case 0:
			mobileCommon.select(null,areaId,"INPUT1");
			break;
		case 1:
			mobileCommon.select("Chage Input Text",areaId,"INPUT1");
			break;
		default:
			var data = new DataMap();
				data.put("INPUT1","Init Input Text");
				
			dataBind.dataNameBind(data, areaId);
			
			break;
		}
	}
	
	function focusButtonEvent(type){
		switch (type) {
		case 0:
			var data  = dataBind.paramData(areaId);
			var value = data.get("INPUT2");
			mobileCommon.focus(value,areaId,"INPUT2");
			break;
		case 1:
			mobileCommon.focus(null,areaId,"INPUT2");
			break;
		case 2:
			mobileCommon.focus("Chage Input Text",areaId,"INPUT2");
			break;
		default:
			var data = new DataMap();
				data.put("INPUT2","Init Input Text");
				
			dataBind.dataNameBind(data, areaId);
			
			break;
		}
	}
	
	function messageEvent(type){
		switch (type) {
		case 0:
			mobileCommon.alert({
				message : "Alert Message Test.",
				confirm : function(){
					
				}
			});
			break;
		case 1:
			mobileCommon.confirm({
				message : "Confirm Message Test.",
				confirm : function(){
					
				}
			});
			break;
		case 2:
			mobileCommon.toast({
				type : "S",
				message : "Success Toast Message Test.",
				execute : function(){
					
				}
			});
			break;
		case 3:
			mobileCommon.toast({
				type : "W",
				message : "Warring Toast Message Test.",
				execute : function(){
					
				}
			});
			break;
		case 4:
			mobileCommon.toast({
				type : "F",
				message : "Fail Toast Message Test.",
				execute : function(){
					
				}
			});
			break;
		case 5:
			mobileCommon.toast({
				type : "N",
				message : "Toast Message Test.",
				execute : function(){
					
				}
			});
			break;	
		default:
			break;
		}
	}
	
	function closeKeyPadAfterEvent(areaId,name,value,$Obj){
		if((areaId == "scanArea") && (name == "INPUT3")){
			var message = "";
			if(value == undefined || $.trim(value) == "" || value == null){
				message = "areaId : " + areaId + "\n" + "inputName : " + name + "\n" + "inputValue : 입력된 값이 없습니다.";
			}else{
				message = "areaId : " + areaId + "\n" + "inputName : " + name + "\n" + "inputValue : " + value;
			}
			
			mobileCommon.alert({
				message : "<span class='msgColorGreen'><< Close KeyPad Test >></span>\n"+message
			});
		}
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
							<td class="dT">mobileCommon.select(option)</td>
						</tr>
						<tr>
							<td class="dC">
								<input type="text" name="INPUT1" value="Init Input Text"/>
							</td>
						</tr>
						<tr>
							<td class="dC">
								<button class="type3" onclick="selectButtonEvent(0);">Select</button>
								<button class="type3" onclick="selectButtonEvent(1);">Change Select</button>
								<button class="type2" onclick="selectButtonEvent();">Init</button>
							</td>
						</tr>
						<tr>
							<td class="dT">mobileCommon.focus(option)</td>
						</tr>
						<tr>
							<td class="dC">
								<input type="text" name="INPUT2" value="Init Input Text"/>
							</td>
						</tr>
						<tr>
							<td class="dC">
								<button class="type1" onclick="focusButtonEvent(0);">Focus</button>
								<button class="type2" onclick="focusButtonEvent(1);">Init Focus</button>
								<button class="type3" onclick="focusButtonEvent(2);">Change Focus</button>
								<button class="type0" onclick="focusButtonEvent();">Init</button>
							</td>
						</tr>
						<tr>
							<td class="dT">Alert Message</td>
						</tr>
						<tr>
							<td class="dC">
								<button class="type4" onclick="messageEvent(0);">Alert</button>
							</td>
						</tr>
						<tr>
							<td class="dT">Confirm Message</td>
						</tr>
						<tr>
							<td class="dC">
								<button class="type4" onclick="messageEvent(1);">Confirm</button>
							</td>
						</tr>
						<tr>
							<td class="dT">Toast Message</td>
						</tr>
						<tr>
							<td class="dC">
								<button class="type5" onclick="messageEvent(2);">Toast(S)</button>
								<button class="type5" onclick="messageEvent(3);">Toast(W)</button>
								<button class="type5" onclick="messageEvent(4);">Toast(F)</button>
								<button class="type5" onclick="messageEvent(5);">Toast(N)</button>
							</td>
						</tr>
						<tr>
							<td class="dT">closeKeyPadAfterEvent</td>
						</tr>
						<tr>
							<td class="dC">
								<input type="text" name="INPUT3" value="Close KeyPad Test."/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<%@ include file="/pda/include/mobileBottom.jsp" %>
</body>