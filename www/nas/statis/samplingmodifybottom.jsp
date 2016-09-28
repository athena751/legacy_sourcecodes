<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: samplingmodifybottom.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>

<SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
<SCRIPT language=JavaScript src="../common/validation.js"></SCRIPT>
<script language="javascript">
var bottomLoadFlag=0;
function bottomLoadFinish(){
    bottomLoadFlag=1;
}
function submitModify(){
	if(!parent.sampmodifytop){
		return false;
	}
	if(!parent.sampmodifytop.frameloadflag){
		return false;
	}
    if((parent.sampmodifytop.frameloadflag)!=1){
        return false;
    }
    if(isSubmitted()){
        return false;
    }    
    var str=trim(parent.sampmodifytop.document.forms[0].stockPeriod.value);
    if(!isValidDigit(str,1,366)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>"+"\r\n"
            +"<bean:message key="statis.sampling.perioderror_alert"/>");
        parent.sampmodifytop.document.forms[0].stockPeriod.select();
        return false;
    }
    str=parseInt(str,10);
    parent.sampmodifytop.document.forms[0].stockPeriod.value=str;
    if(!confirm("<bean:message key="common.confirm" bundle="common"/>"+"\r\n"
                +"<bean:message key="common.confirm.action" bundle="common"/>"
                +"<bean:message key="common.button.submit" bundle="common"/>")){
        return false;
    }        
    setSubmitted();
    parent.sampmodifytop.document.forms[0].action="sampling.do?operation=changePeriod";
    parent.sampmodifytop.document.forms[0].submit();
}
</script>
</head>
<body onload="bottomLoadFinish();">
<form>
    <html:button property="submit" onclick="submitModify()">
    <bean:message key="common.button.submit" bundle="common"/>
    </html:button>
</form>
</html>