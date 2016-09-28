<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: snmpcommoninfolist.jsp,v 1.2 2007/07/11 12:04:40 hetao Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="com.nec.nsgui.taglib.nssorttab.*,com.nec.nsgui.action.base.*,java.util.*"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>

<h3 class="title"><bean:message key="snmp.title.system"/></h3>
    <bean:define id="contactString" value="contact" toScope="request"/>
    <bean:define id="locationString" value="location" toScope="request"/> 
    <%@include file="commonsysteminfotable.jsp" %> 
<br>
<h3 class="title"><bean:message key="snmp.title.comunity"/></h3>
<logic:empty name="communityList" scope="request">
  <bean:message key="snmp.snmplist.community.nocommunity"/>
</logic:empty>
<logic:notEmpty name="communityList" scope="request">
    <bean:define id="communityList" name="communityList" scope="request"/> 
    <nssorttab:table  tablemodel="<%=new ListSTModel((AbstractList)communityList)%>" 
                      id="list1"
                      table="border=1"   
                      sortonload="communityName:ascend" >
            <nssorttab:column name="communityName" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.snmp.SnmpComTDataRender"
                              sortable="yes">
               <bean:message key="snmp.community.th_communityname"/>
            </nssorttab:column>
    
            <nssorttab:column name="clientoption" 
                              th="com.nec.nsgui.action.snmp.SnmpSrcTHeaderRender" 
                              td="com.nec.nsgui.action.snmp.SnmpSrcTDataRender"
                              sortable="no">
                   <bean:message key="snmp.community.th_source"/>,
                   <bean:message key="snmp.community.readLabel"/>,
                   <bean:message key="snmp.community.writeLabel"/>,
                   <bean:message key="snmp.community.th_trap"/>,
                   <bean:message key="snmp.community.th_snmpversion"/>
            </nssorttab:column>
    </nssorttab:table>
</logic:notEmpty>
<br>
<h3 class="title"><bean:message key="snmp.title.user"/></h3>
<logic:empty name="userList" scope="request">
  <bean:message key="snmp.snmplist.user.nouser"/>
</logic:empty>
<logic:notEmpty name="userList" scope="request" scope="request"> 
    <bean:define id="List" value="list3" toScope="request"/>
    <bean:define id="userListName" value="userList" toScope="request"/> 
    <%@include file="commonusertable.jsp" %>    
</logic:notEmpty>
