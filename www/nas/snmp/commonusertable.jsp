<!---
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: commonusertable.jsp,v 1.1 2005/08/21 04:49:28 zhangj Exp $" -->

<bean:define id="List" name="List" type="java.lang.String" scope="request"/> 
<bean:define id="userListName" name="userListName" type="java.lang.String" scope="request"/> 
<bean:define id="userList" name="<%=userListName%>" /> 
<nssorttab:table  tablemodel="<%=new ListSTModel((AbstractList)userList)%>" 
                      id="<%=List%>"
                      table="border=1"   
                      sortonload="user:ascend" >
                      
    <nssorttab:column name="user" 
                      th="STHeaderRender"
                      td="com.nec.nsgui.action.snmp.SnmpUserTNameRender"
                      sortable="yes">
        <bean:message key="snmp.user.th_userName"/>
    </nssorttab:column>
    
    <nssorttab:column name="authProtocol" 
                      th="STHeaderRender" 
                      td="STDataRender"
                      sortable="no">
        <bean:message key="snmp.user.th_authProtocol"/>
    </nssorttab:column> 
    
    <nssorttab:column name="privProtocol" 
                      th="STHeaderRender" 
                      td="STDataRender"
                      sortable="no">
        <bean:message key="snmp.user.th_privProtocol"/>
    </nssorttab:column>
</nssorttab:table>