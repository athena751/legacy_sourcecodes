<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumebatchcreatespecifyshowbottom.jsp,v 1.2 2007/05/09 05:18:15 liuyq Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>

<script language="javaScript">
var loaded=0;

function onSubmit(){
    if (parent.frames[0]
        && parent.frames[0].loaded==1){
        return parent.frames[0].onConfirm();
    }
    return false;
}

function init() {
    loaded=1;
}
</script>
</head>
<body onload="init()">
<form onsubmit="return onSubmit()">
<input type="submit" value='<bean:message key="button.batchcreateshow.confirm"/>'  >
</form>
</body>
</html:html>