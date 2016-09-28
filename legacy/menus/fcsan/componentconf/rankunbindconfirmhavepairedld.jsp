<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: rankunbindconfirmhavepairedld.jsp,v 1.1 2008/04/19 15:35:02 jiangfx Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.framework.NSConstant"%>
<jsp:include page="../../common/wait.jsp" />
<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<title>
<nsgui:message key="fcsan_common/title/title_confirm"/>
</title>

<script language="javaScript">
function onCancel()
{
    if(window.opener&&!window.opener.closed){
        window.opener.document.forms[0].ok.disabled=false;
        window.opener.document.forms[0].cancel.disabled=false;
    }
    window.close();
}

function defaultFocus()
{
    document.forms[0].cancel.focus();
}
</script>
</head>
<body onLoad="defaultFocus()" onunload="onCancel();">
<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/rankunbind/h2_rankunbind"/></h2>

<form name="delForm">
<br>
    <nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/haspairedlds"/>
<br><br><br>
<center>
<input type="button" name="cancel" value="<nsgui:message key="common/button/close" />"   onClick="onCancel()">
</center>
</form>
</body>
</html>
