<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicdetailtop.jsp,v 1.6 2007/08/28 07:12:38 fengmh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
</head>
<body onload="setHelpAnchor('s_network_6');" onUnload="setHelpAnchor('s_network_1');">

<logic:present name="interfaceNameForm" property="nic_from4change">
  <logic:equal name="interfaceNameForm" property="nic_from4change" value="service">
        <h1 class="popup"><bean:message key="nic.h1.servicenetwork"/></h1>
  </logic:equal>
  <logic:equal name="interfaceNameForm" property="nic_from4change" value="admin">
        <h1 class="popup"><bean:message key="nic.h1.adminnetwork"/></h1>
  </logic:equal>
</logic:present>
<h2 class="popup"><bean:message key="nic.h2.nicDetail"/></h2>
<logic:notPresent name="detailBase" scope="request">
		<bean:message key="nic.detail.error" />
</logic:notPresent>
<logic:present name="detailBase" scope="request">
<h3 class="popup"><bean:message key="nic.h3.basic"/></h3>
<table border="1">
    <tr>
        <th colspan="2" align="left"><bean:message key="nic.list.table.head.name" /></th>
        <td nowrap align="left"><bean:write name="detailBase" property="nicName" /></td>
    </tr>
    <logic:present name="linkAndWorkStatus">
    <tr>
        <th colspan="2" align="left"><bean:message key="nic.list.table.head.status" /></th>        
    	<td>    
    	    <logic:equal name="linkAndWorkStatus" value="UP">
			    <bean:message key="nic.detail.status.normal" />
		    </logic:equal>
	    	<logic:equal name="linkAndWorkStatus" value="DOWN">
			    <b><font color="red"><bean:message key="nic.detail.status.error" /></fond></b>
		    </logic:equal>	
            <logic:equal name="linkAndWorkStatus" value="IPNULL">
                <bean:message key="nic.detail.status.ipnull" />
            </logic:equal>  		        
		</td>    
    </tr>
    </logic:present>
    <tr>
        <th colspan="2" align="left"><bean:message key="nic.list.table.head.type" /></th>
        <td nowrap align="left">
        <logic:equal name="detailBase" property="type" value="NORMAL" >
            <bean:message key="nic.list.table.data.normal" />
        </logic:equal>
        <logic:equal name="detailBase" property="type" value="TOE" >
            <bean:message key="nic.list.table.data.toe" />
        </logic:equal>     
        <logic:equal name="detailBase" property="type" value="MIX" >
            <bean:message key="nic.list.table.data.normaltoe" />
        </logic:equal>    
        </td>
    </tr>
    <tr>
        <th colspan="2" align="left"><bean:message key="nic.detail.mac" /></th>
	    <td nowrap align="left"><bean:write name="detailBase" property="macAddress" /></td>
    </tr>
    <tr>
        <th colspan="2" align="left"><bean:message key="nic.detail.ipaddress" /></th>
	    <td nowrap align="left"><bean:write name="detailBase" property="address" /></td>
    </tr>
    <tr>
        <th colspan="2" align="left"><bean:message key="nic.route.table.head.netmask" /></th>
	    <td nowrap align="left"><bean:write name="detailBase" property="netmask" /></td>
    </tr>
    <tr>
        <th colspan="2" align="left"><bean:message key="nic.list.table.head.gateway" /></th>
	    <td nowrap align="left"><bean:write name="detailBase" property="gateway" /></td>
    </tr>
    <tr>
        <th colspan="2" align="left"><bean:message key="nic.detail.broadcast" /></th>
	    <td nowrap align="left"><bean:write name="detailBase" property="broadcast" /></td>
    </tr>
    <tr>
        <th colspan="2" align="left"><bean:message key="nic.list.table.head.mtu" /></th>
        <td nowrap align="left"><bean:write name="detailBase" property="mtu" /></td>
     </tr> 
    <logic:present name="bondInfo" >
    <tr>
        <th rowspan="3" align="left"><bean:message key="nic.list.table.head.extension" /></th>
        <th align="left"><bean:message key="nic.bond.mode" /></th>
        <td nowrap >
           <logic:equal name="bondInfo" property="mode" value="AB"><bean:message key="nic.bond.mode.AB"/></logic:equal>
           <logic:equal name="bondInfo" property="mode" value="BA"><bean:message key="nic.bond.mode.BA"/></logic:equal>
           <logic:equal name="bondInfo" property="mode" value="LA"><bean:message key="nic.bond.mode.LA"/></logic:equal>
           <logic:equal name="bondInfo" property="mode" value="--"><bean:write  name="bondInfo" property="mode"/></logic:equal>
        </td>
    </tr>
    <tr>
        <th align="left"><bean:message key="nic.bond.primary" /></th>
        <td nowrap >
           <bean:write name="bondInfo" property="primaryIF"/>
        </td>
    </tr>
    <tr>
        <th align="left"><bean:message key="nic.bond.interval" /></th>
        <td nowrap >
           <bean:write name="bondInfo" property="interval" />
            <logic:notEqual name="bondInfo" property="interval" value="--">
                 <bean:message key="nic.detail.msecond" />
            </logic:notEqual> 
        </td>
    </tr>
    </logic:present>
    <logic:present name="vid4nic">
   <tr>
        <th colspan="2" align="left"><bean:message key="nic.vlan.vid" /></th>
        <td nowrap>
           <bean:write name="vid4nic" />
        </td>
    </tr>
    </logic:present>
    <logic:present name="parentInterfaceName">
   <tr>
        <th colspan="2" align="left"><bean:message key="nic.detail.parentinterfacename" /></th>
        <td nowrap>
           <bean:write name="parentInterfaceName" />
        </td>
    </tr>
    </logic:present>
    <logic:equal name="machineSeries" value="Procyon" scope="session">
        <logic:present name="alias_num">
          <tr>
            <th colspan="2" align="left"><bean:message key="nic.detail.alias_num" /></th>
            <td nowrap>
               <bean:write name="alias_num" />
            </td>
          </tr>
        </logic:present>
        <logic:present name="alias_baseIF">
          <tr>
            <th colspan="2" align="left"><bean:message key="nic.detail.alias_baseIF" /></th>
            <td nowrap>
               <bean:write name="alias_baseIF" />
            </td>
          </tr>
        </logic:present>
    </logic:equal>
</table>
<h3 class="popup"><bean:message key="nic.h3.link"/></h3>

<logic:equal name="bondInfo" property="mode" value="LA">
    <jsp:include page="../nic/nicdetaillinkinformationbond.jsp" />
</logic:equal>
<logic:equal name="bondInfo" property="mode" value="BA">
    <jsp:include page="../nic/nicdetaillinkinformationbond.jsp" />
</logic:equal>
<logic:equal name="bondInfo" property="mode" value="AB">
    <jsp:include page="../nic/nicdetaillinkinformation4ab.jsp" />
</logic:equal>
<logic:equal name="bondInfo" property="mode" value="--">
    <jsp:include page="../nic/nicdetaillinkinformation.jsp" />
</logic:equal>
</logic:present>
</body>
</html>
