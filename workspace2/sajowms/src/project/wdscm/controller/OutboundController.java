package project.wdscm.controller;

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
import project.wdscm.service.OutboundService;

@Controller
public class OutboundController extends BaseController {
	
	static final Logger log = LogManager.getLogger(OutboundController.class.getName());
	
	@Autowired
	private OutboundService outboundService;
	
	@RequestMapping("/outbound/{page}.*")
	public String page(@PathVariable String page){
		return "/outbound/"+page;
	}
	
	@RequestMapping("/outbound/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/outbound/"+module+"/"+page;
	}
	
	@RequestMapping("/outbound/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/outbound/"+module+"/"+sub+"/"+page;
	}
	
	@RequestMapping("/outbound/json/saveSO01.*")
	public String saveSO01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = outboundService.saveSO01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/outbound/json/saveSO10.*")
	public String saveSO10(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = outboundService.saveSO10(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/outbound/json/saveSH01.*")
	public String saveSH01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = outboundService.saveSH01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/outbound/json/saveSH01Cancel.*")
	public String saveSH01Cancel(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = outboundService.saveSH01Cancel(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/outbound/json/saveSH02.*")
	public String saveSH02(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.put("ALSTKY", "0000000001");
		
		Object data = data = outboundService.saveSH02(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/outbound/json/saveSH03.*")
	public String saveSH03(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.put("ALSTKY", "0000000002");
		
		Object data = data = outboundService.saveSH02(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	@RequestMapping("/outbound/json/saveSH04.*")
	public String saveSH04(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.put("ALSTKY", "0000000003");
		
		Object data = data = outboundService.saveSH02(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/outbound/json/savePK01.*")
	public String savePK01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = outboundService.savePK01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/outbound/json/savePK01Cancel.*")
	public String savePK01Cancel(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = outboundService.savePK01Cancel(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/outbound/json/saveSH30.*")
	public String saveSH30(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = outboundService.saveSH30(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
}