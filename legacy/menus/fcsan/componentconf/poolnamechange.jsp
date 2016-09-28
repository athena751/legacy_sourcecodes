<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: poolnamechange.jsp,v 1.1 2005/09/29 08:16:29 liyb Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="namechangeBean" class="com.nec.sydney.beans.fcsan.componentconf.PoolNameChangeBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = namechangeBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<html>
<head>
<%int result = namechangeBean.getResult();
  if(result==0){%>
<title><nsgui:message key="fcsan_common/title/page_title_success"/></title>
<%}else{%>
<title><nsgui:message key="fcsan_common/title/page_title_error"/></title>
<%}%>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="JavaScript">
    function onOK() {
        if(<%= result %>==0 && window.opener && !window.opener.closed){
            if (window.opener.opener.parent && window.opener.opener.parent.topframe && window.opener.opener.parent.topframe.document.forms[0].rankspare_check)
                window.opener.opener.parent.location.reload() ;
            window.opener.close();
        }
        window.close();
    }
    
    function decideOpenerButton() {
        if(<%=result%>!=0 && window.opener&&!window.opener.closed) {
            window.opener.document.forms[0].ok.disabled=false;
            window.opener.document.forms[0].cancel.disabled=false;
        }
    }
</script>
</head>

<body onLoad="decideOpenerButton()">
<form>
    
    
    <%if(namechangeBean.getErrorCode() == FCSANConstants.iSMSM_ALREADY) {%>
        <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>
        <h2 class="popup"><nsgui:message key="fcsan_componentconf/poolnamechange/namechange_failed_existname"/></h2>
    <%}else if(result==0){%>
        <h1 class="popup"><nsgui:message key="common/alert/done"/></h1>    
        <h2 class="popup"><nsgui:message key="fcsan_common/specialmessage/msg_do_reload"/></h2>
    <%}else{%>
        <%if(namechangeBean.setSpecialErrMsg()) {%>
            <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>
            <h2 class="popup"><%=namechangeBean.getErrMsg()%></h2>       
        <%}else{%>
            <h1 class="popupError"><nsgui:message key="common/alert/failed"/></h1>
            <h2 class="popupError"><%=namechangeBean.getErrMsg()%></h2>
        <%}%>
    <%}%>
<center> 
    <input type="button" name="ok" value="<nsgui:message key="fcsan_common/button/button_ok"/>" onClick="onOK()">
</center>
</form>
</body>
</html>
