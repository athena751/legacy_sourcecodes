/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.common;

import java.math.BigInteger;



public class DiskArrayRankInfo {


    private static final String     cvsid = "@(#) $Id: DiskArrayRankInfo.java,v 1.2301 2005/09/21 05:00:38 wangli Exp $";


    private String type;

    private String poolNo;
    private String poolName;
    private String basePd;
    private String state;
    private String raidType;
    private String capacity;
    private String progression;
    private String rebuildingTime;
    private String expandingTime;
    private String remainCapacity;
    private String PDG;

    public DiskArrayRankInfo()
    {
        type="";
        poolNo="";
        poolName="";
        basePd="";
        raidType="";
        capacity="";
        progression="";
        rebuildingTime="";
        expandingTime="";
        remainCapacity="";
        PDG="";
    }

    public String getType()
    {
        return type;
    }
    public String getState()
    {
        return state;
    }
    public String getRaidType()
    {
        if (raidType.equals("6")){
            if (basePd.equals("6")){
                return FCSANConstants.RAID_6_4PQ;
            }else{
                return FCSANConstants.RAID_6_8PQ;
            }
        }else{
            return raidType;
        }
    }
    public String getCapacity()
    {
        return capacity;
    }
    public String getProgression()
    {
        return progression;
    }
    public String getRebuildingTime()
    {
        return rebuildingTime;
    }
    public String getExpandingTime()
    {
        return expandingTime;
    }

    public void setType(String typeValue)
    {
        type=typeValue;
    }
    public void setState(String stateValue)
    {
        state=stateValue;
    }
    public void setRaidType(String raidTypeValue)
    {
        raidType=raidTypeValue;
    }
    public void setCapacity(String capacityValue)
    {
        BigInteger biCapacity = new BigInteger(capacityValue);
        biCapacity = biCapacity.multiply(new BigInteger("512"));
        capacity = biCapacity.toString();        
    }
    public void setProgression(String progressionValue)
    {
        progression=progressionValue;
    }
    public void setRebuildingTime(String rebuildingTimeValue)
    {
        rebuildingTime=rebuildingTimeValue;
    }
    public void setExpandingTime(String expandingTimeValue)
    {
        expandingTime=expandingTimeValue;
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

    public String getBasePd() {
        return basePd;
    }

    public void setBasePd(String basePd) {
        this.basePd = basePd;
    }

    public String getRemainCapacity() {
        return remainCapacity;
    }

    public void setRemainCapacity(String remainCapacity) {
        BigInteger biCapacity = new BigInteger(remainCapacity);
        biCapacity = biCapacity.multiply(new BigInteger("512"));
        this.remainCapacity = biCapacity.toString();
    }

    public String getPDG() {
        return PDG;
    }

    public void setPDG(String pdg) {
        PDG = pdg;
    }
}