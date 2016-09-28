<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumebatchcreateconfirm.jsp,v 1.7 2008/05/24 12:19:33 liuyq Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ page import="java.lang.Double" %>
<%@ page import="java.text.DecimalFormat" %>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript" src="/nsadmin/common/validation.js"></script>
<title>
<bean:message key="title.batchcreateconfirm.h3"/>
</title>
<%
String contextPath = request.getContextPath();
%>
<script language="JavaScript">
function onSet() {
    if(!isSubmitted()){
        setSubmitted();
        
        window.opener.parent.location = "<%=contextPath%>/volume/volumeBatchCreate.do?operation=create";
        
        window.close();
    }
}

function onClose(){
    window.close();
}

</script>
</head>

<body>
<h1><bean:message key="title.h1"/></h1>
<h2><bean:message key="title.batchcreateshow.h2"/></h2>
<h3><bean:message key="title.batchcreateconfirm.h3"/></h3>

<logic:equal name="volume_confirmError" value="UsePairedLds4SyncfsError" scope="request">
    <bean:message key="msg.batchcreateconfirm.UsePairedLds4SyncfsError"/>
</logic:equal>

<logic:equal name="volume_confirmError" value="volumeSameNameError" scope="request">
    <bean:message key="msg.batchcreateconfirm.samenameerr"/>
</logic:equal>

<logic:equal name="volume_confirmError" value="MPSameNameError" scope="request">
    <bean:message key="msg.batchcreateconfirm.samenameerr"/>
</logic:equal>

<logic:equal name="volume_confirmError" value="mpError" scope="request">
    <bean:message key="msg.batchcreateconfirm.mperr"/>
</logic:equal>

<logic:equal name="volume_confirmError" value="none" scope="request">
	<logic:equal name="volumeLicense_exceed" value="true" scope="request">
	    <font color=red>
	    	<bean:message key="volumeLicense.exceed.volCreate"/>
	    </font>
	    <br>
	</logic:equal>
    <bean:message key="msg.batchcreateconfirm.note"/>
</logic:equal>

<form>
<table width="100%" border="1">
<tr>
<logic:equal name="volume_machineType" value="nashead" scope="request">
    <th rowspan="2"><bean:message key="info.storage"/></th>
    <th rowspan="2"><bean:message key="info.lun"/></th>
</logic:equal>
<logic:equal name="volume_machineType" value="nas" scope="request">
    <th rowspan="2"><bean:message key="pool.th.diskArrayName"/></th>
    <th rowspan="2"><bean:message key="pool.th.poolName"/></th>
    <th rowspan="2"><bean:message key="pool.th.poolNo"/></th>
</logic:equal>

<th rowspan="2"><bean:message key="title.h1"/></th>
<th rowspan="2"><bean:message key="info.batchcreateshow.size"/></th>
<th rowspan="2"><bean:message key="info.mountpoint"/></th>
<th rowspan="2"><bean:message key="info.fsType"/></th>
<th colspan="3"><bean:message key="info.option"/></th>
</tr>

<tr>
<th><bean:message key="info.quota"/></th>
<th><bean:message key="info.noatime"/></th>
<!--<th><bean:message key="info.dmapi"/></th>-->
<th><bean:message key="info.batchcreateshow.replication"/></th>
</tr>


