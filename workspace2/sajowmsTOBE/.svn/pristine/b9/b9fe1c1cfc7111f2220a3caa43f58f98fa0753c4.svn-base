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
import project.wdscm.service.WdscmService;
import project.wms.service.DaerimReportService;

@Controller
public class DaerimReportController extends BaseController {
	
	static final Logger log = LogManager.getLogger(DaerimReportController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private DaerimReportService daerimReportService;


	@RequestMapping("/daerimReport/{page}.*")
	public String page(@PathVariable String page){
		return "/daerimReport/"+page;
	}
	
	@RequestMapping("/daerimReport/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/daerimReport/"+module+"/"+page;
	}
	
	@RequestMapping("/daerimReport/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/daerimReport/"+module+"/"+sub+"/"+page;
	}
		
	//[DR14] 거래명세서발행(통합) 아이템 1 조회
	@RequestMapping("/DaerimReport/json/displayDR14Item.*")
	public String displayDR14Item(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = daerimReportService.displayDR14Item(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//[DR14] 거래명세서발행(통합) 아이템 1 조회 
//	@RequestMapping("/DaerimReport/json/displayDR14Item..*")
//	public String displayDR14Item(HttpServletRequest request, Map model) throws Exception{
//		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
//		String ptnrty = map.getString("PTNRTY");
//		
//		if (ptnrty.equals("5")){//해표 통합송장발행
//			DataMap data = daerimReportService.displayDR14Item(map);
//			model.put("data", data);
//		} else if(ptnrty.equals("8")){//대림 통합송장발행
//			DataMap data = daerimReportService.displayDR14Item2(map);
//			model.put("data", data);
//		} 
//		
//		return JSON_VIEW;
//	} 
	
	//[DR14] 저장
	@RequestMapping("/DaerimReport/json/saveDR14.*")
	public String saveDR14(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		
		DataMap data = daerimReportService.saveDR14(map);
		model.put("data", data);
		
		
		return JSON_VIEW;
	}
	
}