package project.common.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.service.SystemMagService;
import project.system.comtroller.SystemController;

@Controller
public class SystemMagController extends BaseController {
	
	
	static final Logger log = LogManager.getLogger(SystemController.class.getName());
	
	
	@Autowired
	private SystemMagService systemMagService;
		
	/**
	 * 2020-12-15 라벨 저장 Ahn JinSeok
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/wms/system/json/saveYL01.*")
	public String saveYL01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = systemMagService.saveYL01(map);
		model.put("data", data);
		
		return JSON_VIEW;
	} 
	
	/**
	 * 2020-12-15 메세지 저장 Ahn JinSeok
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/wms/system/json/saveYM01.*")
	public String saveYM01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = systemMagService.saveYM01(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	/**
	 * 2021-02-09 사유코드 저장 Nam Gi Yun
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/wms/system/json/saveRC01.*")
	public String saveRC01(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String data = systemMagService.saveRC01(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
}