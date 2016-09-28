/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.volume;

import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.Map;
import java.util.Vector;
import javax.servlet.http.*;
import org.apache.struts.action.*;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.action.base.*;
import com.nec.nsgui.model.entity.volume.*;
import com.nec.nsgui.model.biz.license.LicenseInfo;

public class VolumeBatchCreateShowAction extends DispatchAction implements VolumeActionConst {
    
    private static final String     cvsid = "@(#) $Id: VolumeBatchCreateShowAction.java,v 1.13 2008/10/15 02:16:39 jiangfx Exp $";
    
    public ActionForward showMaxPOOL(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {
        VolumeInfoBean [] volumes = (VolumeInfoBean [])((DynaActionForm)form).get("volumes");
        
        String[] selectOrNot = (String [])((DynaActionForm)form).get("selectOrNot");
        
        int selectStart = 0;
        String [] volumeNames = VolumeHandler.generateAllVolumeNames(selectOrNot.length , NSActionUtil.getExportGroupPath(request), NSActionUtil.getCurrentNodeNo(request));
        int i;
         for (i=0 ; i<volumes.length ; i++) {
            if (selectStart == selectOrNot.length) {
                break;
            }
            if (i == Integer.parseInt(selectOrNot[selectStart])) {
                 volumes[i].setVolumeName(volumeNames[selectStart]);
                volumes[i].setMountPoint(volumeNames[selectStart]);
                if((new Double(volumes[i].getCapacity())).compareTo(new Double(VOLUME_MAX_SIZE)) > 0){
                    volumes[i].setCapacity(VOLUME_MAX_SIZE);
                }
                selectStart++;
            } else {
                volumes[i].setPoolNo("");
            }
        }
            
        for (; i<volumes.length ; i++) {
            volumes[i].setPoolNo("");
        }  
            
        ((DynaActionForm)form).set("volumes" , volumes);
        
        // get license infomation of MVD sync
        LicenseInfo license = LicenseInfo.getInstance();
        String hasReplicLicense =
            license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"mvdsync") != 0 ? "true" : "false";
        
        NSActionUtil.setSessionAttribute(request, "volume_hasReplicLicense", hasReplicLicense);
        NSActionUtil.setSessionAttribute(request, "volume_machineType" , "nas");
        NSActionUtil.setSessionAttribute(request, "volume_volumeNumber" , Integer.toString(selectOrNot.length));
        NSActionUtil.setSessionAttribute(request, "volume_exportgroup" , NSActionUtil.getExportGroupPath(request));
        
        
        return mapping.findForward("success");
        
    }

    public ActionForward showSpecifyPOOL(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {
        VolumeInfoBean [] volumes = (VolumeInfoBean [])((DynaActionForm)form).get("volumes");
        
        String[] selectOrNot = (String [])((DynaActionForm)form).get("selectOrNot");
        String aid = (String)((DynaActionForm)form).get("diskArray");
        String raidType = (String)((DynaActionForm)form).get("raidType");
        String lvNo = (String)request.getParameter("lvNo");
        Vector pools = new Vector();
        Vector poolSizeVec = new Vector();
        long totalCapacity = 0;

        //get LD count that can been created on the specified diskarray
        String availLdCount = VolumeHandler.getLdNum4Create(aid);
        NSActionUtil.setSessionAttribute(request, "availLdCount4BatchCreate", availLdCount);//only used in batch specified page
        
        String baseVolumeName = VolumeHandler.generateBaseVolumeName(NSActionUtil.getExportGroupPath(request), NSActionUtil.getCurrentNodeNo(request));
        int selectStart = 0;
        int i;
        for (i=0 ; i<volumes.length ; i++) {
            if (selectStart == selectOrNot.length) {
                break;
            }
            if (i == Integer.parseInt(selectOrNot[selectStart])) {
            	long availableCap = getAvailableCap4Pool(volumes[i].getCapacity(), volumes[i].getManageCapOfLD(), availLdCount);
                poolSizeVec.add(volumes[i].getPoolNo() + "#" + availableCap);
                totalCapacity += availableCap;
                selectStart++;
            } else {
                volumes[i].setPoolNo("");
            }
        }
            
        for (; i<volumes.length ; i++) {
            volumes[i].setPoolNo("");
        }  

        // get license infomation of MVD sync
        LicenseInfo license = LicenseInfo.getInstance();
        String hasReplicLicense =
            license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"mvdsync") != 0 ? "true" : "false";
        
        NSActionUtil.setSessionAttribute(request, "aid", aid);
        NSActionUtil.setSessionAttribute(request, "raidType", raidType);
        Collections.sort(poolSizeVec, new SizePoolComparator());
        Collections.reverse(poolSizeVec);
        Vector rtVec = getPoolSizeVec(poolSizeVec);
        NSActionUtil.setSessionAttribute(request, "pools", rtVec.get(0));
        NSActionUtil.setSessionAttribute(request, "poolSize", join((Vector)rtVec.get(1), ","));//only used in batch specified page
        
        NSActionUtil.setSessionAttribute(request, "totalCapacity", totalCapacity + "");
        NSActionUtil.setSessionAttribute(request, "baseName", baseVolumeName);
        NSActionUtil.setSessionAttribute(request, "lvNo", lvNo);
        NSActionUtil.setSessionAttribute(request, "volume_hasReplicLicense", hasReplicLicense);
        NSActionUtil.setSessionAttribute(request, "volume_machineType" , "nas");
        NSActionUtil.setSessionAttribute(request, "volume_exportgroup" , NSActionUtil.getExportGroupPath(request));
        
        return mapping.findForward("specify");
        
    }    
    
