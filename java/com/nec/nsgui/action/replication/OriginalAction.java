/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.replication;
import java.util.*;
import com.nec.nsgui.model.biz.replication.*;
import com.nec.nsgui.action.replication.ReplicationActionConst;
import com.nec.nsgui.model.entity.replication.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionUtil;

import com.nec.nsgui.model.entity.volume.VolumeInfoBean;

public class OriginalAction extends DispatchAction {
    private static final String cvsid =
        "@(#) $Id: OriginalAction.java,v 1.5 2008/06/17 06:48:22 liy Exp $";

    // deteal after error---filesetExit
    public ActionForward afterError(
        ActionMapping mapping,
        ActionForm Form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        DynaValidatorForm inputForm = (DynaValidatorForm) Form;
        String errorFrom = inputForm.get("errorFrom").toString();

        if (errorFrom.equals("preCreate")) {
            return mapping.findForward("afterCreateError");
        } else {
            return mapping.findForward("afterTransferError");
        }

    }

    // to show original list  for nsadmin 
    public ActionForward list(
        ActionMapping mapping,
        ActionForm Form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        ////if this page comes from volume//
        VolumeInfoBean volumeInfo =
            (VolumeInfoBean) request.getSession().getAttribute(
                ReplicationActionConst.SESSION_VOLUME_INFO_4REPLI);

        if (volumeInfo != null) { //from volume
            return transfer(mapping, request, Form, volumeInfo);
        }

        String strExportgroup = NSActionUtil.getExportGroupPath(request);
        int iNode = NSActionUtil.getCurrentNodeNo(request);

        List oriList = OriginalHandler.getOriginalList(iNode, strExportgroup);
        request.setAttribute("oriList", oriList);

        if (NSActionUtil.isNsview(request)) { // for view
            return mapping.findForward("list4nsview");
        } else { //for admin
            return mapping.findForward("list");
        }

    }

    //prepare to create a new original 
    public ActionForward preCreate(
        ActionMapping mapping,
        ActionForm Form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
    	String strExportgroup = NSActionUtil.getExportGroupPath(request);
        request.setAttribute("exportgroup", strExportgroup + "/");

        int iNode = NSActionUtil.getCurrentNodeNo(request);
        String strCodePage = ReplicaCreateShowAction.getEncoding4Replication(request);

        List mpList =
            OriginalHandler.getFreeMP(iNode, strExportgroup, strCodePage);
        request.setAttribute("mpList", mpList);

        Vector interfaceVec = ReplicaCreateShowAction.getInterfaceVec(iNode);
        request.setAttribute("interfaceVec", interfaceVec);

        return mapping.findForward("preCreate");

    }

    //create a new original 
    public ActionForward create(
        ActionMapping mapping,
        ActionForm Form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        DynaValidatorForm inputForm = (DynaValidatorForm) Form;
        OriginalBean ori = (OriginalBean) inputForm.get("originalInfo");
        int iNode = NSActionUtil.getCurrentNodeNo(request);
        OriginalHandler.create(iNode, ori);

        NSActionUtil.setSessionAttribute(
            request,
            ReplicationActionConst.SESSION_FILESET,
            ori.getFilesetName());

        NSActionUtil.setSuccess(request);
        return mapping.findForward("listDo");

    }

    //delete  original 
    public ActionForward delete(
        ActionMapping mapping,
        ActionForm Form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        DynaValidatorForm inputForm = (DynaValidatorForm) Form;
        OriginalBean ori = (OriginalBean) inputForm.get("originalInfo");
        NSActionUtil.setSessionAttribute(
            request,
            ReplicationActionConst.SESSION_FILESET,
            ori.getFilesetName());
        int iNode = NSActionUtil.getCurrentNodeNo(request);

        OriginalHandler.delete(iNode, ori);

        NSActionUtil.setSuccess(request);
        return mapping.findForward("listDo");

    }
    //prepare to demote a  original 
    public ActionForward preDemote(
        ActionMapping mapping,
        ActionForm Form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaValidatorForm inputForm = (DynaValidatorForm) Form;
        OriginalBean ori = (OriginalBean) inputForm.get("originalInfo");
        NSActionUtil.setSessionAttribute(
            request,
            ReplicationActionConst.SESSION_FILESET,
            ori.getFilesetName());

        return mapping.findForward("preDemote");

    }
    //demote  original 
    public ActionForward demote(
        ActionMapping mapping,
        ActionForm Form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        DynaValidatorForm inputForm = (DynaValidatorForm) Form;
        OriginalBean ori = (OriginalBean) inputForm.get("originalInfo");

        String filesetName = ori.getFilesetName();
        int iNode = NSActionUtil.getCurrentNodeNo(request);
        ReplicaHandler.checkVolSyncInFileset("localhost",
        		filesetName,
                "true",
                iNode);
        OriginalHandler.demote(iNode, ori);

        NSActionUtil.setSuccess(request);
        return mapping.findForward("listDo");
    }

