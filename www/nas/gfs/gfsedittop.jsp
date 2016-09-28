<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: gfsedittop.jsp,v 1.2 2005/11/22 02:13:52 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="struts-html"        prefix="html" %>
<%@ taglib uri="struts-bean"        prefix="bean" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript">
        function init(){
            parent.bottomframe.location="gfsEditBottom.do";
            document.forms[0].elements["fileInfo"].focus();
        }
    </script>
</head>

<body onload="init();displayAlert();setHelpAnchor('volume_gfs');" onUnload="closeDetailErrorWin();">

<displayerror:error h1_key="gfs.common.h1"/>

<html:form action="gfsEdit.do?operation=modify" target="_parent">
    <html:textarea property="fileInfo" rows="20" style='width:100%;'/>
</html:form>

</body>
</html>
