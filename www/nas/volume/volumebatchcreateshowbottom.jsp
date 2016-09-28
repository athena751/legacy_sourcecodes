<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumebatchcreateshowbottom.jsp,v 1.3 2007/08/23 05:43:19 xingyh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="javaScript">

function onSubmit(){
    if (parent.frames[1].document.forms[0]){
        return parent.frames[1].onConfirm();
    }
    return false;
}
</script>
</head>
<body onUnload="unLockMenu();">
<form onsubmit="return onSubmit()">
<input type="submit" value='<bean:message key="button.batchcreateshow.confirm"/>'  >
</form>
</body>
</html:html>