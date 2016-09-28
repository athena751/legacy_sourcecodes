/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.disk;

import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.disk.PoolInfoBean;
import com.nec.nsgui.model.biz.disk.DiskHandler;
import com.nec.nsgui.action.disk.DiskCommon;

public class BindPoolAction extends Action{
    public static final String cvsid = "@(#) $Id: BindPoolAction.java,v 1.6 2008/04/19 12:17:10 jiangfx Exp $";
    public PoolInfoBean poolinfo = new PoolInfoBean();
    
    public ActionForward execute(ActionMapping mapping,
                               ActionForm form,
                               HttpServletRequest request,
                               HttpServletResponse response)throws Exception {
        DynaActionForm dynaForm = (DynaActionForm) form;
        
        PoolInfoBean poolInfo = (PoolInfoBean) dynaForm.get("poolinfo");
        Vector notUsePDList = DiskCommon.getVectorforPDList(poolInfo.getNotusedpd());
        Vector usePDList = DiskCommon.getVectorforPDList(poolInfo.getUsedpd());
        String arrayname = (String)(dynaForm.get("diskarrayname"));
        String pdgn = (String)(dynaForm.get("pdgroupnumber"));
        String from = (String)(dynaForm.get("from"));
        request.setAttribute("notusepdlist",notUsePDList);
        request.setAttribute("usepdlist",usePDList);
        DiskHandler.bindPool(poolInfo,arrayname,pdgn);
        if (from.equals("volumeCreate")){
            NSActionUtil.setSuccess(request);
            return mapping.findForward("backToCreat");
        }
        if (from.equals("volumeExtend")){
            NSActionUtil.setSuccess(request);
            return mapping.findForward("backToExtend");
        }
        if (from.equals("replication")){
            NSActionUtil.setSuccess(request);
            return mapping.findForward("backToReplication");
        }
        if (from.equals("ddrCreate")){
            NSActionUtil.setSuccess(request);
            return mapping.findForward("backToDdrCreate");
        }
        if (from.equals("ddrExtend")){
            NSActionUtil.setSuccess(request);
            return mapping.findForward("backToDdrExtend");
        }
        return mapping.findForward("setSuccess");
    }
}
