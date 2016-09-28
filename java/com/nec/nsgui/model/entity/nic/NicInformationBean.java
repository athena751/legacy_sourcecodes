/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NicInformationBean.java,v 1.5 2007/08/23 04:54:06 fengmh Exp $
 */
package com.nec.nsgui.model.entity.nic;

public class NicInformationBean {

/* Note:
 *     the property of ipAddress is the whole network information , such as xxx.xxx.xxx.xxx/xx
 *     the property of address is only the ip information such as xxx.xxx.xxx.xxx 
 * 
 */
    private String nicName = "";
    private String ipAddress = "--";
    private String broadcast = "--";
    private String gateway = "--";
    private String macAddress = "--";
    private String workStatus = "DOWN";
    private String linkStatus = "DOWN";
    private String mtu = "--";
    private String type = "NORMAL";
    private String mode = "--";    
    private String vl = "NO";
    private String alias = "";
    private String construction = "--";
    private String isAliasBase = "no";

    /*
     * the method to get the readonly property address   * 
     */
    public String getAddress() {
        String[] arr = this.ipAddress.split("/");
        if (arr.length > 1) {
            return arr[0];
        } else {
            return this.ipAddress;
        }
    }
    
    public void setNetmask(String string){
        String[] arr = this.ipAddress.split("/");
        if (arr.length > 1) {
            ipAddress = arr[0] + "/" + mask2Int(string);          
        } else{
            ipAddress = ipAddress +"/" + mask2Int(string);     
        }
    }
    
    public void setAddress(String string){
        String[] arr = this.ipAddress.split("/");
        if (arr.length > 1) {
            ipAddress = string+ "/" + arr[1];          
        } else {
            ipAddress = string;      
        }        
    }        
    /*
     * the method to get the readonly property netmask
     */

    public String getNetmask() {
        try {
            String[] arr = this.ipAddress.split("/");
            if (arr.length > 1) {
                int mask = Integer.parseInt(arr[1]);
                return int2mask(mask);
            } else {
                return "--";
            }
        } catch (Exception E) {
            return "--";
        }
    }


    /**
     * @return
     */
    public String getConstruction() {
        return construction;       
    }

    /**
     * @return
     */
    public String getGateway() {
        return gateway;
    }


    /**
     * @return
     */
    public String getMtu() {
        return mtu;
    }

    /**
     * @return
     */
    public String getNicName() {
        return nicName;        
    }

    /**
     * @return
     */
    public String getType() {
        return type;      
    }

    /**
     * @return
     */
    public String getVl() {
        return vl;        
    }

    /**
     * @param vector
     */
    public void setConstruction(String string) {
        construction = string;
    }

    /**
     * @param string
     */
    public void setGateway(String string) {
        gateway = string;
    }

    /**
     * @param string
     */
    public void setMtu(String string) {
        mtu = string;
    }

    /**
     * @param string
     */
    public void setNicName(String string) {
        nicName = string;
    }

    /**
     * @param string
     */
    public void setType(String string) {
        type = string;
    }

    /**
     * @param string
     */
    public void setVl(String string) {
        vl = string;
    }

    /**
     * @return
     */
    public String getBroadcast() {
        return broadcast;
    }

    /**
     * @return
     */
    public String getIpAddress() {
        return ipAddress;
    }

    /**
     * @return
     */
    public String getLinkStatus() {
        return linkStatus;       
    }

    /**
     * @return
     */
    public String getWorkStatus() {
        return workStatus;      
    }

    /**
     * @param string
     */
    public void setBroadcast(String string) {
        broadcast = string;
    }

    /**
     * @param string
     */
    public void setIpAddress(String string) {
        ipAddress = string;
    }

    /**
     * @param string
     */
    public void setLinkStatus(String string) {
        linkStatus = string;
    }

    /**
     * @param string
     */
    public void setWorkStatus(String string) {
        workStatus = string;
    }

    /**
     * @return
     */
    public String getMacAddress() {
        return macAddress;
    }

    /**
     * @param string
     */
    public void setMacAddress(String string) {
        macAddress = string;
    }
    private static String int2mask(int mask){
        String strMask = "";
        if (mask > 32 || mask < 0) {
            return "--";
        } else {
            for (int j = 0; j < 4; j++) {
                int tmp = mask > 8 ? 8 : mask;
                if (tmp >= 0) {
                    int re = (int) (256 - Math.pow(2, 8 - tmp));
                    strMask = strMask + "." + Integer.toString(re);
                } else {
                    strMask = strMask + ".0";
                }
                mask = mask - 8;
            }
            return strMask.substring(1, strMask.length());
        }
    }
    
    private static String mask2Int(String mask) {
           if (mask == "")
               return "";

           String[] num = mask.split("\\.");
           int i = 0;
           if (num.length != 4) {
               return "";
           }
           for (int j = 0; j < num.length; j++) {
               int num1 = Integer.parseInt(num[j]);
               if (num1 < 0 || num1 > 255) {
                   return "";
               }
               int tmp = (int) Math.round(Math.log(256 - num1) / Math.log(2));
               if (Math.pow(2, tmp) != (256 - num1)) {
                   return "";
               }
               if (tmp > 0) {
                   for (int k = j + 1; k < num.length; k++) {
                       if (Integer.parseInt(num[k]) > 0) {
                           return "";
                       }
                   }
               }
               i += 8 - tmp;
           }
           return "" + i;
       }


    /**
     * @return
     */
    public String getMode() {
        return mode;
    }

    /**
     * @param string
     */
    public void setMode(String string) {
        mode = string;
    }

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public String getIsAliasBase() {
        return isAliasBase;
    }

    public void setIsAliasBase(String isAliasBase) {
        this.isAliasBase = isAliasBase;
    }

}