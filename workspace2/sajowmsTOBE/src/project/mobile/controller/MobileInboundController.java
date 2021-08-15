package project.mobile.controller;

import java.sql.SQLException;
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
import project.common.controller.BaseController;
import project.common.service.CommonService;
import project.mobile.service.MobileInboundServerImpl;

@Controller
public class MobileInboundController extends BaseController {
	
	static final Logger log = LogManager.getLogger(MobileInboundController.class.getName());
	
	@Autowired
	private CommonService commonService;

	@Autowired
	private MobileInboundServerImpl mobileInboundServerImpl;
	
	@RequestMapping("/mobile/MobileInbound/{page}.*")
	public String page(@PathVariable String page){
		return "/mobile/"+page;
	}
	
	@RequestMapping("/mobile/MobileInbound/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/mobile/"+module+"/"+page;
	}
	
	@RequestMapping("/mobile/MobileInbound/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/mobile/"+module+"/"+sub+"/"+page;
	}
	
	//saveMGR00 이고입고  저장
	@RequestMapping("/mobile/MobileInbound/json/saveMGR00.*")
	public String saveMGR00(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = mobileInboundServerImpl.saveMGR00(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//saveMGR03 이고입고  저장
	@RequestMapping("/mobile/MobileInbound/json/saveMGR03.*")
	public String saveMGR03(HttpSession session, HttpServletRequest request, Map model) throws Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileInboundServerImpl.saveMGR03(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	@RequestMapping("/mobile/MobileInbound/json/searchMGR05_POP.*")
	public String searchMGR05_POP(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = mobileInboundServerImpl.searchMGR05_POP(map);
		
		model.put("data", list);
		model.put("FLAG", "Add");
		
		return JSON_VIEW;
	}
	
	//saveMGR05_POP 팔렛타이징 팝업창  저장
	@RequestMapping("/mobile/MobileInbound/json/saveMGR05_POP.*")
	public String saveMGR05_POP(HttpSession session, HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = mobileInboundServerImpl.saveMGR05_POP(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//saveMGR08  적치완료 저장
	@RequestMapping("/mobile/MobileInbound/json/saveMGR08.*")
	public String saveMGR08(HttpSession session, HttpServletRequest request, Map model) throws Exception,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileInboundServerImpl.saveMGR08(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//saveMGR04 이고입고  저장
	@RequestMapping("/mobile/MobileInbound/json/saveMGR04.*")
	public String saveMGR04(HttpSession session, HttpServletRequest request, Map model) throws Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileInboundServerImpl.saveMGR04(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	
	//saveMGR06 적치 저장
	@RequestMapping("/mobile/MobileInbound/json/saveMGR06.*")
	public String saveMGR06(HttpSession session, HttpServletRequest request, Map model) throws Exception,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    DataMap data = mobileInboundServerImpl.saveMGR06(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//saveMGR07 적치잔량 저장
	@RequestMapping("/mobile/MobileInbound/json/saveMGR07.*")
	public String saveMGR07(HttpSession session, HttpServletRequest request, Map model) throws Exception,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileInboundServerImpl.saveMGR07(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//saveMGR09  반품임시입고 저장
	@RequestMapping("/mobile/MobileInbound/json/saveMGR09.*")
	public String saveMGR09(HttpSession session, HttpServletRequest request, Map model) throws Exception,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileInboundServerImpl.saveMGR09(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//saveMGR10  기타입고 저장
	@RequestMapping("/mobile/MobileInbound/json/saveMGR10.*")
	public String saveMGR10(HttpSession session, HttpServletRequest request, Map model) throws Exception,Exception {
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = mobileInboundServerImpl.saveMGR10(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//saveMGR02 구매입고 저장
	@RequestMapping("/mobile/MobileInbound/json/saveMGR02.*")
	public String saveMGR02(HttpSession session, HttpServletRequest request, Map model) throws Exception,Exception {
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = mobileInboundServerImpl.saveMGR02(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}

	
	//saveMGR08  적치완료 저장
	@RequestMapping("/mobile/MobileInbound/json/saveMGR01.*")
	public String saveMGR01(HttpSession session, HttpServletRequest request, Map model) throws Exception,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileInboundServerImpl.saveMGR01(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//saveMGR08  적치완료 저장
	@RequestMapping("/mobile/MobileInbound/json/displayMGR06.*")
	public String displayMGR01(HttpSession session, HttpServletRequest request, Map model) throws Exception,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    Object data = mobileInboundServerImpl.displayMGR06(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//중복 로케이션 체크
	@RequestMapping("/mobile/MobileInbound/json/movingCheck.*")
	public String movingCheck(HttpSession session, HttpServletRequest request, Map model) throws Exception,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    DataMap data = mobileInboundServerImpl.movingCheck(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
}