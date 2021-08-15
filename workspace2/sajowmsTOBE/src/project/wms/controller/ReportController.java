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
import project.wms.service.OutboundService;
import project.wms.service.ReportService;

@Controller
public class ReportController extends BaseController {
  
  static final Logger log = LogManager.getLogger(ReportController.class.getName());
  
  
  @Autowired
  private CommonService commonService;
  
  @Autowired
  private ReportService reportService;
  
  
  
  @RequestMapping("/Report/{page}.*")
  public String page(@PathVariable String page){
    return "/Report/"+page;
  }
  
  @RequestMapping("/Report/{module}/{page}.*")
  public String mpage(@PathVariable String module, @PathVariable String page){
    
    return "/Report/"+module+"/"+page;
  }
  
  @RequestMapping("/Report/{module}/{sub}/{page}.*")
  public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
    
    return "/Report/"+module+"/"+sub+"/"+page;
  }
  
  
  @RequestMapping("/Report/json/RL00.data")
  public String getListRL00(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = reportService.getListRL00(map);
		//List list = commonService.getList("OutBoundReport.DL33", map);
		
		model.put("data", list);
		
		return JSON_VIEW;
  }
  
  @RequestMapping("/Report/json/RL06.data")
  public String getListRL06(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = reportService.getListRL06(map);
		//List list = commonService.getList("OutBoundReport.DL33", map);
		
		model.put("data", list);
		
		return JSON_VIEW;
  }
  
  @RequestMapping("/Report/json/RL07_01.data")
  public String getListRL07_01(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = reportService.getListRL07_01(map);
		//List list = commonService.getList("OutBoundReport.DL33", map);
		
		model.put("data", list);
		
		return JSON_VIEW;
  }
  
  @RequestMapping("/Report/json/RL07_02.data")
  public String getListRL07_02(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = reportService.getListRL07_02(map);
		//List list = commonService.getList("OutBoundReport.DL33", map);
		
		model.put("data", list);
		
		return JSON_VIEW;
  }
  
  @RequestMapping("/Report/json/RL07_03.data")
  public String getListRL07_03(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = reportService.getListRL07_03(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
  }
  
  @RequestMapping("/Report/json/RL23_01.data")
  public String getListRL23_01(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = reportService.getListRL23_01(map);
		//List list = commonService.getList("OutBoundReport.DL33", map);
		
		model.put("data", list);
		
		return JSON_VIEW;
  }
  
  @RequestMapping("/Report/json/RL23_02.data")
  public String getListRL23_02(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = reportService.getListRL23_02(map);
		//List list = commonService.getList("OutBoundReport.DL33", map);
		
		model.put("data", list);
		
		return JSON_VIEW;
  }
  
  @RequestMapping("/Report/json/displayRL21_1.data")
  public String displayRL21_1(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = reportService.displayRL21_1(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
  }
  @RequestMapping("/Report/json/displayRL21_2.data")
  public String displayRL21_2(HttpServletRequest request, Map model) throws Exception{		
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  //조회쿼리 
	  List list = reportService.displayRL21_2(map);
	  
	  model.put("data", list);
	  
	  return JSON_VIEW;
  }
  
  @RequestMapping("/Report/json/displayRL21_3.data")
  public String displayRL21_3(HttpServletRequest request, Map model) throws Exception{		
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  //조회쿼리 
	  List list = reportService.displayRL21_3(map);
	  
	  model.put("data", list);
	  
	  return JSON_VIEW;
  } 
  
  //[SU01] WMS_SAP 수불 - 실행(프로시저)
  @RequestMapping("/Report/json/excuteSU01.*")
  public String excuteSU01(HttpServletRequest request, Map model) throws SQLException {
	  DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  DataMap result = reportService.excuteSU01(map);
	  
	  model.put("data", result);
	  
	  return JSON_VIEW;
  } // end excuteSU01()
  
  @RequestMapping("/Report/json/displayRL25.data")
  public String displayRL25(HttpServletRequest request, Map model) throws Exception{		
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  //조회쿼리 
	  List list = reportService.displayRL25(map);
	  
	  model.put("data", list);
	  
	  return JSON_VIEW;
  }
  
  @RequestMapping("/Report/json/moveRL09.data")
  public String moveRL09(HttpServletRequest request, Map model) throws Exception{		
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  //조회쿼리 
	  DataMap data = reportService.moveRL09(map);
	  
	  model.put("data", data);
	  
	  return JSON_VIEW;
  }

	//[SD04] 배차이력조회
  	@RequestMapping("/Report/json/displaySD04.*")
	public String displayOY24Item(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = reportService.displaySD04(map);		
		model.put("data", list);
		
		return JSON_VIEW;
	}

	//[RL38] 리포트
	@RequestMapping("/outbound/json/displayRL38.*")
	public String displayRL38(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = reportService.displayRL38(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

	//[HP28] 조회
	@RequestMapping("/Report/json/displayHP28.*")
	public String displayHP28(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = reportService.displayHP28(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

	//[HP22] 조회
	@RequestMapping("/Report/json/displayHP22.*")
	public String displayHP22(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = reportService.displayHP22(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

	//[HP26] 조회
	@RequestMapping("/Report/json/displayHP26.*")
	public String displayHP26(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = reportService.displayHP26(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//[HP34]  저장
	@RequestMapping("/Report/json/saveHP34.*")
	public String saveHP34(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  String data = reportService.saveHP34(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}
	
}