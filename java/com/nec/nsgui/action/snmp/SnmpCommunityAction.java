/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.snmp;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.snmp.SnmpCmdHandler;
import com.nec.nsgui.model.entity.snmp.CommunityFormBean;
import com.nec.nsgui.model.entity.snmp.CommunityInfoBean;

/**
 *Actions for community
 */
public class SnmpCommunityAction extends SnmpAction{
    private static final String cvsid = "@(#) $Id: SnmpCommunityAction.java,v 1.4 2007/09/10 01:23:22 lil Exp $";
    
    //edit by cuihw
    public ActionForward displayList(
            ActionMapping mapping,
            final ActionForm form,
            final HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        clearSession(request);
        HashMap infoHash = (HashMap) SnmpCmdHandler.getSnmpCommunityList(false);
        HashMap errorHash = new HashMap();

        // get comm_max form hash, set into form
        String comm_max_str = (String)((HashMap)infoHash).get("comm_max");
        ((DynaActionForm) form).set("commMax", comm_max_str);

        errorHash.put(ERRCODE_RECOVERY, new ExceptionProcessor(){
            public void processExcep(Object info)throws Exception{
                ArrayList communityList = (ArrayList)((HashMap)info).get("communityList");
                request.setAttribute("communityList", communityList);
                ((DynaActionForm) form).set("allSourceNo",Integer.toString(getAllSourceNo(communityList)));
                ((DynaActionForm) form).set("allCommunity",getAllCommunityNameString(communityList));
                request.setAttribute("recoveryFlag", "true");
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setNotDisplayDetail(request);
            }
        });
        errorHash.put(ERRCODE_CONVERTFAILED, new ExceptionProcessor(){
            public void processExcep(Object info)throws Exception{
                ArrayList communityList = (ArrayList)((HashMap)info).get("communityList");
                request.setAttribute("communityList", communityList);
                ((DynaActionForm) form).set("allSourceNo",Integer.toString(getAllSourceNo(communityList)));
                ((DynaActionForm) form).set("allCommunity",getAllCommunityNameString(communityList));
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setNotDisplayDetail(request);
            }
        });
        errorHash.put(ERRCODE_COMMUNITY4COMMUNITY, new ExceptionProcessor(){
            public void processExcep(Object info)throws Exception{
                ArrayList communityList = (ArrayList)((HashMap)info).get("communityList");
                request.setAttribute("communityList", communityList);
                ((DynaActionForm) form).set("allSourceNo",Integer.toString(getAllSourceNo(communityList)));
                ((DynaActionForm) form).set("allCommunity",getAllCommunityNameString(communityList));            
                //for exception of community difference of iptables and snmp.conf
                request.setAttribute("errorComs", ((HashMap)info).get("errorComs"));
                //for exception of community difference of iptables and snmp.conf
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setNotDisplayDetail(request);
            }
        });
		errorHash.put(ERRCODE_COMMUNITY_IPTABLE, new ExceptionProcessor(){
			public void processExcep(Object info)throws Exception{
				ArrayList communityList = (ArrayList)((HashMap)info).get("communityList");
				request.setAttribute("communityList", communityList);
                ((DynaActionForm) form).set("allSourceNo",Integer.toString(getAllSourceNo(communityList)));
                ((DynaActionForm) form).set("allCommunity",getAllCommunityNameString(communityList));
				NSActionUtil.setNoFailedAlert(request);
				NSActionUtil.setNotDisplayDetail(request);
			}
		});
        
        exceptionHandler(request,infoHash,errorHash,new NormalProcessor(){
            public void processNormal(Object info)throws Exception{
                ArrayList communityList = (ArrayList)((HashMap)info).get("communityList");
                request.setAttribute("communityList", communityList);
                ((DynaActionForm) form).set("allSourceNo",Integer.toString(getAllSourceNo(communityList)));
                ((DynaActionForm) form).set("allCommunity",getAllCommunityNameString(communityList));
            }
        });

        return mapping.findForward("displayListTop");
    }
    
