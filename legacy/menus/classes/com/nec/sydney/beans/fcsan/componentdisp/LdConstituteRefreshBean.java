/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.componentdisp;
import java.io.*;
import java.util.*;
import com.nec.sydney.beans.fcsan.common.*;
import com.nec.sydney.beans.fcsan.componentconf.PDAndRankListBean;
import com.nec.sydney.framework.*;

public class LdConstituteRefreshBean extends FcsanAbstractBean implements FCSANConstants{

    private static final String     cvsid = "@(#) $Id: LdConstituteRefreshBean.java,v 1.2302 2005/09/21 05:00:39 wangli Exp $";


    //Member variable
    private Vector LDInfoVec;
    private boolean success;
    
    //Member methods
    public LdConstituteRefreshBean()
    {
        success=true;
    }

    public void beanProcess() throws Exception {
        String diskArrayID = request.getParameter("diskArrayID");
        String typeValue=request.getParameter("typeValue");
        typeValue=typeValue.trim();
        int returnValue;
        
        if (diskArrayID==null || typeValue==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }
        if (typeValue.equals("All"))
        {
            String cmd=CMD_DISKLIST_L+" "+diskArrayID;
            returnValue=getLDInfo(cmd, diskArrayID);
            if (returnValue!=FCSAN_SUCCESS)
            {
                success=false;
                return;
            }
        }
        else if (typeValue.indexOf("-")!=-1) /*port, typeValue is the portno, it's format is "**h-**h"*/
        {
            String cmd = CMD_DISKLIST_L+" "+diskArrayID+" "+"-port"+" "+typeValue;
            returnValue=getLDInfo(cmd, diskArrayID);
            if (returnValue!=FCSAN_SUCCESS)
            {
                success=false;
                return;
            }
        }else if (typeValue.equals("Pool")){
            String cmd = CMD_DISKLIST_L+" "+diskArrayID+" "+"-pool";
            returnValue=getLDInfo(cmd, diskArrayID);
            if (returnValue!=FCSAN_SUCCESS)
            {
                success=false;
                return;
            }
        }else{  /*ldset, typevalue is the ldsetno, it is an integer*/
                String cmd = CMD_DISKLIST_L+" "+diskArrayID+" "+"-ldset"+" "+typeValue;
                returnValue=getLDInfo(cmd, diskArrayID);
                if (returnValue!=FCSAN_SUCCESS)
                {
                    success=false;
                    return;
                }
        }
    }

    public Vector getLDInfoVec()
    {
        return LDInfoVec;
    }
    public boolean getSuccess()
    {
        return success;
    }

    private int getLDInfo(String cmd, String aid) throws Exception
    {
        if (cmd==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }
        BufferedReader buf=execCmd(cmd);
        if(buf!=null)
        {    
            String resultOneLine;
            LDInfoVec = new Vector();   
            while ((resultOneLine=buf.readLine())!=null)
            {
                if (resultOneLine.startsWith(SEPARATED_LINE))
                    break;
            }    
            resultOneLine=buf.readLine();
            
            //iSM2.1_FD_Review_JP No.12  -- Modify by JinKC
            String pdGroup = request.getParameter("PDGroup") ;
                                
            while (resultOneLine!=null)
            {
                StringTokenizer resultValue = new StringTokenizer(resultOneLine);
                int count=resultValue.countTokens();
                if (count!=2)
                {
                    DiskArrayLDInfo diskArrayLDInfo = new DiskArrayLDInfo();
                    if (count!=11 && count!=12)
                    {
                        NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/common/invalid_cmd_output"));
                        throw e;
                    }
                    diskArrayLDInfo.setLdNo(resultValue.nextToken());
                    String type=resultValue.nextToken();
                    if (type.equals(FCSAN_NOMEAN_VALUE))
                        type="&nbsp;&nbsp;";
                    diskArrayLDInfo.setType(type);

                    diskArrayLDInfo.setName(resultValue.nextToken());

                    String tempState = resultValue.nextToken();
                    if (tempState.equals(FCSAN_NOMEAN_VALUE)){        //Changed by Yang AH
                        diskArrayLDInfo.setState("&nbsp;&nbsp;");
                    } else if(count==12){
                            //diskArrayLDInfo.setState((String)valueDisplayHash.get(tempState));
                            diskArrayLDInfo.setState(tempState +" "+resultValue.nextToken());
                    } else{
                           diskArrayLDInfo.setState(tempState);
                    }  //Changed by Yang AH

                    diskArrayLDInfo.setRAID(resultValue.nextToken());

                    String capacityByte=resultValue.nextToken();
                    Double capacityDouble=new Double(capacityByte);
                    double capacitydouble=capacityDouble.doubleValue();
                    double capacitydoubleGB=capacitydouble/(1024*1024*1024);

                    //modify by maojb on 10.8 for not doing shishewuru
                    capacitydoubleGB = capacitydoubleGB - 0.05d ;
                    //modify end

                    if(capacitydoubleGB<0.1d)
                        capacitydoubleGB=0.1d;
                    String capacityGB=GetDouble(capacitydoubleGB,1);
                    
                    diskArrayLDInfo.setCapacity(capacityGB);
                
                    String cacheflag = resultValue.nextToken();
                    if (cacheflag.equals("no")) {
                        diskArrayLDInfo.setCacheFlag("&nbsp;&nbsp;");  
                    } else {
                        diskArrayLDInfo.setCacheFlag(cacheflag);
                    }
                    
                    String progression=resultValue.nextToken();
                    if (progression.equals(FCSAN_NOMEAN_VALUE)) {
                        progression="&nbsp;&nbsp;";        //added by Yang AH
                    }     
                    
                    diskArrayLDInfo.setProgression(progression);
                    
                    //iSM2.1_FD_Review_JP No.12  -- Modify by JinKC  (Start)
                    String poolNo = resultValue.nextToken() ;
                    
                    if (pdGroup==null || getPDGByPool(aid, poolNo).equals(pdGroup)) {                    
                        diskArrayLDInfo.setPoolNo(poolNo) ;
                        diskArrayLDInfo.setPoolName(resultValue.nextToken());
                        diskArrayLDInfo.setBasePd(resultValue.nextToken());
    
                        resultOneLine=buf.readLine();
                        StringTokenizer resultOfLdset = new StringTokenizer(resultOneLine);
                        count=resultOfLdset.countTokens();
                        if (count!=1){
                            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/common/invalid_cmd_output"));
                            throw e;
                        }
                        String LdSetName=resultOfLdset.nextToken();
                        if (LdSetName.equals(FCSAN_NOMEAN_VALUE))
                            LdSetName="&nbsp;&nbsp;";    //Added by Yang AH
                         diskArrayLDInfo.setLdSet(LdSetName);
                        LDInfoVec.add(diskArrayLDInfo);
                    } else {
                        resultOneLine=buf.readLine();
                    }
                    //iSM2.1_FD_Review_JP No.12  -- Modify by JinKC  (End)
                    
                }//end if
                resultOneLine=buf.readLine();
            }//end while
            return 0;
        } else {
            return 1;        
        } 
    }
    
}