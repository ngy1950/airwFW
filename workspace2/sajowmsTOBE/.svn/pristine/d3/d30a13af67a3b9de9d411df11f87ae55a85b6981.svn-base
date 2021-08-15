package project.gcim.controller;

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

@Controller
public class GcimController extends BaseController {
	
	static final Logger log = LogManager.getLogger(GcimController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@RequestMapping("/gcim/{page}.*")
	public String page(@PathVariable String page){
		return "/gcim/"+page;
	}
	
	@RequestMapping("/gcim/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/gcim/"+module+"/"+page;
	}
	
	@RequestMapping("/gcim/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/gcim/"+module+"/"+sub+"/"+page;
	}
	
	@RequestMapping("/gcim/index.*")
	public String index(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		map.put("CODE", "LANGKY");
		
		List list = commonService.getList("Common.JLBLM_LANG_COMBO", map);
		
		model.put("LANGKY", list);
		
		return "/gcim/index";
	}
}