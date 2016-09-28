/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.cifs;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.cifs.CifsCmdHandler;
import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.model.biz.syslog.SyslogCmdHandler;
import com.nec.nsgui.model.entity.syslog.SyslogCacheFileInfo;
import com.nec.nsgui.model.entity.syslog.SyslogCommonInfoBean;
import com.nec.nsgui.model.entity.syslog.SyslogLogviewInfoBean;
import com.nec.nsgui.model.entity.syslog.SyslogSearchConditions;
import com.nec.nsgui.model.entity.syslog.SyslogBeanConst;

/**
 * Actions for direct edit page
 */
public class CifsDCAction extends DispatchAction implements CifsActionConst {
    private static final String cvsid = "@(#) $Id: CifsDCAction.java,v 1.5 2006/07/07 06:49:51 fengmh Exp $";

    /**
     * display the share list
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward dcInfo(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        HttpSession session = request.getSession();
        String domainName = (String) session
                .getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        try {
            List dcAccessStatus = CifsCmdHandler.getDCAccessStatus(nodeNo, domainName);
            String sysDate = CommonUtil.getSysDate(nodeNo, false, request);
            request.setAttribute("dcAccessStatus", dcAccessStatus);
            request.setAttribute(REQUEST_CIFS_SYSDATE, sysDate);
        } catch (NSException ex) {
        	if(ex.getErrorCode().equals(ERRCODE_CIFS_GET_DCCONNECTIONSTATUS_NULL)) {
                request.setAttribute(REQUEST_CIFS_GET_DCCONNECTIONSTATUS_FAILD, "cifs.dc.connectionStatusCannotGet");
            } else if(ex.getErrorCode().equals(ERRCODE_CIFS_GET_DCCONNECTIONSTATUS_TIMEOUT)) {
                request.setAttribute(REQUEST_CIFS_GET_DCCONNECTIONSTATUS_FAILD, "cifs.dc.getconnectionStatusTimeout");
            } else if(ex.getErrorCode().equals(ERRCODE_CIFS_GET_DCCONNECTIONSTATUS_OPTIONERR)) {
                request.setAttribute(REQUEST_CIFS_GET_DCCONNECTIONSTATUS_FAILD, "cifs.dc.connectionStatusGetFailed");
            }
        }
        return mapping.findForward("displayDCTop");
    }

    /**
     * display the share list
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward dcReConnect(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        try {
            CifsCmdHandler.dcReConnect(nodeNo);
            String alertMessage = getResources(request).getMessage(
                    request.getLocale(),
                    "cifs.dc.alertReconnect");
            request.getSession().setAttribute(NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,
                          alertMessage);
        } catch (Exception ex) {
            String alertMessage = getResources(request).getMessage(
                    request.getLocale(),
                    "cifs.dc.reConnectionFailed");
            alertMessage += "\\r\\n";
            alertMessage += getResources(request).getMessage(
                    request.getLocale(),
                    "cifs.dc.confirmDCWinbindd");
            request.getSession().setAttribute(NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,
                          alertMessage);
        }
        return mapping.findForward("displayDCBottom");
    }

    /**
     * display the share list
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward displayDCLog(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        HttpSession session = request.getSession();
        String domainName = (String) session
                .getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String) session
                .getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        String dcLogFilePath = CifsCmdHandler.getDCLogFilePath(nodeNo, domainName);        
        if(dcLogFilePath.equals("rotate")) {
            request.setAttribute(REQUEST_LOGVIEW_ERRORTYPE, "cifs.dclog.rotate");
            return mapping.findForward("displayDCLog");
        }
        SyslogSearchConditions conditions = new SyslogSearchConditions(); 
        SyslogCommonInfoBean commonInfo = getInitCommonInfo(NAS_DC_LOG);        
        commonInfo.setLogFile(dcLogFilePath);
        commonInfo.setSearchAction(SyslogBeanConst.SEARCCH_ACTION_DISPLAY_ALL);
        conditions.setCommonInfo(commonInfo);
        
        SyslogLogviewInfoBean viewInfo = (SyslogLogviewInfoBean)((DynaActionForm) form).get("viewInfo");
       
        request.getSession().setAttribute(SESSION_LOGVIEW_SEARCHCONDTION,conditions);
        SyslogCacheFileInfo cacheFileInfo = SyslogCmdHandler.makeCacheFile(nodeNo,conditions,session.getId());
        CifsCmdHandler.deleteDCLogTmpFile(nodeNo, dcLogFilePath);

        if(cacheFileInfo == null){
            request.setAttribute(REQUEST_LOGVIEW_ERRORTYPE, "");
            return mapping.findForward("displayDCLog");
        }
        
        if(cacheFileInfo.getErrorType().equals("DiskIsFull")) {
            request.setAttribute(REQUEST_LOGVIEW_ERRORTYPE, "cifs.dclog.diskIsFull");
            return mapping.findForward("displayDCLog");
        }
        
        NSActionUtil.setSessionAttribute(request, SESSION_LOGVIEW_FILENAME, cacheFileInfo.getLogFileName());
        request.setAttribute(REQUEST_LOGVIEW_ERRORTYPE, "");
        viewInfo.setDownloadFileName(cacheFileInfo.getLogFileName());
        int viewLines = Integer.parseInt(commonInfo.getViewLines());
        long pageCount = cacheFileInfo.getTotalLine()%viewLines == 0 ? cacheFileInfo.getTotalLine()/viewLines : cacheFileInfo.getTotalLine()/viewLines+1;
        viewInfo.setPageCount(Long.toString(pageCount));
        int currentPage = Integer.parseInt(viewInfo.getCurrentPage());
        if(pageCount < currentPage){
            currentPage = 1;
            viewInfo.setCurrentPage("1");
        }
        if(pageCount != 0){
            long startLine = (currentPage - 1) * viewLines + 1;
            String logContents = SyslogCmdHandler.readLogFile(cacheFileInfo.getLogFileName(), startLine, viewLines - 1, conditions);
            viewInfo.setLogContents(logContents);
        }
        
        return mapping.findForward("displayDCLog");
    }
    
    private SyslogCommonInfoBean getInitCommonInfo (String logType){
        SyslogCommonInfoBean commonInfoBean = new SyslogCommonInfoBean();
        commonInfoBean.setLogType(logType);
        return commonInfoBean;
    }
    
    public ActionForward redisplay(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

            int nodeNo = NSActionUtil.getCurrentNodeNo(request);
            HttpSession session = request.getSession();
            String viewLogFileName = (String)NSActionUtil.getSessionAttribute(request, SESSION_LOGVIEW_FILENAME);
            SyslogSearchConditions conditions = (SyslogSearchConditions)session.getAttribute(SESSION_LOGVIEW_SEARCHCONDTION);

            if(!SyslogCmdHandler.fileExist(viewLogFileName)){
                return displayDCLog(mapping,form,request,response);
            }else{
                DynaActionForm dynaForm = (DynaActionForm)form;
                SyslogLogviewInfoBean viewInfo = (SyslogLogviewInfoBean)dynaForm.get("viewInfo");
                int currentPage = Integer.parseInt(viewInfo.getCurrentPage());
                int viewLines = Integer.parseInt((String)conditions.getCommonInfo().getViewLines());
                long startLine = (currentPage - 1) * viewLines + 1;
                String logContents = SyslogCmdHandler.readLogFile(viewLogFileName, startLine, viewLines -1, conditions);

                viewInfo.setLogContents(logContents);
                return mapping.findForward("displayDCLog");
            }
       }   
}
