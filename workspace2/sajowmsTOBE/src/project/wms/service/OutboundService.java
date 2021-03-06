package project.wms.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.RequestMapping;

import project.common.bean.CommonConfig;
import project.common.bean.DataMap;
import project.common.dao.CommonDAO;
import project.common.service.BaseService;
import project.common.service.CommonService;
import project.common.util.ComU;
import project.common.util.DasStringFormat;
import project.common.util.SqlUtil;
import project.common.util.StringUtil;
import project.http.po.POInterfaceManager;

@Service
public class OutboundService extends BaseService {

	static final Logger log = LogManager.getLogger(OutboundService.class.getName());

	@Autowired
	public CommonDAO commonDao;

	@Autowired
	private CommonService commonService;

	@Autowired
	private TaskDataService taskService;

	@Autowired
	public POInterfaceManager poManager;
	
    @Autowired private PlatformTransactionManager transactionManager;

	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSO01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		int count = 0;
		String ishpky = "";
		try {
			List<DataMap> list = map.getList("list");

			int listSize = list.size();
			if (listSize > 0) {
				map.setModuleCommand("Outbound", "SO01_ISHPKY");
				ishpky = (String) commonDao.getObj(map);

				for (int i = 0; i < listSize; i++) {
					DataMap row = list.get(i).getMap("map");
					map.clonSessionData(row);

					row.put("ISHPKY", ishpky);

					row.setModuleCommand("Common", "COMMON_SKUMA");
					DataMap skumaMap = commonDao.getMap(row);
					String ownrky = skumaMap.getString("OWNRKY");
					String desc01 = skumaMap.getString("DESC01");

					row.put("OWNRKY", ownrky);
					row.put("DESC01", desc01);

					row.setModuleCommand("Common", "COMMON_BZPTN");
					DataMap bzptnMap = commonDao.getMap(row);
					String name01 = bzptnMap.getString("NAME01");

					row.put("PTNRNM", name01);

					String ptrcvr = row.getString("PTRCVR");
					if (!"".equals(ptrcvr.trim())) {
						bzptnMap = new DataMap();
						map.clonSessionData(bzptnMap);
						bzptnMap.put("PTNRKY", ptrcvr);
						bzptnMap.setModuleCommand("Common", "COMMON_BZPTN");

						bzptnMap = commonDao.getMap(bzptnMap);
						name01 = bzptnMap.getString("NAME01");

						row.put("PTRCNM", name01);
					}

					row.setModuleCommand("Outbound", "SO01");

					commonDao.insert(row);

					count++;
				}
			} else {
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}

		rsMap.put("CNT", count);
		rsMap.put("ISHPKY", ishpky);

		return rsMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSO10(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		int count = 0;
		try {
			List<DataMap> head = map.getList("head");

			int headSize = head.size();
			if (headSize > 0) {
				for (int i = 0; i < headSize; i++) {
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);

					String shpoky = commonDao.getDocNum(headRow.getString("SHPMTY"));

					headRow.put("SHPOKY", shpoky);
					headRow.put("STATDO", "NEW");
					headRow.setModuleCommand("Outbound", "SHPDH");

					commonDao.insert(headRow);

					int itemCount = 0;

					headRow.setModuleCommand("Outbound", "SO10_ITEM");
					List<DataMap> item = commonDao.getList(headRow);

					int itemSize = item.size();
					if (itemSize > 0) {
						for (int j = 0; j < itemSize; j++) {
							itemCount += 10;
							String snum = String.valueOf(itemCount);
							String inum = String.valueOf("000000").substring(0, (6 - snum.length())) + snum;

							DataMap itemRow = item.get(j).getMap("map");
							map.clonSessionData(itemRow);

							itemRow.put("SHPOKY", shpoky);
							itemRow.put("SHPOIT", inum);
							itemRow.put("STATIT", "NEW");
							itemRow.setModuleCommand("Outbound", "SHPDI");

							commonDao.insert(itemRow);
						}
					}

					headRow.setModuleCommand("Outbound", "IFSHP_COMPLATE");

					commonDao.update(headRow);

					count++;
				}
			} else {
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}

		rsMap.put("CNT", count);

		return rsMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSH01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();

		List<DataMap> task = new ArrayList<DataMap>();

		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");

		int headSize = head.size();
		int itemSize = item.size();

		try {
			if (headSize > 0) {
				for (int i = 0; i < headSize; i++) {
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);

					String wareky = headRow.getString("WAREKY");

					String shpoky = headRow.getString("SHPOKY");

					String tasoty = headRow.getString("TASOTY");
					String taskky = commonDao.getDocNum(tasoty);
					String taskty = headRow.getString("TASKTY");
					String locatg = headRow.getString("SYSLOC");

					List<DataMap> temp = new ArrayList<DataMap>();
					if (itemSize > 0 && shpoky.equals(item.get(0).getMap("map").getString("SHPOKY"))) {
						for (int j = 0; j < itemSize; j++) {
							DataMap itemRow = item.get(j).getMap("map");
							temp.add(itemRow);
						}
					} else {
						headRow.setModuleCommand("Outbound", "SH01_ITEM");
						temp = commonDao.getList(headRow);
					}

					int taskItemCount = 0;
					int tempSize = temp.size();
					if (tempSize > 0) {
						int itemCount = 0;

						for (int j = 0; j < tempSize; j++) {
							DataMap row = temp.get(j).getMap("map");
							map.clonSessionData(row);

							row.put("WAREKY", wareky);
							row.setModuleCommand("Outbound", "SH01_STOCKYN");
							String isStock = (String) commonDao.getObject(row);

							String shpoit = row.getString("SHPOIT");
							float qttaor = Float.parseFloat(row.getString("QTTAOR"));

							row.setModuleCommand("Task", "STKKY");
							List<DataMap> stkky = commonDao.getList(row);

							int stkkyCount = stkky.size();
							if ("Y".equals(isStock) && stkkyCount > 0 && qttaor > 0) {
								for (int k = 0; k < stkkyCount; k++) {
									if (qttaor <= 0) {
										break;
									}

									itemCount += 10;
									String snum = String.valueOf(itemCount);
									String inum = String.valueOf("000000").substring(0, (6 - snum.length())) + snum;

									DataMap stkRow = stkky.get(k).getMap("map");
									map.clonSessionData(stkRow);

									String stokky = stkRow.getString("STOKKY");
									String locaky = stkRow.getString("LOCAKY");

									String duomky = stkRow.getString("DUOMKY");
									String smeaky = stkRow.getString("MEASKY");
									String suomky = stkRow.getString("UOMKEY");
									float qtpuom = Float.parseFloat(stkRow.getString("QTPUOM"));
									float qtduom = Float.parseFloat(stkRow.getString("QTDUOM"));
									float qtyuom = Float.parseFloat(stkRow.getString("QTYUOM"));

									float qtsiwh = Float.parseFloat(stkRow.getString("QTSIWH"));
									float savqty = 0F;
									if (qttaor > qtsiwh) {
										savqty = qtsiwh;
										qttaor = qttaor - qtsiwh;
									} else if (qttaor < qtsiwh) {
										savqty = qttaor;
										qttaor = 0;
									} else {
										savqty = qttaor;
										qttaor = 0;
									}

									stkRow.put("TASKKY", taskky);
									stkRow.put("TASKIT", inum);
									stkRow.put("TASKTY", taskty);
									stkRow.put("STATIT", "NEW");
									stkRow.put("STKNUM", stokky);
									stkRow.put("QTTAOR", savqty);
									stkRow.put("QTCOMP", 0);
									stkRow.put("LOCASR", locaky);
									stkRow.put("LOCATG", locatg);
									stkRow.put("SHPOKY", shpoky);
									stkRow.put("SHPOIT", shpoit);

									stkRow.put("SMEAKY", smeaky);
									stkRow.put("SUOMKY", suomky);
									stkRow.put("QTYUOM", qtyuom);
									stkRow.put("QTSPUM", qtpuom);
									stkRow.put("SDUOKY", duomky);
									stkRow.put("QTSDUM", qtduom);

									stkRow.setModuleCommand("Task", "TASDI");

									commonDao.insert(stkRow);
								}

								taskItemCount++;
							}
						}

						if (taskItemCount > 0) {
							headRow.put("TASKKY", taskky);
							headRow.setModuleCommand("Task", "TASDH");

							commonDao.insert(headRow);

							task.add(headRow);
						}
					}
				}

				int taskSize = task.size();
				if (taskSize > 0) {
					for (int i = 0; i < taskSize; i++) {
						DataMap headRow = task.get(i).getMap("map");
						map.clonSessionData(headRow);

						headRow.setModuleCommand("Task", "TASK_TO_STK");
						List<DataMap> taskItem = commonDao.getList(headRow);

						int taskItemSize = taskItem.size();
						if (taskItemSize > 0) {
							for (int j = 0; j < taskItemSize; j++) {
								DataMap itemRow = taskItem.get(j).getMap("map");
								map.clonSessionData(itemRow);

								float qttaor = Float.parseFloat(itemRow.getString("QTTAOR"));

								itemRow.put("QTSIWH", 0);
								itemRow.put("QTSALO", qttaor);
								itemRow.put("QTJCMP", 0);
								itemRow.put("QTSPMO", 0);
								itemRow.put("QTSPMI", 0);
								itemRow.put("QTSBLK", 0);
								itemRow.put("QTSHPD", 0);
								itemRow.setModuleCommand("Task", "STKKY");

								commonDao.insert(itemRow);

								itemRow.setModuleCommand("Task", "STKKY_QTY");
								commonDao.update(itemRow);

								itemRow.setModuleCommand("Outbound", "SH01_QTY");
								commonDao.update(itemRow);

								itemRow.setModuleCommand("Outbound", "SH01_STATIT");
								String statit = (String) commonDao.getObject(itemRow);
								itemRow.put("STATIT", statit);
								commonDao.update(itemRow);
							}

							headRow.setModuleCommand("Outbound", "SH01_STATDO");
							String statdo = (String) commonDao.getObject(headRow);
							headRow.put("STATDO", statdo);

							commonDao.update(headRow);
						}
					}
				}
			} else {
				rsMap.put("RESULT", "F2");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}

		rsMap.put("RESULT", "S");

		return rsMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSH02(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();

		int resultCount = 0;

		String alstky = map.getString("ALSTKY");

		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");

		int headSize = head.size();
		int itemSize = item.size();
		try {
			if (headSize > 0) {
				map.setModuleCommand("Outbound", "SHPDR_GRPKEY");

				String grpkey = (String) commonDao.getObject(map);

				for (int i = 0; i < headSize; i++) {
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);

					String wareky = headRow.getString("WAREKY");
					String shpoky = headRow.getString("SHPOKY");
					String shpmty = headRow.getString("SHPMTY");
					String rqshpd = headRow.getString("RQSHPD");
					String docdat = headRow.getString("DOCCAT");
					String dptnky = headRow.getString("DPTNKY");
					String ptnrnm = headRow.getString("DPTNNM");
					String ptrcvr = headRow.getString("PTRCVR");
					String ptrcnm = headRow.getString("PTRCNM");
					String doccat = headRow.getString("DOCCAT");
					String tasoty = headRow.getString("TASOTY");
					String locaky = headRow.getString("SYSLOC");

					List<DataMap> temp = new ArrayList<DataMap>();
					if (itemSize > 0 && shpoky.equals(item.get(0).getMap("map").getString("SHPOKY"))) {
						for (int j = 0; j < itemSize; j++) {
							DataMap itemRow = item.get(j).getMap("map");
							temp.add(itemRow);
						}
					} else {
						headRow.setModuleCommand("Outbound", "SH01_ITEM");
						temp = commonDao.getList(headRow);
					}

					int tempSize = temp.size();
					if (tempSize > 0) {
						for (int j = 0; j < tempSize; j++) {
							DataMap row = temp.get(j).getMap("map");
							map.clonSessionData(row);

							row.put("GRPKEY", grpkey);
							row.put("WAREKY", wareky);
							row.put("SHPMTY", shpmty);
							row.put("RQSHPD", rqshpd);
							row.put("DOCCAT", docdat);
							row.put("DPTNKY", dptnky);
							row.put("DNAME1", ptnrnm);
							row.put("PTRCVR", ptrcvr);
							row.put("DNAME2", ptrcnm);
							row.put("DOCCAT", doccat);
							row.put("TASOTY", tasoty);
							row.put("LOCAKY", locaky);
							row.setModuleCommand("Outbound", "SHPDR");

							commonDao.insert(row);
						}
					}
				}

				map.put("ALSTKY", alstky);
				map.put("GRPKEY", grpkey);
				map.setModuleCommand("Outbound", "PRCS_GRP_ALLOCATION");

				resultCount = commonDao.getCount(map);
				if (resultCount > 0) {
					rsMap.put("RESULT", "S");
				} else {
					rsMap.put("RESULT", "F1");
				}
			} else {
				rsMap.put("RESULT", "F2");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}

		return rsMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSH01Cancel(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");

			int headSize = head.size();
			int itemSize = item.size();
			if (headSize > 0) {
				for (int i = 0; i < headSize; i++) {
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);

					String shpoky = headRow.getString("SHPOKY");
					String wareky = headRow.getString("WAREKY");
					String taskty = headRow.getString("TASKTY");

					List<DataMap> temp = new ArrayList<DataMap>();

					if (itemSize > 0 && shpoky.equals(item.get(0).getMap("map").getString("SHPOKY"))) {
						for (int j = 0; j < itemSize; j++) {
							DataMap itemRow = item.get(j).getMap("map");
							temp.add(itemRow);
						}
					} else {
						headRow.setModuleCommand("Outbound", "SH01_ITEM");
						temp = commonDao.getList(headRow);
					}

					int tempSize = temp.size();
					if (tempSize > 0) {
						for (int j = 0; j < tempSize; j++) {
							DataMap row = temp.get(j).getMap("map");
							map.clonSessionData(row);

							row.put("WAREKY", wareky);
							row.put("TASKTY", taskty);
							row.setModuleCommand("Outbound", "SH01_TASK");

							List<DataMap> tskList = commonDao.getList(row);

							int tskSize = tskList.size();
							if (tskSize > 0) {
								for (int k = 0; k < tskSize; k++) {
									DataMap tskRow = tskList.get(k).getMap("map");
									map.clonSessionData(tskRow);

									float qttaor = Float.parseFloat(tskRow.getString("QTTAOR"));

									tskRow.put("STATIT", "CLS");
									tskRow.setModuleCommand("Outbound", "SH01_TASDI_STATUS");

									commonDao.update(tskRow);

									tskRow.setModuleCommand("Outbound", "SH01_STKKY_QTSIWH");

									commonDao.update(tskRow);

									tskRow.setModuleCommand("Outbound", "SH01_STKKY_ALOC");

									commonDao.delete(tskRow);

									tskRow.put("QTTAOR", (qttaor * -1));
									tskRow.setModuleCommand("Outbound", "SH01_QTY");

									commonDao.update(tskRow);

									tskRow.setModuleCommand("Outbound", "SH01_STATIT");
									String statit = (String) commonDao.getObject(tskRow);

									tskRow.put("STATIT", statit);

									tskRow.setModuleCommand("Outbound", "SH01_STATIT");

									commonDao.update(tskRow);
								}
							}
						}
					}

					headRow.setModuleCommand("Outbound", "SH01_TASK_CLS");
					String isCls = (String) commonDao.getObject(headRow);
					if ("Y".equals(isCls)) {
						headRow.put("STATDO", "CLS");
						headRow.setModuleCommand("Outbound", "SH01_TASDH_STATUS");

						commonDao.update(headRow);
					}

					headRow.setModuleCommand("Outbound", "SH01_STATDO");
					String statdo = (String) commonDao.getObject(headRow);

					headRow.put("STATDO", statdo);

					headRow.setModuleCommand("Outbound", "SH01_STATDO");

					commonDao.update(headRow);
				}
			} else {
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}

		rsMap.put("RESULT", "S");

		return rsMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public DataMap savePK01(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");

			int headSize = head.size();
			int itemSize = item.size();
			if (headSize > 0) {
				for (int i = 0; i < headSize; i++) {
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);

					String shpoky = headRow.getString("SHPOKY");
					String wareky = headRow.getString("WAREKY");
					String taskty = headRow.getString("TASKTY");

					List<DataMap> temp = new ArrayList<DataMap>();
					if (itemSize > 0 && shpoky.equals(item.get(0).getMap("map").getString("SHPOKY"))) {
						for (int j = 0; j < itemSize; j++) {
							DataMap itemRow = item.get(j).getMap("map");
							temp.add(itemRow);
						}
					} else {
						headRow.setModuleCommand("Outbound", "PK01_ITEM");
						temp = commonDao.getList(headRow);
					}

					int tempSize = temp.size();
					if (tempSize > 0) {
						for (int j = 0; j < tempSize; j++) {
							DataMap row = temp.get(j).getMap("map");
							map.clonSessionData(row);

							row.put("WAREKY", wareky);

							float qttaor = Float.parseFloat(row.getString("QTTAOR"));
							float qtcomp = Float.parseFloat(row.getString("QTCOMP"));
							float qtydif = Float.parseFloat(row.getString("QTYDIF"));
							String locaky = row.getString("LOCAKY");
							String locasr = row.getString("LOCASR");
							String taskky = row.getString("TASKKY");
							String taskit = row.getString("TASKIT");
							String shpoit = row.getString("SHPOIT");
							String locatg = row.getString("LOCATG");

							if ((qttaor - qtcomp) >= qtydif) {
								if (!locaky.equals(locasr)) {
									// ???????????? ??????
									row.setModuleCommand("Outbound", "PK01_STK_CHECK");
									List<DataMap> locSkuChkList = commonDao.getList(row);
									if (locSkuChkList.size() > 0) {
										float qtsiwh = Float
												.parseFloat(locSkuChkList.get(0).getMap("map").getString("QTSIWH"));
										if (qtsiwh > 0) {
											row.setModuleCommand("Outbound", "PK01_TASK_TO_STK");
											List<DataMap> stkky = commonDao.getList(row);

											int stkkyCount = stkky.size();
											if (stkkyCount > 0 && qtydif > 0) {
												row.setModuleCommand("Outbound", "TASDI_MAXRIT");

												int itemCount = commonDao.getCount(row);

												for (int k = 0; k < stkkyCount; k++) {
													if (qttaor <= 0) {
														break;
													}

													itemCount += 10;
													String snum = String.valueOf(itemCount);
													String inum = String.valueOf("000000").substring(0,
															(6 - snum.length())) + snum;

													DataMap stkRow = stkky.get(k).getMap("map");
													map.clonSessionData(stkRow);

													String stokky = stkRow.getString("STOKKY");

													String duomky = stkRow.getString("DUOMKY");
													String smeaky = stkRow.getString("MEASKY");
													String suomky = stkRow.getString("UOMKEY");
													float qtpuom = Float.parseFloat(stkRow.getString("QTPUOM"));
													float qtduom = Float.parseFloat(stkRow.getString("QTDUOM"));
													float qtyuom = Float.parseFloat(stkRow.getString("QTYUOM"));

													float aqtsiwh = Float.parseFloat(stkRow.getString("QTSIWH"));
													float savqty = 0F;
													if (qtydif > aqtsiwh) {
														savqty = aqtsiwh;
														qtydif = qttaor - aqtsiwh;
													} else if (qtydif < aqtsiwh) {
														savqty = qtydif;
														qtydif = 0;
													} else {
														savqty = qttaor;
														qtydif = 0;
													}

													stkRow.put("TASKKY", taskky);
													stkRow.put("TASKIT", inum);
													stkRow.put("TASKTY", taskty);
													stkRow.put("STATIT", "FPC");
													stkRow.put("STKNUM", stokky);
													stkRow.put("QTTAOR", savqty);
													stkRow.put("QTCOMP", savqty);
													stkRow.put("LOCASR", locaky);
													stkRow.put("LOCATG", locatg);
													stkRow.put("SHPOKY", shpoky);
													stkRow.put("SHPOIT", shpoit);

													stkRow.put("SMEAKY", smeaky);
													stkRow.put("SUOMKY", suomky);
													stkRow.put("QTYUOM", qtyuom);
													stkRow.put("QTSPUM", qtpuom);
													stkRow.put("SDUOKY", duomky);
													stkRow.put("QTSDUM", qtduom);

													stkRow.setModuleCommand("Task", "TASDI");

													commonDao.insert(stkRow);

													stkRow.put("QTSIWH", 0);
													stkRow.put("QTSALO", savqty);
													stkRow.put("QTJCMP", 0);
													stkRow.put("QTSPMO", 0);
													stkRow.put("QTSPMI", 0);
													stkRow.put("QTSBLK", 0);
													stkRow.put("QTSHPD", 0);
													stkRow.setModuleCommand("Task", "STKKY");

													commonDao.insert(stkRow);

													stkRow.setModuleCommand("Task", "STKKY_QTY");
													commonDao.update(stkRow);

													stkRow.put("QTYDIF", savqty);
													stkRow.setModuleCommand("Outbound", "PK01_SHPDI");
													commonDao.update(stkRow);

													stkRow.put("TASKIT", taskit);
													stkRow.setModuleCommand("Outbound", "PK01_TASK_QTTAOR");
													commonDao.update(stkRow);
												}
											}
										}
									}
								} else {
									String statit = "FPC";
									if ((qttaor - qtcomp) - qtydif > 0) {
										statit = "PPC";
									}

									row.put("STATIT", statit);
									row.setModuleCommand("Outbound", "PK01_TASK");

									commonDao.update(row);

									row.setModuleCommand("Outbound", "PK01_SHPDI");

									commonDao.update(row);
								}
							}

							row.setModuleCommand("Outbound", "PK01_SHPDI_STATUS");
							commonDao.update(row);
						}

						headRow.setModuleCommand("Outbound", "PK01_TASDH_STATUS");
						List<DataMap> tskList = commonDao.getList(headRow);
						if (tskList.size() > 0) {
							for (int j = 0; j < tskList.size(); j++) {
								DataMap row = tskList.get(j).getMap("map");
								map.clonSessionData(row);

								row.setModuleCommand("Outbound", "PK01_TASDH_STATUS");
								String statdo = (String) commonDao.getObject(row);
								row.put("STATDO", statdo);

								commonDao.update(row);
							}
						}
					}

					headRow.setModuleCommand("Outbound", "SH01_STATDO");
					String statdo = (String) commonDao.getObject(headRow);

					headRow.put("STATDO", statdo);

					commonDao.update(headRow);
				}
			} else {
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}

		rsMap.put("RESULT", "S");

		return rsMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public DataMap savePK01Cancel(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");

			int headSize = head.size();
			int itemSize = item.size();
			if (headSize > 0) {
				for (int i = 0; i < headSize; i++) {
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);

					String shpoky = headRow.getString("SHPOKY");
					String wareky = headRow.getString("WAREKY");

					List<DataMap> temp = new ArrayList<DataMap>();
					if (itemSize > 0 && shpoky.equals(item.get(0).getMap("map").getString("SHPOKY"))) {
						for (int j = 0; j < itemSize; j++) {
							DataMap itemRow = item.get(j).getMap("map");
							temp.add(itemRow);
						}
					} else {
						headRow.setModuleCommand("Outbound", "PK01_ITEM");
						temp = commonDao.getList(headRow);
					}

					int tempSize = temp.size();
					if (tempSize > 0) {
						for (int j = 0; j < tempSize; j++) {
							DataMap row = temp.get(j).getMap("map");
							map.clonSessionData(row);

							row.put("WAREKY", wareky);

							float qttaor = Float.parseFloat(row.getString("QTTAOR"));
							float qtcomp = Float.parseFloat(row.getString("QTCOMP"));

							if (qtcomp > 0) {
								row.put("QTYDIF", (qtcomp * -1));
								row.put("STATIT", "NEW");
								row.setModuleCommand("Outbound", "PK01_TASK");

								commonDao.update(row);

								row.setModuleCommand("Outbound", "PK01_SHPDI");

								commonDao.update(row);
							}

							row.setModuleCommand("Outbound", "PK01_SHPDI_STATUS");
							commonDao.update(row);
						}

						headRow.setModuleCommand("Outbound", "PK01_TASDH_STATUS");
						List<DataMap> tskList = commonDao.getList(headRow);
						if (tskList.size() > 0) {
							for (int j = 0; j < tskList.size(); j++) {
								DataMap row = tskList.get(j).getMap("map");
								map.clonSessionData(row);

								row.setModuleCommand("Outbound", "PK01_TASDH_STATUS");
								String statdo = (String) commonDao.getObject(row);
								row.put("STATDO", statdo);

								commonDao.update(row);
							}
						}
					}

					headRow.setModuleCommand("Outbound", "PK01_STATDO");
					String statdo = (String) commonDao.getObject(headRow);

					headRow.put("STATDO", statdo);
					headRow.setModuleCommand("Outbound", "SH01_STATDO");

					commonDao.update(headRow);
				}
			} else {
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}

		rsMap.put("RESULT", "S");

		return rsMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public DataMap saveSH30(DataMap map) throws SQLException {
		DataMap rsMap = new DataMap();
		try {
			List<DataMap> head = map.getList("head");

			int headSize = head.size();
			if (headSize > 0) {
				for (int i = 0; i < headSize; i++) {
					DataMap headRow = head.get(i).getMap("map");
					map.clonSessionData(headRow);

					headRow.setModuleCommand("Outbound", "SH30_TASK");
					List<DataMap> item = commonDao.getList(headRow);

					int itemSize = item.size();
					if (itemSize > 0) {
						for (int j = 0; j < itemSize; j++) {
							DataMap itemRow = item.get(j).getMap("map");
							map.clonSessionData(itemRow);

							itemRow.setModuleCommand("Outbound", "SH30_STKKY");
							commonDao.update(itemRow);

							itemRow.setModuleCommand("Outbound", "SH30_SHPDI");
							commonDao.update(itemRow);
						}
					}

					headRow.setModuleCommand("Outbound", "SH30_SHPDH_STATDO");
					String statdo = (String) commonDao.getObject(headRow);
					headRow.put("STATDO", statdo);

					headRow.setModuleCommand("Outbound", "SH30_SHPDH");
					commonDao.update(headRow);
				}
			} else {
				rsMap.put("RESULT", "F1");
			}
		} catch (Exception e) {
			throw new SQLException(e.getMessage());
		}

		rsMap.put("RESULT", "S");

		return rsMap;
	}

	// [DL00] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayHeadDL00(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("I.ORDTYP");
		keyList.add("I.ORDDAT");
		keyList.add("I.ERPCDT");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.WARESR");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("I.QTYORG");
		keyList.add("I.OWNRKY");
		keyList.add("I.WAREKY");
		keyList.add("SM2.ASKU02");
		keyList.add("SM2.ASKU05");
		keyList.add("B.NAME03");
		keyList.add("SW.LOCARV");
		keyList.add("B.PTNG08");
		keyList.add("B.PTNG01");
		keyList.add("B2.PTNG01");
		keyList.add("B.PTNG02");
		keyList.add("B2.PTNG02");
		keyList.add("I.SKUG02");
		keyList.add("I.SKUG03");
		map.put("RANGE_SQL",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>(); // RangeSearch2
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.QTYORG");
		keyList2.add("I.PTNROD");
		keyList2.add("I.WARESR");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.WAREKY");
		keyList2.add("SM.ASKU05");
		map.put("RANGE_SQL2",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List keyList3 = new ArrayList<>(); // RangeSearch3
		keyList3.add("LOTA05");
		keyList3.add("LOTA06");
		keyList3.add("LOCAKY");
		map.put("RANGE_SQL3",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		List keyList4 = new ArrayList<>(); // RangeSearch4
		keyList4.add("SW.LOCARV");
		map.put("RANGE_SQL4",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList4));

		List keyList5 = new ArrayList<>(); // RangeSearch5
		keyList5.add("F.PTNRKY");
		keyList5.add("C.CARNUM");
		map.put("RANGE_SQL5",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList5));

		map.setModuleCommand("Outbound", "DL00_HEAD");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}


	// [DL00] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayHeadDL00Save(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("I.ORDTYP");
		keyList.add("I.ORDDAT");
		keyList.add("I.ERPCDT");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.WARESR");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("I.QTYORG");
		keyList.add("I.OWNRKY");
		keyList.add("I.WAREKY");
		keyList.add("SM2.ASKU02");
		keyList.add("SM2.ASKU05");
		keyList.add("B.NAME03");
		keyList.add("SW.LOCARV");
		keyList.add("B.PTNG08");
		keyList.add("B.PTNG01");
		keyList.add("B2.PTNG01");
		keyList.add("B.PTNG02");
		keyList.add("B2.PTNG02");
		keyList.add("I.SKUG02");
		keyList.add("I.SKUG03");
		map.put("RANGE_SQL",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>(); // RangeSearch2
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.QTYORG");
		keyList2.add("I.PTNROD");
		keyList2.add("I.WARESR");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.WAREKY");
		keyList2.add("SM.ASKU05");
		map.put("RANGE_SQL2",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List keyList3 = new ArrayList<>(); // RangeSearch3
		keyList3.add("LOTA05");
		keyList3.add("LOTA06");
		keyList3.add("LOCAKY");
		map.put("RANGE_SQL3",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		List keyList4 = new ArrayList<>(); // RangeSearch4
		keyList4.add("SW.LOCARV");
		map.put("RANGE_SQL4",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList4));

		List keyList5 = new ArrayList<>(); // RangeSearch5
		keyList5.add("F.PTNRKY");
		keyList5.add("C.CARNUM");
		map.put("RANGE_SQL5",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList5));
		
		map.put("WAREKY", map.getString("SVWAREKY"));
		map.put("OWNRKY", "");

		map.setModuleCommand("Outbound", "DL00_HEAD_SAVE");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// [DL00] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayHeadDL01(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList2 = new ArrayList<>();
		keyList2.add("IF.SKUKEY");
		map.put("RANGEITEM",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List keyList = new ArrayList<>();
		keyList.add("IF.ORDTYP");
		keyList.add("IF.ORDDAT");
		keyList.add("IF.ERPCDT");
		keyList.add("IF.SVBELN");
		keyList.add("IF.DOCUTY");
		keyList.add("IF.OTRQDT");
		keyList.add("PTNRTO");
		keyList.add("BZ.NAME01");
		keyList.add("IF.WARESR");
		keyList.add("BZP.NAME01)");
		keyList.add("IF.QTYORG");
		keyList.add("IF.DIRSUP");
		keyList.add("IF.DIRDVY");
		keyList.add("SM.SKUG05");
		keyList.add("C.CARNUM");
		DataMap changeMap = new DataMap();
		changeMap.put("PTNRTO", "DECODE(IF.DOCUTY, '266', IF.WARESR, IF.PTNRTO)");
		changeMap.put("BZ.NAME01",
				"DECODE(IF.DOCUTY, '266', NVL((SELECT NAME01 FROM WAHMA  WHERE WAREKY = IF.WARESR),' '), BZ.NAME01)");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),
				keyList, changeMap));

		map.setModuleCommand("Outbound", "DL01_HEAD");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// [DL00] Item ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayItemDL00(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("I.ORDTYP");
		keyList.add("I.ORDDAT");
		keyList.add("I.ERPCDT");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.WARESR");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("I.QTYORG");
		keyList.add("I.OWNRKY");
		keyList.add("I.WAREKY");
		keyList.add("SM2.ASKU02");
		keyList.add("SM2.ASKU05");
		keyList.add("B.NAME03");
		keyList.add("SW.LOCARV");
		keyList.add("B.PTNG08");
		keyList.add("B.PTNG01");
		keyList.add("B2.PTNG01");
		keyList.add("B.PTNG02");
		keyList.add("B2.PTNG02");
		keyList.add("I.SKUG02");
		keyList.add("I.SKUG03");
		map.put("RANGE_SQL",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>(); // RangeSearch2
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.QTYORG");
		keyList2.add("I.PTNROD");
		keyList2.add("I.WARESR");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.WAREKY");
		keyList2.add("SM.ASKU05");
		map.put("RANGE_SQL2",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List keyList3 = new ArrayList<>(); // RangeSearch3
		keyList3.add("LOTA05");
		keyList3.add("LOTA06");
		keyList3.add("LOCAKY");
		map.put("RANGE_SQL3",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		List keyList4 = new ArrayList<>(); // RangeSearch4
		keyList4.add("SW.LOCARV");
		map.put("RANGE_SQL4",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList4));

		List keyList5 = new ArrayList<>(); // RangeSearch5
		keyList5.add("F.PTNRKY");
		keyList5.add("C.CARNUM");
		map.put("RANGE_SQL5",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList5));

		map.setModuleCommand("Outbound", "DL00_ITEM");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// [DL02] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayHeadDL02(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("IF.ORDTYP");
		keyList.add("IF.ORDDAT");
		keyList.add("IF.SEBELN");
		keyList.add("IF.DOCUTY");
		keyList.add("IF.PTNRKY");
		keyList.add("BZ.NAME01");
		keyList.add("IF.SKUKEY");
		map.put("RANGE_SQL",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		// List keyList2 = new ArrayList<>();
		// keyList2.add("IF.SKUKEY");
		// map.put("RANGEITEM", new SqlUtil().getRangeSqlFromList((DataMap)
		// map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		map.setModuleCommand("Outbound", "DL02_HEAD");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	@Transactional(rollbackFor = Exception.class)
	public DataMap saveDL00(DataMap map) throws Exception {
		DataMap result = new DataMap();
		String wareky = "";
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		// // // System.out.println("saveDL00 = " + head);
		String svbelns = "";

		try {

			// Header List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);
				String svbeln = (String) row.get("SVBELN");
				String sposnr = (String) row.get("SPOSNR");
				String docuty = (String) row.get("DOCUTY");

				if (i == 0) {
					svbelns = "'" + svbeln + "'";
				} else {
					svbelns += ("," + "'" + svbeln + "'");
				}
				
				row.setModuleCommand("Outbound", "DL00_HEAD_VALID");
				List<DataMap> validList = commonDao.getList(row);
				for (int j = 0; j < validList.size(); j++) {
					// qtyreq = 0 ?????? ????????? check
					DataMap valid = validList.get(j);
					if (valid == null || valid.isEmpty()) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M1000",
								new String[] { svbeln, sposnr }));
					} else {
						// ???????????? ????????? check
						String c00102 = (String) ((DataMap) validList.get(j)).get("C00102");
						if ("N".equals(c00102)) {
							throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
									"IFWMS_M0030", new String[] { svbeln, sposnr }));
						}
					}
				}

				// Item List ??????
				for (int j = 0; j < item.size(); j++) {


					DataMap itemRow = item.get(j).getMap("map");
					map.clonSessionData(itemRow);

					svbeln = (String) itemRow.get("SVBELN");
					sposnr = (String) itemRow.get("SPOSNR");
					String skukey = (String) itemRow.get("SKUKEY");
					String desc01 = (String) itemRow.get("DESC01");
					int qtyorg =  itemRow.getInt("QTYORG");
					int qtyreq =  itemRow.getInt("QTYREQ");
					


					if (wareky.length() == 0) {
						wareky = "'" + itemRow.getString("WAREKY") + "'";
					} else {
						wareky += ("," + "'" + itemRow.getString("WAREKY") + "'");
					}

					// ?????? ?????? ????????? ?????? ?????? 2018-12-04 ??????
					if (docuty.equals("266") || docuty.equals("267")) {
						if(!itemRow.getString("WAREKY").equals(row.get("WAREKY"))) {
							throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0012",
									new String[] { "" }));
						}
					}

