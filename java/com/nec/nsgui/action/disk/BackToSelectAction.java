/*
 *      Copyright (c) 2006 NEC Corporation
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

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.model.entity.disk.PoolInfoBean;
import com.nec.nsgui.action.disk.DiskCommon;
import com.nec.nsgui.model.entity.disk.DiskConstant;

public class BackToSelectAction extends DispatchAction implements DiskConstant{
    
    private static final String     cvsid = "@(#) $Id: BackToSelectAction.java,v 1.1 2006/01/06 00:36:51 liq Exp $";
    
    public ActionForward backtobind(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {
        DynaActionForm dynaForm = (DynaActionForm) form;
        PoolInfoBean poolInfo = (PoolInfoBean) dynaForm.get("poolinfo");
        Vector notUsePDList = DiskCommon.getVectorforPDList(poolInfo.getNotusedpd());
        Vector usePDList = DiskCommon.getVectorforPDList(poolInfo.getUsedpd());
        request.setAttribute("notusepdlist",notUsePDList);
        request.setAttribute("usepdlist",usePDList);
        return mapping.findForward("backtobind");
    }
    
    
    public ActionForward backtoexpand(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {                          
        DynaActionForm dynaForm = (DynaActionForm) form;
        PoolInfoBean poolInfo = (PoolInfoBean) dynaForm.get("poolinfo");
        Vector notUsePDList = DiskCommon.getVectorforPDList(poolInfo.getNotusedpd());
        Vector usePDList = DiskCommon.getVectorforPDList(poolInfo.getUsedpd());
        request.setAttribute("notusepdlist",notUsePDList);
        request.setAttribute("usepdlist",usePDList);
        request.setAttribute("pdq","1"); 
        Vector oldpd  = (Vector)request.getSession().getAttribute(DiskConstant.SESSION_OLD_POOL_PD);
        request.setAttribute("poolpdnumber",Integer.toString(oldpd.size()));
        return mapping.findForward("backtoexpand");
    }
}