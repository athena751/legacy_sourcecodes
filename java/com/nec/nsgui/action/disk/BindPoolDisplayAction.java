/*
 *      Copyright (c) 2005-2007 NEC Corporation
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

/** 
 * @struts:action-forward name="/nas/disk/poolbind.jsp" path="/nas/volume/poolbind.jsp"
 */
public class BindPoolDisplayAction extends Action{
    public static final String cvsid = "@(#) $Id: BindPoolDisplayAction.java,v 1.6 2007/09/07 08:06:38 liq Exp $";
    
    
    public ActionForward execute(ActionMapping mapping,
                               ActionForm form,
                               HttpServletRequest request,
                               HttpServletResponse response)throws Exception {
        DynaActionForm dynaForm = (DynaActionForm) form;
        String arrayid = request.getParameter("diskarrayid");
        String pdgnum = request.getParameter("pdgroupnumber");
        PoolInfoBean poolinfo = (PoolInfoBean)(dynaForm.get("poolinfo"));
        String newPoolNumber = DiskHandler.getPoolNumber(arrayid);
        String pdinfo = DiskHandler.getUnUsedPD(arrayid,pdgnum); //xxh-yyh,cccc\nxxh-yyh,cccc
        Vector notUsePDList = DiskCommon.getVectorforPDList(pdinfo);
        poolinfo.setPoolname("Pool"+newPoolNumber);
        poolinfo.setPoolnum(newPoolNumber);
        if (DiskCommon.isSSeries(request)){//first load the page and is callisto
            poolinfo.setRbtime("0");
        }
        request.setAttribute("notusepdlist",notUsePDList);
        request.setAttribute("usepdlist",new Vector());
        request.setAttribute("pdq",Integer.toString(notUsePDList.size())); 
        return mapping.findForward("display"); 
    }
}
