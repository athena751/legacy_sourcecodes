<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nicservicetab.jsp,v 1.5 2007/09/13 01:03:09 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="taglib-nstab" prefix="nstab" %>
<%@ taglib uri="struts-logic" prefix="logic" %>

<html>
<%@include file="../../common/head.jsp" %>
<LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
<SCRIPT language=JavaScript src="../common/tab.js"></SCRIPT>
<body>
<div>
<h1 class="title"><bean:message key="nic.h1.servicenetwork"/></h1>
</div>
<nstab:nstab>
    <nstab:subtab url="nicList.do"><bean:message key="nic.tab.information"/></nstab:subtab>       
<logic:present name="userinfo" >  
   <logic:equal name="userinfo" value="nsadmin">     
    <nstab:subtab url="bondShow.do"><bean:message key="nic.tab.bond"/></nstab:subtab>
    <nstab:subtab url="nicVlan.do"><bean:message key="nic.tab.vlan"/></nstab:subtab> 
    <logic:equal name="machineSeries" value="Procyon" scope="session">
      <nstab:subtab url="nicIPAlias.do"><bean:message key="nic.tab.ipalias"/></nstab:subtab> 
    </logic:equal>
   </logic:equal>   
</logic:present>    
<%
if(NSActionUtil.isCluster(request)) {
%>
<logic:equal name ="<%=NSActionConst.SESSION_USERINFO%>"
    value="<%=NSActionConst.NSUSER_NSADMIN%>" scope="session">
    <nstab:subtab url="linkdownConfigFrame.do">
        <bean:message key="nic.tab.linkdown"/>
    </nstab:subtab> 
</logic:equal>
<logic:equal name ="<%=NSActionConst.SESSION_USERINFO%>"
    value="<%=NSActionConst.NSUSER_NSVIEW%>" scope="session">
    <nstab:subtab url="linkdownConfig.do?operation=getLinkdownInfo4View">
        <bean:message key="nic.tab.linkdown"/>
    </nstab:subtab> 
</logic:equal>
<%}%>
</nstab:nstab>
</body>
</html>
