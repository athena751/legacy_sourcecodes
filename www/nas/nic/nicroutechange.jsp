<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicroutechange.jsp,v 1.2 2005/10/24 04:40:50 dengyp Exp $" -->

<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
</head>
<frameset rows="*,60"   border=1>
   <frame name="nicroutechangetop"    src="dispRouteChange.do?Operation=LoadRouteChangeTop" border=0 >
   <frame name="nicroutechangebottom"    src="routeChangeBottom.do" 
           class="TabBottomFrame" >
</frameset>
</html>
