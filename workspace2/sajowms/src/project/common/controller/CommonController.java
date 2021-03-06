package project.common.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import project.common.bean.CommonConfig;
import project.common.bean.CommonSearch;
import project.common.bean.CommonUser;
import project.common.bean.DataMap;
import project.common.bean.FileRepository;
import project.common.bean.SystemConfig;
import project.common.bean.UriInfo;
import project.common.bean.User;
import project.common.service.CommonService;
import project.common.util.PostRequest;
import project.common.util.Util;

@Controller
public class CommonController extends BaseController {
	
	static final Logger log = LogManager.getLogger(CommonController.class.getName());
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private CommonSearch commonSearch;
	
	@Autowired
	private SystemConfig systemConfig;
	
	@Autowired
	private FileRepository respository;
	
	@Autowired
	private CommonUser commonUser;
	
	@RequestMapping("/common/index.*")
	public String index(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		List list = commonService.getList("Common.PARTCOMBO", map);
		
		model.put("WAHMACOMBO", list);
		
		map.put("CODE", "LANGKY");
		
		List list1 = commonService.getList("Common.COMCOMBO", map);
		
		model.put("LANGKY", list1);
		
		List list2 = commonService.getList("Common.LOGINMSG", map);
		
		model.put("MSG", list2);
		
		return "/"+systemConfig.getTheme()+"/index";
	}
	
	@RequestMapping("/common/{page}.*")
	public String page(@PathVariable String page){
		return "/common/"+page;
	}
	
	@RequestMapping("/common/{module}/{page}.*")
	public String mpage(@PathVariable String module, @PathVariable String page){
		
		return "/common/"+module+"/"+page;
	}
	
	@RequestMapping("/common/{module}/{sub}/{page}.*")
	public String spage(@PathVariable String module, @PathVariable String sub, @PathVariable String page){
		
		return "/common/"+module+"/"+sub+"/"+page;
	}
	
