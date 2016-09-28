<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicinterfacechangetop.jsp,v 1.12 2007/08/28 07:12:38 fengmh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page buffer="32kb" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html:html lang="true">
<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript">
	var buttonEnable = 0;
	var myIPAddress = 0;
	var myNetmask = 0;
	<logic:present name="interfaceSet">
	    myIPAddress = '<bean:write name="interfaceSet" property="address" />';
	    myNetmask = '<bean:write name="interfaceSet" property="netmask" />';
	</logic:present>
	
	
	function enableSet() {
		<logic:present name="interfaceSet">
			buttonEnable = 1;
			if(window.parent.frames[1].document&&window.parent.frames[1].document.forms[0]) {
				window.parent.frames[1].changeButtonStatus();
			}
		</logic:present>
	}
		
	function onBack() {
	    if(isSubmitted()){
	       return false;
	    }
	    setSubmitted();
		if(document.forms[0].nic_from4change.value=="service"){
    		parent.location = "/nsadmin/nic/nicList.do";
    	}else if(document.forms[0].nic_from4change.value=="bond"){
            parent.location = "/nsadmin/nic/bondShow.do";
        }else if(document.forms[0].nic_from4change.value=="vlan"){
    	    parent.location = "/nsadmin/nic/nicVlan.do";
    	}
		return true;
	}
		
	function init() {
		<logic:present name="interfaceSet">
            document.forms[0].netmask.value = document.forms[0].elements["interfaceSet.netmask"].value;
            document.forms[0].mtu.value = document.forms[0].elements["interfaceSet.mtu"].value;
			var mtuvalue= document.forms[0].mtu.value;
			<logic:notEqual name="interfaceSet" property="alias" value="">
			    document.forms[0].mtu[0].disabled = 1 ;
			    document.forms[0].mtu[1].disabled = 1 ;
			    document.forms[0].mtu[2].disabled = 1 ;
			    document.forms[0].netmask.disabled = 1 ;
			    document.forms[0].mtuText.disabled = 1;
			</logic:notEqual>
			<logic:equal name="interfaceSet" property="alias" value="">
                if(mtuvalue == "1500"){
                	document.forms[0].mtuText.disabled = 1;
                }else if(mtuvalue == "9000"){
                    document.forms[0].mtuText.disabled = 1;
                }
			</logic:equal>
			if(mtuvalue == "1500"){
                document.forms[0].mtu[0].checked = 1;             
            }else if(mtuvalue == "9000"){
                document.forms[0].mtu[1].checked = 1;
            }else{
                document.forms[0].mtu[2].checked =1;
            }
			document.forms[0].mtuText.value = mtuvalue;
		</logic:present>
	}		

	
	function autoSetNetmask() {
	   if (trim(document.forms[0].netmask.value) != ""
	       || !checkIP(trim(document.forms[0].elements["interfaceSet.address"].value))
	       || trim(document.forms[0].elements["interfaceSet.address"].value) == "0.0.0.0") 
	    return false;         
	   document.forms[0].netmask.value = getMaskFromIP(trim(document.forms[0].elements["interfaceSet.address"].value)) ;
	}

	function isValidMTU(str){
		if (str == ""){
    		return false;
		}
		var valid = /[^0-9]/g;
		var flag=str.search(valid);
		if(flag!=-1){
    		return false;
		} else {
    		var intValue = parseInt(str,10);
    		if((intValue >= 1500) && (intValue <= 9000)){
        		return true;
    		} else {
        		return false;
    		}
		}
	}
	
	var friendIP = "";
	var friendMTU = "";
	var friendNetmask = "";

	<logic:present name="interfaceSetFriend">
		friendIP = '<bean:write name="interfaceSetFriend" property="address" />';
		friendMTU = '<bean:write name="interfaceSetFriend" property="mtu" />';
		friendNetmask = '<bean:write name="interfaceSetFriend" property="netmask" />';
	</logic:present>
  var nodeNoConfirm ="";  
  <logic:present name="nodeNoConfirm">
     nodeNoConfirm = '<bean:write name="nodeNoConfirm" />';
  </logic:present>	
	
	var MTUSet = "";
	
	function getMTUSet(){
	    if(document.forms[0].mtu[0].checked){
			MTUSet = document.forms[0].mtu[0].value;
		}else if(document.forms[0].mtu[1].checked){
			MTUSet = document.forms[0].mtu[1].value;
		}else{
			MTUSet = document.forms[0].mtu[2].value;
		}
	}
	
	function checkMTUAndNetwork() {
		getMTUSet();
		if(friendIP == "" || friendIP == "--"){
			return "true";
		}
		var network = getNetwork(document.forms[0].elements["interfaceSet.address"].value , document.forms[0].netmask.value);
		var friendNetwork = getNetwork(friendIP , friendNetmask);
		if(network != friendNetwork && friendMTU != MTUSet) {
			return "both";
		}else if(friendMTU != MTUSet ){
			return "mtuNotMatch";
		}else if (network != friendNetwork){
		    return "networkNotMatch";	
		}
		return "true";
	}
	
	function onConfirm() {
		if (isSubmitted()){
			return false;
		}
		document.forms[0].elements["interfaceSet.address"].value = 
		     trim(document.forms[0].elements["interfaceSet.address"].value);
 		document.forms[0].netmask.value = 
         trim(document.forms[0].netmask.value);
        document.forms[0].elements["interfaceSet.gateway"].value = 
         trim(document.forms[0].elements["interfaceSet.gateway"].value);                 
                          	     
		if (!checkIP(document.forms[0].elements["interfaceSet.address"].value)) {
			alert("<bean:message key="nic.interfaceChange.invalidIP" />");
			document.forms[0].elements["interfaceSet.address"].focus();
			return false;
		}
		if(document.forms[0].elements["interfaceSet.address"].value == "0.0.0.0"){
		    alert('<bean:message key="alert.message.ipallzero" />');
		    document.forms[0].elements["interfaceSet.address"].focus();
            return false;
		}

		if(!checkAllMask(document.forms[0].netmask.value) 
		     || mask2int(document.forms[0].netmask.value)==-1 ) {
			alert("<bean:message key="nic.interfaceChange.invalidNetmask" />");
			document.forms[0].netmask.focus();
			return false;
		}
        <logic:equal name="interfaceSet" property="isAliasBase" value="yes">
		    var oldNetwork = getNetwork(myIPAddress, myNetmask);
            var newNetwork = getNetwork(document.forms[0].elements["interfaceSet.address"].value , document.forms[0].netmask.value);
            if(oldNetwork != newNetwork) {
                alert("<bean:message key="nic.interfaceChange.ipAliasBase.diffNetwork" />");
                document.forms[0].elements["interfaceSet.address"].focus();
                return false;
            }
        </logic:equal>
        <logic:notEqual name="interfaceSet" property="alias" value="">
		    var oldNetwork = getNetwork(myIPAddress, myNetmask);
            var newNetwork = getNetwork(document.forms[0].elements["interfaceSet.address"].value , document.forms[0].netmask.value);
            if(oldNetwork != newNetwork) {
                alert("<bean:message key="nic.interfaceChange.invalidIP.net" />");
                document.forms[0].elements["interfaceSet.address"].focus();
                return false;
            }
        </logic:notEqual>
		if (document.forms[0].elements["interfaceSet.gateway"].value=="") {
		} else if (!checkIP(document.forms[0].elements["interfaceSet.gateway"].value)
		|| document.forms[0].elements["interfaceSet.gateway"].value == "0.0.0.0") {
			alert("<bean:message key="nic.interfaceChange.invalidGateway" />");
			document.forms[0].elements["interfaceSet.gateway"].focus();
			return false;
		}
		if(document.forms[0].mtu[2].checked) {
			document.forms[0].mtu[2].value=document.forms[0].mtuText.value;
			if(!isValidMTU(document.forms[0].mtu[2].value)){
				alert("<bean:message key="nic_interfaceChange.invalidMTU" />");
				document.forms[0].mtu[2].focus();
				return false;
			}
		}
		var confirmStr = '<bean:message key="common.confirm" bundle="common"/>\r\n'+
            			 '<bean:message key="common.confirm.action" bundle="common"/>'+" "+
            			 '<bean:message key="common.button.submit" bundle="common"/>';
        var mtuOrNetMactch = checkMTUAndNetwork();
        if (mtuOrNetMactch != "true"){
        	confirmStr = confirmStr + "\r\n\r\n" + "<bean:message key="nic.interfaceChange.netWorkOrMTUNotEqual"/>";
        	if (mtuOrNetMactch == "both" || mtuOrNetMactch == "networkNotMatch"){
                var node0Str = "";
                var node1Str = "";
                if(nodeNoConfirm == "0"){
                   node0Str = getNetwork(document.forms[0].elements["interfaceSet.address"].value , document.forms[0].netmask.value) +
                               "/" + mask2int(document.forms[0].netmask.value) + "<bean:message key="nic.interfaceChange.node0"/>";
                   node1Str = getNetwork(friendIP , friendNetmask) +  "/" + mask2int(friendNetmask) + "<bean:message key="nic.interfaceChange.node1"/>";            
                }else{
                   node1Str = getNetwork(document.forms[0].elements["interfaceSet.address"].value , document.forms[0].netmask.value) +
                               "/" + mask2int(document.forms[0].netmask.value) + "<bean:message key="nic.interfaceChange.node1"/>";
                   node0Str = getNetwork(friendIP , friendNetmask) + "/" + mask2int(friendNetmask) + "<bean:message key="nic.interfaceChange.node0"/>";         
                }
                confirmStr = confirmStr + "\r\n\r\n" + "<bean:message key="nic.route.table.head.network"/> : \r\n\t" + 
                        node0Str
                        + ", " + 
                        node1Str;
        	}
        	if (mtuOrNetMactch == "both" || mtuOrNetMactch == "mtuNotMatch"){
                var node0Str = "";
                var node1Str = "";
                if(nodeNoConfirm == "0"){
                   node0Str = MTUSet + "<bean:message key="nic.interfaceChange.node0"/>";
                   node1Str = friendMTU + "<bean:message key="nic.interfaceChange.node1"/>";                               
                }else{
                   node1Str = MTUSet + "<bean:message key="nic.interfaceChange.node1"/>";
                   node0Str = friendMTU + "<bean:message key="nic.interfaceChange.node0"/>"; 
                }       
                confirmStr = confirmStr + "\r\n" + "<bean:message key="nic.list.table.head.mtu"/> : \r\n\t" + 
                        node0Str
                        + ", " + 
                        node1Str;
        	}
		}
		document.forms[0].elements["interfaceSet.netmask"].value = trim(document.forms[0].netmask.value);
		document.forms[0].elements["interfaceSet.mtu"].value = trim(MTUSet);
		if(confirm(confirmStr)) {
			setSubmitted();
    		document.forms[0].submit();
    		return true;
    	}
	}
	
    function displaySetNew(){
        var msg = "";
        if(document.forms[0].nic_from4change.value=="service"){        
        }else{
         var  msg = "<bean:message key="common.alert.done" bundle="common"/>" +"\r\n"
                + "<bean:message key="alert.message.setip" />";
            if(window.parent.frames[0].errorInstance==null){
                alert(msg);
            }
        }              
    }    	

