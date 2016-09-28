<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: schedulescancomputersetbottom.jsp,v 1.2 2008/05/14 08:09:38 chenjc Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript">

function changeButtonStatus(){
    if(parent.frames[0].document &&
       parent.frames[0].document.forms["ComputerForm"]) {
        document.forms[0].setButton.disabled=false;
    }else{
        document.forms[0].setButton.disabled=true;
    }
}

function onSubmit(){
    if(window.parent.frames[0].document && window.parent.frames[0].document.forms[0]) {
        if(parent.frames[0].submitSet()){
            document.forms[0].setButton.disabled=true;
            return true;
        }
    }
    return false;
}
</script>
</head>

<body onload="changeButtonStatus();">
<form>
<input type="button" name="setButton"
       onclick="onSubmit();"
       value="<bean:message key="common.button.submit" bundle="common"/>" 
       disabled="true" />

</form>
</body>
</html>