/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.ndmpv4;

public class NdmpSessionInfoBean{
    
    private static final String cvsid = "@(#) $Id: NdmpSessionInfoBean.java,v 1.0 2006/02/21 05:26:33 qim Exp";
    private String sessionId;
    private String sessionType;
    private String sessionTypeJob;
    private String startTime;
    private String dmaIp;
    private String dataIp;
    private String dataState;
    private String moverIp;
    private String moverState;
    private String bytesTxferred;
    private String currentThruput;
    private String scsiDevice;
    private String tapeDevice;
    private String tapeOpenMode;
    private String sessionRadioId;
    private String MBytesTxferred;
    public void setSessionId(String sessionId){
        this.sessionId = sessionId;
        this.sessionRadioId = sessionId;
    }
    
    public void setSessionType(String sessionType){
        this.sessionType = sessionType;
    }
    
    public void setSessionTypeJob(String sessionTypeJob){
        this.sessionTypeJob = sessionTypeJob;
    }
    public void setStartTime(String startTime ){
        this.startTime= startTime;
    }
    
    public void setDmaIp(String dmaIp){
        this.dmaIp = dmaIp;
    }
    
    public void setDataIp(String dataIp){
        this.dataIp = dataIp;
    }
    
    public void setDataState(String dataState){
        this.dataState = dataState;
    }
        
    public void setMoverIp(String moverIp){
        this.moverIp = moverIp;
    }
    
    public void setMoverState(String moverState){
        this.moverState = moverState;
    }
    
    public void setBytesTxferred(String bytesTxferred){
        this.bytesTxferred = bytesTxferred;
    }
    
    public void setCurrentThruput(String currentThruput){
        this.currentThruput = currentThruput;
    }
    
    public void setScsiDevice(String scsiDevice){
        this.scsiDevice = scsiDevice;
    }
    
    public void setTapeDevice(String tapeDevice){
        this.tapeDevice = tapeDevice;
    }
    
    public void setTapeOpenMode(String tapeOpenMode){
        this.tapeOpenMode = tapeOpenMode;
    }
    public void setMBytesTxferred(String MBytesTxferred) {
        this.MBytesTxferred = MBytesTxferred;
    }
    public String getSessionRadioId(){
        return sessionRadioId;
    }
    public String getSessionId(){
        return sessionId;
    }
    
    public String getSessionType(){
        return sessionType;
    }
    
    public String getSessionTypeJob(){
        return sessionTypeJob;
    }
    public String getStartTime(){
        return startTime;
    }
    
    public String getDmaIp(){
        return dmaIp;
    }
    
    public String getDataIp(){
        return dataIp;
    }
    
    public String getDataState(){
        return dataState;
    }
    
    public String getMoverIp(){
        return moverIp;
    }
    
    public String getMoverState(){
        return moverState;
    }
    
    public String getBytesTxferred(){
        return bytesTxferred;
    }
    
    public String getCurrentThruput(){
        return currentThruput;
    }
    
    public String getScsiDevice(){
        return scsiDevice;
    }
    
    public String getTapeDevice(){
        return tapeDevice;
    }
    
    public String getTapeOpenMode(){
        return tapeOpenMode;
    }

    public String getMBytesTxferred(){
        return MBytesTxferred;
    }
}