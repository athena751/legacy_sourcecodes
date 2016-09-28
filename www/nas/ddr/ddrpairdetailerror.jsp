<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ddrpairdetailerror.jsp,v 1.2 2008/04/20 07:25:35 lil Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html:html lang="true">
  <head>
    <title><bean:message key="pair.detail.h2"/></title>
    <%@include file="/common/head.jsp" %>
    <script language="JavaScript" src="/nsadmin/common/common.js"></script>
  </head>
  <body onload="setHelpAnchor('disk_backup_2');" onUnload="closeDetailErrorWin();">
    <h1 class="title"><bean:message key="ddr.h1"/></h1>
    <h2 class="title"><bean:message key="pair.detail.h2"/></h2>

    <displayerror:error h1_key="ddr.h1"/><br><br><br>
    <hr size=1>
    <center>
      <html:button property="closeBtn" onclick="window.close();">
        <bean:message key="common.button.close" bundle="common"/>
      </html:button>
    </center>
  </body>
</html:html>
