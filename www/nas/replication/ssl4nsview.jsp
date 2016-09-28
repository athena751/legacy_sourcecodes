<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ssl4nsview.jsp,v 1.5 2007/05/09 05:01:15 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<%@ include file="replicationcommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
</head>
<body onload="setHelpAnchor('replication_10');">

<html:button property="reloadBtn" onclick="return loadSsl();">
    <bean:message key="common.button.reload" bundle="common"/>
</html:button>

<br><br>
<html:form action="ssl.do?operation=display">
    <table border="1">
        <tr>
            <td>
				<logic:equal name="sslInfoForm" property="sslStatus" value="on"> 
                	<bean:message key="nsview.info.ssl.on"/>
                </logic:equal>
				<logic:notEqual name="sslInfoForm" property="sslStatus" value="on"> 
                	<bean:message key="nsview.info.ssl.off"/>
                </logic:notEqual>                                 	
            </td>
        </tr>
    </table> 
</html:form>
</body>
</html:html>