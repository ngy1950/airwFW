MobileDatePicker = function(){
	this.datePickerId = "datePicker";
	
	this.ym = 0;
	this.ymf = true;
	this.yArr = ["2017","2018","2019","2020","2021","2022","2023"];
	this.initYear = this.yArr[0];
	this.year = this.initYear;
	this.lastYear = this.yArr[this.yArr.length - 1];
	this.beforeYear = this.yArr[this.yArr.length - 2];
	this.yearLength = this.yArr.length;
	this.yearHeight = this.yearLength * 50;
	this.yearStartY = 0; 
	this.yearEndY = 0;
	this.touchYearStartY = 0; 
	this.touchYearEndY = 0;

	this.mm = 0;
	this.mmf = true;
	this.mArr = ["01","02","03","04","05","06","07","08","09","10","11","12"];
	this.month = this.mArr[0];
	this.initMonth = this.mArr[0];
	this.lastMonth = this.mArr[this.mArr.length - 1];
	this.beforeMonth = this.mArr[this.mArr.length - 2];
	this.monthLength = this.mArr.length;
	this.monthHeight = this.monthLength * 50;
	this.monthStartY = 0; 
	this.monthEndY = 0;
	this.touchMonthStartY = 0;
	this.touchMonthEndY = 0;

	this.dd = 0;
	this.ddf = true;
	this.dArr = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"];
	this.day = this.dArr[0];
	this.initDay = this.dArr[0];
	this.lastDay = this.dArr[this.dArr.length - 1];
	this.beforeDay = this.dArr[this.dArr.length - 2];
	this.dayLength = this.dArr.length;
	this.dayHeight = this.dayLength * 50;
	this.dayStartY = 0;
	this.dayEndY = 0;
	this.touchDayStartY = 0; 
	this.touchDayEndY = 0;
	
	this.datePicker = new DataMap();
}

