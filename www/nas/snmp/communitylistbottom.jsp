<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: communitylistbottom.jsp,v 1.1 2005/08/21 04:49:28 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>

<html>
<head>
    <title><bean:message key="snmp.common.h1"/></title>
    <%@include file="../../common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="javascript">
        var loaded = 0;
        function init() {
            loaded = 1;
            if(parent.frames[0].stateFlag) {
                document.forms[0].modifyCommunity.disabled=false;
                document.forms[0].deleteCommunity.disabled=false;
            }
        }
        function onModify() {
            if(isSubmitted()){
                return false;
            }
            parent.frames[0].setSelectedComValue();
            setSubmitted();
            parent.frames[0].document.forms[0].action="community.do?operation=displaySetFrame";
            parent.frames[0].document.forms[0].submit();
            return true;
        }
        function onDelete() {
            if(isSubmitted()){
                return false;
            }
            parent.frames[0].setSelectedComValue();
            if(!confirm('<bean:message key="common.confirm"         bundle="common"/>\r\n'+
                        '<bean:message key="common.confirm.action"  bundle="common"/>'+
                        '<bean:message key="common.button.delete"   bundle="common"/>\r\n'+
                        '<bean:message key="snmp.community.alert.deleteCommunity"/>'+
                        parent.frames[0].document.forms[0].selectedCom.value)){
                return false;
            }
            setSubmitted();
            parent.frames[0].document.forms[0].action="community.do?operation=delete&isForced=false";
            parent.frames[0].document.forms[0].submit();
            parent.frames[0].document.forms[0].selectedCom.value="";
            return true;
        }
    </script>
</head>

<body onload="init()">
<form method="post">
    <html:button property="modifyCommunity" disabled="true" onclick="return onModify();">
        <bean:message key="common.button.modify2" bundle="common"/>
    </html:button>&nbsp;&nbsp;
    <html:button property="deleteCommunity" disabled="true" onclick="return onDelete();">
        <bean:message key="common.button.delete"  bundle="common"/>
    </html:button>
</form>
</body>
</html>