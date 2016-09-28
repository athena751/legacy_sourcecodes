<!---
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: commonsysteminfotable.jsp,v 1.2 2005/08/24 08:19:32 cuihw Exp $" -->
<bean:define id="contactString" name="contactString" type="java.lang.String" scope="request"/> 
<bean:define id="locationString" name="locationString" type="java.lang.String" scope="request"/> 
<bean:define id="contact"   name="<%=contactString%>"  type="java.lang.String"/>
<bean:define id="location"  name="<%=locationString%>" type="java.lang.String"/>
<table border="1" class="Vertical">
    <tr>
        <th width="30%"><bean:message key="snmp.sysinfo.th_contact"/></th>
        <td> 
            <%=NSActionUtil.sanitize(contact,true)%>
        </td>
    </tr>
    <tr>
        <th width="30%"><bean:message key="snmp.sysinfo.th_location"/></th>
        <td>
            <%=NSActionUtil.sanitize(location,true)%>
        </td>
    </tr>
</table>