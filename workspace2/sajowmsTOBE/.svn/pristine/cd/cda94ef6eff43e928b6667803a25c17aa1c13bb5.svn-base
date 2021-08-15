package project.gcim.controller;

//import java.sql.Date;
import java.sql.SQLException;
//import java.text.SimpleDateFormat;
import java.util.ArrayList;
//import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import project.common.bean.CommonConfig;
import project.common.bean.CommonUser;
import project.common.bean.DataMap;
import project.common.bean.User;
import project.common.controller.BaseController;
import project.common.service.CommonService;

@Controller
public class GcimLoginController extends BaseController {

	static final Logger log = LogManager.getLogger(GcimLoginController.class.getName());

	@Autowired
	private CommonService commonService;

	@RequestMapping("/gcim/json/login.*")
	public String login(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		map.setModuleCommand("GCIM", "LOGIN");
		map.put("PASSWD", map.getString("ZINDEX"));
		map.put("USERID", map.getString("USERID").replaceAll(" ", ""));
		User user = (User) commonService.getObj(map);
		map.remove("PASSWD");
		
		DataMap logparam = new DataMap(); 
		logparam.put("IP", map.getString("SES_USER_IP"));
		logparam.put("URITYPE", "LOGINFAIL");
		logparam.put("URL", "LOGINFAIL");
		logparam.put("URI", "/gcim/json/login.data");
		logparam.put("DATA","{USERID:"+map.getString("USERID")+","
							+"COLOR:"+map.getString("COLOR")+","
							+"SignIn:"+map.getString("SignIn")+","
							+"LANGKY:"+map.getString("LANGKY")+"}");
		logparam.put("SES_USER_ID", map.getString("USERID"));

		if (user != null) {
			
			if("N".equals(user.getPasswd()) && !("Y".equals(user.getLockcheck()))) {
				if(user.getFailcnt() < 4 ){
					map.setModuleCommand("Common", "LOGIN_FAIL");
					commonService.update(map);
					
					model.put("data", "F");
					model.put("cnt",(user.getFailcnt()+1));
				}else{
					map.setModuleCommand("Common", "LOGIN_LOCK");
					commonService.update(map);
					model.put("data", "F");
					model.put("cnt",(user.getFailcnt()+1));
				}

				commonService.insert("Common.SYSLOG", logparam);
				return JSON_VIEW;
			}
			
			if ("Y".equals(user.getLockcheck())) {
				model.put("data", "F_LOGIN_LOCK");
				commonService.insert("Common.SYSLOG", logparam);
				return JSON_VIEW;
			}

			if ("Y".equals(user.getUsecheck())) {
				model.put("data", "F_USE_LOCK");
				commonService.insert("Common.SYSLOG", logparam);
				return JSON_VIEW;
			}
			

			map.setModuleCommand("Common", "LOGIN");
			commonService.update(map);
			
			map.setModuleCommand("Common", "USRLO");
			map.put(CommonConfig.SES_USER_ID_KEY, user.getUserid());
			map.put(CommonConfig.SES_USER_COMPANY_KEY, user.getCompid());
			List<DataMap> list = commonService.getList(map);
			DataMap usrlo = new DataMap();
			DataMap row;
			List data;
			String progid;
			for (int i = 0; i < list.size(); i++) {
				row = list.get(i);
				progid = row.getString("PROGID");
				if (usrlo.containsKey(progid)) {
					data = usrlo.getList(progid);
					data.add(row);
				} else {
					List newData = new ArrayList();
					newData.add(row);
					usrlo.put(progid, newData);
				}
			}

			user.setUsrlo(usrlo);

			session.setAttribute(CommonConfig.SES_USER_OBJECT_KEY, user);
			session.setAttribute(CommonConfig.SES_USER_ID_KEY, user.getUserid());
			session.setAttribute(CommonConfig.SES_USER_NAME_KEY, user.getUsername());
			session.setAttribute(CommonConfig.SES_USER_COMPANY_KEY, user.getCompid());
			session.setAttribute(CommonConfig.SES_DEPT_ID_KEY, user.getDeptid());
			session.setAttribute(CommonConfig.SES_USER_EMPL_ID_KEY, user.getUsercode());
			session.setAttribute(CommonConfig.SES_USER_LANGUAGE_KEY, map.getString("LANGKY"));
			session.setAttribute(CommonConfig.SES_USER_THEME_KEY, CommonConfig.SYSTEM_THEME_PATH);

			if (user.getPwcdat() == null) {
				model.put("data", "F_LOGIN_INIT");
				return JSON_VIEW;
			}
			
			if(user.getPwcdatchk() >=  180){
				model.put("data", "F_PASSWORD_CHANGE");
				return JSON_VIEW;
			}
			
			// menu list
			map.put("LANGKY", map.getString("LANGKY"));
			map.put("USERID", user.getUserid());
			map.put("MENUGID", user.getMenugid());
			map.put("COMPID", user.getCompid());
			
			List<DataMap> rootList = commonService.getList("GCIM.MENUROOT", map);
			DataMap menuListMap  = new DataMap();
			DataMap menuKeyMap = new DataMap();
			DataMap menuDataMap = new DataMap();
			DataMap urlMap = new DataMap();
			if(rootList.size() > 0){
				session.setAttribute(CommonConfig.SES_USER_ROOT_MENU_KEY, rootList);
				
				for(int r=0;r<rootList.size();r++){
					row = rootList.get(r);
					map.put("PMENUID", row.getString("MENUID"));
					list = commonService.getList("GCIM.MENUTREE", map);
					if(r == 0){						
						session.setAttribute("PMENUID", map.getString("PMENUID"));
						session.setAttribute(CommonConfig.SES_USER_MENU_KEY, list);
					}
					
					menuListMap.put(map.getString("PMENUID"), list);
					
					String tmpUrl;
					for (int i = 0; i < list.size(); i++) {
						row = list.get(i);
						tmpUrl = row.getString("PGPATH");
						if (tmpUrl.trim().length() != 0) {
							if (tmpUrl.substring(0, 2).equals("./")) {
								tmpUrl = tmpUrl.substring(1);
							}
							if (tmpUrl.substring(tmpUrl.length() - 3).equals("jsp")) {
								tmpUrl = tmpUrl.substring(0, tmpUrl.length() - 3) + "page";
							}
							urlMap.put(tmpUrl, true);
						}
						menuKeyMap.put(row.getString("MENUID"), map.getString("PMENUID"));
						menuDataMap.put(row.getString("MENUID"), row);
					}
				}

				urlMap.put("/gcim/main.page", true);
				urlMap.put("/gcim/left.page", true);
				urlMap.put("/gcim/top.page", true);
				urlMap.put("/common/wintab.page", true);
				urlMap.put("/gcim/info.page", true);
				session.setAttribute(CommonConfig.SES_USER_URL_KEY, urlMap);
				session.setAttribute("MENUKEYMAP", menuKeyMap);
				session.setAttribute("MENULISTMAP", menuListMap);
				session.setAttribute("MENUDATAMAP", menuDataMap);

				list = commonService.getList("Common.FMENU", map);
				session.setAttribute(CommonConfig.SES_USER_FMENU_KEY, list);
			}else{
				model.put("data", "NM");
				return JSON_VIEW;
			}

			model.put("data", "S");

			log.debug(user);

			logparam.put("URITYPE", "LOGIN");
			logparam.put("URL", "LOGIN");
			commonService.insert("Common.SYSLOG", logparam);
		} else {
			model.put("data", "N");
			commonService.insert("Common.SYSLOG", logparam);
		}

		return JSON_VIEW;
	}
	
