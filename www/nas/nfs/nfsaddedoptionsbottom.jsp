<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfsaddedoptionsbottom.jsp,v 1.1 2005/11/21 01:22:30 liul Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html>
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript">
var loaded=0;
function submitTopFrame() {
    if(parent.frames[0] && parent.frames[0].loaded){
        if(parent.frames[0].setSubmit()){
            document.forms[0].optionset.disabled=true;
            return true;
        }
        return false;
    }else{
        return false;
    } 
}
function  init(){
    loaded=1;
}
</script>
</head>
<body onload="init();">
<form>
<input type="button" name="optionset" disabled="true"
             onclick="submitTopFrame()" 
             value="<bean:message key="common.button.submit" bundle="common"/>"/>
</form>
</body>
</html>