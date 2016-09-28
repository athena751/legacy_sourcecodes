<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nasswitchgraphbottom.jsp,v 1.3 2005/10/19 10:57:09 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst"%>
<html>
<head>
</head>
<bean:define id="graphType" value="" type="java.lang.String"/>
<logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Virtual_Export%>">
<bean:define id="graphType" name="graphType" type="java.lang.String"/>
</logic:equal>
<logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Server%>">
<bean:define id="graphType" name="graphType" type="java.lang.String"/>
</logic:equal>
<logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Node%>">
<bean:parameter id="graphType" name="graphType"/>
</logic:equal>
<frameset rows="*,0">
    <frame name="contentframe"  scrolling="auto" frameborder="0" src="nasSwitchGraph.do?operation=displayGraph&graphType=<%=graphType%>">
    <frame name="hideframe" src="../nas/statis/rrdwindow.jsp" scrolling="no" frameborder="0">
</frameset>


</html>