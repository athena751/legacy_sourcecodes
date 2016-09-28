<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: snapshotforward.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean"    prefix="bean" %>

<html>
	<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
	<Frameset rows="83,*">
	    <frame name="topframe" scrolling="no" frameborder="0"
	           src="snapshotTop.do?watchItemDesc=<bean:write name="watchItemDesc" scope="request"/>&defaultGraphType=<bean:write name="defaultGraphType" scope="request"/>">
	    <frame name="bottomframe" scrolling="auto" frameborder="0" src="/nsadmin/common/commonblank.html">
	</Frameset>
</html>