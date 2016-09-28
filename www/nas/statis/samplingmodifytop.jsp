<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: samplingmodifytop.jsp,v 1.2 2007/04/03 02:24:22 yangxj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>

<SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
<script language="javascript">
var frameloadflag=0;
function setframeloadflag(){
    frameloadflag=1;
    document.forms[0].originalPeriod.value=document.forms[0].stockPeriod.value;
}
function onBack(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    parent.location="samplingframe.do";
    return true;
}
function onTopSubmit(){
    if(!parent.sampmodifybottom){
        return false;
    }
    if(!parent.sampmodifybottom.bottomLoadFlag){
        return false;
    }
    if((parent.sampmodifybottom.bottomLoadFlag)!=1){
        return false;
    }
    return parent.sampmodifybottom.submitModify();
}
</script>
</head>
<body onload="setframeloadflag();displayAlert();setHelpAnchor('performance_sampling_1_2');" onUnload="closeDetailErrorWin();">
	<input type="button" name="goBack" value="<bean:message key="common.button.back" bundle="common"/>"
		onclick="return onBack()">
    <displayerror:error h1_key="statis.sampling.h1"/>
    <h3 class='title'><bean:message key="statis.sampling.h3_modifysampling"/> </h3>
    <html:form action="sampling.do" target="_parent" onsubmit="return onTopSubmit();">
    	<html:hidden property="id"/>
	    <html:hidden property="itemKey" />
	    <input type="hidden" name="originalPeriod">
	    <table border='1' class='Vertical'>
		    <tr><th>
		        <bean:message key="statis.sampling.href_item"/>
		        </th>
		        <td>
		        <bean:write name="samplingForm" property="itemKey"/>
		        </td>
		    </tr>
		    <tr><th>
		        <bean:message key="statis.sampling.period"/>
		        </th>
		        <td>
		        <html:text property="stockPeriod" maxlength="3" size="4"/>
		        <bean:message key="statis.sampling.days"/>
		        </td>
		    </tr>
	    </table>
    </html:form>
</body>
</html>