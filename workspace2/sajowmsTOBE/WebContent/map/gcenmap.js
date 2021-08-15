var gcen = gcen || {};

if (typeof window.gcen === "undefined") {
    window.gcen = {}
}
if (!gcen.GcenMap) {
    gcen.GcenMap = {}
}

gcen.loadJQuery = function () {
    if (window.jQuery) return;

    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "./jquery-3.4.1.min.js";
    script.onload = function () {
        console.log("jQuery loaded.");
    };
    ( document.getElementsByTagName('head')[0] || document.getElementsByTagName('script')[0] ).appendChild(script);
};

gcen.getMapsetVersion = function () {
    var mapsetVer = "";

    if (window.jQuery) {
        $.ajax({
            type: "GET",
            async: false,
            url: "http://210.116.106.77:4780/gcenmap/map/mapset-info",
            dataType: "jsonp",
            success: function (resp) {
                console.log("Response : " + resp);

                mapsetVer = resp.version;
            },
            error : function(e){
                console.log("mapset load error");
            }

        });
    } else {
        mapsetVer = "" + Math.random();
    }
    console.log("mapset version [" + mapsetVer + "]");

    return mapsetVer;
};

gcen.loadMap = function (element, view, defaultMapset, interactions) {

    if (!window.jQuery) {
        console.log("jQuery lib not loaded.");
    }

    var mapsetVersion = gcen.getMapsetVersion();

    var layers = [
        new ol.layer.Tile({
            id: "mapsetLayer",
            source: new ol.source.XYZ({
				//지도엔진 ip/port 
                url: "http://210.116.106.77:4780/gcenmap/map/tile?tz={z}&tx={x}&ty={y}&mapset=" + defaultMapset + "&v=" + mapsetVersion,
                crossOrigin: 'anonymous'
            })
        })
    ];

    var options;

    // 지도 option 설정(필수)
    if(interactions){
        options = {
            target: element,      // 지도 tag id 지정(필수) ex) <div id='map'></div>
            view: view,         // view 지정(필수)
            layers: layers,     // 레이어 지정(필수)
            logo: false,
			controls:[],
            interactions: interactions
        };
    }else{

        options = {
            target: element,      // 지도 tag id 지정(필수) ex) <div id='map'></div>
            view: view,         // view 지정(필수)
            layers: layers,     // 레이어 지정(필수)
            logo: false,
            controls:[]
        };
    }



    // 지도 객체 선언

    return new ol.Map(options);
};

