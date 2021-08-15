package project.wms.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;


import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.util.ComU;
import project.common.util.SqlUtil;
import project.common.util.StringUtil;

import java.net.URL;

@Service
public class DaerimReportService extends BaseService {
	
	static final Logger log = LogManager.getLogger(DaerimReportService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;
	
	@Transactional(rollbackFor = Exception.class)
	public List displayDR14Item(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		
		if (map.getString("PTNRTY").equals("0001")){//매출처
			map.setModuleCommand("DaerimReport", "DR14_ITEM");
		} else if (map.getString("PTNRTY").equals("0007")){//납품처 
			map.setModuleCommand("DaerimReport", "DR14_ITEM2");
		}
				
		List<DataMap> list = commonDao.getList(map);

		return list;
	}
	
	// [DR14] 프린트
		@Transactional(rollbackFor = Exception.class)
	public DataMap saveDR14(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headlist = map.getList("headlist");
		List<DataMap> itemlist = new ArrayList<DataMap>();
		String key = "";
		String itemquery = map.getString("itemquery");
		StringBuffer keys = new StringBuffer();
		DataMap dMap = new DataMap();
		
		DataMap itemTemp = map.getMap("tempItem");
		if(!map.getList("list").isEmpty()){
			itemlist = map.getList("list");
			key = itemlist.get(0).getMap("map").getString("KEY");
		}
		
		try {
			
			for(int i=0;i<headlist.size();i++){
				DataMap head = headlist.get(i).getMap("map");
				List<DataMap> list = new ArrayList<DataMap>();
				
				if(key.equals(head.getString("KEY"))){
					list = itemlist;
				}else if(itemTemp.containsKey(head.getString("KEY")) ){
					list = itemTemp.getList(head.getString("KEY"));
				}
				
				if(list.size() == 0){
					//dMap = 해드 + 검색조건
					head.put("menuId",map.getString("menuId"));
					dMap = (DataMap)map.clone();
					dMap.putAll(head);
					dMap.setModuleCommand("DaerimReport", itemquery);
					list = commonDao.getList(dMap);
					
				}
				
				for(int j=0;j<list.size();j++){
					DataMap item = list.get(j).getMap("map");
					map.put("PTNG08", item.getString("PTNG08"));
					
					
					map.setModuleCommand("DaerimReport", "DR14_PRINT");
					commonDao.update(map);
					
					if (item.getString("TEXT02").trim().equals("") || item.getString("TEXT02") == null) {
					
						item.setModuleCommand("DaerimReport", "DR14_PRINT");
						commonDao.update(item);
						
						if(map.getString("PTNRTY").equals("0001")){ //매출처
							map.setModuleCommand("DaerimReport", "P_ORDER_GROUPING_PTNROD"); //TEXT02 에 거래명세표출력번호 INSERT
							commonDao.update(map);
						
						}else if(map.getString("PTNRTY").equals("0007")){ //납품처
							map.setModuleCommand("DaerimReport", "P_ORDER_GROUPING_PTNRTO"); //TEXT02 에 거래명세표출력번호 INSERT	
							commonDao.update(map);
						}
						
					}
					
					if("".equals(keys.toString())){
						keys.append("'").append(item.getString("PTNRKY")).append("'");
					}else{
						keys.append(",'").append(item.getString("PTNRKY")).append("'");
					}
					
				}
				
				
			}
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
				
			
		rsMap.put("SAVEKEY", keys);		
	
			
		return rsMap;
	}
		
		
	
}