package project.wms.controller;

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
import project.wms.service.ConsignOutboundService;

@Controller
public class ConsignOutboundController extends BaseController {
	
	static final Logger log = LogManager.getLogger(ConsignOutboundController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private ConsignOutboundService consignOutboundService;


	@RequestMapping("/ConsignOutbound/{page}.*")
	public String page(@PathVariable String page){
		return "/ConsignOutbound/"+page;
	}
	
	@RequestMapping("/ConsignOutbound/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/ConsignOutbound/"+module+"/"+page;
	}
	
	@RequestMapping("/ConsignOutbound/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/ConsignOutbound/"+module+"/"+sub+"/"+page;
	}


	
	//[OD01] 저장 
	@RequestMapping("/ConsignOutbound/json/saveOD01.*")
	public String saveOD01(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		String data = consignOutboundService.saveOD01(map); // 위탁 주문서 생성

	    model.put("data", data);
		
		return JSON_VIEW;
	}

	
	//[OD02] 저장 
	@RequestMapping("/ConsignOutbound/json/saveOD02.*")
	public String saveOD02(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = consignOutboundService.saveOD02(map); // 위탁 주문서 생성

	    model.put("data", data);
		
		return JSON_VIEW;
	}

	
	//[OD03] 저장 
	@RequestMapping("/ConsignOutbound/json/saveOD03.*")
	public String saveOD03(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = consignOutboundService.saveOD03(map); // 위탁 주문서 생성

	    model.put("data", data);
		
		return JSON_VIEW;
	}

	
	//[OD06] 저장 
	@RequestMapping("/ConsignOutbound/json/saveOD06.*")
	public String saveOD06(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = consignOutboundService.saveOD06(map); // 위탁 주문서 생성

	    model.put("data", data);
		
		return JSON_VIEW;
	}
		
	
	//[OD09] 저장 
	@RequestMapping("/ConsignOutbound/json/saveOD09.*")
	public String saveOD09(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = consignOutboundService.saveOD09(map); // 위탁 주문서 생성

	    model.put("data", data);
		
		return JSON_VIEW;
	}

	
	//[OD10] 저장 
	@RequestMapping("/ConsignOutbound/json/saveOD10.*")
	public String saveOD10(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = consignOutboundService.saveOD10(map); // 위탁 주문서 생성

	    model.put("data", data);
		
		return JSON_VIEW;
	}
}