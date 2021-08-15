package project.wdscm.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.util.ComU;
import project.common.util.StringUtil;

@Service
public class SJ10Service extends BaseService {
	
	static final Logger log = LogManager.getLogger(SJ10Service.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
/*
	@Transactional(rollbackFor = Exception.class)
	public List<DataMap> SJ10List(DataMap map) throws SQLException {
		DataMap itemData = new DataMap();
		DataMap temp_Data = new DataMap();
		
		List<DataMap> list = new ArrayList();
		
		// column 선언
		String [] column = {"SADJKY","OWNRKY","WAREKY","ADJUTY","DOCDAT","LOCAKY","PACKID",
							"DUOMKY","SKUKEY","DESC01","LOTA06","QTADJU","LOTA11","LOTA12","LOTA13"};

		try{
			map.setModuleCommand("SJ10", "SJ10_HEAD");		
			List<DataMap> SJ10List = commonDao.getList(map);
			
			if(SJ10List.size() < 0){
				((DataMap) list).put("RESULT", "F1");
				return list;
			}
			
			for(DataMap item : SJ10List){
				itemData = item.getMap("map");
				int count = 0;
				
				for(int i=0; i<column.length; i++){
					if(!temp_Data.isEmpty() && itemData.get(column[i]).equals(temp_Data.get(column[i]))){ // 조회 데이터 그룹핑 처리
						itemData.put(column[i], "");
						count++;
					}
				}
				
				if(count > 0){
					list.add(itemData);
				}else{
					list.add(temp_Data);
				}
				temp_Data.clone();
				temp_Data = item.getMap("map");
			}
			
		}catch (Exception e){
			throw new SQLException(e.getMessage());
		}
		
		return list;
	}
*/
}