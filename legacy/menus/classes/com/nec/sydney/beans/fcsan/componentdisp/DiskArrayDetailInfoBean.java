/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.componentdisp;
import java.util.*;
import java.io.*;
import com.nec.sydney.beans.fcsan.common.*;
import com.nec.sydney.framework.*;

public class DiskArrayDetailInfoBean extends FcsanAbstractBean implements FCSANConstants{

    private static final String     cvsid = "@(#) $Id: DiskArrayDetailInfoBean.java,v 1.2302 2005/09/21 05:00:39 wangli Exp $";


    //Member variable
    private DiskArrayInfo diskArrayInfo;
    private Vector portVec;
    private Vector LDSetVec;
    private boolean success;

    //Member method
    //Construct function
    public DiskArrayDetailInfoBean()
    {
        diskArrayInfo=new DiskArrayInfo();
        portVec=new Vector();
        LDSetVec=new Vector();
        success=true;
    }
    //Execute all command
    public void beanProcess() throws Exception
    {
        String diskArrayID=request.getParameter("diskArrayID"); 
        
        int returnValue=diskArrayBasicInfo(diskArrayID);
        if (returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        } else if(diskArrayInfo.getObservation()!=null && 
        	  diskArrayInfo.getObservation().equals(NSMessageDriver.getInstance()
        	               .getMessage(session,"fcsan_hashvalue/hashvalue/"
        	                            +FCSAN_STATE_NO_MONITORING))) {
            return;	
        }

        returnValue=diskArrayPortInfo(diskArrayID);
        if (returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        }

        returnValue=diskArrayBuildInfo(diskArrayID);
        if (returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        }
        
        returnValue=diskArrayLDSetInfo(diskArrayID);
        if (returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        }

        returnValue=diskArrayProductInfo(diskArrayID);
        if (returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        }
    }

