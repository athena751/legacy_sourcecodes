<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsframe.jsp,v 1.3 2006/07/10 10:04:43 yangxj Exp $" -->

<html>
<head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
<title></title>
</head>
<frameset rows="40%,*,10%,0,0">
    <frame name="topframe" src="syslog.do?operation=loadCifsTop">
    <frame name="dataframe" src="syslog.do?operation=loadCifsMiddle">
    <frame name="bottomframe" src="loadBottomPage.do">
    <frame name="hiddenframe" src="/nsadmin/common/commonblank.html" frameborder="0" scrolling="no" noresize nofocus>
    <frame name="downloadframe" src="/nsadmin/common/commonblank.html" frameborder="0" scrolling="no" noresize nofocus>
</frameset>
</html>
