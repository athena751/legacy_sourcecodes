<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: gfsview4nsview.jsp,v 1.2 2005/11/22 04:51:16 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-bean"        prefix="bean" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript">
        function onReload(){
            window.location="gfsView4Nsview.do?operation=display";
        }
    </script>
</head>

<body onload="displayAlert();setHelpAnchor('volume_gfs');" onUnload="closeDetailErrorWin();">

<input type="button" name="reload" onclick="onReload();"
        value='<bean:message key="common.button.reload" bundle="common"/>' ><br>
<displayerror:error h1_key="gfs.common.h1"/><br>

<textarea name="myNodeFile" rows="20" style='width:100%;' readonly="true"><bean:write name="myNodeContent" scope="session"/></textarea>

</body>
</html>
