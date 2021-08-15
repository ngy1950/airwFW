package project.wms.controller;

import java.sql.SQLException;
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
import project.wms.service.LabelPrintService;

@Controller
public class LabelPrintController extends BaseController {
	
	static final Logger log = LogManager.getLogger(LabelPrintController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private LabelPrintService labelPrintService;
	

	@RequestMapping("/labelPrint/{page}.*")
	public String page(@PathVariable String page){
		return "/labelPrint/"+page;
	}
	
	@RequestMapping("/labelPrint/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/labelPrint/"+module+"/"+page;
	}
	
	@RequestMapping("/labelPrint/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/labelPrint/"+module+"/"+sub+"/"+page;
	}
	
	
	@RequestMapping("/labelPrint/json/printLB01.*")
	public String printLB01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = labelPrintService.printLB01(map);
		
		model.put("data", data);
				
		
//		System.out.println("컨트롤러 접근 ");
		return JSON_VIEW;
	} 
	
	
	@RequestMapping("/labelPrint/json/printAS09.*")
	public String printAS09(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = labelPrintService.printAS09(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	} 
	
	
}