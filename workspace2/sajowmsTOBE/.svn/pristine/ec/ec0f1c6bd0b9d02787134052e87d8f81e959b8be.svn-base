package project.mobile.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.bean.User;
import project.common.controller.BaseController;
import project.common.dao.CommonDAO;
import project.common.service.CommonService;

@Controller
public class MobileController extends BaseController {
	
	static final Logger log = LogManager.getLogger(MobileController.class.getName());
	
	@Autowired
	private CommonService commonService;

	@Autowired
	private CommonDAO commonDAO;
	
	@RequestMapping("/mobile/{page}.*")
	public String page(@PathVariable String page){
		return "/mobile/"+page;
	}
	
	@RequestMapping("/mobile/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/mobile/"+module+"/"+page;
	}
	
	@RequestMapping("/mobile/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/mobile/"+module+"/"+sub+"/"+page;
	}
	
	@RequestMapping("/mobile/index.*")
	public String list(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
//		List list = commonService.getList("System.SYSLABEL", map);
//		
//		model.put("data", list);
		
		return "/mobile/login";
	}
	
	@RequestMapping("/mobile/json/login.*")
	public String login(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		map.setModuleCommand("SajoCommon", "USERCHECK");

		User user = (User) commonService.getObj(map);
		
		

		if (user != null) {

			
			map.setModuleCommand("Common", "SYSGRIDCOL");
			map.put(CommonConfig.SES_USER_ID_KEY, user.getUserid());
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

			map.setModuleCommand("SajoCommon", "ROLOW");
			
			DataMap rolow = commonDAO.getMap(map);
			if(rolow != null){
				if("".equals(map.getString("OWNRKY"))){
					session.setAttribute(CommonConfig.SES_USER_OWNER_KEY, rolow.get("OWNRKY"));
				}else{
					session.setAttribute(CommonConfig.SES_USER_OWNER_KEY, map.getString("OWNRKY"));
				}
				
				if("".equals(map.getString("WAREKY"))){
					session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY, user.getLlogwh());
				}else{
					session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY, map.getString("WAREKY"));
				}
				
	
	
				session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY, user.getLlogwhnm());
				session.setAttribute(CommonConfig.SES_USER_OBJECT_KEY, user);
				session.setAttribute(CommonConfig.SES_USER_ID_KEY, user.getUserid());
				session.setAttribute(CommonConfig.SES_USER_NAME_KEY, user.getUsername());
				session.setAttribute(CommonConfig.SES_USER_COMPANY_KEY, user.getCompid());
				session.setAttribute(CommonConfig.SES_USER_LANGUAGE_KEY, map.getString("LANGKY"));
				session.setAttribute(CommonConfig.SES_USER_THEME_KEY, CommonConfig.SYSTEM_THEME_PATH);
				session.setAttribute(CommonConfig.SES_MENU_GROUP_KEY, user.getMmenugid());
				
				session.setAttribute(CommonConfig.SES_USER_OWNER_NM_KEY, user.getLlogownm());
				
				
				
				String schema = "public";
	//			if(!"WDSCM".equals(user.getCompid())){
	//				schema = user.getCompid().toLowerCase();
	//			}
				schema = "SAJO";
				session.setAttribute(CommonConfig.SES_SCHEMA, schema);
				
				// menu list
				map.put("LANGKY", map.getString("LANGKY"));
				map.put("USERID", user.getUserid());
				map.put("MENUGID", user.getMenugid());
				map.put("COMPID", user.getCompid());
	
				list = commonService.getList("Common.MENUTREE", map);
	
				session.setAttribute(CommonConfig.SES_USER_MENU_KEY, list);
	
				DataMap urlMap = new DataMap();
	
				urlMap.put("/demo/mobile/main.page", true);
				urlMap.put("/demo/mobile/left.page", true);
				urlMap.put("/demo/mobile/top.page", true);
				urlMap.put("/demo/mobile/wintab.page", true);
				urlMap.put("/demo/mobile/info.page", true);
				session.setAttribute(CommonConfig.SES_USER_URL_KEY, urlMap);
	
				model.put("data", "S");
	
				log.debug(user);
			} else {
				model.put("data", "NoCon");
			}
		} else {
			model.put("data", "N");
		}

		return JSON_VIEW;
	}

	@RequestMapping("/mobile/json/logout.*")
	public String mlogout(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		if(session.getAttribute(CommonConfig.SES_USER_ID_KEY) != null){
			
			session.removeAttribute(CommonConfig.SES_USER_OBJECT_KEY);
			session.removeAttribute(CommonConfig.SES_USER_ID_KEY);
			session.removeAttribute(CommonConfig.SES_USER_NAME_KEY);
			session.removeAttribute(CommonConfig.SES_USER_COMPANY_KEY);
			session.removeAttribute(CommonConfig.SES_USER_MENU_KEY);
		}
		return "/mobile/login";
	}

	@RequestMapping("/mobile/json/changeSession.*")
	public String changeSession(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY, map.getString("WAREKY"));
		session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY, commonService.getMap("SajoCommon.WAREKYNM", map).getString("NAME01"));

		model.put("data", "S");
		return JSON_VIEW;
	}
	
}