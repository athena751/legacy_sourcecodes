<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: systemframe.jsp,v 1.3 2006/07/10 10:04:43 yangxj Exp $" -->

<html>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">

<Frameset rows="90%,10%,0,0">
    <frame name="dataframe" src="syslog.do?operation=loadSystemTop">
    <frame name="bottomframe" src="loadBottomPage.do">
    <frame name="hiddenframe" src="/nsadmin/common/commonblank.html" frameborder="0" scrolling="no" noresize nofocus>
    <frame name="downloadframe" src="/nsadmin/common/commonblank.html" frameborder="0" scrolling="no" noresize nofocus>
</Frameset>

</html>
