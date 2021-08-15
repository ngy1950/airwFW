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
import project.wms.service.DaerimService;

@Controller
public class DaerimController extends BaseController {
	
	static final Logger log = LogManager.getLogger(DaerimController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private DaerimService daerimService;


	@RequestMapping("/daerim/{page}.*")
	public String page(@PathVariable String page){
		return "/daerim/"+page;
	}
	
	@RequestMapping("/daerim/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/daerim/"+module+"/"+page;
	}
	
	@RequestMapping("/daerim/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/daerim/"+module+"/"+sub+"/"+page;
	}
		
	//[DL33] 조회 
	@RequestMapping("/Daerim/json/displayDR03.*")
	public String displayDL33(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = daerimService.displayDR03(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	
	//[DR03] 헤드 2 조회 
	@RequestMapping("/Daerim/json/display2DR03.*")
	public String display2DR03(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = daerimService.display2DR03(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	//[DR03] 헤드 3 조회 
	@RequestMapping("/Daerim/json/display3DR03.*")
	public String display3DR03(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = daerimService.display3DR03(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	//[DR03] 아이템 조회 
	@RequestMapping("/Daerim/json/displayDR03Item.*")
	public String displayDR03Item(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = daerimService.displayDR03Item(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	//[DR06] 그룹핑 
	@RequestMapping("/Daerim/json/groupingDR06.*")
	public String groupingDR06(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		DataMap data = daerimService.groupingDR06(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//[DL43] 그룹핑 삭제
	@RequestMapping("/Daerim/json/delGroupDR06.*")
	public String delGroupDR06(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		
		DataMap data = daerimService.delGroupDR06(map);
		model.put("data", data);

		
		return JSON_VIEW;
	}
	//[DR09] 저장
		@RequestMapping("/Daerim/json/saveDR09.*")
		public String saveDR09(HttpServletRequest request, Map model) throws Exception{		
			DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
			
			DataMap data = daerimService.saveDR09(map);
			model.put("data", data);
			
			
			return JSON_VIEW;
		}
}