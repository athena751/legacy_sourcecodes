<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: navigatorlist.jsp,v 1.1 2005/08/21 04:49:28 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-bean"    prefix="bean" %>
<%@ taglib uri="struts-logic"   prefix="logic"%>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript">
        function chooseSource(sourceName){
            if(parent.frames[1].loaded){
                parent.bottomframe.document.forms[0].selectedSource.value = sourceName;
            }
        }
    </script>
</head>

<body>

<h1 class="popup">
    <bean:message key="snmp.common.h1" />
</h1>
<h2 class="popup">
    <bean:message key="snmp.community.th_source" />
</h2>

<bean:size id="sourceSize" name="navigatorList"/>

<logic:equal name="sourceSize" value="0">
    <bean:message key="snmp.community.navigator.noSourceList"/>
</logic:equal>

<logic:notEqual name="sourceSize" value="0">
    <table border="1"  class="Vertical">
        <tr>
            <th align="left"><bean:message key="snmp.community.th_source"/></th>
        </tr>
        <logic:iterate id="source" name="navigatorList">
            <tr><td>
                <a href="#" onclick="chooseSource('<%=source%>'); return false"><%=source%></a>
            </td></tr>
        </logic:iterate>
    </table>
</logic:notEqual>

</body>
</html>