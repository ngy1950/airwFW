package project.demo.controller;

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

@Controller
public class DemoController extends BaseController {
	
	static final Logger log = LogManager.getLogger(DemoController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@RequestMapping("/demo/{page}.*")
	public String page(@PathVariable String page){
		return "/demo/"+page;
	}
	
	@RequestMapping("/demo/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/demo/"+module+"/"+page;
	}
	
	@RequestMapping("/demo/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/demo/"+module+"/"+sub+"/"+page;
	}
	
	@RequestMapping("/demo/System/list/json/SYSLABEL.*")
	public String list(HttpServletRequest request, @PathVariable String module, @PathVariable String command, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);
		
		List list = commonService.getList("System.SYSLABEL", map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
}