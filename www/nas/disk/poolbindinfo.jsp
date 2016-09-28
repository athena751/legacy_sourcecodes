<!--
        Copyright (c) 2006-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: poolbindinfo.jsp,v 1.4 2008/04/19 12:54:40 jiangfx Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <logic:equal name="poolInfoForm" property="poolinfo.raidtype" value="1" scope="request"> 
        document.getElementById('raditype').innerHTML="RAID1";
    </logic:equal>
    <logic:equal name="poolInfoForm" property="poolinfo.raidtype" value="5" scope="request"> 
        document.getElementById('raditype').innerHTML="RAID5";
    </logic:equal>
    <logic:equal name="poolInfoForm" property="poolinfo.raidtype" value="10" scope="request"> 
        document.getElementById('raditype').innerHTML="RAID10";
    </logic:equal>
    <logic:equal name="poolInfoForm" property="poolinfo.raidtype" value="50" scope="request"> 
        document.getElementById('raditype').innerHTML="RAID50";
    </logic:equal>
    <logic:equal name="poolInfoForm" property="poolinfo.raidtype" value="6_6" scope="request"> 
        document.getElementById('raditype').innerHTML="RAID6(4+PQ)";
    </logic:equal>
    <logic:equal name="poolInfoForm" property="poolinfo.raidtype" value="6_10" scope="request"> 
        document.getElementById('raditype').innerHTML="RAID6(8+PQ)";
    </logic:equal>
    
    <bean:define id="ca" name="exactcapacity" scope="request" type="java.lang.String"/>
    var exactcabyte =" ("+"<%=(new DecimalFormat("#,###")).format(new Double(ca))%>"+" <bean:message key="disk.pool.capacity.byte"/>"+")";
    var  tmp= parseInt("<%=ca%>");
    tmp = tmp/1024/1024/1024;
    tmp =tmp *10;
	tmp = parseInt(tmp);
	tmp = tmp /10;
    var ca = new Number(tmp);
    var exactcapacity = ca.toFixed(1)+"GB";
	document.getElementById('capacity').innerHTML=exactcapacity+exactcabyte;
}

function bindpool(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    document.forms[0].action = "bindpool.do";
    document.forms[0].submit();
    return true;
    
}

function backtobind(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    document.forms[0].action = "backtoselect.do?method=backtobind";
    document.forms[0].submit();
    return true;
}

</script>
<title><bean:message key="disk.pool.info.pool.h2"/></title>
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

<html:form action="backtoselect.do?method=backtobind">
<input type="button" name="backbutton" value="<bean:message key="common.button.back" bundle="common"/>" onclick ="backtobind();">
<h2 class="title"><bean:message key="disk.pool.info.pool.h2"/></h2>
<html:hidden property="diskarrayid"/>
<html:hidden property="arraytype"/>
<html:hidden property="from"/>
<html:hidden property="diskarrayname"/>
<html:hidden property="pdgroupnumber"/>
<html:hidden property="poolinfo.raidtype"/>
<html:hidden property="poolinfo.usedpd"/>
<html:hidden property="poolinfo.notusedpd"/>

<bean:message key="disk.pool.info"/>
<br><br>

<table>
<tr>
    <th align="left"><bean:message key="disk.pool.name"/></th>
    <td>:</td>
    <td><html:hidden property="poolinfo.poolname" write="true"/></td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.number"/></th>
    <td>:</td>
    <td><html:hidden property="poolinfo.poolnum" write="true"/>h</td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.raid.type"/></th>
    <td>:</td>
    <td><span id="raditype"></span></td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.rebuildtime"/></th>
    <td>:</td>
    <td><html:hidden property="poolinfo.rbtime" write="true"/><bean:message key="disk.pool.rebuildtime.time"/></td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.factcapacity"/></th>
    <td>:</td>
    <td><span id="capacity"></span></td>
</tr>
</table>
<br>
<hr>

<h3 class="title"><bean:message key="disk.pool.info.pd.h3"/></h3>
<table border=1> 
<tr><th><bean:message key="disk.pool.pd.use"/></th></tr>
<logic:iterate id="listLabel" name="usepdlist">
<tr><td><bean:write name="listLabel" property="label"/></td></tr>
</logic:iterate>
</table>
<br>
<hr>
<br>

<center>
<input type="button" name="set" value="<bean:message key="disk.pool.confirm.button" />" onclick ="bindpool();">
<input type="button" name="close" value="<bean:message key="common.button.close" bundle="common"/>" onclick ="window.close();">
</center>
 
</html:form>
</body>
</html:html>