/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.common;
import java.util.*;


public class DiskArrayLDInfo {


    private static final String     cvsid = "@(#) $Id: DiskArrayLDInfo.java,v 1.2301 2005/09/21 05:00:38 wangli Exp $";


    private String ldNo;

    private String name;
    private String type;
    private String state;
    private String RAID;
    private String raidType;
    private String capacity;
    private String cacheFlag;
    private String progression;
    private String currentOwner;
    private String defaultOwner;
    private String ldSet;
    private String LUN;
    private String ldGroup;
    private String purpose;
    private long partition;
    private long startAddr;
    private String basePd;
    private String poolNo;
    private String poolName;

        public DiskArrayLDInfo()
        {
             ldNo="";
             name="";
             type="";
             state="";
             RAID="";
         raidType="";
         capacity="";
         cacheFlag="";
         progression="";
         currentOwner="";
         defaultOwner="";
         ldSet="";
            LUN = "";
            ldGroup = "";
            purpose = "";
            basePd = "";
            poolNo = "";
            poolName = "";
        }
 
        public String getLdNo()
        {
             return ldNo;
        }

        public String getName()
        {
             return name;
        }

        public String getType()
        {
             return type;
        }

        public String getState()
        {
             return state;
        }

        public String getRAID()
        {
            if (RAID.equals("6")){
                if (basePd.equals("6")){
                    return FCSANConstants.RAID_6_4PQ;
                }else{
                    return FCSANConstants.RAID_6_8PQ;
                }
            }else{
                return RAID;
            }
        }

        public String getRaidType()
        {
                return raidType;
        }        

        public String getCapacity()
        {
             return capacity;
        }

        public String getCacheFlag()
        {
             return cacheFlag;
        }
 
        public String getProgression()
        {
             return progression;
        }

        public String getCurrentOwner()
        {
             return currentOwner;
        }

        public String getDefaultOwner()
        {
             return defaultOwner;
        }
 
        public String getLdSet()
        {
             return ldSet;
        }

    public String getPurpose()
    {
        return purpose;
    }

    public String getLUN(){
        return LUN;
    }

    public String getLdGroup() {
        return ldGroup;
    }

    public long getStartAddr() {
        return startAddr;
    }

    public void setStartAddr(long startAddr)
    {
        this.startAddr = startAddr;
    }

    public long getPartition() {
        return partition;
    }

    public void setPartition(long partition)
    {
        this.partition = partition;
    }

        public void setLdNo(String ld_No)
        {
             ldNo=ld_No;
        }

        public void setName(String ld_name)
        {
             name=ld_name;
        }

        public void setType(String ld_type)
        {
             type=ld_type;
        }

        public void setState(String ld_state)
        {
             state=ld_state;
        }

        public void setRAID(String ld_RAID)
        {
             RAID=ld_RAID;
        }

        public void setRaidType(String ld_raidType)
        {
             raidType=ld_raidType;
        }        

        public void setCapacity(String ld_capacity)
        {
             capacity=ld_capacity;
        }

        public void setCacheFlag(String ld_cacheFlag)
        {
             cacheFlag=ld_cacheFlag;
        }
 
        public void setProgression(String ld_progression)
        {
             progression=ld_progression;
        }

        public void setCurrentOwner(String ld_currentOwner)
        {
             currentOwner=ld_currentOwner;
        }

        public void setDefaultOwner(String ld_defaultOwner)
        {
             defaultOwner=ld_defaultOwner;
        }
 
        public void setLdSet(String ld_set)
        {
             ldSet=ld_set;
        }

    public void setLUN(String lun) {
        LUN = lun;
    }

    public void setLdGroup(String ldGroupValue) {
        ldGroup = ldGroupValue;
    }

    public void setPurpose(String purp) {
        purpose = purp;
    }
//get ldSet and change into corresponding string

    public String getLDSetSummary()
    {
        StringTokenizer st=new StringTokenizer(ldSet,",");
        if (st.countTokens()<=4)
        {
            return ldSet;
        }
        StringBuffer sb=new StringBuffer();
        for (int i=0;i<=3;i++ )
        {
            sb.append(st.nextToken());
            if (i < 3){
                sb.append(",");
            }
        }
        sb.append("...");
        return sb.toString();
        
    }

    public String getBasePd() {
        return basePd;
    }

    public void setBasePd(String basePd) {
        this.basePd = basePd;
    }

    public String getPoolName() {
        return poolName;
    }

    public void setPoolName(String poolName) {
        this.poolName = poolName;
    }

    public String getPoolNo() {
        return poolNo;
    }

    public void setPoolNo(String poolNo) {
        this.poolNo = poolNo;
    }        
 
       
}