<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation
-->
<!-- "@(#) $Id: closepage.jsp,v 1.1 2008/04/19 10:11:18 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
  <head>
    <%@include file="/common/head.jsp" %>
  </head>
  <body>
    <center>
      <html:button property="closeBtn" onclick="parent.close();">
        <bean:message key="common.button.close" bundle="common"/>
      </html:button>
    </center>
  </body>
</html:html>
