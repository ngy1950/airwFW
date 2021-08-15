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
import project.wms.service.CenterCloseService;
import project.wms.service.OyangOutboundService;
import project.wms.service.OyangSalesService;

@Controller
public class OyangOutboundController extends BaseController {
	
	static final Logger log = LogManager.getLogger(OyangOutboundController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private OyangOutboundService oyangOutboundService;


	@RequestMapping("/OyangOutbound/{page}.*")
	public String page(@PathVariable String page){
		return "/OyangOutbound/"+page;
	}
	
	@RequestMapping("/OyangOutbound/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/OyangOutbound/"+module+"/"+page;
	}
	
	@RequestMapping("/OyangOutbound/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/OyangOutbound/"+module+"/"+sub+"/"+page;
	}

	/*
	 * 출고지시
	 * */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("/OyangOutbound/json/acceptShpOrder.*")
	public String acceptShpOrder(HttpServletRequest request, Map model) throws SQLException,Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = oyangOutboundService.acceptShpOrder(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}


	/*
	 * 출고지시해제 
	 * */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("/OyangOutbound/json/cancelAcceptShpOrder.*")
	public String cancelAcceptShpOrder(HttpServletRequest request, Map model) throws SQLException,Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = oyangOutboundService.cancelAcceptShpOrder(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	
	//[OY01] 조회 
	@RequestMapping("/OyangOutbound/json/displayOY01.*")
	public String displayOY01(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//저장로직 구현
		List list = oyangOutboundService.displayOY01(map); // 서치헬프 분리때문에 컨트롤러로 구현
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

	
	//[OY01] 저장 
	@RequestMapping("/OyangOutbound/json/saveOY01.*")
	public String saveOY01(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		String data = oyangOutboundService.saveOY01(map); // 이고생성

	    model.put("data", data);
		
		return JSON_VIEW;
	}

	@RequestMapping("/OyangOutbound/json/displayOY03.*")
	public String displayOY03(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = oyangOutboundService.displayOY03(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	  
	//OY04 저장
	@RequestMapping("/OyangOutbound/json/saveOY04.*")
	public String saveOY04(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  DataMap data = oyangOutboundService.saveOY04(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}

	  
	//OY05 조회
	@RequestMapping("/OyangOutbound/json/displayHeadOY05.*")
	public String displayHeadOY05(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = oyangOutboundService.displayHeadOY05(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	  
	//OY05 저장
	@RequestMapping("/OyangOutbound/json/saveOY05.*")
	public String saveOY05(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  DataMap data = oyangOutboundService.saveOY05(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}
	
	//OY06 조회
	@RequestMapping("/OyangOutbound/json/displayOY06.*")
	public String displayOY06(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = oyangOutboundService.displayOY06(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	  
	  //OY06 동기화
	  @RequestMapping("/OyangOutbound/json/saveOY06.*")
	  public String saveOY06(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = oyangOutboundService.saveOY06(map); 
	    model.put("data", data);
	    
	    return JSON_VIEW;
	  }
	  
	//OY07 조회
	@RequestMapping("/OyangOutbound/json/displayOY07.*")
	public String displayOY07(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = oyangOutboundService.displayOY07(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	  
	//OY14 저장
	@RequestMapping("/OyangOutbound/json/saveOY14.*")
	public String saveOY14(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  DataMap data = oyangOutboundService.saveOY14(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}
	  
	//OY15 저장
	@RequestMapping("/OyangOutbound/json/saveOY15.*")
	public String saveOY15(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  DataMap data = oyangOutboundService.saveOY15(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}
		
	//OY18_1 저장
	@RequestMapping("/OyangOutbound/json/saveOY18.*")
	public String saveOY18(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  String data = oyangOutboundService.saveOY18(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}
	
	//OY18_2 저장
	@RequestMapping("/OyangOutbound/json/saveOY18_2.*")
	public String saveOY18_2(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  String data = oyangOutboundService.saveOY18_2(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}
	  
	//OY22 저장
	@RequestMapping("/OyangOutbound/json/saveOY22.*")
	public String saveOY22(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  String data = oyangOutboundService.saveOY22(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}
	
	
	//OY27 조회
	@RequestMapping("/OyangOutbound/json/displayOY27.*")
	public String displayOY27(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = oyangOutboundService.displayOY27(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//OY06 조회
	@RequestMapping("/OyangOutbound/json/displayOY28.*")
	public String displayOY28(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = oyangOutboundService.displayOY28(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

	  
  //OY30 저장
  @RequestMapping("/OyangOutbound/json/saveOY30.*")
  public String saveDR30(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = oyangOutboundService.saveOY30(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
}