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

public class LdConstituteTypeBean extends FcsanAbstractBean implements FCSANConstants{

    private static final String     cvsid = "@(#) $Id: LdConstituteTypeBean.java,v 1.2301 2005/08/29 08:47:12 huj Exp $";


    //Member variable
    private    Vector LDSetTypeVec;
    private Vector LDSetTypeValueVec;
    private Vector PortTypeVec;
    private Vector PortTypeValueVec;
    private boolean success;

    //Member methods
    //Construct function
    public LdConstituteTypeBean()
    {
        success=true;
    }
//Execute all command 
    public void beanProcess() throws Exception
    {
        String diskArrayID=request.getParameter("diskArrayID");
        
        int returnValue=getLDInfo(diskArrayID);
        if (returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        }
        
        returnValue=getPortInfo(diskArrayID);
        if (returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        }
    }

    public Vector getLDSetTypeVec()
    {
        return LDSetTypeVec;
    }

    public Vector getLDSetTypeValueVec()
    {
        return LDSetTypeValueVec;
    }

    public Vector getPortTypeVec()
    {
        return PortTypeVec;
    }

    public Vector getPortTypeValueVec()
    {
        return PortTypeValueVec;
    }

    public boolean getSuccess()
    {
        return success;
    }
//    Execute the command iSAdisklist -dal -aid diskArrayID
    private int getLDInfo(String diskArrayID) throws Exception
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
            LDSetTypeVec=new Vector();
            LDSetTypeValueVec=new Vector();
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
                String tempType;
                if (resultValue.countTokens()!=2)
                {
                    LDSetTypeValueVec.add(resultValue.nextToken());
                    tempType=resultValue.nextToken()+":"+resultValue.nextToken();
                    LDSetTypeVec.add(tempType);
                }
                resultOneLine=buf.readLine();
            }//end while
            return 0;
        }//end if
        else
        {
            return 1;        
        }
    }
//Execute the command iSAdisklist -dap -aid diskArrayID
    private int getPortInfo(String diskArrayID) throws Exception
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
            PortTypeVec=new Vector();
            PortTypeValueVec=new Vector();

            String resultOneLine;
                
            while ((resultOneLine=buf.readLine())!=null)
            {
                if (resultOneLine.startsWith(SEPARATED_LINE))
                    break;
            }
            resultOneLine=buf.readLine();
            String tempPort;
            while (resultOneLine!=null)
            {
                StringTokenizer resultValue = new StringTokenizer(resultOneLine);
                String tempPortNo;
                String tempWhole;
                if (resultValue.countTokens()!=2)
                {
                    tempPortNo=resultValue.nextToken();
                    tempPort=resultValue.nextToken();
                    PortTypeValueVec.add(tempPortNo);
                    tempWhole=tempPortNo+"("+tempPort+")";
                    PortTypeVec.add(tempWhole);
                }
                
                resultOneLine=buf.readLine();
            }//end while
            return 0;
        }//end if
        else
        {
            return 1;        
        }
    }
}