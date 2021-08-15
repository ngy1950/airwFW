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
import project.common.service.CommonService;
import project.wdscm.service.InboundService;
import project.wdscm.service.WdscmService;

@Controller
public class InboundController extends BaseController {
	
	static final Logger log = LogManager.getLogger(InboundController.class.getName());
	
	@Autowired
	private InboundService inboundService;
	
	@RequestMapping("/inbound/{page}.*")
	public String page(@PathVariable String page){
		return "/inbound/"+page;
	}
	
	@RequestMapping("/inbound/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/inbound/"+module+"/"+page;
	}
	
	@RequestMapping("/inbound/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/inbound/"+module+"/"+sub+"/"+page;
	}
	
	@RequestMapping("/inbound/json/saveAS01.*")
	public String saveAS01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = inboundService.saveAS01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/inbound/json/saveAS02.*")
	public String saveAS02(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.put("ASNTTY", "001");
		map.put("LOTA01", "00");
		
		Object data = data = inboundService.saveAS01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/inbound/json/saveAS03.*")
	public String saveAS03(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.put("ASNTTY", "002");
		map.put("LOTA01", "00");
		
		Object data = data = inboundService.saveAS01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/inbound/json/saveAS04.*")
	public String saveAS04(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.put("ASNTTY", "003");
		map.put("LOTA01", "10");
		
		Object data = data = inboundService.saveAS01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/inbound/json/saveAS05.*")
	public String saveAS05(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = inboundService.saveAS05(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/inbound/json/saveGR01.*")
	public String saveGR01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = inboundService.saveGR01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/inbound/json/saveGR04.*")
	public String saveGR04(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = inboundService.saveGR04(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/inbound/json/saveGR09.*")
	public String saveGR09(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = inboundService.saveGR09(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
}