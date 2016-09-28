/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.statis;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSReporter;
import com.nec.nsgui.model.biz.base.RpqLicense;
import com.nec.nsgui.model.biz.statis.CollectionItemDef;
import com.nec.nsgui.model.biz.statis.MonitorConfigBase;
import com.nec.nsgui.model.biz.statis.MonitorConfig;
import com.nec.nsgui.model.biz.statis.MonitorConfig2;
import com.nec.nsgui.model.biz.statis.RRDFile;
import com.nec.nsgui.model.biz.statis.RRDFilesInfo;
import com.nec.nsgui.model.biz.statis.TargetDef;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.statis.DataSources;
import com.nec.nsgui.model.entity.statis.CollectionItemInfoBeanBase;
import com.nec.nsgui.model.entity.statis.CollectionBeanFactory;
import com.nec.nsgui.model.biz.statis.SamplingHandler;
import com.nec.nsgui.model.entity.statis.CsvDownloadUtil;
import com.nec.nsgui.action.base.NSActionConst;

public class CollectionAssistant implements CollectionConst {
    public static final String cvsid 
            = "@(#) $Id: CollectionAssistant.java,v 1.5 2007/03/07 06:20:49 yangxj Exp $";    
    private MonitorConfigBase mcBase;
    private String targetID;