<logic:iterate id="oneVolumeConfirm" name="volume_confirmVolumes">
    <tr>
    <logic:equal name="volume_machineType" value="nashead" scope="request">
        <td><bean:write name="oneVolumeConfirm" property="storage"/></td>
        <td>
        <logic:equal name="oneVolumeConfirm" property="usePairedLd4Syncfs" value="true">
            <font color=red><i><bean:write name="oneVolumeConfirm" property="lunDisplay"/></i></font>
        </logic:equal>
        <logic:notEqual name="oneVolumeConfirm" property="usePairedLd4Syncfs" value="true">
            <bean:write name="oneVolumeConfirm" property="lunDisplay"/>
        </logic:notEqual>
        </td>
    </logic:equal>
    
    <logic:equal name="volume_machineType" value="nas" scope="request">
        <td><bean:write name="oneVolumeConfirm" property="aname"/></td>
        <td><bean:write name="oneVolumeConfirm" property="poolName"/></td>
        <td><bean:write name="oneVolumeConfirm" property="poolNo"/></td>
    </logic:equal>	
    	
    <td>
    <logic:equal name="oneVolumeConfirm" property="volumeNameExist" value="true">
        <font color=red><i>
    </logic:equal>
        <bean:write name="oneVolumeConfirm" property="volumeName"/>
    <logic:equal name="oneVolumeConfirm" property="volumeNameExist" value="true">
        </i></font>
    </logic:equal>
    </td>	
    
    <td align="right"><bean:define id="showCap" name="oneVolumeConfirm" property="capacity" type="java.lang.String"/>
        <%=(new DecimalFormat("#,##0.0")).format(new Double(showCap))%>
    </td>
    
    
    <logic:equal name="oneVolumeConfirm" property="MPNameExist" value="true">
        <td>
        <font color=red><i>
        <bean:write name="oneVolumeConfirm" property="mountPoint"/>
        </i></font>
        </td>
    </logic:equal>
    

    <logic:notEqual name="oneVolumeConfirm" property="MPNameExist" value="true">
        <logic:equal name="oneVolumeConfirm" property="MPErrorCode" value="0">
            <td>
            <bean:write name="oneVolumeConfirm" property="mountPoint"/>
            </td>
        </logic:equal>
    
        <logic:equal name="oneVolumeConfirm" property="MPErrorCode" value="1">
            <td title="<bean:message key="msg.batchcreateconfirm.mperr.fsTypeDif"/>">
            <font color="red"><i>
            <bean:write name="oneVolumeConfirm" property="mountPoint"/>
            </i></font>
            </td>
        </logic:equal>
    
        <logic:equal name="oneVolumeConfirm" property="MPErrorCode" value="2">
            <td title="<bean:message key="msg.batchcreateconfirm.mperr.parentUmount"/>">
            <font color="red"><i>
            <bean:write name="oneVolumeConfirm" property="mountPoint"/>
            </i></font>
            </td>
        </logic:equal> 
    
        <logic:equal name="oneVolumeConfirm" property="MPErrorCode" value="3">
            <td title="<bean:message key="msg.batchcreateconfirm.mperr.parentRO"/>">
            <font color="red"><i>
            <bean:write name="oneVolumeConfirm" property="mountPoint"/>
            </i></font>
            </td>
        </logic:equal> 
    
        <logic:equal name="oneVolumeConfirm" property="MPErrorCode" value="4">
            <td title="<bean:message key="msg.batchcreateconfirm.mperr.parentHasReplication"/>">
            <font color="red"><i>
            <bean:write name="oneVolumeConfirm" property="mountPoint"/>
            </i></font>
            </td>
        </logic:equal> 
    
        <logic:equal name="oneVolumeConfirm" property="MPErrorCode" value="5">
            <td title="<bean:message key="msg.batchcreateconfirm.mperr.subMountExist"/>">
            <font color="red"><i>
            <bean:write name="oneVolumeConfirm" property="mountPoint"/>
            </i></font>
            </td>
        </logic:equal> 
    </logic:notEqual>

    
    	
    <td><bean:write name="oneVolumeConfirm" property="fsType"/></td>
	
    <logic:equal name="oneVolumeConfirm" property="quota" value="true">
        <td align="center"><img border="0" src="<%=contextPath%>/images/nation/check.gif"></td>
    </logic:equal>
    <logic:equal name="oneVolumeConfirm" property="quota" value="false">
        <td>&nbsp;</td>
    </logic:equal>  
	
    <logic:equal name="oneVolumeConfirm" property="noatime" value="true">
        <td align="center"><img border="0" src="<%=contextPath%>/images/nation/check.gif"></td>
    </logic:equal>
    <logic:equal name="oneVolumeConfirm" property="noatime" value="false">
        <td>&nbsp;</td>
    </logic:equal>

<!--    
    <logic:equal name="oneVolumeConfirm" property="dmapi" value="true">
        <td align="center"><img border="0" src="<%=contextPath%>/images/nation/check.gif"></td>
    </logic:equal>
    <logic:equal name="oneVolumeConfirm" property="dmapi" value="false">
        <td>&nbsp;</td>
    </logic:equal>	
-->    
    <logic:equal name="oneVolumeConfirm" property="replication" value="true">
        <td align="center"><img border="0" src="<%=contextPath%>/images/nation/check.gif"></td>
    </logic:equal>
    <logic:equal name="oneVolumeConfirm" property="replication" value="false">
        <td>&nbsp;</td>
    </logic:equal>
    </tr>
</logic:iterate>
</table>
<br>
<logic:equal name="volume_confirmError" value="none" scope="request">
    <input type="button" value='<bean:message key="common.button.submit" bundle="common"/>' onClick="onSet()">
</logic:equal>
<logic:notEqual name="volume_confirmError" value="none" scope="request">
    <input type="button" value='<bean:message key="common.button.submit" bundle="common"/>' disabled onClick="return false;">
</logic:notEqual>

<input type="button" value='<bean:message key="common.button.close" bundle="common"/>' onClick="onClose()">
</form>
</body>
</html:html>