	@RequestMapping("/common/Common/insert/json/USRLO1.*")
	public String usrloinsert1(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand("Common", "USRLO");

		Object data = commonService.insert(map);
		
		User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
		DataMap usrlo = user.getUsrlo();
		String progid = map.getString("PROGID");
		if(usrlo.containsKey(progid)){
			List list = usrlo.getList(progid);
			list.add(map);
		}else{
			List newData = new ArrayList();
			newData.add(map);
			usrlo.put(progid, newData);
		}
				
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/Common/update/json/USRLO1.*")
	public String usrloupdate1(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand("Common", "USRLO");

		int rs = commonService.update(map);
		
		User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
		DataMap usrlo = user.getUsrlo();
		String progid = map.getString("PROGID");
		if(usrlo.containsKey(progid)){
			List list = usrlo.getList(progid);
			list.add(map);
		}else{
			List newData = new ArrayList();
			newData.add(map);
			usrlo.put(progid, newData);
		}
		
		model.put("data", rs);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/Common/insert/json/USRLO.*")
	public String usrloinsert(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
		
		commonService.usrloinsert(map, user);
		model.put("data", "OK");
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/Common/update/json/USRLO.*")
	public String usrloupdate(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		User user = (User)request.getSession().getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
		
		commonService.usrloupdate(map, user);
		model.put("data", "OK");
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/{module}/count/json/{command}.*")
	public String count(HttpServletRequest request, @PathVariable String module, @PathVariable String command, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);

		int count = commonService.getCount(map);
		
		model.put("data", count);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/{module}/paging/json/{command}.*")
	public String paging(HttpServletRequest request, @PathVariable String module, @PathVariable String command, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);
		
		List list = commonService.getPagingList(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/{module}/list/json/{command}.*")
	public String list(HttpServletRequest request, @PathVariable String module, @PathVariable String command, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);
		
		List list = commonService.getList(map);
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/{module}/datalist/{dataType}/{command}.*")
	public String datalist(HttpServletRequest request, @PathVariable String module, @PathVariable String command, Map model) throws SQLException, InterruptedException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);
		
		String listData = commonService.getJdbcData(map);

		model.put("data", listData);
		
		return TEXT_VIEW;
	}
	
	@RequestMapping("/common/search/json/data.*")
	public String searchList(HttpServletRequest request, Map model) throws SQLException, InterruptedException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand("COMMON", "SEARCH");
		
		searchSql(map);
		
		String listData = commonService.getJdbcData(map);

		model.put("data", listData);
		
		return TEXT_VIEW;
	}
	
	public void searchSql(DataMap map) throws SQLException{
		
		StringBuilder sql = new StringBuilder();
		
		DataMap inputParam = map.getMap(CommonConfig.INPUT_SEARCH_PARAM_KET);
		DataMap itemMap = commonSearch.getItemMap(map.getString("COMMPOPID"));
		DataMap itemData;
		Iterator it = inputParam.keySet().iterator();
		while(it.hasNext()){
			Object key = it.next();
			itemData = itemMap.getMap(key);
			if(itemData.getString("SEARCHTYPE").equals("LIKE")){
				sql.append(" AND ").append(key).append(" LIKE '%").append(inputParam.get(key)).append("%' ");
			}else if(key != CommonConfig.RANGE_SQL_KEY && key != CommonConfig.WHARE_SQL){
 				sql.append(" AND ").append(key).append(" = '").append(inputParam.get(key)).append("' ");
			}
		}
		
		if(sql.length() > 0){
			if(map.containsKey(CommonConfig.RANGE_SQL_KEY)){
				sql.append(" ").append(map.get(CommonConfig.RANGE_SQL_KEY));
				map.put(CommonConfig.RANGE_SQL_KEY, sql.toString());
			}else{
				map.put(CommonConfig.RANGE_SQL_KEY, sql.toString());
			}			
		}	
		
		DataMap head = commonSearch.getHead(map);
		
		List<DataMap> itemList = commonSearch.getItem(map.getString("COMMPOPID"));
		
		DataMap row;
		
		StringBuilder col = new StringBuilder();
		
		for(int i=0;i<itemList.size();i++){
			row = itemList.get(i);
			if(row.getInt("GWIDTH") > 0){
				if(col.length() > 0){
					col.append(",");
				}
				col.append(row.getString("CPOPITEMID"));
			}			
		}
		
		map.setModuleCommand("Common", "SEARCH");
		
		map.put("COL", col.toString());
		map.put("TABLE", head.getString("VIEWTNAME"));
	}
	
	@RequestMapping("/common/{module}/map/json/{command}.*")
	public String map(HttpServletRequest request, @PathVariable String module, @PathVariable String command, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);
		
		Map data = commonService.getMap(map);
		
		model.put("data", data);
		model.put("map", map);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/{module}/insert/json/{command}.*")
	public String insert(HttpServletRequest request, @PathVariable String module, @PathVariable String command, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);

		Object data = commonService.insert(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/{module}/update/json/{command}.*")
	public String update(HttpServletRequest request, @PathVariable String module, @PathVariable String command, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);

		int rs = commonService.update(map);
		
		model.put("data", rs);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/{module}/delete/json/{command}.*")
	public String delete(HttpServletRequest request, @PathVariable String module, @PathVariable String command, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);

		int rs = commonService.delete(map);
		
		model.put("data", rs);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/excelParam/json/save.*")
	public String excelParamSave(HttpSession session, HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		String key = UUID.randomUUID().toString();
		
		session.setAttribute(key, map);
		
		model.put("key", key);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/{module}/excel/{command}.*")
	public String excel(HttpServletRequest request, @PathVariable String module, @PathVariable String command, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);

		String data = commonService.getListString(map);
		
		return excelView(map, model, data);
	}
	
	@RequestMapping("/common/excel/temp.*")
	public String excelTemp(HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		String data;
		if(map.containsKey("dataString")){
			data = map.getString("dataString");
		}else{
			data = "";
		}
		
		return excelView(map, model, data);
	}
	
	@RequestMapping("/common/{module}/{type}/fileUp/{command}.*")
	public String fileUp(HttpServletRequest request, @PathVariable String module, @PathVariable String type, @PathVariable String command, Map model) throws FileNotFoundException, IOException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);

		DataMap fileMap = map.getMap(CommonConfig.FILE_MAP_KEY);
		List list = fileMap.getList(CommonConfig.FILELIST_KEY);

		map.put("data", list);
		
		return "/common/fileAjaxUp";
	}
	
	@RequestMapping("/common/fileUp/file.*")
	public String fileUpDummy(HttpServletRequest request, Map model) throws FileNotFoundException, IOException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		DataMap fileMap = map.getMap(CommonConfig.FILE_MAP_KEY);
		List list = fileMap.getList(CommonConfig.FILELIST_KEY);
		map.put("data", list);
		
		return "/common/fileAjaxUp";
	}
	
