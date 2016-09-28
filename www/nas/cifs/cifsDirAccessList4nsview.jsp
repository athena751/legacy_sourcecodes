<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsDirAccessList4nsview.jsp,v 1.2 2005/09/08 00:34:03 key Exp $" -->
<%@include file="../../common/head.jsp" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<html>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
<head>
<title><bean:message key="cifs.dirAccess_list.settingTitle_4nsview"/></title>
</head>
<Frameset rows="*,60" border="1" >
<frame name="dirAccess_topframe" src="dirAccessControl4nsview.do?operation=loadTop4nsview" border="0" >
<frame name="dirAccess_bottomframe" src="dirAccessControl4nsview.do?operation=loadBottom" class="TabBottomFrame">
</Frameset>

</html>
