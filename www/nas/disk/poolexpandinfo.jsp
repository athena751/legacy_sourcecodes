<!--
        Copyright (c) 2006-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: poolexpandinfo.jsp,v 1.4 2008/04/19 13:01:39 jiangfx Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.model.entity.disk.DiskConstant"%>
<%@ page buffer="32kb" %>
<%@ taglib uri="struts-bean"   prefix="bean" %>
<%@ taglib uri="struts-html"   prefix="html" %>
<%@ taglib uri="struts-logic"  prefix="logic"%>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>
<%@ page import="java.lang.Double" %>
<%@ page import="java.text.DecimalFormat" %>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
function init(){
    <logic:equal name="poolInfoForm" property="poolinfo.raidtype" value="6_6" scope="request"> 
        document.getElementById('raditype').innerHTML="RAID6(4+PQ)";
    </logic:equal>
    <logic:equal name="poolInfoForm" property="poolinfo.raidtype" value="6_10" scope="request"> 
        document.getElementById('raditype').innerHTML="RAID6(8+PQ)";
    </logic:equal>
    
    <bean:define id="ca" name="exactcapacity" scope="request" type="java.lang.String"/>
    var exactcabyte =" ("+"<%=(new DecimalFormat("#,###")).format(new Double(ca))%>"+" <bean:message key="disk.pool.capacity.byte"/>"+")";
    var tmp= parseInt("<%=ca%>");
    tmp = tmp/1024/1024/1024;
    tmp = tmp *10;
    tmp = parseInt(tmp);
    tmp = tmp/10;
    var ca = new Number(tmp);
    var exactcapacity = ca.toFixed(1)+"GB";
    document.getElementById('aftercapacity').innerHTML=exactcapacity+exactcabyte;
	
	<bean:define id="oldca" name="<%=DiskConstant.SESSION_OLD_POOL_CAPACITY%>" type="java.lang.String"/>
	var cabyte = " ("+"<%=(new DecimalFormat("#,###")).format(new Double(oldca))%>"+" <bean:message key="disk.pool.capacity.byte"/>"+")";
	var tmp2 = parseInt("<%=oldca%>");
	tmp2 = tmp2/1024/1024/1024;
    tmp2 = tmp2 *10;
    tmp2 = parseInt(tmp2);
    tmp2 = tmp2/10;
    var ca2 = new Number(tmp2);
    var capacity = ca2.toFixed(1)+"GB";
    document.getElementById('capacity').innerHTML=capacity+cabyte;
    
}

function expandpool(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    document.forms[0].action = "expandpool.do";
    document.forms[0].submit();
    return true;
    
}

function backtoexpand(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    document.forms[0].action = "backtoselect.do?method=backtoexpand";
    document.forms[0].submit();
    return true;
}
</script>
<title><bean:message key="disk.pool.info.poolexpand.h2"/></title>
</head>

<body onload="init();">
<logic:equal name="poolInfoForm" property="from" value="disk" scope="request"> 
    <h1 class="title"><bean:message key="disk.h1"/></h1>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="volumeCreate" scope="request"> 
    <h1 class="title"><bean:message key="volume.h1"/></h1>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="volumeExtend" scope="request"> 
    <h1 class="title"><bean:message key="volume.h1"/></h1>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="replication" scope="request"> 
    <h1 class="title"><bean:message key="replication.h1"/></h1>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="ddrCreate" scope="request"> 
    <h1 class="title"><bean:message key="ddr.h1"/></h1>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="ddrExtend" scope="request"> 
    <h1 class="title"><bean:message key="ddr.h1"/></h1>
</logic:equal>

<html:form action="backtoselect.do?method=backtoexpand">
<input type="button" name="backbutton" value="<bean:message key="common.button.back" bundle="common"/>" onclick ="backtoexpand();">
<h2 class="title"><bean:message key="disk.pool.info.poolexpand.h2"/></h2>
<html:hidden property="diskarrayid"/>
<html:hidden property="arraytype"/>
<html:hidden property="from"/>
<html:hidden property="diskarrayname"/>
<html:hidden property="pdgroupnumber"/>
<html:hidden property="poolinfo.raidtype"/>
<html:hidden property="poolinfo.usedpd"/>
<html:hidden property="poolinfo.notusedpd"/>
<html:hidden property="poolinfo.expandmode"/>
<bean:message key="disk.pool.info.expand"/>
<br><br>
<table>
<tr>
    <th align="left"><bean:message key="disk.pool.namenumber"/></th>
    <td>:</td>
    <td><html:hidden property="poolinfo.poolname" write="true"/></td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.raid.type"/></th>
    <td>:</td>
    <td><span id="raditype"></span></td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.before.expand.capacity"/></th>
    <td>:</td>
    <td><span id="capacity"></td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.after.expand.factcapacity"/></th>
    <td>:</td>
    <td><span id="aftercapacity"></span></td>
</tr>
<logic:equal name="poolInfoForm" property="poolinfo.expandmode" value="on" scope="request"> 
<tr>
	<th align="left"><bean:message key="disk.pool.h3.expandmodeselect"/></th>
    <td>:</td>
    <td><bean:message key="disk.pool.expand.mode.on.fordisplay"/></td>
</tr>
<tr>
    <th align="left"><bean:message key="disk.pool.expand.time"/></th>
    <td>:</td>
    <td><html:hidden property="poolinfo.expandtime" write="true"/>&nbsp;<bean:message key="disk.pool.expand.time.denomination"/></td>
</tr>
</logic:equal>
<logic:equal name="poolInfoForm" property="poolinfo.expandmode" value="off" scope="request"> 
<tr>
	<th align="left"><bean:message key="disk.pool.h3.expandmodeselect"/></th>
    <td>:</td>
    <td><bean:message key="disk.pool.expand.mode.off.fordisplay"/></td>
</tr>
</logic:equal>

</table>
<br>
<hr>

<h3 class="title"><bean:message key="disk.pool.info.pd.expand.h3"/></h3>
<table border=1>
<tr><th><bean:message key="disk.pool.pd.use"/></th></tr>
<logic:iterate id="listLabel" name="<%=DiskConstant.SESSION_OLD_POOL_PD%>">
<tr><td style="color:gray"><bean:write name="listLabel" property="label"/></td></tr>
</logic:iterate>

<logic:iterate id="addlistLabel" name="usepdlist">
<tr><td><bean:write name="addlistLabel" property="label"/></td></tr>
</logic:iterate>
</table>

<br>
<hr>
<br>

<center>
<input type="button" name="set" value="<bean:message key="disk.pool.confirm.button" />" onclick ="expandpool();">
<input type="button" name="close" value="<bean:message key="common.button.close" bundle="common"/>" onclick ="window.close();">
</center>
 
</html:form>
</body>
</html:html>