<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ddrpairlisterror.jsp,v 1.3 2008/05/15 11:36:54 pizb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>

<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html:html>
<head>
<%@ include file="/common/head.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<%@ include file="ddrcommon.jsp"%>

</head>
<body onUnload="unLockMenu();closeDetailErrorWin();">

<html:button property="reloadBtn" onclick="return loadDdrPairList();">
		<bean:message key="common.button.reload" bundle="common" />
    </html:button>
<br><br>
<displayerror:error h1_key="ddr.h1"/>
</body>
</html:html>
