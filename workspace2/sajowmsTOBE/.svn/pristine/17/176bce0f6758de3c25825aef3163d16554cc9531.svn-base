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

import java.net.URL;

@Service
public class LabelPrintService extends BaseService {
	
	static final Logger log = LogManager.getLogger(LabelPrintService.class.getName());
	
	@Autowired
	public CommonDAO commonDao;
	
	@Autowired
	private CommonService commonService;
	
	//LB01 
	@Transactional(rollbackFor = Exception.class)
	public DataMap printLB01(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
//			CHECKBARCODE
			DataMap param = new DataMap();
			param.put("WAREKY", map.getString("WAREKY"));
			param.put("RETURN", "");
			
			param.setModuleCommand("LabelPrint", "CHECKBARCODE");
			commonDao.update(param);
			
			String sequence = param.getString("RETURN");
			
//			System.out.println("return == ?>>> " + sequence);
			
			map.put("REFDKY", sequence);
			
			//INSERT 구현 
			int prtcnt = map.getInt("PRINTCNT");

			for(int  i = 0; i < prtcnt ; i++){
				map.setModuleCommand("LabelPrint", "LB01");
				commonDao.insert(map);
				count++;
			}
			
			if(count > 0 ){
				rsMap.put("REFDKY",sequence);
			}
			
		} catch (Exception e) {
			// throw new Exception( ComU.getLastMsg(e.getMessage()) );
			//throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "출력할 수 없는 바코드입니다. \n시스템즈에 문의해주세요.", new String[]{}));
			String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_P0001",new String[]{""});
			throw new Exception("*"+ msg + "*");
		}
		
		rsMap.put("CNT", count);
		return rsMap;
	}
	
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public DataMap printAS09(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		List<DataMap> headlist = map.getList("headlist");
		List<DataMap> itemlist = new ArrayList<DataMap>();
		String key = "";
		String itemquery = map.getString("itemquery");
		StringBuffer keys = new StringBuffer();
		DataMap dMap = new DataMap();
		String wareky = headlist.get(0).getMap("map").getString("WAREKY");
		String sequence = "";
		int printCnt = 0;
		
		DataMap itemTemp = map.getMap("tempItem");
		if(!map.getList("list").isEmpty()){
			itemlist = map.getList("list");
			key = itemlist.get(0).getMap("map").getString("KEY");
		}
		
		int count = 0;
		
		try {
			
			
			for(int i=0;i<headlist.size();i++){
				DataMap head = headlist.get(i).getMap("map");
				map.clonSessionData(head);
				 
				DataMap param = new DataMap();
				param.put("WAREKY", wareky);
				param.put("RETURN", "");
				
				param.setModuleCommand("LabelPrint", "CHECKBARCODE");
				commonDao.update(param);
				
				sequence = param.getString("RETURN");
				
				List<DataMap> list = new ArrayList<DataMap>();
				
				if(key.equals(head.getString("KEY"))){
					list = itemlist;
				}else if(itemTemp.containsKey(head.getString("KEY")) ){
					list = itemTemp.getList(head.getString("KEY"));
				}
				
				if(list.size() == 0){
					//dMap = 해드 + 검색조건
					dMap = (DataMap)map.clone();
					dMap.putAll(head);
					dMap.setModuleCommand("AdvancedShipmentNotice", "AS09_ITEM_LIST");
					list = commonDao.getList(dMap);
					
				}
				if(!sequence.equals("FAIL")){
					for(int j=0;j<list.size();j++){
						DataMap row = list.get(j).getMap("map");
						
						row.put("REFDKY", sequence);
						
						printCnt = Integer.valueOf(row.getString("QTYASN")).intValue() / Integer.valueOf(row.getString("PLTQTYCAL")).intValue() +1 ;
						
						map.clonSessionData(row);
						
						row.put("QTDREM", String.valueOf( Integer.valueOf(row.getString("PLTQTYCAL")).intValue() % Integer.valueOf(row.getString("QTDUOM")).intValue() ));
						row.put("RCVQTY", String.valueOf( Integer.valueOf(row.getString("QTYASN")).intValue() ));
						row.put("QTDPRT", String.valueOf( Integer.valueOf(row.getString("PLTQTYCAL")).intValue() ));
						row.put("QTDBOX", String.valueOf( Integer.valueOf(row.getString("PLTQTYCAL")).intValue() / Integer.valueOf(row.getString("QTDUOM")).intValue() ));
						row.put("LOTA01", row.getString("SEBELN") +  row.getString("SEBELP") );
						
						for(int k=0;k<printCnt;k++){
							if(k == (printCnt-1) && (!"".equals(row.getString("RCVQTY"))) && (row.getString("RCVQTY") != null) ){
								int iQtduom = Integer.parseInt(row.getString("QTDUOM"));
								int iRcvqty = Integer.parseInt(row.getString("RCVQTY"));
								int iQtdprt = Integer.parseInt(row.getString("QTDPRT"));
								String sQtdprt = Integer.toString(iRcvqty % iQtdprt);
								String sQtdbox = Integer.toString((iRcvqty % iQtdprt)/iQtduom);
								
								if("0".equals(sQtdprt)){
									row.put("QTDPRT", param.get("QTDPRT"));
								}else{
									row.put("QTDPRT", sQtdprt);
								}
								
								if((iRcvqty % iQtdprt) == 0){
									row.put("QTDBOX", row.getString("QTDBOX"));
								} else if((iRcvqty % iQtdprt) > 0){
									row.put("QTDBOX", sQtdbox);
								}
							}
							
							row.setModuleCommand("LabelPrint", "LB01");
							commonDao.insert(row);
							count++;
						}
						
					}
					
					if("".equals(keys.toString())){
						keys.append("'").append(sequence).append("'");
					}else{
						keys.append(",'").append(sequence).append("'");
					}
				}else{
					throw new Exception("* Creating barcode Sequence error *");
				}
				
				
			}
			
		} catch (Exception e) {
			throw new Exception( ComU.getLastMsg(e.getMessage()) );
		}
		
		rsMap.put("CNT", count);
		rsMap.put("REFDKY", keys);
		
		return rsMap;
	}
	
}