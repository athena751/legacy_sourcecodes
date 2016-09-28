<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: rrdpropertybottom.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-bean"    prefix="bean" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript">
        function changeButtonStatus(){
            if(parent.topframe.loaded == 1){
                document.forms[0].submitButton.disabled = false;
                document.forms[0].resetButton.disabled = false;
            }else{
                document.forms[0].submitButton.disabled = true;
                document.forms[0].resetButton.disabled = true;
            }
        }
        function submitForm(){
            window.parent.topframe.submitModify();
        }
        function resetForm(){
            window.parent.topframe.document.forms[0].reset();
            window.parent.topframe.resetElement();
        }
    </script>
</head>

<body onload="changeButtonStatus();">
<form>
    <input type="button" name="submitButton" onclick="return submitForm();" 
            value='<bean:message key="common.button.submit" bundle="common"/>'>&nbsp;&nbsp;
    <input type="button" name="resetButton" onclick="return resetForm();" 
            value='<bean:message key="common.button.reset" bundle="common"/>' >
</form>
</body>
</html>