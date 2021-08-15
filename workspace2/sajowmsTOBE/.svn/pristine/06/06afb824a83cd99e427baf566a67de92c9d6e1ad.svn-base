package project.mobile.controller;

import java.sql.SQLException;
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
import project.mobile.service.MobileInventoryService;

@Controller
public class MobileInventoryController extends BaseController {
	
	static final Logger log = LogManager.getLogger(MobileInventoryController.class.getName());
	
	@Autowired
	private CommonService commonService;

	@Autowired
	private MobileInventoryService mobileInventoryServerImpl;
	
	@RequestMapping("/mobile/mobileInventory/{page}.*")
	public String page(@PathVariable String page){
		return "/mobile/"+page;
	}
	
	@RequestMapping("/mobile/mobileInventory/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/mobile/"+module+"/"+page;
	}
	
	@RequestMapping("/mobile/mobileInventory/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/mobile/"+module+"/"+sub+"/"+page;
	}
	
	//MSD00 재고이동 저장
	@RequestMapping("/mobile/mobileInventory/json/saveMSD00.*")
	public String saveMGR03(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    DataMap data = mobileInventoryServerImpl.saveMSD00(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//MSD00 재고이동 저장
	@RequestMapping("/mobile/mobileInventory/json/saveMSD06.*")
	public String saveMSD06(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileInventoryServerImpl.saveMSD06(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	//MSD01 재고실사 저장
	@RequestMapping("/mobile/mobileInventory/json/saveMSD01.*")
	public String saveMSD01(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = mobileInventoryServerImpl.saveMSD01(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//MSD02 재고조정 저장
	@RequestMapping("/mobile/mobileInventory/json/saveMSD02.*")
	public String saveMSD02(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = mobileInventoryServerImpl.saveMSD02(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//중복 로케이션 체크
	@RequestMapping("/mobile/mobileInventory/json/movingCheck.*")
	public String movingCheck(HttpSession session, HttpServletRequest request, Map model) throws Exception,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    DataMap data = mobileInventoryServerImpl.movingCheck(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
}