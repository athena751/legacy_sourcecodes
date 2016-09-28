<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicapromote.jsp,v 1.5 2008/06/18 08:04:39 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.replication.ReplicationActionConst"%>
<%@ page import="com.nec.nsgui.action.replication.STDataRender4Original"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested"%>
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
function onSet(){
    if (isSubmitted()) {
        return false;
    }
    
    if (confirm("<bean:message key="common.confirm" bundle="common"/>" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common"/>" 
            + "<bean:message key="replica.h3.promote"/>" + "\r\n\r\n"
            + "<bean:message key="replica.confirm.longtime"/>")) {
        setSubmitted();
        heartBeatWin = openHeartBeatWin();
        document.forms[0].submit();
        return true;
    }
    return false;
}
</script>
</head>
<body onload="loadExecutePage();setHelpAnchor('replication_8');" onUnload="unloadBtnFrame();closePopupWin(heartBeatWin);">
<html:button property="backBtn" onclick="return loadReplicaList();">
    <bean:message key="common.button.back" bundle="common"/>
</html:button>
<displayerror:error h1_key="replicate.h1"/>
<h3 class="title"><bean:message key="replica.h3.promote"/></h3>
<html:form action="replicaPromote.do">
    <nested:nest property="replicaInfo">
    	<nested:hidden property="repliMethod"/>
        <table border="1" nowrap class="Vertical">
            <tr>
                <th><bean:message key="replication.info.oriservername"/></th>
                <td><nested:hidden property="originalServer" write="true"/></td>
            </tr>
            <tr>
                <th><bean:message key="replication.info.filesetname"/></th>
                <td><nested:hidden property="filesetName" write="true"/></td>
            </tr>
            <tr>
                <th><bean:message key="replication.info.mountpoint"/></th>
                <td><nested:hidden property="mountPoint" write="true"/></td>
            </tr>
            <nested:equal property="repliMethod" value="<%=ReplicationActionConst.CONST_REPLI_METHOD_SPLIT%>">
	            <tr id="showCheckpoint" >
	            	<th align="left"><bean:message key="original.info.checkpoint.create"/></th>
	          		<td><bean:message key="original.info.daily"/>&nbsp;
	            		<html:select property="hour" >      				
							<%for(int i=0;i<24;i++){%>
								<html:option value="<%=String.valueOf(i)%>"><%=STDataRender4Original.to2Digit(String.valueOf(i))%></html:option>
							<%}%>
						</html:select>&nbsp;
						<bean:message key="original.info.hour"/>&nbsp;
						<html:select property="minute" >	
							<%for(int i=0;i<60;i=i+10){%>
								<html:option value="<%=String.valueOf(i)%>"><%=STDataRender4Original.to2Digit(String.valueOf(i))%></html:option>
							<%}%>
						</html:select>&nbsp;
						<bean:message key="original.info.minute"/>
					</td>
	        	</tr>	            
            </nested:equal>
        </table>    
    </nested:nest>
</html:form>
</body>
</html:html>