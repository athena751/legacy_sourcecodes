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
import com.nec.sydney.framework.*;

public class LdDetailBean extends FcsanAbstractBean implements FCSANConstants{

    private static final String     cvsid = "@(#) $Id: LdDetailBean.java,v 1.2304 2005/12/16 06:44:14 wangli Exp $";


    //Member variable
    private DiskArrayLDInfo diskArrayLDInfo;
    private Vector PDVec;
    private Vector portVec;
    private Vector LDSetVec;
    private boolean success;

    //Member methods
    public LdDetailBean()
    {
        diskArrayLDInfo = new DiskArrayLDInfo();
        PDVec = new Vector();
        portVec = new Vector();
        LDSetVec = new Vector();
        success=true;
    } 

    public void beanProcess() throws Exception
    {
        String diskArrayID = request.getParameter("diskArrayID");
        String ldID = request.getParameter("ldID");

        if (diskArrayID==null || ldID==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }
        int returnValue=getLDBasicInfo(diskArrayID,ldID);
        if (returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        }
        returnValue=getLDBuildInfo(diskArrayID,ldID);
        if (returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        }
        returnValue=getLDPortInfo(diskArrayID,ldID);
        if (returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        }
        returnValue=getLDLDSetInfo(diskArrayID,ldID);
        if (returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        }
    }

    public DiskArrayLDInfo getDiskArrayLDInfo()
    {
        return diskArrayLDInfo;
    }

    public Vector getPDVec()
    {
        return PDVec;
    }
    
    public Vector getPortVec()
    {
        return portVec;
    }

    public Vector getLDSetVec()
    {
        return LDSetVec;
    }

    public boolean getSuccess()
    {
        return success;
    }