	@RequestMapping("/gcim/json/menuChange.*")
	public String menuChange(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);		
		
		DataMap menuListMap  = (DataMap)session.getAttribute("MENULISTMAP");
		
		List<DataMap> list = menuListMap.getList(map.getString("PMENUID"));
		
		session.setAttribute(CommonConfig.SES_USER_MENU_KEY, list);

		model.put("data", list.size());
		
		session.setAttribute("PMENUID", map.getString("PMENUID"));
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/gcim/json/menuChangeSearch.*")
	public String menuChangeSearch(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);		
		
		User user = (User)session.getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
				
		//2020.02.24 johaehee 수정
		map.put("LANGKY", map.get(CommonConfig.SES_USER_LANGUAGE_KEY));
		//map.put("LANGKY", CommonConfig.SES_USER_LANGUAGE_KEY);
		map.put("USERID", user.getUserid());
		map.put("MENUGID", user.getMenugid());
		map.put("COMPID", user.getCompid());
		
		List<DataMap> list = commonService.getList("GCIM.MENUTREE", map);
		
		session.setAttribute(CommonConfig.SES_USER_MENU_KEY, list);
		
		DataMap urlMap = (DataMap)session.getAttribute(CommonConfig.SES_USER_URL_KEY);
		String tmpUrl;
		DataMap row;
		for (int i = 0; i < list.size(); i++) {
			row = list.get(i);
			tmpUrl = row.getString("PGPATH");
			if (tmpUrl.trim().length() != 0) {
				if (tmpUrl.substring(0, 2).equals("./")) {
					tmpUrl = tmpUrl.substring(1);
				}
				if (tmpUrl.substring(tmpUrl.length() - 3).equals("jsp")) {
					tmpUrl = tmpUrl.substring(0, tmpUrl.length() - 3) + "page";
				}
				urlMap.put(tmpUrl, true);
			}
		}
		
		model.put("data", list.size());
		
		session.setAttribute("PMENUID", map.getString("PMENUID"));
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/gcim/json/menuCheck.*")
	public String menuCheck(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		String menuId = map.getString("MENUID");
		DataMap menuKeyMap  = (DataMap)session.getAttribute("MENUKEYMAP");
		
		String pmenuId = menuKeyMap.getString(menuId);
		if(!pmenuId.equals("")){
			DataMap menuListMap  = (DataMap)session.getAttribute("MENULISTMAP");
			
			List<DataMap> list = menuListMap.getList(pmenuId);
			
			session.setAttribute(CommonConfig.SES_USER_MENU_KEY, list);
			
			session.setAttribute("PMENUID", pmenuId);
		}
		
		model.put("PMENUID", pmenuId);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/gcim/json/menuData.*")
	public String menuData(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		String menuId = map.getString("MENUID");
		DataMap menuDataMap  = (DataMap)session.getAttribute("MENUDATAMAP");
		
		DataMap menuData = menuDataMap.getMap(menuId);

		model.put("data", menuData);
		
		return JSON_VIEW;
	}
}