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
import project.wdscm.service.InventoryService;

@Controller
public class InventoryController extends BaseController {
	
	static final Logger log = LogManager.getLogger(InventoryController.class.getName());
	
	@Autowired
	private InventoryService inventoryService;
	
	@RequestMapping("/inventory/{page}.*")
	public String page(@PathVariable String page){
		return "/task/"+page;
	}
	
	@RequestMapping("/inventory/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/task/"+module+"/"+page;
	}
	
	@RequestMapping("/inventory/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/task/"+module+"/"+sub+"/"+page;
	}
	
	@RequestMapping("/inventory/json/saveMV01.*")
	public String saveMV01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = inventoryService.saveMV01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	

	@RequestMapping("/inventory/json/saveSJ04.*")
	public String saveSJ04(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = inventoryService.saveSJ04(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}

	@RequestMapping("/inventory/json/saveSJ05.*")
	public String saveSJ05(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = inventoryService.saveSJ05(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
}