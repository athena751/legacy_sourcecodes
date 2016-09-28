/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume; 

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.SortTableModel;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.model.entity.volume.LunInfoBean;


public class LunSelectAction extends  Action {
    private static final String cvsid = "@(#) $Id: LunSelectAction.java,v 1.4 2008/05/24 12:11:17 liuyq Exp $";
    
    public ActionForward execute(ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response) 
        throws Exception {
        // get lun info and set it to session
        String dowhat  = (String)request.getSession().getAttribute(VolumeActionConst.VOLUME_FLAG_EXTEND);
        String forSyncfs  = (String)request.getSession().getAttribute(VolumeActionConst.VOLUME_FLAG_SHOWLUN4SYNCFS);
        String usage = VolumeActionConst.CONST_DISPLAYMVLUN;
        if (forSyncfs==null || forSyncfs.equalsIgnoreCase("")){
        }else{
            //extend4syncfs or create4syncfs
            usage = VolumeActionConst.CONST_NOTDISPLAYMVLUN;
        }
        Vector tmplunVector = VolumeHandler.getAvailLunInfo(usage);
        Vector lunVector = new Vector();
        
        if (dowhat==null || dowhat.equals("")){
            lunVector = tmplunVector;
        }else{
            for(int i =0;i<tmplunVector.size();i++){
                LunInfoBean onelun = (LunInfoBean)tmplunVector.get(i);
                float lunsize = Float.parseFloat(onelun.getSize());
                if (lunsize>=0.2){
                   lunVector.add(onelun);
                }
            }
        }
        if ((lunVector != null) && (lunVector.size() > 0)) {
            SortTableModel lunTableMode = new ListSTModel(lunVector); 
            NSActionUtil.setSessionAttribute(request, "lunInfoTable", lunTableMode);
        } else {
            NSActionUtil.setSessionAttribute(request, "lunInfoTable", null);
        } 
        
        return mapping.findForward("showLunInfo");         
    }
}