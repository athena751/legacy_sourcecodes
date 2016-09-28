<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: userlistbottom.jsp,v 1.2 2005/08/25 01:36:52 zhangj Exp $" -->

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
                document.forms[0].modifyUser.disabled=false;
                document.forms[0].deleteUser.disabled=false;
            }
        }
        function onModify() {
            if (isSubmitted()){
                return false;
            }
            parent.frames[0].setSelectedUserValue();
            setSubmitted();
            parent.frames[0].document.forms[0].action="user.do?operation=displaySetFrame";
            parent.frames[0].document.forms[0].submit();
            return true;
        }
        
        function onDelete() {
            if (isSubmitted()){
                return false;
            }
            parent.frames[0].setSelectedUserValue();
            if(!confirm('<bean:message key="common.confirm"         bundle="common"/>\r\n'+
                        '<bean:message key="common.confirm.action"  bundle="common"/>'+
                        '<bean:message key="common.button.delete"   bundle="common"/>\r\n'+
                        '<bean:message key="snmp.user.alert.deleteUser"/>'+
                        parent.frames[0].document.forms[0].selectedUser.value)){
                return false;
            }
            setSubmitted();  
            parent.frames[0].document.forms[0].action="user.do?operation=delete";
            parent.frames[0].document.forms[0].submit();
            parent.frames[0].document.forms[0].selectedUser.value="";
            return true;
        }
    </script>
</head> 

<body onload="init()">
    <form method="post">
        <html:button property="modifyUser" disabled="true" onclick="return onModify();"><bean:message key="common.button.modify2" bundle="common"/></html:button>&nbsp;&nbsp;
        <html:button property="deleteUser" disabled="true" onclick="return onDelete();"><bean:message key="common.button.delete"  bundle="common"/></html:button>
    </form>
</body>
</html>