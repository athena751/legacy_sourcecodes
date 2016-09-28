<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.        
-->

<!-- "@(#) $Id: ndmpdeviceinfo.jsp,v 1.3 2006/12/26 02:33:33 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
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
    window.location="ndmpDevice.do?operation=entryDeviceInfo";       
}
</script>
</head>
<body onload="setHelpAnchor('backup_ndmp_6');">         
    <form name="ndmpDeviceForm" method="post" > 
        <html:button property="refreshBtn" onclick="onRefresh();">
            <bean:message key="common.button.reload" bundle="common"/>
        </html:button><br><br>            
        <logic:empty name="deviceInfoList">
            <bean:message key="ndmp.device.noDevice"/>
        </logic:empty>
        <logic:notEmpty name="deviceInfoList">
        <bean:define id="hasRobot" value="0"/>
        <bean:define id="hasDrive" value="0"/>
            <logic:iterate id="deviceInfoBean" name="deviceInfoList">               
                <bean:define id="deviceType" name="deviceInfoBean" property="deviceType"/>
                <logic:equal name="deviceType" value="robot">
                    <logic:equal name="hasRobot" value="0">           
                        <h3 class="title"><bean:message key= "<%="ndmp.device.h3." + deviceType%>"/></h3>
                        <bean:define id="hasRobot" value="1"/>
                    </logic:equal> 
                </logic:equal>
                <logic:equal name="deviceType" value="drive">
                    <logic:equal name="hasDrive" value="0">           
                        <h3 class="title"><bean:message key= "<%="ndmp.device.h3." + deviceType%>"/></h3>
                        <bean:define id="hasDrive" value="1"/>
                    </logic:equal> 
                </logic:equal>    
                <table border="1" class="VerticalTop">
                    <tr>
                        <th><bean:message key="ndmp.device.table.deviceName"/></th>
                        <td><bean:define id="deviceName" name="deviceInfoBean" property="deviceName" type="java.lang.String"/>
                            <%=NSActionUtil.sanitize(deviceName)%></td>
                    <tr>
                    <tr>
                        <th><bean:message key="ndmp.device.table.modelName"/></th>
                        <td><bean:define id="modelName" name="deviceInfoBean" property="modelName" type="java.lang.String"/>
                            <%=NSActionUtil.sanitize(modelName)%></td>
                    <tr>
                    <tr>
                        <th><bean:message key="ndmp.device.table.contrlNo"/></th>
                        <td><bean:write name="deviceInfoBean" property="contrlNo"/></td>
                    <tr>
                    <tr>
                        <th><bean:message key="ndmp.device.table.channelNo"/></th>
                        <td><bean:write name="deviceInfoBean" property="channelNo"/></td>
                    <tr>
                    <tr>
                        <th><bean:message key="ndmp.device.table.id"/></th>
                        <td><bean:write name="deviceInfoBean" property="id"/></td>
                    <tr>
                    <tr>
                        <th><bean:message key="ndmp.device.table.lun"/></th>
                        <td><bean:write name="deviceInfoBean" property="lun"/></td>
                    <tr>
                    <tr>
                        <th><bean:message key="ndmp.device.table.connectionType"/></th>
                        <td><bean:write name="deviceInfoBean" property="connectionType"/></td>
                    <tr>
                    <tr>
                        <th><bean:message key="ndmp.device.table.wwnn"/></th>
                        <td><bean:write name="deviceInfoBean" property="wwnn"/></td>
                    <tr>
                    <tr>
                        <th><bean:message key="ndmp.device.table.wwpn"/></th>
                        <td><bean:write name="deviceInfoBean" property="wwpn"/></td>
                    <tr>
                    <tr>
                        <th><bean:message key="ndmp.device.table.protID"/></th>
                        <td><bean:write name="deviceInfoBean" property="protID"/></td>
                    <tr>
                </table>
                <br>
           </logic:iterate>           
        </logic:notEmpty>
    </form>
</body>
</html>