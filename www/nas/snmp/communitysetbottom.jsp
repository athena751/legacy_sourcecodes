<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: communitysetbottom.jsp,v 1.1 2005/08/21 04:49:28 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-bean"    prefix="bean" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript">
        function submitForm(){
            if( parent.topframe.submitProcess() ){
                parent.topframe.document.forms[0].submit();
                return true;
            }
            return false;
        }
        function changeButtonStatus(){
            if(parent.topframe.buttonEnable == 1){
                document.forms[0].set.disabled = false;
            }else{
                document.forms[0].set.disabled = true;
            }
        }
    </script>
</head>

<body onload="changeButtonStatus();">
<form>
    <input type="button" name="set" onclick="return submitForm();" 
            value='<bean:message key="common.button.submit" bundle="common"/>' >&nbsp;&nbsp;
</form>
</body>
</html>