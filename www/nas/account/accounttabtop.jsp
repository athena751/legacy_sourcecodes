<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: accounttabtop.jsp,v 1.2 2005/10/19 01:19:19 fengmh Exp $" -->
<%@ page session="true"%>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="taglib-nstab" prefix="nstab"%>

<html>
<%@include file="../../common/head.jsp"%>
<LINK href="<%=request.getContextPath()%>/skin/default/tab.css"
	type=text/css rel=stylesheet><script language=JavaScript
	src="../common/tab.js"></script>
<body>
<div class="h1">
<h1 class="title"><bean:message key="account.common.h1" /></h1>
</div>
<logic:equal name="<%= NSActionConst.SESSION_USERINFO %>"
	value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
	<nstab:nstab>
		<nstab:subtab url="accountTablist.do">
			<bean:message key="account.tab.list" />
		</nstab:subtab>
		<nstab:subtab url="accountTabnsadmin.do">
			<bean:message key="account.tab.nsadmin" />
		</nstab:subtab>
		<nstab:subtab url="accountTabnsview.do">
			<bean:message key="account.tab.nsview" />
		</nstab:subtab>
		<nstab:subtab url="enterTimeout.do">
			<bean:message key="account.tab.timeout" />
		</nstab:subtab>
	</nstab:nstab>
</logic:equal>
<logic:equal name="<%= NSActionConst.SESSION_USERINFO %>"
	value="<%= NSActionConst.NSUSER_NSVIEW %>" scope="session">
	<nstab:nstab>
		<nstab:subtab url="accountTablistTop.do?operation=list">
			<bean:message key="account.tab.list" />
		</nstab:subtab>
	</nstab:nstab>
</logic:equal>
</body>
</html>
