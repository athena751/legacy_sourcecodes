<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: loginnofip.jsp,v 1.3 2007/05/09 05:20:56 liul Exp $" -->

<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<title><bean:message key="myname"/><bean:write name="titleHost"/></title>
<script language="JavaScript">
function windowChange(){
    if(window.opener && window.opener.document){
        window.opener.document.location="<bean:write name="URL" scope="request"/>index.jsp";
        window.close();
    }else{
        window.location="<bean:write name="URL" scope="request"/>framework/loginShow.do";
    }
}
</script>
</head>
<body>
<table border="0">
    <tr>
        <td class="ErrorInfo"><img border=0 src="/nsadmin/images/icon/png/icon_alert.png"></td>
        <td class="ErrorInfo"><bean:message key="error.td_error" bundle="errorDisplay"/>&nbsp;&nbsp;</td>
        <td class="ErrorInfo">
            <bean:message key="login.nofip"/>
        </td>
     </tr>
</table>
<br><font size="3">
<logic:equal name="IPTYPE" value="NORMAL_TOE" scope="request">
    <bean:message key="login.nofip.managerip"/>
</logic:equal>
<logic:equal name="IPTYPE" value="REDUCE_TOE" scope="request">
    <bean:message key="login.nofip.serviceip"/>
</logic:equal>
</font>
<BR><BR>
<font size="4">
<a href="" onclick="windowChange();return false;">
        <bean:write name="URL" scope="request"/></a>
</font>
<br><br><br>
&nbsp;&nbsp;<html:button property="close" onclick="window.close();">
<bean:message key="common.button.close" bundle="common"/>
</html:button>
</body>
</html:html>
