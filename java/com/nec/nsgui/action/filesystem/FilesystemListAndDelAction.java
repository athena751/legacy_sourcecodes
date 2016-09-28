/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.filesystem;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;


import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.ddr.DdrActionConst;
import com.nec.nsgui.action.disk.DiskCommon;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.filesystem.FilesystemHandler;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.SortTableModel;
import com.nec.nsgui.model.biz.license.LicenseInfo;

import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.action.volume.VolumeListAction;


/**
 * @author Zhangjx
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class FilesystemListAndDelAction extends DispatchAction implements FilesystemConst{
    public static final String cvsid =
        "@(#) $Id: FilesystemListAndDelAction.java,v 1.13 2008/04/26 08:06:22 pizb Exp $";

    public ActionForward display(ActionMapping mapping,
                               ActionForm form,
                               HttpServletRequest request,
                               HttpServletResponse response)
    throws Exception {      
       boolean isNashead = NSActionUtil.isNashead(request);
       
       
       LicenseInfo license = LicenseInfo.getInstance();
       String hasWpLicense =
           license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"fpfs") != 0 ? "true" : "false";
       NSActionUtil.setSessionAttribute(request, SESSION_WP_LICENSE, hasWpLicense);
       try{
           Vector fsList =
               VolumeHandler.getVolumeList(
                   NSActionUtil.getExportGroupPath(request),
                   isNashead,
                   NSActionUtil.getCurrentNodeNo(request));
                   
           fsList.remove(fsList.size() - 1);
           if(!isNashead){
               DiskCommon.setDiskArrayTypeToSession(request);
           }
           // when nashead machine the diskarray type is all "false";
           boolean isSSeries = DiskCommon.isSSeries(request);
           
           boolean asyncCurrent = false;
           boolean asyncErr = false;
           
           if (fsList != null && fsList.size() > 0) {
               SortTableModel tableMode = new ListSTModel(fsList);
                NSActionUtil.setSessionAttribute(request, SESSION_FS_TABLE_MODE, tableMode);
               if(isSSeries) {
                     for (int i = 0; i < fsList.size(); i++) {
                         VolumeInfoBean volumeInfo = (VolumeInfoBean) fsList.get(i);
                         if (!volumeInfo.getAsyncStatus().equals(VolumeActionConst.SESSION_ASYNC_STATUS_NORMAL)) {
                             asyncCurrent = true;
                             if (!volumeInfo.getErrCode().equals(ASYNC_NO_ERROR)) {
                                 asyncErr = true;
                                 break;
                             }
                         }
                     }
               }            
           }else{
                NSActionUtil.setSessionAttribute(request, SESSION_FS_TABLE_MODE, null);
           }
    
           if(isSSeries) {
               NSActionUtil.setSessionAttribute(request, SESSION_CURRENT_EXPORTGROUP_ASYNC, new Boolean(asyncCurrent));
               NSActionUtil.setSessionAttribute(request, SESSION_ASYNC_ERROR, new Boolean(asyncErr) );
               if(!NSActionUtil.isNsview(request)) {                
                   String[] asyncInfo = VolumeHandler.getAsyncInfo();
                   if ((asyncInfo.length>0) || asyncCurrent || NSActionUtil.hasActiveBatchVolume(request)) {
                       NSActionUtil.setSessionAttribute(request, SESSION_NV_ASYNC, new Boolean(true) );
                   } else {
                       NSActionUtil.setSessionAttribute(request, SESSION_NV_ASYNC, new Boolean(false) );                        
                   }
                   // judge that whether there is any operation of async pair, add by jiangfx, 2008/4/19.
             	   NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_ASYNCPAIR, NSActionUtil.hasAsyncPair(request));
               }
           }
        }catch(NSException e){
            
            VolumeListAction.setISAdiskListErrorCode(e, "82", request);
            throw e;
        }
       return mapping.findForward("forwardToList");
   }    
   
    public ActionForward del(ActionMapping mapping,
                                  ActionForm form,
                                  HttpServletRequest request,
                                  HttpServletResponse response)
    throws Exception { 
        DynaValidatorForm thisForm = (DynaValidatorForm)form;
        String forceFlag = (String)thisForm.get("forceFlag");
        forceFlag = (forceFlag!=null && forceFlag.equals("force"))?forceFlag:"";
        String mp = ((VolumeInfoBean)thisForm.get("fsInfo")).getMountPoint();
        
        NSActionUtil.setSessionAttribute(request, VolumeActionConst.VOLUME_INFO_VOLUME_NAME,
                                         ((VolumeInfoBean)thisForm.get("fsInfo")).getVolumeName()); 
        
        //get mvdsync's licence
        LicenseInfo license=LicenseInfo.getInstance();
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        String licence = ((license.checkAvailable(nodeNo,"mvdsync"))!=0)?"true":"false";
        FilesystemHandler.delFS(mp, licence, forceFlag, nodeNo);
        NSActionUtil.setSessionAttribute(request,NSActionConst.SESSION_SUCCESS_ALERT,"true");
        return mapping.findForward("delSuccess");
    } 
}