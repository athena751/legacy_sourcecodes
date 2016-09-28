<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: volumelist.jsp,v 1.6 2007/05/09 05:20:13 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

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
<Frameset rows="*,60" >
    <logic:equal name="userinfo" value="nsadmin" scope="session">
	   <frame name="middleframe" src="/nsadmin/volume/volumeListMiddle.do">
	</logic:equal>
	<logic:equal name="userinfo" value="nsview" scope="session">
       <frame name="middleframe" src="/nsadmin/volume/volumeListMiddle4Nsview.do">
    </logic:equal>
	<frame name="bottomframe" scrolling="no" src="/nsadmin/common/commonblank.html">
</Frameset>
</html:html>