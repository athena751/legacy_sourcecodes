<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: heartbeatfinish.jsp,v 1.2 2008/05/16 11:48:48 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="struts-logic" prefix="logic" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta HTTP-EQUIV="Refresh" CONTENT="2">
    <script language="javascript">
    <%
    	String downloadWinKey = (String) request.getParameter("downloadWinKey");
		String flag_download_ended = "statis_download_ended"+downloadWinKey;
	%>
    function pageLoad(){
        <logic:equal name="<%=flag_download_ended%>" scope="session" value="yes">
            parent.close();
        </logic:equal>
        return true;
    }
    </script>
</head>
<body onload="pageLoad();"></body>
</html>
