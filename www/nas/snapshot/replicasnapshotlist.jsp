<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation
-->
<!-- "@(#) $Id: replicasnapshotlist.jsp,v 1.1 2008/05/28 02:14:46 lil Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
  <head>
    <%@ include file="/common/head.jsp" %>
  </head>
  <Frameset rows="*,60">
    <frame name="topframe" src="/nsadmin/snapshot/replicaSnapshotListTop.do" scrolling="auto">
    <frame name="bottomframe" src="/nsadmin/common/commonblank.html" scrolling="no">
  </frameset>
</html:html>