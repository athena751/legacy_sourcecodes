<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ndmptab.jsp,v 1.3 2006/12/26 02:34:29 wanghui Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="taglib-nstab" prefix="nstab" %>
<html>
<%@include file="../../common/head.jsp" %>
<LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
<SCRIPT language=JavaScript src="../common/tab.js"></SCRIPT>
<body>
<div class="h1">
<h1 class="title"><bean:message key="ndmp.common.h1"/></h1>
</div>
<nstab:nstab>
<nstab:subtab url="ndmpSessionAction.do?operation=entrySessionInfo"><bean:message key="ndmp.tab.session"/></nstab:subtab>
<nstab:subtab url="ndmpConfig.do?operation=getNdmpConfigInfo"><bean:message key="ndmp.tab.configInfo"/></nstab:subtab>
<logic:equal name="<%= NSActionConst.SESSION_USERINFO %>"
	value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
    <nstab:subtab url="ndmpConfigFrame.do"><bean:message key="ndmp.tab.setting"/></nstab:subtab>
</logic:equal>
<nstab:subtab url="ndmpManage.do?operation=getStatus"><bean:message key="ndmp.tab.manage"/></nstab:subtab>
<nstab:subtab url="ndmpDevice.do?operation=entryDeviceInfo"><bean:message key="ndmp.tab.device"/></nstab:subtab>
</nstab:nstab>
</body>
</html>
