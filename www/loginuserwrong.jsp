<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: loginuserwrong.jsp,v 1.3 2007/05/09 05:22:33 liul Exp $" -->

<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<title><bean:message key="myname"/><bean:write name="titleHost"/></title>
</head>
<body>
<table border="0">
    <tr>
        <td class="ErrorInfo"><img border=0 src="/nsadmin/images/icon/png/icon_alert.png"></td>
        <td class="ErrorInfo"><bean:message key="error.td_error" bundle="errorDisplay"/>&nbsp;&nbsp;</td>
        <td class="ErrorInfo">
			<logic:equal name="USERWRONG" value="PERMISSION" scope="request">
			    <bean:define id="username" name="username" scope="request" type="java.lang.String"/>
			    <bean:message key="login.error.permission" arg0="<%=NSActionUtil.sanitize(username,true)%>"/>
			</logic:equal>
			<logic:equal name="USERWRONG" value="PASSWORD" scope="request">
			    <bean:message key="login.error.passwd"/>
			</logic:equal>
			<logic:equal name="USERWRONG" value="EXISTSESSION" scope="request">
                <bean:message key="login.session.exist"/>
            </logic:equal>
        </td>
     </tr>
</table>
<logic:equal name="USERWRONG" value="EXISTSESSION" scope="request">
<ul>
    <bean:define id="remainder" name="remainder" scope="request" type="java.lang.String"/>
    <li><bean:message key="login.maxsession.relogin.tip" arg0="<%=remainder%>"/><BR>
    <logic:equal name="versionType" value="<%= NSActionConst.VERSION_TYPE_JAPAN%>" scope="request" >
    	<bean:message key="login.maxsession.japan.suggestion" />
    </logic:equal>
    <logic:notEqual name="versionType" value="<%= NSActionConst.VERSION_TYPE_JAPAN%>" scope="request" >
    	<bean:message key="login.maxsession.abroad.suggestion" />
    </logic:notEqual>
    </li>
</ul>
</logic:equal>
<br>
<br>
&nbsp;&nbsp;<html:button property="back" onclick="window.location='/nsadmin/framework/loginShow.do';">
<bean:message key="common.button.back" bundle="common"/>
</html:button>
</body>
</html:html>
