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
import project.wms.service.TaskOrderService;

@Controller
public class TaskOrderController extends BaseController {

	static final Logger log = LogManager.getLogger(TaskOrderController.class.getName());

	@Autowired
	private CommonService commonService;

	@Autowired
	private TaskOrderService taskOrderService;

	@RequestMapping("/taskOrder/{page}.*")
	public String page(@PathVariable String page) {
		return "/task/" + page;
	}

	@RequestMapping("/taskOrder/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page) {

		return "/task/" + module + "/" + page;
	}

	@RequestMapping("/taskOrder/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page) {

		return "/task/" + module + "/" + sub + "/" + page;
	}
	
	// MV01 저장
	@RequestMapping("/taskOrder/json/saveMV01.*")
	public String saveMV01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = taskOrderService.saveMV01(map);
		
		model.put("data", data);

		return JSON_VIEW;
	}
	
	@RequestMapping("/taskOrder/json/saveTaskMV01.*")
	public String saveTaskMV01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = taskOrderService.saveTaskMV01(map);
		
		model.put("data", data);

		return JSON_VIEW;
	}
	
	@RequestMapping("/taskOrder/json/saveMV07.*")
	public String saveMV07(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = taskOrderService.saveMV07(map);
		
		model.put("data", data);

		return JSON_VIEW;
	}
	
	@RequestMapping("/taskOrder/json/deleteMV07.*")
	public String deleteMV07(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = taskOrderService.deleteMV07(map);
		
		model.put("data", data);

		return JSON_VIEW;
	}
	
	// [TO40] 조회
	@RequestMapping("/taskOrder/json/displayTO40.*")
	public String displayTO40(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		// 조회쿼리
		List list = taskOrderService.displayTO40(map);

		model.put("data", list);

		return JSON_VIEW;
	}
	
	// [TO40] 아이템 조회
	@RequestMapping("/taskOrder/json/displayTO40Item.*")
	public String displayTO40Item(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		// 조회쿼리
		List list = taskOrderService.displayTO40Item(map);

		model.put("data", list);

		return JSON_VIEW;
	}
	
	// MV01 저장
	@RequestMapping("/taskOrder/json/saveMV03.*")
	public String saveMV03(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = taskOrderService.saveMV03(map);
			
		model.put("data", data);
		return JSON_VIEW;
	}
		
	@RequestMapping("/taskOrder/json/saveTaskMV03.*")
	public String saveTaskMV03(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = taskOrderService.saveTaskMV03(map);
		
		model.put("data", data);

		return JSON_VIEW;
	}
	
	@RequestMapping("/taskOrder/json/saveMV05.*")
	public String saveMV05(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = taskOrderService.saveMV05(map);
		
		model.put("data", data);

		return JSON_VIEW;
	}
	
	@RequestMapping("/taskOrder/json/saveTaskMV05.*")
	public String saveTaskMV05(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = taskOrderService.saveTaskMV05(map);
		
		model.put("data", data);

		return JSON_VIEW;
	}
	
	
	@RequestMapping("/taskOrder/json/saveMV17.*")
	public String saveMV17(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = taskOrderService.saveMV17(map);
		
		model.put("data", data);

		return JSON_VIEW;
	}
	
	@RequestMapping("/taskOrder/json/saveTaskMV17.*")
	public String saveTaskMV17(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		Object data = taskOrderService.saveTaskMV17(map);
		
		model.put("data", data);

		return JSON_VIEW;
	}
	
	@RequestMapping("/taskOrder/json/saveMV06.*")
	public String saveMV06(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap checkValiDation = taskOrderService.checkMV06(map);
		
		DataMap firstSave = taskOrderService.firstSaveMV06(checkValiDation);
		
		DataMap findAvailableStockMergeMap = taskOrderService.findAvailableStockMergeMV06(firstSave);
		
		DataMap result = taskOrderService.secondSaveMV06(findAvailableStockMergeMap); 
		
			
		 model.put("data", result);
		
		return JSON_VIEW;
	} // end saveMV06()
	
	@RequestMapping("/taskOrder/json/createMV12.*")
	public String createMV12(HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap result = taskOrderService.findAvailableStockMV12(map); // key : FINDAVAILABLESTOCK 

		model.put("data", result);
		
		return JSON_VIEW;
	} // end createMV12()
	
	@RequestMapping("/taskOrder/json/saveMV12.*")
	public String saveMV12(HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		DataMap movingCheck = taskOrderService.movingCheckMV12(map); // key : MOVINGCHECKLIST

		DataMap validate = taskOrderService.validateMV12(movingCheck); // validation 여부만 check 기존 map 반환 (first save 전에 체크)
		
		DataMap result = taskOrderService.saveMV12(validate);
		
		 model.put("data", result);
		
		return JSON_VIEW;
	} // end saveMV12()
	
	@RequestMapping("/taskOrder/json/confirmMV12.*")
	public String confirmMV12(HttpServletRequest request, Map model) throws SQLException {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap result = taskOrderService.confirmSaveMV12(map);
		
		model.put("data", result);
			
		return JSON_VIEW;
	} // end confirmMV12()
	

}