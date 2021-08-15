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
import project.wdscm.service.TaskService;

@Controller
public class TaskController extends BaseController {
	
	static final Logger log = LogManager.getLogger(TaskController.class.getName());
	
	@Autowired
	private TaskService taskService;
	
	@RequestMapping("/task/{page}.*")
	public String page(@PathVariable String page){
		return "/task/"+page;
	}
	
	@RequestMapping("/task/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/task/"+module+"/"+page;
	}
	
	@RequestMapping("/task/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/task/"+module+"/"+sub+"/"+page;
	}
	
	@RequestMapping("/task/json/savePT01.*")
	public String savePT01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = taskService.savePT01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/task/json/savePT02.*")
	public String savePT02(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.put("TKFLKY", "0000000001");
		
		Object data = data = taskService.savePT02(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/task/json/savePT02Comp.*")
	public String savePT02Comp(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = data = taskService.savePT02Comp(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/task/json/deletePT02.*")
	public String deletePT02(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = data = taskService.deletePT02(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/task/json/savePT03.*")
	public String savePT03(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.put("TKFLKY", "0000000002");
		
		Object data = data = taskService.savePT02(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/task/json/savePT04.*")
	public String savePT04(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.put("TKFLKY", "0000000003");
		
		Object data = data = taskService.savePT02(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/task/json/savePT05.*")
	public String savePT05(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.put("TKFLKY", "0000000004");
		
		Object data = data = taskService.savePT02(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
}