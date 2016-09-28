<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicdetaillinkinformationbond.jsp,v 1.2 2005/10/24 04:40:02 dengyp Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<table border="1">
    <tr>
        <th align="center"><bean:message key="nic.list.table.head.construction" /></th>
        <th align="center"><bean:message key="nic.detail.linkstatus" /></th>   
        <th align="center"><bean:message key="nic.detail.mac" /></th>    
        <th align="center"><bean:message key="nic.detail.communication" /></th>
    </tr> 
    <logic:iterate id="detailLink" name="detailLink" >
    <tr>
        <td nowrap align="left"><bean:write name="detailLink" property="nicName" /></td>      
        <td nowrap align="center">
            <logic:equal name="detailLink" property="linkStatus" value="UP">
                 <img border="0" src="/nsadmin/images/nation/correct.gif" />
		    </logic:equal>
		    <logic:equal name="detailLink" property="linkStatus" value="DOWN">
                 --
		    </logic:equal>
		</td>       
        <td nowrap <logic:equal name="detailLink" property="macAddress" value="--">align="center"</logic:equal>>       
            <bean:write name="detailLink" property="macAddress" />           
        </td> 		 
        <td nowrap align="left">       
            <bean:write name="detailLink" property="communicationStatus" />&nbsp;
            <logic:equal name="detailLink" property="autoNego" value="enable">
                <bean:message key="nic.detail.autorecognition" />
            </logic:equal>
        </td>
    </tr>
    </logic:iterate>
</table>

