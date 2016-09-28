<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation
-->
<!-- "@(#) $Id: ddrpairdetail.jsp,v 1.1 2008/04/19 10:11:18 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
  <head>
    <title><bean:message key="pair.detail.h2"/></title>
    <%@include file="/common/head.jsp" %>
  </head>
  <Frameset rows="*,60">
    <frame name="topframe" src="/nsadmin/ddr/ddrPairDetailTop.do" scrolling="auto"/>
    <frame name="bottomframe" src="/nsadmin/common/commonblank.html" scrolling="no"/>
  </frameset>
</html:html>
