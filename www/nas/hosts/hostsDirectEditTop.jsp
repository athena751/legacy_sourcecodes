<!-- 
    Copyright (c) 2006-2007 NEC Corporation
		
    NEC SOURCE CODE PROPRIETARY
		
    Use, duplication and disclosure subject to a source code 
    license agreement with NEC Corporation.
-->

<!--  "@(#) $Id: hostsDirectEditTop.jsp,v 1.6 2007/05/29 09:22:22 wanghui Exp $" -->



<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

function init(){
		
    <logic:notEqual name="hosts_directEditNoWarn" value="true">
        <logic:notEqual name="hosts_disaccordFlag" value="true">
            alert('<bean:message key="hosts.alert.direct_edit.warning"/>');
        </logic:notEqual>
    </logic:notEqual>
    <logic:equal name="hosts_directEditNoWarn" value="true">
        <%NSActionUtil.setSessionAttribute(request,"hosts_directEditNoWarn",null );%>
    </logic:equal>
    <logic:notEqual name="hosts_disaccordFlag" value="true">
        enableBottomButton();
    </logic:notEqual>
    <logic:equal name="hosts_syncWriteFlag" value="error">
        <logic:equal name="hosts_nodeNum" value="0">
            alert('<bean:message key="hosts.alert.direct_edit.syncError.node0"/>');
        </logic:equal>
        <logic:equal name="hosts_nodeNum" value="1">
            alert('<bean:message key="hosts.alert.direct_edit.syncError.node1"/>');
        </logic:equal>
	<%NSActionUtil.setSessionAttribute(request,"hosts_syncWriteFlag",null );%>
    </logic:equal>
    <logic:equal name="hosts_syncWriteFlag" value="guard">
        alert('<bean:message key="Hosts.alert.direce_edit.writeError.otherNode"/>');
        <%NSActionUtil.setSessionAttribute(request,"hosts_syncWriteFlag",null );%>
    </logic:equal>
		
}

function enableBottomButton(){
    if(window.parent.frames[1]&&window.parent.frames[1].document.hostsFileSetBottom){
	
        window.parent.frames[1].document.hostsFileSetBottom.hostsFileSet.disabled = false;
        window.parent.frames[1].document.hostsFileSetBottom.hostsFileReset.disabled = false;
    }

}
function refreshGraph(){
    if(window.parent.frames[1]&&window.parent.frames[1].isSubmitted()){
        return false;
    }
    window.parent.frames[1].setSubmitted();
    window.parent.location="hostsFile.do";
	
}
</script>
</head>
<body onload="init();displayAlert();setHelpAnchor('network_hosts_2');" onUnload="closeDetailErrorWin();">

<form name="hostsFileSetTop" method="POST" >
<input type="button" name="refresh" value="<bean:message key='common.button.reload' bundle='common'/>" 
onclick="return refreshGraph()"/>
<br><br>
<displayerror:error h1_key="hosts.title.h1"/>
<br>
    <textarea name="fileContent" wrap="off" rows="21" style='width:100%;'>
<bean:write name="directEditForm" property="fileContent"/></textarea>
</form>
</body>
</html:html>

	



