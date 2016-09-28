<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: surveymodifytop.jsp,v 1.2 2007/04/03 02:24:22 yangxj Exp $" -->

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
    document.forms[0].originalStatus.value=document.forms[0].status.value;
    document.forms[0].originalPeriod.value=document.forms[0].stockPeriod.value;
    document.forms[0].originalInterval.value=document.forms[0].interval.value;
}
function onBack(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    parent.location="surveyframe.do";
    return true;
}
</script>
</head>
<body onload="setframeloadflag();displayAlert();setHelpAnchor('performance_sampling_2_2');" onUnload="closeDetailErrorWin();">
	<input type="button" name="goBack" value="<bean:message key="common.button.back" bundle="common"/>"
		onclick="return onBack()">
    <displayerror:error h1_key="statis.sampling.h1"/>
    <h3 class='title'><bean:message key="statis.sampling.h3_modifysurvey"/> </h3>
    <html:form action="survey.do?operation=surveySet" target="_parent">
    <html:hidden property="id"/>
    <html:hidden property="itemKey" />
    <input type="hidden" name="originalStatus">
    <input type="hidden" name="originalPeriod">
    <input type="hidden" name="originalInterval">
    <table border='1' class='Vertical'>
    <tr><th>
        <bean:message key="statis.sampling.href_item"/>
        </th>
        <td>
        <bean:write name="samplingForm" property="itemKey"/>
        </td>
    </tr>
    <tr><th>
        <bean:message key="statis.sampling.sampling"/>
        </th>
        <td>
        <html:checkbox property="status" value="true" styleId="active"/>
        <label for="active"><bean:message key="statis.sampling.active"/></label>
        </td>
    </tr>
    <tr><th>
        <bean:message key="statis.sampling.period"/>
        </th>
        <td>
        <html:select property="stockPeriod">
            <html:option value="1" key="statis.sampling.period_1"/>
            <html:option value="2" key="statis.sampling.period_2"/>
            <html:option value="3" key="statis.sampling.period_3"/>
            <html:option value="4" key="statis.sampling.period_4"/>
            <html:option value="5" key="statis.sampling.period_5"/>
            <html:option value="6" key="statis.sampling.period_6"/>
            <html:option value="7" key="statis.sampling.period_7"/>
        </html:select>
        <bean:message key="statis.sampling.days"/>
        </td>
    </tr>
    <tr><th>
        <bean:message key="statis.sampling.interval"/>
        </th>
        <td>
        <html:select property="interval">
            <html:option value="1" key="statis.sampling.interval_1"/>
            <html:option value="2" key="statis.sampling.interval_2"/>
            <html:option value="3" key="statis.sampling.interval_3"/>
            <html:option value="4" key="statis.sampling.interval_4"/>
            <html:option value="5" key="statis.sampling.interval_5"/>
        </html:select>
        <bean:message key="statis.sampling.minutes"/>
        </td>
    </table>
    </html:form>
</body>
</html>