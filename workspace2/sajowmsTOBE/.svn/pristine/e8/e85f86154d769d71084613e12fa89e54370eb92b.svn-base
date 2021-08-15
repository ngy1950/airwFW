package project.wms.controller;

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
import project.wdscm.service.WdscmService;
import project.wms.service.CenterCloseService;

@Controller
public class CenterCloseController extends BaseController {
	
	static final Logger log = LogManager.getLogger(CenterCloseController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private CenterCloseService centerCloseService; 


	@RequestMapping("/CenterClose/{page}.*")
	public String page(@PathVariable String page){
		return "/CenterClose/"+page;
	}
	
	@RequestMapping("/CenterClose/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/CenterClose/"+module+"/"+page;
	}
	
	@RequestMapping("/CenterClose/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/CenterClose/"+module+"/"+sub+"/"+page;
	}

	
	@RequestMapping("/CenterClose/json/saveCL01.*")
	public String saveCL01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = centerCloseService.saveCL01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/CenterClose/json/saveCL02.*")
	public String saveCL02(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = centerCloseService.saveCL02(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	//[CL02] 조회 
	@RequestMapping("/CenterClose/json/displayCL02.*")
	public String displayCL02(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//저장로직 구현
		centerCloseService.displayCL02(map); // 조회 값이 없을때 데이터를 생성하는 로직을 CenterCloseService에 구현(직접하세요)
		
		//조회쿼리 
		List list = commonService.getList("CenterClose.CL02", map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
}