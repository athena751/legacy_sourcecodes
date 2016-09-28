<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfsframe.jsp,v 1.4 2006/07/04 09:08:57 yangxj Exp $" -->

<html>
<head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
<title></title>
</head>
<frameset rows="36%,*,8%,0,0">
    <frame name="topframe" src="syslog.do?operation=loadNfsTop">
    <frame name="dataframe" src="syslog.do?operation=loadNfsMiddle">
    <frame name="bottomframe" src="loadBottomPage.do">
    <frame name="downloadframe" src="/nsadmin/common/commonblank.html" frameborder="0" scrolling="no" noresize nofocus>
    <frame name="hiddenframe" src="/nsadmin/common/commonblank.html" frameborder="0" scrolling="no" noresize nofocus>
</frameset>
</html>