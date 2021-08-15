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
import project.wms.service.DaerimOutboundService;
import project.wms.service.OutboundService;

@Controller
public class DaerimOutboundController extends BaseController {
  
  static final Logger log = LogManager.getLogger(DaerimOutboundController.class.getName());
  
  @Autowired
  private DaerimOutboundService daerimOutboundService;
  
  @RequestMapping("/daerimOutbound/{page}.*")
  public String page(@PathVariable String page){
    return "/daerimOutbound/"+page;
  }
  
  @RequestMapping("/daerimOutbound/{module}/{page}.*")
  public String mpage(@PathVariable String module, @PathVariable String page){
    
    return "/daerimOutbound/"+module+"/"+page;
  }
  
  @RequestMapping("/daerimOutbound/{module}/{sub}/{page}.*")
  public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
    
    return "/daerimOutbound/"+module+"/"+sub+"/"+page;
  }
  
  //DR01 저장
  @RequestMapping("/daerimOutbound/json/saveDR01.*")
  public String saveDL01(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    DataMap data = daerimOutboundService.saveDR01(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  //DR16 그룹핑
  @RequestMapping("/daerimOutbound/json/groupingDR16.*")
  public String groupingDR16(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    DataMap data = daerimOutboundService.groupingDR16(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }

  //DR16 그룹핑 삭제
  @RequestMapping("/daerimOutbound/json/deleteGrouping.*")
  public String deleteGrouping(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    DataMap data = daerimOutboundService.deleteGrouping(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  //DR19 저장
  @RequestMapping("/daerimOutbound/json/saveDR19.*")
  public String saveDR19(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = daerimOutboundService.saveDR19(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  //DR20 저장
  @RequestMapping("/daerimOutbound/json/saveDR20.*")
  public String saveDR20(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = daerimOutboundService.saveDR20(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  //DR31 저장
  @RequestMapping("/daerimOutbound/json/saveDR31.*")
  public String saveDR31(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = daerimOutboundService.saveDR31(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  //DR30 저장
  @RequestMapping("/daerimOutbound/json/saveDR30.*")
  public String saveDR30(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = daerimOutboundService.saveDR30(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  //DR32 저장
  @RequestMapping("/daerimOutbound/json/saveDR32.*")
  public String saveDR32(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = daerimOutboundService.saveDR32(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  //DR22 동기화
  @RequestMapping("/daerimOutbound/json/saveDR22.*")
  public String saveDR22(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = daerimOutboundService.saveDR22(map); 
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  //DR25 동기화
  @RequestMapping("/daerimOutbound/json/saveDR25.*")
  public String saveDR25(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = daerimOutboundService.saveDR25(map); 
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  @RequestMapping("/daerimOutbound/json/displayDR22.*")
  public String displayDR22(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    Object data = daerimOutboundService.displayDR22(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
}