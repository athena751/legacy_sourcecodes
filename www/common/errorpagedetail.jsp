<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: errorpagedetail.jsp,v 1.10 2007/05/09 05:16:49 liul Exp $" -->

<! DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page session="true" %>
<%@ page import="java.io.*" %>
<%@ page import="com.nec.nsgui.exception.NSExceptionMessage" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<html:html lang="true">
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META HTTP-EQUIV="expires" CONTENT="0">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<link rel="stylesheet" href="/nsadmin/skin/default/errorpage.css" type="text/css">
<bean:define id="titleKey" name="displayErrorForm" property="h1_key" type="java.lang.String"/>
<title><bean:message key="<%=titleKey%>"/></title>
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

<h1 class="title"><bean:message key="<%=titleKey%>"/></h1>

<h2 class="title"><bean:message bundle="errorDisplay" key="error.h2.detailError"/></h2>

<h3 class="title"><bean:message bundle="errorDisplay" key="error.h3.error"/></h3>
<table border="0">
    <tr><td colspan="2">
    <bean:define id="generalInfoMesg" name="displayErrorForm" property="generalInfo"/>
    <%=generalInfoMesg%>
    </td></tr>
    <tr>
        <td>
            <bean:message bundle="errorDisplay" key="error.td_errorID"/>
            <bean:write name="displayErrorForm" property="errorID"/>
        </td>
        <td align="right">
            <input type="button" name="logInfo_button"
             value="<bean:message bundle="errorDisplay" key="error.button.displayLog"/>"
             onclick="return changeLayer()">
        </td>
    </tr>
</table>
</form>

<div id="displayLogLayer"
      style="display: none;  POSITION: absolute; left: 15px">
  
    <form name="displayLogform">
        <h3 class="title"><bean:message bundle="errorDisplay" key="error.h3.errorLog"/></h3>
         <bean:define id="nsExceptionObject" name="displayErrorForm" property="nsException" type="com.nec.nsgui.model.biz.base.NSException"/>
         <textarea name="detailInfo" cols="80" rows="25"><%=nsExceptionObject.getDetail()+"-----------------------------------------------------------------\n"%><%
            nsExceptionObject.printStackTrace(new PrintWriter(out));
         %></textarea>
        <h3 class="title"><bean:message bundle="errorDisplay" key="error.h3.errorContent"/></h3>
        <table border="0">
            <tr><td>
            <bean:define id="detailInfoMesg" name="displayErrorForm" property="detailInfo"/>
            <%=detailInfoMesg%>
            </td></tr>
        </table>
        <h3 class="title"><bean:message bundle="errorDisplay" key="error.h3.errorSolution"/></h3>
        <table border="0">
            <tr><td>
            <bean:define id="detailDealMesg" name="displayErrorForm" property="detailDeal"/>
            <%=detailDealMesg%>
            </td></tr>
        </table><br>
        <input type="button" name="close_button" value="<bean:message bundle="common" key="common.button.close"/>"
        onClick="window.close();" >
    </form>
</div>

<div id="hideLogLayer"
      style="display: none;  POSITION: absolute; left: 15px">
  <form name="hideLogform">
        
        <h3 class="title"><bean:message bundle="errorDisplay" key="error.h3.errorContent"/></h3>
        <table border="0">
            <tr><td><%=detailInfoMesg%></td></tr>
        </table>
        <h3 class="title"><bean:message bundle="errorDisplay" key="error.h3.errorSolution"/></h3>
        <table border="0">
            <tr><td><%=detailDealMesg%></td></tr>
        </table><br>
        <input type="button" name="close_button" value="<bean:message bundle="common" key="common.button.close"/>"
        onClick="window.close();" >
    </form>
</div>
</body>
</html:html>