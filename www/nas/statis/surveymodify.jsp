<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: surveymodify.jsp,v 1.2 2007/09/12 11:41:28 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
</head>
    <frameset rows="*,60" border="1">
        <frame name="surveymodifytop" src="survey.do?operation=modifytopInit&itemKey=<bean:write property="itemKey" name="samplingForm"/>&status=<bean:write property="status" name="samplingForm"/>&interval=<bean:write property="interval" name="samplingForm"/>&stockPeriod=<bean:write property="stockPeriod" name="samplingForm"/>&id=<bean:write property="id" name="samplingForm"/>">
        <frame name="surveymodifybottom" src="surveymodifybottom.do" class="TabBottomFrame">
    </frameset>
</html>