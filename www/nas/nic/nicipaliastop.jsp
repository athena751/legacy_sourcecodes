<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicipaliastop.jsp,v 1.2 2007/08/30 02:31:09 wanghb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
var buttonEnable = 0;

function selectChange(){
	var selBox = document.forms[0].elements["interfaceSet.nicName"];
	var tmp = selBox.options[selBox.selectedIndex].value.split("#");
	var address = tmp[1];
	var netmask = tmp[2];
	var alias = tmp[3];
    document.forms[0].elements["interfaceSet.netmask"].value=netmask;
    document.forms[0].elements["interfaceSet.alias"].value=alias;
    document.forms[0].netmask_text.value=netmask;
    document.forms[0].network.value=getNetwork(address,netmask);
    return true;
}

function init(){
setTimeout('parent.nicIPAliasBottom.location = "/nsadmin/nic/nicIPAliasBottom.do"',1);
<logic:notEqual name="alias_over_total" value="yes">
  <logic:notEmpty name="nicList">
    buttonEnable = 1;
    if(parent.nicIPAliasBottom.document && parent.nicIPAliasBottom.document.forms[0] && parent.nicIPAliasBottom.document.forms[0].set ) {
        parent.nicIPAliasBottom.changeButtonStatus();
    }
	var selBox = document.forms[0].elements["interfaceSet.nicName"];
	var tmp = selBox.options[selBox.selectedIndex].value.split("#");
	var address = tmp[1];
	var netmask = tmp[2];
	var alias = tmp[3];
    document.forms[0].elements["interfaceSet.netmask"].value=netmask;
    <logic:equal name="aliasID_need_change" value="yes">
      document.forms[0].elements["interfaceSet.alias"].value=alias;
    </logic:equal>
    document.forms[0].netmask_text.value=netmask;
    document.forms[0].network.value=getNetwork(address,netmask);
  </logic:notEmpty>
</logic:notEqual>
    return true;
}

function changeAliasNumber(){
    var aliasNumber = trim(document.forms[0].elements["interfaceSet.alias"].value);
    var avail = /[^0-9]/g;
    if(aliasNumber.length == 1 && aliasNumber.search(avail) == -1){
        aliasNumber="0"+aliasNumber;
    }
    document.forms[0].elements["interfaceSet.alias"].value=aliasNumber;
    return true;
}
</script>
</head>
<body onload="init();displayAlert();setHelpAnchor('s_network_8');">
<html:form action="nicIPAliasTop.do?operation=set">
<displayerror:error h1_key="nic.h1.servicenetwork"/>
<input type="hidden" name="nodeNo" value="<bean:write name="nodeNo"/>" />
<input type="hidden" name="network" value="" />
<nested:nest property="interfaceSet">
<nested:hidden property="netmask" />
<logic:equal name="alias_over_total" value="yes">
    <bean:message key="nic.alias.over.total"/>
</logic:equal>
<logic:notEqual name="alias_over_total" value="yes">
    <logic:empty name="nicList">
        <bean:message key="nic.alias.noset"/>
    </logic:empty>
    <logic:notEmpty name="nicList">
    <br>
    <table border="1" class="Vertical">
    <tr>
    <th nowrap><bean:message key="nic.route.table.head.nicname"/></th>    
    <td>
   	    <nested:select property="nicName" onchange="selectChange();">
   	 	    <logic:iterate id="nicList4alias" name="nicList">
   	 	        <bean:define id="nicName" name="nicList4alias" property="nicName" type="java.lang.String"/>
   	 		    <bean:define id="address" name="nicList4alias" property="address" type="java.lang.String"/>
   	 		    <bean:define id="netmask" name="nicList4alias" property="netmask" type="java.lang.String"/>
   	 		    <bean:define id="alias" name="nicList4alias" property="alias" type="java.lang.String"/>
	  	        <html:option value="<%=nicName + "#" + address + "#" + netmask + "#" + alias%>">
                    <bean:write name="nicList4alias" property="nicName"/>(<bean:write name="nicList4alias" property="address"/>)
	  	        </html:option>
	  		</logic:iterate>
	    </nested:select>
    </td>
    </tr>
    <tr>
        <th><bean:message key="nic.table.th.aliasnum" /></th>
		<td>
		    <logic:equal name="nodeNo" value="0" >
		       <bean:message key="nic.table.td.aliasnum.node0"/>
		    </logic:equal>
		    <logic:notEqual name="nodeNo" value="0" >
		       <bean:message key="nic.table.td.aliasnum.node1"/>
		    </logic:notEqual>
		    <nested:text property="alias" size="2" maxlength="2" onblur="changeAliasNumber();"/>
		    &nbsp<bean:message key="nic.table.td.aliasnum"/>
		</td>
	</tr>    
    <tr>
        <th><bean:message key="nic.interfaceChange.IP" /></th>
		<td><nested:text property="address" size="15" maxlength="15" /></td>
	</tr>
    <tr>
	     <th><bean:message key="nic.route.table.head.netmask" /></th>
		 <td><input type="text" name="netmask_text" size="15" maxlength="15" disabled /></td>
    </tr>
	<tr>
	     <th><bean:message key="nic.list.table.head.gateway" /></th>
		 <td><nested:text property="gateway" size="15" maxlength="15" /> <bean:message key="nic.interfaceChange.empty" /></td>
	</tr>
    </table>
    </logic:notEmpty>
</logic:notEqual>
</nested:nest>
</html:form>
</body>
</html>