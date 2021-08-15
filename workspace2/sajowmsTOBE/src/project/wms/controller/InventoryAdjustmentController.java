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
import project.wms.service.InventoryAdjustmentService;
import project.wms.service.InventoryService;

@Controller
public class InventoryAdjustmentController extends BaseController {
	
	static final Logger log = LogManager.getLogger(InventoryAdjustmentController.class.getName());
	
	@Autowired
	private InventoryAdjustmentService inventoryAdjustmentService;
	
	@RequestMapping("/inventoryAdjustment/{page}.*")
	public String page(@PathVariable String page){
		return "/task/"+page;
	}
	
	@RequestMapping("/inventoryAdjustment/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/task/"+module+"/"+page;
	}
	
	@RequestMapping("/inventoryAdjustment/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/task/"+module+"/"+sub+"/"+page;
	}
	
	// SJ03, SJ04, SJ05 SAVE 공통
	@RequestMapping("/inventoryAdjustment/json/saveSJ04.*")
	public String saveSJ04(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = inventoryAdjustmentService.saveSJ04(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
		
}