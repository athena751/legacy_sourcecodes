<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: snmpinfolist.jsp,v 1.2 2005/10/25 08:16:53 cuihw Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>

<html>
<head>
	<title><bean:message key="snmp.common.h1"/></title>
	<%@include file="../../common/head.jsp" %>
	<script language="JavaScript" src="../common/common.js"></script>
    <script language="javascript">	
	        function onRefresh() {
            if(isSubmitted()){
                return false;
            }
            setSubmitted();
            window.location="<html:rewrite page='/snmpInfoList.do?operation=displayList'/>";
            return true;
       }
    </script>
</head>

<body onload="displayAlert();setHelpAnchor('system_snmp_1');" onUnload="closeDetailErrorWin()">

<displayerror:error h1_key="snmp.common.h1"/>
<form method="post">
<html:button property="refreshInfo" onclick="return onRefresh();">
    <bean:message key="common.button.reload" bundle="common"/>
</html:button>
</form>
	<%@include file="snmpcommoninfolist.jsp" %>
</body>
</html>