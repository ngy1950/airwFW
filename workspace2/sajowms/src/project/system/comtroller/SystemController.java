package project.system.comtroller;

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
import project.wdscm.service.SystemService;

@Controller
public class SystemController extends BaseController {
	
	static final Logger log = LogManager.getLogger(SystemController.class.getName());
	
	@Autowired
	private SystemService systemService;
	
	
	@RequestMapping("/system/{page}.*")
	public String page(@PathVariable String page){
		return "/system/"+page;
	}
	
	@RequestMapping("/system/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/system/"+module+"/"+page;
	}
	
	@RequestMapping("/system/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/system/"+module+"/"+sub+"/"+page;
	}
	
	@RequestMapping("/system/json/saveTF01.*")
	public String saveTF01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.saveTF01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/saveAL01.*")
	public String saveAL01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.saveAL01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}

	@RequestMapping("/system/json/saveSK01.*")
	public String saveSK01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.saveSK01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/saveAC01.*")
	public String saveAC01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.saveAC01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/authMemberShip.*")
	public String authMemberShip(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.authMemberShip(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/deleteAllMemberShip.*")
	public String deleteAllMemberShip(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.deleteAllMemberShip(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/saveDefaultInfo.*")
	public String saveDefaultInfo(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//Object data = systemService.saveDefaultInfo(map);
		Object data = systemService.saveDefaultInfoPrcs(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/selectOptionSetData.*")
	public String selectOptionSetData(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.selectOptionSetData(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/saveOptionSetData.*")
	public String saveOptionSetData(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//Object data = systemService.saveOptionSetData(map);
		Object data = systemService.saveOptionSetDatapPrsc(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/selectPriceData.*")
	public String selectPriceData(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.selectPriceData(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/savePriceData.*")
	public String savePriceData(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.savePriceData(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/selectResultData.*")
	public String selectResultData(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.selectResultData(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/saveResultData.*")
	public String saveResultData(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.saveResultData(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/selectIconList.*")
	public String selectIconList(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.selectIconList(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
}