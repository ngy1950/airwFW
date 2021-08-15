Mobile = function() {
	this.popData;
	this.linkData;
};

Mobile.prototype = {
	linkPopOpen : function(url, data) {
		this.popData = data;
		var sWidth = window.screen.availWidth;
		var sHeight = window.screen.availHeight;

		window.opener = self;
		window.open(url, url, "height="+sHeight+",width="+sWidth+",left=0,top=0,resizable=no");
	},
	getLinkPopData : function(menuId) {
		return window.opener.mobile.popData;
	},
	linkPopClose : function(data) {
		window.opener.mobile.popData = data;
		window.close();
		try{
			window.opener.linkPopCloseEvent(data);
		}catch(e){
			console.debug(window);
		}
	},
	linkPageOpen : function(menuId, data) {
		window.top.linkPage(menuId, data);
	},
	getLinkPageData : function(menuId) {
		this.linkData = window.top.getLinkData(menuId);
		window.top.initListData(menuId);
		return this.linkData;
	},
	toString : function() {
		return "Mobile";
	}
};

var mobile = new Mobile();