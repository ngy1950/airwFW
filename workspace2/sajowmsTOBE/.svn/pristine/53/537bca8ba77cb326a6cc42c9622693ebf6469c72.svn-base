package project.wms.controller;

import java.sql.SQLException;
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
import project.wms.service.BoardService;

@Controller
public class BoardController extends BaseController {
	
	static final Logger log = LogManager.getLogger(BoardController.class.getName());
	
	@Autowired
	private BoardService boardService;
	
	@RequestMapping("/board/{page}.*")
	public String page(@PathVariable String page){
		return "/task/"+page;
	}
	
	@RequestMapping("/board/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/task/"+module+"/"+page;
	}
	
	@RequestMapping("/board/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/task/"+module+"/"+sub+"/"+page;
	}

	@RequestMapping("/board/json/saveBD10.*")
	public String saveSJ04(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		String data = boardService.saveBD10(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
}