/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.util.LabelValueBean;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.model.entity.volume.DiskArrayInfoBean;
import com.nec.nsgui.model.entity.volume.VolumeAvailableNumberBean;

/**
 *
 */
public class VolumePoolListAction
    extends DispatchAction
    implements NSActionConst {
    
    public static final String cvsid =
        "@(#) $Id: VolumePoolListAction.java,v 1.2 2005/12/28 06:02:09 wangzf Exp $";
    
    private final static int MAX_LV = 256;

    public ActionForward topDisplay(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
            DynaActionForm thisForm = (DynaActionForm)form;
            String kind = (String) thisForm.get("kind");
            if(kind==null || kind.equals("")) {
                thisForm.set("kind", "max");
            }
            
            List diskArrayInfo = VolumeHandler.getDiskArrayInfo();
            Vector diskArrayList = new Vector();
            DiskArrayInfoBean daib;
            for(int i=0; i<diskArrayInfo.size();i++) {
                daib=(DiskArrayInfoBean)diskArrayInfo.get(i);
                diskArrayList.add(new LabelValueBean(daib.getAname(), daib.getAid()));
            }
            if(diskArrayList.size()==0) {
                diskArrayList.add(new LabelValueBean("--------", ""));
            }
            
            request.setAttribute("diskArrayList", diskArrayList);
            return mapping.findForward("poolListTop");
    }

    public ActionForward midDisplay(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
            DynaActionForm thisForm = (DynaActionForm)form;
            String from = (String)request.getParameter("from");
            if(from != null && from.equals("select")) {
                String[] selected = {};
                thisForm.set("selectOrNot", selected);
            }
            
            Map availLdNo = new TreeMap(); 
            String diskArray = "";
            String raidType = "";
            if(thisForm == null
               || thisForm.get("diskArray")==null
               || thisForm.get("raidType")==null){
                   diskArray = "";
                   raidType = "";
            } else {
                diskArray = (String) thisForm.get("diskArray");
                raidType = (String) thisForm.get("raidType");
            }

            if(diskArray.equals("")) {
                availLdNo = VolumeHandler.getLdNum4Create();         
            } else {
                availLdNo.put(diskArray, VolumeHandler.getLdNum4Create(diskArray)) ;                
            }
            VolumeAvailableNumberBean availNo = VolumeHandler.getVolumeAvailableNumber();
            String availLvNo = Integer.toString(MAX_LV - Integer.valueOf(availNo.getLvCount()).intValue());
            
            List pools = VolumeHandler.getPoolInfo(diskArray, raidType);
            if(pools.size()==0){
                request.setAttribute("volume_error", "error.no.pool.exist");
            }
            request.setAttribute("allAvailablePool", pools);
            request.setAttribute("lvNo", availLvNo);
            request.setAttribute("availLdNo", availLdNo);
            return mapping.findForward("poolListMid");
    }

    public ActionForward bottomDisplay(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response){
                return mapping.findForward("poolListBottom");    
            }
}
