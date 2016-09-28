/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.statis;

import java.util.*;
import javax.servlet.http.HttpServletRequest;
import com.nec.nsgui.model.biz.statis.*;
import com.nec.nsgui.model.biz.statis.NswSamplingHandler;
import com.nec.nsgui.model.entity.statis.*;
import com.nec.nsgui.model.entity.statis.CsvDownloadUtil;
import com.nec.nsgui.model.biz.base.NSReporter;
import com.nec.nsgui.action.base.NSActionUtil;

public class NswSamplingAssistant implements CollectionConst3 {
    public static final String cvsid 
            = "@(#) $Id: NswSamplingAssistant.java,v 1.1 2005/10/18 16:24:27 het Exp $";    
    public List getVirtualPathList(String targetID, String colItemID)
        throws Exception {
        List vpAllList = NswSamplingHandler.getVirtualPathList();
        MonitorConfig3 mc3 = new MonitorConfig3();
        mc3.loadDefs();
        Map rrdFileMap = getRRDFileMap(mc3,targetID,colItemID);
        Map samplingIsOnMap = mc3.loadSamplingConfs(targetID, colItemID);
        for (int i = 0; i < vpAllList.size(); i++) {
            VirtualPathInfoBean vp = (VirtualPathInfoBean) vpAllList.get(i);
            vp.setIndexID(String.valueOf(i));
            fillData(samplingIsOnMap,rrdFileMap,(NswSamplingInfoBeanBase)vp);
        }
        return vpAllList;
    }

    public List getSeverList(String targetID, String colItemID)
        throws Exception {
        List severAllList = NswSamplingHandler.getSeverList();
        MonitorConfig3 mc3 = new MonitorConfig3();
        mc3.loadDefs();
        Map rrdFileMap = getRRDFileMap(mc3,targetID,colItemID);
        Map samplingIsOnMap = mc3.loadSamplingConfs(targetID, colItemID);
        for (int i = 0; i < severAllList.size(); i++) {
            NswSamplingInfoBeanBase nsBase =
                (NswSamplingInfoBeanBase) severAllList.get(i);
            nsBase.setIndexID(String.valueOf(i));
            fillData(samplingIsOnMap,rrdFileMap,nsBase);
        }
        return severAllList;
    }

    public List getNodeList(String targetID, String colItemID)
        throws Exception {
        MonitorConfig3 mc3 = new MonitorConfig3();
        mc3.loadDefs();       
        Map rrdFileMap = getRRDFileMap(mc3,targetID,colItemID);
        Map samplingIsOnMap = mc3.loadSamplingConfs(targetID, colItemID);
        List nodesList = getNodeIDList(targetID,mc3);
        List resNodeList = new ArrayList();
        for (int i = 0; i < nodesList.size(); i++) {
            NodeInfoBean nodeBean = new NodeInfoBean();
            nodeBean.setIndexID(String.valueOf(i));
            String nodeID = (String)nodesList.get(i);
            nodeBean.setId(nodeID);
            TargetDef tdi = mc3.getTargetDef(nodeID);
            nodeBean.setNickName(tdi.getNickName());
            fillData(samplingIsOnMap,rrdFileMap,nodeBean);
            resNodeList.add(nodeBean);
        }
        return resNodeList;
    }

