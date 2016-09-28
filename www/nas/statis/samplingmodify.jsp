<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: samplingmodify.jsp,v 1.2 2007/09/12 11:40:03 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
</head>
    <frameset rows="*,60" border="1">
        <frame name="sampmodifytop" src="sampling.do?operation=modifytopInit&itemKey=<bean:write name="samplingForm" property="itemKey"/>&stockPeriod=<bean:write name="samplingForm" property="stockPeriod"/>&id=<bean:write name="samplingForm" property="id"/>">
        <frame name="sampmodifybottom" src="samplingmodifybottom.do" class="TabBottomFrame">
    </frameset>
</html>