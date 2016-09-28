<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: krb5directeditbottom.jsp,v 1.1 2006/11/06 05:59:51 liy Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
</head>
<body>
<form>
    <input type="button" name="krb5FileSet" value="<bean:message key="common.button.submit" bundle="common"/>" onclick="return parent.topFrame.onSet()">
    <input type="button" name="krb5FileReset" value="<bean:message key="common.button.reset" bundle="common"/>" onclick="return parent.topFrame.onReset()">
    </form>
</body>
</html>