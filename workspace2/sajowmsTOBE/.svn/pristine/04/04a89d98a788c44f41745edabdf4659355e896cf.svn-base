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
import project.wms.service.CenterCloseService;
import project.wms.service.InventorySetBomService;

@Controller
public class InventorySetBomController extends BaseController {
	
	static final Logger log = LogManager.getLogger(InventorySetBomController.class.getName());
	
	@Autowired
	private InventorySetBomService inventorySetBomService;
	
	@RequestMapping("/inventorySetBom/{page}.*")
	public String page(@PathVariable String page){
		return "/task/"+page;
	}
	
	@RequestMapping("/inventorySetBom/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/task/"+module+"/"+page;
	}
	
	@RequestMapping("/inventorySetBom/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/task/"+module+"/"+sub+"/"+page;
	}
	
	//SJ01 세트 구성품 데이터 가져오기
	@RequestMapping("/inventorySetBom/json/setJoinSJ01.*")
	public String setJoinSJ01(HttpServletRequest request, Map model) throws SQLException, Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = inventorySetBomService.setJoinSJ01(map);
		
		model.put("data", list);
		

		return JSON_VIEW;
	}
	
	//SJ01 저장 ( 세트품 조립 ) 
	@RequestMapping("/inventorySetBom/json/saveSJ01.*")
	public String saveSJ01(HttpServletRequest request, Map model) throws SQLException, Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		String data = inventorySetBomService.saveSJ01(map);
		model.put("data", data);
		

		return JSON_VIEW;
	}

	//SJ02 해체품 조회 
	@RequestMapping("/inventorySetBom/json/disjoinSJ02.*")
	public String disjoinSJ02(HttpServletRequest request, Map model) throws SQLException, Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		List list = inventorySetBomService.disjoinSJ02(map);
		model.put("data", list);

		return JSON_VIEW;
	}
	
	//SJ02 저장 
	@RequestMapping("/inventorySetBom/json/saveSJ02.*")
	public String saveSJ02(HttpServletRequest request, Map model) throws SQLException, Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = inventorySetBomService.saveSJ02(map);
		model.put("data", data);
		

		return JSON_VIEW;
	}
}