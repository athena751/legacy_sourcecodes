/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.snapshot;

import java.util.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.snapshot.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;

public class SnapShowBean extends AbstractJSPBean implements NasConstants
{
    private static final String     cvsid = "@(#) $Id: SnapShowBean.java,v 1.2302 2007/05/30 10:04:36 liy Exp $";
    private String  snapName;
    private SnapSummaryInfo  snapSummaryInfo;
    private String  mountPointName; // The mount point namd for Display
    private String  hexMountPointName;  // The hex format mountPoint name
    
    public SnapShowBean(){
        snapName = "";
        mountPointName = "";
    }
    
    public void beanProcess() throws Exception
    {
        //1. Get mountPoint from the session object
        this.hexMountPointName = (String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
        if (this.hexMountPointName == null){
            //Redirect to mountpoint.jsp;
            String redirectURL = response.encodeRedirectURL(NasConstants.URL_MOUNT_POINT_JSP);
            response.sendRedirect(redirectURL);
        }
        
        String param = (String)session.getAttribute(MP_SESSION_EXPORTROOT); //Get the export root from session
        if ( param != null ){
            this.mountPointName = param;
        }
        
        param = (String)session.getAttribute(MP_SESSION_MOUNTPOINT); //Get the mount point from session
        if ( param != null ){
            this.mountPointName +=param;
        }
        
        String deviceName = SnapSOAPClient.hexMP2DevName(this.hexMountPointName , super.target); //2003/7/14 xinghui maojb
        //get the property for display on the web page:
        snapSummaryInfo = SnapSOAPClient.getSnapList(this.hexMountPointName,deviceName,super.target);

        //2. Get the parameter "act" from the request
        String action = request.getParameter(NasConstants.REQUEST_PARAMETER_ACT);
        //3. If "act" is null, which indicates a browser refresh or the first time the page is loaded,
        if(action != null){
            //5. if act is "CreateSnap", do:
            if(action.equalsIgnoreCase(NasConstants.FORM_ACTION_CREATE_SNAPSHOT)){
                try{
                    snapName = request.getParameter(NasConstants.REQUEST_PARAMETER_SNAP_NAME);
                    //Call SnapSOAPClient.createSnap(super.target,this.snapName,mountPoint)
                    SnapSOAPClient.createSnap(this.snapName,this.hexMountPointName,super.target);
                    super.setMsg(
                        NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
                }catch (NSException e){
                	if(e.getErrorCode()==1){
                		throw e;
                	}else{
                		super.setMsg(SnapshotErrorMsg.getErrorMsg(session,e));
                	}
                }
            }
            //6. if act is "DeleteSnap", do:
            else if(action.equalsIgnoreCase(NasConstants.FORM_ACTION_DELETE_SNAPSHOT)){
                snapName = request.getParameter(NasConstants.REQUEST_PARAMETER_DELETE_SNAP_NAME);
                //Call SnapSOAPClient.deleteSnap(this.snapName,mountPoint,super.target)
                try{
                	SnapSOAPClient.deleteSnap(this.snapName,this.hexMountPointName,super.target);
                //if successful, super.setMsg(snapName +"deleted!")
                	super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
                }
                catch (NSException e){
                	if(e.getErrorCode()==1){
                		throw e;
                	}
                	else{
                		super.setMsg(SnapshotErrorMsg.getErrorMsg(session,e));
                	}
                }
            }
            //response.sendRedirect(response.encodeRedirectURL("snapShow.jsp"));        
            response.sendRedirect(response.encodeRedirectURL(NasConstants.URL_SNAP_SHOW_JSP));        
        }// end of if
        else{
            return ; 
        }
    }
    
    public Vector getSnapList(){
        return snapSummaryInfo.getSnapshotVector();
    }
    
    public int getAvailableNumber(){
        return snapSummaryInfo.getSnapAvailableNumber();
    }
    
    public String getMountPointListURL(){
        //return response.encodeRedirectURL("../common/mountpoint.jsp?"+MP_NEXT_ACTION_PARAM+"=Snapshot"+"&action=selected");
        return response.encodeRedirectURL("../common/mountpoint.jsp?"+MP_NEXT_ACTION_PARAM+"=Snapshot");
    }
    
    public String getSnapScheduleURL(){
        return response.encodeRedirectURL("snapSchedule.jsp");
    }
    
    public String getMountPointName(){
        return this.mountPointName;
    }
}
