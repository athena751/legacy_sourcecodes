<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrnomv.jsp,v 1.5 2008/05/14 09:59:10 xingyh Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>
<html>
<head>
<%@ include file="/common/head.jsp"%>
<%@ include file="ddrcreatecommon.jsp"%>
<%@ include file="ddrcommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
function init(){
    loadBottom();
<logic:equal name="<%=DdrActionConst.REQUEST_D2D_USAGE%>" value="<%=DdrActionConst.USAGE_ALWAYS%>" scope="request">
    setHelpAnchor('disk_backup_5');
</logic:equal>
<logic:equal name="<%=DdrActionConst.REQUEST_D2D_USAGE%>" value="<%=DdrActionConst.USAGE_GENERATION%>" scope="request">
    setHelpAnchor('disk_backup_6');
</logic:equal>
}
function loadBottom(){
	if (parent.btnframe){
        // load empty btn frame
        setTimeout('parent.btnframe.location="' + '/nsadmin/common/commonblank.html' + '"',1);
  	}
}

</script>
</head>
<body onload="init();" onUnload="unLockMenu();">
<html:button property="reloadBtn" onclick="reloadPage();">
   <bean:message key="common.button.reload" bundle="common"/>
</html:button>
<displayerror:error h1_key="ddr.h1"/>
<h3 class="title"><bean:message key="title.add.h3"/></h3>
<table border="0">
<tr><td>
<logic:present name="<%=DdrActionConst.SESSION_DDR_ASYNCVOL%>" scope="request">
      <bean:message key="msg.add.haveSyncVol"/>
</logic:present>
<logic:present name="<%=DdrActionConst.REQUEST_MV_NAME_AND_VALUE%>" scope="request">
      <bean:message key="info.noMv"/>
</logic:present>
</td></tr>
</table>
</body>
</html>