/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.lvm;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.volume.LVMHandler;
import com.nec.sydney.atom.admin.base.NSExceptionMsg;
import com.nec.sydney.atom.admin.base.NasConstants;
import com.nec.sydney.beans.base.AbstractJSPBean;
import com.nec.sydney.framework.NSMessageDriver;

public class LVMListBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg {
    public static final String cvsid =
            "@(#) $Id: LVMListBean.java,v 1.2313 2008/05/24 12:17:27 liuyq Exp $";

    private Hashtable lvInfoHash;
    private List othersLVInfo;
    private Vector nodes;
    private boolean asCluster;
    private boolean is1Node = false;
    private final String manager = "nsadmin";

    //constructor
    public LVMListBean() {
        lvInfoHash=new Hashtable();
        nodes = new Vector();
        asCluster = false;
    }

    //beanProcess
    public void beanProcess() throws Exception {
        try {
            NSActionUtil.removeSessionAttribute(request, VolumeActionConst.VOLUME_FLAG_EXTEND);
            NSActionUtil.removeSessionAttribute(request, VolumeActionConst.VOLUME_FLAG_SHOWLUN4SYNCFS);
            //get type
            String type=request.getParameter("cluster");
   
            is1Node =NSActionUtil.isOneNodeSirius(request);
            if (type != null && type.equals("true")) {
                asCluster = true;
                nodes.add("0");
                if(!is1Node){
                    nodes.add("1");
                }
            } else{
                nodes.add("");
            }

            Vector lvVec = LVMHandler.getLVList(NSActionUtil.isNsview(request));
            lvInfoHash.put("0", (ArrayList)(lvVec.get(0)));
            lvInfoHash.put("1", (ArrayList)(lvVec.get(1)));
            othersLVInfo = (ArrayList)(lvVec.get(2));
            if(NSActionUtil.isNashead(request)){
                LicenseInfo license = LicenseInfo.getInstance();
                String hasGfsLicense =
                                    license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"gfs") != 0 ? "true" : "false";
                request.setAttribute("hasGfsLicense", hasGfsLicense);
            }
        }catch (NSException e){
            if (e.getErrorCode().startsWith("0x1080006")) {
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/diskarrayErr4List"));
                super.response.sendRedirect(super.response.encodeRedirectURL("LVMError.jsp") 
                                            + "?fromPage=fromList");
                session.setAttribute("diskarrayErrOccured", "true");
                return;
            }else{
                throw e;
            }
        }
        
    }

    //getLVInfo:get the all active Logical Volume's information
    public Hashtable getLVInfo() {
        return lvInfoHash;
    }

    public List getOthersLVInfo() {
        return othersLVInfo;
    }

    public boolean getType() {
        return asCluster;
    }

    public String getManager() {
        return manager;
    }

    public Vector getNodes() {
        return nodes;
    }

    public boolean is1Node(){
        return is1Node;    
    }
}
