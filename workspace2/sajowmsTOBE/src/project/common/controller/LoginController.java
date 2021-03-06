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
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import project.common.bean.CommonConfig;
import project.common.bean.CommonUser;
import project.common.bean.DataMap;
import project.common.bean.User;
import project.common.dao.CommonDAO;
import project.common.service.CommonService;
import project.common.util.Keygen;


@Controller
public class LoginController extends BaseController {

	static final Logger log = LogManager.getLogger(LoginController.class.getName());

	@Autowired
	private CommonService commonService;
	
	@Autowired
	private CommonDAO commonDAO;

	@Autowired
	private CommonUser commonUser;

	@RequestMapping("/common/json/login.*")
	public String login(HttpSession session, HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		map.setModuleCommand("SajoCommon", "USERCHECK");
		String desc01 = "ID , PASSWORD 입력 오류";

		//로그인이력 데티어 생성 start
		//ip 가져오기
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String serverip = req.getHeader("X-FORWARDED-FOR");
		if (serverip == null)
			serverip = req.getRemoteAddr();
		
		//os 가져오기
		String agent = request.getHeader("User-Agent");
		String os = " ";
		
		if(agent.indexOf("NT 6.3") != -1) os = "Windows 8.1";
		else if(agent.indexOf("NT 6.2") != -1) os = "Windows 8";
		else if(agent.indexOf("NT 6.1") != -1) os = "Windows 7";
		else if(agent.indexOf("NT 6.0") != -1) os = "Windows Vista/Server 2008";
		else if(agent.indexOf("NT 5.2") != -1) os = "Windows Server 2003";
		else if(agent.indexOf("NT 5.1") != -1) os = "Windows XP";
		else if(agent.indexOf("NT 5.0") != -1) os = "Windows 2000";
		else if(agent.indexOf("NT") != -1) os = "Windows NT";
		else if(agent.indexOf("9x 4.90") != -1) os = "Windows Me";
		else if(agent.indexOf("98") != -1) os = "Windows 98";
		else if(agent.indexOf("95") != -1) os = "Windows 95";
		else if(agent.indexOf("Win16") != -1) os = "Windows 3.x";
		else if(agent.indexOf("Windows") != -1) os = "Windows";
		else if(agent.indexOf("Linux") != -1) os = "Linux";
		else if(agent.indexOf("Macintosh") != -1) os = "Macintosh";
		
		String browser = "";

		if(agent.indexOf("Trident") > -1 || agent.indexOf("MSIE") > -1) { //IE

			if(agent.indexOf("Trident/7") > -1) {
				browser = "IE 11";
			}else if(agent.indexOf("Trident/6") > -1) {
				browser = "IE 10";
			}else if(agent.indexOf("Trident/5") > -1) {
				browser = "IE 9";
			}else if(agent.indexOf("Trident/4") > -1) {
				browser = "IE 8";
			}else if(agent.indexOf("edge") > -1) {
				browser = "IE edge";
			}

		}else if(agent.indexOf("Whale") > -1){ //네이버 WHALE
			browser = "WHALE " + agent.split("Whale/")[1].toString().split(" ")[0].toString();
		}else if(agent.indexOf("Opera") > -1 || agent.indexOf("OPR") > -1){ //오페라
			if(agent.indexOf("Opera") > -1) {
				browser = "OPERA " + agent.split("Opera/")[1].toString().split(" ")[0].toString();
			}else if(agent.indexOf("OPR") > -1) {
				browser = "OPERA " + agent.split("OPR/")[1].toString().split(" ")[0].toString();
			}
		}else if(agent.indexOf("Firefox") > -1){ //파이어폭스
			browser = "FIREFOX " + agent.split("Firefox/")[1].toString().split(" ")[0].toString();
		}else if(agent.indexOf("Safari") > -1 && agent.indexOf("Chrome") == -1 ){ //사파리
			browser = "SAFARI " + agent.split("Safari/")[1].toString().split(" ")[0].toString();
		}else if(agent.indexOf("Chrome") > -1){ //크롬
			browser = "CHROME " + agent.split("Chrome/")[1].toString().split(" ")[0].toString();
		}
		
		DataMap logHis = new DataMap();
		logHis.put("USERID", map.getString("USERID"));
		logHis.put("SERVERIP", serverip );
		logHis.put("USEROS", os);
		logHis.put("BROWSER", browser);
		//로그인이력 데티어 생성 END

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
			
			session.setAttribute(CommonConfig.SESSION_KEY_USER_BROWSER,browser);
			session.setAttribute(CommonConfig.SESSION_KEY_USER_OS, os);
			session.setAttribute(CommonConfig.SESSION_KEY_USERIP,serverip);

			user.setUsrlo(usrlo);

			session.setAttribute(CommonConfig.SES_USER_OBJECT_KEY, user);
			session.setAttribute(CommonConfig.SES_USER_ID_KEY, user.getUserid());
			session.setAttribute(CommonConfig.SES_USER_NAME_KEY, user.getUsername());
			
			if("".equals(map.getString("WAREKY"))){
				session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY, user.getLlogwh());
			}else{
				session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY, map.getString("WAREKY"));
			}
			
			//session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_KEY, user.getLlogwh());
			
			session.setAttribute(CommonConfig.SES_USER_WHAREHOUSE_NM_KEY, user.getLlogwhnm());
			session.setAttribute(CommonConfig.SES_USER_COMPANY_KEY, user.getCompid());
			session.setAttribute(CommonConfig.SES_USER_LANGUAGE_KEY, map.getString("LANGKY"));
			session.setAttribute(CommonConfig.SES_USER_THEME_KEY, CommonConfig.SYSTEM_THEME_PATH);
			session.setAttribute(CommonConfig.SES_MENU_GROUP_KEY, user.getMenugid());
			
			
			//운영,개발구분

			map.setModuleCommand("SajoCommon", "CMCDV_COMBO");
			map.put("CMCDKY", "SERVINFO");
			session.setAttribute(CommonConfig.DIV_REAL_TEST, ((DataMap)commonDAO.getList(map).get(0)).getString("VALUE_COL"));
			
			map.setModuleCommand("SajoCommon", "ROLOW");
			
			DataMap rolow = commonDAO.getMap(map);
			if(rolow != null){
				if("".equals(map.getString("OWNRKY"))){
					session.setAttribute(CommonConfig.SES_USER_OWNER_KEY, rolow.get("OWNRKY"));
				}else{
					session.setAttribute(CommonConfig.SES_USER_OWNER_KEY, map.getString("OWNRKY"));
				}
			
				session.setAttribute(CommonConfig.SESSION_KEY_OWNER_MANAGE, rolow.get("UROLKY"));
	
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
	
				desc01 = "성공";
				logHis.put("DESC01", desc01);
				logHis.put("STATUS", "S");
	
				log.debug(user);
			} else {
				model.put("data", "NoCon");
			}
		} else {
			model.put("data", "N");
			logHis.put("STATUS", "E");
			logHis.put("DESC01", desc01);
		}
		
		//이력저장
		logHis.setModuleCommand("Common", "LOGHIS");
		commonDAO.insert(logHis);
		
		
		//유저 GET/SAVE 마이그레이션 (최초 1회만 동작) CHK INDARC TEST
		logHis.setModuleCommand("Common", "USRMA_INDARC");
		if(!"V".equals(commonService.getMap(logHis).getString("INDARC"))){
			//setUserpl(logHis);
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
			session.setAttribute(CommonConfig.SES_MENU_GROUP_KEY, user.getMenugid());

			
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
		
		final String find = map.getString("FIND");
		String send = map.getString("FIND_SEND");
		String passWord = null;
		DataMap row = new DataMap();
		DataMap psData = new DataMap();
		DataMap pMsgMap = new DataMap();
		final DataMap logMap = new DataMap();
		
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
					final DataMap emailMap = row;
					
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
	
	//GET/SAVE VAIRRAINT 마이그레이션 
	@Transactional(rollbackFor = Exception.class)
	public void setUserpl(DataMap map) throws SQLException {

		//구버전 문자열 
		String SIGN_INCLUDE = "signIn"; // OR
		String SIGN_EXCLUDE = "signEx"; // AND 
		String SIGN_BETWEEN = "BW"; // BETWEEN 
		String EQUAL        = "EQ";
		String GREAT_EQUAL  = "GE";
		String LITTLE_EQUAL = "LE";
		String GREAT_THEN   = "GT";
		String LITTLE_THEN  = "LT";
		String NOT_EQUAL    = "NE";
		String LIKE         = "LK";
		String NOT_LIKE     = "NL";
		String BETWEEN      = "BW";
		String NOT_BETWEEN  = "NB";
		String OLD_DELI = "|";
		String OLD_ROW_DELI = "↓";
		
		//신버전 문자열
		String NEW_DELI = "↓";
		String NEW_ROW_DELI = "↑";
		String NEW_EQUAL = "E"; // =
		String NEW_NOT = "N"; // !=
		String NEW_LT = "LT"; // <
		String NEW_GT = "GT"; // >
		String NEW_LE = "LE"; // <=
		String NEW_GE = "GE"; // >=
		
		DataMap signParser = new DataMap();
		signParser.put(SIGN_INCLUDE, "OR");
		signParser.put(SIGN_EXCLUDE, "AND");
		signParser.put(EQUAL, NEW_EQUAL);
		signParser.put(NOT_EQUAL, NEW_NOT);
		signParser.put(LIKE, NEW_EQUAL);
		signParser.put(BETWEEN, NEW_EQUAL);
		signParser.put(NOT_LIKE, NEW_NOT);

		map.setModuleCommand("Common", "USRPL_USRPH");
		List<DataMap> list = commonService.getList(map);
		String ctrval;
		DataMap param;
		StringBuffer strBf = new StringBuffer();
		
		for(int i=0; i<list.size(); i++){
			DataMap headRow = list.get(i).getMap("map");
			headRow.putAll(map);
			DataMap parseMap = new DataMap();
			DataMap sqlParam = new DataMap();
			int itemNo  = 1;
			
			//헤더 선 삭제 
			headRow.setModuleCommand("Common", "USRPL");
			commonService.delete(headRow); 
			
			headRow.setModuleCommand("Common", "USRPL_USRPI");
			List<DataMap> itemList = commonService.getList(headRow);
			for(DataMap item : itemList){
				strBf = new StringBuffer();
				param = new DataMap();
				
				DataMap itemRow = item.getMap("map");
				ctrval = itemRow.getString("CTRVAL");
				
				//값을 세팅해야 할 경우
				if(null != ctrval && !" ".equals(ctrval) && !"".equals(ctrval)){
					String[] rowArr = ctrval.split(OLD_ROW_DELI); // row
					String[] valArr;
					
					//쿼리에서 맵핑키를 가져온다.
					param.put("CMCDVL", headRow.getString("PROGID")+"$"+itemRow.getString("CTRLID"));
					param.setModuleCommand("Common", "USRPL_CMCDV");
					parseMap = commonService.getMap(param);
					
					
					if(null == parseMap || !parseMap.containsKey("CMCDVL")){ //맵핑 데이터가 부재시 패스 로그를 남긴다 
						//param.setModuleCommand("System", "CC01SUB");
						//param.put("CMCDKY", "$"+ map.getString("USERID"));
						//param.put("CDESC1", map.getString("USERID"));
						//param.put("SES_USER_ID", map.getString("USERID"));
						//param.put("CMCDVL", headRow.getString("PROGID")+"$"+itemRow.getString("CTRLID"));
                        //
						//param.setModuleCommand("Common", "CMCDV");
						//commonService.delete(param);
						//param.setModuleCommand("System", "CC01SUB");
						//commonService.insert(param);
						continue;
					}else{

						//레인지 조건 파싱 날짜일경우에만 R로 들어간다 그외엔 SR 
						if("DATE".equals(parseMap.getString("CDESC2"))){
							//나중에 추가
						}else if("R".equals(itemRow.getString("CTRLTY"))){
							itemRow.put("CTRLTY","SR");
						}
					}
					
					
					if("CB".equals(itemRow.getString("CTRLTY"))){
						if("1".equals(ctrval)){
							strBf.append("V");	
						}else{
							strBf.append(" ");
						}
						itemRow.put("CTRLTY", "C");
					}else if("C".equals(itemRow.getString("CTRLTY")) || "E".equals(itemRow.getString("CTRLTY"))){
						itemRow.put("CTRLTY", "C");
						strBf.append(ctrval);
						
						if("".equals(ctrval) || " ".equals(ctrval)) continue; //빈 값 거름 
						
					}else{
						
						if(parseMap.getString("CDESC1").equals("I.QTYORG")){
							
							System.out.println("catch");
						}
						
						for(int j=0; j<rowArr.length; j++){ //값이 여러개 일 수 있으므로  for문으로 저장 
							valArr = rowArr[j].split("\\"+OLD_DELI);
							
							if(valArr.length > 3){ //between
								//between 조건 체크 
								String sign = valArr[0];
								String sign2 = valArr[1];
								String val = valArr[2];
								String val2 = valArr[3];
								
								if(sign.equals(SIGN_INCLUDE) && sign2.equals(BETWEEN)){ // 조건 체크
									if(j==0){
										strBf.append(signParser.getString(SIGN_BETWEEN)).append(NEW_DELI).append(val).append(NEW_DELI).append(val2);
									}else{
										strBf.append(NEW_ROW_DELI).append(signParser.getString(SIGN_BETWEEN)).append(NEW_DELI).append(val).append(NEW_DELI).append(val2);
									}
								}else{
									continue;
								}
								
							}else if(valArr.length == 3){ // or and 빈값일 경우가 있으니 3으로 한정   
	
								String sign = valArr[0];
								String sign2 = valArr[1];
								String val = valArr[2];
								
								if(SIGN_BETWEEN.equals(sign2)){ //캘린더 single 
									if(j==0){
										strBf.append(signParser.getString(sign2)).append(NEW_DELI).append(val).append(NEW_DELI);
									}else{
										strBf.append(NEW_ROW_DELI).append(signParser.getString(sign2)).append(NEW_DELI).append(val).append(NEW_DELI);
									}
								}else{
									if(j==0){
										strBf.append(signParser.getString(sign2)).append(NEW_DELI).append(val).append(NEW_DELI).append(signParser.getString(sign));
									}else{
										strBf.append(NEW_ROW_DELI).append(signParser.getString(sign2)).append(NEW_DELI).append(val).append(NEW_DELI).append(signParser.getString(sign));
									}
								}
							}
							
							//System.out.println("parse ===> "+strBf.toString());
							
						}
					}
				} 

				if(strBf.length() > 0){
					sqlParam.put("PARMKY", headRow.getString("PARMKY"));
					sqlParam.put("USERID", map.getString("USERID"));
					sqlParam.put("CTRLID", parseMap.getString("CDESC1"));
					sqlParam.put("CTRLTY", itemRow.getString("CTRLTY"));
					sqlParam.put("PROGID", headRow.getString("PROGID"));
					sqlParam.put("SHORTX", headRow.getString("SHORTX"));
					sqlParam.put("DEFCHK", headRow.getString("DEFCHK"));
					sqlParam.put("CTRVAL", strBf.toString());
					sqlParam.put("ITEMNO", itemNo);
	
					//기존걸 삭제하고 insert
					sqlParam.setModuleCommand("Common", "USRPL");
					commonService.insert(sqlParam);
					itemNo++;
				}
				
			} //USRPI LOOP END 
			
		}

	}
}