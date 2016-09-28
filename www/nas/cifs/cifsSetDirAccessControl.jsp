<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsSetDirAccessControl.jsp,v 1.5 2005/06/23 01:46:05 key Exp $" -->
<%@include file="../../common/head.jsp" %>
<%@ page import="com.nec.nsgui.model.entity.cifs.DirAccessControlInfoBean" %>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst" %>
<html>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
<%
   String operationType = request.getParameter("operationType");
   session.setAttribute(CifsActionConst.SESSION_SET_DIR_OPERATION,operationType);
   if (operationType != null && operationType.equals("modify")){
	   DirAccessControlInfoBean dirAccessInfo = new DirAccessControlInfoBean();
	   dirAccessInfo.setDirectory(request.getParameter("directory"));
	   dirAccessInfo.setAllowHost(request.getParameter("allowHost"));
	   dirAccessInfo.setDenyHost(request.getParameter("denyHost"));	
	   session.setAttribute(CifsActionConst.SESSION_SET_DIR_INFO,dirAccessInfo);
	}
%>
<Frameset rows="*,60" border="1" >
<frame name="dir_topframe" src="dirAccessControl.do?operation=displaySettingPage" border="0" >
<frame name="dir_bottomframe" src="loadSetDirAccessControlBottom.do" class="TabBottomFrame">
</Frameset>

</html>
