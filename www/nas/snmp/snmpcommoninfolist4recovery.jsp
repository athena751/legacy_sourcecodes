<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: snmpcommoninfolist4recovery.jsp,v 1.1 2005/08/21 04:49:28 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="com.nec.nsgui.taglib.nssorttab.*,com.nec.nsgui.action.base.*,java.util.*"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>

<h3 class="title"><bean:message key="snmp.title.system"/></h3>
<h4 class="title">&nbsp;&nbsp;<bean:message key="snmp.title.node0"/></h4>
    <bean:define id="contactString" value="contact0" toScope="request"/>
    <bean:define id="locationString" value="location0" toScope="request"/> 
    <%@include file="commonsysteminfotable.jsp" %> 
<br>
<h4 class="title">&nbsp;&nbsp;<bean:message key="snmp.title.node1"/></h4>
    <bean:define id="contactString" value="contact1" toScope="request"/>
    <bean:define id="locationString" value="location1" toScope="request"/> 
    <%@include file="commonsysteminfotable.jsp" %> 
<br>
<h3 class="title"><bean:message key="snmp.title.comunity"/></h3>
<h4 class="title">&nbsp;&nbsp;<bean:message key="snmp.title.node0"/></h4>  
<logic:empty name="communityList0" scope="session" >
  <bean:message key="snmp.snmplist.community.nocommunity"/>
</logic:empty>
<logic:notEmpty name="communityList0" scope="session">
	<bean:define id="List" value="list1" toScope="request"/>
	<bean:define id="communityListName" value="communityList0" toScope="request"/> 
    <%@include file="commoncommunitytable4recovery.jsp" %> 
</logic:notEmpty>
<br>
<h4 class="title">&nbsp;&nbsp;<bean:message key="snmp.title.node1"/></h4>
<logic:empty name="communityList1" scope="session" >
  <bean:message key="snmp.snmplist.community.nocommunity"/>
</logic:empty>
<logic:notEmpty name="communityList1" scope="session">
	<bean:define id="List" value="list2" toScope="request"/>
	<bean:define id="communityListName" value="communityList1" toScope="request"/> 
    <%@include file="commoncommunitytable4recovery.jsp" %> 
</logic:notEmpty>
<br>
<h3 class="title"><bean:message key="snmp.title.user"/></h3>
<h4 class="title">&nbsp;&nbsp;<bean:message key="snmp.title.node0"/></h4>
<logic:empty name="userList0" scope="session">
  <bean:message key="snmp.snmplist.user.nouser"/>
</logic:empty>
<logic:notEmpty name="userList0" scope="request" scope="session"> 
	<bean:define id="List" value="list3" toScope="request"/>
	<bean:define id="userListName" value="userList0" toScope="request"/> 
	<%@include file="commonusertable.jsp" %>  	
</logic:notEmpty>
<br>
<h4 class="title">&nbsp;&nbsp;<bean:message key="snmp.title.node1"/></h4>
<logic:empty name="userList1" scope="session" >
  <bean:message key="snmp.snmplist.user.nouser"/>
</logic:empty>
<logic:notEmpty name="userList1" scope="request" scope="session"> 
	<bean:define id="List" value="list4" toScope="request"/>
	<bean:define id="userListName" value="userList1" toScope="request"/> 
	<%@include file="commonusertable.jsp" %>  	
</logic:notEmpty>