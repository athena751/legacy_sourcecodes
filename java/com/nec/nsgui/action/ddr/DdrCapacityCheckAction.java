/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.ddr;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.entity.ddr.DdrVolInfoBean;

public class DdrCapacityCheckAction extends Action {
    private static final String cvsid = "@(#) $Id: DdrCapacityCheckAction.java,v 1.1 2008/04/30 09:00:29 xingyh Exp $";
    
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // get the node of current condition.
        int currentNodeNo = NSActionUtil.getCurrentNodeNo(request);
        DynaActionForm inputForm = (DynaActionForm) form;
        DdrVolInfoBean  mvInfo = (DdrVolInfoBean) inputForm.get("mvInfo");
        
        DdrVolInfoBean [] rvsInfo  = {
                                  (DdrVolInfoBean) inputForm.get("rv0Info"),
                                  (DdrVolInfoBean) inputForm.get("rv1Info"),
                                  (DdrVolInfoBean) inputForm.get("rv2Info")
                                   };
        DdrHandler.check4Create(mvInfo, rvsInfo, currentNodeNo);
        
        return mapping.findForward("success");
    }
    
}
