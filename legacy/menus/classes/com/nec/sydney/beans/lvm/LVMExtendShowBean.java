/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.lvm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.action.volume.VolumeAddShowAction;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.NSMessageDriver;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.ddr.DdrHandler;

public class LVMExtendShowBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg {
    public static final String cvsid =
            "@(#) $Id: LVMExtendShowBean.java,v 1.2308 2008/05/24 12:16:55 liuyq Exp $";

    private String lvname;
    private String size;
    private String nickname;
    private String ldList;
    private String lunStorageList;
    private String mountPoint; // add for capacity license, 2007/9/11,jiangfx
    public LVMExtendShowBean() {
        lvname="";
        size="";
        nickname="";
        ldList = "";
        lunStorageList = "";
        mountPoint = "";
    }
    
    public void beanProcess() throws Exception {
        NSActionUtil.setSessionAttribute(request, VolumeActionConst.VOLUME_FLAG_EXTEND, "extend");
        
        String type = request.getParameter("cluster");
        String node = request.getParameter("node");
        String isCluster = request.getParameter("lvtype").equals("cluster")?"true":"false";
        if(node.equals("-1")){
            node = "0";
        }
        boolean is1Node =NSActionUtil.isOneNodeSirius(request);
        if (is1Node){
            node = "0";
        }
        boolean asCluster = false ; 
        if (type != null && type.equals("true")) {
            asCluster = true;
        }
        /// modify by liuyq 
        String radioButton = super.request.getParameter("radioButton");
        String[] strArray = radioButton.split(",");
        lvname = strArray[0];
        mountPoint = strArray[1];
        size = strArray[2];
        
        if(NSActionUtil.isNashead(request)){
            lunStorageList = NSActionUtil.reqStr2EncodeStr(strArray[3], NSActionUtil.ENCODING_EUC_JP);
        }else{
            ldList = strArray[4];
        }
        
        
        try{
            DdrHandler.isPaired(lvname);
        } catch (NSException e){
            if(e.getErrorCode().equals("0x12400095")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/vgpaircheck_failed"));
                super.response.sendRedirect(super.response.encodeRedirectURL("LVMError.jsp") 
                        + "?fromPage=fromExtendShow&cluster=" + isCluster);
                return;
            }else if(e.getErrorCode().equals("0x12400094")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/extend_paired"));
                super.response.sendRedirect(super.response.encodeRedirectURL("LVMError.jsp") 
                        + "?fromPage=fromExtendShow&cluster=" + isCluster);
                return;
            }else{
                throw e;
            }
        }
        
        if(NSActionUtil.isNashead(request)){
            LicenseInfo license = LicenseInfo.getInstance();
            String hasGfsLicense =
                        license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"gfs") != 0 ? "true" : "false";
            request.setAttribute("hasGfsLicense", hasGfsLicense);
        }
        ///add by liuyq end
        VolumeAddShowAction.setLicenseChkSession(request); //add for capacity license

        int nodeNo = Integer.parseInt(node);
        String hasSnapshot= "no";
        String hasReplication = "no";
        if(!mountPoint.equals("--")){
        	hasReplication = VolumeHandler.isSyncFS(mountPoint,nodeNo);        
	        try{
	        	hasSnapshot = VolumeHandler.hasSnapshotSet(mountPoint,nodeNo);
	        } catch (NSException e){
	        	if(e.getErrorCode().equals("0x10800048")){
	        		super.setMsg(NSMessageDriver.getInstance().getMessage(session, 
	                "nas_lvm/alert/snapshotCmdError"));
	        		super.response.sendRedirect(super.response.encodeRedirectURL("LVMError.jsp") 
	                        + "?fromPage=fromExtendShow&cluster=" + isCluster);
	        		return;
	        	}else{
	        		throw e;
	        	}
	        }
        }
        request.setAttribute("hasSnapshot", hasSnapshot);
        request.setAttribute("hasReplication", hasReplication);
        if(hasReplication.equalsIgnoreCase("yes")){
            NSActionUtil.setSessionAttribute(request, VolumeActionConst.VOLUME_FLAG_SHOWLUN4SYNCFS, "extend4syncfs");
        }
    }

    public String getLvname() {
        return lvname;
    }


    public String getMountPoint() {
		return mountPoint;   // "--" or /export/.../...
	}

	public String getSize() {
        return size;
    }

    /**
     * @return
     */
    public String getLdList() {
        return ldList;
    }

    /**
     * @return
     */
    public String getLunStorageList() {
        return lunStorageList;
    }

}
