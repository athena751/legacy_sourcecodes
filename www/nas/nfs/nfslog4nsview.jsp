<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfslog4nsview.jsp,v 1.2 2008/09/23 09:55:25 penghe Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.nec.nsgui.model.entity.nfs.*"%>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript">
function init(){
    <logic:equal name="failedGetLogInfo" value="true">
        alert('<bean:message key="nfslog.alert.failed.get.loginfo"/>');
    </logic:equal>
}

function reloadPage(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="<html:rewrite page='/nfsLog4nsview.do?operation=display'/>";
}

</script>
</head>
<body onload="init(); setHelpAnchor('network_nfs_6');">
<displayerror:error h1_key="title.nfs"/>
<html:form action="nfsLog4nsview.do?operation=set" method="POST">
<input type="button" name="refresh" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="reloadPage()"/>
<h3 class="title"><bean:message key="nfslog.h3.access.set"/></h3>
    <table border="1" class="Vertical">
        <tbody>
        <tr>
           <th>
                <bean:message key="nfslog.th.logfile.name"/>    
           </th>
           <td>
                <logic:notEqual name="NfsLogForm" property="accessLogInfo.fileName" value="">
                    <bean:write name="NfsLogForm" property="accessLogInfo.fileName"/>
                </logic:notEqual>
                <logic:equal name="NfsLogForm" property="accessLogInfo.fileName" value="">
                    <bean:message key="accesslog.proc.none"/>
                </logic:equal>
            </td>
        </tr>
        <tr>
            <th>
                <bean:message key="nfslog.th.rotation.size"/>             
            </th>
            <td>
                <logic:notEqual name="NfsLogForm" property="accessLogInfo.fileSize" value="">
	                <bean:write name="NfsLogForm" property="accessLogInfo.fileSize"/>
	                <logic:equal name="NfsLogForm" property="accessLogInfo.fileSizeUnit" value="<%=NFSConstant.NFS_LOG_FILE_SIZE_MB%>">
	                    <bean:message key="nfslog.option.size.mb"/>
	                </logic:equal>
	                <logic:equal name="NfsLogForm" property="accessLogInfo.fileSizeUnit" value="<%=NFSConstant.NFS_LOG_FILE_SIZE_KB%>">
	                    <bean:message key="nfslog.option.size.kb"/>
	                </logic:equal>
	            </logic:notEqual>
                <logic:equal name="NfsLogForm" property="accessLogInfo.fileSize" value="">
                    <bean:message key="accesslog.proc.none"/>
                </logic:equal>	            
            </td>
        </tr>
        <tr>
            <th>
                <bean:message key="nfslog.th.generations"/>             
            </th>
            <td>
                <logic:notEqual name="NfsLogForm" property="accessLogInfo.generationNum" value="">
                    <bean:write name="NfsLogForm" property="accessLogInfo.generationNum"/>
                </logic:notEqual>
                <logic:equal name="NfsLogForm" property="accessLogInfo.generationNum" value="">
                    <bean:message key="accesslog.proc.none"/>
                </logic:equal>   
            </td>
        </tr>
        </tbody>
    </table>
</html:form>
</body>
</html>