<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: poolselect.jsp,v 1.5 2008/05/30 02:55:54 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"  prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"  prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<bean:parameter id="from" name="from" value="volumeCreate"/>
<%String title = "title.h1"; //from volume
  if (from.equals("replication")) {
  	title = "replication.h1";
  } else if (from.startsWith("ddr")) {
  	title = "ddr.h1";
  }
%>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<title><bean:message key="<%=title%>"/></title>
</head> 
<logic:notEmpty name="diskArrayVector" scope="session">
<bean:define id="aid" name="diskArrayInfoForm" property="aid" scope="request"/>
<bean:define id="raidType" name="diskArrayInfoForm" property="raidType" scope="request"/>
<bean:define id="poolnameno" name="poolnameno" scope="session"/>

<Frameset rows="152,*,60">
    <frame name="topframe"    src="/nsadmin/volume/poolSelectTop.do?from=<bean:write name="from"/>" scrolling="no">
    <frame name="middleframe" src="/nsadmin/framework/moduleForward.do?msgKey=apply.volume.volume.forward.to.pool.choose&doNotLock=yes&doNotClear=yes&url=/nsadmin/volume/poolSelectMiddle.do?from=<bean:write name="from"/>&aid=<%=aid%>&raidType=<%=raidType%>&poolnameno=<%=poolnameno%>" scrolling="auto">
    <frame name="bottomframe" src="/nsadmin/volume/poolSelectBottom.do" scrolling="no">
</frameset>
</logic:notEmpty>

<logic:empty name="diskArrayVector" scope="session">
<Frameset rows="*,60">
    <frame name="topframe"    src="/nsadmin/volume/poolNoDiskArray.do?from=<bean:write name="from"/>" scrolling="no">
    <frame name="bottomframe" src="/nsadmin/volume/volumeClosePage.do" scrolling="no">
</frameset>
</logic:empty>
</html:html>