<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WMS</title>
<%@ include file="/common/include/head.jsp" %>
<style type="text/css">
	/*input disable common*/
	h3{font-size: 40px;}
	h2{font-size: 35px;}
	h1{font-size: 30px;}
	@media ( max-width: 1920px ) {
		h3{font-size: 30px;}
		h2{font-size: 25px;}
		h1{font-size: 20px;}
	}
	.imageWrapDisabled{border-radius: 5px 5px 5px 5px !important; cursor: grab !important;}
	.imageDisabled{border-radius: 3px 3px 3px 3px !important;}
	.inputDisabled{border: none !important;background-color: #fff !important;}
	.pointer{cursor: pointer;}
	/*app manage common wrapper*/
	.versionWrap{width: 250px;height: 100%;border-right: 2px solid #a6b0ca;float: left;}
	.versionWrap .versionBox{width: calc(100% - 10px);height: 100%;}
	.versionWrap .versionBox div{width: 100%;height: 70px;text-align: center;font-size: 20px;font-weight: bold;border-bottom: 2px solid #a6b0ca;cursor: pointer;}
	.versionWrap .versionBox div p{padding-top: 25px;}
	.versionWrap .versionBox div.focus{background-color: #efefef;color: #000;}
	.versionWrap .versionBox div span{
		width: 0px;
		height: 0px;
		position: absolute;
		display:none;
		left: 237px;
		border-top:25px solid transparent;
		border-bottom:25px solid transparent;
		border-right: 25px solid transparent;
		border-left: 25px solid #efefef;
	}
	.versionWrap .versionBox div span.ra1{top: 10px;}
	.versionWrap .versionBox div span.ra2{top: 78px;}
	/*app version*/
	.contentWrap{width: calc(100% - 252px);height: 100%;float: left;overflow: auto;}
	.contentWrap .subContent{width: 100%;height: 100%;padding: 10px 0px 10px 20px;display: none;box-sizing: border-box;min-width: 1200px;min-height: 800px;overflow: hidden;}
	.contentWrap .subContent.on{display: block;}
	.contentWrap .subContent .appReg{width: 45%;height: 100%;float: left;padding: 10px;overflow: hidden;border-right: 1px solid #a6b0ca;position: relative;}
	.contentWrap .subContent .appReg .btnArea{width: 250px;height: 50px;position: absolute;overflow: hidden;border-radius: 5px;}
	.contentWrap .subContent .appReg .btnArea .btn1Area{width: 50px;height: 50px;left: 0;float: left;border: 2px solid #9d9d9d;background-color: #9d9d9d;border-radius: 5px;padding: 10px;cursor: pointer;position: absolute;z-index: 2;}
	.contentWrap .subContent .appReg .btnArea .btn1Area img{width: 25px}
	.contentWrap .subContent .appReg .btnArea .btn2Area{width: 250px;height: 50px;left: -200px;border: 2px solid #9d9d9d;background-color: #9d9d9d;border-radius: 5px;padding: 5px;position: relative;z-index: 0;}
	.contentWrap .subContent .appReg .btnArea .btn2Area .addBtn{margin-left: 70px;height:100%;background-color: #efefef;border-radius: 5px;padding: 6px;cursor: pointer;}
	.contentWrap .subContent .appReg .btnArea .btn2Area .addBtn img{width: 25px;float: left;}
	.contentWrap .subContent .appReg .btnArea .btn2Area .addBtn p{float: left;font-size: 18px;font-weight: bold;text-align: center;margin-left: 15px;padding-top: 3px;}
	.contentWrap .subContent .appReg .refreshArea{width: 50px;height: 50px;float: right;padding: 15px 7px 7px 7px;cursor: pointer;}
	.contentWrap .subContent .appReg .refreshArea img{width: 35px;transition: all ease 0.4s;}
	.contentWrap .subContent .appReg .refreshArea img.spin{transform: rotate( 360deg );}
	.contentWrap .subContent .appReg .tabArea{width: calc(100% + 35px);height: calc(100% - 50px);overflow-y: scroll;margin-top: 50px;}
	.contentWrap .subContent .appReg .tabArea .noRow{width: calc(100% - 40px);height: 150px;margin-top: 50px;}
	.contentWrap .subContent .appReg .tabArea .noRow .noRowCont{width: 500px;height: 100%;margin: 0 auto;}
	.contentWrap .subContent .appReg .tabArea .noRow .noRowCont p{width: 100%;height: 50px;} 
	.contentWrap .subContent .appReg .tabArea .noRow .noRowCont .txt1{font-size: 34px;font-weight: bold;margin-bottom: 12px;padding-left: 35px;}
	.contentWrap .subContent .appReg .tabArea .noRow .noRowCont .txt1 .icoInf{
		width: 50px;
		height: 50px;
		float: left;
		background: url(/common/theme/gsfresh/images/icon/ico_info.png) no-repeat;
		background-size: 35px;
		background-position: top;
	}
	.contentWrap .subContent .appReg .tabArea .noRow .noRowCont .txt2{font-size: 29px;font-weight: bold;text-align: center;}
	.contentWrap .subContent .appReg .tabArea .noRow .noRowCont .txt2 .bold{font-style: italic;border-bottom: 3px dotted #7fc241;color: #7fc241;cursor: pointer;}
	.contentWrap .subContent .appReg .tabArea .row{width: calc(100% - 40px);box-sizing: border-box;margin-top: 20px;cursor: grab;position: relative;}
	.contentWrap .subContent .appReg .tabArea .row .tit{width: 100%;height: 60px;border: 3px solid #9d9d9d;background-color: #efefef;border-radius: 8px 8px 8px 8px;}
	.contentWrap .subContent .appReg .tabArea .row .tit.on{border-radius: 8px 8px 0px 0px;}
	.contentWrap .subContent .appReg .tabArea .row .tit img{width: 25px;margin: 15px;float: left;transition: all ease 0.5s;}
	.contentWrap .subContent .appReg .tabArea .row .tit img.down{transform: rotate( 90deg );}
	.contentWrap .subContent .appReg .tabArea .row .tit img.add{width: 35px;margin: 10px;transform: none;}
	.contentWrap .subContent .appReg .tabArea .row .tit p{width: calc(100% - 55px);float: left;height: 100%;font-size: 30px;padding-top: 10px;}
	.contentWrap .subContent .appReg .tabArea .row .reg{width: 100%;height: 400px;border: 3px solid #9d9d9d;background-color: #fff;border-radius: 0px 0px 8px 8px;border-top: 0px;display: none;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap{width: 100%;height: 100%;padding: 20px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap input[type=file]{display: none;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont1{width: 100%;height: 72px;position: relative;margin-bottom: 20px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont1 .imgRegBtn{width: 35px;height: 35px;background-color: #9d9d9d;border: 2px solid #9d9d9d;border-radius: 20px;position: absolute;top: -16px;left: 37px;z-index: 0;cursor: pointer;text-align: center;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont1 .imgRegBtn img{width: 20px;padding: 4px;padding-top: 2px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont1 .imgRegWrap{width: 72px;height: 72px;background-color: #fff;border: 2px solid #9d9d9d;border-radius: 5px 0px 5px 5px;cursor: pointer;float: left;margin-right: 20px;text-align: center;position: absolute;z-index: 2;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont1 .imgRegWrap.read{border-radius: 5px 5px 5px 5px;cursor: none;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont1 .imgRegWrap img{width: 68px;height: 68px;padding: 0;border-radius: 3px 0px 3px 3px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont1 .imgRegWrap img.read{border-radius: 3px 3px 3px 3px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont1 .imgRegWrap img.noImg{width: 72px;padding: 10px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont1 .apkNameWrap{width: calc(100% - 92px);height: 72px;float: left;position: absolute;left: 92px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont1 .apkNameWrap .appTitle{width: 100%;height: 30px;font-size: 20px;font-weight: bold;padding-top: 5px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont1 .apkNameWrap .appText{width: 100%;height: 42px;font-size: 17px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont1 .apkNameWrap .appText input{width: 100%;height: 40px;margin-top: 2px;border: 2px solid #9d9d9d;border-radius: 5px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont2{width: 100%;height: 95px;margin-bottom: 20px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont2 .verTitle{width: 100%;height: 30px;font-size: 20px;padding-top: 5px;margin-bottom: 10px;font-weight: bold;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont2 .verText{width: 80px;height: 50px;float: left;font-size: 25px;font-weight: bold;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont2 .verText input{width: 100%;height: 100%;border: 2px solid #9d9d9d;border-radius: 5px;text-align: center;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont2 .verDot{width: 35px;height: 50px;float: left;font-size: 53px;text-align: center;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3{width: 100%;height: 120px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpTitleWrap{width: 100%;height: 40px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpTitleWrap p{width: 100%;height: 30px;font-size: 20px;padding-top: 5px;font-weight: bold;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap{width: 100%;height: 100%;border: 2px solid #9d9d9d;border-radius: 5px;cursor: pointer;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont{width: 100%;height: 100%;padding: 20px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .noApkWrap{width: 100%;height: 100%;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .noApkWrap .noApkImg{width: 80px;height: 100%;float: left;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .noApkWrap .noApkImg img{width: 80px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .noApkWrap .noApkText{width: calc(100% - 80px);height: 100%;float: left;text-align: center;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .noApkWrap .noApkText p{font-size: 24px;font-weight: bold;padding: 6px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .noApkWrap .noApkText p span{font-style: italic;border-bottom: 2px solid #7fc241;border-style: dotted;color: #7fc241;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .apkFileWrap{width: 100%;height: 100%;display: none;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .apkFileWrap .apkImg{width: 80px;height: 100%;float: left;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .apkFileWrap .apkImg img{width: 80px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .apkFileWrap .apkInf{width: calc(100% - 80px);height: 100%;float: left;position: relative;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .apkFileWrap .apkInf .inf{width: calc(100% - 20px);height: 100%;float: left;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .apkFileWrap .apkInf .inf .fileNm{width: 100%;height: 60%;font-size: 20px;padding-top: 7px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .apkFileWrap .apkInf .inf .fileSize{width: 100%;height: 40%;font-size: 18px;padding-top: 8px;}
	.contentWrap .subContent .appReg .tabArea .row .reg .regWrap .regCont3 .apkUpWrap .apkUpCont .apkFileWrap .apkInf .btn{
		width: 30px;
		height: 30px;
		float: left;
		background: url(/common/theme/gsfresh/images/icon/ico_file_del.png) no-repeat;
		background-size: 30px;
		background-position: center;
		position: absolute;
		top: -9px;
		left: calc(100% - 18px);
	}
	.contentWrap .subContent .appReg .tabArea .row .editBtnArea{position: absolute;width: 155px;height: 45px;top: 7px;left: calc(100% - 165px);z-index: 2;display: none;}
	.contentWrap .subContent .appReg .tabArea .row .editBtnArea button{width: 45px;height: 45px;float: left;outline: none;}
	.contentWrap .subContent .appReg .tabArea .row .editBtnArea .refresh{margin-right: 10px;background: url("/common/theme/gsfresh/images/icon/ico_refresh_row.png") no-repeat;background-size: 45px;}
	.contentWrap .subContent .appReg .tabArea .row .editBtnArea .save{margin-right: 10px;background: url("/common/theme/gsfresh/images/icon/ico_save_row.png") no-repeat;background-size: 45px;}
	.contentWrap .subContent .appReg .tabArea .row .editBtnArea .delete{background: url("/common/theme/gsfresh/images/icon/ico_del_row.png") no-repeat;background-size: 45px;}
	/*app version guide*/
	.contentWrap .subContent .appRegGuide{width: 55%;height: 100%;float: left;padding: 20px 10px 0 20px;}
	.contentWrap .subContent .appRegGuide .guideTitleWrap{width: 100%;height: 50px;}
	.contentWrap .subContent .appRegGuide .guideTitleWrap .guideTitle{width: 600px;height: 100%;margin: 0 auto;}
	.contentWrap .subContent .appRegGuide .guideTitleWrap .guideTitle p{height: 100%;float:left;}
	.contentWrap .subContent .appRegGuide .guideTitleWrap .guideTitle p img{width: 50px;}
	.contentWrap .subContent .appRegGuide .guideTitleWrap .guideTitle .btnLeft{width: 50px;cursor: pointer;}
	.contentWrap .subContent .appRegGuide .guideTitleWrap .guideTitle .btnRight{width: 50px;cursor: pointer;}
	.contentWrap .subContent .appRegGuide .guideTitleWrap .guideTitle .guideTitleText{width: calc(100% - 100px);text-align: center;font-weight: bold;font-size: 30px;padding-top: 8px;cursor: pointer;}
	.contentWrap .subContent .appRegGuide .guideContentWrap{width: 100%;height: calc(100% - 50px);position: relative;overflow: hidden;}
	.contentWrap .subContent .appRegGuide .guideContentScroll{width: 100%;height: calc(100% + 17px);overflow-x: scroll;overflow-y: hidden;}
	.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent{height: 100%;}
	.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent .page{width: calc(100% + 17px);height: calc(100% - 0px);float: left;overflow: hidden;}
	.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent .page .pageScroll{width: calc(100% + 17px);height: 100%;padding: 50px 20px 0 20px;overflow-x: hidden;overflow-y: scroll;}
	.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent .page .pageScroll h3{font-weight: bold;margin-bottom: 20px;}
	.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent .page .pageScroll .listItem .item1{margin-bottom: 40px;}
	.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent .page .pageScroll .listItem .item1 h2{font-weight: bold;}
	.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent .page .pageScroll .listItem .item2{margin: 30px 0 0 15px;}
	.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent .page .pageScroll .listItem .item2 .itemRow{margin-bottom: 15px;font-size: 20px;line-height: 1.5;white-space: normal;}
	.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent .page .pageScroll .listItem .item3{margin: 20px 0 0 30px;}
	.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent .page .pageScroll .listItem .item4{margin: 20px 0 0 30px;}
	.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent .page .pageScroll .listItem .item4 .itemRow{margin-bottom: 15px;font-size: 20px;line-height: 1.5;white-space: normal;}
	@media ( max-width: 1920px ) {
		.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent .page .pageScroll .listItem .item2 .itemRow{margin-bottom: 15px;font-size: 17px;line-height: 1.5;white-space: normal;}
		.contentWrap .subContent .appRegGuide .guideContentWrap .guideContentScroll .guideContent .page .pageScroll .listItem .item4 .itemRow{margin-bottom: 15px;font-size: 17px;line-height: 1.5;white-space: normal;}
	}
	
	.contentWrap .subContent .sourceReg{width: 45%;height: 100%;float: left;padding: 10px;overflow: hidden;border-right: 1px solid #a6b0ca;position: relative;}
	.contentWrap .subContent input[type=file]{display: none;}
	.contentWrap .subContent .sourceReg .fileTitleArea{width: calc(100% - 17px);height: 200px;border: 3px solid #9d9d9d;border-radius: 8px 8px 8px 8px;margin-bottom: 40px;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegInit{width: 100%;height: 100%;cursor: pointer;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegInit .fileRegWrap{width: 100%;height: 100%;padding: 54px 40px 40px 40px;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegInit .fileRegWrap .noFileImg{width: 80px;height: 100%;float: left;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegInit .fileRegWrap .noFileImg img{width: 80px;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegInit .fileRegWrap .noFileText{width: calc(100% - 80px);height: 100%;float: left;text-align: center;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegInit .fileRegWrap .noFileText p{font-size: 24px;font-weight: bold;padding: 6px;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegInit .fileRegWrap .noFileText p span{font-style: italic;border-bottom: 2px solid #7fc241;border-style: dotted;color: #7fc241;}
	
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent{width: 100%;height: calc(100% - 50px);display: none;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileRegHead{width: 100%;height: 50px;padding: 5px 10px 5px 10px;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileRegHead button{width: 45px;height: 45px;float: left;outline: none;border: 0;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileRegHead .fileSave{
		margin-left: calc(100% - 100px);
		margin-right: 10px;
		background: url(/common/theme/gsfresh/images/icon/ico_save_row.png) no-repeat;
		background-size: 45px;
	}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileRegHead .fileDelete{
		background: url("/common/theme/gsfresh/images/icon/ico_del_row.png") no-repeat;
		background-size: 45px;
	}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileReg{width: 100%;height: 100%;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileReg .regFileIcon{
		width: 100px;
		height: 100%;
		float: left;
		background: url("/common/theme/gsfresh/images/fileIcon/ico_file_etc.png") no-repeat;
		background-size: 80px;
		background-position: center;
		padding: 34px 10px 20px 15px;
	}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileReg .regFileIcon .icoWrap{width: 80px;height: 80px;border: 2px solid #9d9d9d;border-radius: 5px;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileReg .regFileIcon .icoWrap img{width: 76px;height: 100%;border-radius: 3px;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileReg .regFileInf{width: calc(100% - 100px);height: calc(100% - 50px);float: left;padding: 10px;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileReg .regFileInf .regFileName{width: 100%;height: 85px;white-space: normal;text-overflow: ellipsis;overflow: hidden;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileReg .regFileInf .regFileName p{width: 100%;height: 100%;font-size: 20px;font-weight: bold;line-height: 1.4;padding-top: 20px;padding-left: 10px;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileReg .regFileInf .regFileSize{width: 100%;height: 40px;}
	.contentWrap .subContent .sourceReg .fileTitleArea .fileRegContent .fileReg .regFileInf .regFileSize p{font-size: 18px;padding-left: 10px;}
	.contentWrap .subContent .sourceReg .fileListArea{width: calc(100% - 17px);height: calc(100% - 200px);}
	.contentWrap .subContent .sourceReg .fileListArea .fileListTitle{width: 100%; height: 40px;}
	
	.contentWrap .subContent .sourceReg .fileListArea .fileListTitle .regRefreshArea{width: 50px;height: 50px;left: calc(100% - 72px);top: 225px;padding: 15px 7px 7px 7px;cursor: pointer;position: absolute;}
	.contentWrap .subContent .sourceReg .fileListArea .fileListTitle .regRefreshArea img{width: 35px;transition: all ease 0.4s;}
	.contentWrap .subContent .sourceReg .fileListArea .fileListTitle .regRefreshArea img.spin{transform: rotate( 360deg );}
	
	.contentWrap .subContent .sourceReg .fileListArea .fileListTitle .titleImgWrap{width: 35px;height: 40px;float: left;padding-top: 2px;}
	.contentWrap .subContent .sourceReg .fileListArea .fileListTitle .titleImgWrap img{width: 25px;}
	.contentWrap .subContent .sourceReg .fileListArea .fileListTitle .titleTxtWrap{width: calc(100% - 35px);height: 40px;float: left;font-size: 20px;font-weight: bold;padding-top: 5px;}
	.contentWrap .subContent .sourceReg .fileListArea .noRegFile{display: none;width: 100%; height: calc(100% - 80px);overflow: hidden;}
	.contentWrap .subContent .sourceReg .fileListArea .noRegFile .noRegFileWrap{width: 500px;height: 50%;margin: 0 auto;}
	.contentWrap .subContent .sourceReg .fileListArea .noRegFile .noRegFileWrap .regIcoInf{
		width: 50px;
		height: 50px;
		float: left;
		background: url(/common/theme/gsfresh/images/icon/ico_info.png) no-repeat;
		background-size: 35px;
		background-position: top;
		margin-left: 25px;
	}
	.contentWrap .subContent .sourceReg .fileListArea .noRegFile .noRegFileWrap .regIcoTxt{width: calc(100% - 25px);height: 50px;font-size: 34px;font-weight: bold;margin-top: 50%;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList{width: calc(100% + 42px); height: calc(100% - 80px);overflow-y: scroll;padding: 10px 10px 0px 10px;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem{width: calc(100% - 25px);height: 150px;margin-bottom: 10px;border: 2px solid #9d9d9d;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap{width: 100%;height: 100%;padding: 10px;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemIcon{width: 100px;height: 100%;float: left;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemIcon p.iconWrap{width: 100%;height: 75px;padding-top: 0;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemIcon p.iconWrap img{width: 65px;height: 100%;border-radius: 5px;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemIcon p{width: 100%;height: 25px;font-weight: bold;font-size: 15px;padding-top: 5px;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemCont{width: calc(100% - 160px);height: 100%;float: left;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemCont .fileItemName{width: 100%;height: 75px;font-size: 20px;font-weight: bold;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemCont .fileItemSize{width: 100%;height: 25px;font-size: 15px;padding-top: 5px;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemCont .fileItemTime{width: 100%;height: 25px;font-size: 15px;padding-top: 5px;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemBtn{width: 60px;height: 100%;float: left;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemBtn .fileItemRemove{width: 100%;height: 50%;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemBtn .fileItemRemove button{
		background: url(/common/theme/gsfresh/images/icon/ico_file_del.png) no-repeat;
		background-size: 25px;
		width: 25px;
		height: 25px;
		margin-left: 40px;
		outline: none;
		border: 0;
	}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemBtn .fileItemDown{width: 100%;height: 50%;}
	.contentWrap .subContent .sourceReg .fileListArea .fileList .fileItem .fileItemWrap .fileItemBtn .fileItemDown button{
		background: url(/common/theme/gsfresh/images/icon/ico_down.png) no-repeat;
		background-size: 57px;
		width: 100%;
		height: 100%;
		background-position: bottom;
		outline: none;
		border: 0;
	}
	.contentWrap .subContent .sourceRegGuide{width: 55%;height: 100%;float: left;padding: 20px 10px 0 20px;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideTitleWrap{width: 100%;height: 50px;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideTitleWrap .sourceGuideTitle{width: 600px;height: 100%;margin: 0 auto;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideTitleWrap .sourceGuideTitle p{height: 100%;float:left;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideTitleWrap .sourceGuideTitle .sourceGuideTitleText{width: 100%;text-align: center;font-weight: bold;font-size: 30px;padding-top: 8px;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap{width: 100%;height: calc(100% - 50px);position: relative;overflow: hidden;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentScroll{width: 100%;height: calc(100% + 17px);overflow-x: scroll;overflow-y: hidden;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent{height: 100%;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent .sourcePage{width: calc(100% + 17px);height: calc(100% - 0px);float: left;overflow: hidden;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent .sourcePage .sourcePageScroll{width: calc(100% + 17px);height: 100%;padding: 50px 20px 0 20px;overflow-x: hidden;overflow-y: scroll;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent .sourcePage .sourcePageScroll h3{font-weight: bold;margin-bottom: 20px;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent .sourcePage .sourcePageScroll .sourceListItem .sourceItem1{margin-bottom: 40px;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent .sourcePage .sourcePageScroll .sourceListItem .sourceItem1 h2{font-weight: bold;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent .sourcePage .sourcePageScroll .sourceListItem .sourceItem2{margin: 30px 0 0 15px;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent .sourcePage .sourcePageScroll .sourceListItem .sourceItem2 .sourceItemRow{margin-bottom: 15px;font-size: 20px;line-height: 1.5;white-space: normal;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent .sourcePage .sourcePageScroll .sourceListItem .sourceItem3{margin: 20px 0 0 30px;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent .sourcePage .sourcePageScroll .sourceListItem .sourceItem4{margin: 20px 0 0 30px;}
	.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent .sourcePage .sourcePageScroll .sourceListItem .sourceItem4 .sourceItemRow{margin-bottom: 15px;font-size: 20px;line-height: 1.5;white-space: normal;}
	@media ( max-width: 1920px ) {
		.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent .sourcePage .sourcePageScroll .sourceListItem .sourceItem2 .sourceItemRow{margin-bottom: 15px;font-size: 17px;line-height: 1.5;white-space: normal;}
		.contentWrap .subContent .sourceRegGuide .sourceGuideContentWrap .sourceGuideContentScroll .sourceGuideContent .sourcePage .sourcePageScroll .sourceListItem .sourceItem4 .sourceItemRow{margin-bottom: 15px;font-size: 17px;line-height: 1.5;white-space: normal;}
	}
	
	.progressLoding{width: 100%;height: 100%;position: absolute;top: 0;background: rgba(0,0,0,0.8);z-index: 999;font-size: 12px;overflow: hidden;display: none;}
	.progressLoding .boxWrap{width: 600px;height: 100%;margin: 0 auto;}
	.progressLoding .boxWrap .box{width: 100%;height: 300px;margin-top: 50%;}
	.progressLoding .boxWrap .box .gif{width: 150px;height: 200px;margin-top: 50px;float: left;}
	.progressLoding .boxWrap .box .text{width: calc(100% - 200px);height: 200px;margin-top: 50px;float: left;padding-top: 60px;}
	.progressLoding .boxWrap .box .text p{width: 100%;font-size: 35px;font-weight: bold;color: #fff;text-align: center;}
	.progressLoding .boxWrap .box .text p.text1{margin-bottom: 10px;color: #7fc241;}
</style>
<script type="text/javascript">
	var typeMap = {
			"init"   : "I",
			"add"    : "A",
			"read"   : "R",
			"update" : "U",
			"delete" : "D"
	};
	var fileMap = new DataMap();
	var dataMap = new DataMap();
	var dataList = [];
	
	var appGuiW = 0;
	var appGuiCount = 0;
	var appPageCount = 0;
	
	var regFileList = [];
	
	$(window).resize(function(){
		appGuiW = $(".guideContentWrap").width();
		appPageCount = $(".page").length;
		$(".page").css("width",appGuiW)
		$(".guideContent").css("width",(appGuiW*appPageCount));
		$(".guideContentScroll").scrollLeft(appGuiW*appGuiCount);
	});
	
	$(document).ready(function(){
		loadVersionData();
		
		setTabEvent();
		setRowEvent();
		selectRegList();
		
		$(".btn1Area").unbind("click").on("click",function(){
			if($(this).hasClass("on")){
				$(this).removeClass("on");
				$(this).find("img").attr({"alt":"편집","src":"/common/theme/gsfresh/images/icon/ico_edit_list.png"});
				$(".btn2Area").animate({left:-200});
				updateRowBtnAreaHide();
				if(dataList.length > 0){
					for(var i in dataList){
						var data = dataList[i];
						setRow(typeMap["read"],data);
					}
				}
			}else{
				$(this).addClass("on");
				$(this).find("img").attr({"alt":"편집취소","src":"/common/theme/gsfresh/images/icon/ido_exit.png"});
				$(".btn2Area").animate({left:0});
				$(".editBtnArea").show();
				
				if(dataList.length > 0){
					for(var i in dataList){
						var data = dataList[i];
						setRow(typeMap["update"],data);
					}
				}
			}
		});
		
		$(".btn2Area").unbind("click").on("click",function(){
			setRow(typeMap["add"]);
		});
		
		$("#tab1").trigger("click");
		
		appGuiW = $(".guideContentWrap").width();
		$(".page").css("width",appGuiW)
		$(".guideContent").css("width",(appGuiW*appPageCount));
		$("#appCnt").text(appGuiCount + 1);
		$("#appTot").text(appPageCount);
	});
	
	function loadVersionData(){
		fileMap = new DataMap();
		dataList = [];
		
		var json = netUtil.sendData({
			module : "System",
			command : "AK01",
			sendType : "list"
		});
		
		if(json && json.data){
			var list = json.data;
			var len = list.length;
			if(len > 0){
				for(var i = 0; i < len; i++){
					var row = list[i];
					dataList.push(row);
					setRow(typeMap["init"],row);
				}
			}
		}
	}
	
	function updateRowBtnAreaHide(){
		var $obj = $(".editBtnArea");
		$obj.each(function(){
			var $row = $(this).parent();
			if(!$row.hasClass("A")){
				$(this).hide();
			}
		})
	}
	
	function openImageFile($o){
		var $imgBtn = $($o);
		var $imgFileInput = $imgBtn.parent().parent().parent().find("input[name=imgFile]");
		if($imgBtn.hasClass("imgOn")){
			if (Browser.ie) {
				$imgFileInput.replaceWith( $imgFileInput.clone(true) );
			} else {
				$imgFileInput.val("");
			}
			
			$imgBtn.removeClass("imgOn");
			$imgBtn.addClass("imgOff");
			
			var $imageZone = $imgBtn.next().find("img");
			$imageZone.addClass("noImg");
			$imageZone.attr("src","/common/theme/gsfresh/images/icon/ico_add_img_off.png");
			$imgBtn.find("img").attr("src","/mobile/img/ico/plus-white.png");
			
			var $row = $imgFileInput.parent().parent().parent();
			var id = $row.attr("data-seq");
			if(fileMap.containsKey(id)){
				fileMap.get(id).put("imgFile",null);
			}
			
			if($row.hasClass("U")){
				var imgType = typeMap["delete"];
				setRowEditType("IMG",id,imgType);
			}
		}else{
			$imgFileInput.trigger("click");
		}
	}
	
	// 파일 선택시
	function selectFile(files,$o){
		if(files != null){
			var fileName = files[0].name;
			var fileNameArr = fileName.split("\.");
			var ext = fileNameArr[fileNameArr.length - 1];
			if(ext != "apk"){
				commonUtil.msgBox("apk 파일만 등록 가능합니다.");
				return;
			}
			
			var formatSize = "";
			var fileSize = files[0].size;
			if(fileSize < 0){
				formatSize = fileSize + "BYTE";
			}else if(fileSize > 1024 && fileSize < (1024*1024)){
				formatSize = Math.round(fileSize/1024,2) + "KB";
			}else{
				formatSize = Math.round(fileSize/(1024*1024),2) + "MB";
			}
			
			var $row = $($o).parent().parent().parent();
			var id = $row.attr("data-seq");
			
			if(fileMap.containsKey(id)){
				fileMap.get(id).put("file",files[0]);
			}else{
				var defaultMap = new DataMap();
				defaultMap.put("file",files[0]);
				defaultMap.put("imgFile",null);
				
				fileMap.put(id,defaultMap);
			}
			
			if($row.hasClass("U")){
				var imgType = typeMap["update"];
				setRowEditType("FILE",id,imgType);
			}
			
			drawFile(fileName,ext,formatSize,$o);
		}else{
			alert("ERROR");
		}	
	}
	
	function drawFile(fileName,ext,fileSize,$o){
		var $obj = $o.parent().find("form").find(".regCont3");
		var $inf = $obj.find(".apkUpWrap").find(".inf");
		
		var $fileNm = $inf.find(".fileNm");
		var $fileSize = $inf.find(".fileSize");
		
		$fileNm.text("");
		$fileSize.text("");
		
		$fileNm.text(fileName);
		$fileSize.text(fileSize);
		
		$obj.find(".apkFileWrap").show();
		$obj.find(".noApkWrap").hide();
	}
	
	function drawRegFile(file,fileName,ext,fileSize){
		ext = ext.toUpperCase();
		var $init = $("#fileRegInit");
		var $inf = $("#fileRegContent");
		
		var $fileNm = $("#regFileName");
		var $fileSize = $("#regFileSize");
		var $fileImg = $(".regFileIcon");
		
		var isImg = false;
		var imgPath = "/common/theme/gsfresh/images/fileIcon/ico_file_etc.png";
		switch (ext) {
		case "PDF":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_pdf.png";
			break;
		case "PPT":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_ppt.png";
			break;
		case "PPTX":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_ppt.png";
			break;
		case "PPTX":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_ppt.png";
			break;
		case "DOC":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_word.png";
			break;
		case "DOCX":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_word.png";
			break;
		case "XLSX":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_excel.png";
			break;
		case "XLS":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_excel.png";
			break;
		case "ZIP":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_zip.png";
			break;
		case "APK":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/icon/ico_apk.png";
			break;	
		case "PNG":
			isImg = true;
			break;
		case "JPEG":
			isImg = true;
			break;
		case "JPG":
			isImg = true;
			break;
		default:
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_file_etc.png";
			break;
		}
		
		if(isImg){
			$fileImg.css({"background":"none"});
			$fileImg.find(".icoWrap").remove();
			
			var $img = $("<img>");
			var $div = $("<div>");
			
			var $imgWrap = $div.clone().addClass("icoWrap");
			var reader = new FileReader();
			reader.onload = (function(f) {
				return function(e){
					var src = e.target.result;
					$img.attr("src",src);
				}
			})(file);
			reader.readAsDataURL(file);
			
			$fileImg.append($imgWrap.append($img));
			
		}else{
			$fileImg.find(".icoWrap").remove();
			$fileImg.css({"background":"url("+(imgPath)+") no-repeat","background-size":"80px","background-position":"center"});
		}
		
		$fileNm.text("");
		$fileSize.text("");
		
		$fileNm.text(fileName);
		$fileSize.text(fileSize);
		
		$inf.show();
		$init.hide();
	}
	
	function changeFile($obj){
		selectFile($obj.files,$($obj));
	}
	
	function changeRegFile($obj){
		selectRegFile($obj.files);
	}
	
	function changeImageFile(e){
		var $o   = $(e.target);
		var $obj = $o.next().find(".regCont1");
		var $imgRegWrap = $obj.find(".imgRegWrap");
		var $imgRegBtn  = $obj.find(".imgRegBtn");
		
		var $img = $imgRegWrap.find("img");
		var imgFile = e.target.files[0];
		var fileNameArr = imgFile["name"].split("\.");
		var ext = fileNameArr[1];
		if (!(ext == "gif" || ext == "jpg" || ext == "png")) {
			commonUtil.msgBox("이미지파일(.jpg, .png, .gif )만  등록 가능합니다.");
			return;
		}
		
		var reader = new FileReader();
		reader.onload = function(e){
			var src = e.target.result;
			$img.attr("src",src);
		};
		reader.readAsDataURL(imgFile);
		
		var $row = $o.parent().parent().parent();
		var id = $row.attr("data-seq");
		if(fileMap.containsKey(id)){
			fileMap.get(id).put("imgFile",imgFile);
		}else{
			var defaultMap = new DataMap();
			defaultMap.put("file",null);
			defaultMap.put("imgFile",imgFile);
			
			fileMap.put(id,defaultMap);
		}
		
		if($row.hasClass("U")){
			var imgType = typeMap["update"];
			setRowEditType("IMG",id,imgType);
		}
		
		$imgRegBtn.removeClass("imgOff");
		$imgRegBtn.addClass("imgOn");
		$img.removeClass("noImg");
		$imgRegBtn.find("img").attr("src","/mobile/img/ico/minus-white.png");
	}
	
	// 파일 선택시
	function selectRegFile(files){
		if(files != null){
			regFileList = [];
			
			var fileName = files[0].name;
			var fileNameArr = fileName.split("\.");
			var ext = fileNameArr[fileNameArr.length - 1];
			
			var formatSize = "";
			var fileSize = files[0].size;
			if(fileSize < 0){
				formatSize = fileSize + "BYTE";
			}else if(fileSize > 1024 && fileSize < (1024*1024)){
				formatSize = Math.round(fileSize/1024,2) + "KB";
			}else{
				formatSize = Math.round(fileSize/(1024*1024),2) + "MB";
			}
			
			regFileList.push(files[0]);
			
			drawRegFile(files[0],fileName,ext,formatSize);
		}else{
			alert("ERROR");
		}	
	}
	
	function setTabEvent(){
		var $tabArea = $(".versionBox");
		var $tab = $tabArea.find("div");
		$tab.each(function(){
			var $obj = $(this);
			$obj.unbind("click").on("click",function(){
				$tab.removeClass("focus");
				$tab.find("span").hide();
				$(this).addClass("focus");
				$(this).find("span").show();
				
				var tabId = $(this).attr("id");
				tabEvent(tabId);
			});
		});
	}
	
	function tabEvent(id){
		var $tab1 = $("#appVersion");
		var $tab2 = $("#appSource");
		
		switch (id) {
		case "tab1":
			$tab1.show();
			$tab2.hide();
			
			appGuiW = $(".guideContentWrap").width();
			appPageCount = $(".page").length;
			$(".page").css("width",appGuiW);
			$(".guideContent").css("width",(appGuiW*appPageCount));
			$(".guideContentScroll").scrollLeft(appGuiW*appGuiCount);
			
			break;
		case "tab2":
			$tab1.hide();
			$tab2.show();
			setSourceRegFileEvent();
			break;
		default:
			break;
		}
	}
	
	function rowClickEvent($obj){
		var $rows = $(".tabArea .row .tit.on");
		$rows.each(function(){
			$(this).find("img").removeClass("down");
			$(this).next().slideUp(300,function(){
				$rows.removeClass("on");
			});
		});
		
		var $reg = $obj.next();
		if($obj.hasClass("on")){
			$reg.slideUp(300,function(){
				$obj.find("img").removeClass("down");
				$obj.removeClass("on");
			});
		}else{
			$obj.find("img").addClass("down");
			$obj.addClass("on");
			$reg.slideDown(300,function(){
				focusRowScrollEvent();
			});
		}
	}
	
	function setRowEvent(){
		var $rows = $(".tabArea .row .tit");
		$rows.each(function(){
			var $row = $(this);
			$row.unbind("click").on("click",function(){
				var $obj = $(this);
				rowClickEvent($obj);
			});
		});
		
		$("input:text[numberOnly]").unbind("keyup").on("keyup", function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
			changeVersionTitle($(this));
		});
		
		$("input:text[numberOnly]").unbind("click").on("click",function(){
			$(this).select();
		});
		
		$("input:text[numberOnly]").unbind("focusout").on("focusout",function(){
			var value = $(this).val();
			if($.trim(value) == ""){
				$(this).val(0);
			}
		});
	}
	
	function focusRowScrollEvent(){
		var $wrapObj = $(".tabArea");
		
		var mh = 0;
		var oh = 80;
		var ph = 0;
		var fh = 0;
		var h  = 0;
		var hh = $wrapObj.height();

		var $obj      = $(".row");
		var $focusRow = $obj.find(".on").parent();
		if($obj.length > 0){
			var focusRowIdx = $focusRow.index();
			if(focusRowIdx > -1){
				ph = oh*focusRowIdx;
				fh = $focusRow.height() + 20;
			}
			
			h = ph + fh;
			
			if(h > hh){
				mh = h - hh;
				$wrapObj.animate({scrollTop:mh});
			}
		}
	}
	
	function setRegFileEvent(){
		$(".apkInf .btn").unbind("click").on("click",function(){
			var $obj = $(this);
			$obj.addClass("del");
			
			var $reg = $obj.parent().parent().parent().parent().parent().parent().parent();
			var $inf = $reg.find(".inf");
			var $fileNm = $inf.find(".fileNm");
			var $fileSize = $inf.find(".fileSize");
			
			$fileNm.text("");
			$fileSize.text("");
			
			var $fileInput = $reg.find("input[name=file]"); 
			if (Browser.ie) {
				$fileInput.replaceWith( $fileInput.clone(true) );
			} else {
				$fileInput.val("");
			}
			var $row = $reg.parent().parent();
			var id = $row.attr("data-seq");
			if(fileMap.containsKey(id)){
				fileMap.get(id).put("file",null);
			}
			
			if($row.hasClass("U")){
				var imgType = typeMap["delete"];
				setRowEditType("FILE",id,imgType);
			}
			
			var $apkFileWrap = $reg.find(".apkFileWrap");
			var $noApkWrap = $reg.find(".noApkWrap");
			
			$apkFileWrap.hide();
			$noApkWrap.show();
			
			setTimeout(function() {
				$obj.removeClass("del");
			}, 300);
		});
		
		var apkOn = "/common/theme/gsfresh/images/icon/ico_drag_on.png";
		var apkOff = "/common/theme/gsfresh/images/icon/ico_drag_off.png";
		var $dropZone = $(".apkUpWrap");
		var $apkImg = $(".noApkImg img");
		$dropZone.unbind("click").on("click",function(e){
			e.preventDefault();
			var $fileInput = $(this).parent().parent().parent().find("input[name=file]");
			var $btn = $(this).find(".apkInf").find(".btn"); 
			if(!$btn.hasClass("del")){
				$fileInput.trigger("click");
			}
		});
		$dropZone.unbind("dragenter").on("dragenter",function(e){
			e.stopPropagation();
			e.preventDefault();
			$dropZone.css("background-color","#efefef");
			$apkImg.attr("src",apkOn);
		});
		$dropZone.unbind("dragleave").on("dragleave",function(e){
			e.stopPropagation();
			e.preventDefault();
			$dropZone.css("background-color","#ffffff");
			$apkImg.attr("src",apkOff);
		});
		$dropZone.unbind("dragover").on("dragover",function(e){
			e.stopPropagation();
			e.preventDefault();
			$dropZone.css("background-color","#efefef");
			$apkImg.attr("src",apkOn);
		});
		$dropZone.unbind("drop").on("drop",function(e){
			e.preventDefault();
			
			$apkImg.attr("src",apkOff);
			$dropZone.css("background-color","#ffffff");

			var files = e.originalEvent.dataTransfer.files;
			if(files != null){
				if(files.length < 1){
					alert("폴더 업로드 불가");
					return;
				}
				selectFile(files,$(this).parent().parent().parent().find("input[name=file]"))
			}else{
				alert("ERROR");
			}
		});
		
		var imgOn = "/common/theme/gsfresh/images/icon/ico_add_img_on.png"
		var imgOff = "/common/theme/gsfresh/images/icon/ico_add_img_off.png"
		var $imageZone = $(".imgRegWrap");
		$imageZone.unbind("click").on("click",function(e){
			e.preventDefault();
			var $imgFile = $(this).parent().parent().parent().find("input[name=imgFile]");;
			$imgFile.trigger("click");
		});
		$imageZone.unbind("dragenter").on("dragenter",function(e){
			e.stopPropagation();
			e.preventDefault();
			if($(".imgRegBtn").hasClass("imgOff")){
				var $img = $(this).find("img");
				$img.attr("src",imgOn);
			}
		});
		$imageZone.unbind("dragleave").on("dragleave",function(e){
			e.stopPropagation();
			e.preventDefault();
			var $img = $(this).find("img");
			$img.attr("src",imgOff);
			
			var $imgBtn = $(".imgRegBtn");
			$(".imgRegBtn").removeClass("imgOn");
			$imgBtn.addClass("imgOff");
			$img.addClass("noImg");
			$imgBtn.find("img").attr("src","/mobile/img/ico/plus-white.png");
			
			var $o = $(e.target);
			var $row = $o.parent().parent().parent().parent().parent().parent();
			var id = $row.attr("data-seq");
			if(fileMap.containsKey(id)){
				fileMap.get(id).put("imgFile",null);
			}else{
				var defaultMap = new DataMap();
				defaultMap.put("file",null);
				defaultMap.put("imgFile",null);
				
				fileMap.put(id,defaultMap);
			}
			
			if($row.hasClass("U")){
				var imgType = typeMap["delete"];
				setRowEditType("IMG",id,imgType);
			}
		});
		$imageZone.unbind("dragover").on("dragover",function(e){
			e.stopPropagation();
			e.preventDefault();
			if($(".imgRegBtn").hasClass("imgOff")){
				var $img = $(this).find("img");
				$img.attr("src",imgOn);
			}
		});
		$imageZone.unbind("drop").on("drop",function(e){
			e.preventDefault();
			
			var $img = $(this).find("img");
			
			var files = e.originalEvent.dataTransfer.files;
			if(files.length > 0){
				var $o = $(e.target);
				var $row = $o.parent().parent().parent().parent().parent().parent();
				var id = $row.attr("data-seq");
				
				var imgFile = files[0];
				var ext = imgFile["name"].split(".")[1];
				if (!(ext == "gif" || ext == "jpg" || ext == "png")) {
					commonUtil.msgBox("이미지파일(.jpg, .png, .gif )만  등록 가능합니다.");
					var list = dataList.filter(function(element,index,array){
						return element["SEQ"] == id;
					});
					if(list.length > 0){
						var rowData = list[0];
						var imgPath = rowData["IMGFTH"];
						if($.trim(imgPath)!=""){
							$img.removeClass("noImg");
							$img.attr("src",imgPath);
						}
					}
					return;
				}
				
				var reader = new FileReader();
				reader.onload = (function(f) {
					return function(e){
						var src = e.target.result;
						$img.attr("src",src);
					}
				})(imgFile);
				reader.readAsDataURL(imgFile);
				
				if(fileMap.containsKey(id)){
					fileMap.get(id).put("imgFile",imgFile);
				}else{
					var defaultMap = new DataMap();
					defaultMap.put("file",null);
					defaultMap.put("imgFile",imgFile);
					
					fileMap.put(id,defaultMap);
				}
				
				if($row.hasClass("U")){
					var imgType = typeMap["update"];
					setRowEditType("IMG",id,imgType);
				}
				
				var $imgBtn = $(".imgRegBtn");
				$(".imgRegBtn").removeClass("imgOff");
				$imgBtn.addClass("imgOn");
				$img.removeClass("noImg");
				$imgBtn.find("img").attr("src","/mobile/img/ico/minus-white.png");
			}
		});
	}
	
	function setSourceRegFileEvent(){
		var fileOn = "/common/theme/gsfresh/images/icon/ico_drag_on.png";
		var fileOff = "/common/theme/gsfresh/images/icon/ico_drag_off.png";
		var $regFileDropZone = $(".fileRegInit");
		var $regFileInput = $("[name=regSourceFile]");
		var $fileImg = $(".noFileImg").find("img");
		
		$regFileDropZone.unbind("click").on("click",function(e){
			e.stopPropagation();
			e.preventDefault();
			$regFileInput.trigger("click");
		});
		$regFileDropZone.unbind("dragenter").on("dragenter",function(e){
			e.stopPropagation();
			e.preventDefault();
			$regFileDropZone.css("background-color","#efefef");
			$regFileDropZone.attr("src",fileOn);
		});
		$regFileDropZone.unbind("dragleave").on("dragleave",function(e){
			e.stopPropagation();
			e.preventDefault();
			$regFileDropZone.css("background-color","#ffffff");
			$fileImg.attr("src",fileOff);
		});
		$regFileDropZone.unbind("dragover").on("dragover",function(e){
			e.stopPropagation();
			e.preventDefault();
			$regFileDropZone.css("background-color","#efefef");
			$fileImg.attr("src",fileOn);
		});
		$regFileDropZone.unbind("drop").on("drop",function(e){
			e.preventDefault();
			
			$fileImg.attr("src",fileOff);
			$regFileDropZone.css("background-color","#ffffff");

			var files = e.originalEvent.dataTransfer.files;
			if(files != null){
				if(files.length < 1){
					alert("폴더 업로드 불가");
					return;
				}
				selectRegFile(files,$regFileInput)
			}else{
				alert("ERROR");
			}
		});
	}
	
	function setRowEditType(fileType,id,type){
		fileType = (fileType == "IMG")?"IMGSAV":"FIESAV";
		var dataLen = dataList.length;
		if(dataLen > 0){
			dataList.filter(function(element,index,array){
				if(element["SEQ"] == id){
					dataList[index][fileType] = type;
				}
			});
		}
	}
	
	function setRow(type,data){
		var seq = "";
		var imgfky = "";
		var vertxt = "";
		var ver001 = "";
		var ver002 = "";
		var ver003 = "";
		var imgfth = "";
		var appdnm = "";
		var apkfnm = "";
		var apksiz = "";
		
		if(type != "A" && (data != null && data != undefined)){
			seq    = data["SEQ"];
			imgfky = data["IMGFKY"];
			vertxt = data["APPVER"];
			ver001 = data["VER001"];
			ver002 = data["VER002"];
			ver003 = data["VER003"];
			//imgfth = data["IMGFTH"];
			if($.trim(imgfky) != ""){
				imgfth = "/wms/admin/icon/view.data?uuid="+imgfky;
			}
			appfnm = data["APPFNM"];
			apkfnm = data["APKFNM"];
			apksiz = data["APKSIZ"];
		}
		
		if(type != "U" && type != "R"){
			var $div     = $("<div>");
			var $p       = $("<p>");
			var $img     = $("<img>");
			var $input   = $("<input>");
			var $form    = $("<form>");
			var $button  = $("<button>");
			
			var $row     = $div.clone().addClass("row").addClass(type);
				$row.attr("data-seq",(type == "A")?"A_"+($(".row.A").length + 1):seq);
			var addIco = "/common/theme/gsfresh/images/icon/ico_btn_add.png";
			var defaultIco = "/common/images/ico-right-arrow.png";
			
			var $tit     = $div.clone().addClass("tit");
			var $title   = $p.clone().text((type != "A")?vertxt:"");
				$tit.append($img.clone().addClass((type == "A")?"add":"").attr("src",(type == "A"?addIco:defaultIco)))
				    .append($title);
			
			var $reg     = $div.clone().addClass("reg");
			var $regWrap = $div.clone().addClass("regWrap");
				$regWrap.append($input.clone().attr({"type":"file","name":"file","onchange":"changeFile(this);"}))
						.append($input.clone().attr({"type":"file","name":"imgFile","onchange":"changeImageFile(event);"}));
						
			var $regForm = $form.clone().attr("autocomplete","off");
			
			if(type != "A"){
				if($.trim(imgfth) == ""){
					imgfth = "/common/theme/gsfresh/images/icon/ico_add_img_off.png";
				}
			}else{
				imgfth = "/common/theme/gsfresh/images/icon/ico_add_img_off.png";
			}
			
			var $rgCont1 = $div.clone().addClass("regCont1");
				$rgCont1.append($div.clone().addClass("imgRegBtn").addClass("imgOff").attr("onclick","openImageFile(this);")
									.append($img.clone().attr("src","/mobile/img/ico/plus-white.png")))
						.append($div.clone().addClass("imgRegWrap").append($img.clone().addClass("noImg").attr("src",imgfth)))
						.append($div.clone().addClass("apkNameWrap").append($p.clone().addClass("appTitle").text("앱 명칭"))
																	.append($p.clone().addClass("appText")
																			  .append($input.clone().attr({"type":"text","name":"APPFNM"}))));
			
			var $rgCont2 = $div.clone().addClass("regCont2");
			var $apkVer  = $div.clone().addClass("apkVerWrap");
			var $verTit  = $p.clone().addClass("verTitle").text("Version");
			var $verTxt  = $p.clone().addClass("verText");
			var $verDot  = $p.clone().addClass("verDot").text(".");
				$rgCont2.append($apkVer.append($verTit)
									   .append($verTxt.clone().append($input.clone().attr({"type":"text","name":"VER001","maxlength":"1","numberOnly":true})))
									   .append($verDot.clone())
									   .append($verTxt.clone().append($input.clone().attr({"type":"text","name":"VER002","maxlength":"1","numberOnly":true})))
									   .append($verDot.clone())
									   .append($verTxt.clone().append($input.clone().attr({"type":"text","name":"VER003","maxlength":"1","numberOnly":true}))));
			
			var $rgCont3 = $div.clone().addClass("regCont3");
			var $rg3tit  = $div.clone().addClass("apkUpTitleWrap").append($p.clone().text("APK 파일 등록"));
			var $apkUpWp = $div.clone().addClass("apkUpWrap").attr("id","apkFileZone");
			var $apkCont = $div.clone().addClass("apkUpCont");
			var $noApkCt = $div.clone().addClass("noApkWrap");
			var $noApkIg = $div.clone().addClass("noApkImg").append($img.clone().attr("src","/common/theme/gsfresh/images/icon/ico_drag_off.png"));
			var $noApktx = $div.clone().addClass("noApkText").append($p.clone().html("파일을 끌어다가 놓거나 <span>클릭</span>  하여"))
															 .append($p.clone().text("파일을 선택 해주세요."));
			var $apkFile = $div.clone().addClass("apkFileWrap");
			var $apkImg  = $div.clone().addClass("apkImg").append($img.clone().attr("src","/common/theme/gsfresh/images/icon/ico_apk.png"));
			var $apkInf  = $div.clone().addClass("apkInf");
			var $inf     = $div.clone().addClass("inf").append($p.clone().addClass("fileNm"))
													   .append($p.clone().addClass("fileSize"));
			var $btn     = $div.clone().addClass("btn");
				$rgCont3.append($rg3tit)
						.append($apkUpWp.append($apkCont.append($noApkCt.append($noApkIg).append($noApktx))
										.append($apkFile.append($apkImg).append($apkInf.append($inf).append($btn)))));
			
			var $editBtnArea = $div.clone().addClass("editBtnArea");
				$editBtnArea.append($button.clone().addClass("refresh").attr("onclick","refreshRow(event,'"+type+"');"))
							.append($button.clone().addClass("save").attr("onclick","saveRow(event,'"+type+"');"))
							.append($button.clone().addClass("delete").attr("onclick","deleteRow(event,'"+type+"');"));
			
			if(type == "A"){
				$editBtnArea.css("display","block");
			}
			
			$row.append($tit)
				.append($reg.append($regWrap.append($regForm.append($rgCont1)
															.append($rgCont2)
															.append($rgCont3))))
				.append($editBtnArea);
			
			var $area = $(".tabArea");
			var $item = $area.children();
			if($item.length > 0 && type != "I"){
				$item.eq(0).before($row.clone());
			}else{
				$area.append($row.clone());
			}
			
			setRowEvent();
		}
		
		var $curretRow = $(".row[data-seq='"+seq+"']");
		var $curretImgBtn = $curretRow.find(".imgRegBtn");
		var $curretImgWrp = $curretRow.find(".imgRegWrap");
		var $curretImg = $curretImgWrp.find("img");
		if(type != "R" && type != "I"){
			setRegFileEvent();
			if(type == "U"){
				$curretRow.removeClass("I").removeClass("U").removeClass("R").addClass("U");
				if($.trim(data["IMGFTH"]) != ""){
					$curretImgBtn.removeClass("imgOff").addClass("imgOn");
					$curretImgBtn.find("img").attr("src","/mobile/img/ico/minus-white.png");
				}
				$curretImgBtn.show();
				$curretImgWrp.removeClass("imageWrapDisabled");
				$curretImg.removeClass("imageDisabled");
				$curretRow.find("input").removeClass("inputDisabled").attr("disabled",false);
				$curretRow.find(".btn").show();
				
				var $btns = $curretRow.find(".editBtnArea");
				$btns.find(".refresh").attr("onclick","refreshRow(event,'"+type+"');");
				$btns.find(".save").attr("onclick","saveRow(event,'"+type+"');");
				$btns.find(".delete").attr("onclick","deleteRow(event,'"+type+"');");
			}
		}else{
			if(type == "R"){
				$curretRow.removeClass("I").removeClass("U").removeClass("R").addClass("R");
				$curretImgBtn.hide();
				$curretImgWrp.addClass("imageWrapDisabled");
				$curretImg.addClass("imageDisabled");
				if($curretImg.attr("src") == "/common/theme/gsfresh/images/icon/ico_add_img_off.png"){
					$curretImg.removeClass("noImg").addClass("noImg");
				}else{
					$curretImg.removeClass("noImg");
				}
				$curretRow.find("input").addClass("inputDisabled").attr("disabled",true);
				$curretRow.find(".btn").hide();
				
				var $btns = $curretRow.find(".editBtnArea");
				$btns.find(".refresh").attr("onclick","refreshRow(event,'"+type+"');");
				$btns.find(".save").attr("onclick","saveRow(event,'"+type+"');");
				$btns.find(".delete").attr("onclick","deleteRow(event,'"+type+"');");
			}else{
				$curretImgBtn.hide();
				$curretImgWrp.addClass("imageWrapDisabled");
				if($curretImg.attr("src") == "/common/theme/gsfresh/images/icon/ico_add_img_off.png"){
					$curretImg.removeClass("noImg").addClass("noImg");
				}else{
					$curretImg.removeClass("noImg");
				}
				$curretRow.find("input").addClass("inputDisabled").attr("disabled",true);
				
				$curretRow.find("input[name=APPFNM]").val(appfnm);
				$curretRow.find("input[name=VER001]").val(ver001);
				$curretRow.find("input[name=VER002]").val(ver002);
				$curretRow.find("input[name=VER003]").val(ver003);
				
				$curretRow.find(".noApkWrap").hide();
				$curretRow.find(".apkFileWrap").show();
				$curretRow.find(".fileNm").text(apkfnm);
				$curretRow.find(".fileSize").text(apksiz);
				$curretRow.find(".btn").hide();
			}
		}
		
		var rowLen = $(".row").length;
		if(rowLen > 0){
			$("#noRowGrid").hide();
		}
		
		if(type == "A"){
			var $curretRow = $(".row").eq(0);
			if((rowLen > 0 && rowLen == 1)){
				$curretRow.find(".tit").find("p").text("1.0.0");
				$curretRow.find("input[name=VER001]").val("1");
				$curretRow.find("input[name=VER002]").val("0");
				$curretRow.find("input[name=VER003]").val("0");
				$curretRow.attr("data-version","1.0.0");
			}else{
				var maxVer = 0;
				$(".row").each(function(){
					var verNum = $(this).find(".tit").find("p").text();
					if(verNum != undefined){
						var n = commonUtil.parseInt(commonUtil.replaceAll(verNum, ".", ""));
						if(maxVer < n){
							maxVer = n + 1;
						}
					}
				});
				var strMaxVer = String(maxVer);
				var ver1 = strMaxVer.substr(0,1);
				var ver2 = strMaxVer.substr(1,1);
				var ver3 = strMaxVer.substr(2,1);
				var version = ver1 + "." + ver2 + "." + ver3;
				
				$curretRow.find(".tit").find("p").text(version);
				$curretRow.find("input[name=VER001]").val(ver1);
				$curretRow.find("input[name=VER002]").val(ver2);
				$curretRow.find("input[name=VER003]").val(ver3);
				$curretRow.attr("data-version",version);
			}
			
			setTimeout(function(){
				var $addRow = $(".tabArea .row .tit").eq(0);
				rowClickEvent($addRow);
				$area.animate({scrollTop:0});
			});
		}	
	}
	
	function rowCountCheck(){
		var rowLen = $(".row").length;
		if(rowLen > 0){
			$("#noRowGrid").hide();
		}else{
			$("#noRowGrid").show();
			
			var $btn = $(".btn1Area");
			if($btn.hasClass("on")){
				$btn.trigger("click");
			}
			
			if(dataList.length > 0){
				dataList = [];
			}
		}
	}
	
	function changeVersionTitle($o){
		var returnValue = "";
		
		var $wrap = $o.parent().parent();
		var $obj = $wrap.find(".verText").find("input");
		$obj.each(function(i){
			var dot = ".";
			if(i == 2){
				dot = "";
			}
			var value = $(this).val();
			if($.trim(value) == ""){
				value = 0;
			}
			
			returnValue = returnValue + value + dot;
		});
		
		var $row = $wrap.parent().parent().parent().parent().parent();
		var $tit = $row.find(".tit").find("p");
		$tit.html(returnValue);
	}
	
	function refreshRow(e,type){
		var $obj;
		if(e == undefined){
			$obj = e;
		}else{
			$obj = $(e.target);
		}
		var $row = $obj.parent().parent();
		var id = $row.attr("data-seq");
		
		var $imgArea    = $row.find(".imgRegWrap");
		var $img        = $imgArea.find("img");
		var $imgBtnArea = $row.find(".imgRegBtn");
		var $imgBtn     = $imgBtnArea.find("img");
		var imgOnOff    = "/common/theme/gsfresh/images/icon/ico_add_img_off.png";
		var imgPlus     = "/mobile/img/ico/plus-white.png";
		var imgMinus    = "/mobile/img/ico/minus-white.png";
		var $noFileZone = $row.find(".noApkWrap");
		var $fileZone   = $row.find(".apkFileWrap");
		
		if(fileMap.containsKey(id)){
			fileMap.get(id).put("imgFile",null);
			fileMap.get(id).put("file",null);
		}
		
		switch (type) {
		case "A":
			var version = $row.attr("data-version");
			var ver = version.split(".");
			$row.find(".tit").find("p").text(version);
			
			$row.find("input[name=APPFNM]").val("");
			$row.find("input[name=VER001]").val(ver[0]);
			$row.find("input[name=VER002]").val(ver[1]);
			$row.find("input[name=VER003]").val(ver[2]);
			
			$imgBtnArea.removeClass("imgOn").removeClass("imgOff").addClass("imgOff");
			$imgBtn.attr("src",imgPlus);
			$img.addClass("noImg").attr("src",imgOnOff);
			
			$noFileZone.show();
			$fileZone.hide();
			
			$fileZone.find(".fileNm").text("");
			$fileZone.find(".fileSize").text("");
			
			break;
		case "U":
			var seq    = "";
			var imgfky = "";
			var vertxt = "";
			var ver001 = "";
			var ver002 = "";
			var ver003 = "";
			var imgfth = "";
			var appfnm = "";
			var apkfnm = "";
			var apksiz = "";
			
			var list = dataList.filter(function(element,index,array){
				return element["SEQ"] == id;
			});
			if(list.length > 0){
				var rowData = list[0];
				seq    = rowData["SEQ"];
				imgfky = rowData["IMGFKY"];
				vertxt = rowData["APPVER"];
				ver001 = rowData["VER001"];
				ver002 = rowData["VER002"];
				ver003 = rowData["VER003"];
				//imgfth = rowData["IMGFTH"];
				if($.trim(imgfky) != ""){
					imgfth = "/wms/admin/icon/view.data?uuid="+imgfky;
				}
				appfnm = rowData["APPFNM"];
				apkfnm = rowData["APKFNM"];
				apksiz = rowData["APKSIZ"];
			}
			
			$row.find(".tit").find("p").text(vertxt);
			
			$row.find("input[name=APPFNM]").val(appfnm);
			$row.find("input[name=VER001]").val(ver001);
			$row.find("input[name=VER002]").val(ver002);
			$row.find("input[name=VER003]").val(ver003);
			
			if($.trim(imgfth) == ""){
				$imgBtnArea.removeClass("imgOn").removeClass("imgOff").addClass("imgOff");
				$imgBtn.attr("src",imgPlus);
				$img.addClass("noImg").attr("src",imgOnOff);
			}else{
				$imgBtnArea.removeClass("imgOn").removeClass("imgOff").addClass("imgOn");
				$imgBtn.attr("src",imgMinus);
				$img.removeClass("noImg").attr("src",imgfth);
			}
			
			$noFileZone.hide();
			$fileZone.show();
			
			$fileZone.find(".fileNm").text(apkfnm);
			$fileZone.find(".fileSize").text(apksiz);
			
			break;
		default:
			return;
			break;
		}
	}
	
	function saveRow(e,type){
		var $obj = $(e.target);
		var $row = $obj.parent().parent();
		var id = $row.attr("data-seq");
		var saveType = "";
		var imgSave = "";
		var fileSave = "";
		switch (type) {
		case "A":
			saveType = "A";
			break;
		case "U":
			saveType = "U";
			var list = dataList.filter(function(element,index,array){
				return element["SEQ"] == id;
			});
			if(list.length > 0){
				var rowData = list[0];
				imgSave = rowData["IMGSAV"];
				fileSave = rowData["FIESAV"];
			}
			break;
		default:
			//저장 할 수 없는 유형 
			return;
		
			break;
		}
		
		var $form = $row.find("form");
		var formData = new FormData($form[0]);
			formData.append("seq", id);
			formData.append("file", (fileMap.containsKey(id))?fileMap.get(id).get("file"):null);
			formData.append("imgFile", (fileMap.containsKey(id))?fileMap.get(id).get("imgFile"):null);
			formData.append("type", saveType);
			formData.append("imgSave", imgSave);
			formData.append("fileSave", fileSave);
		$.ajax({
			url:"/wms/admin/saveAppData.data",
			data:formData,
			type:"POST",
			enctype:"multipart/form-data",
			processData:false,
			contentType:false,
			dataType:"json",
			cache:false,
			beforeSend : function(){
				showProgress();
			},
			error : function(a, b, c){
				hideProgress();
				
				setTimeout(function(){
					var errMsg = a.responseText;
					if(errMsg.indexOf("Session empty") > -1){
						commonUtil.msgBox("세션이 만료되어 로그인 화면으로 이동합니다.");
						window.top.location.href = "/index.jsp";
					}else{
						errMsg = commonUtil.replaceAll(errMsg, "\r\n", "");
						commonUtil.msgBox(errMsg);
					}
				}, 700);
			},
			success:function(json){
				if(json.data["result"] = "S"){
					var seq = json.data["SEQ"];
					if(type == "A"){
						$row.removeClass("A").addClass("U");
						$row.attr("data-seq",seq);
						$row.find(".tit").find("img").attr("src","/common/images/ico-right-arrow.png");
						$row.find(".tit").find("img").removeClass("add").addClass("down");
					}
					
					dataList = [];
					
					var json = netUtil.sendData({
						module : "System",
						command : "AK01",
						sendType : "list"
					});
					
					if(json && json.data){
						var list = json.data;
						var len = list.length;
						if(len > 0){
							for(var i = 0; i < len; i++){
								var row = list[i];
								dataList.push(row);
								setRow(typeMap["update"],row);
							}
						}
					}
					
				}
				
				hideProgress();
			}
		});
	}
	
	function deleteRow(e,type){
		var $obj = $(e.target);
		var $row = $obj.parent().parent();
		var id = $row.attr("data-seq");
		if(fileMap.containsKey(id)){
			fileMap.remove(id);
		}
		
		switch (type) {
		case "A":
			$row.remove();
			rowCountCheck();
			break;
		case "U":
			var param = new DataMap();
			param.put("SEQ",id);
			
			var paramStr = param.jsonString();
			while(paramStr.indexOf("??") != -1){
				paramStr = commonUtil.replaceAll(paramStr, "??", "?");
			}
			
			$.ajax({
				type: "POST",
				url : "/wms/admin/json/deleteAppData.data",
				async : false,
				data : paramStr,
				dataType : "json",
				contentType: "application/json",
				beforeSend : function(){
					showProgress();
				},
				error : function(a, b, c){
					hideProgress();
					
					setTimeout(function(){
						var errMsg = a.responseText;
						if(errMsg.indexOf("Session empty") > -1){
							commonUtil.msgBox("세션이 만료되어 로그인 화면으로 이동합니다.");
							window.top.location.href = "/index.jsp";
						}else{
							errMsg = commonUtil.replaceAll(errMsg, "\r\n", "");
							commonUtil.msgBox(errMsg);
						}
					}, 700);
				},
				success : function (json) {
					if(json.data == "S"){
						$row.remove();
						
						var json = netUtil.sendData({
							module : "System",
							command : "AK01",
							sendType : "list"
						});
						
						if(json && json.data){
							var list = json.data;
							var len = list.length;
							if(len > 0){
								for(var i = 0; i < len; i++){
									var row = list[i];
									dataList.push(row);
								}
							}
							
							rowCountCheck();
						}
					}
					
					hideProgress();
				}
			});
			break;
		default:
			break;
		}
	}
	
	function refreshAll(){
		var $refresh = $(".refreshArea img");
		$refresh.addClass("spin");
		
		fileMap = new DataMap();
		dataList = [];
		
		$(".row").remove();
		
		var json = netUtil.sendData({
			module : "System",
			command : "AK01",
			sendType : "list"
		});
		
		if(json && json.data){
			var list = json.data;
			var len = list.length;
			if(len > 0){
				for(var i = 0; i < len; i++){
					var row = list[i];
					dataList.push(row);
					setRow(typeMap["init"],row);
				}
			}
			
			rowCountCheck();
		}
		
		var $btn = $(".btn1Area");
		if($btn.hasClass("on")){
			$btn.trigger("click");
		}
		
		setTimeout(function(){
			$refresh.remove();
			$(".refreshArea").append($("<img>").clone().attr({"src":"/common/theme/gsfresh/images/icon/ico_refresh_all.png","alt":"새로고침"}));
		},400);
	}
	
	function regRefreshAll(){
		var $refresh = $(".regRefreshArea img");
		$refresh.addClass("spin");
		
		selectRegList();
		
		setTimeout(function(){
			$refresh.remove();
			$(".regRefreshArea").append($("<img>").clone().attr({"src":"/common/theme/gsfresh/images/icon/ico_refresh_all.png","alt":"새로고침"}));
		},400);
	}
	
	function appGuiPageMove(type){
		var pageCount = $(".page").length;
		if(type == "next"){
			if((pageCount - 1) > appGuiCount){
				appGuiCount++;
			}else{
				return;
			}
		}else if(type == "prev"){
			if(appGuiCount > 0){
				appGuiCount--;
			}else{
				return;
			}
		}
		$("#appCnt").text(appGuiCount + 1);
		var w = appGuiW*appGuiCount;
		$(".guideContentScroll").animate({scrollLeft:w});
		if(appGuiCount > 0){
			$(".page").eq(appGuiCount - 1).find(".pageScroll").scrollTop(0);
		}
	}
	
	function navigate(page,subContentId){
		appGuiCount = page;
		$("#appCnt").text(appGuiCount + 1);
		$(".guideContentScroll").scrollLeft(appGuiW*appGuiCount);
		
		if(subContentId == "" || subContentId == undefined){
			$(".page").eq(page).find(".pageScroll").scrollTop(0);
		}else{
			if(subContentId.split("_")[1] == "1"){
				$(".page").eq(page).find(".pageScroll").scrollTop(0);
			}else{
				var offset = $("#" + subContentId).offset();
				$(".page").eq(page).find(".pageScroll").scrollTop(offset.top);
			}
		}
	}
	
	function selectRegList(){
		$(".fileList").children().remove();
		
		regFileList = [];
		
		var $fileInput = $("input[name=regSourceFile]");
		if (Browser.ie) {
			$fileInput.replaceWith( $imgFileInput.clone(true) );
		} else {
			$fileInput.val("");
		}
		
		var json = netUtil.sendData({
			module : "System",
			command : "APP_SRC",
			sendType : "list"
		});
		
		if(json && json.data){
			var list = json.data;
			var len = list.length;
			if(len > 0){
				for(var i = 0; i < len; i++){
					var row = list[i];
					setRegFileItemList(row);
				}
				
				$(".fileList").show();
				$(".noRegFile").hide();
			}else{
				$(".fileList").hide();
				$(".noRegFile").show();
			}
		}
	}
	
	function regFileDelete(){
		regFileList = [];
		
		var $fileInput = $("input[name=regSourceFile]");
		if (Browser.ie) {
			$fileInput.replaceWith( $imgFileInput.clone(true) );
		} else {
			$fileInput.val("");
		}
		
		var imgPath = "/common/theme/gsfresh/images/fileIcon/ico_file_etc.png";
		
		var $init = $("#fileRegInit");
		var $inf = $("#fileRegContent");
		
		var $fileNm = $("#regFileName");
		var $fileSize = $("#regFileSize");
		var $fileImg = $(".regFileIcon");
		
		$fileImg.find(".icoWrap").remove();
		$fileImg.css({"background":"url("+(imgPath)+") no-repeat","background-size":"80px","background-position":"center"});
		
		$fileNm.text("");
		$fileSize.text("");
		
		$inf.hide();
		$init.show();
	}
	
	function regFileSave(){
		var maxSize = 1024*1024*1024;
		if(regFileList[0].size > maxSize){
			commonUtil.msgBox("처리할 수 없는 파일 크기 입니다.(제한: 1GB)");
			regFileList = [];
			regFileDelete();
			return;
		}
		
		var ext = "";
		if(regFileList.length > 0){
			var fileName = regFileList[0].name;
			ext = fileName.substr(fileName.lastIndexOf(".") +1);
		}
		if(!fileExtentionCheck(ext)){
			commonUtil.msgBox("처리할 수 없는 파일 유형 입니다.");
			regFileList = [];
			regFileDelete();
			return;
		}
		
		var $form = $("#fileRegInit").find("form");
		var formData = new FormData($form[0]);
			formData.append("file", (regFileList.length > 0)?regFileList[0]:null);
		$.ajax({
			url:"/wms/admin/saveAppSourceData.data",
			data:formData,
			type:"POST",
			enctype:"multipart/form-data",
			processData:false,
			contentType:false,
			dataType:"json",
			cache:false,
			beforeSend : function(){
				showProgress();
			},
			error : function(a, b, c){
				hideProgress();
				
				setTimeout(function(){
					var errMsg = a.responseText;
					if(errMsg.indexOf("Session empty") > -1){
						commonUtil.msgBox("세션이 만료되어 로그인 화면으로 이동합니다.");
						window.top.location.href = "/index.jsp";
					}else{
						errMsg = commonUtil.replaceAll(errMsg, "\r\n", "");
						commonUtil.msgBox(errMsg);
					}
				}, 700);
			},
			success:function(json){
				if(json.data["result"] = "S"){
					regFileList = [];
					regFileDelete();
					selectRegList();
					hideProgress();
				}
			}
		});
	}
	
	function fileExtentionCheck(ext) {
		ext = ext.toUpperCase();
		var isPass = false;
		switch (ext) {
		case "PNG":
			isPass = true;
			break;
		case "JPEG":
			isPass = true;
			break;
		case "JPG":
			isPass = true;
			break;
		case "GIF":
			isPass = true;
			break;
		case "BMP":
			isPass = true;
			break;	
		case "XLSX":
			isPass = true;
			break;
		case "XLS":
			isPass = true;
			break;
		case "CSV":
			isPass = true;
			break;	
		case "TXT":
			isPass = true;
			break;	
		case "DOC":
			isPass = true;
			break;
		case "DOCX":
			isPass = true;
			break;
		case "PDF":
			isPass = true;
			break;
		case "PPT":
			isPass = true;
			break;
		case "PPTX":
			isPass = true;
			break;
		case "HWP":
			isPass = true;
			break;
		case "APK":
			isPass = true;
			break;
		case "ZIP":
			isPass = true;
			break;	
		default:
			isPass = false;
			break;
		}
		return isPass;
	}
	
	function regFileListDelete($o){
		var $row = $($o).parent().parent().parent().parent();
		var uuid = $row.attr("data-file-seq");
		
		var param = new DataMap();
		param.put("UUID",uuid);
		
		var paramStr = param.jsonString();
		while(paramStr.indexOf("??") != -1){
			paramStr = commonUtil.replaceAll(paramStr, "??", "?");
		}
		
		$.ajax({
			type: "POST",
			url : "/wms/admin/json/deleteAppSourceData.data",
			async : false,
			data : paramStr,
			dataType : "json",
			contentType: "application/json",
			beforeSend : function(){
				showProgress();
			},
			error : function(a, b, c){
				hideProgress();
				
				setTimeout(function(){
					var errMsg = a.responseText;
					if(errMsg.indexOf("Session empty") > -1){
						commonUtil.msgBox("세션이 만료되어 로그인 화면으로 이동합니다.");
						window.top.location.href = "/index.jsp";
					}else{
						errMsg = commonUtil.replaceAll(errMsg, "\r\n", "");
						commonUtil.msgBox(errMsg);
					}
				}, 700);
			},
			success : function (json) {
				if(json.data == "S"){
					selectRegList();
					hideProgress();
				}
			}
		});
	}
	
	function setRegFileItemList(data){
		var uuid     = data["UUID"];
		var mime     = data["MIME"];
			mime     = mime.toUpperCase();
		var fileName = data["NAME"];
		var fileSize = data["FILESIZE"];
		var fileTime = data["CREDAT"];
		
		var isImg   = false;
		var imgPath = "/common/theme/gsfresh/images/fileIcon/ico_file_etc.png";
		switch (mime) {
		case "PDF":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_pdf.png";
			break;
		case "PPT":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_ppt.png";
			break;
		case "PPTX":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_ppt.png";
			break;
		case "PPTX":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_ppt.png";
			break;
		case "DOC":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_word.png";
			break;
		case "DOCX":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_word.png";
			break;
		case "XLSX":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_excel.png";
			break;
		case "XLS":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_excel.png";
			break;
		case "ZIP":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_zip.png";
			break;
		case "APK":
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/icon/ico_apk.png";
			break;
		case "PNG":
			isImg = true;
			break;
		case "JPEG":
			isImg = true;
			break;
		case "JPG":
			isImg = true;
			break;
		default:
			isImg = false;
			imgPath = "/common/theme/gsfresh/images/fileIcon/ico_file_etc.png";
			break;
		}
		
		if(isImg){
			imgPath = "/wms/admin/icon/view.data?uuid=" + uuid;
		}
		
		
		var $div = $("<div>");
		var $p   = $("<p>");
		var $img = $("<img>");
		var $btn = $("<button>");
		
		var $itemList     = $div.clone().addClass("fileItem").attr("data-file-seq",uuid);
		var $itemWrap     = $div.clone().addClass("fileItemWrap");
		
		var $itemIconWrap = $div.clone().addClass("fileItemIcon");
		var $iconImg      = $img.clone();
			$iconImg.attr("src",imgPath);
		var $itemIcon     = $p.clone().addClass("iconWrap");
			$itemIcon.append($iconImg);
		var $sizeTit      = $p.clone().text("파일 크기 : ");
		var $timeTit      = $p.clone().text("등록 일시 : ");
			$itemIconWrap.append($itemIcon).append($sizeTit).append($timeTit);
			
		var $itemContentWrap = $div.clone().addClass("fileItemCont");
		var $itemFileName    = $p.clone().addClass("fileItemName").text(fileName);
		var $itemFileSize    = $p.clone().addClass("fileItemSize").text(fileSize);
		var $itemFileTime    = $p.clone().addClass("fileItemTime").text(fileTime);
			$itemContentWrap.append($itemFileName).append($itemFileSize).append($itemFileTime);
		
		var $itemBtnWrap = $div.clone().addClass("fileItemBtn");
		var $remove      = $div.clone().addClass("fileItemRemove");
		var $removeBtn   = $btn.clone().attr("onclick","regFileListDelete(this);");
			$remove.append($removeBtn);
		var $down        = $div.clone().addClass("fileItemDown");
		var $downBtn     = $btn.clone().attr("onclick","fileDownload(this)");
			$down.append($downBtn);
			$itemBtnWrap.append($remove).append($down);
		
			$itemList.append($itemWrap.append($itemIconWrap).append($itemContentWrap).append($itemBtnWrap));
		
		var $fileList     = $(".fileList");
		$fileList.append($itemList);
	}
	
	function fileDownload($o){
		var $row = $($o).parent().parent().parent().parent();
		var uuid = $row.attr("data-file-seq");
		
		$("#fileDownloadForm").remove();
		var $form = $("<form>");
		var $input = $("<input>");
		var $f = $form.clone().attr({
			"action":"/common/fileDown/file.data",
			"method": "post",
			"id":"fileDownloadForm" 
		});
		var $i =$input.clone().attr({
			"type":"hidden",
			"name":"UUID"
		});
		$i.val(uuid);
		$f.append($i);
		$f.hide().appendTo("body");
		$("#fileDownloadForm").submit();
	}
	
	function goAndriodPage(){
		window.open("https://developer.android.com/studio/");
	}
	
	function showProgress(){
		var $prog = $("#progressLoding");
		$prog.show();
	}
	
	function hideProgress(){
		var $prog = $("#progressLoding");
		setTimeout(function(){
			$prog.hide();
		}, 600);
	}
</script>
</head>
<body>
<div class="contentHeader"></div>
<!-- content -->
<div class="content" style="top: 0">
		<div class="innerContainer">
			<!-- contentContainer -->
			<div class="contentContainer">
				<div class="bottomSect bottom" style="top: -8px;">
					<div class="tabs" style="border-bottom: 0;">
						<div id="tabs1-1">
							<div class="section type1" style="border-radius: 5px 5px 5px 5px;border-top-width: 1px;">
								<div class="table type2" style="bottom: 9px;">
									<div class="versionWrap">
										<div class="versionBox">
											<div id="tab1">
												<p>앱 버전 관리</p>
												<span class="ra1"></span>
											</div>
											<div id="tab2">
												<p>앱 소스 관리</p>
												<span class="ra2"></span>
											</div>
										</div>
									</div>
									<div class="contentWrap">
										<div class="subContent" id="appVersion">
											<div class="appReg">
												<div class="btnArea">
													<div class="btn1Area">
														<img alt="편집" src="/common/theme/gsfresh/images/icon/ico_edit_list.png">
													</div>
													<div class="btn2Area">
														<div class="addBtn">
															<img alt="추가" src="/common/theme/gsfresh/images/icon/ico_add_row.png">
															<p>앱 버전 추가</p>
														</div>
													</div>
												</div>
												<div class="refreshArea" onclick="refreshAll();">
													<img src="/common/theme/gsfresh/images/icon/ico_refresh_all.png" alt="새로고침"/>
												</div>
												<div class="tabArea">
													<div id="noRowGrid" class="noRow">
														<div class="noRowCont">
															<p class="txt1">
																<span class="icoInf"></span>
																<span>등록된 버전이 없습니다.</span>
															</p>
															<p class="txt2">버전을 <span class="bold" onclick="setRow('A');">추가</span>  해 주세요.</p>
														</div>
													</div>
												</div>
											</div>
											<div class="appRegGuide">
												<div class="guideTitleWrap">
													<div class="guideTitle">
														<p class="btnLeft" onclick="appGuiPageMove('prev');"><img src="/common/theme/gsfresh/images/icon/ico_list_left.png"/></p>
														<p class="guideTitleText" onclick="navigate(0,'');">앱 버전 관리 가이드 ( <span id="appCnt">0</span> / <span id="appTot">0</span> )</p>
														<p class="btnRight" onclick="appGuiPageMove('next');"><img src="/common/theme/gsfresh/images/icon/ico_list_right.png"/></p>
													</div>
												</div>
												<div class="guideContentWrap">
													<div class="guideContentScroll">
														<div class="guideContent">
															<div class="page" id="page1">
																<div class="pageScroll">
																	<h3>목차</h3>
																	<div class="listItem">
																		<div class="item1">
																			<h2 class="pointer" onclick="navigate(1,'');">1. 앱 버전 코드 변경 </h2>
																			<div class="item2">
																				<div class="item3" onclick="navigate(1,'1_1');">
																					<h1 class="pointer">1-1. 개발 버전 변경</h1>
																				</div>
																				<div class="item3" onclick="navigate(1,'1_2');">
																					<h1 class="pointer">1-2. 운영 버전 변경</h1>
																				</div>
																			</div>
																		</div>
																		<div class="item1">
																			<h2 class="pointer" onclick="navigate(2,'');">2. .apk 파일 추출</h2>
																			<div class="item2">
																				<div class="item3" onclick="navigate(2,'2_1');">
																					<h1 class="pointer">2-1. key store 등록</h1>
																				</div>
																				<div class="item3" onclick="navigate(2,'2_2');">
																					<h1 class="pointer">2-2. .apk 파일  생성</h1>
																				</div>
																			</div>
																		</div>
																		<div class="item1">
																			<h2 class="pointer" onclick="navigate(3,'');">3. 앱 버전 등록</h2>
																		</div>
																		<div class="item1">
																			<h2 class="pointer" onclick="navigate(4,'');">4. 주의사항</h2>
																		</div>
																	</div>
																</div>
															</div>
															<div class="page" id="page2">
																<div class="pageScroll">
																	<div class="listItem">
																		<div class="item1">
																			<h2>1. 앱 버전 코드 변경 </h2>
																			<div class="item2">
																				<div class="item3" id="1_1">
																					<h1>1-1. 개발 버전 변경</h1>
																					<div class="item4">
																						<p class="itemRow">
																							<span class="dot">■</span>
																							Android Studio 에서 [ Gradle Script ] > [ build.gradle(Module : app) ] 파일로 접근.
																						</p>
																						<p class="itemRow">
																							<img src="/common/theme/gsfresh/images/appGuide/guide1_1.png"/>
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							productFlavors -> dev -> versionName 과 versionCode 를 수정.
																						</p>
																						<p class="itemRow">
																							<img src="/common/theme/gsfresh/images/appGuide/guide1_2.png"/>
																						</p>
																					</div>
																				</div>
																				<div class="item3" id="1_2">
																					<h1>1-2. 운영 버전 변경</h1>
																					<div class="item4">
																						<p class="itemRow">
																							<span class="dot">■</span>
																							Android Studio 에서 [ Gradle Script ] > [ build.gradle(Module : app) ] 파일로 접근.
																						</p>
																						<p class="itemRow">
																							<img src="/common/theme/gsfresh/images/appGuide/guide1_1.png"/>
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							productFlavors -> prod -> versionName 과 versionCode 를 수정.
																						</p>
																						<p class="itemRow">
																							<img src="/common/theme/gsfresh/images/appGuide/guide1_3.png"/>
																						</p>
																					</div>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
															</div>	
															
															<div class="page" id="page3">
																<div class="pageScroll">
																	<div class="listItem">
																		<div class="item1">
																			<h2>2. .apk 파일 추출 </h2>
																			<div class="item2">
																				<div class="item3" id="2_1">
																					<h1>2-1. key store 등록</h1>
																					<div class="item4">
																						<p class="itemRow">
																							<span class="dot">■</span>
																							.apk 파일을 등록하기 위해선 key값이 필요 합니다. 기존에 등록한 key가 있을 경우, 등록하지 않고 재 사용 할 수 있습니다.
																						</p>
																						<p class="itemRow">
																							(<span style="color: red;">*</span>Android Studio 버전에 따라 등록 방법이 상이 할 수 있습니다.)
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							Android Studio에서 [Build] > [Generate Signed Bundle / APK…]를 클릭합니다.
																						</p>
																						<p class="itemRow">
																							<img src="/common/theme/gsfresh/images/appGuide/guide2_1.png"/>
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							APK 를 선택하고 [Next]를 클릭합니다.
																						</p>
																						<p class="itemRow">
																							<img src="/common/theme/gsfresh/images/appGuide/guide2_4.png"/>
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							기존에 생성된 key가 있으면 [Choose existing…]를 눌러 .apk 파일 추출을 진행합니다.
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							key가 없을 경우, [Create new…]를 클릭합니다.
																						</p>
																						<p class="itemRow">
																							<img src="/common/theme/gsfresh/images/appGuide/guide2_2.png"/>
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							key store path는 임의로 directory를 설정해야 합니다. 계속해서 key를 사용해야 하므로 잘 관리할 수 있는 경로를 선택합니다.
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							Password를 입력합니다.
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							Alias 또는 기타 추가 사항도 입력 가능 합니다. Alias변경 시, 추가 Password를 입력해야 합니다.
																						</p>
																						<p class="itemRow">
																							등록하지 않아도 문제없이 key가 발급됩니다.
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							Certificate 영역의 내용은 First and Last Name에 대해서만 기입해줘도 무관합니다.
																						</p>
																						<p class="itemRow">
																							<img src="/common/theme/gsfresh/images/appGuide/guide2_3.png"/>
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							[OK]를 클릭합니다.
																						</p>
																					</div>
																				</div>
																				<div class="item3" id="2_2">
																					<h1>2-2. .apk 파일 생성</h1>
																					<div class="item4">
																						<p class="itemRow">
																							<span class="dot">■</span>
																							Android Studio에서 [Build] > [Generate Signed Bundle / APK…]를 클릭합니다.
																						</p>
																						<p class="itemRow">
																							<img src="/common/theme/gsfresh/images/appGuide/guide2_1.png"/>
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							key를 등록하지 않았으면 [ 2-1. key store 등록]을 참조하여 key를 등록합니다. 
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							key가 등록되어 있으면 [Next]를 클릭 합니다. 
																						</p>
																						<p class="itemRow">
																							<img src="/common/theme/gsfresh/images/appGuide/guide2_5.png"/>
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							Build Variants에 따라서 각기 다른 apk 파일이 생성됩니다.
																						</p>
																						<p class="itemRow">
																							<table style="font-weight: bold;border: 2px solid #caccd1;">
																								<tr>
																									<td style="width: 150px;height: 35px;padding-left: 10px;">devDebug</td>
																									<td style="width: 300px;height: 35px;padding-left: 10px;">개발 디버깅용 apk 파일 생성 </td>
																								</tr>
																								<tr>
																									<td style="width: 150px;height: 35px;padding-left: 10px;color: #7fc241">devRelease</td>
																									<td style="width: 300px;height: 35px;padding-left: 10px;color: #7fc241">개발  apk 파일 생성 </td>
																								</tr>
																								<tr>
																									<td style="width: 150px;height: 35px;padding-left: 10px;">prodDebug</td>
																									<td style="width: 300px;height: 35px;padding-left: 10px;">운영 디버깅용 apk 파일 생성 </td>
																								</tr>
																								<tr>
																									<td style="width: 150px;height: 35px;padding-left: 10px;color: #7fc241">prodRelease</td>
																									<td style="width: 300px;height: 35px;padding-left: 10px;color: #7fc241">운영 apk 파일 생성 </td>
																								</tr>
																							</table>
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							안드로이드 7.0 버전부터 v2 버전을 선택 할 수 있습니다.  
																						</p>
																						<p class="itemRow">
																							<span style="color: red;">*</span>현재 개발된 소스는 안드로이드 롤리팝(5.0) 버전 이므로 v2 버전 선택 시, apk 파일이 생성되지 않습니다.
																						</p>
																						<p class="itemRow">
																							<img src="/common/theme/gsfresh/images/appGuide/guide2_6.png"/>
																						</p>
																						<p class="itemRow">
																							<span class="dot">■</span>
																							Build Variants (개발서버 -> devRelease / <span style="color:#7fc241 ">운영서버 -> prodRelease</span>)선택 후 [Finish]를 클릭합니다.
																						</p>
																					</div>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
															
															<div class="page" id="page4">
																<div class="pageScroll">
																	<div class="listItem">
																		<div class="item1">
																			<h2>3. 앱 버전 등록 </h2>
																			<div class="item2">
																				<p class="itemRow">
																					<span class="dot">■</span>
																					[앱 버전 추가] 또는 [추가]를 클릭 합니다.
																				</p>
																				<p class="itemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide3_1.png"/>
																				</p>
																				<p class="itemRow">
																					<span class="dot">■</span>
																					[+] 또는 이미지 등록 아이콘 클릭 또는 이미지 파일을 끌어다 놓기 하여 이미지를 등록합니다.
																				</p>
																				<p class="itemRow">
																					(<span style="color:red ">*</span>
																					[{Android Studio 설치경로}\pda\app\src\{prod 또는 dev}\res\mipmap-xxxhdpi\이미지 파일] 경로의 App Launch Icon 이미지 파일을 등록하시길 권장합니다.)
																				</p>
																				<p class="itemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide3_2.png"/>
																				</p>
																				<p class="itemRow">
																					<span class="dot">■</span>
																					앱 명칭을 입력 합니다.
																				</p>
																				<p class="itemRow">
																					<span class="dot">■</span>
																					버전을 입력 합니다.
																				</p>
																				<p class="itemRow">
																					(<span style="color:red ">*</span>
																					앱 등록을 할 버전은 Android Studio에 [ Gradle Script ] > [ build.gradle(Module : app) ] 파일의  productFlavors -> dev / prod -> versionName 과 반드시 동일 해야합니다.)
																				</p>
																				<p class="itemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide3_3.png"/>
																				</p>
																				<p class="itemRow">
																					<span class="dot">■</span>
																					apk 파일 등록 영역을 클릭 또는 끌어다놓기 하여 apk 파일을 등록 합니다.
																				</p>
																				<p class="itemRow">
																					(<span style="color:red ">*</span>
																					.apk 파일만 등록 가능합니다.)
																				</p>
																				<p class="itemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide3_4.png"/>
																				</p>
																				<p class="itemRow">
																					<span class="dot">■</span>
																					생성된 apk 파일 경로 : key srore 생성 시, 지정했던 directory의 경로 입니다.
																				</p>
																				<p class="itemRow">
																					<table style="font-weight: bold;border: 2px solid #caccd1;">
																						<tr>
																							<td style="width: 150px;height: 35px;padding-left: 10px;">개발</td>
																							<td style="width: 300px;height: 35px;padding-left: 10px;">{key store 경로}/dev/release/apk 파일</td>
																						</tr>
																						<tr>
																							<td style="width: 150px;height: 35px;padding-left: 10px;color: #7fc241">운영</td>
																							<td style="width: 300px;height: 35px;padding-left: 10px;color: #7fc241">{key store 경로}/prod/release/apk 파일</td>
																						</tr>
																					</table>
																				</p>
																				<p class="itemRow">
																					(<span style="color:red ">*</span>
																					.apk 파일명은 wms-pda-v{버전}-{개발/운영}-{debug/release}.apk 규칙으로 생성 됩니다.)
																				</p>
																				<p class="itemRow">
																					<span class="dot">■</span>
																					[V] 클릭하여 등록을 완료 합니다.
																				</p>
																				<p class="itemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide3_5.png"/>
																				</p>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
															
															<div class="page" id="page5">
																<div class="pageScroll">
																	<div class="listItem">
																		<div class="item1">
																			<h2>4. 주의사항 </h2>
																			<div class="item2">
																				<p class="itemRow">
																					<span class="dot">■</span>
																					버전 등록 규칙을 준수해 주세요.
																				</p>
																				<p class="itemRow">
																					<span class="dot">■</span>
																					앱 Launch Icon 이미지는 {Android Studio 설치경로}\pda\app\src\{prod 또는 dev}\res\mipmap-xxxhdpi\이미지 파일] 경로의 App Launch Icon 이미지 파일을 등록하시길 권장합니다.
																				</p>
																				<p class="itemRow">
																					<span class="dot">■</span>
																					앱 등록을 할 버전은 Android Studio에 [ Gradle Script ] > [ build.gradle(Module : app) ] 파일의  productFlavors -> dev / prod -> versionName 과 반드시 동일 해야합니다.)
																				</p>
																				<p class="itemRow">
																					<span class="dot">■</span>
																					파일은 .apk 파일만 등록 가능합니다. 
																				</p>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
															
														</div>
													</div>
												</div>
											</div>
										</div>
										
										<div class="subContent" id="appSource">
											<input type="file" name="regSourceFile" onchange="changeRegFile(this);"/>
											<div class="sourceReg">
												<div class="fileTitleArea">
													<div class="fileRegInit" id="fileRegInit">
														<form autocomplete="off">
															<div class="fileRegWrap">
																<div class="noFileImg">
																	<img src="/common/theme/gsfresh/images/icon/ico_drag_off.png">
																</div>
																<div class="noFileText">
																	<p>파일을 끌어다가 놓거나 <span>클릭</span>  하여</p><p>파일을 선택 해주세요.</p>
																</div>
															</div>
														</form>
													</div>
													<div class="fileRegContent" id="fileRegContent">
														<div class="fileRegHead">
															<button class="fileSave" onclick="regFileSave();"></button>
															<button class="fileDelete" onclick="regFileDelete();"></button>
														</div>
														<div class="fileReg">
															<div class="regFileIcon"></div>
															<div class="regFileInf">
																<div class="regFileName">
																	<p id="regFileName"></p>
																</div>
																<div class="regFileSize">
																	<p id="regFileSize"></p>
																</div>
															</div>
														</div>
													</div>
												</div>
												<div class="fileListArea">
													<div class="fileListTitle">
														<div class="regRefreshArea" onclick="regRefreshAll();">
															<img src="/common/theme/gsfresh/images/icon/ico_refresh_all.png" alt="새로고침"/>
														</div>
														<p class="titleImgWrap">
															<img src="/common/images/ico-right-arrow.png"/>
														</p>
														<p class="titleTxtWrap">앱 소스 파일 리스트</p>
													</div>
													<div class="fileList"></div>
													<div class="noRegFile">
														<div class="noRegFileWrap">
															<P class="regIcoInf"></p>
															<P class="regIcoTxt">등록된 파일이 없습니다.</p>
														</div>
													</div>
												</div>
											</div>
											<div class="sourceRegGuide">
												<div class="sourceGuideTitleWrap">
													<div class="sourceGuideTitle">
														<p class="sourceGuideTitleText">앱 소스 관리 가이드</p>
													</div>
												</div>
												<div class="sourceGuideContentWrap">
													<div class="sourceGuideContentScroll">
														<div class="sourceGuideContent">
															<div class="sourcePage">
																<div class="sourcePageScroll">
																	<div class="sourceListItem">
																		<div class="sourceItem1">
																			<h2>1. Andorid Studio 설치</h2>
																			<div class="sourceItem2">
																				<p class="sourceItemRow">
																					<span class="dot">■</span>
																					안드로이드 개발자 페이지(<span style="color: #7fc241;border-bottom: 2px dotted;cursor: pointer;" onclick="goAndriodPage();">https://developer.android.com/studio/</span>)로 접속 .
																				</p>
																				<p class="sourceItemRow">
																					안드로이드 developers > Android 스튜디오 > [ DOWNLOAD ANDRIOD STUDIO ]
																				</p>
																				<p class="sourceItemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide_s_1.png"/>
																				</p>
																				<p class="sourceItemRow">
																					<span class="dot">■</span>
																					Andriod Studio 설치를 진행하여 완료 합니다.
																				</p>
																			</div>
																			<h2>2. 외부로 소스 Export</h2>
																			<div class="sourceItem2">
																				<p class="sourceItemRow">
																					<span class="dot">■</span>
																					Android Studio 에서  [file] > [Export to Zip File...]로 접근
																				</p>
																				<p class="sourceItemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide_s_2.png"/>
																				</p>
																				<p class="sourceItemRow">
																					<span class="dot">■</span>
																					저장할 파일 경로 선택.
																				</p>
																				<p class="sourceItemRow">
																					<span class="dot">■</span>
																					File name 변경 후, [OK] 클릭 한다.
																				</p>
																				<p class="sourceItemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide_s_3.png"/>
																				</p>
																				<p class="sourceItemRow">
																					<span class="dot">■</span>
																					WMS의 [AD01] PDA 앱  관리 > 앱 소스 관리 에서 Export한 소스(.zip파일)을 등록한다.
																				</p>
																				<p class="sourceItemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide_s_8.png"/>
																				</p>
																			</div>
																			<h2>2. Andorid Studio로 소스 Import</h2>
																			<div class="sourceItem2">
																				<p class="sourceItemRow">
																					<span class="dot">■</span>
																					Android 소스를 내려 받는다.
																				</p>
																				<p class="sourceItemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide_s_6.png"/>
																				</p>
																				<p class="sourceItemRow">
																					<span class="dot">■</span>
																					내려받은 Android 소스 파일 경로에서 파일 압축 해제.
																				</p>
																				<p class="sourceItemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide_s_4.png"/>
																				</p>
																				<p class="sourceItemRow">
																					<span class="dot">■</span>
																					Android Studio 에서  [file] > [new] >[Import Project...]로 접근
																				</p>
																				<p class="sourceItemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide_s_5.png"/>
																				</p>
																				<p class="sourceItemRow">
																					<span class="dot">■</span>
																					압축 해제한 Android 소스 경로를 선택한다.
																				</p>
																				<p class="sourceItemRow">
																					<img src="/common/theme/gsfresh/images/appGuide/guide_s_7.png"/>
																				</p>
																				<p class="sourceItemRow">
																					<span class="dot">■</span>
																					[OK] 버튼을 눌러 Import 작업을 완료한다.
																				</p>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
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
<div class="progressLoding" id="progressLoding">
	<div class="boxWrap">
		<div class="box">
			<div class="gif">
				<img src="/mobile/img/page_loding_box.gif">
			</div>
			<div class="text">
				<p class="text1">처리 중 입니다.</p>
				<p class="text2">잠시만 기다려주세요.</p>
			</div>
		</div>
	</div>
</div>
</body>
</html>