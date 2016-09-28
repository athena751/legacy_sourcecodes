<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: accounttabnsviewtop.jsp,v 1.2 2007/05/09 08:09:43 chenbc Exp $" -->
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
function onloadbottom(){
    document.forms[0]._nsviewpassword.value = "";
    document.forms[0]._nsviewpasswordcheck.value = "";
    //parent.accountTabnsviewBottom.location = "/nsadmin/account/accountTabnsviewBottom.do";
    setTimeout('parent.accountTabnsviewBottom.location = "/nsadmin/account/accountTabnsviewBottom.do"',1);
}
function setnsview(){
    if(document.forms[0].checkconnection.checked == 1){
        document.forms[0]._nsviewpassword.disabled = 0;
        document.forms[0]._nsviewpasswordcheck.disabled = 0;
    }else{
        document.forms[0]._nsviewpassword.disabled = 1;
        document.forms[0]._nsviewpasswordcheck.disabled = 1;
    }
}
</script>
</head>
<body onload="onloadbottom();displayAlert();setnsview();setHelpAnchor('system_account_3');" onUnload="closeDetailErrorWin();">
<html:form action="accountTabnsviewTop.do?operation=set">
<displayerror:error h1_key="account.common.h1"/>
<h3><bean:message key="account.nsview.connection.h3"/></h3>
<table border="1" class="Vertical">
    <tr>
        <td><html:checkbox property="checkconnection" styleId="volID1" onclick="setnsview();" ></html:checkbox></td>
        <td><label for="volID1"><bean:message key="account.nsview.checkconnection"/></label></td>
    </tr>
</table>
<h3><bean:message key="account.ns.password"/></h3>
<table border="1" class="Vertical">
    <tr>
        <th><bean:message key="account.ns.password" /></th>
        <td><html:password property="_nsviewpassword" size="50" maxlength="50"></html:password></td>
    </tr>
    <tr>
        <th><bean:message key="account.ns.passwordcheck" /></th>
        <td><input type="password" name="_nsviewpasswordcheck" size="50" maxlength="50"></td>
    </tr>
</table>
</html:form>
</body>
</html>