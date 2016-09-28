<!-- 
        Copyright (c) 2006-2007 NEC Corporation
		
        NEC SOURCE CODE PROPRIETARY
		
        Use, duplication and disclosure subject to a source code 
        license agreement with NEC Corporation.
-->

<!--  "@(#) $Id: ndmpstatus.jsp,v 1.6 2007/05/16 05:36:58 wanghui Exp $" -->
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil,
                 com.nec.nsgui.action.ndmpv4.NdmpActionConst"%>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp"%>
<SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
function setframeloadflag(){
    setHelpAnchor("backup_ndmp_5");
    <logic:equal name="<%= NSActionConst.SESSION_USERINFO %>"
    value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
    <bean:define id="ndmpdStatus" name="ndmpdStatus"/>
    if("<%=ndmpdStatus%>"=="start"){
        document.forms[0].start.disabled=true;
    }else if("<%=ndmpdStatus%>"=="stop"){
        document.forms[0].stop.disabled=true;
        document.forms[0].restart.disabled=true;
    }else{
        document.forms[0].stop.disabled=true;
        document.forms[0].restart.disabled=true;
        document.forms[0].start.disabled=true;
    }
    if("<%=session.getAttribute(NdmpActionConst.NDMP_SERVER_EXEC_RET)%>"=="START_SCRIPT_EXEC_ERR"){
        alert("<bean:message key="ndmp.app.startScript.execErr"/>");
    }else if("<%=session.getAttribute(NdmpActionConst.NDMP_SERVER_EXEC_RET)%>"=="STOP_SCRIPT_EXEC_ERR"){
        alert("<bean:message key="ndmp.app.stopScript.execErr"/>");
    }
    <%NSActionUtil.setSessionAttribute(request,NdmpActionConst.NDMP_SERVER_EXEC_RET,null);%>
    </logic:equal> 
    <logic:equal name="needToConfirm" value="true" scope="request">
    if(confirm('<bean:message key="ndmp.app.execute.confirm"/>')){
            setSubmitted();
            document.forms[0].needToCheckSession.value="false";
            document.forms[0].submit();
    }    
    </logic:equal>
}   

function onStatus(event){
    if(isSubmitted()){
        return false;
    }
    if(event=='start'){
        oper="<bean:message key="ndmp.app.button.start"/>";
    }else if(event=='stop'){
        oper="<bean:message key="ndmp.app.button.stop"/>";
    }else{
        oper="<bean:message key="ndmp.app.button.restart"/>";
    }
    document.forms[0].ndmpdManage.value=event;
    if(confirm("<bean:message key="common.confirm" bundle="common"/>"+"\r\n"
                    +"<bean:message key="common.confirm.action" bundle="common"/>"
                    +oper)){
        setSubmitted();
        document.forms[0].needToCheckSession.value="true";
        document.forms[0].submit();
    }
}
 
function refreshGraph(){
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="ndmpManage.do?operation=getStatus"; 
}

</SCRIPT> 
</head>
<body onload="setframeloadflag();displayAlert();">
<html:form action="ndmpManage.do?operation=changeStatus">
<displayerror:error h1_key="ndmp.common.h1"/>
<input type="button" name="refresh" 
         value="<bean:message key='common.button.reload' bundle='common'/>" onclick="return refreshGraph()"/>
<br>
<br>
<table><tr><td>
    <logic:equal name="ndmpdStatus" value="start">
        <bean:message key="ndmp.app.status.starting"/>
    </logic:equal>
    <logic:equal name="ndmpdStatus" value="stop">
        <bean:message key="ndmp.app.status.stopping"/>
    </logic:equal>
</td></tr>
</table>
<logic:equal name="<%= NSActionConst.SESSION_USERINFO %>"
    value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
    <br>
    <br>
    <html:hidden property="ndmpdManage"/>
    <input type="button" name="start" onclick="onStatus('start')" 
        value="<bean:message key="ndmp.app.button.start"/>"/>
    <input type="button" name="stop" onclick="onStatus('stop')" 
        value="<bean:message key="ndmp.app.button.stop"/>"/>
    <input type="button" name="restart" onclick="onStatus('restart')" 
        value="<bean:message key="ndmp.app.button.restart"/>"/>
</logic:equal>
<html:hidden property="needToCheckSession"/>
</html:form>
</body>
</html:html>