    //prepare to modify a  original 
    public ActionForward preModify(
        ActionMapping mapping,
        ActionForm Form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaValidatorForm inputForm = (DynaValidatorForm) Form;
        OriginalBean ori = (OriginalBean) inputForm.get("originalInfo");
        int iNode = NSActionUtil.getCurrentNodeNo(request);

        Vector interfaceVec = ReplicaCreateShowAction.getInterfaceVec(iNode);
        request.setAttribute("interfaceVec", interfaceVec);
        //set default hour and minute
        if(ori.getHour().equals("--") && ori.getMinute().equals("--")){
        	ori.setHour(ReplicationActionConst.DEFAULT_HOUR);
        	ori.setMinute(ReplicationActionConst.DEFAULT_MINUTE);
        }
        //inputForm.set("originalInfo", ori);
        NSActionUtil.setSessionAttribute(
            request,
            ReplicationActionConst.SESSION_FILESET,
            ori.getFilesetName());

        return mapping.findForward("preModify");

    }
    //modify  original 
    public ActionForward modify(
        ActionMapping mapping,
        ActionForm Form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        DynaValidatorForm inputForm = (DynaValidatorForm) Form;
        OriginalBean ori = (OriginalBean) inputForm.get("originalInfo");

        int iNode = NSActionUtil.getCurrentNodeNo(request);

        ReplicaHandler.checkVolSyncInFileset("localhost",
        		ori.getFilesetName(),
                "true",
                iNode);
        String convert = (String) inputForm.get("convert");
        OriginalHandler.modify(iNode, ori, convert);

        NSActionUtil.setSessionAttribute(
            request,
            ReplicationActionConst.SESSION_FILESET,
            ori.getFilesetName());

        NSActionUtil.setSuccess(request);
        return mapping.findForward("listDo");
    }

    //prepare to create a new original----after error 
    public ActionForward transfer(
        ActionMapping mapping,
        ActionForm Form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        int iNode = NSActionUtil.getCurrentNodeNo(request);

        Vector interfaceVec = ReplicaCreateShowAction.getInterfaceVec(iNode);
        request.setAttribute("interfaceVec", interfaceVec);

        return mapping.findForward("transfer");

    }

    //prepare to create a new original  from volume module 
    private ActionForward transfer(
        ActionMapping mapping,
        HttpServletRequest request,
        ActionForm Form,
        VolumeInfoBean volumeInfo)
        throws Exception {

        int iNode = NSActionUtil.getCurrentNodeNo(request);
        String strCodePage = ReplicaCreateShowAction.getEncoding4Replication(request);

        Vector interfaceVec = ReplicaCreateShowAction.getInterfaceVec(iNode);
        request.setAttribute("interfaceVec", interfaceVec);

        String strMP = volumeInfo.getMountPoint();
        String strVolume = volumeInfo.getVolumeName();
        String strFstype = volumeInfo.getFsType();

        request.getSession().removeAttribute(
            ReplicationActionConst.SESSION_VOLUME_INFO_4REPLI);

        if (strFstype.equals("sxfsfw")) {
            strFstype += "#" + strCodePage;
        }

        DynaValidatorForm inputForm = (DynaValidatorForm) Form;
        OriginalBean ori = (OriginalBean) inputForm.get("originalInfo");
        ori.setMountPoint(strMP);

        inputForm.set("filesetNamePrefix", strVolume);
        inputForm.set("filesetNameSuffix", strFstype);

        return mapping.findForward("transfer");

    }
}