    public DiskArrayInfo getDiskArrayInfo()
    {
        return diskArrayInfo;
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
    
    //Execute the command iSAdisklist -ds -aid diskArrayID
    private int diskArrayBasicInfo(String diskArrayID) throws Exception
    {
        if (diskArrayID==null) {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }

        String cmd = CMD_DISKLIST_DS+" "+diskArrayID;
        BufferedReader buf=execCmd(cmd);
    
        if(buf!=null)
        {
            //String result[]=new String[15];
            //String result[]=new String[17];
            // Modify by maojb on 4.22
            String result[] = new String[19];
            //Modify by maojb on 5.22
            String resultOneLine=buf.readLine();
            int count=0;
            if (resultOneLine != null && resultOneLine.trim().endsWith(":")) {
            	setErrorCode(71);
            	specialErrMsgHash.put(new Integer(71), NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_disk_err_popup"));
            	return 1;
            }
            while (resultOneLine!=null)
            {
                StringTokenizer resultValue = new StringTokenizer(resultOneLine.trim(),":");
                int words=resultValue.countTokens();
                if (words==2)
                {
                    resultValue.nextToken();
                    result[count++]=resultValue.nextToken();
                }
                resultOneLine=buf.readLine();
            }//end while
            count=0;
            diskArrayInfo.setID(result[count++]);
            diskArrayInfo.setName(result[count++]);
            diskArrayInfo.setType(result[count++]);
//Modify on 4.15
            //diskArrayInfo.setState((String)valueDisplayHash.get(result[count++]));
            diskArrayInfo.setState(result[count++]);
            //diskArrayInfo.setObservation((String)valueDisplayHash.get(result[count++]));
            String keyObservation = "fcsan_hashvalue/hashvalue/"+result[count++];
            diskArrayInfo.setObservation(NSMessageDriver.getInstance().getMessage(session,keyObservation));            
//Modify End        

            diskArrayInfo.setSAA(result[count++]);
            diskArrayInfo.setProductID(result[count++]);
            diskArrayInfo.setProductRev(result[count++]);
            diskArrayInfo.setSerialNo(result[count++]);
            
            String tempCapValue=result[count++];
            
            //if observation is no_monitoring, set"-",else set capacity
            if(diskArrayInfo.getObservation()!=null
               &&!diskArrayInfo.getObservation()
                               .equals(NSMessageDriver.getInstance()
                               .getMessage(session,"fcsan_hashvalue/hashvalue/"
        	                                +FCSAN_STATE_NO_MONITORING))) {
                Integer capValue=new Integer(tempCapValue.trim());
                int capSize=capValue.intValue();
                if (capSize<1024) {
                    tempCapValue=tempCapValue+"GB";
                }else {
                    String displayStrValue=new Float(capSize/1024.0).toString();
                    int InxOfDot=displayStrValue.indexOf(".");
                    if (InxOfDot<displayStrValue.length()-4) {
                        //tempCapValue=displayStrValue.substring(0,displayStrValue.indexOf(".")+4)+"TB";
                        tempCapValue = GetDouble(displayStrValue,3);
                        tempCapValue = tempCapValue + "TB";
                    } else {
                        tempCapValue=displayStrValue+"TB";
                    }
                }
            }                 
            diskArrayInfo.setCapacity(tempCapValue);
            diskArrayInfo.setControlPass1(result[count++]);
            diskArrayInfo.setPathState1(result[count++]);//Add by maojb on 4.22
            diskArrayInfo.setControlPass2(result[count++]);
            diskArrayInfo.setPathState2(result[count++]);//Add by maojb on 4.22
            diskArrayInfo.setCrossCallMode(result[count++]);
            diskArrayInfo.setAssignMode(result[count++]);        
            diskArrayInfo.setAccessControlFlag(result[count++]);
            diskArrayInfo.setUserSystemCode(result[count++]);//Add by maojb on 5.22
            diskArrayInfo.setWWNN(result[count++]);
            
            return 0;
        }//end if
        else
        {
            return 1;        
        }
        
    }

    //Execute the command iSAdisklist -dd -aid diskArrayID
    private int diskArrayBuildInfo(String diskArrayID) throws Exception
    {
        if (diskArrayID==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }
        String cmd = CMD_DISKLIST_DD+" "+diskArrayID;
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
            
            Vector componentTypes=new Vector();
            Vector componentStates=new Vector();
            Vector entryCounts=new Vector();
            
            while (resultOneLine!=null)
            {
                StringTokenizer resultValue = new StringTokenizer(resultOneLine.trim());
                if(resultValue.countTokens()==3)
                {
//Modify on 4.15
                    //String componentType=(String)valueDisplayHash.get(resultValue.nextToken());
                    String keyComponentType = "fcsan_hashvalue/hashvalue/"+resultValue.nextToken(); 
                    String componentType=NSMessageDriver.getInstance().getMessage(session,keyComponentType);

                    //String componentState=(String)valueDisplayHash.get(resultValue.nextToken());
                    String componentState=resultValue.nextToken();

                    String entryCount=resultValue.nextToken();
                    componentTypes.add(componentType);
                    componentStates.add(componentState);
                    entryCounts.add(entryCount);
                }
                resultOneLine=buf.readLine();
            }
            diskArrayInfo.setComponentTypes(componentTypes);
            diskArrayInfo.setComponentStates(componentStates);
            diskArrayInfo.setEntryCounts(entryCounts);
            return 0;
        }//end if
        else
        {
            return 1;        
        }
        
    }

    //Execute the command iSAdisklist -dap -aid diskArrayID
    private int diskArrayPortInfo(String diskArrayID) throws Exception
    {
        if (diskArrayID==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }
        
        String cmd = CMD_DISKLIST_DAP+" "+diskArrayID;
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
                StringTokenizer resultValue = new StringTokenizer(resultOneLine.trim());
                //if (resultValue.countTokens()==4)
                if(resultValue.countTokens()==5)
                {
                    DiskArrayPortInfo diskArrayPortInfo =new DiskArrayPortInfo();
                    diskArrayPortInfo.setPortNo(resultValue.nextToken());
                    diskArrayPortInfo.setName(resultValue.nextToken());
                    diskArrayPortInfo.setMode(resultValue.nextToken());
                    diskArrayPortInfo.setState(resultValue.nextToken());
                    diskArrayPortInfo.setProtocol(resultValue.nextToken());
    
                    portVec.add(diskArrayPortInfo);
                }
                resultOneLine=buf.readLine();
            }
            return 0;
        }//end if
        else
        {
            return 1;
        }
        
    }
