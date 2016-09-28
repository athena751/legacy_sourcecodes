<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: systemsetbottom.jsp,v 1.1 2005/08/21 04:49:28 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-bean"    prefix="bean" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript">
        function submitProcess(){
            if( parent.topframe.submitModify() ){
                parent.topframe.document.forms[0].submit();
            }
        }
        function changeButtonStatus(){
            if(parent.topframe.buttonEnable == 1){
                document.forms[0].set.disabled = false;
                document.forms[0].res.disabled = false;
            }else{
                document.forms[0].set.disabled = true;
                document.forms[0].res.disabled = true;
            }
        }
        function resetForm(){
            parent.topframe.document.forms[0].reset();
        }
    </script>
</head>

<body onload="changeButtonStatus();">
<form>
    <input type="button" name="set" onclick="return submitProcess();" 
            value='<bean:message key="common.button.submit" bundle="common"/>' >&nbsp;&nbsp;
    <input type="button"  name="res" onclick="resetForm();" 
            value='<bean:message key="common.button.reset" bundle="common"/>'>
</form>
</body>
</html>