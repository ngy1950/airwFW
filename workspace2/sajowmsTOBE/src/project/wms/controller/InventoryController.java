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
import project.wms.service.InventoryService;

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
	
	@RequestMapping("/inventory/json/saveIP02.*")
	public String saveIP02(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = inventoryService.saveIP02(map);
		model.put("data", data);

		return JSON_VIEW;
	}
	
	@RequestMapping("/inventory/json/confirmIP02.*")
	public String confirmIP02(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = inventoryService.confirmIP02(map);
		model.put("data", data);

		return JSON_VIEW;
	}
	
	@RequestMapping("/inventory/json/saveIP04.*")
	public String saveIP04(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = inventoryService.saveIP04(map);
		model.put("data", data);

		return JSON_VIEW;
	}
	
	@RequestMapping("/inventory/json/saveIP01.*")
	public String saveIP01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = inventoryService.saveIP01(map);
		model.put("data", data);

		return JSON_VIEW;
	}
	
	
	//[**IP13 재고실사지시(출고포함) 실행 조회 ]
	@RequestMapping("/inventory/json/displayIP13ItemC.*")
	public String displayIP13ItemC(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = inventoryService.displayIP13ItemC(map);
		model.put("data", data);

		return JSON_VIEW;
	}
		
	@RequestMapping("/inventory/json/saveIP14.*")
	public String saveIP14(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = inventoryService.saveIP14(map);
		model.put("data", data);

		return JSON_VIEW;
	}
	
	// [IP11] 재조고정 Duomky(단위) GET
	@RequestMapping("/inventory/json/getDataIP11.*")
	public String getDuomkyIP11(HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = inventoryService.getDataIP11(map);
		model.put("data", data);
		
		return JSON_VIEW;
	} // end getDuomkyIP11()

	// [IP11] 재조고정 save
	@RequestMapping("/inventory/json/saveIP11.*")
	public String saveIP11(HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = inventoryService.saveIP11(map);
		model.put("data", data);
		
		return JSON_VIEW;
	} // end saveIP11()

	// [IP11] 재조고정 research
	@RequestMapping("/inventory/json/reSearchIP11.*")
	public String reSearchIP11(HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = inventoryService.reSearchIP11(map);
		model.put("data", data);
		
		return JSON_VIEW;
	} // end saveIP11()
}