MobileDatePicker.prototype = {
	set : function(option){
		var beforeYear = option.beforeYear;
		var afterYear  = option.afterYear;
		
		var yearTitle  = option.yearTitle;
		var monthTitle = option.monthTitle;
		var dayTitle   = option.dayTitle;
		
		//title setting
		var $titleArea = $(".datePicker .title ul li");
		$titleArea.eq(0).html(yearTitle);
		$titleArea.eq(1).html(monthTitle);
		$titleArea.eq(2).html(dayTitle);
		
		//year setting
		var toDate = new Date();
		
		var yy = toDate.getFullYear();
		var mm = toDate.getMonth() + 1;
		var dd = toDate.getDate();
		
		var y = yy.toString();
		var m = mm < 10? "0" + mm:mm.toString();
		var d = dd < 10? "0" + dd:dd.toString();
		
		mobileDatePicker.yArr = [];
		for(var i = beforeYear; i > 0; i--){
			var year = yy - i;
			mobileDatePicker.yArr.push(year.toString());
		}
		
		for(var i = 0; i < afterYear; i++){
			var year = yy + i;
			mobileDatePicker.yArr.push(year.toString());
		}
		
		var $yearArea  = $(".datePicker .year");
		var $monthArea = $(".datePicker .month");
		var $dayArea   = $(".datePicker .day");
		
		var $yearUl = $yearArea.find("ul");
		
		$yearUl.children().remove();
		
		for(var i = 0; i < mobileDatePicker.yArr.length; i++){
			var $li = $("<li>").clone().addClass("no-drag");
			$li.attr("data-date",mobileDatePicker.yArr[i]);
			$yearUl.append($li.html(mobileDatePicker.yArr[i]));
		}
		
		$yearUl.find("li").eq(0).before($("<li>").clone().addClass("no-drag"));
		$yearUl.find("li").eq(mobileDatePicker.yArr.length).after($("<li>").clone().addClass("no-drag"));
		
		mobileDatePicker.initYear   = mobileDatePicker.yArr[0];
		mobileDatePicker.year       = mobileDatePicker.initYear;
		mobileDatePicker.lastYear   = mobileDatePicker.yArr[mobileDatePicker.yArr.length - 1];
		mobileDatePicker.beforeYear = mobileDatePicker.yArr[mobileDatePicker.yArr.length - 2];
		mobileDatePicker.yearLength = mobileDatePicker.yArr.length;
		mobileDatePicker.yearHeight = mobileDatePicker.yearLength * 50;
		
		//Month Setting
		var $monthUl = $monthArea.find("ul");
		
		$monthUl.children().remove();
		
		for(var i = 0; i < mobileDatePicker.mArr.length; i++){
			var $li = $("<li>").clone().addClass("no-drag");
			$li.attr("data-date",mobileDatePicker.mArr[i]);
			$monthUl.append($li.html(mobileDatePicker.mArr[i]));
		}
		
		$monthUl.find("li").eq(0).before($("<li>").clone().addClass("no-drag"));
		$monthUl.find("li").eq(mobileDatePicker.mArr.length).after($("<li>").clone().addClass("no-drag"));
		
		//Day Setting
		var $dayUl = $dayArea.find("ul");
		
		$dayUl.children().remove();
		
		for(var i = 0; i < mobileDatePicker.dArr.length; i++){
			var $li = $("<li>").clone().addClass("no-drag");
			$li.attr("data-date",mobileDatePicker.dArr[i]);
			$dayUl.append($li.html(mobileDatePicker.dArr[i]));
		}
		
		$dayUl.find("li").eq(0).before($("<li>").clone().addClass("no-drag"));
		$dayUl.find("li").eq(mobileDatePicker.dArr.length).after($("<li>").clone().addClass("no-drag"));
		
		//event setting
		//YEAR
		$yearArea.on("touchstart",function(e){
			e.preventDefault();
			mobileDatePicker.touchYearStartY = e.originalEvent.changedTouches[0].screenY;
		});
		$yearArea.on("touchend",function(e){
			e.preventDefault();
			mobileDatePicker.touchYearEndY = e.originalEvent.changedTouches[0].screenY;
			if(mobileDatePicker.ymf){
				mobileDatePicker.ymf = false;
				var ymm = 1;
				var evt = "";
				if(mobileDatePicker.touchYearStartY - mobileDatePicker.touchYearEndY > 5){
					evt = "up";
					ymm = Math.floor((mobileDatePicker.touchYearStartY - mobileDatePicker.touchYearEndY)/20);
					if(ymm <= 1){
						mobileDatePicker.ym = mobileDatePicker.ym + 50;
					}else{
						mobileDatePicker.ym = mobileDatePicker.ym +(ymm*50);
						if(mobileDatePicker.ym >= mobileDatePicker.yearHeight){
							mobileDatePicker.ym = mobileDatePicker.yearHeight;
						}
					}
				}else if(mobileDatePicker.touchYearEndY - mobileDatePicker.touchYearStartY > 5){
					evt = "down";
					ymm = Math.floor((mobileDatePicker.touchYearEndY - mobileDatePicker.touchYearStartY)/20);
					if(ymm <= 1){
						var n = 50;
						if(mobileDatePicker.year == mobileDatePicker.lastYear){
							n = 100;
						}
						mobileDatePicker.ym = mobileDatePicker.ym - n;
					}else{
						mobileDatePicker.ym = mobileDatePicker.ym -(ymm*50)
						if(mobileDatePicker.year == mobileDatePicker.lastYear){
							mobileDatePicker.ym = mobileDatePicker.ym - 100;
						}
					}
					
					if(mobileDatePicker.ym <= 0){
						mobileDatePicker.ym = 0;
					}
				}
				$(this).animate({scrollTop : mobileDatePicker.ym},200,function(){
					var idx = mobileDatePicker.ym/50;
					mobileDatePicker.year = mobileDatePicker.yArr[idx];
					if(mobileDatePicker.ym <= 0){
						mobileDatePicker.year = mobileDatePicker.initYear;
						mobileDatePicker.ym = 0;
					}
					if(mobileDatePicker.ym >= mobileDatePicker.yearHeight){
						mobileDatePicker.year = mobileDatePicker.lastYear;
						mobileDatePicker.ym = mobileDatePicker.yearHeight;
					}
					
					mobileDatePicker.ymf = true;
					
					mobileDatePicker.setDay(mobileDatePicker.year,mobileDatePicker.month);
					
					mobileDatePicker.setSelectDateColor();
				});
			}
		});
		$yearArea.on("mousewheel",function(e){
			e.preventDefault();
			if(mobileDatePicker.ymf){
				var wheel = e.originalEvent.wheelDelta;
				mobileDatePicker.ymf = false;
				var evt = "";
				if(wheel > 0){
					evt = "up";
					if(mobileDatePicker.ym >= mobileDatePicker.yearHeight){
						evt = "";
						mobileDatePicker.ym = mobileDatePicker.yearHeight;
						mobileDatePicker.year = mobileDatePicker.lastYear;
					}else{
						mobileDatePicker.ym = mobileDatePicker.ym + 50;
					}
				}else{
					evt = "down";
					if(mobileDatePicker.ym <= 0){
						evt = "";
						mobileDatePicker.ym = 0;
						mobileDatePicker.year = mobileDatePicker.initYear;
					}else if(mobileDatePicker.ym == mobileDatePicker.yearHeight){
						evt = "";
						mobileDatePicker.ym = mobileDatePicker.ym - 100;
						mobileDatePicker.year = mobileDatePicker.beforeYear;
					}else{
						mobileDatePicker.ym = mobileDatePicker.ym - 50;
					}
				}
				$(this).animate({scrollTop : mobileDatePicker.ym},0,function(){
					var idx = mobileDatePicker.ym/50;
					mobileDatePicker.year = mobileDatePicker.yArr[idx];
					if(mobileDatePicker.ym <= 0){
						mobileDatePicker.year = mobileDatePicker.initYear;
					}
					if(mobileDatePicker.ym >= mobileDatePicker.yearHeight){
						mobileDatePicker.year = mobileDatePicker.lastYear;
					}
					
					mobileDatePicker.ymf = true;
					
					mobileDatePicker.setDay(mobileDatePicker.year,mobileDatePicker.month);
					
					mobileDatePicker.setSelectDateColor();
				});
			}
		});
		
		//MONTH
		$monthArea.on("touchstart",function(e){
			e.preventDefault();
			mobileDatePicker.touchMonthStartY = e.originalEvent.changedTouches[0].screenY;
		});
		$monthArea.on("touchend",function(e){
			e.preventDefault();
			mobileDatePicker.touchMonthEndY = e.originalEvent.changedTouches[0].screenY;
			if(mobileDatePicker.mmf){
				mobileDatePicker.mmf = false;
				var evt = "";
				var cmm = 1;
				if(mobileDatePicker.touchMonthStartY - mobileDatePicker.touchMonthEndY > 5){
					evt = "up";
					cmm = Math.floor((mobileDatePicker.touchMonthStartY - mobileDatePicker.touchMonthEndY)/20);
					if(cmm <= 1){
						mobileDatePicker.mm = mobileDatePicker.mm + 50;
					}else{
						mobileDatePicker.mm = mobileDatePicker.mm +(cmm*50);
						if(mobileDatePicker.mm >= mobileDatePicker.monthHeight){
							mobileDatePicker.mm = mobileDatePicker.monthHeight;
						}
					}
				}else if(mobileDatePicker.touchMonthEndY - mobileDatePicker.touchMonthStartY > 5){
					evt = "down";
					cmm = Math.floor((mobileDatePicker.touchMonthEndY - mobileDatePicker.touchMonthStartY)/20);
					if(cmm <= 1){
						var n = 50;
						if(mobileDatePicker.month == mobileDatePicker.lastMonth){
							n = 100;
						}
						mobileDatePicker.mm = mobileDatePicker.mm - n;
					}else{
						mobileDatePicker.mm = mobileDatePicker.mm -(cmm*50)
						if(mobileDatePicker.month == mobileDatePicker.lastMonth){
							mobileDatePicker.mm = mobileDatePicker.mm - 100;
						}
					}
					
					if(mobileDatePicker.mm <= 0){
						mobileDatePicker.mm = 0;
					}
				}
				$(this).animate({scrollTop : mobileDatePicker.mm},200,function(){
					var idx = mobileDatePicker.mm/50;
					mobileDatePicker.month = mobileDatePicker.mArr[idx];
					if(mobileDatePicker.mm <= 0){
						mobileDatePicker.month = mobileDatePicker.initMonth;
						mobileDatePicker.mm = 0;
					}
					if(mobileDatePicker.mm >= mobileDatePicker.monthHeight){
						mobileDatePicker.month = mobileDatePicker.lastMonth;
						mobileDatePicker.mm = mobileDatePicker.monthHeight;
					}
					
					mobileDatePicker.mmf = true;
					
					mobileDatePicker.setDay(mobileDatePicker.year,mobileDatePicker.month);
					
					mobileDatePicker.setSelectDateColor();
				});
			}
		});
		$monthArea.on("mousewheel",function(e){
			e.preventDefault();
			if(mobileDatePicker.mmf){
				var wheel = e.originalEvent.wheelDelta;
				mobileDatePicker.mmf = false;
				var evt = "";
				if(wheel > 0){
					evt = "up";
					if(mobileDatePicker.mm >= mobileDatePicker.monthHeight){
						evt = "";
						mobileDatePicker.mm = mobileDatePicker.monthHeight;
						mobileDatePicker.month = mobileDatePicker.lastMonth;
					}else{
						mobileDatePicker.mm = mobileDatePicker.mm + 50;
					}
				}else{
					evt = "down";
					if(mobileDatePicker.mm <= 0){
						evt = "";
						mobileDatePicker.mm = 0;
						mobileDatePicker.month = mobileDatePicker.initMonth;
					}else if(mobileDatePicker.mm == mobileDatePicker.monthHeight){
						evt = "";
						mobileDatePicker.mm = mobileDatePicker.mm - 100;
						mobileDatePicker.month = mobileDatePicker.beforeMonth;
					}else{
						mobileDatePicker.mm = mobileDatePicker.mm - 50;
					}
				}
				$(this).animate({scrollTop : mobileDatePicker.mm},0,function(){
					var idx = mobileDatePicker.mm/50;
					mobileDatePicker.month = mobileDatePicker.mArr[idx];
					if(mobileDatePicker.mm <= 0){
						mobileDatePicker.month = mobileDatePicker.initMonth;
					}
					if(mobileDatePicker.mm >= mobileDatePicker.monthHeight){
						mobileDatePicker.month = mobileDatePicker.lastMonth;
					}
					
					mobileDatePicker.mmf = true;
					
					mobileDatePicker.setDay(mobileDatePicker.year,mobileDatePicker.month);
					
					mobileDatePicker.setSelectDateColor();
				});
			}
		});
		
		//DAY
		$dayArea.on("touchstart",function(e){
			e.preventDefault();
			mobileDatePicker.touchDayStartY = e.originalEvent.changedTouches[0].screenY;
		});
		$dayArea.on("touchend",function(e){
			e.preventDefault();
			mobileDatePicker.touchDayEndY = e.originalEvent.changedTouches[0].screenY;
			if(mobileDatePicker.ddf){
				mobileDatePicker.ddf = false;
				var evt = "";
				var dmm = 1;
				if(mobileDatePicker.touchDayStartY - mobileDatePicker.touchDayEndY > 5){
					evt = "up";
					dmm = Math.floor((mobileDatePicker.touchDayStartY - mobileDatePicker.touchDayEndY)/20);
					if(dmm <= 1){
						mobileDatePicker.dd = mobileDatePicker.dd + 50;
					}else{
						mobileDatePicker.dd = mobileDatePicker.dd +(dmm*50);
						if(mobileDatePicker.dd >= mobileDatePicker.dayHeight){
							mobileDatePicker.dd = mobileDatePicker.dayHeight;
						}
					}
				}else if(mobileDatePicker.touchDayEndY - mobileDatePicker.touchDayStartY > 5){
					evt = "down";
					dmm = Math.floor((mobileDatePicker.touchDayEndY - mobileDatePicker.touchDayStartY)/20);
					if(dmm <= 1){
						var n = 50;
						if(mobileDatePicker.day == mobileDatePicker.lastDay){
							n = 100;
						}
						mobileDatePicker.dd = mobileDatePicker.dd - n;
					}else{
						mobileDatePicker.dd = mobileDatePicker.dd -(dmm*50)
						if(mobileDatePicker.day == mobileDatePicker.lastDay){
							mobileDatePicker.dd = mobileDatePicker.dd - 100;
						}
					}
					
					if(mobileDatePicker.dd <= 0){
						mobileDatePicker.dd = 0;
					}
				}
				$(this).animate({scrollTop : mobileDatePicker.dd},200,function(){
					var idx = mobileDatePicker.dd/50;
					mobileDatePicker.day = mobileDatePicker.dArr[idx];
					if(mobileDatePicker.dd <= 0){
						mobileDatePicker.day = mobileDatePicker.initDay;
						mobileDatePicker.dd = 0;
					}
					if(mobileDatePicker.dd >= mobileDatePicker.dayHeight){
						mobileDatePicker.day = mobileDatePicker.lastDay;
						mobileDatePicker.dd = mobileDatePicker.dayHeight;
					}
					
					mobileDatePicker.ddf = true;
					
					mobileDatePicker.setSelectDateColor();
				});
			}
		});
		$dayArea.on("mousewheel",function(e){
			e.preventDefault();
			if(mobileDatePicker.ddf){
				var wheel = e.originalEvent.wheelDelta;
				mobileDatePicker.ddf = false;
				var evt = "";
				if(wheel > 0){
					evt = "up";
					if(mobileDatePicker.dd >= mobileDatePicker.dayHeight){
						evt = "";
						mobileDatePicker.dd = mobileDatePicker.dayHeight;
						mobileDatePicker.day = mobileDatePicker.lastDay;
					}else{
						mobileDatePicker.dd = mobileDatePicker.dd + 50;
					}
				}else{
					evt = "down";
					if(mobileDatePicker.dd <= 0){
						evt = "";
						mobileDatePicker.dd = 0;
						mobileDatePicker.day = mobileDatePicker.initDay;
					}else if(mobileDatePicker.dd == mobileDatePicker.dayHeight){
						evt = "";
						mobileDatePicker.dd = mobileDatePicker.dd - 100;
						mobileDatePicker.Day = mobileDatePicker.beforeDay;
					}else{
						mobileDatePicker.dd = mobileDatePicker.dd - 50;
					}
				}
				$(this).animate({scrollTop : mobileDatePicker.dd},0,function(){
					var idx = mobileDatePicker.dd/50;
					mobileDatePicker.day = mobileDatePicker.dArr[idx];
					if(mobileDatePicker.dd <= 0){
						mobileDatePicker.day = mobileDatePicker.initDay;
					}
					if(mobileDatePicker.dd >= mobileDatePicker.dayHeight){
						mobileDatePicker.day = mobileDatePicker.lastDay;
					}
					
					mobileDatePicker.ddf = true;
					
					mobileDatePicker.setSelectDateColor();
				});
			}
		});
	},
	
	setDay : function(year, month){
		var beforeLen = mobileDatePicker.dayLength;
		
		mobileDatePicker.dArr = [];
		
		var date = new Date(year, month); 
			date = new Date(date - 1); 
		var dd = date.getDate();
		for(var i = 0; i < dd; i++){
			var d = "";
			if((i+1) < 10){
				d = "0" + (i+1);
			}else{
				d = (i+1).toString();
			}
			mobileDatePicker.dArr.push(d);
		}
		
		mobileDatePicker.initDay   = mobileDatePicker.dArr[0];
		mobileDatePicker.lastDay   = mobileDatePicker.dArr[mobileDatePicker.dArr.length - 1];
		mobileDatePicker.beforeDay = mobileDatePicker.dArr[mobileDatePicker.dArr.length - 2];
		mobileDatePicker.dayLength = mobileDatePicker.dArr.length;
		mobileDatePicker.dayHeight = mobileDatePicker.dayLength * 50;

		var objLen = beforeLen;
		if(objLen > mobileDatePicker.dayLength){
			var len = objLen - mobileDatePicker.dayLength;
			for(var i = 0 ; i < len; i++){
				var $obj = $(".datePicker .day ul li");
				$obj.eq((objLen - i)).remove();
			}
		}else if(objLen < mobileDatePicker.dayLength){
			var len = mobileDatePicker.dayLength - objLen;
			for(var i = 0 ; i < len; i++){
				var $itemObj = $(".datePicker .day ul li");
				
				var $li = $("<li>");
				var $appendObj = $itemObj.eq(objLen + i);
				var ld = mobileDatePicker.dArr[objLen + i];
				var $dayObj = $li.clone().addClass("no-drag");
				
				$dayObj.attr("data-date",ld);
				
				$appendObj.after($dayObj.html(ld));
			}
		}
		
		if(mobileDatePicker.dArr.indexOf(mobileDatePicker.day) == -1){
			mobileDatePicker.day = mobileDatePicker.lastDay;
		}
		
		mobileDatePicker.dd = (commonUtil.parseInt(mobileDatePicker.day)*50) - 50;
		$(".datePicker .day").animate({scrollTop : mobileDatePicker.dd},0);
		
		mobileDatePicker.setSelectDateColor();
	},
	
	setSelectDateColor : function(){
		var yy = mobileDatePicker.year;
		var mm = mobileDatePicker.month;
		var dd = mobileDatePicker.day;
		
		var $selectYear  = $(".datePicker .year ul li[data-date="+yy+"]");
		var $selectMonth = $(".datePicker .month ul li[data-date="+mm+"]");
		var $selectDay   = $(".datePicker .day ul li[data-date="+dd+"]");
		
		$(".datePicker ul li").removeClass("on");
		
		$selectYear.addClass("on");
		$selectMonth.addClass("on");
		$selectDay.addClass("on");
	},
	
	getSelectDate : function(){
		var yy = mobileDatePicker.year;
		var mm = mobileDatePicker.month;
		var dd = mobileDatePicker.day;
		
		var date = yy + mm + dd;
		
		return date;
	},
		
	setDatePicker : function(option){
		var intiData = new DataMap();
		
		var id     = option.id;
		var name   = option.name;
		var bindId = option.bindId;
		var gridId = "";
		if($.trim(option.gridId) != ""|| option.gridId != undefined || option.gridId != null){
			gridId = option.gridId;
		}
		
		var $obj   = $("#"+bindId+" [name="+name+"]");
		
		intiData.put("name", name);
		intiData.put("bindId", bindId);
		intiData.put("object",$obj);
		intiData.put("gridId",gridId);
		
		mobileDatePicker.datePicker.put(id,intiData);
		
		mobileDatePicker.drawDatePicker(id);
		//numberKeyPad.set($obj,bindId,gridId);
	},
	
	drawDatePicker : function(id){
		var datePicker = mobileDatePicker.datePicker.get(id);
		var bindId = datePicker.get("bindId");
		var name = datePicker.get("name");
		var $obj = datePicker.get("object");
		var $input  = $obj.addClass("input_btn").attr("id",id);
		var $button = $("<button>").clone().addClass("btn_date_picker").append($("<img>").clone().attr("src","/common/images/cal_icon.png"));
		
		$input.attr("UIFormat","D");
		$input.attr("type","tel");
		$button.attr("onclick","mobileDatePicker.openDatePicker('"+id+"')");
		
		$input.after($button);
		inputList.setInput(id);
		uiList.UICheck();
		
		var $returnInput = $("#"+bindId+" [name="+name+"]");
		$returnInput.on("click",function(){
			var value = commonUtil.replaceAll($(this).val(),".","");
			$(this).val(value);
			mobileKeyPad.openMobileKeyPad($(this));
			
			setTimeout(function(){
				if($returnInput.val().length > 0 && !$returnInput.hasClass("on")){
					$returnInput.select();
					$returnInput.addClass("on");
				}else{
					$returnInput.focus();
				}
			});
		});
		$returnInput.on("keydown",function(e){
			if(e.keyCode == 13){
				$returnInput.blur();
			}
		});
		$returnInput.blur(function(){
			var param = dataBind.paramData(bindId);
			var data = new DataMap();
			data.put(name,param.get(name));
			dataBind.dataBind(data, bindId);
			dataBind.dataNameBind(data, bindId);
			$returnInput.removeClass("on");
		});
	},
	
	openDatePicker : function(id){
		var toDate = new Date();
		
		var y = toDate.getFullYear();
		var m = toDate.getMonth() + 1;
		var d = toDate.getDate();
		
		var yy = y.toString();
		var mm = m < 10? "0" + m:m.toString();
		var dd = d < 10? "0" + d:d.toString();
		
		var $returnObj = mobileDatePicker.datePicker.get(id).get("object");
		
		var isReadOnly = $returnObj.attr("readonly");
		if(isReadOnly == "readonly"){
			return;
		}
		
		var value = $returnObj.val();
		if($.trim(value) != "" && value != null && value != undefined){
			value = commonUtil.replaceAll(value,".","");
			if(validate.isValidDate(value)){
				if(mobileDatePicker.yArr.indexOf(value.substr(0,4)) > -1 && mobileDatePicker.mArr.indexOf(value.substr(4,2)) > -1
					&& mobileDatePicker.dArr.indexOf(value.substr(6,2)) > -1){
						yy = value.substr(0,4);
						mm = value.substr(4,2);
						dd = value.substr(6,2);
				}
			}
		}
		
		mobileDatePicker.setDay(yy,mm);
		
		var yIdx = mobileDatePicker.yArr.indexOf(yy);
		var mIdx = mobileDatePicker.mArr.indexOf(mm);
		var dIdx = mobileDatePicker.dArr.indexOf(dd);
		
		mobileDatePicker.year = yy;
		mobileDatePicker.month = mm;
		mobileDatePicker.day = dd;
		
		mobileDatePicker.ym = yIdx*50;
		mobileDatePicker.mm = mIdx*50;
		mobileDatePicker.dd = dIdx*50;
		
		$(".year").animate({scrollTop : 0});
		$(".month").animate({scrollTop : 0});
		$(".day").animate({scrollTop : 0});
		
		$(".year").animate({scrollTop : mobileDatePicker.ym},0);
		$(".month").animate({scrollTop : mobileDatePicker.mm},0);
		$(".day").animate({scrollTop : mobileDatePicker.dd},0);
		
		//button event setting
		var $obj = $("#"+mobileDatePicker.datePickerId);
		
		var $buttonArea = $obj.find(".button");
		$buttonArea.find(".confim").attr("onclick","mobileDatePicker.confirmDatePicker('"+id+"')");
		$buttonArea.find(".cancel").attr("onclick","mobileDatePicker.closeDatePicker('"+id+"')");
		
		mobileDatePicker.setSelectDateColor();
		
		mobileKeyPad.focusOnEvent($returnObj);
		
		$obj.fadeIn(300);
	},
	
	confirmDatePicker : function(id){
		var $obj = $("#"+mobileDatePicker.datePickerId);
		
		//return data
		var date       = mobileDatePicker.getSelectDate();
		
		var datePicker = mobileDatePicker.datePicker.get(id);
		var $returnObj = datePicker.get("object");
		var areaId     = datePicker.get("bindId");
		var key        = datePicker.get("name");
		var gridId     = datePicker.get("gridId");
		
		var data = new DataMap();
		data.put(key,date);
		
		dataBind.dataBind(data,areaId);
		dataBind.dataNameBind(data,areaId);
		
		if(gridId != ""){
			var rowNum = gridList.getFocusRowNum(gridId);
			gridList.setColValue(gridId,rowNum,key,date);
		}
		
		//init
		mobileDatePicker.initDatePickerData();
		
		//remove button event
		var $buttonArea = $obj.find(".button");
		$buttonArea.find(".confim").removeAttr("onclick");
		$buttonArea.find(".cancel").removeAttr("onclick");
		
		$obj.fadeOut(300);
		
		if(commonUtil.checkFn("confirmDatePickerEvent")){
			confirmDatePickerEvent(areaId,key,date,$returnObj);
		}
	},
	
	closeDatePicker : function(id){
		var $obj = $("#"+mobileDatePicker.datePickerId);
		
		//init
		mobileDatePicker.initDatePickerData();
		
		//remove button event
		var $buttonArea = $obj.find(".button");
		$buttonArea.find(".confim").removeAttr("onclick");
		$buttonArea.find(".cancel").removeAttr("onclick");
		
		$obj.fadeOut(300);
	},
	
	initDatePickerData : function(){
		mobileDatePicker.ym = 0;
		mobileDatePicker.ymf = true;
		mobileDatePicker.initYear = mobileDatePicker.yArr[0];
		mobileDatePicker.year = mobileDatePicker.initYear;
		mobileDatePicker.lastYear = mobileDatePicker.yArr[mobileDatePicker.yArr.length - 1];
		mobileDatePicker.beforeYear = mobileDatePicker.yArr[mobileDatePicker.yArr.length - 2];
		mobileDatePicker.yearLength = mobileDatePicker.yArr.length;
		mobileDatePicker.yearHeight = mobileDatePicker.yearLength * 50;
		mobileDatePicker.yearStartY = 0; 
		mobileDatePicker.yearEndY = 0;
		mobileDatePicker.touchYearStartY = 0; 
		mobileDatePicker.touchYearEndY = 0;

		mobileDatePicker.mm = 0;
		mobileDatePicker.mmf = true;
		mobileDatePicker.mArr = ["01","02","03","04","05","06","07","08","09","10","11","12"];
		mobileDatePicker.month = mobileDatePicker.mArr[0];
		mobileDatePicker.mobileDatePicker = mobileDatePicker.mArr[0];
		mobileDatePicker.lastMonth = mobileDatePicker.mArr[mobileDatePicker.mArr.length - 1];
		mobileDatePicker.beforeMonth = mobileDatePicker.mArr[mobileDatePicker.mArr.length - 2];
		mobileDatePicker.monthLength = mobileDatePicker.mArr.length;
		mobileDatePicker.monthHeight = mobileDatePicker.monthLength * 50;
		mobileDatePicker.monthStartY = 0; 
		mobileDatePicker.monthEndY = 0;
		mobileDatePicker.touchMonthStartY = 0;
		mobileDatePicker.touchMonthEndY = 0;

		/*mobileDatePicker.dd = 0;
		mobileDatePicker.ddf = true;
		mobileDatePicker.dArr = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"];
		mobileDatePicker.day = mobileDatePicker.dArr[0];
		mobileDatePicker.initDay = mobileDatePicker.dArr[0];
		mobileDatePicker.lastDay = mobileDatePicker.dArr[mobileDatePicker.dArr.length - 1];
		mobileDatePicker.beforeDay = mobileDatePicker.dArr[mobileDatePicker.dArr.length - 2];
		mobileDatePicker.dayLength = mobileDatePicker.dArr.length;
		mobileDatePicker.dayHeight = mobileDatePicker.dayLength * 50;
		mobileDatePicker.dayStartY = 0;
		mobileDatePicker.dayEndY = 0;
		mobileDatePicker.touchDayStartY = 0; 
		mobileDatePicker.touchDayEndY = 0;*/
	}
}

var mobileDatePicker = new MobileDatePicker();