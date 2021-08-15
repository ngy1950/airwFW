<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, target-densitydpi=medium-dpi"/>
<meta name="format-detection" content="telephone=no"/>
<%@ include file="/mobile/include/head.jsp" %>
<title><%=documentTitle%></title>
<script type="text/javascript">
	$(document).ready(function(){
		// 버튼 클릭시 자동 submit 되는거 방지
		$("form").submit(function () {
			if(!$(this).prop("action")) {
				return false;
			}
		});
		
		var ssl = sessionStorage.length;
		if(ssl > 0){
			var param = dataBind.paramData("searchArea");
			for(var i = 0; i<ssl; i++){
				var ssk = sessionStorage.key(i);
				param.put(ssk, sessionStorage[ssk]);
			}
            sessionStorage.clear();
			dataBind.dataNameBind(param, "searchArea");
		}
	});
	
	// 확인버튼 클릭시 조회 화면으로 이동 
	function sendData(){
		var param  = dataBind.paramData("searchArea");
		dataBind.dataNameBind(param, "searchArea");
		
		var PHYIKY = param.get("PHYIKY");
		var LOCAKY = param.get("LOCAKY");
			
		if( isNull( PHYIKY ) ||  isNull( LOCAKY ) ){
			// COMMON_M0001 {0} 중 하나는 필수 입력 값입니다.
			// COMMON_M0002 {0} 필수 입력 값입니다.
			// COMMON_M0003 적어도 하나 이상의 값을 입력하세요
			var msg = "["+ uiList.getLabel("STD_PHYIKY")+"]," + "[" + uiList.getLabel("STD_LOCAKY") + "]";
			commonUtil.msgBox("COMMON_M0002", msg);
			
			return;
		}
		
		sessionStorage["PHYIKY"] = PHYIKY;
		
		var $form = $("form");
		$form.prop("action", "/mobile/inventory/MIP02_list.page");
		$form.prop("method", "post");
		$form.submit();
	}

    // 입력버튼 포커스시 초기화
	function clearText(data){
		if(data!=null||data!=""){
			data.value="";
		}
	}
	
    // 팝업 호출
	function linkPopupOpen(){
        var param =  dataBind.paramData("searchArea");
		mobile.linkPopOpen('/mobile/inventory/MIP02_search.page', param);
	}
	
    // 팝업 닫힐시 호출 
	function linkPopCloseEvent(data){
    	
		if ( $.trim(data.get("PROGID")) == "MGR20SEARCHSKU" ){
			
    		var SKUKEY = data.get("SKUKEY");
    		var param = dataBind.paramData("searchArea");
	   		param.put("MGRCOD",SKUKEY);
	   		dataBind.dataNameBind(param, "searchArea");
	   		checkList();
	   		
    	}else {
			var param = dataBind.paramData("searchArea");
			if(data.get("PROGID") == "MIP02"){
				var SKUKEY = data.get("SKUKEY");
				param.put("MGRCOD", SKUKEY);
			}else{
				var PHYIKY = data.get("PHYIKY");
				param.put("PHYIKY", PHYIKY);
				$("[name='LOCAKY']").focus();
			}
			dataBind.dataNameBind(param, "searchArea");
    	}
    }
	
    // 값 존재 체크
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
    
	function inputSkuCheck(){
		
		var param  = dataBind.paramData("searchArea");
		var MGRCOD = $.trim(param.get("MGRCOD"));
		
		if ( $.trim(MGRCOD) == "" ){
            return false;
		}
			
		var json = netUtil.sendData({
            module : "Mobile",
            command : "MGR20val",
            sendType : "map",
            param : param
        });
	            
        if(json && json.data){
        	var cnt = json.data["CNT"];
            var seltype = json.data["SELTYPE"];
            
            if(json && json.data){
                var cnt = json.data["CNT"];
                var seltype = json.data["SELTYPE"];
                   
                if(cnt == 1){
                    checkList();
                }else if(cnt > 1){
                    var param =  dataBind.paramData("searchArea");
                    param.put("MGRCOD", MGRCOD);
                    mobile.linkPopOpen('/mobile/inbound/MGR20_search_sku.page', param);
                    return;
                }
            }else{
                commonUtil.msgBox("VALID_M0206", MGRCOD);
                $('[name=MGRCOD]').val("");
                return;
            }
        }else{
            commonUtil.msgBox("VALID_M0206", MGRCOD);
            $('[name=MGRCOD]').val("");
            return;
        }
		
        return true;
    }
	
	// keyPress Enter 처리 함수
    function checkList(){
        // 필수입력값 체크 
        // 모두 입력 sendData
        // 미입력 빈값 포커스
        
        var param  = dataBind.paramData("searchArea");
        
        var PHYIKY = $.trim(param.get("PHYIKY"));
        var LOCAKY = $.trim(param.get("LOCAKY"));
        var MGRCOD = $.trim(param.get("MGRCOD"));
            
        if( isNull( PHYIKY ) ||  isNull( LOCAKY ) || isNull( MGRCOD )){
            if(isNull( PHYIKY )){
                $("[name='PHYIKY']").focus();
            }else if(isNull( LOCAKY )){
                $("[name='LOCAKY']").focus();
            }else if ( isNull( MGRCOD ) ){
            	$("[name='MGRCOD']").focus();
            }
        }else{
            sendData();
        }
    }
</script>
</head>
<body>
	<div class="main_wrap">
        <h2 class="info_title" CL="MENU_MIP02,3"></h2>
		<div class="tem3_content">
			<div class="search">
				<form id="searchArea">
					<table>
						<colgroup>
							<col width="100px"/>
							<col/>
							<col width="60px"/>
						</colgroup>
						<tbody>
							<input type="hidden" name="WAREKY"  value="<%=wareky%>"/>
							<input type="hidden" name="OWNRKY"  value="<%=ownrky%>"/>
							<input type="hidden" name="LOTA09" />
							<input type="hidden" name="PHSCTY"  value="ALL"/>
							<input type="hidden" name="PROGID"  value="MIP02"/>
							<tr>
								<th CL="STD_PHYIKY"></th>
								<td>
									<input type="text" class="text" id="PHYIKY" name="PHYIKY"  UIFormat="U" onfocus="clearText(this)" onkeypress="commonUtil.enterKeyCheck(event, 'checkList()')" autocomplete="off" />
								</td>
								<td>
									<input type="button" value="p" class="bt" onclick="linkPopupOpen()"/>
								</td>
							</tr>
							<tr>
								<th CL="STD_LOCAKY"></th>
								<td>
									<input type="text" class="text" id="LOCAKY" name="LOCAKY" onfocus="clearText(this)" UIFormat="U"  onkeypress="commonUtil.enterKeyCheck(event, 'checkList()')" autocomplete="off" />
								</td>
							</tr>
                            <tr>
                                <th CL="STD_MGRCOD"></th>
	                            <td>
	                                <input type="text" class="text" id="MGRCOD"  name="MGRCOD"  onfocus="clearText(this)" onkeypress="commonUtil.enterKeyCheck(event, 'inputSkuCheck()')" autocomplete="off"/>
	                            </td>
                            </tr>
						</tbody>
					</table>
				</form>
			</div>
			<div class="bottom">
				<button class=" bottom_bt" onClick="sendData()"><span CL="BTN_CONFIRM"></span></button>
			</div>
		</div>
	</div>
</body>