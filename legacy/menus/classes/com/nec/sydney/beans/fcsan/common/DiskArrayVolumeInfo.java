/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.common;

public class DiskArrayVolumeInfo{
    private static final String     cvsid = "@(#) $Id: DiskArrayVolumeInfo.java,v 1.2300 2003/11/24 00:54:47 nsadmin Exp $";

    private String selfLdName="";
    private String selfLdType="";
    private String selfLdNo="";
    private String LdCapacity="";

    private String pairLdName="";
    private String pairLdType="";
    private String pairLdNo="";
    private String pairDiskArrayName="";

    private String activityState="";
    private String syncState="";
    private String copyControlState="";
    
    private String separateDiff="";
    private String copyDiff="";
    private String volumeDiff="";

    private String previousActive="";
    private String rvAccess="";
    
    private String startTime="";
    private String endTime="";

    private String volumeKind="";

    private String transCap="";  //the string of capacity with unit

    public String getSelfLdName(){
        return selfLdName;
    }
    public void setSelfLdName(String selfLdName){
        this.selfLdName = selfLdName;
    }
    public String getSelfLdType(){
        return selfLdType;
    }
    public void setSelfLdType(String selfLdType){
        this.selfLdType = selfLdType;
    }
    public String getSelfLdNo(){
        return selfLdNo;
    }
    public void setSelfLdNo(String selfLdNo){
        this.selfLdNo = selfLdNo;
    }
    public String getPairLdType(){
        return pairLdType;
    }
    public void setPairLdType(String pairLdType){
        this.pairLdType = pairLdType;
    }
    public String getPairLdName(){
        return pairLdName;
    }
    public void setPairLdName(String pairLdName){
        this.pairLdName = pairLdName;
    }
    public String getPairLdNo(){
        return pairLdNo;
    }
    public void setPairLdNo(String pairLdNo){
        this.pairLdNo = pairLdNo;
    }
    public String getPairDiskArrayName(){
        return pairDiskArrayName;
    }
    public void setPairDiskArrayName(String pairDiskArrayName){
        this.pairDiskArrayName = pairDiskArrayName;
    }
    public String getActivityState(){
        return activityState;
    }
    public void setActivityState(String activityState){
        this.activityState = activityState;
    }
    public String getSyncState(){
        return syncState;
    }
    public void setSyncState(String syncState){
        this.syncState = syncState;
    }
    public String getCopyControlState(){
        return copyControlState;
    }
    public void setCopyControlState(String copyControlState){
        this.copyControlState = copyControlState;
    }
    public String getSeparateDiff(){
        return separateDiff;
    }
    public void setSeparateDiff(String separateDiff){
        this.separateDiff = separateDiff;
    }
    public String getLdCapacity(){
        return LdCapacity;
    }
    public void setLdCapacity(String LdCapacity){
        this.LdCapacity = LdCapacity;
    }
    public String getPreviousActive(){
        return previousActive;
    }
    public void setPreviousActive(String previousActive){
        this.previousActive = previousActive;
    }
    public String getRvAccess(){
        return rvAccess;
    }
    public void setRvAccess(String rvAccess){
        this.rvAccess = rvAccess;
    }
    public String getCopyDiff(){
        return copyDiff;
    }
    public void setCopyDiff(String copyDiff){
        this.copyDiff = copyDiff;
    }
    public String getStartTime(){
        return startTime;
    }
    public void setStartTime(String startTime){
        this.startTime = startTime;
    }
    public String getEndTime(){
        return endTime;
    }
    public void setEndTime(String endTime){
        this.endTime = endTime;
    }
    public String getVolumeKind(){
        return volumeKind;
    }
    public void setVolumeKind(String volumeKind){
        this.volumeKind = volumeKind;
    }
    public String getVolumeDiff() {
        return volumeDiff;
    }
    public void setVolumeDiff(String volumeDiff) {
        this.volumeDiff = volumeDiff;
    }

    public String getTransCap() {
        return transCap;
    }
    public void setTransCap(String transCap) {
        this.transCap = transCap;
    }

}
