/*
 *      Copyright (c) 2005-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.statis.MonitorConfig;
import com.nec.nsgui.model.biz.statis.MonitorConfig2;
import com.nec.nsgui.model.biz.statis.MonitorConfigBase;
import com.nec.nsgui.model.biz.statis.WatchItemDef;
import com.nec.nsgui.model.entity.statis.YInfoBean;

/**
 * @author Administrator
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ChangeMaxAction extends DispatchAction implements StatisActionConst{
    public static final String cvsid 
            = "@(#) $Id: ChangeMaxAction.java,v 1.4 2006/03/03 05:03:40 pangqr Exp $";
    public ActionForward changeMax(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        DynaActionForm dForm = (DynaActionForm) form;
        String isDetail = (String) dForm.get("isDetail");
        String targetId = (String) dForm.get("targetId");
        String watchItem = (String) dForm.get("watchItem");
        YInfoBean yInfoBean = (YInfoBean) dForm.get("yInfoBean");
        String session_y = "statis_" + watchItem + targetId;
        request.getSession().setAttribute(session_y, yInfoBean);
        if (isDetail.trim().equals("0")) {
            return mapping.findForward("displayRRDGraph");
        } else {
            return mapping.findForward("displayDeatilRRDGraph");
        }
    }
    public ActionForward displayMax(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        DynaActionForm dForm = (DynaActionForm) form;
        String targetId = (String) dForm.get("targetId");
        String watchItem = (String) dForm.get("watchItem");
        String session_y = "statis_" + watchItem + targetId;
        YInfoBean yInfoBean = (YInfoBean) request.getSession().getAttribute(
                session_y);
        if (yInfoBean == null) {
            yInfoBean = new YInfoBean();
        }
        MonitorConfigBase mc;
        String isInvestGraph =(String) NSActionUtil.getSessionAttribute(request, SESSION_IS_INVESTGRAPH);
        if(isInvestGraph.equals("1")){
            mc =(MonitorConfig2)NSActionUtil.getSessionAttribute(request, SESSION_MC_4SURVEY); 
        }else{
            mc =(MonitorConfig)NSActionUtil.getSessionAttribute(request, SESSION_MC);
        }
        String watchItemId=(String)NSActionUtil.getSessionAttribute(request, SESSION_WATCHITEM_ID);
        WatchItemDef wid = mc.getWatchItemDef(watchItemId);
        String maxDefined = wid.getMax();
        String minDefined = wid.getMin();           
        request.setAttribute("maxDefined", maxDefined);
        request.setAttribute("minDefined", minDefined);
        String unit_type;
        String isSpecial;
        if (watchItemId.trim().equals(WatchItemDef.CPU_States)
                || watchItemId.trim().equals(WatchItemDef.Disk_Used_Rate)
                || watchItemId.trim().equals(WatchItemDef.Inode_Used_Rate)) {
            isSpecial="1";
            unit_type="percentage";
        }else if(watchItemId.trim().equals(WatchItemDef.Disk_Used_Quantity)){
            isSpecial="0";
            unit_type="quantity_1024";
        }else if(watchItemId.trim().equals(WatchItemDef.Inode_Used_Quantity)){
            isSpecial="0";
            unit_type="quantity_1000";
        }else{
            isSpecial="0";
            unit_type="quantity_1000_decimal";
        }
        request.setAttribute("isSpecial",isSpecial);
        request.setAttribute("unit_type",unit_type);
        dForm.set("yInfoBean", yInfoBean);
        return mapping.findForward("viewMaxPage");

    }

}