package project.wdscm.controller;

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
import project.wdscm.service.SJ10Service;

@Controller
public class SJ10Controller extends BaseController {
	
	static final Logger log = LogManager.getLogger(SJ10Controller.class.getName());
	
	@Autowired
	private SJ10Service sj10Service;
	
	@RequestMapping("/sj10/{page}.*")
	public String page(@PathVariable String page){
		return "/task/"+page;
	}
	
	@RequestMapping("/sj10/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/task/"+module+"/"+page;
	}
	
	@RequestMapping("/sj10/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/task/"+module+"/"+sub+"/"+page;
	}
/*	
	@RequestMapping("/sj10/json/SJ10List.*")
	public String SJ10List(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		List<DataMap> list = sj10Service.SJ10List(map);
		
		model.put("data", list);

		return JSON_VIEW;
	}
*/
}