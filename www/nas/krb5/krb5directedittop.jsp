<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: krb5directedittop.jsp,v 1.1 2006/11/06 05:58:50 liy Exp $" -->


<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.krb5.Krb5ActionConst"%>

<html>
<head>
<%@include file="../../common/head.jsp" %>

<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">


function init() {
    <logic:notEqual name="<%=Krb5ActionConst.SESSION_NOWARNING%>" value="true">
        alert('<bean:message key="krb5.alert.direct_edit.warning"/>');
    </logic:notEqual>
    <logic:equal name="<%=Krb5ActionConst.SESSION_NOWARNING%>" value="true">
        <%NSActionUtil.setSessionAttribute(request, Krb5ActionConst.SESSION_NOWARNING, null);%>
    </logic:equal>	
      
    <logic:equal name="<%=Krb5ActionConst.SESSION_SYNC_WRITE_FLAG%>" value="<%=Krb5ActionConst.CONST_ERR_FILE_SYNC%>">
	    alert('<bean:message key="krb5.alert.direct_edit.syncError"/>');
	    <%NSActionUtil.setSessionAttribute(request, Krb5ActionConst.SESSION_SYNC_WRITE_FLAG, null);%>
    </logic:equal>
	 
	if (parent.bottomFrame) {
		setTimeout('parent.bottomFrame.location="' + '<html:rewrite page="/krb5FileBottom.do"/>' + '"',1);
	}
}

function onReload(){
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="krb5FileTop.do?operation=readKrb5File";
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
    
    parent.bottomFrame.document.forms[0].krb5FileSet.disabled   = true;
    parent.bottomFrame.document.forms[0].krb5FileReset.disabled = true;
    
    document.forms[0].action="krb5FileTop.do?operation=writeKrb5File";
    document.forms[0].submit();
    return true;
}

function onReset() {
    if(isSubmitted()){
        return false;
    }
   document.forms[0].reset();
   return true;
}

</script>
</head>
<body onload="init();displayAlert();">
<form name="krb5FileSetForm" method="POST">
	<input type="button" name="reload" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="onReload()"/>
	<br>
	<displayerror:error h1_key="krb5.h1"/>
	<br>
    <textarea name="fileContent" wrap="off" rows="30" style='width:100%;'><bean:write name="directEditForm" property="fileContent"/></textarea>
</form>
</body>
</html>