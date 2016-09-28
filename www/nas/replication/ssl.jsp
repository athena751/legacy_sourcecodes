<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ssl.jsp,v 1.3 2007/05/09 05:00:56 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html:html lang="true">
<head>
<%@ include file="/common/head.jsp" %>
<%@ include file="replicationcommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
function onSet(){
    if (isSubmitted()) {
        return false;
    }

    if (confirm("<bean:message key="common.confirm" bundle="common"/>" + "\r\n"
               + "<bean:message key="common.confirm.action" bundle="common"/>" 
               + "<bean:message key="common.button.submit" bundle="common"/>")) {
        setSubmitted();
        document.forms[0].submit();
        return true;
    }
    return false;
}
</script>
</head>
<body onload="loadSubmitPage('false');setHelpAnchor('replication_10');" onUnload="unloadBtnFrame();">
<html:button property="reloadBtn" onclick="return loadSsl();">
    <bean:message key="common.button.reload" bundle="common"/>
</html:button>
<br>
<displayerror:error h1_key="replicate.h1"/>
<br>
<table border="0">
    <tr>
        <td class="wrapTD"><bean:message key="ssl.set.note"/></td>            
    </tr>
</table>

<br>
<html:form action="ssl.do?operation=set">
    <table border="1">
        <tr>
            <td><html:checkbox styleId="sslCheckbox" property="sslStatus" value="on"/></td>
            <td>
                <label for="sslCheckbox"><bean:message key="ssl.checkbox.label"/></label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            </td>
        </tr>
    </table> 
</html:form>
</body>
</html:html>