<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: krb54nsview.jsp,v 1.1 2006/11/06 06:00:05 liy Exp $" -->


<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.krb5.Krb5ActionConst"%>

<html>
<head>
<%@include file="../../common/head.jsp" %>

<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">

function onReload(){
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="krb5FileTop.do?operation=readKrb5File";
}

</script>
</head>
<body>
<form name="krb5FileSetForm" method="POST">
	<input type="button" name="reload" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="onReload()"/>
	<br>
	<br>
	<displayerror:error h1_key="krb5.h1"/>
	<br>
    <textarea name="fileContent" wrap="off" rows="30" style='width:100%;' readonly><bean:write name="directEditForm" property="fileContent"/></textarea>
</form>
</body>
</html>