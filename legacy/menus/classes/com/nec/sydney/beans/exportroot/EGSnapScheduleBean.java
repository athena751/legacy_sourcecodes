/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.sydney.beans.exportroot;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.snapshot.*;
import com.nec.sydney.atom.admin.exportroot.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.beans.snapshot.*;
import com.nec.sydney.beans.mapdcommon.*;
import java.util.*; 

/****************************************************************

* this program is designed for the ExportGroup to display snapshot*     

* schedule infomation.                                  *

*******************************************************************/
public class EGSnapScheduleBean extends TemplateBean implements EGConstants
{
    private static final String     cvsid = "@(#) $Id: EGSnapScheduleBean.java,v 1.2300 2003/11/24 00:54:46 nsadmin Exp $";
    
    private SnapSummaryInfo snapScheduleInfo;
    
    public void onDisplay() throws Exception{
        String hexMountPoint;
        String deviceName;        
        
        hexMountPoint = request.getParameter(MP_SELECT_HEX_MOUNTPOINT_NAME);
        String groupNo = (String)session.getAttribute("group");
        deviceName = ExportRootSOAPClient.hexMP2DevName(hexMountPoint , super.target ,groupNo);
        
        snapScheduleInfo  = ExportRootSOAPClient.getSnapSchedule(hexMountPoint,
                                                           deviceName,
                                                           SNAPSHOT,
                                                           super.target,
                                                           groupNo);
    }
    
    public Vector getSchedule(){
        return snapScheduleInfo.getSnapshotVector();  
    }
    
    public String getMountPoint(){
        String mountPointName = (String)request.getParameter(MP_SELECT_MOUNTPOINT_NAME);
        return mountPointName;
    }
}