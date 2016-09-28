/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.ndmpv4;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.cifs.CommonUtil;
import com.nec.nsgui.model.biz.ndmpv4.NdmpHandler;
import com.nec.nsgui.model.entity.ndmpv4.NdmpSessionInfoBean;
public final class NdmpSessionAction extends DispatchAction implements NdmpActionConst {

    private static final String cvsid =
        "@(#) $Id: NdmpSessionAction.java,v 1.3 2006/12/26 03:00:20 wanghui Exp $";
    
    public ActionForward getSessionInfo(
            ActionMapping mapping,ActionForm form,
            HttpServletRequest request,HttpServletResponse response)
        throws Exception {
        
        int groupNum = NSActionUtil.getCurrentNodeNo(request);
        String sessionPath = NdmpHandler.getSessionPath(groupNum);
        List sessioninfoList = NdmpHandler.getSessionInfo(groupNum,sessionPath);
        HashMap sessionJobValue_key = new HashMap();
        sessionJobValue_key.put("BACKUP", "ndmp.session.typejob.backMsg");
        sessionJobValue_key.put("RESTORE", "ndmp.session.typejob.restoreMsg");
        CommonUtil.setMsgInObj(sessioninfoList, "sessionTypeJob", sessionJobValue_key, getResources
(request), request);
        List localSessionList = new ArrayList();
        List moverSessionList = new ArrayList();
        List dataSessionList = new ArrayList();
        List unknownSessionList = new ArrayList();
        for(int i=0;i<sessioninfoList.size();i++){
            NdmpSessionInfoBean sessionInfo = (NdmpSessionInfoBean)sessioninfoList.get(i);
            sessionInfo.setStartTime(convertToLocaleTime(sessionInfo.getStartTime(),request));
            if(sessionInfo.getSessionType().equals(SESSION_TYPE_LOCAL)){
                localSessionList.add(sessionInfo);
            }else if(sessionInfo.getSessionType().equals(SESSION_TYPE_DATA)){
                dataSessionList.add(sessionInfo);
            }else if(sessionInfo.getSessionType().equals(SESSION_TYPE_MOVER)){
                moverSessionList.add(sessionInfo);
            }else if(sessionInfo.getSessionType().equals(SESSION_TYPE_UNKNOWN)) {
                unknownSessionList.add(sessionInfo);
            }
        }
        NSActionUtil.setSessionAttribute(request,SESSION_INFO_LIST,sessioninfoList);
        request.setAttribute(SESSION_LOCAL_LIST,localSessionList);
        request.setAttribute(SESSION_MOVER_LIST,moverSessionList);
        request.setAttribute(SESSION_DATA_LIST,dataSessionList);
        request.setAttribute(SESSION_UNKNOWN_LIST,unknownSessionList);
        String dates = getSysDate(groupNum,request,sessionPath);
        request.setAttribute(REQUEST_NDMP_SYSDATE,dates);
        return (mapping.findForward("ndmpsessiontop"));
    }

    public ActionForward displayDetail(
            ActionMapping mapping,ActionForm form,
            HttpServletRequest request,HttpServletResponse response)
        throws Exception { 
        DynaActionForm DetailInfoForm = (DynaActionForm)form;
        String sessionId = (String)DetailInfoForm.get("sessionID");
        List sessionList =(List)NSActionUtil.getSessionAttribute(request,SESSION_INFO_LIST);
        for(int i=0;i<sessionList.size();i++){
            NdmpSessionInfoBean sessionDetail = (NdmpSessionInfoBean)sessionList.get(i);
            if(sessionDetail.getSessionId().equals(sessionId)){
                DetailInfoForm.set("sessionDetail",sessionDetail);
                break;  
            }
        }
        return (mapping.findForward("displayDetail"));
    }
    
    private String convertToLocaleTime(String times,HttpServletRequest request){
        
        String[] tmptime = times.split("\\s+");
        if(tmptime.length!=4){
            return times;
        }
        String[] localeTime = NSActionUtil.getLocalDate_Time(tmptime[3]+" "+tmptime[0]+" "+tmptime[1],tmptime[2],request);
        return localeTime[0]+" "+localeTime[1];   
    }
    public static String getSysDate (int nodeNum,HttpServletRequest request,String path) throws Exception {
        String dates[] = NdmpHandler.getSysDate(nodeNum,path);
        String dates2[] = NSActionUtil.getLocalDate_Time(dates[0], dates[1], request);
        String date = dates2[0] + " " + dates2[1];
        return date;
   }
    
    public ActionForward entrySessionInfo(
            ActionMapping mapping,ActionForm form,
            HttpServletRequest request,HttpServletResponse response)
        throws Exception { 
        int groupNum = NSActionUtil.getCurrentNodeNo(request);
        String version = NdmpHandler.getRunningVersion(groupNum);
        if (version.equals("2")) {
            return (mapping.findForward("sessionInfoV2"));
        } else {
            return (mapping.findForward("sessionInfoV4"));
        }
        
    }
}