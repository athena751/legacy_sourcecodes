/*
 *      Copyright (c) 2001-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.quota;


import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.framework.*;

public class QuotaSetBean extends GetOneReportBean implements NasConstants,NasSession,NSExceptionMsg
{

    private static final String     cvsid = "@(#) $Id: QuotaSetBean.java,v 1.2305 2006/01/03 09:43:53 cuihw Exp $";
    private static String fstype;

    private String oldBlockSoft;
    private String oldBlockHard;
    private String oldFileSoft;
    private String oldFileHard;
    
    public QuotaSetBean()
    {
    }

    public void beanProcess() throws Exception
    {
        fstype = (String)session.getAttribute(NasSession.SESSION_QUOTA_FSTYPE);  
        oldBlockSoft="0";
        oldBlockHard="0";
        oldFileSoft="0";
        oldFileHard="0"; 
     //   getSpecifiedReport();
    }
    
    public String setQuota() throws Exception
    {
        //the flag mark if it is comeing from DirQuota.
        boolean isDirQuota;
        
        String dirQuotaFlag = request.getParameter("DirQuotaFlag");
        if (dirQuotaFlag != null && !dirQuotaFlag.equals("")){
            isDirQuota = true; 
        } else {
            isDirQuota = false;
        }   
        
        //decide user or group , flag="user" (user) , flag="group"(group)
        String flag;
        //Get all parameter
        String filesystem;
        if (isDirQuota){
            filesystem = (String)session.getAttribute(SESSION_HEX_DIRQUOTA_DATASET);
        } else {
            filesystem = (String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);  
        }
        String idnumber = request.getParameter("idnumber");
        String blockSoftLimit = request.getParameter("blockSoftLimit");
        String blockHardLimit = request.getParameter("blockHardLimit");
        String fileSoftLimit = request.getParameter("fileSoftLimit");
        String fileHardLimit = request.getParameter("fileHardLimit");
        String unitOfBlock = request.getParameter("unitOfBlock");
        String flagUser = request.getParameter("flagUser");
        String flagName = request.getParameter("flagName");
        
        if(getSpecifiedReport() == false){
            return idnumber;
        }
        Double blockSoftLimitDouble = new Double (blockSoftLimit);
        Double blockHardLimitDouble = new Double (blockHardLimit);
        double blockSoftDoubleValue = blockSoftLimitDouble.doubleValue();
        double blockHardDoubleValue = blockHardLimitDouble.doubleValue();
        if (unitOfBlock.equals("/M")) {
            if(blockSoftLimit.equals("-1")){
                blockSoftLimit = oldBlockSoft;
            }else {
                blockSoftDoubleValue = blockSoftDoubleValue*1024*1024/NasConstants.BLOCK_SIZE;
                blockSoftLimit = NSUtil.getDouble(blockSoftDoubleValue,0,1);
            }
            
            if(blockHardLimit.equals("-1")){
                blockHardLimit = oldBlockHard; 
            }else {
                blockHardDoubleValue = blockHardDoubleValue*1024*1024/NasConstants.BLOCK_SIZE;
                blockHardLimit = NSUtil.getDouble(blockHardDoubleValue,0,1);
            } 
        } else if (unitOfBlock.equals("/G")) {
            if(blockSoftLimit.equals("-1")){
                blockSoftLimit = oldBlockSoft;
            }else {
                blockSoftDoubleValue = (blockSoftDoubleValue*1024*1024/NasConstants.BLOCK_SIZE)*1024;
                blockSoftLimit = NSUtil.getDouble(blockSoftDoubleValue,0,1);
            }
            
            if(blockHardLimit.equals("-1")){
                blockHardLimit = oldBlockHard; 
            }else {
                blockHardDoubleValue = (blockHardDoubleValue*1024*1024/NasConstants.BLOCK_SIZE)*1024;
                blockHardLimit = NSUtil.getDouble(blockHardDoubleValue,0,1);
            }
        } else {
            NSException ex = new NSException(this.getClass(),NSMessageDriver.getInstance().getMessage(session, "exception/common/invalid_param"));
            ex.setDetail("unitOfBlock="+unitOfBlock);
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            NSReporter.getInstance().report(ex);
            throw ex;
        }
        
        //add by cuihw
        blockSoftDoubleValue = (new Double (blockSoftLimit)).doubleValue();
        blockHardDoubleValue = (new Double (blockHardLimit)).doubleValue();
        double zero = new Double ("0").doubleValue();
        
        String replacementsblock[] = {changeUnit4Show(blockSoftDoubleValue,unitOfBlock),changeUnit4Show(blockHardDoubleValue,unitOfBlock)};
        if(Double.compare(blockSoftDoubleValue,blockHardDoubleValue) > 0 && Double.compare(blockHardDoubleValue,zero) != 0){
            super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed")
                 + "\\r\\n" + NSMessageDriver.getInstance().getMessage(session, "nas_quota/alert/blockLimitErr1")
                 + "\\r\\n" + NSMessageDriver.getInstance().getMessage(session, "nas_quota/alert/blockLimitErr12_common",replacementsblock ));
            if (isDirQuota){
                response.sendRedirect(response.encodeRedirectURL("dirquotasetbottom.jsp"));
            } else {
                response.sendRedirect(response.encodeRedirectURL("quotasetbottom.jsp"));
            }
            return idnumber; 
        }
        
                
        if(fileSoftLimit.equals("-1")){
            fileSoftLimit = oldFileSoft; 
        }        
        if(fileHardLimit.equals("-1")){
            fileHardLimit = oldFileHard; 
        } 
        int filesoft=Integer.parseInt(fileSoftLimit,10);
        int filehard=Integer.parseInt(fileHardLimit,10);
        String replacementsfile[] = {fileSoftLimit,fileHardLimit};
        if(filehard != 0 && filesoft > filehard){
            super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed")
                 + "\\r\\n" + NSMessageDriver.getInstance().getMessage(session, "nas_quota/alert/fileLimitErr1")
                 + "\\r\\n" + NSMessageDriver.getInstance().getMessage(session, "nas_quota/alert/fileLimitErr12_common",replacementsfile ));
            if (isDirQuota){
                response.sendRedirect(response.encodeRedirectURL("dirquotasetbottom.jsp"));
            } else {
                response.sendRedirect(response.encodeRedirectURL("quotasetbottom.jsp"));
            }
            return idnumber; 
        }
        //add by cuihw
        
        if (flagUser.equals("true")) {
            flag="user";
        } else if (flagUser.equals("false")) {
            flag="group";
        } else if (flagUser.equals("dir")){
            flag="dir" ;  
        }
        else {
            NSException ex = new NSException(this.getClass(),NSMessageDriver.getInstance().getMessage(session, "exception/common/invalid_param"));
            ex.setDetail("flagUser="+flagUser);
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            NSReporter.getInstance().report(ex);
            throw ex;
        }

        if (flagName.equals("true")) {
           // String name=idnumber;//MessageDriver-modify
            String name=idnumber.replaceAll("\"","\\\\\"");
            
            idnumber = QuotaSOAPClient.getIDFromName(target,idnumber,(String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT),flag);
            if (idnumber.startsWith(IMS_CTL_ERR_START)) {
                String replacements[]={name};   
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed")+
                       "\\r\\n"+NSMessageDriver.getInstance().getMessage(session, "nas_quota/alert/convert",replacements)); 
                if (isDirQuota){
                    response.sendRedirect(response.encodeRedirectURL("dirquotasetbottom.jsp"));
                } else {
                    response.sendRedirect(response.encodeRedirectURL("quotasetbottom.jsp"));
                }return idnumber;
            }
        }

        QuotaSOAPClient.setQuota(target,filesystem,idnumber,blockSoftLimit,blockHardLimit,fileSoftLimit,fileHardLimit,flagUser,isDirQuota);
        super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        if (isDirQuota){
            response.sendRedirect(response.encodeRedirectURL("dirquotasetbottom.jsp"));
        } else {
            response.sendRedirect(response.encodeRedirectURL("quotasetbottom.jsp"));
        }
        return  null;
    }
    /*
    * 2002-11-01
    *If it's ntfs , check username by NT's name.Get the fstype before
    *setQuota so that to apply username's check rule
    */
    public  String getFsType() throws Exception
    {
        return fstype;
    }
    
    public boolean getSpecifiedReport() throws Exception {
        String DirQuota = (String)request.getParameter("DirQuotaFlag");
        boolean isDirQuota = false;
        String filesystem;
        if (DirQuota == null){
            filesystem = (String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
            isDirQuota = false;
        } else {
            filesystem = (String)session.getAttribute(SESSION_HEX_DIRQUOTA_DATASET);
            isDirQuota = true;
        }

        String idnumber = (String)request.getParameter("idnumber");
        String flagName = request.getParameter("flagName");
        String flagUser = request.getParameter("flagUser");
        String[] limitInfo = getOneReport(isDirQuota, filesystem, idnumber, flagUser, flagName);
        if(limitInfo == null ){
            return true;
        }else if(limitInfo.length !=0){
            oldBlockSoft = limitInfo[0];
            oldBlockHard = limitInfo[1];
            oldFileSoft = limitInfo[2];
            oldFileHard = limitInfo[3];
            return true;
        }else {
            return false;
        }  
    }
    public String changeUnit4Show(double limitValue, String unit) throws Exception{
        if (unit.equals("/M")){
            limitValue = limitValue*NasConstants.BLOCK_SIZE/(1024*1024);
            return NSUtil.getDouble(limitValue,2,1)+" MB";
        } else{//unit.equals("/G")
            limitValue = limitValue*NasConstants.BLOCK_SIZE/(1024*1024*1024);
            return NSUtil.getDouble(limitValue,2,1)+" GB";
        }
    }
}