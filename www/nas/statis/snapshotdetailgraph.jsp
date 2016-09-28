<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: snapshotdetailgraph.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-bean"    prefix="bean" %>
<%@ taglib uri="struts-logic"   prefix="logic"%>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>
<%@ page import="com.nec.nsgui.model.entity.statis.DeviceInfoBean" %>

<html>
<head>
	<title>
		<bean:message name="watchItemDesc" scope="request"/>
	</title>
	<%@include file="../../common/head.jsp" %>
</head>

<body>
<p>
<h1 class="popup">
    <bean:message name="watchItemDesc" scope="request"/>
</h1>
</p>

<logic:equal name="returnValue" value="2">
	<script language="JavaScript"> 
        alert("<bean:message key="statis.snapshot.snmp_connect_timeout"/>");
	</script>
</logic:equal>

<h2 class="popup">
    <bean:define id="nickName" name="nickName" type="java.lang.String"/>
    <bean:message key='statis.snapshot.detail.h2_graphdetail' arg0='<%=nickName%>'/>
</h2>

<logic:equal name="returnValue" value="0">
	<br>
	<table border="1" class="Vertical">
	    <bean:define id="device" name="deviceInfo" type="com.nec.nsgui.model.entity.statis.DeviceInfoBean"/>
	    <tr>
	        <th rowspan="6">
	            <IMG src=<%=NSActionConst.CONFIG_ROOT_PATH%>/cgi/GDPieCGI.pl?us=<%=device.getUsedRate()%>&id=1&wd=<bean:write name="sWidth"/>&ht=<bean:write name="sHeight"/>>
	        </th>
	        <th><bean:message key="statis.snapshot.common.href_type"/></th>
	        <td><%=device.getSType()%></td>
	    </tr>
	    <tr>
	        <th><bean:message key="statis.snapshot.common.href_total"/></th>
	        <td>
	            <logic:equal name="watchItemId" value="Disk_Used_Rate">
	                <%=(String)(device.getTotal() + "GB")%>
	            </logic:equal>
	            <logic:equal name="watchItemId" value="Inode_Used_Rate">
	                <%=Long.toString((long) device.getTotal())%>
	            </logic:equal>
	        </td>
	    </tr>
	    <tr>
	        <th><bean:message key="statis.snapshot.common.href_used"/></th>
	        <td>
	            <logic:equal name="watchItemId" value="Disk_Used_Rate">
	                <%=(String)(device.getUsed()+"GB")%>(<%=device.getUsedRate()%>%)
	            </logic:equal>
	            <logic:equal name="watchItemId" value="Inode_Used_Rate">
	                <%=Long.toString((long) device.getUsed())%>(<%=device.getUsedRate()%>%)
	            </logic:equal>
	        </td>
	    </tr>
	    <tr>
	        <th><bean:message key="statis.snapshot.common.href_avai"/></th>
	        <td>
	            <%double tmpAvail = Math.round((100 - device.getUsedRate())*10)/10.0;%>
	            <logic:equal name="watchItemId" value="Disk_Used_Rate">
	                <%=(String)(device.getAvailable()+"GB")%>(<%=tmpAvail%>%)
	            </logic:equal>
	            <logic:equal name="watchItemId" value="Inode_Used_Rate">
	                <%=Long.toString((long) device.getAvailable())%>(<%=tmpAvail%>%)
	            </logic:equal>
	        </td>
	    </tr>
	    <tr>
	        <th><bean:message key="statis.snapshot.common.href_device"/></th>
	        <td><%=device.getSDevice()%></td>
	    </tr>
	    <tr>
	        <th><bean:message key="statis.snapshot.common.href_mp"/></th>
	        <td><%=device.getSMountPoint()%></td>
	    </tr>
	</table>
</logic:equal>

<logic:equal name="returnValue" value="2">
    <bean:message key="statis.snapshot.snmp_connect_timeout"/>
</logic:equal>

<br>
<form>
    <input type="button" name="close" value="<bean:message key="common.button.close" bundle="common"/>" onclick="window.close();">
</form>
</body>
</html>