//    Execute the command iSAdisklist -dal -aid diskArrayID
    private int diskArrayLDSetInfo(String diskArrayID) throws Exception
    {
        if (diskArrayID==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }
        
        String cmd = CMD_DISKLIST_DAL+" "+diskArrayID;
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
                StringTokenizer resultValue = new StringTokenizer(resultOneLine.trim());
                if (resultValue.countTokens()==5)
                {
                    DiskArrayLDSetInfo diskArrayLDSetInfo =new DiskArrayLDSetInfo();
                    resultValue.nextToken();
                    diskArrayLDSetInfo.setType(resultValue.nextToken());
                    diskArrayLDSetInfo.setName(resultValue.nextToken());
                    resultValue.nextToken();

                    String path=resultValue.nextToken();
                    if (path.equals(FCSAN_NOMEAN_VALUE))
                        diskArrayLDSetInfo.setPathInfo("&nbsp;&nbsp;");
                    else
                        diskArrayLDSetInfo.setPathInfo(path);
                        /*     changed by Yang AH    */

                    LDSetVec.add(diskArrayLDSetInfo);
                }

                resultOneLine=buf.readLine();
            }
            return 0;
        }//end if
        else
        {
            return 1;
        }
        
    }
//    Exectue the command iSAdisklist -dp -aid diskArrayID
    private int diskArrayProductInfo(String diskArrayID) throws Exception
    {
        if (diskArrayID==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }
        String cmd = CMD_DISKLIST_DP+" "+diskArrayID;
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
            Vector productNames=new Vector();
            Vector productStates=new Vector();
            while (resultOneLine!=null)
            {
                StringTokenizer resultValue = new StringTokenizer(resultOneLine.trim());
                StringTokenizer resultValue2 = new StringTokenizer(resultOneLine.trim(),":");
                int tokenCounts = resultValue.countTokens();
                int tokenCounts2 = resultValue2.countTokens();
                    
                if (tokenCounts==2 && tokenCounts2==1)
                {
                    String productOneName=resultValue.nextToken();
                    String productOneState=resultValue.nextToken();
                    productNames.add(productOneName);
        
                    /* changed by Yang AH */
                    if (productOneState.equals(FCSAN_NOMEAN_VALUE))
                        productStates.add("&nbsp;&nbsp;");
                    else
                    {
                        //productStates.add((String)valueDisplayHash.get(productOneState));
                        String keyProductState = "fcsan_hashvalue/hashvalue/"+productOneState;
                        productStates.add(NSMessageDriver.getInstance().getMessage(session,keyProductState));
                    //Modify on 4.15 by maojb
                    }    
                }
                else if (tokenCounts==3 && tokenCounts2==1)
                {
                    String productOneName=resultValue.nextToken();
                    String productOneState=resultValue.nextToken();
                    productOneState+=" ";
                    productOneState+=resultValue.nextToken();
                    productNames.add(productOneName);
                    //productStates.add((String)valueDisplayHash.get(productOneState));
                    String keyProductState = "fcsan_hashvalue/hashvalue/"+productOneState;
                    productStates.add(NSMessageDriver.getInstance().getMessage(session,keyProductState));
                    //Modify on 4.15 by maojb
                }
                else if (tokenCounts==2 && tokenCounts2==3)
                {
                }
                else
                {
                    NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/common/invalid_cmd_output"));
                    throw e;
                }
                    
                resultOneLine=buf.readLine();
            }//end while
            diskArrayInfo.setProductStates(productStates);
            diskArrayInfo.setProductNames(productNames);
            return 0;
        }//end if
        else
        {
            return 1;
        }
    }
}