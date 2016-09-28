<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: poolbindsuccess.jsp,v 1.4 2005/09/29 07:52:52 liq Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean"   prefix="bean" %>
<%@ taglib uri="struts-html"   prefix="html" %>
<%@ taglib uri="struts-logic"  prefix="logic"%>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript">
function closeit(){
    if(window.opener.parent) {
        window.opener.parent.location = "/nsadmin/menu/fcsan/componentconf/rankspare.jsp?diskarrayid="+document.forms[0].elements["diskarrayid"].value+
        "&diskarrayname="+document.forms[0].elements["diskarrayname"].value+
        "&pdgroupnumber="+document.forms[0].elements["pdgroupnumber"].value+
        "&arraytype="+document.forms[0].elements["arraytype"].value+"&reload=reload";
    }
    window.close();
}
</script>
</head>

<body>
<title><bean:message key="disk.pool.create.success.title"/></title>
<h1 class="popup"><bean:message key="common.alert.done" bundle="common"/></h1>
<h2 class="popup"><bean:message key="disk.pool.create.success.detail"/></h2>
<html:form action="bindpool.do">
<html:hidden property="diskarrayid"/>
<html:hidden property="arraytype"/>
<html:hidden property="diskarrayname"/>
<html:hidden property="pdgroupnumber"/>
<center>
<input type="button" value="<bean:message key="common.button.close" bundle="common"/>" onClick="closeit();">
</center>
</html:form>
</body>
</html>