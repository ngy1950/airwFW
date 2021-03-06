package project.wms.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.controller.BaseController;
import project.wms.service.OutboundService;

@Controller
public class OutboundController extends BaseController {
  
  static final Logger log = LogManager.getLogger(OutboundController.class.getName());
  
  @Autowired
  private OutboundService outboundService;
  
  @RequestMapping("/outbound/{page}.*")
  public String page(@PathVariable String page){
    return "/outbound/"+page;
  }
  
  @RequestMapping("/outbound/{module}/{page}.*")
  public String mpage(@PathVariable String module, @PathVariable String page){
    
    return "/outbound/"+module+"/"+page;
  }
  
  @RequestMapping("/outbound/{module}/{sub}/{page}.*")
  public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
    
    return "/outbound/"+module+"/"+sub+"/"+page;
  }
  
  @RequestMapping("/outbound/json/saveSO01.*")
  public String saveSO01(HttpServletRequest request, Map model) throws SQLException{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = data = outboundService.saveSO01(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/saveSO10.*")
  public String saveSO10(HttpServletRequest request, Map model) throws SQLException{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = data = outboundService.saveSO10(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/saveSH01.*")
  public String saveSH01(HttpServletRequest request, Map model) throws SQLException{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = data = outboundService.saveSH01(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/saveSH01Cancel.*")
  public String saveSH01Cancel(HttpServletRequest request, Map model) throws SQLException{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = data = outboundService.saveSH01Cancel(map);
    
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/saveSH02.*")
  public String saveSH02(HttpServletRequest request, Map model) throws SQLException{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    map.put("ALSTKY", "0000000001");
    
    Object data = data = outboundService.saveSH02(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/saveSH03.*")
  public String saveSH03(HttpServletRequest request, Map model) throws SQLException{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    map.put("ALSTKY", "0000000002");
    
    Object data = data = outboundService.saveSH02(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  @RequestMapping("/outbound/json/saveSH04.*")
  public String saveSH04(HttpServletRequest request, Map model) throws SQLException{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    map.put("ALSTKY", "0000000003");
    
    Object data = data = outboundService.saveSH02(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/savePK01.*")
  public String savePK01(HttpServletRequest request, Map model) throws SQLException{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = data = outboundService.savePK01(map);
    
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/savePK01Cancel.*")
  public String savePK01Cancel(HttpServletRequest request, Map model) throws SQLException{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = data = outboundService.savePK01Cancel(map);
    
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/saveSH30.*")
  public String saveSH30(HttpServletRequest request, Map model) throws SQLException{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = data = outboundService.saveSH30(map);
    
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
	//[DL00] ?????? 
	@RequestMapping("/outbound/json/displayHeadDL00.*")
	public String displayHeadDL00(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayHeadDL00(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

	//[DL00] ?????? 
	@RequestMapping("/outbound/json/displayItemDL00.*")
	public String displayItemDL00(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayItemDL00(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

  @RequestMapping("/outbound/json/saveDL00.*")
  public String saveDL00(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    DataMap data = outboundService.saveDL00(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
	//[DL01] ?????? 
	@RequestMapping("/outbound/json/displayHeadDL01.*")
	public String displayHeadDL01(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayHeadDL01(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//[DL02] ?????? 
	@RequestMapping("/outbound/json/displayHeadDL02.*")
	public String displayHeadDL02(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayHeadDL02(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
  
  @RequestMapping("/outbound/json/saveDL80.*")
  public String saveDL80(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = outboundService.saveDL80(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }

  @RequestMapping("/outbound/json/createOrderDocDL01.*")
  public String createOrderDocDL01(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = outboundService.createOrderDocDL01(map);

    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/allocateDL01.*")
  public String allocateDL01(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = outboundService.allocateDL01(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/createOrderDocDL02.*")
  public String createOrderDocDL02(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = outboundService.createOrderDocDL02(map);

    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/allocateDL02.*")
  public String allocateDL02(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = outboundService.allocateDL02(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }

	//[DL03] ?????? 
	@RequestMapping("/outbound/json/displayHeadDL03.*")
	public String displayHeadDL03(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayHeadDL03(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

	//[DL03] ?????? 
	@RequestMapping("/outbound/json/displayItemDL03.*")
	public String displayItemDL03(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayItemDL03(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

  @RequestMapping("/outbound/json/acceptDL03.*")
  public String acceptDL03(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = outboundService.acceptDL03(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
	//[DL04] ?????? 
	@RequestMapping("/outbound/json/displayHeadDL04.*")
	public String displayHeadDL04(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayHeadDL04(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	  
	//[DL04] ?????? 
	@RequestMapping("/outbound/json/displayItemDL04.*")
	public String displayItemDL04(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayItemDL04(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

  @RequestMapping("/outbound/json/cancelAcceptDL04.*")
  public String cancelAcceptDL04(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = outboundService.cancelAcceptDL04(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/acceptDL05.*")
  public String acceptDL05(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = outboundService.acceptDL05(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/cancelAcceptDL06.*")
  public String cancelAcceptDL06(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = outboundService.cancelAcceptDL06(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/allocateDL07.*")
  public String allocateDL07(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
//    System.out.println("allocateDL07");
    String data = outboundService.allocateDL07(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }

  @RequestMapping("/outbound/json/saveDL10.*")
  public String saveDL10(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.saveDL10(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/saveTodayDL11.*")
  public String saveTodayDL11(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.saveTodayDL11(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }

  @RequestMapping("/outbound/json/autoDL11.*")
  public String autoDL11(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.autoDL11(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
	// GR42 ?????????????????? ??????, ????????? ??????
	@RequestMapping("/outbound/json/printDL11.*")
	public String printDL11(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? ??????
		DataMap data = outboundService.printDL11(map); // ?????? ?????? ????????? ???????????? ???????????? ????????? goodReceiptService??? ??????
		
		model.put("data", data);
		
		return JSON_VIEW;
	}

  @RequestMapping("/outbound/json/closeDL17.*")
  public String closeDL17(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.closeDL17(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
	//[DL23] ?????? 
	@RequestMapping("/outbound/json/displayHeadDL23.*")
	public String displayHeadDL23(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayHeadDL23(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

	  @RequestMapping("/outbound/json/removeDL24.*")
	  public String removeDL24(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.removeDL24(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }  

  @RequestMapping("/outbound/json/confirmOrderDocDL24.*")
  public String confirmOrderDocDL24(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.confirmOrderDocDL24(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/confirmOrderTaskDL24.*")
  public String confirmTaskOrderDL24(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.confirmOrderTaskDL24(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/saveDL26.*")
  public String saveDL26(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.saveDL26(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/removeDL26.*")
  public String removeDL26(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.removeDL26(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }  
  
  @RequestMapping("/outbound/json/unallocateDL26.*")
  public String unallocateDL26(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.unallocateDL26(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }  
  
  @RequestMapping("/outbound/json/confirmOrderDocDL26.*")
  public String confirmOrderDocDL26(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.confirmOrderDocDL26(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }  
  
  @RequestMapping("/outbound/json/allocateDL30.*")
  public String allocateDL30(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = outboundService.allocateDL30(map);
    model.put("data", data);
    
    return JSON_VIEW;
  } 
  
  @RequestMapping("/outbound/json/unallocateDL30.*")
  public String unallocateDL30(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    String data = outboundService.unallocateDL30(map);
    model.put("data", data);
    
    return JSON_VIEW;
  }

  @RequestMapping("/outbound/json/saveDL31.*")
  public String saveDL31(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.saveDL31(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }

  @RequestMapping("/outbound/json/saveDL34.*")
  public String saveDL34(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.saveDL34(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/autoDL34.*")
  public String autoDL34(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.autoDL34(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/auto2DL34.*")
  public String auto2DL34(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.auto2DL34(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/fixedDL34.*")
  public String fixedDL34(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.fixedDL34(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/fixed2DL34.*")
  public String fixed2DL34(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.fixed2DL34(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/confirmOrderDocDL34.*")
  public String confirmOrderDocDL34(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.confirmOrderDocDL34(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
	//[DL35] ?????? 
	@RequestMapping("/outbound/json/displayDL35.*")
	public String displayDL35(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayDL35(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	  
	  @RequestMapping("/outbound/json/saveDL35.*")
	  public String saveDL35(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.saveDL35(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
	  
	  @RequestMapping("/outbound/json/confirmDL35.*")
	  public String confirmDL35(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.confirmDL35(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
	  
	//[DL36] ?????? 
	@RequestMapping("/outbound/json/displayDL36.*")
	public String displayDL36(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayDL35(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

  @RequestMapping("/outbound/json/confirmDL36.*")
  public String confirmDL36(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.confirmDL36(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/deleteDL36.*")
  public String deleteDL36(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.deleteDL36(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
	
  @RequestMapping("/outbound/json/pickingDL40.*")
  public String pickingDL40(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.pickingDL40(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
	@RequestMapping("/outbound/json/closeDL50.*")
	public String closeDL50(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  
	  Object data = outboundService.closeDL50(map);
	  
	  model.put("data", data);
	      
	  return JSON_VIEW;
	}
	  @RequestMapping("/outbound/json/saveDL60.*")
	  public String saveDL60(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.saveDL60(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
	  
	  @RequestMapping("/outbound/json/saveDL61.*")
	  public String saveDL61(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.saveDL61(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
	  
		//[DL62] ?????? 
		@RequestMapping("/outbound/json/displayDL62.*")
		public String displayDL62(HttpServletRequest request, Map model) throws SQLException{		
			DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
			//???????????? 
			List list = outboundService.displayDL62(map);
			
			model.put("data", list);
			
			return JSON_VIEW;
		}

	 
	  @RequestMapping("/outbound/json/saveDL62.*")
	  public String saveDL62(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.saveDL62(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
	  
	  @RequestMapping("/outbound/json/autoDL62.*")
	  public String autoDL62(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.autoDL62(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
	  
	  @RequestMapping("/outbound/json/fixedDL62.*")
	  public String fixedDL62(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.fixedDL62(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
	  
	  @RequestMapping("/outbound/json/icrecarDL62.*")
	  public String icrecarDL62(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.icrecarDL62(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
		//[DL63] ?????? 
		@RequestMapping("/outbound/json/displayDL63.*")
		public String displayDL63(HttpServletRequest request, Map model) throws SQLException{		
			DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
			//???????????? 
			List list = outboundService.displayDL63(map);
			
			model.put("data", list);
			
			return JSON_VIEW;
		}

	 
	  @RequestMapping("/outbound/json/saveDL63.*")
	  public String saveDL63(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.saveDL63(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
	  
	  @RequestMapping("/outbound/json/autoDL63.*")
	  public String autoDL63(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.autoDL63(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
	  
	  @RequestMapping("/outbound/json/fixedDL63.*")
	  public String fixedDL63(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.fixedDL63(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
	  
	  @RequestMapping("/outbound/json/icrecarDL63.*")
	  public String icrecarDL63(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.icrecarDL63(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }


	//[JT01] ?????? 
	@RequestMapping("/OutBoundReport/json/displayJT01.*")
	public String displayJT01(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayJT01(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	  @RequestMapping("/outbound/json/saveTM04.*")
	  public String saveTM04(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.saveTM04(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
	  
	  //[TM05]  ???????????? 
	  @RequestMapping("/outbound/json/displayHeadTM05.*")
	  public String displayHeadTM05(HttpServletRequest request, Map model) throws SQLException{		
		  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		  
		  //???????????? 
		  List list = outboundService.displayHeadTM05(map);
		  
		  model.put("data", list);
		  
		  return JSON_VIEW;
	  }
		//[TM05] ??????????????? 
		@RequestMapping("/outbound/json/displayItemTM05.*")
		public String displayItemTM05(HttpServletRequest request, Map model) throws SQLException{		
			DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
			//???????????? 
			List list = outboundService.displayItemTM05(map);
			
			model.put("data", list);
			
			return JSON_VIEW;
		}
		
	  @RequestMapping("/outbound/json/saveTM05.*")
	  public String saveTM05(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.saveTM05(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }
	  
	  @RequestMapping("/outbound/json/saveTM05return.*")
	  public String saveTM05return(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		String svbeln = map.getString("SVBELN");
		List<DataMap> rslist = map.getList("list");
		
		List<DataMap> list = new ArrayList<DataMap>();
		
		for(int i=0;i<rslist.size();i++){
			DataMap row = rslist.get(i).getMap("map");
			row.put("SVBELN",svbeln);
			list.add(row);
		}
		
		model.put("data", list);
		    
		return JSON_VIEW;
	  }
	  
	  //[TM06]  ???????????? 
	  @RequestMapping("/outbound/json/displayHeadTM06.*")
	  public String displayHeadTM06(HttpServletRequest request, Map model) throws SQLException{		
		  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		  
		  //???????????? 
		  List list = outboundService.displayHeadTM06(map);
		  
		  model.put("data", list);
		  
		  return JSON_VIEW;
	  }
		//[TM06] ??????????????? 
		@RequestMapping("/outbound/json/displayItemTM06.*")
		public String displayItemTM06(HttpServletRequest request, Map model) throws SQLException{		
			DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
			//???????????? 
			List list = outboundService.displayItemTM06(map);
			
			model.put("data", list);
			
			return JSON_VIEW;
		}
	  
	  @RequestMapping("/outbound/json/saveDL85.*")
	  public String saveDL85(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = outboundService.saveDL85(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	  }
	  
	//[DL91] ?????? 
	@RequestMapping("/outbound/json/displayDL91.*")
	public String displayDL91(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayDL91(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	/**
	 * 2020-12-28 DAS??????????????? ?????? cmu
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/outbound/json/createDasFileDL93.*")
	public String createDasFileDL93(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  DataMap data = outboundService.createDasFileDL93(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}

	//[DL95] ?????? 
	@RequestMapping("/outbound/json/displayHeadDL95.*")
	public String displayHeadDL95(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayHeadDL95(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}

	//[DL95] ?????? 
	@RequestMapping("/outbound/json/displayItemDL95.*")
	public String displayItemDL95(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayItemDL95(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	  
	@RequestMapping("/outbound/json/saveDL90.*")
	public String saveDL90(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  String data = outboundService.saveDL90(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}
	
	//[DL99] ?????? 
	@RequestMapping("/outbound/json/saveDL95.*")
	public String saveDL95(HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		Object data = data = outboundService.saveDL95(map);
		
		model.put("data", data);
				
		return JSON_VIEW;
	}
  
  	@Transactional(rollbackFor = Exception.class)
	public String saveDL52(DataMap map) throws Exception {
		List<DataMap> item = map.getList("item");
		String check = map.getString("CHECK");
		
		DataMap result = new DataMap();
		
		try{
			if(check.equals("5")){
				
			}
			
			if(check.equals("8")){
				
			}else{
				
			}

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		
		return "";
	}
	
	
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveShipmentOrderSavedData2(DataMap map) throws Exception {
		List<DataMap> itemList = map.getList("item");
		
		String chk_cardat = ""; //????????????
		String chk_dptnky = ""; //???????????????
		String chk_shpmty = ""; //????????????
		String chk_pgrc02 = ""; //????????????
		String chk_pgrc03 = ""; //????????????
		String chk_docseq = ""; //??????????????? ???????????? 
		String docseq = "";
		
		try{
			for(DataMap item : itemList){
				DataMap row = item.getMap("map");
				
				DataMap upParams = new DataMap();
				
				upParams.put("SHPOKY", row.getString("SHPOKY"));
				upParams.put("CARNUM", row.getString("CARNUM"));
				upParams.put("CARDAT", row.getString("CARDAT"));
				upParams.put("SHIPSQ", row.getString("SHIPSQ"));
				
				if(row.getString("DOCSEQ").equals(" ") && (!row.getString("SHPMTY").equals("213") && !row.getString("SHPMTY").equals("214")) 
						                               && (!row.getString("PGRC03").equals("004") && !row.getString("PGRC02").equals("02"))){
//				    - ????????????(SHPMTY) : 213 ????????????/214 ???????????? /	 - ????????????(PGRC03) : 4 ??????EDI - ???????????? : 02 ?????? ?????? ?????? 
					if(row.getString("CARDAT").equals(chk_cardat)&&
					   row.getString("DPTNKY").equals(chk_dptnky)&&
					   row.getString("SHPMTY").equals(chk_shpmty)&&
					   row.getString("PGRC03").equals(chk_pgrc03)&&
					   row.getString("PGRC02").equals(chk_pgrc02)){
						// ????????????, ???????????????, ????????????, ????????????, ??????????????? ?????? ??????
						
						upParams.put("DOCSEQ", chk_docseq);
					}else{
					// *** ????????? ?????? ???.. ?????????
						
					}
					
				}
			}
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		
		return null;
	}
	
	@RequestMapping("/outbound/json/saveTO20.*")
	public String saveTO20(HttpServletRequest request, Map model) throws Exception{
	  DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	  String data = outboundService.saveTO20(map);
	  model.put("data", data);
	  
	  return JSON_VIEW;
	}
    
  @RequestMapping("/outbound/json/pickingTO30.*")
  public String pickingTO30(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.pickingTO30(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
  @RequestMapping("/outbound/json/saveDL36.*")
  public String saveDL36(HttpServletRequest request, Map model) throws Exception{
    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
    
    Object data = outboundService.saveDL36(map);
    
    model.put("data", data);
        
    return JSON_VIEW;
  }
  
	//[DL01] ?????? - ?????????
	@RequestMapping("/outbound/json/displayItemDL34.*")
	public String displayItemDL34(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//???????????? 
		List list = outboundService.displayItemDL34(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}	
	

	  @RequestMapping("/outbound/json/saveDL30POP.*")
	  public String saveDL30POP(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.saveDL30POP(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }

	  
	  @RequestMapping("/outbound/json/removeDL30.*")
	  public String removeDL30(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.removeDL30(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }  

	  
	  @RequestMapping("/outbound/json/allocateDL19.*")
	  public String allocateDL19(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = outboundService.allocateDL19(map);
	    model.put("data", data);
	    
	    return JSON_VIEW;
	  }

	  @RequestMapping("/outbound/json/createOrderDocDL19.*")
	  public String createOrderDocDL19(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    String data = outboundService.createOrderDocDL19(map);

	    model.put("data", data);
	    
	    return JSON_VIEW;
	  }
	  
	  @RequestMapping("/outbound/json/saveDL31Dialog2.*")
	  public String saveDL31Dialog2(HttpServletRequest request, Map model) throws Exception{
	    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
	    
	    Object data = outboundService.saveDL31Dialog2(map);
	    
	    model.put("data", data);
	        
	    return JSON_VIEW;
	  }

	  
		//[DL00] ?????? 
		@RequestMapping("/outbound/json/displayHeadDL00Save.*")
		public String displayHeadDL00Save(HttpServletRequest request, Map model) throws SQLException{		
			DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
			
			//???????????? 
			List list = outboundService.displayHeadDL00Save(map);
			
			model.put("data", list);
			
			return JSON_VIEW;
		}

		  @RequestMapping("/outbound/json/test.*")
		  public String test(HttpServletRequest request, Map model) throws SQLException{
		    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		    
		    Object data = data = outboundService.test(map);
		    
		    model.put("data", data);
		        
		    return JSON_VIEW;
		  }
		  
		  @RequestMapping("/outbound/json/allocateDL01SO.*")
		  public String allocateDL01SO(HttpServletRequest request, Map model) throws Exception{
		    DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		    String data = outboundService.allocateDL01SO(map);
		    model.put("data", data);
		    
		    return JSON_VIEW;
		  }

			
			//[DL09] ????????? ?????? ??????
			@RequestMapping("/OutBoundReport/json/deleteNewDL09.*")
			public String deleteNewDL88(HttpServletRequest request, Map model) throws Exception{		
				DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
					
				//???????????? 
				String data = outboundService.deleteNewDL09(map);
				
				model.put("data", data);
					
				return JSON_VIEW;
			}
			
			//[DL88] ?????????????????? ??????
			@RequestMapping("/OutBoundReport/json/deletePalDL09.*")
			public String deletePalDL88(HttpServletRequest request, Map model) throws Exception{		
				DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
					
				//???????????? 
				String data = outboundService.deletePalDL09(map);
				
				model.put("data", data);
					
				return JSON_VIEW;
			}
}