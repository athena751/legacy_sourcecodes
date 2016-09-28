<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsTop4nsview.jsp,v 1.8 2007/05/09 06:04:19 chenbc Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="taglib-nstab" prefix="nstab" %>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst" %>
<html>
<%@include file="../../common/head.jsp" %>
<LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
<SCRIPT language=JavaScript src="../common/tab.js"></SCRIPT>
<body>
<div class="h1">
<h1 class="title"><bean:message key="cifs.common.h1"/></h1>
<p class="domain"><bean:message key="cifs.common.p_domain_com"/>
   [<bean:write name="cifs_domainName" />/<bean:write name="cifs_computerName" />]
</p>
</div>
<nstab:nstab divoptions="style=\"top:78px;\"" >
<nstab:subtab url="enterCifs4nsview.do"><bean:message key="cifs.tab.share"/></nstab:subtab>
<nstab:subtab url="setGlobal4nsview.do?operation=display"><bean:message key="cifs.tab.global"/></nstab:subtab>
<logic:equal name="<%=CifsActionConst.SESSION_SECURITY_MODE%>" value="<%=CifsActionConst.SECURITYMODE_ADS%>" scope="session">
    <nstab:subtab url="specialShare4nsview.do"><bean:message key="cifs.tab.specialShare"/></nstab:subtab>
    <logic:notEqual name="<%=CifsActionConst.SESSION_PASSWDSERVER%>" value="*" scope="session">
        <nstab:subtab url="cifsDCFrame.do"><bean:message key="cifs.tab.dc"/></nstab:subtab>
    </logic:notEqual>
</logic:equal>
<nstab:subtab url="directEdit4nsview.do?operation=displayForSmbConf"><bean:message key="cifs.tab.smbConf"/></nstab:subtab>
<nstab:subtab url="directEdit4nsview.do?operation=displayForDirAccessConf"><bean:message key="cifs.tab.dirAccessConf"/></nstab:subtab>
<nstab:subtab url="otherOptions4nsview.do?operation=displayOtherOptions"><bean:message key="cifs.otherOptions.tab"/></nstab:subtab>
</nstab:nstab>
</body>
</html>
