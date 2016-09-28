<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: dirquotadatasetmain.jsp,v 1.2304 2006/02/20 00:35:05 zhangjun Exp $" -->
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%
    String nextAction = request.getParameter("nextAction");
    String action = request.getParameter("action");
    String target = request.getParameter(NasConstants.TARGET);
    String hasAlert = request.getParameter("hasAlert");
    if(target != null){
        session.setAttribute(NasConstants.TARGET, target);
    }
%>
<html> 
<head>
<%  if(hasAlert != null){
        if(hasAlert.trim().equals("yes")){
%>
            <script language="JavaScript">
            alert("<nsgui:message key="common/alert/done"/>");
            </script>
<%            
        }
    }
%>
</head> 
<%
String browserInfo = (String)session.getAttribute(NSConstant.SESSION_BROWSER);
boolean isns = browserInfo.startsWith(NSConstant.BROWER_NS47);

if(isns) {
%>
 <frameset rows="41%,*,10%" frameborder="NO" border="0" framespacing="0">
 
<%
} else {
%>
 <frameset rows="41%,*,10%"> 
<%
}
%>
 <%if(action==null || action.equals("")){%>
    <frame name="topframe" src="dirquotamountpoint.jsp?nextAction=<%=nextAction%>">
 <%}else{%>
    <frame name="topframe" src="dirquotamountpoint.jsp?nextAction=<%=nextAction%>&action=<%=action%>">
 <%}%>
    <frame name="middleframe" src="../../fcsan/common/blank.jsp">
    <frame name="bottomframe" src="../../fcsan/common/blank.jsp">
</frameset><noframes></noframes>
</html>