    public boolean checkCapacity(
        HttpServletRequest request,
        String interval,
        String period,
        boolean isCluster)
        throws Exception {
        double percentage = NswSamplingHandler.getUsedSizePercentage();
        if(percentage>90.0){
            return false;
        }
        String colItemID = (String)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_COLITEM_ID);
        String targetID = (String)NSActionUtil.getSessionAttribute(request,CollectionConst.STATIS_SAMPLING_TARGETID);
        //get virtual path,server,node's samplingConf list
        // The curSamplingConf is current displayed collection item's.
        MonitorConfig3 mc3 = new MonitorConfig3();
        mc3.loadDefs();
        double estimateFileSize = 0.0;
        Map curSamplingConf = mc3.loadSamplingConfs(targetID,colItemID);
        double newInterval = Double.parseDouble(interval); //unit:minute
        newInterval *= 60;
        double newPeriod = Double.parseDouble(period);
        Map modeMap = NswSamplingHandler.getModeMap(colItemID);
        estimateFileSize = getCurColItemsEstimateSize(request,curSamplingConf,modeMap,newInterval,newPeriod,isCluster);
        // The other collection items 
        String[] colItemIDArray = {STATIS_NFS_VIRTUAL_PATH,STATIS_NFS_SEVER,STATIS_NFS_NODE
        };
        for(int i=0;i<colItemIDArray.length;i++){
            if(!(colItemIDArray[i].equals(colItemID))){
                Map tmpSamplingConf = mc3.loadSamplingConfs(targetID,colItemIDArray[i]);                
                estimateFileSize += getNoCurColItemsEstimateSize(colItemID,tmpSamplingConf,modeMap,isCluster);
            }
        }
        if(estimateFileSize>STATIS_NSW_TOTAL_SIZE){
            return false;
        }else{
            return true;
        }
    }
    
    private double getCurColItemsEstimateSize(HttpServletRequest request,Map samplingConf,Map modeMap,double newInterval,double newPeriod,boolean isCluster) throws Exception{
        double estimateSize = 0.0;
        String colItemID = (String)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_COLITEM_ID);
        List indexList = (List)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_SESSION_SELECTED_INDEXLIST);
        Map sessionMap = (Map)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_SESSION_TABLELIST_MAP);
        for(int i=0;i<indexList.size();i++){
            String index = (String)indexList.get(i);
            NswSamplingInfoBeanBase nsBase = (NswSamplingInfoBeanBase)sessionMap.get(index);
            String itemID = nsBase.getId();
            estimateSize += getEstimateSize(colItemID,itemID,modeMap,newInterval,newPeriod,isCluster);
            if(samplingConf.containsKey(itemID)){
                samplingConf.remove(itemID);
            }
        }
        //calculate no modify item 
        estimateSize += getNoCurColItemsEstimateSize(colItemID,samplingConf,modeMap,isCluster);
        return estimateSize;
    }
    
    private double getNoCurColItemsEstimateSize(String colItemID,Map samplingConf,Map modeMap,boolean isCluster) throws Exception{
        double estimateSize = 0.0;
        Iterator samplingConfIter = samplingConf.keySet().iterator();
        while(samplingConfIter.hasNext()){
            String itemID = (String)samplingConfIter.next();
            SamplingConf sc = (SamplingConf)samplingConf.get(itemID);
            double interval = Double.parseDouble(sc.getInterval());
            double period = Double.parseDouble(sc.getPeriod());
            estimateSize += getEstimateSize(colItemID,itemID,modeMap,interval,period,isCluster);
        }
        return estimateSize;
    }
    
    private double getEstimateSize(String colItemID,String id,Map modeMap,double interval,double period,boolean isCluster) throws Exception{
        int resourceNum = getResourceNum(colItemID,id,modeMap,isCluster);
        return calcuExpectSize(interval,period,resourceNum);
    }
    
    private int getResourceNum(String colItemID,String id,Map modeMap, boolean isCluster)
        throws Exception {
        int resourceNum;
        if (colItemID.equals(STATIS_NFS_VIRTUAL_PATH)) {
            String mode = (String) modeMap.get(id);
            resourceNum = (isCluster&&(mode.equals(BOTH)))?2:1;
        } else if (colItemID.equals(STATIS_NFS_SEVER)) {
            resourceNum = isCluster ? 2 : 1;
        } else {
            resourceNum = 1;
        }
        return resourceNum;
        
    }
    
    private double calcuExpectSize(double interval,double period,int resourceNum) throws Exception{
        interval /= 60;
        double headSectionSize = 340 + 392 * STATIS_NSW_SAMPLING_INFO_NUM;
        double dataSectionSize =13440 * STATIS_NSW_SAMPLING_INFO_NUM * period / interval;
        double RRDsize = headSectionSize + dataSectionSize;
        double blockRRDSize = Math.ceil(RRDsize / BLOCK_SIZE) * BLOCK_SIZE;
        double size = blockRRDSize * resourceNum; //B
        return size;
    }

    public void setSamplingConfs(
        HttpServletRequest request,
        String interval,
        String period)
        throws Exception {
        String targetID =
            (String)NSActionUtil.getSessionAttribute(request,CollectionConst.STATIS_SAMPLING_TARGETID);
        String colItemID =
            (String)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_COLITEM_ID); 
        List indexList =
            (List)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_SESSION_SELECTED_INDEXLIST); 
        Map infoMap =
            (Map)NSActionUtil.getSessionAttribute(request,STATIS_NSW_SAMPLING_SESSION_TABLELIST_MAP); 
        List confList = new ArrayList();
        String intervalSec = min2sec(interval);
        for (int i = 0; i < indexList.size(); i++) {
            String index = (String) indexList.get(i);
            NswSamplingInfoBeanBase nsBase =
                (NswSamplingInfoBeanBase) infoMap.get(index);
            SamplingConf sc = new SamplingConf();
            sc.setId(nsBase.getId());
            sc.setInterval(intervalSec);
            sc.setPeriod(period);
            confList.add(sc);
        }
        MonitorConfig3 mc3 = new MonitorConfig3();
        mc3.loadDefs(); 
        int result = mc3.setSamplingConfs(targetID, colItemID, confList);
        if (result != 0) {
            CsvDownloadUtil.makeNSException(
                NswSamplingAction.class,
                STATIS_NSW_SAMPLING_MODIFY_FAILED,
                null,
                NSReporter.ERROR);
        }
    }

    private String sec2min(String seconds) {

        int second = Integer.parseInt(seconds);
        int minute = second / 60;
        String result = String.valueOf(minute);
        return result;
    }

    public String min2sec(String minutes) {
        int minute = Integer.parseInt(minutes);
        int second = minute * 60;
        String result = String.valueOf(second);
        return result;
    }
    
    public void putResourceList2SessionMap(HttpServletRequest request,List resourceList){
        Map resourceMap = new HashMap();
        for(int i=0;i<resourceList.size();i++){
            String index = ((NswSamplingInfoBeanBase) resourceList.get(i)).getIndexID();
            resourceMap.put(index, resourceList.get(i));
            NSActionUtil.setSessionAttribute(request,STATIS_NSW_SAMPLING_SESSION_TABLELIST_MAP,resourceMap);
        }
    }
    
    private void fillData(Map samplingIsOnMap,Map rrdFileMap,NswSamplingInfoBeanBase nsBase){
        SamplingConf sc =
            (SamplingConf) samplingIsOnMap.get(nsBase.getId());
        if (sc == null){
            nsBase.setSamplingStatus(new Boolean(false));
            nsBase.setInterval("--");
            nsBase.setPeriod("--");
        }else{
            nsBase.setSamplingStatus(new Boolean(true));
            nsBase.setInterval(sec2min(sc.getInterval()));
            nsBase.setPeriod(sc.getPeriod());
        }
        if(rrdFileMap.containsKey(nsBase.getId())){
            nsBase.setSize((String)rrdFileMap.get(nsBase.getId()));
        }else{
            nsBase.setSize("--");
        }
    }
    
    private List getNodeIDList(String targetID,MonitorConfigBase mc){
        TargetDef td = mc.getTargetDef(targetID);
        List nodeList = new ArrayList();
        if (td.getType().equals(TargetDef.CLUSTER)||td.getType().equals(TargetDef.NASIPSAN)) {           
            nodeList = td.getNodes();
        } else {
            nodeList.add(targetID);
        }
        return nodeList;
    }
    
    private Map getRRDFileMap(MonitorConfigBase mcBase,String targetID,String colItemID) throws Exception{
        List nodeList = getNodeIDList(targetID,mcBase);
        Map rrdFileSizeMap = new HashMap();
        for(int i=0;i<nodeList.size();i++){
            String nodeID = (String)nodeList.get(i);
            RRDFilesInfo rfi = mcBase.loadRRDFilesInfo(nodeID,colItemID);
            List rrdFileIDList = rfi.getIDList();
            for(int j=0;j<rrdFileIDList.size();j++){
                String rrdID = (String)rrdFileIDList.get(j);
                RRDFile rf = rfi.get(rrdID);
                if(rrdFileSizeMap.containsKey(rrdID)){
                    double size = Double.parseDouble((String)rrdFileSizeMap.get(rrdID));
                    size += Double.parseDouble(rf.getSize());
                    rrdFileSizeMap.put(rrdID,formatSize(size));
                }else{
                    double size = Double.parseDouble(rf.getSize());
                    rrdFileSizeMap.put(rrdID,formatSize(size));
                }
            }
        }
        return rrdFileSizeMap;
    }
    
    private String formatSize(double size){
        size = size / MILLIONBYTE;
        String fileSize = Double.toString(Math.round(size * 100) / 100.00);
        if (fileSize.length() - fileSize.indexOf(".")<3){
            fileSize = fileSize + "0";
        }
        return fileSize;
    }
}