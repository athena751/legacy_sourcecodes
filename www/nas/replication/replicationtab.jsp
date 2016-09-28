<!--
        Copyright (c) 2005-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: replicationtab.jsp,v 1.5 2006/05/16 10:17:25 xingh Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="taglib-nstab" prefix="nstab"%>
<html>
<%@ include file="../../common/head.jsp"%>
<LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
<SCRIPT language=JavaScript src="../common/tab.js"></SCRIPT>
<bean:define id="module" name="module" scope="session" type="java.lang.String"/>
<bean:define id="tabNo" value="<%=(module.equals("replica")) ? "1" : "0"%>"/>

<body>
<div class="h1"><h1 class="title"><bean:message key="replicate.h1"/></h1></div>
<nstab:nstab displayonload="<%=tabNo%>">
    <nstab:subtab url="originalAction.do?operation=list" enableExportGroup="enable">
    	<bean:message key="tab.original"/>
  	</nstab:subtab>
    <nstab:subtab url="replicaList.do?operation=display" enableExportGroup="enable">
    	<bean:message key="tab.replica"/>
    </nstab:subtab>
    <nstab:subtab url="ssl.do?operation=display" enableExportGroup="disable">
    	<bean:message key="tab.ssl"/>
    </nstab:subtab>
</nstab:nstab>
</body>
</html>
