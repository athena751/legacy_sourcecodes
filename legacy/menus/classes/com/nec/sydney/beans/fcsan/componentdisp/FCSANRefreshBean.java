/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.componentdisp;

import com.nec.sydney.framework.*;
import com.nec.sydney.beans.fcsan.common.*;
import java.util.*;
import java.io.*;

/**
*
* Revision History
*
* Nas3373
*
*/

public class FCSANRefreshBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: FCSANRefreshBean.java,v 1.2301 2005/08/29 08:47:12 huj Exp $";


   private String errorMessage;

   //constructor
   public FCSANRefreshBean()
   {
      errorMessage=new String();
   }

   public void beanProcess()
   {}

   //execute command "iSArefreshlist -aid(diskarrayID)
    public int refresh(String diskid) throws Exception
    {
        if(diskid == null || diskid.equals("")){
             NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
             throw ex;
        }
         
        String cmd = CMD_DISKLIST_DS + " " +diskid;
        BufferedReader buf=execCmd(cmd);
    
        if (buf == null)
            return 1;
            
        String observation;

// modify by hujun June, 20        
/*        for (int i = 0;i<4;i++)
            buf.readLine();
        StringTokenizer st = new StringTokenizer(buf.readLine(),":");
        st.nextToken();
        observation = (st.nextToken()).trim();
        if (observation.startsWith(FCSAN_STATE_RUNNING )){  
            cmd = CMD_DISKREFRESH+" "+diskid;
            buf = execCmd(cmd);
            if (buf == null)
                return 1;
        }
        return 0;
       }*/
       String state;
        for (int i = 0;i<3;i++)
            buf.readLine();
        StringTokenizer st = new StringTokenizer(buf.readLine(),":");
        st.nextToken();
        state = (st.nextToken()).trim();
        st = new StringTokenizer(buf.readLine(),":");
        st.nextToken();
        observation = (st.nextToken()).trim();
        
        /* if observation is "running" and state is not "Attn", do refresh*/
        if (observation.startsWith(FCSAN_STATE_RUNNING )
            && (!state.startsWith(FCSAN_STATE_ATTN))){  

            cmd = CMD_DISKREFRESH+" "+diskid;
            buf = execCmd(cmd);
            if (buf == null)
                return 1;
        }
        return 0;
       }
}