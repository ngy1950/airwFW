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
import project.system.comtroller.SystemController;
import project.wms.service.OutBoundPickingService;

@Controller
public class OutBoundPickingController extends BaseController {
	
	
	static final Logger log = LogManager.getLogger(OutBoundPickingController.class.getName());

	@Autowired
	private CommonService commonService;
	
	@Autowired
	private project.wms.service.OutBoundPickingService OutBoundPickingService;
		
	@RequestMapping("/OutBoundPicking/{page}.*")
	public String page(@PathVariable String page){
		return "/OutBoundPicking/"+page;
	}
	
	@RequestMapping("/OutBoundPicking/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/OutBoundPicking/"+module+"/"+page;
	}
	
	@RequestMapping("/OutBoundPicking/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/OutBoundPicking/"+module+"/"+sub+"/"+page;
	}
	
	//[DL42] 조회 
//	@RequestMapping("/OutBoundPicking/json/displayDL42.*")
//	public String displayDL42(HttpServletRequest request, Map model) throws Exception{		
//		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
//		
//		//조회쿼리 
//		List list = OutBoundPickingService.displayDL42(map);
//		
//		model.put("data", list);
//		
//		return JSON_VIEW;
//	}
	
	//[DL42] 그룹핑 
	@RequestMapping("/OutBoundPicking/json/groupingDL42.*")
	public String groupingDL42(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = OutBoundPickingService.groupingDL42(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//[DL42] 그룹핑 삭제
	@RequestMapping("/OutBoundPicking/json/delGroupDL42.*")
	public String delGroupDL42(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = OutBoundPickingService.delGroupDL42(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//[DL42] 그룹핑 확인
	@RequestMapping("/OutBoundPicking/json/saveDL42.*")
	public String saveDL42(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = data = OutBoundPickingService.saveDL42(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
	

	//[DL43] 그룹핑 
	@RequestMapping("/OutBoundPicking/json/groupingDL43.*")
	public String groupingDL43(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = OutBoundPickingService.groupingDL43(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//[DL43] 그룹핑 삭제
	@RequestMapping("/OutBoundPicking/json/delGroupDL43.*")
	public String delGroupDL43(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = OutBoundPickingService.delGroupDL43(map);
		model.put("data", data);

		return JSON_VIEW;
	}
	
	//[DL43] 그룹핑 확인
	@RequestMapping("/OutBoundPicking/json/saveDL43.*")
	public String saveDL43(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = data = OutBoundPickingService.saveDL43(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	//[DL43] 그룹핑 확인
	@RequestMapping("/OutBoundPicking/json/saveDL43New.*")
	public String saveDL43New(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = data = OutBoundPickingService.saveDL43New(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
		
	//[DL44] 그룹핑 
	@RequestMapping("/OutBoundPicking/json/groupingDL44.*")
	public String groupingDL44(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = OutBoundPickingService.groupingDL44(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}

	
	//[DL44] 그룹핑(속도개선)
	@RequestMapping("/OutBoundPicking/json/groupingDL44New.*")
	public String groupingDL44New(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = OutBoundPickingService.groupingDL44New(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//[DL44] 그룹핑 삭제
	@RequestMapping("/OutBoundPicking/json/delGroupDL44New.*")
	public String delGroupDL44New(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = OutBoundPickingService.delGroupDL44New(map);
		model.put("data", data);

		return JSON_VIEW;
	}
	
	//[DL44] 그룹핑 삭제
	@RequestMapping("/OutBoundPicking/json/delGroupDL44.*")
	public String delGroupDL44(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = OutBoundPickingService.delGroupDL44(map);
		model.put("data", data);

		return JSON_VIEW;
	}
	
	//[DL44] 그룹핑 확인
	@RequestMapping("/OutBoundPicking/json/saveDL44.*")
	public String saveDL44(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = data = OutBoundPickingService.saveDL44(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	//[DL43] 프린트 체크 
	@RequestMapping("/OutBoundPicking/json/printDL43.*")
	public String printDL43(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = data = OutBoundPickingService.printDL43(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	//[DL44] 프린트 체크 
	@RequestMapping("/OutBoundPicking/json/printDL44.*")
	public String printDL44(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = data = OutBoundPickingService.printDL44(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	//[DL45] 피킹완료
	@RequestMapping("/OutBoundPicking/json/pickingDL45.*")
	public String pickingDL45(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = data = OutBoundPickingService.pickingDL45(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	//[DL45] RangeSearchRS
	@RequestMapping("/OutBoundPicking/json/displayDL45.*")
	public String displayDL45(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = data = OutBoundPickingService.displayDL45(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
	

	//[DL45] RangeSearchRS
	@RequestMapping("/OutBoundPicking/json/displayDL45Item.*")
	public String displayDL45Item(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = data = OutBoundPickingService.displayDL45Item(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	
	//[DL45] 프린트 체크 
	@RequestMapping("/OutBoundPicking/json/printDL45.*")
	public String printDL45(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = data = OutBoundPickingService.printDL45(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
}