    public void init(MonitorConfigBase monitorConfig, String targetid)
        throws Exception {
        mcBase = monitorConfig;
        targetID = targetid;
    }
    public List getItemInfoList(String typeFlag,HttpServletRequest request) throws Exception {
        List collectionItemList = mcBase.getCollectionItemList();
        TargetDef td = mcBase.getTargetDef(targetID);
        List colItemInfoList = new ArrayList();
        Iterator collectionItemListIter = collectionItemList.iterator();
        int flag=1;
        try{
            flag = RpqLicense.getLicense(RPQ_NUM, 0);
        }catch(Exception e){
        }
        try{
            boolean isCluster=NSActionUtil.isCluster(request);
            if(flag==1 && isCluster){
                flag = RpqLicense.getLicense(RPQ_NUM, 1);
            }
        }catch(Exception e){
        }
        while (collectionItemListIter.hasNext()) {
            String colItemID = (String) collectionItemListIter.next();
            if( flag == 1 && colItemID.equals(CollectionItemDef.Filesystem_Quantity)){
                continue;  
            }
            if(colItemID.equals(CollectionConst.COLITEMID_ANTI_VIRUS_SCAN) 
            		&& request.getSession().getAttribute(NSActionConst.SESSION_USERINFO).equals("nsview")){
            	//check Virus Detection's license
            	int group = ClusterUtil.getInstance().getMyNodeNo();
            	LicenseInfo license = LicenseInfo.getInstance();
            	if ((license.checkAvailable(group,CollectionConst.SERVERPROTECT_LICENSE)) == 0){
            		//no license
            		continue;
            	}
            }
            CollectionItemDef colItemDef =
                mcBase.getCollectionItemDef(colItemID);
            String colItem = colItemDef.getDesc();
            List nodesList = getNodesList(colItemID);
            double dataSize = calcDataFileSize(nodesList, colItemID);
            String dataFileSize;
            if (dataSize == 0) {
                //2005-09-26
                //dataFileSize = "-";
                dataFileSize = CollectionConst.DLINE;
            } else {
                dataSize = dataSize / CollectionConst.MILLION;
                dataFileSize =
                    Double.toString(Math.round(dataSize * 100) / 100.00);
                if (dataFileSize.length() - dataFileSize.indexOf(".")
                    < 3) {
                    dataFileSize = dataFileSize + "0";
                }
            }
            String stockPeriod = "";
            if(mcBase instanceof MonitorConfig){
                
                stockPeriod = ((MonitorConfig)mcBase).getStockPeriod(targetID,colItemID);
            }else{
                stockPeriod = ((MonitorConfig2)mcBase).getStockPeriod(targetID,colItemID);
            }
            if(flag==0&&colItemID.equals(CollectionItemDef.Filesystem)){
                colItem= FILESYSTEM_RATE;  
            }
            CollectionItemInfoBeanBase colBeanBase =
                CollectionBeanFactory.create(
                    typeFlag,
                    mcBase,
                    targetID,
                    colItemID,
                    colItem,
                    dataFileSize,
                    stockPeriod);
            colItemInfoList.add(colBeanBase);
        }
        return colItemInfoList;
    }
    private List getNodesList(String colItemID) throws Exception {
        List list = new ArrayList();
        TargetDef td = mcBase.getTargetDef(targetID);
        String targetType = td.getType();
        if (targetType.equals(TargetDef.NASIPSAN)) {
            list = td.getNodes();
        } else if (targetType.equals(TargetDef.CLUSTER)) {
            list = td.getNodes();
        } else {
            list.add(targetID);
        }
        return list;
    }
    private double calcDataFileSize(List nodesList, String colItemID)
        throws Exception {
        double dataSize = 0.00;
        Iterator nodesListIter = nodesList.iterator();
        while (nodesListIter.hasNext()) {
            String nodeID = (String) nodesListIter.next();
            dataSize += calcUsedRRDFileSize(nodeID, colItemID);
        }
        return dataSize;
    }
    private boolean iscsiAvail() throws Exception {
        LicenseInfo license = LicenseInfo.getInstance();
        int nodeNo = ClusterUtil.getInstance().getMyNodeNo();
        return ((license.checkAvailable(nodeNo, "iscsi", false)) != 0);
    }
    private String getCollectionItem(List list, int num) throws Exception {
        CollectionItemInfoBeanBase info =
            (CollectionItemInfoBeanBase) (list.get(num));
        return (info.getCollectionItem());
    }
    /*
    private int dataSourceNum(String id) {
        CollectionItemDef colItemDef = mcBase.getCollectionItemDef(id);
        DataSources dataSources = colItemDef.getDataSources();
        List idList = dataSources.getIDList();
        return idList.size();
    }
    */
    /*
    public boolean checkTotalSize() throws Exception {                
        double expectSize = 0.00;
        double usedSize = 0.00;
        List colItemList = getItemInfoList("sampling");
        Iterator colItemIter = colItemList.iterator();
        while (colItemIter.hasNext()) {
            CollectionItemInfoBeanBase colBeanBase =
                (CollectionItemInfoBeanBase) colItemIter.next();
            String colItem = colBeanBase.getCollectionItem();
            String colItemID = colBeanBase.getID();
            List nodesIDList = getNodesList(colItemID);
            Iterator nodesIDIter = nodesIDList.iterator();
            while (nodesIDIter.hasNext()) {
                String nodeID = (String) nodesIDIter.next();
                TargetDef nodeTD = mcBase.getTargetDef(nodeID);
                String nodeAddr = nodeTD.getAddress();
                usedSize += calcUsedRRDFileSize(nodeID, colItemID);
                expectSize += calcExpectRRDFileSize(colBeanBase)
                    * SamplingHandler.getResourceNum(nodeAddr, colItemID);
            }
        }
        double increaseSize =
            Math.ceil((expectSize - usedSize) / CollectionConst.KILOBYTE);
        if (increaseSize > SamplingHandler.getAvailableSize()) { //low space            
            return false;
        } else {            
            return true;
        }
    }
    */
    /*
    private double calcExpectRRDFileSize(CollectionItemInfoBeanBase colBeanBase)
        throws Exception {
        double period = Double.parseDouble(colBeanBase.getStockPeriod());
        double interval = Double.parseDouble(colBeanBase.getInterval());
        String id = colBeanBase.getID();
        int dataSourceNum = dataSourceNum(id);
        double headSectionSize = 340 + 392 * dataSourceNum;
        double dataSectionSize = 13440 * dataSourceNum * period / interval;
        double size = headSectionSize + dataSectionSize;
        return Math.ceil(size / CollectionConst.BLOCK_SIZE)
            * CollectionConst.BLOCK_SIZE;
    }
    */
    private double calcUsedRRDFileSize(String nodeID, String colItemID)
        throws Exception {
        RRDFilesInfo rfi = mcBase.loadRRDFilesInfo(nodeID, colItemID);
        List subItemList = rfi.getIDList();
        Iterator subIt = subItemList.iterator();
        double dataSize = 0.00;
        while (subIt.hasNext()) {
            RRDFile rf = rfi.get((String) subIt.next());
            dataSize += Double.parseDouble(rf.getSize());
        }
        return dataSize;
    }
    public void changeStatus(boolean isOn, String colItem) throws Exception {
        if (colItem == null) {
            ((MonitorConfig)mcBase).setTargetStatus(targetID, isOn);
        } else {
            ((MonitorConfig2)mcBase).setTargetStatus(targetID, colItem, isOn);
        }
    }
    public void changeStockPeriod(String itemID, String period)
        throws Exception {
        int ret;
        if(mcBase instanceof MonitorConfig){
            ret = ((MonitorConfig)mcBase).setStockPeriod(targetID,itemID,period);
        }else{
            ret = ((MonitorConfig2)mcBase).setStockPeriod(targetID,itemID,period);
        }
        if (ret != 0) {
            CsvDownloadUtil.makeNSException(
                CollectionAssistant.class,
                CollectionConst.PERIOD_SETTING_FAILED,
                null,
                NSReporter.ERROR);
        }
    }
    /*
    public boolean checkItemSize(
        String itemID,
        String item,
        String period,
        String flag4create)
        throws Exception {            
        CollectionItemInfoBeanBase colBeanBase =
            new CollectionItemInfoBeanBase();
        colBeanBase =
            CollectionBeanFactory.create(
                flag4create,
                mcBase,
                targetID,
                itemID,
                item,
                null,
                period);
        String colItemID = colBeanBase.getID();
        List nodesIDList = getNodesList(colItemID);
        Iterator nodesIDIter = nodesIDList.iterator();
        double expectSize = 0.00;
        double usedSize = 0.00;
        while (nodesIDIter.hasNext()) {
            String nodeID = (String) nodesIDIter.next();
            TargetDef nodeTD = mcBase.getTargetDef(nodeID);
            String nodeAddr = nodeTD.getAddress();
            usedSize += calcUsedRRDFileSize(nodeID, itemID);
            expectSize += calcExpectRRDFileSize(colBeanBase)
                * SamplingHandler.getResourceNum(nodeAddr, itemID);
        }
        double increaseSize =
            Math.ceil((expectSize - usedSize) / CollectionConst.KILOBYTE);
        if (increaseSize > SamplingHandler.getAvailableSize()) { //low space            
            return false;
        } else {            
            return true;
        }
    }
    */
    public void deleteData(String itemID) throws Exception {
        mcBase.deleteRRDFiles(targetID,itemID);
    }
    public void changeInterval(String item, String interval) throws Exception {
        String newInterval = min2sec(interval);
        int ret = ((MonitorConfig2)mcBase).setInterval(targetID, item, newInterval);
        if (ret != 0) {
            CsvDownloadUtil.makeNSException(
                CollectionAssistant.class,
                CollectionConst.INTERVAL_SETTING_FAILED,
                null,
                NSReporter.ERROR);
        }
    }
    
    public String min2sec(String minutes){
        int minute = Integer.parseInt(minutes);
        int second = minute * 60;
        String result = String.valueOf(second);
        return result;        
    }

}