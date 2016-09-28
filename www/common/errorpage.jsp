<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: errorpage.jsp,v 1.15 2008/05/09 01:25:11 zhangjun Exp $" -->

<! DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page session="true" %>
<%@ page isErrorPage="true" %>
<%@ page import="java.io.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>
<%@ page import="com.nec.nsgui.model.biz.base.NSException" %>
<%@ page import="com.nec.nsgui.exception.NSExceptionMessage" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%
boolean displayMaintain = false;
String errorcode = ""; 
if(exception != null){
    if (exception instanceof com.nec.sydney.framework.NSException) {
    	com.nec.sydney.framework.NSException ex = (com.nec.sydney.framework.NSException)exception;
    	if (ex.getReportLevel() == NSReporter.WARN){
    	    displayMaintain = true;
    	}
    }else{
         try{
            com.nec.nsgui.model.biz.base.NSException ex;
            try{
                ex = (com.nec.nsgui.model.biz.base.NSException)exception;
            }catch(Exception e){
                ex = (com.nec.nsgui.model.biz.base.NSException)exception.getCause();
            }
            if(ex.getErrorCode().equals("0x10000006")||ex.getErrorCode().equals("0x10000007")
            	||ex.getErrorCode().equals("0x10000008")||ex.getErrorCode().equals("0x10000009")){
                session.setAttribute(NSActionConst.SESSION_EXCEPTION_MESSAGE, null);
                session.setAttribute(NSActionConst.SESSION_EXCEPTION_OBJECT, null);
                errorcode = ex.getErrorCode();
                displayMaintain = true;
            }
         }catch(Exception e){
            //do nothing
         }
    } 
}
if(displayMaintain){%>
<html>
<head>
<%@include file="head.jsp" %>
</head>
<body >
<form>
<h1 class="Warning"><nsgui:message key="framework/error/h1/warning"/></h1>
<%
	if (errorcode.equals("0x10000008")||errorcode.equals("0x10000009")){
%>
<h2 class="Warning"><nsgui:message key="framework/error/commmsg"/></h2>

<h3 class="Warning"><nsgui:message key="framework/error/reason"/></h3>
<table><tr><td>
	<li><nsgui:message key="framework/error/reasonlist1"/>
	<li><nsgui:message key="framework/error/reasonlist2"/>
	<li><nsgui:message key="framework/error/reasonlist3"/>
</td></tr></table>

<h3 class="Warning"><nsgui:message key="framework/error/operation"/></h3>
<table><tr><td>
	<li><nsgui:message key="framework/error/operationlist1"/>
	<li><nsgui:message key="framework/error/operationlist2"/>
</td></tr></table>

<%
	}else{
%>
<h2 class="Warning"><nsgui:message key="framework/error/msg"/></h2>
<%	}
%>

</form>
</body>
</html>
<%}else{%>
<html>
<head>
<%@include file="head.jsp" %>
	<title><bean:message bundle="errorDisplay" key="error.h1.unExpectError"/></title>
<script src="<%=request.getContextPath()%>/common/common.js"></script>
<script language="JavaScript">
    function changeLayer(){
        if(document.topform.logInfo_button.value == "<bean:message bundle="errorDisplay" key="error.button.displayLog"/>"){
            hideIt("hideLogLayer");
            showIt("displayLogLayer");
            document.topform.logInfo_button.value = "<bean:message bundle="errorDisplay" key="error.button.hideLog"/>";
        }else{
            showIt("hideLogLayer");
            hideIt("displayLogLayer");
            document.topform.logInfo_button.value = "<bean:message bundle="errorDisplay" key="error.button.displayLog"/>"
        }
        return true;
    }
    
</script>
</head>
<body onload="showIt('hideLogLayer');">
<form name="topform">
<h1 class="title"><bean:message bundle="errorDisplay" key="error.h1.unExpectError"/></h1>

<h2 class="title"><bean:message bundle="errorDisplay" key="error.h2.error"/></h2>

<table border="0">
    <tr><td><bean:message bundle="errorDisplay" key="error.unExpect.error_msg"/></td></tr>
    <tr><td align="right">
        <input type="button" name="logInfo_button"
         value="<bean:message bundle="errorDisplay" key="error.button.displayLog"/>"
         onclick="return changeLayer()">
    </td></tr>
</table>
</form>

<div id="displayLogLayer"
      style="display: none;  POSITION: absolute; left: 15px">
  
    <form name="displayLogform">
        <h2 class="title"><bean:message bundle="errorDisplay" key="error.h3.errorLog"/></h2>
        <textarea name="detailInfo" cols="80" rows="25"><%
        Exception exc = (Exception)session.getAttribute(NSActionConst.SESSION_EXCEPTION_OBJECT);
        if(exc != null){
            if (exc instanceof com.nec.nsgui.model.biz.base.NSException){
                com.nec.nsgui.model.biz.base.NSException ex = (com.nec.nsgui.model.biz.base.NSException)exc;
                %><%=NSMessageDriver.getInstance().reformMessage(ex.getDetail(),session)+"-----------------------------------------------------------------\n"%><%
            }
            out.println(NSMessageDriver.getInstance().reformMessage(exc,session));
            NSReporter.getInstance().trace(NSMessageDriver.getInstance().reformMessage(exc,session));
            //exc.printStackTrace(new PrintWriter(out));
            session.setAttribute(NSActionConst.SESSION_EXCEPTION_OBJECT, null);
     	}
    	if(exception != null){
            NSReporter.getInstance().report(exception);
            String	message = exception.getMessage();
            if (message != null){ 
                %><%= NSMessageDriver.getInstance().reformMessage(message,session)+"\n"%><%
            }
            if (exception instanceof com.nec.sydney.framework.NSException) {
            	com.nec.sydney.framework.NSException ex = (com.nec.sydney.framework.NSException)exception;
            	String	detail = ex.whatHappened();
            	if (detail != null) {
                    %><%=NSMessageDriver.getInstance().reformMessage(detail,session)+"\n-----------------------------------------------------------------\n"%><%
            	}
            }
            
            try{
                com.nec.nsgui.model.biz.base.NSException ex;
                try{
                    ex = (com.nec.nsgui.model.biz.base.NSException)exception;
                }catch(Exception e){
                    ex = (com.nec.nsgui.model.biz.base.NSException)exception.getCause();
                }
                %><%=NSMessageDriver.getInstance().reformMessage(ex.getDetail(),session)+"-----------------------------------------------------------------\n"%><%
             }catch(Exception e){
                //do nothing
             }
             NSReporter.getInstance().trace(NSMessageDriver.getInstance().reformMessage(exception,session));
             out.println(NSMessageDriver.getInstance().reformMessage(exception,session));
            //exception.printStackTrace(new PrintWriter(out));
    	}
        %></textarea>
        <h2 class="title"><bean:message bundle="errorDisplay" key="error.h2.errorSolution"/></h2>
        <table border="0">
            <tr><td><bean:message bundle="errorDisplay" key="error.unExpect.method_msg"/></td></tr>
        </table>
    </form>
</div>

<div id="hideLogLayer"
      style="display: none;  POSITION: absolute; left: 15px">
  <form name="hideLogform">
        <h2 class="title"><bean:message bundle="errorDisplay" key="error.h2.errorSolution"/></h2>
        <table border="0">
            <tr><td><bean:message bundle="errorDisplay" key="error.unExpect.method_msg"/></td></tr>
        </table>
   </form>
</div>
</body>
</html>
<%}%>