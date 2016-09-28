
/*
 *      Copyright (c) 2004-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: DisplayError.java,v 1.32 2009/03/11 02:08:05 fengmh Exp $
 *
 */

package com.nec.nsgui.taglib.displayerror;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.struts.Globals;
import org.apache.struts.config.ModuleConfig;
import org.apache.struts.taglib.TagUtils;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.exception.NSExceptionMessage;
import com.nec.nsgui.model.biz.base.NSException;

/**
 * class to display the error information when it occurs. 
 * 
 *
 * @author  $Author: fengmh $
 * @version $Revision: 1.32 $
 */

public class DisplayError extends TagSupport{

    private String h1_key = null;
    private final static String ERROR_LEVEL_INFO="info"; 
    public void setH1_key(String h1_key){
        this.h1_key = h1_key;
    }
    public String getH1_key(){
        return this.h1_key;
    }
    
    public int doEndTag() throws JspException{
        HttpSession userSession = (HttpSession)pageContext.getSession();
        NSExceptionMessage exceptionInfo = (NSExceptionMessage)userSession.getAttribute(NSActionConst.SESSION_EXCEPTION_MESSAGE);
        JspWriter out = pageContext.getOut();
        if(exceptionInfo == null){
            displayNoError(out, userSession);
        }else{
            userSession.setAttribute(NSActionConst.SESSION_EXCEPTION_MESSAGE, null);
            userSession.setAttribute(NSActionConst.SESSION_EXCEPTION_MESSAGE_DETAIL, exceptionInfo);
            displayErrorInfo(out, exceptionInfo, userSession);
        }
        return EVAL_PAGE;
    }
    
    private void displayNoError(JspWriter out, HttpSession userSession){
        try{
            out.println("<script language=\"JavaScript\">");
            out.println("    function closeDetailErrorWin(){}");
            out.println("    function displayAlert(){");
            generateDisplaySuccess(out,userSession);
            out.println("    }");
            out.println("</script>");
        }catch(Exception ex){
            
        }
    }
    
    private void displayErrorInfo(JspWriter out, NSExceptionMessage exceptionInfo, HttpSession userSession){
        try{
            String notDisplayDetail = (String)userSession.getAttribute(NSActionConst.SESSION_NOT_DISPLAY_DETAIL);
            userSession.setAttribute(NSActionConst.SESSION_NOT_DISPLAY_DETAIL, null);
            
            out.println("<script language=\"JavaScript\">");
            
            if( (notDisplayDetail==null) || !notDisplayDetail.equals("true") ){
                generateDetailJScript(out);
            }else{
                out.println("    function closeDetailErrorWin(){}");
            }
            generateDisplayAlert( out, userSession);
            out.println("</script>");
            generateErrorTable( out,exceptionInfo,notDisplayDetail );
        }catch(Exception ex){
            
        }
    }
    
    private void generateDisplayAlert(JspWriter out,HttpSession userSession) throws Exception{
        out.println(" var errorInstance=\"true\";");
        out.println("    function displayAlert(){");
        
        String alert_failed = TagUtils.getInstance().message(pageContext,"common",Globals.LOCALE_KEY,NSActionConst.FAILED_ALERT_KEY);
        String noFailedAlert = (String)userSession.getAttribute(NSActionConst.SESSION_NOFAILED_ALERT);
        userSession.setAttribute(NSActionConst.SESSION_NOFAILED_ALERT, null);
        if( (noFailedAlert==null) || !noFailedAlert.equals("true") ){
            out.println("       alert(\""+alert_failed+"\");");
        }
        generateDisplaySuccess(out,userSession);
        
        out.println("    }");
    }
    
    private void generateDetailJScript(JspWriter out) throws Exception{
        HttpServletRequest httpRequest = (HttpServletRequest)pageContext.getRequest();
        String contextPath = httpRequest.getContextPath();
        
        ModuleConfig config = (ModuleConfig)httpRequest.getAttribute(Globals.MODULE_KEY);
        String defaultPage = contextPath 
                            + config.getPrefix()
                            + "/displayError.do";
        String key = getH1_key();
        if(key == null || key.equals("")){
            key = "h1.title";
        }
        defaultPage = defaultPage + "?h1_key=" + key;
        
        out.println("    var errorDetailWindowName;");
        out.println("    function openErrorWin(){");
        out.println("       if(errorDetailWindowName == null || errorDetailWindowName.closed){");
        out.println("           errorDetailWindowName = open(\"" + defaultPage + "\", \"errorDetailWindowName\", \"resizable=yes,toolbar=no,menubar=no,scrollbars=yes,width=800,height=600\");");
        out.println("       }else{");
        out.println("           errorDetailWindowName.focus();");
        out.println("       }");
        out.println("    }");
        out.println("    function closeDetailErrorWin(){");
        out.println("       if(errorDetailWindowName != null){");
        out.println("           errorDetailWindowName.close();");
        out.println("       }");
        out.println("    }");
    }
    
