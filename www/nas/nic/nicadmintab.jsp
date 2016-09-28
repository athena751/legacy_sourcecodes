<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nicadmintab.jsp,v 1.1 2005/10/24 04:40:02 dengyp Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="taglib-nstab" prefix="nstab" %>
<%@ taglib uri="struts-logic" prefix="logic" %>

<html>
<%@include file="../../common/head.jsp" %>
<LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
<SCRIPT language=JavaScript src="../common/tab.js"></SCRIPT>
<body>
<div>
<h1 class="title"><bean:message key="nic.h1.adminnetwork"/></h1>
</div>
<nstab:nstab>    
    <nstab:subtab url="adminList.do"><bean:message key="nic.tab.information"/></nstab:subtab>     
</nstab:nstab>
</body>
</html>
