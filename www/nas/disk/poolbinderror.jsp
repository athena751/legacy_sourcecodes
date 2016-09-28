<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: poolbinderror.jsp,v 1.5 2008/04/19 12:58:07 jiangfx Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean"   prefix="bean" %>
<%@ taglib uri="struts-logic"  prefix="logic"%>
<%@ taglib uri="struts-html"   prefix="html" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript">
function closeit(){
    <logic:equal name="poolInfoForm" property="from" value="disk" scope="request"> 
    if(window.opener.parent) {
        window.opener.parent.location = "/nsadmin/menu/fcsan/componentconf/rankspare.jsp?diskarrayid="+document.forms[0].elements["diskarrayid"].value+
        "&diskarrayname="+document.forms[0].elements["diskarrayname"].value+
        "&pdgroupnumber="+document.forms[0].elements["pdgroupnumber"].value+
        "&arraytype="+document.forms[0].elements["arraytype"].value+"&reload=reload";
    }
	</logic:equal>
    window.close();
}
</script>
</head>

<body>
<title><bean:message key="disk.pool.create.fail"/></title>
<h1 class="popup"><bean:message key="common.alert.failed" bundle="common"/></h1>

<logic:equal name="poolInfoForm" property="from" value="disk" scope="request"> 
    <displayerror:error h1_key="disk.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="volumeExtend" scope="request"> 
   <displayerror:error h1_key="volume.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="volumeCreate" scope="request"> 
   <displayerror:error h1_key="volume.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="replication" scope="request"> 
   <displayerror:error h1_key="replication.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from"  value="ddrCreate" scope="request"> 
   <displayerror:error h1_key="ddr.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from"  value="ddrExtend" scope="request"> 
   <displayerror:error h1_key="ddr.h1"/>
</logic:equal>

<html:form action="bindpool.do">
<html:hidden property="diskarrayid"/>
<html:hidden property="arraytype"/>
<html:hidden property="diskarrayname"/>
<html:hidden property="pdgroupnumber"/>
<center>
<logic:equal name="poolInfoForm" property="from" value="volumeExtend" scope="request"> 
   <input type="button" value="<bean:message key="common.button.back" bundle="common"/>" onclick="window.location = '/nsadmin/volume/volumePoolSelect.do?from=volumeExtend'">
	&nbsp;&nbsp;
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="volumeCreate" scope="request"> 
   <input type="button" value="<bean:message key="common.button.back" bundle="common"/>" onclick="window.location = '/nsadmin/volume/volumePoolSelect.do?from=volumeCreate'">
	&nbsp;&nbsp;
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="replication" scope="request"> 
   <input type="button" value="<bean:message key="common.button.back" bundle="common"/>" onclick="window.location = '/nsadmin/volume/volumePoolSelect.do?from=replication'">
	&nbsp;&nbsp;
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="ddrCreate" scope="request"> 
   <input type="button" value="<bean:message key="common.button.back" bundle="common"/>" onclick="window.location = '/nsadmin/volume/volumePoolSelect.do?from=ddrCreate'">
	&nbsp;&nbsp;
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="ddrExtend" scope="request"> 
   <input type="button" value="<bean:message key="common.button.back" bundle="common"/>" onclick="window.location = '/nsadmin/volume/volumePoolSelect.do?from=ddrExtend'">
	&nbsp;&nbsp;
</logic:equal>
<input type="button" value="<bean:message key="common.button.close" bundle="common"/>" onClick="closeit();">
</center>
</html:form>
</body>
</html>