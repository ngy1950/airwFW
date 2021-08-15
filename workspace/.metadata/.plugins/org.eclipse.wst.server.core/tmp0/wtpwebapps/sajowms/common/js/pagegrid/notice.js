Notice = function(){
	this.seq = "";
	
	this.auth = false;
	this.ntic = false;
	
	this.areaId = "";
	
	this.saveButton = "save";
	this.modifyButton = "modify";
	this.createButton = "create";
	this.cancelButton = "cancel";
	this.deleteButton = "delete";
	
	this.noticeButtonColorClass = "contentCheckBoxColor";
	
	this.saveType = "R";
	
	this.rowNum = -1;
}

Notice.prototype = {
	setNotice : function(options){
		var opts = jQuery.extend(Notice, options);
		
		notice.setAuth("");
		
		if(this.ntic || this.auth){
			notice.resizeNoticeButtonArea(opts.areaId);
		}
		
		this.areaId = opts.areaId;
		
		notice.drawNotice(opts.areaId,"","init");
	},
	
	setAuth : function(seq){
		var authParam = new DataMap();
		authParam.put("PROGID", configData.MENU_ID);
		authParam.put("NTISEQ", seq);
		authParam.put("NTITYP","I");
		
		var auth = netUtil.sendData({
			module : "Notice",
			command : "NOTICE_AUTH",
			sendType : "list",
			param : authParam
		});
		
		if(auth && auth.data){
			this.ntic = auth.data[0]["CNT"] > 0?true:false; 
			this.auth = auth.data[1]["CNT"] > 0?true:false;
		}
	},
	
	drawNotice : function(areaId,seq,drawType){
		this.saveType = "R";
		
		notice.resetButtonArea();
		
		notice.setAuth(seq);
		
		if(this.auth){
			notice.drawNoticeButton(this.createButton,areaId);
			if(this.ntic){
				notice.drawNoticeButton(this.deleteButton,areaId);
				notice.drawNoticeButton(this.modifyButton,areaId);
			}
		}
		this.seq = seq;
		if(drawType != "init"){
			if(this.ntic){
				notice.drawNoticeEditArea(areaId,"detail");
			}else{
				notice.drawNoticeEditArea(areaId,"detail");
			}
		}else{
			notice.drawNoticeEditArea(areaId,"init");
		}
	},
	
	resizeNoticeButtonArea : function(areaId){
		$("#"+areaId).css("height","96%");
	},
	
	resetButtonArea : function(){
		$("#"+this.saveButton).remove();
		$("#"+this.modifyButton).remove();
		$("#"+this.createButton).remove();
		$("#"+this.cancelButton).remove();
		$("#"+this.deleteButton).remove();
	},
	
	drawNoticeButton : function(buttonType,areaId){
		var buttonImage = "";
		var buttonText = "";
		
		var $ul = $("<ul>").addClass("contentCheckBox").attr("style","width: 98px;margin-bottom: 5px;");
		var $imageClassLi = $("<li>").addClass("contentUserBoxArea");
		var $textClassLi = $("<li>").addClass("contentCheckBoxTextArea");
		$textClassLi.attr("style","width: 60px;text-align: center;font-weight: bold;");
		var $image = $("<img>").attr("width","18px;");
		
		switch (buttonType) {
		case "save":
			buttonImage = "/common/images/ico_btn3.png";
			buttonText = uiList.getLabel("BTN_SAVE");
			break;
		case "modify":
			buttonImage = "/common/images/ico_btn3.png";
			buttonText = uiList.getLabel("BTN_MODIFY");
			break;
		case "create":
			buttonImage = "/common/images/ico_btn12.png";
			buttonText = uiList.getLabel("BTN_CREATE");
			break;
		case "cancel":
			buttonImage = "/common/images/ico_closer.png";
			buttonText = uiList.getLabel("BTN_CANCEL");
			break;	
		case "delete":
			buttonImage = "/common/images/ico_btn13.png";
			buttonText = uiList.getLabel("BTN_DELETE");
			break;	
		default:
			break;
		}
		
		var $cloneUl = $ul.clone();
		var $cloneImageClassLi = $imageClassLi.clone(); 
		var $cloneTextClassLi = $textClassLi.clone();
		var $cloneImage = $image.attr("src",buttonImage);
		
		$cloneTextClassLi.text(buttonText);
		$cloneImageClassLi.append($cloneImage);
		$cloneUl.append($cloneImageClassLi).append($cloneTextClassLi);
		$cloneUl.attr("id",buttonType);
		
		var isDrawCreate = false;
		var $contentBox = $(".contentCheckBox");
		$contentBox.each(function(){
			if($(this).attr("id") == notice.createButton){
				isDrawCreate = true;
			}
		});
		if(isDrawCreate){
			$("#" + notice.createButton).before($cloneUl);
		}else{
			$("#" + areaId).before($cloneUl);
		}
		
		notice.setNoticeButtonEvent(buttonType,areaId);
	},
	
	noticeButtonChageColor : function($obj,bool){
		if(bool){
			$obj.addClass(this.noticeButtonColorClass);
		}else{
			$obj.removeClass(this.noticeButtonColorClass);
		}
	},
	
	setNoticeButtonEvent : function(buttonId,areaId){
		switch (buttonId) {
		case "create":
			$("#" + buttonId).off("click").on("click",function(e){
				notice.saveType = "C";
				
				notice.noticeButtonChageColor($("#" + buttonId),true);
				
				setTimeout(function(){
					notice.noticeButtonChageColor($("#" + buttonId),false);
				}, 100);
				
				setTimeout(function() {
					var isDrawSave = true;
					var $contentBox = $(".contentCheckBox");
					$contentBox.each(function(){
						if($(this).attr("id") == notice.saveButton){
							isDrawSave = false;
						}
					});
					if(isDrawSave){
						notice.drawNoticeButton(notice.saveButton,areaId);
					}
					$("#"+notice.deleteButton).remove();
					$("#"+notice.modifyButton).remove();
					notice.drawNoticeEditArea(areaId,"edit");
					gridList.setRowFocus("gridList",-1,true);
				},150);
			});
			break;
		case "save":
			$("#" + buttonId).off("click").on("click",function(e){
				notice.noticeButtonChageColor($("#" + buttonId),true);
				
				setTimeout(function(){
					notice.noticeButtonChageColor($("#" + buttonId),false);
				}, 100);
				
				setTimeout(function() {
					notice.saveNotice();
				},150);
			});
			break;
		case "modify":
			$("#" + buttonId).off("click").on("click",function(e){
				notice.saveType = "U";
				
				notice.noticeButtonChageColor($("#" + buttonId),true);
				
				setTimeout(function(){
					notice.noticeButtonChageColor($("#" + buttonId),false);
				}, 100);
				
				setTimeout(function() {
					$("#"+notice.deleteButton).remove();
					$("#"+notice.modifyButton).remove();
					notice.drawNoticeButton(notice.cancelButton,areaId);
					notice.drawNoticeButton(notice.saveButton,areaId);
					notice.drawNoticeEditArea(areaId,"modify");
				},150);
			});
			break;
		case "cancel":
			$("#" + buttonId).off("click").on("click",function(e){
				notice.saveType = "R";
				
				notice.noticeButtonChageColor($("#" + buttonId),true);
				
				setTimeout(function(){
					notice.noticeButtonChageColor($("#" + buttonId),false);
				}, 100);
				
				setTimeout(function() {
					$("#"+notice.cancelButton).remove();
					$("#"+notice.saveButton).remove();
					notice.drawNoticeButton(notice.deleteButton,areaId);
					notice.drawNoticeButton(notice.modifyButton,areaId);
					notice.drawNoticeEditArea(areaId,"detail");
				},150);
			});
			break;
		case "delete":
			$("#" + buttonId).off("click").on("click",function(e){
				notice.noticeButtonChageColor($("#" + buttonId),true);
				
				setTimeout(function(){
					notice.noticeButtonChageColor($("#" + buttonId),false);
				}, 100);
				
				setTimeout(function() {
					notice.deleteNotice();
				},150);
			});
			break;	
		default:
			break;
		}
	},
	
	drawNoticeAttachGrid : function(type){
		var html;  
		html += '<div id="attachBox">                                                                         ';
	    html += '	<div class="table type2" style="margin: 0;top: 0;bottom: 29px;">                          ';
		html += '			<div class="tableBody">                                                           ';
		html += '				<table>                                                                       ';
		html += '					<tbody id="gridList2">                                                    ';
		html += '						<tr CGRow="true">                                                     ';
		html += '							<td GH="40 STD_NUMBER"  GCol="rownum">1</td>                      ';
	    if(type == "detail"){
	    	html += '	                        <td GH="400 STD_ATTACH"  GCol="fileDownload,ATTACH"/></td>    ';
	    }else{
	    	html += '	                        <td GH="400 STD_ATTACH"  GCol="file,ATTACH"/></td>            ';
	    }
	    html += '	                            <td GH="100 STD_FILESIZE"  GCol="fileSize,BYTE"/></td>        ';
	    html += '						</tr>                                                                 ';
		html += '					</tbody>                                                                  ';
		html += '				</table>                                                                      ';
		html += '			</div>                                                                            ';
		html += '		</div>                                                                                ';
		html += '		<div class="tableUtil" style="margin: 0;bottom: 0;left: 0;right: 0;">                 ';
		html += '			<div class="leftArea">                                                            ';
		html += '				<button type="button" GBtn="find"></button>                                   ';
		if(type != "detail"){
			html += '				<button type="button" GBtn="add"></button>                                ';
			html += '				<button type="button" GBtn="delete"></button>                             ';
		}
		html += '			</div>                                                                            ';
		html += '			<div class="rightArea">                                                           ';
		html += '				<p class="record" GInfoArea="true"></p>                                       ';
		html += '			</div>                                                                            ';
		html += '		</div>                                                                                ';
		html += '</div>                                                                                       ';
		
		return html;
	},
	
	drawNoticeEditArea : function(areaId,drawType){
		var $area = $("."+areaId).find(".elTd");
		var $areaTr = $("."+areaId).find(".elTr");
		
		var $input = $("<input>");
		var $textArea = $("<textarea>");
		var $span = $("<span>");
		var $ul = $("<ul>");
		var $li = $("<li>");
		var $select = $("<select>");
		var $iframe = $("<iframe>");
		var $div = $("<div>");
		
		switch (drawType) {
		case "init":
			$areaTr.addClass("editDisabled");
			
			$("#"+this.modifyButton).remove();
			$("#"+this.saveButton).remove();
			$("#"+this.cancelButton).remove();
			$("#"+this.deleteButton).remove();
			
			$area.eq(0).html("");
			$area.eq(0).removeClass("inputRequired");
			$area.eq(1).html("");
			$area.eq(2).html("");
			$area.eq(3).html("");
			$area.eq(4).html("");
			$area.eq(5).html("");
			$area.eq(6).html("");
			$area.eq(7).html("");
			$area.eq(8).html("");
			
			break;
		case "detail":
			$areaTr.removeClass("editDisabled");
			
			var param = new DataMap();
			param.put("NTISEQ",this.seq);
			param.put("NTAGTY","I");
			
			var titnti = "";
			var cusrnm = "";
			var nidtfr = "";
			var nidtto = "";
			var contnt = "";
			var smsflg = "";
			var popflg = "";
			var impflg = "";
			var credat = "";
			var cretim = "";
			var pfrdat = "";
			var ptodat = "";
			var imgFlg = "";
			
			var json = netUtil.sendData({
				module : "Notice",
				command : configData.MENU_ID,
				sendType : "map",
				param : param
			});
			
			if(json && json.data){
				titnti = json.data["TITNTI"];
				cusrnm = json.data["CUSRNM"];
				nidtfr = json.data["NIDTFR"];
				nidtto = json.data["NIDTTO"];
				contnt = json.data["CONTNT"];
				smsflg = json.data["SMSFLG"];
				popflg = json.data["POPFLG"];
				impflg = json.data["IMPFLG"];
				imgFlg = json.data["IMGFLG"];
				credat = json.data["CREDAT"];
				cretim = json.data["CRETIM"];
				pfrdat = $.trim(json.data["PFRDAT"]);
				ptodat = $.trim(json.data["PTODAT"]);
			}
			
			var $titnti = $span.clone().html(titnti);
			$area.eq(0).html($titnti);
			
			var $cusrnm = $span.clone().text(cusrnm);
			$area.eq(1).html($cusrnm);
			
			var $credat = $input.clone().attr({"type":"text","name":"CREDAT","autocomplete":"off","UIInput":"D","UIFormat":"D","disabled":true});
			var $cretim = $input.clone().attr({"type":"text","name":"CRETIM","autocomplete":"off","UIInput":"T","UIFormat":"T","disabled":true});
			
			var div1 = $div.clone().append($credat).append($cretim);
			
			$area.eq(2).html(div1);
			
			$("#"+ areaId +" [name=CREDAT]").val(credat);
			$("#"+ areaId +" [name=CRETIM]").val(cretim);
			
			var $nidtfr = $input.clone().attr({"type":"text","name":"NIDTFR","UIFormat":"D","disabled":true,"style":"border: 0;background: no-repeat;width: 80px;"});
			var $nidtto = $input.clone().attr({"type":"text","name":"NIDTTO","UIFormat":"D","disabled":true,"style":"border: 0;background: no-repeat;"});
			
			var $ul1 = $ul.clone();
			var $li1 = $li.clone().append($nidtfr).append(" <span>~</span> ").append($nidtto);
			
			if(imgFlg == "X"){
				$li1.css("color","rgb(192,0,0)");
			}
			
			var $noifimSpan = $span.clone().attr("CL","STD_NOIFIM"); 
			
			var $noifim = $input.clone().attr({"type":"checkbox","name":"IMPFLG","value":"V","disabled":true});
			
			var $li2 = $li.clone().append($noifimSpan).append($noifim);
			
			$ul1.append($li1).append($li2);
			$area.eq(3).html($ul1);
			
			var $npopyn = $input.clone().attr({"type":"checkbox","name":"POPFLG","value":"V","disabled":true});
			$area.eq(4).html($npopyn);
			
			var $popyn = "";
			if(pfrdat != "" && ptodat != ""){
				var $pfrdat = $input.clone().attr({"type":"text","name":"PFRDAT","UIFormat":"D","disabled":true,"style":"border: 0;background: no-repeat;width: 80px;"});
				var $ptodat = $input.clone().attr({"type":"text","name":"PTODAT","UIFormat":"D","disabled":true,"style":"border: 0;background: no-repeat;"});
				
				$popyn = $div.clone().append($pfrdat).append(" <span>~</span> ").append($ptodat);
			}
			
			$area.eq(5).html($popyn);
			
			$("#"+ areaId +" [name=PFRDAT]").val(pfrdat);
			$("#"+ areaId +" [name=PTODAT]").val(ptodat);
			
			var ntargtnm = "";
			
			var ntargt = netUtil.sendData({
				module : "Notice",
				command : "NITAG",
				sendType : "list",
				param : param	
			});
			
			if(ntargt && ntargt.data){
				var len = ntargt.data.length;
				if(len > 0){
					var spactor = ", ";
					for(var i = 0; i < len; i++){
						var row = ntargt.data[i];
						var ntarnm = row["NTARNM"];
						if(len == (i+1)){
							spactor = "";
						}
							
						ntargtnm += ntarnm + spactor;
					}
				}
			}
			
			var $ntargt = $span.clone().text(ntargtnm);
			$area.eq(6).html($ntargt);
			
			var height = $area.eq(5).height();
			var src = "/wms/notice/grid/note/"+(configData.MENU_ID)+".page";
			var $contnt = $iframe.clone().attr({"id":"note","name":"note","width":"100%","height":"100%","scrolling":"auto"});//,"src":src
			
			var $frm = $("<form>").attr({"name":"frm","action":src,"method":"POST"});
			$frm.append($("<input>").attr({"type":"hidden","name":"seq"}).val(this.seq));
			$frm.append($("<input>").attr({"type":"hidden","name":"type"}).val("detail"));
			
			$area.eq(7).html($contnt);
			$area.eq(7).append($frm);
			
			$area.eq(8).html(notice.drawNoticeAttachGrid("detail").replace("undefined",""));
			
			notice.beforeLord("note",src,this.seq,"detail");
			
			$("#"+ areaId +" [name=NIDTFR]").val(nidtfr);
			$("#"+ areaId +" [name=NIDTTO]").val(nidtto);
			
			uiList.UICheck($("#"+areaId));
			inputList.setCombo(areaId);
			inputList.setInput(areaId);
			
			popflg == "V"?$("#"+ areaId +" [name=POPFLG]").prop("checked",true):$("#"+ areaId +" [name=POPFLG]").prop("checked",false); 
			impflg == "V"?$("#"+ areaId +" [name=IMPFLG]").prop("checked",true):$("#"+ areaId +" [name=IMPFLG]").prop("checked",false); 
			
			gridList.setGrid({
				id : "gridList2",
				module : "Notice",
				command : "NITBD_ATTACH",
				firstRowFocusType : false,
				editedClassType : false,
				emptyMsgType : false
			});
			
			gridList.setReadOnly("gridList2", true, ["ATCTYP"]);
			
			setTimeout(function(){
				netUtil.send({
					module : "Notice",
					command : "NITBD_ATTACH",
					sendType : "list",
					bindType : "grid",
		            bindId   : "gridList2",
					param : param	
				});
			});
			
			var $form = document.frm;
			$form.target = "note";
			$form.submit();
			$frm.remove();
			
			break;
		case "edit":
			$areaTr.removeClass("editDisabled");
			
			var userid = "";
			var usernm = "";
			var credat = "";
			var cretim = "";
			
			var json = netUtil.sendData({
				module : "Notice",
				command : "NOTICE_USER",
				sendType : "map"
			});
			
			if(json && json.data){
				userid = json.data["USERID"];
				usernm = json.data["USERNM"];
				credat = json.data["CREDAT"];
				cretim = json.data["CRETIM"];
			}
			
			var $titnti = $input.clone().attr({"type":"text","name":"TITNTI","autocomplete":"off","UIformat":"S 100","placeholder":"제목을 입력해주세요."});
			$area.eq(0).addClass("inputRequired");
			var $cusrnm = $input.clone().attr({"type":"text","name":"CUSRNM","autocomplete":"off","disabled":true});
			
			var $nidtfr = $input.clone().attr({"type":"text","name":"NIDTFR","autocomplete":"off","UIFormat":"C","onchange": "notice.dateChangeEvent('NIDTFR');"});
			var $nidtto = $input.clone().attr({"type":"text","name":"NIDTTO","autocomplete":"off","UIFormat":"C","onchange": "notice.dateChangeEvent('NIDTTO');"});
			
			var $ul1 = $ul.clone();
			var $li1 = $li.clone().append($nidtfr).append(" <span>~</span> ").append($nidtto);
			
			var $noifimSpan = $span.clone().attr("CL","STD_NOIFIM"); 
			
			var $noifim = $input.clone().attr({"type":"checkbox","name":"IMPFLG","value":"V"});
			
			var $li2 = $li.clone().append($noifimSpan).append($noifim);
			
			$ul1.append($li1).append($li2);
			
			var $npopyn = $input.clone().attr({"type":"checkbox","name":"POPFLG","value":"V","onclick": "notice.npopynChangeEvent();"});
			
			var $pfrdat = $input.clone().attr({"type":"text","name":"PFRDAT","autocomplete":"off","UIFormat":"C","onchange": "notice.dateChangeEvent('PFRDAT');"});
			var $ptodat = $input.clone().attr({"type":"text","name":"PTODAT","autocomplete":"off","UIFormat":"C","onchange": "notice.dateChangeEvent('PTODAT');"});
			
			var $popyn = $div.clone().append($pfrdat).append(" <span>~</span> ").append($ptodat);
			
			var $nttagt = $div.clone().addClass("msBox");
			var $nttagtSelect = $nttagtSelect = $select.attr({"Combo":"Wms,WAHMACOMBO","name":"NTTAGT","ComboType":"MS","style":"width: 180px;"}); 

			$nttagt.html($nttagtSelect);
			
			var src = "/wms/notice/grid/note/"+(configData.MENU_ID)+".page";
			var $contnt = $iframe.clone().attr({"id":"note","name":"note","width":"100%","height":"100%","scrolling":"no"});
			
			var $frm = $("<form>").attr({"name":"frm","action":src,"method":"POST"});
			$frm.append($("<input>").attr({"type":"hidden","name":"seq"}).val("no"));
			$frm.append($("<input>").attr({"type":"hidden","name":"type"}).val("edit"));
			
			var $credat = $input.clone().attr({"type":"text","name":"CREDAT","autocomplete":"off","UIInput":"D","UIFormat":"D","disabled":true});
			var $cretim = $input.clone().attr({"type":"text","name":"CRETIM","autocomplete":"off","UIInput":"T","UIFormat":"T","disabled":true});
			
			var div1 = $div.clone().append($credat).append($cretim);
			
			$area.eq(0).html($titnti);
			$area.eq(1).html($cusrnm);
			$area.eq(2).html(div1);
			$area.eq(3).html($ul1);
			$area.eq(4).html($npopyn);
			$area.eq(5).html($popyn);
			$area.eq(6).html($nttagt);
			$area.eq(7).html($contnt);
			$area.eq(7).append($frm);
			$area.eq(8).html(notice.drawNoticeAttachGrid("edit").replace("undefined",""));
			
			notice.beforeLord("note",src,"no","edit");
			
			$("#"+ areaId +" [name=CREDAT]").val(credat);
			$("#"+ areaId +" [name=CRETIM]").val(cretim);
			
			uiList.UICheck($("#"+areaId));
			inputList.setCombo(areaId);
			inputList.setInput(areaId);
			
			$(".msBox").attr("style","height:0");
			$(".msBox").children().eq(0).css("margin-top","0");
			
			$("[name=CUSRNM]").val(usernm);
			
			$("[name=PFRDAT]").attr("disabled",true);
			$("[name=PTODAT]").attr("disabled",true);
			$("[name=PFRDAT]").next().hide();
			$("[name=PTODAT]").next().hide();
			
			var frDate = notice.initDateFormat(0);
			var toDate = notice.initDateFormat(30);
			
			$("[name=NIDTFR]").val(frDate);
			$("[name=NIDTTO]").val(toDate);
			
			inputList.setMultiComboSelectAll($("[name=NTTAGT]"),true);
			
			gridList.setGrid({
				id : "gridList2",
				module : "Notice",
				command : "NITBD_ATTACH"
			});
			
			var $form = document.frm;
			$form.target = "note";
			$form.submit();
			$frm.remove();
			
			break;
		case "modify":
			$areaTr.removeClass("editDisabled");
			
			var param = new DataMap();
			param.put("NTISEQ",this.seq);
			param.put("NTAGTY","I");
			
			var titnti = "";
			var cusrnm = "";
			var nidtfr = "";
			var nidtto = "";
			var contnt = "";
			var smsflg = "";
			var popflg = "";
			var impflg = "";
			var credat = "";
			var cretim = "";
			var pfrdat = "";
			var ptodat = "";
			
			var json = netUtil.sendData({
				module : "Notice",
				command : configData.MENU_ID,
				sendType : "map",
				param : param	
			});
			
			if(json && json.data){
				titnti = json.data["TITNTI"];
				cusrnm = json.data["CUSRNM"];
				nidtfr = json.data["NIDTFR"];
				nidtto = json.data["NIDTTO"];
				contnt = json.data["CONTNT"];
				smsflg = json.data["SMSFLG"];
				popflg = json.data["POPFLG"];
				impflg = json.data["IMPFLG"];
				credat = json.data["CREDAT"];
				cretim = json.data["CRETIM"];
				pfrdat = $.trim(json.data["PFRDAT"]);
				ptodat = $.trim(json.data["PTODAT"]);
			}
			
			var $titnti = $input.clone().attr({"type":"text","name":"TITNTI","autocomplete":"off","UIformat":"S 100","placeholder":"제목을 입력해주세요."});
			$area.eq(0).addClass("inputRequired");
			var $cusrnm = $input.clone().attr({"type":"text","name":"CUSRNM","autocomplete":"off","disabled":true});
			
			var $nidtfr = $input.clone().attr({"type":"text","name":"NIDTFR","autocomplete":"off","UIFormat":"C","onchange": "notice.dateChangeEvent('NIDTFR');"});
			var $nidtto = $input.clone().attr({"type":"text","name":"NIDTTO","autocomplete":"off","UIFormat":"C","onchange": "notice.dateChangeEvent('NIDTTO');"});
			
			var $ul1 = $ul.clone();
			var $li1 = $li.clone().append($nidtfr).append(" <span>~</span> ").append($nidtto);
			
			var $noifimSpan = $span.clone().attr("CL","STD_NOIFIM"); 
			
			var $noifim = $input.clone().attr({"type":"checkbox","name":"IMPFLG","value":"V"});
			
			var $li2 = $li.clone().append($noifimSpan).append($noifim);
			
			$ul1.append($li1).append($li2);
			
			var $npopyn = $input.clone().attr({"type":"checkbox","name":"POPFLG","value":"V","onclick": "notice.npopynChangeEvent();"});
			
			var $pfrdat = $input.clone().attr({"type":"text","name":"PFRDAT","autocomplete":"off","UIFormat":"C","onchange": "notice.dateChangeEvent('PFRDAT');"});
			var $ptodat = $input.clone().attr({"type":"text","name":"PTODAT","autocomplete":"off","UIFormat":"C","onchange": "notice.dateChangeEvent('PTODAT');"});
			
			var $popyn = $div.clone().append($pfrdat).append(" <span>~</span> ").append($ptodat);
			
			var $nttagt = $div.clone().addClass("msBox");
			var $nttagtSelect = $select.attr({"Combo":"Wms,WAHMACOMBO","name":"NTTAGT","ComboType":"MS","style":"width: 180px;"}); 

			$nttagt.html($nttagtSelect);
			
			var src = "/wms/notice/grid/note/"+(configData.MENU_ID)+".page";
			var $contnt = $iframe.clone().attr({"id":"note","name":"note","width":"100%","height":"100%","scrolling":"no"});
			
			var $frm = $("<form>").attr({"name":"frm","action":src,"method":"POST"});
			$frm.append($("<input>").attr({"type":"hidden","name":"seq"}).val(this.seq));
			$frm.append($("<input>").attr({"type":"hidden","name":"type"}).val("modify"));
			
			var $credat = $input.clone().attr({"type":"text","name":"CREDAT","autocomplete":"off","UIInput":"D","UIFormat":"D","disabled":true});
			var $cretim = $input.clone().attr({"type":"text","name":"CRETIM","autocomplete":"off","UIInput":"T","UIFormat":"T","disabled":true});
			
			var div1 = $div.clone().append($credat).append($cretim);
			
			$area.eq(0).html($titnti);
			$area.eq(1).html($cusrnm);
			$area.eq(2).html(div1);
			$area.eq(3).html($ul1);
			$area.eq(4).html($npopyn);
			$area.eq(5).html($popyn);
			$area.eq(6).html($nttagt);
			$area.eq(7).html($contnt);
			$area.eq(7).append($frm);
			$area.eq(8).html(notice.drawNoticeAttachGrid("edit").replace("undefined",""));
			
			notice.beforeLord("note",src,this.seq,"modify");
			
			$("#"+ areaId +" [name=TITNTI]").val(titnti);
			$("#"+ areaId +" [name=NIDTFR]").val(nidtfr);
			$("#"+ areaId +" [name=NIDTTO]").val(nidtto);
			$("#"+ areaId +" [name=PFRDAT]").val(pfrdat);
			$("#"+ areaId +" [name=PTODAT]").val(ptodat);
			$("#"+ areaId +" [name=CREDAT]").val(credat);
			$("#"+ areaId +" [name=CRETIM]").val(cretim);
			
			uiList.UICheck($("#"+areaId));
			inputList.setCombo(areaId);
			inputList.setInput(areaId);
			
			$("[name=CUSRNM]").val(cusrnm);
			
			$(".msBox").attr("style","height:0");
			$(".msBox").children().eq(0).css("margin-top","0");
			
			popflg == "V"?$("#"+ areaId +" [name=POPFLG]").prop("checked",true):$("#"+ areaId +" [name=POPFLG]").prop("checked",false); 
			impflg == "V"?$("#"+ areaId +" [name=IMPFLG]").prop("checked",true):$("#"+ areaId +" [name=IMPFLG]").prop("checked",false); 
			
			var ntargt = netUtil.sendData({
				module : "Notice",
				command : "NITAG",
				sendType : "list",
				param : param	
			});
			
			if(ntargt && ntargt.data){
				var len = ntargt.data.length;
				if(len > 0){
					var arr = new Array();
					for(var i = 0; i < len; i++){
						var row = ntargt.data[i];
						var data = row["NTARGT"];
						
						arr.push(data);
					}
					
					$("[name=NTTAGT]").multipleSelect('setSelects', arr);
				}
			}
			
			var $obj = $("[name=POPFLG]");
			var flg = $obj.is(":checked");
			if(!flg){
				$("[name=PFRDAT]").attr("disabled",true);
				$("[name=PTODAT]").attr("disabled",true);
				$("[name=PFRDAT]").next().hide();
				$("[name=PTODAT]").next().hide();
			}else{
				var frDate = this.initDateFormat(0);
				var toDate = this.initDateFormat(5);
				
				if(pfrdat == "" && pfrdat == ""){
					$("[name=PFRDAT]").val(frDate);
					$("[name=PTODAT]").val(toDate);
				}
				
				$("[name=PFRDAT]").attr("disabled",false);
				$("[name=PTODAT]").attr("disabled",false);
				$("[name=PFRDAT]").next().show();
				$("[name=PTODAT]").next().show();
			}
			
			gridList.setGrid({
				id : "gridList2",
				module : "Notice",
				command : "NITBD_ATTACH",
				firstRowFocusType : false,
				editedClassType : false,
				emptyMsgType : false
			});
			
			setTimeout(function(){
				netUtil.send({
					module : "Notice",
					command : "NITBD_ATTACH",
					sendType : "list",
					bindType : "grid",
		            bindId   : "gridList2",
					param : param	
				});
			});
			
			var $form = document.frm;
			$form.target = "note";
			$form.submit();
			$frm.remove();
			
			break;
		default:
			break;
		}
	},
	
	beforeLord : function(note,src,seq,type){
		var $obj = $("#"+note);
		notice.iframeURLChange($obj, src, seq, type, null);
	},
	
	iframeURLChange : function (iframe, src, seq, type, callback){
	    var unloadHandler = function () {
	        setTimeout(function () {
	        	if(iframe.get(0) != null && iframe.get(0) != undefined && iframe.get(0).contentWindow != null && iframe.get(0).contentWindow != undefined){
		        	var chgFlag = false;
	        		var url = iframe.get(0).contentWindow.location.pathname;
		        	if(url.indexOf("/wms/notice/") == -1){
		        		iframe.removeAttr("src");
		        		chgFlag = true;
		        	}else{
		        		var sUrl = url.split("/");
		        		
		        		var fUrl1 = (sUrl[5] != null&&sUrl[5] != undefined)?sUrl[5]:"";
		        		var fUrl2 = (sUrl[4] != null&&sUrl[4] != undefined)?sUrl[4]:"";
		        		
		        		if(fUrl1 != ""){
		        			if(fUrl1.indexOf(".") > -1){
		        				var menuId = fUrl1.split(".")[0];
			        			var ext = fUrl1.split(".")[1];
			        			if(ext != "page"){
			        				chgFlag = true;
			        				iframe.removeAttr("src");
			        			}else if(menuId != configData.MENU_ID){
			        				chgFlag = true;
			        				iframe.removeAttr("src");
			        			}
		        			}else{
		        				chgFlag = true;
		        				iframe.removeAttr("src");
		        			}
		        		}else{
		        			chgFlag = true;
		        			iframe.removeAttr("src");
		        		}
		        		
		        		if(fUrl2 != ""){
		        			var srcSeq = src.split("/")[4];
		        			if(srcSeq != fUrl2){
		        				chgFlag = true;
		        				iframe.removeAttr("src");
		        			}
		        		}else{
		        			chgFlag = true;
		        			iframe.removeAttr("src");
		        		}
		        	}
		        	
		        	if(chgFlag){
		        		var $frm = $("<form>").attr({"name":"frm","action":src,"method":"POST"});
		    			$frm.append($("<input>").attr({"type":"hidden","name":"seq"}).val(seq));
		    			$frm.append($("<input>").attr({"type":"hidden","name":"type"}).val(type));
		        		
		    			$("#newBoard .elTd:eq(7)").append($frm);
		    			
		    			var $form = document.frm;
		    			$form.target = "note";
		    			$form.submit();
		    			$frm.remove();
		        	}
		        	
		            if(callback != null && callback != undefined && callback != ""){
		            	callback(iframe.get(0).contentWindow.location.href);
		            }
	        	}
	        }, 0);
	    };

	    function attachUnload() {
	        iframe.get(0).contentWindow.removeEventListener("unload", unloadHandler);
	        iframe.get(0).contentWindow.addEventListener("unload", unloadHandler);
	    }

	    iframe.get(0).addEventListener("load", attachUnload);
	    attachUnload();
	},
	
	dateChangeEvent : function(col){
		var $obj = $("#"+this.areaId+" [name="+col+"]");
		var val = $.trim($obj.val());
		
		var pattern = /[0-9]{4}.[0-9]{2}.[0-9]{2}/;
		if(!pattern.test(val) && val) {
			commonUtil.msgBox("VALID_date");
			$obj.val("");
			$obj.focus();
			return;
		}
		
		if(val){
			val = $.trim(commonUtil.replaceAll(val,".",""));
		}
		
		switch (col) {
		case "NIDTFR":
			if(val){
				var toDate = $.trim(commonUtil.replaceAll($("#"+this.areaId+" [name=NIDTTO]").val(),".",""));
				if(toDate){
					if(commonUtil.parseInt(val) > commonUtil.parseInt(toDate)){
						alert("공지기간의 시작일자가 종료일자보다 클 수 없습니다.");
						$obj.val("");
						$obj.focus();
						return;
					}
				}
			}
			break;
		case "NIDTTO":
			if(val){
				var frDate = $.trim(commonUtil.replaceAll($("#"+this.areaId+" [name=NIDTFR]").val(),".",""));
				if(frDate){
					if(commonUtil.parseInt(val) < commonUtil.parseInt(frDate)){
						alert("공지기간의 시작일자가 종료일자보다 클 수 없습니다.");
						$obj.val("");
						$obj.focus();
						return;
					}
				}else{
					alert("공지기간의 시작일자가 종료일자보다 클 수 없습니다.");
					$obj.val("");
					$("#"+this.areaId+" [name=NIDTFR]").focus();
					return;
				}
			}
			break;
		case "PFRDAT":
			if(val){
				var toDate = $.trim(commonUtil.replaceAll($("#"+this.areaId+" [name=PTODAT]").val(),".",""));
				if(toDate){
					if(commonUtil.parseInt(val) > commonUtil.parseInt(toDate)){
						alert("팝업 공지기간의 시작일자가 종료일자보다 클 수 없습니다.");
						$obj.val("");
						$obj.focus();
						return;
					}
				}
			}
			break;
		case "PTODAT":
			if(val){
				var frDate = $.trim(commonUtil.replaceAll($("#"+this.areaId+" [name=PFRDAT]").val(),".",""));
				if(frDate){
					if(commonUtil.parseInt(val) < commonUtil.parseInt(frDate)){
						alert("팝업 공지기간의 시작일자가 종료일자보다 클 수 없습니다.");
						$obj.val("");
						$obj.focus();
						return;
					}
				}else{
					alert("팝업 공지기간의 시작일자가 없습니다.");
					$obj.val("");
					$("#"+this.areaId+" [name=NIDTFR]").focus();
					return;
				}
			}
			break;	
		default:
			break;
		}
	},
	
	npopynChangeEvent : function(){
		var $obj = $("[name=POPFLG]");
		var flg = $obj.is(":checked");
		if(!flg){
			$("[name=PFRDAT]").val("");
			$("[name=PTODAT]").val("");
			
			$("[name=PFRDAT]").attr("disabled",true);
			$("[name=PTODAT]").attr("disabled",true);
			$("[name=PFRDAT]").next().hide();
			$("[name=PTODAT]").next().hide();
		}else{
			var frDate = this.initDateFormat(0);
			var toDate = this.initDateFormat(5);
			
			$("[name=PFRDAT]").val(frDate);
			$("[name=PTODAT]").val(toDate);
			
			$("[name=PFRDAT]").attr("disabled",false);
			$("[name=PTODAT]").attr("disabled",false);
			$("[name=PFRDAT]").next().show();
			$("[name=PTODAT]").next().show();
		}
	},
	
	initDateFormat : function(d){
		var date = new Date();
		var yy = date.getFullYear();
		var mm = date.getMonth() + 1;
		var dd = date.getDate();
		
		date.setDate(dd + d);
		
		yy = date.getFullYear();
		mm = date.getMonth() + 1;
		dd = date.getDate();
		
		if(mm < 10){
			mm = "0"+ mm; 
		}
		
		if(dd < 10){
			dd = "0"+ dd; 
		}
		
		return yy+"."+mm+"."+dd;
	},
	
	saveNotice : function(){
		var areaId = this.areaId;
		var contentData = dataBind.paramData(areaId);
		
		var titnti = $.trim(contentData.get("TITNTI"));
		var nidtfr = $.trim(contentData.get("NIDTFR"));
		var nidtto = $.trim(contentData.get("NIDTTO"));
		var contnt = $.trim(contentData.get("CONTNT"));
		var popflg = $.trim(contentData.get("POPFLG"));
		var pfrdat = $.trim(contentData.get("PFRDAT"));
		var ptodat = $.trim(contentData.get("PTODAT"));
		
		var nttagt = $.trim(commonUtil.replaceAll(contentData.get("NTTAGT"),"'",""));
		contentData.put("NTTAGT", nttagt);
		
		var noteData = document.getElementById("note").contentWindow.getNoteText();
		contentData.put("CONTNT",noteData);
		contentData.put(configData.GRID_ROW_STATE_ATT,this.saveType);
		
		if(this.saveType == "U"){
			contentData.put("NTISEQ",this.seq);
		}
		
		var sendData = new DataMap();
		sendData.put("content",contentData);
		
		if(!titnti){
			alert("제목을 입력해주세요.");
			$("#" + notice.areaId + " [name=TITNTI]").focus();
			return;
		}else if(!nidtfr){
			alert("공지기간을 입력해주세요.");
			$("#" + notice.areaId + " [name=NIDTFR]").focus();
			return;
		}else if(!nidtto){
			alert("공지기간을 입력해주세요.");
			$("#" + notice.areaId + " [name=NIDTTO]").focus();
			return;
		}else if(!nttagt){
			alert("공지대상을 입력해주세요.");
			$("#" + notice.areaId + " [name=NTTAGT]").focus();
			return;
		}else if(!noteData){
			alert("내용을 입력해주세요.");
			return;
		}
		
		if(popflg){
			if(!pfrdat){
				alert("팝업 공지기간을 입력해주세요.");
				$("#" + notice.areaId + " [name=PFRDAT]").focus();
				return;
			}
			if(!ptodat){
				alert("팝업 공지기간을 입력해주세요.");
				$("#" + notice.areaId + " [name=PTODAT]").focus();
				return;
			}
		}
		
		var attachData = gridList.getModifyData("gridList2", "A");
		var attachDataLen = attachData.length;
		if(attachDataLen > 0){
			sendData.put("attach", attachData);
		}else{
			sendData.put("attach", new Array());
		}
		
		sendData.put("PROGID", configData.MENU_ID);
		
		if(!commonUtil.msgConfirm(configData.MSG_MASTER_SAVE_CONFIRM)){
            return;
        }
		
		netUtil.send({
            url : "/wms/notice/json/SaveNT10.data",
            param : sendData,
            successFunction : "notice.noticeSaveCallBack"
        });
	},
	
	noticeSaveCallBack : function(json, status){
		if(json && json.data){
			if(json.data["result"] == "S"){
				commonUtil.msgBox("VALID_M0001");
				
				var ntiseq = json.data["NTISEQ"];
				notice.rowNum = -1;
				
				if(notice.saveType == "C"){
					notice.reloadGrid();
					setTimeout(function(){
						var list = gridList.getGridData("gridList", true);
						for(var i = 0; i < list.length; i++){
							var row = list[i];
							var seq = row.get("NTISEQ");
							if(seq == ntiseq){
								notice.rowNum = row.get(configData.GRID_ROW_NUM);
							}
						}
						
						notice.drawNotice("newBoard", ntiseq, "");
						gridList.setRowFocus("gridList", notice.rowNum, false);
						
						notice.rowNum = -1;
					},300);
				}else if(notice.saveType == "U"){
					var list = gridList.getGridData("gridList", true);
					for(var i = 0; i < list.length; i++){
						var row = list[i];
						var seq = row.get("NTISEQ");
						if(seq == ntiseq){
							notice.rowNum = row.get(configData.GRID_ROW_NUM);
						}
					}
					
					gridList.setRowFocus("gridList", notice.rowNum, false);
					
					var param = new DataMap();
					param.put("NTISEQ",ntiseq);
					
					var json = netUtil.sendData({
            			module : "Notice",
                        command : configData.MENU_ID,
                        sendType : "list",
                        param : param
                    });
					
					var headList = json.data;
					
					gridList.setColValue("gridList", notice.rowNum, "NTISEQ", headList[0]["NTISEQ"]);
					gridList.setColValue("gridList", notice.rowNum, "TITNTI", headList[0]["TITNTI"]);
					gridList.setColValue("gridList", notice.rowNum, "NTITYP", headList[0]["NTITYP"]);
					gridList.setColValue("gridList", notice.rowNum, "IMPFLG", headList[0]["IMPFLG"]);
					gridList.setColValue("gridList", notice.rowNum, "IMGFLG", headList[0]["IMGFLG"]);
					gridList.setColValue("gridList", notice.rowNum, "CREUSR", headList[0]["CREUSR"]);
					gridList.setColValue("gridList", notice.rowNum, "CUSRNM", headList[0]["CUSRNM"]);
					gridList.setColValue("gridList", notice.rowNum, "CREDAT", headList[0]["CREDAT"]);
					gridList.setColValue("gridList", notice.rowNum, "CRETIM", headList[0]["CRETIM"]);
					
					var imgHtml = "";
					if(headList[0]["IMGFLG"] == "V"){
						imgHtml = "<div class='gridIcon-center'><span class='impflg'>Icon</span></div>";
					}else if(headList[0]["IMGFLG"] == "X"){
						imgHtml = "<div class='gridIcon-center'><span class='regAft'>Icon</span></div>";
					}else{
						
					}
					
					var $gridObj = $("#gridList tr");
					
					$gridObj.each(function(){
						$(this).find("td").removeClass("editabled");
						var gridRowNum = commonUtil.parseInt($(this).attr(configData.GRID_ROW_NUM));
						if(gridRowNum == notice.rowNum){
							$(this).find("td").eq(0).text(notice.rowNum + 1);
							$(this).find("td").eq(1).html(imgHtml);
						}
					});
					
					gridList.setRowState("gridList", configData.GRID_ROW_STATE_READ, notice.rowNum);
					
					notice.drawNotice("newBoard", ntiseq, "");
					
					notice.rowNum = -1;
				}
			}
		}
	},
	
	deleteNotice : function(){
		if(!commonUtil.msgConfirm("VALID_M0016")){
            return;
        }
		
		var param = new DataMap();
		param.put("NTISEQ",this.seq);
		
		var attachDataLen = gridList.getGridDataCount("gridList2");
		if(attachDataLen > 0){
			var attachData = gridList.getGridData("gridList2",true);
			param.put("attach", attachData);
		}else{
			param.put("attach", new Array());
		}
		
		netUtil.send({
            url : "/wms/notice/json/DeleteNT10.data",
            param : param,
            successFunction : "notice.noticeDeleteCallBack"
        });
	},
	
	noticeDeleteCallBack : function(json, status){
		if(json && json.data){
			if(json.data["result"] == "S"){
				notice.rowNum = -1;
				commonUtil.msgBox("VALID_M0003");
				notice.reloadGrid();
			}
		}
	},
	
	reloadGrid : function(){
		if(validate.check("searchArea")){
			notice.drawNoticeEditArea("newBoard","init");
			var param = inputList.setRangeParam("searchArea");
			gridList.gridList({
				id : "gridList",
				param : param
			});
		}
	}
}

var notice = new Notice();