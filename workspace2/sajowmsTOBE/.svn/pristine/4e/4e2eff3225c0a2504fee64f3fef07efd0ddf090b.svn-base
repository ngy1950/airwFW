package project.wms.controller;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.controller.BaseController;
import project.common.service.CommonService;
import project.wdscm.service.InboundService;
import project.wdscm.service.WdscmService;
import project.wms.service.GoodReceiptService;
import project.common.dao.CommonDAO;

@Controller
public class GoodReceiptController<goodReceiptService> extends BaseController {
	
	static final Logger log = LogManager.getLogger(GoodReceiptController.class.getName());
	
	@Autowired
	private GoodReceiptService goodReceiptService;

	private CommonService commonService;

	private DataMap commonDao;
	
	@RequestMapping("/GoodReceipt/{page}.*")
	public String page(@PathVariable String page){
		return "/GoodReceipt/"+page;
	}
	
	@RequestMapping("/GoodReceipt/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/GoodReceipt/"+module+"/"+page;
	}
	
	@RequestMapping("/GoodReceipt/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/GoodReceipt/"+module+"/"+sub+"/"+page;
	}
	
	// GR42 출고반품입고 조회, 명세서 인쇄
	@RequestMapping("/GoodReceipt/json/printGR42.*")
	public String printGR42(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//저장로직 구현
		DataMap data = goodReceiptService.printGR42(map); // 조회 값이 없을때 데이터를 생성하는 로직을 goodReceiptService에 구현
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	
	// GR44 회송반품입고  save
	@RequestMapping("/GoodReceipt/json/saveGR44.*")
	public String saveGR44(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//저장로직 구현
		DataMap data = goodReceiptService.saveGR44(map); 			
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	// GR44 회송반품입고  callback 회수지시
	@RequestMapping("/GoodReceipt/json/callbackGR44.*")
	public String callbackGR44(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = goodReceiptService.callbackGR44(map); 			
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	
	// [GR44] 아이템조회
	@RequestMapping("/GoodReceipt/json/displayGR44Item.*")
	public String displayGR44Item(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		// 조회쿼리
		List list = goodReceiptService.displayGR44Item(map);
		model.put("data", list);
		return JSON_VIEW;
	}
		
	// [GR44] 저장 후 아이템 재조회  
	@RequestMapping("/GoodReceipt/json/returnGR44Item.*")
	public String returnGR44Item(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		// 조회쿼리
		List list = goodReceiptService.returnGR44Item(map);
		model.put("data", list);
		return JSON_VIEW;
	}
	
	

	
	

}