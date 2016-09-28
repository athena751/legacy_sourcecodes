<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: accounttabnsadmintop.jsp,v 1.2 2007/05/09 08:09:43 chenbc Exp $" -->
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>


<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
function onloadbottom(){
    document.forms[0]._nsadminpassword.value = "";
    document.forms[0]._nsadminpasswordcheck.value = "";
    //parent.accountTabnsadminBottom.location = "/nsadmin/account/accountTabnsadminBottom.do";
    setTimeout('parent.accountTabnsadminBottom.location = "/nsadmin/account/accountTabnsadminBottom.do"',1);
}
</script>
</head>
<body onload="onloadbottom();displayAlert();setHelpAnchor('system_account_2');" onUnload="closeDetailErrorWin();">
<html:form action="accountTabnsadminTop.do?operation=set">
<displayerror:error h1_key="account.common.h1"/>
<h3><bean:message key="account.ns.password"/></h3>
<table border="1" class="Vertical">
    <tr>
        <th><bean:message key="account.ns.password"/></th>
        <td><html:password property="_nsadminpassword" size="50" maxlength="50"></html:password></td>
    </tr>
    <tr>
        <th><bean:message key="account.ns.passwordcheck"/></th>
        <td><input type="password" name="_nsadminpasswordcheck" size="50" maxlength="50"></td>
    </tr>
</table>
</html:form>
</body>
</html>