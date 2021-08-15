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
import org.springframework.web.bind.annotation.RequestMapping;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.controller.BaseController;
import project.wms.service.SajoInboundService;

@Controller
public class SajoInboundController extends BaseController {

	static final Logger log = LogManager.getLogger(SajoInboundController.class.getName());

	@Autowired
	private SajoInboundService sajoinboundService;

	@RequestMapping("/inbound/json/saveReceive.*")
	public String saveReceive(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = data = sajoinboundService.saveReceive(map);

		model.put("data", data);

		return JSON_VIEW;
	}

	// [GR30] 헤드 조회
	@RequestMapping("/SajoInbound/json/displayGR30.*")
	public String displayGR30(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		// 조회쿼리
		List list = sajoinboundService.displayGR30(map);

		model.put("data", list);

		return JSON_VIEW;
	}

	// [GR30] 아이템 조회
	@RequestMapping("/SajoInbound/json/displayGR30Item.*")
	public String displayGR30Item(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		// 조회쿼리
		List list = sajoinboundService.displayGR30Item(map);

		model.put("data", list);

		return JSON_VIEW;
	}

	// [GR30] 저장
	@RequestMapping("/SajoInbound/json/saveGR30.*")
	public String saveGR30(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = data = sajoinboundService.saveGR30(map);

		model.put("data", data);

		return JSON_VIEW;
	}
	
	// [GR30] 저장 후 헤드 조회
	@RequestMapping("/SajoInbound/json/returnGR30.*")
	public String returnGR30(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		// 조회쿼리
		List list = sajoinboundService.returnGR30(map);

		model.put("data", list);

		return JSON_VIEW;
	}

	// [GR30] 저장 후 아이템 조회
	@RequestMapping("/SajoInbound/json/returnGR30Item.*")
	public String returnGR30Item(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		// 조회쿼리
		List list = sajoinboundService.returnGR30Item(map);

		model.put("data", list);

		return JSON_VIEW;
	}
	
	//[GR20] 조회 
	@RequestMapping("/SajoInbound/json/displayGR20.*")
	public String displayGR20(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = sajoinboundService.displayGR20(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	//[GR20] 아이템 조회 
	@RequestMapping("/SajoInbound/json/displayGR20Item.*")
	public String displayGR20Item(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = sajoinboundService.displayGR20Item(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	// [GR21] 저장
	@RequestMapping("/SajoInbound/json/saveGR20.*")
	public String saveGR20(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = data = sajoinboundService.saveGR20(map);

		model.put("data", data);

		return JSON_VIEW;
	}
	
	//[GR20] 아이템 조회 
	@RequestMapping("/SajoInbound/json/displayGR21Item.*")
	public String displayGR21Item(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = sajoinboundService.displayGR21Item(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	/**[GR21 PO 관리(제품별) PO 마감 로직
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/SajoInbound/json/saveGR21.*")
	public String saveGR21(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = data = sajoinboundService.saveGR21(map);

		model.put("data", data);

		return JSON_VIEW;
	}	
	
	/**
	 * [GR61] 생산입고 취소 저장
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/SajoInbound/json/saveGR61.*")
	public String saveGR61(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = data = sajoinboundService.saveGR61(map);

		model.put("data", data);

		return JSON_VIEW;
	}
	
	
	/**
	 * PT01 TAB1 선택시
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/SajoInbound/json/displayPT01Choose.*")
	public String displayPT01Choose(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = sajoinboundService.displayPT01Choose(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	/**
	 * 던진 리스트 다시 돌려주기
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/SajoInbound/json/dispalyRetrun.*")
	public String dispalyRetrun(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		List<DataMap> list = map.getList("list");
		
		List<DataMap> retrunlist = new ArrayList<DataMap>();
		for(int i=0;i<list.size();i++){
			retrunlist.add(list.get(i).getMap("map"));
		}
		
		List relist = retrunlist;
		
		model.put("data", retrunlist);
		
		return JSON_VIEW;
	}
	
	/**
	 * [GR46] 회수지시
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/SajoInbound/json/saveCallback.*")
	public String saveCallback(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = data = sajoinboundService.saveCallback(map);

		model.put("data", data);

		return JSON_VIEW;
	}
	
	/**
	 * [GR46] 정상재고변경
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/SajoInbound/json/saveGR46Adjdh.*")
	public String saveGR46Adjdh(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = data = sajoinboundService.saveGR46Adjdh(map);

		model.put("data", data);

		return JSON_VIEW;
	}
	
	/**
	 * [GR47] 입고후 기타 출고
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/SajoInbound/json/saveGR47disposal.*")
	public String saveGR47disposal(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = data = sajoinboundService.saveGR47disposal(map);

		model.put("data", data);

		return JSON_VIEW;
	}
	
	

	
	
	/**
	 * PT01 TAB2 선택시
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/SajoInbound/json/autoPal.*")
	public String autoPal(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = sajoinboundService.autoPal(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	/**
	 * PT01 TAB2 선택시
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/SajoInbound/json/saveTaskData.*")
	public String saveTaskData(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = sajoinboundService.saveTaskData(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	/**
	 * PT01 TAB2 선택시
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/SajoInbound/json/saveTaskConfirm.*")
	public String saveTaskConfirm(HttpServletRequest request, Map model) throws Exception{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		//조회쿼리 
		List list = sajoinboundService.saveTaskConfirm(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	
	@RequestMapping("/inbound/json/savePT02.*")
	public String savePT02(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = data = sajoinboundService.savePT02(map);

		model.put("data", data);

		return JSON_VIEW;
	}

	//GR40 저장
	@RequestMapping("/inbound/json/saveReturned.*")
	public String saveReturned(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap) request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		Object data = data = sajoinboundService.saveReturned(map);

		model.put("data", data);

		return JSON_VIEW;
	}
}