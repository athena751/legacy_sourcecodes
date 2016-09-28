<!---
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: commoncommunitytable4recovery.jsp,v 1.2 2007/07/11 12:04:40 hetao Exp $" -->
<bean:define id="List" name="List" type="java.lang.String" scope="request"/> 
<bean:define id="communityListName" name="communityListName" type="java.lang.String" scope="request"/> 
<bean:define id="communityList" name="<%=communityListName%>" /> 
<nssorttab:table  tablemodel="<%=new ListSTModel((AbstractList)communityList)%>" 
                  id="<%=List%>"
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
               <bean:message key="snmp.community.th_snmpversion"/>,
               <bean:message key="snmp.community.filterLable"/>
               
               
        </nssorttab:column>
</nssorttab:table>