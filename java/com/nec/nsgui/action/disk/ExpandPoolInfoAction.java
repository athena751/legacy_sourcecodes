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

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.model.entity.disk.PoolInfoBean;
import com.nec.nsgui.model.biz.disk.DiskHandler;
import com.nec.nsgui.action.disk.DiskCommon;
import com.nec.nsgui.model.entity.disk.DiskConstant;

/** 
 * @struts:action-forward name="/nas/disk/poolexpandinfo.jsp" "
 */
public class ExpandPoolInfoAction extends Action implements DiskConstant{
    public static final String cvsid = "@(#) $Id: ExpandPoolInfoAction.java,v 1.1 2006/01/06 00:36:51 liq Exp $";
    
    
    public ActionForward execute(ActionMapping mapping,
                               ActionForm form,
                               HttpServletRequest request,
                               HttpServletResponse response)throws Exception {
        DynaActionForm dynaForm = (DynaActionForm) form;
        PoolInfoBean poolInfo = (PoolInfoBean) dynaForm.get("poolinfo");
        String arrayname = (String)(dynaForm.get("diskarrayname"));
        String pdgn = (String)(dynaForm.get("pdgroupnumber"));
        String from = (String)(dynaForm.get("from"));
        Vector notUsePDList = DiskCommon.getVectorforPDList(poolInfo.getNotusedpd());
        Vector usePDList = DiskCommon.getVectorforPDList(poolInfo.getUsedpd());
        request.setAttribute("notusepdlist",notUsePDList);
        request.setAttribute("usepdlist",usePDList);
        String ExactCapacity = DiskHandler.expandPoolinfo(poolInfo,arrayname,pdgn);
        request.setAttribute("exactcapacity",ExactCapacity);
        return mapping.findForward("showinfo");
    }
}
