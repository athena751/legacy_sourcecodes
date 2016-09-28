<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumebatchcreatespecifyconfirm.jsp,v 1.3 2007/07/09 06:53:03 jiangfx Exp $" -->

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
        
        window.opener.parent.location = "<%=contextPath%>/volume/volumeBatchCreate.do?operation=specifyCreate";
        
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
<table border="1" class="Vertical">
  <tr>
    <th colspan="2"><bean:message key="text.volume.num"/></th>
    <td><bean:write name="volNum" scope="session"/></td>
  </tr>
  <tr>
    <th colspan="2"><bean:message key="text.volume.size"/></th>
    <td><bean:write name="capacity" scope="session"/>
        <logic:equal name="unit" value="gb" scope="session">
            <bean:message key="select.volume.size.unit.gb"/>
        </logic:equal>
        <logic:notEqual name="unit" value="gb" scope="session">
            <bean:message key="select.volume.size.unit.tb"/>
        </logic:notEqual>
    </td>
  </tr>
  <tr>
    <th colspan="2"><bean:message key="text.volume.baseName"/></th>
    <td>
       <logic:equal name="volume_confirmVolume" property="volumeNameExist" value="true" scope="session">
         <font color=red><i>
       </logic:equal>
         <bean:write name="volume_confirmVolume" property="volumeName" scope="session"/>
       <logic:equal name="volume_confirmVolume" property="volumeNameExist" value="true" scope="session">
         </i></font>
       </logic:equal>       
    </td>
  </tr>
  <tr>
    <th colspan="2"><bean:message key="info.fsType"/></th>
    <td><bean:write name="volume_confirmVolume" property="fsType" scope="session"/></td>
  </tr>
  <tr>
    <th colspan="2"><bean:message key="text.volume.baseMP"/></th>
    <logic:equal name="volume_confirmVolume" property="MPNameExist" value="true">
        <td>
        <font color=red><i>
        <bean:write name="volume_confirmVolume" property="mountPoint"/>
        </i></font>
        </td>
    </logic:equal>
    

    <logic:notEqual name="volume_confirmVolume" property="MPNameExist" value="true">
        <logic:equal name="volume_confirmVolume" property="MPErrorCode" value="0">
            <td>
            <bean:write name="volume_confirmVolume" property="mountPoint"/>
            </td>
        </logic:equal>
    
        <logic:equal name="volume_confirmVolume" property="MPErrorCode" value="1">
            <td title="<bean:message key="msg.batchcreateconfirm.mperr.fsTypeDif"/>">
            <font color="red"><i>
            <bean:write name="volume_confirmVolume" property="mountPoint"/>
            </i></font>
            </td>
        </logic:equal>
    
        <logic:equal name="volume_confirmVolume" property="MPErrorCode" value="2">
            <td title="<bean:message key="msg.batchcreateconfirm.mperr.parentUmount"/>">
            <font color="red"><i>
            <bean:write name="volume_confirmVolume" property="mountPoint"/>
            </i></font>
            </td>
        </logic:equal> 
    
        <logic:equal name="volume_confirmVolume" property="MPErrorCode" value="3">
            <td title="<bean:message key="msg.batchcreateconfirm.mperr.parentRO"/>">
            <font color="red"><i>
            <bean:write name="volume_confirmVolume" property="mountPoint"/>
            </i></font>
            </td>
        </logic:equal> 
    
        <logic:equal name="volume_confirmVolume" property="MPErrorCode" value="4">
            <td title="<bean:message key="msg.batchcreateconfirm.mperr.parentHasReplication"/>">
            <font color="red"><i>
            <bean:write name="volume_confirmVolume" property="mountPoint"/>
            </i></font>
            </td>
        </logic:equal> 
    
        <logic:equal name="volume_confirmVolume" property="MPErrorCode" value="5">
            <td title="<bean:message key="msg.batchcreateconfirm.mperr.subMountExist"/>">
            <font color="red"><i>
            <bean:write name="volume_confirmVolume" property="mountPoint"/>
            </i></font>
            </td>
        </logic:equal> 
    </logic:notEqual>
  </tr>
  <tr valign="top">
    <th rowspan="3"><bean:message key="info.option"/></th>
    <th><bean:message key="info.quota"/></th>
    <td>
        <logic:equal name="quota" value="on" scope="session">
            <img src="/nsadmin/images/nation/check.gif">
        </logic:equal>    
        <logic:notEqual name="quota" value="on" scope="session">
            &nbsp;
        </logic:notEqual> 
    </td>
  </tr>
  <tr>
    <th><bean:message key="info.noatime"/></th>
    <td>
        <logic:equal name="atime" value="on" scope="session">
            <img src="/nsadmin/images/nation/check.gif">
        </logic:equal> 
        <logic:notEqual name="atime" value="on" scope="session">
            &nbsp;
        </logic:notEqual> 
    </td>
  </tr>
  <tr>
    <th><bean:message key="info.batchcreateshow.replication"/></th>
    <td>
        <logic:equal name="replication" value="on" scope="session">
            <img src="/nsadmin/images/nation/check.gif">
        </logic:equal> 
        <logic:notEqual name="replication" value="on" scope="session">
            &nbsp;
        </logic:notEqual> 
    </td>
  </tr>
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

