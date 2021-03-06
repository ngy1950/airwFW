package project.wms.controller;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.controller.BaseController;
import project.common.service.CommonService;
import project.system.comtroller.SystemController;
import project.wms.service.OutBoundReportService;

@Controller
public class OutBoundReportController extends BaseController {
	
	
	static final Logger log = LogManager.getLogger(OutBoundReportController.class.getName());

	@Autowired
	private CommonService commonService;
	
	@Autowired
	private OutBoundReportService outBoundReportService;
		
	
	//[DL51] 프린트
	@RequestMapping("/OutBoundReport/json/saveDL51.*")
	public String saveDL51(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String check = map.getString("CHECK");
		
		if (check.equals("5")){//해표 통합송장발행
			DataMap data = outBoundReportService.save2DL51(map);
			model.put("data", data);
		} else if(check.equals("8")){//대림 통합송장발행
			DataMap data = outBoundReportService.save3DL51(map);
			model.put("data", data);
		} else {
			DataMap data = outBoundReportService.saveDL51(map);
			model.put("data", data);
		}
		
		return JSON_VIEW;
	} 
	
	//[DL52]save 프린트
	@RequestMapping("/OutBoundReport/json/saveDL52.*")
	public String saveDL52(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		DataMap data = outBoundReportService.saveDL52(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//[DL33] 조회 
	@RequestMapping("/OutBoundReport/json/displayDL33.*")
	public String displayDL33(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = outBoundReportService.displayDL33(map);
		//List list = commonService.getList("OutBoundReport.DL33", map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
/*	//[DL41] 조회 
	@RequestMapping("/OutBoundReport/json/displayDL41.*")
	public String displayDL41(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = outBoundReportService.displayDL41(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	*/
	//[DL97] 조회 
	@RequestMapping("/OutBoundReport/json/displayDL97.*")
	public String displayDL97(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = outBoundReportService.displayDL97(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	//[DL97] 조회 
	@RequestMapping("/OutBoundReport/json/displayDL97Item.*")
	public String displayDL97Item(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = outBoundReportService.displayDL97Item(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	//[DL97] 저장 
	@RequestMapping("/OutBoundReport/json/saveDL97.*")
	public String saveDL97(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = outBoundReportService.saveDL97(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	
	//[DL98] 조회 
	@RequestMapping("/OutBoundReport/json/displayDL98.*")
	public String displayDL98(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = outBoundReportService.displayDL98(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
		
	//[DL99] 조회 
	@RequestMapping("/OutBoundReport/json/displayDL99.*")
	public String displayDL99(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = outBoundReportService.displayDL99(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	//[DL99] 아이템조회 
	@RequestMapping("/OutBoundReport/json/displayDL99Item.*")
	public String displayDL99Item(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = outBoundReportService.displayDL99Item(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	//[DL99] 저장 
	@RequestMapping("/OutBoundReport/json/saveDL99.*")
	public String saveDL99(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = outBoundReportService.saveDL99(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
	
	//[DL55] 조회 
	@RequestMapping("/OutBoundReport/json/displayDL55.*")
	public String displayDL55(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
		//조회쿼리 
		List list = outBoundReportService.displayDL55(map);
		
		model.put("data", list);
			
		return JSON_VIEW;
	}
	
	
	//[DL99] 아이템조회 
	@RequestMapping("/OutBoundReport/json/displayDL55Item.*")
	public String displayDL55Item(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = outBoundReportService.displayDL55Item(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/OutBoundReport/json/displayDL84.*")
	public String saveDL84(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    List list = outBoundReportService.displayDL84(map);
	    model.put("data", list);
	    
	    return JSON_VIEW;
	 }
	
	//[DL88] 부족수량 오더 리스트(All) 
	@RequestMapping("/OutBoundReport/json/displayDL88Item2.*")
	public String displayDL88_grid2(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
				
		//조회쿼리 
		List list = outBoundReportService.displayDL88Item2(map);
			
		model.put("data", list);
				
		return JSON_VIEW;
	}
	
	//[DL88] 오더 리스트(All)
	@RequestMapping("/OutBoundReport/json/displayDL88Item3.*")
	public String displayDL88_grid3(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
				
		//조회쿼리 
		List list = outBoundReportService.displayDL88Item3(map);
			
		model.put("data", list);
				
		return JSON_VIEW;
	}
	
/*	//[DL88] WMS Shipment 리스트 조회 
	@RequestMapping("/OutBoundReport/json/displayDL88Item4.*")
	public String displayDL88_grid4(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
				
		//조회쿼리 
		List list = outBoundReportService.displayDL88Item4(map);
			
		model.put("data", list);
				
		return JSON_VIEW;
	}*/
	
	//[DL88] 오더 리스트(All) 할당
	@RequestMapping("/OutBoundReport/json/allocSaveDL88.*")
	public String allocSaveDL88(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
		//조회쿼리 
		List list = outBoundReportService.allocSaveDL88(map);
		
		model.put("data", list);
			
		return JSON_VIEW;
	}
	
	//[DL88] 미작업 삭제 저장
	@RequestMapping("/OutBoundReport/json/deleteNewDL88.*")
	public String deleteNewDL88(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
		//조회쿼리 
		List data = outBoundReportService.deleteNewDL88(map);
		
		model.put("data", data);
			
		return JSON_VIEW;
	}
	
	//[DL88] 부분할당삭제 저장
	@RequestMapping("/OutBoundReport/json/deletePalDL88.*")
	public String deletePalDL88(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
		//조회쿼리 
		List data = outBoundReportService.deletePalDL88(map);
		
		model.put("data", data);
			
		return JSON_VIEW;
	}
	
	//[DL88] 전체삭제 저장
	@RequestMapping("/OutBoundReport/json/deleteDL88.*")
	public String deleteDL88(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
		//조회쿼리 
		List data = outBoundReportService.deleteDL88(map);
		
		model.put("data", data);
			
		return JSON_VIEW;
	}
	
	//[DL88] 할당 저장
	@RequestMapping("/OutBoundReport/json/realLocDL88.*")
	public String realLocDL88(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
		//조회쿼리 
		List data = outBoundReportService.realLocDL88(map);
		
		model.put("data", data);
			
		return JSON_VIEW;
	}
	
	//[DL88] 할당취소 저장
	@RequestMapping("/OutBoundReport/json/unalLocDL88.*")
	public String unalLocDL88(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
		//조회쿼리 
		List data = outBoundReportService.unalLocDL88(map);
		
		model.put("data", data);
			
		return JSON_VIEW;
	}
	
	//[DL88] D/O전송 저장
	@RequestMapping("/OutBoundReport/json/drelinDL88.*")
	public String drelinDL88(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
		//조회쿼리 
		List data = outBoundReportService.drelinDL88(map);
		
		model.put("data", data);
			
		return JSON_VIEW;
	}
	
	//[DL88] 조회 
	@RequestMapping("/OutBoundReport/json/displayDL88Head.*")
	public String displayDL88(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
		//조회쿼리 
		List list = outBoundReportService.displayDL88(map);
		
		model.put("data", list);
			
		return JSON_VIEW;
	}

	
	//[DL88] 오더 리스트(All) 할당
	@RequestMapping("/OutBoundReport/json/allocateSODL88.*")
	public String allocateSODL88(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
		//조회쿼리 
		List list = outBoundReportService.allocateSODL88(map);
		
		model.put("data", list);
			
		return JSON_VIEW;
	}
}