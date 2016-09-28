/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: NicDetailTopAction.java,v 3.2 2005/06/13 02:01:04 wanghb Exp
 */
package com.nec.nsgui.action.nic;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.nic.NicHandler;
import com.nec.nsgui.model.entity.nic.NicInformationBean;
import com.nec.nsgui.model.entity.nic.BondingInfoBean;
import org.apache.struts.action.DynaActionForm;

public class NicDetailTopAction extends Action {
    private static final String cvsid =
        "@(#) $Id: NicDetailTopAction.java,v 1.4 2007/08/29 00:55:04 fengmh Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        String parentInterfaceName = "--";
        String linkAndWorkStatus = "DOWN";
        String vid4nic = "--";
        String alias_baseIF = "--";
        String alias_num = "--";

        String interfaceName =
            (String) (String) ((DynaActionForm) form).get("interfaceName");
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        NicInformationBean detailBase = null;
        Vector detailLink = null;
        BondingInfoBean bondInfo = null;
        try {
            detailBase =
                (NicInformationBean) NicHandler.getDetail(
                    interfaceName,
                    nodeNo);
            detailLink = NicHandler.getDetailLink(interfaceName, nodeNo);

            if (detailBase.getLinkStatus().equals("UP")
                && detailBase.getWorkStatus().equals("UP")) {
                linkAndWorkStatus = "UP";
            } else if (
                detailBase.getLinkStatus().equals("DOWN")                    
                    && !detailBase.getIpAddress().equals("--")) {
                linkAndWorkStatus = "DOWN";
            } else if (detailBase.getIpAddress().equals("--")) {
                linkAndWorkStatus = "IPNULL";
            }
            if (interfaceName.indexOf(".") != -1
                && detailBase.getVl().equals("YES")) {
                String[] tmpInterfaceName = interfaceName.split("\\.");
                parentInterfaceName = tmpInterfaceName[0];
                String[] tmpVid = tmpInterfaceName[1].split("\\:");
                if(tmpVid.length>=2){
                    vid4nic = tmpVid[0];
                }else{
                    vid4nic = tmpInterfaceName[1];
                } 
            }
            
            if(interfaceName.indexOf(":") != -1) {
                String[] tmpAlias = interfaceName.split("\\:");
                if(tmpAlias[1].matches("\\d{3,}")){
                    alias_baseIF = tmpAlias[0];
                    alias_num = tmpAlias[1];
                }
            }

            if (interfaceName.startsWith("bond")) {
                bondInfo = NicHandler.getBondInfo(interfaceName, nodeNo);
            } else {
                bondInfo = new BondingInfoBean();
                bondInfo.setMode("--");
                bondInfo.setPrimaryIF("--");
                bondInfo.setInterval("--");
            }
        } catch (Exception e) {
            detailBase = null;
        }
        if (detailBase != null && detailLink != null) {
            request.setAttribute("detailBase", detailBase);
            request.setAttribute("detailLink", detailLink);
            request.setAttribute("linkAndWorkStatus", linkAndWorkStatus);
            request.setAttribute("vid4nic", vid4nic);
            request.setAttribute("parentInterfaceName", parentInterfaceName);
            request.setAttribute("bondInfo", bondInfo);
            request.setAttribute("alias_baseIF", alias_baseIF);
            request.setAttribute("alias_num", alias_num);
        }
        return mapping.findForward("nicDetailTop");
    }
}