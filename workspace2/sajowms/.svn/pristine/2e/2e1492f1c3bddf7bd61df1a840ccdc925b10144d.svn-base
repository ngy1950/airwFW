package project.common.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import project.common.bean.CommonConfig;
import project.common.bean.CommonUser;
import project.common.bean.DataMap;
import project.common.bean.User;
import project.common.service.CommonService;
import project.common.util.Keygen;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;


@Controller
public class LoginController extends BaseController {

	static final Logger log = LogManager.getLogger(LoginController.class.getName());

	@Autowired
	private CommonService commonService;

	@Autowired
	private CommonUser commonUser;

	@RequestMapping("/common/json/login.*")
	public String login(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		map.setModuleCommand("Common", "USERCHECK");

		User user = (User) commonService.getObj(map);

		if (user != null) {

			/*
			if ("V".equals(user.getUserg2())) {
				model.put("data", "F_LOGIN_LOCK");
				return JSON_VIEW;
			}
			
			
			if (!user.getPasswd().equals(user.getCpasswd())) {

				if (user.getUserg1() == null || Integer.parseInt(user.getUserg1()) < 4) {
					map.setModuleCommand("Common", "LOGIN_FAIL");
					commonService.update(map);
				}
				if (Integer.parseInt(user.getUserg1()) >= 4) {
					map.setModuleCommand("Common", "LOGIN_LOCK");
					commonService.update(map);
				}

				model.put("data", "F");

				return JSON_VIEW;
			}
			*/
			
			//map.setModuleCommand("Common", "LOGIN");
			//commonService.update(map);
			
//			if (user.getPwcdat() == null) {
//				model.put("data", "F_LOGIN_INIT");
//				return JSON_VIEW;
//			}
			
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

			session.setAttribute(CommonConfig.SES_USER_OBJECT_KEY, user);
			session.setAttribute(CommonConfig.SES_USER_ID_KEY, user.getUserid());
			session.setAttribute(CommonConfig.SES_USER_NAME_KEY, user.getUsername());
			session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY, user.getLlogwh());
			session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY, user.getLlogwhnm());
			session.setAttribute(CommonConfig.SES_USER_COMPANY_KEY, user.getCompid());
			session.setAttribute(CommonConfig.SES_USER_LANGUAGE_KEY, map.getString("LANGKY"));
			session.setAttribute(CommonConfig.SES_USER_THEME_KEY, CommonConfig.SYSTEM_THEME_PATH);

			// menu list
			map.put("LANGKY", map.getString("LANGKY"));
			map.put("USERID", user.getUserid());
			map.put("MENUGID", user.getMenugid());
			map.put("COMPID", user.getCompid());

			list = commonService.getList("Common.MENUTREE", map);

			session.setAttribute(CommonConfig.SES_USER_MENU_KEY, list);

