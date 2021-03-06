package project.common.handler;

import java.io.BufferedReader;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.catalina.manager.util.SessionUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.SessionFactoryUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.bean.UriInfo;
import project.common.service.CommonService;
import project.common.util.SqlUtil;

public class CommonIntercepter extends HandlerInterceptorAdapter{
	
	static final Logger log = LogManager.getLogger(CommonIntercepter.class.getName());
	
	private DataMap operMap;
	
	@Autowired
	private CommonService commonService;
	
	public CommonIntercepter(){
		super();
		this.operMap = new DataMap();
		this.operMap.put("", "=");
		this.operMap.put("E", "=");
		this.operMap.put("N", "!=");
		this.operMap.put("LT", "<");
		this.operMap.put("GT", ">");
		this.operMap.put("LE", "<=");
		this.operMap.put("GE", ">=");
	}
	 
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		// TODO Auto-generated method stub	
		DataMap params = null;		
		
		UriInfo uriInfo = new UriInfo(request.getRequestURL().toString(), request.getRequestURI());

		String json = null;
		
		if(uriInfo.getDataType().equals("json")){
			try {
				json = readJSONStringFromRequestBody(request);
				if(json != null && !json.equals("")){
					JSONObject jsonObject = new JSONObject(json);	    
					params = getMap(jsonObject);
				}
			}catch(Exception e) {
		        e.printStackTrace();
			}finally{
				if(params == null){
					params = new DataMap();
				}
			}
			
			SqlUtil sqlUtil = new SqlUtil();
			sqlUtil.setRangeSql(params);
		}else if(uriInfo.getDataType().equals("excel")){
			params = new DataMap(request);
			String key = params.getString(CommonConfig.DATA_EXCEL_REQUEST_KEY);
			params = (DataMap)request.getSession().getAttribute(key);
		}else{
			params = new DataMap(request);
			if(uriInfo.getExt().equals("page")){
				uriInfo.setParam(params);
			}
			if(!params.containsKey(CommonConfig.MENU_ID_KEY)){
				params.put(CommonConfig.MENU_ID_KEY, uriInfo.getCommand());
			}

			HttpSession session = request.getSession();
			writeLog(session, request, uriInfo, uriInfo.getCommand());
		}
	
		request.setAttribute(CommonConfig.PARAM_ATT_KEY, params);
		
		uriInfo.setParams(params.toString());
		
		request.setAttribute(CommonConfig.REQUEST_URI_INFO_KEY, uriInfo);
		
		
		return super.preHandle(request, response, handler);
	}
	
	public String readJSONStringFromRequestBody(HttpServletRequest request) {
		StringBuffer json = new StringBuffer();
		String line = null;
		try {
			BufferedReader reader = request.getReader();
			while ((line = reader.readLine()) != null) {
				json.append(line);
			}
		} catch (Exception e) {
			log.error("Error reading JSON string", e);
		}
		return json.toString();
	}
	
	public DataMap getMap(JSONObject json) {
		DataMap paramMap = new DataMap();
		Iterator it = json.keys();
		while (it.hasNext()) {
			String key = (String) it.next();
			if (json.isNull(key)) {
				continue;
			}
			try {
				Object obj = json.get(key);
				if(obj instanceof JSONObject){
					JSONObject jObject = (JSONObject)obj;
					paramMap.put(key, getMap(jObject));
				}else if(obj instanceof ArrayList){
					paramMap.put(key, obj);
				}else if(obj instanceof JSONArray){
					JSONArray array = (JSONArray)obj;
					List list = new ArrayList();
					Object tmpObj;
					for(int i=0;i<array.length();i++){
						tmpObj = array.get(i);
						if(tmpObj instanceof JSONObject){
							list.add(getMap(array.getJSONObject(i)));
						}else{
							list.add(tmpObj);
						}						
					}
					
					paramMap.put(key, list);
				}else{
					paramMap.put(key, obj);
				}
			} catch (Exception e) {
				log.error("Error mapping JSON map", e);
			}
		}
		return paramMap;
	}
	
	private void writeLog(HttpSession session, HttpServletRequest request, UriInfo uriInfo, String uriCode) throws UnsupportedEncodingException, SQLException{
		DataMap param = new DataMap();
		
		Object SES_USER_ID = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY);
		if(SES_USER_ID != null){
			//?????? ????????? ??????????????? ???????????? ?????? 
			if("main".equals(uriCode) || "top".equals(uriCode) || "wintab".equals(uriCode)|| "info".equals(uriCode)|| "left".equals(uriCode)) return;
			
			param.put("SES_USER_ID", SES_USER_ID);
			param.put("LOG_IP", session.getAttribute(CommonConfig.SESSION_KEY_USERIP));
			param.put("LOG_CMP", session.getAttribute(CommonConfig.SES_USER_OWNER_KEY));
			param.put("LOG_PGM", uriCode);
			
			commonService.insert("Common.SYSLOG", param);
		}

	}
	
	private String getClientIP(HttpServletRequest request) {
	    String ip = request.getHeader("X-Forwarded-For");
	    log.info("> X-FORWARDED-FOR : " + ip);

	    if (ip == null) {
	        ip = request.getHeader("Proxy-Client-IP");
	        log.info("> Proxy-Client-IP : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getHeader("WL-Proxy-Client-IP");
	        log.info(">  WL-Proxy-Client-IP : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_CLIENT_IP");
	        log.info("> HTTP_CLIENT_IP : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	        log.info("> HTTP_X_FORWARDED_FOR : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getRemoteAddr();
	        log.info("> getRemoteAddr : "+ip);
	    }
	    log.info("> Result : IP Address : "+ip);

	    return ip;
	}
	
	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub
		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub
		super.afterCompletion(request, response, handler, ex);
	}
}