/*
 *      Copyright (c) 2001-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans. fcsan.componentdisp;
import java.util.*;
import java.io.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.beans.fcsan.common.*;
public class DiskArrayPDListBean extends FcsanAbstractBean implements FCSANConstants 
{

    private static final String     cvsid = "@(#) $Id: DiskArrayPDListBean.java,v 1.2305 2006/01/06 06:58:38 wangli Exp $";


    private List PDInfoList;
    private boolean success;
    public DiskArrayPDListBean()
    {
        success=true;
    }
    public List getPDInfo()
    {
        return PDInfoList;
    }
    public boolean getSuccess()
    {
        return success;
    }

    public void beanProcess() throws Exception
    {
        String diskarrayid=request.getParameter("id");
        if (diskarrayid==null||diskarrayid.equals(""))
        {
            NSException ex=new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw ex;
        }
        String cmd=CMD_DISKLIST_P+" "+diskarrayid;
        BufferedReader readbuf = execCmd(cmd);
        if (readbuf==null)
        {
            success=false;
            return;
        }
    
        PDInfoList=new ArrayList();
        String line=readbuf.readLine();
        while (!line.startsWith(SEPARATED_LINE)) {
            line=readbuf.readLine();
        }
        line=readbuf.readLine();
        while (line!=null) {
            StringTokenizer st=new StringTokenizer(line);
            int number=st.countTokens();
            if (number==9||number==10)
            {
                DiskArrayPDInfo pd=new DiskArrayPDInfo();
                pd.setPdNo(st.nextToken());
                String state=st.nextToken();
//                if(FCSAN_STATE_POWERING_UP.indexOf(state)!=-1)
                /* for "powering up" */
                if(number == 10) {
                    pd.setState(state+" "+st.nextToken());//caoyh 4.15
                } else {
                    pd.setState(state);//caoyh 4.15
                }
                pd.setCapacity(st.nextToken());
                pd.setPoolNo(st.nextToken());
                pd.setPoolName(st.nextToken());
                String keyDivision = "fcsan_hashvalue/hashvalue/"+st.nextToken();
                pd.setPdDivision(NSMessageDriver.getInstance().getMessage(session,keyDivision));//caoyh 4.15
                //for [nsgui-necas-sv4:12155] by wangli 2005.12.10
                String progression=st.nextToken();
                if (progression.equals(FCSAN_NOMEAN_VALUE)){
                    progression="&nbsp;&nbsp;";
                } else {
                    progression += "%";
                }
                pd.setProgression(progression);
                st.nextToken();//skip spin
                pd.setType(st.nextToken());
                
                PDInfoList.add(pd);
            }
            line=readbuf.readLine();
        }//end while    
    }
}