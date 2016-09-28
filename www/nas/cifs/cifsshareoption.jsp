<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsshareoption.jsp,v 1.16 2005/06/23 01:44:18 key Exp $" -->
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst" %>
<%@include file="../../common/head.jsp" %>

<html>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
<%
String action = (String)request.getParameter("shareAction");
String name = (String)request.getParameter("shareName");
session.setAttribute(CifsActionConst.SESSION_ACTION_FOR_SHARE_OPTION,action);
if(action != null && action.equals("modify")){
	session.setAttribute(CifsActionConst.SESSION_SHARE_NAME_FOR_MODIFY,name);
}
%>
<Frameset rows="*,60" border="1" >
<frame name="shareOption_topframe" src="setShare.do?operation=loadTop" border="0" >
<frame name="shareOption_bottomframe" src="loadSetShareBottom.do" class="TabBottomFrame">
</Frameset>

</html>
