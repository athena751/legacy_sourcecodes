<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: serverprotectdirecteditbottom.jsp,v 1.1 2007/02/09 13:04:21 liy Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<html>
<head>
<%@include file="../../common/head.jsp"%>
<%@ page import="com.nec.nsgui.action.serverprotect.ServerProtectActionConst"%>

<script language="JavaScript">

 function init(){
     if(window.parent.frames[0].document&&window.parent.frames[0].document.forms[0]&&window.parent.frames[0].document.forms[0].fileContent){
  	     document.forms[0].serverProtectFileSet.disabled = false;
  	     document.forms[0].serverProtectFileReset.disabled = false;
  	     <logic:equal name="<%=ServerProtectActionConst.SESSION_HASCONFIGFILE%>" value="true">
            document.forms[0].serverProtectFileDelete.disabled = false;
        </logic:equal>
  	 } 
 }
 
 function onSet(){
     if(window.parent.frames[0]&&window.parent.frames[0].document.forms[0]&&window.parent.frames[0].document.forms[0].fileContent){
  	     return parent.frames[0].onSet();
     }
 }
 
 function onReset(){
     if(window.parent.frames[0]&&window.parent.frames[0].document.forms[0]&&window.parent.frames[0].document.forms[0].fileContent){
  	     return parent.frames[0].onReset();
  	 }
 }
  function onDelete(){
     if(window.parent.frames[0]&&window.parent.frames[0].document.forms[0]&&window.parent.frames[0].document.forms[0].fileContent){
  	     return parent.frames[0].onDelete();
  	 }
 }
 </script>

</head>
<body onload="init();">
<form>
    <input type="button" name="serverProtectFileSet" disabled=true value="<bean:message key="common.button.submit" bundle="common"/>" onclick="return onSet()" /> 
	&nbsp;&nbsp;
	<input type="button" name="serverProtectFileReset" disabled=true value="<bean:message key="common.button.reset" bundle="common"/>" onclick="return onReset()" />
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input type="button" name="serverProtectFileDelete" disabled=true value="<bean:message key="common.button.delete" bundle="common"/>" onclick="onDelete()" />
</form>
</body>
</html>
