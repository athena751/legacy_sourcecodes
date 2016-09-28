<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: gfseditbottom.jsp,v 1.1 2005/11/04 01:23:48 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-bean"    prefix="bean" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript">
        function submitProcess(){
            if(isSubmitted() ){
                return false;
            }
            if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
                        '<bean:message key="common.confirm.action" bundle="common"/>'+
                        '<bean:message key="common.button.submit" bundle="common"/>')){
                return false;
            }
            setSubmitted();
            parent.topframe.document.forms[0].submit();
            return true;
        }
        function resetForm(){
            parent.topframe.document.forms[0].reset();
        }
    </script>
</head>

<body>
<form method="post">
    <input type="button" name="set" onclick="return submitProcess();" 
            value='<bean:message key="common.button.submit" bundle="common"/>' >&nbsp;&nbsp;
    <input type="button"  name="res" onclick="resetForm();" 
            value='<bean:message key="common.button.reset" bundle="common"/>'>
</form>
</body>
</html>
