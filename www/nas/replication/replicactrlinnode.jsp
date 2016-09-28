<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicactrlinnode.jsp,v 1.5 2008/06/18 08:04:30 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.replication.ReplicationActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<%  String replicaMP = request.getParameter("replicaInfo.mountPoint");
    NSActionUtil.setSessionAttribute(request, ReplicationActionConst.SESSION_MOUNT_POINT, replicaMP); 
%>
<html:html lang="true">
<head>
<%@ include file="/common/head.jsp"%>
<%@ include file="replicationcommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
var heartBeatWin;

function init(){
    if (document.forms[0].elements["replicaInfo.syncRate"].value != "100") {
        document.forms[0].operation[1].disabled = true;
    }
    
    loadExecutePage();
}

function onSet(){
    if (isSubmitted()) {
        return false;
    }
   
    if (confirm('<bean:message key="replica.ctrlInNode.confirm"/>' 
                + '\r\n\r\n'
                + '<bean:message key="replica.confirm.longtime"/>')) {
        setSubmitted();
        heartBeatWin = openHeartBeatWin();
        document.forms[0].submit();
        return true;
    }
    return false;
}
</script>
</head>
<body onload="init();setHelpAnchor('replication_9');" onUnload="unloadBtnFrame();closePopupWin(heartBeatWin);">
<html:button property="backBtn" onclick="return loadReplicaList();">
    <bean:message key="common.button.back" bundle="common"/>
</html:button>
<displayerror:error h1_key="replicate.h1"/>
<h3 class="title"><bean:message key="replica.h3.ctrlInNode"/></h3>
<html:form action="replicaCtrlInNode.do">
    <html:hidden property="replicaInfo.syncRate"/>
    <html:hidden property="replicaInfo.originalServer"/>
    <table border="1" nowrap class="Vertical">
        <tr>
            <th><bean:message key="replication.info.filesetname"/></th>
            <td><html:hidden property="replicaInfo.filesetName" write="true"/></td>
        </tr>
        <tr>
            <th><bean:message key="replica.ctrlInNode.replicaMP"/></th>
            <td><html:hidden property="replicaInfo.mountPoint" write="true"/></td>
        </tr>
        <tr>
            <th><bean:message key="replica.ctrlInNode.originalMP"/></th>
            <td><html:hidden property="replicaInfo.originalMP" write="true"/></td>
        </tr>
    </table>

    <br>
    
    <table border="0" nowrap>
        <tr>
            <td valign=top><html:radio styleId="operationRadio1" property="operation" value="replace"/></td>
            <td valign=top>
                <label for="operationRadio1">
                    &nbsp;<bean:message key="replica.ctrlInNode.item.replace"/>
                    <bean:message key="replica.ctrlInNode.colon"/>&nbsp;
                </label>
            </td>
            <td><bean:message key="replica.ctrlInNode.replace.msg"/></td>
        </tr>
        <tr>
            <td valign=top><html:radio styleId="operationRadio2" property="operation" value="exchange"/></td>
            <td valign=top>
                <label for="operationRadio2">
                    &nbsp;<bean:message key="replica.ctrlInNode.item.exchange"/>
                    <bean:message key="replica.ctrlInNode.colon"/>&nbsp;
                </label>
            </td>
            <td><bean:message key="replica.ctrlInNode.exchange.msg"/></td>
        </tr>        
    </table>
</html:form>
</body>
</html:html>