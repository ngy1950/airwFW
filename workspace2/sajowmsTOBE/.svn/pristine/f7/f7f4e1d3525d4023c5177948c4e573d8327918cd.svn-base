package project.system.comtroller;

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
import project.wdscm.service.SystemService;

@Controller
public class SystemController extends BaseController {
	
	static final Logger log = LogManager.getLogger(SystemController.class.getName());
	
	@Autowired
	private SystemService systemService;
	
	
	@RequestMapping("/system/{page}.*")
	public String page(@PathVariable String page){
		return "/system/"+page;
	}
	
	@RequestMapping("/system/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/system/"+module+"/"+page;
	}
	
	@RequestMapping("/system/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/system/"+module+"/"+sub+"/"+page;
	}
	
	//UI01 사용자
	@RequestMapping("/system/json/saveUI01.*")
	public String saveUI01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.saveUI01(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	//UI01_UserDialog 팝업
	@RequestMapping("/system/json/saveUI01_UserDialog.*")
	public String saveUI01_UserDialog(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.saveUI01_UserDialog(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	//UI01_LAYOUTDLG 팝업
	@RequestMapping("/system/json/saveUI01_LAYOUTDLG.*")
	public String saveUI01_LAYOUTDLG(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.saveUI01_LAYOUTDLG(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	
	//UI02 사용자 계정잠금
	@RequestMapping("/system/json/saveUI02.*")
	public String saveUI02(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.saveUI02(map);
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	
	@RequestMapping("/system/json/saveTF01.*")
	public String saveTF01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.saveTF01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/saveAL01.*")
	public String saveAL01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.saveAL01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}

	
	@RequestMapping("/system/json/saveAC01.*")
	public String saveAC01(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.saveAC01(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/authMemberShip.*")
	public String authMemberShip(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = systemService.authMemberShip(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/deleteAllMemberShip.*")
	public String deleteAllMemberShip(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.deleteAllMemberShip(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/saveDefaultInfo.*")
	public String saveDefaultInfo(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//Object data = systemService.saveDefaultInfo(map);
		Object data = systemService.saveDefaultInfoPrcs(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/selectOptionSetData.*")
	public String selectOptionSetData(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.selectOptionSetData(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/saveOptionSetData.*")
	public String saveOptionSetData(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//Object data = systemService.saveOptionSetData(map);
		Object data = systemService.saveOptionSetDatapPrsc(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/selectPriceData.*")
	public String selectPriceData(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.selectPriceData(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/savePriceData.*")
	public String savePriceData(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.savePriceData(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/selectResultData.*")
	public String selectResultData(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.selectResultData(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/saveResultData.*")
	public String saveResultData(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.saveResultData(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/system/json/selectIconList.*")
	public String selectIconList(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = systemService.selectIconList(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//[UR01] 생성 (원래  ADMIN에도 있음 둘중하나 지워야됨)
	@RequestMapping("/system/json/createUR01.*")
	public String createUR01(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = systemService.createUR01(map);
		model.put("data", data);
		return JSON_VIEW;
	}
	
	//[UR01] 삭제 (원래  ADMIN에도 있음 둘중하나 지워야됨)
	@RequestMapping("/system/json/deleteUR01.*")
	public String deleteUR01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = systemService.deleteUR01(map);
		model.put("data", data);
		return JSON_VIEW;
	}
	
	//[UR01] 저장 
	@RequestMapping("/system/json/saveUR01.*")
	public String saveUR01(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = systemService.saveUR01(map);
		model.put("data", data);
		return JSON_VIEW;
	}
	
	//[UR01] 저장2 (원래  ADMIN에도 있음 둘중하나 지워야됨)
	@RequestMapping("/system/json/saveUR01_2.*")
	public String saveUR01_2(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = systemService.saveUR01_2(map);
		model.put("data", data);
		return JSON_VIEW;
	}
	
	//[UR01] POPUP1 저장
	@RequestMapping("/system/json/saveUR01_popup1.*")
	public String saveUR01_popup1(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = systemService.saveUR01_popup1(map);
		model.put("data", data);
		
		
		return JSON_VIEW;
	}
	//[UR01] POPUP2 저장
	@RequestMapping("/system/json/saveUR01_popup2.*")
	public String saveUR01_popup2(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = systemService.saveUR01_popup2(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	//[UR01] POPUP3 저장
	@RequestMapping("/system/json/saveUR01_popup3.*")
	public String saveUR01_popup3(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = systemService.saveUR01_popup3(map);
		model.put("data", data);
		
		
		return JSON_VIEW;
	}
	
	//[UM02] 저장
	@RequestMapping("/system/json/saveUM02.*")
	public String saveUM02(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = systemService.saveUM02(map);
		model.put("data", data);
		
		
		return JSON_VIEW;
	}

	//[공통] 레이아웃 저장
	@RequestMapping("/system/json/saveVariant.*")
	public String saveVariant(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = systemService.saveVariant(map);
		model.put("data", data);
		
		
		return JSON_VIEW;
	}
	
	//[공통] 레이아웃 삭제
	@RequestMapping("/system/json/deleteVariant.*")
	public String deleteVariant(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = systemService.deleteVariant(map);
		model.put("data", data);
		
		
		return JSON_VIEW;
	}
	
	//[공통] 레이아웃 로드
	@RequestMapping("/system/json/getVariant.*")
	public String getVariant(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = systemService.getVariant(map);
		model.put("data", data);
		
		
		return JSON_VIEW;
	}
	
	//[UM01] 저장
	@RequestMapping("/system/json/saveUM01.*")
	public String saveUM01(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = systemService.saveUM01(map);
		model.put("data", data);
		
		
		return JSON_VIEW;
	}
	
	//[공통] 레이아웃 로드
	@RequestMapping("/system/json/getDefVariant.*")
	public String getDefVariant(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		DataMap data = systemService.getDefVariant(map);
		model.put("data", data);
		
		
		return JSON_VIEW;
	}

	
	//[공통] 레이아웃 로드
	@RequestMapping("/system/json/saveLayOut.*")
	public String saveLayOut(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data =  systemService.saveLayOut(map);
		model.put("data", data);
		
		
		return JSON_VIEW;
	}

	
	//[공통] 레이아웃 로드
	@RequestMapping("/system/json/deleteLayout.*")
	public String deleteLayout(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data =  systemService.deleteLayout(map);
		model.put("data", data);
		
		
		return JSON_VIEW;
	}
}