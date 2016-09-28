/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *
 */

package com.nec.sydney.atom.admin.ddr;

public class DdrInfo{

    private static final String     cvsid = "@(#) $Id: DdrInfo.java,v 1.3 2007/04/26 05:38:00 liy Exp $";

    private String mvName,mvLogicalDisk,mvDiskArray
                    ,rvName,rvLogicalDisk,rvDiskArray,isMvRvusing
                    ,ddrStatus,replicateStatus,hasSchedule,status;
    private boolean hasDelete;
    public DdrInfo(String[] info){
    	setMvName(info[0]);
		setMvLogicalDisk(info[1]);
		setMvDiskArray(info[2]);
		setRvName(info[3]);
		setRvLogicalDisk(info[4]);
		setRvDiskArray(info[5]);
		setIsMvRvusing(info[6]);
		setDdrStatus(info[7].equals("-")?"none":info[7]);
		setReplicateStatus(info[8].equals("-")?null:info[8]);
		setHasSchedule(info[9]);//"true" means that the pairing has schedule in cron file
		setHasDelete(info[10].equals("1"));//"1" means that the pairing exists only in cron file
		
    }
    public String getMvName(){
        return mvName;
    }
    public String getMvLogicalDisk(){
        return mvLogicalDisk;
    }
    public String getMvDiskArray(){
        return mvDiskArray;
    }
    public String getRvName(){
        return rvName;
    }
    public String getRvLogicalDisk(){
        return rvLogicalDisk;
    }
    public String getRvDiskArray(){
        return rvDiskArray;
    }
    public String getIsMvRvusing(){
        return isMvRvusing;
    }
    public String getDdrStatus(){
        return ddrStatus;
    }
    public String getReplicateStatus(){
        return replicateStatus;
    }
    public String getHasSchedule (){
        return hasSchedule;
    }
    public String getStatus (){
        if(ddrStatus!=null && replicateStatus!=null){
            status = ddrStatus+replicateStatus;
        }else if(ddrStatus!=null && replicateStatus==null){
            status = ddrStatus;
        }else{
            status = "";
        }
        return status;
    }
    public boolean getHasDelete (){
        return hasDelete;
    }

    public void setMvName (String mvName){
        this.mvName = mvName;
    }
    public void setMvLogicalDisk (String mvLogicalDisk){
        this.mvLogicalDisk = mvLogicalDisk;
    }
    public void setMvDiskArray (String mvDiskArray){
        this.mvDiskArray = mvDiskArray;
    }
    public void setRvName (String rvName){
        this.rvName = rvName;
    }
    public void setRvLogicalDisk (String rvLogicalDisk){
        this.rvLogicalDisk = rvLogicalDisk;
    }
    public void setRvDiskArray (String rvDiskArray){
        this.rvDiskArray = rvDiskArray;
    }
    public void setIsMvRvusing (String isMvRvusing){
        this.isMvRvusing = isMvRvusing;
    }
    public void setDdrStatus (String ddrStatus){
        this.ddrStatus = ddrStatus;
    }
    public void setReplicateStatus (String replicateStatus){
        this.replicateStatus = replicateStatus;
    }
    public void setHasSchedule (String hasSchedule){
        this.hasSchedule = hasSchedule;
    }
    public void setHasDelete (boolean hasDelete){
        this.hasDelete = hasDelete;
    }
}