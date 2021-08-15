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
import project.wms.service.DaerimDASService;
import project.wms.service.DaerimOutboundService;
import project.wms.service.OutboundService;

@Controller
public class DaerimDASController extends BaseController {
  
  static final Logger log = LogManager.getLogger(DaerimDASController.class.getName());
  
  @Autowired
  private DaerimDASService daerimDASService;
  
  @RequestMapping("/daerimDASController/{page}.*")
  public String page(@PathVariable String page){
    return "/daerimDASController/"+page;
  }
  
  @RequestMapping("/daerimDASController/{module}/{page}.*")
  public String mpage(@PathVariable String module, @PathVariable String page){
    
    return "/daerimDASController/"+module+"/"+page;
  }
  
  @RequestMapping("/daerimDASController/{module}/{sub}/{page}.*")
  public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
    
    return "/daerimDASController/"+module+"/"+sub+"/"+page;
  }
  
	/**
	 * 2020-12-23 DAS고정셀관리 cmu
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
  @RequestMapping("/daerimDASController/json/saveDR11.*")
  public String saveDR11(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = daerimDASService.saveDR11(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }

  
	/**
	 * 2020-12-28 DAS고정셀매핑 cmu
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/daerimDASController/json/saveDR12.*")
	public String saveDR12(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  String data = daerimDASService.saveDR12(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}

  
	/**
	 * 2020-12-28 DAS고정셀파일 생성 cmu
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/daerimDASController/json/createDasFileDR13.*")
	public String createDasFileDR13(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  DataMap data = daerimDASService.createDasFileDR13(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}

  
	/**
	 * 2021-01-07 DAS품목관리 cmu
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/daerimDASController/json/saveDR18.*")
	public String saveDR18(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  String data = daerimDASService.saveDR18(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}
}