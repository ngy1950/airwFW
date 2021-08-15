package project.wms.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.controller.BaseController;
import project.common.service.CommonService;
import project.wms.service.MasterService;

@Controller
public class MasterController extends BaseController {
	
	static final Logger log = LogManager.getLogger(MasterController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private MasterService masterService;
	

	@RequestMapping("/master/json/saveMW01.*")
	public String saveMW01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveMW01(map);
		
		model.put("data", data);
				
		
//		System.out.println("컨트롤러 접근 ");
		return JSON_VIEW;
	}
	
	/**[MO01] 화주 저장 2020-12-27 Ahn JinSeok
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/master/json/saveMO01.*")
	public String saveMO01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveMO01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	/**[MA01] 영역  저장 2020-12-27 Ahn JinSeok
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/master/json/saveMA01.*")
	public String saveMA01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveMA01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	/**
	 * [MZ01] 구역 저장 2020-12-27 Ahn JinSeok
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/master/json/saveMZ01.*")
	public String saveMZ01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveMZ01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	/**
	 * [SK01] SKU 2020-12-29 Ahn JinSeok
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/master/json/saveSK01.*")
	public String saveSK01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveSK01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	
	/**
	 * [SK03] SKU 2021-01-04 Ahn JinSeok
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/master/json/saveSK03.*")
	public String saveSK03(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveSK03(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	/**
	 * [TC01] 차량관리 2021-01-04 Ahn JinSeok
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/master/json/saveTC01.*")
	public String saveTC01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveTC01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	/**
	 * [TC01] 차량관리 2021-01-04 Ahn JinSeok
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/master/json/saveTP01.*")
	public String saveTP01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveTP01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	/**
	 * [TC01] 차량관리 2021-01-04 Ahn JinSeok
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/master/json/saveTS01.*")
	public String saveTS01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveTS01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	/**
	 * [SM01] 차량관리
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/master/json/saveSM01.*")
	public String saveSM01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveSM01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	/**
	 * [BD01] 거래처 상미기간 마스터 Ahn JinSeok
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/master/json/saveBD01.*")
	public String saveBD01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveBD01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	/**
	 * [TC02] 권역관리 Ahn JinSeok
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/master/json/saveTC02.*")
	public String saveTC02(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveTC02(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//[TC05] 아이템조회 
	@RequestMapping("/master/json/displayTC05_ITEM.*")
	public String displayTC05_ITEM(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = masterService.displayTC05_ITEM(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	//[TC05] 저장
	@RequestMapping("/master/json/saveTC05.*")
	public String saveTC05(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveTC05(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	//[TC06] 아이템조회 
	@RequestMapping("/master/json/displayTC06_ITEM.*")
	public String displayTC06_ITEM(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = masterService.displayTC06_ITEM(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//[TC06] 저장
	@RequestMapping("/master/json/saveTC06.*")
	public String saveTC06(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveTC06(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	//[ML01] 저장
	@RequestMapping("/master/json/saveML01.*")
	public String saveML01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveML01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//[BZ01] 저장
	@RequestMapping("/master/json/saveBZ01.*")
	public String saveBZ01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveBZ01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//[TR01] 저장
	@RequestMapping("/master/json/saveTR01.*")
	public String saveTR01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = masterService.saveTR01(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
}