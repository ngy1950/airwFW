package project.wdscm.controller;

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
import project.common.service.CommonService;
import project.wdscm.service.PdaService;

@Controller
public class PdaController extends BaseController {
	
	static final Logger log = LogManager.getLogger(PdaController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private PdaService pdaService;
	
	private static final String sys_env = "DEV";
	
	@RequestMapping("/pda/{page}.*")
	public String page(@PathVariable String page, HttpServletRequest request, Map model){
		String env = sys_env;
		
		String isBack = "N";
		if(request.getParameter("isBack") != null){
			isBack = request.getParameter("isBack");
		}
		if(("index".equals(page) || "main".equals(page)) && "Y".equals(isBack)){
			isBack = "Y";
		}
		
		String fullScreen = "N";
		if(request.getSession().getAttribute("fullScreen") != null){
			fullScreen = request.getSession().getAttribute("fullScreen").toString();
		}else{
			if("main".equals(page)){
				fullScreen = request.getParameter("fullScreen");
				request.getSession().setAttribute("fullScreen", fullScreen);
			}
		}
		
		String isFull = "";
		if("PROD".equals(env)){
			isFull = "Y";
		}else{
			isFull = "N";
		}
		
		model.put("isFull", isFull);
		model.put("ENV", env);
		model.put("isBack", isBack);
		
		return "/pda/"+page;
	}
	
	@RequestMapping("/pda/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/pda/"+module+"/"+page;
	}
	
	@RequestMapping("/pda/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/pda/"+module+"/"+sub+"/"+page;
	}
	
	@RequestMapping("/pda/index.*")
	public String index(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		String isBack = "N";
		if(request.getParameter("isBack") != null){
			isBack = request.getParameter("isBack");
		}
		
		String isAppDown = "N";
		model.put("ENV", sys_env);
		model.put("isBack", isBack);
		model.put("isAppDown", isAppDown);
		
		return "/pda/index";
	}
	
	@RequestMapping("/pda/json/login.*")
	public String login(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		map.setModuleCommand("Common", "USERCHECK");

		User user = (User) commonService.getObj(map);

		if (user != null) {
			map.setModuleCommand("Common", "USRLO");
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
			
			session.setAttribute(CommonConfig.SES_ENV_KEY, sys_env);
			session.setAttribute(CommonConfig.SES_USER_OBJECT_KEY, user);
			session.setAttribute(CommonConfig.SES_USER_ID_KEY, user.getUserid());
			session.setAttribute(CommonConfig.SES_USER_NAME_KEY, user.getUsername());
			session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY, user.getLlogwh());
			session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY, user.getLlogwhnm());
			session.setAttribute(CommonConfig.SES_USER_COMPANY_KEY, user.getCompid());
			session.setAttribute(CommonConfig.SES_USER_LANGUAGE_KEY, map.getString("LANGKY"));
			
			String fullScreen = map.getString("fullScreen");
			request.getSession().setAttribute("fullScreen", fullScreen);
			
			model.put("data", "S");

			log.debug(user);
		} else {
			model.put("data", "F");
		}

		return JSON_VIEW;
	}
	
	@RequestMapping("/pda/json/logout.*")
	public String logout(HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		request.getSession().removeAttribute(CommonConfig.SES_USER_OBJECT_KEY);
		request.getSession().removeAttribute(CommonConfig.SES_USER_ID_KEY);
		request.getSession().removeAttribute(CommonConfig.SES_USER_NAME_KEY);
		request.getSession().removeAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY);
		request.getSession().removeAttribute(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY);
		request.getSession().removeAttribute(CommonConfig.SES_USER_COMPANY_KEY);
		request.getSession().removeAttribute(CommonConfig.SES_USER_LANGUAGE_KEY);
		
		if(request.getSession() != null){
			request.getSession().invalidate();
		}
		
		return "/pda/sessionEmpty";
	}
	
	@RequestMapping("/pda/main.*")
	public String main(HttpServletRequest request, Map model) throws SQLException{
		String langky = request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY).toString();
		
		String env = sys_env;
		String isBack = "N";
		if(request.getParameter("isBack") != null) {
			isBack = request.getParameter("isBack");
		}
		if("Y".equals(isBack)) {
			isBack = "Y";
		}
		
		String fullScreen = "N";
		if(request.getSession() != null) {
			if(request.getSession().getAttribute("fullScreen") != null){
				fullScreen = request.getSession().getAttribute("fullScreen").toString();
			}else {
				fullScreen = request.getParameter("fullScreen");
				request.getSession().setAttribute("fullScreen", fullScreen);
			}
		}
		
		String isFull = "";
		if("PROD".equals(env) && "Y".equals(fullScreen)) {
			isFull = "Y";
		}else {
			isFull = "N";
		}
		
		model.put("isFull", isFull);
		model.put("ENV", env);
		model.put("isBack", isBack);
		
		model.put(CommonConfig.SES_USER_LANGUAGE_KEY, langky);
		model.put("data", "S");
		
		return "/pda/main";
	}
	
	@RequestMapping("/pda/json/top.*")
	public String top(HttpServletRequest request, Map model) throws SQLException{
		String langky = request.getSession().getAttribute(CommonConfig.SES_USER_LANGUAGE_KEY).toString();
		String compky = request.getSession().getAttribute(CommonConfig.SES_USER_COMPANY_KEY).toString();
		String wareky = request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY).toString();
		String warenm = request.getSession().getAttribute(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY).toString();
		String userid = request.getSession().getAttribute(CommonConfig.SES_USER_ID_KEY).toString();
		String usernm = request.getSession().getAttribute(CommonConfig.SES_USER_NAME_KEY).toString();
		
		DataMap map = new DataMap();
		map.put("COMPID", compky);
		map.setModuleCommand("Pda", "MENUTREE");
		
		List list = commonService.getList(map);
		
		model.put("ENV", sys_env);
		model.put("list", list);
		model.put(CommonConfig.SES_USER_LANGUAGE_KEY, langky);
		model.put(CommonConfig.SES_USER_COMPANY_KEY, compky);
		model.put(CommonConfig.SES_USER_WHAREHOUSE_KEY, wareky);
		model.put(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY, warenm);
		model.put(CommonConfig.SES_USER_ID_KEY, userid);
		model.put(CommonConfig.SES_USER_NAME_KEY, usernm);
		
		return "/pda/top";
	}
	
	@RequestMapping("/pda/info.*")
	public String info(HttpServletRequest request, Map model) throws SQLException{
		String env = sys_env;
		
		String isBack = "N";
		if(request.getParameter("isBack") != null){
			isBack = request.getParameter("isBack");
		}
		
		String fullScreen = "N";
		if(request.getSession() != null) {
			if(request.getSession().getAttribute("fullScreen") != null){
				fullScreen = request.getSession().getAttribute("fullScreen").toString();
			}else {
				fullScreen = request.getParameter("fullScreen");
				request.getSession().setAttribute("fullScreen", fullScreen);
			}
		}
		
		String isFull = "";
		String scheme = request.getScheme();
		if("PROD".equals(env) && "Y".equals(fullScreen) && "https".equals(scheme)){
			isFull = "Y";
		}else {
			isFull = "N";
		}
		
		model.put("isFull", isFull);
		model.put("ENV", env);
		model.put("isBack", isBack);
		
		return "/pda/info";
	}
}