					itemRow.setModuleCommand("Outbound", "DL00_ITEM_VALID");
					DataMap valid = commonDao.getMap(itemRow);
					// ?????? ?????? ?????? Check
					// // // System.out.println("valid = " + valid);
					if (valid == null || valid.isEmpty()) {// if??? ????????? ??????.
					} else {
						String itemValid = (String) valid.get("ITEM_VALID");
						if(!itemRow.getString("WAREKY").equals(row.get("WAREKY"))) {
							if ("04".equals(itemValid)) {
								throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
										"OUT_M0161", new String[] {
												"????????? ?????? ??????\n" + skukey + " " + desc01 + " ?????? ?????????????????? ?????? ?????? ????????? ???????????????." }));
							}
						}
					}

					// ?????????????????? ????????????????????? ??????
					if (qtyorg < qtyreq) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "IFWMS_M0020",
								new String[] { qtyorg + "", qtyreq + "" }));

					}

					// // // System.out.println("qtyorg = " + qtyorg);
					// // // System.out.println("qtyreq = " + qtyreq);

					itemRow.setModuleCommand("Outbound", "DL00_ITEM");
					commonDao.update(itemRow);
					

				}

				row.setModuleCommand("Outbound", "DL00_HEAD");
				commonDao.update(row);

			}
			result.put("SVBELNS", svbelns);
			result.put("WAREKY", wareky);
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL80(DataMap map) throws Exception {

		String result = "";
		List<DataMap> head = map.getList("head");

		try {

			// Header List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				map.put("SEARCHKEY", row.get("SEARCHKEY"));
				map.setModuleCommand("Outbound", "CAR_STATUS_REFINDITEM");
				List<DataMap> updateList = commonDao.getList(map);
				if (updateList == null || updateList.isEmpty()) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",
							new String[] { "* ?????? ????????????  ????????? ???????????? ????????????. *" }));
				}
				for (DataMap updateShpdr : updateList) {
					DataMap row2 = updateShpdr.getMap("map");
					map.clonSessionData(row2);

					row2.put("CASTYN", row.get("CASTYN"));
					row2.put("CASTDT", row.get("CASTDT"));
					row2.put("CASTIM", row.get("CASTIM"));
					row2.put("RECNUM", row.get("RECNUM"));
					row2.put("PERHNO", row.get("PERHNO"));

					row2.setModuleCommand("Outbound", "CAR_STATUS_SHPDR");
					commonDao.update(row2);

				}

			}

			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String createOrderDocDL01(DataMap map) throws Exception {

		String result = "";

		try {
			// ???????????? ??????
			result = createShipmentOrderDocument(map);
			// // // System.out.println("result = " + result);
		} catch (Exception e) {

			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String allocateDL01(DataMap map) throws Exception {

		String result = "";
		try {
			DataMap temp = new DataMap();
			temp.putAll(map);

			// ???????????? ??????
			result = createShipmentOrderDocument(temp);

			// ?????? ??????
			shipmentOrderAllocation(map);

			// result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	private String createShipmentOrderDocument(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		DataMap itemTemp = map.getMap("itemTemp");
		DataMap clsMap = new DataMap();

		String carnum = "";
		String shpoky = "";
		String ownrky = "";
		String wareky = "";
		String svbeln = "";
		String shpokys = "";

		// Header List ??????
		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);
			row.put("SES_LANGUAGE", map.getString("SES_LANGUAGE"));

			ownrky = (String) row.get("OWNRKY");
			wareky = (String) row.get("WAREKY");
			carnum = (String) row.get("CARNUM");
			svbeln = (String) row.get("SVBELN");
			shpoky = (String) row.get("SHPOKY");

			// if(i==0){
			// //??????????????? ??????
			// clsMap.put("WAREKY", wareky);
			// clsMap.setModuleCommand("Outbound", "CLSYN_CHK");
			// DataMap clsChk = commonDao.getMap(clsMap);
			//
			// if(clsChk!=null && "Y".equals(clsChk.getString("CLSYN"))) throw
			// new
			// Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
			// "OUT_M0155",new String[]{"* ?????? ???????????? ????????? ?????????.. *"}));
			//
			// //clsyn update ????????? ????????????(?????? ????????????)
			// clsMap.setModuleCommand("Outbound", "CLSYN");
			// clsMap.put("CLS_YN", "Y");
			// map.clonSessionData(clsMap);
			// commonDao.update(clsMap);
			//
			// //??????????????? ?????? ????????? ????????? ???????????? ?????? ???????????????
			// DataMap falChk = (DataMap)clsMap.clone();
			// falChk.setModuleCommand("Outbound", "OUTBOUND_FALCHK");
			// DataMap falMap = commonDao.getMap(falChk);
			// if(falMap != null && falMap.getInt("CNT") > 0){
			// throw new
			// Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
			// "OUT_M0154",new String[]{"* ?????? ???????????? ????????? ?????????.. *"}));
			// }
			// }

			String docnum = "";

			if (" ".equals(shpoky)) { // ????????????????????? ?????? ?????? ?????? ??????
				row.setModuleCommand("Outbound", "GETDOCNUMBER");
				docnum = commonDao.getMap(row).getString("DOCNUM");
				row.put("SHPOKY", docnum);
				row.put("STATDO", "NEW");
				if (i == 0) {
					shpokys = "'" + docnum + "'";
				} else {
					shpokys += ("," + "'" + docnum + "'");
				}
			} else {
				if (i == 0) {
					shpokys = "'" + shpoky + "'";
				} else {
					shpokys += ("," + "'" + shpoky + "'");
				}
				row.setModuleCommand("Outbound", "SHPDI"); // ???????????? ?????? : SHPDI
				commonDao.delete(row);

				row.setModuleCommand("Outbound", "SHPDH"); // ???????????? ?????? : SHPDH
				commonDao.delete(row);
			}

			shpoky = (String) row.get("SHPOKY");

			row.setModuleCommand("Outbound", "SHPDH"); // ?????????????????? : SHPDH
			commonDao.insert(row);

			String itemSvbeln = "";
			// // // System.out.println("item.size = " + item.size());
			if (item.size() > 0) {
				itemSvbeln = item.get(0).getMap("map").getString("SVBELN");
			}
			// // System.out.println("svbeln = " + svbeln + " itemSvbeln = " +
			// itemSvbeln);
			if (svbeln.equals(itemSvbeln)) {
				// ??????????????? ????????? Item List ??????
				// // System.out.println("item = " + item);
				createShipmentOrderDocumentforItem(map, row, item);
			} else {
				// ?????? ??????
				// // System.out.println("SVBELN = " + row.getString("SVBELN"));
				List<DataMap> itemByHead = itemTemp.getList(row.getString("SVBELN"));
				if (itemByHead == null) {
					row.setModuleCommand("Outbound", "SALES_ORDER_DOC_ITEM_FOR_PARTIAL_ALLOC");
					itemByHead = commonDao.getList(row);
				}

				// // System.out.println("itemByHead = " + itemByHead);
				createShipmentOrderDocumentforItem(map, row, itemByHead);
			}
		}
		// CLS UPDATE N
		// clsMap.put("CLS_YN", "N");
		// commonDao.update(clsMap);

		return shpokys;
	}

	private void createShipmentOrderDocumentforItem(DataMap map, DataMap head, List<DataMap> items) throws Exception {

		String ownrky = (String) head.get("OWNRKY");
		String wareky = (String) head.get("WAREKY");
		String carnum = (String) head.get("CARNUM");
		String shpoky = (String) head.get("SHPOKY");
		String shpoit = (String) head.get("SHPOIT");

		// ??????????????? ????????? Item List ??????
		for (int i = 0; i < items.size(); i++) {

			DataMap row = items.get(i).getMap("map");
			map.clonSessionData(row);

			if ("DL26".equals(map.getString("menuId")) || "DL32".equals(map.getString("menuId"))) {
				row.put("SXBLNR", carnum); // head??? CARNUM
			}
			row.put("SHPOKY", shpoky); // head??? SHPOKY

			if ("".equals(shpoit)) {
				row.put("SHPOIT", (i + 1) * 10);
				row.setModuleCommand("Outbound", "GETDOCNUMBER_ITEM");
				String docnumItem = commonDao.getMap(row).getString("DOCNUM_ITEM");
				row.put("SHPOIT", docnumItem);
			}

			row.put("OWNRKY", ownrky); // head??? OWNRKY
			row.put("WAREKY", wareky); // head??? WAREKY
			row.setModuleCommand("Outbound", "SALES_ORDER_ITEM_CREATE_DOC_VALIDATE");
			List<DataMap> error = commonDao.getList(row);

			for (int j = 0; j < error.size(); j++) {
				if (error.get(j) != null) {
					String skukey = row.getString("SKUKEY");
					String errorMsg = error.get(j).getString("ERROR_MSG");
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), errorMsg,
							new String[] { skukey }));
				}
			}

			// 1?????? ????????? ??????
			if (row.getInt("QTSHPO") < 1) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",
						new String[] { "?????? ????????? 1?????? ????????????. SHPOKY = " + row.getString("SHPOKY") + " SHPOIT = "
								+ row.getString("SHPOIT") + " QTALOC = " + row.getString("QTSHPO") + " QTSHPO = "
								+ row.getString("QTALOC") }));
			} else if (row.getInt("QTALOC") < 0) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",
						new String[] { "?????? ????????? 0?????? ????????????. SHPOKY = " + row.getString("SHPOKY") + " SHPOIT = "
								+ row.getString("SHPOIT") + " QTALOC = " + row.getString("QTSHPO") + " QTSHPO = "
								+ row.getString("QTALOC") }));
			}

			row.put("QTYUOM", row.getString("QTSHPO"));
			row.setModuleCommand("Outbound", "SHPDI"); // ?????????????????? : SHPDI
			commonDao.insert(row);
		}

	}

	public void shipmentOrderAllocation(DataMap map) throws Exception {
		DataMap clsMap = new DataMap();
		List<DataMap> head = map.getList("head");
		// List<DataMap> item = map.getList("item");

		String carnum = "";
		String shpoky = "";
		String ownrky = "";
		String wareky = "";
		String sapKey = "";
		String docnum = "";

		// // System.out.println("head.size() = " + head.size());
		// // System.out.println("head = " + head);
		// Header List ??????

		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			ownrky = (String) row.get("OWNRKY");
			wareky = (String) row.get("WAREKY");
			carnum = (String) row.get("CARNUM");
			sapKey = (String) row.get("SVBELN");
			shpoky = (String) row.get("SHPOKY");

			if (i == 0 && row.getString("OWNRKY").equals("2500")) {
				// ??????????????? ??????
				clsMap.put("WAREKY", wareky);
				clsMap.setModuleCommand("Outbound", "CLSYN_CHK");
				DataMap clsChk = commonDao.getMap(clsMap);

				if (clsChk != null && "Y".equals(clsChk.getString("CLSYN")))
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0155",
							new String[] { "* ?????? ???????????? ????????? ?????????.. *" }));

				// clsyn update ????????? ????????????(?????? ????????????)
				clsMap.setModuleCommand("Outbound", "CLSYN");
				clsMap.put("CLS_YN", "Y");
				map.clonSessionData(clsMap);
				commonDao.update(clsMap);

				// ??????????????? ?????? ????????? ????????? ???????????? ?????? ???????????????
				DataMap falChk = (DataMap) clsMap.clone();
				falChk.setModuleCommand("Outbound", "OUTBOUND_FALCHK");
				DataMap falMap = commonDao.getMap(falChk);
				if (falMap != null && falMap.getInt("CNT") > 0) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0154",
							new String[] { "* ?????? ???????????? ????????? ?????????.. *" }));
				}
			}

			// 2019-02-28 ????????? ?????? [?????? : if("2100".equals(ownrky) &&
			// !"2114".equals(wareky)) ]
			// if(("2100".equals(ownrky) && !"2114".equals(wareky)) ||
			// ("2500".equals(ownrky) && !"2254".equals(wareky))){
			// row.setModuleCommand("Outbound",
			// "SALES_ORDER_ALLOCATE_ITEM_VALIDATE"); //????????? ???????????? ????????? check
			// DataMap validate = commonDao.getMap(row);
			//
			// if(validate == null || validate.isEmpty()){
			// throw new
			// Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
			// "VALID_M0154",new String[]{"* M0154 ????????? ???????????? ????????????. *"}));
			// }
			// }

			String shpmty = (String) row.get("SHPMTY");
			String svbeln = (String) row.get("SVBELN");
			String c00107 = (String) row.get("C00107");
			String procName = " ";

			// // System.out.println(" shpmty +++++ " + shpmty);
			// // System.out.println(" svbeln +++++ " + svbeln);
			// // System.out.println(" c00107 +++++ " + c00107);
			// // System.out.println(" shpoky +++++ " + shpoky);

			row.put("SHPOKY", shpoky);

			if (("266".equals(shpmty) || "267".equals(shpmty))) {
				String sajosvCheck = svbeln.substring(0, 2);
				if ("61".equals(sajosvCheck)) {
					row.setModuleCommand("Outbound", "P_BATCH_ALLOCATION_SV_TRFIT");
				} else if ("Y003".equals(c00107)) {
					row.setModuleCommand("Outbound", "P_BATCH_ALLOCATION");
				} else {
					row.setModuleCommand("Outbound", "P_BATCH_ALLOCATION_TRFIT");
				}
				commonDao.update(row);
			} else {
				row.setModuleCommand("Outbound", "P_BATCH_ALLOCATION");
				commonDao.update(row);
			}

			if (i == 0 && row.getString("OWNRKY").equals("2500")) {
				clsMap.put("CLS_YN", "N");
				commonDao.update(clsMap);
			}
		}

	}

	@Transactional(rollbackFor = Exception.class)
	public String createOrderDocDL02(DataMap map) throws Exception {

		String result = "";

		try {
			// ???????????? ??????
			result = createShipmentOrderDocument_SEBELN(map);

		} catch (Exception e) {

			throw new Exception(e.getMessage());
		}

		return result;
	}

	private String createShipmentOrderDocument_SEBELN(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");

		String carnum = "";
		String shpoky = "";
		String ownrky = "";
		String wareky = "";
		String sebeln = "";
		String shpokys = "";

		// Header List ??????
		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);
			row.put("SES_LANGUAGE", map.getString("SES_LANGUAGE"));

			ownrky = (String) row.get("OWNRKY");
			wareky = (String) row.get("WAREKY");
			carnum = (String) row.get("CARNUM");
			sebeln = (String) row.get("SEBELN");
			shpoky = (String) row.get("SHPOKY");

			String docnum = "";

			if (" ".equals(shpoky)) { // ????????????????????? ?????? ?????? ?????? ??????
				row.setModuleCommand("Outbound", "GETDOCNUMBER");
				docnum = commonDao.getMap(row).getString("DOCNUM");
				row.put("SHPOKY", docnum);
				row.put("STATDO", "NEW");
				if (i == 0) {
					shpokys = "'" + docnum + "'";
				} else {
					shpokys += ("," + "'" + docnum + "'");
				}
			} else {
				if (i == 0) {
					shpokys = "'" + shpoky + "'";
				} else {
					shpokys += ("," + "'" + shpoky + "'");
				}
				row.setModuleCommand("Outbound", "SHPDI"); // ???????????? ?????? : SHPDI
				commonDao.delete(row);

				row.setModuleCommand("Outbound", "SHPDH"); // ???????????? ?????? : SHPDH
				commonDao.delete(row);
			}

			shpoky = (String) row.get("SHPOKY");

			row.setModuleCommand("Outbound", "SHPDH"); // ?????????????????? : SHPDH
			commonDao.insert(row);

			String iSEBELN = "";
			if (item.size() > 0) {
				iSEBELN = item.get(0).getMap("map").getString("SEBELN");
			}

			if (sebeln.equals(iSEBELN)) {
				// // System.out.println("item = " + item);
				// ??????????????? ????????? Item List ??????
				createShipmentOrderDocumentforItem_SEBELN(map, row, item);
			} else {
				row.setModuleCommand("Outbound", "DL02_ITEM");
				List<DataMap> itemByHead = commonDao.getList(row);
				// Head??? ????????? ???????????? ????????? ????????? Item List ?????? ??? ??????
				createShipmentOrderDocumentforItem_SEBELN(map, row, itemByHead);
			}
		}

		return shpokys;
	}

	private void createShipmentOrderDocumentforItem_SEBELN(DataMap map, DataMap head, List<DataMap> items)
			throws Exception {

		String ownrky = (String) head.get("OWNRKY");
		String wareky = (String) head.get("WAREKY");
		String carnum = (String) head.get("CARNUM");
		String shpoky = (String) head.get("SHPOKY");
		String shpoit = (String) head.get("SHPOIT");

		// ??????????????? ????????? Item List ??????
		for (int i = 0; i < items.size(); i++) {

			DataMap row = items.get(i).getMap("map");
			map.clonSessionData(row);
			// // System.out.println("QTSHPO = " + row.getString("QTSHPO"));
			row.put("SXBLNR", carnum); // head??? CARNUM
			row.put("SHPOKY", shpoky); // head??? SHPOKY
			if ("".equals(shpoit)) {
				row.put("SHPOIT", (i + 1) * 10);
				row.setModuleCommand("Outbound", "GETDOCNUMBER_ITEM");
				String docnumItem = commonDao.getMap(row).getString("DOCNUM_ITEM");
				row.put("SHPOIT", docnumItem);
			}

			row.put("OWNRKY", ownrky); // head??? OWNRKY
			row.put("WAREKY", wareky); // head??? WAREKY

			row.put("QTYUOM", row.getString("QTSHPO"));
			row.setModuleCommand("Outbound", "SHPDI"); // ?????????????????? : SHPDI
			commonDao.insert(row);
		}

	}

	@Transactional(rollbackFor = Exception.class)
	public String allocateDL02(DataMap map) throws Exception {

		String result = "";
		try {
			DataMap temp = new DataMap();
			temp.putAll(map);

			// ???????????? ??????
			result = createShipmentOrderDocument_SEBELN(temp);

			// ?????? ??????
			shipmentOrderAllocation(map);

			// result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	// [DL03] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayHeadDL03(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("I.ORDTYP");
		keyList.add("I.ORDDAT");
		keyList.add("I.ERPCDT");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.WARESR");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("I.QTYORG");
		keyList.add("I.OWNRKY");
		keyList.add("I.OWNRKY");
		keyList.add("SM2.SKUG05");
		keyList.add("B2.PTNG08");
		map.put("RANGE_SQL",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.WARESR");
		keyList2.add("I.SKUKEY");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.OWNRKY");
		map.put("RANGE_SQL2",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		map.setModuleCommand("Outbound", "DL03_HEAD");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// [DL03] Item ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayItemDL03(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("I.ORDTYP");
		keyList.add("I.ORDDAT");
		keyList.add("I.ERPCDT");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.WARESR");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("I.QTYORG");
		keyList.add("I.OWNRKY");
		keyList.add("I.OWNRKY");
		keyList.add("SM2.SKUG05");
		keyList.add("B2.PTNG08");
		map.put("RANGE_SQL",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.WARESR");
		keyList2.add("I.SKUKEY");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG");
		keyList2.add("I.OWNRKY");
		keyList2.add("I.OWNRKY");
		map.put("RANGE_SQL2",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		map.setModuleCommand("Outbound", "DL03_ITEM");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	@Transactional(rollbackFor = Exception.class)
	public String acceptDL03(DataMap map) throws Exception {

		String result = "";
		try {
			// ????????????
			result = acceptIfwms113(map);

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	// ????????????
	public String acceptIfwms113(DataMap map) throws Exception {

		List<DataMap> head = map.getList("head");
		// List<DataMap> item = map.getList("item");
		// DataMap itemTemp = map.getMap("itemTemp");

		String svbelns = "";
		// ??????????????? ????????? Head List ??????
		for (int i = 0; i < head.size(); i++) {
			// // System.out.println(" +++++ +++++ ");

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			// ?????? or ?????? ????????? ????????????.
			map.setModuleCommand("SajoCommon", "CMCDV_COMBO");
			map.put("CMCDKY", "SERVINFO");
			String serverInfo = ((DataMap) commonDao.getList(map).get(0)).getString("VALUE_COL");

			// // System.out.println(" +++++ +++++ " + serverInfo);

			String svbeln = (String) row.get("SVBELN");
			String docuty = (String) row.get("DOCUTY");
			String status = "30"; // ????????????
			String result = ""; // Interface ??????
			// // System.out.println(" svbeln +++++ " + svbeln);
			// // System.out.println(" docuty +++++ " + docuty);

			if (i == 0) {
				svbelns = "'" + svbeln + "'";
			} else {
				svbelns += ("," + "'" + svbeln + "'");
			}

			// ????????? ??????????????????
			// ?????? ????????? ????????? ?????? TOSS??? ????????? ?????????.
			if (svbeln.substring(0, 1).equals("1") || svbeln.substring(0, 1).equals("5") || docuty.equals("216")) {
				// TOSS ????????? ??????????????????
				result = poManager.TOSS_NS0090(svbeln, "Y", status);
				if (!"Y".equals(result)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",
							new String[] { "??????????????? ?????????????????????.(TOSS)" }));
				}
			} else {
				result = "Y";
			}
			// // System.out.println(" rtnval +++++ " + result);

			if ("Y".equals(result)) {
				if (!"216".equals(docuty)) {
					result = poManager.SAP_SD0340(svbeln, status); // SAP ??????????????????
				}

				if (!"Y".equals(result)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",
							new String[] { "??????????????? ?????????????????????.(SAP)" }));
				}
				// // System.out.println(" svbeln +++++ " + svbeln);

				// IFWMS113 TABLE ????????? UPDATE
				row.setModuleCommand("Outbound", "ACCEPT");
				commonDao.update(row);
			} else {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",
						new String[] { "??????????????? ?????????????????????.(TOSS)" }));
			}
		}

		return svbelns;
	}

	// [DL04] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayHeadDL04(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("I.ORDTYP");
		keyList.add("I.ORDDAT");
		keyList.add("I.ERPCDT");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.WARESR");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("I.QTYORG");
		keyList.add("I.OWNRKY");
		keyList.add("SM2.SKUG05");
		keyList.add("B2.PTNG08");
		keyList.add("B2.PTNG01");
		keyList.add("B2.PTNG02");
		keyList.add("B2.PTNG03");
		keyList.add("I.SKUG02");
		keyList.add("I.SKUG03");
		map.put("RANGE_SQL",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.WARESR");
		keyList2.add("I.SKUKEY");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG");
		keyList2.add("I.OWNRKY");
		map.put("RANGE_SQL2",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		map.setModuleCommand("Outbound", "DL04_HEAD");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// [DL04] Item ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayItemDL04(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("I.ORDTYP");
		keyList.add("I.ORDDAT");
		keyList.add("I.ERPCDT");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.WARESR");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("I.QTYORG");
		keyList.add("I.OWNRKY");
		keyList.add("SM2.SKUG05");
		keyList.add("B2.PTNG08");
		keyList.add("B2.PTNG01");
		keyList.add("B2.PTNG02");
		keyList.add("B2.PTNG03");
		keyList.add("I.SKUG02");
		keyList.add("I.SKUG03");
		map.put("RANGE_SQL",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>();
		keyList2.add("I.ORDTYP");
		keyList2.add("I.ORDDAT");
		keyList2.add("I.ERPCDT");
		keyList2.add("I.SVBELN");
		keyList2.add("I.DOCUTY");
		keyList2.add("I.OTRQDT");
		keyList2.add("I.PTNRTO");
		keyList2.add("I.PTNROD");
		keyList2.add("I.WARESR");
		keyList2.add("I.SKUKEY");
		keyList2.add("I.DIRSUP");
		keyList2.add("I.DIRDVY");
		keyList2.add("I.QTYORG");
		keyList2.add("I.OWNRKY");
		map.put("RANGE_SQL2",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		map.setModuleCommand("Outbound", "DL04_ITEM");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	@Transactional(rollbackFor = Exception.class)
	public String cancelAcceptDL04(DataMap map) throws Exception {

		String result = "";
		try {
			// ???????????? ??????
			result = CancelSendInterface113(map);

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	// ???????????? ??????
	public String CancelSendInterface113(DataMap map) throws Exception {

		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");

		String svbelns = "";

		// ??????????????? ????????? Header List ??????
		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			// ?????? or ?????? ????????? ????????????.
			map.setModuleCommand("SajoCommon", "CMCDV_COMBO");
			map.put("CMCDKY", "SERVINFO");
			String serverInfo = ((DataMap) commonDao.getList(map).get(0)).getString("VALUE_COL");

			String svbeln = (String) row.get("SVBELN");
			String docuty = (String) row.get("DOCUTY");
			String status = "35"; // ???????????? ??????
			String result = ""; // Interface ??????

			// // System.out.println(" svbeln +++++ " + svbeln);
			// // System.out.println(" docuty +++++ " + docuty);

			if (i == 0) {
				svbelns = "'" + svbeln + "'";
			} else {
				svbelns += ("," + "'" + svbeln + "'");
			}

			// ???????????? ???????????? check
			row.setModuleCommand("Outbound", "DL04_HEADER_VALID_01");
			List<DataMap> valid1 = commonDao.getList(row);
			// // System.out.println(" valid1 ++++" + valid1 + "++++");

			if (valid1.size() != 0) {
				String ifflg = (String) valid1.get(0).get("IFFLG");
				// // System.out.println(" ifflg +++++ " + ifflg);
				if ("D".equals(ifflg)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "IFWMS_M0010",
							new String[] { "" }));
				}
			}

			// ???????????? ?????? - ????????? ????????? ?????? CHECK
			row.setModuleCommand("Outbound", "DL04_HEADER_VALID_02");
			DataMap valid2 = commonDao.getMap(row);

			// // System.out.println(" valid2 ++++" + valid2 + "++++");
			if (valid2 != null) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M1000",
						new String[] { "" }));
			}

			// // System.out.println(" svbeln +++++ " + svbeln);
			// // System.out.println(" docuty +++++ " + docuty);

			// ?????? ????????? ????????? ?????? TOSS??? ????????? ?????????.
			if (svbeln.substring(0, 1).equals("1") || svbeln.substring(0, 1).equals("5") || docuty.equals("216")) {
				result = poManager.TOSS_NS0090(svbeln, "Y", status); // TOSS
																		// ??????????????????
																		// ??????
			}

			// TOSS ?????? ?????? TOSS ????????? ???
			if ("Y".equals(result)) {
				if (!"216".equals(docuty)) {
					result = poManager.SAP_SD0340(svbeln, status); // SAP ??????????????????
																	// ??????
				}
				if (!"Y".equals(result)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",
							new String[] { "???????????? ????????? ?????????????????????.(SAP)" }));
				}
				// IFWMS113 TABLE ????????????(COO102)
				row.setModuleCommand("Outbound", "CANCEL_ACCEPT"); // ???????????? ?????? ??????
				commonDao.update(row);
			} else {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",
						new String[] { "???????????? ????????? ?????????????????????.(TOSS)" }));
			}
		}

		return svbelns;
	}

	@Transactional(rollbackFor = Exception.class)
	public String acceptDL05(DataMap map) throws Exception {

		String result = "";
		try {
			// ???????????? ??????????????? ???????????? ?????? ??? ????????? ?????? ????????? ????????? ????????? ????????? ????????? ??????????????? ??????
			// 2021.05.19 CMU
			List<DataMap> head = map.getList("head");
			// Header List ??????
			for (int i = 0; i < head.size(); i++) {
				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				// ?????? ????????? ?????????
				DataMap trgMap = (DataMap) map.clone();

				map.put("PTNG08", row.getString("PTNG08"));
				map.setModuleCommand("Outbound", "DL05_ITEM");
				List<DataMap> list = commonDao.getList(map);
				trgMap.put("head", list);

				// ????????????
				acceptIfwms113(trgMap);
			}

			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String cancelAcceptDL06(DataMap map) throws Exception {

		String result = "";
		try {
			// ???????????? ??????
			result = CancelSendInterface113(map);

			// result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String allocateDL07(DataMap map) throws Exception {
		DataMap clsMap = new DataMap();
		String result = "";
		try {

			// ???????????? ??????????????? ???????????? ?????? ??? ????????? ?????? ????????? ????????? ????????? ????????? ????????? ??????????????? ??????
			// 2021.05.19 CMU
			List<DataMap> head = map.getList("head");
			// Header List ??????
			for (int i = 0; i < head.size(); i++) {
				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				if (i == 0) {
					// ??????????????? ??????
					clsMap.put("WAREKY", row.getString("WAREKY"));
					clsMap.setModuleCommand("Outbound", "CLSYN_CHK");
					DataMap clsChk = commonDao.getMap(clsMap);

					if (clsChk != null && "Y".equals(clsChk.getString("CLSYN")))
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0155",
								new String[] { "* ?????? ???????????? ????????? ?????????.. *" }));

					// ??????????????? ?????? ????????? ????????? ???????????? ?????? ???????????????
					DataMap falChk = (DataMap) clsMap.clone();
					falChk.setModuleCommand("Outbound", "OUTBOUND_FALCHK");
					DataMap falMap = commonDao.getMap(falChk);
					if (falMap != null && falMap.getInt("CNT") > 0) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0154",
								new String[] { "* ?????? ???????????? ????????? ?????????.. *" }));
					}
				}

				// ?????? ????????? ?????????
				DataMap trgMap = (DataMap) map.clone();
				trgMap.putAll(row);
				trgMap.put("PTNG08", row.getString("PTNG08"));
				trgMap.setModuleCommand("Outbound", "DL07_ITEM_01");
				List<DataMap> list = commonDao.getList(trgMap);
				trgMap.put("head", list);

				// ????????????
				shipmentOrderAllocationComplete(trgMap);
			}

			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public void shipmentOrderAllocationComplete(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		// ??????????????? ????????? Item List ??????
		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			String ownrky = (String) row.get("OWNRKY");
			String wareky = (String) row.get("WAREKY");
			String ptng08 = (String) row.get("PTNG08");
			String orddat = (String) row.get("ORDDAT");
			String unalloccnt = (String) row.get("UNALLCCNT");

			// if (new BigDecimal(unalloccnt).compareTo(BigDecimal.ZERO) > 0){
			// row.setModuleCommand("Outbound", "SZF_GETDL07_CLSYN");
			// DataMap validMap = commonDao.getMap(row);
			// if(validMap == null ) continue;
			// String clsYN = validMap.getString("CHK");
			// if ("N".equals((String)clsYN)){
			// row.setModuleCommand("Outbound", "P_BATCH_GI_COMPLET_DETAIL");
			// commonDao.update(row);
			// }
			row.setModuleCommand("Outbound", "P_BATCH_GI_COMPLET_DETAIL");
			commonDao.update(row);
			// }
		}
	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL10(DataMap map) throws Exception {

		String result = "";
		String svbelns = "";
		try {
			List<DataMap> head = map.getList("head");
			// Header List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				String docuty = (String) row.get("DOCUTY");
				String svbeln = (String) row.get("SVBELN");
				String rtnval = "";

				// // System.out.println(" docuty +++++ " + docuty);
				// // System.out.println(" svbeln +++++ " + svbeln);

				if (i == 0) {
					svbelns = "'" + svbeln + "'";
				} else {
					svbelns += ("," + "'" + svbeln + "'");
				}

				// ?????? ?????? ????????? ?????? ?????? 2018-12-04 ??????
				if (docuty.substring(0, 1).equals("266") || docuty.equals("267")) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0012",
							new String[] { "" }));
				}
				String c00106 = (String) row.get("C00106");
				// // System.out.println(" c00106 +++++ " + c00106);

				if (c00106 == null) {

				} else {
					// String rtnval = changeSap(svbeln, "30");
					result = poManager.SAP_SD0340(svbeln, "30"); // SAP ??????????????????

					if ("Y".equals(result)) {
						row.setModuleCommand("Outbound", "DL10");
						commonDao.update(row);
					}
				}
			}
			result = svbelns;
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String saveTodayDL11(DataMap map) throws Exception {

		String result = "";
		String svbelns = "";
		try {
			List<DataMap> head = map.getList("head");
			// Header List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				String docuty = (String) row.get("DOCUTY");
				String svbeln = (String) row.get("SVBELN");
				String otrqdt = (String) row.get("OTRQDT");
				String rtnval = "";

				// // System.out.println(" docuty +++++ " + docuty);
				// // System.out.println(" svbeln +++++ " + svbeln);
				// // System.out.println(" otrqdt +++++ " + otrqdt);

				if (i == 0) {
					svbelns = "'" + svbeln + "'";
				} else {
					svbelns += ("," + "'" + svbeln + "'");
				}

				result = poManager.SAP_SD0340(svbeln, "30"); // SAP ??????????????????

				if ("Y".equals(result)) {
					row.setModuleCommand("Outbound", "P_CAR_REDISPATCHING_RECALLDAT");
					commonDao.update(row);
				}
			}
			result = svbelns;
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String autoDL11(DataMap map) throws Exception {

		String result = "";
		String svbelns = "";
		try {
			List<DataMap> head = map.getList("head");
			// Header List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				String docuty = (String) row.get("DOCUTY");
				String svbeln = (String) row.get("SVBELN");
				String otrqdt = (String) row.get("OTRQDT");
				String rtnval = "";

				// // System.out.println(" docuty +++++ " + docuty);
				// // System.out.println(" svbeln +++++ " + svbeln);
				// // System.out.println(" otrqdt +++++ " + otrqdt);

				if (i == 0) {
					svbelns = "'" + svbeln + "'";
				} else {
					svbelns += ("," + "'" + svbeln + "'");
				}

				result = poManager.SAP_SD0340(svbeln, "30"); // SAP ??????????????????

				if ("Y".equals(result)) {
					row.setModuleCommand("Outbound", "P_CAR_REDISPATCHING_RETURN");
					commonDao.update(row);
				}
			}
			result = svbelns;
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	// DL11 ????????????????????? ??????
	@Transactional(rollbackFor = Exception.class)
	public DataMap printDL11(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		int resultChk = 0;
		List<DataMap> list = map.getList("list");

		// ?????? or ?????? ????????? ????????????.
		map.setModuleCommand("SajoCommon", "CMCDV_COMBO");
		map.put("CMCDKY", "SERVINFO");
		String serverInfo = ((DataMap) commonDao.getList(map).get(0)).getString("VALUE_COL");

		try {
			for (int i = 0; i < list.size(); i++) {
				DataMap row = list.get(i).getMap("map");

				// ????????? ?????????.
				String result = poManager.SAP_SD0340(row.getString("SVBELN"), "30");
				if ("Y".equals(result)) {
					row.setModuleCommand("Outbound", "DL11_PRINT");
					commonDao.update(row);
				}

				resultChk++;
			}
			rsMap.put("CNT", resultChk);
		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public String closeDL17(DataMap map) throws Exception {

		String result = "";
		String svbelns = "";

		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");
			DataMap itemTemp = map.getMap("itemTemp");
			List<DataMap> itemList = null;

			// List ??????
			for (int i = 0; i < head.size(); i++) {
				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);
				String svbeln = (String) row.get("SVBELN");
				if (i == 0) {
					svbelns = "'" + svbeln + "'";
				} else {
					svbelns += ("," + "'" + svbeln + "'");
				}

				List<DataMap> itemTepList = itemTemp.getList(row.getString("SVBELN"));
				// item == head
				if (item.size() > 0 && ((DataMap) item.get(0).get("map")).getString("SVBELN").equals(svbeln)) {
					itemList = item;
				} else if (itemTepList != null && itemTepList.size() > 0) {
					itemList = itemTepList;
				} else {
					// ????????? ?????????????????? ?????? ????????? ?????? ??????
					map.setModuleCommand("Outbound", "DL17_ITEM");
					map.put("SVBELN", svbeln);
					itemList = commonDao.getList(map);
				}

				for (int j = 0; j < itemList.size(); j++) {
					DataMap itemRow = itemList.get(j).getMap("map");
					map.clonSessionData(itemRow);

					if ("".equals(itemRow.getString("C00103")) || " ".equals(itemRow.getString("C00103"))) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0161",
								new String[] { "* ??????????????? ?????? ?????? ?????????." + itemRow.getString("SVBELN") + " *" }));
					}

					// ???????????? ???????????? CHECK
					itemRow.setModuleCommand("Outbound", "DL17_CLOSE_VALID");
					List<DataMap> valid = commonDao.getList(itemRow);
					if (valid.size() > 0) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "MASTER_M0517",
								new String[] { svbeln }));
					}

					itemRow.setModuleCommand("Outbound", "DL17_CLOSE");
					commonDao.update(itemRow);
				}

			}
			result = svbelns;
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	// [DL23] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayHeadDL23(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("IF.ORDTYP");
		keyList.add("IF.ORDDAT");
		keyList.add("IF.SVBELN");
		keyList.add("IF.DOCUTY");
		keyList.add("IF.OTRQDT");
		keyList.add("DECODE(IF.DOCUTY, '266', IF.WARESR, IF.PTNRTO)");
		keyList.add("IF.PTNROD");
		keyList.add("IF.WARESR");
		keyList.add("IF.QTYORG");
		keyList.add("IF.DIRSUP");
		keyList.add("IF.DIRDVY");
		keyList.add("SM.SKUG05");
		keyList.add("BZ.PTNG08");
		map.put("RANGE_SQL",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>();
		keyList2.add("IF.SKUKEY");
		map.put("RANGE_SQL2",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		String group = map.getString("GRPRL");
		if ("ERPSO".equals(group)) {
			map.setModuleCommand("Outbound", "DL23_HEAD_01");
		} else if ("MOVE".equals(group)) {
			map.setModuleCommand("Outbound", "DL23_HEAD_01");
		} else if ("PTNPUR".equals(group)) {
			map.setModuleCommand("Outbound", "DL23_HEAD_02");
		}
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	@Transactional(rollbackFor = Exception.class)
	public String removeDL24(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		// List<DataMap> item = map.getList("item");
		String shpokys = "";

		// ??????????????? ????????? head List ??????
		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			String shpoky = (String) row.get("SHPOKY");
			String drelin = (String) row.get("DRELIN");
			String sktnum = (String) row.get("STKNUM");
			String shpmty = (String) row.get("SHPMTY");
			// // System.out.println(" shpoky +++++ " + shpoky);
			// // System.out.println(" drelin +++++ " + drelin);
			// // System.out.println(" shpmty +++++ " + shpmty);
			if (i == 0) {
				shpokys = "'" + shpoky + "'";
			} else {
				shpokys += ("," + "'" + shpoky + "'");
			}

			if ("V".equals(drelin)) {
				// ?????? ?????? ?????? ??? ???????????? ?????????.
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0134",
						new String[] { shpoky }));
			}

			row.setModuleCommand("Outbound", "DL24_REMOVE");
			commonDao.update(row);

			if ("299".equals(shpmty)) {
				row.setModuleCommand("Outbound", "P_DEL_SHP_REF");
				commonDao.update(row);
			}

			// ???????????? ??????
			row.setModuleCommand("Outbound", "P_IFWMS113_REMOVE_SHIPMENT");
			commonDao.update(row);
		}

		return shpokys;
	}

	@Transactional(rollbackFor = Exception.class)
	public String confirmOrderDocDL24(DataMap map) throws Exception {
		String result = "";
		try {
			// D/O ??????
			result = confirmShipmentOrderDocument(map);

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String confirmOrderTaskDL24(DataMap map) throws Exception {
		String result = "";
		try {
			// Picking
			result = confirmOrderTask(map);

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return result;
	}

	// D/O ??????
	public String confirmShipmentOrderDocument(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		// List<DataMap> item = map.getList("item");
		DataMap itemTemp = map.getMap("itemTemp");
		int shipsqNum = 0;
		String shpokys = "";
		// ??????????????? ????????? head List ??????
		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			String ownrky = (String) row.get("OWNRKY");
			String wareky = (String) row.get("WAREKY");
			String shipsq = (String) row.get("SHIPSQ");
			String cardat = (String) row.get("CARDAT");
			String shpoky = (String) row.get("SHPOKY");
			String drelin = (String) row.get("DRELIN");
			String statdo = (String) row.get("STATDO");
			String carnum = (String) row.get("CARNUM");
			// // System.out.println(" ownrky +++++ " + ownrky);
			// // System.out.println(" wareky +++++ " + wareky);
			// // System.out.println(" shipsq +++++ " + shipsq);
			// // System.out.println(" cardat +++++ " + cardat);
			// // System.out.println(" shpoky +++++ " + shpoky);
			// // System.out.println(" drelin +++++ " + drelin);
			if (i == 0) {
				shpokys = "'" + shpoky + "'";
			} else {
				shpokys += ("," + "'" + shpoky + "'");
			}

			int ShipsqChk = Integer.parseInt(shipsq);
			if ("2100".equals(ownrky) || "2500".equals(ownrky)) { // ?????? D/O?????????
																	// ????????????
																	// 2019-02-28
																	// ????????? ??????
				if (shipsqNum != ShipsqChk) {
					// ?????? ??????????????? ?????? ????????? ????????? ??????
					row.setModuleCommand("Outbound", "DL24_HEAD_VALID_01");
					DataMap valid = commonDao.getMap(row);
					String ifflg = (String) valid.get("IFFLG");
					// // System.out.println(" valid +++++ " + valid);
					if (valid != null) {
						if ("Y".equals(ifflg)) {
							throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
									"OUT_M0000", new String[] { shipsq, cardat }));
						}
					}
				}
				// 0????????? ?????? ????????? ??????
				row.setModuleCommand("Outbound", "DL24_HEAD_VALID_02");
				DataMap valid = commonDao.getMap(row);
				// // System.out.println(" valid +++++ " + valid);
				if (valid != null) {
					String ifflg = (String) valid.get("IFFLG");
					if ("D".equals(ifflg)) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0153",
								new String[] { shpoky }));
					}
				}
			}
			if ("V".equals(drelin)) {
				// ?????? ?????? ?????? ??? ???????????? ?????????.
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0134",
						new String[] { shpoky }));
			} else {
				// // System.out.println(" statdo +++++ " + statdo);
				// // System.out.println(" carnum +++++ " + carnum);
				if (!"NEW".equals(statdo) && ("".equals(carnum) || " ".equals(carnum))) {
					// ????????? ????????? ????????? ??????
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0151",
							new String[] { shpoky }));
				}
				//
				row.setModuleCommand("Outbound", "DL24_HEAD_VALID_03");
				DataMap valid = commonDao.getMap(row);
				BigDecimal cnt = new BigDecimal((String) valid.get("CNT"));
				if (!"NEW".equals(statdo) && cnt.compareTo(BigDecimal.ONE) != 0) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0152",
							new String[] { shpoky }));
				}

				// D/O ?????? ?????? - ITEM
				// row.setModuleCommand("Outbound", "DL24_ITEM_01");
				// List<DataMap> itemByHead = commonDao.getList(row);
				// ?????? ??????
				List<DataMap> itemByHead = itemTemp.getList(row.getString("SVBELN"));
				if (itemByHead == null) {// ????????? null????????? ?????? 20210515 cmu
					if (map.containsKey("item")) {// ???????????? ????????? ???
						List<DataMap> item = map.getList("item");
						if (item.size() > 0
								&& row.getString("SVBELN").equals(item.get(0).getMap("map").getString("SVBELN"))) { // ????????????
																													// ??????
																													// ????????????
																													// ?????????
																													// ???????????????
																													// ??????
							itemByHead = item;
						} else {// ???????????? ?????? ??????
							row.setModuleCommand("Outbound", "DL30_ITEM_DOC_CONFIRM");
							itemByHead = commonDao.getList(row);
						}
					} else { // ????????? ???????????? ??????
								// ?????? ???????????? ????????? ?????????????????? ??????????????? shpoky, shpoit ????????????
								// ?????? ????????? ???????????????.
						row.setModuleCommand("Outbound", "DL30_ITEM_DOC_CONFIRM");
						itemByHead = commonDao.getList(row);
					}
				}

				for (int j = 0; j < itemByHead.size(); j++) {

					DataMap itemRow = itemByHead.get(j).getMap("map");
					map.clonSessionData(itemRow);
					String itemQtaloc = (String) itemRow.get("QTALOC");
					String itemShpoky = (String) itemRow.get("SHPOKY");
					String itemShpoit = (String) itemRow.get("SHPOIT");
					// // System.out.println(" itemQtaloc +++++ " + itemQtaloc);
					// // System.out.println(" itemShpoky +++++ " + itemShpoky);
					// // System.out.println(" itemShpoit +++++ " + itemShpoit);

					itemRow.setModuleCommand("Outbound", "DL24_CFM_ORD_DOC_ITEM");
					commonDao.update(itemRow);
				}

				// D/O ?????? ?????? - HEAD
				row.put("DRELIN", "V");
				row.setModuleCommand("Outbound", "DL24_CFM_ORD_DOC_HEAD");
				commonDao.update(row);
			}
			shipsqNum = ShipsqChk;
		}

		return shpokys;
	}

	// Remove
	public String remove(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		// List<DataMap> item = map.getList("item");
		String shpokys = "";

		// ??????????????? ????????? head List ??????
		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			String shpoky = (String) row.get("SHPOKY");
			String drelin = (String) row.get("DRELIN");
			String sktnum = (String) row.get("STKNUM");
			String shpmty = (String) row.get("SHPMTY");
			// // System.out.println(" shpoky +++++ " + shpoky);
			// // System.out.println(" drelin +++++ " + drelin);
			// // System.out.println(" shpmty +++++ " + shpmty);
			if (i == 0) {
				shpokys = "'" + shpoky + "'";
			} else {
				shpokys += ("," + "'" + shpoky + "'");
			}

			if ("V".equals(drelin)) {
				// ?????? ?????? ?????? ??? ???????????? ?????????.
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0134",
						new String[] { shpoky }));
			}

			row.setModuleCommand("Outbound", "DL24_REMOVE");
			commonDao.update(row);

			if ("299".equals(shpmty)) {
				row.setModuleCommand("Outbound", "P_DEL_SHP_REF");
				commonDao.update(row);
			}
		}

		return shpokys;
	}

	// Picking
	public String confirmOrderTask(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		// List<DataMap> item = map.getList("item");
		String shpokys = "";

		// ??????????????? ????????? head List ??????
		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			String shpoky = (String) row.get("SHPOKY");
			// // System.out.println(" shpoky +++++ " + shpoky);
			if (i == 0) {
				shpokys = "'" + shpoky + "'";
			} else {
				shpokys += ("," + "'" + shpoky + "'");
			}
			row.setModuleCommand("Outbound", "P_SAJO_PICKING_DRTCMP");
			commonDao.update(row);
		}

		return shpokys;
	}

	@Transactional(rollbackFor = Exception.class)
	public String unallocateDL30(DataMap map) throws Exception {

		String result = "";
		try {
			// ?????? ??????
			result = shipmentOrderUnAllocation(map);

			// result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	public String shipmentOrderUnAllocation(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");

		// ?????? ?????? ?????? ??????x

		// DataMap itemTemp = map.getMap("itemTemp");
		String shpokys = "";
		// ??????????????? ????????? Item List ??????
		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			String ownrky = (String) row.get("OWNRKY");
			String wareky = (String) row.get("WAREKY");
			String shpoky = (String) row.get("SHPOKY");

			// // System.out.println(" ownrky +++++ " + ownrky);
			// // System.out.println(" wareky +++++ " + wareky);
			// // System.out.println(" shpoky +++++ " + shpoky);

			if (i == 0) {
				shpokys = "'" + shpoky + "'";
			} else {
				shpokys += ("," + "'" + shpoky + "'");
			}

			// D/O?????? ?????? ??????
			row.setModuleCommand("Outbound", "DL30_UNALLOCATE_VALID_01");
			DataMap valid = commonDao.getMap(row);
			// // System.out.println(" valid +++++ " + valid);
			if (valid != null) {
				String drelin = (String) valid.get("DRELIN");
				if ("V".equals(drelin)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0134",
							new String[] { shpoky }));
				}
			}

			unallocate(row);
		}

		return shpokys;
	}

	// unallocate
	public void unallocate(DataMap row) throws Exception {

		// 1. ??????????????? TASK??? ????????? ?????? ??? ??? ??????
		row.setModuleCommand("Outbound", "DL30_UNALLOCATE_VALID_02");
		DataMap valid = commonDao.getMap(row);
		// // System.out.println(" valid +++++ " + valid);
		if (valid != null) {
			String taskky = (String) valid.get("TASKKY");
			throw new Exception(
					commonService.getMessageParam(row.getString("SES_LANGUAGE"), "OUT_M0143", new String[] {}));

		}

		// 2. ??????????????? TASK ORDER ?????? ??????.
		row.setModuleCommand("Outbound", "DL30_UNALLOCATE_TARGET");
		List<DataMap> target = commonDao.getList(row);
		int size = target.size();
		// // System.out.println(" size +++++ " + size);
		if (target.size() > 0) {
			// // System.out.println(" size +++++ " + size);
			for (int i = 0; i < target.size(); i++) {

				String taskky = (String) ((DataMap) target.get(0)).get("TASKKY");
				// // System.out.println(" taskky +++++ " + taskky);
				row.put("TASKKY", taskky);

				// 3. ?????????????????? ?????? ??????
				row.setModuleCommand("Outbound", "DL30_UNALLOCATE_ITEM");
				commonDao.delete(row);

				row.setModuleCommand("Outbound", "DL30_UNALLOCATE_HEAD");
				commonDao.delete(row);

				// DRELIN ?????????
				row.setModuleCommand("Outbound", "DL24_REMOVE");
				commonDao.update(row);

			}
		}
	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL26(DataMap map) throws Exception {
		String result = "";
		try {
			//
			createTaskOrderDirect(map);

			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return result;
	}

	// ????????????
	public void createTaskOrderDirect(DataMap map) throws Exception {

		List<DataMap> head = map.getList("head");
		List<DataMap> headAll = map.getList("headAll");
		List<DataMap> item = map.getList("item");
		// DataMap itemTemp = map.getMap("itemTemp");

		DataMap shpdi = head.get(0).getMap("map");
		DataMap tasdh = new DataMap();
		DataMap tasdi = new DataMap();
		DataMap tasdr = new DataMap();
		map.clonSessionData(shpdi);
		map.clonSessionData(tasdi);

		tasdh.put("STATDO", "NEW");
		tasdh.put("TASOTY", "210");
		tasdh.put("DOCCAT", "300");
		tasdh.put("WAREKY", (String) shpdi.get("WAREKY"));

		tasdh.setModuleCommand("Outbound", "DL26_TASDH");
		tasdh = commonDao.getMap(tasdh);

		String tasoty = (String) tasdh.get("TASOTY");
		// // System.out.println(" tasoty +++++" + tasoty + "++++");

		// Validation ??????
		// //////////////////////////////////////////////////////////////////////////////////////////////////////
		// TASDH Validation
		String docdat = (String) tasdh.get("DOCDAT");
		// // System.out.println(" docdat +++++" + docdat + "++++");
		if ("".equals(docdat)) {
			throw new Exception(
					commonService.getMessageParam(map.getString("SES_LANGUAGE"), "IN_M0033", new String[] {}));
		}

		String wareky = (String) tasdh.get("WAREKY");
		// // System.out.println(" wareky +++++" + wareky + "++++");
		if ("".equals(wareky)) {
			throw new Exception(
					commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0401", new String[] {}));
		}

		// // System.out.println("tasdi 0 = " + tasdi);
		// TASKKY ??????
		tasdh.put("DOCUTY", tasoty);
		tasdh.setModuleCommand("Outbound", "GETDOCNUMBER");
		String docnum = commonDao.getMap(tasdh).getString("DOCNUM");
		tasdh.put("TASKKY", docnum);
		tasdi.put("TASKKY", docnum);

		// TASDH ??????
		// //////////////////////////////////////////////////////////////////////////////////////////////////////
		map.clonSessionData(tasdh);
		tasdh.setModuleCommand("Outbound", "TASDH");
		commonDao.update(tasdh);

		// List<DataMap> itemByHead = itemTemp.getList(row.getString("SVBELN"));
		// ??????????????? ????????? item List ??????
		createTaskOrderDirectforItem(map, shpdi, tasdh, tasdi, tasdr, item, docnum);

		// TASDR ??????
		// //////////////////////////////////////////////////////////////////////////////////////////////////////
		for (int i = 0; i < headAll.size(); i++) {
			DataMap row = headAll.get(i).getMap("map");
			row.setModuleCommand("Outbound", "DL26_CRE_TASK_ORD_VALID_03");
			DataMap valid = commonDao.getMap(row);
			// // System.out.println(" valid ++++" + valid + "++++");

			if (valid != null) {
				int result = Integer.parseInt((String) valid.get("RESULT"));
				if (result == 0) {
					row.setModuleCommand("Outbound", "SHPDI_DIRECT");
				} else {
					row.setModuleCommand("Outbound", "SHPDR_DIRECT");
				}
				commonDao.update(row);
			}
		}
	}

	private void createTaskOrderDirectforItem(DataMap map, DataMap shpdi, DataMap tasdh, DataMap tasdi, DataMap tasdr,
			List<DataMap> item, String docnum) throws Exception {
		int taskit = 0;
		String tasoty = (String) tasdh.get("TASOTY");
		String wareky = (String) tasdh.get("WAREKY");

		for (int i = 0; i < item.size(); i++) {

			tasdi = item.get(i).getMap("map");
			// TASDI Validation
			// // System.out.println("tasdi 0 = " + tasdi);
			String locasr = (String) tasdi.get("LOCASR");
			// // System.out.println(" locasr +++++" + locasr + "++++");
			if ("".equals(locasr)) {
				throw new Exception(
						commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0404", new String[] {}));
			}
			String skukey = (String) tasdi.get("SKUKEY");
			// // System.out.println(" skukey +++++" + skukey + "++++");
			if ("".equals(skukey)) {
				throw new Exception(
						commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0406", new String[] {}));
			}

			String smeaky = (String) tasdi.get("SMEAKY");
			// // System.out.println(" smeaky +++++" + smeaky + "++++");
			if ("".equals(smeaky)) {
				throw new Exception(
						commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0407", new String[] {}));
			}

			String suomky = (String) tasdi.get("SUOMKY");
			// // System.out.println(" suomky +++++" + suomky + "++++");
			if ("".equals(suomky)) {
				throw new Exception(
						commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0420", new String[] {}));
			}

			String tmeaky = (String) tasdi.get("TMEAKY");
			// // System.out.println(" tmeaky +++++" + tmeaky + "++++");
			if ("".equals(tmeaky)) {
				throw new Exception(
						commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0407", new String[] {}));
			}

			String tuomky = (String) tasdi.get("TUOMKY");
			// // System.out.println(" tuomky +++++" + tuomky + "++++");
			if ("".equals(tuomky)) {
				throw new Exception(
						commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0420", new String[] {}));
			}

			tasdi.put("STATDO", (String) tasdh.get("STATDO"));
			String statdo = (String) tasdi.get("STATDO");
			// // System.out.println(" statdo +++++" + statdo + "++++");
			String ameaky = (String) tasdi.get("AMEAKY");
			// // System.out.println(" ameaky +++++" + ameaky + "++++");
			if (!"NEW".equals(statdo) && " ".equals(ameaky)) {
				throw new Exception(
						commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0407", new String[] {}));
			}

			String auomky = (String) tasdi.get("AUOMKY");
			// // System.out.println(" auomky +++++" + auomky + "++++");
			if (!"NEW".equals(statdo) && " ".equals(auomky)) {
				throw new Exception(
						commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0420", new String[] {}));
			}

			BigDecimal qttaor = new BigDecimal((String) tasdi.get("QTTAOR"));
			// // System.out.println(" qttaor +++++" + qttaor + "++++");
			if (qttaor.compareTo(BigDecimal.ZERO) == 0) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0021",
						new String[] { "0" }));
			}

			BigDecimal availQty = new BigDecimal((String) tasdi.get("AVAILABLEQTY"));
			// // System.out.println(" availQty +++++" + availQty + "++++");
			if (qttaor.compareTo(availQty) > 0) {
				throw new Exception(
						commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0023", new String[] {}));
			}

			BigDecimal qtcomp = new BigDecimal((String) tasdi.get("QTCOMP"));
			// // System.out.println(" qtcomp +++++" + qtcomp + "++++");
			if (qtcomp.compareTo(qttaor) > 0) {
				throw new Exception(
						commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0033", new String[] {}));
			}

			String locatg = (String) tasdi.get("LOCATG");
			// // System.out.println(" locatg +++++" + locatg + "++++");
			boolean locatgError = false;
			String toloc = "";
			if (tasoty.equals("320") || tasoty.equals("399")) {
				if (locatg.equals("RTNLOC") || locatg.equals("SCRLOC") || locatg.equals("SETLOC")) {
					// locatgError = true;
					toloc = "RTNLOC or SCRLOC or SETLOC";
				}
			}
			if (locatgError) {
				throw new Exception(
						commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0934", new String[] {}));
			}

			if (tasoty.equals("331")) { // ??????????????? ???????????? ??????
				// ???????????? ???????????? check
				tasdi.setModuleCommand("Outbound", "DL26_CRE_TASK_ORD_VALID_01");
				DataMap valid = commonDao.getMap(tasdi);
				// // System.out.println(" valid ++++" + valid + "++++");

				if (valid != null) {
					String result = (String) valid.get("RESULTMSG");
					// // System.out.println(" result +++++ " + result);
					if ("OK".equals(result)) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0011",
								new String[] { result }));
					}
				}
			}

			tasdi.put("WAREKY", wareky);
			tasdi.setModuleCommand("Outbound", "DL26_CRE_TASK_ORD_VALID_02");
			DataMap valid = commonDao.getMap(tasdi);

			// // System.out.println(" valid ++++" + valid + "++++");
			if (valid != null) {
				String slockay = (String) valid.get("SLOCKAY");
				String tlockay = (String) valid.get("TLOCKAY");
				String shmeasky = (String) valid.get("SHMEASKY");
				String simeasky = (String) valid.get("SIMEASKY");
				String siuomkey = (String) valid.get("SIUOMKEY");
				String thmeasky = (String) valid.get("THMEASKY");
				String timeasky = (String) valid.get("TIMEASKY");
				String tioumkey = (String) valid.get("TIUOMKEY");
				// // System.out.println(" slockay +++++ " + slockay);
				// // System.out.println(" tlockay +++++ " + tlockay);
				// // System.out.println(" shmeasky +++++ " + shmeasky);
				// // System.out.println(" siuomkey +++++ " + siuomkey);
				// // System.out.println(" thmeasky +++++ " + thmeasky);
				// // System.out.println(" tioumkey +++++ " + tioumkey);
				if ("".equals(slockay)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0204",
							new String[] { slockay, "" }));
				}
				if ("".equals(tlockay)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0204",
							new String[] { tlockay, "" }));
				}
				if ("".equals(shmeasky)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0207",
							new String[] { shmeasky, "" }));
				}
				if ("".equals(tioumkey)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0220",
							new String[] { tioumkey, "" }));
				}
				if ("".equals(thmeasky)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0207",
							new String[] { thmeasky, "" }));
				}
				if ("".equals(tioumkey)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0220",
							new String[] { tioumkey, "" }));
				}
			} else {
				// WAREKY ??? ?????? ??????
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0204",
						new String[] { wareky, "" }));
			}

			// TASDI ??????
			// //////////////////////////////////////////////////////////////////////////////////////////////////////
			// Task ???????????????
			taskit += 10;
			tasdi.put("SHPOIT", taskit);
			tasdi.setModuleCommand("Outbound", "GETDOCNUMBER_ITEM"); // Task ?????????
																		// ?????? ??????
																		// ??????
			String docnumItem = commonDao.getMap(tasdi).getString("DOCNUM_ITEM");
			tasdi.put("TASKIT", docnumItem);

			// SHPDI ?????? ??????
			// row.put("SHPOKY", shpoky);
			// row.put("SHPOIT", shpoit);
			// // System.out.println("tasdi 1 = " + tasdi);
			tasdi.putAll(shpdi); // TASDI??? ??????????????? ????????? SHPDI ??? ??????
			// // System.out.println("tasdi 2 = " + tasdi);
			tasdi.put("QTDUOM", (String) tasdi.get("BXIQTY"));
			tasdi.setModuleCommand("Outbound", "DL26_SHPDI");
			DataMap selectedShpdi = commonDao.getMap(tasdi);
			tasdi.putAll(selectedShpdi); // TASDI??? ????????? SHPDI ??? ??????
			// // System.out.println("tasdi 3 = " + tasdi);

			// // System.out.println(" qttaor +++++ " + qttaor);
			tasdi.put("QTYUOM", qttaor);
			tasdi.put("TASKKY", docnum);
			tasdi.put("TASKIR", "0001");
			tasdi.put("STATIT", "NEW");

			tasdr.put("QTSTKC", "0");
			tasdi.put("QTTPUM", (String) tasdi.get("PLIQTY"));
			String confirm = (String) tasdi.get("CONFIRM");
			if ("V".equals(confirm) || "1".equals(confirm)) {
				tasdi.put("STATIT", "FPC");
				tasdi.put("QTCOMP", qttaor);
				tasdi.put("LOCAAC", (String) tasdi.get("LOCATG"));
				tasdi.put("SECTAC", (String) tasdi.get("SECTTG"));
				tasdi.put("PAIDAC", (String) tasdi.get("PAIDTG"));
				tasdi.put("TRNUAC", (String) tasdi.get("TRNUTG"));
				tasdi.put("ATRUTY", (String) tasdi.get("TTRUTY"));
				tasdi.put("AMEAKY", (String) tasdi.get("TMEAKY"));
				tasdi.put("AUOMKY", (String) tasdi.get("TUOMKY"));
				tasdi.put("QTAPUM", (String) tasdi.get("QTTPUM"));
				tasdi.put("ADUOKY", (String) tasdi.get("TDUOKY"));
				tasdi.put("QTADUM", (String) tasdi.get("QTTDUM"));
				tasdr.put("QTSTKC", (String) tasdr.get("QTSTKM"));
			}

			tasdi.put("QTSPUM", "0");
			tasdi.put("QTSDUM", "0");
			tasdi.put("PAIDSR", skukey);
			tasdi.put("PAIDTG", skukey);
			tasdi.put("ALSTKY", "");
			// // System.out.println(" QTTPUM +++++ " +
			// (String)tasdi.get("QTTPUM"));
			tasdi.setModuleCommand("Outbound", "DL26_STKKY_LOTA");
			DataMap selectedStokkyLotas = commonDao.getMap(tasdi);
			tasdi.putAll(selectedStokkyLotas); // TASDI??? ????????? SHPDI ??? ??????
			// // System.out.println("selectedStokkyLotas = " +
			// selectedStokkyLotas);

			tasdi.setModuleCommand("Outbound", "TASDI");
			commonDao.update(tasdi);

			tasdr.putAll(tasdi);
			tasdr.put("QTSTKM", qttaor);
			tasdr.setModuleCommand("Outbound", "TASDR");
			commonDao.update(tasdr);

		}
	}

	@Transactional(rollbackFor = Exception.class)
	public String unallocateDL26(DataMap map) throws Exception {
		String result = "";
		try {
			// ???????????? ??????
			directShipmentOrderUnAllocate(map);

			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String removeDL26(DataMap map) throws Exception {
		String result = "";
		try {
			// ??????
			directShipmentOrderAllocationConfirmCancel(map);

			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return result;
	}

	// remove
	public void directShipmentOrderAllocationConfirmCancel(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");

		String shpoky = "";
		String shpoit = "";

		// ??????????????? ????????? item List ??????
		for (int i = 0; i < head.size(); i++) {
			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			shpoky = (String) row.get("SHPOKY");
			shpoit = (String) row.get("SHPOIT");

			// // System.out.println(" shpoky ++++" + shpoky + "++++");
			// // System.out.println(" shpoit ++++" + shpoit + "++++");

			row.setModuleCommand("Outbound", "DL26_REMOVE_UNALLOC_VALID");
			DataMap valid = commonDao.getMap(row);
			// // System.out.println(" valid ++++" + valid + "++++");

			if (valid != null) {
				String result = (String) valid.get("RESULTMSG");
				// // System.out.println(" result +++++ " + result);
				if (Integer.parseInt(result) > 0) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0501",
							new String[] { result }));
				}
			}

			row.setModuleCommand("Outbound", "DL26_REMOVE_VALID");
			valid = commonDao.getMap(row);
			// // System.out.println(" valid ++++" + valid + "++++");

			if (valid != null) {
				String result = (String) valid.get("RESULTMSG");
				// // System.out.println(" result +++++ " + result);
				if (!"0".equals(result)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0501",
							new String[] { result }));
				}
			}

			// TASDI ?????? ??????
			row.setModuleCommand("Outbound", "DL26_DELETE_TASDI");
			commonDao.delete(row);

		}

		// ??????????????? ????????? item List ??????
		for (int i = 0; i < head.size(); i++) {
			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);
			// SHPDI ?????? ??????
			row.setModuleCommand("Outbound", "DL26_DELETE_SHPDI");
			commonDao.delete(row);
		}

		DataMap headRow = head.get(0).getMap("map");
		// SHPDH ?????? ??????
		headRow.setModuleCommand("Outbound", "DL26_DELETE_SHPDH");
		commonDao.delete(headRow);
	}

	// ????????????
	public void directShipmentOrderUnAllocate(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");

		String shpoky = "";
		String shpoit = "";

		// ??????????????? ????????? item List ??????
		for (int i = 0; i < head.size(); i++) {
			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			unallocate(row);

			shpoky = (String) row.get("SHPOKY");
			shpoit = (String) row.get("SHPOIT");
			// // System.out.println(" shpoky +++++ " + shpoky);
			// // System.out.println(" shpoit +++++ " + shpoit);

			row.setModuleCommand("Outbound", "DL26_REMOVE_UNALLOC_VALID");
			DataMap valid = commonDao.getMap(row);
			// // System.out.println(" valid ++++" + valid + "++++");

			if (valid != null) {
				String result = (String) valid.get("RESULTMSG");
				// // System.out.println(" result +++++ " + result);
				if (Integer.parseInt(result) > 0) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0501",
							new String[] { result }));
				}
			}

			row.setModuleCommand("Outbound", "DL26_UNALLOC_SHPDH");
			commonDao.update(row);

			row.setModuleCommand("Outbound", "DL26_UNALLOC_SHPDI");
			commonDao.update(row);

			row.setModuleCommand("Outbound", "DL26_UNALLOC_SHPDR");
			commonDao.update(row);
		}

		/*
		 * //??????????????? ????????? item List ?????? for(int i=0;i<item.size();i++){ DataMap row
		 * = item.get(i).getMap("map"); map.clonSessionData(row);
		 * 
		 * row.put("SHPOKY", shpoky); row.put("SHPOIT", shpoit);
		 * 
		 * row.setModuleCommand("Outbound", "DL26_UNALLOC_VALID"); List<DataMap>
		 * valid = commonDao.getList(row); // // System.out.println(
		 * " valid ++++" + valid + "++++"); //0. ??????????????? TASK??? ????????? ?????? ??? ??? ??????
		 * if(valid.size() > 0){ String taskky =
		 * (String)valid.get(0).get("TASKKY"); // // System.out.println(
		 * " taskky +++++ " + taskky); // if(!"0".equals(taskky)){ throw new
		 * Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE")
		 * , "OUT_M0143",new String[]{})); // } }
		 * 
		 * //???????????? ?????? ?????? Unallocate(row);
		 */
		// row.setModuleCommand("Outbound", "DL26_UNALLOC_TASKKY");
		// List<DataMap> taskkys = commonDao.getList(row);
		// // // System.out.println(" taskkys ++++" + taskkys + "++++");
		// //1. ??????????????? TASK ORDER ?????? ?????????.
		// if(taskkys.size() > 0){
		// for(int j=0;j<taskkys.size();j++){
		// String taskky = (String)taskkys.get(j).get("TASKKY");
		// // // System.out.println(" taskky +++++ " + taskky);
		//
		// }
		// }
		//
		// //2. ??????????????? TASK ORDER ?????? ??????.
		// row.setModuleCommand("Outbound", "DL30_UNALLOCATE_TARGET");
		// List<DataMap> target = commonDao.getList(row);
		// int size = target.size();
		// if(size > 0){
		// for(int j=0; j<size; j++){
		// //3. ?????????????????? ?????? ??????
		// row.setModuleCommand("Outbound", "DL30_UNALLOCATE_ITEM");
		// commonDao.delete(row);
		// row.setModuleCommand("Outbound", "DL30_UNALLOCATE_HEAD");
		// commonDao.delete(row);
		//
		// }
		// }
		//
		// }
	}

	@Transactional(rollbackFor = Exception.class)
	public String confirmOrderDocDL26(DataMap map) throws Exception {
		String result = "";
		try {
			// ????????????????????? ???????????????
			confirmOrderDocS(map);

			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return result;
	}

	// ????????????????????? ???????????????
	// D/O ??????
	public void confirmOrderDocS(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		int shipsqNum = 0;

		// ??????????????? ????????? head List ??????
		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);
			

			String ownrky = (String) row.get("OWNRKY");
			String wareky = (String) row.get("WAREKY");
			String shpoky = (String) row.get("SHPOKY");
			String drelin = (String) row.get("DRELIN");
			String statdo = (String) row.get("STATDO");
			String cardat = (String) row.get("CARDAT");
			String shipsq = (String) row.get("SHIPSQ");
			String carnum = (String) row.get("CARNUM");
			BigDecimal qtaloc = new BigDecimal((String) row.get("QTALOC"));
			// // System.out.println(" ownrky +++++ " + ownrky);
			// // System.out.println(" wareky +++++ " + wareky);
			// // System.out.println(" shpoky +++++ " + shpoky);
			// // System.out.println(" drelin +++++ " + drelin);
			// // System.out.println(" cardat +++++ " + cardat);
			// // System.out.println(" shipsq +++++ " + shipsq);
			// // System.out.println(" qtaloc +++++ " + qtaloc);
			

			if ("Yes".equals(drelin)) {
				// ?????? ?????? ?????? ??? ???????????? ?????????.
				throw new Exception(
						commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0134", new String[] {}));
			} else {

				if ("".equals(carnum) || " ".equals(carnum)) {
					// ????????? ????????? ????????? ??????
					throw new Exception(
							commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0151", new String[] {}));
				}
				

				row.setModuleCommand("Outbound", "DL24_HEAD_VALID_03");
				DataMap valid = commonDao.getMap(row);
				BigDecimal cnt = new BigDecimal((String) valid.get("CNT"));
				if (!"NEW".equals(statdo) && cnt.compareTo(BigDecimal.ONE) != 0) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0152",
							new String[] { shpoky }));
				}

				//????????? ?????? ?????? 2021.08.04
				row.setModuleCommand("Outbound", "DL32_ALLOC_CHK");
				valid = commonDao.getMap(row);
				if(valid != null && valid.getInt("CNT") > 0 )
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0447", new String[] { row.getString("SHPOKY") }));

				// 0????????? ?????? ????????? ??????
				row.setModuleCommand("Outbound", "DL24_HEAD_VALID_02");
				valid = commonDao.getMap(row);
				// // System.out.println(" valid +++++ " + valid);
				if (valid != null) {
					String ifflg = (String) valid.get("IFFLG");
					if ("D".equals(ifflg)) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0153",
								new String[] { shpoky }));
					}
				}

				if (cardat.trim().isEmpty() && qtaloc.compareTo(BigDecimal.ZERO) > 0) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0444",
							new String[] { shpoky }));
				}
				if (carnum.trim().isEmpty() && qtaloc.compareTo(BigDecimal.ZERO) > 0) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0445",
							new String[] { shpoky }));
				}
				if (shipsq.trim().isEmpty() && qtaloc.compareTo(BigDecimal.ZERO) > 0) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0446", new String[] { shpoky }));
				}
				
				// // System.out.println("
				// ++++++++++++++++++++++++++++++++++++++++++++++++++ ");
				// D/O ?????? ?????? - ITEM
				row.setModuleCommand("Outbound", "DL26_ITEM");
				List<DataMap> itemByHead = commonDao.getList(row);
				// // System.out.println(" itemByHead +++++ " + itemByHead);
				for (int j = 0; j < itemByHead.size(); j++) {

					DataMap itemRow = itemByHead.get(j).getMap("map");
					map.clonSessionData(itemRow);
					String itemQtaloc = (String) itemRow.get("QTALOC");
					String itemShpoky = (String) itemRow.get("SHPOKY");
					String itemShpoit = (String) itemRow.get("SHPOIT");
					// // System.out.println(" itemQtaloc +++++ " + itemQtaloc);
					// // System.out.println(" itemShpoky +++++ " + itemShpoky);
					// // System.out.println(" itemShpoit +++++ " + itemShpoit);
					
					itemRow.setModuleCommand("Outbound", "DL24_CFM_ORD_DOC_ITEM");
					commonDao.update(itemRow);
				}

				
				// D/O ?????? ?????? - HEAD
				row.put("DRELIN", "V");
				row.setModuleCommand("Outbound", "DL24_CFM_ORD_DOC_HEAD");
				commonDao.update(row);

			}
		}
	}

	@Transactional(rollbackFor = Exception.class)
	public String removeDL30(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		// List<DataMap> item = map.getList("item");
		String shpokys = "";

		// ??????????????? ????????? head List ??????
		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			String shpoky = (String) row.get("SHPOKY");
			String drelin = (String) row.get("DRELIN");
			String sktnum = (String) row.get("STKNUM");
			String shpmty = (String) row.get("SHPMTY");
			// // System.out.println(" shpoky +++++ " + shpoky);
			// // System.out.println(" drelin +++++ " + drelin);
			// // System.out.println(" shpmty +++++ " + shpmty);
			if (i == 0) {
				shpokys = "'" + shpoky + "'";
			} else {
				shpokys += ("," + "'" + shpoky + "'");
			}

			row.setModuleCommand("Outbound", "P_IFWMS113_REMOVE_SHIPMENT");
			commonDao.update(row);
		}

		return shpokys;
	}

	@Transactional(rollbackFor = Exception.class)
	public String allocateDL30(DataMap map) throws Exception {

		String result = "";
		try {
			DataMap temp = new DataMap();
			temp.putAll(map);

			// ?????? ??????
			result = shipmentOrderAllocationDL30(map);

			// result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	public String shipmentOrderAllocationDL30(DataMap map) throws Exception {

		List<DataMap> head = map.getList("head");
		// List<DataMap> item = map.getList("item");
		DataMap clsMap = new DataMap();

		String carnum = "";
		String shpoky = "";
		String ownrky = "";
		String wareky = "";
		String sapKey = "";
		String docnum = "";
		String shpokys = "";

		// // System.out.println("head.size() = " + head.size());
		// // System.out.println("head = " + head);
		// Header List ??????

		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);

			ownrky = (String) row.get("OWNRKY");
			wareky = (String) row.get("WAREKY");
			carnum = (String) row.get("CARNUM");
			sapKey = (String) row.get("SVBELN");
			shpoky = (String) row.get("SHPOKY");

			if (i == 0) {

				// ??????????????? ??????
				clsMap.put("WAREKY", wareky);
				clsMap.setModuleCommand("Outbound", "CLSYN_CHK");
				DataMap clsChk = commonDao.getMap(clsMap);

				if (clsChk != null && "Y".equals(clsChk.getString("CLSYN")))
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0155",
							new String[] { "* ?????? ???????????? ????????? ?????????.. *" }));

				// clsyn update ????????? ????????????(?????? ????????????)
				clsMap.setModuleCommand("Outbound", "CLSYN");
				clsMap.put("CLS_YN", "Y");
				map.clonSessionData(clsMap);
				commonDao.update(clsMap);

				// ??????????????? ?????? ????????? ????????? ???????????? ?????? ???????????????
				DataMap falChk = (DataMap) clsMap.clone();
				falChk.setModuleCommand("Outbound", "OUTBOUND_FALCHK");
				DataMap falMap = commonDao.getMap(falChk);
				if (falMap != null && falMap.getInt("CNT") > 0) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0154",
							new String[] { "* ?????? ???????????? ????????? ?????????.. *" }));
				}
			}

			if (i == 0) {
				shpokys = "'" + shpoky + "'";
			} else {
				shpokys += ("," + "'" + shpoky + "'");
			}

			// 2019-02-28 ????????? ?????? [?????? : if("2100".equals(ownrky) &&
			// !"2114".equals(wareky)) ]
			// if(("2100".equals(ownrky) && !"2114".equals(wareky)) ||
			// ("2500".equals(ownrky) && !"2254".equals(wareky))){
			// row.setModuleCommand("Outbound",
			// "SALES_ORDER_ALLOCATE_ITEM_VALIDATE"); //????????? ???????????? ????????? check
			// DataMap validate = commonDao.getMap(row);
			//
			// if(validate == null || validate.isEmpty()){
			// throw new
			// Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
			// "VALID_M0154",new String[]{"* M0154 ????????? ???????????? ????????????. *"}));
			// }
			// }

			String shpmty = (String) row.get("SHPMTY");
			String svbeln = (String) row.get("SVBELN");
			String c00107 = (String) row.get("C00107");
			String procName = " ";

			// // System.out.println(" shpmty +++++ " + shpmty);
			// // System.out.println(" svbeln +++++ " + svbeln);
			// // System.out.println(" c00107 +++++ " + c00107);
			// // System.out.println(" shpoky +++++ " + shpoky);

			row.put("SHPOKY", shpoky);

			if (("266".equals(shpmty) || "267".equals(shpmty))) {
				String sajosvCheck = svbeln.substring(0, 2);
				if ("61".equals(sajosvCheck)) {
					row.setModuleCommand("Outbound", "P_BATCH_ALLOCATION_SV_TRFIT");
				} else if ("Y003".equals(c00107)) {
					row.setModuleCommand("Outbound", "P_BATCH_ALLOCATION");
				} else {
					row.setModuleCommand("Outbound", "P_BATCH_ALLOCATION_TRFIT");
				}
				commonDao.update(row);
			} else {
				row.setModuleCommand("Outbound", "P_BATCH_ALLOCATION");
				commonDao.update(row);
			}
		}

		clsMap.put("CLS_YN", "N");
		commonDao.update(clsMap);
		return shpokys;
	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL31(DataMap map) throws Exception {

		String result = "";
		try {
			List<DataMap> head = map.getList("head");
			// Header List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				String rtnval = "";
				String ownrky = (String) row.get("OWNRKY");
				String locaky = (String) row.get("LOCAKY");
				String skukey = (String) row.get("SKUKEY");
				String shpoky = (String) row.get("SHPOKY");
				String shpoit = (String) row.get("SHPOIT");

				// // System.out.println(" ownrky +++++ " + ownrky);
				// // System.out.println(" locaky +++++ " + locaky);
				// // System.out.println(" skukey +++++ " + skukey);
				// // System.out.println(" shpoky +++++ " + shpoky);
				// // System.out.println(" shpoit +++++ " + shpoit);

				row.setModuleCommand("Outbound", "DL31_TASDI");
				DataMap sTASDI = commonDao.getMap(row);
				// // System.out.println(" sTASDI +++++ " + sTASDI);
				String taskky = sTASDI.getString("TASKKY");
				row.setModuleCommand("Outbound", "DL31_TASDI");
				commonDao.delete(row);

				row.put("TASKKY", taskky);
				row.setModuleCommand("Outbound", "DL31_TASDH");
				commonDao.delete(row);

				row.setModuleCommand("Outbound", "DL31_SHPDH");
				DataMap sSHPDH = commonDao.getMap(row);
				// // System.out.println(" sSHPDH +++++ " + sSHPDH);

				String shpmty = sSHPDH.getString("SHPMTY");
				String tasoty = "299".equals(shpmty) ? "208" : "210";
				// // System.out.println(" tasoty +++++ " + tasoty);
				// TASKKY ??????
				row.put("DOCUTY", tasoty);
				row.setModuleCommand("Outbound", "GETDOCNUMBER");
				taskky = commonDao.getMap(row).getString("DOCNUM");

				DataMap iTASDH = new DataMap();
				DataMap iTASDI = new DataMap();
				DataMap iTASDR = new DataMap();

				iTASDH.put("TASKKY", taskky);
				iTASDH.put("WAREKY", (String) sSHPDH.get("WAREKY"));
				iTASDH.put("TASOTY", tasoty);
				iTASDH.put("DOCDAT", (String) sSHPDH.get("DOCDAT"));
				iTASDH.put("DOCCAT", "300");
				iTASDH.put("DRELIN", (String) sSHPDH.get("DRELIN"));
				iTASDH.put("STATDO", " ");
				iTASDH.put("QTTAOR", "0");
				iTASDH.put("QTCOMP", "0");
				iTASDH.put("TSPKEY", " ");
				iTASDH.put("DOORKY", " ");
				iTASDH.put("WARETG", (String) sSHPDH.get("WAREKY"));
				iTASDH.put("PTNRKY", (String) sSHPDH.get("DPTNKY"));
				iTASDH.put("AREAKY", " ");
				iTASDH.put("PTNRTY", " ");
				iTASDH.put("PTNRNM", " ");
				iTASDH.put("USRID1", (String) sSHPDH.get("USRID1"));
				iTASDH.put("UNAME1", (String) sSHPDH.get("UNAME1"));
				iTASDH.put("DEPTID1", (String) sSHPDH.get("DEPTID1"));
				iTASDH.put("DNAME1", (String) sSHPDH.get("DNAME1"));
				iTASDH.put("USRID2", (String) sSHPDH.get("USRID2"));
				iTASDH.put("UNAME2", (String) sSHPDH.get("UNAME2"));
				iTASDH.put("DEPTID2", (String) sSHPDH.get("DEPTID2"));
				iTASDH.put("DNAME2", (String) sSHPDH.get("DNAME2"));
				iTASDH.put("USRID3", (String) sSHPDH.get("USRID3"));
				iTASDH.put("UNAME3", (String) sSHPDH.get("UNAME3"));
				iTASDH.put("DEPTID3", (String) sSHPDH.get("DEPTID3"));
				iTASDH.put("DNAME3", (String) sSHPDH.get("DNAME3"));
				iTASDH.put("USRID4", (String) sSHPDH.get("USRID4"));
				iTASDH.put("UNAME4", (String) sSHPDH.get("UNAME4"));
				iTASDH.put("DEPTID4", (String) sSHPDH.get("DEPTID4"));
				iTASDH.put("DNAME4", (String) sSHPDH.get("DNAME4"));
				iTASDH.put("DOCTXT", (String) sSHPDH.get("DOCTXT"));

				int taskit = sSHPDH.getInt("QTTAOR");

				// // System.out.println(" iTASDH +++++ " + iTASDH);

				row.setModuleCommand("Outbound", "DL31_SHPDI");
				DataMap sSHPDI = commonDao.getMap(row);

				// // System.out.println(" sSHPDI +++++ " + sSHPDI);

				String qtshpo = sSHPDI.getString("QTSHPO");
				String qtaloc = sSHPDI.getString("QTALOC");
				String qtsalo = row.getString("QTSALO");
				String qttaor = sSHPDI.getString("QTTAOR");

				// // System.out.println(" qtshpo +++++ " + qtshpo);
				// // System.out.println(" qtaloc +++++ " + qtaloc);
				// // System.out.println(" qtsalo +++++ " + qtsalo);
				// // System.out.println(" qttaor +++++ " + qttaor);

				if (new Integer(qtsalo) > new Integer(qtshpo)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0334",
							new String[] { shpoky }));
				}

				row.setModuleCommand("Outbound", "DL31_STKKY");
				DataMap sSTKKY = commonDao.getMap(row);

				// // System.out.println(" sSTKKY +++++ " + sSTKKY);
				if (new BigDecimal(qtsalo).compareTo(BigDecimal.ZERO) > 0) {
					iTASDI.put("TASKKY", taskky);
					taskit += 10;
					iTASDI.put("TASKIT", StringUtil.leftPad(String.valueOf(taskit), "0", 6));
					;
					iTASDI.put("TASKTY", "PK");
					iTASDI.put("RSNCOD", "MANU");
					iTASDI.put("STATIT", "NEW");
					String qtsiwh = sSTKKY.getString("QTSIWH");
					if (new BigDecimal(qtsalo).compareTo(new BigDecimal(qtsiwh)) > 0) {
						iTASDI.put("QTTAOR", qtsiwh);
						iTASDI.put("QTYUOM", qtsiwh);
						row.put("QTSALO", new BigDecimal(qtsalo).subtract(new BigDecimal(qtsiwh)));
					} else {
						iTASDI.put("QTTAOR", qtsalo);
						iTASDI.put("QTYUOM", qtsalo);
						row.put("QTSALO", BigDecimal.ZERO);
						sSTKKY.put("QTSIWH", qttaor);

					}
					iTASDI.put("QTCOMP", "0");
					iTASDI.put("OWNRKY", sSTKKY.getString("OWNRKY"));
					iTASDI.put("SKUKEY", sSTKKY.getString("SKUKEY"));
					iTASDI.put("LOTNUM", sSTKKY.getString("LOTNUM"));
					iTASDI.put("ACTCDT", "00000000");
					iTASDI.put("ACTCTI", "000000");
					iTASDI.put("TKFLKY", " ");
					iTASDI.put("STEPNO", " ");
					iTASDI.put("LSTTFL", " ");
					iTASDI.put("LOCASR", sSTKKY.getString("LOCAKY"));
					iTASDI.put("SECTSR", sSTKKY.getString("SECTID"));
					iTASDI.put("PAIDSR", sSTKKY.getString("PACKID"));
					iTASDI.put("TRNUSR", sSTKKY.getString("TRNUID"));
					iTASDI.put("STRUTY", " ");
					iTASDI.put("SMEAKY", sSTKKY.getString("MEASKY"));
					iTASDI.put("SUOMKY", sSTKKY.getString("UOMKEY"));
					iTASDI.put("QTSPUM", sSTKKY.getString("QTPUOM"));
					iTASDI.put("SDUOKY", sSTKKY.getString("DUOMKY"));
					iTASDI.put("QTSDUM", sSTKKY.getString("QTDUOM"));
					iTASDI.put("LOCATG", sSTKKY.getString("SHPLOC"));
					iTASDI.put("SECTTG", sSTKKY.getString("SECTID"));
					iTASDI.put("PAIDTG", sSTKKY.getString("PACKID"));
					iTASDI.put("TRNUTG", sSTKKY.getString("TRNUID"));
					iTASDI.put("TTRUTY", " ");
					iTASDI.put("TMEAKY", sSTKKY.getString("MEASKY"));
					iTASDI.put("TUOMKY", sSTKKY.getString("UOMKEY"));
					iTASDI.put("QTTPUM", sSTKKY.getString("QTPUOM"));
					iTASDI.put("TDUOKY", sSTKKY.getString("DUOMKY"));
					iTASDI.put("QTTDUM", sSTKKY.getString("QTDUOM"));
					iTASDI.put("LOCAAC", " ");
					iTASDI.put("SECTAC", " ");
					iTASDI.put("PAIDAC", " ");
					iTASDI.put("TRNUAC", " ");
					iTASDI.put("ATRUTY", " ");
					iTASDI.put("AMEAKY", " ");
					iTASDI.put("AUOMKY", " ");
					iTASDI.put("QTAPUM", "0");
					iTASDI.put("ADUOKY", " ");
					iTASDI.put("QTADUM", "0");
					iTASDI.put("REFDKY", sSHPDI.getString("SHPOKY"));
					iTASDI.put("REFDIT", sSHPDI.getString("SHPOIT"));
					iTASDI.put("REFCAT", "300");
					iTASDI.put("PURCKY", sSTKKY.getString("PURCKY"));
					iTASDI.put("PURCIT", sSTKKY.getString("PURCIT"));
					iTASDI.put("ASNDKY", sSTKKY.getString("ASNDKY"));
					iTASDI.put("ASNDIT", sSTKKY.getString("ASNDIT"));
					iTASDI.put("RECVKY", sSTKKY.getString("RECVKY"));
					iTASDI.put("RECVIT", sSTKKY.getString("RECVIT"));
					iTASDI.put("SHPOKY", sSHPDI.getString("SHPOKY"));
					iTASDI.put("SHPOIT", sSHPDI.getString("SHPOIT"));
					iTASDI.put("GRPOKY", sSHPDI.getString("GRPOKY"));
					iTASDI.put("GRPOIT", sSHPDI.getString("GRPOIT"));
					iTASDI.put("SADJKY", sSHPDI.getString("SADJKY"));
					iTASDI.put("SADJIT", sSHPDI.getString("SADJIT"));
					iTASDI.put("SDIFKY", sSHPDI.getString("SDIFKY"));
					iTASDI.put("SDIFIT", sSHPDI.getString("SDIFIT"));
					iTASDI.put("PHYIKY", sSHPDI.getString("PHYIKY"));
					iTASDI.put("PHYIIT", sSHPDI.getString("PHYIIT"));
					iTASDI.put("DROPID", " ");
					iTASDI.put("DESC01", sSHPDI.getString("DESC01"));
					iTASDI.put("DESC02", sSHPDI.getString("DESC02"));
					iTASDI.put("ASKU01", sSHPDI.getString("ASKU01"));
					iTASDI.put("ASKU02", sSHPDI.getString("ASKU02"));
					iTASDI.put("ASKU03", sSHPDI.getString("ASKU03"));
					iTASDI.put("ASKU04", sSHPDI.getString("ASKU04"));
					iTASDI.put("ASKU05", sSHPDI.getString("ASKU05"));
					iTASDI.put("EANCOD", sSHPDI.getString("EANCOD"));
					iTASDI.put("GTINCD", sSHPDI.getString("GTINCD"));
					iTASDI.put("SKUG01", sSHPDI.getString("SKUG01"));
					iTASDI.put("SKUG02", sSHPDI.getString("SKUG02"));
					iTASDI.put("SKUG03", sSHPDI.getString("SKUG03"));
					iTASDI.put("SKUG04", sSHPDI.getString("SKUG04"));
					iTASDI.put("SKUG05", sSHPDI.getString("SKUG05"));
					iTASDI.put("GRSWGT", sSHPDI.getString("GRSWGT"));
					iTASDI.put("NETWGT", sSHPDI.getString("NETWGT"));
					iTASDI.put("WGTUNT", sSHPDI.getString("WGTUNT"));
					iTASDI.put("LENGTH", sSHPDI.getString("WGTUNT"));
					iTASDI.put("WIDTHW", sSHPDI.getString("WIDTHW"));
					iTASDI.put("HEIGHT", sSHPDI.getString("HEIGHT"));
					iTASDI.put("CUBICM", sSHPDI.getString("CUBICM"));
					iTASDI.put("CAPACT", sSHPDI.getString("CAPACT"));
					iTASDI.put("WORKID", " ");
					iTASDI.put("WORKNM", " ");
					iTASDI.put("HHTTID", " ");
					iTASDI.put("AREAKY", sSHPDI.getString("AREAKY"));
					iTASDI.put("LOTA01", sSHPDI.getString("LOTA01"));
					iTASDI.put("LOTA02", sSHPDI.getString("LOTA02"));
					iTASDI.put("LOTA03", sSHPDI.getString("LOTA03"));
					iTASDI.put("LOTA04", sSHPDI.getString("LOTA04"));
					iTASDI.put("LOTA05", sSHPDI.getString("LOTA05"));
					iTASDI.put("LOTA06", sSHPDI.getString("LOTA06"));
					iTASDI.put("LOTA07", sSHPDI.getString("LOTA07"));
					iTASDI.put("LOTA08", sSHPDI.getString("LOTA08"));
					iTASDI.put("LOTA09", sSHPDI.getString("LOTA09"));
					iTASDI.put("LOTA10", sSHPDI.getString("LOTA10"));
					iTASDI.put("LOTA11", sSHPDI.getString("LOTA11"));
					iTASDI.put("LOTA12", sSHPDI.getString("LOTA12"));
					iTASDI.put("LOTA13", sSHPDI.getString("LOTA13"));
					iTASDI.put("LOTA14", sSHPDI.getString("LOTA14"));
					iTASDI.put("LOTA15", sSHPDI.getString("LOTA15"));
					iTASDI.put("LOTA16", sSHPDI.getString("LOTA16"));
					iTASDI.put("LOTA17", sSHPDI.getString("LOTA17"));
					iTASDI.put("LOTA18", sSHPDI.getString("LOTA18"));
					iTASDI.put("LOTA19", sSHPDI.getString("LOTA19"));
					iTASDI.put("LOTA20", sSHPDI.getString("LOTA20"));
					iTASDI.put("PTLT01", sSHPDI.getString("PTLT01"));
					iTASDI.put("PTLT02", sSHPDI.getString("PTLT02"));
					iTASDI.put("PTLT03", sSHPDI.getString("PTLT03"));
					iTASDI.put("PTLT04", sSHPDI.getString("PTLT04"));
					iTASDI.put("PTLT05", sSHPDI.getString("PTLT05"));
					iTASDI.put("PTLT06", sSHPDI.getString("PTLT06"));
					iTASDI.put("PTLT07", sSHPDI.getString("PTLT07"));
					iTASDI.put("PTLT08", sSHPDI.getString("PTLT08"));
					iTASDI.put("PTLT09", sSHPDI.getString("PTLT09"));
					iTASDI.put("PTLT10", sSHPDI.getString("PTLT10"));
					iTASDI.put("PTLT11", sSHPDI.getString("PTLT11"));
					iTASDI.put("PTLT12", sSHPDI.getString("PTLT12"));
					iTASDI.put("PTLT13", sSHPDI.getString("PTLT13"));
					iTASDI.put("PTLT14", sSHPDI.getString("PTLT14"));
					iTASDI.put("PTLT15", sSHPDI.getString("PTLT15"));
					iTASDI.put("PTLT16", sSHPDI.getString("PTLT16"));
					iTASDI.put("PTLT17", sSHPDI.getString("PTLT17"));
					iTASDI.put("PTLT18", sSHPDI.getString("PTLT18"));
					iTASDI.put("PTLT19", sSHPDI.getString("PTLT19"));
					iTASDI.put("PTLT20", sSHPDI.getString("PTLT20"));
					iTASDI.put("AWMSNO", sSHPDI.getString("AWMSNO"));
					iTASDI.put("AWMSTS", " ");
					iTASDI.put("SMANDT", sSHPDI.getString("SMANDT"));
					iTASDI.put("SEBELN", sSHPDI.getString("SEBELN"));
					iTASDI.put("SEBELP", sSHPDI.getString("SEBELP"));
					iTASDI.put("SZMBLNO", sSHPDI.getString("SZMBLNO"));
					iTASDI.put("SZMIPNO", sSHPDI.getString("SZMIPNO"));
					iTASDI.put("STRAID", sSHPDI.getString("STRAID"));
					iTASDI.put("SVBELN", sSHPDI.getString("SVBELN"));
					iTASDI.put("SPOSNR", sSHPDI.getString("SPOSNR"));
					iTASDI.put("STKNUM", sSHPDI.getString("STKNUM"));
					iTASDI.put("STPNUM", sSHPDI.getString("STPNUM"));
					iTASDI.put("SWERKS", sSHPDI.getString("SWERKS"));
					iTASDI.put("SLGORT", sSHPDI.getString("SLGORT"));
					iTASDI.put("SDATBG", sSHPDI.getString("SDATBG"));
					iTASDI.put("STDLNR", sSHPDI.getString("STDLNR"));
					iTASDI.put("SSORNU", sSHPDI.getString("SSORNU"));
					iTASDI.put("SSORIT", sSHPDI.getString("SSORIT"));
					iTASDI.put("SMBLNR", sSHPDI.getString("SMBLNR"));
					iTASDI.put("SZEILE", sSHPDI.getString("SZEILE"));
					iTASDI.put("SMJAHR", sSHPDI.getString("SMJAHR"));
					iTASDI.put("SXBLNR", sSHPDI.getString("SXBLNR"));
					iTASDI.put("SAPSTS", sSHPDI.getString("SAPSTS"));
					iTASDI.put("ALSTKY", sSHPDI.getString("ALSTKY"));

					iTASDR.put("TASKKY", taskky);
					iTASDR.put("TASKIT", sSHPDI.getString("TASKIT"));
					iTASDR.put("TASKIR", "0001");
					iTASDR.put("STOKKY", sSTKKY.getString("STOKKY"));
					iTASDR.put("QTSTKM", sSHPDI.getString("QTTAOR"));
					iTASDR.put("TASTKC", "0");
				}

				if (new BigDecimal(qtsalo).compareTo(BigDecimal.ZERO) != 0) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0000",
							new String[] { "" }));
				}

				if (iTASDH.getString("STATDO").equals(" ")) {
					iTASDH.put("STATDO", "NEW");
					map.clonSessionData(iTASDH);
					// // System.out.println(" iTASDH +++++ " + iTASDH);
					iTASDH.setModuleCommand("Outbound", "TASDH");
					commonDao.update(iTASDH);
				}

				map.clonSessionData(iTASDI);
				// // System.out.println(" iTASDI +++++ " + iTASDI);
				iTASDI.setModuleCommand("Outbound", "TASDI");
				commonDao.update(iTASDI);

				map.clonSessionData(iTASDR);
				iTASDR.put("TASKIT", iTASDI.getString("TASKIT"));
				// // System.out.println(" iTASDR +++++ " + iTASDR);
				iTASDR.setModuleCommand("Outbound", "TASDR");
				commonDao.update(iTASDR);

				/*
				 * //?????? ?????? ????????? ?????? ?????? 2018-12-04 ?????? if (docuty.substring(0,
				 * 1).equals("266") || docuty.equals("267")){ throw new
				 * Exception(commonService.getMessageParam(map.getString(
				 * "SES_LANGUAGE"), "VALID_M0012",new String[]{""})); } String
				 * c00106 = (String)row.get("C00106"); // // System.out.println(
				 * " c00106 +++++ " + c00106);
				 * 
				 * if(c00106 == null){
				 * 
				 * }else{ // String rtnval = changeSap(svbeln, "30"); //
				 * if("Y".equals(rtnval)){ //
				 * super.nativeExecuteUpdate("IFWMS113.SETHEADER.RETURNUPDATE",
				 * sqlParams); // } row.setModuleCommand("Outbound", "DL10");
				 * commonDao.update(row); }
				 */
			}
			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	// [JT01] ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayJT01(DataMap map) throws Exception {

		map.setModuleCommand("Outbound", "JT01");

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("I.ORDTYP");
		keyList.add("I.ORDDAT");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.WARESR");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("SM.ASKU05");
		keyList.add("B2.PTNG08");
		keyList.add("B2.PTNG01");
		keyList.add("B2.PTNG02");
		keyList.add("B2.PTNG03");
		keyList.add("W.LOCARV");
		keyList.add("C.CARNUM");
		keyList.add("PK.PICGRP");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List<DataMap> list = commonDao.getList(map);

		return list;
	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL34(DataMap map) throws Exception {

		String result = "";
		String sCheck = "";
		boolean bshipsqchk = true;
		ArrayList<String> alSqCheck = new ArrayList<String>();

		try {
			List<DataMap> item = map.getList("item");
			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "DL34_ITEM");
				commonDao.update(row);
			}
			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String autoDL34(DataMap map) throws Exception {

		String result = "";
		String shipsq = map.getString("SHIPSQ");

		try {
			List<DataMap> item = map.getList("item");

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "DL34_ITEM_VALID_03");
				List<DataMap> valid = commonDao.getList(row);
				// // System.out.println(" valid1 ++++" + valid + "++++");

				if (valid.size() > 0) {
					for (int j = 0; j < item.size(); j++) {
						String shipchk = (String) valid.get(j).get("SHIPCHK");
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0000",
								new String[] { shipchk }));
					}
				}

				row.put("SHIPSQ", shipsq);
				row.setModuleCommand("Outbound", "P_CAR_DISPATCHING_AUTO");
				commonDao.update(row);
			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String auto2DL34(DataMap map) throws Exception {

		String result = "";
		String shipsq = map.getString("SHIPSQ");

		try {
			List<DataMap> item = map.getList("item");

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "DL34_ITEM_VALID_03");
				List<DataMap> valid = commonDao.getList(row);
				// // System.out.println(" valid1 ++++" + valid + "++++");

				if (valid.size() > 0) {
					for (int j = 0; j < item.size(); j++) {
						String shipchk = (String) valid.get(j).get("SHIPCHK");
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0000",
								new String[] { shipchk }));
					}
				}

				row.put("SHIPSQ", shipsq);
				row.setModuleCommand("Outbound", "P_CAR_DISPATCHING_AUTO2");
				commonDao.update(row);
			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String fixedDL34(DataMap map) throws Exception {

		String result = "";
		String shipsq = map.getString("SHIPSQ");

		try {
			List<DataMap> item = map.getList("item");

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "DL34_ITEM_VALID_03");
				List<DataMap> valid = commonDao.getList(row);
				// // System.out.println(" valid1 ++++" + valid + "++++");

				if (valid.size() > 0) {
					for (int j = 0; j < item.size(); j++) {
						String shipchk = (String) valid.get(j).get("SHIPCHK");
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0000",
								new String[] { shipchk }));
					}
				}

				row.put("SHIPSQ", shipsq);
				row.setModuleCommand("Outbound", "P_CAR_DISPATCHING_FIXED");
				commonDao.update(row);
			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String fixed2DL34(DataMap map) throws Exception {

		String result = "";
		String shipsq = map.getString("SHIPSQ");

		try {
			List<DataMap> item = map.getList("item");

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "DL34_ITEM_VALID_03");
				List<DataMap> valid = commonDao.getList(row);
				// // System.out.println(" valid1 ++++" + valid + "++++");

				if (valid.size() > 0) {
					for (int j = 0; j < item.size(); j++) {
						String shipchk = (String) valid.get(j).get("SHIPCHK");
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0000",
								new String[] { shipchk }));
					}
				}

				row.put("SHIPSQ", shipsq);
				row.setModuleCommand("Outbound", "P_CAR_DISPATCHING_FIXED2");
				commonDao.update(row);
			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String confirmOrderDocDL34(DataMap map) throws Exception {
		String result = "";
		try {
			// D/O ??????
			confirmShipmentOrderDocumentToSend(map);

			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return result;
	}

	// D/O ??????
	public void confirmShipmentOrderDocumentToSend(DataMap map) throws Exception {
		// List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		int shipsqNum = 0;

		// ??????????????? ????????? head List ??????
		for (int i = 0; i < item.size(); i++) {

			DataMap row = item.get(i).getMap("map");
			map.clonSessionData(row);

			String ownrky = (String) row.get("OWNRKY");
			String wareky = (String) row.get("WAREKY");
			String shipsq = (String) row.get("SHIPSQ");
			String cardat = (String) row.get("CARDAT");
			String shpoky = (String) row.get("SHPOKY");
			String drelin = (String) row.get("DRELIN");
			String statdo = (String) row.get("STATDO");
			String carnum = (String) row.get("CARNUM");
			// // System.out.println(" ownrky +++++ " + ownrky);
			// // System.out.println(" wareky +++++ " + wareky);
			// // System.out.println(" shipsq +++++ " + shipsq);
			// // System.out.println(" cardat +++++ " + cardat);
			// // System.out.println(" shpoky +++++ " + shpoky);
			// // System.out.println(" drelin +++++ " + drelin);

			int ShipsqChk = Integer.parseInt(shipsq);

			if (shipsqNum != ShipsqChk) {
				// ?????? ??????????????? ?????? ????????? ????????? ??????
				row.setModuleCommand("Outbound", "DL24_HEAD_VALID_01");
				DataMap valid = commonDao.getMap(row);
				String ifflg = (String) valid.get("IFFLG");
				// // System.out.println(" valid +++++ " + valid);
				if (valid != null) {
					if ("Y".equals(ifflg)) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0000",
								new String[] { cardat, shipsq, }));
					}
				}
			}

			// 0????????? ?????? ????????? ??????
			row.setModuleCommand("Outbound", "DL24_HEAD_VALID_02");
			DataMap valid = commonDao.getMap(row);
			// // System.out.println(" valid +++++ " + valid);
			if (valid != null) {
				String ifflg = (String) valid.get("IFFLG");
				if ("D".equals(ifflg)) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0153",
							new String[] { shpoky }));
				}
			}

			if ("V".equals(drelin)) {
				// ?????? ?????? ?????? ??? ???????????? ?????????.
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0134",
						new String[] { shpoky }));
			} else {
				// // System.out.println(" statdo +++++ " + statdo);
				// // System.out.println(" carnum +++++ " + carnum);
				if (!"NEW".equals(statdo) && ("".equals(carnum) || " ".equals(carnum))) {
					// ????????? ????????? ????????? ??????
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0151",
							new String[] { shpoky }));
				}

				// D/O ?????? ?????? - ITEM
				row.setModuleCommand("Outbound", "DL24_ITEM_01");
				List<DataMap> itemByHead = commonDao.getList(row);
				// // System.out.println(" itemByHead +++++ " + itemByHead);
				for (int j = 0; j < itemByHead.size(); j++) {

					DataMap itemRow = itemByHead.get(j).getMap("map");
					map.clonSessionData(itemRow);
					String itemQtaloc = (String) itemRow.get("QTALOC");
					String itemShpoky = (String) itemRow.get("SHPOKY");
					String itemShpoit = (String) itemRow.get("SHPOIT");
					// // System.out.println(" itemQtaloc +++++ " + itemQtaloc);
					// // System.out.println(" itemShpoky +++++ " + itemShpoky);
					// // System.out.println(" itemShpoit +++++ " + itemShpoit);

					row.put("DRELIN", "V");
					itemRow.setModuleCommand("Outbound", "DL24_CFM_ORD_DOC_ITEM");
					commonDao.update(itemRow);
				}

				// D/O ?????? ?????? - HEAD
				row.put("DRELIN", "V");
				row.setModuleCommand("Outbound", "DL24_CFM_ORD_DOC_HEAD");
				commonDao.update(row);
			}

			shipsqNum = ShipsqChk;
		}
	}

	// [DL35] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayDL35(DataMap map) throws Exception {

		map.setModuleCommand("Outbound", "DL35_HEAD_VALID");
		List<DataMap> valid = commonDao.getList(map);

		// // System.out.println(" tasdh.size() +++++ " + valid.size());

		if (valid.size() != 0) {
			// ????????? ????????? ????????? ??????
			throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",
					new String[] { "* ???????????? ?????????  ?????? ???????????????. *" }));
		}

		// // System.out.println(" DOCCAT = " + map.getString("DOCCAT"));

		map.put("DOCCAT", "300");
		map.put("TASOTY", "305");
		map.put("STATDO", "NEW");

		map.setModuleCommand("Outbound", "DL35_HEAD");
		List<DataMap> tasdh = commonDao.getList(map);

		return tasdh;

	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL35(DataMap map) throws Exception {

		String docnum = "";
		String shipsq = map.getString("SHIPSQ");
		DataMap head = ((DataMap) map.getList("head").get(0)).getMap("map");

		try {
			List<DataMap> item = map.getList("item");

			StringBuffer shpokys = new StringBuffer();
			// List TASKKY ??????
			for (int i = 0; i < item.size(); i++) {
				DataMap row = item.get(i).getMap("map");
				if (i == 0) {
					shpokys.append(" SELECT '").append(row.getString("SHPOKY")).append("' AS SHPOKY FROM DUAL ");
				} else {
					shpokys.append(" UNION ALL SELECT '").append(row.getString("SHPOKY")).append("' FROM DUAL ");
				}
			}

			// VALIDATION
			DataMap data = new DataMap();
			map.clonSessionData(data);
			data.put("SHPOKYS", shpokys.toString());
			data.setModuleCommand("Outbound", "DL35_VALIDATE_SHPDR");

			if (commonDao.getMap(data).getInt("CNT") < 1) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_M0009",
						new String[] { "\t\t* ???????????? ????????? ????????????. * \n\n\t????????????/?????? ?????? ?????? ??????????????? ??? ??? ????????????. " }));
			}

			// TASKKY ??????
			head.put("DOCUTY", head.getString("TASOTY"));
			head.setModuleCommand("SajoCommon", "GETDOCNUMBER");
			docnum = commonDao.getMap(head).getString("DOCNUM");

			// ?????? TASKKY ????????????
			data.put("TASKKY", docnum);
			data.setModuleCommand("Outbound", "DL35_TASKKY");
			commonDao.update(data);

			// ???????????? ???
			data.setModuleCommand("Outbound", "P_STOCK_REPLENISH");
			commonDao.update(data);

			// ????????? ????????????
			data.setModuleCommand("Outbound", "DL35_VALIDATE_TARGET");
			if (commonDao.getMap(data).getInt("CNT") < 1) {
				return "E";
			}

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return docnum;
	}

	@Transactional(rollbackFor = Exception.class)
	public String confirmDL35(DataMap map) throws Exception {

		String result = "";
		String shipsq = map.getString("SHIPSQ");

		try {
			List<DataMap> item = map.getList("item");

			DataMap head = ((DataMap) map.getList("head").get(0)).getMap("map");

			// ?????? ?????? ??????
			head.setModuleCommand("Outbound", "DL35_VALIDATE_TASDH");
			DataMap validMap = commonDao.getMap(head);
			if ("FPC".equals(validMap.getString("STATDO")) || "PPC".equals(validMap.getString("STATDO"))) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0037",
						new String[] { head.getString("TASKKY"), "" }));
			}

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "P_STOCK_REPLENISHMENT_COMPL");
				commonDao.update(row);
			}

			result = ((DataMap) map.getList("head").get(0)).getMap("map").getString("TASKKY");

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL36(DataMap map) throws Exception {

		String docnum = "";
		String shipsq = map.getString("SHIPSQ");

		try {
			List<DataMap> headList = map.getList("head");

			DataMap head;
			for (DataMap row : headList) {
				head = row.getMap("map");

				docnum = head.getString("TASKKY");
				// VALIDATION ?????? ????????? ?????? ROW ?????? ???????????? TASKKY ?????? ???????????? ??? ???????????? ????????? ??????
				// ??????????????? ??????(PPC?????????)
				head.setModuleCommand("Outbound", "DL36_DEL_VALDATION");
				DataMap validMap = commonDao.getMap(head);
				if (validMap.getInt("CNT") > 0) {
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0037",
							new String[] { validMap.getString("TASKKY"), validMap.getString("SKUKEY") }));
				}

				// SHPDR TASKKY?????????
				head.setModuleCommand("Outbound", "DL36_SHPDR");
				commonDao.update(head);

				// TASDI ?????? ( TASDI ????????? TASDR ?????? ?????? TASDH??? ???????????? ?????????.)
				head.setModuleCommand("Outbound", "DL36_TASDI");
				commonDao.delete(head);

			}
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return docnum;
	}

	// [DL36] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayDL36(DataMap map) throws Exception {

		map.setModuleCommand("Outbound", "DL36_HEAD");
		List<DataMap> tasdh = commonDao.getList(map);

		return tasdh;

	}

	@Transactional(rollbackFor = Exception.class)
	public String confirmDL36(DataMap map) throws Exception {

		String result = "";
		String shipsq = map.getString("SHIPSQ");

		try {
			List<DataMap> item = map.getList("item");

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				// row.setModuleCommand("Outbound", "DL35_SAVE_VALID_01");
				// List<DataMap> valid1 = commonDao.getList(row);
				// // // System.out.println(" valid1 ++++" + valid1 + "++++");

				// if(valid1.size() > 0){
				// for(int j=0;j<valid1.size();j++){
				// String statit = (String)valid1.get(j).get("STATIT");
				// throw new
				// Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
				// "VALID_M0000",new String[]{"\t\t* ???????????? ????????? ????????????. *
				// \n\n\t????????????/?????? ?????? ?????? ??????????????? ??? ??? ????????????. "}));
				// }
				// }

				// row.put("SHIPSQ", shipsq);
				row.setModuleCommand("Outbound", "P_STOCK_REPLENISHMENT_COMPL");
				commonDao.update(row);
			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String deleteDL36(DataMap map) throws Exception {

		String result = "";
		String shipsq = map.getString("SHIPSQ");

		try {
			List<DataMap> item = map.getList("item");

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				// row.setModuleCommand("Outbound",
				// "P_STOCK_REPLENISHMENT_COMPL");
				commonDao.update(row);
			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	// [DL62] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayDL62(DataMap map) throws SQLException {
		// // System.out.println("map = " + map);
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("SVBELN");
		// keyList.add("SHPMTY");
		// keyList.add("PGRC03");
		keyList.add("DPTNKY");
		keyList.add("OWNRKY");
		keyList.add("WAREKY");

		DataMap changeMap = new DataMap();
		changeMap.put("SVBELN", "SI.SVBELN");
		// changeMap.put("SHPMTY", "SH.SHPMTY");
		// changeMap.put("PGRC03", "SH.PGRC03");
		changeMap.put("DPTNKY", "SH.DPTNKY");
		changeMap.put("OWNRKY", "CM.OWNRKY");
		changeMap.put("WAREKY", "CM.WAREKY");
		map.put("RANGE_SQL0", new SqlUtil()
				.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList, changeMap));

		List keyList2 = new ArrayList<>();
		keyList2.add("SVBELN");
		keyList2.add("SHPMTY");
		keyList2.add("H.SHPOKY");
		keyList2.add("PGRC03");
		keyList2.add("DOCDAT");
		keyList2.add("CARDAT");
		keyList2.add("CARNUM");
		keyList2.add("RECDAT");
		keyList2.add("RECNUM");
		keyList2.add("SHIPSQ");
		keyList2.add("DPTNKY");
		keyList2.add("B.NAME01");
		keyList2.add("OWNRKY");
		keyList2.add("WAREKY");
		// keyList2.add("SHPOKY");

		DataMap changeMap2 = new DataMap();
		changeMap2.put("SVBELN", "I.SVBELN");
		// changeMap2.put("SHPMTY", "SHPMTY");
		// changeMap2.put("H.SHPOKY", "H.SHPOKY");
		// changeMap2.put("PGRC03", "PGRC03");
		// changeMap2.put("DOCDAT", "DOCDAT");
		changeMap2.put("CARDAT", "R.CARDAT");
		changeMap2.put("CARNUM", "R.CARNUM");
		changeMap2.put("RECDAT", "R.RECDAT");
		changeMap2.put("RECNUM", "R.RECNUM");
		changeMap2.put("SHIPSQ", "R.SHIPSQ");
		// changeMap2.put("DPTNKY", "DPTNKY");
		changeMap2.put("OWNRKY", "H.OWNRKY");
		changeMap2.put("WAREKY", "H.WAREKY");
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),
				keyList2, changeMap2));

		List keyList3 = new ArrayList<>();
		keyList3.add("SVBELN");
		keyList3.add("H.SHPOKY");
		keyList3.add("SHPMTY");
		keyList3.add("PGRC03");
		keyList3.add("DOCDAT");
		keyList3.add("CARDAT");
		keyList3.add("CARNUM");
		keyList3.add("SHIPSQ");
		keyList3.add("DPTNKY");
		keyList3.add("B.NAME01");
		keyList3.add("OWNRKY");
		DataMap changeMap3 = new DataMap();
		changeMap3.put("SVBELN", "I.SVBELN");
		// changeMap3.put("H.SHPOKY", "H.SHPOKY");
		// changeMap3.put("SHPMTY", "SHPMTY");
		// changeMap3.put("PGRC03", "PGRC03");
		// changeMap3.put("DOCDAT", "DOCDAT");
		// changeMap3.put("CARDAT", "CARDAT");
		changeMap3.put("CARNUM", "R.CARNUM");
		changeMap3.put("SHIPSQ", "R.SHIPSQ");
		// changeMap3.put("DPTNKY", "DPTNKY");
		// changeMap3.put("B.NAME01", "B.NAME01");
		changeMap3.put("OWNRKY", "H.OWNRKY");
		// changeMap3.put("WAREKY", "H.WAREKY");
		map.put("RANGE_SQL2", new SqlUtil()
				.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3, changeMap3));

		List keyList4 = new ArrayList<>();
		keyList4.add("SCSHPOKY");
		DataMap changeMap4 = new DataMap();
		changeMap4.put("SCSHPOKY", "H.SHPOKY");
		map.put("RANGE_SQL3", new SqlUtil()
				.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList4, changeMap4));

		List keyList5 = new ArrayList<>();
		keyList5.add("SVBELN");
		keyList5.add("SHPMTY");
		keyList5.add("PGRC03");
		keyList5.add("DOCDAT");
		keyList5.add("CARDAT");
		keyList5.add("CARNUM");
		keyList5.add("SHIPSQ");
		keyList5.add("DPTNKY");
		keyList5.add("B.NAME01");
		keyList5.add("OWNRKY");
		keyList5.add("WAREKY");
		keyList5.add("H.SHPOKY");
		DataMap changeMap5 = new DataMap();
		changeMap5.put("SVBELN", "I.SVBELN");
		// changeMap5.put("SHPMTY", "SHPMTY");
		// changeMap5.put("PGRC03", "PGRC03");
		// changeMap5.put("DOCDAT", "DOCDAT");
		// changeMap5.put("CARDAT", "CARDAT");
		changeMap5.put("CARNUM", "R.CARNUM");
		changeMap5.put("SHIPSQ", "R.SHIPSQ");
		// changeMap5.put("DPTNKY", "DPTNKY");
		changeMap5.put("B.NAME01", "B.NAME01");
		changeMap5.put("OWNRKY", "H.OWNRKY");
		changeMap5.put("WAREKY", "H.WAREKY");
		// changeMap5.put("H.SHPOKY", "H.SHPOKY");

		map.put("RANGE_SQL4", new SqlUtil()
				.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList5, changeMap5));

		String wareky = map.getString("WAREKY");
		String command = map.getString("command");
		// // System.out.println("wareky = " + wareky);
		// // System.out.println("command = " + command);

		map.setModuleCommand("Outbound", command);
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL62(DataMap map) throws Exception {

		String result = "";
		String sCheck = "";
		boolean bshipsqchk = true;
		ArrayList<String> alSqCheck = new ArrayList<String>();

		try {
			List<DataMap> item = map.getList("item");
			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "DL62_ITEM");
				commonDao.update(row);
			}
			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String autoDL62(DataMap map) throws Exception {

		String result = "";

		try {
			List<DataMap> item = map.getList("item");

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "P_CAR_DISPATCHING_AUTO");
				commonDao.update(row);
			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String fixedDL62(DataMap map) throws Exception {

		String result = "";

		try {
			List<DataMap> item = map.getList("item");

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "P_CAR_DISPATCHING_FIXED");
				commonDao.update(row);
			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String icrecarDL62(DataMap map) throws Exception {

		String result = "";
		String shipsq = map.getString("SHIPSQ");

		try {
			List<DataMap> item = map.getList("item");

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "P_CAR_REDISPATCHING_AUTO_IC");
				commonDao.update(row);
			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	// [DL63] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayDL63(DataMap map) throws SQLException {
		// // System.out.println("map = " + map);
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("SVBELN");
		// keyList.add("SHPMTY");
		// keyList.add("PGRC03");
		keyList.add("DPTNKY");
		keyList.add("OWNRKY");
		keyList.add("WAREKY");

		DataMap changeMap = new DataMap();
		changeMap.put("SVBELN", "SI.SVBELN");
		// changeMap.put("SHPMTY", "SH.SHPMTY");
		// changeMap.put("PGRC03", "SH.PGRC03");
		changeMap.put("DPTNKY", "SH.DPTNKY");
		changeMap.put("OWNRKY", "CM.OWNRKY");
		changeMap.put("WAREKY", "CM.WAREKY");
		map.put("RANGE_SQL0", new SqlUtil()
				.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList, changeMap));

		List keyList2 = new ArrayList<>();
		keyList2.add("SVBELN");
		keyList2.add("SHPMTY");
		keyList2.add("H.SHPOKY");
		keyList2.add("PGRC03");
		keyList2.add("DOCDAT");
		keyList2.add("CARDAT");
		keyList2.add("CARNUM");
		keyList2.add("RECDAT");
		keyList2.add("RECNUM");
		keyList2.add("SHIPSQ");
		keyList2.add("DPTNKY");
		keyList2.add("B.NAME01");
		keyList2.add("OWNRKY");
		keyList2.add("WAREKY");
		// keyList2.add("SHPOKY");

		DataMap changeMap2 = new DataMap();
		changeMap2.put("SVBELN", "I.SVBELN");
		// changeMap2.put("SHPMTY", "SHPMTY");
		// changeMap2.put("H.SHPOKY", "H.SHPOKY");
		// changeMap2.put("PGRC03", "PGRC03");
		// changeMap2.put("DOCDAT", "DOCDAT");
		changeMap2.put("CARDAT", "R.CARDAT");
		changeMap2.put("CARNUM", "R.CARNUM");
		changeMap2.put("RECDAT", "R.RECDAT");
		changeMap2.put("RECNUM", "R.RECNUM");
		changeMap2.put("SHIPSQ", "R.SHIPSQ");
		// changeMap2.put("DPTNKY", "DPTNKY");
		changeMap2.put("OWNRKY", "H.OWNRKY");
		changeMap2.put("WAREKY", "H.WAREKY");
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),
				keyList2, changeMap2));

		List keyList3 = new ArrayList<>();
		keyList3.add("SVBELN");
		keyList3.add("H.SHPOKY");
		keyList3.add("SHPMTY");
		keyList3.add("PGRC03");
		keyList3.add("DOCDAT");
		keyList3.add("CARDAT");
		keyList3.add("CARNUM");
		keyList3.add("SHIPSQ");
		keyList3.add("DPTNKY");
		keyList3.add("B.NAME01");
		keyList3.add("OWNRKY");
		DataMap changeMap3 = new DataMap();
		changeMap3.put("SVBELN", "I.SVBELN");
		// changeMap3.put("H.SHPOKY", "H.SHPOKY");
		// changeMap3.put("SHPMTY", "SHPMTY");
		// changeMap3.put("PGRC03", "PGRC03");
		// changeMap3.put("DOCDAT", "DOCDAT");
		// changeMap3.put("CARDAT", "CARDAT");
		changeMap3.put("CARNUM", "R.CARNUM");
		changeMap3.put("SHIPSQ", "R.SHIPSQ");
		// changeMap3.put("DPTNKY", "DPTNKY");
		// changeMap3.put("B.NAME01", "B.NAME01");
		changeMap3.put("OWNRKY", "H.OWNRKY");
		// changeMap3.put("WAREKY", "H.WAREKY");
		map.put("RANGE_SQL2", new SqlUtil()
				.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3, changeMap3));

		List keyList4 = new ArrayList<>();
		keyList4.add("SCSHPOKY");
		DataMap changeMap4 = new DataMap();
		changeMap4.put("SCSHPOKY", "H.SHPOKY");
		map.put("RANGE_SQL3", new SqlUtil()
				.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList4, changeMap4));

		List keyList5 = new ArrayList<>();
		keyList5.add("SVBELN");
		keyList5.add("SHPMTY");
		keyList5.add("PGRC03");
		keyList5.add("DOCDAT");
		keyList5.add("CARDAT");
		keyList5.add("CARNUM");
		keyList5.add("SHIPSQ");
		keyList5.add("DPTNKY");
		keyList5.add("B.NAME01");
		keyList5.add("OWNRKY");
		keyList5.add("WAREKY");
		keyList5.add("H.SHPOKY");
		DataMap changeMap5 = new DataMap();
		changeMap5.put("SVBELN", "I.SVBELN");
		// changeMap5.put("SHPMTY", "SHPMTY");
		// changeMap5.put("PGRC03", "PGRC03");
		// changeMap5.put("DOCDAT", "DOCDAT");
		// changeMap5.put("CARDAT", "CARDAT");
		changeMap5.put("CARNUM", "R.CARNUM");
		changeMap5.put("SHIPSQ", "R.SHIPSQ");
		// changeMap5.put("DPTNKY", "DPTNKY");
		changeMap5.put("B.NAME01", "B.NAME01");
		changeMap5.put("OWNRKY", "H.OWNRKY");
		changeMap5.put("WAREKY", "H.WAREKY");
		// changeMap5.put("H.SHPOKY", "H.SHPOKY");

		map.put("RANGE_SQL4", new SqlUtil()
				.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList5, changeMap5));

		String wareky = map.getString("WAREKY");
		String command = map.getString("command");
		// // System.out.println("wareky = " + wareky);
		// // System.out.println("command = " + command);

		map.setModuleCommand("Outbound", command);
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL63(DataMap map) throws Exception {

		String result = "";
		String sCheck = "";
		boolean bshipsqchk = true;
		ArrayList<String> alSqCheck = new ArrayList<String>();

		try {
			List<DataMap> item = map.getList("item");
			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "DL63_ITEM");
				commonDao.update(row);
			}
			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String autoDL63(DataMap map) throws Exception {

		String result = "";

		try {
			List<DataMap> item = map.getList("item");

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "P_CAR_DISPATCHING_AUTO");
				commonDao.update(row);
			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String fixedDL63(DataMap map) throws Exception {

		String result = "";

		try {
			List<DataMap> item = map.getList("item");

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "P_CAR_DISPATCHING_FIXED");
				commonDao.update(row);
			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String icrecarDL63(DataMap map) throws Exception {

		String result = "";
		String shipsq = map.getString("SHIPSQ");

		try {
			List<DataMap> item = map.getList("item");

			// List ??????
			for (int i = 0; i < item.size(); i++) {

				DataMap row = item.get(i).getMap("map");
				map.clonSessionData(row);

				row.setModuleCommand("Outbound", "P_CAR_REDISPATCHING_AUTO_IC");
				commonDao.update(row);
			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String pickingDL40(DataMap map) throws Exception {
		String result = "";
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");
			DataMap itemTemp = map.getMap("itemTemp");

			String progid = map.get("PROGID") + "";
			String taskkys = "";

			// ??????????????? ????????? head List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);
				String taskky = (String) row.get("TASKKY");

				// // System.out.println(" taskky +++++ " + taskky);
				row.put("TASKKY", taskky);

				if (i == 0) {
					taskkys = "'" + taskky + "'";
				} else {
					taskkys += ("," + "'" + taskky + "'");
				}

				String itemTaskky = "";
				if (item.size() > 0) {
					itemTaskky = item.get(0).getMap("map").getString("TASKKY");
				}

				if (taskky.equals(itemTaskky)) {
					// ??????????????? ????????? Item List ??????
					pickingforItem(map, head.get(i), item);
				} else {

					// ?????? ??????
					List<DataMap> itemByHead = itemTemp.getList(row.getString("SVBELN"));

					if (itemByHead == null) {
						row.setModuleCommand("Outbound", "DL40_ITEM");
						itemByHead = commonDao.getList(row);
					}
					// // System.out.println("itemByHead = " + itemByHead);
					// Head??? ????????? ???????????? ????????? ????????? Item List ?????? ??? ??????
					pickingforItem(map, head.get(i), itemByHead);
				}
			}

			result = taskkys;

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return result;
	}

	private void pickingforItem(DataMap map, DataMap head, List<DataMap> items) throws Exception {
		int shipsqNum = 0;
		int qtcompSum = 0;
		String progid = map.get("PROGID") + "";
		String taskky = (String) head.get("TASKKY");
		String tasoty = (String) head.get("TASOTY");

		for (int j = 0; j < items.size(); j++) {

			DataMap itemRow = items.get(j).getMap("map");
			map.clonSessionData(itemRow);

			String taskit = (String) itemRow.get("TASKIT");

			itemRow.setModuleCommand("Outbound", "DL40_PICK_ITEM");
			DataMap pickItem = commonDao.getMap(itemRow);

			String wareky = (String) pickItem.get("WAREKY");
			String locaac = (String) pickItem.get("LOCAAC");
			String ameaky = (String) pickItem.get("AMEAKY");
			String auomky = (String) pickItem.get("AUOMKY");
			String doorky = (String) pickItem.get("DOORKY");
			String locasr = (String) pickItem.get("LOCASR");
			double dqtyuom = Double.parseDouble((String) pickItem.get("QTYUOM"));
			double qtcomp = Double.parseDouble((String) pickItem.get("QTCOMP"));
			double qttaor = Double.parseDouble((String) pickItem.get("QTTAOR"));
			String rsncod = (String) pickItem.get("RSNCOD");
			String autloc = (String) pickItem.get("AUTLOC");
			String skukey = (String) pickItem.get("SKUKEY");
			// ??????????????? ???
			int iqtcomp = Integer.parseInt((String) pickItem.get("QTCOMP"));
			qtcompSum += iqtcomp;

			// 2012.09.10 by GOKU - ???????????? ??????????????????, ????????? ??????????????? ????????? ????????? ??????????????? ??????
			// ??????????????? ??? ??? ??????.
			if (qtcomp == 0) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0032",
						new String[] { taskky }));
			}
			// ?????? confirm ???????????? ??????

			itemRow.setModuleCommand("Outbound", "DL40_TASDI");
			DataMap tasdi = commonDao.getMap(itemRow);
			String actcdt = (String) tasdi.get("ACTCDT");
			if (!"00000000".equals(actcdt) && !"".equals(actcdt)) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0009",
						new String[] { taskit }));
			}

			// ??????????????? ??????????????? ??????
			if ("V".equals(autloc)) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0018",
						new String[] { locaac }));
			}

			// Location ??????
			itemRow.put("LOCAKY", locasr);
			itemRow.setModuleCommand("Outbound", "DL40_LOCMA");
			DataMap locma = commonDao.getMap(itemRow);
			// // System.out.println("selectedLocma = " + locma);
			if (locma == null) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "MASTER_M0507",
						new String[] { locaac }));
			}

			String lautloc = (String) locma.get("AUTLOC");
			// ??????????????? ??????????????? ??????
			if ("V".equals(lautloc)) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0024",
						new String[] { locaac }));
			}

			if ("310".equals(tasoty)
					&& ("SETLOC".equals(locaac) || "RTNLOC".equals(locaac) || "SCRLOC".equals(locaac))) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0035",
						new String[] { locaac }));
			}

			if (qttaor < qtcomp) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0005",
						new String[] { qtcomp + "", qttaor + "" }));
			} else if (progid.equals("PI97") && qttaor > qtcomp && rsncod.trim().equals("")) {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0130",
						new String[] { taskky, taskit, skukey }));
			}

			List<DataMap> tasdr = new ArrayList<DataMap>();
			itemRow.setModuleCommand("Outbound", "DL40_ITEM_PUTW");
			tasdr = commonDao.getList(itemRow);

			for (int k = 0; k < tasdr.size(); k++) {
				DataMap tasdrRow = tasdr.get(k).getMap("map");
				// // System.out.println( "tasdrRow = " + tasdrRow);
				tasdrRow.put("WAREKY", wareky);
				tasdrRow.setModuleCommand("Outbound", "DL40_STKKY");
				DataMap styyk = commonDao.getMap(tasdrRow);
				// // System.out.println( "styyk = " + styyk);
				// ????????? ????????? source stokky?????? ????????????.
				tasdr.get(k).put("STOKKY", (String) styyk.get("SRCSKY"));

				BigDecimal bqtspmo = new BigDecimal((String) tasdrRow.get("QTSPMO"));
				BigDecimal bqtcomp = new BigDecimal((String) itemRow.get("QTCOMP"));
				// // System.out.println("bqtspmo = " + bqtspmo + "bqtcomp = " +
				// bqtcomp + "styyk = " + styyk);
				// TASOTY:310 ??????
				if ("310".equals(tasoty) || "311".equals(tasoty)) {
					if (bqtcomp.compareTo(bqtspmo) <= 0) {
						tasdr.get(k).put("QTSTKC", qtcomp);
						break;
					}
					bqtcomp = bqtcomp.subtract(bqtspmo);
					tasdr.get(k).put("QTSTKC", bqtspmo);
				} else {
					tasdr.get(k).put("QTSTKC", bqtcomp);
				}
				// // System.out.println("bqtspmo = " + bqtspmo + "bqtcomp = " +
				// bqtcomp + "styyk = " + styyk);
			}

			itemRow.setModuleCommand("Outbound", "DL40_TASDI");
			commonDao.delete(itemRow);

			// "FPC" ???????????? = ??????????????????
			// "PPC" ???????????? > ??????????????????
			// "OPC" ???????????? < ??????????????????
			if (qttaor == qtcomp) {
				itemRow.put("STATIT", "FPC");
			}
			if (qttaor > qtcomp) {
				itemRow.put("STATIT", "PPC");
			}
			if (qttaor < qtcomp) {
				itemRow.put("STATIT", "OPC");
			}

			itemRow.setModuleCommand("Outbound", "TASDI");
			commonDao.insert(itemRow);
			for (int k = 0; k < tasdr.size(); k++) {
				DataMap tasdrRow = tasdr.get(k).getMap("map");
				map.clonSessionData(tasdrRow);
				tasdrRow.setModuleCommand("Outbound", "TASDR");
				commonDao.update(tasdrRow);
			}
		}

		// ??????????????? ?????? 0 ??? ??????
		if (qtcompSum == 0) {
			throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "TASK_M0032",
					new String[] { taskky }));
		}

	}

	@Transactional(rollbackFor = Exception.class)
	public DataMap closeDL50(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();

		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");
			DataMap itemTemp = map.getMap("itemTemp");

			String progid = map.get("PROGID") + "";
			String shpokys = "";

			StringBuffer keys = new StringBuffer();

			// ??????????????? ????????? head List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				String shpmty = (String) row.get("SHPMTY");
				String shpoky = (String) row.get("SHPOKY");

				if (i == 0) {
					shpokys = "'" + shpoky + "'";
				} else {
					shpokys += ("," + "'" + shpoky + "'");
				}

				if (!"299".equals(shpmty)) {

					// 1. ?????????????????? ?????? TASK ????????? ????????? ??????.
					row.setModuleCommand("Outbound", "DL50_CLOSE_VALID_02");
					DataMap valid = commonDao.getMap(row);
					BigDecimal cnt = new BigDecimal((String) valid.get("CNT"));
					if (cnt.compareTo(BigDecimal.ZERO) > 0) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0107",
								new String[] { shpoky }));
					}

					String itemShpoky = "";
					if (item.size() > 0) {
						itemShpoky = item.get(0).getMap("map").getString("SHPOKY");
					}

					if (shpoky.equals(itemShpoky)) {
						// ??????????????? ????????? ????????? Item List ?????? ??? ??????
						// // System.out.println("item = " + item);
						for (int j = 0; j < item.size(); j++) {
							DataMap itemRow = item.get(j).getMap("map");
							map.clonSessionData(itemRow);
							
							itemRow.put("OWNRKY", row.getString("OWNRKY"));
							itemRow.put("WAREKY",  row.getString("WAREKY"));
							itemRow.setModuleCommand("Outbound", "DL50_CLOSE_VALID_01");
							DataMap valid2 = commonDao.getMap(itemRow);
							// // System.out.println("valid = " + valid);
							if (valid2 != null) {
								shpoky = (String) valid.get("SHPOKY");
								String shpoit = (String) valid2.get("SHPOIT");
								String skukey = (String) valid2.get("SKUKEY");
								String statit = (String) valid2.get("STATIT");
								double qtshpo = Double.parseDouble((String) valid2.get("QTSHPO"));
								double qtshpd = Double.parseDouble((String) valid2.get("QTSHPD"));
								double qtjcmp = Double.parseDouble((String) valid2.get("QTJCMP"));
								String obprot = (String) valid.get("OBPROT");
								if ("PSH".equals(statit) || "FSH".equals(statit)) {
									throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
											"OUT_M0141", new String[] { shpoky }));
								} else if (qtshpo < qtshpd) {
									throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
											"OUT_M0141", new String[] { shpoky, shpoit, qtshpo + "", qtshpd + "" }));
								} else if (qtjcmp < qtshpd) {
									throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
											"OUT_M0141", new String[] { shpoky, shpoit, qtshpd + "", qtjcmp + "" }));
								} else if ("V".equals(obprot)) {
									throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
											"OUT_M0141", new String[] { shpoky, shpoit, skukey }));
								}
							}
							
							itemRow.setModuleCommand("Outbound", "DL50_CLOSE_SHPDI");
							commonDao.update(itemRow);
							if ("".equals(keys.toString())) {
								keys.append("SELECT '").append(shpoky).append(itemRow.getString("SHPOIT"))
										.append("' AS KEY FROM DUAL ");
							} else {
								keys.append("UNION ALL SELECT '").append(shpoky).append(itemRow.getString("SHPOIT"))
										.append("' AS KEY FROM DUAL ");
							}
						}
					} else {
						// ?????? ??????
						List<DataMap> itemByHead = itemTemp.getList(row.getString("SHPOKY"));
						if (itemByHead == null) {
							row.setModuleCommand("Outbound", "DL50_ITEM");
							itemByHead = commonDao.getList(row);
						}
						// Head??? ????????? ???????????? ????????? ????????? Item List ?????? ??? ??????
						// // System.out.println("itemByHead = " + itemByHead);
						for (int j = 0; j < itemByHead.size(); j++) {
							DataMap itemRow = itemByHead.get(j).getMap("map");
							map.clonSessionData(itemRow);
							
							itemRow.setModuleCommand("Outbound", "DL50_CLOSE_VALID_01");
							DataMap valid2 = commonDao.getMap(itemRow);
							// // System.out.println("valid = " + valid);
							if (valid2 != null) {
								shpoky = (String) valid.get("SHPOKY");
								String shpoit = (String) valid2.get("SHPOIT");
								String skukey = (String) valid2.get("SKUKEY");
								String statit = (String) valid2.get("STATIT");
								double qtshpo = Double.parseDouble((String) valid2.get("QTSHPO"));
								double qtshpd = Double.parseDouble((String) valid2.get("QTSHPD"));
								double qtjcmp = Double.parseDouble((String) valid2.get("QTJCMP"));
								String obprot = (String) valid.get("OBPROT");
								if ("PSH".equals(statit) || "FSH".equals(statit)) {
									throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
											"OUT_M0141", new String[] { shpoky }));
								} else if (qtshpo < qtshpd) {
									throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
											"OUT_M0141", new String[] { shpoky, shpoit, qtshpo + "", qtshpd + "" }));
								} else if (qtjcmp < qtshpd) {
									throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
											"OUT_M0141", new String[] { shpoky, shpoit, qtshpd + "", qtjcmp + "" }));
								} else if ("V".equals(obprot)) {
									throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
											"OUT_M0141", new String[] { shpoky, shpoit, skukey }));
								}
							}
							
							itemRow.setModuleCommand("Outbound", "DL50_CLOSE_SHPDI");
							commonDao.update(itemRow);
							if ("".equals(keys.toString())) {
								keys.append("SELECT '").append(shpoky).append(itemRow.getString("SHPOIT"))
										.append("' AS KEY FROM DUAL ");
							} else {
								keys.append("UNION ALL SELECT '").append(shpoky).append(itemRow.getString("SHPOIT"))
										.append("' AS KEY FROM DUAL ");
							}
						}
					}
				}

				// ?????? ??????????????? NULL????????? ??????????????? ????????? ??????. ???????????? ???????????? ????????? ??????
				if (null == row.getString("DOCDAT") || "".equals(row.getString("DOCDAT"))
						|| " ".equals(row.getString("DOCDAT"))) {
					row.setModuleCommand("Outbound", "DL50_SHPDH_DOCDAT");
					DataMap docdatMap = commonDao.getMap(row);
					row.put("DOCDAT", docdatMap.getString("DOCDAT"));
				}

				// 2. ??????????????? ???????????? ???????????? ???????????? ??? ????????? ?????? ??????
				row.setModuleCommand("Outbound", "DL50_CLOSE_SHPDH");
				commonDao.update(row);
			}

			rsMap.put("ITEMKEY", keys);
			rsMap.put("SHPOKYS", shpokys);

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return rsMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL60(DataMap map) throws Exception {

		String result = "";
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");
			DataMap itemTemp = map.getMap("itemTemp");

			String svbeln = "";
			// List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				String headRowState = row.getString(CommonConfig.GRID_ROW_STATE_ATT);
				String recayn = row.getString("RECAYN");

				// // System.out.println("headRowState = " + headRowState);
				// // System.out.println("recayn = " + recayn);
				// // System.out.println("row = " + row);
				if ("U".equals(headRowState) && "N".equals(recayn)) {
					row.setModuleCommand("Outbound", "DL60_HEAD");
					commonDao.update(row);
				} else {

					String shpoky = row.getString("SHPOKY");
					String itemShpoky = "";

					// // // System.out.println("itemByHead = " + itemByHead);

					if (item.size() > 0) {
						itemShpoky = item.get(0).getMap("map").getString("SHPOKY");
					}
					if (shpoky.equals(itemShpoky)) {
						// ??????????????? ????????? ???
						saveDL60ForItem(map, row, item);
					} else {
						// ?????? ??????
						// // System.out.println("SHPOKY = " +
						// row.getString("SHPOKY") + "itemShpoky = " +
						// itemShpoky);
						List<DataMap> itemByHead = itemTemp.getList(row.getString("SHPOKY"));
						if (itemByHead == null) {
							row.setModuleCommand("Outbound", "DL60_ITEM");
							itemByHead = commonDao.getList(row);
						}

						// // System.out.println("itemByHead = " + itemByHead);
						saveDL60ForItem(map, row, itemByHead);

					}
				}
			}
			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	private void saveDL60ForItem(DataMap map, DataMap head, List<DataMap> items) throws Exception {
		try {
			for (int j = 0; j < items.size(); j++) {

				DataMap itemRow = items.get(j).getMap("map");
				map.clonSessionData(itemRow);
				// // System.out.println("itemRow = " + itemRow);

				String rowState = itemRow.getString(CommonConfig.GRID_ROW_STATE_ATT);
				// // System.out.println("rowState = " + rowState);
				// if(rowState.equals("C")){
				// itemRow.setModuleCommand("Outbound", "DL60_ITEM");
				// commonDao.insert(itemRow);
				// }else if(rowState.equals("U")){
				itemRow.setModuleCommand("Outbound", "DL60_ITEM");
				commonDao.update(itemRow);
				// }else if(rowState.equals("D")){
				// itemRow.setModuleCommand("Outbound", "DL60_ITEM");
				// commonDao.delete(itemRow);
				// }
			}
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL61(DataMap map) throws Exception {

		String result = "";
		try {
			List<DataMap> head = map.getList("head");
			String svbeln = "";
			// List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);
				// // System.out.println("row = " + row);
				row.setModuleCommand("Outbound", "DL61_HEAD");
				commonDao.update(row);

			}

			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String saveTM04(DataMap map) throws Exception {

		String result = "";
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");
			String svbeln = "";
			// List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				if (item.size() < 1
						|| (item.size() > 0 && !row.getString("SVBELN").equals(item.get(0).getString("SVBELN")))) {
					row.setModuleCommand("Outbound", "TM04_ITEM");
					item = commonDao.getList(row);
				}

				for (int j = 0; j < item.size(); j++) {

					DataMap itemRow = item.get(j).getMap("map");
					map.clonSessionData(itemRow);
					itemRow.setModuleCommand("Outbound", "SZF_GETIFWMS113_CHECK");
					String check = commonDao.getMap(itemRow).getString("CHK");
					// // System.out.println("check = " + check);

					if ("X".equals(check))
						continue;

					itemRow.put("STATUS", "M");
					itemRow.put("C00101", "IF");
					itemRow.put("C00102", "Y");

					itemRow.setModuleCommand("Outbound", "TM05_MOVE");
					commonDao.insert(itemRow);
				}

			}
			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	// [TM06] head ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayHeadTM05(DataMap map) throws SQLException {

		String svbeln = map.getString("SVBELN");
		map.setModuleCommand("Outbound", "TM05_AFTER_HEAD");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// [TM05] Item ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayItemTM05(DataMap map) throws SQLException {
		String svbeln = map.getString("SVBELN");

		if (svbeln.equals("")) {
			map.setModuleCommand("Outbound", "TM05_ITEM");
		} else {
			map.setModuleCommand("Outbound", "TM05_AFTER_ITEM");
		}
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	@Transactional(rollbackFor = Exception.class)
	public String saveTM05(DataMap map) throws Exception {

		String result = "";
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");
			String svbeln = "";
			// List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);
				String docuty = head.get(i).getMap("map").getString("DOCUTY");
				row.setModuleCommand("Outbound", "TM05_MOVE_SEQ");
				DataMap svbelnMap = commonDao.getMap(row);
				svbeln = svbelnMap.getString("SVBELN");
				int itemno = 10;
				int sposnr = itemno;
				row.put("SVBELN", svbeln);
				row.put("CHKSEQ", svbeln);

				for (int j = 0; j < item.size(); j++) {

					row.putAll(item.get(j));
					row.put("SKUKEY", (String) item.get(j).getMap("map").get("SKUKEY"));
					row.put("ORDSEQ", StringUtil.leftPad(String.valueOf(sposnr), "0", 5));
					row.put("SPOSNR", StringUtil.leftPad(String.valueOf(sposnr), "0", 5));
					row.put("QTYORG", (String) item.get(j).getMap("map").get("QTYORG"));
					row.put("QTYREQ", (String) item.get(j).getMap("map").get("QTYORG"));
					row.put("DUOMKY", (String) item.get(j).getMap("map").get("DUOMKY"));
					row.put("NETPR", "0");
					row.put("SALDPT", " ");
					row.put("REFDKY", " ");
					row.put("REDKIT", " ");
					row.put("REDDAT", " ");
					row.put("DIRDVY", "01");
					row.put("DIRSUP", "000");
					row.put("SALEPR", "0");
					row.put("DISRAT", "0");
					row.put("SELLPR", "0");
					row.put("SELAMT", "0");
					row.put("VATAMT", "0");
					row.put("CUSRID", " ");
					row.put("CUNAME", " ");
					row.put("CUPOST", " ");
					row.put("CUNATN", " ");
					row.put("CUTEL1", " ");
					row.put("CUTEL2", " ");
					row.put("CUMAIL", " ");
					row.put("CUADDR", " ");
					row.put("CTNAME", " ");
					row.put("CTTEL1", " ");
					row.put("SALENM", " ");
					row.put("SALTEL", " ");
					row.put("TEXT01", (String) item.get(j).getMap("map").get("TEXT01"));
					if ("266".equals(docuty)) {
						row.put("C00101", "IF");
						row.put("C00104", "1011");
						row.put("C00107", "1011");
					} else {
						row.put("C00104", "1021");
						row.put("C00107", "1021");
					}
					row.put("STATUS", "C");
					row.put("USRID1", " ");
					row.put("XDATS", " ");
					row.put("XTIMS", " ");
					row.put("XSTAT", "R");

					sposnr = sposnr + itemno;

					// // System.out.println("row = " + row);
					row.setModuleCommand("Outbound", "TM05_MOVE");
					commonDao.insert(row);
				}

			}
			result = svbeln;
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	// [TM06] head ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayHeadTM06(DataMap map) throws SQLException {
		String svbeln = map.getString("SVBELN");

		if (svbeln.equals("")) {
			map.setModuleCommand("Outbound", "TM06_HEAD");
		} else {
			map.setModuleCommand("Outbound", "TM06_AFTER_HEAD");
		}
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// [TM06] Item ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayItemTM06(DataMap map) throws SQLException {
		String svbeln = map.getString("SVBELN");

		if (svbeln.equals("")) {
			map.setModuleCommand("Outbound", "TM06_ITEM");
		} else {
			map.setModuleCommand("Outbound", "TM06_AFTER_ITEM");
		}
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL85(DataMap map) throws Exception {

		String result = "";
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");

		try {
			String shpokys = "";
			// Header List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				String shpoky = row.getString("SHPOKY");
				// // System.out.println("shpoky = " + shpoky);
				if (i == 0) {
					shpokys = "'" + shpoky + "'";
				} else {
					shpokys += ("," + "'" + shpoky + "'");
				}

				if (row.getString("RECODT").isEmpty()) {
					row.put("RECODT", " ");
				}
				row.setModuleCommand("Outbound", "DL85_HEAD");
				commonDao.update(row);
			}

			result = shpokys;

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	// [DL91] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayDL91(DataMap map) throws SQLException {
		String soGubn = map.getString("SOGUBN");

		// // System.out.println("soGubn === "+soGubn);
		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("DH.UNAME4");
		keyList.add("DH.DNAME4");
		keyList.add("SM.ASKU02");
		keyList.add("BZ.NAME03");
		keyList.add("DH.SHPOKY");
		keyList.add("DH.PGRC02");
		keyList.add("DI.SVBELN");
		keyList.add("DH.DOCUTY");
		keyList.add("DH.RQSHPD");
		keyList.add("DH.RQARRD");
		keyList.add("DH.DPTNKY");
		keyList.add("DH.PTRCVR");
		keyList.add("DH.PGRC04");
		keyList.add("SA.NAME01");
		keyList.add("DI.SKUKEY");
		keyList.add("SM.DESC01");
		keyList.add("DH.PGRC03");
		keyList.add("DH.RQSHPD");
		keyList.add("DR.CARNUM");
		keyList.add("DR.SHIPSQ");
		map.put("RANGE_SQL",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList));

		List keyList2 = new ArrayList<>();
		// keyList2.add("IF.SALENM");
		// keyList2.add("IF.SALTEL");
		// keyList2.add("IF.SVBELN");
		// keyList2.add("IF.DOCUTY");
		// keyList2.add("IF.OTRQDT");
		// keyList2.add("IF.ERPCDT");
		// keyList2.add("IF.DPTNKY");
		// keyList2.add("BZ.EXPTNK");
		// keyList2.add("IF.WARESR");
		// keyList2.add("SA.NAME01");
		// keyList2.add("IF.SKUKEY");
		// keyList2.add("IF.DESC01");
		// keyList2.add("IF.DIRSUP");
		// keyList2.add("IF.OTRQDT");
		keyList2.add("DH.UNAME4");
		keyList2.add("DH.DNAME4");
		keyList2.add("DI.SVBELN");
		keyList2.add("DH.DOCUTY");
		keyList2.add("DH.RQSHPD");
		keyList2.add("DH.RQARRD");
		keyList2.add("DH.DPTNKY");
		keyList2.add("DH.PTRCVR");
		keyList2.add("DH.PGRC04");
		keyList2.add("SA.NAME01");
		keyList2.add("DI.SKUKEY");
		keyList2.add("SM.DESC01");
		keyList2.add("DH.PGRC03");
		keyList2.add("DH.RQSHPD");

		DataMap changeMap = new DataMap();
		changeMap.put("DH.UNAME4", "IF.SALENM");
		changeMap.put("DH.DNAME4", "IF.SALTEL");
		changeMap.put("DI.SVBELN", "IF.SVBELN");
		changeMap.put("DH.DOCUTY", "IF.DOCUTY");
		changeMap.put("DH.RQSHPD", "IF.OTRQDT");
		changeMap.put("DH.RQARRD", "IF.ERPCDT");
		changeMap.put("DH.DPTNKY", "IF.PTNRTO");
		changeMap.put("DH.PTRCVR", "BZ.EXPTNK");
		changeMap.put("DH.PGRC04", "IF.WARESR");
		changeMap.put("SA.NAME01", "SA.NAME01");
		changeMap.put("DI.SKUKEY", "IF.SKUKEY");
		changeMap.put("SM.DESC01", "IF.DESC01");
		changeMap.put("DH.PGRC03", "IF.DIRSUP");
		changeMap.put("DH.RQSHPD", "IF.OTRQDT");

		map.put("RANGE_SQL2", new SqlUtil()
				.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2, changeMap));

		if ("ALL".equals(soGubn)) {
			map.setModuleCommand("Outbound", "DL91_ALL");
		} else if ("WMS".equals(soGubn)) {
			map.setModuleCommand("Outbound", "DL91_WMS");
		} else if ("S/O".equals(soGubn)) {
			map.setModuleCommand("Outbound", "DL91_SO");
		}
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// [DL93] DAS ?????? ??????
	@Transactional(rollbackFor = Exception.class)
	public DataMap createDasFileDL93(DataMap map) throws SQLException, Exception {
		DataMap rsMap = new DataMap();
		List keyList = new ArrayList();

		String optype = map.getString("OPTYPE");
		map.put("DASTYP", optype);

		if ("03".equals(optype)) {
			rsMap.put("DSMT9A", this.createDasFile03_1(map));
			rsMap.put("DSMT9B", this.createDasFile03_2(map));
			rsMap.put("DSMT9C", this.createDasFile03_3(map));

			keyList.add("DSMT9A");
			keyList.add("DSMT9B");
			keyList.add("DSMT9C");

		} else if ("04".equals(optype)) {
			rsMap.put("DSMT73", this.createDasFile04_1(map));
			rsMap.put("DSMT74", this.createDasFile04_2(map));
			rsMap.put("DSMT75", this.createDasFile04_3(map));

			keyList.add("DSMT73");
			keyList.add("DSMT74");
			keyList.add("DSMT75");
		} else if ("05".equals(optype)) {
			rsMap.put("DSBT81", this.createDasFile05_1(map));
			rsMap.put("DSBT82", this.createDasFile05_2(map));
			rsMap.put("DSBT83", this.createDasFile05_3(map));

			keyList.add("DSBT81");
			keyList.add("DSBT82");
			keyList.add("DSBT83");
		} else if ("06".equals(optype)) {
			rsMap.put("DSMT83", this.createDasFile06_1(map));
			rsMap.put("DSMT84", this.createDasFile06_2(map));
			rsMap.put("DSMT85", this.createDasFile06_3(map));

			keyList.add("DSMT83");
			keyList.add("DSMT84");
			keyList.add("DSMT85");
		}

		rsMap.put("KEY", keyList);
		rsMap.put("RESULT", "S");

		return rsMap;
	}

	// [DL93] CREATE DAS FILE03_1(?????? ???????????? 78) : OUTBOUND.DAS.CREATE_FILE03_1
	public DataMap createDasFile03_1(DataMap param) throws SQLException, Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		// ???????????? ??????????????? select
		param.setModuleCommand("Outbound", "CREATE_DASFILE03_1");
		list = commonDao.getList(param);

		for (DataMap row : list) {
			// ??? ??? ????????? ??? ??????
			if (sb.toString().length() > 0)
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDDAT"), 8, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNROD"), 5, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SKUKEY"), "0", 7), 7, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("VATGUB"), 1, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ASKU05"), 1, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("SPOSNR"), 2, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDTYP"), 2, 2));
			sb.append(" ");
			sb.append("0000000");
			sb.append(" ");
			sb.append("0000000");
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTYREQ"), "0", 7), 7, 2));
			sb.append(" ");
			sb.append("000000000");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDDAT"), 8, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SVBELN"), "0", 9), 9, 2));
		}

		rtnMap.put("fileName", "DSMT9A");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DL93] CREATE DAS FILE03_2(?????? ?????? ????????? 25) : OUTBOUND.DAS.CREATE_FILE03_2
	public DataMap createDasFile03_2(DataMap param) throws SQLException, Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		// ???????????? ??????????????? select
		param.setModuleCommand("Outbound", "CREATE_DASFILE03_2");
		list = commonDao.getList(param);

		for (DataMap row : list) {
			// ??? ??? ????????? ??? ??????
			if (sb.toString().length() > 0)
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNROD"), 5, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNRODNM"), 19, 2));
		}

		rtnMap.put("fileName", "DSMT9B");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DL93] CREATE DAS FILE03_3(?????? ?????? 75) : OUTBOUND.DAS.CREATE_FILE03_3
	public DataMap createDasFile03_3(DataMap param) throws SQLException, Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		// ???????????? ??????????????? select
		param.setModuleCommand("Outbound", "CREATE_DASFILE03_3");
		list = commonDao.getList(param);

		for (DataMap row : list) {
			// ??? ??? ????????? ??? ??????
			if (sb.toString().length() > 0)
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("EANCOD"), 13, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ASKL04"), 14, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("DESC01"), 29, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("NETWGT"), "0", 5), 5, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTDUOM"), "0", 3), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SKUKEY"), "0", 7), 7, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("VATGUB"), 1, 2));
		}

		rtnMap.put("fileName", "DSMT9C");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DL93] CREATE DAS FILE04_1(?????? ???????????? 78) : OUTBOUND.DAS.CREATE_FILE04_1
	public DataMap createDasFile04_1(DataMap param) throws SQLException, Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		// ???????????? ??????????????? select
		param.setModuleCommand("Outbound", "CREATE_DASFILE04_1");
		list = commonDao.getList(param);

		for (DataMap row : list) {
			// ??? ??? ????????? ??? ??????
			if (sb.toString().length() > 0)
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDDAT"), 8, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNROD"), 5, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SKUKEY"), "0", 7), 7, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("VATGUB"), 1, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ASKU05"), 1, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("SPOSNR"), 2, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDTYP"), 2, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTYREQ1"), "0", 7), 7, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTYREQ2"), "0", 7), 7, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTYREQ"), "0", 7), 7, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("TOTAMT"), "0", 9), 9, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDDAT"), 8, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SVBELN"), "0", 9), 9, 2));
		}

		rtnMap.put("fileName", "DSMT73");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DL93] CREATE DAS FILE04_2(?????? ????????? 25) : OUTBOUND.DAS.CREATE_FILE04_2
	public DataMap createDasFile04_2(DataMap param) throws SQLException, Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		// ???????????? ??????????????? select
		param.setModuleCommand("Outbound", "CREATE_DASFILE04_2");
		list = commonDao.getList(param);

		for (DataMap row : list) {
			// ??? ??? ????????? ??? ??????
			if (sb.toString().length() > 0)
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNROD"), 5, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNRODNM"), 19, 2));
		}

		rtnMap.put("fileName", "DSMT74");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DL93] CREATE DAS FILE04_3(?????? ?????? 68) : OUTBOUND.DAS.CREATE_FILE04_3
	public DataMap createDasFile04_3(DataMap param) throws SQLException, Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		// ???????????? ??????????????? select
		param.setModuleCommand("Outbound", "CREATE_DASFILE04_3");
		list = commonDao.getList(param);

		for (DataMap row : list) {
			// ??? ??? ????????? ??? ??????
			if (sb.toString().length() > 0)
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("EANCOD2"), 6, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ASKL04"), 14, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("DESC01"), 29, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("NETWGT"), "0", 5), 5, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTDUOM"), "0", 3), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SKUKEY"), "0", 7), 7, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("VATGUB"), 1, 2));
		}

		rtnMap.put("fileName", "DSMT75");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DL93] CREATE DAS FILE05_1(?????? ????????? 185) : OUTBOUND.DAS.CREATE_FILE05_1
	public DataMap createDasFile05_1(DataMap param) throws SQLException, Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		// ???????????? ??????????????? select
		param.setModuleCommand("Outbound", "CREATE_DASFILE05_1");
		list = commonDao.getList(param);

		for (DataMap row : list) {
			// ??? ??? ????????? ??? ??????
			if (sb.toString().length() > 0)
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNROD"), 5, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNRODNM"), 19, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("VATREG"), 10, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNRODNM"), 39, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("NAME02"), 14, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNL06"), 20, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNL07"), 19, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("POSTCD1"), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("POSTCD2"), 3, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ADDRESS"), 49, 2));
		}

		rtnMap.put("fileName", "DSBT81");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DL93] CREATE DAS FILE05_2(?????? ?????? 68) : OUTBOUND.DAS.CREATE_FILE05_2
	public DataMap createDasFile05_2(DataMap param) throws SQLException, Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		// ???????????? ??????????????? select
		param.setModuleCommand("Outbound", "CREATE_DASFILE05_2");
		list = commonDao.getList(param);

		for (DataMap row : list) {
			// ??? ??? ????????? ??? ??????
			if (sb.toString().length() > 0)
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("EANCOD"), 13, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("DESC01"), 29, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("NETWGT"), "0", 5), 5, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("VATGUB"), 1, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ASKU05"), 1, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTDUOM"), "0", 3), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SKUKEY"), "0", 7), 7, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("EANCOD2"), 6, 2));
		}

		rtnMap.put("fileName", "DSBT82");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DL93] CREATE DAS FILE05_3(?????? ???????????? 198) : OUTBOUND.DAS.CREATE_FILE05_3
	public DataMap createDasFile05_3(DataMap param) throws SQLException, Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		// ???????????? ??????????????? select
		param.setModuleCommand("Outbound", "CREATE_DASFILE05_3");
		list = commonDao.getList(param);
		int sposnr = 0;
		String svbeln1 = "";
		String svbeln2 = "";

		for (DataMap row : list) {
			// ??? ??? ????????? ??? ??????
			if (sb.toString().length() > 0)
				sb.append("\r\n");
			svbeln1 = row.getString("SVBELN");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDDAT"), 8, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNROD"), 5, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SKUKEY"), "0", 7), 7, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("VATGUB"), 1, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ASKU05"), 1, 2));
			sb.append(" ");
			if (!svbeln1.equals(svbeln2)) {
				sposnr = 1;
			} else {
				sposnr += 1;
			}
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + sposnr, "0", 2), 2, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDTYP"), 2, 2));
			sb.append(" ");
			sb.append("0000000");
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTYREQ"), "0", 7), 7, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTYREQ"), "0", 7), 7, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("TOTAMT"), "0", 9), 9, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDDAT"), 8, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getString("SVBELN"), "0", 9), 9, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("DESC01"), 38, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("NETWGT"), "0", 5), 5, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("SHIPSQ"), 1, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTDUOM"), "0", 3), 3, 2));
			sb.append("1");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("OUTDMT"), "0", 3), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("NETWGT"), "0", 5), 5, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("EANCOD"), 13, 2));
			sb.append("2");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("LENGTH"), "0", 3), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("WIDTHW"), "0", 3), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("HEIGHT"), "0", 3), 3, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PGRC04NM"), 16, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("SALENM"), 9, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("EANCOD"), 13, 2));
			svbeln2 = svbeln1;
		}

		rtnMap.put("fileName", "DSBT83");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DL93] CREATE DAS FILE06_1(?????? ???????????? 78) : OUTBOUND.DAS.CREATE_FILE06_1
	public DataMap createDasFile06_1(DataMap param) throws SQLException, Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		// ???????????? ??????????????? select
		param.setModuleCommand("Outbound", "CREATE_DASFILE06_1");
		list = commonDao.getList(param);
		BigDecimal sposnr = new BigDecimal(0);

		for (DataMap row : list) {
			// ??? ??? ????????? ??? ??????
			if (sb.toString().length() > 0)
				sb.append("\r\n");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDDAT"), 8, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNROD"), 5, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SKUKEY"), "0", 7), 7, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("VATGUB"), 1, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ASKU05"), 1, 2));
			sb.append(" ");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("SPOSNR"), 2, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDTYP"), 2, 2));
			sb.append(" ");
			sb.append("0000000");
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTYREQ"), "0", 7), 7, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTYREQ"), "0", 7), 7, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("TOTAMT"), "0", 9), 9, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ORDDAT"), 8, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getString("SVBELN"), "0", 9), 9, 2));
		}

		rtnMap.put("fileName", "DSMT83");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DL93] CREATE DAS FILE06_2(?????? ????????? 25) : OUTBOUND.DAS.CREATE_FILE06_2
	public DataMap createDasFile06_2(DataMap param) throws SQLException, Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		// ???????????? ??????????????? select
		param.setModuleCommand("Outbound", "CREATE_DASFILE06_2");
		list = commonDao.getList(param);
		BigDecimal sposnr = new BigDecimal(0);

		for (DataMap row : list) {
			// ??? ??? ????????? ??? ??????
			if (sb.toString().length() > 0)
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNROD"), 5, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("PTNRODNM"), 19, 2));
		}

		rtnMap.put("fileName", "DSMT84");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DL93] CREATE DAS FILE06_3(?????? ?????? 68) : OUTBOUND.DAS.CREATE_FILE06_3
	public DataMap createDasFile06_3(DataMap param) throws SQLException, Exception {
		List<DataMap> list = null;
		DataMap rtnMap = new DataMap();
		StringBuffer sb = new StringBuffer();
		DasStringFormat ds = new DasStringFormat();

		// ???????????? ??????????????? select
		param.setModuleCommand("Outbound", "CREATE_DASFILE06_3");
		list = commonDao.getList(param);
		BigDecimal sposnr = new BigDecimal(0);

		for (DataMap row : list) {
			// ??? ??? ????????? ??? ??????
			if (sb.toString().length() > 0)
				sb.append("\r\n");

			sb.append(ds.byteSpacePaddingAlignString(row.getString("EANCOD2"), 6, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(row.getString("ASKL04"), 14, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("DESC01"), 29, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("NETWGT"), "0", 5), 5, 2));
			sb.append(" ");
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad("" + row.getInt("QTDUOM"), "0", 3), 3, 2));
			sb.append(ds.byteSpacePaddingAlignString(StringUtil.leftPad(row.getString("SKUKEY"), "0", 7), 7, 2));
			sb.append(ds.byteSpacePaddingAlignString(row.getString("VATGUB"), 1, 2));
		}

		rtnMap.put("fileName", "DSMT85");
		rtnMap.put("fileText", sb.toString());
		rtnMap.put("dasListCnt", list.size());
		rtnMap.put("dasList", list);

		return rtnMap;
	}

	// [DL91] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayHeadDL95(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("I.ORDTYP");
		keyList.add("I.ORDDAT");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.WARESR");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("C.CARNUM");
		keyList.add("SM.ASKU05");
		keyList.add("B2.PTNG08");
		keyList.add("W.LOCARV");
		keyList.add("B2.PTNG01");
		keyList.add("B2.PTNG02");
		keyList.add("B2.PTNG03");
		keyList.add("B2.PTNG03");
		keyList.add("S.SKUG03");
		keyList.add("PK.PICGRP");

		DataMap changeMap = new DataMap();
		changeMap.put("S.SKUG03", "SM.SKUG03");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),
				keyList, changeMap));

		List keyList2 = new ArrayList<>();
		keyList2.add("S.LOTA05");
		keyList2.add("S.LOTA06");
		keyList2.add("S.LOCAKY");
		map.put("RANGE_SQL2",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List keyList3 = new ArrayList<>();
		keyList3.add("OWNRKY");
		keyList3.add("WAREKY");
		keyList3.add("I.ORDTYP");
		keyList3.add("I.ORDDAT");
		keyList3.add("I.SVBELN");
		keyList3.add("I.DOCUTY");
		keyList3.add("I.OTRQDT");
		keyList3.add("I.WARESR");
		keyList3.add("I.PTNRTO");
		keyList3.add("I.PTNROD");
		keyList3.add("I.SKUKEY");
		keyList3.add("I.DIRSUP");
		keyList3.add("I.DIRDVY");
		keyList3.add("C.CARNUM");
		keyList3.add("I.DIRDVY");
		keyList3.add("SM.ASKU05");
		keyList3.add("B2.PTNG08");
		keyList3.add("W.LOCARV");
		keyList3.add("B2.PTNG01");
		keyList3.add("B2.PTNG02");
		keyList3.add("B2.PTNG03");
		keyList3.add("PK.PICGRP");
		map.put("RANGE_SQL3",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		map.setModuleCommand("Outbound", "DL95_HEAD");

		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// [DL91] Item ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayItemDL95(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("I.ORDTYP");
		keyList.add("I.ORDDAT");
		keyList.add("I.SVBELN");
		keyList.add("I.DOCUTY");
		keyList.add("I.OTRQDT");
		keyList.add("I.WARESR");
		keyList.add("I.PTNRTO");
		keyList.add("I.PTNROD");
		keyList.add("I.SKUKEY");
		keyList.add("I.DIRSUP");
		keyList.add("I.DIRDVY");
		keyList.add("C.CARNUM");
		keyList.add("SM.ASKU05");
		keyList.add("B2.PTNG08");
		keyList.add("W.LOCARV");
		keyList.add("B2.PTNG01");
		keyList.add("B2.PTNG02");
		keyList.add("B2.PTNG03");
		keyList.add("B2.PTNG03");
		keyList.add("S.SKUG03");

		DataMap changeMap = new DataMap();
		changeMap.put("S.SKUG03", "SM.SKUG03");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),
				keyList, changeMap));

		List keyList2 = new ArrayList<>();
		keyList2.add("S.LOTA05");
		keyList2.add("S.LOTA06");
		keyList2.add("S.LOCAKY");
		map.put("RANGE_SQL2",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		List keyList3 = new ArrayList<>();
		keyList3.add("OWNRKY");
		keyList3.add("WAREKY");
		keyList3.add("I.ORDTYP");
		keyList3.add("I.ORDDAT");
		keyList3.add("I.SVBELN");
		keyList3.add("I.DOCUTY");
		keyList3.add("I.OTRQDT");
		keyList3.add("I.WARESR");
		keyList3.add("I.PTNRTO");
		keyList3.add("I.PTNROD");
		keyList3.add("I.SKUKEY");
		keyList3.add("I.DIRSUP");
		keyList3.add("I.DIRDVY");
		keyList3.add("C.CARNUM");
		keyList3.add("I.DIRDVY");
		keyList3.add("SM.ASKU05");
		keyList3.add("B2.PTNG08");
		keyList3.add("W.LOCARV");
		keyList3.add("B2.PTNG01");
		keyList3.add("B2.PTNG02");
		keyList3.add("B2.PTNG03");
		keyList3.add("PK.PICGRP");
		map.put("RANGE_SQL3",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList3));

		map.setModuleCommand("Outbound", "DL95_ITEM");

		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	@Transactional(rollbackFor = Exception.class)
	public String saveDL90(DataMap map) throws Exception {

		String result = "";
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");
			String svbeln = "";
			// List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				String refdky = "";
				String refdit = "";
				String refcat = "";
				String adjuty = row.getString("ADJUTY");

				row.put("DOCUTY", adjuty);
				row.put("DOCUTY", "425");
				row.put("DOCCAT", "400");
				row.put("ADJUCA", "400");
				row.setModuleCommand("Outbound", "GETDOCNUMBER");
				String sadjky = commonDao.getMap(row).getString("DOCNUM");

				row.put("SADJKY", sadjky);
				row.setModuleCommand("Outbound", "DL90_ADJDH");
				commonDao.insert(row);

				int sadjit = 0;
				for (int j = 0; j < item.size(); j++) {
					DataMap itemRow = item.get(j).getMap("map");
					map.clonSessionData(itemRow);

					// ????????????
					itemRow.put("STRAID", itemRow.getString("RSNADJ"));
					itemRow.put("CARDAT", itemRow.getString("ORDDAT"));
					itemRow.put("SADJKY", sadjky);
					sadjit += 10;
					itemRow.put("SADJIT", StringUtil.leftPad(String.valueOf(sadjit), "0", 6));
					;
					itemRow.put("QTYUOM", itemRow.getString("QTADJU"));
					itemRow.setModuleCommand("Outbound", "DL90_ADJDI");
					commonDao.insert(itemRow);

					refdky = itemRow.getString("REFDKY");
					refdit = itemRow.getString("REFDIT");
					refcat = itemRow.getString("REFCAT");
					int qtajdu = itemRow.getInt("QTADJU");

					itemRow.put("QTYFCN", qtajdu);
					itemRow.put("TASKKY", itemRow.getString("TASKKY"));
					itemRow.put("TASKIT", itemRow.getString("TASKIT"));
					if (qtajdu < 1) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0340",
								new String[] { refdky }));
					}

					itemRow.setModuleCommand("Outbound", "DL90_VALID_01");
					List<DataMap> TASDI = commonDao.getList(itemRow);
					// System.out.println("TASDI = " + TASDI.get(0));
					for (int k = 0; k < TASDI.size(); k++) {

						// System.out.println("TASDI = " + TASDI.get(j));

						if (TASDI.get(k) != null) {
							int qtafcn = TASDI.get(k).getInt("QTYFCN");
							if (qtajdu > qtafcn) {
								throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
										"OUT_M0340", new String[] { refdky }));
							}
						}

					}

					itemRow.setModuleCommand("Outbound", "DL90_VALID_02");
					List<DataMap> SHPDI = commonDao.getList(itemRow);
					// System.out.println("SHPDI = " + SHPDI.get(0));
					for (int k = 0; k < SHPDI.size(); k++) {
						// System.out.println("SHPDI" + SHPDI.get(j));
						if (SHPDI.get(k) != null) {
							int qtshpd = SHPDI.get(k).getInt("QTSHPD");
							if (qtajdu > qtshpd) {
								throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
										"OUT_M0340", new String[] { refdky }));
							}
						}
					}

					if ("421".equals(adjuty)) {
						// ????????????
						itemRow.put("AWMSNO", itemRow.getString("TASKKY"));
						itemRow.setModuleCommand("Outbound", "DL90_SHPCANCEL");
						commonDao.update(itemRow);

					} else if ("425".equals(adjuty)) {
						// ????????????
						itemRow.put("AWMSNO", "WMS");

						// 2019-10-29 toss ???????????? check
						itemRow.put("SVBELN", itemRow.getString("SVBELN"));
						itemRow.setModuleCommand("Outbound", "DL90_VALID_03");
						DataMap TOSS = commonDao.getMap(itemRow);
						// System.out.println("TOSS = " + TOSS.get(0));
						if ("N".equals(TOSS.getString("RESULTMSG"))) {
							throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
									"VALID_M0940", new String[] {}));
						}

						itemRow.setModuleCommand("Outbound", "DL90_SHPMODIFY");
						commonDao.update(itemRow);

					} else if ("422".equals(adjuty)) {

						itemRow.setModuleCommand("Outbound", "DL90_TASKYCAN");
						commonDao.update(itemRow);

					}
				}
				result = sadjky;
			}
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	// [DL95] ??????
	@Transactional(rollbackFor = Exception.class)
	public DataMap saveDL95(DataMap map) throws Exception {
		DataMap rsMap = new DataMap();
		DataMap itemData; // ???????????? ?????????.
		int resultChk = 0;
		// List<DataMap> list = map.getList("list");
		HashMap<String, String> sqlParams = new HashMap<String, String>();

		try {

			List<DataMap> itemList = map.getList("item");

			for (DataMap item : itemList) {
				itemData = item.getMap("map");
				map.clonSessionData(itemData);
				// validateIfwms113ModifyCheckingS(item);
				itemData.setModuleCommand("Outbound", "DL95_VALI");
				commonDao.getMap(itemData);

				if (itemData.getString("IFFLG").equals("D")) {
					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",
							new String[] { "" });

					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "IFWMS_M0010",new String[]{itemData.getString("SVBELN"),itemData.getString("SPOSNR")}));
				}

				if (itemData.getInt("QTYORG") < itemData.getInt("QTYREQ")) {

					String msg = commonService.getMessageParam(map.getString("SES_LANGUAGE"), "VALID_TC0001",
							new String[] { "" });
					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "IFWMS_M0020",new String[]{itemData.getString("QTYORG"),itemData.getString("QTYREQ")}));

				}

				itemData.setModuleCommand("Outbound", "DL95");
				resultChk = (int) commonDao.update(itemData);

				if (resultChk > 0) {

					rsMap.put("RESULT", "OK");
				}
			}
			rsMap.put("gridItemList", itemList);

		} catch (Exception e) {
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}
		return rsMap;
	}

	@Transactional(rollbackFor = Exception.class)
	public String saveTO20(DataMap map) throws Exception {

		String result = "";
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");
			String svbeln = "";
			// List ??????
			for (int i = 0; i < head.size(); i++) {

				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				String refdky = "";
				String refdit = "";
				String refcat = "";
				String adjuty = row.getString("ADJUTY");

				row.put("DOCUTY", adjuty);
				row.put("DOCUTY", "425");
				row.setModuleCommand("Outbound", "GETDOCNUMBER");
				String sadjky = commonDao.getMap(row).getString("DOCNUM");

				row.put("SADJKY", sadjky);
				row.setModuleCommand("Outbound", "DL90_ADJDH");
				commonDao.insert(row);

				int sadjit = 0;
				for (int j = 0; j < item.size(); j++) {
					DataMap itemRow = item.get(j).getMap("map");
					map.clonSessionData(itemRow);

					itemRow.put("CARDAT", itemRow.getString("ORDDAT"));
					itemRow.put("SADJKY", sadjky);
					sadjit += 10;
					itemRow.put("SADJIT", StringUtil.leftPad(String.valueOf(sadjit), "0", 6));
					;
					itemRow.put("QTYUOM", itemRow.getString("QTADJU"));
					itemRow.setModuleCommand("Outbound", "DL90_ADJDI");
					commonDao.insert(itemRow);

					refdky = row.getString("REFDKY");
					refdit = row.getString("REFDIT");
					refcat = row.getString("REFCAT");
					String qtajdu = itemRow.getString("QTADJU");

					itemRow.put("SHPOKY", refdky);
					itemRow.put("SHPOIT", refdit);
					itemRow.put("QTYFCN", qtajdu);
					itemRow.put("TASKKY", itemRow.getString("TASKKY"));
					itemRow.put("TASKIT", itemRow.getString("TASKIT"));
					if (new BigDecimal(qtajdu).compareTo(BigDecimal.ZERO) <= 0) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0340",
								new String[] { refdky }));
					}

					row.setModuleCommand("Outbound", "DL90_VALID_01");
					List<DataMap> TASDI = commonDao.getList(row);
					// // System.out.println("TASDI = " + TASDI.get(0));
					for (int k = 0; k < TASDI.size(); k++) {

						// // System.out.println("TASDI = " + TASDI.get(j));

						if (TASDI.get(k) != null) {
							String qtafcn = row.getString("QTAFCN");
							if (new BigDecimal(qtajdu).compareTo(new BigDecimal(qtafcn)) > 0) {
								throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
										"OUT_M0340", new String[] { refdky }));
							}
						}

					}

					row.setModuleCommand("Outbound", "DL90_VALID_02");
					List<DataMap> SHPDI = commonDao.getList(row);
					// // System.out.println("SHPDI = " + SHPDI.get(0));
					for (int k = 0; k < SHPDI.size(); k++) {
						// // System.out.println("SHPDI" + SHPDI.get(j));
						if (SHPDI.get(k) != null) {
							String qtshpd = row.getString("QTSHPD");
							if (new BigDecimal(qtajdu).compareTo(new BigDecimal(qtshpd)) > 0) {
								throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
										"OUT_M0340", new String[] { refdky }));
							}
						}
					}

					if ("421".equals(adjuty)) {
						// ????????????
						itemRow.put("AWMSNO", itemRow.getString("TASKKY"));
						row.setModuleCommand("Outbound", "DL90_SHPCANCEL");
						commonDao.update(row);

					} else if ("425".equals(adjuty)) {
						// ????????????
						itemRow.put("AWMSNO", "WMS");

						// 2019-10-29 toss ???????????? check
						itemRow.put("SVBELN", itemRow.getString("SVBELN"));
						row.setModuleCommand("Outbound", "DL90_VALID_03");
						DataMap TOSS = commonDao.getMap(row);
						// // System.out.println("TOSS = " + TOSS.get(0));
						if ("N".equals(TOSS.getString("RESULTMSG"))) {
							throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"),
									"VALID_M0940", new String[] {}));
						}

						row.setModuleCommand("Outbound", "DL90_SHPMODIFY");
						commonDao.update(row);

					} else if ("422".equals(adjuty)) {

						row.setModuleCommand("Outbound", "DL90_TASKYCAN_");
						commonDao.update(row);

					}
				}
			}
			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String pickingTO30(DataMap map) throws Exception {
		String result = "";
		try {
			List<DataMap> head = map.getList("head");
			List<DataMap> item = map.getList("item");
			String progid = map.get("PROGID") + "";
			String taskkys = "";

			// ??????????????? ????????? head List ??????
			for (int i = 0; i < head.size(); i++) {
				DataMap row = head.get(i).getMap("map");
				map.clonSessionData(row);

				String tasoty = row.getString("TASOTY");
				if ("380".equals(tasoty)) {
					row.put("CARDAT", row.getString("CARDAT"));
					row.setModuleCommand("Outbound", "TO30_HEAD_VALID");
					DataMap valid = commonDao.getMap(row);
					// ??????????????? ?????? ????????? ?????? ?????? ??????
					String msg = "";
					if (valid == null || valid.isEmpty()) {
						msg = "??????????????? ?????? ?????????????????????.";
					} else if ("Y".equals(valid.getString("RESULTMSG"))) {
						msg = "?????? ??????????????? ?????? ?????????????????????.";
					}

					throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0161",
							new String[] { msg }));
				}

				String headTaskky = (String) row.get("TASKKY");

				for (int j = 0; j < item.size(); j++) {
					DataMap itemRow = item.get(j).getMap("map");
					map.clonSessionData(itemRow);
					String itemTaskky = row.getString("TASKKY");
					itemRow.put("CARDAT", itemRow.getString("ORDDAT"));

					itemRow.put("TASKIR", "00001");

					itemRow.setModuleCommand("Outbound", "TO30_TASDR");
					DataMap TASDR = commonDao.getMap(itemRow);

					// 1. TASDI ?????? (TASDI ????????? TASDR??? ??????????????? ?????????.)
					// TASDI ?????? ??????
					itemRow.setModuleCommand("Outbound", "TO30_TASDI");
					commonDao.delete(itemRow);

					// 2. TASDI, TASDR ??????
					String qttaor = itemRow.getString("QTTAOR");
					String qtcomp = itemRow.getString("QTCOMP");
					if (new BigDecimal(qttaor).compareTo(new BigDecimal(qtcomp)) == 0)
						itemRow.put("STATIT", "FPC");
					else if (new BigDecimal(qttaor).compareTo(new BigDecimal(qtcomp)) > 0)
						itemRow.put("STATIT", "PPC");

					if ("331".equals(tasoty) && new BigDecimal(qttaor).compareTo(new BigDecimal(qtcomp)) < 0) {

						itemRow.put("QTTAOR", qtcomp);
					}

					itemRow.put("LOCAAC", itemRow.getString("LOCATG"));
					itemRow.put("SECTAC", itemRow.getString("SECTTG"));
					itemRow.put("PAIDAC", itemRow.getString("PAIDTG"));
					itemRow.put("TRNUAC", itemRow.getString("TRNUTG"));
					itemRow.put("ATRUTY", itemRow.getString("TTRUTY"));
					itemRow.put("AMEAKY", itemRow.getString("TMEAKY"));
					itemRow.put("AUOMKY", itemRow.getString("TUOMKY"));
					itemRow.put("QTAPUM", itemRow.getString("TUOMKY"));
					itemRow.put("ADUOKY", itemRow.getString("TDUOKY"));
					itemRow.put("QTADUM", itemRow.getString("QTTDUM"));

					TASDR.put("QTSTKC", qtcomp);

					// 3. TASDI, TASDR ??????

					itemRow.setModuleCommand("Outbound", "TASDI");
					commonDao.insert(itemRow);
					itemRow.setModuleCommand("Outbound", "TASDR");
					commonDao.insert(itemRow);

				}

				row.setModuleCommand("Outbound", "TASDH");
				commonDao.update(row);
			}
			/*
			 * // // System.out.println(" taskky +++++ " + taskky);
			 * row.put("TASKKY", taskky);
			 * 
			 * if (i==0) { taskkys = "'"+taskky+"'"; } else { taskkys +=
			 * (","+"'"+taskky+"'"); }
			 * 
			 * String itemTaskky = ""; if (item.size() > 0){ itemTaskky =
			 * item.get(0).getMap("map").getString("TASKKY"); }
			 * 
			 * if (taskky.equals(itemTaskky)){ //??????????????? ????????? Item List ??????
			 * pickingforItem(map, head.get(i), item); } else {
			 * row.setModuleCommand("Outbound", "DL40_ITEM"); List<DataMap>
			 * itemByHead = commonDao.getList(row); // // System.out.println(
			 * "itemByHead = " + itemByHead); //Head??? ????????? ???????????? ????????? ????????? Item List
			 * ?????? ??? ?????? pickingforItem(map, head.get(i), itemByHead); } }
			 */
			result = "OK";

		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return result;
	}

	// [DL34] item ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayItemDL34(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();

		keyList.add("CARNUM");
		keyList.add("CARNAME");
		DataMap changeMap = new DataMap();
		changeMap.put("CARNUM", "B.CARNUM");
		changeMap.put("CARNAME", "B.DESC01");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),
				keyList, changeMap));

		List keyList2 = new ArrayList<>();
		keyList2.add("SVBELN");
		keyList2.add("H.SHPOKY");
		keyList2.add("SHPMTY");
		keyList2.add("PGRC03");
		keyList2.add("DOCDAT");
		keyList2.add("CARDAT_O");
		keyList2.add("CARNUM_O");
		keyList2.add("R.SHIPSQ");
		keyList2.add("PTNRKY1");
		keyList2.add("B.NAME01");
		DataMap changeMap2 = new DataMap();
		changeMap2.put("SVBELN", "I.SVBELN");
		changeMap2.put("CARDAT_O", "CARDAT");
		changeMap2.put("CARNUM_O", "R.CARNUM");
		changeMap2.put("PTNRKY1", "DPTNKY");
		map.put("RANGE_SQL1", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),
				keyList2, changeMap2));

		map.setModuleCommand("Outbound", "DL34_ITEM");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// dl30?????? ??????
	@Transactional(rollbackFor = Exception.class)
	public String saveDL30POP(DataMap map) throws Exception {

		List<DataMap> item = map.getList("item");
		DataMap shpdiMap = null;
		String result = "";

		String taskky = "";
		int taskit = 10;
		int attaor = 0;

		for (int i = 0; i < item.size(); i++) {
			DataMap itemRow = item.get(i).getMap("map");
			map.clonSessionData(itemRow);
			itemRow.put("SHPOKY", map.getString("SHPOKY"));
			itemRow.put("SHPOIT", map.getString("SHPOIT"));
			itemRow.put("QTTAOR", itemRow.getInt("QTSALO"));
			attaor = itemRow.getInt("QTSALO");

			// ?????? 0?????? ??????
			if (itemRow.getInt("QTSALO") < 1)
				continue;

			if (taskit == 10) {

				// ????????? ?????? ?????? ?????? TASDI ??? ????????????
				itemRow.setModuleCommand("Outbound", "DL26_DELETE_TASDI");
				commonDao.delete(itemRow);

				// ?????? ????????? ????????????.
				itemRow.setModuleCommand("Outbound", "MANUAL_ALLOC_SHPDH");
				DataMap shpdhMap = commonDao.getMap(itemRow);
				itemRow.putAll(shpdhMap);
				itemRow.put("TASOTY", "210");
				itemRow.put("DOCCAT", "300");
				itemRow.put("QTTAOR", 0);
				itemRow.put("QTCOMP", 0);

				// ?????? ??????
				taskky = taskService.createTasdh(itemRow);

				// SHPDI ??? ????????????
				itemRow.setModuleCommand("Outbound", "MANUAL_ALLOC_SHPDI");
				shpdiMap = commonDao.getMap(itemRow);

			}

			// ????????? ????????? ????????? ????????????.
			itemRow.setModuleCommand("Outbound", "DL30_POP_STKKY");
			List<DataMap> stkList = commonDao.getList(itemRow);
			DataMap stkky = null;

			if (stkList.size() > 0)
				stkky = stkList.get(0);

			if (stkky != null) {
				// tasdi????????? ?????? ????????? ??????
				itemRow.append(stkky);
				itemRow.append(shpdiMap);
				itemRow.put("TASKKY", taskky);
				itemRow.put("TASKIT", taskit);

				itemRow.put("QTTAOR", attaor);
				itemRow.put("ACTCDT", "00000000");
				itemRow.put("ACTCTI", "000000");
				itemRow.put("TKFLKY", " ");
				itemRow.put("STEPNO", " ");
				itemRow.put("LSTTFL", " ");
				itemRow.put("TASKTY", "PK");
				itemRow.put("RSNCOD", "MANU");
				itemRow.put("STATIT", "NEW");
				itemRow.put("LOCASR", itemRow.getString("LOCAKY"));
				itemRow.put("LOCATG", "SHPLOC");
				itemRow.put("LOCAAC", "SHPLOC");
				itemRow.put("SHPOKY", map.getString("SHPOKY"));
				itemRow.put("SHPOIT", map.getString("SHPOIT"));
				itemRow.put("REFDKY", itemRow.getString("SHPOKY"));
				itemRow.put("REFDIT", itemRow.getString("SHPOIT"));
				itemRow.put("DOCCAT", "200");
				itemRow.put("ALSTKY", "STD");

				DataMap tasdr = new DataMap();
				tasdr.put("TASKKY", taskky);
				tasdr.put("TASKIT", taskit);
				tasdr.put("TASKIR", "0001");
				tasdr.put("STOKKY", stkky.getString("STOKKY"));
				tasdr.put("QTSTKM", itemRow.getInt("QTTAOR"));
				tasdr.put("QTSTKC", 0);
				map.clonSessionData(tasdr);

				// TASDI ??????
				taskService.createTasdi(itemRow);
				// TASDR ??????
				taskit = taskService.createTasdr(tasdr);

			} else {
				throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0161",
						new String[] { "????????? ????????? ????????? ??? ????????????." }));
			}

		}

		return taskky;
	}

	// [DL00] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayHeadDL62(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("IF.ORDTYP");
		keyList.add("IF.ORDDAT");
		keyList.add("IF.ERPCDT");
		keyList.add("IF.SVBELN");
		keyList.add("IF.DOCUTY");
		keyList.add("IF.OTRQDT");
		keyList.add("IF.PTNRTO");
		keyList.add("BZ.NAME01)");
		keyList.add("IF.WARESR");
		keyList.add("BZP.NAME01)");
		keyList.add("IF.QTYORG");
		keyList.add("IF.DIRSUP");
		keyList.add("IF.DIRDVY");
		keyList.add("SM.SKUG05");
		keyList.add("C.CARNUM");
		DataMap changeMap = new DataMap();
		changeMap.put("IF.PTNRTO", "DECODE(IF.DOCUTY, '266', IF.WARESR, IF.PTNRTO)");
		changeMap.put("BZ.NAME01",
				"DECODE(IF.DOCUTY, '266', NVL((SELECT NAME01 FROM WAHMA  WHERE WAREKY = IF.WARESR),' '), BZ.NAME01)");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),
				keyList, changeMap));

		List keyList2 = new ArrayList<>();
		keyList2.add("IF.SKUKEY");
		map.put("RANGEITEM",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		map.setModuleCommand("Outbound", "DL01_HEAD");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// [DL00] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayItemDL62(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("IF.ORDTYP");
		keyList.add("IF.ORDDAT");
		keyList.add("IF.ERPCDT");
		keyList.add("IF.SVBELN");
		keyList.add("IF.DOCUTY");
		keyList.add("IF.OTRQDT");
		keyList.add("IF.PTNRTO");
		keyList.add("BZ.NAME01)");
		keyList.add("IF.WARESR");
		keyList.add("BZP.NAME01)");
		keyList.add("IF.QTYORG");
		keyList.add("IF.DIRSUP");
		keyList.add("IF.DIRDVY");
		keyList.add("SM.SKUG05");
		keyList.add("C.CARNUM");
		DataMap changeMap = new DataMap();
		changeMap.put("IF.PTNRTO", "DECODE(IF.DOCUTY, '266', IF.WARESR, IF.PTNRTO)");
		changeMap.put("BZ.NAME01",
				"DECODE(IF.DOCUTY, '266', NVL((SELECT NAME01 FROM WAHMA  WHERE WAREKY = IF.WARESR),' '), BZ.NAME01)");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),
				keyList, changeMap));

		List keyList2 = new ArrayList<>();
		keyList2.add("IF.SKUKEY");
		map.put("RANGEITEM",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		map.setModuleCommand("Outbound", "DL01_HEAD");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	@Transactional(rollbackFor = Exception.class)
	public String allocateDL19(DataMap map) throws Exception {

		String result = "";
		try {
			DataMap temp = new DataMap();
			temp.putAll(map);

			// ???????????? ??????
			result = createShipmentOrderDocumentTRF(temp);

			// ?????? ??????
			shipmentOrderAllocation(map);

			// result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public String createOrderDocDL19(DataMap map) throws Exception {

		String result = "";

		try {
			// ???????????? ??????
			result = createShipmentOrderDocumentTRF(map);
			// System.out.println("result = " + result);
		} catch (Exception e) {

			throw new Exception(e.getMessage());
		}

		return result;
	}

	private String createShipmentOrderDocumentTRF(DataMap map) throws Exception {
		List<DataMap> head = map.getList("head");
		List<DataMap> item = map.getList("item");
		DataMap itemTemp = map.getMap("itemTemp");
		List<DataMap> itemList = null;

		String carnum = "";
		String shpoky = "";
		String ownrky = "";
		String wareky = "";
		String svbeln = "";
		String shpokys = "";

		// Header List ??????
		for (int i = 0; i < head.size(); i++) {

			DataMap row = head.get(i).getMap("map");
			map.clonSessionData(row);
			row.put("SES_LANGUAGE", map.getString("SES_LANGUAGE"));

			ownrky = (String) row.get("OWNRKY");
			wareky = (String) row.get("WAREKY");
			carnum = (String) row.get("CARNUM");
			svbeln = (String) row.get("SVBELN");
			shpoky = (String) row.get("SHPOKY");

			String docnum = "";

			if (" ".equals(shpoky)) { // ????????????????????? ?????? ?????? ?????? ??????
				row.setModuleCommand("Outbound", "GETDOCNUMBER");
				docnum = commonDao.getMap(row).getString("DOCNUM");
				row.put("SHPOKY", docnum);
				row.put("STATDO", "NEW");

				if (i == 0) {
					shpokys = "'" + row.getString("SHPOKY") + "'";
				} else {
					shpokys += (", '" + row.getString("SHPOKY") + "'");
				}
			} else {

				if (i == 0) {
					shpokys = "'" + shpoky + "'";
				} else {
					shpokys += (", '" + shpoky + "'");
				}
				row.setModuleCommand("Outbound", "SHPDI"); // ???????????? ?????? : SHPDI
				commonDao.delete(row);

				row.setModuleCommand("Outbound", "SHPDH"); // ???????????? ?????? : SHPDH
				commonDao.delete(row);
			}

			shpoky = (String) row.get("SHPOKY");

			row.setModuleCommand("Outbound", "SHPDH"); // ?????????????????? : SHPDH
			commonDao.insert(row);

			List<DataMap> itemTepList = itemTemp.getList(row.getString("SVBELN"));
			// item == head
			if (item.size() > 0 && ((DataMap) item.get(0).get("map")).getString("SVBELN").equals(svbeln)) {
				itemList = item;
			} else if (itemTepList != null && itemTepList.size() > 0) {
				itemList = itemTepList;
			} else {
				// ????????? ?????????????????? ?????? ????????? ?????? ??????
				map.setModuleCommand("Outbound", "DL01_ITEM");
				map.put("SVBELN", svbeln);
				itemList = commonDao.getList(map);
			}

			createShipmentOrderDocumentforItem(map, row, itemList);

		}

		return shpokys;
	}

	// [DL63] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayHeadDL63(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("IF.ORDTYP");
		keyList.add("IF.ORDDAT");
		keyList.add("IF.ERPCDT");
		keyList.add("IF.SVBELN");
		keyList.add("IF.DOCUTY");
		keyList.add("IF.OTRQDT");
		keyList.add("IF.PTNRTO");
		keyList.add("BZ.NAME01)");
		keyList.add("IF.WARESR");
		keyList.add("BZP.NAME01)");
		keyList.add("IF.QTYORG");
		keyList.add("IF.DIRSUP");
		keyList.add("IF.DIRDVY");
		keyList.add("SM.SKUG05");
		keyList.add("C.CARNUM");
		DataMap changeMap = new DataMap();
		changeMap.put("IF.PTNRTO", "DECODE(IF.DOCUTY, '266', IF.WARESR, IF.PTNRTO)");
		changeMap.put("BZ.NAME01",
				"DECODE(IF.DOCUTY, '266', NVL((SELECT NAME01 FROM WAHMA  WHERE WAREKY = IF.WARESR),' '), BZ.NAME01)");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),
				keyList, changeMap));

		List keyList2 = new ArrayList<>();
		keyList2.add("IF.SKUKEY");
		map.put("RANGEITEM",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		map.setModuleCommand("Outbound", "DL63_HEAD");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// [DL63] Header ??????
	@Transactional(rollbackFor = Exception.class)
	public List displayItemDL63(DataMap map) throws SQLException {

		SqlUtil sqlUtil = new SqlUtil();
		List keyList = new ArrayList<>();
		keyList.add("IF.ORDTYP");
		keyList.add("IF.ORDDAT");
		keyList.add("IF.ERPCDT");
		keyList.add("IF.SVBELN");
		keyList.add("IF.DOCUTY");
		keyList.add("IF.OTRQDT");
		keyList.add("IF.PTNRTO");
		keyList.add("BZ.NAME01)");
		keyList.add("IF.WARESR");
		keyList.add("BZP.NAME01)");
		keyList.add("IF.QTYORG");
		keyList.add("IF.DIRSUP");
		keyList.add("IF.DIRDVY");
		keyList.add("SM.SKUG05");
		keyList.add("C.CARNUM");
		DataMap changeMap = new DataMap();
		changeMap.put("IF.PTNRTO", "DECODE(IF.DOCUTY, '266', IF.WARESR, IF.PTNRTO)");
		changeMap.put("BZ.NAME01",
				"DECODE(IF.DOCUTY, '266', NVL((SELECT NAME01 FROM WAHMA  WHERE WAREKY = IF.WARESR),' '), BZ.NAME01)");
		map.put("RANGE_SQL", sqlUtil.getRangeSqlFromListChangeAlias((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP),
				keyList, changeMap));

		List keyList2 = new ArrayList<>();
		keyList2.add("IF.SKUKEY");
		map.put("RANGEITEM",
				new SqlUtil().getRangeSqlFromList((DataMap) map.get(CommonConfig.RNAGE_DATA_MAP), keyList2));

		map.setModuleCommand("Outbound", "DL63_HEAD");
		List<DataMap> list = commonDao.getList(map);

		return list;

	}

	// saveDL31Dialog2
	@Transactional(rollbackFor = Exception.class)
	public String saveDL31Dialog2(DataMap map) throws Exception {
		DataMap row;
		List<DataMap> itemList = map.getList("item");
		String result = "F";
		String cardat = "";
		String shipsq = "";

		try {// ???????????????

			result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}

		return result;
	}
	

	public DataMap test(DataMap map) throws SQLException {
		DataMap result = new DataMap();
        
        
    	for(int i=0; i < 10; i ++){
    		test2(i);
    	}
		
		return result;
	}
	

	public DataMap test2(int i) throws SQLException {
		DataMap result = new DataMap();
        TransactionDefinition transactionDefinition = new DefaultTransactionDefinition();
        TransactionStatus transactionStatus = transactionManager.getTransaction(transactionDefinition);
        
        String[] data = {"1H81F", "2000281", "05071001", "11078005", "1H87F", "11128001", "05071002", "2003182" ,"100013", "100178"};
        
		DataMap param = new DataMap();
		param.put("USERID", data[i]);
		param.put("INDARC", i);
		try{
    		param.setModuleCommand("Outbound", "USRMA");
			commonDao.update(param);
			
			if(i==5) transactionManager.rollback(transactionStatus);
		} catch (RuntimeException e) { 
			transactionManager.rollback(transactionStatus); throw e; 
		} finally { 
			if (!transactionStatus.isCompleted()) {
				transactionManager.commit(transactionStatus); 
			} 
		}
		
		return result;
	}
	


	public String allocateDL01SO(DataMap map) throws Exception {

		String shpoky = "";
		String result = "";
		DataMap clsMap = new DataMap();
		
		try {

			List<DataMap> headList = map.getList("head");
			
			for(int i=0; i < headList.size(); i++){

				DataMap temp = new DataMap();
				temp.putAll(map);
				temp.put("head", headList.get(i));
				
				// ???????????? ??????
				shpoky = this.createShipmentOrderDocumentSO(temp);
	
				if (i == 0) {
					result = "'" + shpoky + "'";
				} else {
					result += ("," + "'" + shpoky + "'");
				}

				// ??????????????? ??????
				if(i ==0 ){
					clsMap.put("WAREKY", headList.get(i).getMap("map").getString("WAREKY"));
					clsMap.setModuleCommand("Outbound", "CLSYN_CHK");
					DataMap clsChk = commonDao.getMap(clsMap);
	
					if (clsChk != null && "Y".equals(clsChk.getString("CLSYN")))
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0155",
								new String[] { "* ?????? ???????????? ????????? ?????????.. *" }));
	
					// clsyn update ????????? ????????????(?????? ????????????)
					clsMap.setModuleCommand("Outbound", "CLSYN");
					clsMap.put("CLS_YN", "Y");
					map.clonSessionData(clsMap);
					commonDao.update(clsMap);
	
					// ??????????????? ?????? ????????? ????????? ???????????? ?????? ???????????????
					DataMap falChk = (DataMap) clsMap.clone();
					falChk.setModuleCommand("Outbound", "OUTBOUND_FALCHK");
					DataMap falMap = commonDao.getMap(falChk);
					if (falMap != null && falMap.getInt("CNT") > 0) {
						throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0154",
								new String[] { "* ?????? ???????????? ????????? ?????????.. *" }));
					}
				}
				//?????? 
				this.shipmentOrderAllocationSO(temp);
			}

			// result = "OK";
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}finally {
			map.clonSessionData(clsMap);
			clsMap.setModuleCommand("Outbound", "CLSYN");
			clsMap.put("CLS_YN", "N");
			commonDao.update(clsMap);
		}

		return result;
	}
	
	


	private String createShipmentOrderDocumentSO(DataMap map) throws Exception {

        TransactionDefinition transactionDefinition = new DefaultTransactionDefinition();
        TransactionStatus transactionStatus = transactionManager.getTransaction(transactionDefinition);
        
		DataMap head = map.getMap("head");
		List<DataMap> item = map.getList("item");
		DataMap itemTemp = map.getMap("itemTemp");
		DataMap clsMap = new DataMap();

		String carnum = "";
		String shpoky = "";
		String ownrky = "";
		String wareky = "";
		String svbeln = "";

		try{
			// Header List ??????
			DataMap row = head.getMap("map");
			map.clonSessionData(row);
			row.put("SES_LANGUAGE", map.getString("SES_LANGUAGE"));
	
			ownrky = (String) row.get("OWNRKY");
			wareky = (String) row.get("WAREKY");
			carnum = (String) row.get("CARNUM");
			svbeln = (String) row.get("SVBELN");
			shpoky = (String) row.get("SHPOKY");
	
			String docnum = "";

			row.setModuleCommand("Outbound", "GETDOCNUMBER");
			docnum = commonDao.getMap(row).getString("DOCNUM");
			row.put("SHPOKY", docnum);
			row.put("STATDO", "NEW");
	
			shpoky = (String) row.get("SHPOKY");
	
			row.setModuleCommand("Outbound", "SHPDH"); // ?????????????????? : SHPDH
			commonDao.insert(row);
	
			String itemSvbeln = "";
			if (item.size() > 0) {
				itemSvbeln = item.get(0).getMap("map").getString("SVBELN");
			}
			
			if (svbeln.equals(itemSvbeln)) {
				// ??????????????? ????????? Item List ??????
				createShipmentOrderDocumentforItem(map, row, item);
			} else {
				// ?????? ??????
				List<DataMap> itemByHead = itemTemp.getList(row.getString("SVBELN"));
				if (itemByHead == null) {
					row.setModuleCommand("Outbound", "SALES_ORDER_DOC_ITEM_FOR_PARTIAL_ALLOC");
					itemByHead = commonDao.getList(row);
				}
	
				createShipmentOrderDocumentforItem(map, row, itemByHead);
			}

		} catch (Exception e) { 
			transactionManager.rollback(transactionStatus);
		} finally { 
			if (!transactionStatus.isCompleted()) {
				transactionManager.commit(transactionStatus); 
			} 
		}

		return shpoky;
	}
	


	public void shipmentOrderAllocationSO(DataMap map) throws Exception {

        TransactionDefinition transactionDefinition = new DefaultTransactionDefinition();
        TransactionStatus transactionStatus = transactionManager.getTransaction(transactionDefinition);
		DataMap clsMap = new DataMap();
		DataMap head = map.getMap("head");
		// List<DataMap> item = map.getList("item");

		String carnum = "";
		String shpoky = "";
		String ownrky = "";
		String wareky = "";
		String sapKey = "";
		String docnum = "";


		try{
			// Header List ??????
			DataMap row = head.getMap("map");
			map.clonSessionData(row);

			ownrky = (String) row.get("OWNRKY");
			wareky = (String) row.get("WAREKY");
			carnum = (String) row.get("CARNUM");
			sapKey = (String) row.get("SVBELN");
			shpoky = (String) row.get("SHPOKY");

			String shpmty = (String) row.get("SHPMTY");
			String svbeln = (String) row.get("SVBELN");
			String c00107 = (String) row.get("C00107");
			String procName = " ";

			row.put("SHPOKY", shpoky);

			if (("266".equals(shpmty) || "267".equals(shpmty))) {
				String sajosvCheck = svbeln.substring(0, 2);
				if ("61".equals(sajosvCheck)) {
					row.setModuleCommand("Outbound", "P_BATCH_ALLOCATION_SV_TRFIT");
				} else if ("Y003".equals(c00107)) {
					row.setModuleCommand("Outbound", "P_BATCH_ALLOCATION");
				} else {
					row.setModuleCommand("Outbound", "P_BATCH_ALLOCATION_TRFIT");
				}
				commonDao.update(row);
			} else {
				row.setModuleCommand("Outbound", "P_BATCH_ALLOCATION");
				commonDao.update(row);
			}
		} catch (Exception e) { 
			transactionManager.rollback(transactionStatus);
		} finally { 
			if (!transactionStatus.isCompleted()) {
				transactionManager.commit(transactionStatus); 
			} 
		}

	}


	// [DL88] ???????????????
	@Transactional(rollbackFor = Exception.class)
	public String deleteNewDL09(DataMap map) throws Exception {
		List<DataMap> rsMap = new ArrayList();
		
		List<DataMap> itemList = map.getList("item");
		List<DataMap> groupingShpokyList = new ArrayList();
		
		if(itemList.size() < 1){
			throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0022",new String[]{}));
		}
		
		groupingShpokyList = groupingShpoky(map);
		
		
		return removeShipmentOrderDocumentNEW(groupingShpokyList);
	}
	
	// [DL88] ??????????????? ??????
	@Transactional(rollbackFor = Exception.class)
	public String removeShipmentOrderDocumentNEW(List map) throws Exception {
		List<DataMap> rsList = new ArrayList();
		List<DataMap> itemList = map;
		
		String shpokys = "";
		DataMap sqlParams = new DataMap();
		
		try{
			
			for(DataMap item : itemList){
				item = item.getMap("map");
				
				if(shpokys.length() > 0){
					shpokys += " ,";
				}
				shpokys += " '" + item.getString("SHPOKY") + "'";
				
				sqlParams.put("SHPOKY", item.get("SHPOKY"));
				sqlParams.setModuleCommand("OutBoundReport", "P_IFWMS113_REMOVE_SHIPMENT_NEW");
				commonDao.update(sqlParams);
			}
			
		}catch(Exception e){
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}	
		
		return shpokys;
	}
	
	// [DL88] ?????????????????? ??????
	@Transactional(rollbackFor = Exception.class)
	public String deletePalDL09(DataMap map) throws Exception {
		List<DataMap> rsMap = new ArrayList();
		
		List<DataMap> itemList = map.getList("item");
		List<DataMap> groupingShpokyList = new ArrayList();
		
		if(itemList.size() < 1){
			throw new Exception(commonService.getMessageParam(map.getString("SES_LANGUAGE"), "OUT_M0022",new String[]{}));
		}
		
		groupingShpokyList = groupingShpoky(map);
		
		return removeShipmentOrderDocumentPAL(groupingShpokyList);
	}
	
	// [DL88] ??????????????????
	@Transactional(rollbackFor = Exception.class)
	public String removeShipmentOrderDocumentPAL(List map) throws Exception {
		List<DataMap> rsList = new ArrayList();
		List<DataMap> itemList = map;
		
		String shpokys = "";
		DataMap sqlParams = new DataMap();
		
		try{
			
			for(DataMap item : itemList){
				item = item.getMap("map");
				
				if(shpokys.length() > 0){
					shpokys += " ,";
				}
				shpokys += " '" + item.getString("SHPOKY") + "'";
				
				sqlParams.put("SHPOKY", item.get("SHPOKY"));
				sqlParams.setModuleCommand("OutBoundReport", "P_IFWMS113_REMOVE_SHIPMENT_PAL");
				commonDao.update(sqlParams);
			}
			
		}catch(Exception e){
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}	
		
		return shpokys;
	}

	// [DL88] groupingShpoky
	@Transactional(rollbackFor = Exception.class)
	public List groupingShpoky(DataMap map) throws Exception {
		List<DataMap> rsList = new ArrayList();
		List<DataMap> itemList = map.getList("item");
		
		String appendQuery = "";
		DataMap sqlParams = new DataMap();
		
		try{
			
			for(DataMap item : itemList){
				item = item.getMap("map");
				
				if(appendQuery.length() > 0){
					appendQuery += "\nUNION ALL\n";
				}
				appendQuery += "SELECT '" + item.getString("SHPOKY") + "' AS SHPOKY " + "FROM DUAL";
			}
			sqlParams.put("APPENDQUERY", appendQuery.toString());

			sqlParams.setModuleCommand("OutBoundReport", "DL88_GROUPING_SHPOKY");
			rsList = commonDao.getList(sqlParams);
			
		}catch(Exception e){			
			throw new Exception(ComU.getLastMsg(e.getMessage()));
		}

		
		return rsList;
	}
}