package project.common.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import project.common.bean.CommonConfig;
import project.common.bean.CommonUser;
import project.common.bean.DataMap;
import project.common.bean.SystemConfig;
import project.common.bean.UriInfo;
import project.common.bean.User;
import project.common.exception.MobileSessionEmptyException;
import project.common.exception.SessionEmptyException;
import project.common.service.CommonService;

public class SessionIntercepter extends HandlerInterceptorAdapter {
	static final Logger log = LogManager.getLogger(SessionIntercepter.class.getName());

	@Autowired
	private CommonService commonService;
	
	@Autowired
	private SystemConfig systemConfig;
	
	@Autowired
	private CommonUser commonUser;
 	
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		DataMap params = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		UriInfo uriInfo = (UriInfo)request.getAttribute(CommonConfig.REQUEST_URI_INFO_KEY);
		
		DataMap urlMap = (DataMap)request.getSession().getAttribute(CommonConfig.SES_USER_URL_KEY);
		
		String userType = "";
		
		Object SES_USER_ID = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY);
		String sesUserId = (SES_USER_ID == null?null:SES_USER_ID.toString());
		
		String memApplyCode = request.getSession().getAttribute(CommonConfig.MEMBERSHIP_APPLY_CODE) == null?
										null:request.getSession().getAttribute(CommonConfig.MEMBERSHIP_APPLY_CODE).toString();
		
		//2020.12.09 이범준
		String pdaModule = uriInfo.getUri()!=null&&!"".equals(uriInfo.getUri().trim())&&uriInfo.getUri().indexOf("/") > -1?uriInfo.getUri().split("/")[1]:"";
		boolean isPda = "mobile".equals(pdaModule)?true:false;
//		boolean isDemo = "demo".equals(pdaModule)?true:false;
		
		/*
		String sesUserId = null;
		if(commonUser != null){
			sesUserId = commonUser.getUserId(request.getSession());
		}
		*/
		
		String sesWareky = null;
		String sesWarenm = null;
		String sesOwner = null;
		String sesCompky = null;
		String sesLang = null;
		String sesUserExpId = null;
		DataMap userInfo = null;
		if(sesUserId == null || sesUserId.equals("")){
			//UriInfo uriInfo = new UriInfo(request.getRequestURL().toString(), request.getRequestURI());	
			if(uriInfo.getDataType().equals("xml")
					|| uriInfo.getUri().equals("/common/Common/list/json/COMCOMBO.data")
					|| uriInfo.getUri().equals("/common/SajoCommon/list/json/LOGIN_OWNRKY_COMCOMBO.data")
					|| uriInfo.getUri().equals("/common/SajoCommon/list/json/LOGIN_WAREKY_COMCOMBO.data")
					|| uriInfo.getUri().equals("/common/Wms/list/json/WAHMACOMBO.data")
					|| uriInfo.getUri().equals("/common/api/json/restfulResponse.data")
					|| uriInfo.getUri().equals("/common/image/fileUp/mobile.data")
					|| uriInfo.getUri().equals("/system/json/authMemberShip.data")
					|| uriInfo.getUri().equals("/system/json/selectOptionSetData.data")
					|| uriInfo.getUri().equals("/system/json/selectPriceData.data")
					|| uriInfo.getUri().equals("/common/json/idPsFind.data")
					|| uriInfo.getUri().indexOf("mb") != -1
					|| uriInfo.getUri().equals("/app/image/fileUp/json.data")
					|| uriInfo.getUri().indexOf("api") != -1 
					|| uriInfo.getUri().indexOf("/mobile/error") != -1
					|| uriInfo.getUri().indexOf("password") != -1 
					|| uriInfo.getUri().indexOf("pop") != -1 
					|| uriInfo.getUri().indexOf("login") != -1
					|| uriInfo.getUri().indexOf(".ndo") != -1		// sms발송 관련 to마감을 위해 web.xml내용 추가분
					|| uriInfo.getUri().indexOf("index") != -1){
				sesUserId = request.getRemoteAddr();
			}else{
				//sesUserId = request.getRemoteAddr();
				
				//2020.12.09 이범준
//				if(isPda || isDemo) {
				if(isPda) {
					if(uriInfo.getUri().equals("/mobile/json/appDownList.data")
							|| uriInfo.getUri().equals("/mobile/icon/view.data")
							|| uriInfo.getUri().equals("/mobile/apk/fileDown/file.data")) {
						sesUserId = request.getRemoteAddr();
					}else {
						throw new MobileSessionEmptyException();
					}
				}else{
					if(memApplyCode == null){
						throw new SessionEmptyException();
					}
				}
			}
		//}else if(urlMap != null && !urlMap.containsKey(uriInfo.getUri()) && uriInfo.getExt().equals("page") && !uriInfo.getWorkType().equals("demo") && !uriInfo.getWorkType().equals("theme") && !uriInfo.getDataType().equals("aprove") && !uriInfo.getCommand().equals("searchHelp") && !uriInfo.getUris()[1].equals("aprove")){
		//	throw new Exception("page open exception");
		}else{			
			sesCompky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_COMPANY_KEY);
			sesWareky = (String)request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY);
			sesWarenm = (String)request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY);
			sesLang = (String)request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY);			
			userInfo = (DataMap)request.getSession().getAttribute(CommonConfig.SES_USER_INFO_KEY);
			
			//UriInfo uriInfo = (UriInfo)request.getAttribute(CommonConfig.REQUEST_URI_INFO_KEY);
			if(uriInfo.getExt().equals("page")){
				User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
				if(user.getUsrlo().containsKey(uriInfo.getMenuId())){
					request.setAttribute(CommonConfig.SES_USER_LAYOUT_LIST_KEY, user.getUsrlo().getList(uriInfo.getMenuId()));
				}
				/*
				if(user.getUsrph().containsKey(uriInfo.getMenuId())){
					request.setAttribute(CommonConfig.SES_USER_SEARCHPARAM_LIST_KEY, user.getUsrph().getList(uriInfo.getMenuId()));
					request.setAttribute(CommonConfig.SES_USER_SEARCHPARAM_DEFAULT_KEY, user.getUsrpi().getList(uriInfo.getMenuId()));
				}
				*/
			}
		}
		
		log.info(CommonConfig.SES_USER_ID_KEY+" : "+sesUserId);
		
		params.put(CommonConfig.SES_USER_TYPE_KEY, userType);
		
		params.put(CommonConfig.SES_USER_ID_KEY, sesUserId);
		params.put(CommonConfig.SES_USER_COMPANY_KEY, sesCompky);
		params.put(CommonConfig.SES_USER_LANGUAGE_KEY, sesLang);
		
		params.put(CommonConfig.SES_USER_INFO_KEY, userInfo);
		params.put(CommonConfig.SES_USER_IP_KEY, request.getRemoteAddr());
		
		params.put(CommonConfig.SES_USER_WHAREHOUSE_KEY, sesWareky);
		params.put(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY, sesWarenm);
		
		if(sesUserExpId == null){
			sesUserExpId = "";
		}
		
		params.put(CommonConfig.SES_USER_EMPL_ID_KEY, sesUserExpId);
		
		request.setAttribute(CommonConfig.PARAM_ATT_KEY, params);
		
		return super.preHandle(request, response, handler);
	}
}