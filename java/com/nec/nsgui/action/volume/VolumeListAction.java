/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

import java.util.Vector;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.model.entity.volume.VolumeAvailableNumberBean;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.SortTableModel;
import com.nec.nsgui.action.ddr.DdrActionConst;
import com.nec.nsgui.action.disk.DiskCommon;


/** 
 * VolumeListAction.java created by EasyStruts - XsltGen.
 * http://easystruts.sf.net
 * created on 07-10-2004
 * 
 * XDoclet definition:
 * @struts:action validate="true"
 * @struts:action-forward name="/nas/volume/volumelist.jsp" path="/nas/volume/volumelist.jsp"
 */
public class VolumeListAction extends Action implements VolumeActionConst{
    public static final String cvsid =
        "@(#) $Id: VolumeListAction.java,v 1.18 2008/05/24 12:13:46 liuyq Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        if(!NSActionUtil.isNsview(request)){
            NSActionUtil.removeSessionAttribute(request, VolumeActionConst.VOLUME_FLAG_EXTEND);    
            NSActionUtil.removeSessionAttribute(request, VolumeActionConst.VOLUME_FLAG_SHOWLUN4SYNCFS);
            ServletContext application = request.getSession().getServletContext();
            String statusString = (String)application.getAttribute(APPLICATION_VOLUME_PROCESS);
        
            if(statusString!=null){
                return mapping.findForward("forwardToBatchSet");
            }
            request.getSession().removeAttribute("volumeBatchCreateForm");
        }
        
        LicenseInfo license = LicenseInfo.getInstance();
        String hasWpLicense =
            license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"fpfs") != 0 ? "true" : "false";
        NSActionUtil.setSessionAttribute(request, SESSION_WP_LICENSE, hasWpLicense);
        
        boolean isNashead = NSActionUtil.isNashead(request);
       try{ 
            Vector volumeList =
                VolumeHandler.getVolumeList(
                    NSActionUtil.getExportGroupPath(request),
                    isNashead,
                    NSActionUtil.getCurrentNodeNo(request));
            if(!isNashead){
                DiskCommon.setDiskArrayTypeToSession(request);
            }
            // when nashead machine the diskarray type is all "false";
            boolean isSSeries = DiskCommon.isSSeries(request);
            boolean isCondorSeries = DiskCommon.isCondorLiteSeries(request);           
            if(isCondorSeries){
                NSActionUtil.setSessionAttribute(request, SESSION_DISKIARRAY_CONDORSERIES, "true");
            }
            VolumeAvailableNumberBean availNo = (VolumeAvailableNumberBean)(volumeList.remove(volumeList.size() - 1));

            boolean asyncCurrent = false;
            boolean asyncErr = false; 
            if (volumeList != null && volumeList.size() > 0) {
                SortTableModel tableMode = new ListSTModel(volumeList);
                NSActionUtil.setSessionAttribute(request, SESSION_VOLUME_TABLE_MODE, tableMode );
                if(isSSeries) {
                    for (int i = 0; i < volumeList.size(); i++) {
                        VolumeInfoBean volumeInfo = (VolumeInfoBean) volumeList.get(i);
                        if (!volumeInfo.getAsyncStatus().equals(SESSION_ASYNC_STATUS_NORMAL)) {
                            asyncCurrent = true;
                            if (!volumeInfo.getErrCode().equals(ASYNC_NO_ERROR)) {
                                asyncErr = true;
                                break;
                            }
                        }
                    }
                }
            }else{
                NSActionUtil.setSessionAttribute(request, SESSION_VOLUME_TABLE_MODE, null );
            }
        
            if(!NSActionUtil.isNsview(request)){
                NSActionUtil.setSessionAttribute(request, "ldCount", availNo.getLdCount());
                NSActionUtil.setSessionAttribute(request, "lvCount", availNo.getLvCount());
            }
            if(isSSeries) {
                NSActionUtil.setSessionAttribute(request, SESSION_CURRENT_EXPORTGROUP_ASYNC, new Boolean(asyncCurrent));
                NSActionUtil.setSessionAttribute(request, SESSION_ASYNC_ERROR, new Boolean(asyncErr) );
                if(!NSActionUtil.isNsview(request)) {                
                    String[] asyncInfo = VolumeHandler.getAsyncInfo();
                    if ((asyncInfo.length>0) || asyncCurrent) {
                        NSActionUtil.setSessionAttribute(request, SESSION_NV_ASYNC, new Boolean(true) );
                    } else {
                        NSActionUtil.setSessionAttribute(request, SESSION_NV_ASYNC, new Boolean(false) );                        
                    }
                   //judge that whether there is any operation of async pair, add by jiangfx, 2008/4/19.
             	   NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_ASYNCPAIR, NSActionUtil.hasAsyncPair(request));
                }
            }
      }catch(NSException e){
          setISAdiskListErrorCode(e, "82", request);          
          throw e;
      }
        return mapping.findForward("forwardToList");
    }

    public static void setISAdiskListErrorCode(NSException e, String errCodeSuffix, HttpServletRequest request) throws Exception{
        Boolean hasActiveVolume = NSActionUtil.hasActiveAsyncVolume(request);
        Boolean hasActivePair = NSActionUtil.hasActiveAsyncPair(request);
        
        if(e.getErrorCode().equals("0x10800082") ){
            if(hasActiveVolume){
                e.setErrorCode("0x108100" + errCodeSuffix);
            }else if(hasActivePair){
                e.setErrorCode("0x108200" + errCodeSuffix);
            }else{
                throw e;
            }
            NSActionUtil.setSessionAttribute(request, NSActionConst.SESSION_NOFAILED_ALERT, "true");               
        }
    }
}
