<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: filesystemlist.jsp,v 1.4 2007/05/09 08:09:19 xingyh Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-html" prefix="html"%>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<% 
    String target = (String)request.getParameter("target");
    String targetSession = (String)session.getAttribute("target");
    if(target!=null){
        if( (targetSession==null) || (!target.equals(targetSession)) ) {
            session.setAttribute("clusterMyNum", null);
        }
        session.setAttribute("target", target);
    }
%>
</head>
<Frameset rows="*,60">
	<frame name="topframe" scrolling="auto" src="/nsadmin/filesystem/filesystemListTop.do">
	<frame name="bottomframe" scrolling="no" src="/nsadmin/common/commonblank.html">
</Frameset>
</html:html>