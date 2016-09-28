<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.        
-->

<!-- "@(#) $Id: ndmpconfiginfo.jsp,v 1.3 2006/12/26 02:24:06 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html>
<head>
<%@include file="../../common/head.jsp"%>  
<script language="JavaScript" src="../common/common.js"></script>
<script language="javascript">
function onRefresh(){    
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="ndmpConfig.do?operation=getNdmpConfigInfo";       
}
</script>
</head>
<body onload="setHelpAnchor('backup_ndmp_3');">         
    <form name="ndmpConfigForm" method="post" >   
        <html:button property="refreshBtn" onclick="onRefresh();">
            <bean:message key="common.button.reload" bundle="common"/>
        </html:button><br><br> 
        <logic:equal name="ndmpInfoBean" property="defaultVersion" value="2">
            <logic:empty name="ndmpInfoBean" property="backupSoftware">
                <bean:message key="ndmp.message.notSet"/>
            </logic:empty>
            <logic:notEmpty name="ndmpInfoBean" property="backupSoftware">
                 <table border="1" class="VerticalTop">
                     <tr>
                         <th><bean:message key= "ndmp.info.table.defaultVersion"/></th>
                         <td><bean:write name="ndmpInfoBean" property="defaultVersion"/>&nbsp;</td>
                     </tr>
                     <tr>
                         <th><bean:message key= "ndmp.info.table.dataConnectionIP"/></th>
                         <td><bean:write name="ndmpInfoBean" property="dataConnectionIPV2"/>&nbsp;</td>
                     </tr>
                     <tr>
                         <th><bean:message key= "ndmp.info.table.backupSoftware"/></th>
                         <td><bean:write name="ndmpInfoBean" property="backupSoftware"/>&nbsp;</td>
                     </tr>
                 </table>
            </logic:notEmpty>
        </logic:equal> 
        <logic:notEqual name="ndmpInfoBean" property="defaultVersion" value="2">           
        <logic:empty name="ndmpInfoBean" property="ctrlConnectionIP">
            <bean:message key="ndmp.message.notSet"/>
        </logic:empty>
        <logic:notEmpty name="ndmpInfoBean" property="ctrlConnectionIP">
            <table border="1" class="VerticalTop">                
                <tr>
                    <th><bean:message key= "ndmp.info.table.defaultVersion"/></th>
                    <td><bean:write name="ndmpInfoBean" property="defaultVersion"/>&nbsp;</td>
                </tr>
                <tr>
                    <th><bean:message key= "ndmp.info.table.DMAIP"/></th>
                    <td><logic:notEmpty name="ndmpInfoBean" property="authorizedDMAIP">
                            <table border="0">
                              <tr><td>
                                <bean:define id="backupIP" name="ndmpInfoBean" property="authorizedDMAIP"/>
                                <%=((String)backupIP).trim().replaceAll("\\s+", "<br>") %>  
                              </td></tr>                              
                            </table border="0"> 
                       </logic:notEmpty>   
                       <logic:empty name="ndmpInfoBean" property="authorizedDMAIP"> 
                            &nbsp;
                       </logic:empty> </td>
                </tr>
                <tr>
                    <th><bean:message key= "ndmp.info.table.ctrlConnectionIP"/></th>
                    <td><table border="0">
                        <logic:iterate id="ctrlIP" name="ndmpInfoBean" property="ctrlConnectionIP">
                            <tr><td><bean:write name="ctrlIP"/></td></tr>
                        </logic:iterate>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th><bean:message key= "ndmp.info.table.dataConnectionIP"/></th>
                    <td><logic:notEmpty name="ndmpInfoBean" property="dataConnectionIP">
                            <table border="0">
                                <logic:iterate id="dataIP" name="ndmpInfoBean" property="dataConnectionIP">
                                    <tr><td><bean:write name="dataIP"/></td></tr>
                                </logic:iterate>
                            </table border="0"> 
                       </logic:notEmpty>   
                       <logic:empty name="ndmpInfoBean" property="dataConnectionIP"> 
                            &nbsp;
                       </logic:empty>                 
                    </td>
                </tr>                
            </table>
        </logic:notEmpty>
        </logic:notEqual>
    </form>
</body>
</html>