    private long getAvailableCap4Pool(String capacity, String manageCapOfLD, String availLdCount) {
    	long availableCap=(new Double(capacity)).longValue();
    	    	
    	// get LD number using pool capacity and max available LD number of system 
    	long maxLdNumofPool = Math.min(availableCap, Long.parseLong(availLdCount));
    	// one LD's manage capacity is keeped when getting pool information
    	if (maxLdNumofPool == 1) {
    		return availableCap;
    	}
        
    	// manageCapOfLD's unit is MB, manageCapofPool's unit is GB
    	double manageCapofPool = (Double.parseDouble(manageCapOfLD) * (maxLdNumofPool - 1)) / 1024;

    	// get ingteger value
    	availableCap = (long)((new Double(capacity)).doubleValue() - manageCapofPool);
    	return availableCap;
    }
    
    /**
     * @param poolSizeVec
     * @return
     */
    private Vector getPoolSizeVec(Vector poolSizeVec) {
        Iterator it = poolSizeVec.iterator();
        Vector poolVec = new Vector();
        Vector sizeVec = new Vector();
        Vector vec = new Vector();
        while(it.hasNext()){
            String[] strArr = ((String)it.next()).split("#");
            poolVec.add(strArr[0]);
            sizeVec.add(strArr[1]);
        }
        vec.add(poolVec);
        vec.add(sizeVec);
        return vec;
    }

    /**
     * @param collection
     * @return
     */
    public static String join(Collection collection, String flag) {
        StringBuffer sb = new StringBuffer();
        Iterator it = collection.iterator();
        while(it.hasNext()){
            sb.append(it.next().toString()).append(flag);
        }
        String str = sb.toString();
        return str.substring(0, str.length() - flag.length());
    }

    /**
     * @param sizePoolmap
     * @param comparator
     * @return
     */
    public static Vector getValueSortByKey(Map map, Comparator comparator) {
        Vector valueVec = new Vector();
        Vector keyVec = new Vector();
        keyVec.addAll(java.util.Arrays.asList(map.keySet().toArray()));
        if(comparator != null){
            Collections.sort(keyVec, comparator);
        }else{
            Collections.sort(keyVec);
        }
        Iterator it = keyVec.iterator();
        while(it.hasNext()){
            valueVec.add(map.get(it.next()));
        }
        return valueVec;
    }
    

    public ActionForward showLUN(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {  
        VolumeInfoBean [] volumes = (VolumeInfoBean [])((DynaActionForm)form).get("volumes");
        Vector allLuns = VolumeHandler.getAvailLunInfo(CONST_DISPLAYMVLUN);

        VolumeAvailableNumberBean availNo = VolumeHandler.getVolumeAvailableNumber();
        int availLvNum = 256 - Integer.parseInt(availNo.getLvCount());
        
        //generate all volume names that are needed .
        String [] volumeNames = VolumeHandler.generateAllVolumeNames(allLuns.size() , NSActionUtil.getExportGroupPath(request), NSActionUtil.getCurrentNodeNo(request));
        int availLUNcount = 0;
        for (int i=0 ; i<allLuns.size(); i++) {
            LunInfoBean lunInfo = (LunInfoBean)allLuns.get(i);
            volumes[i].setStorage(lunInfo.getStorage());
            volumes[i].setWwnn(lunInfo.getWwnn());
            volumes[i].setLdPath(lunInfo.getLdPath());
            if ((new Double(lunInfo.getSize())).compareTo(new Double(VOLUME_MAX_SIZE)) > 0){
                volumes[i].setLun("");
            } else {
                volumes[i].setLun(lunInfo.getLun());
                availLUNcount++;                
            }
            volumes[i].setLunDisplay(lunInfo.getLun() + "(" + NSActionUtil.getHexString(4 , lunInfo.getLun()) + ")");
            volumes[i].setCapacity(lunInfo.getSize());
            
            volumes[i].setVolumeName(volumeNames[i]);
            volumes[i].setMountPoint(volumeNames[i]);
        }     

        if(availLvNum > availLUNcount){
            availLvNum = availLUNcount;
        }

        if (availLvNum == 0) {
            return mapping.findForward("noLun");  
        }
                
        for (int i=allLuns.size() ; i<volumes.length; i++) {
            volumes[i].setLun("");
        }

        
        ((DynaActionForm)form).set("volumes" , volumes);
        
         // get license infomation of MVD sync
        LicenseInfo license = LicenseInfo.getInstance();
        String hasReplicLicense =
            license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"mvdsync") != 0 ? "true" : "false";
        
        NSActionUtil.setSessionAttribute(request, 
                        "volume_hasReplicLicense", hasReplicLicense);
        NSActionUtil.setSessionAttribute(request, 
                        "volume_machineType" , "nashead");
        NSActionUtil.setSessionAttribute(request, 
                        "volume_volumeNumber" , Integer.toString(availLUNcount));
        NSActionUtil.setSessionAttribute(request, 
                        "volume_availLvNumber" , "" + availLvNum);                        
        NSActionUtil.setSessionAttribute(request, 
                        "volume_exportgroup" , NSActionUtil.getExportGroupPath(request));
                  	
        return mapping.findForward("success");  
    }
}

class SizePoolComparator implements Comparator {
    public int compare(Object o1, Object o2){
        if(o1 == null && o2 == null) return 0;
        if(o1 == null) return -1;
        if(o2 == null) return 1;
        String  size1 = ((String)o1).split("#")[1].trim();
        String  size2 = ((String)o2).split("#")[1].trim();
        return new Double(size1).compareTo(new Double(size2));
    }
}