</script>
</head>
<body onLoad="init();displayAlert();displaySetNew();enableSet();setHelpAnchor('s_network_2');"
	onUnload="closeDetailErrorWin();">
<form method="post" action="interfaceSet.do" target="_parent"><input
	type="button" name="back"
	value='<bean:message key="common.button.back" bundle="common" />'
	onclick="return onBack();">
    <h3><bean:message key="nic.interfacechange.h3" /></h3>
    <displayerror:error h1_key="nic.h1.servicenetwork" />      
    <br> 
    <input type="hidden" name="nic_from4change" value="<bean:write name="nic_from4change"/>" />
    <logic:present	name="interfaceSet">	
    <input type="hidden" name="interfaceSet.netmask" value='<logic:notEqual name="interfaceSet" property="netmask" value="--"><bean:write name="interfaceSet" property="netmask" /></logic:notEqual>'/>
    <input type="hidden" name="interfaceSet.mtu" value='<logic:notEqual name="interfaceSet" property="mtu" value="--"><bean:write name="interfaceSet" property="mtu" /></logic:notEqual>'/>
    <input type="hidden" name="interfaceSet.alias" value='<bean:write name="interfaceSet" property="alias" />'/>
    <input type="hidden" name="interfaceSet.isAliasBase" value='<bean:write name="interfaceSet" property="isAliasBase" />'/>
	<table border="1">
		<tr>
			<th align="left"><bean:message key="nic.list.table.head.name" /></th>
			<td align="left"><bean:write name="interfaceSet" property="nicName" />
			<input type="hidden" name="interfaceSet.nicName"
				value='<bean:write name="interfaceSet"
				property="nicName" />' /></td>
		</tr>
		<tr>
			<th align="left"><bean:message key="nic.interfaceChange.IP" /></th>
			<td align="left"><input type="text" name="interfaceSet.address"
				value='<logic:notEqual name="interfaceSet" property="address" value="--"><bean:write name="interfaceSet" property="address" /></logic:notEqual>'
				size="15" maxlength="15" /></td>
		</tr>
		<tr>
			<th align="left"><bean:message key="nic.route.table.head.netmask" /></th>
			<td align="left"><input type="text" name="netmask"
				size="15" onfocus="autoSetNetmask();" maxlength="15" /></td>
		</tr>
		<tr>
			<th align="left"><bean:message key="nic.list.table.head.gateway" /></th>
			<td align="left"><input type="text" name="interfaceSet.gateway"
				value='<logic:notEqual name="interfaceSet" property="gateway" value="--"><bean:write name="interfaceSet" property="gateway"/></logic:notEqual>'
				size="15" maxlength="15" /> <bean:message
				key="nic.interfaceChange.empty" /></td>
		</tr>
		<tr>
			<th align="left"><bean:message key="nic.list.table.head.mtu" /></th>
			<td align="left"><input type="radio" name="mtu"
				value="1500" id="radio_mtuid1"
				onclick="document.forms[0].mtuText.disabled=1;" /> <label
				for="radio_mtuid1"><bean:message key="nic_interfaceChange.mtul" /></label>
			<input type="radio" name="mtu" value="9000"
				id="radio_mtuid2" onclick="document.forms[0].mtuText.disabled=1;" />
			<label for="radio_mtuid2"><bean:message
				key="nic_interfaceChange.mtuh" /></label> <input type="radio"
				name="mtu" value="" id="radio_mtuid3"
                onclick="document.forms[0].mtuText.disabled=0;" /> <label
				for="radio_mtuid3"><bean:message key="nic.interfaceChange.other" /></label>
			<input type="text" id="mtuText" name="mtuText" size="4" maxlength="4"
				value=""
				onfocus="if(this.disabled)this.blur();else{}" /></td>
		</tr>
	</table>
</logic:present></form>
</body>
</html:html>
