/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.volume;

import java.util.Iterator;
import java.util.TreeMap;

import com.nec.nsgui.action.base.NSActionUtil;

/**
 *
 */
public class LVMInfoBean {

    public static final String cvsid =
            "@(#) $Id: LVMInfoBean.java,v 1.2 2007/06/11 03:36:31 xingyh Exp $";
            
    private String lvName = "";
    private String size = "";
    private String mountPoint = "";
    private String deviceNo = "";
    private String storage = ""; 
    private String lun = "";
    private String wwnn = "";
    private String ldList = "";
    private String striping = "";
    private String errorFlag = "";
    private String accessMode = "--";
    private String lunLd = "";
    

    /**
     * @return
     */
    public String getDeviceNo() {
        return deviceNo;
    }

    /**
     * @return
     */
    public String getErrorFlag() {
        return errorFlag;
    }

    /**
     * @return
     */
    public String getLun() {
        return lun;
    }

    /**
     * @return
     */
    public String getLvName() {
        return lvName;
    }

    /**
     * @return
     */
    public String getMountPoint() {
        return mountPoint;
    }

    /**
     * @return
     */
    public String getSize() {
        return size;
    }

    /**
     * @return
     */
    public String getStorage() {
        return storage;
    }

    /**
     * @return
     */
    public String getStriping() {
        return striping;
    }

    /**
     * @param string
     */
    public void setDeviceNo(String string) {
        deviceNo = string;
    }

    /**
     * @param string
     */
    public void setErrorFlag(String string) {
        errorFlag = string;
    }



    /**
     * @param string
     */
    public void setLun(String string) {
        lun = string;
    }

    /**
     * @param string
     */
    public void setLvName(String string) {
        lvName = string;
    }

    /**
     * @param string
     */
    public void setMountPoint(String string) {
        mountPoint = string;
    }

    /**
     * @param string
     */
    public void setSize(String string) {
        size = string;
    }

    /**
     * @param string
     */
    public void setStorage(String string) {
        storage = string;
    }

    /**
     * @param string
     */
    public void setStriping(String string) {
        striping = string;
    }

    /**
     * @return
     */
    public String getLunStorage() throws Exception{
        if(this.getLun().trim().equals("--") 
           || this.getStorage().trim().equals("--")){
            return "--";
        }
        
        String jpSlash = " / ";
        String storageStr = NSActionUtil.perl2Page(this.getStorage(),NSActionUtil.ENCODING_EUC_JP);
        String[] storages = storageStr.split(",");
        String[] luns = this.getLun().split(",");
        TreeMap map = new TreeMap();
        for (int i = 0; i < luns.length; i++) {
            String hexLun = "--";
            if(!luns[i].equals("--")){
                hexLun = NSActionUtil.getHexString(4, luns[i]);
            }
            String key = storages[i] + ","+ hexLun;
            String value = hexLun + jpSlash + storages[i];
            map.put(key, value);
        }

        Iterator itr = map.keySet().iterator();
        StringBuffer sb = 
            new StringBuffer((String)(map.get(itr.next())));
        while(itr.hasNext()){
            sb.append("<BR>")
            .append((String)(map.get(itr.next())));
        }
        return sb.toString();
    }

    /**
     * @return
     */
    public String getWwnn() {
        return wwnn;
    }

    /**
     * @param string
     */
    public void setWwnn(String string) {
        wwnn = string;
    }

    /**
     * @return
     */
    public String getLdList() {
        return ldList;
    }

    /**
     * @param string
     */
    public void setLdList(String string) {
        ldList = string;
    }

    /**
     * @return
     */
    public String getLunLd() throws Exception{
        if(this.getLun().trim().equals("--") 
           || this.getLdList().trim().equals("--")){
            return "--";
        }
        String[] luns = this.getLun().split(",");
        String[] lds = this.getLdList().split(",");
        TreeMap map = new TreeMap(); 
        
        for(int i = 0; i<luns.length; i++){
            String lunLd = "--";
            if(!luns[i].equals("--")){
                lunLd = NSActionUtil.getHexString(4, luns[i])
                        + "(" + lds[i] +")";
            }
            map.put(lunLd, lunLd);
        }
        
        Iterator itr = map.keySet().iterator();
        StringBuffer sb = new StringBuffer((String)(itr.next()));
        while(itr.hasNext()){
            sb.append(",").append((String)(itr.next()));
        }
        return sb.toString();
    }

    /**
     * @param string
     */
    public void setLunLd(String string) {
        lunLd = string;
    }

    public String getAccessMode() {
        return accessMode;
    }

    public void setAccessMode(String accessMode) {
        this.accessMode = accessMode;
    }
}
