<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicavolumesync.jsp,v 1.5 2008/06/18 08:04:48 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.replication.ReplicationActionConst"%>
<%@ taglib uri="struts-bean" prefix="bean"%>
<%@ taglib uri="struts-html" prefix="html"%>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>

<%  String replicaMP = request.getParameter("replicaInfo.mountPoint");
    NSActionUtil.setSessionAttribute(request, ReplicationActionConst.SESSION_MOUNT_POINT, replicaMP); 
%>

<html:html lang="true">

<head>
<%@ include file="/common/head.jsp"%>
<%@ include file="replicationcommon.jsp"%>
<script language="JavaScript" src="<%=request.getContextPath()%>/common/common.js"></script>
<script language="JavaScript">
var heartBeatWin;

function onSet(){
    if (isSubmitted()) {
        return false;
    }
   
    if (confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
            '<bean:message key="common.confirm.action" bundle="common"/>'+
            '<bean:message key="replicaton.button.execute"/>' + '\r\n\r\n' +
            '<bean:message key="replica.volumeSync.confirm"/>')){
        setSubmitted();
        heartBeatWin = openHeartBeatWin();
        document.forms[0].submit();
        return true;
    }
    return false;
}
</script>
</head>

<body onload="loadExecutePage();setHelpAnchor('replication_11');" onUnload="closeDetailErrorWin();unloadBtnFrame();closePopupWin(heartBeatWin);">
<html:button property="backBtn" onclick="return loadReplicaList();">
    <bean:message key="common.button.back" bundle="common"/>
</html:button>
<br><br>
<displayerror:error h1_key="replicate.h1"/>
<h3 class="title"><bean:message key="replica.h3.volumeSync"/></h3>
<html:form action="replicaVolumeSyncSet.do" method="POST">
    <table border="1" nowrap class="Vertical">
        <tr>
            <th><bean:message key="replication.info.oriservername"/></th>
            <td><html:hidden property="replicaInfo.originalServer" write="true"/></td>
        </tr>
        <tr>
            <th><bean:message key="replication.info.filesetname"/></th>
            <td><html:hidden property="replicaInfo.filesetName" write="true"/></td>
        </tr>
        <tr>
            <th><bean:message key="replication.info.mountpoint"/></th>
            <td><html:hidden property="replicaInfo.mountPoint" write="true"/></td>
        </tr>
    </table>
    
    <html:hidden property="syncType"/>
<!--
    <br>
    <table border="0" nowrap>
        <tr>
            <td valign=top><html:radio styleId="syncTypeRadio1" property="syncType" value="cur"/></td>
            <td valign=top>
                <label for="syncTypeRadio1">
                    &nbsp;<bean:message key="replica.volumeSync.syncCurrent"/>&nbsp;
                </label>
            </td>
            <td><bean:message key="replica.volumeSync.syncCurrent.info"/></td>
        </tr>
        <tr>
            <td valign=top><html:radio styleId="syncTypeRadio2" property="syncType" value="all"/></td>
            <td valign=top>
                <label for="syncTypeRadio2">
                    &nbsp;<bean:message key="replica.volumeSync.syncAll"/>&nbsp;
                </label>
            </td>
            <td><bean:message key="replica.volumeSync.syncAll.info"/></td>
        </tr>
    </table>
-->
</html:form>
</body>

</html:html>
