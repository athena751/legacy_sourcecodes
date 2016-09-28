<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicdetaillinkinformation.jsp,v 1.2 2005/10/24 04:40:02 dengyp Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>

<logic:notEmpty name="detailLink" >
<table border="1" class="Vertical">
    <logic:iterate id="detailLinklist" name="detailLink" > 
    <tr>
        <th ><bean:message key="nic.detail.linkstatus" /></th>        
            <logic:equal name="detailLinklist" property="linkStatus" value="UP">
               <td align="center"> <img border="0" src="/nsadmin/images/nation/correct.gif" /></td>
            </logic:equal>
            <logic:equal name="detailLinklist" property="linkStatus" value="DOWN">
                <td>--</td>
            </logic:equal>		
    </tr>   
    <tr>
        <th  align="left"><bean:message key="nic.detail.communication" /></th> 
        <td nowrap align="left">
        <bean:write name="detailLinklist" property="communicationStatus" />&nbsp;
        <logic:equal name="detailLinklist" property="autoNego" value="enable">
            <bean:message key="nic.detail.autorecognition" />
        </logic:equal>
        </td>
    </tr>
    </logic:iterate>
</table>
</logic:notEmpty>