	@RequestMapping("/common/image/fileUp/mobile.*")
	public String fileUpMobile(HttpServletRequest request, Map model) throws FileNotFoundException, IOException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		DataMap fileMap = map.getMap(CommonConfig.FILE_MAP_KEY);
		List list = fileMap.getList(CommonConfig.FILELIST_KEY);
		DataMap rsMap = new DataMap();
		rsMap.put("UUID",list.get(0).toString());
		model.put("data", rsMap);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/fileUp/mfile.*")
	public String mFileUpDummy(HttpServletRequest request, Map model) throws FileNotFoundException, IOException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		DataMap fileMap = map.getMap(CommonConfig.FILE_MAP_KEY);
		String guuid = fileMap.getString(CommonConfig.FILEGROUP_KEY);

		map.put("data", "["+guuid+"]");
		
		return "/common/fileAjaxUp";
	}
	
	@RequestMapping("/common/fileGroupUp/file.*")
	public String fileUpGroup(HttpServletRequest request, Map model) throws FileNotFoundException, IOException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		DataMap fileMap = map.getMap(CommonConfig.FILE_MAP_KEY);
		String guuid = fileMap.getString(CommonConfig.FILEGROUP_KEY);
		List list = new ArrayList();
		list.add(guuid);
		
		map.put("data", list);
		
		return "/common/fileAjaxUp";
	}
	
	@RequestMapping("/common/image/fileUp/image.*")
	public String fileUpImageDummy(HttpServletRequest request, Map model) throws FileNotFoundException, IOException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		DataMap fileMap = map.getMap(CommonConfig.FILE_MAP_KEY);
		List list = fileMap.getList(CommonConfig.FILELIST_KEY);

		map.put("data", list);
		
		return "/common/fileAjaxUp";
	}
	
	@RequestMapping("/common/image/fileGroupUp/image.*")
	public String fileGroupUpImageDummy(HttpServletRequest request, Map model) throws FileNotFoundException, IOException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		DataMap fileMap = map.getMap(CommonConfig.FILE_MAP_KEY);
		String guuid = fileMap.getString(CommonConfig.FILEGROUP_KEY);
		List list = new ArrayList();
		list.add(guuid);

		map.put("data", list);
		
		return "/common/fileAjaxUp";
	}
	
	@RequestMapping("/common/fileDown/file.*")
	public String doDownload(HttpServletRequest request, Map model) throws Exception {
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		File file = null;
		if(map.getString("UUID").equals("CUBE_COL_NAME_UUID")){
			return null;
		}

		if(map.getString("UUID").equals("")){
			file = new File(respository.getPath(), "noImage");
			model.put("downloadFile", file);
			model.put("fileName", "");
		}else{
			DataMap data = commonService.getMap(map);
			file = commonService.getFile(data);
			if(!file.isFile()){
				file = new File(respository.getPath(), "noImage");
			}
			
			model.put("downloadFile", file);
			model.put("fileName", java.net.URLEncoder.encode(data.getString("NAME"), "UTF-8"));
		}
		return FILE_VIEW;
	}
	
	@RequestMapping("/common/load/excel/json/grid.*")
	public String excelGrid(HttpServletRequest request, Map model) throws FileNotFoundException, IOException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		List data = commonService.getExcel(map);
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/sample/{module}/excel/{command}.*")
	public String excelM(HttpServletRequest request, @PathVariable String module, @PathVariable String command, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);

		List list = commonService.getList(map);
		
		return excelView(map, model, list);
	}
	
	@RequestMapping("/common/{module}/gridSave/json/{command}.*")
	public String gridSave(HttpServletRequest request, @PathVariable String module, @PathVariable String command, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand(module, command);
		
		DataMap data = commonService.gridSave(map);
		
		model.putAll(data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/label/json/reload.*")
	public String loadLabel(HttpServletRequest request, Map model) throws SQLException, IOException{		

		commonService.loadLabel();
		
		model.put("data", "reload");

		return JSON_VIEW;
	}
	
	@RequestMapping("/common/message/json/reload.*")
	public String loadMessage(HttpServletRequest request, Map model) throws SQLException, IOException{		

		commonService.loadMessage();
		
		model.put("data", "reload");

		return JSON_VIEW;
	}
	
	@RequestMapping("/common/search/json/reload.*")
	public String loadSearch(HttpServletRequest request, Map model) throws SQLException, IOException{		

		commonService.loadSearch();
		
		//UriInfo uriInfo = (UriInfo)request.getAttribute(CommonConfig.REQUEST_URI_INFO_KEY);
		
		//commonSearch.searchFileCreate(uriInfo);
		
		model.put("data", "reload");

		return JSON_VIEW;
	}
	
	@RequestMapping("/common/variant/json/insert.*")
	public String variantInsert(HttpSession session, HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		List list = commonService.variantInsert(map);
		
		User user = (User)session.getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
		map.put("USERID", map.getString(CommonConfig.SES_USER_ID_KEY));
		String progId = map.getString("PROGID");
		if(user.getUsrph().containsKey(progId)){
			if(map.containsKey("UCOUNT")){
				String parmky = map.getString("PARMKY");
				List tmpList = user.getUsrph().getList(progId);
				Map row;
				for(int i=0;i<tmpList.size();i++){
					row = (Map)tmpList.get(i);
					if(row.get("PARMKY").toString().equals(parmky)){
						tmpList.set(i, map);
						break;
					}
				}
			}else{
				user.getUsrph().getList(progId).add(map);
			}			
		}else{
			List tmpList = new ArrayList();
			tmpList.add(map);
			user.getUsrph().put(progId, tmpList);
		}
		
		if(map.getString("DEFCHK").equals("V")){
			user.getUsrpi().put(map.getString("PROGID"), list);
		}else{
			map.put("DEFCHK","V");
			map.setModuleCommand("Common", "USRPH");
			List tmpList = commonService.getList(map);
			if(tmpList.size() == 0){
				user.getUsrpi().remove(map.getString("PROGID"));
			}
		}
		
		model.put("data", list);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/variant/json/delete.*")
	public String variantDelete(HttpSession session, HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		DataMap data = commonService.variantDelete(map);
		
		User user = (User)session.getAttribute(CommonConfig.SES_USER_OBJECT_KEY);
		String progId = map.getString("PROGID");
		String parmky = map.getString("PARMKY");
		List list = user.getUsrph().getList(progId);
		Map row;
		for(int i=0;i<list.size();i++){
			row = (Map)list.get(i);
			if(row.get("PARMKY").toString().equals(parmky)){
				list.remove(i);				
				break;
			}
		}			
		
		if(data.getString("DEFCHK").equals("V")){
			user.getUsrpi().remove(progId);
		}
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/userinfo.*")
	public String userInfo(HttpSession session, HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		
		Object obj = session.getAttribute(CommonConfig.SES_USER_INFO_KEY);
		DataMap data = null;
		
		if(obj != null){
			data = (DataMap)obj;
		}
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/api/json/restfulRequest.*")
	public String restfulRequest(HttpSession session, HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		PostRequest postRequest = new PostRequest();
		
		DataMap data = postRequest.jsonPost("http://127.0.0.1:8080/common/api/json/restfulResponse.data", map);
		
		model.putAll(data);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/api/json/restfulResponse.*")
	public String restfulResponse(HttpSession session, HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		map.setModuleCommand("Common", "USRPH");
		map.put("SES_USER_ID", "DEV");
		List list = commonService.getList(map);
		map.put("detail", list);
		
		model.putAll(map);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/page/SQL_GRID_LIST.*")
	public String SQL_GRID_LIST(HttpSession session, HttpServletRequest request, Map model) throws SQLException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		String data = commonService.getSqlGridList(map.getString("sql"));
		
		session.setAttribute("SQL_GRID_DATA_LIST", data);
		
		String[] cols = data.substring(0, data.indexOf("???")).split("???");
		
		request.setAttribute("cols", cols);
		request.setAttribute("sql", map.getString("sql"));
		
		return "/common/tool/sqlGrid";
	}
	
	@RequestMapping("/common/json/SQL_GRID_DATA_LIST.*")
	public String sqlGridDatalist(HttpSession session, HttpServletRequest request, Map model) throws SQLException, InterruptedException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		String listData = (String)session.getAttribute("SQL_GRID_DATA_LIST");

		model.put("data", listData);
		
		return TEXT_VIEW;
	}
	
	@RequestMapping("/common/sql/json/executeUpdate.*")
	public String executeUpdate(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		int result = commonService.executeUpdate(map.getString("sql"));
		
		model.put("result", result);
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/grid/excel/fileUp/data.*")
	public String excelGridData(HttpSession session, HttpServletRequest request, Map model) throws FileNotFoundException, IOException, NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);

		List list = map.getList(CommonConfig.FILELIST_KEY);
		if(list.size() > 0){
			map.put("UUID", list.get(0));
			map.put(CommonConfig.DATA_EXCEL_COLNAME_ROWNUM_KEY, 1);
			List<String> colList = commonService.getExcelCollist(map);
			List<DataMap> dataList = commonService.getExcel(map);
			
			if(map.containsKey(CommonConfig.EXCEL_DATA_VALIDATION_BEANNAME)){
				map.put("list", dataList);
				Util util = new Util();
				Object result = util.executeBeanObject(request, map.getString(CommonConfig.EXCEL_DATA_VALIDATION_BEANNAME), map.getString(CommonConfig.EXCEL_DATA_VALIDATION_FUNCNAME), map);
				request.setAttribute("result", result);
			}
			
			/*
			if(dataList.size() > 0){
				DataMap row = dataList.get(0);
				String[] cols = new String[row.size()-2];
				Iterator it = row.keySet().iterator();
				int count = 0;
				for(int i=0;i<row.size();i++){
					String key = it.next().toString();
					if(key.equals(CommonConfig.EXCEL_DATA_VALIDATION_RESULT_CODE) || key.equals(CommonConfig.EXCEL_DATA_VALIDATION_RESULT_MSG)){
						continue;
					}
					cols[count] = key;
					count++;
				}
				request.setAttribute("cols", cols);
			}
			*/
			
			String[] cols = new String[colList.size()];
			for(int i=0;i<colList.size();i++){
				cols[i] = colList.get(i);
			}
			request.setAttribute("cols", cols);
			
			session.setAttribute("EXCEL_GRID_DATA_LIST", dataList);
		}
		
		return "/common/tool/excelGrid";
	}
	
	@RequestMapping("/common/json/EXCEL_GRID_DATA_LIST.*")
	public String excelGridDatalist(HttpSession session, HttpServletRequest request, Map model) throws SQLException, InterruptedException{		
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		List listData = (List)session.getAttribute("EXCEL_GRID_DATA_LIST");

		model.put("data", listData);
		
		return JSON_VIEW;
	}
	
	/**
	 * @author 2019.06.28 ?????????
	 * @param map
	 * @return json
	 * @throws Exception
	 * @method sessionSaveDataCount 
	 * PROCS_BTCSEQ_MAP sessionKey??? ??? ??????????????? ??????
	 */
	@RequestMapping("/common/session/json/sessionSaveDataCount.*")
	public String sessionSaveDataCount(HttpSession session, HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		String sessionKey = map.getString("sessionKey");
		if(session.getAttribute(sessionKey) == null){
			session.setAttribute(sessionKey, 0);
		}
		
		Object obj = session.getAttribute(sessionKey);
		int data = 0;
		if(obj != null){
			data = (int)obj;
		}
		
		model.put("data", data);
		
		return JSON_VIEW;
	}
	/**
	 * @author 2019.06.28 ?????????
	 * @param map
	 * @return json
	 * @throws SQLException
	 * @method procsUpdateDataCount 
	 * proc ????????? ????????? 
	 */
	@RequestMapping("/common/session/json/procsUpdateDataCount.*")
	public String procsUpdateDataCount(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		map.setModuleCommand("Common", "PROCS_UPD");
		int data = commonService.getCount(map);
		model.put("data", data);
		
		return JSON_VIEW;
	}
	/**
	 * @author 2019.06.28 ?????????
	 * @param map
	 * @return json
	 * @throws Exception
	 * @method removeSessionSaveData 
	 * ????????? ?????? ????????? ??????
	 */
	@RequestMapping("/common/session/json/removeSessionSaveData.*")
	public String removeSessionSaveData(HttpSession session, HttpServletRequest request, Map model) throws Exception{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		String sessionKey = map.getString("sessionKey");
		
		session.removeAttribute(sessionKey);
		
		model.put("data", "S");
		
		return JSON_VIEW;
	}
	
	@RequestMapping("/common/page/commonPop.*")
	public String commonPop(HttpServletRequest request, Map model) throws SQLException{				
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		
		model.put("param", map);
		
		Map head = commonSearch.getHead(map);
		
		if(head == null){
			head = new DataMap();
		}
		
		model.put("head", head);
		
		List itemList = commonSearch.getItem(map.getString("COMMPOPID"));
		
		if(itemList == null){
			itemList = new ArrayList();
		}
		
		model.put("itemList", itemList);
		
		return "/common/commonPop";
	}
	
	@RequestMapping("/common/common_ezprint.*")
	public String ezpage(HttpServletRequest request, Map model) throws SQLException{
		DataMap map = (DataMap)request.getAttribute(CommonConfig.PARAM_ATT_KEY);
		UriInfo uriInfo = (UriInfo)request.getAttribute(CommonConfig.REQUEST_URI_INFO_KEY);
		model.put("filename", map.get("filename"));
		model.put("andvalue", map.get("andvalue"));
		model.put("width", map.get("width"));
		model.put("height", map.get("height"));
		model.put("url", uriInfo.getUrl());
		return "/common/common_ezprint";
	}
}