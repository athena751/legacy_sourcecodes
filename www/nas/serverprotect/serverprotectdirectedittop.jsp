<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: serverprotectdirectedittop.jsp,v 1.5 2007/03/23 04:59:15 liy Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.serverprotect.ServerProtectActionConst"%>

<html>
<head>
<%@include file="../../common/head.jsp"%>

<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">

function init() {
    <logic:notEqual name="<%=ServerProtectActionConst.REQUEST_NOWARNING%>" value="true">
        <logic:equal name="<%=ServerProtectActionConst.SESSION_HASCONFIGFILE%>" value="true">
            alert('<bean:message key="serverprotect.alert.directedit.warning"/>');
        </logic:equal>
        <logic:notEqual name="<%=ServerProtectActionConst.SESSION_HASCONFIGFILE%>" value="true">
            alert('<bean:message key="serverprotect.alert.directedit.warning"/>');
        </logic:notEqual>
    </logic:notEqual>
    <logic:equal name="<%=ServerProtectActionConst.REQUEST_NOWARNING%>" value="true">
        <%NSActionUtil.setSessionAttribute(request, ServerProtectActionConst.REQUEST_NOWARNING, null);%>
    </logic:equal>
    <logic:equal name="<%=ServerProtectActionConst.REQUEST_DOFAILEDALERT%>" value="true">
        <%request.setAttribute(ServerProtectActionConst.REQUEST_DOFAILEDALERT, null);%>
        alert('<bean:message key="common.alert.failed" bundle="common"/>');
    </logic:equal>
    document.forms[0].reload.disabled = false;
    enableBottomButton();
    
}
function enableBottomButton(){
    if(window.parent.frames[1].document && window.parent.frames[1].document.forms[0] 
    && window.parent.frames[1].document.forms[0].serverProtectFileSet 
    && window.parent.frames[1].document.forms[0].serverProtectFileReset
    && window.parent.frames[1].document.forms[0].serverProtectFileDelete){
        window.parent.frames[1].document.forms[0].serverProtectFileSet.disabled = false;
        window.parent.frames[1].document.forms[0].serverProtectFileReset.disabled = false;
        <logic:equal name="<%=ServerProtectActionConst.SESSION_HASCONFIGFILE%>" value="true">
           window.parent.frames[1].document.forms[0].serverProtectFileDelete.disabled = false;
        </logic:equal> 
    }
}
function onReload(){
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    window.parent.location = "serverProtectDirectEdit.do";
}

function onSet(){
    if(isSubmitted()){
        return false;
    }
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
        '<bean:message key="common.confirm.action" bundle="common"/>'+
        '<bean:message key="common.button.submit" bundle="common"/>')){
        return false;
    }
    setSubmitted();
    document.forms[0].action = "serverProtectFile.do?operation=writeVrscanFile";
    document.forms[0].submit();
    window.parent.frames[1].document.forms[0].serverProtectFileSet.disabled = true;
	window.parent.frames[1].document.forms[0].serverProtectFileReset.disabled = true;
    window.parent.frames[1].document.forms[0].serverProtectFileDelete.disabled = true;
    document.forms[0].reload.disabled = true;
    return true;
}

function onReset() {
    if(isSubmitted()){
        return false;
    }
   document.forms[0].reset();
   return true;
}

function onDelete(){
    if(isSubmitted()){
        return false;
    }
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
        '<bean:message key="common.confirm.action" bundle="common"/>'+
        '<bean:message key="common.button.delete" bundle="common"/>')){
        return false;
    }
    setSubmitted();
    document.forms[0].action = "serverProtectFile.do?operation=deleteVrscanFile";
    document.forms[0].submit();
    window.parent.frames[1].document.forms[0].serverProtectFileSet.disabled = true;
	window.parent.frames[1].document.forms[0].serverProtectFileReset.disabled = true;
    window.parent.frames[1].document.forms[0].serverProtectFileDelete.disabled = true;
    document.forms[0].reload.disabled = true;
    return true;
}
</script>
</head>
<body onload="displayAlert();init();setHelpAnchor('nvavs_realtimescan_4');">
<form name="serverProtectFileSetForm" method="POST">
<input type="button" name="reload" value="<bean:message key="common.button.reload" bundle="common"/>" disabled="true" onclick="onReload()" />
<br>
<displayerror:error h1_key="serverprotect.common.h1" />

<%String[] errorInfo=(String[])(request.getAttribute(ServerProtectActionConst.REQUEST_ERRORINFO));%>
<logic:notEmpty name="<%=ServerProtectActionConst.REQUEST_ERRORINFO%>">
<table border="0">
    <tr>
      <td vAlign="top" align="center" rowspan="<%=errorInfo.length+1%>" class="ErrorInfo">
          <img border=0 src="/nsadmin/images/icon/png/icon_alert.png">&nbsp;&nbsp;
      </td>
      <td class="ErrorInfo">
          <bean:message key="serverprotect.error.directedit.nvavs_config_create" />&nbsp;&nbsp;
      </td>
    </tr>
<%int lineToShow = errorInfo.length - 2;
  if(lineToShow>0){%>
    <logic:iterate id="currentLine" 
          collection="<%=errorInfo%>"
          type="java.lang.String"
          offset="0"
          length="<%= String.valueOf(lineToShow)%>">
    <tr>
        <td class="ErrorInfo">
            <%=currentLine%>&nbsp;&nbsp;
        </td>
    </tr>
    </logic:iterate>
<%}%>
</table>
<%request.setAttribute(ServerProtectActionConst.REQUEST_ERRORINFO,null); %>
</logic:notEmpty>
   
<br>
<textarea name="fileContent" wrap="off" rows="30" style='width:100%;'><bean:write name="directEditForm" property="fileContent" /></textarea>
</form>
</body>
</html>
