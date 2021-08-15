var map;						// 지도 전역 변수
var view;						// view 전역 변수
var featureSource;
var featureLayer;
var clickOverlayId = "click-overlay";

function mapDocumentReady() {
	view = new ol.View({
		center: ol.proj.fromLonLat([bl.LAT, bl.LON]), // 페이지 시작시 지도 중심 좌표 설정
		zoom: 16,       // 페이지 시작시 지도 레벨 설정(필수)
		minZoom: 5,     // 축소 지도 레벨 설정(필수)
		maxZoom: 18,     // 확대 지도 레벨 설정(필수),
		projection: 'EPSG:3857'	// 좌표계
    });

    // 지도 객체 선언
    map = gcen.loadMap("map", view, "vt_maplabel");
	var zoomControl = new ol.control.Zoom();
	map.addControl(zoomControl);

	var scaleLineControl = new ol.control.ScaleLine();
	map.addControl(scaleLineControl);
	
	var container = $("#popup").get(0);
	var popup = new ol.Overlay({
		id:clickOverlayId,
		element: container,
		positioning: 'bottom-center',
		stopEvent: false,
		offset: [0, -50],
		autoPan: true,
		autoPanAnimation: { duration: 250}
	});
	map.addOverlay(popup);
	
	// feature 소스 생성
	featureSource = new ol.source.Vector();

	// feature 레이어 생성
	featureLayer = new ol.layer.Vector({
		id: "featureLayer",
		source: featureSource
	});

	// 지도에 레이어 추가
	map.addLayer(featureLayer);
	map.on("click", onMarkerClick);
}

function onMarkerClick(evt)
{
	var feature;
    var layer;

    map.forEachFeatureAtPixel(evt.pixel,
        function(getFeature,getLayer)
        {
            feature = getFeature;
            layer = getLayer;
        }
    );

	var popup = map.getOverlayById(clickOverlayId);
	var obj = popup.getElement();

    if(layer != undefined && layer.get("id") == "featureLayer" && feature)
    {
    	var point;
    	var title;
		var content;

		if(feature.getGeometry() instanceof ol.geom.Point)
		{
			point = feature.getGeometry().getCoordinates();
			content = feature.get("content");
			$(obj).find(".ol-popup-content").html(content);
		}
		
		if(content == "")
		{
			popup.setPosition(undefined);
		}
		else
		{
			popup.setOffset([0,-50]);
			popup.setPosition(point);	
		}
	}
    else
    {
		popup.setPosition(undefined);
	}
}


function addMarker(lat, lon, title, content, img)
{
	var marker = new ol.Feature({
		geometry: new ol.geom.Point(ol.proj.fromLonLat([lon, lat])),
		title: title,
		content: content,
		division : "marker",
		rainfall: 500
	});			
	
	var image = new ol.style.Icon({
		anchor: [0.5, 1],
		opacity: 1,
		src: img
	});
	
	var text = new ol.style.Text({
        text: title,
        stroke: new ol.style.Stroke({ color:"#fff", width:2 }),
        fill: new ol.style.Fill({color:"#333"}),
        font: '13px sans-serif'				
	});
	
	marker.setStyle(new ol.style.Style({
		image: image,
		text : text
	}));

	featureSource.addFeature(marker);
}
