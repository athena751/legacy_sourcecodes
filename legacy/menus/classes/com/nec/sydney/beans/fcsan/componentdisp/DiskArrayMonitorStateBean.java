/*
 *      Copyright (c) 2001 NEC Corporation
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

public class DiskArrayMonitorStateBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: DiskArrayMonitorStateBean.java,v 1.2300 2003/11/24 00:54:48 nsadmin Exp $";


    private String buttonState;
    public DiskArrayMonitorStateBean()
    {
    }

    public void beanProcess(){}

    public String getButtonState()
    {
        return buttonState;
    }
    public int  setButtonState() throws Exception
    {
        String diskArrayID = request.getParameter("diskArrayID");
        String  state= super.getDiskArrayMonState(diskArrayID);
        if (state == null) {
            return -1;
        }else if (state.equals(FCSANConstants.FCSAN_STATE_RUNNING)) {
            return 0;
        }else{
            return 1;
        }
    }        
}