    private void generateErrorTable(JspWriter out,NSExceptionMessage exceptionInfo, String notDisplayDetail) throws Exception{
        HttpServletRequest httpRequest = (HttpServletRequest)pageContext.getRequest();
        String contextPath = httpRequest.getContextPath();
        NSException nsex = exceptionInfo.getCauseException();
        if(nsex.getErrorCode().equals("0x10810082") || nsex.getErrorCode().equals("0x10820082") ||
           nsex.getErrorCode().equals("0x10810083") || nsex.getErrorCode().equals("0x10820083") ||
           nsex.getErrorCode().equals("0x10810084") || nsex.getErrorCode().equals("0x10820084") 
           ){
            
            String msgKey = "error.async.fcsanCmdFail.iSAdisklist.generalDeal";
            if(nsex.getErrorCode().startsWith("0x1082")){
                msgKey = msgKey + ".pair";
            }
            if(nsex.getErrorCode().endsWith("82")){
                msgKey = msgKey + ".volume";
            }else if(nsex.getErrorCode().endsWith("83")){
                msgKey = msgKey + ".poolSelect";
            }else{
                msgKey = msgKey + ".pairDetail";
            }
            
            String msg = TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY+"/volume",Globals.LOCALE_KEY, msgKey);
            out.println("<table border=\"0\">");
            out.println("<tr><td>");
            out.println(msg);
            out.println("</td></tr>");
            out.println("</table>");
            return;
        }
        
        String td_error = TagUtils.getInstance().message(pageContext,"errorDisplay",Globals.LOCALE_KEY,"error.td_error");
        String img = "icon_alert.png";
        if(exceptionInfo.getLevel().equals(ERROR_LEVEL_INFO)){
        	td_error="";
        }
        String link_detail = TagUtils.getInstance().message(pageContext,"errorDisplay",Globals.LOCALE_KEY,"error.link.detail");
//      out.println("<form name=\"errorInfoForm\">");
        out.println("<table border=\"0\">");
        out.println("    <tr><td rowspan=\"2\" class=\"ErrorInfo\">");        

