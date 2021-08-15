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
import project.wms.service.OyangOutboundService;
import project.wms.service.OyangReportService;
import project.wms.service.OyangSalesService;

@Controller
public class OyangReportController extends BaseController {
	
	static final Logger log = LogManager.getLogger(OyangReportController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private OyangReportService oyangReportService;


	@RequestMapping("/OyangReport/{page}.*")
	public String page(@PathVariable String page){
		return "/OyangReport/"+page;
	}
	
	@RequestMapping("/OyangReport/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/OyangReport/"+module+"/"+page;
	}
	
	@RequestMapping("/OyangReport/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/OyangReport/"+module+"/"+sub+"/"+page;
	}
	
	//[OY08] 피킹리스트 (코스)save 
	@RequestMapping("/OyangReport/json/saveOY08.*")
	public String saveOY08(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = oyangReportService.saveOY08(map);
		model.put("data", data);
		String check = map.getString("CHECK");
	
		return JSON_VIEW;
		
	}
	
	//[OY09] save 
	@RequestMapping("/OyangReport/json/saveOY09.*")
	public String saveOY09(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = oyangReportService.saveOY09(map);
		model.put("data", data);
		String check = map.getString("CHECK");
		
		return JSON_VIEW;
		
	}

	//[OY17] 아이템  조회 
	@RequestMapping("/OyangReport/json/displayOY17.*")
	public String displayOY17(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = oyangReportService.displayOY17(map);		
		model.put("data", list);
		
		return JSON_VIEW;
	}
		
	
	//[OY17] 거래명세표 출력 save
	@RequestMapping("/OyangReport/json/saveOY17.*")
	public String saveOY17(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = oyangReportService.saveOY17(map);
		model.put("data", data);
	
		return JSON_VIEW;
	}
	
	
	//[OY24] 아이템  조회  RangeSearch2
	@RequestMapping("/OyangReport/json/displayOY24Item.*")
	public String displayOY24Item(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = oyangReportService.displayOY24Item(map);		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//[OY24] 헤더 조회  RangeSearch1
		@RequestMapping("/OyangReport/json/displayOY24.*")
		public String displayOY24(HttpServletRequest request, Map model) throws Exception{		
			DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			//조회쿼리 
			List list = oyangReportService.displayOY24(map);		
			model.put("data", list);
			
			return JSON_VIEW;
		}
		
	//[OY25] RangeSearch1 OY25_1
	@RequestMapping("/OyangReport/json/displayOY25.*")
	public String displayOY25(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = oyangReportService.displayOY25(map);		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//[OY25] RangeSearch1 OY25_2
	@RequestMapping("/OyangReport/json/display2OY25.*")
	public String display2OY25(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = oyangReportService.display2OY25(map);		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//[OY25] RangeSearch1 OY25_3
	@RequestMapping("/OyangReport/json/display3OY25.*")
	public String display3OY25(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = oyangReportService.display3OY25(map);		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//[OY25] RangeSearch1 OY25_4
	@RequestMapping("/OyangReport/json/display4OY25.*")
	public String display4OY25(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = oyangReportService.display4OY25(map);		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//[OY26] RangeSearch1,2 (헤더)
	@RequestMapping("/OyangReport/json/displayOY26Head.*")
	public String displayOY26Head(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = oyangReportService.displayOY26Head(map);		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//[OY26] RangeSearch3 (아이템)
	@RequestMapping("/OyangReport/json/displayOY26Item.*")
	public String displayOY26Item(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = oyangReportService.displayOY26Item(map);		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//OY26 저장
	  @RequestMapping("/OyangReport/json/saveOY26.*")
	  public String saveOY26(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    DataMap data = oyangReportService.saveOY26(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	  }
	  
	//[OY10] 피킹리스트 (코스)save 
	@RequestMapping("/OyangReport/json/saveOY10.*")
	public String saveOY10(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = oyangReportService.saveOY10(map);
		model.put("data", data);
		String check = map.getString("CHECK");
	
		return JSON_VIEW;
		
	}
		
	//[OY11] 피킹리스트(양산) 조회
	@RequestMapping("/OyangReport/json/displayOY11.*")
	public String displayOY11(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
				
		//조회쿼리 
		List list = oyangReportService.displayOY11(map);
				
		model.put("data", list);
				
		return JSON_VIEW;
	}
		
	//[OY11] 피킹리스트(양산) 아이템 조회
	@RequestMapping("/OyangReport/json/displayOY11Item.*")
	public String displayOY11Item(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
		//조회쿼리 
		List list = oyangReportService.displayOY11Item(map);
			
		model.put("data", list);
			
		return JSON_VIEW;
	}
	//[OY11] 피킹리스트(양산)save 
	@RequestMapping("/OyangReport/json/saveOY11.*")
	public String saveOY11(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = oyangReportService.saveOY11(map);
		model.put("data", data);
	
		return JSON_VIEW;
	}
	
	//[OY12] 거래명세표(오양)save 
	@RequestMapping("/OyangReport/json/saveOY12.*")
	public String saveOY12(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = oyangReportService.saveOY12(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	//[OY12] displayOY12_ASN
	@RequestMapping("/OyangReport/json/displayOY12_ASN.*")
	public String displayOY12_ASN(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		//조회쿼리 
		List list = oyangReportService.displayOY12_ASN(map);		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//[OY12] saveOY12_ASN
	@RequestMapping("/OyangReport/json/saveOY12_ASN.*")
	public String saveOY12_ASN(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		DataMap data = oyangReportService.saveOY12_ASN(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	
}