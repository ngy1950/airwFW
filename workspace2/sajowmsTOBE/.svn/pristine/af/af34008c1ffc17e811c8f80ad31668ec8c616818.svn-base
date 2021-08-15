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
import project.mobile.service.MobileInventoryService;
import project.mobile.service.MobileOutboundServerImpl;

@Controller
public class MobileOutboundController extends BaseController {
	
	static final Logger log = LogManager.getLogger(MobileOutboundController.class.getName());
	
	@Autowired
	private CommonService commonService;

	@Autowired
	private MobileOutboundServerImpl mobileOutboundServerImpl;
	
	@RequestMapping("/mobile/mobileOutbound/{page}.*")
	public String page(@PathVariable String page){
		return "/mobile/"+page;
	}
	
	@RequestMapping("/mobile/mobileOutbound/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/mobile/"+module+"/"+page;
	}
	
	@RequestMapping("/mobile/mobileOutbound/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/mobile/"+module+"/"+sub+"/"+page;
	}
	
	//saveMDL06 차량별 피킹완료  저장
	  @RequestMapping("/mobile/MobileOutbound/json/saveMDL06.*")
	  public String saveMDL06(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	      DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	      String data = mobileOutboundServerImpl.saveMDL06(map);
	      model.put("data", data);
	      
	      return JSON_VIEW;
	  }
	  
	//MSD00 재고이동 저장
	@RequestMapping("/mobile/mobileOutbound/json/MDL02POP.*")
	public String saveMDL02POP(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.saveMDL02POP(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//MSD00 재고이동 저장
	@RequestMapping("/mobile/mobileOutbound/json/MDL02POP_Delete.*")
	public String deleteMDL02POP(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.deleteMDL02POP(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
/*	
	//MSD00 재고이동 저장
	@RequestMapping("/mobile/mobileOutbound/json/SearchMDL02POP_Barcode.*")
	public String SearchMDL02POP_Barcode(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.SearchMDL02POP_Barcode(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
		}
*/
	//MDL03  저장
	@RequestMapping("/mobile/mobileOutbound/json/saveMDL03.*")
	public String saveMDL03(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.saveMDL03(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//MDL04  저장
	@RequestMapping("/mobile/mobileOutbound/json/saveMDL04.*")
	public String saveMDL04(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = mobileOutboundServerImpl.saveMDL04(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//MSD00 재고이동 저장
	@RequestMapping("/mobile/mobileOutbound/json/saveMTO11.*")
	public String saveMTO11(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.saveMTO11(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//MDL00 저장
	@RequestMapping("/mobile/mobileOutbound/json/saveMDL00.*")
	public String saveMDL00(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.saveMDL00(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	//MDL05 담당별 피킹완료
	@RequestMapping("/mobile/mobileOutbound/json/saveMDL05.*")
	public String saveMDL05(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.saveMDL05(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//MDL07POP 토탈피킹검수 팝업
	@RequestMapping("/mobile/mobileOutbound/json/MDL07POP.*")
	public String saveMDL07POP(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.saveMDL07POP(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//MDL08 차량출발
	@RequestMapping("/mobile/MobileOutbound/json/saveMDL08.*")
	public String saveMDL08(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.saveMDL08(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	//MDL09  저장
	@RequestMapping("/mobile/mobileOutbound/json/saveMDL09.*")
	public String saveMDL09(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.saveMDL09(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//MTO02  저장
	@RequestMapping("/mobile/mobileOutbound/json/saveMTO02.*")
	public String saveMTO02(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.saveMTO02(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//MTO03  저장
	@RequestMapping("/mobile/mobileOutbound/json/saveMTO03.*")
	public String saveMTO03(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.saveMTO03(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//MTO04POP 토탈피킹검수 팝업
	@RequestMapping("/mobile/mobileOutbound/json/MTO04POP.*")
	public String saveMTO04POP(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.saveMTO04POP(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}
	
	//MTO05  저장
	@RequestMapping("/mobile/mobileOutbound/json/saveMTO05.*")
	public String saveMTO05(HttpSession session, HttpServletRequest request, Map model) throws SQLException,Exception {
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = mobileOutboundServerImpl.saveMTO05(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}

	
	//MDL11  피킹완료 저장
	@RequestMapping("/mobile/mobileOutbound/json/saveMDL11.*")
	public String saveMDL11(HttpSession session, HttpServletRequest request, Map model) throws Exception,Exception {
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = mobileOutboundServerImpl.saveMDL11(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	}

}