        if (!nsex.getErrorCode().equals("0x18A000FF")) {
            out.println(
                "    <img border=0 src=\""
                    + contextPath
                    + "/images/icon/png/" + img + "\">"
                    + td_error
                    + "&nbsp;&nbsp;</td>");
        }
        if(nsex.getErrorCode().equals("0x107000FF")){ //add for pool liq 2005/9/21
            String errorCode = (nsex.getDetail().trim()).split("\n")[0];
            String errorinfokey = "disk.pool.error."+errorCode;
            String errorInfo= TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY+"/disk",Globals.LOCALE_KEY,errorinfokey);
            out.println("    <td class=\"ErrorInfo\">" + exceptionInfo.getGeneralInfo() +"<br>"+ errorInfo +"</td></tr><br>");
        }else if (nsex.getErrorCode().equals("0x18A000FF")) {
            String detailErrorCode = nsex.getCommandErrorCode();
            String tmp[] = detailErrorCode.split("_");
            String commandFile = "";
            String commandCode = "";
            if (tmp.length >= 3) {
                commandCode = tmp[tmp.length - 1];
                commandFile =
                    detailErrorCode.substring(
                        0,
                        detailErrorCode.length() - commandCode.length() - 1);
            }
            String encoding =
                (NSActionUtil.getLang(pageContext.getSession()).equals(NSActionConst.LANGUAGE_JAPANESE))
                    ? NSActionConst.ENCODING_EUC_JP
                    : NSActionConst.ENCODING_ISO8859_1;
            String fileName = NSActionConst.RESOURPATH_NIC + commandFile;
            if (NSActionUtil.getLang(pageContext.getSession()).equals(NSActionConst.LANGUAGE_JAPANESE)) {
                fileName += "_" + NSActionConst.LANGUAGE_JAPANESE;
            }
            String errorCodeThInfo =
                NSActionUtil.getMessage(
                    fileName,
                    "Mess_" + commandCode,
                    encoding);
            String errorCodeThDeal =
                NSActionUtil.getMessage(
                    fileName,
                    "Detail_" + commandCode,
                    encoding);
            if (errorCodeThInfo != null) {
                StringBuffer tmpSb = new StringBuffer();
                Pattern p = Pattern.compile("((&nbsp;)*)(&nbsp;)");
                Matcher m1 = p.matcher(errorCodeThInfo);
                while (m1.find()) {           
                    m1.appendReplacement(tmpSb, m1.group(1) + " ");
                }
                m1.appendTail(tmpSb);
                errorCodeThInfo = tmpSb.toString();
                out.println(
                    "    <img border=0 src=\""
                        + contextPath
                        + "/images/icon/png/icon_alert.png\">"
                        + td_error
                        + "&nbsp;&nbsp;</td>");
                out.println(
                    "    <td class=\"ErrorInfo\" style=\"white-space: normal\">"
                        + errorCodeThInfo
                        + "</td></tr>");
                if (errorCodeThDeal != null) {
                    tmpSb = new StringBuffer();
                    Matcher m2 = p.matcher(errorCodeThDeal);
                    while (m2.find()) {           
                        m2.appendReplacement(tmpSb, m2.group(1) + " ");
                    }
                    m2.appendTail(tmpSb);
                    errorCodeThDeal = tmpSb.toString();
                    out.println(
                        "    <tr><td class=\"ErrorInfo\" style=\"white-space: normal\">"
                            + errorCodeThDeal
                            + "</td></tr>");
                }
            } else {            
                String args[] = new String[1];
                args[0] = detailErrorCode;
                String errorMessage = TagUtils.getInstance().message(
                pageContext,
                Globals.MESSAGES_KEY + "/nic",
                Globals.LOCALE_KEY,
                "exception.th.error.unknown",args); 
                out.println(
                    "    <img border=0 src=\""
                        + contextPath
                        + "/images/icon/png/icon_alert.png\">"
                        + td_error
                        + "&nbsp;&nbsp;"
                        + errorMessage
                        + "</td></tr>"); 
            }
             
        } else{
        	dealCsarError(nsex, exceptionInfo); //if it is csar error, deal with it.
        	
            out.println("    <td class=\"ErrorInfo\">" + exceptionInfo.getGeneralInfo() + "</td></tr>");
            out.println("    <tr><td class=\"ErrorInfo\">" + exceptionInfo.getGeneralDeal() + "&nbsp;&nbsp;");
            String displayDetail = exceptionInfo.getDisplayDetail();//for improve the exception handler constructor at 2005/10/10
            if(displayDetail != null && displayDetail.equals("false")){
            }else{
                if((notDisplayDetail==null) || !notDisplayDetail.equals("true")){
                        out.println("        <a href=\"#\" onclick='openErrorWin();return false'>"+link_detail+"</a>");
                }
               }
            out.println("    </td></tr>");
        }
        out.println("</table>");
