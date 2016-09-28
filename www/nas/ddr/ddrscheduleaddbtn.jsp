<!--
        Copyright (c) 2008 NEC Corporation
        NEC SOURCE CODE PROPRIETARY
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) ddrscheduleaddbtn.jsp,v 1.1 2004/08/24 09:49:51 liy Exp" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
</head>
<body>
<form>
<input type="button" name="previous" value="<bean:message key="ddr.button.previous"/>" onclick="parent.bottomframe.backToAdd();"/>
<input type="button" name="next"  value="<bean:message key="ddr.button.next"/>" onclick="parent.bottomframe.onAddSchedule();"/>
</form>
</body>
</html>