			DataMap urlMap = new DataMap();
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
			}
			urlMap.put("/common/main.page", true);
			urlMap.put("/common/left.page", true);
			urlMap.put("/common/top.page", true);
			urlMap.put("/common/wintab.page", true);
			urlMap.put("/common/info.page", true);
			session.setAttribute(CommonConfig.SES_USER_URL_KEY, urlMap);

			model.put("data", "S");

			log.debug(user);
		} else {
			model.put("data", "N");
		}

		return JSON_VIEW;
	}

	@RequestMapping("/common/param/loginPost.*")
	public String loginPost(HttpSession session, HttpServletRequest request, Map model,
			@RequestParam(value = "USERID") String id, @RequestParam(value = "PASSWD") String pwd) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.put("USERID", id);
		map.put("PASSWD", pwd);

		map.setModuleCommand("Common", "LOGIN");

		User user = (User) commonService.getObj(map);

		if (user != null) {
			commonService.update(map);

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

			map.setModuleCommand("Common", "USRPH");
			list = commonService.getList(map);
			DataMap usrph = new DataMap();
			DataMap usrphc = new DataMap();
			DataMap usrpi = new DataMap();
			String defchk;
			for (int i = 0; i < list.size(); i++) {
				row = list.get(i);
				progid = row.getString("PROGID");
				if (usrph.containsKey(progid)) {
					data = usrph.getList(progid);
					data.add(row);
				} else {
					List newData = new ArrayList();
					newData.add(row);
					usrph.put(progid, newData);
				}
				defchk = row.getString("DEFCHK");
				if (defchk.equals("V") && !usrphc.containsKey(progid)) {
					usrphc.put(progid, row.getString("PARMKY"));
					row.setModuleCommand("Common", "USRPI");
					List itemList = commonService.getList(row);
					usrpi.put(progid, itemList);
				}
			}

			user.setUsrph(usrph);
			user.setUsrpi(usrpi);

			map.setModuleCommand("Wms", "USERINFO");

			DataMap userInfo = (DataMap) commonService.getMap(map);
			session.setAttribute(CommonConfig.SES_USER_INFO_KEY, userInfo);

			user.addUserData("userIndo", userInfo);

			if (!commonUser.addUserIdMap(session, map.getString("USERID"),
					map.getString(CommonConfig.SES_USER_TYPE_KEY))) {
				commonUser.killSession(session, map.getString("USERID"), "");
				commonUser.addUserIdMap(session, map.getString("USERID"),
						map.getString(CommonConfig.SES_USER_TYPE_KEY));
			}

			commonUser.addSessionMap(session.getId(), user);

			session.setAttribute(CommonConfig.SES_USER_OBJECT_KEY, user);
			session.setAttribute(CommonConfig.SES_USER_ID_KEY, user.getUserid());
			session.setAttribute(CommonConfig.SES_USER_NAME_KEY, user.getUsername());
			session.setAttribute(CommonConfig.SES_USER_COMPANY_KEY, user.getCompid());
			session.setAttribute(CommonConfig.SES_DEPT_ID_KEY, user.getDeptid());
			session.setAttribute(CommonConfig.SES_USER_LANGUAGE_KEY, map.getString("LANGKY"));
			session.setAttribute(CommonConfig.SES_USER_THEME_KEY, CommonConfig.SYSTEM_THEME_PATH);

			model.put("data", "S");

			map.setModuleCommand("Common", "ROLCT");

			List<DataMap> rolctList = commonService.getList(map);
			if (rolctList.size() < 1) {
				model.put("data", "R");
			}

			log.debug(user);
		} else {
			// model.put("data", "F");
			return "/common/index";
		}

		return "/common/main";
	}

	@RequestMapping("/common/password.page")
	public String passwordPage(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		session.setAttribute(CommonConfig.SES_USER_LANGUAGE_KEY, map.getString("LANGKY"));
		session.setAttribute(CommonConfig.SES_USER_THEME_KEY, CommonConfig.SYSTEM_THEME);

		return "/wms/password";
	}

	@RequestMapping("/common/json/password.*")
	public String password(HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand("Common", "PASSWORD");

		DataMap rs = commonService.getMap(map);

		if (rs != null) {
			commonService.update(map);

			model.put("data", "S");
		} else {
			model.put("data", "F");
		}

		return JSON_VIEW;
	}

	@RequestMapping("/common/json/logout.*")
	public String logout(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		if(session.getAttribute(CommonConfig.SES_USER_ID_KEY) != null){
			String userid = session.getAttribute(CommonConfig.SES_USER_ID_KEY).toString();
			
			session.removeAttribute(CommonConfig.SES_USER_OBJECT_KEY);
			session.removeAttribute(CommonConfig.SES_USER_ID_KEY);
			session.removeAttribute(CommonConfig.SES_USER_NAME_KEY);
			session.removeAttribute(CommonConfig.SES_USER_COMPANY_KEY);
			session.removeAttribute(CommonConfig.SES_DEPT_ID_KEY);
			session.removeAttribute(CommonConfig.SES_USER_INFO_KEY);
			session.removeAttribute(CommonConfig.SES_USER_MENU_KEY);
			
			map.setModuleCommand("Common", "LOGOUT");
			commonService.update(map);
		}
		return "/index";
	}
	
	@RequestMapping("/common/left.*")
	public String leftMenu(HttpSession session, HttpServletRequest request, Map model) throws SQLException {

		List<DataMap> list = (List) session.getAttribute(CommonConfig.SES_USER_MENU_KEY);

		model.put("list", list);

		return "/common/left";
	}
	
	@RequestMapping("/common/json/addFmenu.*")
	public String addFmenu(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		commonService.insert("Common.MSTMENUFL", map);

		model.put("data", true);

		return JSON_VIEW;
	}
	
	@RequestMapping("/common/json/deleteFmenu.*")
	public String deleteFmenu(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		commonService.delete("Common.MSTMENUFL", map);

		model.put("data", true);

		return JSON_VIEW;
	}
	
	@RequestMapping("/common/json/idPsFind.*")
	@Transactional(rollbackFor = Exception.class)
	public String idPsFind(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		String find = map.getString("FIND");
		String send = map.getString("FIND_SEND");
		String passWord = null;
		DataMap row = new DataMap();
		DataMap psData = new DataMap();
		DataMap pMsgMap = new DataMap();
		DataMap logMap = new DataMap();
		
		map.setModuleCommand("Common", "USERINFO");
		
		List<DataMap> infoList =  commonService.getList(map);
		
		if(infoList.size() == 0){
			model.put("data", find+"_NOTHING");
		}else{
			
			for (int i = 0; i < infoList.size(); i++) {
				row = infoList.get(i).getMap("map");
//				String dd = Keygen.makeRandomPassword(5);
				//String gg = infoList.get(i). //.toString("USERID");
				
				if(send.equals("EMAIL")){
					DataMap emailMap = row;
					
					final MimeMessagePreparator preparator = new MimeMessagePreparator() {
						@Override
						public void prepare(MimeMessage mimeMessage) throws Exception {
							final MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
							// TODO Auto-generated method stub
							String cnts = "<p style='font-family:'맑은 고딕'> [G-HUB 시스템]<br><br>";
							
							helper.setFrom("gclcbl@greencross.com");
							helper.setTo(emailMap.getString("USERG3"));
							
							if(find.equals("ID")){
								helper.setSubject("[G-HUB 시스템] 요청하신 아이디 안내입니다."); 
								cnts += "요청하신 아이디 안내입니다.<br><br>";
								cnts += "▶ 아이디 : "+ emailMap.getString("USERID") + "<br><br>";
								cnts += "비밀번호가 기억나지 않는 경우 비밀번호 찾기에서 임시비밀번호를 발급받아 로그인 하실 수 있습니다.<br><br>";
								cnts += "감사합니다.";
							}else if(find.equals("PS")){
								helper.setSubject("[G-HUB 시스템] 요청하신 비밀번호 안내입니다."); 
								String mailPassWord = Keygen.makeRandomPassword(5);
								emailMap.setModuleCommand("Common", "USER_PS");
								emailMap.put("PASSWORD", mailPassWord);
								commonService.update(emailMap);
								
								cnts += "요청하신 아이디/비밀번호 안내입니다. <br><br>";
								cnts += "▶  임시비밀번호 : "+ mailPassWord + "<br><br>";
								cnts += "임시비밀번호로 로그인 하신 후 새로운 비밀번호로 변경하여 사용하시기 바랍니다. <br><br>";
								cnts += "감사합니다.";
							}
							cnts += "</p>";
							helper.setText("content\ndata", cnts); 

							logMap.put("COMPID", emailMap.getString("COMPID"));
							logMap.put("SENDG_EMAIL", "gclcbl@greencross.com");
							logMap.put("RCV_EMAIL", emailMap.getString("USERG3"));
							logMap.put("TITLE", "[G-HUB 시스템]");
							logMap.put("CNTS", cnts);
							logMap.put("REG_ID", "SYSTEM");
						}
					};

					model.put("data", "S") ;
					
				}else if(send.equals("PNUM")){
					String cnts = "[G-HUB 시스템]\n요청하신 ";
					
					if(find.equals("ID")){
						pMsgMap.put("SUBJECT", "아이디찾기");
						cnts += "아이디 안내입니다.\n\n";
						cnts += "▶ 아이디 : "+ row.getString("USERID");
					}else if(find.equals("PS")){
						pMsgMap.put("SUBJECT", "비밀번호찾기");
						passWord = Keygen.makeRandomPassword(5);
						
						row.setModuleCommand("Common", "USER_PS");
						row.put("PASSWORD", passWord);
						commonService.update(row);
						
						cnts += "비밀번호 안내입니다.\n\n";
						cnts += "▶  임시비밀번호 : "+ passWord;
					}
					
					pMsgMap.put("TEXT", cnts);
					pMsgMap.put("DSTADDR", row.getString("TELNUM"));
					pMsgMap.setModuleCommand("Common", "ID_MSG_SEND");
					commonService.insert(pMsgMap);
					
					model.put("data", "S");
					
				}else if(send.equals("PS_SEARCH")){
					psData = infoList.get(i);
					model.put("data", "PS_SEARCH");
					model.put("dataMap", psData);
					
					break;
				}
			}
		}
		
		

		return JSON_VIEW;
	}
}