//out.println("</form>");
    }
    
    private void generateDisplaySuccess(JspWriter out, HttpSession userSession) throws Exception{
        String resultMsg = (String)userSession.getAttribute(NSActionConst.SESSION_OPERATION_RESULT_MESSAGE);
        if((resultMsg != null) && (!resultMsg.equals(""))){
            userSession.setAttribute(NSActionConst.SESSION_OPERATION_RESULT_MESSAGE, null);
            out.println("       alert(\""+resultMsg+"\");");
        }else{
            String isSuccess = (String)userSession.getAttribute(NSActionConst.SESSION_SUCCESS_ALERT);
            if((isSuccess != null) && (isSuccess.equals("true"))){
                userSession.setAttribute(NSActionConst.SESSION_SUCCESS_ALERT, null);
                String alert_sucess = TagUtils.getInstance().message(pageContext,
                                "common",Globals.LOCALE_KEY,NSActionConst.SUCCESS_ALERT_KEY);
                out.println("       alert(\""+alert_sucess+"\");");
            }
        }
    }
    
    private void dealCsarError(NSException nsex, NSExceptionMessage exceptionInfo) throws Exception{
        String errorCode = nsex.getErrorCode();        
        if(!errorCode.startsWith("0x139")){//not csar error            
            return;
        }else{//csar error
            //errorCode:0x13900NHS
            //N: 0, when collect both node information, and the fip is on node0
            //   1, when collect both node information, and the fip is on node1
            //   2, when collect one node information
            //H: (0~d),when collect both node information, and the error occured on the node that fip is not on
            //S: (0~a),when collect both node information, and the error occured on the node that fip is on
            //   (0~9),when collect one node information
           
            //get "N" of errorCode            	
            if(errorCode.substring(7, 8).equals("2")){ //it collects one node information, so it is no need to modify error messages.
                return;
            } else {// it collects both nodes informations, so it needs to modify error messages.            	
                HttpSession userSession = (HttpSession)pageContext.getSession();
                String mainNode = (String)userSession.getAttribute("csar_main_node");                
                String otherNode = (String)userSession.getAttribute("csar_other_node");                
                String mainNodeMsg = TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY + "/csar",
                        Globals.LOCALE_KEY,"csar.exception.nodecollect.node." + mainNode);                
                String otherNodeMsg = TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY + "/csar",
                        Globals.LOCALE_KEY,"csar.exception.nodecollect.node." + otherNode); 
                
                String s = errorCode.substring(9);  //get "S" of errorCode
                String h = errorCode.substring(8, 9);  //get "H" of errorCode
                
                //deal with detail.info of exception message 
                StringBuffer info = new StringBuffer();
                if(s.equals("6")){//detail.info of fip node starts with "nodeN only" instead of "nodeN:"
                    mainNodeMsg = TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY + "/csar",
                            Globals.LOCALE_KEY,"csar.exception.nodecollect.node." + mainNode + ".only");
                }
                info.append(mainNodeMsg + exceptionInfo.getDetailInfo() + "<br>");                    
                
                String oDetailInfoMsg = TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY + "/csar",
                        Globals.LOCALE_KEY,"csar.exception.othernode." + h + ".detail.info");
                if((h.equalsIgnoreCase("a") && !(s.equals("7") || s.equals("8"))) || h.equalsIgnoreCase("d")){//detail.info of not fip node starts with "nodeN only" instead of "nodeN:"
                    otherNodeMsg = TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY + "/csar",
                            Globals.LOCALE_KEY,"csar.exception.nodecollect.node." + otherNode + ".only");;
                }
                if(h.equalsIgnoreCase("a") && (s.equals("7") || s.equals("8"))){//add for no tar to download
                    oDetailInfoMsg = TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY + "/csar",
                        Globals.LOCALE_KEY,"csar.exception.othernode." + h + s + ".detail.info");
                }
                info.append(otherNodeMsg + oDetailInfoMsg);
                exceptionInfo.setDetailInfo(info.toString());

                //deal with general.info when having tar file to download
                //general.info=detail.info+wizard.recollect.info+wizard.download.info
                if(s.equals("6") || (h.equalsIgnoreCase("a") && !(s.equals("7") || s.equals("8")))){
                    StringBuffer gInfo = new StringBuffer();
                    gInfo.append(exceptionInfo.getDetailInfo());
                    gInfo.append("<br>");
                    String wizardInfo =TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY + "/csar",
                        Globals.LOCALE_KEY,"csar.exception.wizard.info.download");
                    gInfo.append(wizardInfo);
                    gInfo.append("<br>");
                    wizardInfo =TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY + "/csar",
                        Globals.LOCALE_KEY,"csar.exception.wizard.info.recollect");
                    gInfo.append(wizardInfo);
                    exceptionInfo.setGeneralInfo(gInfo.toString());
                }

                
                //deal with detail.deal of exception message
                StringBuffer deal = new StringBuffer();
                boolean hasMainDeal = false;
                if(!s.equals("6")){//detail.deal of fip node exists. so it needs to add node information at the beginning of deal
                    deal.append(mainNodeMsg + exceptionInfo.getDetailDeal());
                    hasMainDeal = true;
                }
                if(!h.equalsIgnoreCase("a") || s.equals("7") || s.equals("8")){//detail.deal of not fip node exists.
                    if(hasMainDeal){
                        deal.append("<br>");
                    } 
                    
                    String oDetailDealMsg = null;
                    if(h.equals("3")){// detail.deal of othernode has parameter
                        //get parameter of detail.deal of othernode
                        String args[] = new String[1];
                        args[0] = (String)userSession.getAttribute("csar_other_info"); 
                        oDetailDealMsg = TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY + "/csar",
                                Globals.LOCALE_KEY,"csar.exception.othernode." + h + ".detail.deal", args);
                    }else if(h.equalsIgnoreCase("a") && (s.equals("7") || s.equals("8"))){//no file to download 
                        oDetailDealMsg = TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY + "/csar",
                                Globals.LOCALE_KEY,"csar.exception.othernode." + h + s + ".detail.deal");
                    }else{
                        oDetailDealMsg = TagUtils.getInstance().message(pageContext,Globals.MESSAGES_KEY + "/csar",
                                Globals.LOCALE_KEY,"csar.exception.othernode." + h + ".detail.deal");
                    }                    
                    deal.append(otherNodeMsg + oDetailDealMsg);
                }
                exceptionInfo.setDetailDeal(deal.toString());                
                
                userSession.setAttribute(NSActionConst.SESSION_EXCEPTION_MESSAGE_DETAIL, exceptionInfo);//refresh message in session
            }//end of else(it collects both nodes informations, so it needs to modify error messages.)
        }//end of else(csar error.)     
        
        
        
    }
}