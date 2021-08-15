package project.wdscm.controller;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import project.wdscm.service.AdminService;
import project.wdscm.service.WdscmService;

@Controller
public class AdminController extends BaseController {
	
	static final Logger log = LogManager.getLogger(AdminController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private AdminService adminService;


	@RequestMapping("/admin/{page}.*")
	public String page(@PathVariable String page){
		return "/admin/"+page;
	}
	
	@RequestMapping("/admin/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/admin/"+module+"/"+page;
	}
	
	@RequestMapping("/admin/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/admin/"+module+"/"+sub+"/"+page;
	}
	
	/*
	 * 공통팝업 생성
	 * */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("/admin/json/createYH01.*")
	public String createYH01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = null;
		
		data = adminService.createYH01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	/*
	 * 공통팝업 저장
	 * */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("/admin/json/saveYH01.*")
	public String saveYH01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = null;
		
		data = adminService.saveYH01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}


	/*
	 * 화면권한관리 저장
	 * */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("/admin/json/createUR01.*")
	public String createUR01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = null;
		
		data = adminService.createUR01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	

	/*
	 * 화면권한관리 저장
	 * */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("/admin/json/saveUR01.*")
	public String saveUR01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = null;
		
		data = adminService.saveUR01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	

	/*
	 * 화면권한 삭제
	 * */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("/admin/json/deleteUR01.*")
	public String deleteUR01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = null; 
		
		data = adminService.deleteUR01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	

	@RequestMapping("/admin/json/NR01.*")
	public String saveNR01(HttpServletRequest request, Map model) throws SQLException{				
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = adminService.saveNR01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
}