    private int getLDBasicInfo(String diskArrayID,String ldID) throws Exception
    {
        String cmd = CMD_DISKLIST_LS+" "+diskArrayID+" "+"-nld"+" "+ldID;
        BufferedReader buf=execCmd(cmd);
        if(buf!=null)
        {
            String resultOneLine;        
            while ((resultOneLine=buf.readLine())!=null)
            {
                if (resultOneLine.startsWith(SEPARATED_LINE))
                    break;
            }
            resultOneLine=buf.readLine();
            if(resultOneLine!=null&&resultOneLine.startsWith(DISKLIST_CMD_NAME)) {
            	setErrorCode(71);
            	specialErrMsgHash.put(new Integer(71)    ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_disk_err_popup"));
            	return 1;
            }
            while (resultOneLine!=null)
            {
                StringTokenizer resultValue = new StringTokenizer(resultOneLine);
                int count=resultValue.countTokens();
                if(count!=2)
                {
                    if (count!=14 && count!=15)
                    {
                        NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/common/invalid_cmd_output"));
                        throw e;
                    }
                    diskArrayLDInfo.setLdNo(resultValue.nextToken());
                    String type=resultValue.nextToken();
                    if (type.equals(FCSAN_NOMEAN_VALUE))
                        type="&nbsp;&nbsp;" ;        //added by Yang AH    
                    diskArrayLDInfo.setType(type);
                    diskArrayLDInfo.setName(resultValue.nextToken());

                    String tempState = resultValue.nextToken();                
                    //the variable flag(true):the state has space , 
                    //flag(false):the state has no space.
                    if (tempState.equals(FCSAN_NOMEAN_VALUE))
                        diskArrayLDInfo.setState("&nbsp;&nbsp;");
                    else if(count==15){
                        diskArrayLDInfo.setState(tempState + " " + resultValue.nextToken());
                    } else{
                            //diskArrayLDInfo.setState((String)valueDisplayHash.get(tempState));
                            diskArrayLDInfo.setState(tempState);
                    }
                                    
                    diskArrayLDInfo.setRAID(resultValue.nextToken());
//                    diskArrayLDInfo.setCapacity(super.GetDouble(resultValue.nextToken(),0)+ " " +"byte");
                    diskArrayLDInfo.setCapacity(super.GetDouble(resultValue.nextToken(),0)
                                + " " +NSMessageDriver.getInstance().getMessage(session,"fcsan_common/label/unit_bytes"));
                    String cacheflag = resultValue.nextToken();
                    if (cacheflag.equals("no")) {
                        diskArrayLDInfo.setCacheFlag("&nbsp;&nbsp;");   
                    } else {
                        diskArrayLDInfo.setCacheFlag(cacheflag);
                    }

                    String progression=resultValue.nextToken();
                    if (progression.equals(FCSAN_NOMEAN_VALUE)) {
                        progression="&nbsp;&nbsp;";  //Added by Yang AH
                    } else {
                        progression = progression + "%";
                    }

                    diskArrayLDInfo.setProgression(progression);
            
                    String currentOwner=resultValue.nextToken();
                    String defaultOwner=resultValue.nextToken();
            
                    if (currentOwner.equals(FCSAN_CURRENT_OWNER_CONTROLLER0) 
                        || currentOwner.equals(FCSAN_CURRENT_OWNER_CONTROLLER1))
                    {
                        //diskArrayLDInfo.setCurrentOwner((String)valueDisplayHash.get(currentOwner));
                        String keyCurrentOwner = "fcsan_hashvalue/hashvalue/"+currentOwner;
                        diskArrayLDInfo.setCurrentOwner(NSMessageDriver.getInstance().getMessage(session,keyCurrentOwner));
                        //Modify on 4.15 by maojb
                    } else {
                        diskArrayLDInfo.setCurrentOwner(currentOwner);
                    }
                    if (defaultOwner.equals(FCSAN_CURRENT_OWNER_CONTROLLER1) 
                        || defaultOwner.equals(FCSAN_CURRENT_OWNER_CONTROLLER0))
                    {
                        //diskArrayLDInfo.setDefaultOwner((String)valueDisplayHash.get(defaultOwner));
                        String keyDefaultOwner = "fcsan_hashvalue/hashvalue/"+defaultOwner;
                        diskArrayLDInfo.setDefaultOwner(NSMessageDriver.getInstance().getMessage(session,keyDefaultOwner));
                    } else {
                        diskArrayLDInfo.setDefaultOwner(defaultOwner);
                    }

                    diskArrayLDInfo.setPoolNo(resultValue.nextToken());
                    diskArrayLDInfo.setPoolName(resultValue.nextToken());
                    diskArrayLDInfo.setBasePd(resultValue.nextToken());
                    diskArrayLDInfo.setLUN(resultValue.nextToken());
                }
                resultOneLine=buf.readLine();
            }//end while
            return 0;
        }  else {
            return 1;
        }
    }
    
    private int getLDBuildInfo(String diskArrayID,String ldID) throws Exception
    {
        String cmd = CMD_DISKLIST_LP+" "+diskArrayID+" "+"-nld"+" "+ldID;
        BufferedReader buf=execCmd(cmd);
        if(buf!=null)
        {
            String resultOneLine;
                
            while ((resultOneLine=buf.readLine())!=null)
            {
                if (resultOneLine.startsWith(SEPARATED_LINE))
                    break;
            }
                
            resultOneLine=buf.readLine();
                
            while (resultOneLine!=null)
            {
                StringTokenizer resultValue = new StringTokenizer(resultOneLine);
                DiskArrayPDInfo diskArrayPDInfo =new DiskArrayPDInfo();
                int counts=resultValue.countTokens();
                if (counts!=2)
                {
                    diskArrayPDInfo.setPdNo(resultValue.nextToken());
                    if(counts==9)
                    {
                        //diskArrayPDInfo.setState((String)valueDisplayHash.get(resultValue.nextToken()));
                        diskArrayPDInfo.setState(resultValue.nextToken());
                    } else {
                        diskArrayPDInfo.setState(resultValue.nextToken() + " " + resultValue.nextToken());
                    //Modify on 4.15 by maojb
                    }
                
                    diskArrayPDInfo.setCapacity(resultValue.nextToken());

                    diskArrayPDInfo.setPoolNo(resultValue.nextToken());
                    diskArrayPDInfo.setPoolName(resultValue.nextToken());
                    //diskArrayPDInfo.setPdDivision((String)valueDisplayHash.get(resultValue.nextToken()));
                    String keyPdDivision="fcsan_hashvalue/hashvalue/"+resultValue.nextToken();
                    diskArrayPDInfo.setPdDivision(NSMessageDriver.getInstance().getMessage(session,keyPdDivision));
                    
                    //for [nsgui-necas-sv4:12155] by wangli 2005.12.10
                    String progression=resultValue.nextToken();
                    if (progression.equals(FCSAN_NOMEAN_VALUE)){
                        progression="&nbsp;&nbsp;";
                    } else {
                        progression += "%";
                    }
                    diskArrayPDInfo.setProgression(progression);
                    resultValue.nextToken();//skip spin
                    diskArrayPDInfo.setType(resultValue.nextToken());
                    
                    //Modify on 4.15 by maojb
                    PDVec.add(diskArrayPDInfo);
                }
                resultOneLine=buf.readLine();
            }//end while
            return 0;
        } else {
            return 1;
        }
    }

    private int getLDPortInfo(String diskArrayID,String ldID) throws Exception
    {
        String cmd = CMD_DISKLIST_LAP+" "+diskArrayID+" "+"-nld"+" "+ldID;
        BufferedReader buf=execCmd(cmd);
        if(buf!=null){
            String resultOneLine;
            while ((resultOneLine=buf.readLine())!=null)
            {
                if (resultOneLine.startsWith(SEPARATED_LINE))
                    break;
            }
                
            resultOneLine=buf.readLine();
                
            while (resultOneLine!=null)
            {
                StringTokenizer resultValue = new StringTokenizer(resultOneLine);
                int wordCount=resultValue.countTokens();
                //if(wordCount!=2)
                if(wordCount == 5)
                {
                    DiskArrayPortInfo diskArrayPortInfo =new DiskArrayPortInfo();
                    
                    diskArrayPortInfo.setPortNo(resultValue.nextToken());
                    diskArrayPortInfo.setName(resultValue.nextToken());
                    resultValue.nextToken();
                    diskArrayPortInfo.setState(resultValue.nextToken());
                    //Modify on 4.15 by maojb
                    portVec.add(diskArrayPortInfo);
                }
                resultOneLine=buf.readLine();
            }//end while
            return 0;
        } else {
            return 1;
        }
    }

    private int getLDLDSetInfo (String diskArrayID,String ldID) throws Exception
    {
        String cmd = CMD_DISKLIST_LAL+" "+diskArrayID+" "+"-nld"+" "+ldID;
        BufferedReader buf=execCmd(cmd);
        if(buf!=null)
        {
            String resultOneLine;
                
            while ((resultOneLine=buf.readLine())!=null)
            {
                if (resultOneLine.startsWith(SEPARATED_LINE))
                    break;
            }
                
            resultOneLine=buf.readLine();
                
            while (resultOneLine!=null)
            {
                StringTokenizer resultValue = new StringTokenizer(resultOneLine);
                int wordCount=resultValue.countTokens();
                if (wordCount!=2)
                {
                    if (wordCount!=5)
                    {
                        NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/common/invalid_cmd_output"));
                        throw e;
                    }
                    DiskArrayLDSetInfo diskArrayLDSetInfo =new DiskArrayLDSetInfo();
                
                    resultValue.nextToken();
                    diskArrayLDSetInfo.setType(resultValue.nextToken());
                    diskArrayLDSetInfo.setName(resultValue.nextToken());
                    resultValue.nextToken();
                    diskArrayLDSetInfo.setPathInfo(resultValue.nextToken());
            
                    LDSetVec.add(diskArrayLDSetInfo);
                }
                resultOneLine=buf.readLine();
            }//end while
            return 0;
        }else{
            return 1;
        }
    }
}