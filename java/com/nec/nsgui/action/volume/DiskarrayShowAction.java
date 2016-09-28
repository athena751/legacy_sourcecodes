/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

import java.util.List;
import java.util.TreeMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.LabelValueBean;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.volume.DiskArrayInfoBean;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.action.disk.DiskCommon;

public class DiskarrayShowAction extends Action {
    public static final String cvsid =
        "@(#) $Id: DiskarrayShowAction.java,v 1.11 2008/05/21 09:28:30 liuyq Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        String aid = (String) ((DynaValidatorForm) form).get("aid");       
        String raidType = (String) ((DynaValidatorForm) form).get("raidType");
        String poolnameno = request.getParameter("poolinfonameno");
        if (poolnameno==null){
            poolnameno="";
        }

        String unusablePoolNo = "--";
        //flag : notFromDisk
        String flag = request.getParameter("flag");
        if ((flag != null) && (flag.equals("notFromDisk"))) {
            request.getSession().setAttribute("aid", aid);
            request.getSession().setAttribute("raidType", raidType);
            request.getSession().setAttribute("poolnameno", poolnameno);

            //from is module name, set from to session
            String from = request.getParameter("from");
            if (from.startsWith("ddr")) {
                NSActionUtil.setSessionAttribute(request, "module4ErrPage", "ddr");
            	unusablePoolNo = request.getParameter("unusablePoolNo");
            }
            request.getSession().setAttribute("moduleName", from);
            request.getSession().setAttribute("unusablePoolNo", unusablePoolNo);
        } else {
            aid      = (String)request.getSession().getAttribute("aid");
            raidType = (String)request.getSession().getAttribute("raidType");
            
            ((DynaValidatorForm) form).set("aid", aid);
            ((DynaValidatorForm) form).set("raidType", raidType);
        }
        try{
            Vector diskArrayVector = new Vector();
            TreeMap diskArrayPdgMap = new TreeMap();
            List diskArrayList = VolumeHandler.getDiskArrayInfo();
            
            for (int i = 0; i < diskArrayList.size(); i++) {
                DiskArrayInfoBean diskArrayInfo = (DiskArrayInfoBean)diskArrayList.get(i);
                            
                String pdgList = diskArrayInfo.getPdgList();
                String [] pdgArr = pdgList.split(",");
                Vector pdgVector = new Vector();
                for (int j = 0; j < pdgArr.length; j++) {
                    pdgVector.add(new LabelValueBean(pdgArr[j], pdgArr[j].substring(0, 2)));    
                }
                
                String aname = diskArrayInfo.getAname();
                diskArrayVector.add(new LabelValueBean(aname, diskArrayInfo.getAid()));
                diskArrayPdgMap.put(aname, pdgVector);
            }
            NSActionUtil.setSessionAttribute(request, "diskArrayVector", diskArrayVector);
            NSActionUtil.setSessionAttribute(request, "diskArrayPdgMap", diskArrayPdgMap);

        }catch(NSException e){
            
            if (DiskCommon.isSSeries(request)){
                VolumeListAction.setISAdiskListErrorCode(e, "83", request);
            }
            throw e;
        }
        return mapping.findForward("showDiskarrayInfo");
    }
}