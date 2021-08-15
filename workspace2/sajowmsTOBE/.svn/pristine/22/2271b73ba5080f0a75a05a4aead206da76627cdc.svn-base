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
import project.wms.service.OyangSalesService;

@Controller
public class OyangSalesController extends BaseController {
	
	static final Logger log = LogManager.getLogger(OyangSalesController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private OyangSalesService oyangSalesService;


	@RequestMapping("/OyangSales/{page}.*")
	public String page(@PathVariable String page){
		return "/OyangSales/"+page;
	}
	
	@RequestMapping("/OyangSales/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/OyangSales/"+module+"/"+page;
	}
	
	@RequestMapping("/OyangSales/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/OyangSales/"+module+"/"+sub+"/"+page;
	}

	
}