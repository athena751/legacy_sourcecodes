<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: hideframe.jsp,v 1.4 2005/10/19 10:57:09 zhangj Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<html>
<head>
</head>


<frameset rows="*,0">
    <frame name="contentframe"  src="rrdgraph.do?operation=displayList" scrolling="auto" frameborder="0" noresize>
    <frame name="hideframe" src="../nas/statis/rrdwindow.jsp" scrolling="auto" frameborder="0">
</frameset>


</html>
