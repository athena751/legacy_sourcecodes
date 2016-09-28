<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: survey.jsp,v 1.2 2007/09/12 11:40:45 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
</head>
    <frameset rows="*,60" border="1">
        <frame name="survey" src="survey.do?operation=init">
        <frame name="surveymodify" src="surveybottom.do" class="TabBottomFrame">
    </frameset>
</html>