    //edit by zhangjun
    public ActionForward displaySetFrame(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response){
        String communityName = (String)((DynaActionForm)form).get("selectedCom");
        String sourceNo      = (String)((DynaActionForm)form).get("allSourceNo");
        String allCommunity  = (String)((DynaActionForm)form).get("allCommunity");
        NSActionUtil.setSessionAttribute(request, "communityName", communityName);
        NSActionUtil.setSessionAttribute(request, "sourceNo", sourceNo);
        NSActionUtil.setSessionAttribute(request, "allCommunity", allCommunity);
        return mapping.findForward("displaySetFrame");
    }
    //edit by zhangjun
    public ActionForward displaySet(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        DynaActionForm communityform = (DynaActionForm)
                NSActionUtil.getSessionAttribute( request, SESSION_SNMP_COMMUNITYFORM);
        
        if( communityform == null ){
            String communityName = (String)NSActionUtil.getSessionAttribute( request, "communityName");
            if(communityName.equals("")){
                ((DynaActionForm) form).set("operate","add");
                ((DynaActionForm) form).set("communityInfo", new CommunityFormBean());
            }else{
                ((DynaActionForm) form).set("operate","modify");
                ((DynaActionForm) form).set("communityInfo",getCommunityFormInfo(communityName));
            }
        }else{
            ((DynaActionForm) form).set("communityInfo",(CommunityFormBean)communityform.get("communityInfo"));
            ((DynaActionForm) form).set("operate",(String)communityform.get("operate"));
        }
        ((DynaActionForm)form).set("allCommunity",(String)NSActionUtil.getSessionAttribute(request,"allCommunity"));
        return mapping.findForward("displaySetTop");
    }
    //edit by zhangjun
    public ActionForward add(
            ActionMapping mapping,
            ActionForm form,
            final HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        NSActionUtil.setSessionAttribute( request,SESSION_SNMP_ERRORHOSTS,null);
        
        NSActionUtil.setSessionAttribute(request, SESSION_SNMP_COMMUNITYFORM, (DynaActionForm)form);

        String comm_max_str = ((DynaActionForm) form).getString("commMax");
        NSActionUtil.setSessionAttribute(
            request, SESSION_SNMP_COMMUNITY_MAX, comm_max_str.trim());

        final CommunityFormBean communityInfo = (CommunityFormBean)((DynaActionForm)form).get("communityInfo");
        partnerFailedHandle(request,new PartnerFailedProcessor(){
            public void process()throws Exception{
                try{
                    SnmpCmdHandler.addCommunity(communityInfo);
                }catch(NSException e){
                    if (e.getErrorCode().equals(ERRCODE_FAILED_CONVERT_ADDCOM)) {
                        String detailErr = e.getDetail();
                        String[] detailError = detailErr.split("\n");
                        String[] errorHostsArray = detailError[detailError.length-3].split(":");
                        NSActionUtil.setSessionAttribute( request,SESSION_SNMP_ERRORHOSTS,errorHostsArray[errorHostsArray.length-1].trim());
                    }
                    throw e;
                }
            }
        });
        return mapping.findForward("enterCommunityList");
    }
    //edit by zhangjun
    public ActionForward modify(
            ActionMapping mapping,
            ActionForm form,
            final HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        NSActionUtil.setSessionAttribute(request, SESSION_SNMP_COMMUNITYFORM, (DynaActionForm)form);

        String comm_max_str = ((DynaActionForm) form).getString("commMax");
        NSActionUtil.setSessionAttribute(
            request, SESSION_SNMP_COMMUNITY_MAX, comm_max_str.trim());

        final CommunityFormBean communityInfo = (CommunityFormBean)((DynaActionForm)form).get("communityInfo");
        final String isForced = (String)((DynaActionForm)form).get("forceModify");
        partnerFailedHandle(request,new PartnerFailedProcessor(){
            public void process()throws Exception{
                boolean failedFlag = SnmpCmdHandler.modifyCommunity(communityInfo,isForced);
                if(failedFlag){
                    NSActionUtil.setSessionAttribute(request, SESSION_SNMP_NAMECHANGEFAILED, "true");
                }else{
                    NSActionUtil.setSessionAttribute(request, SESSION_SNMP_NAMECHANGEFAILED, "false");
                }
            }
        });
        
        if(((String)NSActionUtil.getSessionAttribute( request, SESSION_SNMP_NAMECHANGEFAILED)).equals("true")){
            NSActionUtil.setSessionAttribute(request, NSActionConst.SESSION_SUCCESS_ALERT, null);
            return mapping.findForward("displaySetFrame");
        }else{
            return mapping.findForward("enterCommunityList");
        }
    }
    //edit by cuihw
    public ActionForward delete(
            ActionMapping mapping,
            ActionForm form,
            final HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        final String communityName  = (String)((DynaActionForm)form).get("selectedCom");
        final String isForced       = request.getParameter("isForced");
        
        partnerFailedHandle(request,new PartnerFailedProcessor(){
            public void process()throws Exception{
                boolean failedFlag = SnmpCmdHandler.deleteCommunity(communityName,isForced);
                if(failedFlag){
                    NSActionUtil.setSessionAttribute(request, SESSION_SNMP_NAMECHANGEFAILED, "true");
                    NSActionUtil.setSessionAttribute(request, "selectedCom", communityName);
                }else{
                    NSActionUtil.setSessionAttribute(request, SESSION_SNMP_NAMECHANGEFAILED, "false");
                }
            }
        });
        if(((String)NSActionUtil.getSessionAttribute( request, SESSION_SNMP_NAMECHANGEFAILED)).equals("true")){
            NSActionUtil.setSessionAttribute(request, NSActionConst.SESSION_SUCCESS_ALERT, null);
        }
        return mapping.findForward("enterCommunityList");
    }
    
    //edit by zhangjun
    private CommunityFormBean getCommunityFormInfo(String communityName) throws Exception{
        String []sourceListArray = SnmpCmdHandler.getCommunityInfo(communityName);
        StringBuffer sourceList = new StringBuffer();
        sourceList.append(sourceListArray[0]);
        for ( int i = 1 ; i < sourceListArray.length ; i++ ) {
            sourceList.append("\n").append(sourceListArray[i]);
        }
        CommunityFormBean communityInfo = new CommunityFormBean();
        communityInfo.setSourceList(sourceList.toString());
        communityInfo.setCommunityName(communityName);
        return communityInfo;
    }
    //edit by cuihw
	int getAllSourceNo(ArrayList communityList){
        int result = 0;
        if(communityList != null){
	        int n = communityList.size();
	        for(int i = 0; i < n; i ++) {
	            result = result + ((CommunityInfoBean)communityList.get(i)).getSourceList().size();
	        }
	    }
        return result;
    }
    //edit by cuihw
	String getAllCommunityNameString(ArrayList communityList){
        String result = "";
        if(communityList != null){
	        int n = communityList.size();
	        for(int i = 0; i < n; i ++) {
	            if(i == n-1){
	                result = result + ((CommunityInfoBean)communityList.get(i)).getCommunityName();
	            }else{
	                result = result + ((CommunityInfoBean)communityList.get(i)).getCommunityName()+" ";
	            }
	        }
	    }
        return result;
    }
}